`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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

module tb_pw();
   
    parameter pUSB_CLOCK_PERIOD = 10;
    parameter pFE_CLOCK_PERIOD = 16;
    // TODO: generate a few testcases wih various ranges of delays, to more easily stress and hit corner cases
    parameter pMIN_FE_DELAY = 0;
    parameter pMAX_FE_DELAY = 7;
    parameter pDELAY_MODE = 0;
    parameter pVERBOSE = 1;
    parameter pSHOW_TIME_EVENTS = 0;
    parameter pNUM_EVENTS = 20;
    parameter pPVALID = 50;
    parameter pSEED = 1;

   // FIFO bitfields: (TODO: pull in from external file)
   `define FE_FIFO_CMD_DATA 2'b00
   `define FE_FIFO_CMD_STAT 2'b01
   `define FE_FIFO_CMD_TIME 2'b10

   `define FE_FIFO_CMD_START 16
   `define FE_FIFO_CMD_BIT_LEN 2

   `define FE_FIFO_TIME_START 0
   `define FE_FIFO_SHORTTIME_LEN 3
   `define FE_FIFO_FULLTIME_LEN 16

   `define FE_FIFO_STATUS_BITS_START 3
   `define FE_FIFO_STATUS_BITS_LEN 5
   `define FE_FIFO_RXACTIVE_BIT 3
   `define FE_FIFO_RXERROR_BIT 4
   `define FE_FIFO_SESSVLD_BIT 5
   `define FE_FIFO_SESSEND_BIT 6
   `define FE_FIFO_VBUSVLD_BIT 7

   `define FE_FIFO_DATA_START 8
   `define FE_FIFO_DATA_LEN 8


    reg           usb_clk;
    wire [7:0]    USB_Data;
    reg  [7:0]    USB_wdata;
    reg  [7:0]    USB_Addr;
    reg           USB_nRD;
    reg           USB_nWE;
    reg           USB_nCS;
    wire          USB_SPARE0;
    reg           USB_SPARE1;

    /* FRONT END CONNECTIONS */
    reg  fe_clk;
    reg  fe_txrdy;
    reg  fe_rxactive;
    reg  fe_id_dig;
    reg  fe_linestate0;
    reg  fe_linestate1;
    reg  fe_hostdisc;
    reg  fe_sessend;
    wire [7:0] fe_data;
    reg  [7:0] fe_wdata;
    reg  fe_rxvalid;
    reg  fe_sessvld;
    reg  fe_rxerror;
    reg  fe_vbusvld;

    /* 20-PIN USER HEADER CONNECTOR */
    reg  [7:0] userio_d;
    reg  userio_clk;
    reg  [23:0] read_data;
    reg  [7:0] data;
    reg  [7:0] expected_data;
    reg  [1:0] command;
    reg  [`FE_FIFO_FULLTIME_LEN-1:0] timestamp;
    reg  dut_rxactive;
    reg  dut_rxerror;
    reg  dut_sessvld;
    reg  dut_sessend;
    reg  dut_vbusvld;
    reg  [4:0] dut_usbstat;

    /* 20-PIN CHIPWHISPERER CONNECTOR */
    wire cw_clk;
    wire cw_trig;

    reg  reset;
    int  seed;


    //TODO: provide input seed, so user running testbench can choose to change it or repeat it

   initial begin
      seed = pSEED;
      $display("Running with pSEED=%0d", pSEED);
      $urandom(seed);
      $dumpfile("tb.fst");
      $dumpvars(0, tb_pw);
      usb_clk = 1'b1;
      fe_clk = 1'b1;
      reset = 1'b0;

      USB_wdata = 0;
      USB_Addr = 0;
      USB_nRD = 1;
      USB_nWE = 1;
      USB_nCS = 1;
      USB_SPARE1 = 1;

      fe_txrdy = 0;
      fe_rxactive = 0;
      fe_id_dig = 0;
      fe_linestate0 = 0;
      fe_linestate1 = 0;
      fe_hostdisc = 0;
      fe_sessend = 0;
      fe_wdata = 0;
      fe_rxvalid = 0;
      fe_sessvld = 0;
      fe_rxerror = 0;
      fe_vbusvld = 0;

      //userio_d = 0;
      //userio_clk = 0;

      #(pUSB_CLOCK_PERIOD*2) reset = 1;
      #(pUSB_CLOCK_PERIOD*2) reset = 0;

      /*
      repeat(10) @(posedge usb_clk);
      write_1byte(0, 8'ha3);
      repeat(10) @(posedge usb_clk);
      read_1byte(0, read_data);
      $display("Got %h", read_data);
      */

      //#(pFE_CLOCK_PERIOD*100) $finish;
   end

   int i,j,k;
   int errors;
   int time_counter;
   string str;
   reg fe_data_event [0:2047];
   reg [7:0] fe_bytes [0:2047];
   reg [4:0] fe_stat [0:2047];
   reg [15:0] fe_times [0:2047];
   reg [7:0] sniff_bytes [0:7];

   // FE feeding thread:
   initial begin
      errors = 0;
      #(pFE_CLOCK_PERIOD*100);
      //write_1byte(2, 8'h01); // disable timestamps
      write_1byte(3, 8'h01); // enable capture
      fe_times[0] = 0; // by definition

      if (pVERBOSE) begin
         $display("--------------------------------------|-------------------------------");
         $display("FE testbench sending:                 | PhyWhisperer DUT receiving:");
         $display("--------------------------------------|-------------------------------");
      end

      @(posedge fe_clk);
      for (i = 0; i < pNUM_EVENTS; i = i + 1) begin
         fe_bytes[i] = $urandom;
         fe_stat[i] = $urandom;
         get_delay(fe_times[i+1]);
         get_valid(fe_data_event[i]);
         // if rxvalid is low, then stat must change -- otherwise there is no event to pick up
         if (fe_data_event[i] == 0) begin
            if (i == 0) begin
               while (fe_stat[i] == 0)
                  fe_stat[i] = $urandom;
            end
            else begin
               while (fe_stat[i] == fe_stat[i-1])
                  fe_stat[i] = $urandom;
            end
         end

         // TODO: consider driving fe_stat independently of fe_bytes?
         send_fe_data(fe_data_event[i], fe_bytes[i], fe_stat[i], fe_times[i+1]);
         if (pVERBOSE)
            if (fe_data_event[i])
               $display("DATA: data=%h, stat=%h, delay=%0d", fe_bytes[i], fe_stat[i], fe_times[i+1]);
            else
               $display("STAT:          stat=%h, delay=%0d", fe_stat[i], fe_times[i+1]);
      end
      fe_rxvalid = 1'b0;
      #(pFE_CLOCK_PERIOD*1000);
      if (j == pNUM_EVENTS)
         $display("Read all %0d DATA packets", j);
      else begin
         $display("*** ONLY READ %0d of %0d DATA packets.", j, pNUM_EVENTS);
         errors += 1;
      end
      if (errors)
         $display("SIMULATION FAILED (%0d errors).", errors);
      else
         $display("Simulation passed!");
      $finish;
   end


   // FIFO read thread:
   initial begin
      j = 0;
      time_counter = 0;
      while (1) begin
         wait (U_dut.U_reg_pw.sniff_fifo_empty == 1'b0);
         read_lots_bytes(1);
         read_next_byte(read_data[7:0]);
         read_next_byte(read_data[15:8]);
         read_next_byte(read_data[23:16]);
         command = read_data[`FE_FIFO_CMD_START +: `FE_FIFO_CMD_BIT_LEN];

         if ( (command == `FE_FIFO_CMD_DATA) || (command == `FE_FIFO_CMD_STAT) ) begin
            data = read_data[`FE_FIFO_DATA_START +: `FE_FIFO_DATA_LEN];
            dut_rxactive = read_data[`FE_FIFO_RXACTIVE_BIT];
            dut_rxerror = read_data[`FE_FIFO_RXERROR_BIT];
            dut_sessvld = read_data[`FE_FIFO_SESSVLD_BIT];
            dut_sessend = read_data[`FE_FIFO_SESSEND_BIT];
            dut_vbusvld = read_data[`FE_FIFO_VBUSVLD_BIT];
            dut_usbstat = read_data[`FE_FIFO_STATUS_BITS_START +: `FE_FIFO_STATUS_BITS_LEN];

            if (command == `FE_FIFO_CMD_DATA) begin
               expected_data = fe_bytes[j];
               str = "DATA";
            end
            else begin
               expected_data = 8'd0;
               str = "STAT";
            end

            timestamp = read_data[`FE_FIFO_TIME_START +: `FE_FIFO_SHORTTIME_LEN];
            time_counter = time_counter + timestamp;
            if ( (data == expected_data) && (dut_usbstat == fe_stat[j]) && (time_counter == fe_times[j]) ) begin
               if (pVERBOSE)
                  //$display("\t\t\t\tdata=%h, rxactive=%0b, rxerror=%0b, sessvld=%0b, sessend=%0b, vbusvld=%0b, time=%0d, total time=%0d", data, dut_rxactive, dut_rxerror, dut_sessvld, dut_sessend, dut_vbusvld, timestamp, time_counter);
                  $display("\t\t\t\t\t%s: data=%h, stat=%h, time=%0d, total time=%0d", str, data, dut_usbstat, timestamp, time_counter);
            end
            else begin
               errors += 1;
               if ( (data == expected_data) && (dut_usbstat == fe_stat[j]))
                  $display("\t\t\t\t\t*** MISMATCH on %s read #%0d at time %0t: got good data (%h) and stat (%h), bad time: expected %0d, got %0d", str, j, $time, data, dut_usbstat, fe_times[j], time_counter);
               else if (time_counter == fe_times[j])
                  $display("\t\t\t\t\t*** MISMATCH on %s read #%0d at time %0t: got good timestamp (%0d), bad data (got %h, expected %h) or stat (got %h, expected %h)", str, j, $time, timestamp, data, expected_data, dut_usbstat, fe_stat[j]);
               else
                  $display("\t\t\t\t\t*** MISMATCH on %s read #%0d at time %0t: bad data (got %h, expected %h), stat (got %h, expected %h) and time (got %0d, expected %0d)", str, j, $time, data, expected_data, dut_usbstat, fe_stat[j], time_counter, fe_times[j]);
            end
            j = j + 1;
            time_counter = 0;
         end


         else if (command == `FE_FIFO_CMD_TIME) begin
            timestamp = read_data[`FE_FIFO_TIME_START +: `FE_FIFO_FULLTIME_LEN];
            time_counter = time_counter + timestamp;
            if (pVERBOSE && pSHOW_TIME_EVENTS)
               $display("\t\t\t\t\ttime=%0d", timestamp);
         end

         else begin
            errors += 1;
            $display("\t\t\t\t\t*** ERROR: Unknown command!");
         end

         /* check sniff register
         if (j == pNUM_EVENTS) begin
            read_lots_bytes(5);
            for (k = 0; k < 8; k = k + 1) begin
               read_next_byte(sniff_bytes[k]);
               $display("Sniff byte: %h", sniff_bytes[k]);
            end
         end
         */

      end
   end


   assign USB_Data = USB_nWE? 8'bz : USB_wdata;
   assign fe_data = fe_wdata;
   assign USB_SPARE0 = reset;

   task write_1byte;
      input [7:0] address;
      input [7:0] data;
      @(posedge usb_clk);
      USB_SPARE1 = 0;
      USB_Addr = address;
      @(posedge usb_clk);
      USB_SPARE1 = 1;
      repeat(4) @(posedge usb_clk);
      USB_wdata = data;
      USB_nWE = 0;
      @(posedge usb_clk);
      USB_nWE = 1;
      USB_nCS = 0;
      @(posedge usb_clk);
      USB_nCS = 1;
   endtask


   task read_1byte;
      input [7:0] address;
      output [7:0] data;
      @(posedge usb_clk);
      USB_SPARE1 = 0;
      USB_Addr = address;
      @(posedge usb_clk);
      USB_SPARE1 = 1;
      repeat(4) @(posedge usb_clk);
      USB_nRD = 0;
      USB_nCS = 0;
      @(posedge usb_clk);
      USB_nCS = 1;
      //data = USB_Data;
      @(posedge usb_clk);
      #1 data = USB_Data;
      @(posedge usb_clk);
      USB_nRD = 1;
   endtask

   task read_lots_bytes;
      input [7:0] address;
      @(posedge usb_clk);
      USB_SPARE1 = 0;
      USB_Addr = address;
      @(posedge usb_clk);
      USB_SPARE1 = 1;
      repeat(4) @(posedge usb_clk);
   endtask

   task read_next_byte;
      output [7:0] data;
      USB_nRD = 0;
      USB_nCS = 0;
      @(posedge usb_clk);
      USB_nCS = 1;
      @(posedge usb_clk);
      #1 data = USB_Data;
      @(posedge usb_clk);
      USB_nRD = 1;
      @(posedge usb_clk);
   endtask


   task send_fe_data;
      input rxvalid;
      input [7:0] data;
      input [4:0] stat;
      input [15:0] delay;
      fe_rxvalid = rxvalid;
      fe_wdata = data;
      fe_rxactive = stat[`FE_FIFO_RXACTIVE_BIT - `FE_FIFO_STATUS_BITS_START];
      fe_rxerror = stat[`FE_FIFO_RXERROR_BIT - `FE_FIFO_STATUS_BITS_START];
      fe_sessvld = stat[`FE_FIFO_SESSVLD_BIT - `FE_FIFO_STATUS_BITS_START];
      fe_sessend = stat[`FE_FIFO_SESSEND_BIT - `FE_FIFO_STATUS_BITS_START];
      fe_vbusvld = stat[`FE_FIFO_VBUSVLD_BIT - `FE_FIFO_STATUS_BITS_START];

      @(posedge fe_clk);
      if (delay > 0) begin
         fe_rxvalid = 0;
         fe_wdata = 0;
      end
      repeat (delay) @(posedge fe_clk);
   endtask


   task get_delay;
      output [15:0] delay;
      if (pDELAY_MODE == 0)
         delay = $urandom_range(pMIN_FE_DELAY, pMAX_FE_DELAY);
      else if (pDELAY_MODE == 1) begin
         delay = $urandom_range(0, 1);
         if (delay == 1) delay = $urandom_range(pMIN_FE_DELAY, pMAX_FE_DELAY);
         else delay = 0;
      end
   endtask


   task get_valid;
      output valid;
      if ($urandom_range(0, 100) < pPVALID)
         valid = 1;
      else
         valid = 0;
   endtask


   always #(pUSB_CLOCK_PERIOD/2) usb_clk = !usb_clk;
   always #(pFE_CLOCK_PERIOD/2) fe_clk = !fe_clk;

   // TODO: repeat this for all DUT inputs
   wire #1 fe_id_dig_out      = fe_id_dig;
   wire #1 fe_txrdy_out       = fe_txrdy;
   wire #1 fe_rxactive_out    = fe_rxactive;
   wire #1 fe_linestate0_out  = fe_linestate0;
   wire #1 fe_linestate1_out  = fe_linestate1;
   wire #1 fe_hostdisc_out    = fe_hostdisc;
   wire #1 fe_sessend_out     = fe_sessend;
   wire [7:0] #1 fe_data_out  = fe_data;
   wire #1 fe_rxvalid_out     = fe_rxvalid;
   wire #1 fe_sessvld_out     = fe_sessvld;
   wire #1 fe_rxerror_out     = fe_rxerror;
   wire #1 fe_vbusvld_out     = fe_vbusvld;

