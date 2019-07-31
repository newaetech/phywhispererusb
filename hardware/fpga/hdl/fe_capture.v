`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: NewAE
// Engineer: Jean-Pierre Thibaut
// 
// Create Date: 
// Design Name: 
// Module Name: fe_capture
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fe_capture #(
    parameter pTIMESTAMP_FULL_WIDTH = 16,
    parameter pTIMESTAMP_SHORT_WIDTH = 3
)(
    /* FRONT END CONNECTIONS */
    input  wire reset_i,
    input  wire fe_clk,
    inout  wire [7:0] fe_data,
    input  wire fe_rxvalid,
    input  wire fe_rxactive,
    input  wire fe_rxerror,
    input  wire fe_sessvld,
    input  wire fe_vbusvld,
    input  wire fe_sessend,

    /* REGISTER CONNECTIONS */
    input  wire I_capture_enable,
    input  wire I_timestamps_disable,
    output reg  [1:0] O_command,
    output reg  [pTIMESTAMP_FULL_WIDTH-1:0] O_time,
    output wire [7:0] O_data,
    output wire [4:0] O_status,
    output reg  O_data_wr,

    output reg  [7:0] O_sniff_data,
    output reg  O_sniff_wr,
    output reg  [3:0] O_sniff_count

    );

    reg  [pTIMESTAMP_FULL_WIDTH-1:0] timestamp_ctr;
    reg  [pTIMESTAMP_FULL_WIDTH-1:0] timestamp;
    reg  [3:0] next_sniff_count;

    // TODO: move to separate file which could be more easily parsed by Python:
    `define FE_FIFO_CMD_DATA 2'b00
    `define FE_FIFO_CMD_STAT 2'b01
    `define FE_FIFO_CMD_TIME 2'b10

    `define FE_FIFO_STATUS_BITS_START 3
    `define FE_FIFO_STATUS_BITS_LEN 5
    `define FE_FIFO_RXACTIVE_BIT 3
    `define FE_FIFO_RXERROR_BIT 4
    `define FE_FIFO_SESSVLD_BIT 5
    `define FE_FIFO_SESSEND_BIT 6
    `define FE_FIFO_VBUSVLD_BIT 7
    
    reg [1:0] state, next_state, state_r, state_r2;
    localparam pS_IDLE = 0;
    localparam pS_DATA = 1;
    localparam pS_TIME = 2;

    wire short_timestamp;
    wire short_timestamp_pre;
    reg  fe_rxvalid_reg;
    reg  fe_rxvalid_reg2;
    reg  [7:0] fe_data_reg;
    reg  [7:0] fe_data_reg2;
    reg  [7:0] fe_data_reg3;
    reg  [pTIMESTAMP_FULL_WIDTH-1:0] timestamp_reg;
    reg  ctr_running;

    wire [`FE_FIFO_STATUS_BITS_LEN-1:0] fe_status_bits;
    reg  [`FE_FIFO_STATUS_BITS_LEN-1:0] fe_status_bits_reg;
    reg  [`FE_FIFO_STATUS_BITS_LEN-1:0] fe_status_bits_reg2;
    reg  [`FE_FIFO_STATUS_BITS_LEN-1:0] fe_status_bits_reg3;

    wire usb_event; // rxvalid=1 or status bits changed
    reg  usb_event_reg;

    assign fe_status_bits[`FE_FIFO_RXACTIVE_BIT - `FE_FIFO_STATUS_BITS_START] = fe_rxactive;
    assign fe_status_bits[`FE_FIFO_RXERROR_BIT  - `FE_FIFO_STATUS_BITS_START] = fe_rxerror;
    assign fe_status_bits[`FE_FIFO_SESSVLD_BIT  - `FE_FIFO_STATUS_BITS_START] = fe_sessvld;
    assign fe_status_bits[`FE_FIFO_SESSEND_BIT  - `FE_FIFO_STATUS_BITS_START] = fe_sessend;
    assign fe_status_bits[`FE_FIFO_VBUSVLD_BIT  - `FE_FIFO_STATUS_BITS_START] = fe_vbusvld;

    assign usb_event = fe_rxvalid || (fe_status_bits != fe_status_bits_reg);

    //assign short_timestamp = (timestamp_ctr[pTIMESTAMP_FULL_WIDTH-1:pTIMESTAMP_SHORT_WIDTH] == 0);
    //assign short_timestamp = (timestamp_ctr < 8); // TODO: parameterize
    //assign short_timestamp_pre = (timestamp_ctr < 7); // TODO: parameterize
    // TODO: temporary, prevents TIME packets and their associated bugs:
    assign short_timestamp = I_timestamps_disable? 1'b1 : (timestamp_ctr < 8);
    assign short_timestamp_pre = I_timestamps_disable? 1'b1: (timestamp_ctr < 7);

    // Delay incoming fe_* signals by one cycle to avoid issuing
    // FE_FIFO_CMD_STAT at the same time as an fe_* data event, which could
    // lead to tricky edge cases. Cost is some extra flops and a 1-cycle delay.
    always @ (posedge fe_clk) begin
       if (reset_i) begin
          fe_rxvalid_reg <= 1'b0;
          fe_rxvalid_reg2 <= 1'b0;
          fe_data_reg <= 8'd0;
          fe_data_reg2 <= 8'd0;
          fe_data_reg3 <= 8'd0;
          fe_status_bits_reg <= 5'd0;
          fe_status_bits_reg2 <= 5'd0;
          fe_status_bits_reg3 <= 5'd0;
          usb_event_reg <= 1'b0;
       end
       else begin
          fe_rxvalid_reg <= fe_rxvalid;
          fe_rxvalid_reg2 <= fe_rxvalid_reg;
          fe_data_reg2 <= fe_data_reg;
          fe_data_reg3 <= fe_data_reg2;
          fe_status_bits_reg <= fe_status_bits;
          fe_status_bits_reg2 <= fe_status_bits_reg;
          fe_status_bits_reg3 <= fe_status_bits_reg2;
          usb_event_reg <= usb_event;
          if (fe_rxvalid)
             fe_data_reg <= fe_data;
       end
    end

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
             if (usb_event_reg && short_timestamp && I_capture_enable)
                next_state = pS_DATA;
             else if (usb_event && !short_timestamp_pre && I_capture_enable)
                // do FE_FIFO_CMD_TIME packet one cycle early so we don't get caught behind, 
                // for the corner case of back-to-back events following a long idle time:
                next_state = pS_TIME;
             else if (timestamp_ctr == { {(pTIMESTAMP_FULL_WIDTH-1){1'b1}}, 1'b0})
                next_state = pS_TIME;
             else
                next_state = pS_IDLE;
          end


          pS_DATA: begin
             if (usb_event_reg)
                next_state = pS_DATA;
             else
                next_state = pS_IDLE;
          end


          pS_TIME: begin
             if (usb_event_reg)
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

          if (I_capture_enable && usb_event)
             ctr_running <= 1'b1;
          else if (!I_capture_enable)
             ctr_running <= 1'b0;

          if (!ctr_running)
             timestamp_ctr <= 0;
          else if (usb_event_reg) begin
             timestamp <= timestamp_ctr;
             timestamp_ctr <= 0;
          end
          else if (timestamp_ctr < {pTIMESTAMP_FULL_WIDTH{1'b1}})
             timestamp_ctr <= timestamp_ctr + 1;
       end
    end


    // write captured data:
    // (TODO: could save a stage of buffering on input data by using next_state instead of state?
    always @ (posedge fe_clk) begin
       if (reset_i) begin
          O_command <= 2'd0;
          O_data_wr <= 1'b0;
       end
       else begin
          if (state == pS_DATA) begin
             O_command <= fe_rxvalid_reg2? `FE_FIFO_CMD_DATA : `FE_FIFO_CMD_STAT;
             O_data_wr <= 1'b1;
          end
          else if (state == pS_TIME) begin
             O_command <= `FE_FIFO_CMD_TIME;
             O_data_wr <= 1'b1;
          end
          else begin
             O_data_wr <= 1'b0;
          end
       end
    end

    //assign O_time = (state_r == pS_TIME)? timestamp : timestamp_reg;
    always @(*) begin
       if (state_r == pS_TIME)
          O_time = timestamp;
       else if (state_r2 == pS_TIME)
          O_time = 0;
       else
          O_time = timestamp_reg;
    end

    // TODO: can I tweak the FSM timing to avoid needing 3 sync stages?
    assign O_data = fe_data_reg3;
    assign O_status = fe_status_bits_reg3;


    // TODO: old logic for basic validation of FIFO operation; remove when no longer needed:
    // (Capture first 8 rxvalid bytes, for basic/sanity testing.)
    always @ (posedge fe_clk) begin
       if (reset_i) begin
          O_sniff_data <= 8'd0;
          O_sniff_wr <= 1'b0;
          O_sniff_count <= 4'b0;
          next_sniff_count <= 4'b0;
       end
       else begin
          if (fe_rxvalid && (O_sniff_count < 8)) begin
             O_sniff_data <= fe_data;
             O_sniff_wr <= 1'b1;
             O_sniff_count <= next_sniff_count;
             next_sniff_count <= next_sniff_count + 1;
          end
          else begin
             O_sniff_wr <= 1'b0;
          end
       end
    end

    // strictly for easier visualization/debug:
    wire state_idle = (state == pS_IDLE);
    wire state_data = (state == pS_DATA);
    wire state_time = (state == pS_TIME);


endmodule
`default_nettype wire