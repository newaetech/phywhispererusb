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
// Description: Register block for PW-USB frontend.
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
`include "defines_usb.v"

module reg_usb #(
   parameter pTIMESTAMP_FULL_WIDTH = 16,
   parameter pTIMESTAMP_SHORT_WIDTH = 3,
   parameter pPATTERN_BYTES = 8,
   parameter pCAPTURE_DELAY_WIDTH = 18,
   parameter pBYTECNT_SIZE = 7,
   parameter pUSB_AUTO_COUNTER_WIDTH = 24

)(
   input  wire         reset_i,

// Interface to usb_reg_main:
   input  wire                                  cwusb_clk,
   input  wire [7:0]                            reg_address,  // Address of register
   input  wire [pBYTECNT_SIZE-1:0]              reg_bytecnt,  // Current byte count
   output reg  [7:0]                            read_data,    //
   input  wire [7:0]                            write_data,   //
   input  wire                                  reg_read,     // Read flag. One clock cycle AFTER this flag is high
                                                              // valid data must be present on the read_data bus
   input  wire                                  reg_write,    // Write flag. When high on rising edge valid data is
                                                              // present on write_data
   input  wire                                  reg_addrvalid,// Address valid flag

// Interface to front end capture:
   input  wire                                  fe_clk,
   output wire                                  O_reg_arm_feclk,
   input  wire [4:0]                            I_fe_capture_stat,

// Interface to main register block:
   input  wire                                  I_reg_arm,

// Interface to pattern matcher:
   output wire         [8*pPATTERN_BYTES-1:0]   O_pattern,
   output wire         [8*pPATTERN_BYTES-1:0]   O_pattern_mask,
   output wire         [7:0]                    O_pattern_bytes,

// Interface to trigger generator:
   output wire [pCAPTURE_DELAY_WIDTH-1:0]       O_capture_delay,

// Interface to USB autodetect:
   output reg                                   O_usb_auto_restart,
   output wire [pUSB_AUTO_COUNTER_WIDTH-1:0]    O_usb_auto_wait1,
   output wire [pUSB_AUTO_COUNTER_WIDTH-1:0]    O_usb_auto_wait2,
   input  wire [1:0]                            I_usb_auto_speed,

// To top-level:
   output wire [1:0]                            O_usb_speed,
   output wire [1:0]                            O_usb_xcvrsel_auto,
   output wire                                  O_usb_termsel_auto,

   output wire                                  selected

);


   reg reg_arm_feclk;
   reg reg_arm_feclk_r;
   reg [8*pPATTERN_BYTES-1:0] reg_pattern;
   reg [8*pPATTERN_BYTES-1:0] reg_pattern_mask;
   reg [7:0] reg_pattern_bytes;
   reg [pCAPTURE_DELAY_WIDTH-1:0] reg_capture_delay;
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

   reg  [7:0] reg_read_data;


   assign O_pattern = reg_pattern;
   assign O_pattern_mask = reg_pattern_mask;
   assign O_pattern_bytes = reg_pattern_bytes;
   assign O_capture_delay = reg_capture_delay;
   assign O_usb_speed = (reg_usb_speed == `USB_SPEED_AUTO)? usb_speed_auto : reg_usb_speed;
   assign O_usb_xcvrsel_auto = reg_usb_auto_defaults[1:0];
   assign O_usb_termsel_auto = reg_usb_auto_defaults[2];
   assign O_usb_auto_wait1 = reg_usb_auto_wait1;
   assign O_usb_auto_wait2 = reg_usb_auto_wait2;
   assign O_reg_arm_feclk = reg_arm_feclk;

   assign selected = reg_addrvalid & reg_address[7:6] == `USB_REG_SELECT;
   wire [5:0] address = reg_address[5:0];

   // read logic:
   always @(*) begin
      if (selected && reg_read) begin
         case (address)
            `REG_PATTERN: reg_read_data = reg_pattern[reg_bytecnt*8 +: 8];
            `REG_PATTERN_MASK: reg_read_data = reg_pattern_mask[reg_bytecnt*8 +: 8];
            `REG_PATTERN_BYTES: reg_read_data = reg_pattern_bytes;
            `REG_USB_SPEED: reg_read_data = {6'b0, O_usb_speed};
            `REG_STAT_MATCH: reg_read_data = reg_stat_matched[reg_bytecnt*8 +: 8];
            `REG_USB_AUTO_DEFAULTS: reg_read_data = reg_usb_auto_defaults;
            `REG_CAPTURE_DELAY: reg_read_data = reg_capture_delay[reg_bytecnt*8 +: 8];
            `REG_USB_AUTO_WAIT1: reg_read_data = reg_usb_auto_wait1[reg_bytecnt*8 +: 8];
            `REG_USB_AUTO_WAIT2: reg_read_data = reg_usb_auto_wait2[reg_bytecnt*8 +: 8];
            `REG_STAT_PATTERN: reg_read_data = reg_stat_pattern[reg_bytecnt*5 +: 5];
            default: reg_read_data = 8'h0;
         endcase
      end
      else
         reg_read_data = 8'h0;
   end


   // Register output read data to ease timing. If you need data one clock
   // cycle earlier, simply remove this stage.
   always @(posedge cwusb_clk)
      read_data <= reg_read_data;


   // write logic (USB clock domain):
   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         reg_pattern <= 0;
         reg_pattern_mask <= 64'h0;
         reg_pattern_bytes <= 8'd0;
         reg_capture_delay <= 0;
         reg_usb_speed <= `USB_SPEED_AUTO;
         O_usb_auto_restart <= 1'b0;
         reg_usb_auto_defaults <= {1'b1, 2'b01}; // for USB_SPEED_FS
         reg_usb_auto_wait1 <= 60000; // 1ms
         reg_usb_auto_wait2 <= 3600000; // 60ms
         reg_stat_pattern <= 10'b11111_00000;
         stat_match_update_pulse <= 1'b0;

      end
      else begin
         if (selected && reg_write) begin
            case (address)
               `REG_PATTERN: reg_pattern[reg_bytecnt*8 +: 8] <= write_data;
               `REG_PATTERN_MASK: reg_pattern_mask[reg_bytecnt*8 +: 8] <= write_data;
               `REG_PATTERN_BYTES: reg_pattern_bytes <= write_data;
               `REG_USB_SPEED: reg_usb_speed <= write_data;
               `REG_USB_AUTO_DEFAULTS: reg_usb_auto_defaults <= write_data[2:0];
               `REG_CAPTURE_DELAY: reg_capture_delay[reg_bytecnt*8 +: 8] <= write_data;
               `REG_USB_AUTO_WAIT1: reg_usb_auto_wait1[reg_bytecnt*8 +: 8] <= write_data;
               `REG_USB_AUTO_WAIT2: reg_usb_auto_wait2[reg_bytecnt*8 +: 8] <= write_data;
            endcase
         end

         // USB auto restart register is special:
         if (selected && reg_write && (address == `REG_USB_SPEED) && (write_data == `USB_SPEED_AUTO))
            O_usb_auto_restart <= 1'b1;
         else
            O_usb_auto_restart <= 1'b0;

         // STAT match register is special:
         if (selected && reg_write && (address == `REG_STAT_PATTERN)) begin
            reg_stat_pattern[reg_bytecnt*5 +: 5] <= write_data[4:0];
            if (reg_bytecnt == 0)
               stat_match_update_pulse <= 1'b1;
         end
         else
            stat_match_update_pulse <= 1'b0;

      end
   end

   (* ASYNC_REG = "TRUE" *) reg  [1:0] reg_arm_pipe;

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
         reg_arm_feclk <= 0;
         reg_arm_pipe <= 0;
      end
      else begin
         // CDC:
         stat_pattern <= reg_stat_pattern[4:0];
         stat_mask <= reg_stat_pattern[9:5];
         {reg_arm_feclk_r, reg_arm_feclk, reg_arm_pipe} <= {reg_arm_feclk, reg_arm_pipe, I_reg_arm};

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


   always @(posedge cwusb_clk) begin
      if (reset_i) begin
         usb_speed_auto <= 0;
      end
      else begin
         usb_speed_auto <= I_usb_auto_speed;
      end
   end

   `ifdef ILA_REG
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
	.probe9         ({6'b0, reg_usb_speed})         // input wire [7:0]  probe9
       );

   `endif


endmodule

`default_nettype wire
