//////////////////////////////////////////////////////////////////////////////////
// Company: NewAE
// Engineer: Jean-Pierre Thibault
// 
// Create Date: 
// Design Name: 
// Module Name: 
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

`define REG_TEST                     6'h00
`define REG_SNIFF_FIFO_RD            6'h01
`define REG_TIMESTAMPS_DISABLE       6'h02
`define REG_ARM                      6'h03
`define REG_FE                       6'h04
`define REG_FE_SNIFF                 6'h05
`define REG_FE_WR_CNT                6'h06
`define REG_USB_RD_CNT               6'h07
`define USB_RD_CNT_CLR               6'h08
`define FE_WR_CNT_CLR                6'h09
`define REG_PATTERN                  6'h0a
`define REG_PATTERN_MASK             6'h0b
`define REG_PATTERN_ACTION           6'h0c
`define REG_PATTERN_BYTES            6'h0d
`define REG_CAPTURE_LEN              6'h0e

`define REG_TEST_LEN                 4
`define REG_FE_LEN                   1
`define REG_FE_SNIFF_LEN             8
`define REG_FE_WR_CNT_LEN            4
`define REG_USB_RD_CNT_LEN           4
`define REG_SNIFF_FIFO_RD_LEN        1

// FIFO bitfields:
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

// pattern match action definitions:
`define PM_NOP 0
`define PM_CAPTURE 1
`define PM_TRIGGER 2

