`default_nettype none
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NewAE
// Engineer: Jean-Pierre Thibault
// 
// Create Date: 
// Design Name: 
// Module Name: pw_trigger
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


module pw_trigger #(
   parameter pCAPTURE_DELAY_WIDTH = 18,
   parameter pTRIGGER_DELAY_WIDTH = 20,
   parameter pTRIGGER_WIDTH_WIDTH = 17,
   parameter pNUM_TRIGGER_PULSES = 8,
   parameter pNUM_TRIGGER_WIDTH = 4,
   parameter pALL_TRIGGER_DELAY_WIDTHS = 24*pNUM_TRIGGER_PULSES,
   parameter pALL_TRIGGER_WIDTH_WIDTHS = 24*pNUM_TRIGGER_PULSES
)(
   input  wire         reset_i,
   input  wire         trigger_clk,
   input  wire         fe_clk,
   output reg          O_trigger,

   // to/from register block:
   input  wire [pCAPTURE_DELAY_WIDTH-1:0] I_capture_delay,
   input  wire [pALL_TRIGGER_DELAY_WIDTHS-1:0] I_trigger_delay,
   input  wire [pALL_TRIGGER_WIDTH_WIDTHS-1:0] I_trigger_width,
   input  wire [pNUM_TRIGGER_WIDTH-1:0]   I_num_triggers,
   input  wire         I_trigger_enable,
   output wire         O_capture_enable_pulse,

   // from pattern match block:
   input  wire         I_match,

   // to/from capture block:
   input  wire         I_capturing,
   output wire         O_capture_enable
);

   reg  [pTRIGGER_DELAY_WIDTH-1:0] delay_counter;
   reg  [pTRIGGER_DELAY_WIDTH-3:0] delay_counter_fe;
   reg  delay_counter_fe_running;
   wire match_pulse;
   (* ASYNC_REG = "TRUE" *) reg  [pTRIGGER_DELAY_WIDTH-1:0] trigger_delay_r [0:pNUM_TRIGGER_PULSES-1];
   (* ASYNC_REG = "TRUE" *) reg  [pTRIGGER_WIDTH_WIDTH-1:0] trigger_width_r [0:pNUM_TRIGGER_PULSES-1];
   (* ASYNC_REG = "TRUE" *) reg  [pNUM_TRIGGER_WIDTH-1:0] num_triggers_r;
   (* ASYNC_REG = "TRUE" *) reg  trigger_enable_r;
   reg  [pTRIGGER_DELAY_WIDTH-1:0] trigger_delay;
   reg  [pTRIGGER_WIDTH_WIDTH-1:0] trigger_width;
   reg  capturing_r;
   wire capture_done;
   wire match;
   wire capture_enable_start;
   reg  capture_enable_reg;
   reg  capture_enable_reg2;
   reg  capture_enable_pulse;


   // CDC for register block inputs: since these signals are quasi-static
   // and should not be changing while the downstream logic is active, a 
   // single sync stage is sufficient:
   always @ (posedge trigger_clk) begin
      // ease timing by foregoing reset here:
      /*
      if (reset_i) begin
         trigger_delay_r[0] <= 0;
         trigger_delay_r[1] <= 0;
         trigger_delay_r[2] <= 0;
         trigger_delay_r[3] <= 0;
         trigger_delay_r[4] <= 0;
         trigger_delay_r[5] <= 0;
         trigger_delay_r[6] <= 0;
         trigger_delay_r[7] <= 0;
         trigger_width_r[0] <= 0;
         trigger_width_r[1] <= 0;
         trigger_width_r[2] <= 0;
         trigger_width_r[3] <= 0;
         trigger_width_r[4] <= 0;
         trigger_width_r[5] <= 0;
         trigger_width_r[6] <= 0;
         trigger_width_r[7] <= 0;
         num_triggers_r <= 0;
         trigger_enable_r <= 0;
      end
      else begin
      */
      trigger_delay_r[0] <= I_trigger_delay[0*24+:pTRIGGER_DELAY_WIDTH];
      trigger_delay_r[1] <= I_trigger_delay[1*24+:pTRIGGER_DELAY_WIDTH];
      trigger_delay_r[2] <= I_trigger_delay[2*24+:pTRIGGER_DELAY_WIDTH];
      trigger_delay_r[3] <= I_trigger_delay[3*24+:pTRIGGER_DELAY_WIDTH];
      trigger_delay_r[4] <= I_trigger_delay[4*24+:pTRIGGER_DELAY_WIDTH];
      trigger_delay_r[5] <= I_trigger_delay[5*24+:pTRIGGER_DELAY_WIDTH];
      trigger_delay_r[6] <= I_trigger_delay[6*24+:pTRIGGER_DELAY_WIDTH];
      trigger_delay_r[7] <= I_trigger_delay[7*24+:pTRIGGER_DELAY_WIDTH];

      trigger_width_r[0] <= I_trigger_width[0*24+:pTRIGGER_WIDTH_WIDTH];
      trigger_width_r[1] <= I_trigger_width[1*24+:pTRIGGER_WIDTH_WIDTH];
      trigger_width_r[2] <= I_trigger_width[2*24+:pTRIGGER_WIDTH_WIDTH];
      trigger_width_r[3] <= I_trigger_width[3*24+:pTRIGGER_WIDTH_WIDTH];
      trigger_width_r[4] <= I_trigger_width[4*24+:pTRIGGER_WIDTH_WIDTH];
      trigger_width_r[5] <= I_trigger_width[5*24+:pTRIGGER_WIDTH_WIDTH];
      trigger_width_r[6] <= I_trigger_width[6*24+:pTRIGGER_WIDTH_WIDTH];
      trigger_width_r[7] <= I_trigger_width[7*24+:pTRIGGER_WIDTH_WIDTH];

      num_triggers_r <= I_num_triggers;
      trigger_enable_r <= I_trigger_enable;
   end

   cdc_pulse U_match_cdc (
      .reset_i       (reset_i),
      .src_clk       (fe_clk),
      .src_pulse     (I_match),
      .dst_clk       (trigger_clk),
      .dst_pulse     (match_pulse)
   );

   `ifdef ILA_TRIG
      // NOTE: this ILA tends to make timing fail on the trigger_clk domain
      ila_4 I_ila_trigger (
         .clk          (trigger_clk),           // input wire clk
         .probe0       (1'b0),                  // input wire [0:0]  probe0  
         .probe1       (delay_counter),         // input wire [19:0]  probe1 
         .probe2       (17'b0),                 // input wire [16:0]  probe2 
         .probe3       (trigger_delay),         // input wire [19:0]  probe3 
         .probe4       (trigger_width),         // input wire [16:0]  probe4 
         .probe5       (state_wait_for_on),     // input wire [0:0]  probe5 
         .probe6       (state_wait_for_off),    // input wire [0:0]  probe6 
         .probe7       (O_trigger),             // input wire [0:0]  probe7 
         .probe8       (match_pulse)            // input wire [0:0]  probe8 
      );
   `endif

   // FSM to generate output trigger pulse(s):

    reg  [1:0] state;
    localparam pS_IDLE = 0;
    localparam pS_WAIT_FOR_ON = 1;
    localparam pS_WAIT_FOR_OFF = 2;

    // strictly for easier visualization/debug:
    wire state_idle = (state == pS_IDLE);
    wire state_wait_for_on = (state == pS_WAIT_FOR_ON);
    wire state_wait_for_off = (state == pS_WAIT_FOR_OFF);

    reg  [pNUM_TRIGGER_WIDTH-1:0] trigger_index;
    reg  [pNUM_TRIGGER_WIDTH-1:0] trigger_delay_index;


   always @ (posedge trigger_clk) begin
      if (reset_i) begin
         state <= pS_IDLE;
         //trigger_index <= 0;
         //trigger_delay_index <= 0;
         //delay_counter <= 0;
         O_trigger <= 0;
      end
      else begin
         case (state)

            pS_IDLE: begin
               O_trigger <= 0;
               // setup initial trigger delay and width:
               trigger_delay <= trigger_delay_r[0];
               trigger_width <= trigger_width_r[0];
               if (match_pulse & trigger_enable_r) begin
                  delay_counter <= 0;
                  trigger_index <= 0;
                  state <= pS_WAIT_FOR_ON;
               end
               else
                  state <= pS_IDLE;
            end

            pS_WAIT_FOR_ON: begin
               // setup the next trigger width:
               trigger_width <= trigger_width_r[trigger_index];
               if ((delay_counter < trigger_delay) & ~O_trigger)
                  delay_counter <= delay_counter + 1;
               else begin
                  delay_counter <= 1;
                  O_trigger <= 1'b1;
                  // setup for the next trigger delay, part 1:
                  trigger_delay_index <= trigger_index + 1;
                  state <= pS_WAIT_FOR_OFF;
               end
            end

            pS_WAIT_FOR_OFF: begin
               // setup for the next trigger delay, part 2:
               trigger_delay <= trigger_delay_r[trigger_delay_index];
               if (delay_counter < trigger_width)
                  delay_counter <= delay_counter + 1;
               else begin
                  O_trigger <= 0;
                  if (trigger_index < num_triggers_r-1) begin
                     trigger_index <= trigger_index + 1;
                     delay_counter <= 1;
                     state <= pS_WAIT_FOR_ON;
                  end
                  else begin
                     trigger_index <= 0;
                     delay_counter <= 0;
                     state <= pS_IDLE;
                  end
               end
            end

         endcase
      end
   end


   assign capture_done = !I_capturing & capturing_r;


   // Generate an internal trigger signal with the 1x fe_clk for capture, to avoid crossing 
   // clock domains back and forth. Bit more complicated than it could be in order to deal with the
   // 0-delay case, where the data to be captured follows the pattern match immediately, as well as
   // the general case where there is a programmable delay between pattern match and capture.
   always @ (posedge fe_clk) begin
      if (reset_i) begin
         delay_counter_fe <= 0;
         delay_counter_fe_running <= 1'b0;
         capturing_r <= 1'b0;
         capture_enable_reg <= 1'b0;
         capture_enable_reg2 <= 1'b0;
         capture_enable_pulse <= 1'b0;
      end

      else begin
         capturing_r <= I_capturing;
         capture_enable_reg2 <= capture_enable_reg;

         if (capture_enable_reg & !capture_enable_reg2)
            capture_enable_pulse <= 1'b1;
         else
            capture_enable_pulse <= 1'b0;

         if (O_capture_enable) 
            delay_counter_fe_running <= 1'b0;
         else if (I_match) 
            delay_counter_fe_running <= 1'b1;

         if (capture_done)
            capture_enable_reg <= 1'b0;
         else if (I_match || delay_counter_fe_running) begin
            if ((delay_counter_fe < I_capture_delay) & ~O_capture_enable)
               delay_counter_fe <= delay_counter_fe + 1;
            else begin
               delay_counter_fe <= 0;
               capture_enable_reg <= 1'b1;
            end
         end

      end
   end

   assign match = I_match | delay_counter_fe_running;
   assign capture_enable_start = match & (delay_counter_fe == I_capture_delay);
   assign O_capture_enable = capture_enable_start | capture_enable_reg;
   assign O_capture_enable_pulse = capture_enable_pulse;

   `ifdef ILA_TRIG_FE
      ila_trig_fe I_ila_trigger_fe (
         .clk          (fe_clk),                        // input wire clk
         .probe0       (capture_enable_reg),            // input wire [0:0]  probe0  
         .probe1       (capture_done),                  // input wire [0:0]  probe1 
         .probe2       (capturing_r),                   // input wire [0:0]  probe2 
         .probe3       (I_match),                       // input wire [0:0]  probe3 
         .probe4       (delay_counter_fe_running)       // input wire [0:0]  probe4 
      );
   `endif


endmodule

`default_nettype wire
