//////////////////////////////////////////////////////////////////////////////////
// Company: NewAE
// Engineer: Jean-Pierre Thibault
// 
// Create Date: 
// Design Name: 
// Module Name: userio
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Generic USERIO bit-banging module.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`default_nettype none
`timescale 1ns / 1ps

module userio #(
   parameter pWIDTH = 8
)(
   input  wire                          usb_clk,
   inout  wire [pWIDTH-1:0]             userio_d,
   input  wire [pWIDTH-1:0]             I_userio_drive_data,
   input  wire [pWIDTH-1:0]             I_userio_pwdriven,
   input  wire                          userio_clk
);

   genvar i;

   generate
      for (i = 0; i < pWIDTH; i = i + 1) begin
         assign userio_d[i] = I_userio_pwdriven[i]? I_userio_drive_data[i] : 1'bz;
      end
   endgenerate

   `ifndef __ICARUS__
      PULLUP USERIO_PULLUP[pWIDTH-1:0] (.O(userio_d));
   `endif


endmodule

`default_nettype wire
