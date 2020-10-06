//////////////////////////////////////////////////////////////////////////////////
// Company: NewAE
// Engineer: Jean-Pierre Thibault
// 
// Create Date: 
// Design Name: 
// Module Name: reg_pw
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

`default_nettype none
`timescale 1ns / 1ps
`include "defines.v"

module reg_pw #(
   parameter pTIMESTAMP_FULL_WIDTH = 16,
   parameter pTIMESTAMP_SHORT_WIDTH = 3,
   parameter pPATTERN_BYTES = 8,
   parameter pCAPTURE_DELAY_WIDTH = 18,
   parameter pBYTECNT_SIZE = 7,
   parameter pUSB_AUTO_COUNTER_WIDTH = 24,
   parameter pCAPTURE_LEN_WIDTH = 24,
   parameter pNUM_TRIGGER_PULSES = 8,
   parameter pNUM_TRIGGER_WIDTH = 4,
   parameter pALL_TRIGGER_DELAY_WIDTHS = 24*pNUM_TRIGGER_PULSES,
   parameter pALL_TRIGGER_WIDTH_WIDTHS = 24*pNUM_TRIGGER_PULSES

)(
   input  wire         reset_i,

// Interface to reg_main_cwlite:
   input  wire         cwusb_clk,
   input  wire [5:0]   reg_address,  // Address of register
   input  wire [pBYTECNT_SIZE-1:0]  reg_bytecnt,  // Current byte count
   output reg  [7:0]   read_data,    //
   input  wire [7:0]   write_data,   //
   input  wire         reg_read,     // Read flag. One clock cycle AFTER this flag is high
                                     // valid data must be present on the read_data bus
   input  wire         reg_write,    // Write flag. When high on rising edge valid data is
                                     // present on write_data
   input  wire         reg_addrvalid,// Address valid flag

// USERIO pins:
   input  wire [7:0]                            userio_d,
   output wire [7:0]                            O_userio_pwdriven,
   output wire [7:0]                            O_userio_drive_data,

// Interface to front end capture:
   input  wire         fe_clk,
   output wire         O_timestamps_disable,
   output wire         O_arm,
   output wire [pCAPTURE_LEN_WIDTH-1:0]  O_capture_len,
   output wire         O_fifo_full,
   output wire         O_fifo_overflow_blocked,
   input  wire         [pTIMESTAMP_FULL_WIDTH-1:0] I_fe_capture_time,
   input  wire [7:0]   I_fe_capture_data,
   input  wire [4:0]   I_fe_capture_stat,
   input  wire [1:0]   I_fe_capture_cmd,
   input  wire         I_fe_capture_data_wr,
   input  wire         I_fe_capturing,

// Interface to pattern matcher:
   output wire         [8*pPATTERN_BYTES-1:0] O_pattern,
   output wire         [8*pPATTERN_BYTES-1:0] O_pattern_mask,
   output wire         [7:0] O_pattern_bytes,

// Interface to trigger generator:
   output wire [pALL_TRIGGER_DELAY_WIDTHS-1:0] O_trigger_delay,
   output wire [pALL_TRIGGER_WIDTH_WIDTHS-1:0] O_trigger_width,
   output wire [pCAPTURE_DELAY_WIDTH-1:0] O_capture_delay,
   output wire [pNUM_TRIGGER_WIDTH-1:0] O_num_triggers,
   output wire         O_trigger_enable,
   input  wire         I_capture_enable_pulse,

// Interface to USB autodetect:
   output reg  O_usb_auto_restart,
   output wire [pUSB_AUTO_COUNTER_WIDTH-1:0] O_usb_auto_wait1,
   output wire [pUSB_AUTO_COUNTER_WIDTH-1:0] O_usb_auto_wait2,
   input  wire [1:0] I_usb_auto_speed,

// Interface to trigger clock phase shift:
   output reg  O_psincdec,
   output reg  O_psen,
   input  wire I_psdone,  

// To top-level:
   output wire [1:0] O_usb_speed,
   output wire [1:0] O_usb_xcvrsel_auto,
   output wire O_usb_termsel_auto

);

   reg [7:0] reg_userio_pwdriven;
   reg [7:0] reg_userio_drive_data;
   assign O_userio_pwdriven = reg_userio_pwdriven;
   assign O_userio_drive_data = reg_userio_drive_data;

   reg reg_arm;
   reg reg_arm_r;
   reg reg_timestamps_disable;
   reg [8*pPATTERN_BYTES-1:0] reg_pattern;
   reg [8*pPATTERN_BYTES-1:0] reg_pattern_mask;
   reg reg_trigger_enable;
   reg [7:0] reg_pattern_bytes;
   reg [pCAPTURE_LEN_WIDTH-1:0] reg_capture_len;
   reg [pCAPTURE_DELAY_WIDTH-1:0] reg_capture_delay;
   reg [pALL_TRIGGER_DELAY_WIDTHS-1:0] reg_trigger_delay;
   reg [pALL_TRIGGER_WIDTH_WIDTHS-1:0] reg_trigger_width;
   reg [pNUM_TRIGGER_WIDTH-1:0] reg_num_triggers;
   reg [1:0] reg_usb_speed;
   reg [pUSB_AUTO_COUNTER_WIDTH-1:0] reg_usb_auto_wait1;
   reg [pUSB_AUTO_COUNTER_WIDTH-1:0] reg_usb_auto_wait2;
   reg [15:0] reg_stat_pattern;
   reg stat_match_captured;
   reg [4:0] stat_match;
   wire [15:0] reg_stat_matched;
   (* ASYNC_REG = "TRUE" *) reg  [4:0] stat_pattern;
   (* ASYNC_REG = "TRUE" *) reg  [4:0] stat_mask;
   reg  stat_match_update_pulse;
   wire stat_match_update_pulse_fe;

   reg [2:0] reg_usb_auto_defaults;
   (* ASYNC_REG = "TRUE" *) reg [1:0] usb_speed_auto;

   wire sniff_fifo_full;
   wire sniff_fifo_empty;
   reg  sniff_fifo_overflow_blocked;
   wire sniff_fifo_underflow;
   reg  sniff_fifo_underflow_sticky;
   reg  sniff_fifo_wr_en;
   wire sniff_fifo_rd_en;
   reg  [17:0] sniff_fifo_din;
   wire [17:0] sniff_fifo_dout;
   reg  [17:0] fifo_read_data;
   wire sniff_fifo_empty_threshold_xilinx;
   wire sniff_fifo_empty_threshold;
   wire sniff_fifo_full_threshold_xilinx;
   wire fifo_read_condition;
   wire fifo_flush_condition;
   wire capture_done;

   reg  [7:0] reg_read_data;
   reg  flushing;
   wire [5:0] fifo_status;
   reg  empty_fifo_read;
   reg  sniff_fifo_empty_r;

   reg  phaseshift_active;

   wire [31:0] buildtime;
   wire capture_enable_pulse;

   assign O_arm = reg_arm_r & ~flushing;
   assign O_timestamps_disable = reg_timestamps_disable;
   assign O_pattern = reg_pattern;
   assign O_pattern_mask = reg_pattern_mask;
   assign O_trigger_enable = reg_trigger_enable;
   assign O_pattern_bytes = reg_pattern_bytes;
   assign O_capture_len = reg_capture_len;
   assign O_trigger_delay = reg_trigger_delay;
   assign O_trigger_width = reg_trigger_width;
   assign O_num_triggers = reg_num_triggers;
   assign O_capture_delay = reg_capture_delay;
   assign O_usb_speed = (reg_usb_speed == `USB_SPEED_AUTO)? usb_speed_auto : reg_usb_speed;
   assign O_usb_xcvrsel_auto = reg_usb_auto_defaults[1:0];
   assign O_usb_termsel_auto = reg_usb_auto_defaults[2];
   assign O_usb_auto_wait1 = reg_usb_auto_wait1;
   assign O_usb_auto_wait2 = reg_usb_auto_wait2;

   // read logic:
   always @(posedge cwusb_clk) begin
      if (reg_addrvalid && reg_read) begin
         case (reg_address)
            `REG_ARM: reg_read_data <= reg_arm;
            `REG_PATTERN: reg_read_data <= reg_pattern[reg_bytecnt*8 +: 8];
            `REG_PATTERN_MASK: reg_read_data <= reg_pattern_mask[reg_bytecnt*8 +: 8];
            `REG_TRIGGER_ENABLE: reg_read_data <= reg_trigger_enable;
            `REG_PATTERN_BYTES: reg_read_data <= reg_pattern_bytes;
            `REG_SNIFF_FIFO_STAT: reg_read_data <= {2'b00, fifo_status};
            `REG_USB_SPEED: reg_read_data <= {6'b0, O_usb_speed};
            `REG_BUILDTIME: reg_read_data <= buildtime[reg_bytecnt*8 +: 8];
            `REG_TRIG_CLK_PHASE_SHIFT: reg_read_data <= {7'b0, phaseshift_active};
            `REG_STAT_MATCH: reg_read_data <= reg_stat_matched[reg_bytecnt*8 +: 8];
            `REG_TIMESTAMPS_DISABLE: reg_read_data <= reg_timestamps_disable;
            `REG_CAPTURE_LEN: reg_read_data <= reg_capture_len[reg_bytecnt*8 +: 8];
            `REG_TRIGGER_DELAY: reg_read_data <= reg_trigger_delay[reg_bytecnt*8 +: 8];
            `REG_TRIGGER_WIDTH: reg_read_data <= reg_trigger_width[reg_bytecnt*8 +: 8];
            `REG_NUM_TRIGGERS: reg_read_data <= {4'b0, reg_num_triggers};
            `REG_USB_AUTO_DEFAULTS: reg_read_data <= reg_usb_auto_defaults;
            `REG_CAPTURE_DELAY: reg_read_data <= reg_capture_delay[reg_bytecnt*8 +: 8];
            `REG_USB_AUTO_WAIT1: reg_read_data <= reg_usb_auto_wait1[reg_bytecnt*8 +: 8];
            `REG_USB_AUTO_WAIT2: reg_read_data <= reg_usb_auto_wait2[reg_bytecnt*8 +: 8];
            `REG_STAT_PATTERN: reg_read_data <= reg_stat_pattern[reg_bytecnt*5 +: 5];
            `REG_USERIO_DATA: reg_read_data <= userio_d;
            `REG_USERIO_PWDRIVEN: reg_read_data <= reg_userio_pwdriven;
         endcase
      end
      else
         reg_read_data <= 8'b0;
   end


   // MUX read output between registers and FIFO output:
   always @(*) begin
      if (empty_fifo_read) begin
         fifo_read_data = 0; // prevent uninentional latch inference
         fifo_read_data[`FE_FIFO_CMD_START +: `FE_FIFO_CMD_BIT_LEN] = `FE_FIFO_CMD_STRM;
         fifo_read_data[`FE_FIFO_DATA_START +: `FE_FIFO_DATA_LEN] = `FE_FIFO_STRM_EMPTY;
      end
      else
         fifo_read_data = sniff_fifo_dout;
      
      if (reg_address == `REG_SNIFF_FIFO_RD) begin
         case (reg_bytecnt % 4)
            0: read_data = fifo_read_data[7:0];
            1: read_data = fifo_read_data[15:8];
            2: read_data = {fifo_status, fifo_read_data[17:16]};
            default: read_data = 0;
         endcase
      end
      else
         read_data = reg_read_data;
   end


   // write logic (USB clock domain):
   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         reg_arm <= 1'b0;
         reg_timestamps_disable <= 1'b0;
         reg_pattern <= 0;
         reg_pattern_mask <= 64'h0;
         reg_trigger_enable <= 0;
         reg_pattern_bytes <= 8'd0;
         reg_capture_len <= 0;
         reg_capture_delay <= 0;
         reg_trigger_delay <= 0;
         reg_trigger_width <= 0;
         reg_num_triggers <= 1;
         reg_usb_speed <= `USB_SPEED_AUTO;
         O_usb_auto_restart <= 1'b0;
         reg_usb_auto_defaults <= {1'b1, 2'b01}; // for USB_SPEED_FS
         reg_usb_auto_wait1 <= 60000; // 1ms
         reg_usb_auto_wait2 <= 3600000; // 60ms
         phaseshift_active <= 1'b0;
         O_psen <= 1'b0;
         reg_stat_pattern <= 10'b11111_00000;
         stat_match_update_pulse <= 1'b0;
         reg_userio_pwdriven <= 8'b0;
         reg_userio_drive_data <= 8'b0;

      end
      else begin
         if (reg_addrvalid && reg_write) begin
            case (reg_address)
               `REG_TIMESTAMPS_DISABLE: reg_timestamps_disable <= write_data[0];
               `REG_PATTERN: reg_pattern[reg_bytecnt*8 +: 8] <= write_data;
               `REG_PATTERN_MASK: reg_pattern_mask[reg_bytecnt*8 +: 8] <= write_data;
               `REG_TRIGGER_ENABLE: reg_trigger_enable <= write_data;
               `REG_PATTERN_BYTES: reg_pattern_bytes <= write_data;
               `REG_CAPTURE_LEN: reg_capture_len[reg_bytecnt*8 +: 8] <= write_data;
               `REG_TRIGGER_DELAY: reg_trigger_delay[reg_bytecnt*8 +: 8] <= write_data;
               `REG_TRIGGER_WIDTH: reg_trigger_width[reg_bytecnt*8 +: 8] <= write_data;
               `REG_NUM_TRIGGERS: reg_num_triggers <= write_data[pNUM_TRIGGER_WIDTH-1:0];
               `REG_USB_SPEED: reg_usb_speed <= write_data;
               `REG_USB_AUTO_DEFAULTS: reg_usb_auto_defaults <= write_data[2:0];
               `REG_CAPTURE_DELAY: reg_capture_delay[reg_bytecnt*8 +: 8] <= write_data;
               `REG_USB_AUTO_WAIT1: reg_usb_auto_wait1[reg_bytecnt*8 +: 8] <= write_data;
               `REG_USB_AUTO_WAIT2: reg_usb_auto_wait2[reg_bytecnt*8 +: 8] <= write_data;
               `REG_USERIO_DATA: reg_userio_drive_data = write_data;
               `REG_USERIO_PWDRIVEN: reg_userio_pwdriven <= write_data;
            endcase
         end

         // ARM register is special:
         if (reg_addrvalid && reg_write && (reg_address == `REG_ARM))
            reg_arm <= write_data[0];
         else if (capture_enable_pulse)
            reg_arm <= 1'b0;

         // USB auto restart register is special:
         if (reg_addrvalid && reg_write && (reg_address == `REG_USB_SPEED) && (write_data == `USB_SPEED_AUTO))
            O_usb_auto_restart <= 1'b1;
         else
            O_usb_auto_restart <= 1'b0;

         // Phase shift for trigger clock register is special: (reference: Xilinx UG472)
         if (reg_addrvalid && reg_write && (reg_address == `REG_TRIG_CLK_PHASE_SHIFT) && ~phaseshift_active) begin
            O_psincdec <= write_data[0];
            O_psen <= 1'b1;
            phaseshift_active <= 1'b1;
         end
         else begin
            O_psen <= 1'b0;
            if (I_psdone)
               phaseshift_active <= 1'b0;
         end

         // STAT match register is special:
         if (reg_addrvalid && reg_write && (reg_address == `REG_STAT_PATTERN)) begin
            reg_stat_pattern[reg_bytecnt*5 +: 5] <= write_data[4:0];
            if (reg_bytecnt == 0)
               stat_match_update_pulse <= 1'b1;
         end
         else
            stat_match_update_pulse <= 1'b0;

      end
   end

   reg reg_arm_feclk;
   reg reg_arm_feclk_r;
   (* ASYNC_REG = "TRUE" *) reg  [1:0] reg_arm_pipe;

   reg sniff_fifo_full_usbclk;
   reg sniff_fifo_overflow_blocked_usbclk;
   reg capturing;
   (* ASYNC_REG = "TRUE" *) reg [1:0] sniff_fifo_full_pipe;
   (* ASYNC_REG = "TRUE" *) reg [1:0] sniff_fifo_overflow_blocked_pipe;
   (* ASYNC_REG = "TRUE" *) reg [1:0] capturing_pipe;


   // CDC:
   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         sniff_fifo_full_usbclk <= 0;
         sniff_fifo_overflow_blocked_usbclk <= 0;
         capturing <= 0;
         sniff_fifo_full_pipe <= 0;
         sniff_fifo_overflow_blocked_pipe <= 0;
         capturing_pipe <= 0;
         usb_speed_auto <= 0;
      end
      else begin
         usb_speed_auto <= I_usb_auto_speed;
         {capturing, capturing_pipe} <= {capturing_pipe, I_fe_capturing};
         {sniff_fifo_full_usbclk, sniff_fifo_full_pipe} <= {sniff_fifo_full_pipe, sniff_fifo_full};
         {sniff_fifo_overflow_blocked_usbclk, sniff_fifo_overflow_blocked_pipe} <= {sniff_fifo_overflow_blocked_pipe, sniff_fifo_overflow_blocked};
      end
   end

   cdc_pulse U_match_cdc (
      .reset_i       (reset_i),
      .src_clk       (fe_clk),
      .src_pulse     (I_capture_enable_pulse),
      .dst_clk       (cwusb_clk),
      .dst_pulse     (capture_enable_pulse)
   );

   cdc_pulse U_stat_update_cdc (
      .reset_i       (reset_i),
      .src_clk       (cwusb_clk),
      .src_pulse     (stat_match_update_pulse),
      .dst_clk       (fe_clk),
      .dst_pulse     (stat_match_update_pulse_fe)
   );



   // USB STAT monitor logic:
   always @(posedge fe_clk) begin
      if (reset_i) begin
         stat_pattern <= 0;
         stat_mask <= 0;
         stat_match <= 0;
         stat_match_captured <= 0;
      end
      else begin
         // CDC:
         stat_pattern <= reg_stat_pattern[4:0];
         stat_mask <= reg_stat_pattern[9:5];

         // reset stat match upon arming:
         if (reg_arm_feclk && ~reg_arm_feclk_r || stat_match_update_pulse_fe)
            stat_match_captured <= 1'b0;
         else if (~stat_match_captured && ((stat_pattern & stat_mask) == (I_fe_capture_stat & stat_mask))) begin
            stat_match_captured <= 1'b1;
            stat_match <= I_fe_capture_stat;
         end

      end
   end

   assign reg_stat_matched = {3'b0, stat_match, 7'b0, stat_match_captured};



   // FIFO write logic.
   // note: could maybe get away with combinatorial logic here?
   always @(posedge fe_clk) begin
      if (reset_i) begin
         sniff_fifo_wr_en <= 1'b0;
         sniff_fifo_din <= 0;
         sniff_fifo_overflow_blocked <= 1'b0;
         reg_arm_feclk <= 0;
         reg_arm_pipe <= 0;
      end
      else begin
         // CDC:
         {reg_arm_feclk_r, reg_arm_feclk, reg_arm_pipe} <= {reg_arm_feclk, reg_arm_pipe, reg_arm};

         // don't overflow the FIFO:
         // Because back-to-back writes are possible, checking sniff_fifo_full may not prevent overflow,
         // and so the last few FIFO entries are wasted :-(
         if (I_fe_capture_data_wr & !sniff_fifo_full_threshold_xilinx) begin
            sniff_fifo_wr_en <= 1'b1;
            sniff_fifo_din[`FE_FIFO_CMD_START +: `FE_FIFO_CMD_BIT_LEN] <= I_fe_capture_cmd;
            case (I_fe_capture_cmd)
               `FE_FIFO_CMD_DATA: begin
                  sniff_fifo_din[`FE_FIFO_TIME_START +: `FE_FIFO_SHORTTIME_LEN] <= I_fe_capture_time[`FE_FIFO_SHORTTIME_LEN-1:0];
                  sniff_fifo_din[`FE_FIFO_DATA_START +: `FE_FIFO_DATA_LEN] <= I_fe_capture_data;
                  sniff_fifo_din[`FE_FIFO_USB_STATUS_BITS_START +: `FE_FIFO_USB_STATUS_BITS_LEN] <= I_fe_capture_stat;
               end
               `FE_FIFO_CMD_STAT: begin
                  sniff_fifo_din[`FE_FIFO_TIME_START +: `FE_FIFO_SHORTTIME_LEN] <= I_fe_capture_time[`FE_FIFO_SHORTTIME_LEN-1:0];
                  sniff_fifo_din[`FE_FIFO_DATA_START +: `FE_FIFO_DATA_LEN] <= 8'd0;
                  sniff_fifo_din[`FE_FIFO_USB_STATUS_BITS_START +: `FE_FIFO_USB_STATUS_BITS_LEN] <= I_fe_capture_stat;
               end
               `FE_FIFO_CMD_TIME: begin
                  sniff_fifo_din[`FE_FIFO_TIME_START +: `FE_FIFO_FULLTIME_LEN] <= I_fe_capture_time;
               end
            endcase
         end
         else
            sniff_fifo_wr_en <= 1'b0;

         // if a write WOULD have overflowed the FIFO, log it:
         if (I_fe_capture_data_wr & sniff_fifo_full_threshold_xilinx)
            sniff_fifo_overflow_blocked <= 1'b1;
         else if (reg_arm_feclk)
            sniff_fifo_overflow_blocked <= 1'b0;

      end
   end

   // FIFO read logic:
   // perform a FIFO read on first read access to FIFO register, or when flushing:
   assign fifo_read_condition = reg_addrvalid && reg_read && ~sniff_fifo_empty_r &&
                               (reg_address == `REG_SNIFF_FIFO_RD) &&
                              ((reg_bytecnt % 4) == 0) && ~empty_fifo_read;
   assign fifo_flush_condition = (flushing & ~sniff_fifo_empty);
   assign sniff_fifo_rd_en = fifo_read_condition || fifo_flush_condition;

   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         sniff_fifo_underflow_sticky <= 1'b0;
         empty_fifo_read <= 1'b0;
         sniff_fifo_empty_r <= 1'b0;
      end
      else begin
         // Xilinx FIFO underflow flag isn't sticky, so create our own:
         if (sniff_fifo_underflow)
            sniff_fifo_underflow_sticky <= 1'b1;
         else if (reg_arm)
            sniff_fifo_underflow_sticky <= 1'b0;

         sniff_fifo_empty_r <= sniff_fifo_empty;
         if (reg_addrvalid && reg_read && (reg_address == `REG_SNIFF_FIFO_RD) && ((reg_bytecnt % 4) == 0) && sniff_fifo_empty_r)
            empty_fifo_read <= 1'b1;
         // NOTE: this works because the 4th byte of a FIFO read is dummy data; it
         // will have to be tweaked if the 4th byte contains valid data 
         else if (reg_addrvalid && reg_read && (reg_address == `REG_SNIFF_FIFO_RD) && ((reg_bytecnt % 4) == 3) && ~sniff_fifo_empty_r)
            empty_fifo_read <= 1'b0;

      end
   end

   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         flushing <= 1'b0;
         reg_arm_r <= 1'b0;
      end
      else begin
         reg_arm_r <= reg_arm;
         if (sniff_fifo_empty)
            flushing <= 1'b0;
         else if (reg_arm & ~flushing)
            flushing <= 1'b1;
      end
   end

   fifo_generator_0 U_sniff_fifo (
     .rst            (reset_i),

     // Write port:
     .wr_clk         (fe_clk),
     .wr_en          (sniff_fifo_wr_en),
     .din            (sniff_fifo_din),
     .full           (sniff_fifo_full),
     .prog_full      (sniff_fifo_full_threshold_xilinx),

     // Read port:
     .rd_clk         (cwusb_clk),
     .rd_en          (sniff_fifo_rd_en),
     .dout           (sniff_fifo_dout),
     .underflow      (sniff_fifo_underflow),
     .empty          (sniff_fifo_empty),
     .prog_empty     (sniff_fifo_empty_threshold_xilinx)
   );

   // these definitions are more useful:
   assign sniff_fifo_empty_threshold = sniff_fifo_empty_threshold_xilinx & !sniff_fifo_empty;
   assign capture_done = ~(reg_arm || capturing);

   assign O_fifo_full = sniff_fifo_full;
   assign O_fifo_overflow_blocked = sniff_fifo_overflow_blocked;
   assign fifo_status[`FIFO_STAT_EMPTY] = sniff_fifo_empty;
   assign fifo_status[`FIFO_STAT_UNDERFLOW] = sniff_fifo_underflow_sticky;
   assign fifo_status[`FIFO_STAT_EMPTY_THRESHOLD] = sniff_fifo_empty_threshold;
   assign fifo_status[`FIFO_STAT_FULL] = sniff_fifo_full_usbclk;
   assign fifo_status[`FIFO_STAT_OVERFLOW_BLOCKED] = sniff_fifo_overflow_blocked_usbclk;
   assign fifo_status[`FIFO_STAT_CAPTURE_DONE] = capture_done;


   `ifdef ILA_REG
       wire [63:0] ila_probe;
       assign ila_probe[5:0] = reg_address;
       assign ila_probe[21:6] = reg_bytecnt;
       assign ila_probe[29:22] = read_data;
       assign ila_probe[37:30] = write_data;
       assign ila_probe[38] = reg_read;
       assign ila_probe[39] = reg_write;
       assign ila_probe[40] = reg_addrvalid;
       assign ila_probe[41] = sniff_fifo_rd_en;
       assign ila_probe[42] = sniff_fifo_empty;
       assign ila_probe[43] = sniff_fifo_underflow_sticky;
       assign ila_probe[51:44] = sniff_fifo_dout[15:8]; // TODO: upsize
       assign ila_probe[59:52] = reg_read_data;
       assign ila_probe[63:60] = 0;

       ila_2 U_reg_ila (cwusb_clk, ila_probe);

   `endif

   `ifdef ILA_FIFO
       ila_3 U_fe_fifo_wr_ila (
          .clk          (fe_clk),
          .probe0       (sniff_fifo_wr_en),
          .probe1       (sniff_fifo_full),
          .probe2       (sniff_fifo_overflow_blocked),
          .probe3       (1'b0),
          .probe4       (sniff_fifo_din)
       );
   `endif

   `ifdef ILA_FIFO
       ila_3 U_fe_fifo_rd_ila (
          .clk          (cwusb_clk),
          .probe0       (sniff_fifo_rd_en),
          .probe1       (sniff_fifo_empty),
          .probe2       (sniff_fifo_underflow_sticky),
          .probe3       (sniff_fifo_overflow_blocked_usbclk),
          .probe4       (sniff_fifo_dout)
       );


   `endif

   `ifndef __ICARUS__
      USR_ACCESSE2 U_buildtime (
         .CFGCLK(),
         .DATA(buildtime),
         .DATAVALID()
      );
   `else
      assign buildtime = 0;
   `endif



endmodule

`default_nettype wire
