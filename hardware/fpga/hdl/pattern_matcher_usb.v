`default_nettype none
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NewAE
// Engineer: Jean-Pierre Thibault
// 
// Create Date: 
// Design Name: 
// Module Name: pattern_matcher_usb
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


module pattern_matcher_usb #(
   parameter pPATTERN_BYTES = 8
)(
   input  wire  reset_i,
   input  wire  fe_clk,
   input  wire  trigger_clk,

   // from register block:
   input  wire  I_arm,
   input  wire  [pPATTERN_BYTES*8-1:0] I_pattern,
   input  wire  [pPATTERN_BYTES*8-1:0] I_mask,
   input  wire  [7:0] I_pattern_bytes,
   input  wire  [15:0] I_num_triggers,
   output wire  [15:0] O_num_triggers,

   // from capture block:
   input  wire  [7:0] I_fe_data,
   input  wire  I_fe_data_valid,

   // to trigger block:
   output wire  O_match_trigger,

   // to register block:
   output wire  O_disarm_pulse

);

   // -1 here because we compare the incoming data byte immediately:
   reg  [(pPATTERN_BYTES-1)*8-1:0] input_data;
   wire [(pPATTERN_BYTES-1)*8-1:0] masked_input;

   wire [pPATTERN_BYTES*8-1:0] masked_pattern;

   reg  match_trigger;
   reg  match_trigger_r;
   reg  arm_r, arm_r2;
   reg  done, done_r;
   reg  [15:0] triggers;

   wire [7:0] masked_input_byte;


   (* ASYNC_REG = "TRUE" *) reg  [1:0] arm_pipe;
   (* ASYNC_REG = "TRUE" *) reg  [pPATTERN_BYTES*8-1:0] pattern_r;
   (* ASYNC_REG = "TRUE" *) reg  [pPATTERN_BYTES*8-1:0] mask_r;
   (* ASYNC_REG = "TRUE" *) reg  [7:0] pattern_bytes_r;

   reg  [7:0] bytes_received;
   reg  [7:0] fe_data;
   reg  fe_data_valid;

   // just for easier debugging:
   wire [31:0]  masked_input_first_bytes = {masked_input[23:0], masked_input_byte};
   wire [31:0]  masked_pattern_first_bytes = masked_pattern[31:0];

   assign masked_input_byte = fe_data & mask_r[7:0];

   assign masked_input = input_data & mask_r[pPATTERN_BYTES*8-1:8];
   assign masked_pattern = pattern_r & mask_r;

   assign O_num_triggers = triggers;

   always @ (posedge fe_clk) begin
      if (reset_i) begin
         match_trigger <= 1'b0;
         match_trigger_r <= 1'b0;
         input_data <= 0;
         bytes_received <= 0;
         fe_data <= 0;
         fe_data_valid <= 0;
         done <= 0;
         done_r <= 0;
      end
      else begin
         match_trigger_r <= match_trigger;
         done_r <= done;

         if (I_fe_data_valid) begin
            fe_data_valid <= 1'b1;
            fe_data <= I_fe_data;
         end
         else
            fe_data_valid <= 1'b0;

         // count triggers to determine if done:
         if (arm_r && ~arm_r2) begin
             done <= 1'b0;
             triggers <= 1;
         end
         else if (O_match_trigger && ~done) begin
             triggers <= triggers + 1;
             if ((triggers == I_num_triggers) && (I_num_triggers < {16{1'b1}}))
                 done <= 1'b1;
         end

         // reset upon arming:
         if (arm_r && ~arm_r2) begin
            match_trigger <= 1'b0;
            input_data <= 0;
            bytes_received <= 0;
         end

         else if (fe_data_valid && arm_r && ~done) begin
            input_data <= {input_data[pPATTERN_BYTES*8-17:0], fe_data};
            if (bytes_received < 8'hff)
               bytes_received <= bytes_received + 1;
            // don't wait for the incoming data byte to be stored, compare immediately:
            if ( ({masked_input, masked_input_byte} == masked_pattern) &&
                 (bytes_received >= pattern_bytes_r-1) )
               match_trigger <= 1'b1;
            else
               match_trigger <= 1'b0;
         end
      end
   end

   assign O_match_trigger = match_trigger & !match_trigger_r;
   assign O_disarm_pulse = done && ~done_r;


   // CDC for inputs from register block. Single flop for quasi-static signals,
   // more for dynamic control signals.
   always @ (posedge fe_clk) begin
      if (reset_i) begin
         pattern_r <= 0;
         mask_r <= 0;
         pattern_bytes_r <= 0;
         arm_pipe <= 0;
         arm_r <= 0;
         arm_r2 <= 0;
      end
      else begin
         pattern_r <= I_pattern;
         mask_r <= I_mask;
         pattern_bytes_r <= I_pattern_bytes;
         {arm_r2, arm_r, arm_pipe} <= {arm_r, arm_pipe, I_arm};
      end
   end


endmodule

`default_nettype wire
