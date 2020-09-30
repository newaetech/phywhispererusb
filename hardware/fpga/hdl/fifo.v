//////////////////////////////////////////////////////////////////////////////////
// Company: NewAE
// Engineer: Jean-Pierre Thibault
// 
// Create Date: 
// Design Name: 
// Module Name: fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Capture FIFO, shared by all PW frontends. Frontend-specific logic is elsewhere.
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

module fifo (
   input  wire         reset_i,
   input  wire         cwusb_clk,
   input  wire         fe_clk,

// Interface to fe_capture_main:
   input  wire         I_fifo_flush,
   input  wire         I_custom_fifo_stat_flag,
   output wire         O_fifo_full,
   output wire         O_fifo_empty,
   output wire         O_fifo_overflow_blocked,

// Interface to fe_capture_<specific front-end>:
   input  wire [17:0]  I_data,
   input  wire         I_wr,

// Interface to reg_main:
   input  wire         I_fifo_read,
   output wire [17:0]  O_data,
   output wire [5:0]   O_fifo_status,

// Interface to reg_<specific front-end>:
   input  wire         I_clear_read_flags,
   input  wire         I_clear_write_flags

);


   reg fifo_full_usbclk;
   reg fifo_overflow_blocked_usbclk;
   (* ASYNC_REG = "TRUE" *) reg [1:0] fifo_full_pipe;
   (* ASYNC_REG = "TRUE" *) reg [1:0] fifo_overflow_blocked_pipe;

   reg  fifo_underflow_sticky;

   wire fifo_flush_condition;
   wire fifo_rd_en;
   wire fifo_full;
   wire fifo_full_threshold_xilinx;
   wire fifo_empty_threshold_xilinx;
   wire fifo_empty;
   wire fifo_underflow;
   wire fifo_empty_threshold;
   reg  fifo_overflow_blocked;

   assign O_fifo_empty = fifo_empty;

   // CDC:
   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         fifo_full_usbclk <= 0;
         fifo_overflow_blocked_usbclk <= 0;
         fifo_full_pipe <= 0;
         fifo_overflow_blocked_pipe <= 0;
      end
      else begin
         {fifo_full_usbclk, fifo_full_pipe} <= {fifo_full_pipe, fifo_full};
         {fifo_overflow_blocked_usbclk, fifo_overflow_blocked_pipe} <= {fifo_overflow_blocked_pipe, fifo_overflow_blocked};
      end
   end


   // fe_clk (write side) logic:
   always @(posedge fe_clk) begin
      if (reset_i) begin
         fifo_overflow_blocked <= 1'b0;
      end
      else begin
         // if a write WOULD have overflowed the FIFO, log it:
         if (I_wr & fifo_full_threshold_xilinx)
            fifo_overflow_blocked <= 1'b1;
         else if (I_clear_write_flags)
            fifo_overflow_blocked <= 1'b0;

      end
   end

   // FIFO read logic:
   // perform a FIFO read on first read access to FIFO register, or when flushing:
   assign fifo_flush_condition = (I_fifo_flush & ~fifo_empty);
   assign fifo_rd_en = I_fifo_read || fifo_flush_condition;

   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         fifo_underflow_sticky <= 1'b0;
      end
      else begin
         // Xilinx FIFO underflow flag isn't sticky, so create our own:
         if (fifo_underflow)
            fifo_underflow_sticky <= 1'b1;
         else if (I_clear_read_flags)
            fifo_underflow_sticky <= 1'b0;
      end
   end


   `ifdef TINYFIFO
      fifo_generator_tiny U_fifo (
        .rst            (reset_i),

        // Write port:
        .wr_clk         (fe_clk),
        .wr_en          (I_wr),
        .din            (I_data),
        .full           (fifo_full),
        .prog_full      (fifo_full_threshold_xilinx),

        // Read port:
        .rd_clk         (cwusb_clk),
        .rd_en          (fifo_rd_en),
        .dout           (O_data),
        .underflow      (fifo_underflow),
        .empty          (fifo_empty),
        .prog_empty     (fifo_empty_threshold_xilinx)
      );
   `else
      fifo_generator_0 U_fifo (
        .rst            (reset_i),

        // Write port:
        .wr_clk         (fe_clk),
        .wr_en          (I_wr),
        .din            (I_data),
        .full           (fifo_full),
        .prog_full      (fifo_full_threshold_xilinx),

        // Read port:
        .rd_clk         (cwusb_clk),
        .rd_en          (fifo_rd_en),
        .dout           (O_data),
        .underflow      (fifo_underflow),
        .empty          (fifo_empty),
        .prog_empty     (fifo_empty_threshold_xilinx)
      );
   `endif

   // these definitions are more useful:
   assign fifo_empty_threshold = fifo_empty_threshold_xilinx & !fifo_empty;

   assign O_fifo_full = fifo_full;
   assign O_fifo_overflow_blocked = fifo_overflow_blocked;


   assign O_fifo_status[`FIFO_STAT_EMPTY] = fifo_empty;
   assign O_fifo_status[`FIFO_STAT_UNDERFLOW] = fifo_underflow_sticky;
   assign O_fifo_status[`FIFO_STAT_EMPTY_THRESHOLD] = fifo_empty_threshold;
   assign O_fifo_status[`FIFO_STAT_FULL] = fifo_full_usbclk;
   assign O_fifo_status[`FIFO_STAT_OVERFLOW_BLOCKED] = fifo_overflow_blocked_usbclk;

   // info: for PW, this is capture_done:
   assign O_fifo_status[`FIFO_STAT_CUSTOM_FLAG] = I_custom_fifo_stat_flag;

   `ifdef ILA_FIFO
       ila_3 U_fe_fifo_wr_ila (
          .clk          (fe_clk),
          .probe0       (I_wr),
          .probe1       (fifo_full),
          .probe2       (fifo_overflow_blocked),
          .probe3       (1'b0),
          .probe4       (I_data)
       );
   `endif

   `ifdef ILA_FIFO
       ila_3 U_fe_fifo_rd_ila (
          .clk          (cwusb_clk),
          .probe0       (fifo_rd_en),
          .probe1       (fifo_empty),
          .probe2       (fifo_underflow_sticky),
          .probe3       (fifo_overflow_blocked_usbclk),
          .probe4       (O_data)
       );
   `endif


endmodule

`default_nettype wire
