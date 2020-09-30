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

module usb_autodetect #(
    parameter pCOUNTER_WIDTH = 24
)(
    /* FRONT END CONNECTIONS */
    input  wire reset_i,
    input  wire fe_clk,
    input  wire cwusb_clk,
    input  wire fe_linestate0,
    input  wire fe_linestate1,

    /* REGISTER CONNECTIONS */
    input  wire I_restart,
    input  wire [pCOUNTER_WIDTH-1:0] I_wait1,
    input  wire [pCOUNTER_WIDTH-1:0] I_wait2,
    output reg  [1:0] O_speed
);

    reg  [2:0] state, next_state, state_r;
    localparam pS_IDLE = 0;
    localparam pS_LS = 1;
    localparam pS_FS = 2;
    localparam pS_HS = 3;
    localparam pS_DONE = 4;
    localparam pS_ERROR = 5;
    localparam pS_FSHS = 6;
    localparam pS_WAIT_LOW = 7;

    reg  [pCOUNTER_WIDTH-1:0] timer;
    wire restart;

    wire [1:0] linestate = {fe_linestate1, fe_linestate0};

    (* ASYNC_REG = "TRUE" *) reg [pCOUNTER_WIDTH-1:0] wait1;
    (* ASYNC_REG = "TRUE" *) reg [pCOUNTER_WIDTH-1:0] wait2;

    // strictly for easier visualization/debug:
    wire state_idle = (state == pS_IDLE);
    wire state_ls   = (state == pS_LS);
    wire state_fshs = (state == pS_FSHS);
    wire state_fs   = (state == pS_FS);
    wire state_hs   = (state == pS_HS);
    wire state_wait = (state == pS_WAIT_LOW);
    wire state_done = (state == pS_DONE);
    wire state_error = (state == pS_ERROR);


    // FSM:
    always @ (posedge fe_clk) begin
       if (reset_i)
          state <= pS_IDLE;
       else
          state <= next_state;
    end
    always @(*) begin
       case (state)

          pS_IDLE: begin
             if (linestate == 2'b10)
                next_state = pS_LS;
             else if (linestate == 2'b01)
                next_state = pS_FSHS;
             else
                next_state = pS_IDLE;
          end


          pS_LS: begin
             if (linestate != 2'b10)
                next_state = pS_ERROR;
             else if (timer == wait1)
                next_state = pS_DONE;
             else
                next_state = pS_LS;
          end


          pS_FSHS: begin
             if (linestate != 2'b01)
                next_state = pS_ERROR;
             else if (timer == wait1)
                next_state = pS_WAIT_LOW;
             else
                next_state = pS_FSHS;
          end


          pS_WAIT_LOW: begin
             if (linestate == 2'b01)
                next_state = pS_WAIT_LOW;
             else if (linestate == 2'b00)
                next_state = pS_HS;
             else
                next_state = pS_ERROR;
          end


          pS_HS: begin
             if (timer == wait2)
                next_state = pS_DONE;
             else if (linestate == 2'b01)
                next_state = pS_FS;
             else if (linestate == 2'b10)
                next_state = pS_ERROR;
             else
                next_state = pS_HS;
          end


          pS_FS: begin
             next_state = pS_DONE;
          end


          pS_DONE: begin
             if (restart)
                next_state = pS_IDLE;
             else
                next_state = pS_DONE;
          end


          pS_ERROR: begin
             next_state = pS_IDLE;
          end


          default: begin
             next_state = pS_IDLE;
          end


       endcase
    end


    // Timer:
    always @(posedge fe_clk) begin
       if (reset_i) begin
          timer <= 0;
       end
       else begin
          if ( (state == pS_IDLE) || (state == pS_WAIT_LOW) || restart)
             timer <= 0;
          else if ( (state == pS_LS) || (state == pS_FSHS)  || (state == pS_HS) )
             timer <= timer + 1;
       end
    end

    // announce speed:
    always @ (posedge fe_clk) begin
       if (reset_i) begin
          state_r <= 0;
          O_speed <= `USB_SPEED_AUTO;
       end
       else begin
          state_r <= state;
          if (state_idle | state_error)
             O_speed <= `USB_SPEED_AUTO;
          else if (state_done) begin
             if (state_r == pS_LS)
                O_speed <= `USB_SPEED_LS;
             else if (state_r == pS_FS)
                O_speed <= `USB_SPEED_FS;
             else if (state_r == pS_HS)
                O_speed <= `USB_SPEED_HS;
          end
       end
    end


    // CDC:
    cdc_pulse U_match_cdc (
       .reset_i       (reset_i),
       .src_clk       (cwusb_clk),
       .src_pulse     (I_restart),
       .dst_clk       (fe_clk),
       .dst_pulse     (restart)
    );

    always @ (posedge fe_clk) begin
       wait1 <= I_wait1;
       wait2 <= I_wait2;
    end


   `ifdef ILA_USB_AUTODETECT
      ila_5 I_ila_autodetect (
         .clk          (fe_clk),           // input wire clk
         .probe0       (state_idle),            // input wire [0:0]  probe0  
         .probe1       (state_ls),              // input wire [0:0]  probe1 
         .probe2       (state_fs),              // input wire [0:0]  probe2 
         .probe3       (state_hs),              // input wire [0:0]  probe3 
         .probe4       (state_done),            // input wire [0:0]  probe4 
         .probe5       (state_error),           // input wire [0:0]  probe5 
         .probe6       (fe_linestate0),         // input wire [0:0]  probe6 
         .probe7       (fe_linestate1),         // input wire [0:0]  probe7 
         .probe8       (O_speed),               // input wire [1:0]  probe8 
         .probe9       (timer[15:0]),           // input wire [15:0]  probe9 
         .probe10      (state_fshs),            // input wire [0:0]  probe10 
         .probe11      (state_wait),            // input wire [0:0]  probe11 
         .probe12      (restart)                // input wire [0:0]  probe12 
      );
   `endif


endmodule
`default_nettype wire
