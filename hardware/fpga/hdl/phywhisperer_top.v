`timescale 1ns / 1ps
`default_nettype none
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

    /* FRONT END CONNECTIONS */
    output wire fe_xcvrsel0,
    output wire fe_xcvrsel1,
    output wire fe_termsel,
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
    inout  wire [7:0] fe_data,
    input  wire fe_rxvalid,
    input  wire fe_sessvld,
    output wire fe_dppd,
    output wire fe_dmpd,
    input  wire fe_rxerror,
    input  wire fe_vbusvld,

    /* 20-PIN USER HEADER CONNECTOR */
    inout  wire [7:0] userio_d,
    inout  wire userio_clk,

    /* 20-PIN CHIPWHISPERER CONNECTOR */
    output wire cw_clk,
    output wire cw_trig
    );

   parameter pTIMESTAMP_FULL_WIDTH = 16; // TODO: 8 for development/testing; increase to 16 later
   parameter pTIMESTAMP_SHORT_WIDTH = 3;

   wire cmdfifo_isout;
   wire [7:0] cmdfifo_din;
   wire [7:0] cmdfifo_dout;
   wire clk_usb_buf;
   wire clk_fe_buf;
   wire reset_i = USB_SPARE0;

   wire [5:0]   reg_address;
   wire [15:0]  reg_bytecnt;
   wire [7:0]   write_data;
   wire [7:0]   read_data;
   wire         reg_read;
   wire         reg_write;
   wire         reg_addrvalid;

   wire usb_clk_copy;

   wire [7:0] fe_capture_data;
   wire [4:0] fe_capture_stat;
   wire [1:0] fe_capture_cmd;
   wire [pTIMESTAMP_FULL_WIDTH-1:0] fe_capture_time;
   wire fe_capture_data_wr;

   wire [7:0] fe_capture_sniff_data;
   wire fe_capture_sniff_wr;
   wire [3:0] fe_capture_sniff_count;

   wire trigger_clk;
   wire psen;
   wire psincdec;
   wire psdone;
   wire trigger_clk_locked;
   wire trigger_match;
   wire timestamps_disable;
   wire capture_enable;

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

   usb_reg_main U_usb_reg_main (
      .reset_i          (reset_i), 
      .cwusb_clk        (clk_usb_buf), 
      .cwusb_din        (cmdfifo_din), 
      .cwusb_dout       (cmdfifo_dout), 
      .cwusb_rdn        (USB_nRD), 
      .cwusb_wrn        (USB_nWE),
      .cwusb_cen        (USB_nCS),
      .cwusb_alen       (USB_SPARE1),
      .cwusb_addr       (USB_Addr),
      .cwusb_isout      (cmdfifo_isout), 
      .reg_address      (reg_address), 
      .reg_bytecnt      (reg_bytecnt), 
      .reg_datao        (write_data), 
      .reg_datai        (read_data),
      .reg_read         (reg_read), 
      .reg_write        (reg_write), 
      .reg_addrvalid    (reg_addrvalid)
   );


   reg_pw #(
      .pTIMESTAMP_FULL_WIDTH    (pTIMESTAMP_FULL_WIDTH),
      .pTIMESTAMP_SHORT_WIDTH   (pTIMESTAMP_SHORT_WIDTH)
   ) U_reg_pw (
      .reset_i          (reset_i), 
      .cwusb_clk        (clk_usb_buf), 
      .reg_address      (reg_address), 
      .reg_bytecnt      (reg_bytecnt), 
      .read_data        (read_data), 
      .write_data       (write_data),
      .reg_read         (reg_read), 
      .reg_write        (reg_write), 
      .reg_addrvalid    (reg_addrvalid),

      // FE:
      .fe_clk                   (clk_fe_buf),
      .I_fe_capture_data        (fe_capture_data),
      .I_fe_capture_stat        (fe_capture_stat),
      .I_fe_capture_cmd         (fe_capture_cmd),
      .I_fe_capture_time        (fe_capture_time),
      .I_fe_capture_data_wr     (fe_capture_data_wr),

      .I_fe_sniff_data          (fe_capture_sniff_data),
      .I_fe_sniff_wr            (fe_capture_sniff_wr),
      .I_fe_sniff_count         (fe_capture_sniff_count),

      .O_trigger_match          (trigger_match),
      .O_timestamps_disable     (timestamps_disable),
      .O_capture_enable         (capture_enable)

   );


   fe_capture #(
      .pTIMESTAMP_FULL_WIDTH    (pTIMESTAMP_FULL_WIDTH),
      .pTIMESTAMP_SHORT_WIDTH   (pTIMESTAMP_SHORT_WIDTH)
   ) U_fe_capture (
      .reset_i                  (reset_i), 
      .fe_clk                   (clk_fe_buf), 
      .I_timestamps_disable     (timestamps_disable),
      .I_capture_enable         (capture_enable),
      .fe_data                  (fe_data),
      .fe_rxvalid               (fe_rxvalid),
      .fe_rxactive              (fe_rxactive),
      .fe_rxerror               (fe_rxerror ),
      .fe_sessvld               (fe_sessvld ),
      .fe_vbusvld               (fe_vbusvld ),
      .fe_sessend               (fe_sessend ),
      .O_time                   (fe_capture_time),
      .O_data                   (fe_capture_data),
      .O_status                 (fe_capture_stat),
      .O_command                (fe_capture_cmd),
      .O_data_wr                (fe_capture_data_wr),
      .O_sniff_data             (fe_capture_sniff_data),
      .O_sniff_wr               (fe_capture_sniff_wr),
      .O_sniff_count            (fe_capture_sniff_count)
   );


    //10 = FS, 00 = HS
    assign fe_xcvrsel0 = 1;
    assign fe_xcvrsel1 = 0;

    //1 = FS, 0 = HS
    assign fe_termsel = 1; 

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

    //assign userio_d = fe_data;
    //assign userio_clk = usb_clk_copy;
    //assign userio_d[0] = USB_SPARE1;
    //assign userio_d[1] = USB_nRD;
    //assign userio_d[2] = USB_nWE;
    //assign userio_d[3] = USB_nCS;
    //assign userio_d[7:4] = USB_Addr[3:0];


    `ifdef ILA
       wire [31:0] ila_probe;

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
       assign ila_probe[31:17] = 15'h0;

       assign fe_data = 8'hZZ;

       ila_0 ila_0_inst (clk_fe_buf, ila_probe);

       /*
       wire [75:0] ila_usb_probe; // 8 + 8 + 3 + 6 + 16 + 8 + 16 + 3 + 6 = 74 bits
       assign ila_usb_probe[7:0] = USB_Data;
       assign ila_usb_probe[15:8] = USB_Addr;
       assign ila_usb_probe[16] = USB_nRD;
       assign ila_usb_probe[17] = USB_nWE;
       assign ila_usb_probe[18] = USB_nCS;
       assign ila_usb_probe[24:19] = reg_address;
       assign ila_usb_probe[40:25] = reg_bytecnt;
       assign ila_usb_probe[48:41] = reg_datao;
       assign ila_usb_probe[64:49] = reg_size;
       assign ila_usb_probe[65] = reg_read;
       assign ila_usb_probe[66] = reg_write;
       assign ila_usb_probe[67] = reg_addrvalid;
       assign ila_usb_probe[73:68] = reg_hypaddress;
       assign ila_usb_probe[74] = USB_SPARE0;
       assign ila_usb_probe[75] = USB_SPARE1;
       */

    `endif

    `ifdef ILA
       ila_1 I_ila_usbreg (
          .clk          (clk_usb_buf),          // input wire clk
          .probe0       (USB_Data),             // input wire [7:0]  probe0  
          .probe1       (USB_Addr),             // input wire [7:0]  probe1 
          .probe2       (USB_nRD),              // input wire [0:0]  probe2 
          .probe3       (USB_nWE),              // input wire [0:0]  probe3 
          .probe4       (USB_nCS),              // input wire [0:0]  probe4 
          .probe5       (reg_address),          // input wire [5:0]  probe5 
          .probe6       (reg_bytecnt),          // input wire [15:0]  probe6 
          .probe7       (write_data),           // input wire [7:0]  probe7 
          .probe8       (read_data),            // input wire [15:0]  probe8 
          .probe9       (reg_read),             // input wire [0:0]  probe9 
          .probe10      (reg_write),            // input wire [0:0]  probe10 
          .probe11      (reg_addrvalid),        // input wire [0:0]  probe11 
          .probe12      (USB_SPARE0),           // input wire [0:0]  probe12 
          .probe13      (USB_SPARE1)            // input wire [0:0]  probe13 
       );


    `endif

    // TODO: phase shift
    assign psen = 1'b0;
    assign psincdec = 1'b0;

    `ifndef __ICARUS__

        clk_wiz_0 U_trigger_clock (
          .reset        (reset_i),
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

    `endif

   pw_trigger U_trigger (
      .reset_i          (reset_i),
      .trigger_clk      (trigger_clk),
      .usb_clk          (clk_usb_buf),
      .O_trigger        (cw_trig),
      //.O_trigger        (),
      .I_offset         (4'b0),
      .I_match          (trigger_match)
   );


   reg [7:0] clk_counter;
   always @ (posedge clk_fe_buf) begin
      clk_counter <= clk_counter + 1;
   end


   `ifndef __ICARUS__
      ODDR U_cw_clk (
         .Q(cw_clk),
         .C(clk_counter[7]),
         .CE(1'b1),
         .D1(1'b1),
         .D2(1'b0),
         .R(1'b0),
         .S(1'b0)
      );
   `endif

endmodule
`default_nettype wire

