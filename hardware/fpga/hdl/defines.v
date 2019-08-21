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

`define REG_SNIFF_FIFO_RD            6'h01
`define REG_TIMESTAMPS_DISABLE       6'h02
`define REG_ARM                      6'h03
`define REG_PATTERN                  6'h04
`define REG_PATTERN_MASK             6'h05
`define REG_PATTERN_ACTION           6'h06
`define REG_PATTERN_BYTES            6'h07
`define REG_CAPTURE_LEN              6'h08
`define REG_SNIFF_FIFO_STAT          6'h09
`define REG_TRIGGER_DELAY            6'h0a
`define REG_TRIGGER_WIDTH            6'h0b
`define REG_USB_SPEED                6'h0c


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

// FIFO status register bits:
`define FIFO_STAT_EMPTY 0
`define FIFO_STAT_UNDERFLOW 1
`define FIFO_STAT_EMPTY_THRESHOLD 2
`define FIFO_STAT_FULL 3
`define FIFO_STAT_OVERFLOW_BLOCKED 4
`define FIFO_STAT_FULL_THRESHOLD 5

// USB speed definitions
`define USB_SPEED_AUTO 0
`define USB_SPEED_LS 1
`define USB_SPEED_FS 2
`define USB_SPEED_HS 3

