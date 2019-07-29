`default_nettype none
`timescale 1ns / 1ps
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


module reg_pw #(
   parameter pTIMESTAMP_FULL_WIDTH = 16,
   parameter pTIMESTAMP_SHORT_WIDTH = 3
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
   output wire         O_timestamps_enable,
   output wire         O_capture_enable,
   input  wire [pTIMESTAMP_FULL_WIDTH-1:0]   I_fe_capture_time,
   input  wire [7:0]   I_fe_capture_data,
   input  wire [1:0]   I_fe_capture_cmd,
   input  wire         I_fe_capture_data_wr,

   input  wire [7:0]   I_fe_sniff_data,
   input  wire         I_fe_sniff_wr,
   input  wire [3:0]   I_fe_sniff_count,

// Interface to trigger:
   output wire         O_trigger_match

);

   // TODO: move defines into other file (which could be more easily parsed by Python)
   `define REG_TEST                     6'h00
   `define REG_SNIFF_FIFO_RD            6'h01
   `define REG_TIMESTAMPS_ENABLE        6'h02
   `define REG_CAPTURE_ENABLE           6'h03
   `define REG_FE                       6'h04
   `define REG_FE_SNIFF                 6'h05
   `define REG_FE_WR_CNT                6'h06
   `define REG_USB_RD_CNT               6'h07
   `define USB_RD_CNT_CLR               6'h08
   `define FE_WR_CNT_CLR                6'h09
   `define REG_TRIG_MATCH               6'h0a

   `define REG_TEST_LEN                 4
   `define REG_TRIG_MATCH_LEN           1
   `define REG_FE_LEN                   1
   `define REG_FE_SNIFF_LEN             8
   `define REG_FE_WR_CNT_LEN            4
   `define REG_USB_RD_CNT_LEN           4
   `define REG_SNIFF_FIFO_RD_LEN        1

   // FIFO bitfields:
   `define FE_FIFO_CMD_DATA 2'b00
   `define FE_FIFO_CMD_STAT 2'b01
   `define FE_FIFO_CMD_TIME 2'b10

   `define FE_FIFO_CMD_START 16
   `define FE_FIFO_CMD_BIT_LEN 2

   `define FE_FIFO_TIME_START 0
   `define FE_FIFO_SHORTTIME_LEN 3
   `define FE_FIFO_FULLTIME_LEN 16

   `define FE_FIFO_RXACTIVE_BIT 3
   `define FE_FIFO_RXERROR_BIT 4
   `define FE_FIFO_SESSVLD_BIT 5
   `define FE_FIFO_SESSEND_BIT 6
   `define FE_FIFO_VBUSVLD_BIT 7

   `define FE_FIFO_DATA_START 8
   `define FE_FIFO_DATA_LEN 8


   reg [8*`REG_TEST_LEN-1:0] reg_a;
   reg [8*`REG_FE_LEN-1:0] reg_fe;
   reg [8*`REG_FE_LEN-1:0] reg_fe_usb_r1; // TODO: unnecessary?
   reg [8*`REG_FE_LEN-1:0] reg_fe_usb_r2;
   reg [8*`REG_FE_SNIFF_LEN-1:0] reg_fe_sniff;
   reg [8*`REG_FE_WR_CNT_LEN-1:0] reg_fe_write_counter;
   reg [8*`REG_USB_RD_CNT_LEN-1:0] reg_usb_read_counter;
   reg reg_trigger;
   reg reg_capture_enable;
   reg reg_timestamps_enable;

   reg usb_read_counter_clear;
   reg fe_write_counter_clear_trig;
   reg fe_write_counter_clear_r1;
   reg fe_write_counter_clear_r2;
   wire fe_write_counter_clear;

   wire sniff_fifo_full;
   wire sniff_fifo_overflow;
   wire sniff_fifo_empty;
   wire sniff_fifo_underflow;
   reg  sniff_fifo_wr_en;
   wire sniff_fifo_rd_en;
   reg  [17:0] sniff_fifo_din;
   wire [17:0] sniff_fifo_dout;
   
   reg  [7:0] reg_read_data;
   wire [7:0] sniff_fifo_read_data;

   assign O_trigger_match = reg_trigger;
   assign O_capture_enable = reg_capture_enable;
   assign O_timestamps_enable = reg_timestamps_enable;

   // read logic:
   always @(posedge cwusb_clk) begin
      reg_fe_usb_r1 <= reg_fe;
      reg_fe_usb_r2 <= reg_fe_usb_r1;
      if (reg_addrvalid && reg_read) begin
         // TODO: protect against overflow on reading registers > 1 byte?
         case (reg_address)
            `REG_TEST: reg_read_data <= reg_a[reg_bytecnt*8 +: 8];
            `REG_FE: reg_read_data <= reg_fe_usb_r2[reg_bytecnt*8 +: 8];
            `REG_FE_SNIFF: reg_read_data <= reg_fe_sniff[reg_bytecnt*8 +: 8];
            `REG_FE_WR_CNT: reg_read_data <= reg_fe_write_counter[reg_bytecnt*8 +: 8];
            `REG_USB_RD_CNT: reg_read_data <= reg_usb_read_counter[reg_bytecnt*8 +: 8];
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
         //read_data = sniff_fifo_dout[reg_bytecnt*8 +: 8];
      else
         read_data = reg_read_data;
   end


   // write logic (USB clock domain):
   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         reg_a <= 0;
         usb_read_counter_clear <= 1'b0; 
         fe_write_counter_clear_trig <= 1'b0; 
         reg_trigger <= 1'b0;
         reg_capture_enable <= 1'b0;
         reg_timestamps_enable <= 1'b0;
      end
      else begin
         if (reg_addrvalid && reg_write) begin
            // TODO: protect against overflow on writing registers > 1 byte?
            case (reg_address)
               `REG_TEST: reg_a[reg_bytecnt*8 +: 8] <= write_data;
               `USB_RD_CNT_CLR: usb_read_counter_clear <= 1'b1; 
               `FE_WR_CNT_CLR: fe_write_counter_clear_trig <= 1'b1; 
               `REG_TRIG_MATCH: reg_trigger <= write_data[0];
               `REG_CAPTURE_ENABLE: reg_capture_enable <= write_data[0];
               `REG_TIMESTAMPS_ENABLE: reg_timestamps_enable <= write_data[0];
            endcase
         end
         else begin
            usb_read_counter_clear <= 1'b0; 
            fe_write_counter_clear_trig <= 1'b0; 
         end
      end
   end

   // extend fe_write_counter_clear_trig because it gets used in a different clock domain:
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
            reg_fe_sniff[I_fe_sniff_count*8 +: 8] <= I_fe_capture_data;
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
      end
      // TODO: guard against overflow
      else if (I_fe_capture_data_wr && !sniff_fifo_full) begin
      //else if (I_fe_capture_data_wr) begin
         sniff_fifo_wr_en <= 1'b1;
         sniff_fifo_din[`FE_FIFO_CMD_START +: `FE_FIFO_CMD_BIT_LEN] <= I_fe_capture_cmd;
         case (I_fe_capture_cmd)
            `FE_FIFO_CMD_DATA: begin
               sniff_fifo_din[`FE_FIFO_TIME_START +: `FE_FIFO_SHORTTIME_LEN] <= I_fe_capture_time[`FE_FIFO_SHORTTIME_LEN-1:0];
               sniff_fifo_din[`FE_FIFO_DATA_START +: `FE_FIFO_DATA_LEN] <= I_fe_capture_data;
            end
            `FE_FIFO_CMD_STAT: begin
               sniff_fifo_din <= 8'haa; // TODO
            end
            `FE_FIFO_CMD_TIME: begin
               sniff_fifo_din[`FE_FIFO_TIME_START +: `FE_FIFO_FULLTIME_LEN] <= I_fe_capture_time;
            end
         endcase
      end
      else
         sniff_fifo_wr_en <= 1'b0;
   end

   // perform a FIFO read on first read access to FIFO register:
   assign sniff_fifo_rd_en = ( reg_addrvalid && reg_read &&   // TODO: guard against underflow
                              (reg_address == `REG_SNIFF_FIFO_RD) &&
                              (reg_bytecnt == 0) );

   fifo_generator_0 U_sniff_fifo (
     .rst            (reset_i),

     // Write port:
     .wr_clk         (fe_clk),
     .wr_en          (sniff_fifo_wr_en),
     .din            (sniff_fifo_din),
     .full           (sniff_fifo_full),
     .overflow       (sniff_fifo_overflow),

     // Read port:
     .rd_clk         (cwusb_clk),
     .rd_en          (sniff_fifo_rd_en),
     .dout           (sniff_fifo_dout),
     .empty          (sniff_fifo_empty),
     .underflow      (sniff_fifo_underflow)
   );

   `ifdef ILA
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
       assign ila_probe[43] = sniff_fifo_underflow;
       assign ila_probe[51:44] = sniff_fifo_dout[15:8]; // TODO: upsize
       assign ila_probe[59:52] = reg_read_data;
       assign ila_probe[63:60] = 0;

       ila_2 U_reg_ila (cwusb_clk, ila_probe);

   `endif

   `ifdef ILA
       ila_3 U_fe_fifo_wr_ila (
          .clk          (fe_clk),
          .probe0       (sniff_fifo_wr_en),
          .probe1       (sniff_fifo_full),
          .probe2       (sniff_fifo_overflow),
          .probe3       (sniff_fifo_din)
       );
   `endif

   `ifdef ILA
       ila_3 U_fe_fifo_rd_ila (
          .clk          (cwusb_clk),
          .probe0       (sniff_fifo_rd_en),
          .probe1       (sniff_fifo_empty),
          .probe2       (sniff_fifo_underflow),
          .probe3       (sniff_fifo_dout)
       );


   `endif


endmodule

`default_nettype wire
