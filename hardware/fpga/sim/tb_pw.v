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

`timescale 1ns / 1ps
`default_nettype none
`include "defines_pw.v"
`include "defines_usb.v"

module tb_pw();

    parameter pUSB_CLOCK_PERIOD = 10;
    parameter pFE_CLOCK_PERIOD = 16;

    // these parameters define the testcase:
    parameter pMIN_FE_DELAY = 0;
    parameter pMAX_FE_DELAY = 7;
    parameter pDELAY_MODE = 0;
    parameter pVERBOSE = 1;
    parameter pSHOW_TIME_EVENTS = 0;
    parameter pNUM_EVENTS = 20;
    parameter pNO_CAPTURE_LIMIT = 0;
    parameter pNUM_REPEATS = 2;
    parameter pPRETRIG_BYTES_MIN = 0;
    parameter pPRETRIG_BYTES_MAX = 200;
    parameter pPATTERN_BYTES_MIN = 2;
    parameter pPATTERN_BYTES_MAX = 64;
    parameter pPATTERN_ACTUAL_SIZE = 64;
    parameter pPVALID = 50;
    parameter pSEED = 1;
    parameter pFIFO_DEPTH = 8192;
    parameter pMAX_EVENTS = pFIFO_DEPTH * 4; // arbitrary
    parameter pTIMEOUT = 50000;
    parameter pTRIGGER_ENABLE = 0;
    parameter pTRIGGER_DELAY_MIN= 0;
    parameter pTRIGGER_DELAY_MAX= 2**20-1;
    parameter pTRIGGER_WIDTH_MIN= 1;
    parameter pTRIGGER_WIDTH_MAX= 2**17-1;
    parameter pNUM_TRIGGERS_MIN = 1;
    parameter pNUM_TRIGGERS_MAX = 8;
    parameter pOVERFLOW_EXPECTED = 0;
    parameter pREAD_CONCURRENTLY = 1;
    parameter pSTREAM_MODE = 0;
    parameter pSLOW_READS = 0;
    parameter pMAX_TIMESTAMP = 'hFFFF;
    parameter pDUMP = 0;

    reg           usb_clk;
    wire [7:0]    USB_Data;
    reg  [7:0]    USB_wdata;
    reg  [7:0]    USB_Addr;
    reg           USB_nRD;
    reg           USB_nWE;
    reg           USB_nCS;
    wire          USB_SPARE0;
    reg           USB_SPARE1;

    /* for simulation only (real DUT generates this itself) */
    reg  trigger_clk;

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
    reg  [7:0] dummy;
    reg  [7:0] data;
    reg  [7:0] expected_data;
    reg  [7:0] stream_code;
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

    parameter pNUM_TRIGGER_PULSES = 8;


   initial begin
      seed = pSEED;
      $display("Running with pSEED=%0d", pSEED);
      $urandom(seed);
      if (pDUMP) begin
         $dumpfile("results/tb.fst");
         $dumpvars(0, tb_pw);
      end
      usb_clk = 1'b1;
      fe_clk = 1'b1;
      trigger_clk = 1'b1;
      reset = 1'b0;
      num_triggers = $urandom_range(pNUM_TRIGGERS_MIN, pNUM_TRIGGERS_MAX);

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
   end

   int i;
   int txindex;
   int rx_dataindex;
   int rx_readindex;
   int send_iteration;
   int receive_iteration;
   int trigger_receive_iteration;
   int errors;
   int time_counter;
   string str;
   string rxalign = "                                            ";
   reg fe_data_event [0:pMAX_EVENTS-1];
   reg [7:0] fe_bytes [0:pMAX_EVENTS-1];
   reg [4:0] fe_stat [0:pMAX_EVENTS-1];
   reg [4:0] last_stat;
   reg [15:0] fe_times [0:pMAX_EVENTS-1];
   reg [15:0] last_pattern_match_delay;
   reg [7:0] sniff_bytes [0:7];
   reg [7:0] match_pattern [0:pPATTERN_BYTES_MAX-1];
   reg [7:0] match_mask [0:pPATTERN_ACTUAL_SIZE-1];
   int pattern_bytes;
   int pretrig_bytes;
   bit armed;
   bit overflow_noted;
   bit pattern_match_marker;
   bit checking_pulses;
   reg [7:0] stat_pattern;
   reg [7:0] stat_mask;
   reg stat_matched;
   reg [4:0] stat_matched_value;
   reg [15:0] max_timestamp;

   int matchtime;
   int triggertime;
   int rx_trigger_delay;
   int rx_trigger_width;
   int trigger_delay [0:pNUM_TRIGGER_PULSES-1];
   int trigger_width [0:pNUM_TRIGGER_PULSES-1];
   int capture_delay;
   int num_triggers;

   reg fifo_stat_empty;
   reg fifo_stat_underflow;
   reg fifo_stat_empty_threshold;
   reg fifo_stat_full;
   reg fifo_stat_overflow_blocked;
   //reg fifo_stat_full_threshold;
   reg fifo_stat_capture_done;

   // timeout thread:
   initial begin
      #(pFE_CLOCK_PERIOD*pTIMEOUT);
      errors += 1;
      $display("ERROR: global timeout");
      $display("SIMULATION FAILED (%0d errors).", errors);
      $finish;
   end

   // heartbeat indicator for long tests that have no activity:
   initial begin
      while (1) begin
         #(pFE_CLOCK_PERIOD*pTIMEOUT/20);
         $display(":hearbeat:time:%0t", $time);
      end
   end


   reg [7:0] rdata;
   // FE feeding thread:
   initial begin
      errors = 0;
      pattern_match_marker = 0;
      #(pFE_CLOCK_PERIOD*100);

      write_1byte(`USB_REG_SELECT, `REG_USERIO_PWDRIVEN, 8'hff);
      write_1byte(`USB_REG_SELECT, `REG_USERIO_DATA, 8'ha5);
      repeat (10) @(posedge usb_clk);
      write_1byte(`USB_REG_SELECT, `REG_USERIO_PWDRIVEN, 8'hf0);
      repeat (10) @(posedge usb_clk);
      write_1byte(`USB_REG_SELECT, `REG_USERIO_PWDRIVEN, 8'h0f);


      write_1byte(`MAIN_REG_SELECT, `REG_COUNT_WRITES, 1);
      read_1byte(`MAIN_REG_SELECT, `REG_COUNT_WRITES, rdata);

      write_1byte(`USB_REG_SELECT, `REG_PATTERN_BYTES, 8'haa);
      read_1byte(`USB_REG_SELECT, `REG_PATTERN_BYTES, rdata);

      max_timestamp = $urandom_range('h08, pMAX_TIMESTAMP);
      $display("Setting max timestamp to %h", max_timestamp);
      rw_lots_bytes(`MAIN_REG_SELECT, `REG_MAX_TIMESTAMP);
      write_next_byte(max_timestamp & 255);
      write_next_byte((max_timestamp >> 8) & 255);

      write_1byte(`MAIN_REG_SELECT, `REG_TRIGGER_ENABLE, pTRIGGER_ENABLE);
      write_1byte(`MAIN_REG_SELECT, `REG_COUNT_WRITES, 1);
      rw_lots_bytes(`MAIN_REG_SELECT, `REG_CAPTURE_LEN);
      if (pNO_CAPTURE_LIMIT) begin
         write_next_byte(0);
         write_next_byte(0);
         write_next_byte(0);
         write_next_byte(0);
      end
      else begin
      end
         write_next_byte(pNUM_EVENTS & 255);
         write_next_byte((pNUM_EVENTS >> 8) & 255);
         write_next_byte((pNUM_EVENTS >> 16) & 255);
         write_next_byte((pNUM_EVENTS >> 24) & 255);

         write_next_byte(trigger_width[i] & 255);
         write_next_byte((trigger_width[i] >> 8) & 255);
         write_next_byte((trigger_width[i] >> 16) & 255);

      if (pVERBOSE) begin
         $display("---------------------------------------------|-------------------------------");
         $display("FE testbench sending:                        | PhyWhisperer DUT receiving:");
         $display("---------------------------------------------|-------------------------------");
      end

      last_stat = 0;
      for (send_iteration = 0; send_iteration < pNUM_REPEATS; send_iteration = send_iteration + 1) begin
         armed = 0;
         $display("\nTx Iteration %d:", send_iteration);

         stat_matched = 0;
         set_stat_pattern();
         set_pattern();
         if (pTRIGGER_ENABLE)
            set_trigger();

         write_1byte(`MAIN_REG_SELECT, `REG_ARM, 8'h99);
         armed = 1;
         // give some time for the arm process to complete:
         if (pPRETRIG_BYTES_MIN < 10)
            repeat (10) @(posedge fe_clk);

         @(posedge fe_clk);

         // sending data moved to tasks to keep for loop readable:
         send_pre_pm_data();
         send_pattern_match_data();
         send_pre_trigger_data();
         send_capture_data();

         // sync up with receive block:
         wait (rx_readindex >= pNUM_EVENTS);
         check_stat_pattern();
         if (pTRIGGER_ENABLE)
            wait (trigger_receive_iteration == send_iteration + 1); // needed for very long triggers!

      end

      if (receive_iteration < send_iteration) begin
         $display("ERROR: simulation finished but receive thread did not complete its iterations: rx iteration=%0d, tx iteration=%0d", 
                  receive_iteration, send_iteration);
         errors += 1;
      end

      if (rx_readindex < txindex) begin
         $display("ERROR: simulation finished but not all data was received: rx index=%0d, tx index=%0d", rx_readindex, txindex);
         errors += 1;
      end

      if (errors)
         $display("SIMULATION FAILED (%0d errors).", errors);
      else
         $display("Simulation passed!");
      $finish;
   end


   // Trigger check thread:
   initial begin
      int i;
      checking_pulses = 0;
      if (pTRIGGER_ENABLE) begin
         # 1; // wait for num_triggers to get set
         for (trigger_receive_iteration = 0; trigger_receive_iteration < pNUM_REPEATS; trigger_receive_iteration = trigger_receive_iteration + 1) begin
            wait (pattern_match_marker == 1'b1);
            checking_pulses = 1;
            matchtime = $time;
            for (i = 0; i < num_triggers; i = i + 1) begin
               wait (cw_trig == 1'b1);
               triggertime = $time;
               wait (cw_trig == 1'b0);
               rx_trigger_delay = (triggertime - matchtime) / (pFE_CLOCK_PERIOD/4);
               if (i == 0)
                  rx_trigger_delay -= 18; // Additional 18 cycle delay is inherent to the current design. 8 of the 18 is because
                                          // we start measuring time when the pattern match data is *sent*.
               rx_trigger_width = ($time - triggertime) / (pFE_CLOCK_PERIOD/4);
               if ( (rx_trigger_delay == trigger_delay[i]) && (rx_trigger_width == trigger_width[i]) )
                  $display("%sTrigger #%0d: delay=%0d, width=%0d", rxalign, trigger_receive_iteration, rx_trigger_delay, rx_trigger_width);
               else begin
                  $display("%s*** ERROR Trigger #%0d: delay=%0d (expected %0d) width=%0d (expected %0d)", rxalign, trigger_receive_iteration, rx_trigger_delay,
                                                                                                          trigger_delay[i], rx_trigger_width, trigger_width[i]);
                  errors += 1;
               end
               matchtime = $time;
            end
            wait (pattern_match_marker == 1'b0);
            checking_pulses = 0;
         end
      end
   end

   // check cw_trig outside of trigger pulses:
   always @(*) begin
      if (checking_pulses == 0) begin
         if (cw_trig) begin
            $display("ERROR: cw_trig is high when it shouldn't be, time=%0t", $time);
            errors += 1;
         end
      end
   end


   // FIFO read thread:
   initial begin
      //if (pACTION == `PM_CAPTURE) begin
         for (receive_iteration = 0; receive_iteration < pNUM_REPEATS; receive_iteration = receive_iteration + 1) begin
            $display("Rx Iteration %d:", receive_iteration);
            rx_dataindex = 0;
            time_counter = 0;
            fifo_stat_overflow_blocked = 0;
            overflow_noted = 0;
            // sync up with transmit block:
            wait(send_iteration == receive_iteration);
            wait(armed);
            wait_fifo_empty();

            if (pREAD_CONCURRENTLY == 0) begin
               wait_fifo_not_empty();
               wait(txindex == pNUM_EVENTS); // TODO: txindex is used for several things, this may not be robust, should use a 'tx_done' flag instead
               #(pFE_CLOCK_PERIOD*100);
            end

            if ( (pREAD_CONCURRENTLY == 0) || (pSTREAM_MODE == 1) )
               rw_lots_bytes(`MAIN_REG_SELECT, `REG_SNIFF_FIFO_RD);

            for (rx_readindex = 0; rx_readindex < pNUM_EVENTS; rx_readindex = rx_readindex + 1) begin
               if ( !((pREAD_CONCURRENTLY == 0) || (pSTREAM_MODE == 1)) ) begin
                  wait_fifo_not_empty();
                  rw_lots_bytes(`MAIN_REG_SELECT, `REG_SNIFF_FIFO_RD);
               end

               read_next_fifo_word();

               if (pSTREAM_MODE && fifo_stat_overflow_blocked) begin
                  if (!overflow_noted) begin
                     $display("%s*** Received overflow flag, will read FIFO until empty\n", rxalign);
                     overflow_noted = 1;
                     if (pOVERFLOW_EXPECTED == 0) begin
                        errors += 1;
                        $display("*** ERROR: overflow was not expected for this testcase!");
                     end
                  end
                  if (fifo_stat_empty_threshold) begin
                     rx_readindex = pNUM_EVENTS - 1;
                     $display("%s*** Emptied FIFO after overflow, stopping read.\n", rxalign);
                  end
               end
               else if (fifo_stat_underflow | fifo_stat_overflow_blocked) begin
                  $display("%s*** ERROR on read #%0d at time %0t: underflow=%d, overflow=%d", rxalign, rx_dataindex, $time, fifo_stat_underflow, fifo_stat_overflow_blocked);
                  errors += 1;
               end


               if ( (command == `FE_FIFO_CMD_DATA) || (command == `FE_FIFO_CMD_STAT) ) begin
                  check_rx_data(); // moved to task to keep for loop readable
                  rx_dataindex = rx_dataindex + 1;
               end


               else if (command == `FE_FIFO_CMD_TIME) begin
                  timestamp = read_data[`FE_FIFO_TIME_START +: `FE_FIFO_FULLTIME_LEN];
                  time_counter = time_counter + timestamp;
                  if (pVERBOSE && pSHOW_TIME_EVENTS)
                     $display("%stime=%0d", rxalign, timestamp);
               end


               else if (command == `FE_FIFO_CMD_STRM) begin
                  // we haven't actually consumed anything from the FIFO, so don't increment index:
                  rx_readindex -= 1;
                  stream_code = read_data[`FE_FIFO_DATA_START +: `FE_FIFO_DATA_LEN];
                  if (pVERBOSE)
                     $display("%sstream code=%0d", rxalign, stream_code);
               end


               else begin
                  errors += 1;
                  $display("%s*** ERROR: Unknown command!", rxalign);
               end

            end
         end
      //end
   end


   reg read_select;

   assign USB_Data = read_select? 8'bz : USB_wdata;
   assign fe_data = fe_wdata;
   assign USB_SPARE0 = reset;

   always @(*) begin
      if (USB_nWE == 1'b0)
         read_select = 1'b0;
      else if (USB_nRD == 1'b0)
         read_select = 1'b1;
   end

   task write_1byte;
      input [1:0] block;
      input [5:0] address;
      input [7:0] data;
      @(posedge usb_clk);
      USB_SPARE1 = 0;
      USB_Addr = {block, address};
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
      @(posedge usb_clk);
   endtask



   task read_1byte;
      input [1:0] block;
      input [5:0] address;
      output [7:0] data;
      @(posedge usb_clk);
      USB_SPARE1 = 0;
      USB_Addr = {block, address};
      @(posedge usb_clk);
      USB_SPARE1 = 1;
      repeat(2) @(posedge usb_clk);
      USB_nRD = 0;
      USB_nCS = 0;
      @(posedge usb_clk);
      USB_nCS = 1;
      //data = USB_Data;
      @(posedge usb_clk);
      @(posedge usb_clk);
      USB_nRD = 1;
      #1 data = USB_Data;
      @(posedge usb_clk);
   endtask

   task rw_lots_bytes;
      input [1:0] block;
      input [5:0] address;
      @(posedge usb_clk);
      USB_SPARE1 = 0;
      USB_Addr = {block, address};
      @(posedge usb_clk);
      USB_SPARE1 = 1;
      repeat(2) @(posedge usb_clk);
      if (pSLOW_READS)
         repeat($urandom_range(2, 20)) @(posedge usb_clk);
   endtask

   task read_next_byte;
      output [7:0] data;
      USB_nRD = 0;
      USB_nCS = 0;
      @(posedge usb_clk);
      USB_nCS = 1;
      @(posedge usb_clk);
      @(posedge usb_clk);
      USB_nRD = 1;
      #1 data = USB_Data;
      repeat (2) @(posedge usb_clk);
      if (pSLOW_READS)
         repeat($urandom_range(2, 20)) @(posedge usb_clk);
   endtask

   task write_next_byte;
      input [7:0] data;
      USB_wdata = data;
      USB_nWE = 0;
      @(posedge usb_clk);
      USB_nWE = 1;
      USB_nCS = 0;
      @(posedge usb_clk);
      USB_nCS = 1;
      @(posedge usb_clk);
   endtask


   task send_fe_data;
      input [31:0] index;
      input rxvalid;
      input [7:0] data;
      input [4:0] stat;
      input [15:0] delay;
      fe_rxvalid = rxvalid;
      fe_wdata = data;
      fe_rxactive = stat[`FE_FIFO_RXACTIVE_BIT - `FE_FIFO_USB_STATUS_BITS_START];
      fe_rxerror = stat[`FE_FIFO_RXERROR_BIT - `FE_FIFO_USB_STATUS_BITS_START];
      fe_sessvld = stat[`FE_FIFO_SESSVLD_BIT - `FE_FIFO_USB_STATUS_BITS_START];
      fe_sessend = stat[`FE_FIFO_SESSEND_BIT - `FE_FIFO_USB_STATUS_BITS_START];
      fe_vbusvld = stat[`FE_FIFO_VBUSVLD_BIT - `FE_FIFO_USB_STATUS_BITS_START];

      @(posedge fe_clk);
      if (delay > 0) begin
         fe_rxvalid = 0;
         fe_wdata = 0;
      end
      repeat (delay) @(posedge fe_clk);

      last_stat = stat;
      if (~stat_matched && ((stat & stat_mask) == (stat_pattern[4:0] & stat_mask[4:0])) ) begin
         stat_matched = 1;
         stat_matched_value = stat;
         if (pVERBOSE)
            $display("Matching stat pattern: %h", stat);
      end

      if (pVERBOSE)
         if (rxvalid)
            $display("Write %4d DATA: data=%h, stat=%h, delay=%0d", index, data, stat, delay);
         else
            $display("Write %4d STAT:          stat=%h, delay=%0d", index, stat, delay);

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


   task set_trigger;
      int i;
      $display("Programming %0d trigger parameters for iteration #%0d", num_triggers, send_iteration);
      write_1byte(`MAIN_REG_SELECT, `REG_NUM_TRIGGERS, num_triggers);

      // trigger delays:
      rw_lots_bytes(`MAIN_REG_SELECT, `REG_TRIGGER_DELAY);
      for (i = 0; i < num_triggers; i = i + 1) begin
         trigger_delay[i] = $urandom_range(pTRIGGER_DELAY_MIN, pTRIGGER_DELAY_MAX);
         // zero-delay not allowed after first trigger:
         if ((i > 0) && (trigger_delay[i] == 0))
            trigger_delay[i] = 1;
         write_next_byte(trigger_delay[i] & 255);
         write_next_byte((trigger_delay[i] >> 8) & 255);
         write_next_byte((trigger_delay[i] >> 16) & 255);
         if (i == 0) begin
         end
      end

      // TODO: capture_delay independent of trigger_delay
      capture_delay = trigger_delay[0] >> 2;
      rw_lots_bytes(`USB_REG_SELECT, `REG_CAPTURE_DELAY);
      write_next_byte(capture_delay & 255);
      write_next_byte((capture_delay >> 8) & 255);
      write_next_byte((capture_delay >> 16) & 255);

      // trigger widths:
      rw_lots_bytes(`MAIN_REG_SELECT, `REG_TRIGGER_WIDTH);
      for (i = 0; i < num_triggers; i = i + 1) begin
         trigger_width[i] = $urandom_range(pTRIGGER_WIDTH_MIN, pTRIGGER_WIDTH_MAX);
         write_next_byte(trigger_width[i] & 255);
         write_next_byte((trigger_width[i] >> 8) & 255);
         write_next_byte((trigger_width[i] >> 16) & 255);
      end

      for (i = 0; i < num_triggers; i = i + 1)
         $display("Programming trigger #%0d: delay=%0d, width=%0d cycles", i, trigger_delay[i], trigger_width[i]);

   endtask


   task set_pattern;
      int i;
      pattern_bytes = $urandom_range(pPATTERN_BYTES_MIN, pPATTERN_BYTES_MAX);
      // first, zero out the full mask:
      for (i = 0; i < pPATTERN_ACTUAL_SIZE; i = i + 1)
         match_mask[i] = 0;

      rw_lots_bytes(`USB_REG_SELECT, `REG_PATTERN);
      for (i = 0; i < pattern_bytes; i = i + 1)
         match_pattern[i] = $urandom;
      for (i = pattern_bytes-1; i >= 0; i = i - 1)
         write_next_byte(match_pattern[i]);

      // generating and writing the mask is a bit convoluted, to make the hardware easier...
      // the actual mask needs to be *preceeded* by padded zeros
      for (i = pPATTERN_ACTUAL_SIZE-pattern_bytes; i < pPATTERN_ACTUAL_SIZE; i = i + 1) begin
         match_mask[i] = $urandom;
         //match_mask[i] = 8'h0f; // TODO: temp
         // things would get unnecessarily complex if the first mask byte could be 0, so prevent that:
         if (i == pPATTERN_ACTUAL_SIZE-pattern_bytes) begin
            while (match_mask[i] == 0)
               match_mask[i] = $urandom;
         end
      end
      rw_lots_bytes(`USB_REG_SELECT, `REG_PATTERN_MASK);
      for (i = pPATTERN_ACTUAL_SIZE-1; i >= 0; i = i - 1)
         write_next_byte(match_mask[i]);

      write_1byte(`USB_REG_SELECT, `REG_PATTERN_BYTES, pattern_bytes);

      $write("Pattern: ");
      for (i = 0; i < pattern_bytes; i = i + 1)
         $write("%h ", match_pattern[i]);
      $write("\nMask:    ");
      for (i = 0; i < pPATTERN_ACTUAL_SIZE; i = i + 1)
         $write("%h ", match_mask[i]);
      $write("\n");

   endtask


   task set_stat_pattern;
      stat_pattern = $urandom_range(0, 2**5-1);
      stat_mask = $urandom_range(1, 2**5-1);
      //stat_mask = 5'h1f;
      if (pVERBOSE)
         $display("Stat pattern=%h, mask=%h", stat_pattern, stat_mask);
      rw_lots_bytes(`USB_REG_SELECT, `REG_STAT_PATTERN);
      write_next_byte(stat_pattern);
      write_next_byte(stat_mask);
      if ((last_stat & stat_mask) == (stat_pattern[4:0] & stat_mask[4:0])) begin
         stat_matched = 1;
         stat_matched_value = last_stat;
         if (pVERBOSE)
            $display("Matching stat pattern immediately upon arming, from previous stat: %h", last_stat);
      end


   endtask


   task check_stat_pattern;
      rw_lots_bytes(`USB_REG_SELECT, `REG_STAT_MATCH);
      read_next_byte(read_data[7:0]);
      read_next_byte(read_data[15:8]);
      if (stat_matched != read_data[0]) begin
         $display("*** ERROR at %0t: expected stat_matched=%b, got %b", $time, stat_matched, read_data[0]);
         errors += 1;
      end
      if (stat_matched_value != read_data[12:8]) begin
         $display("*** ERROR at %0t: expected stat_matched_value=%h, got %h", $time, stat_matched_value, read_data[12:8]);
         errors += 1;
      end
   endtask


   task read_next_fifo_word;
      /* NOTE: FIFO read timing changed, used to be that last byte is dummy, now it's the first one
      read_next_byte(read_data[7:0]);
      read_next_byte(read_data[15:8]);
      read_next_byte(read_data[23:16]);
      read_next_byte(dummy);
      */
      read_next_byte(dummy);
      read_next_byte(read_data[7:0]);
      read_next_byte(read_data[15:8]);
      read_next_byte(read_data[23:16]);
      command = read_data[`FE_FIFO_CMD_START +: `FE_FIFO_CMD_BIT_LEN];

      fifo_stat_empty =           read_data[18+`FIFO_STAT_EMPTY];
      fifo_stat_underflow =       read_data[18+`FIFO_STAT_UNDERFLOW];
      fifo_stat_empty_threshold = read_data[18+`FIFO_STAT_EMPTY_THRESHOLD];
      fifo_stat_full =            read_data[18+`FIFO_STAT_FULL];
      fifo_stat_overflow_blocked= read_data[18+`FIFO_STAT_OVERFLOW_BLOCKED];
      //fifo_stat_full_threshold =  read_data[18+`FIFO_STAT_FULL_THRESHOLD];
      fifo_stat_capture_done =    read_data[18+`FIFO_STAT_CAPTURE_DONE];
   endtask


   task wait_fifo_empty;
      bit fifo_empty = 0;
      while (fifo_empty == 0) begin
         read_1byte(`MAIN_REG_SELECT, `REG_SNIFF_FIFO_STAT, fifo_empty);
      end
   endtask


   task wait_fifo_not_empty;
      bit fifo_empty = 1;
      read_1byte(`MAIN_REG_SELECT, `REG_SNIFF_FIFO_STAT, fifo_empty);
      while (fifo_empty == 1) begin
         read_1byte(`MAIN_REG_SELECT, `REG_SNIFF_FIFO_STAT, fifo_empty);
      end
   endtask


   task check_rx_data;
      data = read_data[`FE_FIFO_DATA_START +: `FE_FIFO_DATA_LEN];
      dut_rxactive = read_data[`FE_FIFO_RXACTIVE_BIT];
      dut_rxerror = read_data[`FE_FIFO_RXERROR_BIT];
      dut_sessvld = read_data[`FE_FIFO_SESSVLD_BIT];
      dut_sessend = read_data[`FE_FIFO_SESSEND_BIT];
      dut_vbusvld = read_data[`FE_FIFO_VBUSVLD_BIT];
      dut_usbstat = read_data[`FE_FIFO_USB_STATUS_BITS_START +: `FE_FIFO_USB_STATUS_BITS_LEN];

      if (command == `FE_FIFO_CMD_DATA) begin
         expected_data = fe_bytes[rx_dataindex];
         str = "DATA";
      end
      else begin
         expected_data = 8'd0;
         str = "STAT";
      end

      timestamp = read_data[`FE_FIFO_TIME_START +: `FE_FIFO_SHORTTIME_LEN];
      time_counter = time_counter + timestamp - 1;
      if ( (data == expected_data) && (dut_usbstat == fe_stat[rx_dataindex]) && (time_counter == fe_times[rx_dataindex]) ) begin
         if (pVERBOSE)
            $display("%sRead %4d: %s: data=%h, stat=%h, time=%0d, total time=%0d", rxalign, rx_dataindex, str, data, dut_usbstat, timestamp, time_counter);
      end
      else begin
         errors += 1;
         $display("%sRead %4d *** %s ERROR at time %0t:", rxalign, rx_dataindex, str, $time);
         if (data != expected_data)
            $display("%s     *** bad data (got %h expected %h)", rxalign, data, expected_data);
         if (dut_usbstat != fe_stat[rx_dataindex])
            $display("%s     *** bad stat (got %h expected %h)", rxalign, dut_usbstat, fe_stat[rx_dataindex]);
         if (time_counter != fe_times[rx_dataindex])
            $display("%s     *** bad time (got %d expected %d)", rxalign, time_counter, fe_times[rx_dataindex]);
      end
      time_counter = 0;
   endtask


   task send_pre_pm_data;
      pretrig_bytes = $urandom_range(pPRETRIG_BYTES_MIN, pPRETRIG_BYTES_MAX);
      $display("Sending pre-pattern-match data (%0d events):", pretrig_bytes);
      for (txindex = 0; txindex < pretrig_bytes; txindex = txindex + 1) begin
         fe_bytes[0] = $urandom;
         // ensure we aren't randomly matching the programmed pattern:
         while ( (fe_bytes[0] & match_mask[pPATTERN_ACTUAL_SIZE-pattern_bytes]) == 
                 (match_pattern[0] & match_mask[pPATTERN_ACTUAL_SIZE-pattern_bytes]) )
            fe_bytes[0] = $urandom;
         fe_stat[0] = $urandom;
         get_delay(fe_times[0]);
         get_valid(fe_data_event[0]);
         send_fe_data(txindex, fe_data_event[0], fe_bytes[0], fe_stat[0], fe_times[0]);
      end
      fe_rxvalid = 1'b0;
   endtask


   task send_pattern_match_data;
      int bitindex;
      $display("\nSending matching pattern (%0d bytes):", pattern_bytes);
      txindex = 0;
      while (txindex < pattern_bytes) begin
         fe_stat[0] = $urandom;
         get_delay(fe_times[0]);
         get_valid(fe_data_event[0]);
         if (fe_data_event[0]) begin
            fe_bytes[0] = match_pattern[txindex];
            // randomly flip bits that are masked out:
            for (bitindex = 0; bitindex < 7; bitindex = bitindex + 1) begin
               if (match_mask[pPATTERN_ACTUAL_SIZE-pattern_bytes+txindex][bitindex] == 1'b0)
                  fe_bytes[0][bitindex] = $urandom;
            end
            txindex = txindex + 1;
            if (txindex == pattern_bytes)
               pattern_match_marker = 1;
         end
         else
            fe_bytes[0] = $urandom;
         send_fe_data(txindex, fe_data_event[0], fe_bytes[0], fe_stat[0], fe_times[0]);
         last_pattern_match_delay = fe_times[0];
         pattern_match_marker = 0;
      end
      fe_rxvalid = 1'b0;
   endtask


   task send_pre_trigger_data;
      // send data that won't be captured because trigger hasn't occured yet:
      int remaining_cycles;
      txindex = 0;
      remaining_cycles = trigger_delay[0]/4 - last_pattern_match_delay;
      if (trigger_delay[0] > 0) begin
         $display("\nSending pre-trigger data (not captured):");
         // send data until the trigger activates:
         while (remaining_cycles > 0) begin
            fe_bytes[0] = $urandom;
            fe_stat[0] = $urandom;
            get_delay(fe_times[0]);
            if (fe_times[0] > remaining_cycles)
               fe_times[0] = remaining_cycles;
            get_valid(fe_data_event[0]);
            send_fe_data(txindex, fe_data_event[0], fe_bytes[0], fe_stat[0], fe_times[0]);
            remaining_cycles = remaining_cycles - fe_times[0] - 1; // delay of 0 consumes 1 clock cycle
            txindex += 1;
         end
      fe_rxvalid = 1'b0;

      end
      else
         $display("\nNo pre-trigger data.");
   endtask


   task send_capture_data;
      // send data that will be captured:
      get_delay(fe_times[0]);
      repeat (fe_times[0]) @(posedge fe_clk);
      fe_times[0] = 0; // by definition
      $display("\nSending data that will be captured:");
      for (txindex = 0; txindex < pNUM_EVENTS; txindex = txindex + 1) begin
         // Notes we are sending pNUM_EVENTS data/stat events; if large time deltas between events
         // generate TIME commands, then the number of events generated by the hardware will be greater
         // than pNUM_EVENTS!
         // To avoid over complicating the testbench, let's just accept this disparity.
         fe_bytes[txindex] = $urandom;
         fe_stat[txindex] = $urandom;
         get_delay(fe_times[txindex+1]);
         get_valid(fe_data_event[txindex]);
         // if rxvalid is low, then stat must change -- otherwise there is no event to pick up
         if (fe_data_event[txindex] == 0) begin
            while (fe_stat[txindex] == last_stat)
               fe_stat[txindex] = $urandom;
         end
         // TODO: consider driving fe_stat independently of fe_bytes?
         send_fe_data(txindex, fe_data_event[txindex], fe_bytes[txindex], fe_stat[txindex], fe_times[txindex+1]);
      end
      fe_rxvalid = 1'b0;
   endtask


   always #(pUSB_CLOCK_PERIOD/2) usb_clk = !usb_clk;
   always #(pFE_CLOCK_PERIOD/2) fe_clk = !fe_clk;
   always #(pFE_CLOCK_PERIOD/8) trigger_clk = !trigger_clk;

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

   wire [7:0] #1 USB_Addr_out   = USB_Addr;
   wire       #1 USB_nRD_out    = USB_nRD;
   wire       #1 USB_nWE_out    = USB_nWE;
   wire       #1 USB_nCS_out    = USB_nCS;
   wire       #1 USB_SPARE0_out = USB_SPARE0;
   wire       #1 USB_SPARE1_out = USB_SPARE1;


phywhisperer_top U_dut (
    /* USB CHIP CONNECTIONS */
    .usb_clk            (usb_clk        ),
    .USB_Data           (USB_Data       ),
    .USB_Addr           (USB_Addr_out   ),
    .USB_nRD            (USB_nRD_out    ),
    .USB_nWE            (USB_nWE_out    ),
    .USB_nCS            (USB_nCS_out    ),
    .USB_SPARE0         (USB_SPARE0_out ),
    .USB_SPARE1         (USB_SPARE1_out ),

    /* SIMULATION-ONLY PORTS */
    .I_trigger_clk      (trigger_clk),

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

