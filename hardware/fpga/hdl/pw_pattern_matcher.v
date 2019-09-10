`default_nettype none
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NewAE
// Engineer: Jean-Pierre Thibault
// 
// Create Date: 
// Design Name: 
// Module Name: pw_pattern_matcher
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


module pw_pattern_matcher #(
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

   // from capture block:
   input  wire  [7:0] I_fe_data,
   input  wire  I_fe_data_valid,
   input  wire  I_capturing,

   // to trigger block:
   output wire  O_match_trigger
);

   reg  [6:0] match_counter;
   reg  match_trigger;
   reg  match_trigger_r;
   reg  capturing_r;
   reg  arm_r;

   wire [7:0] masked_pattern_byte;
   wire [7:0] masked_pattern_first_byte;
   wire [7:0] masked_input_byte;
   wire [7:0] masked_input_first_byte;

   wire capture_done;
   wire trigger_pulse;

   (* ASYNC_REG = "TRUE" *) reg  [1:0] arm_pipe;
   (* ASYNC_REG = "TRUE" *) reg  [pPATTERN_BYTES*8-1:0] pattern_r;
   (* ASYNC_REG = "TRUE" *) reg  [pPATTERN_BYTES*8-1:0] mask_r;
   (* ASYNC_REG = "TRUE" *) reg  [7:0] pattern_bytes_r;

   assign masked_pattern_byte = pattern_r[8*match_counter +: 8] & mask_r[8*match_counter +: 8];
   assign masked_input_byte = I_fe_data & mask_r[8*match_counter +: 8];
   assign masked_pattern_first_byte = pattern_r[7:0] & mask_r[7:0];
   assign masked_input_first_byte = I_fe_data & mask_r[7:0];

   assign capture_done = (!I_capturing & capturing_r);
   always @ (posedge fe_clk) begin
      if (reset_i) begin
         match_counter <= 0;
         match_trigger <= 1'b0;
         match_trigger_r <= 1'b0;
         capturing_r <= 1'b0;
      end
      else begin
         match_trigger_r <= match_trigger;
         capturing_r <= I_capturing;

         // end of capture is a good time to reset these:
         if (match_trigger && capture_done) begin
            match_counter <= 0;
            match_trigger <= 1'b0;
         end

         else if (I_fe_data_valid && arm_r && (match_counter < pattern_bytes_r)) begin
            if (masked_pattern_byte == masked_input_byte)
               match_counter <= match_counter + 1;
            // maybe we thought we were onto a pattern match but actually the pattern match is starting NOW:
            else if (masked_pattern_first_byte == masked_input_first_byte)
               match_counter <= 1;
            else
               match_counter <= 0;

            if ( (match_counter == (pattern_bytes_r-1)) && 
                 ((masked_pattern_byte == masked_input_byte) || (masked_pattern_byte == masked_input_byte)) )
               match_trigger <= 1'b1;
            else
               match_trigger <= 1'b0;
         end

      end
   end

   assign O_match_trigger = match_trigger & !match_trigger_r;


   // CDC for inputs from register block. Single flop for quasi-static signals,
   // more for dynamic control signals.
   always @ (posedge trigger_clk) begin
      if (reset_i) begin
         pattern_r <= 0;
         mask_r <= 0;
         pattern_bytes_r <= 0;
         arm_pipe <= 0;
         arm_r <= 0;
      end
      else begin
         pattern_r <= I_pattern;
         mask_r <= I_mask;
         pattern_bytes_r <= I_pattern_bytes;
         {arm_r, arm_pipe} <= {arm_pipe, I_arm};
      end
   end


endmodule

`default_nettype wire
