//////////////////////////////////////////////////////////////////////////////////
// Company: NewAE
// Engineer: Jean-Pierre Thibaut
// 
// Create Date: 
// Design Name: 
// Module Name: usb_autodetect
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

`timescale 1ns / 1ps
`default_nettype none
`include "defines_usb.v"

module tb_usb_autodetect;

   parameter pUSB_CLOCK_PERIOD = 10;
   parameter pFE_CLOCK_PERIOD = 16;
   parameter pCOUNTER_WIDTH = 24;
   parameter pWAIT_0_START = 8;
   parameter pWAIT_1_LINEHIGH = 32;
   parameter pWAIT_2_LINELOW = 32;

   reg  reset;
   reg  fe_clk;
   reg  usb_clk;
   reg  [1:0] linestate;
   reg  restart;
   wire [1:0] speed;
   wire [pCOUNTER_WIDTH-1:0] wait1;
   wire [pCOUNTER_WIDTH-1:0] wait2;

   int errors;
   
   assign wait1 = pWAIT_1_LINEHIGH;
   assign wait2 = pWAIT_2_LINELOW;

   initial begin
      $dumpfile("results/tb_usb_autodetect.fst");
      $dumpvars(0, tb_usb_autodetect);
      usb_clk = 1'b1;
      fe_clk = 1'b1;
      reset = 1'b0;
      restart = 1'b0;
      linestate = 2'b00;
      #(pUSB_CLOCK_PERIOD*2) reset = 1;
      #(pUSB_CLOCK_PERIOD*2) reset = 0;
   end

   always #(pUSB_CLOCK_PERIOD/2) usb_clk = !usb_clk;
   always #(pFE_CLOCK_PERIOD/2) fe_clk = !fe_clk;


   // drive DUT:
   initial begin

      errors = 0;

      $write("Test 1: start LS but abort early... ");
      repeat (pWAIT_0_START+2) @(posedge fe_clk);
      linestate = 2'b10;
      repeat (10) @(posedge fe_clk);
      linestate = 2'b00;
      repeat (3) @(posedge fe_clk);
      if (speed == `USB_SPEED_AUTO)
         $display("pass.");
      else begin
         errors += 1;
         $display("FAIL! speed should be %0d but it is %0d", `USB_SPEED_AUTO, speed);
      end

      repeat (10) @(posedge usb_clk);
      restart = 1;
      repeat (10) @(posedge usb_clk);
      restart = 0;


      $write("Test 2: successful LS... ");
      repeat (pWAIT_0_START+2) @(posedge fe_clk);
      linestate = 2'b10;
      repeat (pWAIT_1_LINEHIGH+2) @(posedge fe_clk);
      linestate = 2'b00;
      repeat (3) @(posedge fe_clk);
      if (speed == `USB_SPEED_LS)
         $display("pass.");
      else begin
         errors += 1;
         $display("FAIL! speed should be %0d but it is %0d", `USB_SPEED_LS, speed);
      end

      repeat (10) @(posedge usb_clk);
      restart = 1;
      repeat (10) @(posedge usb_clk);
      restart = 0;


      $write("Test 3: successful FS... ");
      repeat (pWAIT_0_START+2) @(posedge fe_clk);
      linestate = 2'b01;
      repeat (pWAIT_1_LINEHIGH+2) @(posedge fe_clk);
      linestate = 2'b00;
      repeat (pWAIT_2_LINELOW-1) @(posedge fe_clk);
      linestate = 2'b01;
      repeat (4) @(posedge fe_clk);
      if (speed == `USB_SPEED_FS)
         $display("pass.");
      else begin
         errors += 1;
         $display("FAIL! speed should be %0d but it is %0d", `USB_SPEED_FS, speed);
      end

      linestate = 2'b00;
      repeat (10) @(posedge usb_clk);
      restart = 1;
      repeat (10) @(posedge usb_clk);
      restart = 0;


      $write("Test 4: successful HS... ");
      repeat (pWAIT_0_START+2) @(posedge fe_clk);
      linestate = 2'b01;
      repeat (pWAIT_1_LINEHIGH+2) @(posedge fe_clk);
      linestate = 2'b00;
      repeat (pWAIT_2_LINELOW+2) @(posedge fe_clk);
      linestate = 2'b01;
      repeat (4) @(posedge fe_clk);
      if (speed == `USB_SPEED_HS)
         $display("pass.");
      else begin
         errors += 1;
         $display("FAIL! speed should be %0d but it is %0d", `USB_SPEED_HS, speed);
      end

      if (errors)
         $display("SIMULATION FAILED (%0d errors).", errors);
      else
         $display("Simulation passed!");
      $finish;


   end


    usb_autodetect #(
        .pCOUNTER_WIDTH     (pCOUNTER_WIDTH),
        .pWAIT_1_LINEHIGH (pWAIT_1_LINEHIGH),
        .pWAIT_2_LINELOW  (pWAIT_2_LINELOW)
    ) U_dut (
        .reset_i            (reset),
        .fe_clk             (fe_clk),
        .cwusb_clk          (usb_clk),
        .fe_linestate0      (linestate[0]),
        .fe_linestate1      (linestate[1]),
        .I_restart          (restart),
        .I_wait1            (wait1),
        .I_wait2            (wait2),
        .O_speed            (speed)
    );



endmodule
`default_nettype wire
