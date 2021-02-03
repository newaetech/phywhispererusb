`default_nettype none
`timescale 1ns / 1ps
`include "defines_pw.v"
`include "defines_usb.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: NewAE
// Engineer: Colin O'Flynn, Jean-Pierre Thibault
// 
// Create Date: 05/20/2019 04:26:22 PM
// Design Name: 
// Module Name: phywhisperer_top
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


module phywhisperer_top(
    /* USB CHIP CONNECTIONS */
    input wire          usb_clk,
    inout wire [7:0]    USB_Data,
    input wire [7:0]    USB_Addr,
    input wire          USB_nRD,
    input wire          USB_nWE,
    input wire          USB_nCS,
    input wire          USB_SPARE0,
    input wire          USB_SPARE1,

    `ifdef __ICARUS__
    input wire  I_trigger_clk, // for simulation only
    `endif

    /* FRONT END CONNECTIONS */
    output reg  fe_xcvrsel0,
    output reg  fe_xcvrsel1,
    output reg  fe_termsel,
    input  wire fe_txrdy,
    output wire fe_suspendn,
    output wire fe_txvalid,

    output wire fe_reset,

    output wire fe_chrgvbus,
    input  wire fe_rxactive,
    output wire fe_opmode0,
    output wire fe_opmode1,
    input  wire fe_id_dig,
    output wire fe_idpullup,
    input  wire fe_linestate0,
    input  wire fe_linestate1,
    input  wire fe_hostdisc,
    output wire fe_dischrgvbus,
    input  wire fe_sessend,
    
    input  wire fe_clk,
    input  wire [7:0] fe_data,
    input  wire fe_rxvalid,
    input  wire fe_sessvld,
    output wire fe_dppd,
    output wire fe_dmpd,
    input  wire fe_rxerror,
    input  wire fe_vbusvld,

    /* 20-PIN USER HEADER CONNECTOR */
    inout  wire [7:0] userio_d,
    input  wire userio_clk,

    /* 20-PIN CHIPWHISPERER CONNECTOR */
    output wire cw_clk,
    output wire cw_trig,

    /* MCX CONNECTOR */
    output wire mcx_trig,

    /* LEDs */
    output wire LED_TRIG,
    output wire LED_CAP
    );

   parameter pTIMESTAMP_FULL_WIDTH = 16;
   parameter pTIMESTAMP_SHORT_WIDTH = 3;
   parameter pPATTERN_BYTES = 64;
   parameter pTRIGGER_DELAY_WIDTH = 20;
   parameter pTRIGGER_WIDTH_WIDTH = 17;
   parameter pNUM_TRIGGER_PULSES = 8;
   parameter pNUM_TRIGGER_WIDTH = 4;

   parameter pBYTECNT_SIZE = 7;
   parameter pCAPTURE_DELAY_WIDTH = pTRIGGER_DELAY_WIDTH-2;
   parameter pUSB_AUTO_COUNTER_WIDTH = 24;
   parameter pCAPTURE_LEN_WIDTH = 24;
   parameter pUSERIO_WIDTH = 8;
   
   parameter pALL_TRIGGER_DELAY_WIDTHS = 24*pNUM_TRIGGER_PULSES;
   parameter pALL_TRIGGER_WIDTH_WIDTHS = 24*pNUM_TRIGGER_PULSES;

   wire cmdfifo_isout;
   wire [7:0] cmdfifo_din;
   wire [7:0] cmdfifo_dout;
   wire clk_usb_buf;
   wire clk_fe_buf;
   wire reset_i = USB_SPARE0;
   wire fpga_reset;

   wire [7:0]   reg_address;
   wire [pBYTECNT_SIZE-1:0]  reg_bytecnt;
   wire [7:0]   write_data;
   wire [7:0]   read_data;
   wire [7:0]   read_data_usb;
   wire [7:0]   read_data_main;
   wire [5:0]   fifo_status;
   wire         reg_read;
   wire         reg_write;
   wire         reg_addrvalid;

   wire usb_clk_copy;

   wire [7:0] fe_capture_data;
   wire [4:0] fe_capture_stat;
   wire [1:0] fe_capture_cmd;
   wire [pTIMESTAMP_FULL_WIDTH-1:0] fe_capture_time;
   wire fe_capture_data_wr;

   wire trigger_clk;
   wire psen;
   wire psincdec;
   wire psdone;
   wire trigger_clk_locked;
   wire capture_enable_pulse;
   wire trigger_match;
   wire timestamps_disable;
   wire [pCAPTURE_LEN_WIDTH-1:0] capture_len;
   wire count_writes;
   wire counter_quick_start;
   wire fifo_full;
   wire arm;
   wire reg_arm;
   wire reg_arm_feclk;
   wire capturing;
   wire capture_enable;

   wire [pCAPTURE_DELAY_WIDTH-1:0] capture_delay;
   wire [pALL_TRIGGER_DELAY_WIDTHS-1:0] trigger_delay;
   wire [pALL_TRIGGER_WIDTH_WIDTHS-1:0] trigger_width;

   wire [pPATTERN_BYTES*8-1:0] pattern;
   wire [pPATTERN_BYTES*8-1:0] pattern_mask;
   wire trigger_enable;
   wire [pNUM_TRIGGER_WIDTH-1:0] num_triggers;
   wire [7:0] pattern_bytes;

   wire [1:0] usb_speed;

   wire usb_auto_restart;
   wire [1:0] usb_auto_speed;
   wire [1:0] usb_xcvrsel_auto;
   wire usb_termsel_auto;
   wire [pUSB_AUTO_COUNTER_WIDTH-1:0] usb_auto_wait1;
   wire [pUSB_AUTO_COUNTER_WIDTH-1:0] usb_auto_wait2;
   
   wire [`FE_SELECT_WIDTH-1:0] fe_select;

   wire [17:0] fifo_in_data;
   wire [17:0] fifo_out_data;
   wire fifo_wr;
   wire fifo_read;
   wire fifo_flush;
   wire fifo_overflow_blocked;
   wire fifo_empty;
   wire capture_done;

   wire fe_event;
   wire [1:0] fe_data_cmd;
   wire [pTIMESTAMP_FULL_WIDTH-1:0] fe_time;
   wire [1:0] fe_command;
   wire fe_fifo_wr;

   wire reg_main_selected;
   wire reg_usb_selected;

   wire [15:0] max_short_timestamp;
   wire [15:0] max_timestamp;

   wire [pUSERIO_WIDTH-1:0] userio_pwdriven;
   wire [pUSERIO_WIDTH-1:0] userio_drive_data;

   assign LED_CAP = arm;
   assign LED_TRIG = capturing;

   assign mcx_trig = cw_trig;

   `ifdef __ICARUS__
      assign clk_fe_buf = fe_clk;
      assign clk_usb_buf = usb_clk;
      assign usb_clk_copy = usb_clk;
   `else
      IBUFG U_usb_clk_buf (
           .O(clk_usb_buf),
           .I(usb_clk) );

      IBUFG U_clk_fe_buf (
           .O(clk_fe_buf),
           .I(fe_clk) );

     ODDR USB_CLK_COPY (
        .Q(usb_clk_copy),   // 1-bit DDR output
        .C(clk_usb_buf),   // 1-bit clock input
        .CE(1'b1), // 1-bit clock enable input
        .D1(1'b1), // 1-bit data input (positive edge)
        .D2(1'b0), // 1-bit data input (negative edge)
        .R(1'b0),   // 1-bit reset
        .S(1'b0)    // 1-bit set
     );


   `endif

   assign USB_Data = cmdfifo_isout ? cmdfifo_dout : 8'bZ;
   assign cmdfifo_din = USB_Data;

   usb_reg_main #(
      .pBYTECNT_SIZE    (pBYTECNT_SIZE)
   ) U_usb_reg_main (
      .cwusb_clk        (clk_usb_buf), 
      .cwusb_din        (cmdfifo_din), 
      .cwusb_dout       (cmdfifo_dout), 
      .cwusb_rdn        (USB_nRD), 
      .cwusb_wrn        (USB_nWE),
      .cwusb_cen        (USB_nCS),
      .cwusb_addr       (USB_Addr),
      .cwusb_isout      (cmdfifo_isout), 
      .I_drive_data     (1'b0), // unused
      .reg_address      (reg_address), 
      .reg_bytecnt      (reg_bytecnt), 
      .reg_datao        (write_data), 
      .reg_datai        (read_data),
      .reg_read         (reg_read), 
      .reg_write        (reg_write), 
      .reg_addrvalid    (reg_addrvalid)
   );

   reg_main #(
      .pBYTECNT_SIZE            (pBYTECNT_SIZE),
      .pNUM_TRIGGER_PULSES      (pNUM_TRIGGER_PULSES),
      .pNUM_TRIGGER_WIDTH       (pNUM_TRIGGER_WIDTH),
      .pCAPTURE_LEN_WIDTH       (pCAPTURE_LEN_WIDTH),
      .pUSERIO_WIDTH            (pUSERIO_WIDTH)
   ) U_reg_main (
      .reset_pin        (reset_i), 
      .fpga_reset       (fpga_reset),
      .cwusb_clk        (clk_usb_buf), 
      .reg_address      (reg_address), 
      .reg_bytecnt      (reg_bytecnt), 
      .read_data        (read_data_main), 
      .write_data       (write_data),
      .reg_read         (reg_read), 
      .reg_write        (reg_write), 
      .reg_addrvalid    (reg_addrvalid),

      .fe_select        (fe_select),

      .userio_d         (userio_d),
      .O_userio_pwdriven (userio_pwdriven),
      .O_userio_drive_data (userio_drive_data),

      .I_fifo_data      (fifo_out_data),
      .I_fifo_empty     (fifo_empty),
      .O_fifo_read      (fifo_read),
      .I_fifo_status    (fifo_status),

      .O_data_available (), // unused
      .O_usb_drive_data (), // unused
      .I_fast_fifo_rdn  (1'b1), // unused
      .I_usb_cen        (1'b1), // unused

      .fe_clk           (clk_fe_buf),
      .O_arm            (arm),
      .O_reg_arm        (reg_arm),
      .O_arm_pulse      ( ), // unused
      .I_flushing       (fifo_flush),
      .O_capture_len    (capture_len),
      .O_count_writes   (count_writes),
      .O_counter_quick_start (counter_quick_start),
      .I_capture_enable_pulse (capture_enable_pulse),
      .O_timestamps_disable (timestamps_disable),
      .O_capture_now    ( ), // unused
      .O_board_rev      ( ), // unused
      .O_capture_while_trig ( ), // unused
      .O_max_timestamp  (max_timestamp),

      .I_locked1        (trigger_clk_locked),
      .I_locked2        (1'b0),

      // Trigger:
      .O_trigger_delay  (trigger_delay),
      .O_trigger_width  (trigger_width),
      .O_trigger_enable (trigger_enable),
      .O_num_triggers   (num_triggers),

      // Trigger clock phase shift:
      .O_psincdec               (psincdec),
      .O_psen                   (psen),
      .I_psdone                 (psdone),

      .selected         (reg_main_selected)

   );

   assign read_data = reg_main_selected? read_data_main :
                      reg_usb_selected?  read_data_usb : 0;

   userio #(
      .pWIDTH                   (pUSERIO_WIDTH)
   ) U_userio (
      .usb_clk                  (clk_usb_buf),
      .userio_d                 (userio_d),
      .userio_clk               (userio_clk),
      .I_userio_pwdriven        (userio_pwdriven),
      .I_userio_drive_data      (userio_drive_data)
   );

   reg_usb #(
      .pTIMESTAMP_FULL_WIDTH    (pTIMESTAMP_FULL_WIDTH),
      .pTIMESTAMP_SHORT_WIDTH   (pTIMESTAMP_SHORT_WIDTH),
      .pPATTERN_BYTES           (pPATTERN_BYTES),
      .pCAPTURE_DELAY_WIDTH     (pCAPTURE_DELAY_WIDTH),
      .pBYTECNT_SIZE            (pBYTECNT_SIZE),
      .pUSB_AUTO_COUNTER_WIDTH  (pUSB_AUTO_COUNTER_WIDTH)

   ) U_reg_usb (
      .reset_i                  (fpga_reset), 
      .cwusb_clk                (clk_usb_buf), 
      .reg_address              (reg_address), 
      .reg_bytecnt              (reg_bytecnt), 
      .read_data                (read_data_usb), 
      .write_data               (write_data),
      .reg_read                 (reg_read), 
      .reg_write                (reg_write), 
      .reg_addrvalid            (reg_addrvalid),

      // FE:
      .fe_clk                   (clk_fe_buf),
      .I_fe_capture_stat        (fe_capture_stat),
      .O_reg_arm_feclk          (reg_arm_feclk),

      // Trigger:
      .O_capture_delay          (capture_delay),

      // PM:
      .O_pattern                (pattern),
      .O_pattern_mask           (pattern_mask),
      .O_pattern_bytes          (pattern_bytes),

      .O_usb_speed              (usb_speed),
      .O_usb_xcvrsel_auto       (usb_xcvrsel_auto),
      .O_usb_termsel_auto       (usb_termsel_auto),

      // USB autodetect:
      .O_usb_auto_restart       (usb_auto_restart),
      .O_usb_auto_wait1         (usb_auto_wait1),
      .O_usb_auto_wait2         (usb_auto_wait2),

      .I_usb_auto_speed         (usb_auto_speed),

      .selected                 (reg_usb_selected),

      .I_reg_arm                (1'b0)

   );


   `ifndef NOFIFO // for clean compilation
   fifo U_fifo (
      .reset_i                  (fpga_reset),
      .cwusb_clk                (clk_usb_buf),
      .fe_clk                   (clk_fe_buf),

      .O_fifo_full              (fifo_full),
      .O_fifo_overflow_blocked  (fifo_overflow_blocked),
      .I_data                   (fifo_in_data),
      .I_wr                     (fifo_wr),

      .I_fifo_read              (fifo_read),
      .I_fifo_flush             (fifo_flush),
      .I_clear_read_flags       (reg_arm),
      .I_clear_write_flags      (reg_arm_feclk),

      .O_data                   (fifo_out_data),
      .O_fifo_status            (fifo_status),
      .O_fifo_empty             (fifo_empty),

      .I_custom_fifo_stat_flag  (capture_done)
   );
   `endif


   fe_capture_main #(
      .pTIMESTAMP_FULL_WIDTH    (pTIMESTAMP_FULL_WIDTH),
      .pTIMESTAMP_SHORT_WIDTH   (pTIMESTAMP_SHORT_WIDTH),
      .pCAPTURE_LEN_WIDTH       (pCAPTURE_LEN_WIDTH)
   ) U_fe_capture_main (
      .reset_i                  (fpga_reset), 
      .cwusb_clk                (clk_usb_buf),
      .fe_clk                   (clk_fe_buf), 

      .I_timestamps_disable     (timestamps_disable),
      .I_arm                    (arm),
      .I_reg_arm                (reg_arm),
      .I_capture_len            (capture_len),
      .I_count_writes           (count_writes),
      .I_counter_quick_start    (counter_quick_start),
      .I_max_timestamp          (max_timestamp),

      .I_event                  (fe_event),
      .I_data_cmd               (fe_data_cmd),
      .I_max_short_timestamp    (max_short_timestamp),
      .O_fifo_time              (fe_time),
      .O_fifo_command           (fe_command),
      .O_fifo_wr                (fe_fifo_wr),

      .O_fifo_flush             (fifo_flush),
      .O_capture_done           (capture_done),
      .I_fifo_overflow_blocked  (fifo_overflow_blocked),
      .I_fifo_full              (fifo_full),
      .I_fifo_empty             (fifo_empty),

      .I_target_trig            (1'b0), // unused
      .I_capture_while_trig     (1'b0), // unused

      .O_capturing              (capturing),
      .I_capture_enable         (capture_enable)
   );


   fe_capture_usb #(
      .pTIMESTAMP_FULL_WIDTH    (pTIMESTAMP_FULL_WIDTH),
      .pTIMESTAMP_SHORT_WIDTH   (pTIMESTAMP_SHORT_WIDTH),
      .pCAPTURE_LEN_WIDTH       (pCAPTURE_LEN_WIDTH)
   ) U_fe_capture_usb (
      .reset_i                  (fpga_reset), 
      .fe_clk                   (clk_fe_buf), 
      .fe_data                  (fe_data),
      .fe_rxvalid               (fe_rxvalid),
      .fe_rxactive              (fe_rxactive),
      .fe_rxerror               (fe_rxerror ),
      .fe_sessvld               (fe_sessvld ),
      .fe_vbusvld               (fe_vbusvld ),
      .fe_sessend               (fe_sessend ),

      .O_event                  (fe_event),
      .O_data_cmd               (fe_data_cmd),
      .O_max_short_timestamp    (max_short_timestamp),
      .I_fifo_time              (fe_time),
      .I_fifo_command           (fe_command),
      .I_fifo_wr                (fe_fifo_wr),

      .O_fifo_fe_status         (fe_capture_stat),

      .O_fifo_data              (fifo_in_data),
      .O_fifo_wr                (fifo_wr)
   );


    always @(*) begin
       if (usb_speed == `USB_SPEED_LS) begin
          {fe_xcvrsel1, fe_xcvrsel0} = 2'b10;
          fe_termsel = 1; 
       end
       else if (usb_speed == `USB_SPEED_HS) begin
          {fe_xcvrsel1, fe_xcvrsel0} = 2'b00;
          fe_termsel = 0; 
       end
       else if ((usb_speed == `USB_SPEED_AUTO) || (usb_speed == `USB_SPEED_FS)) begin
          {fe_xcvrsel1, fe_xcvrsel0} = 2'b01;
          fe_termsel = 1; 
       end
       // when speed is set to auto and hasn't been determined yet, settings are programmable
       // (but default to FS)
       else if (usb_speed == `USB_SPEED_AUTO) begin
          {fe_xcvrsel1, fe_xcvrsel0} = usb_xcvrsel_auto;
          fe_termsel = usb_termsel_auto;
       end
       else begin // default: `USB_SPEED_FS
          {fe_xcvrsel1, fe_xcvrsel0} = 2'b01;
          fe_termsel = 1; 
       end
    end

    assign fe_suspendn = 1;

    assign fe_txvalid = 0;
    assign fe_reset = 0;
    assign fe_chrgvbus = 0; //do not want

    assign fe_opmode1 = 0;
    assign fe_opmode0 = 1; //Non-driving mode

    assign fe_idpullup = 0; //do not want

    assign fe_dischrgvbus = 0; //do not want

    assign fe_dppd = 0;
    assign fe_dmpd = 0;


    `ifdef ILA_FE
       wire [17:0] ila_probe;

       assign ila_probe[7:0] = fe_data;
       assign ila_probe[8] = fe_txrdy;
       assign ila_probe[9] = fe_rxactive;
       assign ila_probe[10] = fe_linestate0;
       assign ila_probe[11] = fe_linestate1;
       assign ila_probe[12] = fe_sessend;
       assign ila_probe[13] = fe_rxvalid;
       assign ila_probe[14] = fe_sessvld;
       assign ila_probe[15] = fe_rxerror;
       assign ila_probe[16] = fe_vbusvld;
       assign ila_probe[17] = 1'b0;

       ila_0 ila_0_inst (clk_fe_buf, ila_probe);
    `endif

    `ifdef ILA_USBREG
       ila_1 I_ila_usbreg (
          .clk          (clk_usb_buf),          // input wire clk
          .probe0       (USB_Data),             // input wire [7:0]  probe0  
          .probe1       (USB_Addr),             // input wire [7:0]  probe1 
          .probe2       (USB_nRD),              // input wire [0:0]  probe2 
          .probe3       (USB_nWE),              // input wire [0:0]  probe3 
          .probe4       (USB_nCS),              // input wire [0:0]  probe4 
          .probe5       (reg_address),          // input wire [7:0]  probe5
          .probe6       (reg_bytecnt),          // input wire [6:0]  probe6 
          .probe7       (write_data),           // input wire [7:0]  probe7 
          .probe8       (read_data),            // input wire [8:0]  probe8 
          .probe9       (reg_read),             // input wire [0:0]  probe9 
          .probe10      (reg_write),            // input wire [0:0]  probe10 
          .probe11      (reg_addrvalid),        // input wire [0:0]  probe11 
          .probe12      (USB_SPARE0),           // input wire [0:0]  probe12 
          .probe13      (USB_SPARE1)            // input wire [0:0]  probe13 
          .probe14      (psen)                  // input wire [0:0]  probe14 
          .probe15      (psdone)                // input wire [0:0]  probe15 
          .probe16      (psincdec)              // input wire [0:0]  probe16 
       );
    `endif

    `ifndef __ICARUS__
        clk_wiz_0 U_trigger_clock (
          .reset        (fpga_reset),
          .clk_in1      (clk_fe_buf),
          .clk_out1     (trigger_clk),
          // Dynamic phase shift ports
          .psclk        (clk_usb_buf),
          .psen         (psen),
          .psincdec     (psincdec),
          .psdone       (psdone),
          // Status and control signals
          .locked       (trigger_clk_locked)
       );
    `else
       assign trigger_clk_locked = 1'b1;
       assign psdone = 1'b1;
       assign trigger_clk = I_trigger_clk;
    `endif


   pattern_matcher_usb #(
      .pPATTERN_BYTES  (pPATTERN_BYTES)
   ) U_pattern_matcher (
      .reset_i          (fpga_reset),
      .fe_clk           (clk_fe_buf),
      .trigger_clk      (trigger_clk),
      .I_arm            (arm),
      .I_pattern        (pattern),
      .I_mask           (pattern_mask),
      .I_pattern_bytes  (pattern_bytes),
      .I_fe_data        (fe_data),
      .I_fe_data_valid  (fe_rxvalid),
      .I_capturing      (capturing),
      .O_match_trigger  (trigger_match)
   );


   pw_trigger #(
      .pCAPTURE_DELAY_WIDTH     (pCAPTURE_DELAY_WIDTH),
      .pTRIGGER_DELAY_WIDTH     (pTRIGGER_DELAY_WIDTH),
      .pTRIGGER_WIDTH_WIDTH     (pTRIGGER_WIDTH_WIDTH),
      .pALL_TRIGGER_DELAY_WIDTHS(pALL_TRIGGER_DELAY_WIDTHS),
      .pALL_TRIGGER_WIDTH_WIDTHS(pALL_TRIGGER_WIDTH_WIDTHS),
      .pNUM_TRIGGER_PULSES      (pNUM_TRIGGER_PULSES),
      .pNUM_TRIGGER_WIDTH       (pNUM_TRIGGER_WIDTH)
   ) U_trigger (
      .reset_i          (fpga_reset),
      .trigger_clk      (trigger_clk),
      .fe_clk           (clk_fe_buf),
      .O_trigger        (cw_trig),
      .I_capture_delay  (capture_delay),
      .I_trigger_delay  (trigger_delay),
      .I_trigger_width  (trigger_width),
      .I_trigger_enable (trigger_enable),
      .I_num_triggers   (num_triggers),
      .O_capture_enable_pulse (capture_enable_pulse),
      .I_match          (trigger_match),
      .I_capturing      (capturing),
      .O_capture_enable (capture_enable)
   );


    usb_autodetect #(
        .pCOUNTER_WIDTH     (pUSB_AUTO_COUNTER_WIDTH)
    ) U_usb_autodetect (
        .reset_i            (fpga_reset),
        .fe_clk             (clk_fe_buf),
        .cwusb_clk          (clk_usb_buf),
        .fe_linestate0      (fe_linestate0),
        .fe_linestate1      (fe_linestate1),

        .I_restart          (usb_auto_restart),
        .I_wait1            (usb_auto_wait1),
        .I_wait2            (usb_auto_wait2),
        .O_speed            (usb_auto_speed)
    );


   `ifndef __ICARUS__
      //TODO: add MMCM to provide CW with regenerated target clock from FE clock
      ODDR U_cw_clk (
         .Q(cw_clk),
         .C(clk_fe_buf),
         .CE(1'b1),
         .D1(1'b1),
         .D2(1'b0),
         .R(1'b0),
         .S(1'b0)
      );
   `else
      assign cw_clk = clk_fe_buf;
   `endif

endmodule
`default_nettype wire

