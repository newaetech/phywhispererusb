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
   parameter pBYTECNT_SIZE = 7,
   parameter pNUM_TRIGGER_PULSES = 8,
   parameter pNUM_TRIGGER_WIDTH = 4,
   parameter pALL_TRIGGER_DELAY_WIDTHS = 24*pNUM_TRIGGER_PULSES,
   parameter pALL_TRIGGER_WIDTH_WIDTHS = 24*pNUM_TRIGGER_PULSES,
   parameter pCAPTURE_LEN_WIDTH = 24,
   parameter pQUICK_START_DEFAULT = 0  // set to 0 for PW-USB, 1 for PW-Trace

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

// Interface to front-end capture:
   input  wire         fe_clk,
   output wire         O_arm,
   output wire         O_reg_arm,
   input  wire         I_flushing,
   output wire [pCAPTURE_LEN_WIDTH-1:0] O_capture_len,
   output wire         O_count_writes,
   output wire         O_counter_quick_start,

// user-settable to allow for FPGA pin assignment changes across board revisions
   output wire [3:0]   O_board_rev,

   input  wire         I_capture_enable_pulse,

// Interface to trigger generator:
   output wire [pALL_TRIGGER_DELAY_WIDTHS-1:0]  O_trigger_delay,
   output wire [pALL_TRIGGER_WIDTH_WIDTHS-1:0]  O_trigger_width,
   output wire [pNUM_TRIGGER_WIDTH-1:0]         O_num_triggers,
   output wire                                  O_trigger_enable,


// Interface to trigger clock phase shift:
   output reg          O_psincdec,
   output reg          O_psen,
   input  wire         I_psdone,  

