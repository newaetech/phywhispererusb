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
   parameter pQUICK_START_DEFAULT = 0, // set to 0 for PW-USB, 1 for PW-Trace
   parameter pUSERIO_WIDTH = 8

)(
   input  wire         reset_pin,
   output wire         fpga_reset,

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

// USERIO pins:
   input  wire [pUSERIO_WIDTH-1:0]              userio_d,
   output wire [pUSERIO_WIDTH-1:0]              O_userio_pwdriven,
   output wire [pUSERIO_WIDTH-1:0]              O_userio_drive_data,

// Interface to FIFO:
   input  wire [17:0]  I_fifo_data,
   input  wire [5:0]   I_fifo_status,
   input  wire         I_fifo_empty,
   output wire         O_fifo_read,

// Fast fifo read:
   output wire         O_data_available,
   input  wire         I_fast_fifo_rdn,
   input  wire         I_usb_cen,
   output wire         O_usb_drive_data,

// Interface to front-end capture:
   input  wire         fe_clk,
   output wire         O_arm,
   output wire         O_reg_arm,
   output wire         O_arm_pulse,
   input  wire         I_flushing,
   output wire [pCAPTURE_LEN_WIDTH-1:0] O_capture_len,
   output wire         O_count_writes,
   output wire         O_counter_quick_start,
   output wire         O_capture_now,
   output wire         O_timestamps_disable,
   output wire         O_capture_while_trig,
   output wire [15:0]  O_max_timestamp,

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

// MMCM locked status bits:
   input  wire         I_locked1,
   input  wire         I_locked2,

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
   reg  [17:0] fifo_data_r;
   reg  reg_arm;
   reg  reg_arm_r;
   reg  capture_now;
   reg  capture_now_r;
   wire capture_enable_pulse;
   reg  phaseshift_active;
   reg [pCAPTURE_LEN_WIDTH-1:0] reg_capture_len;
   reg  reg_count_writes;
   reg  reg_counter_quick_start;
   reg  [3:0] reg_board_rev;
   reg  [7:0] read_data_pre;
   reg  reg_fast_fifo_rd_en;
   reg reg_timestamps_disable;
   reg reg_capture_while_trig;
   reg [15:0] reg_max_timestamp;

   reg reg_trigger_enable;
   reg [pNUM_TRIGGER_WIDTH-1:0] reg_num_triggers;
   reg [pALL_TRIGGER_DELAY_WIDTHS-1:0] reg_trigger_delay;
   reg [pALL_TRIGGER_WIDTH_WIDTHS-1:0] reg_trigger_width;
   reg [1:0] reg_bytecnt_r20;
   reg [1:0] fast_fifo_rd_bytecnt;
   reg fast_fifo_rd;
   wire reg_fifo_rd;
   reg fast_fifo_rdn_r;
   reg fast_fifo_rd_out;

   assign O_timestamps_disable = reg_timestamps_disable;
   assign O_trigger_enable = reg_trigger_enable;
   assign O_num_triggers = reg_num_triggers;
   assign O_trigger_delay = reg_trigger_delay;
   assign O_trigger_width = reg_trigger_width;
   assign O_capture_len = reg_capture_len;
   assign O_count_writes = reg_count_writes;
   assign O_counter_quick_start = reg_counter_quick_start;
   assign O_board_rev = reg_board_rev;
   assign O_capture_while_trig = reg_capture_while_trig;
   assign O_max_timestamp = reg_max_timestamp;

   reg [pUSERIO_WIDTH-1:0] reg_userio_pwdriven;
   reg [pUSERIO_WIDTH-1:0] reg_userio_drive_data;

   reg reg_reset = 1'b0;

   assign selected = reg_addrvalid & reg_address[7:6] == `MAIN_REG_SELECT;
   wire [5:0] address = reg_address[5:0];

   assign O_arm = reg_arm_r & ~I_flushing;
   assign O_arm_pulse = reg_arm & ~reg_arm_r;
   assign O_reg_arm = reg_arm;
   assign O_userio_pwdriven = reg_userio_pwdriven;
   assign O_userio_drive_data = reg_userio_drive_data;
   assign O_capture_now = capture_now & ~capture_now_r;
   assign O_data_available = ~I_fifo_empty;
   assign O_usb_drive_data = fast_fifo_rd_out;

   assign fpga_reset = reset_pin || reg_reset;

   // read logic:
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
            `REG_USERIO_DATA: reg_read_data = userio_d;
            `REG_USERIO_PWDRIVEN: reg_read_data = reg_userio_pwdriven;
            `REG_MMCM_LOCKED: reg_read_data = {6'd0, I_locked2, I_locked1};
            `REG_FAST_FIFO_RD_EN: reg_read_data = reg_fast_fifo_rd_en;
            `REG_TIMESTAMPS_DISABLE: reg_read_data = reg_timestamps_disable;
            `REG_CAPTURE_WHILE_TRIG: reg_read_data = reg_capture_while_trig;
            `REG_MAX_TIMESTAMP: reg_read_data = reg_max_timestamp[reg_bytecnt*8 +: 8];
            default: reg_read_data = 0;
         endcase
      end
      else
         reg_read_data = 0;
   end


   // fast FIFO read logic:
   always @(posedge cwusb_clk) begin
      fast_fifo_rdn_r <= I_fast_fifo_rdn;
      //if (~I_usb_cen & ~fast_fifo_rd & ~I_fast_fifo_rdn & reg_fast_fifo_rd_en & (fast_fifo_rd_bytecnt == 3))
      if ( (~fast_fifo_rdn_r & I_fast_fifo_rdn & reg_fast_fifo_rd_en) && (reg_timestamps_disable || (fast_fifo_rd_bytecnt == 3)) )
         fast_fifo_rd <= 1'b1;
      else
         fast_fifo_rd <= 1'b0;

      // Select fast FIFO read output: when we see the first fast FIFO read, we grab hold of driving the output
      // data bus until cen goes back high - this allows us to have the read data ready before it's requested.
      // Caveats: 
      // 1- can't insert a write in the middle of a fast fifo read (will cause bus contention)
      // 2- data can't be presented early for the very first read (this only matters when timestamps are disabled:
      //    when timestamps are enabled, the first read byte is always 0)
      if (~I_usb_cen & ~I_fast_fifo_rdn & reg_fast_fifo_rd_en)
         fast_fifo_rd_out <= 1'b1;
      else if (I_usb_cen)
         fast_fifo_rd_out <= 1'b0;

      if (I_usb_cen)
         fast_fifo_rd_bytecnt <= 0;
      else if (reg_fast_fifo_rd_en & ~fast_fifo_rdn_r & I_fast_fifo_rdn)
         fast_fifo_rd_bytecnt <= fast_fifo_rd_bytecnt + 1; // overflow ok and expected

   end


   // FIFO read logic: perform a FIFO read on first read access to FIFO register:
   assign reg_fifo_rd = selected && reg_read && ~reg_read_r && ~fifo_empty_r &&
                       (address == `REG_SNIFF_FIFO_RD) &&
                      ((reg_bytecnt % 4) == 0) && ~empty_fifo_read;
   assign O_fifo_read = fast_fifo_rd || reg_fifo_rd;

   // catch empty FIFO reads (for streaming mode)
   always @(posedge cwusb_clk) begin
      if (fpga_reset) begin
         empty_fifo_read <= 1'b0;
         fifo_empty_r <= 1'b0;
         reg_read_r <= 1'b0;
         reg_bytecnt_r20 <= 2'b0;
         fifo_data_r <= 18'b0;
      end
      else begin
         fifo_empty_r <= I_fifo_empty;
         reg_read_r <= reg_read;
         reg_bytecnt_r20 <= reg_bytecnt[1:0];
         if (O_fifo_read)
            fifo_data_r <= I_fifo_data;
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
         // bit messy, driven by need for data to be available asap in fast FIFO read mode:
         read_data_fifo = reg_fast_fifo_rd_en? I_fifo_data : fifo_data_r;
      
      if (address == `REG_SNIFF_FIFO_RD) begin
         case (reg_bytecnt % 4)
            1: read_data_pre = read_data_fifo[7:0];
            2: read_data_pre = read_data_fifo[15:8];
            3: read_data_pre = {I_fifo_status, read_data_fifo[17:16]};
            default: read_data_pre = 0;
         endcase
      end

      // fast FIFO reads follow the same logic but there is no address and the byte counter is different:
      else if (fast_fifo_rd_out) begin
         if (reg_timestamps_disable) // grab data straight from FIFO
            read_data_pre = I_fifo_data[15:8];
         else begin
            case (fast_fifo_rd_bytecnt % 4)
               1: read_data_pre = read_data_fifo[7:0];
               2: read_data_pre = read_data_fifo[15:8];
               3: read_data_pre = {I_fifo_status, read_data_fifo[17:16]};
               default: read_data_pre = 0;
            endcase
         end
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
      if (fpga_reset) begin
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
         reg_userio_pwdriven <= 8'b0;
         reg_userio_drive_data <= 8'b0;
         capture_now <= 1'b0;
         capture_now_r <= 1'b0;
         reg_fast_fifo_rd_en <= 1'b0;
         reg_timestamps_disable <= 1'b0;
         reg_capture_while_trig <= 1'b0;
         reg_max_timestamp <= 16'hFFFF;
      end

      else begin
         reg_arm_r <= reg_arm;
         capture_now_r <= capture_now;
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
               `REG_USERIO_DATA: reg_userio_drive_data = write_data;
               `REG_USERIO_PWDRIVEN: reg_userio_pwdriven <= write_data;
               `REG_FAST_FIFO_RD_EN: reg_fast_fifo_rd_en <= write_data;
               `REG_TIMESTAMPS_DISABLE: reg_timestamps_disable <= write_data[0];
               `REG_CAPTURE_WHILE_TRIG: reg_capture_while_trig <= write_data[0];
               `REG_MAX_TIMESTAMP: reg_max_timestamp[reg_bytecnt*8 +: 8] <= write_data;
            endcase
         end

         // ARM register is special:
         if (selected && reg_write && (address == `REG_ARM)) begin
            if (write_data[0])
               reg_arm <= 1'b1;
            if (write_data[1])
               capture_now <= 1'b1;
         end
         else if (capture_enable_pulse)
            reg_arm <= 1'b0;
         else 
            capture_now <= 1'b0;

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

   // special case: register-triggered reset:
   always @(posedge cwusb_clk) begin
      if (selected && reg_write && (address == `REG_RESET_REG))
         reg_reset <= write_data[0];
   end


   cdc_pulse U_match_cdc (
      .reset_i       (fpga_reset),
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
