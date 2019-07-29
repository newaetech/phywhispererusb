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


module pw_trigger (
   input  wire         reset_i,
   input  wire         trigger_clk,
   input  wire         usb_clk,
   output wire         O_trigger,

   // from register block:
   input  wire [3:0]   I_offset,

   // from pattern match block:
   input  wire         I_match
);

   reg [7:0] trig_counter;

   always @ (posedge trigger_clk) begin
      if (reset_i) begin
         trig_counter <= 0;
      end
      else if (I_match) begin
         trig_counter <= trig_counter + 1;
      end
   end

   assign O_trigger = trig_counter[7];
   //assign O_trigger = 1'b1;


endmodule

`default_nettype wire
