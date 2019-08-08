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
   parameter pTRIGGER_DELAY_WIDTH = 20,
   parameter pTRIGGER_WIDTH_WIDTH = 17

)(
   input  wire         reset_i,
   input  wire         trigger_clk,
   output reg          O_trigger,

   // from register block:
   input  wire [pTRIGGER_DELAY_WIDTH-1:0] I_trigger_delay,
   input  wire [pTRIGGER_WIDTH_WIDTH-1:0] I_trigger_width,

   // from pattern match block:
   input  wire         I_match
);

   reg [pTRIGGER_DELAY_WIDTH-1:0] delay_counter;
   reg [pTRIGGER_WIDTH_WIDTH-1:0] width_counter;
   reg delay_counter_running;
   reg width_counter_running;

   `ifdef ILA_TRIG
      reg match_r;
      reg [pTRIGGER_DELAY_WIDTH-1:0] trigger_delay_r;
      reg [pTRIGGER_WIDTH_WIDTH-1:0] trigger_width_r;
      always @ (posedge trigger_clk) begin
         if (reset_i) begin
            match_r <= 1'b0;
            trigger_delay_r <= 0;
            trigger_width_r <= 0;
         end
         else begin
            match_r <= I_match;
            trigger_delay_r <= I_trigger_delay;
            trigger_width_r <= I_trigger_width;
         end
      end
      ila_4 I_ila_trigger (
         .clk          (trigger_clk),           // input wire clk
         .probe0       (match_r),               // input wire [0:0]  probe0  
         .probe1       (delay_counter),         // input wire [19:0]  probe1 
         .probe2       (width_counter),         // input wire [16:0]  probe2 
         .probe3       (trigger_delay_r),       // input wire [19:0]  probe3 
         .probe4       (trigger_width_r),       // input wire [16:0]  probe4 
         .probe5       (delay_counter_running), // input wire [0:0]  probe5 
         .probe6       (width_counter_running), // input wire [0:0]  probe6 
         .probe7       (O_trigger)              // input wire [0:0]  probe7 
      );
   `endif


   // TODO: CDC on I_match; ideally getting a single-cycle pulse, will prevent two triggers from being issued
   // within a single 4-cycle I_match pulse
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
         else if (I_match) 
            delay_counter_running <= 1'b1;


         if (O_trigger && (width_counter == I_trigger_width)) begin
            width_counter_running <= 1'b0;
            O_trigger <= 1'b0;
         end
         else if (delay_counter_running) begin
            if ((delay_counter < I_trigger_delay) & ~O_trigger)
               delay_counter <= delay_counter + 1;
            else begin
               delay_counter <= 0;
               width_counter_running <= 1'b1;
               O_trigger <= 1'b1;
            end
         end


         if (width_counter_running) begin
            if (width_counter < I_trigger_width)
               width_counter <= width_counter + 1;
            else
               width_counter <= 1;
         end

      end
   end


endmodule

`default_nettype wire