// Interface to top-level:
   output reg  [`FE_SELECT_WIDTH-1:0] fe_select,
   output wire selected

);

   wire [31:0] buildtime;
   reg  [7:0] reg_read_data;
   reg  empty_fifo_read;
   reg  fifo_empty_r;
   reg  reg_read_r;
   reg  [17:0] read_data_fifo;
   reg  reg_arm;
   reg  reg_arm_r;
   wire capture_enable_pulse;
   reg  phaseshift_active;
   reg [pCAPTURE_LEN_WIDTH-1:0] reg_capture_len;
   reg  reg_count_writes;
   reg  reg_counter_quick_start;
   reg  [3:0] reg_board_rev;
   reg  [7:0] read_data_pre;

   reg reg_trigger_enable;
   reg [pNUM_TRIGGER_WIDTH-1:0] reg_num_triggers;
   reg [pALL_TRIGGER_DELAY_WIDTHS-1:0] reg_trigger_delay;
   reg [pALL_TRIGGER_WIDTH_WIDTHS-1:0] reg_trigger_width;
   reg [1:0] reg_bytecnt_r20;

   assign O_trigger_enable = reg_trigger_enable;
   assign O_num_triggers = reg_num_triggers;
   assign O_trigger_delay = reg_trigger_delay;
   assign O_trigger_width = reg_trigger_width;
   assign O_capture_len = reg_capture_len;
   assign O_count_writes = reg_count_writes;
   assign O_counter_quick_start = reg_counter_quick_start;
   assign O_board_rev = reg_board_rev;

   assign selected = reg_addrvalid & reg_address[7:6] == `MAIN_REG_SELECT;
   wire [5:0] address = reg_address[5:0];

   assign O_arm = reg_arm_r & ~I_flushing;
   assign O_reg_arm = reg_arm;

   always @(*) begin
      if (selected && reg_read) begin
         case (address)
            `REG_BUILDTIME: reg_read_data = buildtime[reg_bytecnt*8 +: 8];
            `REG_SNIFF_FIFO_STAT: reg_read_data = {2'b00, I_fifo_status};
            `REG_FE_SELECT: reg_read_data = fe_select;
            `REG_ARM: reg_read_data = reg_arm;
            `REG_TRIGGER_ENABLE: reg_read_data = reg_trigger_enable;
            `REG_TRIGGER_DELAY: reg_read_data = reg_trigger_delay[reg_bytecnt*8 +: 8];
            `REG_TRIGGER_WIDTH: reg_read_data = reg_trigger_width[reg_bytecnt*8 +: 8];
            `REG_NUM_TRIGGERS: reg_read_data = {4'b0, reg_num_triggers};
            `REG_TRIG_CLK_PHASE_SHIFT: reg_read_data = {7'b0, phaseshift_active};
            `REG_CAPTURE_LEN: reg_read_data = reg_capture_len[reg_bytecnt*8 +: 8];
            `REG_COUNT_WRITES: reg_read_data = reg_count_writes;
            `REG_COUNTER_QUICK_START: reg_read_data = reg_counter_quick_start;
            `REG_BOARD_REV: reg_read_data = reg_board_rev;
            default: reg_read_data = 0;
         endcase
      end
      else
         reg_read_data = 0;
   end


   // FIFO read logic: perform a FIFO read on first read access to FIFO register:
   assign O_fifo_read = selected && reg_read && ~reg_read_r && ~fifo_empty_r &&
                       (address == `REG_SNIFF_FIFO_RD) &&
                      ((reg_bytecnt % 4) == 0) && ~empty_fifo_read;

   // catch empty FIFO reads (for streaming mode)
   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         empty_fifo_read <= 1'b0;
         fifo_empty_r <= 1'b0;
         reg_read_r <= 1'b0;
         reg_bytecnt_r20 <= 2'b0;
      end
      else begin
         fifo_empty_r <= I_fifo_empty;
         reg_read_r <= reg_read;
         reg_bytecnt_r20 <= reg_bytecnt[1:0];
         if (selected && reg_read && ~reg_read_r && (address == `REG_SNIFF_FIFO_RD) && ((reg_bytecnt % 4) == 0) && fifo_empty_r)
            empty_fifo_read <= 1'b1;
         else if (selected && reg_read_r && (address == `REG_SNIFF_FIFO_RD) && ((reg_bytecnt % 4) == 0) && reg_bytecnt_r20 == 2'b11 && ~fifo_empty_r)
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
            1: read_data_pre = read_data_fifo[7:0];
            2: read_data_pre = read_data_fifo[15:8];
            3: read_data_pre = {I_fifo_status, read_data_fifo[17:16]};
            default: read_data_pre = 0;
         endcase
      end
      else
         read_data_pre = reg_read_data;
   end

   // Register output read data to ease timing. If you need data one clock
   // cycle earlier, simply remove this stage.
   always @(posedge cwusb_clk)
      read_data <= read_data_pre;

   // write logic (USB clock domain):
   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         fe_select <= `FE_USB;
         reg_arm <= 1'b0;
         reg_arm_r <= 1'b0;
         reg_trigger_enable <= 0;
         reg_trigger_delay <= 0;
         reg_trigger_width <= 0;
         reg_num_triggers <= 1;
         O_psen <= 1'b0;
         O_psincdec <= 1'b0;
         phaseshift_active <= 1'b0;
         reg_capture_len <= 0;
         reg_count_writes <= 0;
         reg_counter_quick_start <= pQUICK_START_DEFAULT;
         reg_board_rev <= 4; // production boards
      end

      else begin
         reg_arm_r <= reg_arm;
         if (selected && reg_write) begin
            case (address)
               `REG_FE_SELECT: fe_select <= write_data[`FE_SELECT_WIDTH-1:0];
               `REG_TRIGGER_ENABLE: reg_trigger_enable <= write_data;
               `REG_TRIGGER_DELAY: reg_trigger_delay[reg_bytecnt*8 +: 8] <= write_data;
               `REG_TRIGGER_WIDTH: reg_trigger_width[reg_bytecnt*8 +: 8] <= write_data;
               `REG_NUM_TRIGGERS: reg_num_triggers <= write_data[pNUM_TRIGGER_WIDTH-1:0];
               `REG_CAPTURE_LEN: reg_capture_len[reg_bytecnt*8 +: 8] <= write_data;
               `REG_COUNT_WRITES: reg_count_writes <= write_data;
               `REG_COUNTER_QUICK_START: reg_counter_quick_start <= write_data;
               `REG_BOARD_REV: reg_board_rev <= write_data;
            endcase
         end

         // ARM register is special:
         if (selected && reg_write && (address == `REG_ARM))
            reg_arm <= write_data[0];
         else if (capture_enable_pulse)
            reg_arm <= 1'b0;

         // Phase shift for trigger clock register is special: (reference: Xilinx UG472)
         if (selected && reg_write && (address == `REG_TRIG_CLK_PHASE_SHIFT) && ~phaseshift_active) begin
            O_psincdec <= write_data[0];
            O_psen <= 1'b1;
            phaseshift_active <= 1'b1;
         end
         else begin
            O_psen <= 1'b0;
            if (I_psdone)
               phaseshift_active <= 1'b0;
         end

      end
   end


   cdc_pulse U_match_cdc (
      .reset_i       (reset_i),
      .src_clk       (fe_clk),
      .src_pulse     (I_capture_enable_pulse),
      .dst_clk       (cwusb_clk),
      .dst_pulse     (capture_enable_pulse)
   );


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
