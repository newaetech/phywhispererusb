// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Tue Dec 14 16:42:17 2021
// Host        : red running 64-bit Ubuntu 18.04.6 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/jpnewae/git/phywhispererusb/hardware/fpga/vivado/pw_fpga.srcs/sources_1/ip/ila_2/ila_2_stub.v
// Design      : ila_2
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s15ftgb196-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2020.2" *)
module ila_2(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6, probe7, probe8, probe9)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[7:0],probe1[6:0],probe2[7:0],probe3[7:0],probe4[0:0],probe5[0:0],probe6[0:0],probe7[7:0],probe8[0:0],probe9[7:0]" */;
  input clk;
  input [7:0]probe0;
  input [6:0]probe1;
  input [7:0]probe2;
  input [7:0]probe3;
  input [0:0]probe4;
  input [0:0]probe5;
  input [0:0]probe6;
  input [7:0]probe7;
  input [0:0]probe8;
  input [7:0]probe9;
endmodule
