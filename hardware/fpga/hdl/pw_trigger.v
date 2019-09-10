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
   parameter pTRIGGER_WIDTH_WIDTH = 17

)(
   input  wire         reset_i,
   input  wire         trigger_clk,
   input  wire         fe_clk,
   output reg          O_trigger,

   // to/from register block:
   input  wire [pCAPTURE_DELAY_WIDTH-1:0] I_capture_delay,
   input  wire [pTRIGGER_DELAY_WIDTH-1:0] I_trigger_delay,
   input  wire [pTRIGGER_WIDTH_WIDTH-1:0] I_trigger_width,
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
   reg  [pTRIGGER_WIDTH_WIDTH-1:0] width_counter;
   reg  delay_counter_running;
   reg  delay_counter_fe_running;
   reg  width_counter_running;
   wire match_pulse;
   (* ASYNC_REG = "TRUE" *) reg  [pTRIGGER_DELAY_WIDTH-1:0] trigger_delay_r;
   (* ASYNC_REG = "TRUE" *) reg  [pTRIGGER_WIDTH_WIDTH-1:0] trigger_width_r;
   (* ASYNC_REG = "TRUE" *) reg  trigger_enable_r;
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
      if (reset_i) begin
         trigger_delay_r <= 0;
         trigger_width_r <= 0;
         trigger_enable_r <= 0;
      end
      else begin
         trigger_delay_r <= I_trigger_delay;
         trigger_width_r <= I_trigger_width;
         trigger_enable_r <= I_trigger_enable;
      end
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
         .probe2       (width_counter),         // input wire [16:0]  probe2 
         .probe3       (trigger_delay_r),       // input wire [19:0]  probe3 
         .probe4       (trigger_width_r),       // input wire [16:0]  probe4 
         .probe5       (delay_counter_running), // input wire [0:0]  probe5 
         .probe6       (width_counter_running), // input wire [0:0]  probe6 
         .probe7       (O_trigger),             // input wire [0:0]  probe7 
         .probe8       (match_pulse)            // input wire [0:0]  probe8 
      );
   `endif


   // generate the output trigger signal with the 4x trigger_clk:
   always @ (posedge trigger_clk) begin
      if (reset_i) begin
         delay_counter <= 0;
         delay_counter_running <= 1'b0;
         width_counter <= 1;
         width_counter_running <= 1'b0;
         O_trigger <= 1'b0;
      end

      else begin
         if (O_trigger) 
            delay_counter_running <= 1'b0;
         else if (match_pulse & trigger_enable_r) 
            delay_counter_running <= 1'b1;


         if (O_trigger && (width_counter == trigger_width_r)) begin
            width_counter_running <= 1'b0;
            O_trigger <= 1'b0;
         end
         else if (delay_counter_running) begin
            if ((delay_counter < trigger_delay_r) & ~O_trigger)
               delay_counter <= delay_counter + 1;
            else begin
               delay_counter <= 0;
               width_counter_running <= 1'b1;
               O_trigger <= 1'b1;
            end
         end

         if (width_counter_running) begin
            if (width_counter < trigger_width_r)
               width_counter <= width_counter + 1;
            else
               width_counter <= 1;
         end

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

endmodule

`default_nettype wire
