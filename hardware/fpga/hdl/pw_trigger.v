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
   input  wire         usb_clk,
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
   reg trigger_r;

   // TODO: CDC on I_match; ideally getting a single-cycle pulse, will prevent two triggers from being issued
   // within a single 4-cycle I_match pulse
   always @ (posedge trigger_clk) begin
      if (reset_i) begin
         delay_counter <= 0;
         delay_counter_running <= 1'b0;
         width_counter <= 1;
         width_counter_running <= 1'b0;
         O_trigger <= 1'b0;
         trigger_r <= 1'b0;
      end

      else begin
         trigger_r <= O_trigger;

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
