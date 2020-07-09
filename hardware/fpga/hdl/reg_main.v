//////////////////////////////////////////////////////////////////////////////////
// Company: NewAE
// Engineer: Jean-Pierre Thibault
// 
// Create Date: 
// Design Name: 
// Module Name: reg_main
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Main register block: any registers not specific to a
// particular front-end go here.
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
`include "defines_pw.v"

module reg_main #(
   parameter pBYTECNT_SIZE = 7

)(
   input  wire         reset_i,

// Interface to usb_reg_main:
   input  wire         cwusb_clk,
   input  wire [7:0]   reg_address,  // Address of register
   input  wire [pBYTECNT_SIZE-1:0]  reg_bytecnt,  // Current byte count
   output reg  [7:0]   read_data,    //
   input  wire [7:0]   write_data,   //
   input  wire         reg_read,     // Read flag. One clock cycle AFTER this flag is high
                                     // valid data must be present on the read_data bus
   input  wire         reg_write,    // Write flag. When high on rising edge valid data is
                                     // present on write_data
   input  wire         reg_addrvalid,// Address valid flag

// Interface to FIFO:
   input  wire [17:0]  I_fifo_data,
   input  wire [5:0]   I_fifo_status,
   input  wire         I_fifo_empty,
   output wire         O_fifo_read,


// Interface to top-level:
   output reg  [`FE_SELECT_WIDTH-1:0] fe_select,
   output wire selected

);

   wire [31:0] buildtime;
   reg  [7:0] reg_read_data;
   reg  empty_fifo_read;
   reg  fifo_empty_r;
   reg  [17:0] read_data_fifo;

   assign selected = reg_addrvalid & reg_address[6:5] == `MAIN_REG_SELECT;
   wire [4:0] address = reg_address[4:0];

   // read logic:
   always @(posedge cwusb_clk) begin
      if (selected && reg_read) begin

         case (address)
            `REG_BUILDTIME: reg_read_data <= buildtime[reg_bytecnt*8 +: 8];
            `REG_SNIFF_FIFO_STAT: reg_read_data <= {2'b00, I_fifo_status};
            `REG_FE_SELECT: reg_read_data <= fe_select;
         endcase

      end
      else begin
         reg_read_data <= 8'h0;
      end
   end

   // FIFO read logic: perform a FIFO read on first read access to FIFO register:
   assign O_fifo_read = selected && reg_read && ~fifo_empty_r &&
                       (address == `REG_SNIFF_FIFO_RD) &&
                      ((reg_bytecnt % 4) == 0) && ~empty_fifo_read;

   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         empty_fifo_read <= 1'b0;
         fifo_empty_r <= 1'b0;
      end
      else begin
         fifo_empty_r <= I_fifo_empty;
         if (selected && reg_read && (address == `REG_SNIFF_FIFO_RD) && ((reg_bytecnt % 4) == 0) && fifo_empty_r)
            empty_fifo_read <= 1'b1;
         // NOTE: this works because the 4th byte of a FIFO read is dummy data; it
         // will have to be tweaked if the 4th byte contains valid data 
         else if (selected && reg_read && (address == `REG_SNIFF_FIFO_RD) && ((reg_bytecnt % 4) == 3) && ~fifo_empty_r)
            empty_fifo_read <= 1'b0;

      end
   end



   // MUX read output between registers and FIFO output:
   always @(*) begin
      if (empty_fifo_read) begin
         read_data_fifo = 0; // prevent uninentional latch inference
         read_data_fifo[`FE_FIFO_CMD_START +: `FE_FIFO_CMD_BIT_LEN] = `FE_FIFO_CMD_STRM;
         read_data_fifo[`FE_FIFO_DATA_START +: `FE_FIFO_DATA_LEN] = `FE_FIFO_STRM_EMPTY;
      end
      else
         read_data_fifo = I_fifo_data;
      
      if (address == `REG_SNIFF_FIFO_RD) begin
         case (reg_bytecnt % 4)
            0: read_data = read_data_fifo[7:0];
            1: read_data = read_data_fifo[15:8];
            2: read_data = {I_fifo_status, read_data_fifo[17:16]};
            default: read_data = 0;
         endcase
      end
      else
         read_data = reg_read_data;
   end


   // write logic (USB clock domain):
   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         fe_select <= `FE_USB;
      end
      else begin
         if (selected && reg_write) begin
            case (address)
               `REG_FE_SELECT: fe_select <= write_data[`FE_SELECT_WIDTH-1:0];
            endcase
         end
      end
   end


   `ifndef __ICARUS__
      USR_ACCESSE2 U_buildtime (
         .CFGCLK(),
         .DATA(buildtime),
         .DATAVALID()
      );
   `else
      assign buildtime = 0;
   `endif

   `ifdef ILA_REG_MAIN

       ila_2 U_reg_ila (
	.clk            (cwusb_clk),                    // input wire clk
	.probe0         (reg_address),                  // input wire [7:0]  probe0  
	.probe1         (reg_bytecnt),                  // input wire [6:0]  probe1 
	.probe2         (read_data),                    // input wire [7:0]  probe2 
	.probe3         (write_data),                   // input wire [7:0]  probe3 
	.probe4         (reg_read),                     // input wire [0:0]  probe4 
	.probe5         (reg_write),                    // input wire [0:0]  probe5 
	.probe6         (reg_addrvalid),                // input wire [0:0]  probe6 
	.probe7         (reg_read_data),                // input wire [7:0]  probe7 
	.probe8         (selected),                     // input wire [0:0]  probe8 
	.probe9         (read_data_fifo[7:0])           // input wire [7:0]  probe9
       );


   `endif


endmodule

`default_nettype wire
