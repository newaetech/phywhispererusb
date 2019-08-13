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
   parameter pTRIGGER_DELAY_WIDTH = 20,
   parameter pTRIGGER_WIDTH_WIDTH = 16
)(
   input  wire         reset_i,

// Interface to reg_main_cwlite:
   input  wire         cwusb_clk,
   input  wire [5:0]   reg_address,  // Address of register
   input  wire [15:0]  reg_bytecnt,  // Current byte count
   output reg  [7:0]   read_data,    //
   input  wire [7:0]   write_data,   //
   input  wire         reg_read,     // Read flag. One clock cycle AFTER this flag is high
                                     // valid data must be present on the write_data bus
   input  wire         reg_write,    // Write flag. When high on rising edge valid data is
                                     // present on read_data
   input  wire         reg_addrvalid,// Address valid flag

// Interface to front end capture:
   input  wire         fe_clk,
   output wire         O_timestamps_disable,
   output wire         O_arm,
   output wire [15:0]  O_capture_len,
   output wire         O_fifo_full,
   input  wire [pTIMESTAMP_FULL_WIDTH-1:0]   I_fe_capture_time,
   input  wire [7:0]   I_fe_capture_data,
   input  wire [4:0]   I_fe_capture_stat,
   input  wire [1:0]   I_fe_capture_cmd,
   input  wire         I_fe_capture_data_wr,

   input  wire [7:0]   I_fe_sniff_data,
   input  wire         I_fe_sniff_wr,
   input  wire [3:0]   I_fe_sniff_count,

// Interface to pattern matcher:
   output wire [8*pPATTERN_BYTES-1:0] O_pattern,
   output wire [8*pPATTERN_BYTES-1:0] O_pattern_mask,
   output wire [1:0] O_pattern_action,
   output wire [7:0] O_pattern_bytes,
   input  wire         I_match,

// Interface to trigger generator:
   output wire [pTRIGGER_DELAY_WIDTH-1:0] O_trigger_delay,
   output wire [pTRIGGER_WIDTH_WIDTH-1:0] O_trigger_width,

// To top-level:
   output wire [1:0] O_usb_speed

);


   reg [8*`REG_TEST_LEN-1:0] reg_a;
   reg [8*`REG_FE_LEN-1:0] reg_fe;
   reg [8*`REG_FE_LEN-1:0] reg_fe_usb_r1; // TODO: unnecessary?
   reg [8*`REG_FE_LEN-1:0] reg_fe_usb_r2;
   reg [8*`REG_FE_SNIFF_LEN-1:0] reg_fe_sniff;
   reg [8*`REG_FE_WR_CNT_LEN-1:0] reg_fe_write_counter;
   reg [8*`REG_USB_RD_CNT_LEN-1:0] reg_usb_read_counter;
   reg reg_arm;
   reg reg_arm_r;
   reg reg_timestamps_disable;
   reg [8*pPATTERN_BYTES-1:0] reg_pattern;
   reg [8*pPATTERN_BYTES-1:0] reg_pattern_mask;
   reg [1:0] reg_pattern_action;
   reg [7:0] reg_pattern_bytes;
   reg [15:0] reg_capture_len;
   reg [pTRIGGER_DELAY_WIDTH-1:0] reg_trigger_delay;
   reg [pTRIGGER_WIDTH_WIDTH-1:0] reg_trigger_width;
   reg [1:0] reg_usb_speed;

   // TODO: remove these counters
   reg usb_read_counter_clear;
   reg fe_write_counter_clear_trig;
   reg fe_write_counter_clear_r1;
   reg fe_write_counter_clear_r2;
   wire fe_write_counter_clear;

   wire sniff_fifo_full;
   wire sniff_fifo_empty;
   reg  sniff_fifo_overflow_blocked;
   wire sniff_fifo_underflow;
   reg  sniff_fifo_underflow_sticky;
   reg  sniff_fifo_wr_en;
   wire sniff_fifo_rd_en;
   reg  [17:0] sniff_fifo_din;
   wire [17:0] sniff_fifo_dout;
   wire sniff_fifo_empty_threshold_xilinx;
   wire sniff_fifo_empty_threshold;
   wire sniff_fifo_full_threshold_xilinx;
   wire sniff_fifo_full_threshold;

   reg  [7:0] reg_read_data;
   wire [7:0] sniff_fifo_read_data;
   reg  flushing;
   wire [5:0] fifo_status;

   assign O_arm = reg_arm_r & ~flushing;
   assign O_timestamps_disable = reg_timestamps_disable;
   assign O_pattern = reg_pattern;
   assign O_pattern_mask = reg_pattern_mask;
   assign O_pattern_action = reg_pattern_action;
   assign O_pattern_bytes = reg_pattern_bytes;
   assign O_capture_len = reg_capture_len;
   assign O_trigger_delay = reg_trigger_delay;
   assign O_trigger_width = reg_trigger_width;
   assign O_usb_speed = reg_usb_speed;

   // read logic:
   always @(posedge cwusb_clk) begin
      reg_fe_usb_r1 <= reg_fe;
      reg_fe_usb_r2 <= reg_fe_usb_r1;
      if (reg_addrvalid && reg_read) begin
         // TODO: protect against overflow on reading registers > 1 byte?
         // TODO: make all registers readable? or only those that are strictly necessary?
         case (reg_address)
            `REG_TEST: reg_read_data <= reg_a[reg_bytecnt*8 +: 8];
            `REG_FE: reg_read_data <= reg_fe_usb_r2[reg_bytecnt*8 +: 8];
            `REG_FE_SNIFF: reg_read_data <= reg_fe_sniff[reg_bytecnt*8 +: 8];
            `REG_FE_WR_CNT: reg_read_data <= reg_fe_write_counter[reg_bytecnt*8 +: 8];
            `REG_USB_RD_CNT: reg_read_data <= reg_usb_read_counter[reg_bytecnt*8 +: 8];
            `REG_PATTERN: reg_read_data <= reg_pattern[reg_bytecnt*8 +: 8];
            `REG_PATTERN_MASK: reg_read_data <= reg_pattern_mask[reg_bytecnt*8 +: 8];
            `REG_PATTERN_ACTION: reg_read_data <= reg_pattern_action[reg_bytecnt*8 +: 8];
            `REG_PATTERN_BYTES: reg_read_data <= reg_pattern_bytes;
            `REG_SNIFF_FIFO_STAT: reg_read_data <= {2'b00, fifo_status};
            `REG_USB_SPEED: reg_read_data <= {6'b0, reg_usb_speed};
         endcase
      end
      else
         reg_read_data <= 8'b0;

      if (usb_read_counter_clear)
         reg_usb_read_counter <= 0;
      else if (reg_addrvalid && reg_read && reg_usb_read_counter < {(`REG_USB_RD_CNT_LEN*4){1'b1}})
         reg_usb_read_counter <= reg_usb_read_counter + 1;

   end

   // MUX read output between registers and FIFO output:
   always @(*) begin
      if (reg_address == `REG_SNIFF_FIFO_RD)
         case (reg_bytecnt)
            0: read_data = sniff_fifo_dout[7:0];
            1: read_data = sniff_fifo_dout[15:8];
            2: read_data = {6'b0, sniff_fifo_dout[17:16]}; // TODO: add FIFO flags
            default: read_data = 0;
         endcase
      else
         read_data = reg_read_data;
   end


   // write logic (USB clock domain):
   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         reg_a <= 0;
         usb_read_counter_clear <= 1'b0; 
         fe_write_counter_clear_trig <= 1'b0; 
         reg_arm <= 1'b0;
         reg_timestamps_disable <= 1'b0;
         reg_pattern <= 0;
         reg_pattern_mask <= 64'h0;
         reg_pattern_action <= 0;
         reg_pattern_bytes <= 8'd0;
         reg_capture_len <= 0;
         reg_trigger_delay <= 0;
         reg_trigger_width <= 0;
         reg_usb_speed <= 0;
      end
      else begin
         if (reg_addrvalid && reg_write) begin
            // TODO: protect against overflow on writing registers > 1 byte?
            case (reg_address)
               `REG_TEST: reg_a[reg_bytecnt*8 +: 8] <= write_data;
               `USB_RD_CNT_CLR: usb_read_counter_clear <= 1'b1; 
               `FE_WR_CNT_CLR: fe_write_counter_clear_trig <= 1'b1; 
               `REG_TIMESTAMPS_DISABLE: reg_timestamps_disable <= write_data[0];
               `REG_PATTERN: reg_pattern[reg_bytecnt*8 +: 8] <= write_data;
               `REG_PATTERN_MASK: reg_pattern_mask[reg_bytecnt*8 +: 8] <= write_data;
               `REG_PATTERN_ACTION: reg_pattern_action[reg_bytecnt*8 +: 8] <= write_data;
               `REG_PATTERN_BYTES: reg_pattern_bytes <= write_data;
               `REG_CAPTURE_LEN: reg_capture_len[reg_bytecnt*8 +: 8] <= write_data;
               `REG_TRIGGER_DELAY: reg_trigger_delay[reg_bytecnt*8 +: 8] <= write_data;
               `REG_TRIGGER_WIDTH: reg_trigger_width[reg_bytecnt*8 +: 8] <= write_data;
               `REG_USB_SPEED: reg_usb_speed <= write_data;
            endcase
         end
         else begin
            usb_read_counter_clear <= 1'b0; 
            fe_write_counter_clear_trig <= 1'b0; 
         end
         if (reg_addrvalid && reg_write && (reg_address == `REG_ARM))
            reg_arm <= write_data[0];
         else if (I_match) // TODO: CDC
            reg_arm <= 1'b0;
      end
   end

   // extend fe_write_counter_clear_trig because it gets used in a different clock domain: (TODO: remove)
   always @(posedge cwusb_clk) begin
      fe_write_counter_clear_r1 <= fe_write_counter_clear_trig;
      fe_write_counter_clear_r2 <= fe_write_counter_clear_r1;
   end
   assign fe_write_counter_clear = fe_write_counter_clear_r2 | fe_write_counter_clear_r1 | fe_write_counter_clear_trig;

   // write logic for sniff register (FE clock domain): (TODO: remove when no longer needed)
   always @(posedge fe_clk) begin
      if (reset_i) begin
         reg_fe <= 0;
         reg_fe_sniff <= 0;
         reg_fe_write_counter <= 0;
      end
      else begin
         if (I_fe_capture_data_wr) begin
            reg_fe <= I_fe_capture_data;
         end
         if (I_fe_sniff_wr) begin
            reg_fe_sniff[I_fe_sniff_count*8 +: 8] <= I_fe_sniff_data;
         end

         if (fe_write_counter_clear) // TODO: doesn't always work since it gets set in a different clock domain!
            reg_fe_write_counter <= 0;
         else if (I_fe_capture_data_wr && reg_fe_write_counter < {(`REG_FE_WR_CNT_LEN*4){1'b1}})
            reg_fe_write_counter <= reg_fe_write_counter + 1;

      end
   end

   // FIFO write logic.
   // TODO: could maybe get away with combinatorial logic here? but don't bother unless tight on LUTs.
   always @(posedge fe_clk) begin
      if (reset_i) begin
         sniff_fifo_wr_en <= 1'b0;
         sniff_fifo_din <= 0;
         sniff_fifo_overflow_blocked <= 1'b0;
      end
      else begin
         // don't overflow the FIFO:
         if (I_fe_capture_data_wr & !sniff_fifo_full) begin
            sniff_fifo_wr_en <= 1'b1;
            sniff_fifo_din[`FE_FIFO_CMD_START +: `FE_FIFO_CMD_BIT_LEN] <= I_fe_capture_cmd;
            case (I_fe_capture_cmd)
               `FE_FIFO_CMD_DATA: begin
                  sniff_fifo_din[`FE_FIFO_TIME_START +: `FE_FIFO_SHORTTIME_LEN] <= I_fe_capture_time[`FE_FIFO_SHORTTIME_LEN-1:0];
                  sniff_fifo_din[`FE_FIFO_DATA_START +: `FE_FIFO_DATA_LEN] <= I_fe_capture_data;
                  sniff_fifo_din[`FE_FIFO_STATUS_BITS_START +: `FE_FIFO_STATUS_BITS_LEN] <= I_fe_capture_stat;
               end
               `FE_FIFO_CMD_STAT: begin
                  sniff_fifo_din[`FE_FIFO_TIME_START +: `FE_FIFO_SHORTTIME_LEN] <= I_fe_capture_time[`FE_FIFO_SHORTTIME_LEN-1:0];
                  sniff_fifo_din[`FE_FIFO_DATA_START +: `FE_FIFO_DATA_LEN] <= 8'd0;
                  sniff_fifo_din[`FE_FIFO_STATUS_BITS_START +: `FE_FIFO_STATUS_BITS_LEN] <= I_fe_capture_stat;
               end
               `FE_FIFO_CMD_TIME: begin
                  sniff_fifo_din[`FE_FIFO_TIME_START +: `FE_FIFO_FULLTIME_LEN] <= I_fe_capture_time;
               end
            endcase
         end
         else
            sniff_fifo_wr_en <= 1'b0;

         // if a write WOULD have overflowed the FIFO, log it:
         if (I_fe_capture_data_wr & sniff_fifo_full)
            sniff_fifo_overflow_blocked <= 1'b1;
         else if (reg_arm) // TODO: CDC
            sniff_fifo_overflow_blocked <= 1'b0;

      end
   end

   // FIFO read logic:
   // perform a FIFO read on first read access to FIFO register, or when flushing:
   assign sniff_fifo_rd_en = ( reg_addrvalid && reg_read &&   // TODO: guard against underflow
                              (reg_address == `REG_SNIFF_FIFO_RD) &&
                              (reg_bytecnt == 0) ) || (flushing & ~sniff_fifo_empty);

   // Xilinx FIFO underflow flag isn't sticky, so create our own:
   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         sniff_fifo_underflow_sticky <= 1'b0;
      end
      else begin
         if (sniff_fifo_underflow)
            sniff_fifo_underflow_sticky <= 1'b1;
         else if (reg_arm)
            sniff_fifo_underflow_sticky <= 1'b0;
      end
   end

   // TODO: add a flushing mechanism; flush when:
   // - arming (done)
   // - other scenarios??
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
   assign sniff_fifo_full_threshold = sniff_fifo_full_threshold_xilinx & !sniff_fifo_full;

   assign O_fifo_full = sniff_fifo_full;
   assign fifo_status[`FIFO_STAT_EMPTY] = sniff_fifo_empty;
   assign fifo_status[`FIFO_STAT_UNDERFLOW] = sniff_fifo_underflow_sticky;
   assign fifo_status[`FIFO_STAT_EMPTY_THRESHOLD] = sniff_fifo_empty_threshold;
   // TODO: CDC on write side flags:
   assign fifo_status[`FIFO_STAT_FULL] = sniff_fifo_full;
   assign fifo_status[`FIFO_STAT_OVERFLOW_BLOCKED] = sniff_fifo_overflow_blocked;
   assign fifo_status[`FIFO_STAT_FULL_THRESHOLD] = sniff_fifo_full_threshold;


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
          .probe3       (sniff_fifo_din)
       );
   `endif

   `ifdef ILA_FIFO
       ila_3 U_fe_fifo_rd_ila (
          .clk          (cwusb_clk),
          .probe0       (sniff_fifo_rd_en),
          .probe1       (sniff_fifo_empty),
          .probe2       (sniff_fifo_underflow_sticky),
          .probe3       (sniff_fifo_dout)
       );


   `endif


endmodule

`default_nettype wire
