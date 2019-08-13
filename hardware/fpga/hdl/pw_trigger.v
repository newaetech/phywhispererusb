`default_nettype none
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NewAE
// Engineer: Jean-Pierre Thibault
// 
// Create Date: 
// Design Name: 
// Module Name: pw_trigger
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


module pw_trigger #(
   parameter pTRIGGER_DELAY_WIDTH = 20,
   parameter pTRIGGER_WIDTH_WIDTH = 17

)(
   input  wire         reset_i,
   input  wire         trigger_clk,
   input  wire         fe_clk,
   output reg          O_trigger,

   // from register block:
   input  wire [pTRIGGER_DELAY_WIDTH-1:0] I_trigger_delay,
   input  wire [pTRIGGER_WIDTH_WIDTH-1:0] I_trigger_width,

   // from pattern match block:
   input  wire         I_match
);

   reg  [pTRIGGER_DELAY_WIDTH-1:0] delay_counter;
   reg  [pTRIGGER_WIDTH_WIDTH-1:0] width_counter;
   reg  delay_counter_running;
   reg  width_counter_running;
   wire match_pulse;

   `ifndef __ICARUS__

      // xpm_cdc_pulse: Pulse Transfer
      // Xilinx Parameterized Macro, version 2018.3
      // (reference: UG953)
      xpm_cdc_pulse #(
         .DEST_SYNC_FF(2),        // DECIMAL; range: 2-10
         .INIT_SYNC_FF(0),        // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
         .REG_OUTPUT(0),          // DECIMAL; 0=disable registered output, 1=enable registered output
         .RST_USED(1),            // DECIMAL; 0=no reset, 1=implement reset
         .SIM_ASSERT_CHK(0)       // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      )
      xpm_cdc_pulse_inst (
         .dest_pulse(match_pulse),// 1-bit output: Outputs a pulse the size of one dest_clk period when a pulse
                                  // transfer is correctly initiated on src_pulse input. This output is
                                  // combinatorial unless REG_OUTPUT is set to 1.
         .dest_clk(trigger_clk),  // 1-bit input: Destination clock.
         .dest_rst(reset_i),      // 1-bit input: optional; required when RST_USED = 1
         .src_clk(fe_clk),        // 1-bit input: Source clock.
         .src_pulse(I_match),     // 1-bit input: Rising edge of this signal initiates a pulse transfer to the
                                  // destination clock domain. The minimum gap between each pulse transfer must be
                                  // at the minimum 2*(larger(src_clk period, dest_clk period)). This is measured
                                  // between the falling edge of a src_pulse to the rising edge of the next
                                  // src_pulse. This minimum gap will guarantee that each rising edge of src_pulse
                                  // will generate a pulse the size of one dest_clk period in the destination
                                  // clock domain. When RST_USED = 1, pulse transfers will not be guaranteed while
                                  // src_rst and/or dest_rst are asserted.
         .src_rst(reset_i)        // 1-bit input: optional; required when RST_USED = 1
      );
      // End of xpm_cdc_pulse_inst instantiation
   `else
      assign match_pulse = I_match;
   `endif


   `ifdef ILA_TRIG
      reg match_r;
      reg [pTRIGGER_DELAY_WIDTH-1:0] trigger_delay_r;
      reg [pTRIGGER_WIDTH_WIDTH-1:0] trigger_width_r;
      always @ (posedge trigger_clk) begin
         if (reset_i) begin
            match_r <= 1'b0;
            trigger_delay_r <= 0;
            trigger_width_r <= 0;
         end
         else begin
            match_r <= I_match;
            trigger_delay_r <= I_trigger_delay;
            trigger_width_r <= I_trigger_width;
         end
      end
      ila_4 I_ila_trigger (
         .clk          (trigger_clk),           // input wire clk
         .probe0       (match_r),               // input wire [0:0]  probe0  
         .probe1       (delay_counter),         // input wire [19:0]  probe1 
         .probe2       (width_counter),         // input wire [16:0]  probe2 
         .probe3       (trigger_delay_r),       // input wire [19:0]  probe3 
         .probe4       (trigger_width_r),       // input wire [16:0]  probe4 
         .probe5       (delay_counter_running), // input wire [0:0]  probe5 
         .probe6       (width_counter_running), // input wire [0:0]  probe6 
         .probe7       (O_trigger),             // input wire [0:0]  probe7 
         .probe8       (match_pulse)            // input wire [0:0]  probe8 
      );
   `endif


   // TODO: CDC on I_match; ideally getting a single-cycle pulse, will prevent two triggers from being issued
   // within a single 4-cycle I_match pulse
   always @ (posedge trigger_clk) begin
      if (reset_i) begin
         delay_counter <= 0;
         delay_counter_running <= 1'b0;
         width_counter <= 1;
         width_counter_running <= 1'b0;
         O_trigger <= 1'b0;
      end

      else begin
         if (O_trigger) 
            delay_counter_running <= 1'b0;
         else if (match_pulse) 
            delay_counter_running <= 1'b1;


         if (O_trigger && (width_counter == I_trigger_width)) begin
            width_counter_running <= 1'b0;
            O_trigger <= 1'b0;
         end
         else if (delay_counter_running) begin
            if ((delay_counter < I_trigger_delay) & ~O_trigger)
               delay_counter <= delay_counter + 1;
            else begin
               delay_counter <= 0;
               width_counter_running <= 1'b1;
               O_trigger <= 1'b1;
            end
         end


         if (width_counter_running) begin
            if (width_counter < I_trigger_width)
               width_counter <= width_counter + 1;
            else
               width_counter <= 1;
         end

      end
   end


endmodule

`default_nettype wire
