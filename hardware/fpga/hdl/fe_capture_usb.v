//////////////////////////////////////////////////////////////////////////////////
// Company: NewAE
// Engineer: Jean-Pierre Thibaut
// 
// Create Date: 
// Design Name: 
// Module Name: fe_capture_usb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Front-end module, USB-specific logic.
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
`include "defines_pw.v"

module fe_capture_usb #(
    parameter pTIMESTAMP_FULL_WIDTH = 16,
    parameter pTIMESTAMP_SHORT_WIDTH = 3,
    parameter pCAPTURE_LEN_WIDTH = 24
)(
    input  wire reset_i,

    /* FRONT END CONNECTIONS */
    input  wire fe_clk,
    input  wire [7:0] fe_data,
    input  wire fe_rxvalid,
    input  wire fe_rxactive,
    input  wire fe_rxerror,
    input  wire fe_sessvld,
    input  wire fe_vbusvld,
    input  wire fe_sessend,

    /* GENERIC FRONT END CONNECTIONS */
    output wire O_event,
    output wire [1:0] O_data_cmd,
    input  wire [pTIMESTAMP_FULL_WIDTH-1:0] I_fifo_time,
    input  wire [1:0] I_fifo_command,
    input  wire I_fifo_wr,
    output wire [15:0] O_max_short_timestamp,

    /* REGISTER CONNECTIONS */
    output wire [4:0] O_fifo_fe_status,

    /* FIFO CONNECTIONS */
    output reg [17:0] O_fifo_data,
    output reg  O_fifo_wr
);

    reg  fe_rxvalid_reg;
    reg  fe_rxvalid_reg2;
    reg  [7:0] fe_data_reg;
    reg  [7:0] fe_data_reg2;
    reg  [7:0] fe_data_reg3;

    wire [`FE_FIFO_USB_STATUS_BITS_LEN-1:0] fe_status_bits;
    reg  [`FE_FIFO_USB_STATUS_BITS_LEN-1:0] fe_status_bits_reg;
    reg  [`FE_FIFO_USB_STATUS_BITS_LEN-1:0] fe_status_bits_reg2;
    reg  [`FE_FIFO_USB_STATUS_BITS_LEN-1:0] fe_status_bits_reg3;

    wire usb_event; // rxvalid=1 or status bits changed

    wire [7:0] fifo_data;
    wire [4:0] fifo_fe_status;

    assign O_fifo_fe_status = fifo_fe_status;
    

    assign fe_status_bits[`FE_FIFO_RXACTIVE_BIT - `FE_FIFO_USB_STATUS_BITS_START] = fe_rxactive;
    assign fe_status_bits[`FE_FIFO_RXERROR_BIT  - `FE_FIFO_USB_STATUS_BITS_START] = fe_rxerror;
    assign fe_status_bits[`FE_FIFO_SESSVLD_BIT  - `FE_FIFO_USB_STATUS_BITS_START] = fe_sessvld;
    assign fe_status_bits[`FE_FIFO_SESSEND_BIT  - `FE_FIFO_USB_STATUS_BITS_START] = fe_sessend;
    assign fe_status_bits[`FE_FIFO_VBUSVLD_BIT  - `FE_FIFO_USB_STATUS_BITS_START] = fe_vbusvld;

    assign usb_event = fe_rxvalid || (fe_status_bits != fe_status_bits_reg);
    assign O_event = usb_event;


    assign O_data_cmd = fe_rxvalid_reg2? `FE_FIFO_CMD_DATA : `FE_FIFO_CMD_STAT;

    assign O_max_short_timestamp = 2**`FE_FIFO_SHORTTIME_LEN-1;

    // Delay incoming fe_* signals by one cycle to avoid issuing
    // FE_FIFO_CMD_STAT at the same time as an fe_* data event, which could
    // lead to tricky edge cases. Cost is some extra flops and a 1-cycle delay.
    always @ (posedge fe_clk) begin
       if (reset_i) begin
          fe_rxvalid_reg <= 1'b0;
          fe_rxvalid_reg2 <= 1'b0;
          fe_data_reg <= 8'd0;
          fe_data_reg2 <= 8'd0;
          fe_data_reg3 <= 8'd0;
          fe_status_bits_reg <= 5'd0;
          fe_status_bits_reg2 <= 5'd0;
          fe_status_bits_reg3 <= 5'd0;
       end
       else begin
          fe_rxvalid_reg <= fe_rxvalid;
          fe_rxvalid_reg2 <= fe_rxvalid_reg;
          fe_data_reg2 <= fe_data_reg;
          fe_data_reg3 <= fe_data_reg2;
          fe_status_bits_reg <= fe_status_bits;
          fe_status_bits_reg2 <= fe_status_bits_reg;
          fe_status_bits_reg3 <= fe_status_bits_reg2;
          if (fe_rxvalid)
             fe_data_reg <= fe_data;
       end
    end


    // note: it may be possible to tweak the FSM timing to avoid needing 3 sync stages?
    assign fifo_data = fe_data_reg3;
    assign fifo_fe_status = fe_status_bits_reg3;


   // FIFO write logic.
   // note: could maybe get away with combinatorial logic here?
   always @(posedge fe_clk) begin
      if (reset_i) begin
         O_fifo_wr <= 1'b0;
         O_fifo_data <= 0;
      end
      else begin
         if (I_fifo_wr) begin
            O_fifo_wr <= 1'b1;
            O_fifo_data[`FE_FIFO_CMD_START +: `FE_FIFO_CMD_BIT_LEN] <= I_fifo_command;
            case (I_fifo_command)
               `FE_FIFO_CMD_DATA: begin
                  O_fifo_data[`FE_FIFO_TIME_START +: `FE_FIFO_SHORTTIME_LEN] <= I_fifo_time[`FE_FIFO_SHORTTIME_LEN-1:0];
                  O_fifo_data[`FE_FIFO_DATA_START +: `FE_FIFO_DATA_LEN] <= fifo_data;
                  O_fifo_data[`FE_FIFO_USB_STATUS_BITS_START +: `FE_FIFO_USB_STATUS_BITS_LEN] <= fifo_fe_status;
               end
               `FE_FIFO_CMD_STAT: begin
                  O_fifo_data[`FE_FIFO_TIME_START +: `FE_FIFO_SHORTTIME_LEN] <= I_fifo_time[`FE_FIFO_SHORTTIME_LEN-1:0];
                  O_fifo_data[`FE_FIFO_DATA_START +: `FE_FIFO_DATA_LEN] <= 8'd0;
                  O_fifo_data[`FE_FIFO_USB_STATUS_BITS_START +: `FE_FIFO_USB_STATUS_BITS_LEN] <= fifo_fe_status;
               end
               `FE_FIFO_CMD_TIME: begin
                  O_fifo_data[`FE_FIFO_TIME_START +: `FE_FIFO_FULLTIME_LEN] <= I_fifo_time;
               end
            endcase
         end
         else
            O_fifo_wr <= 1'b0;
      end
   end


endmodule
`default_nettype wire
