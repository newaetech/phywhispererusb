//////////////////////////////////////////////////////////////////////////////////
// Company: NewAE
// Engineer: Jean-Pierre Thibaut
// 
// Create Date: 
// Design Name: 
// Module Name: fe_capture_main
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Front-end module, interface-agnostic logic.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none
`include "defines_pw.v"

module fe_capture_main #(
    parameter pTIMESTAMP_FULL_WIDTH = 16,
    parameter pTIMESTAMP_SHORT_WIDTH = 3,
    parameter pCAPTURE_LEN_WIDTH = 24
)(
    input  wire cwusb_clk,
    input  wire reset_i,

    /* FRONT END CONNECTIONS */
    input  wire fe_clk,

    /* SPECIFIC FRONTEND CONNECTIONS */
    input  wire I_event,
    input  wire [1:0] I_data_cmd,
    output reg  [pTIMESTAMP_FULL_WIDTH-1:0] O_fifo_time,
    output reg  [1:0] O_fifo_command,
    output reg  O_fifo_wr,
    input  wire [15:0] I_max_short_timestamp,

    /* REGISTER CONNECTIONS */
    input  wire I_timestamps_disable,
    input  wire I_arm,
    input  wire I_reg_arm, // TODO: yes this is confusing but there are two different arms..
                           // maybe there's a better way?
    input  wire [pCAPTURE_LEN_WIDTH-1:0] I_capture_len,

    /* FIFO CONNECTIONS */
    output reg  O_fifo_flush,
    output wire O_capture_done,
    input  wire I_fifo_overflow_blocked,
    input  wire I_fifo_empty,
    input  wire I_fifo_full,

    /* PATTERN MATCH CONNECTIONS */
    output wire O_capturing,

    /* TRIGGER CONNECTIONS */
    input  wire I_capture_enable
);

    reg  [pTIMESTAMP_FULL_WIDTH-1:0] timestamp_ctr;
    reg  [pTIMESTAMP_FULL_WIDTH-1:0] timestamp;

    reg [1:0] state, next_state, state_r, state_r2;
    localparam pS_IDLE = 0;
    localparam pS_DATA = 1;
    localparam pS_TIME = 2;

    wire short_timestamp;
    wire short_timestamp_pre;
    reg  [pTIMESTAMP_FULL_WIDTH-1:0] timestamp_reg;
    reg  ctr_running;

    reg  event_reg;
    reg  [pCAPTURE_LEN_WIDTH-1:0] capture_count;
    wire capture_allowed;

    (* ASYNC_REG = "TRUE" *) reg [pCAPTURE_LEN_WIDTH-1:0] capture_len_r;
    (* ASYNC_REG = "TRUE" *) reg timestamps_disable_r;
    (* ASYNC_REG = "TRUE" *) reg [1:0] arm_pipe;
    (* ASYNC_REG = "TRUE" *) reg [1:0] capturing_pipe;
    reg  arm_r;
    reg  arm_r2;
    reg  capturing;

    assign short_timestamp = timestamps_disable_r? 1'b1 : (timestamp_ctr <= I_max_short_timestamp);
    assign short_timestamp_pre = timestamps_disable_r? 1'b1: (timestamp_ctr < I_max_short_timestamp);

    // FSM:
    always @ (posedge fe_clk) begin
       if (reset_i)
          state <= pS_IDLE;
       else
          state <= next_state;
    end
    always @(*) begin
       case (state)

          pS_IDLE: begin
             // Note: capture_allowed is what stops capturing when we've captured enough bytes;
             // there is a bit of a lag here so it's possible to capture one or two more events
             // than we should. Could be fixed but it's not a problem since the FIFO gets flushed
             // upon re-arming. And the Xilinx FIFO is actually deeper than the requested 8192 anyway.
             // And we don't allow overflow writes anyway.
             if (event_reg && short_timestamp && I_capture_enable && capture_allowed)
                next_state = pS_DATA;
             else if (I_event && !short_timestamp_pre && I_capture_enable && capture_allowed)
                // do FE_FIFO_CMD_TIME packet one cycle early so we don't get caught behind, 
                // for the corner case of back-to-back events following a long idle time:
                next_state = pS_TIME;
             else if (timestamp_ctr == { {(pTIMESTAMP_FULL_WIDTH-1){1'b1}}, 1'b0})
                next_state = pS_TIME;
             else
                next_state = pS_IDLE;
          end


          pS_DATA: begin
             if (event_reg && capture_allowed)
                next_state = pS_DATA;
             else
                next_state = pS_IDLE;
          end


          pS_TIME: begin
             if (event_reg && capture_allowed)
                next_state = pS_DATA;
             else
                next_state = pS_IDLE;
          end


          default: begin
             next_state = pS_IDLE;
          end

       endcase
    end

    // manage timestamp counter:
    always @ (posedge fe_clk) begin
       if (reset_i) begin
          timestamp <= 0;
          timestamp_reg <= 0;
          timestamp_ctr <= 0;
          ctr_running <= 1'b0;
          state_r <= 0;
          state_r2 <= 0;
       end
       else begin
          state_r <= state;
          state_r2 <= state_r;
          timestamp_reg <= timestamp;

          if (I_capture_enable && event_reg)
             ctr_running <= 1'b1;
          else if (!I_capture_enable)
             ctr_running <= 1'b0;

          if (!ctr_running) begin
             timestamp_ctr <= 0;
             timestamp <= 0;
          end
          else if (event_reg) begin
             timestamp <= timestamp_ctr;
             timestamp_ctr <= 0;
          end
          else if (timestamp_ctr < {pTIMESTAMP_FULL_WIDTH{1'b1}})
             timestamp_ctr <= timestamp_ctr + 1;
       end
    end


    // write captured data:
    // note: could possibly save a stage of buffering on input data by using next_state instead of state?
    always @ (posedge fe_clk) begin
       if (reset_i) begin
          O_fifo_command <= 2'd0;
          O_fifo_wr <= 1'b0;
       end
       else begin
          if (state == pS_DATA) begin
             O_fifo_command <= I_data_cmd;
             O_fifo_wr <= 1'b1;
          end
          else if (state == pS_TIME) begin
             O_fifo_command <= `FE_FIFO_CMD_TIME;
             O_fifo_wr <= 1'b1;
          end
          else begin
             O_fifo_wr <= 1'b0;
          end
       end
    end

    always @(*) begin
       if (state_r == pS_TIME)
          O_fifo_time = timestamp;
       else if (state_r2 == pS_TIME)
          O_fifo_time = 0;
       else
          O_fifo_time = timestamp_reg;
    end


    // manage capture mode:
    always @ (posedge fe_clk) begin
       if (reset_i) begin
          capture_count <= 24'd0;
       end
       else begin
          if (arm_r & !arm_r2)
             capture_count <= 24'd0;
          else if (O_fifo_wr)
             capture_count <= capture_count + 1;
       end
    end

    assign O_capturing = capture_allowed;

    assign capture_allowed = I_capture_enable & ((capture_count < capture_len_r) || (capture_len_r == 0)) & 
                            !I_fifo_full & !I_fifo_overflow_blocked;

   // CDC:
   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         capturing <= 0;
         capturing_pipe <= 0;
      end
      else begin
         {capturing, capturing_pipe} <= {capturing_pipe, capture_allowed};
      end
   end

   assign O_capture_done = ~(I_reg_arm || capturing);

    // strictly for easier visualization/debug:
    wire state_idle = (state == pS_IDLE);
    wire state_data = (state == pS_DATA);
    wire state_time = (state == pS_TIME);

   // CDC:
   always @ (posedge fe_clk) begin
      if (reset_i) begin
         capture_len_r <= 0;
         timestamps_disable_r <= 0;
         arm_pipe <= 0;
         arm_r <= 0;
         arm_r2 <= 0;
         event_reg <= 0;
      end
      else begin
         capture_len_r <= I_capture_len;
         timestamps_disable_r <= I_timestamps_disable;
         event_reg <= I_event;
         {arm_r2, arm_r, arm_pipe} <= {arm_r, arm_pipe, I_arm};
      end
   end


   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         O_fifo_flush <= 1'b0;
      end
      else begin
         if (I_fifo_empty)
            O_fifo_flush <= 1'b0;
         else if (I_reg_arm & ~O_fifo_flush)
            O_fifo_flush <= 1'b1;
      end
   end


endmodule
`default_nettype wire