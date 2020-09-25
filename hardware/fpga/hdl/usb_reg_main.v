`default_nettype none
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NewAE
// Engineer: Jean-Pierre Thibault
// 
// Create Date: 
// Design Name: 
// Module Name: usb_reg_main
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


module usb_reg_main #(
   parameter pBYTECNT_SIZE = 7
)(
   input  wire         cwusb_clk,

   /* Interface to ChipWhisperer-Lite USB Chip */
   input  wire [7:0]   cwusb_din,
   output wire [7:0]   cwusb_dout,
   output wire         cwusb_isout,
   input  wire [7:0]   cwusb_addr,
   input  wire         cwusb_rdn,
   input  wire         cwusb_wrn,
   input  wire         cwusb_alen,
   input  wire         cwusb_cen,

 /* Interface to registers */
   output reg  [7:0]   reg_address,  // Address of register
   output reg  [pBYTECNT_SIZE-1:0]  reg_bytecnt,  // Current byte count
   output reg  [7:0]   reg_datao,    // Data to write
   input  wire [7:0]   reg_datai,    // Data to read
   output wire         reg_read,     // Read flag. One clock cycle AFTER this flag is high
                                     // valid data must be present on the reg_datai bus
   output reg          reg_write,    // Write flag. When high on rising edge valid data is
                                     // present on reg_datao
   output reg          reg_addrvalid // Address valid flag
);


   reg cwusb_alen_rs, cwusb_alen_rs_dly;

   wire rdflag = ~cwusb_rdn & ~cwusb_cen;
   reg rdflag_rs, rdflag_rs_dly;
   reg isoutreg, isoutregdly;
   reg addrvalid_outreg;
   reg cwusb_wrn_rs, cwusb_wrn_rs_dly;
   reg reg_write_dly;

   // note: could possibly be simplified, and delays reduced?
   always @(posedge cwusb_clk) begin
      cwusb_alen_rs <= cwusb_alen;
      cwusb_alen_rs_dly <= cwusb_alen_rs;

      rdflag_rs <= rdflag;
      rdflag_rs_dly <= rdflag_rs;

      isoutreg <= ~cwusb_rdn;
      isoutregdly <= isoutreg;

      cwusb_wrn_rs <= cwusb_wrn;
      cwusb_wrn_rs_dly <= cwusb_wrn_rs;
      reg_write <= cwusb_wrn_rs & ~cwusb_wrn_rs_dly;
   end


   //TODO: this should be synchronous to device clock, but is phase OK? Might need to
   //use resyncronized version...
   assign reg_read = cwusb_isout;
   assign cwusb_dout = reg_datai;

   //Don't immediatly turn off output drivers
   assign cwusb_isout = isoutreg | isoutregdly;

   //Address valid on rising edge of ALEn, simplify and just latch when ALEn low
   always @(posedge cwusb_clk) begin
      if (cwusb_alen_rs_dly == 1'b0) begin
         reg_address <= cwusb_addr;
      end
   end

//Address valid from ALEn until next falling edge of ALEn
   always @(posedge cwusb_clk) begin
      if (cwusb_alen_rs == 1'b0) begin
         reg_addrvalid <= 1'b0;
      end else if ((cwusb_alen_rs == 1'b1) &&(cwusb_alen_rs_dly == 1'b0)) begin
         reg_addrvalid <= 1'b1;
      end
   end

   always @(posedge cwusb_clk) begin
      //if (~cwusb_cen & ~cwusb_wrn) begin
      if (~cwusb_cen & ~cwusb_wrn_rs) begin
         reg_datao <= cwusb_din;
      end
   end


   /* Byte count block. We need to increment after a read or after a write */
   always @(posedge cwusb_clk) reg_write_dly <= reg_write;


   always @(posedge cwusb_clk) begin
      if (cwusb_alen_rs == 1'b0) begin
         reg_bytecnt <= 0;
      //end else if ((rdflag_rs_dly) || (reg_write_dly) ) begin
      end else if ((isoutregdly & !isoutreg) || (reg_write_dly) ) begin
         //roll-over is allowed (only access to use it is FIFO read, where we
         //only look at reg_bytecnt % 4)
         reg_bytecnt <= reg_bytecnt + 1;
      end
   end

endmodule

`default_nettype wire
