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
   input  wire  usb_clk, // TODO: needed? try to have everything here in fe_clk domain

   // from register block:
   input  wire  I_arm,
   input  wire  [pPATTERN_BYTES*8-1:0] I_pattern,
   input  wire  [pPATTERN_BYTES*8-1:0] I_mask,
   input  wire  [1:0] I_action,
   input  wire  [7:0] I_pattern_bytes,

   // from capture block:
   input  wire  [7:0] I_fe_data,
   input  wire  I_fe_data_valid,
   input  wire  I_capturing,

   // from trigger block:
   input  wire  I_trigger_out,

   // to register block:
   output wire  O_match,

   // to capture block:
   output wire  O_match_capture,

   // to trigger block:
   output wire  O_match_trigger
);

   // simple: use a pattern match counter! just keep the logic generic for
   // re-use into DesignStart trace trigger

   reg  [6:0] match_counter;
   reg  match_trigger;
   reg  match_trigger_r;
   reg  capturing_r;

   wire [7:0] masked_pattern_byte;
   wire [7:0] masked_pattern_first_byte;
   wire [7:0] masked_input_byte;
   wire [7:0] masked_input_first_byte;

   wire capture_done;

   assign masked_pattern_byte = I_pattern[8*match_counter +: 8] & I_mask[8*match_counter +: 8];
   assign masked_input_byte = I_fe_data & I_mask[8*match_counter +: 8];
   assign masked_pattern_first_byte = I_pattern[7:0] & I_mask[7:0];
   assign masked_input_first_byte = I_fe_data & I_mask[7:0];

   // TODO: need some sort of "enable pattern matcher", to prevent reset values from triggering right away?
   // or just reset mask to all ones? or just rely on default action being NOP?

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
         if (match_trigger && (capture_done || I_trigger_out)) begin
            match_counter <= 0;
            match_trigger <= 1'b0;
         end

         else if (I_fe_data_valid && I_arm && (match_counter < I_pattern_bytes)) begin
            if (masked_pattern_byte == masked_input_byte)
               match_counter <= match_counter + 1;
            // maybe we thought we were onto a pattern match but actually the pattern match is starting NOW:
            else if (masked_pattern_first_byte == masked_input_first_byte)
               match_counter <= 1;
            else
               match_counter <= 0;

            if ( (match_counter == (I_pattern_bytes-1)) && 
                 ((masked_pattern_byte == masked_input_byte) || (masked_pattern_byte == masked_input_byte)) )
               match_trigger <= 1'b1;
            else
               match_trigger <= 1'b0;
         end

      end
   end

   assign O_match = match_trigger;// & !match_trigger_r;
   assign O_match_capture = O_match & (I_action == `PM_CAPTURE);
   assign O_match_trigger = match_trigger & !match_trigger_r & (I_action == `PM_TRIGGER);


endmodule

`default_nettype wire