phywhisperer_top U_dut (
    /* USB CHIP CONNECTIONS */
    .usb_clk            (usb_clk    ),
    .USB_Data           (USB_Data   ),
    .USB_Addr           (USB_Addr   ),
    .USB_nRD            (USB_nRD    ),
    .USB_nWE            (USB_nWE    ),
    .USB_nCS            (USB_nCS    ),
    .USB_SPARE0         (USB_SPARE0 ),
    .USB_SPARE1         (USB_SPARE1 ),

    /* FRONT END CONNECTIONS */
    .fe_xcvrsel0        (), // unused
    .fe_xcvrsel1        (), // unused
    .fe_termsel         (), // unused
    .fe_suspendn        (), // unused
    .fe_txvalid         (), // unused
    .fe_reset           (), // unused
    .fe_chrgvbus        (), // unused
    .fe_opmode0         (), // unused
    .fe_opmode1         (), // unused
    .fe_idpullup        (), // unused
    .fe_dischrgvbus     (), // unused
    .fe_dppd            (), // unused
    .fe_dmpd            (), // unused
    .fe_id_dig          (fe_id_dig_out     ),
    .fe_txrdy           (fe_txrdy_out      ),
    .fe_rxactive        (fe_rxactive_out   ),
    .fe_linestate0      (fe_linestate0_out ),
    .fe_linestate1      (fe_linestate1_out ),
    .fe_hostdisc        (fe_hostdisc_out   ),
    .fe_sessend         (fe_sessend_out    ),
    .fe_clk             (fe_clk            ),
    .fe_data            (fe_data_out       ),
    .fe_rxvalid         (fe_rxvalid_out    ),
    .fe_sessvld         (fe_sessvld_out    ),
    .fe_rxerror         (fe_rxerror_out    ),
    .fe_vbusvld         (fe_vbusvld_out    ),

    /* 20-PIN USER HEADER CONNECTOR */
    .userio_d           (userio_d),
    .userio_clk         (userio_clk),

    /* 20-PIN CHIPWHISPERER CONNECTOR */
    .cw_clk             (cw_clk),
    .cw_trig            (cw_trig)
    );

endmodule
`default_nettype wire

