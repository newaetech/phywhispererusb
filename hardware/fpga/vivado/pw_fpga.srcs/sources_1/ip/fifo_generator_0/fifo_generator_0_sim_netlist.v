// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Tue Dec 14 16:41:48 2021
// Host        : red running 64-bit Ubuntu 18.04.6 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/jpnewae/git/phywhispererusb/hardware/fpga/vivado/pw_fpga.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_sim_netlist.v
// Design      : fifo_generator_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s15ftgb196-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "fifo_generator_0,fifo_generator_v13_2_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_5,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module fifo_generator_0
   (rst,
    wr_clk,
    rd_clk,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    empty,
    underflow,
    prog_full,
    prog_empty);
  input rst;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 write_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME write_clk, FREQ_HZ 1000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input wr_clk;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 read_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME read_clk, FREQ_HZ 1000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input rd_clk;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) input [17:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [17:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;
  output underflow;
  output prog_full;
  output prog_empty;

  wire [17:0]din;
  wire [17:0]dout;
  wire empty;
  wire full;
  wire prog_empty;
  wire prog_full;
  wire rd_clk;
  wire rd_en;
  wire rst;
  wire underflow;
  wire wr_clk;
  wire wr_en;
  wire NLW_U0_almost_empty_UNCONNECTED;
  wire NLW_U0_almost_full_UNCONNECTED;
  wire NLW_U0_axi_ar_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_overflow_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_full_UNCONNECTED;
  wire NLW_U0_axi_ar_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_underflow_UNCONNECTED;
  wire NLW_U0_axi_aw_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_overflow_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_full_UNCONNECTED;
  wire NLW_U0_axi_aw_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_underflow_UNCONNECTED;
  wire NLW_U0_axi_b_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_overflow_UNCONNECTED;
  wire NLW_U0_axi_b_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_b_prog_full_UNCONNECTED;
  wire NLW_U0_axi_b_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_underflow_UNCONNECTED;
  wire NLW_U0_axi_r_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_overflow_UNCONNECTED;
  wire NLW_U0_axi_r_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_r_prog_full_UNCONNECTED;
  wire NLW_U0_axi_r_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_underflow_UNCONNECTED;
  wire NLW_U0_axi_w_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_overflow_UNCONNECTED;
  wire NLW_U0_axi_w_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_w_prog_full_UNCONNECTED;
  wire NLW_U0_axi_w_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_underflow_UNCONNECTED;
  wire NLW_U0_axis_dbiterr_UNCONNECTED;
  wire NLW_U0_axis_overflow_UNCONNECTED;
  wire NLW_U0_axis_prog_empty_UNCONNECTED;
  wire NLW_U0_axis_prog_full_UNCONNECTED;
  wire NLW_U0_axis_sbiterr_UNCONNECTED;
  wire NLW_U0_axis_underflow_UNCONNECTED;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_m_axi_arvalid_UNCONNECTED;
  wire NLW_U0_m_axi_awvalid_UNCONNECTED;
  wire NLW_U0_m_axi_bready_UNCONNECTED;
  wire NLW_U0_m_axi_rready_UNCONNECTED;
  wire NLW_U0_m_axi_wlast_UNCONNECTED;
  wire NLW_U0_m_axi_wvalid_UNCONNECTED;
  wire NLW_U0_m_axis_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_tvalid_UNCONNECTED;
  wire NLW_U0_overflow_UNCONNECTED;
  wire NLW_U0_rd_rst_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_s_axis_tready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire NLW_U0_valid_UNCONNECTED;
  wire NLW_U0_wr_ack_UNCONNECTED;
  wire NLW_U0_wr_rst_busy_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_wr_data_count_UNCONNECTED;
  wire [12:0]NLW_U0_data_count_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_araddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_arburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_arlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_aruser_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_awaddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_awburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_awlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awuser_UNCONNECTED;
  wire [63:0]NLW_U0_m_axi_wdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_wstrb_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wuser_UNCONNECTED;
  wire [7:0]NLW_U0_m_axis_tdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tdest_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tid_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tkeep_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tstrb_UNCONNECTED;
  wire [3:0]NLW_U0_m_axis_tuser_UNCONNECTED;
  wire [12:0]NLW_U0_rd_data_count_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_buser_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_ruser_UNCONNECTED;
  wire [12:0]NLW_U0_wr_data_count_UNCONNECTED;

  (* C_ADD_NGC_CONSTRAINT = "0" *) 
  (* C_APPLICATION_TYPE_AXIS = "0" *) 
  (* C_APPLICATION_TYPE_RACH = "0" *) 
  (* C_APPLICATION_TYPE_RDCH = "0" *) 
  (* C_APPLICATION_TYPE_WACH = "0" *) 
  (* C_APPLICATION_TYPE_WDCH = "0" *) 
  (* C_APPLICATION_TYPE_WRCH = "0" *) 
  (* C_AXIS_TDATA_WIDTH = "8" *) 
  (* C_AXIS_TDEST_WIDTH = "1" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_AXIS_TKEEP_WIDTH = "1" *) 
  (* C_AXIS_TSTRB_WIDTH = "1" *) 
  (* C_AXIS_TUSER_WIDTH = "4" *) 
  (* C_AXIS_TYPE = "0" *) 
  (* C_AXI_ADDR_WIDTH = "32" *) 
  (* C_AXI_ARUSER_WIDTH = "1" *) 
  (* C_AXI_AWUSER_WIDTH = "1" *) 
  (* C_AXI_BUSER_WIDTH = "1" *) 
  (* C_AXI_DATA_WIDTH = "64" *) 
  (* C_AXI_ID_WIDTH = "1" *) 
  (* C_AXI_LEN_WIDTH = "8" *) 
  (* C_AXI_LOCK_WIDTH = "1" *) 
  (* C_AXI_RUSER_WIDTH = "1" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_AXI_WUSER_WIDTH = "1" *) 
  (* C_COMMON_CLOCK = "0" *) 
  (* C_COUNT_TYPE = "0" *) 
  (* C_DATA_COUNT_WIDTH = "13" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "18" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "32" *) 
  (* C_DIN_WIDTH_RDCH = "64" *) 
  (* C_DIN_WIDTH_WACH = "1" *) 
  (* C_DIN_WIDTH_WDCH = "64" *) 
  (* C_DIN_WIDTH_WRCH = "2" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "18" *) 
  (* C_ENABLE_RLOCS = "0" *) 
  (* C_ENABLE_RST_SYNC = "1" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_ERROR_INJECTION_TYPE = "0" *) 
  (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
  (* C_FAMILY = "spartan7" *) 
  (* C_FULL_FLAGS_RST_VAL = "0" *) 
  (* C_HAS_ALMOST_EMPTY = "0" *) 
  (* C_HAS_ALMOST_FULL = "0" *) 
  (* C_HAS_AXIS_TDATA = "1" *) 
  (* C_HAS_AXIS_TDEST = "0" *) 
  (* C_HAS_AXIS_TID = "0" *) 
  (* C_HAS_AXIS_TKEEP = "0" *) 
  (* C_HAS_AXIS_TLAST = "0" *) 
  (* C_HAS_AXIS_TREADY = "1" *) 
  (* C_HAS_AXIS_TSTRB = "0" *) 
  (* C_HAS_AXIS_TUSER = "1" *) 
  (* C_HAS_AXI_ARUSER = "0" *) 
  (* C_HAS_AXI_AWUSER = "0" *) 
  (* C_HAS_AXI_BUSER = "0" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_AXI_RD_CHANNEL = "1" *) 
  (* C_HAS_AXI_RUSER = "0" *) 
  (* C_HAS_AXI_WR_CHANNEL = "1" *) 
  (* C_HAS_AXI_WUSER = "0" *) 
  (* C_HAS_BACKUP = "0" *) 
  (* C_HAS_DATA_COUNT = "0" *) 
  (* C_HAS_DATA_COUNTS_AXIS = "0" *) 
  (* C_HAS_DATA_COUNTS_RACH = "0" *) 
  (* C_HAS_DATA_COUNTS_RDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WACH = "0" *) 
  (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WRCH = "0" *) 
  (* C_HAS_INT_CLK = "0" *) 
  (* C_HAS_MASTER_CE = "0" *) 
  (* C_HAS_MEMINIT_FILE = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
  (* C_HAS_PROG_FLAGS_RACH = "0" *) 
  (* C_HAS_PROG_FLAGS_RDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WACH = "0" *) 
  (* C_HAS_PROG_FLAGS_WDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WRCH = "0" *) 
  (* C_HAS_RD_DATA_COUNT = "0" *) 
  (* C_HAS_RD_RST = "0" *) 
  (* C_HAS_RST = "1" *) 
  (* C_HAS_SLAVE_CE = "0" *) 
  (* C_HAS_SRST = "0" *) 
  (* C_HAS_UNDERFLOW = "1" *) 
  (* C_HAS_VALID = "0" *) 
  (* C_HAS_WR_ACK = "0" *) 
  (* C_HAS_WR_DATA_COUNT = "0" *) 
  (* C_HAS_WR_RST = "0" *) 
  (* C_IMPLEMENTATION_TYPE = "6" *) 
  (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RACH = "2" *) 
  (* C_IMPLEMENTATION_TYPE_RDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WACH = "2" *) 
  (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WRCH = "2" *) 
  (* C_INIT_WR_PNTR_VAL = "0" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_MEMORY_TYPE = "4" *) 
  (* C_MIF_FILE_NAME = "BlankString" *) 
  (* C_MSGON_VAL = "1" *) 
  (* C_OPTIMIZATION_MODE = "0" *) 
  (* C_OVERFLOW_LOW = "0" *) 
  (* C_POWER_SAVING_MODE = "0" *) 
  (* C_PRELOAD_LATENCY = "0" *) 
  (* C_PRELOAD_REGS = "1" *) 
  (* C_PRIM_FIFO_TYPE = "2kx18" *) 
  (* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RDCH = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WDCH = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "128" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "129" *) 
  (* C_PROG_EMPTY_TYPE = "1" *) 
  (* C_PROG_EMPTY_TYPE_AXIS = "0" *) 
  (* C_PROG_EMPTY_TYPE_RACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "8188" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "8187" *) 
  (* C_PROG_FULL_TYPE = "1" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "13" *) 
  (* C_RD_DEPTH = "8192" *) 
  (* C_RD_FREQ = "1" *) 
  (* C_RD_PNTR_WIDTH = "13" *) 
  (* C_REG_SLICE_MODE_AXIS = "0" *) 
  (* C_REG_SLICE_MODE_RACH = "0" *) 
  (* C_REG_SLICE_MODE_RDCH = "0" *) 
  (* C_REG_SLICE_MODE_WACH = "0" *) 
  (* C_REG_SLICE_MODE_WDCH = "0" *) 
  (* C_REG_SLICE_MODE_WRCH = "0" *) 
  (* C_SELECT_XPM = "0" *) 
  (* C_SYNCHRONIZER_STAGE = "2" *) 
  (* C_UNDERFLOW_LOW = "0" *) 
  (* C_USE_COMMON_OVERFLOW = "0" *) 
  (* C_USE_COMMON_UNDERFLOW = "0" *) 
  (* C_USE_DEFAULT_SETTINGS = "0" *) 
  (* C_USE_DOUT_RST = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_ECC_AXIS = "0" *) 
  (* C_USE_ECC_RACH = "0" *) 
  (* C_USE_ECC_RDCH = "0" *) 
  (* C_USE_ECC_WACH = "0" *) 
  (* C_USE_ECC_WDCH = "0" *) 
  (* C_USE_ECC_WRCH = "0" *) 
  (* C_USE_EMBEDDED_REG = "0" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "0" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "13" *) 
  (* C_WR_DEPTH = "8192" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "1" *) 
  (* C_WR_PNTR_WIDTH = "13" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  (* is_du_within_envelope = "true" *) 
  fifo_generator_0_fifo_generator_v13_2_5 U0
       (.almost_empty(NLW_U0_almost_empty_UNCONNECTED),
        .almost_full(NLW_U0_almost_full_UNCONNECTED),
        .axi_ar_data_count(NLW_U0_axi_ar_data_count_UNCONNECTED[4:0]),
        .axi_ar_dbiterr(NLW_U0_axi_ar_dbiterr_UNCONNECTED),
        .axi_ar_injectdbiterr(1'b0),
        .axi_ar_injectsbiterr(1'b0),
        .axi_ar_overflow(NLW_U0_axi_ar_overflow_UNCONNECTED),
        .axi_ar_prog_empty(NLW_U0_axi_ar_prog_empty_UNCONNECTED),
        .axi_ar_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_prog_full(NLW_U0_axi_ar_prog_full_UNCONNECTED),
        .axi_ar_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_rd_data_count(NLW_U0_axi_ar_rd_data_count_UNCONNECTED[4:0]),
        .axi_ar_sbiterr(NLW_U0_axi_ar_sbiterr_UNCONNECTED),
        .axi_ar_underflow(NLW_U0_axi_ar_underflow_UNCONNECTED),
        .axi_ar_wr_data_count(NLW_U0_axi_ar_wr_data_count_UNCONNECTED[4:0]),
        .axi_aw_data_count(NLW_U0_axi_aw_data_count_UNCONNECTED[4:0]),
        .axi_aw_dbiterr(NLW_U0_axi_aw_dbiterr_UNCONNECTED),
        .axi_aw_injectdbiterr(1'b0),
        .axi_aw_injectsbiterr(1'b0),
        .axi_aw_overflow(NLW_U0_axi_aw_overflow_UNCONNECTED),
        .axi_aw_prog_empty(NLW_U0_axi_aw_prog_empty_UNCONNECTED),
        .axi_aw_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_prog_full(NLW_U0_axi_aw_prog_full_UNCONNECTED),
        .axi_aw_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_rd_data_count(NLW_U0_axi_aw_rd_data_count_UNCONNECTED[4:0]),
        .axi_aw_sbiterr(NLW_U0_axi_aw_sbiterr_UNCONNECTED),
        .axi_aw_underflow(NLW_U0_axi_aw_underflow_UNCONNECTED),
        .axi_aw_wr_data_count(NLW_U0_axi_aw_wr_data_count_UNCONNECTED[4:0]),
        .axi_b_data_count(NLW_U0_axi_b_data_count_UNCONNECTED[4:0]),
        .axi_b_dbiterr(NLW_U0_axi_b_dbiterr_UNCONNECTED),
        .axi_b_injectdbiterr(1'b0),
        .axi_b_injectsbiterr(1'b0),
        .axi_b_overflow(NLW_U0_axi_b_overflow_UNCONNECTED),
        .axi_b_prog_empty(NLW_U0_axi_b_prog_empty_UNCONNECTED),
        .axi_b_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_prog_full(NLW_U0_axi_b_prog_full_UNCONNECTED),
        .axi_b_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_rd_data_count(NLW_U0_axi_b_rd_data_count_UNCONNECTED[4:0]),
        .axi_b_sbiterr(NLW_U0_axi_b_sbiterr_UNCONNECTED),
        .axi_b_underflow(NLW_U0_axi_b_underflow_UNCONNECTED),
        .axi_b_wr_data_count(NLW_U0_axi_b_wr_data_count_UNCONNECTED[4:0]),
        .axi_r_data_count(NLW_U0_axi_r_data_count_UNCONNECTED[10:0]),
        .axi_r_dbiterr(NLW_U0_axi_r_dbiterr_UNCONNECTED),
        .axi_r_injectdbiterr(1'b0),
        .axi_r_injectsbiterr(1'b0),
        .axi_r_overflow(NLW_U0_axi_r_overflow_UNCONNECTED),
        .axi_r_prog_empty(NLW_U0_axi_r_prog_empty_UNCONNECTED),
        .axi_r_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_prog_full(NLW_U0_axi_r_prog_full_UNCONNECTED),
        .axi_r_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_rd_data_count(NLW_U0_axi_r_rd_data_count_UNCONNECTED[10:0]),
        .axi_r_sbiterr(NLW_U0_axi_r_sbiterr_UNCONNECTED),
        .axi_r_underflow(NLW_U0_axi_r_underflow_UNCONNECTED),
        .axi_r_wr_data_count(NLW_U0_axi_r_wr_data_count_UNCONNECTED[10:0]),
        .axi_w_data_count(NLW_U0_axi_w_data_count_UNCONNECTED[10:0]),
        .axi_w_dbiterr(NLW_U0_axi_w_dbiterr_UNCONNECTED),
        .axi_w_injectdbiterr(1'b0),
        .axi_w_injectsbiterr(1'b0),
        .axi_w_overflow(NLW_U0_axi_w_overflow_UNCONNECTED),
        .axi_w_prog_empty(NLW_U0_axi_w_prog_empty_UNCONNECTED),
        .axi_w_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_prog_full(NLW_U0_axi_w_prog_full_UNCONNECTED),
        .axi_w_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_rd_data_count(NLW_U0_axi_w_rd_data_count_UNCONNECTED[10:0]),
        .axi_w_sbiterr(NLW_U0_axi_w_sbiterr_UNCONNECTED),
        .axi_w_underflow(NLW_U0_axi_w_underflow_UNCONNECTED),
        .axi_w_wr_data_count(NLW_U0_axi_w_wr_data_count_UNCONNECTED[10:0]),
        .axis_data_count(NLW_U0_axis_data_count_UNCONNECTED[10:0]),
        .axis_dbiterr(NLW_U0_axis_dbiterr_UNCONNECTED),
        .axis_injectdbiterr(1'b0),
        .axis_injectsbiterr(1'b0),
        .axis_overflow(NLW_U0_axis_overflow_UNCONNECTED),
        .axis_prog_empty(NLW_U0_axis_prog_empty_UNCONNECTED),
        .axis_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_prog_full(NLW_U0_axis_prog_full_UNCONNECTED),
        .axis_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_rd_data_count(NLW_U0_axis_rd_data_count_UNCONNECTED[10:0]),
        .axis_sbiterr(NLW_U0_axis_sbiterr_UNCONNECTED),
        .axis_underflow(NLW_U0_axis_underflow_UNCONNECTED),
        .axis_wr_data_count(NLW_U0_axis_wr_data_count_UNCONNECTED[10:0]),
        .backup(1'b0),
        .backup_marker(1'b0),
        .clk(1'b0),
        .data_count(NLW_U0_data_count_UNCONNECTED[12:0]),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .int_clk(1'b0),
        .m_aclk(1'b0),
        .m_aclk_en(1'b0),
        .m_axi_araddr(NLW_U0_m_axi_araddr_UNCONNECTED[31:0]),
        .m_axi_arburst(NLW_U0_m_axi_arburst_UNCONNECTED[1:0]),
        .m_axi_arcache(NLW_U0_m_axi_arcache_UNCONNECTED[3:0]),
        .m_axi_arid(NLW_U0_m_axi_arid_UNCONNECTED[0]),
        .m_axi_arlen(NLW_U0_m_axi_arlen_UNCONNECTED[7:0]),
        .m_axi_arlock(NLW_U0_m_axi_arlock_UNCONNECTED[0]),
        .m_axi_arprot(NLW_U0_m_axi_arprot_UNCONNECTED[2:0]),
        .m_axi_arqos(NLW_U0_m_axi_arqos_UNCONNECTED[3:0]),
        .m_axi_arready(1'b0),
        .m_axi_arregion(NLW_U0_m_axi_arregion_UNCONNECTED[3:0]),
        .m_axi_arsize(NLW_U0_m_axi_arsize_UNCONNECTED[2:0]),
        .m_axi_aruser(NLW_U0_m_axi_aruser_UNCONNECTED[0]),
        .m_axi_arvalid(NLW_U0_m_axi_arvalid_UNCONNECTED),
        .m_axi_awaddr(NLW_U0_m_axi_awaddr_UNCONNECTED[31:0]),
        .m_axi_awburst(NLW_U0_m_axi_awburst_UNCONNECTED[1:0]),
        .m_axi_awcache(NLW_U0_m_axi_awcache_UNCONNECTED[3:0]),
        .m_axi_awid(NLW_U0_m_axi_awid_UNCONNECTED[0]),
        .m_axi_awlen(NLW_U0_m_axi_awlen_UNCONNECTED[7:0]),
        .m_axi_awlock(NLW_U0_m_axi_awlock_UNCONNECTED[0]),
        .m_axi_awprot(NLW_U0_m_axi_awprot_UNCONNECTED[2:0]),
        .m_axi_awqos(NLW_U0_m_axi_awqos_UNCONNECTED[3:0]),
        .m_axi_awready(1'b0),
        .m_axi_awregion(NLW_U0_m_axi_awregion_UNCONNECTED[3:0]),
        .m_axi_awsize(NLW_U0_m_axi_awsize_UNCONNECTED[2:0]),
        .m_axi_awuser(NLW_U0_m_axi_awuser_UNCONNECTED[0]),
        .m_axi_awvalid(NLW_U0_m_axi_awvalid_UNCONNECTED),
        .m_axi_bid(1'b0),
        .m_axi_bready(NLW_U0_m_axi_bready_UNCONNECTED),
        .m_axi_bresp({1'b0,1'b0}),
        .m_axi_buser(1'b0),
        .m_axi_bvalid(1'b0),
        .m_axi_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_rid(1'b0),
        .m_axi_rlast(1'b0),
        .m_axi_rready(NLW_U0_m_axi_rready_UNCONNECTED),
        .m_axi_rresp({1'b0,1'b0}),
        .m_axi_ruser(1'b0),
        .m_axi_rvalid(1'b0),
        .m_axi_wdata(NLW_U0_m_axi_wdata_UNCONNECTED[63:0]),
        .m_axi_wid(NLW_U0_m_axi_wid_UNCONNECTED[0]),
        .m_axi_wlast(NLW_U0_m_axi_wlast_UNCONNECTED),
        .m_axi_wready(1'b0),
        .m_axi_wstrb(NLW_U0_m_axi_wstrb_UNCONNECTED[7:0]),
        .m_axi_wuser(NLW_U0_m_axi_wuser_UNCONNECTED[0]),
        .m_axi_wvalid(NLW_U0_m_axi_wvalid_UNCONNECTED),
        .m_axis_tdata(NLW_U0_m_axis_tdata_UNCONNECTED[7:0]),
        .m_axis_tdest(NLW_U0_m_axis_tdest_UNCONNECTED[0]),
        .m_axis_tid(NLW_U0_m_axis_tid_UNCONNECTED[0]),
        .m_axis_tkeep(NLW_U0_m_axis_tkeep_UNCONNECTED[0]),
        .m_axis_tlast(NLW_U0_m_axis_tlast_UNCONNECTED),
        .m_axis_tready(1'b0),
        .m_axis_tstrb(NLW_U0_m_axis_tstrb_UNCONNECTED[0]),
        .m_axis_tuser(NLW_U0_m_axis_tuser_UNCONNECTED[3:0]),
        .m_axis_tvalid(NLW_U0_m_axis_tvalid_UNCONNECTED),
        .overflow(NLW_U0_overflow_UNCONNECTED),
        .prog_empty(prog_empty),
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(prog_full),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(rd_clk),
        .rd_data_count(NLW_U0_rd_data_count_UNCONNECTED[12:0]),
        .rd_en(rd_en),
        .rd_rst(1'b0),
        .rd_rst_busy(NLW_U0_rd_rst_busy_UNCONNECTED),
        .rst(rst),
        .s_aclk(1'b0),
        .s_aclk_en(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arid(1'b0),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlock(1'b0),
        .s_axi_arprot({1'b0,1'b0,1'b0}),
        .s_axi_arqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_aruser(1'b0),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awid(1'b0),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlock(1'b0),
        .s_axi_awprot({1'b0,1'b0,1'b0}),
        .s_axi_awqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awuser(1'b0),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_buser(NLW_U0_s_axi_buser_UNCONNECTED[0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_ruser(NLW_U0_s_axi_ruser_UNCONNECTED[0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wid(1'b0),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wuser(1'b0),
        .s_axi_wvalid(1'b0),
        .s_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tdest(1'b0),
        .s_axis_tid(1'b0),
        .s_axis_tkeep(1'b0),
        .s_axis_tlast(1'b0),
        .s_axis_tready(NLW_U0_s_axis_tready_UNCONNECTED),
        .s_axis_tstrb(1'b0),
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .sleep(1'b0),
        .srst(1'b0),
        .underflow(underflow),
        .valid(NLW_U0_valid_UNCONNECTED),
        .wr_ack(NLW_U0_wr_ack_UNCONNECTED),
        .wr_clk(wr_clk),
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[12:0]),
        .wr_en(wr_en),
        .wr_rst(1'b0),
        .wr_rst_busy(NLW_U0_wr_rst_busy_UNCONNECTED));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.2"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
SFoQ2tXDMrL2nCJbfpmHXuteJlKaWDWl3o9OY1miFvmYb8EDywmDpLUHQktJ/VoW+17fK5WHgFVI
FZV1B91GDQ==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
mxGWDRjEAsKmBqldxevT1RKZvqK7vn0KlTODVXNGlRcGf9zOAmj0Z7Ppu79POBDb8oNQyCY+2q1q
BddzhQfh5WLIVX9BNUMIF6M6IF0elM4GMSLHGeYEwqSaMPC+thuR8FGj1J7z6rH+43gDYhtIeyY+
ZuZUz/Pqg8Lu63Xwe+0=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
HLwPjQzkuqv5FEDBriEJS2DikBeIHB/bWuVWooHY5ChdoHatcmqCHpSvnGxVzLwObZWHFys2nR9y
P3zxywjtgtOWq/n3cYVa5li6eyiUmGXv2OE8nw1nLnAY1kzBvGd6VwQ45t6l4Hx5+oqpIfuU2KI2
7/Qpj2atiTN3Y+q5He/BMXLIxF9vWuU6XL/+HsxriGAumcZDuESdidlxOztbW1bFhYr1/qWwou2q
wynnRVKYHL41aWycgFdkDoDEFFxv8ft8+F5Ux+J5Hg5XdgRULJc6uUQE/lDG3zOqzPftlODB52zU
d0cm8gFOvSZ2nO8ZB8THnxoAGe33iIZJfMcefA==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
jlR0iZ4fp9QXiFgaT07DMAK1YFLyBpsOGOOR9j2PWImFEh8oTBt4cvmGo+2z1Umbt9OMQwOhyepO
QIsKLFzUXYUba+SFFLBoCiaww24KICecbUfd3VV5sg2bEJjAdtYTT6mJqyc3vQRvBlONeBFdIGy2
AXqdK7QtXGLsLAIF/z4FG8cfG6nSD6e16gccBC6+kl5MoShdnmebKLyoo6UKFdMbDK88sHvTcD9S
LNCau6RK7FkTZg23FV0tf6cTP9Rray9YEcowm2AAh51Wldo2lGJ2W5iiDatRKH/W1bu7FGWZG+OT
+VZE+Ckiuf4T6cuu+G5IbrtMv6a4U93R0gtxXQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
p/kq+JjPPJbOTWT2SRiPJ99/iH6kkVGEiluRRXpuRN+j+cVPgJD1v4QVjw3zMWLlvTGB7OOqC+JG
Lc62Wiizd/BFfGj2JYkTZMatcOWok7A87HK+vRTjr4nZMApD2jKaneJdU1279KsIEeRfImCQ2uRl
QRNMH3PPdNGYCnOGgNk=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kyyI/O29YYc5VBwhz19i7AV7MC75r43hHVKAOTBiGBhRu8zZxCwGGcNFqc2HgHcWC6nq4jCIbIXf
S3FDzPdasegnERlWvoob9/SXM88zKsyeTbUf+DRu5lB8SPROBMaIhnj375C5XLowL17MXZdmB6fV
X5ukCg7cNhCjssKt/bIJibWkfna7hvj4ye+CLWmi3LdEiix8KTwRoBS3ZJrjM4/N6FfZkXerVxs+
txkhdsmG9ga1g/xErhTRilhqrV2WetlpX86qH/64sRGVxrWeEfNoHhMZsqEK0jWDx4WavKt8XY7W
NDzMXLZ2m5Dv5HMiJWgFG+ntPwgiYYtBuwu7Eg==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
tv6UL1ZWqo3dAIlhN5UTNGzJyqzdHpCqh217JPvIvHiWJgcFh2tw1n7HWnOPcK3VhCt31AGnCEFe
HpTiinXvHna65L2X2HhtNUrsgvZlUuh/oQR273wp5JPFDPD97NQ4ELkGI+w26HTYLgZ70K5rQo87
D4AkQNRuzTRS5G12yb4RU7ZYgmkYLuq1UyqjlxyN62Del4XoqZyivOGw5H+7wlfkNRu98iQwqq12
jthZbH/ue5wxZJUcb7NmEwL+3abpyDNmWs1qORHOFoE3t97/9XMmeSCpM2+KnSKJvsV5VbuoTCOT
964fsEh7ey4IVb4aum095gQjLCqTmDm8DWFmaw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2020_08", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Oxo3AgNmVWgrXtMKDIThYfXr0YJfyFr7Bsjn2ge/G72mb25MA8Dbkd9ZZPtwqU1poazNnTng5Cx5
s8C1zMNEoo38jNY8zEUBjCCuasJgeMo5xsiha+3ZIBiuHS0KLrjLaPFIQZdsYevb44fg6J5YQLn5
jd1M6YdNMd1VwSezDxtbk9sN8ExPrmtwum/6L1ia9j9UlIzPTEaJ60Xz7tloPsgsbkborO2JLiIk
kIAY2q1b8tuhHzJ5DoXlvIo49wSDj75ncLrkwbAd26huob7aOmX1bS34pJLF17JzqYH0MoPJbHxb
RPdD+qUawXFsMSs2fOLnZrNxeG8L+TyAT0N8tQ==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
CIR/vwxo0IBrPr5+bMp2YuBCQTNBRIIbqgEB18Oewkc8CuHzGCAgPyQUBUKaUG3bBy+KDOPVxBP5
cE/d3QYZAT11fyB1OMMTrjmEIZcr0Vk3nVTAnivoxxxkmdzPjkj0OcGcU9fMArPi3dfTgIsKdtCq
94+mV/70WeprgijzuZFWD7uH+gVioY/+rq/Wc1O6x1n949w8YGgSCTurUvhsobx2bonoC317J0Wm
IX17XRkSBIFgzqA8iC+GV5oCfxIGkihKmXxjIJbMamlOdCOycEkjkh3JYmm7TLNxmI65iffsabR0
t5+iI0l8eJxFhElzWeREqE43cnJYLaKZBUA+DA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 69408)
`pragma protect data_block
Kg+usDqX0oUkeNXhKlTCTbnT7zjBx3NiIpYHpSK+lHGvHuaPBiU2FYRLxS2KDah+XprRQq3W2LeJ
6VcIitAwTRVLNv62hdOKXrsgfK1Hw+4ybcJEx/xVPX5C3K2I4aj7OPcHahM7GzAMhzttjjUnDWO4
bM+zDIDjvdnqJk75osg0wCtzeQmxD4aY2jJiaPi0qogRXXJno8YBoe7sU4jPWyaKHGAC8MUfKuJ4
kqrNuQ4D60AZOPVL31veTkqCpcQDqqgfMT8FJJJKaakLMqXGg37zi6acAU//ZAqU0syzowcHXHyU
pa19FjuhfnYDZFwUlrMHvFaS9hIQYFYapUq7RAYiI2f+18kWPHmMvMbi2yO17I20CX90stAnLlR7
lSqlPUWH3dNfa/wTwLdeogQf936geaOVU7AHTnnAmAp4OfoMPIrqCZ1Rj28hvBnHpuzKTeoW4YFo
RGtFgH43QgxdWR8BUlzz+aYmd99FnyJ0sGs1LxUEGXukXqDsc0iC/ZiSmZrcGEiHejt/h5nRK65c
B6XsjSHAsWiM7uhA9d4JiBMuJ0zshjhIvWidyRpTk4jVSIJx0AK7oST6ndikXPpv6gkmyECEat8q
Oe9dMEBVmPrXB2CUO4Q9VsZoNviXMVcQNPnPSAxbSusa0ypy/tfkieYYVYSgN2uFK5+z4tSX749/
PLPD1sjWxcO/3NPjwGRjICuKVONLU52bc6xxooR5gkJOjOc6vwGux0SpuFej3sQY1bqyFjtmSx5q
peWG4ZX+nRG39jHS3vrVEIB9rQuBTkojegpvUB5qZpZZT75BMDFR343S/J8yFNdBRXVxL3IOeB8Z
4qFgJJ32X1FRNNUjPfx87yDr14RixzUL2NnJNL8UAe9VVTLvMO2o7B0o279dCz176qcKrV6ZLKin
9Se28kHC9sST9PaUqLXgLiczOl2YT6V73FDzxFFIzQaUM/MUJyT2wuPqJWEQZrrcfT3SUEOYoZyy
yGzkjNcoVvGCM25ovrqb5pSmWPYASzriQjOvIyQ6qpKZlk8l/4mbyPI5lwCZTL750B0nUWzgSv+8
YLIo2qpGVz4Uind2kIBqjbHPZL3WlpLh6KyWNWoxj3nuIueWDVO1i4TD81q6wYkkur7PUnuQBNaj
QxmZHrKdmp6L/o369NLQKMpvss7RVy0iYMx+Ye6adcmO7nP1LqdyLy3a4Jg41/qc9dCJ4ZKeNIN+
QsuQwBLgo0PhkjL2d1A/s5+CZfGCKyIxXzHPjBNYEPX6JpH6XWWd211ImO0ni28waKycH2i850cS
0akxGF+LhI+W8NBnxGZ/go6XiGP86w7R9gcvabIFaLmu3NMjNFv0fGe40XSONbXJBKosGJBU4Wci
D3SKLs6FIZY+cNsLcvShsWUIxqLJQU5D5Wql2+bdFBdn+A9N2bEyB13Eg259gCT663J8H11YVei3
Y3xNFc+S5PcTxC2MViKEpqP3xdaHObHaErL/CglvsLHzfB6rhdJZnq9rOnXKQwVcj2iE7jkt/rvh
N1E4+SibZd222n7LOSDRGYenG1Wt0exFsBF61RKvu5e4idCGOb7nBi0tBSNwgEMtoQc93HePy4n6
qHesKzowlOZsUNUSXSNrSkI2b4JgPGoo4NyscPAXiJhZdVAGIOfKaAgYiTzpRX6eEX9SIGUa7RT1
YwESgcspYyJ/JCJIzjtWlB1QXhaOpaf5oX6dznUyhIyf4NTl864DGdgNkW1Mmoz7tdaXsp0dBBEj
fz4Iam13fNJCWVzQPBLw8T/+dRqch0xYE6cAf36e1fanGkfSIiBNgFRxF6BZjGXrIutVBo+NNxcE
M54zi0wapJX4CJyCsP9O6lzv4CiHxdJCfbXt3rONS7a38keLcEVpPhWs9jzHwMM26RKYgxWztkVy
xCok7NR3Tm1DeYC5Jlcz0UYoivQ03Dh1ox8I2keVESUfJKbv+RAREUEy05RvKzymlmPHyjHqz6VP
lpO9q/7b2RVr1U0SJzeAouS5Ew1aDseNrlP/yfLc/4QvVshs52im59UdA4kaVpaqxCr7Q8BcQ1NE
/VVWKI+1UYW8nlQ9R8apXbfXwwQCFpDfIwnyYlXWCjD5GfDScKLbVnPfCM8oIwX5InR1q+g55Xnr
qXGXyQHQJ1iLNwMxTlKZ7qH2DG82SyvZUcZiQcmmJhBzHly7BL16SKLEF4T7dTKPLu5R2eT1+yPY
j18UZqr3bzZgWeJ7fKv0kW2EBbJS5YIrQbbIlAn9Ii9Cxqi+l1Z/Jj9J+6V8y/FPz1J1mQHZuS5Y
mNtMUsniy9dLKL8GxM2r9qae8mSQdOAM0WRbHgnoT3abeKhgOh6gMHASyRSnz0kN5cuOLJEIMDL2
Yn2iushKDhsJtOnuG3REtD6sv5zzIAi/PP3VcWFib7D+HU2RZrulh4JWMgV1OUr+9MCXG9dhM8Zh
wgv+zzAxuhNDeMb5Wi4+CB9k0OoD6/lGfmxV9/MDRS5vTA084/WWcZAcKDdNrU1ec1I1+8nuYulL
IpDPEfx7Yl5kHkToZucd1rlJQT6gvhyLCAMUAi8D1olKzxO6mjlZxilIM+pl/vJ9N/YkIPvNJqhv
hkM/fo0Bwc0ql0G4PCUTsThlp+uTlE12EHNvA/QChjQZs2OLxtsL31LpWIeD5QCyxCJWg/qxUU+j
wF4Z8oZv+X1qjtrxxBvKp2O/3ZNlgTkMIKcSSgZ/z5VgxnjwSCFaIsXAybGMqu1gZ4JIU1lWfAD5
MoXGEdt2WHP4AYoddMiDbDJwFJdYTRJ6b7YMBTVW2zPPAgormb5q8rIKThFBFK/qfAptdVqzBHjN
iXYRmF4R09yz3mcTBlRt/42tDDjx1pxbPlp++EeLNWFnfJ4dwfZnCv9D4r/rzZ8/6uZwwE1gNcMV
54m5NWGq0C716fXRp/ZS6iR/z3RjKnnF3yldIOdLs/aj17XPP6tujyoP7qRhNukq+RhPPgzgc6ok
z6cZMuzFa31gmr45yzlV7I9HS4riBvzfdP8mKO8H3GGNCtQ/WffyN3Qq5e25hSWX3M+Efdes69Md
isRIow7s+akFhrfa0+kngGFhb40BYIGLLv4VNkFslPIh0DbB8Y+qpOTMyaATEAJcnlha6mPHiK7B
GwHGP5MVnK5XBEDFc88J0kDwes0p7goUnm8Yd1W4l71s90eKHoa7QCVf7Mph1/ARiFbj6Aw/+oq5
o6pSr3dahGOnHXErnDR5+G2SoLw7OVh2ZqBltKs79wGdd8OZLFnjTmyNWjFXx80iGEPiMuBfaijF
KYsAF3MHZVTeK7daQJHS9qUgExkUziMYEZCtju4tGiwin8hnfJUfXtsN+J5TidA378bNtCKeP1NZ
dbORA8JiDtFwfaVY/u7NU4eV0OSuBnoGS6XDHnJBIYo8qQwaxkq7lq/kNyaQZyF0t405sHvTyBd6
1qgzVqybUWmNosKSXEgQb/WbREqw7mvNd9OIQ3ftPHDRg+56mDUzBpaQTspnb8N6wXNealjff8Tq
BYpb+ohpMgrMVXemGUK4+4dg8Mgds5Ajp3XOJXjN2KsjIXIPuI7rwf2g3C5VUK5RVUp1cfwZj2/e
Zv/1WWRjMJzTFLgkKPgi4kkC0ofifHBm4hfrKywAp3vK2wFfKEKRPm/gyc8Ov2e1XBs5GErejhQ7
q4OX6Oynvv4B0CQbz1LXQwgSnoHQZremglPi7XIafq7GZ7C4CeoWB2Q/OhhR5g0DoSoqahiJU0wN
JWcP3o/eu77h68TFQ3eHwkr5EX6zOYJmbSLSVS+yqTqVpEARVzxYt+g/P4xMzomOcBFpFwDTCc5U
5mvB9id7cYldZSMndgkirEFcWmf6XUgF3ZTELPnnaeJJXPPE+JKRuHOrLhEzOmaLiRlbc2avbP6U
S7WA+Z/mfR0QUdTq2pWRUIslqlRTONbT6K0PXkgg8nA/fR+rSK50BaJ6VWcMUE4flZnrRh43opOB
Ja17nSkyDAGkkO+4SMZstKYs5aCwoFO0q/wmUKsRD7Xq1knivMMJ3lCCOMbffiuQ4XGrn9dREJFv
9MYnQYuBRomx4AQrgDUPO5IKLKPpcqwimB4QPlV4zxjAsZeY3HATu555axkrriqehC5OcTl+3X9h
kGW52DSyMIirZILBuesUn26E2hw3nzO+Ea9rkgw4kGGfXzzLjfQsv5BpVbMWC5Y205c4dCEDh+3V
tWA0vjSxPMCzPXT4sjquS+DIKCPMahQH3na2vpXPqgVbl9Kebs7LUE8shPBzMmPT8ZBxxeE7vd1X
tIPz39LgIgBkMxW2WnNxokRu13Crsf/K5yUBPEBcCBMEaGM9+dRbPFR88Ry5SV7qAqnR/1tkZEtm
G6mr1Mnkn23V3eeJDXftCpWpjwAfRu1+49YqgOp8ODfSTQ27hTaTEuMfq4U5iexuaFkhW/6+PoOm
F088+eHZswRL4dZDQLfbYkJXu/TMf1IFpIYj9KqUkWHeKTw94ukHWWlUlPuqojS98YUdK9XIb+MX
Vr1Hd6eQ5olHf3poEMYLSycxJDXpUzrD5QwRYnaIkPmwIAUfhcB85fv6fqxS+BXDyuso+/BIX6wg
9lcwpR5/dFsZRmhmyW7a38smsKC4MfJ7dGPjJPRB2bzvRmlr+Ze8ugLeqhBJIYly8Zii1oKJKFWJ
9YKSoltzn94pZhAVYytf/C3PIWphJavS8ieHjSa7KW43sP7eI6jh+euWJvCxWrntKhiYDTgWB9e7
mrP9sZK32V960BiYjG4Xp1oHaXfCw+M7KAwfyq9TNFA3JDboYZoqgGTFCLsHfTrAbdo0UzPTM3yF
vm1299FkTLiGWMGdaI357I+haAoBC2r6MTtb7OV1C3Ok9/pHmkn6a6HOOSuFs7CbSa277rGEd2EJ
1k+exrU7UoYXBCrYaXMWfvX+9bhX5cc9mOB4qCKu96NXirNPjbwe+ahuYLUdQaoX8TeOJzDS6g8C
R1UOFyVRVmmYFmxu/JgN25FG3dkrMa5ab5V9yJ8WJLognFC+7eh8Pk1P06SXj1WrSFhJF3uydVzl
4j42CANvWWoxJi6VGK6pmi6ZKOXmpPHQ3YcjU+JkdpPOYNozgtjqyZqOWjAV+zuhY2PwUBuLwVJQ
njdLivRK4QhOM5KCiPwK2ReKjLIIGGx76grqeZ6HkCA+Pm+qoPFpok5G6sxVcA+y/qCBizcTLyvE
U87clcNLaw0APsg54X9TWKadhGwWdykE096e7hW+HAMRJWLUuZyg4mDmTKewSRIMW1dZMapHtird
Oy5OHogTTTGD8XuAU0HkrkBeXromaVfBUN+uGfR0c06z8K8B5g9tTLhkf0KqeZMDpe04SomW/6Rm
d4icnjBFlL/vJGnPArDmPnlcXFhfMSBZdOk9nsbolMjhuJGHR+eSUeafUrKameqqf3rEJ+qeGU0C
Noxirty3/T5VfNdpgl9pqkVo/Kl5wTeP2ZRaDRUv5rM5/w0M3YpJGQMnP+Vqq0O1JkRaNR/RPWrt
wromhpXOiGZd0gjYBHJYel5fB01465nKMPzZcE3jxDYPOymn1IOPMNhjnt6xltqJPdgjV52aqU6x
eb/xBeCuNhs3z2jrpIehFO5RFAX+aCq+VR27aMlxhak7AO+HWRTnvCf3ms5rgPGMjG04PyESmUeL
lfrrAL728FMHr0SocDmiw3z8tj+YS7hYwDCZQyvZP8Xy12ia+FBqtOXbbsGQANB1APFIXs+sbYS6
AkxA84hWiWAVaCLvYmmd28D943k74eRVOZ0yUJE+H/T1ZTU6nEF0C0V9x+HicnCQcLVx7jAQzpZ+
/R7fU352NkLs2hmWbD4dizcBHdVCXDUbGdEunJovDribKwFmB8vcLTuorVhgyHZF7vxSZw/c7kI4
KzkfW+mZOzmF28J83GUz9E+Y0EQEk2P/FLvCh9p0rjFKC/ad/GC7zLi5C2qjkKlObnR+YjFKCLLO
gNF1XhKHLeaTeDaE5ngslvMEqMo0egna7PsX19wGYH1Ylnc5KrbOY1RQDg8xny9LpbMdQRBRWEap
UuIyolbFvCcDCSni9fBPhsk5a9ce/7OEucDGujqpYtLAM0vdb1O8jIZrzDrzVBauQug+HhopibNd
1cscHDRpFIqtWWoWeeMMC1/QSLZX8eydEpK1gJ7y7EURZQ1Mb1sgMKhH++kySzlUWrHArA4VrtXc
Nej2cSaAny/fs8YEkqXFnNeSvbXoM0A8K+IujnpGNp4jx2rA+v5TxKKilu6UXN0QzRUVk49Cjoa0
Cpfji7jOjoG0ZFrb+XGihOOgsvMhGYVdQQQnvSrWoj3JZu7Ru74vMfxANS7VapSVX31sxOmcI2JC
BMOSWa11BYO5S8LZ5LIh4VQM58upd4UaLSRrkcIT7X0WlHN7e9rW8GGfsduoOnQVIs8YwjGb9/F0
vzRnh2VsOs3BwIDHLYW7gstI+/Rwhmx3HYd4KUrdo7xOmga6RoMe2L0zZjoeWG8rSf3En/fmIbLr
hsdpoOui63Mp28ffti6YOW78IVskSzabaaU9RpPIomRzQlo3PNvvpicY421V5RSLCSgh5ufDkEBc
S49tuxLflxjvMNMu7dQYaD9bCEacJ/JtW0YzhXSLYkwvhBUKug4vANX+sUjRkQ+PBydwpiSUGkMW
NWgH02uN8v8Lvqz5ImsShJRIBY89cW3esjbxFKHDlNYxbpbGOCHdAo+pp53pAJVyihKONfjeZDQ+
DbFQFa6p6dAkrerQcyz+vIh/Dk0b+5i7vQOc8ddQlXl0Xa1Zb2ZTFtTlObwQMLh2KQOl1VIEyAj7
TOu3CQpdzi9t2ZLQ6U/XrpPi3LgxPEAAb+H9VUYPq4aaHwf2FIp3v5AbWztAliO+waS29t8y16NI
7GlqUNS3EA1JxBEZKuhvnov8WOrLYrfuuq12z3QDVYaRd5vjOdF+5tCPOgsktoHIilO7RqqZrW0m
evoR4b7RyDSQ/ysuH4rPCx82g5US4hUrfu7X1oFB+DzHH8R1YNvdgKAaQQjN6fgXtX2Juo1I8e9r
pWVyrI4+N9ngXDG9dgV99UeIc9P2Uhg4bGb0TksDOr56StERMcUdpw2uup2/VdqTb5jmo890I98t
JA6jkdlf7rFw/eX+8W1FGCwM9gg5+sW8UCA8XtuS2crMNCAqgHyhutdbsolAOJepsbJIL3EhyD8i
03YPi4wIamAgUkTn0E33nVsCcVweo+PVDViPqdrrOllIQBOD6eNWL5F76oDp9ZtAl7rl3IUdrZPB
zgXxL3EMdphbGVKmWVArvoKZv7d678fqNE73GqmeAjZKUsFm1XqG+PBhz59cLoVHmlJ1uGAHa/vC
pS5UcvAXk9AZOaBDkz9/tcd4awrOiEod6vhsb4D/Ww+eFeXdxVEpxbyrEWgxfvwEuT5DHL9ISYw3
wVl/QVsVa2shIM17sEBnH1w3Wxo1okybGRR6t3/85Q5YsHoepJOBwi4mwCQ0n6VrmHAvHg8MVF1g
F1yviMnRarTBOw1mi4j+quGURXSyByyndSXw013L0DZwsu6AMVem6ZGO//YfMwSFA9QZSb3Ao9ck
cEF2YS9205CkKglvsK/F1v4yZGw3oroFQqmHf1s75/SnyItQFUgjClZDYA+4kQtNBFPLt5zNaC9U
UBAM7DrZaQ8pkkJp4NFYcVtR4J4KSUdZVY43jf6VAqtv67ORYuyI92mM5cT6Gpf0ew4+w0mlfS4p
PbLR88uZA96CRU1t/QkwGdLgpHojndjlfgDYX74Sii2Lw4Yi/Dr16G4vgCPkuJjX04QQzVOkX36U
kVQ4tQDsfCHNIVWml7U83bjzJP9Yd+8N+9+19yH32r47Qr6wPtwa5pJ1+ZNDOqQV/Z/g7ANSNuos
rKyyaD/52jo88tIytcqqbvfvBjgAf6AkUCHXKJSgTo5BPuSz+/EGrAMKC3jEOVTbgMKtXeFmLGuH
mXBoZ/fQHqT+OYQNRkmRy4DrTHUW7d1Do3+wtePKqGNRq87Slk6N5SpBoDaMboJcmCfrzwT9POrI
T3t7+nfMVi6vgsHGQTM2lXmiDJETXkmqMalOBu9uYc0aQYwWSf47avdoB3jMpxY6NVArIO32N2dB
8aigHQZUuSeF0mX6TpxkaDB6eKHrnf91oDTvScCoI9Qc1Db+0iZy8wAiRx6PWB/14VoDS1BzO8MA
vj//LS7judNpQWKpmVpfp0kyzR2vyvO3mKGJHImLnlkqPfNmepTkJN/E9bGCLWllaJwBm5FRzzpd
gKTie2czyudp9LMidF7xSeDk0cgYWvOTtiq3WabMciETW3ZmC35LqaubGi3UjAcUDvofQbKXJ9i9
vRDyL2tu30/RziaD9fUMRVsn8LNL9CF/MPTGRzwIg6QZ6jQ9ZeHRc9gNTM8NJPBDPhyBI7tmhRoS
peEd8AcK7eqsdxWERRll3FelSyqLCL7DGz5ptkwUwtHi9Q0CQKiEDlzDkIxSl0yI6xCdLw6XseWj
4SQh+dLpXYWD1ginFpLPn6PUIgraQpSfDqa23vRkmZbIvTPK1YfhhBoN0pE8lJOiTCj7CjJ6VuCe
HFmgV7DxoG5PMWEulel3lnIZSGBFZJZdrtdWsAXwDI0lg8S62lrQGOKzIA/mJdMsK7zIkk5Y2Xv1
7c+nurBNbanH8ffWHCFO7TWBp01+tn4ZEwoSWInGDRY3esM2WBnORBHYEdKmN8gnBpPln0+ZMGsW
Bk35Mzy8xse935kF/uHtG+g8TwRNWIg0L+2OSnF4MqnpeT5RY328iYf1mgcQau8AI3XnqsrmQ0fZ
J8+4H1KjTWDuxtuUDi+94JeUIbXyE6L+lcmvPyF+Uvfkpyns90C0YdQdNXY6PdjPKZkdr2P5yJ/X
J6gbCmqR80YkwhmBHmirqfR0xUPPLGTB67ojA/9F4QlPywO217ikaiEWdZcS46kKKAIZVRn0A+1D
nOCynManpYRo0oBfXzQjewY4pGzwEit2NmT6RKPmfimrenrtijIpqZOxgbCfmUvkbBKlJBomXKvl
s4WV3AEyTBbtKb+ymbZykweVDJDhSKYe/lQkMZpzP1Sfdbb0BKaT6BrXKZ1Auq2c5SHpNSmBYrAH
QLmnfmR8DBbtR9FQ3ktMYoAEMyrx816MbeYV/U2Jqq7NzYBhqKQL/CgDu5iyCjqjJP/ouuKs/vOa
nXnmwWQ8SFl+ymlYWozq65zax1W8URhX2fagyUuNNh/kOHnFR58WpEU2rkajoX6+rx8uokykef39
1oowloO03poFKL8oRfsPg3iZhzIeZXmatCqq99WK9i2gkgOclXLT82tMuD98ooEqC5WBqH+uGeOO
hnsWWE01KN2dLq+NJQQkcD83+TzJ7mkD49xxAHw5k3dDEySI1EC+6BEb43xrjbXS4JsvxLtjuM0r
DE3RWaqwiU4S6Y+0ygdq0pTeG0p0/FuEnfrHSTglMt080iT0km2kvC4rvA0afTw7cYYjAKP01gXB
9wumsxxq/Y31pyy3k0lyEHFY5M2zfyL8Nf8xFjhncJIGY8h/6Vm9AyGNwWaDzXnCgIlgP8hTntH5
3E6oMWLwC6egH7+xUc0iX4+XJmaf7KvZWaWNAk9XFJ4Ma2zDshTawll7xqzSPXbxnES4JyS3vxpQ
elsjFzKKfREgeAQk8C+rwv2NHAPNf9vxEW8vX9hzLj/AleI9uNdzNgLACOZwdld7KvOghvUTutvX
Db4TkcatvfbC12hmz3pPoN+68EMkS3ScCWUSGs0OFLMtuoggnwjR2E65KTrwfIypLoY3WXOeThnG
KaUFgpVkV/IJNmRKF1F4DTF+eQT1iTavN3kGTEZQ6/FvhA2tCzcYUPMiP8y2rIJfPY1yYME7Qnn3
IqyBvOOVvumpFgjb2ziCg2FrPdrX6GejiIdItsCbZSSQ4RL/f5NaqqfL5vsSWxVDCIEWewbZ8xjI
maLAsWdPU20BB7wmgMLbVtyuwLo73MRU/XGjhbgQasP+PL42DYuHYJlDfMrp12YoKPc7pHVAvzwl
JyA5+X/g8f6T/zEFqoYbiJlP5OiyMd0ieb3o8D2qYnktNzvQnFfzNSov5H7aLw9p7y5unA0Ofepd
ZOuGPSKSBmFngoisKbailxHiUVwVMwjRh835189OL4jUoX0fKUe7sE8cB4CpFShWLuBLy5PmPfN5
TZgANppWHVRpy30BlDHXzxB4uFtQPcX08Ro8DUk/YkVantPelLvwxC8x50piuKHKIiAFsreGjl83
nvCIrmElPb4Bct7DFyU+ovyiIpHzbhJhaCD9M1krqrHLTS7r1qk2THajTYBRr/Aa0o9nBU4hJIdz
HwxKJkhjbLOC0UeZLfJldCLnyjza4BNvsUngDS/Kw25O+TXgL4pMxcpMGJcPqCbsCqR+56o0k1/s
FI8CJco7LxW2+EVdQkTO+0W0l1NOuvvEi/GgryQ5FMgkFzB61cGCsNnTKw3Nt7y+T/kbtVYf2ovJ
xWypBjS6CkXa9TOrmZewNSpftdXUAmgC21rgo+RthHUUTdETWQb5AIGFSolLcbAiB1VFIn8LW71+
EARNABt3h70HyqQR6vtyk8n0/9kzgBjOcW5Mp2UFbxoDZDAVoonbGrgolB8Atc++MqsBRNWiA/I8
+I/5pFHbMqq6xKJAz98tJIZOZvfAhsPPTx5C2VXxO4bbB026a/pU2opycBs3eqA2YzGINiLfaRat
YT2yfLsZxR/3YbWZ9vJr2ml6QUhr7cL/fcorzJ8Jhel37KzCoTgBxK2yTd2oQojUbeiR8JAw9fqp
dlNUVZjS7A9vREPGC5wSde5z2aBPCriD37AFu8yuw42s3bj4cFEULlizNeYG+hbQZG0jwMtga9xy
w73wnbXlf9ESxc4C2DBU2X2PloakSbE0/jrLmv23mxqTlh4l+6DA58jbW2tHC1OlUu/bwaamOMrl
rlVeOvDM8u1vCVsYd1LKb+6UNqgA7DfNFViavT1L9zPC9dBeMn95dgxLBcFHaGmiH4auTaGMseGe
G1i7gx1QfXs73gWi6epAurj4GdR+6LmJDJZFxnxMJ+hNdzcuJVIbNe0IQlrX5pddB7TIHnXHTj7Z
UmyxZUcm5IzfJMtj2SDf08rAjNheFGzcVJJYJwk5qNpTHR4e53R8R9wrVhjf1DEMjM65ntBoqK+j
fdsUnEGKZLJo9qMqG1MTyqPGSQ21AaYjtpPmdlcmTA8btgTlapwSj5f3bTkgYAO/2odjOefkMi+R
8T0XaW1a34h6ONQgGKyPkvD9PSMXyzLrVTCiJ+lJF3I+Szfs9tRUltiHKOEyW71q8BpBArTLtTV1
JQc2PMQaQ72drlXOk8ymqFTZZFNnntfYL6KgjGcsZOqxQIIvJxpcnhCT1rmmsSvKq0i/lO3EClm0
abYD+tuDIGHF0m77fyjeCRaDMyomTpdDqfSCZpYs0uZBblKNVzpoB6nu4COi1oSCeL5O/2JKocax
8lO59SFVWuyYMSRv4nFpntAJN5aaWWcBS0XehSKR7aMmwhfFMIMGpbClwCwQIW2HVMUHhgdYIHte
xBaQc4rp5jXucKYV1WhF9cfnm3d72U2n0w601yJ/Vqf3NeSxXZcWHluT/MU08ClXQBC8zX12Fyo9
AvuwEpyAIAoL8w37ZrN7eEqByhsFfkoJvCqSukJm1c34tU13zE6v7wtY2JyAyJwKTrtGJ0kbZrXN
ATWGpSr29GnrGxZsbrN7We4SyhS9fNuYdB6rTCghexhczMyQyy5n1mEcoklRQG3HfORcRZUqAw7L
c0oaOleZxlZFG+eREwZsxeOLQZROkPatiG8d/DYz5NazYhxFp1sz6ZT5WBd5km9ZvC2EsGCS5WWx
TuzRQE1ZGlwasoqLAPbFPzkxFUs6mfyR3W2AYiTiZBnksbz2BOYuCQMlCrYOePpOaFgBSE/IK7f7
47cMBmKqQoXK/4VD9CTr+0Sd4KRuECaBd+i9zigu7x8xU+KdamneZUnH1R7u3ZbVbc4nIGBTtPxt
eJxuN2buW+k3ZGUoqDy+cmmKxX4oRDRSa5INFceRTKDoMkXtYRvdXtitXQ8YU18iVFa71lJU8Ltr
qCoBFzVzAfnWswvW+pXlpUEsp8HlZxFvPZDBrxDp0p8yYavGqW2XldwCso956Om855l1dgHkJUmJ
/O3GQzipOTJ3NCbbSzK8ox4XnUqRVR6OFjPEuYGgygNGes51oNFLttvOouGlAN0MxBUDpp6Wh/oW
zudVlZKaJK+oFDt81sK2qJuu+6SxKbUicbVzTVUpyxmzXetwQSUjCytpmvO6PWQpH4ViUn8FsDee
HuH4qo9tlD88dCdgpTimDwojmpu2UYt573/M5DSla4p7yB0sEayav5lmfISUdZ6uSsAu+qfz8eca
KP9EUn/X+uSEmwK3FWhzAfHFLV40hnEeE/Tu4lk0aZH8DlaXminSzQf8td7s5gWEmZ7JrEJ7U6bp
SOHpSVF6pEjkk1rzxfcVZHqb6NtgLausyr6hqLElqx8t36e9Dbt0tBC4Qq7YjDzVa9NCfwNCgrdO
Sf5UGOc/cxMcv+RSyLCViDoHHPwuVg8NOzPQvXmc9PlTwUgY/D4b2O6g6t+65uxYnld3UeZ+s1a6
8F4DUnSOpnYl0qAmv2wLZMrth4tq+0RbZLzBwoR8Us+6rJ3u2iaBIcQjYu7SEVb/fjZTKkIgHYr1
RMAfNId8Lvt85YO+vyjCIhY1aG9pSUNVnm7iar8zkEYf9tJUY0lFIvG06voZLiDu3q6BxOrUw8Oy
lk1tm7TAgRC9Ku+lso6P8xRT4nFNgXvR5Hh4Oz3XJPYRmGuiEau6Q7/lZJLBtKVe/Xty1vuDHq23
oEbrWoKuGG1s2AnpAP8XDWPx+dhfKAsEnmh6JSxLQGCw+aUqqR68+XpTN6Kl/iV8O0VKAZVg3BPP
DmwajmgXD+BdUzoT/9iLbEorLb68TYcgDSeyuOPB4MZTiCLr73Ih7NmVQag0FO/MDZy3N1uP41//
jkTjW0V97WEYbpfDqZz629djHonEahtGHlpGx4kxcksB/+Bv8tMqEirSLf0yGRFdMBrc3GUbynTl
0XT6nuzVyVdM2C/t2eeZ3MHx5AqiW0m5dng5UCU3nLI0crQIAa8+1Az43I1NpohvEFbUy37IQMis
HcmN/Cql3U+7nZTOxEaZvaLFTO7hkHTA7xd+DmIYw5z+a6Wad+jM0djZN8oCr/GE87rVEg9OWU5H
fkmaNObbkcdwn+5SqbPgK+XWsF0ezuOgNViSQ0qvF//7SEaXkteRpCqhsC+nkGPYm9LX0Vor4I6b
1FSAbwAjoL9eozo/tN3UImgLFX7sVNHCbQU/CsZgdHVKxKNiFMTKX06pe9LXOA/Ya1rOwLizpGoo
RIxCDQNrvRrqIXfV2xwWSBZXS5SN03kl8Xg5X/OAsgpla8zTfpmMJrmR+XEYRY22xxBw09QG0gRP
KG97WM24Pc6X/AHG2uIWW8loPzqa/kJ9250up4FHMNA3T/5kTZIf4wsubz05dTdJ/103kM+h7zw1
LzokHodnq6oM64dRZLphWpk2q1qkJleHsZ8xkKIK2/5B87ZkQAyeGw/f6mljbj9A/dQi0v7op0Hw
j8lYdMi9ca71fk3KlXLvQCQbeTuzZoz/XkWooOehGtSez6RIKykSyQ/76NH1IwZl2ujHsWb94GgX
FR8mMmQ8sm8DYZMlR6fVxXCsZc5bVACUEOA+3iBfDrisyn3+/bgNI9rqGAul6FVdQCu7RNrbvKm+
NqPPHpvE5eOAMnR/f0HfORWZzbmhgyNJU40Po03oAO0dVUlWNA2GQ42av6V6Gw1qgbR84t2dH4jO
M+2Q0Ce8n912AUEt9rVV0vnznyI0ucxdHbfYUq2RAybrU4ELbiVRI2JS4NmMLUVORU47lJ/WvDaP
2juGioX/idvZm2f3iKxt1nZslm7hUP46/QzoCuvJTqlFZd83bgLGGuzOyth/YMwupLI4P2SEvbBW
7ntXLaHaI/WsfIYga1EexGIL2TERuwJjgB5eRxQaVhXDop6vv1+40uz0TlkxbXwy5YuRjLwgA2nk
CRHnID8wJkn+lNpgLCaslF+ceR8b0yL4rEhw/sCYGg0/54k2Cb1i9EWwhfuRw1os68Nr3GiODgoH
d6XrJXfrjgea0131BDwRHjS1QQ7ynQHDLvGcgeXNvbdlXx3vUoDPCfwmkpg71vLmSirlLChAvQjg
jxPUSZqYsgU1ZJAemPKmOc9YTX8izYUxXbU5TyOcbm/N36ULvd0l6sUZ/JoVQkH5BcFQxkXNh+r7
KBgdIwcjvEymi0rfw5z5dGST/QQUGir4Hq6oEzRhQDFLWyVUtvW37wENTGeUEMbopftONKpT+W/g
R+DbkQR/fxV7Ty+IGles228M+Q/VJB8QocsgSYTMMF5rLQHQyMdX2UcyaaJmz8Q05DFeiLkqlwSE
BxYFtToVFNfxUDiWn1pbnje2G/hBO+3hE72dtrd5Y1PzmyfKuBl/BTIBostlaW34IncyxwpbsC+X
16doTpTqTaw5j2n//d/ecl/x0rCPHyO3IKdadYYsZcPwdskIp4ZIseUZ4rjCoPPcOmczsk1GJZTP
uJqgVUzaH7k5Yp4fFBKsjB3pJf0y6r5oMiOCvaogQfiD4x/SiJMNokWKLa93rgs4vB0MWBCNlYZK
J2tdnuQ1B1wvLsYpSQOWOjgb6CiNTpb+F+wo3VVOlyN/i97i5qVlon8Q2xQcqrDSWFyUz6Kh/mLS
vCu3sf5UZJJe2FePOqS9MRX7eCqwVUCyJtssOshI+PdittUhFJ+p/ZOFxLZVbJQthp6gamM927xn
vCRnJw2TolFhVjfT1Ou4Op4WYmohDRymYvPHwjCd/RIJ09j9TFtesY+v11K5JprAsX8JHn90n3yz
Z2r3UuWNtFcVie8tGCFpc9U8gALwwIw1AlgQBM5ImHNVlGCpCSwGtZ/Z+hOTqZqY/rjvl077mekj
nY//btXPzfx5CHv0ox+nlwH1x+IvtLq5vYH87kqSCvpEjUXEOqnGiQH5XlUh6vwcOdmWivpHIWiK
mhBzO+m0P4eO3A0D/CtjGneqGJGqQOmFBhLDo0de/ZZ+TV06W/AARTgEr8cBug563Sj7CFc8vpMw
WvNPt7/s9zDvr74p4btK5nGNQdCAReG5hKAv2/0CyXAst7rVaciBitOcsafDiTdfxbEFOs7RG7pU
p3JWU6gNW6yG0BHNrPJx8YfKo6YXHKDLZ/iSSB0q0pFGRHplG3nGUVECEK0UbqagY8o/r9u31oOQ
zC97YwTeg3JZTpYlt7Z/zV0vIfPnZEatv2iCpXwe39ZsAglGVKUIaTvAG5vtyJST4NA36Rgj882Z
ZDEkZzUpg4oAIoElnp8NXCueLPbLmuRqFDqPIRcM09ucTtfZRR4y2Fn5I0q/4wLEX0ZNtWpfjVdE
AqnAGupv5y2aJl6WU48NtahZml0wvc3tPI/T1XxeLPXtGbJYNZh0vOZ8wmR/aQs6CB/lpVyahV/C
BGRBWP9Dx7ICvxFaghEqq3hUuV4ECSYlfJDa/QkBSe4sb6t5CN1hXDDamzvBXejqEznCiKgYN6xu
enRHsIX8NAqvVXBL/nCSAf1SOQpk/uo0IlLN61vpoMjMaRLyKL+LatIeld0td6Tg0aHt6IHFPaGK
9fhicQ4RD30JdUPxympRmY7umtR/wdEzI6wuv81syS5r++Rm6Py8/rxHj+gaF6L05y8HTzXSDXbp
0dQ+G+1i5xPFEITeNFRc99JPMrkfHLRkfRN1i77geFyA2ElrG3z+D1j2QtGwlYtXjT/7eVMdArZz
SN4Mmu3BXqFt60iCAnLxRu4ZYedDacXaZglMWBcOIbZdnI/Rit+Jz32LlKGztNAzwAwHpu9UUEkI
JTeTjy52pveL2yMcXsHpUzyx+WBz90lCCbzOv+buNJdHp83SJToo22hBqx5eF1PrQ+oWUNXGu7Sn
j1z6im45pQuSPykmalfohjamdc+KLDYyyLIA3yTpqC75okrMEMP8CnV/cc5vDLSswLLNXk5ZVBba
PZdjAMxXFHJE8ApN34l9unwR6fVj5GpFo+5qM7KxIoPvNSiliWxHqMfa3ne/FIJAVzF7qj9F0krG
btPXa0dkEqHfn+AtpzZvwgGFYGsPjM1ed1uW0gZScrU53gp0PJPiqiZJU+ezMp+Sl2AzU2JYRzx9
d2PrksWm9A3h7iIU/jp/HZVK7yblS7dK6Gwq6mmK7zQjxF7Fcw8EJNaKUQGt8uPBAA7EYUeRqkvz
+vVQFhCYoDt2NThvGIQ1fKvGad81FuxdXHKdhywXFIR6yDQ2nafrN8ctPh9B/W94rvq+Z+iyDIO/
qTXb5co9kN/2Jqzxy+v50I/FDp2GqyxNgHHtUPYSXDko5C7Mu+a+MCRPuIufDIfzio6ADQ+GY8qv
+qMVEvO0n9DNRX0UWG8rgcIUcCpc+z6Z3vOX7QKeZKoY0eveWeSkATu5NU5vOxgLq03faKPPc3Lx
VpryQ+J1zOST32jNNiJXb946aOYf10b7NrJWOVash7CFpY7cCX1UUNdm5EDzWHoENJI5+quRKK3B
Q7U7Oeb6WMBLzoW8nN+VLXzlBlEZXQMxDNZdADycTH7foGh/I9Fr2q5zkkTWI3RZmitwRFhhFvdN
nqTn22QXDu5GmxcyyRthPapVetg9pwC5BZEqovOH3CvBPpmPZ4ognESxWm4BQpV6BAdr1RQ/mVHr
FpdZzY8hWWaHK6CWl4A4bJcl/FDaKCG9IpBjwoUHCWfZ+dH8O/NWKZwyBATY331kSFb6mtZP44YC
+P72ZpKKVZQ2wxv0ykdWNshHmCXrovweN0A2IKLP/U0KRhn9bAFHndYh8EQmyyYkHSAVOScIviBQ
uz2Ey9P0keIPlwwzVkCDkK7Tf2c7ozYO8naVjo6+51mcrmxfeQ6W8qjhpNioH3HpYKOp0JSobE5x
ICEzrL+C4+rQwQeUGqOdhOBRwFRP+3N2OsjZgihSOMOOEc1Ti0DfAdRQD0tGHO5a4R5UFmtR6/kP
uwm8WfudlySn6uSIIS6BUSG4i/9edYZcWaFot58Z6+eZdc1pHgiZhQj8oU7kkoI+yRW1mdWiVVum
EH96X3reIKORQAxcECsDv/XdAHYRZK0pQ4IDji7KoCDCZ/pC0uUWhOL8NLCL7ZB6NQk9zEshLN/c
Hb3DlyjkUx7kZJMGHGyh5aw/S2VkxjX6j8swwZ02rYM67+zCXyQFs6tw+nbMB8wiWS0sx6iOE3cZ
Kaj7410urTJ3fYOopXpda2exe5JUFf1TYQFLSn6JjKX/tN01mNDxDWnRjX+KF+6y3b2b+zwf49zG
J+s7r1NeXSFI8XBnj/4r+F03Yat4+ckSAaVnk+ycQNnfG/AjLRVhnBOkxa/xgf9hwczkm+OtS580
T/EbCj9+63HkiIf6CE2+EoXOROV3LAqqDnHHUykRD3EQhw/56/qurneCJs5bhgZ9SE7K4TpTIHiZ
4tmItOtUZxFz3motX3b+yv/zgwfmaiziBreKOUgyzqeYSZAlGRiLU2LAYm05DNUQU9zUiwJVO3wa
AcOsQff6KIKVIEjbTZZIT7r73+sJIQbcrF3JSjBGzDt+B5f7XiSRUkT9bO+lgFGqPlOpP4Cgfydb
0A4k1iMNiMnACeHf65yZ6pzFSdyNuLxq5Y4cPN4875SXbCcTKAfMvtlfguYP5Xja4GxiE+6O/fi1
Ua8yLOGR2J6lzApxX/2aYx9cR+uvkjktxm7sHAtOZLQ54uFvbqAe/gQ+BXzXrNatR63fU3djusg2
nI5xwxR4wRIT/D8Kg98cjqsPXCaDG4Cfoo/1wNgnZZNirDbIbVryugel0ELYt3Yr+4KvfhO/TsU5
Ivwp1YDTiQAjx5Gt3HsR0zBI0OGQJvo2zE+H0Uo8ggR0LWNSBw6wia5bOpegtdzmSaNLcXEOm3Mr
U5iTQrEWbC9kxaVC1ALgfcTV0oZLNbuxdSGMmjqUHiH7mTpWwX+g5YcGuqaE924r2kIC8hDu0YVB
wUOiC98tY5jrXdunVaPstjh+BmuK6ljSoUl5qn9kF5+ZnCK5UIRe0lZiszamiMeuLXpN6WLNTMSh
KELA6Ka/iFj/6nlFGJtjzeFJRFKz8X/eKh3jI/QEP6DjW64LbXyHakgu8ERdkfnfQKypmaDbg6/8
XaXNmDlznL6qsBAh79M87FhUWB30AH7XmrkO6dBSkzlBpABmkLM+TPecUGhXuorb8dFb4t3Qenns
GS8L1qTU0xeJNg2svRLjRnkIChGSMyggWL5fN+hkV3m1XtZ33DQ3ZcZyHSkl2refl+ZLYpYQd+dM
r1zKlYJKvds20YsJZiyo3VcylA/tyzLXdTtu8i8lNWjmYtfXKGzMvEA2mwJLgXogEjOfj/hLcAJ1
IClRnq8gmkYPYIOYCB5CTlf3SioF+IutUDMUHjYhERMHtWmKkV8RTNAsedrpyDludpkOwvx/RXxL
kWvt7Q9IrR6PZRVatPrVhiEObiSTQx7cHwZOGNH4PQTUQq7cOZvJCm9TClTOhK3T96vUduDJnLfi
V2GcUzidJfvNTSDEe9KhqokLr3TMroQtvvZyxnsX45cXkAL2mtcEix2zG55W1oEKSxiuEy+m4zBU
g3VqHDawZD/TzyPsD59tCf/zc4jIpzo/vRKjxEjhhSKKn4KNlwpM1Fr//kPb7c60keFNlGSLy63l
udbp436NXlGgDAMITpitt6GTmVWUFWMPBvdmARL/UK7/FKeWZdxyQUAJ3tFKCrezDnp+Bw+n4M46
QQCRnAjwTXRapXvr/NdPNs9G6tyVQ3Z3AG3IyyuNlEZFQ4Fa0sf6MqaMRk1bzbv9iuICG90z9js2
briDGDmBXT8pxtMm028i089l1TphBAGK81eyfzQGpZcKEvXPforul1TDUAJ5jCxr3yy1zTGmf0nA
F+FnYGHbT5rYMNYx1m1A4btgu2XakCqySkjYLDGRCYOngVK0rVSA+rjxQXY9miEUCc0GCMMi7TM1
cBtHCpHZ4Kq40bD3hiOHoKzvcDL+G5mozftYRMw7YC05YPXZkdR1pRWmttcu22GQOJ5DBxA8GInD
oHmx5IGJDaf5LSGZ9E4uv8U41Tsv1HLL/MpxXg5gsrrNtkmwG+BsgiRnFMcY4Y/LUWTVJWrzUR0S
7/TifFdo2BZk9+kQi4618jzQWw+oGtbwJZPVrvb4W9acEjV/Mvd/H2RXaoRCpql4Rl/JpoSLTd1J
RaCi7Xf5HwkyJ4/tCWhbXAWHf8M98ov/APUhwl1Y6LzcmR1fZxDIXMmixC4qmY6ku09MYmTHGQLc
Xb5/n3zAi3M3rnYExGuteWuCOuhM/Mt6GslVucOuiOJxd4suUPcYY4C54YF6UUXTuWUN2ozcVs+U
JIEV64rIU04hPnr2hwz0l1Hcx1Ir/fGzh+3IdPgcb6rm/Cbg7pIqWXkSqpFxNPA3aRHNcKZXN+TO
JfkOhDKhF4o6UPlVgaplFq6eszbQ3Dks8OiicJrusn8dQ+IMOsf1r18styZMuiROfbQwAhun4dZq
l8oVS0zY89yfBV4eY/Y55TuqiTVtflsAtmEBCLca7+ENOIjw5f81chibEzTp9AX8dNGwC8dQMiSh
cTqC54Ijtb5uy4Hb0OFXSvlGhnSrzLEbjERf4tvPaBOzCZlhKQdSXZrmbBnyxdoChm/ai3elz7jV
rOsD21P+iq/ZQKfZwtUams9JRJhAyO7WoNEG+gxvuLjMbjoGHLdMnEs1mG3s9b5lvFy04Xp6QFr9
Zxx0wD3cQe14OkB72cs+x/+XREseBCv/cxfaIuA8I5ZufJuiz31mq0WDvKLZbHKso12b+FXczPOO
/WToAMDZGfgRI4fxfuKPZxvN2ljgZb6ffcoKAwFoRto0xlYCTaUUdGvmBmNR7T76oxfDu7iNlRKX
Q+syw5tulPIxyDXEQAppIy68qKzfIEXfHSebPpfBwG02cKpP6ObpIlBQmr2S59qHdwkprjG+yROQ
E7HdZj2HKK/CNHyjPXSdqBE2HnJBiZOlizlL1tMjbi7/eTfLGM6OQqK/SpUmHuR2feS/pIGFutiF
xt+sz/qr49z/ME2siUtYaPSTcZCvsikmcDYhZJhHQ5q2TkWi36lsU0clqRdXnmLQIH2tS4+2Ifm7
CbhfpHaxNDNZaJhnsB9UmuyeaJkcnmtkrS5U3R6aSabLiAYbKskZNFR74RpFdaHNVQ7KIGPRvOUr
Cxcpzjr2dKunZOj5h4c4G9gyEpChrHGsRygs2pgDDyz8s0oVWaBxUlDukY1G+u3uYdnBm44KUHZ6
GJPtIsTj3lupN866in4xX705GkZoKkrnkdmM0mldLLEyebdzXzrk75449wwn/BB7g/mEjR16E7eW
WdTABgGGkozj/0ZVVqzgjAy1sZD5FmUsMA8HusNnWTuawQNkE3gfVxJDr/jX6Ykd2Nsyp5UFLfzL
yKBTyP5vmU8XhyB2QRQPosbyx4cJlZ0AuIA92ZcwXWuW/fIRxXxM/oQfV+qXka4ugjbjn4sHXg5B
GcICBd+/OsxxAwoo9+wgbg0DPb4buSzzj8Uw5WY9D0EVdtP/KK3B8PvPfty3RYUIoxOZnvwgQ+R1
bt70e5v2LshfO0VM0g1+O7EfQiuvRaTvEaN3YbkEqSn7qcETWjx3qUI6zHFcrF3MLS9dtNuuCWea
GJXtWJJgaZdFqmlBvT22LOZJtHfTHtaQ+ZNhxwVIyWsyMgf4QsME9LpmZbZWy7sBEED2tm909pbk
wHXPyl8LfQtXItG+ho9thUObR+BuL5wZ5jA+6JTv2D9kKhQcP0ZRtHd2ogEXbcp8pdHcZ4qMeejR
HL83PiYhKLvGbVY7/v36w4cU0iRdetzEcuG2EvK2Z8l+vOsp0DLJsI3Y94Hj4ocHFYd8DXI4gCIv
f2hDTHO2i/x9EtIjCPOXZ7Cp1gluBs1CQwqmhPOiXuErIDc16BpzfflrP42HKf6acfgE+8kKjYnQ
qcXsiwwbFlJaZPT/lfaI+my79IIUwXhpdSWxArMqKei/BL7UsxrCetF+FNuKDH1vKrxg01qDintT
Az5Pgclsz5OFPm9vkNTcdZ1FSqCpl+CgnTfrxxpeqXK903xrWjNB2+2UilKopLt28LfoJAuKRkuL
5WYp2JFDSCfgn9kzDmqQ93SSxAO7ByGoEL4MR1q3Y/TblAhySfc0clh9AGSn5fa7ndfQkOUCEsTw
996kXgftSXD+n+f41N9Kq+ROrGe/5hkgEXEa4AuBFfHPTjEr0avmuNsYIcTRNvfsS8xGHjO4Ru/M
7Xi/hZLnn13HG3eLBclDt2dpQYH9+QQoDfAquPKtpIBvj5tkrAM9N2TvVjbsg5UM2ZJeKaw6GNBE
wAb77x0cHgn/LohKm2p/kI4gXyOB40V06nOMgKyGWmt0jlSJqWoyEVlWTPBdSNlvtd0B4S3pHu8S
vZp3gS107BhHTFeihCHNej44uk962E/xwlk1JMr2uRa+yWvMGRpExOxyg05ncKRdiiRvwr4T+mpS
NFTe0z/jol2ZL1JX2Y7Sl+8a/5pXWjufh7T6TkDmFKNwN6GbTefZIcf9aU8XGMPaIYFlwvK+jonU
qoPs8WZVJAVkvjSqjHayulmKbkQFVIDiNdVJtp5F5Wsb1Ujp/ukQEz4mzz7hlxEnDrVYmLn7kTx3
CYo1Hc1ag8Tg73XjcWBpTP55yp/b44vVk1JpxNPlPKZ0AGT0Cl9iiUEQodjlLE9z7Eam0HOhxZTq
0XH77Q+HLyCxONSS6AtRVdAu8N8O+ZxknFe1YPw+o1ZGeNsBNg5ioC7OJFuYQh8IR4R+bgVwJdHD
1y07AQgClgv4Njd2xmS/FMHoq73kaGzg9PTfSe2m9NbWNJPJkKl6Lw7Zlug/y3/YdIzjKCQWh7nn
Sh0VztalmvLVUM1dsl1FvVcGNG8jwt3uALQEYzdEVqGeVTtvzBcg0DHRTcp2Uas5pbvsXdVmVwFM
Q1FOaDLzoOdz/+QyKTBtHvbuDAtfglYsceaivMw9keJlQ7zitj7h+mJlJexN8gkKHmn2rqs9kYaR
HXe0GLt8uyayZizp8+L4Uw8sADblvgKhD3OGZKr0/kozNrecv2xZICDnQf61/ep3zvfw9Wx1XA6G
Dttjd7RdCoSLarsTvM0qbutDsBcOb6yTy7wUh1BXv/6X7Nc377iyQoE3sS7uIuTs22GlZ/z8Ik4g
D8Btt7eQiX5UnKgNFc4QZw7tSIohxSWmFoZ5wPkhlujhFRpsgq9fv+qmhPj2dfJ0LqcKxcw3RwuX
F7p26dkSMBee+t0HrEpaYhES39uk9BmCUjfK0LK9fAZumMUwp+84ZQlmx7Y4ii9XB1geOWRD/jws
eNIDJJixlW4xSM2PVVO0PZnXhzwpJyNPJdulPFdxRohJrIyK6/+ANuzqPhDxH9zrt/fUHl6TyOfi
64nQqp8Zo05Qa/NmY3JDRJWpuEhcnY6DldH/xxFhtmInX6vt56YJto0dgWYaOpv3ZzvzeQTsqB1m
of6ouKDFz+ycV5+fK5Kgrhi1z06mOny4bEhmdWoxpahxzyC11KKSI0Kmh3wTlzhdZ+JDfVcctmbh
wWNimxWsKzDt5qvQkq+wlkZPJRCjGwlAtEQvzRAmeOf/oFahDMSTD3ZvLibnzAd6ke8WLJWxP8g5
CZR1rxu5/bWkmossBdcP5HaEfs48rNy7F7w0gvpmJ8bExyUHBmInmT1l7BbPqG8kzYlkAoNUZART
2uzvVy5XNtvmBwtvGTqTs0+cxSrfNew7gaD6LsgzHKK0ygKFrA/vktGtsgHaW1mOflLA+zQRdM/X
NmW7Lm4pfoUIBq3BkbVmJ56Ohv2NArPVRXtJ64v2udPUCkVYo+hQpRq8X3/U9Ma81cRMgchEdnoP
xStEitMqotGXgldfRu65j5YcT9G3Qb26hflYlP3MrA0d7kxFdurElQ7eiwsMiVwkNBBqkrKFule2
fW2GJz4bzys19Yn3JtiT/GPq1Lkui6C7xvxD8EjH63qLzA5Bwv+WXsP45FERfYIYeZFFFodO6FKq
TcN2cp3ptjfEHjaip+SmblN0MqUzhXsoE9XVSsJX94CvuCEGsLQQd/ogodPeZzNWOzhRGD68lppT
g4x88PvFIU7yxxvP3KbTyGw3Y8NM+Ajn6Ay63f9vwpn6yDh4yNvv++vTFRAMJZnimGyOV7XaEDxB
RALhoUS78bNGWD3MSyi+2u7pSgwYbVeXfUIlrKhMtgHetfMtEraWISw72AvmypnUV915nhOOFGt9
A7J3YyF65CH5lmXfVprLiFVNdlYPXaPJXdRdTmL+ZA2WQYjuSr9riZW8cgz7b0TKVmBa4CKJd03u
QNTHpoi6je6EGLx/3XtyUkEioqzw9kLa1OBQCvuO+DoQQhfDQSNW9mgJJMTz4YczP1/mbjOLoFeS
UvdJ/fR/Oak/IJJfb7xn8BwAulEHj4wG3wVH/+nXTEu7fQTh2eMGe1wqcGgk/gx+RmxWshXQDabA
QuA3S3OYsFJvnfFgq3XAcjKVCj/ahZJ8WvoAwczrjFKscMIB2dN4hMUfEcNsjzbtWYKIoJsGZ/Kn
htZ10w0exByil7kYy1x575zPpjyTzMINUaXDlplLEz4JeZF4uLdm9h8UFCw8FxzCvc+yyGvKRkdz
qoGIauCdzJyWiq8h+OgdDtgB5UfLdpoHYfqd6xw9XqP3GMEtTnXMmJIAKx+Sbqp3jMR/z0tBGpeq
/RnHm6HsR05iwQEMgdQB0gR/iIPs+RPfUqT40aHpuH3i1HSq6YnHqGcKAIP/rfi1z/XziyCEjHvC
a2N2wS/tIbwRxJE26R/PRqhKJhjgaAAMtTvslP5F/X95kawoWzgqOYu1/iqICteR0MNi9aNek/th
DR0ul8fuATd6OlX2x9dxLp6hYwNFutpF2DdoOXcQ22ohTJp/gdPHqISiVtc6GNSo2KjwkTKRJ/jv
bLKIXpkdMnSz9fqwHY+iyjqVYRJKJ+X6kGKCC73naoNL5T7HTXuUZscJqeUxt4VB5q4khUXo80ca
U7Equrff5IuzEhby88c/jpaiG27NvCO7R9EgeugmhI/OeKquu9/ZuFyJwzU/6mk6XfUnZxI5q4cz
URcaOQsndok0s2zxHY0aUc3mBOQq9pE004tFzut1+Yi9CyniMIWvGqGYPPuXqYt2zsHv65hJrpD3
3OyQbIe7Ft0TcOCUqm2K2mj57FOiDY/k5zjiqdU+TkPfqjlcwJ6Jr+n0CS0FZwzqvoSuhVzmpBou
8mq4FmbDGhX7H9YU9QCATj12gTA+T5L9sCpGroyBV6G/e9rbJ8gScgqqIUZZt3IGGEURse1C4vI6
kgrPRlo0cCTWhsjhqqeyW/1jbps4wXetnMCMIRMKuevbkAlIIZsUeYGwBSoODC8QwS1LImoITc+o
LPInOiUcpXSaojAf0aUEFQtSL36bvtlYaE6iOb8uF0bQk8PyPDrdAwQLczudhCseRFTZnp/ybMd5
giluIe+cPcGitgqcUD61q/LN1xysiTLpOZz44K/EYUnYzWsg3f9PIKH5uBLfRpLl6OggkQhA9OCU
KaiBh81UxAZFGr6BO6K2So7ESqi60t3sGMZoKOe+e2gDqTWQKlIpn+I6XJN0xZRUAg/sP1fnlFYB
tIk4Hbdk2qQ8KXTFgQ5hT2o7Qxkin6V08Ykq0XHjtnnCAUm96l9/bsTjqkROpJF7Bof5Vh1BDzcT
3DfUKqmJpMSm8HL4ASIz+OCCh0VeOlqzGRUs7aBieWKy//LMzb0Cg7zY7dz6wp03n9ILeutLF/xe
WxXlrbdYg+L9auvTBbksEBR91pKLNvirDrqx7x+5LFU6aMf8IOKAQ7JBbT8YhEh9NsY+ngpOCgdL
SKGt2Dkzkh+6IqP1mjca+hnbw7iDjQeCkm5IXOtWyjk8x7hoBKFMtcpW8hUvTpUT5I9oY+BVSYaS
yLXysQk99Z10f9B59DZY7/m0lYcjRLFiFJq3f3jbJfutgsHr6AT07Yiba74Wqs+J1cEjYS42+MAf
szEas1crJB+MhiKOPJfIjAm2TFwP3Q5+2UhgWl8PFHFyzY39Zkm0D7D1gKafnMAesX4i3Bxs3Q0V
0KJbeQZDKfYvjWZWftViN8eg0C66WncotMoW0rWhFQ20paSx53oLFlA0ADKQv6HQUiWR31YrRT2Y
nfO7KTVP5r7TuN4LbmWdlFQjXb7iE5QgoqmtjlLsJ03sQYnTWqf4YV2oDgHcmbygQLrBwQh8Hcta
pQjp/zYv4+SIe1YDot4NvvPQoeN4Jj/zW8CiUYwWAkkps8RY805yTa+mSz/Z6FdSMKwKZWJsit+7
xDfuwOswkZaKRxgiEfEtWd6OMe2sUdkI0f042uVLif5krLg+8GtAYCPUahNt4dIpR058NKpegG90
0VYp9oP/XsT9ASwKoAeWxzDzePrkuIo5Fi18a1WBN/CoqEaeyjb9ahT1YuaBxyY8WK3j9425GKDX
qkarmjwj7Q4ctfsR44RUShhOpxH8g7WQhp2inKbTa7ipGMmfEezZ7AkEb8uTfqNuNOeZ8aCkJb0K
ck179Ub8uYziTxxw+WPv6MrB8VIu3zstDhtH+r2YDujU1yAGF1m0tBMafrR2W4NVlzgZngcCI2ut
oN9S6iSPdlKwROntw22BQW3mQkdv+9I9P1q6KNKQltQi0b01/1K5k2lo2In1s1+Be/F6UkyPR5p3
I7t1XWnFvPzQzqITIT2nWz7tpjVA5fxcAYTakDsSjXdHr9lm8ZCpt2k4b9dwtrkPwR+NzXsIyNdU
NttbUkjmSB2yPNyrWB5LrKYswybe9EhLzS6SlGpHjdDI1GYzzKvo0BRNX6HfQGgiPDcKSZYCUaxr
ROtJTeoTzI7M6NVzfwWlfu+o5po/ERBcQ4775BpzQgrLPmuRzKhSXeO8nTBEI8MifeIT02dFVOJy
KYLh7YFLNNN4EXS5d4FpfujTxzF0b6VPf8mdBWC2+URJdfWHIOO26HeSILSXVPnII2RR8QYS3WP5
cVo+YaxxIBi1a+efPNQpUzIa/ubfmOs/+1A0xcJaNO54sFkPFhscpM+eQDm75mOsK6DllW6Fo+Pi
q7tLFEFVbqvkgdbCkep/tb/yjElEOQt8TjMw36Bu2NJSOs78iieMfALnNybNkF6L8RGbDS9Z11sR
D0tD2yZrjc0bcNCE4Ssf8wkJLFtpBW7xPB4ek+ZCvfRwxkOul/H8W63mlCal+oByUSJzeqm7n1jE
xqSxUeNuhajL5VLjQnMT0CX16qWferOrG/3D36bTo//j5lLhe/xhFzSrwvwGYuEmMCUPXHeVgSYa
g+WeU8otmy+9QYDFMYj8LoPg7bhPolLgLXD20tF0hOPJaqG20KXotSxVRGt4wtuWdaE9R7qibmCV
2vENhcJSd01QJGdS9HQbvzqY14kxEY7VV6dTTmZZkOVze8qPgOx94wz68cOxrMZuhTag0nWulOnl
ZS3VvVT+MsGSxzzO8EHg6zgiFDVsnSUvUiAyf6tTMIheuL2UtMNp35yA73XDjh1acZFIeWBwI8HM
rlUxhvxmYX1tGALTpm/Uu+anKPpmJ5+xnzKb8H72fr2taPTqDoAMRGaqrgEUYgq0wSo7d1c7lwM9
zRAIsjWujWqtO+MI+ofFTa3ielI84aT6U5PxUnEj1NFq+T2HGSw+bjOImWD5jnMi/oyqdxMlYSx3
cWrCFRWZQReNNk3c+PTzmFYvsh60YhWb1/tFlCE/KPcWITR4cvvSD99c1UtLpu7IS9s2dQt7zhUO
+FzQCklO0crL5x695H9HWvXxZDI8JPeP3vCzFY6WC/+F8AO/kkk+F7kv6Q7vWeYfqWkZZgFWn4/t
9Z0WXpQNMjapS3ENzHzbAUL3FayTezNjsG8Cny2PsP3abSpB3vj9LteUQldy7aw43U1o7QjPZkkO
eyGmLRHcUDFQs10RX9IBE/URiBtJY955nqoUomJ2ySNE4mILETzCkfYtAbuo9YahoRHzKOXZv1Q8
zssJ9s/SJb+xRbC/ehHib7xrMGGAneK/j8VejoqXfOhBCS2YIwcf7ldXiOEIsoG/XNhQQwdS4ccW
KDjh8JLtK65uE7FtvMEd25b+jWs9sPswrF52RwwFF5Zj7Nb3erpTZS6nBwR/LJQNzQxXdREUOkwf
Sp76SBo13rKPH8It/tWOsZyyb1MyW3Kzy5F7V6lmvptTbSNCrcQcr2rOlEaRj4DAhzkYHhEuGtJR
X2BX8Al/j1oa4J2GW+BHBW4NGUlAHiitDSgk+gIqcsePmP30Z/Hgiv1QZSP4tmozmKe7zjvbZDPL
03TVJyP2hTn0roN4lrqWnIvEXlwu4H7jO8GlXaMo3XntpV4Ofqo/rUZtL+JyYPPoZ+nMeGn8DQIX
+fHngfoiZSQGHCkt6L+VGZXMWajy4jhI5+uW+MfEMFZXWwDdnm2yid5uAf4ZLZstOurostDLRt4x
fB0QxoBnQAKPmCuoMK4dD55/8uuFKHfAQtl2J4V18g9OK6Uz2krnD98mr/2lKwK0yJwbcRKGqB+k
Jhw6yV/F/wAzA98casEgJv/5f+5oC7rMhF3BW3pRFqWc1uwLl+EZATJzDz0JG24A/ZsAzrXkmdew
+STgAmqbDykP7oHMTH09LPZzm909kHoyO7nP8iimC/1r1TIV7sW/i2Vzbw/iUC1l7MybLZMkBLQA
jENOtsVX3BqYls8ZWe1sbZE//xfPxt6nn639Aa1ZuzmPuIArGv+24xBWQuOZwtO1I8RAZoe1Um/x
OHCos4ke2qE8LUsB/Bz6aR6y7d+iFOJM4YVKG9+4DyNWQl1p75PrDvxPtNjZp//blaxYzaZJDo2z
n5ZfxUV0T7obxhc3VRrgOvAeppNftTfhjQk4R3xLSKcgAR7qr0RMGq3byxzY/N2YbIDiLQ6U5QtR
SlkpAD1DPUFxOSzHeMQxrVjgdKDWH2wqwuumf/waHswQDI+k7Y8WZqlHjn0zljD37KSnXwb6WgMA
OgJ8B2+IsszbXLpwqkDJZUieZ0Mfbssuhw5/tYDIc6lb7fVhK0bLfNJMbGo4Ad39dDKwsTL4FD4R
uM38CJMUPOg6csGneyhMtJuhzX09zuciaIMb+FBRtCXsgIM4rB5GwlxUnqdVd5YsCQ0K+soeclMq
EwnJizZ0E1ERCPp7wDRkqhBJzrJsmAnwmIlZeaX74OqWaxRx0kGOwUYQorkHMqE3Nm0Co7tGgzXi
5R+s9mw0bFJCnGbe2bYd0goNoP2xJQxPAikaS9laWZo/zauCYSBcOJDjh686mRsK0MSyn6vxbzqz
h/tniwaoHP9RH8FiPUi7MRLWbhB2vK4QW7sDiyrhQmM96UP2BIl2+21PEu785qzQj+HhNRhh3QmT
asP7tKq7tyOz3sm8U5WJxLXCtsYOCYK2erza8+NeR1Cl5hr5WzIAoJ4sngzNBDGgsU55gwM7iR5u
Z7pU0MmbvKdT8sxt0JYHjl8YQtR8ZA1qYB0zaTx4+ZM0a2iGv50aAr/qKGGU98rI7t26ys5y0r90
tzmTnzFgcp2INB+n0EqYnA2GkSS3dYD2N3n9Klk9Sc2wvKLOzx0vHjRQBr8T49z/q8jBEoAQnFvV
tiTK863Ki6VgwfkHzROu6h6M1KmodW4jq1zPElzrJ4Ym31mOlRnvI+7O1dmHfdu9oGsi3GogQG1W
EWZJFl1pSNNWiGRHXJrdSOAgDVpQoExk3lSseMpzC4tVvc+YFhU8Kb0RPNNlaZkWg49UMV43qSgx
+5hjWBVh4/+Zr1iZMpPuZ4PppRdUZeGgplrKr2epiuQQnsZY4wPega51dD7QaEsUSFdsCOWJ8ted
0ohS9Uo7jGJXaaIeEdcdR0eRCQ1BakNWYeC3MHfjFol7ZyKaLy/MVS3LD370yuut9z4ylag3wmv5
J2mUdZ3CPgyZTuXptbhWuoQt0SqFSlQhof7sU4Xb/FkWJ+Zfl9C9gYNrgqWf/wR6kw/wsql0gF7/
vwKKgLQBct+XYEM3td2HgCRxbDjrGd6pmNctm93v8V5BVovDhPmKvytaaI6+jGbwOfboY3BrfVg7
8hIBEU15EIvbVPKcib9bbb1VVxx2qshevHXxHiY4EKiXX3/jQfZYIlWh10KLPwoSTQDPfCDKgagh
flNkTWlrk9g41KzFnnOEN6AOz7FWEMeJykiL0eFjmauTjFtMaRNHuSOMiG4uV8fOEmAhwGNDabfA
CNc6pOHv46FyG4lxCN3GBesSQSf66HTTgCBGfP1lKWXtQJes0eIXOgBFGj+mcT6fjg4d1evnH8VM
Ncza0kN9oKf+5/dhkt79bAVtpq8l+si61YIaIhQYrBJ4IoR9Xt7bAQWg9gdPwyQfcaQstMg9zlN8
1QvErq9XKzhzl3neqEU0F+Z6PERE4QlImf0KgucNXJhvJMtiWtH3eTLLuZwXGo/xkaMKpRfjYBZf
S+0OCKT8hHktt/7uouA1NqPy2+LJH71VOlz5bpqgB5umfjeIWrNr+94Xp/8+5s3ilUQ4J9llrYX2
0sUpkPQTHj06mIw54DzjSA1BNpw75pfs383bEwMsLhSUUjEE5d3V0B6O6txyUTEzhmKLIIiP6S2w
HxzlRxGc5AyhdFJjp42+xNUoIGCKFOF7I2NeXE4/8jexf0ONNjxGlaaacCaVAnkM4NHVk3vFqb2A
bk2Tn/KjUDIt0XpYcL+cRlQk2+5xHv7cwkizEdmBCV9MJBE+D3WJ/GxiyGjlbA8i44ewbECVgDCU
sQxlkK1k1g0yyhDhDRHG2weYPuzDtH5QkPRyjkwJN7jW0FJhBVtZLsQkSXw8F2l4FTvQBwsok3fn
m1Iqf41qvrhvnLHxdVX/Q3NxYJECPpz/3ip4pM/WtYaSFuBL5Gk7WV/WsPTonnOgH2McCuyGIY7J
zzI4CiC88zbImmwNZ3cjm9SersLKdutGVg18zWtAPpqhjEpWvhs799puXq8WLA9qfu9RFPvInYfJ
c8RR+oLBBHxB9oBSdHbtfI4QFTZvTgbVlgSVESJvAib4+md/exbBeTdD3cBxMPaYs//QduttUjEH
fTtFWtb5kD/cQBY0n5/QDkvThS8ppOWfStRxTKe4vB6K2POlKQFB2drQN2lckygRzE9CGL/B3/BJ
QR+9HhZlKaINAiee4E0rZL0YsD7gcVY8sF4kFJ1xJUXTqWcZHosFK4WFItOyhzdMrZ3+5oG3Nl2l
rwdxEFloIphMH22xNOgFZ2UhYE86Sze8LtqoUKGmrLuJXE1smZDooPiXJo4RT/gFNgPouzsWBkPV
7h8Uy4Te4a13kLhxdTLi7LhxlTRfmEMeGzuD51r7vcy7MVSlcAO/4s/whw2Jxktr5E5A71aios4B
A1yQ2d/Q9C8dAMKUdUZIQYwX+1cneuobbjEpRwkycMws6nIr7cDeMFMxXuB6zb9Rlr8jwvBTmIi3
9rkPJc5CLEldbm5oxyN9wlLVS3wOLsxQGbpXZG7s5kg1etrHFxnb3pI19AN0Omnfsqgo/uimL+ry
SbXWzjUnc3hzRawEIYn+nThDK3bWzrM46db7BLzSnPCrsuOwjC4vTEs0bW2lhSO71IaoOzIxh4yf
VWxt3DQEkwTvM9Mb0qXhSOhNRKTzWY2J36h16EHEIiGxCeR7hHYppsanr1TXJ9ryIO7K540nnmuZ
9ZJ7Dpm199nD7iVOTkr1rX42za4nyh10Kabc+9X8Og2cM1rxLRfgr2flmYw5A/z0r1lpg5DEhk1L
ory/P+xBBR+KVeS0dlwLbtvkU0OJSQWQp4Pd5wreEHAQxV3ecyYdtpS3WcJcx1HSjMKjzEP33JiB
8jByLkR9Eeya7K0fqNR2ltSPPZxXKEBSdnNbGRAbBmEeH5abeLM5QlcswxoH7kiP3aZI8Mbq5Wb6
14vTLB20ZmoyVBGVojp2bwdn5Ka4yzoI4DGaTTfol1etNGYRmAGj1kcHYaurWdPTqTLKuhl1rhj4
K92KPdpVGxZPc43SZgohB5XgBLL2astf2BU8JxhAm7OsmY5jKiVfxJXtIPnrYRGfCmhqzLsC+vVH
4wKxIFG9hJW/ucAg2KPfqeeCQ6Qo+Syq+MmYnu8YAF7IeHogpi08+0BBXLAeKtE5LqOS46CNJXra
xkv+0mNFwX9aHz8iZH98PWh74VNm01etkcs9lMj7A2Ra/ME5G44/m8jeu9b8nuSkCniXA1z6Ya+o
K5AnWLYePdai6DYORnmuGPUJOJJg5CTyiOJgMxBj84PkFsetVykr7RlpzqZuV149XGb32dF5HAAN
AN5e8byesyuXQX1bFx5TsuT+9mK5FTTstVvtPRmGiP2tXlaS07RfnKVBa7T0aI50osYqPf/GQEmR
+jc9uN1NH1mRUgwpTW1ptmBIrgT+Aa+8N5vp0fEa8TN7q3BWPn9dwhrDQFDIE9wIJPzAfrcK6d7A
yqFW0lUZ8whwztYrzFHsUNr4p88AA4lVozMqN9naB008uz/N48s0X4Wa+Hfixao1xfeBeQYArOh9
lO8lbo1M5uiQ4SN+FugDowQzxNuor0QckhbuLWsYwpqW5W4HwuGYkSARXksVoHOVb/9x4fIxCCqG
2EZJtDa4qZRYnx1X1ie7HrqdewdxzqJi0wzOy1shjFvSUGX+L0yglsjrGhNvcfvoTbXRaKEEG8Bg
K0f//0Fi955RSBRUrpYIr1zyd30OxtG+T+9E5uW8ZMhI1eqNiRh4IlMx3/4ASCTJa8tM2sXNDbJv
MT4cwIC4k8uAGMQGElX7Ey02qYsahOI1oaRNtHksgsahkZsqOhc0a2y1FTR85Gtf/1CHwkxfKGl+
PsohOazHOvF69dLUK5zS5a0Ul4u21tJADQ7vj1G2uwZNwswamFRIJy/A8S+awteVMn5H1oSCTyue
t1KC6ThA26oqeVTiUYUgRBe+T3bRR4Sjvlaysog875tf4HBxkn3nCMqNZXlWm451jODmSaABgSII
XeMl+kh/hXQiamD1mlibluecy06oEeJlzmQL31RlqM4Zx9XRn98aYhbna2XKUKlOe4jF38a0RGA6
R0WWAG+AOffG0r5Gb9kV1mCxUaekwA05tWaODcPnVUQW6Korop3JKhOnTENBeTAtDhQpS8m0CSeQ
vxa8p13sswQaCXbF7Llr2Yp1tXQRUk6qucX3Fap2mEHcDk+EhydWh0L6J7b6EzIcu9M9t5Z+5883
bADSG4HZJB7YbPbgHenNB02CPjdf0qutFbmsaCOvUssnOou9QtUrM8Q53dmN9LoI8aTWjpZFel+j
ecpYhO4oZblBVHrUN4lTr3/TEnF+9EzJLKCIEHVE9Wu1nbGoqHb/5Yqz/jyFOge43osKXhNVddcl
MQPbJMz78qG33hEHaGrRiCJEnb+b3xt91c/r15ZDhK/P9I6asydiyTjHXOiKkSgDF8NjRf17VbwD
OFpG1KFnR+Qfm/+wy3Irq02oWnudiEZ3kkORxLAkRmYfTeQG76KPHX5D/RKO7E8UrfDJmfbEF+Ix
MoiocP1hbkoRy1mdhLw/RdbjHe2F9purmX1r3jm5HbVeSJotVzlR5oYJYRIlyw/+WPpCnzrEy928
NtKS6ex17NHF5m++wcTqt7CU/OwKbA4KZmwaRRWD6SGzw/p9aUCgFqKc12oBz51l1Q0nJfqidbea
+5FSe5Jb6RqZqIvfP0w/EZocDnSv/BD5tP0y1LtD7xE2ZF0LNeX+AI7ar+hFUBZllAqZpcvWFF9C
cX0TUEPbm89ubQqn2iWcP62v1duMJI872WcIRkQO14ua61x/LoyFitaxIRc7vorMv+lp9JvtU7RI
w3zxTu3LQD5t9ltPWQ7lb8qtYAeaZbkbts9OBrF+J7W1fjOih7YTBsWHQot/+9conmvIpD98oSZz
xp8ufd99U2MmdqiNSkWO1LFBdR6ZtZfTURHT2kZK48SXbTMKrzF/9M67RmMeEveFDHcn2YqvDjGN
FfNeivDnEkDOoRoXV5LcgvvAxSgFctgWJSe/KUF16jhqFyiP9z2NV8kw+18ArzCaGmw43Elr54PS
vi/cwsSs89sepQ/FfqegKRWtbLbODo1bavU6G83ziOkYZSQkwtZnEN2Wp4GrR4S6BvlvdE5QP+xB
A0NQBAf+UF2rJIsXV2emxrq9hosUQgwIDf6I2+Fe9953QvAoxvffB9jtNlk33s82nsHn8CuTjhM/
FZ002dTS4jvgYvezG/QzElhN5TaZ798Xv3/i7X0Mr69n8XzAjS5P8Oroaa2DoOCqYMldQhFCHKtS
RMi/UWwry9xlZvrHeQs0oJiEWyUfZr5HuepekB1vQFsmJXKgER81jEgwzA1MGOUqY3Nd4VeSHGzm
CPYJGGxIk637ALWsXsVyLeJ8fSvhf3t3BnWofef9LjREtJtubo01LXCzSBmJR9EsL2L2teOt4F1E
KcYKpbh/iogDmvOZW3WCweF8HRnXhuaBAT2rw/tYGgE/78C9ktkYGQsmn5HrZ5zqiyz9dFGYqGsu
SFgbtpsz5t9y+wkRvG4ebgU/N/M/YatJqzr9eCmkqj0cNu3wgyZGEVdKmOyD9xuJZgxHipyHZi6K
JFkx5QlFUuMMVnh4kS3GFL6TTRWgrFjSHTlYJnvaLU7u46bQxJ71RMUvPF7LDmnVtYKUioG5YuaI
2hOpZni2oRhK+dUXEED5cn3DTtmUxtot4W1glrInwH6sjnZfAlJ3jhpcHCMb/4T5PkD6tYGVOoj0
3jS7ZNu94g6fX2nkAehiFH2Sw5lbamZKunDM7UvFG9i0fTrTltCoMAobQpET4MhF7vCQCz/y9XJR
dNP2p6m8W1SnKLv/ata2hsdTyDli96eHtg+diNj6uVhAB0gLXRS8JfufCIKxnoqrsm0CDT3kVnR8
8JhDff0XuhNDnSgFKydGEios9++AS8EUv1YtKhlvAxx7njq3hz039LEIkUm5UNKiTmF03xjB17Ut
Xj86r98FH0RQp7/xi87ziFS7NiChxEuehn4PFBDWp9IQ86wmLjKTB8lvovyjeuDvzOYXLeqq7g+J
UJqBC4bmapGYsqVD4X+2cjgzlG43CSooeu7FjViFUa8eiKCtVS5ludPEAhWnDwaVQAC4fe3/iiWY
AI+MczD5qIwEh8OGFvD6xTe9S365M/b7Ncc0fMAeTGQ3CK8FAk3IJogs2jlEDCod8v9+QjZ/YewZ
wHP3b/LHctH9oQzrqM1sLSjiGIhcQZkBtAhx04KiB0Ob1WNAt1Zm7KHGmqkJ74joKzZfpFc3KMmb
Dt4mkw6ti6/0dYpaUTuxMzd1b0xCDTei1VmGXEIn+LDp9y+H31lEuvCpX6iWT2CkCzvMgqtjSmR2
gYUhRIKKk7vYOflaYNcyuiNU9msIZmwF3UH27OPSDFPJMVo2moQ6htOgyrYiuai3cJ7bOgmrBhX0
2FFimGnTkkzDwN7gLI0pXpQdwkDp76whONkTW5y/bhS6P+3Iy1iErRsAMQclDIzPK2y8vLg+J8SZ
qunIxJa/IMN0+T6mYn7Jpe88ZL0gNk2N7DvUrNEZ7Hlk5J3Fpyt6614zMlVK8HyGitJDcsJPQWw1
6LwUzhxrbqSBmUFE+skysNLamVeXeks2UBK8roG6+fNCRLtaM1cLygENE59XwacGU5NKESMLMjZ2
Moho2ntoVbgMP0aS4bbeFSTqsHY3hEvE0yf3DIrEB1RP2uQ654k3AbQTj6YG9g+sduniSltmaLG+
lzp2S9sEn0w3ire7/iqsoetN79hb/sY/WoZ1ASseidcLAbjq0wAEAcAV/j9AYZNXu5okUzlss6mi
2EJ1vmUR3xSlVCHJ8VwLc10sTpchwjxZO8/4MuW2Qzj6BkFqZOe1+XflOijfA+XtmkxuAHwT2mTA
/QuyMdTWsVJrky6pLyxsgUx5dF68O/LSicC+T6Gc2Sx6nSmckUM5n0hHCKBNL4UHYrRZJgv5WF3U
63iNxlf7eBlBt+b/GhRXa0jcQS87DrFo9u9z2shQemFrO6SElMv5SjaSIyp8rggdlN0ydO0Yn4X+
DD2VHcuPfdI2XIa0zeAmxZkrTVPmsXvioipVEte/XQTzC/qnpv5j+uzQTq5zzV5bbt1hsUSwZPxf
vff6aJHhADd5eEIvCdjNZ3T1HfjK85HvegBC865hYm5eSMPOibKtTYFhA7BIxyS5pNqcdzjcyni6
KBOMmPMmOm88mUSYpH1tAWCp7Jv71w7+xwOhG1mjdGz5+ANGI7BYWLLgbM9E4bqIM/LsiO1Xsh7U
qbUrNQ6NVRdFEkOBrGqWFuHf6pbJpxD9+qW43zX7xKn3xbN2ztvbNrsPYgn+2wJlFzWlnJLXLNtP
St33DUlsa1YzOZtXB+rgBJ0WZIBcnU7loyhiG6XO6h4mN+N8FDBukTczhxQo39D68gCOktSTP3ym
Li0V6eYN1y4N6sTcYa1RyX8S6WATiRqChT8AQcpjgbMweQzPXNzQtvor0Ww48hEwKK8Iozgv+jBQ
FC8DPj5sU0ALqEMa5PJPx5HEhCVyo7Pnees5OngrcKRwmGaGfD0bSnnJ9p2d3G0lzaOYiBySEQd9
PSdwF7/p6WLIU8gD+ynCMTazox/tvrDXCkmqYXmClP7pV4rLxTtU2LzdSKu1NWFYu5weqFaBO/OH
VoOOOaKx3LkD28JA65Xq1wgR2wEKMXxL3mfXOTryjLX9vcZUJlGJm4fdMR2ueqhm/vZqQ1GNhMfN
o0frXgHvAoALi3hzeZi97fmBickEtI6kWbL28uuADAIJ/tdvrAL1umC5SIlCG+wdDh18ucGcrpr/
AvsjnSR+WrYaHM7EJLb65Na71Z92U5zFZ1Zo6+mo6Wx076kdNo6MwM38n3H4vpuz5k4gpVnQYhCz
YH6qa3uyVoMXPpYg44mr0LxIJ/r3kJfHNA/CHqjdQNVFNKXa+gZZK7MH4oj0ep/z8KXAgOdbI7CI
wFzD3KxOEKaG4mzsxcN9teCl5SJ/LPKOpqspNWV4bx/Yc/UFLukPtfgxyRnL8kXS3XrmMxesG7aK
j7F9ovNItP4aIG00JQfyn7E20biL6PUTw9K82fMEXwEAtlgKMySvL9yYEXelQn7Damidhu3ABvHM
dX97VWlfgKGj761t3VtWpZfGyjTLOCU84PUlFVmiuww32K8T8csKS87hBNHRN06TmBFSNnqpWVJ4
KzLv+oWxc9YffZQtxFxp/6VmqWCEaqiYhUYr4acxlJPA0BqIZbMYF4a4B+yBnpVtTKNFjg0ogvYU
GT/ab2rXI6rYFoegBpjTXxb6tQuuOs/rmXSucWwkpue06e8RGGomWlM/xAkKB8s1kgyzyUr7YdCV
XLEE7mfoIr458buS1Tb3EcWdfM53QApoDrmkaToDTNm75xBzlPSFNNKa657DawQLlYHy1/xk7ZB/
zhrudAgV1VLlkfoMfRx0CfCVT83/XVxjS4FyRHM5kCPcQtj1iVowTzGvTxoBLJuzBcRC0YvNZpkL
bXINQrFEuGzXQ8O+mxR0276YIR3X/FCUI3PKl5o9h7nf2TGstykqnqohKgFXABunfzrcXEPnI/7O
GDiYZawjFYLINvCbY6jtGR/QazFaJk5ZkYbxUAz31o+SI8kMf7ITuh61sEBj3y6pBtxmRigGdIol
tQ0rDMFL3ld9YDk8Lg4EcY1sbgKGKHfVLwkGJ4VJ0RylYPTHnx6AkRJuK1Xvk9xKSSF0QqqU9tpJ
3JghXUbLKIn0+rgzEgpmL1Fo/azKq/ImDL3dOqeZj2MGd5iFopUvnx3ROjG8Slbu0oO6zuZNjkPd
A1f5g9BcQpqB2a3SQM6IiLuIeqgSeQN//VfJGfCcaG/ihh4KjAK7fMnrig1pDTgAXUZRbpeXMpzh
ry/vnKsvZvGZKZ2uKp2+ysKPHaaj++MFKYmHevUZaCE2VO+rcZiU470oohag5Fz71xyDhMnLbhpD
br/vsL3YsXEiiAKz1pfRiImln24GaELcNLzuNvTx/KlRk7MV9G9hKAdG+ZDwV+3Mtw7mCvAf2RAq
PSf9BQxbxrDHq7yNdNB62VE4EYeiXe7ovydEdTYV77t4gKS3Ewen7ntbFICz+tD6Z+pSY1t7tHoH
PhNmyliBWTdVkiD4Ev7lGlSJmoRFaYGkhBDzhVtb6LRpxvP0AcAJUKljbnTiDEoV8pEtBLUY0lVc
krthPJa/BTGF0gZKc4YK5+Yqn1vEgcqfN1CJfQzGZs31qAhVPUKudnJ4Tgm3NIb+jzCpBElhtuQE
cQn7WTk5tc7+Mehr2iUlpKXx9y/B/B42YxjCm2SO/Prp9bMWxVSaHw0cQ42wbL0AdOx0WnLoqn8O
icb0/6oOfdzpprEiD5LxEZ2qXjMksCDRBTUHI+LwW+p1RhAELQTG3eRJuZrUrE/3Co9CuJfV8jTc
dhj9+SKihdVfESextz35rtPOAjiQGq5kQkVH1WGhCVHthMcCKi5p83o3FsnDgDffyTWDCkFdWAbU
CT0wFpnDZn97Vy4RN19vddY6bl2KdZBjANfwFL187xIWmRwb+NX23/NIf536wEYrQBgiIfjU+tY6
dwLe/fGzxTRX1m/f2pVOhNVw2+ftJbdUc2UOk8pMfYCQpKKao0suuirDL37oKULNJJ4zKVBSo79c
IQGWPFY9ON6k4wvRIH71+iVaaaW3m+BMqNCFlQ5GuSg75RzxZlISuddjo1NfgTUyKaPcUrMHvI06
nFgAkf2gThssl6oQF/XI5ohzE4/LtpgxZIBUDe4qQ2UCmFFyKXLPYPlbiTZdrpebqqLigmtkR0BB
ry1JroY/mNT+ZR6HBB5glAcMUhedF0VNUQqIjwDLZe9GMLe8ebYcIRso3VokmXLq+fCf99OQYFfl
CXdk+qUvzkg2xPKsRUBSglfLj6+EBOG2WK3VULqgIXgHinW6aXeJd2H+m5nagTXOGU63XkXf6ZFt
+qdMQKdYGzptjkvd0qnYkyFMTidgebPoCOMaV+LedkYsshP/z09N5QWU6HPFbJaXQT/nX748x7cs
TSuM7hrnfQvBQkgbJow4Twv//nFMb3VC1jelGLeEEENlNRmNgBHIV9zBm1WnUnNN65ND1o+De9DM
eA5dTqqujDG5jBlc4ttlmtSXuRhfhSqPDcpteh/F2tmVj5e1U+RwBXgRwp2Y5HJ5+DXRRiULCcES
2huo4H991jFV3/vi0Ym1/kySZpHyP02ilF8sx8xedI0E8kVuLlbEzBFwHCA4DDDJsnG5heSrBPAN
apLQxRooJGnUtLcIuFgZMyYVanmknE3tibM9s4VpvhEzZMB3hBY1jtitHvXhHiKUTEFaElp0zkGP
htznTVkWT0SO+0RoJmbeTPdjK1p0qu8RpszBt14kNEn7X0wuKyYD5YJbao+7zfjSzjVdpiH8omHa
+fxp6R+gIDlFjLLk/Duqj+xoh5famH7QhaCldkmlyrzV3u0D5PndbaaOkgq4/wfUZODctOuxGBEH
36RLIU9yAKbs8Xh5itbyTK7G3r6aL/mGfE4rXbvL/6HQB+LRi+bsVWRKl5DvmBnVgu+H28uQmo7B
CSAYye98m1HKLDnBJdAOHFT69eYKK81CU6Gb/7vY7jLOFyzgL9wsyi/u90zNI3Gqwk4CEO+N4Nit
M1L4IoIUBPqWhEIruTIeVExTjTMrsJjG+Gu3GG7rgHTQPo4lOCzDW5RuF9Lx7AGxncnVaR5OL6DT
9IEs5YhudXdX7PJ8URtrryHkl2IlfPQuFJH1o2XiRm+6cuJJkLYtuXz9iVH7V8NA5GHp6WoG3tMB
ToTRvcTSGqs9CGNRrMPZRB0w60b510UdQPN9VM/bMdHGcv+z5kPyeAXRYEq8Gx6QAxVb7Sy+/IZP
8oMYfn62RTPr81FlbKT6f3ZUuDQbEsligKvhcLOsf05r5jz/ZUtyEsASF307NnUii0xwnrgOQ8IS
xteP0eEa3RL4SmEODd0W6QOeJxR8IG5csAilWphUZRQGZpBTGjp0Cv8q7+idfmDnKTNmMQoacc4T
91TuRLYVhx2R/g6m/bt5lMDwTelOCRbvoCFmOTSLIfOxUuBcgzOFKKUQo8W95rDLzWsesytUYBsK
DcaHhtqOLJ1qnSSZeLCWGl8zwJpt6GlNqVKhwGPusZsnPqS+ycAbTZidV50rLvz2l9dd1wBq96PZ
wnzLRM0BqBjPl09adLowF55X1uUa43Vk4fiCCsELrqgLovHi4uJSIohFA8lr/X7wH/UB4h5etXnc
FzjNYvfN7e9dbZ1lYpuQJ4J54koYgDPoxOZhMOZA04crDqJ2N77MIe9yt1wUkNXpgnpyVG4fui4D
Mb+Vu+6dIRnZo3crhEMlHq4/lmz40FCi1iVZZjbBtzuX3qqEaIZJat7r3j3gEgbbDLS+TbNAzMUS
fhwUg0S8NL6EuwzmQFkoXdhJb/AsDKFOL7YAUjoXS2B3HTZ7l011jixjspEyuECU3yeuwXSNJ7Wz
B/ixKulLWs55v0V6ScDHLFoG/93h7Ium71u1A8nPN7SHPKpyLWaOjor03dlOjBTKkT5SJntK3W9P
s8w0StOLTgJKjGRXZeDI37Yo4tUVEICiKnffiimtBV90RvgkgHLcxb6mcNAmutyoy1fBprxLCig9
csQOXq5RMzj+7P1+qCiQIj+HgI1CEdGhUv1ENxgG3xFxVNtQdK37FahpuijhwjAy5ptSGV5PwgYU
7QqgiuY29ePwBYJiqYNkjQFvM9RzWck8NQYPGuzBoqoTfYTGfRlT6ESYeXyy5RabMLnkUyCeTKBw
/ptKi3qKQpLp5Rv17JLoUvouTU37Xrk/tFUpGoG2HiCtbx/YjlNbiQoiFgZ5fYJJqjEfwTIp+Qsa
xo08qGH6tg6nJvk5W6V0mYu7wdkjLTW2GE4TsLHv+raumHtlPscMlr2CWM7VesBg8pg/SUlGCect
oBzKtEna+XcKZ+AbWycMOxsWHXyFYlCShazyn2IhPH00/m25ST+Rt/ksWfhyREgSNmkSeL734Pbh
9Q0Yjrq5dwbyAPWkWBI/t9Tdj3u12ACWWUXfQcoF/9JrWgDS+YgZPXhPxU1y6qXwdrWHaHB6O55l
CFdUVoNfPd4UwKhSEqtL/ow1d/lzXCqrE/2zH+gvJ0xYKIItu8HnLS+lE3EF9w3KlFvCJMEOvFkF
B8C/E7HetxcyWaBtTGLZmVPxZyGigxmnrQ+BI6gIADtnOyQWnDcO+uWupGcJQOzg/aSbE1wmVCnk
NgKPl6ad8GfFCgaXBgtyb2uFCx9srSwd4aoqAWPQhVOV4nV4EVsL2YA63g5wXWi42Abns/dTeisX
zF/NvD3tUPpDuIkU5LRN1AK8Soj6Cth9YK/iRIPDh/3E6v4GznJfvLC2Cdl9gcrE2/Gm3CgBIGNl
J6MWYB5GpOOUJJDp+nhHe4iwO+VzEBxkzAUQfC+u/0gaE7haPfqbYltmQQHB0aWpbJGkSRgJE90W
DKNdbR2GNR8/Bi+QovV/546/Hqs8/Q7/E3sdyfTFsVXEmhlYyHWpwnP1DWY9c9waZfJ9Z5QxFlS6
1CLWM7F7r7Y0eVEnLoJgBkUx9ekOE9ecx/hKXfpSfN7F+8/xkcJda+l4dq4mPvf4DNiu28A/E7Qk
XBCpTNLPkR1MBSiB0Yhj2ze0/KaWC0JHcCdAdVjtraRvKzlf50u+kvhwO9GUu5ysBfeYy0Kv4DXR
PzW+NVAv/98MkADaTAfycFBusgTJv6BYmkdOvz/EV8I9M9JH5fUs65Jt48W6O2I7+8pL++28/auF
wt02wHydcQgJ+AkxBQ3iY/6SalJo9KmOaFvlDSM0/afQH2PBBbEDPL/keoeP06kK2WKtrAT7AnnQ
GvFel8khId1daIFZaFrDsr40dC/f8YZ9lXega/55yMT8BPzTp4aIC6ZQx4oj8JK7BEzyUd0xCvCj
meeVqITs4KyNckKID35LrsSRCU8ZCRu+eF+IPe6jWe9oM5GdoRS9HnTB2inNEMmTjZBj8QQKgROi
lNqfP1PPGvY5ZWmjnKBvEB4+snv+cnZqLEkslarChH43mB7hwx5sIEtFt6w9YSvaBkMAWzsfEoaN
BvqMJflS3OSNTnAagduUyCJPMBSmPnzAJ7hrKqC88sHxyRDjvoVSuGlavcF7jTK3QgcE8WpIiMzy
FnWMjqwpSaaxz+ktInuuDZn8SMiS/5SrQJkZXKnTdKTqRDNt6m7u4QCPRtWLoGShMSIlWu4jt6oU
1XCb/HbJhw9HWipBEe5CBWoJZYoKTA68OwV2XvGKND6hOe9sA+2bBFrVXK206z5+DxQS8Qz6zsZa
gW3VKonX1Q93OdxjHOq28q9RPf0bYouXBMpJwS/BM085sVL85BJpbprfDBotz7K2/2eliaP5Eayo
Dm8RPCdrQqYF59lNbgYwECM/cMwkgpXGkNnSfRpKsr7NwSmpmdcj0D7kfMuP7TnOkoj/P75PxCnK
IknFRloX1JtoccqsHqkeverekLPPi370PLdB8DHFd2oa82refsJ+9xUZBGuuaMqvbq7mnFTKfgvO
v0ibn2BJpxTbf1NWDRf1BaZYSjICGP4G6QAYVKQTAXpQHeioLw7AmlEWpnNXuYPCJUchtl9Hg7q/
/PPgpE11BDB54qDaG027I9Z71rTViSu/8bweZsPy86rXO7EdO5G1K10/zARVhGdEzVB0JbyESuOB
F0O0JdNKyFn3L53KG0r+eLRKHk63vwqpIq1NsOu5mlSLGEuZdQJmv6zo4lI2C5TFftf/ktqFzgtz
m6vgzAeHqvQy0zBBDny1vbmmVpIwj8GKdF5cCaRsvq+yYCduPX9y2g0F1KD/9fptHvy8MrQ8DygS
qZXunzEfbsuzRl8KWyHMZQtGDCWUUVYn1eRYSEJ/R0aOgCHSk6t53iqpMW9SNVfHgbQ5EkCfHTau
cyJfvnl/LacxZLnR1zIOl2SooGv4gL5b8J4s0JYJLAa820gVWYPffhH34fxR6Bmt8cUhfZwPU9o3
E44SrUkJPDOS6nV7Sbm8Sz7788PJjupNC6owHBS9JezvAcdr9MyCZmMGdLn7W+Nxe1Msuj4trgeV
We0anz2PyfCDNo8FJ2H664jJDcWr1IGrrZuqEUcNFezRCa4s9sqwXzOfoL9er7Ne1gNpFB1W2+un
x8B8rzG0hmQAXRPhKXDSfYKWGtbHJTu53krBJ+G1CU0ceZBX5GaDRleDi2zPrJWIhak0Bmg7pxbm
Kft4UOphX0hq6t5JF0CW1UDZyXCRcR5PTG0Cwr+8HXEAZab0ekQ+/kqG+mHep1hWK6PFEFyuHt4K
6U2DlHe/F/9dU5TsLt51Yk+rJtE64PMiYKhqLxDz7F0eK/5gz1gjwSeDashi/rPp2KNRRn6gK2gS
ky0ieDcA5k/acs7fpuhWNib5iI9IFQaEBmq2+2T1QV3h6Em2Jw81yzKL7QlAHD0H6N3oX4KW171n
c9VxTS9sxUxU+Hdme2P16xw8eZoo+fJG31RSabIAOf509oZGh2v72QCFxsFVZQ2U/nibuinUSpIq
i17p1C0qv84XicEl/Y5IP2/MLYbPypEOH4RXCPDPoJUn5KtK6KcXYChMmZpc+g8QayCenikXiaSc
0dEpi+iNrjgdGSiwHdU9lkWSHqRO4Oy3xI3UO59m1u3Sw41E6r3o92vcJyBRLXAHeVafhjwgUh0G
FEgeJn2J0HSnzqSVP2rVEjWOlxPnAd52B+WP6iXLr0/pEEHfnHz8kRi/swwglV0yH5rhtbFfZ3ri
JS01TCtk8PWAT5CWO4k8c97lJACMzhK7NywtYharsgAJhzFDWE5r7JD+wyzmKQPTAZQswZTDe0U9
fXyEfb1SK6mKFnl04UOGYsLINYi+ccJ3BtTfLKOpeEdtrag2rGhR5dF2dVY0CX7ZWkA2Zs2S+pmk
YQV812l7Nw5rqB+t9l7f2R8tNW6232rRt18L04zsJOR5U6Px8zMRjcCXkvE2zFkSq1mY/VPm97m7
wPszxn67I3ahCq356OGUU/ldQEej0SFb0JQMmCi1hDfcBkTNNEFo3FvF7KrStYCxYKlYctLuVkiS
rBQlAIPGrQNHbow/saN3LeUpvuVRBuxILcuYyjNqRKXrqn3x2GsxM3HF/YZuwop+d7+E6hU1XHNc
C6VzjVhL48OnHyHG6N8E2aqoM/EpeTvNbqeEqa8svM4VUSifVt8d/zTAdgJzEXr56u+sRrxMExSy
h7DBb4gY4jH/XyudgLQY247pkDJUe/r6r345NpACmcgAVB8isoZc66ArMBSd2VvDocC7UQ5s7Ks9
9ntiOOwsFbJ8jdjSS0MXEpEmq14vJO27AutHvalvgjfTPQ/OLRzk27aRVLIbrgt7ZXk4sEih4nqn
hSAiQjA7En3TsU2bUkgPmLEULOV7AP/7z45jtm/Lnll4Mlz5hS0wCN2+x71WqgYP0Q7FS8+RgIlu
PI1PTa19Ak/PsMlWH5bWNDc557gAYDKsF5gPjgCxMf+HNuC90wlhImOTJOKNt+b+bC3FAVva5bxs
3j/tCPjA8m5rEMsU01S66c23gV6UvKiXNOUWEfLRzWOGQO9WUSSUN5Lwp0oSR5ifco7pHkCMZNq2
1Y1H2a/UuvFY7w7m75zEoSA3/xEbFTJ6Fy+UUEy5wb68Ejoc467mcDDvcfQdTXZnvKqzXcFGE6CV
A7gL/7/5GgZjQuFVwaoIBEUhEzDBq+NCwALsQzMrHBtbEWSZGZK+nkbUvtOcx9Eo0fKq0xiBwhkL
mey2GRlaqY+i7TYOzJDRjdc+Q7kOV+oXroL2owOgW7sjIASKTVA+RQCHqf+eqjftJmr1nzKudCdc
TWdXZBUgHeQyDlV/tu3kvlb0Qw7dQ+fE9Hu5n3KjC7CZB3Ec6/nD3I9eLSAQBcCAYz04izNfMMdB
Dok0fUoU+ZbE74RpuaOscYzweOztYDu23OKaYnvOsnvRxvcqCJrO3sGM8TF1PWcm2G+TEVTSxYR3
ijyd6OuYeMxHDlN79J6IzgLqI20eikIavsPqh2ARWTIiNWfc8+j/7LbVAJLKYTFn2/mIk4k47Zkn
BRaXYh6m09uJ/sd9Y95sI/79bnNGnq3TY58UXNDiX0ydpvlXEwp3QzUce3gvLeF0BYgBJ6WYqQGh
UuLJhrVcWosRpqgbm/Bet/bXMVa1i42VD30q0ZZ4kRrIFV+vedMz/cM+Q5FJhBCK9Q7GTylcfAff
/Fvht98FCWb8X89CSRLoZs1xtLBRA8tYiIrziiyrbjhIX83T5eQvcJlT3VOMKMbNuuV8YPYXXRbd
PdvRFrwCRsInFhrLx2cW1KMr7n8597ev7fLNyO0kwREaUxO05ayfweaftNyh472JptGwr9x99FPW
nyYa72lE7jYvXVY+h4VPrAmPTWdxuUkaurj8TWmCF87FCsXXC7tSuNhUbv5PmLlTnAGGVszAoQqw
Ou4An4FBfvlD2yr/hSHUKSp/malmhkyl/T0Lt4nrnCut8Z7iH6lNSTefATOwvll/iPaGBhmjNynA
JR2MjYqHy9/yfTaPWhyWIfZ9dSfGiH4ciT9NZwKfnjLZowee6NdOyZREpD7bhFGEgsFShZy3JuX0
vEHokHiEu5tiFBXGnOQyfeiiR0MpPv2EBOuB0hiKxrFVePm1jNskI28j6T9W6sS/vIDkIJgMyjpM
K1E3bE2uqHQbftW36251OB6uZRFEQMeuIGPn12SlfKu1zoKTDemPEJGDnuD4Mmt/A33txhgD53AU
wl4PrrbWL1DesmNDlp3KvaPCl9vDk1o9ovuo7eSjhEmS2AA540wBYZ5VTjQ3czUBVd4SmrtekgiB
Q8o8N+7p4CS0UlzmFF9Y6bWOfeLPt+P4jFnNXmMpFK+/RBZrHgd0Y+jvfptzIQCgy9CyvXpvNbS/
u8GAYYhFnsbFLDJm5aNOP9Eqa7soS7hPWS8bhVfz9tlN99k2ZDVGs3F1dDCl0TurWGGJvZe0p0wy
O9pICjIRy5+PxG5NJrAE9ZHlvrTkGmRDQDF229XVOZBkTDJYOLwD3c6+psofGelCltDbgSKG+Xu4
I9XPp2ifT1/08HkJjSqAiqRvm7sIbpfN5MwhbuVs6ez4iB438HCMbKjju/NGT+p9fmQqg8p8c93q
L+W5YlfJ9YOa1XPPkgwAMjkvIo5pdpPYTSCN6wC7B0jhUY3Gq9gSW65WtqXzofisv5iaGtgV6LVH
NJrxkBZ0Io1rrkpRK6MURIUsxkCAOUye/BW92kM81/M4vuvqgOcUOG+U72nGssctqbewb+IvCNZf
H7IOGQAXUW1FqjcsxnVa+Lg3/UWkSlYnT30Dlf66xT4h2iOX2SBgKw3lHT8XmTC4RZt4FnPRMgl8
9XybGXC16flAqeWsOc+/oY6c3ubNkUVwJnFrfxR72AAlqiUYjiEMckt/AqtbrDSkIZlWiGfMs5Ml
py00kXRsnvKXuROts520NVWWRwwxBEr8HaHGfmM99RXUCIzUsBxBiNtwfVdoE1l8lzKEYBg1PMEW
1vg2b9Z5Q+dmmZVi+CYsaq+ciwMGKaAYC4ivUrRCUDBarw3ft5Gfw9inQxpZ9kcFMPsYOBTwmTd/
YRJxTdGWdWPozXd0bI8dWjbz1AXT5RicJ/zFeSlCaxrcdKr8GFArVZ1ZYX2/PJ2Yk5IM5k8Xz4nX
x9SP9Kk2BXdoErTfpTSXBSqXXoRr+OS99mZokG/UizkXGqTXNf29fQM3T9yot1RhKxzlfQoFTG+x
pCb+Ll+ndtRRSDmYWSao3F/SLZgiLAxOY/E2wmqA3T1YcXchL4zF/mqjND1kB7F9bPW2cYdOYpG9
i0k7gaaO4BK8FXzYaa5jFe0tCSUYdgqR+uBWTCHw9+8blRxyCvjNgU9YSWoP18FwZSXzYX0Sidh+
B8KUYby8Ya2q1v2mkFvwZSeFPqwa9RVAeG99fE5wqBqoMh/IvCjyDgqSXmxpArkHLLi90hEfDUCU
48xVw2WlEf8XUATikFZ2NX6hfk3fu3W4TOgLLmSTPNcztlUaS5ljcLqDKlUpCU46NZ0AR95ouaJY
2JAQ2YXMwmePGdFJ8tw/adGuTQhgdM7KLoQwohJnYoTAyYToOGVqC7xWdVsFjqQdzWcdJzJBB/6B
jEQKmG98Xj/6j5l0C7mBR7KtvlKq46q57Q3ZTCpCqIekYxHXxmuZJWu+w+JvPfnlUJoB68gZo92k
X7HkQ00tgbO+5NktyVI5uNRRq+/Ab35L5c8EbyUCcNLzMUA+cHp0X3Yxnhh6OPyEgfrjrYqsHnk8
dpj/AmBAkKu2CvYOnx3rGc29WGsPJq1Z70CjE3sQr0fIL16MsaOVZhKCqdKB+6XmqvzZLqtHSjjI
sdHoYazPy/pNvrjBzZA8bv91FLG5egEEMrmLaTexxlqD5mE+EgTDlto06HoDHkv7FZpZFouNAdnN
Wb1r/3Zk3QFQMiiaLuGy+LJQIIv8glNTBJTQSTq+TeAFI6CyYskis3ARMEqlMSzHUr3diKFWJDDM
05qm8GzDN/rqAx4PQ2GjoUssmBNKglICiPGXFiqkiNe5N/bu/8J2xVaJIPqbUcd9cOlz8vbGml0C
5GHwEpcgdQwLfrYXC/6NZ2LijqYMokSOeAziv46flLZtQSMPkKELZs8yoqwQZojEIxYz1vOg1O3+
8OmNvsjNqYv+2ORaISw5ptCfrvTowV0M9O6YoyzxR0g/5tx8ku3U+2VXk661o82JLU3S4W5dLClV
GEIiN5+HxTAeaUhHFyS1VNfTipthq4CisXA2m4BY7+iv/CBCUgAlktLW3uy8EHjO9o1LWT3wis9V
6lRyssmBtwHj9lMtW9OhBaw8JU9MNewTzPdAvKlYmWtputJA+QmM8jOPtk1gpTUjvLVu1s3tuIdI
i1PClK2iVT4LCnC2aZVv1bylzj14sOcxX8yjPoyx/Oll8MZGsmjDHtG2fJJKSVLAeZV8qv4+I4rs
DLuxr+JHj51jiKFvaA1hvv6Uai6aXPpabiKfRRaGYMssJcnuUk2ncSlXLki5kg7s8KVfDSzCYNL0
kLuUL0gYy9PVM6qAOF4GTv4bKXsnGTRuw6vPmb9gnjhJqvmnwAKcv6bHIBHTR5/CuXnc2VYP8rz0
l1ozcEegtQE8Mb2cuFDPaKXi+55L8kA9bBodUZwALDPrYLXByPEIZW/Exk8jIw3YUhz7XOHfUDVw
gXY3FkDwqsFquxQZpemRZ7rtzaAeSuxBDfGDLHiRNjhp7kwlv0dF8akN/i6NGjX8k8H1/cFRk9Go
Oeqb+2jxlDA6FBa5z1X+1ZGmtsKUmNm/2NVFEKNTlgRgtlkDXcF4IuQtrenk2j1amudHMfqLPTlg
939+OxVXkZAUY3FcdwCJS9Yem4ZrqDotnMcW+QeVhrLdbblgUevJja5AR6GOQEPjJT8mMJjN0Qvo
UvDjC0V4BNb80sxrrVdUE3hd9wHPjkKTBCFzhd1PMRAkFxETdYPxOcnaTYSfsiI92hk+taq9rw+G
d/v6WWvUUpNYw4iTGC5t4PHWnUCtYkH4fdHk8U+nwOFFSzj4GyKV7d2xPCmFIyZM+P24DdpRb0Y/
6difmbRL5go+APJlPGba9qGFlhrw6kKUNNHx57pmx2gJ2P7JJOQsMhNQQc8F0uN1yUHHqV+KwanX
4eOQ2FVV0W1wrecnyaL/XPwmuOM/fnWncnupvvAJmy+FDOG7HPT5ykEd81V4ELe0RyqjnmO5yTzE
2GQsnuLmfGGOQ4mKRt6JVNUQXXGu7AXJ3pJJ6YHSEMUcsoR15fTfeFyQX1vNaHh5nkH6A65k4wyY
vK3bvFPth6hpX+OHS1yHFaXM5KxB4N2z8DG/M0kbvIazB4XSC+zCN6wFU1l8xxNVLXN2akQHf3V0
U622Q9NE7MZJUEEgAnQ7KZ7GhbXnE2BVOCwYWFxtLlHlpy/7rMPBucbgGwtOfJbecU+wUIQlz1n5
qO5VmmS5eZ3t9ykdinQtxJlSs9N05yC7XpHKDOCSqYz/V5+acJn5Y0jIQBfCkUm7jo3QG3poWzSY
AMey9eGfDaDY2hXp9vkjtbiWU1h4Eu4Sb1w/bsMenMIzbWPQVTU39/JZaOYeARWGLsaWoWBUVELF
RK/+/Xm/YXHrc5CegnnsTQcOIKhiwkw53J49q/hAxG9j655GMVpBHOrUBrC9pvXdTHDnh7eNrWlw
C6u2WbYfcKqu3fXHsz1HqtaN7BWxVNPuTgprCJbu3eZsnjZ7vHf5pAFZ22bt+1CpWJRFE8JKm6zv
ilnuYz3Mx2S7XeXm8d5CSsebdtpVTT1knpe8x4VVvhHavIdBBngfNIXHrBRQwYOs2nOm5hKOEHoJ
UuUduXj7wJuXXRFXlLgsfPEVateQfaKRmmcbqpVzcAnTH3oJ3l13+v5OCQ1CnQMcjaxPtyUz+QrO
aTX0uYW+WOEZhvfRXpndJw7iohFgjVmEqVs7qqvvJ9uOOopG/rflZQVna/kdmWIM3Fqz93D6Vlcj
BQY2Nu08JRDM4cI/++gVN5EteY2GZtttDfUqPCsocd3n1qgwBltrAYH3a/c5vfYbM+y6kmRsqvBw
YHPmfJv9z+Us/ktiEWLIzZzlSkssHJj2SORWcCOb8PNnAxH+ztoRQxRRYqO5+d5Zu/hQJ9hKqiKi
0lkyjZF+juDsSVWDE1ztLrCOsBzXi2b8rUBgQg20KPFy3mg3IJ6PYMrp/iWDwr4J6Ukw8vuQqnsp
aGJbfNC3tNhs/jO5CEHBxtNxN/IuJON1Q3ERapnl3uVMZAJoXfSAgGr2GUmkK8rtZ8Uc+Yvrti/X
xYLSg8dzwUTaXB31lpoU1aZ6kqifhkaqzghfiThUUsi+jU8I0zRwgE1maLVSGCEIuISvxpT+nAax
IGuST0RpS7buLoo07XOOuqrME+01NPwGYLWM364FZu3dvf8Nn7FmBds+pD4yIfSkgP+cRID/9X+D
ea11d+6mpivExG2YDzBpONiaQMTMxQaKOvFU4idBGFAcagfyDQTYq3Ewy0yq68RnPIJshRGmA9+9
tuSJCV6GEzRSsvcsc0raoUBmghDVAUAwuIkP6dAO7rl2vDly+PlTL3Ysq34kv+YDjVNt064I0LmI
1U62+xVyANH84bFciKLC92qCK4oABJGFbOLpui56liaZgJVyK73BZTbOS+wV7SwCNDJMjKCHQ3cm
Tcvp/AZC92/W9wUOweLZ1Xigv80qgpmFSskAXkGXDvUMQiqWbPpzLKxyqdYeaqW56aNRg2lxfOND
paiLQ5FnmUQc3CU9+WNzZW/Pe8L/et1rNu9uxx4ErU9yqsI6Ld1qEKqnGBHK188j4YV8bbPkfIhT
BVlfUchASZ6vxO+LqOKy7j8nQmGrO1KNgPxha9uSAQ54S7JIIvRFEz8OG596gGFkcNW8iWxqXnqc
mcIfiMJOPG7Lqf8HUBi6mjwIaVrof/AIjxHRWtLsgo2aYV7emKu9i5VCHAliUINThN33rhMLcYvc
FsKbMRYrhFNSPgMj8MFbG9S5yYdV/TXmetGXsJpYMNuS7+j5mfG44W8uN+gQUYgFaMHfcZq+/3Db
m4J7TvK3GcKdemlv/M5WHQRU8e8T/UD3i8xpcBx8Ae4SE4/TER5rPM6lft2OlModgIoKubvZn17U
M6NX6u/RnTZwjFgZd3RBK5Gu96zZl8ImBtvRnN01NaRyjKeLAZdkprCUTI0fnuH3e0MKy96paioQ
8+iMxItWm31ubZnOTaZlfTY+0Xn8p6Z8uAvVTeVTRUsuvO+Fr9WlE6OXqpuc1CLC+qmmewN7EH+b
Jee5zCr6u8kI4GPfTyTCAZeWsX2SzTAI5KYVytYNXzBflrTMmYMSCfy8avmpIWWgpiSPROz2m8Am
tPO2PmG4/19/ys+Z9NDqzIR0+Kdiz4YipoSqLJ/BwrVweMBX3bMTWZnb2O93Dkj4dXpFGglLddBS
ZjAIlikJCqOHgq7pxx1g8G4NPnxGx/bThbI0oBSwFG5RA6hUQlhfq5rffeV4vlEhqHHj6ovXMWxo
CNUZDMdmauQRGxEErZ1c2Ng5I3GlFDs8+GuSRmlXO0jQQvOu9KWtyHX3Z7DEoxdh86bzpEqy6hCw
6rogtr64FOUIeR9+vrvevrYor/otuZOXzCyvnpB4SC0ju5AgAuYI0GTRfF5RWdaM+iy4NAgqo1Et
9T7Fh2La7wMz9ceaCx+6ennG4qc15okbt6wG5yURkaIg1Gy7hlM01j8/HJylnTf6HFHR+/Z50RQd
f7tGBQ7tkutypk9/0xpvrzHY6ZWaa+zX+Lx6ReUD1XEVRItOWtfaqT5JcyFyEjcJ395AY9/mzMbK
wBoaY4qMn8QXNJUeBsf0n0eh8BlgY70GzF3VfQZsK1AMGG57YMXRrOU3540dy7W/R/37gnnDTeXX
Z6sbxF6b/qmjj4nmuWoYkH632lSHjWX1FHdk1CX5FSs4cdVzDNzHQ+yLgEXLyp+znAO68GyAdSwb
+WJIu3BWzkbdsPn3extJtlbG7cAedU0zc1xIo54w96gVEgQD70jv2JrTdVJgvqhsXIP+QC39FU26
rmVyh4/O9HjuCeBUxDc76I54jB5ES0D4lUxJDqUM1tgVVoyxn1dEibc4m2nE0+iD7HXrDBLbeq8j
mg1A4QiQLA+Km1fq6nZzXBnw2h9F6iQMUjbLwHxxGAvTjkx+83tnul8iXp4lXtcp7mbUvuZkb7T8
hAeHdtkYOT/T5JqE9xnPqTBRSv6R15w1sXEcuWukZCKTszvj6vqKvU3XB3ZLMwyKQbo9/Jpn51nh
eC7J8x8b8GKjRUxuXjKH/Cnun3eeXaJUitbl2CgADMoUc4VI5cO8WZj+kH0HB0zHihPfTlZEYI9N
hycsDaikMXjsZRYnGQLIDLMNlCAjVmcgzgw5gW0lzbaRg1Wu4kUHbq494B6wFgfiY56/NnWNkX7s
G5eovRhfSX18TNeK9fwN/snlWxdJx+h+svpTCvCP29J+72VRPj4vzbZusO2ezQ5K+SiBKiKBYcXh
GIKPng3+nLaoGWTN1ui5ez0/PyfCreUNU4xy00Pu0g/Y/XwbHMHsDqlrZhykZjQXQQ+kBPn7HAQ+
ZSfnTSyqITUZm6bIzp7y4sxmBSiFWNw9jkwHDCly2b0yUJKRxEbSbhLJip6rsHAScZxl9RdWXIOP
xWy5nZ2ioHqp8QRp+7Xz1PPEZ1XtGphFBB/EgqhOZRsw48J6fFdRO/7zn1Vg3ijJUPzzVAdpjczO
Ctn+LE2xkEnygmwr2TzPtotMYZwPDKUsbUQJu/Z8g6xbaAYNtPEXvJkILKFCr4CCzkDxr1wxbpyV
huV36GE4CwQbFQwvb7Gvt6K5Q7NKqhVvT0/nbGEl9pXARUkkcEswjP/H/bti6274A//P5C1qqEhU
hzq8EWkVlxp7EywrvlyAqgIqOXDxlspvR5TgDczRt+nzAPQ6SO33qk4GvRtzBqG/CC8ADugJWIxM
0OeHnf9cQ/Zjfp+/mWFC0k7xhR4Aplg/czSUtTgiczwkImCOVDN7wtHVWiwuufrsvnhSmVnou0KV
d3HMLcS//nkzD0pSzppd5BQjnv/v9aJErlIgKWdccQYq/kwmLx52X2iV+5KC1b0PvXDs+a7CtoIU
Pb11EOEjPJi3Oyy0hz7eACKL8jkTfWGKyThyBBcBCsGwT5DZul8VnmdjvTchIuFZw4MgwRhBjZ9m
GP2ovZ2xQZTMJjp50SsoGe9vxq8Y0Qefzh0b/xyfVujL6CDNtlpOq2kHmdih73QR2EraF4KLwE0B
gocTIpbbVCQZtHTN88C6ubMNYLe55qgNbObEC9eQlH7ikJGKjL5aVrNpc7G3u1KPa5SGy8QD91Ve
fZS7Nn6suHyG5kWwqJTDLgKlevup4m+tQM9dtnEly312ReIbRy0jbF2//MxsIX2i/wbIAUxU6aw8
hyCskBAnXwXhKkSH7mSwXZ7gwZu72kTnrz0DSSyVcfKWu8O3HImbAE3c3/SvICg7DCjjm8Igt1L4
hKF5ZR/q9psH8OM6QBVg2Ch15qAyDZhqAQE5aTLuPDq3LdzfnUEqLrDoC1eX5DLVuDODI2Gw0rhW
lvr/qZj+BU/rmAU5HkORjeg7nBWATw3Joyb6IuDuK31u8RuAG924fN29NMpnTDtRgAYXL7zsZCh6
MqqjlKElSq0HZQvDe3sBSXVPn4msqmjtPfFTVU4gZECZzi9c8HU4r9/y0GOsJ7j7RrG0Nk0u7QS9
6myDK0CQu9yGMW/Xc1L2UScTiXnjHQlStQRnIpcXpjmQj632Pw/24fAyybGFe6Njp+KvNaVBFhfy
fLv0JZJ/Mua0KTQ5RduZMjIioU/IX7DIKmKNhG5x3EVLqrwEkq71iwE0QX92OBIdjzEdgUyQZ6+U
YAiBLzn0OM5zJUpvxiZZKv7KcOXhlmYMNaZRMMcCu3dKiOOqBww7zTwuwEl36gziSbvoIM9vOS3j
26T6KK++bVJBfjcPU+ofUqvWD4vNS5TaIBf9aEQhE+t/5Mz+E2NlCd9mGfG3GpbZ3kUOVWP4BSaE
b8DaTWkClYI8Z6pPUjtDRVkhDexf2ZdhufdI7kDeHxo6n0vGF90szowxActwTFCuffDA9nMAzNpA
YorK1DQwYV4Owk3FBhkm99Tax9j2/kCeWmqlHgZ7j23QBtC0kwfc0xM1u40NhauqC4mrZY8mtsS6
QwLlkNopnm6Ncn+7QK/yEIS0axd3aTkqOtojmcjMC5+5oimps0dmVsou6WTGhOcx1cZKiW53Kvpk
+mblZj/3I2ODPFkEoCK5QziOMr29ASRr6bLEEH4ectXHSsFksTb2Ig2FkAsYnDHfFdU4VfWoqNSl
6gb2jRnHo76rI8UlspL5cKQ/TIiEeL9WdGXFZJ59io2SIUTIvWo5YEWgjPZbro8vo+OwFiwoGGOu
SeAqEfOgObrKgZNZ5XedLCF2yQ5zy+aJ7EoQSxgrzxLrhyATLXCY1gdH2cHH9hVq6n8fqUy1opTG
V+7Z8cz4wszJH+WvmtltGxuBKgzjcEzUPyqZ8loO8tmxEQOFoGz4ZaoSpO1LeORU+wigiao5f6vh
suTZ1sHRTv2LUTczgiauhb1e1GNoJdpArK+LP/Wjsk7ymdWr19kZ2HnxPyTlYw9JiJKftgwltzkQ
JmkKAXRNsWA0mxrKu2yy7HX5PCg5h3h82v9kSYdNW2MJRpUximOdQT3FPj+Uf1vvZq/xOMfzQETF
gsmp9RThGY82VGDyuCAz34igqzXWFhvp20iFTbLujOaE3KmjFIBWmiGCWyVdtLMUVFhJ6yiuihlm
cizLEgtN6smFCYr047OC0cQI0n1YpLVvUu8RytdRpcAJ89Og5Xyfy4OJELQKa32f/jsbProOShno
dosrh2G4Cpzg52e1WATfvzFE3U0BFDlMetWqpA8ScMHhEKFK7kNF/8YhDZnpkc9Dtkpg4VRgnIUF
PTg9YjHEKkV+gJLDzdYLaVyhDKO9jm5u5lY345gpevRgfO/HdCExvIaYO6+fWohNJ60+pxbs5qci
guzFaql8qEmSRdzGBihWkvRyN/M14RJKFWkg9UnuD2vZWO50YIcKEZArgPnNBsRtRRbeXsqqAT1M
mQ3ZYNaipWW63d1z7vUMJikORaYR4hXlwadgfiZ+ybAZm9q8z3/YbgNy+g1dD1Rl+knDANeXzasV
9nxE2GqtLi2KEeWWt+I23jANDUQX0xVgls4jsNQIYv6MRW8DVwToc/chw7HP5mQ4Jv1NOW3MtEEn
f2tkiEgHl/kVEiZrR80u1asg7bhYg4dh2O49mVOG+WeRxZRzXyAfFcAa2kBNf8jsRIXOKSQUBsWP
x44/3eUj4ACvcdImm8Qr5PQb9NCvISO5WAdA/+W6ltSuEXJkLOKw7ntSCd1Ma54G0J98z2zj6BxG
br2Wl6Z1xDuXqnCNETks8Ap/oo7CwASwkOVXTarj0cUUWwOw2fbWf9KdshtLfcEhSCty+/zJH5PS
9dzk5pp/a+KCEkFMbk5XvpU+l6/EWWwfMIaCjAEyZ3xChBXHOLA9eE6RzkOxyPNJxdGg5brnCN6U
LXi++/g6hiYpESigbYVJ0rDlXzJfJvphi2xe365Q0KQzRJVZOtw9KghXdw1+Kjbv5yeRynsaznqQ
i8grD44zH4FFz+iuCyuWFoqF8lNLvuCFzA1IyoXsnMNmD/KUdZSk/02+IwRPstxn7TTN9X/dnD4g
k/1FtTSUt4dhfBEchbCtAMCHU5QcK1gms3fIeTih6mgBJTWzh/1jwGZyESgp9G1CLEuWxceJ3c0I
yACRZIn1FpEaW10L2A2wz+L9UCEDXjl9l3Qpl9SAHZ1ittmdml69vRjq++DzwJN+zy6EC7Huz5zE
fYi20Da9nUtv5mJLx5O6B5afha34+onh2N15qLOFAJCKCpTNy2cwn9uPg3dJ2nC0/KPnBYDWbNMR
8vMLwHIJ7ULdSP/s9edEpRZLlFfx+uHewGrlbp1I1LmjwNLt7HkcLyeq5hoRAwRnEIrPg2cbVnMK
vDk3PHYFOu+isGTvM1r28etzBPGEh+46aeAvIjk6UGDl/BNYp+FUkHpqMG8ey++vhm0t3b+EF4PG
cq2BYdYkcEYZorb0hzV1g8UpH5GcQtORwrmGTxQR9KbbCmfDfYSITVlZwEmPor0Kh2QS9sU/bB6n
HrQwkCRWmaAVaVlmu0dRJ2eGFJ12Gd05escOr4dYG9ID8uYr1pGqISPBzWNAmOuDYDmjfzrk5KLR
mf6O+bfSTUQaHQamwCaALFfd9qY18FfrpT0YlYgeIGEeT+cADkfmHFpRYuR4o8sgIVY/xtkwl/PL
iYUYzTr6uzN0aypjMBMstUL4i8QlzIsfC+Cu7sLrkQcxKuSnW6xBpdwZOU9TyLt+9s+SzIFmR3c7
XRzhvL3Xh9+XR+QDlSyTvABwcXc1F7aWfEghkgKKlhfM2yTwQiY6BSgWI2y4TSWVVpJ95FbodlXY
upmhfUvIny6MYkl1PpYZU05E2VzIsNmRtYley6VTucFD9EmACvEwBpynG2W4OgN5bGXkVNdbPT1M
GStzYTZUDltKAvoKeFzTAjhYsKb9wn2mSQZuO5S8ldr+7uqHSLYF3onPI5SSuGfwH3/9HDyLXFfg
zwXMJ7VOQZsqHckCVhDfzF0PLsTqFm015Hr48eXiJ9slfA8VjVVXSzXNbk39l6QsykYscpNGDa71
Re2M6Tcyn+gCor/inwEUCKKzES5RT/O+j7q4HrKWm/E7LYnHJKsKuG0NhfV4rO5a55CGV8IzfV/h
un4MyyOEThKIMRxJOnXIhF3l3no/FcwY41xaGz7yjR+H3csCTp7xrSkEgwIVutf7ZKfw3NcqMTcp
xalvggbleFY24kmvxrB/9QJF7Q1qiaqZ1L6JpSLRPHBzsJl0OSTH/1UcVIIaq1bXdXHUKsgCLZM1
jOGa/7IpLRxp2jZiWCOwAIKiVuHkk0d8VKt1C/2FBliKYysdKeN9RbXosA826k0zksgCJ4M66kn6
sAmgeLG22K+pi+mZ3sakjRKDLKCJUmMmaw9yZhIOmTGSDE6x83g7/89uoSraR14XdhI8lHoTsCYj
Nx99W/AQRKFZayCQ2Frf3nR2EcKELX0lI/+q4wZIpPzqtevBmMP8LUULCVPiY35y/g6mnabResUn
6RvDzr8rxXe05p3G3M3YOPQ62cKO9pEcetcwh2wqS7OfoihOo7RbI3I6yqxp7+hFyMxWJ1J9H8Kl
HNXHnywKL48HGpiGlfaCZJQjvM1bydhEMGFwtiNY3DjYWhN9CbX4OtNtSFkyCCykVgS7jnmpZN33
LzZhR2bP04qaf/dCYzDTgRHxsavbHURLFLrBew/BNTQmJeLCTD/NDco2RKxc3KRiM8Fq+fNEZCfp
rqQCcqGagIkJ7vIkro5ATu4o4CmyiQKPqAqhOnJDdeB5OdYUcOdK1ciaqFVa7YeB8o/eJJrNaidL
COonRLCxMEA+SlaZnXoPKswEbEK/4SYPazrgOZh25AaBYkDoPDXIXYuNS6W7AOyLWO8X515yDpQu
QL2REcm+kB5YkJ1yY6lDkTHv42p1UToCgt5XvSwhOXaTJk91oNQ5NqdKv3v30gY/YGuRGofGHGEs
l6yNY3nC9AYY9MGZ6VZV4dBh0YkZOciL+rLayhPczzmG2Hp+ROPrld09xHSdLlxtpf8+slY8wqSE
bj8+0XPrPe6nS26eaT5pnbZWrLqID/mRL4ucGFwhfe3K0Wwu3Z+FBCYlNVoYsfuG68i8fPnYtMLz
jWGNSG/RlV34L1lawz+BgVUNerOKeoWwSoMhkBSMynRMg0R0w0lWv+pfEIwcrU7zYHrr4gcVZNsX
f2w7s5IgI8GMmSWg0Vs/9UFN16fEqP046Q7fC2uxaboI/vn6pShIwprQMK0lLK3RsYcNmcdOrfM8
IVB/dmUxBSZ+4BFeCmZWLQCZjbng4SD8/VZQt/NzKtJcfEsTAWSX+DXKOk1VOOR6XkJcJKHGl7b7
fc+w14+2MBHmjmN8FGMm8GnE3AvldAYbqqt9JBkIYWMZuQExprfES7HpZobdVSkM5Vrb9SxqvWkd
5fa5gDuW6Cu/dd239/MjNLFWzOGzoNMOigO9Mh9kmoLuXAvWLW5N8P2Z2rNcPv9oaneRFHO0SiD8
SAp6kW2SDYtD3lOr+uuXfOU6TObx3iJHPadTyo7AUQK9icDZzFprwaOekzqcffjOnSfbDF656ce9
iATbcwKEYGq5QJ3FuNxeXJ2uY/1Oe1GLHk9VrDh/quTlKfyJiKa2yG7VFmKpof13UOh9VXwUpUj/
i3OYEk+CXLFYsbtq9f+OCeaI5xonmSXP3qKkHYo2sQdX/YhwcmxpJX5P4JrgxA5lzEZVisOGrYPJ
5Gw1JzVRxvV5LtEc3KPO3e34xasb98MSBfqLgZUExSdrZFS8ZGIyxuFklMVFtO0XR21BQ58owb93
UAxWHrX+J5S/bLD4NCnyj2JBhC2LsuIKDHttfVwH9l6szIvHUUOZG8KuRwQjX2RWwW1JLEzbd+vV
W0c4IjXZUy7JtxlSeU/GAKgK5F6uZKiCTlCxdtB3lrBuHBUxK6Tn+3Zkh4DrR4PKcQz3zhTQjuxL
BgHql8553fFgGePV0hz8V1XVgLMHpfG8SuBG06kejnAzWqB5UHHqCpIMA7SDl0Yumu+mGqdsg8Zv
N+8f1z/GzGb4OCXvTtY/2GpIet0tr6z53N797QyNBybUEH8KLqatRhp1ZzAoCGwK5llo/H1cK1Ht
/Khh7F58Y2nciHtg3jWw5Wl6/38zufD1uEVV9fz1/8w4piPNTcpznnJEktRci94oDFgTzpnz+WlF
TBIxv5i4LH5ntIxAtDEDqGlETf2FSbyBut9l8pB81QSURU+2JK/UvXrGu9iSECVNMLNPFi/SJwIe
cj3k3rfFpdoPXwtpzJMCG7uajTbIL8mlV1IQOsL1KoKOwtQ9RkFymR/IlX9x9sn9BvBZd3isEbc5
FwxuDLYCYBe2HyB/pwF2zH1bP3ONlMULi+VXgALDMsIOTI1Cw/DpmD2r6uffbvKAsMeLgS29l2dz
NVl/IaY0m7zS2D4z8hqiR4Ncg5Ca6tVtLH+fCrkUksyI+UhlD9guHwdF2PcA7DSnDXibjgHyNM2t
tv5R4cU9jvfqf4hrfOk7pPtKSmGGCaM47yTjwDAymZHHHDtXfzYO2dyM9fxinxsqTp5o0FMlQ6iI
zfo5xEl0NwwMge7SuIa66VwtX3lP3y3YSjmaPIaA1QC+E6K2Ju5D3R6jBBLYSi32iBT2Op6O+lgf
Dix7S3IUHht47H6iqW/5/I31JuwkbESd6AhKs0zweP111acqvQlCUYrdBGVjFhjLQnQbDivcbx23
hulaTZ+Snx9vj7cNHHmCbUeEKskLEB0mob4TVLaTm0bB0r46qK3nvvmnUEcA4CY1XWzldUZ4RoUc
8sw3r6OoQbCUexyKbtgDKyL5Npj+uxyQsC4cCHhzkRj+McPldmK4220gIKAm5g4xYf4GIyhbn1k2
/Cz1nC9PSf5A1d4LBTgXrU1ri0qV/Q7eY4ldIelt5QQ2RaWTgDaRvcUHsCSIYWF//CUcIbsDwxR7
FMCU2aX8SsRk5193Ru7Tl54p36eFzs666FbAHIzmMdc79tD9N2oZcPTYt4eknV+RR0CBvKvfDuyi
P3EnxocO7VAbqANOrqMu28patfxYNRIgTqqoFcfYYCDb2SFx7bjvn5ce+UeFKU3yLsXYQusYTaI4
X7HHk5hsDFdyzYmIPDdnaQUJydFQVr2u/IpeQ+6rq1dP9RI2L039wUKJ5WJkNj2rK7zjlSiyLNnW
EQTDuZAF7qQ830s/kF7z8/NSukFQ/MOh5vGwQsykj9ddm4KB36bSLdX59QAGK7a8/hLsxYXH63NH
kCgsyO1y2MAm4Fw32TGNfaiqjS2nCMBkc85ijDiLl7tIMXZq+wJn4U0adBJBZ+bQLq+xArhf2T4w
fxxA/xMxqRboyC5XZgO3zLO2J95fn6b0We7fZsWwJSrrRXkh8VVx+NtpO77nbbWlbpxNGNDbSG5R
d9v7Dtjnb046YGGj/G6zq3KBDcnEXF7BDwOh5jeqK67yfWf/ZO0GIzhMrwV8clnRTkk0oZ5q/JM3
q9Ol6ZQdp6/zD0P0X3DsbRorY2Keo/dQ41H9C4dsBqjDAqQvN6+5ONByfj2QpKAfOODbJX9r3IkI
DRpb/ROStlCWbXs1X7iEr1rfMaK1LyqngBlGaQlkv+82KyfLy6ouJuyA3Jerl90m3Xk26I7ibsIc
5EIBkJGHgQhzGeDT1DIUb2Ysl6218gvPoijsaclVZ7f/rJM6AzHlLCEUT/AZBZIldDSaTeVyvyK+
B7b2pRiQeY4FV91tKLDNTCh2FvdY7Gzj950ZWZfo94y8SzI6R3bD/5B28sX34LLbTiNgFv+rTBq0
RIJdzRMW+V2pAJtgPspbNO6Ayieeqrad3WnMdBp3RFSUN0g/tKDHFIRV7J5nA54+860IJPF04T7P
+ojYm8MSOvNK4PYhaQEjUgTl9oqnHHQTEogZOABQyaefV3FheU00W4Q3v/oG15nGAtBKHdDKIdqH
8wkDD+J0OU3ayXmPmqHBUxrCshdV7kbaNC4cbBvxuGnRjvFZM0Wno1/E+Ji6A9UUIGDa1gXQHWuM
7XmZt2spLdqcWpWlYAO7lkbv7QtGCw25KHc/UBfxbDJz+wlAN0rBmzDftIpgyHGcoHn9WfWKMb0r
pok8ObnK+u5qT5yqe2+20fNYNFcARstT//1CirCANTj5TwOZnDvk17vHRF+rjHbOjGuyzoh5blE3
qOzLHdjcSo1hpR3NS5lxsLO4H3VVTre6cFU0JyYbHDYN5i7Sc8qfyhd9Yssta0SORAWqlu6YkVrM
QQ7kb8UOd1nE56/7hL6AvBrC/uazw36a1Qr+TeaCR9CyuRtfnVrrFs5+0JP9JrD59034iisRcBdH
pXf4S8AzXh2dOdg7MzRCW6AwKDCKU2ucX7/SOED92vi7/gVhZJsF6qQ/SUO7Lknn4STISv6LaQ9J
JAfVAA/FZpz6p5L2sWcjhAtLeEMPBCFjNSHl1dSzowI5Fs0xPnjRD8xRSv7RY4m8RjsVtbDud2Ol
68ZmJ0/UrdK9pbEvd52OirnGjTzFpeGnFWZkUzrb2a62XmIBl3szGvTxqqtULiV8G7shMG03p0xt
wMC+n11e+I5RWPXahoGimFmBLQTC853F+DMW0r5TnWR0bJ86TebIrw3gmU93ognRlPcHKoRHjPBo
24dI5QYw7gOSEbazzQJgK7uC4TL634zoAV3YRZeZC3yaz9X4SnKWDbgbqKEG1SLBg08aMLAIk2ip
SJ2B4eTBb7Y6qDCXCVcPc5B96zRfQAjZXLbw0dg4rOhY7Alaudz3AnftvKVtkBrYFe8A22871qNq
nHm+Fv1r2Rczx9jvMYcXRXxmwzHecTtrCv77dy+G5DrDZepWRxSOZF6OymhrfCdwWfqwvLU2/oHn
4qQ6jR8KhtiBxlbShe7nJtRjPIRIjKeuKBkMKuik+dbQ54JFelLkQEmqortkv71Nf3g8mrvvZEVP
o+lB4uJlfhbibzoFvDi+mBosPJ3oRMAi8V43YuftshYxNNLpHMgiWrbt8KHUHSLj5iWUHHBQT2Qa
ZLzjBxUikfPrCim+VJ9u2nMLPqRATEWNahZUO714ieQVCVHoGS6LM2IT9+rBBuMheAziBLVOGpw2
OlkLTM0gzqnHG9E9WUFZNz/4NerIepmeh4CbX53ruxTwMG78k7A28LVkv6a2vNWSb+t8h1xRoBmt
pemOhkQ5TVAIXsXWxmI6bRAov9UIFB6I4bLOW+A/e2mO+PNehaKtJ+gprkPrclGvsZVc0Z3t5wxW
kKCHmEO7W+iqoATvrIfP04xyI6RZnwZnR3rA6FuPeBXaEblV4PZYrPFid8L9KW7/NhSqZ6N9KYSk
xZwca7YyBKijwPM+CL0yvrUxLfE2VwLeCVbQUzq2cMLnghCkrUVG2JrQdKGTV46A7yqL7To94znK
Ud5rOImD3ZyXVx3nPbOXexukaIc2s/WTGMNtrj/Ld+pgx+Dw8El8CI9S0NwKJKVyxiGrtWfstK6q
v3LJCN8l7E3wNdEw7fcv78PewJ6bgDugw1zLInIfGdh7lWuljSRcEWsrz7AmToG5ALUnAPjI3CA7
mU83RBU4Aez+WkNmIMJNDml6+hIepOtlq4CONH3Hc/eTxpS/PdjLQ1La1GbmuUhV6/rINBUP9K5D
C/vr+AmG2V+TYHVdfqeUx4h1nWiuLDI7iki/Rp7wj5FQJ/wbzWu4M+uurl2yRnpHmiqp6sCBzLDZ
2wD7KItKVo+YZrg+dYRt0efNndm60yzYxNHbWEljRQuUVHJrsLYAdS3hf8OEk5eTTql4MH770rVL
fjiQ5pN8VYn5ig+YJmKP5qctYdmHNZuhfkWc7HtLg8B8lJrnRz5zD1qbBuhcfDW/BnSGn0+gpuDF
6eOOTYqwBdItDWySsSFpFz9W5udpAdEk/QpyYlwc9wvFu54fA01BH/1KFFtx1sY8Dp2NGzHoGlCw
4x+L8dKUhv3MyzFJ+V20vr2lCxZPcrwyehAG4zrTwBx+gGD798t6b2eWagonyAP+Np01qSpNTKq0
bFs7qgXrqQqLmN88BtgaVC6oBRFCFzzEq4FmnS1GZkVRNVpdc1c4MIVDoghXD6yhiec7/855AeBh
khmaUKb5E/wZH2Z2/1ht+bjbglpcAkmXhVbfkidLsp3gnnq1hNgyhSge79PpPqJ8+JTwVmPqpxJi
60rs8dCbm+HsRHKVLgsYLCNu1IT1Wq0mKyMyg1p8pDn/8CwKWmoroSOoI5r/bi2UgfcG4VXs9MXE
/HFEk9pt7GSuarp4qJqlnqT61tGUdHpS17YHAJPH2YaH3GQ8gkZZpR0c4SZZmxbI67TyhDN8coyI
+3E6BRQ/Q+ZsVlWWeDBP0idqXgJpVMB/ypDE2NA+cgjELWxViWsWVcJ0jVFTSuln1n7hcTPAoeAg
uJ6WmQNb72lPX/uJzEt6ahtBG9rsDJ/aK0xw+eGdCie2/VjDo1OXcVMk1Mrf76Ze4365E6+zZeDY
rHOfXxnwUS0vUQIFmZs+bsX+GydvZF/WFi3dBLw1n2aMdioiEelcmU2pzNR+8+EG3eo59oIoXozB
DJBIPGlCKLUyTDVp2qnsf5bvTTiA22PJvpRSM7uK5cC9dERhQ+bRQ7YrryZ6CoaxJ7W0195IWml/
3kJR5wBPFiXrF6xTG2jVZBHhvogqYJgUtUQAvvwHOsvdGpS8Nc0Xc7qczH/h71imUUfZmt8UYNj2
9QSwRhQM/F+5F6+Bnabk9va3BGiI89mhnW+daJ8EcUVT2Hz4zQkC/F/hpwBsw5zdOtHjwXzdxdXe
KwR9FeXUONVh40e/4Bz2D8H2H15ns/GrnEf+ffvb/9GRZ0GnhjeLYJK1c9UqbSJmzFcLBaFcR6VA
IURBZsD7pc6ff5rvICPt7JZxHfMaFsLxRCrKot58kqD6PRRHF950zf1+KQoLm3jqLVUEWAg7hsqB
wXTxunS40iOnHIk6KifwuanSsEoZLRMYVbuG9nWw+DqpS+50YOIuoGr53L+2YmO4XgrydIUt/roh
il92PMoh07EmqZuwmET1VgDdhl/ggEHU7f57ae4SX399yhmW0srGfd0bD48yFEyHcldg9Tmcew3s
UHk7x1TdgyCGEdbS1DtyfuUC0lOuVtzzMz/R/JIVc3hg4c7q4FjFe9K0OXlU+IS0gVIQV0FAJv/O
g4DXZ4PjCb+tjyKFRWk2t1ScQkA1AFBMNBJmUY1v4j7RlEZI+8ZJvzZXFLAg8WhwCne0kssam9lz
KMkNEVb46NvJQOF/OCwf8dzJrlwVshegp2QCSUfGCshvfGpuZE8GbYHmlVOoaijzwjz3PbLJY5Lr
SZG9p36gmuYqnGK3wMt5dLHav4onlS6LANJurzPETCtX71P8SkK10Av7P2rOxSKqApbRf+bmSGFG
+BfOnx+9N6RV6+mIhIEqhhRo/t22M96lmolC2Xo5xbflgNpo0RpA5s2FNdX/3Frz5kWtgohKH9Ji
EbnypCUNnRDPmPa8/oOQ3BEl3CyKUtH3wsGIU9W3QH5r7bTbXoc3zt4lc1CupDV1IC8mbo1ORUlL
D8EDCIpvsV6bji/oHRaIgOBgl1qlR6xGpIBu2vEqQeQ1hK0d46rqc5/hzPp8ikDIVjJ9wEy4RMwK
QEVB6ROMfjmewAJUa3vc2mSMhTWAodVG01ugWjs8AjjWfaZw3FzEoQQ6bUOGZimW7Fc/52AalUtD
oIjgBldqtkaCqQx3MixQEqPyqFcmqjZKdq1Rgt85ilCHyP+ystFv2xugwmb90nygzPQ+j5OjHGQi
DzDozKSxKFqhun2uHmXEChC8iTf7v25jQDR8vna9vhQCt767fPwsDvXPtaYc76l5S87fcJWIX3DS
JX5CUGrlvg8H12TSKkEhjQm/MYdURnyMfOxW3M1yOBPLLEIaJseAqUK6YPKdmEGEfvF3tPQddZbY
eqs+iWdWoI+NGPWKGSkRtPdmgFP5soReyTvYlr/3PnJ++Wm30Ti8GG+ddBmycCd/+K0XMArsFyZ0
Y4Q5rOv8SOqP8DNS1q2agPjB/PYEzpS5lQjHX+s/9dXRte+n4a9+vzxkW1LHpX1zaMeCN8ZWOwcg
h/YT7IDsrmPP0kvvXcuS305QBTBNruHXxgIWC56F+4k/vEsyv12szfw01yDhghWDEzufXs7mBAs+
rTWfQWQ7XNA+d/o01P1NumAvP7E4ymcafmye6dtuTWC+VlBB3hGjCAkbxYbB9RLvDu1Tiy89CvVJ
s7cZE3E34ve0z+0NR9KY5piQzlMmOmvcRSiQp7r50HOyURURb/M/txf7C8PMp76UMh/wUCEepoZR
cN03u39DDbcGRB4faU5DBMtfY+gXKFKTcQrSSfjMaZiu2Kkfi0RUWcRtMq0+rueJg2N+i6X6w6EN
zwb7EWFAoZEUzFV7YbAyfpZjVwYliR05tUxnauKhkR80p7ztXr+PpG0cRGqIsP93wnQ6Hf9Suk/E
DOe15U4CKqDd6Mvxa4GVzIHOKTSvS35asPuF3I+WMjNY0f6atVI8Y6j65yPBt5WSWctv/jQdmdFM
mPKYoLURyeEVbJ18Tl9vGT4Mxe06jNya2TCxzUuJXuwkDUVDVeMgBXGCfxaz9KOd2qP6c7zZUG6D
RML+KhHhmWTsTKEeq3OVUfW3N9XXfphWCm9XmJew2ffLOtgyiqV4PmiBNCak0F1VCJlVNmgYZRMz
Xkau76qoORutksAs1Hv7QeekhGuFsOH3mss+U7NJDjuJ1H/vqSvgSnfkPwl2tHDk+n1rXy7n1UsK
KsxG3vvX8awn3jNsG+sbfJ9qKCoNs7feWmcABPztXc5/sRDzE0IXsMWB55Q7Ubr52FQTzAsWQWTb
HxXQNCRzt8DkfJcgbV9chQA/AchjMss+ZqnDpyfpaUpOGqMtpU8drl40587JsRDRD/xA+Iwmqhg1
A/DWNZ6IHZPvf9EXEp4ASKL8+HDE2iDwPAE/6YzNTYFeiswH3b9yT1Z0+LGjjiNLMlQrL9sn2Mzi
6RILLuVoP8sp273SG8mAXZ0IDEj3aWkVGNxCrokQS9wRlI1TkC2EFgbMlyJXcrAZTeftJqV3Bvxv
rI/0BZCWR9A/mamnxtDm9tG3YdjTDB/93wqf6Hm7trphjHGIJBe5qU/FewyfCOG2yYNUXcvRK0/J
3+J44ORMl7jDHbhopvo2iq4SRGMT/RboWkwy9Td1gABVui7LXxlafygpqjfoNZ/xa+91nsDtyVb9
x2Dc5dWrQotlmBAChSEd20w5Z1ZkOgXOTjSTOhItnMvwBElnwXHYSCcmTgqsrf0QuK5Hss8BbIXd
8nZFUlcAdQqTcCAulaVv4Vn9dk9o8oxgL/oU4exnlfYnvJE0QRg9EJCCqzQ4vogmVV+kznPiaZ54
8/Bh/Y5C2rqN3BESjvqzhvEXashwXW7a24NQe2G8PbvSflEpiW89QLQfwYcRhEjQttFz6Vsxzkr5
a/XyPaXWVHaRIoAPoV39iGy8airWGaybsksTEgLEeTMiE5bOlZj+PojkXzvrrJAvPnlv5Li03Rnw
/ELcWjfa7sCKmpaF/LY4xeVzISh3BfxFgH/0gQICs/p/tAtbQxIwsZj+ocao4qqEpWYL5dKf6C06
/rIwLJgmxD2qWaNjPS0eMlUMFTOku5uW1lf61zDG/mtYjXUUJLypikD2K8fzLn6UkHLJoyPzh4aW
aBRVOScarDxD/Vr5CYsAOC4UMnko2aTRni9N7BM8SxR5JvVTktRToms//hsL6c70MMDEqlKWPaNx
dogD8laqMlt7Q5S9TN8euhgdD2tKPLCBUtrGDJ9E0U6lw6JHCg/y+mNZqlEaNpL3bwRQMgI7dsUI
swl380DIv/9QgBB7LhyJnVQ5pqlLAlRaW+u0mhcVS8YPLEyvHe6U+ixln7NYae4LXUW1m/wAYwgN
kH/8tKkXYu5p9um2VbVBmHscDKIe0oiiWZpp3udw4pp7kixZkZAHkX3n8CqlaSy249LbYwhlZ1JT
gVfcPeo5AzxO6f6ukp97W5bTDtxjek6Ch18DiMqZRWleuFdIKdWJ1qxoGPGHoi4HdzA5vfXc7s68
Apmc3uFleQzOjfu0C2Xk4uK25DsplgKXhWMQqbHYcKMT1M+O1J5Z8mluhwHsY4GBo4O3EVMCB39M
LdyEfHFZ6L+TerT1RdWRGIDKoxL2+WoYdtX5NFuuaVSXcwOGm6DTYWBTyn3+BzTJm1+G3lQF0wwC
w0nbnV48a9mk7awTHesUYJjz1GbdpNBaF3unIUC31HEdRvQDdBlAln1MxnXK6z/MEvuZDKmrmDMz
S49uqNdgoWUuPnt8XmVVoCUN/3t0cEiatYezi11J9bk+ZAFKaSmj7Rfrvv1TXyARdX7TAZJT3O9Y
VqYvSB2D5U5nrgKDoG52rNBNoBmadib4k3hqunJvvvaPT3x38ylrLySyNMv4xt5OS7cjuRf1m/Lj
QdIQ/BydnlP13QNGg71eSnotHLtTseXiuUhr/m7Ojnrw1PJDmeR5rhTHTVrAZTmS+Icjv7JPYl7z
OI7upbwujBYtDrbx7zINHxKJGwtf/UpvHHYKwiJD/9MLrinK5h/i3Re26aIbiWgH1m6bCRpVvS6W
VO3umP5HcKG26UiLbiFNX3+DJsb3xZtwM3LnaOzL82B5cxbU3MTC0Wn06t9BRH8fUjuVUK85TRnG
NTlkrmo5cndPubi0QZyV1CAVKxyy4Q0zR328FFSTcuvKCGDUsn9UlRQ2xmbP3Kye6bwj72u551VX
J+il6xKaU6CiBBr3wSaJeVYJRCwgnYfVccZyvD1HkjunwH2cX6h1ggY2kEIzS/7Ns0W1r/iZZyLy
vcQPUVWt1R/skxDcYEAp2ZmEteU08J1qdS/qe2iM1iPye//0ucCiVolEJObTZnTegG3kHQMu1fZt
qcc1VVXW9aXYgliNJGtOLSoSISmy7FOQKS98ZWs7tUPdtG3jEM6Lk5MLnAsAIzHiGalgrwmCitEz
v5KgyUvW6LhnhaRz87cYHOwpaZpmNTK4XY/71ZUpWkX2CzK4uJO9QMnyV1KO3eW8XpIXMr6INKlK
tPnVExbSVzuDGrRLykjHEB8uLKC1O4S7nJEoIEd5Nmhjudf+t141BK2Z0AkUDlz3Lxltu83kxXST
9PTgbOM5NITdE0DWZFfGU+qAmk3yd7uRT03ZqHYMOO+eq71LuL2lEJnMxp3hU+/mUhEwc5It00jm
Tv+gD8DQTGvtYMVnPvzd6ztPNQ1Q0HnUCnPgdbzCyJlqjWcCqQaOh/NvHfPdx6wo9Es4ZzwP8/mI
GuewjOwGr9ePE4VO3FC7CBMydH5NPeEOyAiDK1e8UgTxZjw1ByN9qfDUGsWVS5PWfHoC1TlS6VQO
JEJ+s5QJCt7zhoxU9wNNQ1I3tz5eZuf/06aJgOj8t7gKnypXtyEZ3RZmdpoNcUXag4sqEIHtEyL+
iwR1Jw25NKrOH69qQ5e6R7nmYgzRTWfMcHWPyZ2UCSbnslKg6gBYuibBJVF/qVdGRIKnrWXYSepo
R48GY5C0AtB2A4BMGIBMARcQpwBQqsfuW/OZaqqClLXxWbMFFCC6EgDvS7p4PnyOZiNkarRGvI6O
7fluO3+dJocyYJSj4grtLwRg1aXlwmARsAITM7b1XzmTQjkjawNuLaUH1k5Oa3a5fRfs+1HnzeMV
g0OF7TKHiq5DfnjQV1nMRWwwz2j8QcidGI6nXqeHpxELWsUmE0TNJvw2sQLxOS4B153luQI1gymu
pB8Xs/IrL1JMpSsPMUWz1knr77cQjdnPx+L0m7LQjOOCMziQ9PoxWrMAhK7ugyNjQz8w0j+D/XpB
pwYNRX2l7kh8kWgiBqcDLDIDuPUj9xuepZxqiY3bOisptc7ODhzkit8s3vPo+KO9ekyEFp3fRyEO
Ut0rIEVe65HfU9hsIWCevFv7B5iZXvoVUiPVldB/CkMxFX+kaJS1+RiTVbz6UxgD6bsWiWu1X/W/
fzuzdmklbh9vMj/n41cORy9ixnaO0RePxDsxGIJWhDz0iRx49yWgeGnRDDeuddKdWEiG0M1u4RrG
6nK0SFenRoffL+0JpfzJi6SamTNvy8ARUfjCRycOe13NetVmcEplcUQEGOlH/ZD0lDG7mZZWtLTn
pZSVNPZzYCpYsYAIFktKRbaJDCNZSUdBj2wn/j2gfwoQC3D9iVsErKaw6N5GVIyFIIUAQbzryihB
wahcXK6UL/IowfdNu5qisn6t4OcoiEHziYUPPxhUrHYmKHSDe1EQRFHENMJHGq1evaw+hi29qu9R
LCJrzJZPfH8y7Ei27U9Jq/fQVqqukNblct31Srfm/I4EfNha5kPFtLbHmzYvMTxEnLaLyPXI8bAw
uvtLotAYBAUanY15F7tsB2l6QUUuD+2tqMYP2xUzetNRYlUZJuWQhkZL5YdWSmz0fiscC7ozc0me
zS2S30UOA8/hdTn7JZwZMTvEdaJCgNWB7rl0/z4qPjWgcE/5oVYGCjFcXBLtcKtE0q1kZkW+euLB
BrJsde+R0rILUFGtG+UrCilO7vpXk5tTTMh2Rmf1EbNj1eHO9UJrhc0Xr46ipjpKhLCXkgBw2z+I
tV/NVqRl2gounHEKlEAbxRKSbq2mPW6bAyNkIsiXbFLPc4TBoES+4kf8o2SjZoaakMbhWr4AEqc7
8vRYHDvpDVdVjJNBJtasFokG64zOtw04fdE5/dYjH5ypYJg8xi1pm6iUhf3U0GcVc+syRuWESo2R
i4LtmTWqoKmxk8FADFLaVmr3kuY4erkbaTl25/IN4t6l0V0p07FqcKaB/DQPX6BlCm+r1fBp8Iz9
gTByEitQ298VAM8N94l3mIeeDU/70CemQlBj1TBjgHuNhRBVs/jRrcDSaefXK36/r2jTidu8roQv
Wl4ioS7iw3+jqk8gw1T/0+LxQUMxwEpltpFUm9WU56NtCBuKV82K95u+v/6SSB3mOaFZ9L+mKBac
He/kkU1ETTF9sVHrdT4Nfi2iooCuKfQOpzlRK4hhhMtDlV4OLOrV7RwWJKL+YOEMCLY3SGPDwrhq
0MRUTwD8PZBMuuPDqIRnAiroH8VTBgSzNvshb24Ja2GSd3d8yJ+AHLKPA+Syu4A5EeFbcXLTRDZj
f7Mp91q8bvy51oH5NLbhTlgNbZxkM4RaS/ev3UhPuDnKc6w1zAkxVIkg442JaywKg4aW0xe0+OxZ
vGm+WkMRnf/pk5PPYespNBuI/RJnbKzoIyxMjdIxAHA+RIL+V8n2Li2GHrcSRROYWAs0AJhqmJBM
FdLT1KETN6fXKYuVXAaS/dDotUgugqD3yX6zOb0BSsPuPMEyGyKlzuJTj7LCne+iOGJeonE3jAZs
w06zvn5ZnZ+TEgkhk+8pKd2U1AdbEISGvx1xLuqrN4D81C19y74VbYoyQPhu7+mZ6MxetABgcNxf
lvdK/e0L3QYFligs9aBBScIMRIH3kpKGWD+JpdWW2HzpATtlKfzESvWZQ0YtW7zf3NU2mDRuf2dC
KifB+DBjF5d09bGhRU/s+coxwp/r+UsdVyAFAadX9BZ76vOti9LBp+40uO7oTu27g1x6LlnVoW6w
QVRNZefQx+SXspI+S7/hcdhQJThIHU8jZE7LvDZRWiMdiCdzatXov+vzdcbzWQVaAtR5xR23fhOz
5shnxdafxKRg+LNN26d0Om02IL9fu1O8svfnA5o0SQwdP0CRI2Y7IPbalGhmTm7QhCnSaDy2t+I5
v1/+mXPkRgqm5yzkDdoVvw0zMyVnhlF8nh57xssb6klP9RgDpYHgU2ZCR0w6ecSD4ND8UrJ2S61b
tw1hM5zBkHRK5jAg81gxuFjKTcgJFKR0eEprOQ0x3vVPtKMRLyKmXKnJdPztDLtaqT+CWWrwMd3o
segYIHAilpbY4llp79d0Rd3T9sZZSEzXoeJkTDaK4Tlf/5h0nwIFEkFYbeiedJj/JANCEaq+Weit
gWHXYgqmeJzNC52/RtlgyWPWmDgGw7oZtl/VPreku6xCMux3mu8MgJsHHOblKNAFOvxhwJAlNKJE
fGbWY41vhtvlhgkcR1U4++q1CrVdHmddcwc3vYRIo8qAA3t9eADY341N3wzxpbPfGLNH9f6Y7c1m
lTqUouICUSDQeDbKL2OwRiiBeLraYBd5J2p15qM3zTHGy5JrQXDmIL1vIqgo/Nf5V7psEsCZsdmP
kMBDarKEh1lhtAwtAgc97AbAuYEW8y0iNwYSa792P67oiYs+tv7ePVmDVtZQvwsEKP0tkRrXcoD9
f8uyIdiPLjdmRAOF3nez2wvAiqbU7vNyjEzjNGqzmYEkgTHBXIFdLu38Fb8UJ5B050IbhI1mZT1v
Q6OYVLjOotoqN4/AJFfL/DN/lQm5SKnyYNNXSkWapLmWS9LHbIvxijHQ/T0BgIo95ueNWo3+t+lX
n6jYhR2KbRjIrbW/1riSe/PziFlEY6tAYrkOZHXTh7ogqurg02byTIhE3rIjH07dVO27koFdGPP5
b5ATXwcn4e/GoH8FFzDN+eO2HcuKhuqOwGlPmkyBLZG/j33bvB+Xg+DohQnnxI0K/biNFU3qYhgr
Ipv0ycfvorMAgTPduCW0hFGde8rPv+9fjtBLkyT315LS0KIb2My6XowMs8FqwefXsG4o0h5WtDqi
3Y6Xqdu1m1ffD6cQXu60cI/AK4GcqARVaRUVN7mkDV9/oQ6gs9PAeL6SrqhqVRuAdFEmZYXPluxw
ornygSPacIVGOdV7/zicA5A9DJn8PBGwe1zREfh5DH4fAZbZsjTmuAT+h/VhT8lvj3Tqc3btOgSl
QS3o7YxIC40fmiYiVudfjTII3qyhBxzJ+tADOVU+MH2/WpNbAJJE8GiAHL7d0wVZhlD5T5BOcM77
B7UOMJTHMH3iq/97ILo4snoVdyetlJXkR+SI/QSqBQ7ywEWdKBT++4lo/EzGkcEMaM5/+wAeNh/U
tsvUnqYMqKYyMTNpQbbnG2im8vCzG7VaI0Rht1oKWtx3ICXo4Vq3MLS/4XC8KlX8IjOTPsxw7r4t
CjpOzYZuXGvAsSuDKXR6dMuIvMzO5ideKptgkHHxrHnaJjjd55S7YLUGEFwVssH8eRfqUc58rU2l
7GGZhXYVSbnKFxSMKKdnBD3KKz7PvhJFnUPybn4vsD/AK8rnozvv1PtIsFQel+N817j4Nd/LPMkj
jQZhgRYuLFMu5oJ5hRlkOadXz7uLzHBzzDYSsvjGIDx0sNY/ed+gsht6dsQ6Th+7a7Jq7SL6n26/
gfrez9deGSKKFcbG04g0MGgGXRLVASWdA2tTc40wwaoByEuIsYMkYyFBxZFsCV310ygNMaoYvVwj
7TXgwg3DK42MjGamYMVQJED6Up6qw82Co8/s+zW75LjSeliULIGIjLyhD4Duc7unhGBMBUjWNwFN
i+jDRSIvB2E6Q8smqqAmp07ZMJb1RgJZ7Enp1VsUYELO8mpt94oyET31iXS7eJP/yPdmyJy8K18I
5WBzHVklRdY9db2qO1DF7u8aHpvM1PN7dQAcZFLmOdjcCV0/SW6DmPdmpV0SEEE27abGoM+0pS7K
SY1x4I+Aej69G/QttyEKlhoH7wRq1qRX8QDeJrJW9jvmpmF7+1uR87q2s9q+5Cw95HLiQl8doIeA
a4FAy3MPZADRRm9wTQ+EDA8W2mxz2kMxDQEHfJRTuraCsh4LGeLzZd27VhnnXc9dLKxRR3xq6XzF
s++p/t+Ik3T4im0jHiWW6OXJLlTx6do308UccwLQEdCfrG1alMNPgfkeTtYjCR7GsJcjcQ8UZudr
Z04yfziqCYfCcjYX5R0EKiYl5VC6ZUvxqGjLBZCxf0kmkR1Hdj7wia29ubUHfvmOa+H/fhh3JRtq
9/oedyF4X25qG2h+OoLWHcEb7dZtycjNBuJyyuXSOAVrHEmg7hl52ecJi0g8Fbmb7UDHVDDK5hy7
/SE95KZCJKyNg36cT3CGOABQQFkv5XPnaHLFXSSAmewmhDfjk+Y3LxVfT3TmHZ8AkrhvM30aaV1r
bmhexJIAIhT9S/648VSpNx3+nSgkiZFAPeoOq2zj6zo2sjbkxq0wL3Zr86glHSIZcOFQWtvfWc2Z
spxTO7fk5Auu6AWglssI/Ufr0D0coIhHDJKSDZLCGgpBjBvgCIR3g6ej4sjPnFwA/HMVPrMBAGKC
2YlyD0ZGH9qDzvgHADwIyl5JqEIOS/JvcuFoTGoazggVRT02PIXatwu9hPqpNNz01f6C+nfzFaPp
DMm3PV2eGD7ZQcaMI6WVJOnYyvyZDjjXatISVwGl6qa3qtEoYwtyah6a+Gu/o4R5UCbUcE14cSKy
9tBxjxYs4TV6fSrpoy/R8ZuV8E5fIBc9o3T4UPgADHpbjGNamKXq4haKE8WahYLztjzCYLasE9wq
hKVxkgFDMTfhiQouPUmS7IsFdNtd6GaHfkZ6Vz5biFoetDHfG/nmhoaqeDvSf6FTSagDV9/jsyOE
mesLBlI3EEveTBnRpycvdGOSPvzQiXZCd04t8qfGa5vCQ/EkMYDDEnXMOpZfCT209MzaTWn/PvEE
fFExUevw7YYjIMqgQvW7AVuP5KjoTV9Uwceec3/w70pR7M+EaQWJ6xNI3SzwZw3EG7DnCe7zvwjM
qQU1pZteGZ7pBgGBbcHt+CZn9yRMRdIGuJ2a3FAnvTvsa3UIoKvL+LWgahfRKVE12upX2MZwrENo
NR+xc975vETgkq1NmR0lcNQ7mqUBaGwuAgJHEBPCwqpvsW9HSozfnmSxRSoNLaSL3H5+zav/tu6m
9X+T0R7ERUyP+2aAbgBsY+ACCcy8w3pLNB/haa/6wXlyLvCatQ76Q26MgR/MpLzSvkaP09Y5xL8b
lnNC1YUadX+sRs9NBcEDNpPuRRAIH6oJWi/zayemk0UPab2ClsUZFybVLdJ+ihsGfBodc7SfL8OI
pvPHq/1posYo9zNB59330DwERUsikU0NyruuggRMxet6es6duF9hpAK38Nt6j91AhbFlu0j/Akn+
vqRTUICqJQ8G5G5QHKrVDVgpixI0C9TUSzSHQEc3UaLRmhhLQG9Lub8kzv0AcJofSG6c97BPBG9E
lxRUmTZr26qwEUjGj85IZxCjgF16mM3gIR+OGxkEDqZMzfvsqAkw6WT7YoAmwckSSDretDvtY/B8
ktqq6mNYJNtOfVuBKeffls+LsN5hRUC/z48KANlztIFA6hVE5e+d4OIwEAAQriKsiLxwT2FAVdV5
mUnK0IYvgvSL7y3CQgF6QpIXVLluTLGAwUJ3fkoGoCUBd3cTnigA0KHEK9ofAY7X6EkhSfrmFPmC
4sfTfnHWkM2avosA6JUgbPmkei5AxAB1fU7acUUBQ0la8P9mI80o7LAP9YdltvMhQdQQEOPcwtDc
ZceQNC6OcHuN1GoS28OJf2K7s+YPLJAkYwDnLKV9/LWAz/hPGtYlLy/CZSvZkSLF/cSpXNmhV2SH
rsKTkEM+N4gayYjQKe3rakXLu4UKU7e12L0CY+jGN0DK+9I6Rhfi69iVtK0ncEJGPoMaiPPR8tds
8kYgpwCq73UPpghyE71X+bxAwqrLqdZzxczF+nTMoQzgbGMpIyEvHr4GDpaC0eZurHKDIajjic7H
+u14hR6cP0d1HQpZqb+bKE8SeI4YlSqUnbUe9C0M4gSbIC7vvICdRZqV7p32/uJNvLVkV6m/PIDN
PeGPYS6zqYMJ24dwAvR9x4iy6aIWdieCu7PSRtCEfmEpR5wCvZ8B++FdOS6TdlkXmO/OqN6MyN7D
v5BwlNP9K6VwmbGacjvfELIJlW8r9xGPa2Bf/Tt9XmZFCYLKQYTc9v+uUce/WR2FKwWWSXEFkqXM
KFuCFynSwLlihMyWABzKka24OPpzCbASU2vhEDfbZNqOjzQyd1i553Hh3dKwbw2K+NlYX9epkOQl
T/PsBT5Tzus3h7QbTuPD7BGdpSu9d08KM5nTVDPThMOOg+oSzl5C1XFH/WeC0NqrAMUUnAuzGNwd
EM1cdkGv0Nm7Di1CvL2oUjDYrFxehWud21HDwpZGzzUZWTHFuJWwfm/s1mtK11IzjFlrQAq70bQC
VmCNtBLyfqlHuPRC6Kva8gqCRCqG+bnIa/nftDfjI2wV5GlV9Qeyvw1zWxBOUaCyuQ4ZRkR9z0yX
jDND9FmgH/caDHzGpaMCOme9m1wRaC0zSPrjGnEn4HXHduxoQ6BiPNKFO9NP/fcbYy7GMPKHVIbl
tQ4jnJ3MDJzuJCl0lJuW6HqVdnXetB1xO4JCAM3pkBYzJafRkrMWchUfChlhKwlEsroDtC2ZEuyB
xhAJiW+zkAdPHgAhQaWobVlh43LXoA97O/yJ1EM4Pzf8lSHc/M2iAH2DeK2Liv7iKGNTeBUlK14J
ZvTNz0xiPgJujwah3gEk1ppBM92z0VbaNVqelWDJnVd3fpfQg7SZXjn3hKeqbAy5mn8eYhTfOkbe
B/qpQe++3JkiWDmz8QJvazSz+zIr0ogEvgbYk3qlTLybfNonl7iJRRQxu5FlQRCqUTFVY5BVN++d
R8rczcyaaKdSA+JSvPE/HoJ7nTf+jZQXX/S3ec7YcZc+47+2oE246UpMwiGXJpF8MOc/Vc953unl
An9St5XL4h8McZne4kHSD+HkqiIcESQ2rnQDFg23Yzs4d0wSX/zyyIVuTctxB0Gp+fRPwGS1wBDi
ywf4i3W8RLINFy7lBGnXfbKPwHo32bT6OLYMTbNdIyhPl/PMXNEwyQnay3hOYUqE0yZdFtqUkTzs
9jzW7mb3kttSMp0VypaCfc1P4q4moO3dHsyazX7898qtZ//unH9c3h52aeLARucp/5ZYmBzvkYKH
hpwiLyCpywoK0L+jlt0kTVJ315rJ3LSIDRuB7mvVAwcZQ9V322YIDp5K5gjms+a+8NR44cPo1vQZ
E8sg25kdslzyaETA1TtVccEz2OSdpqjI4hkfL78N1umn3FftU+fEfDcCkBst1yFTS9/4JQRJ1GJl
pg9xCxlRElb0c9UwSr+bD1sjRm6sXnjEJpNB9IlhcyJQGTn6HDe7S5TXvmswCxWxUCh7rEXcK4ix
UrWoVG5mRugxZ1TPjjzogqvYyCWBnwoQTUAJWOtjEkHr5kAUpU0eGncL8u9eipfuhbSTFHhUyVrg
RDp8ueWx9TYxaXUE3vPpCvqGv80Ytcv1dcnooP+wq4tS++izAkhLKEghjGOeIhpdQFwi8XpPdG4X
p86kQe9+E6vP29GpNIx/+3VJTA5MsPJCgo0Uw3yqgRsYHa5kKBIS+Xqo6BzegiFjBpDF3mG/7naA
hmOGQID4z27x814a801OXvq33Z1RPx4RrbCGHjyDExhhkRN7w48/aMB49A9Nrd8I1XrZBwB9ydrZ
O6RBzBRpsYrEAlQoE0J7kp8RblkHukcJ/gy/5bGx4uEEVgyUSFw/QO7dw5KPW4wW5hhdPdC16Brn
ZtCRjNuwkI3RaYdcaNmSI2XjkVjxcActvb1grS3IyJurlLrYLjYsRdMf0ZVPlTxbKLSMWczEexid
SQFqjU7DP6PI5YuPp/iHLesgt6AJlGiYSe8zCWCiedQPb7SiTlfedkfYOxmaP7JF5vFtjMegYLkk
lEFSoO8lQHH5szXljohpmI6bn47ZvhATHppBbn2gOFN4e4UOiZyBoykdfuZeRyE++1rjzE8hvCUO
xkNgmqScnODnGQQsPScizPapJyjspmQqVpeI418frURCxK8srdM5p5B8Vmr6xa5BtfEmmNBBfTZc
r7Iw/UdNvOe9Zfr5oVFSvn4Xr6T49Vr74wObwmZoc+sfUGUhqdOtu1vnQJxwIBG8M4Xjc5Cqoi/a
3UrcSTOV2/KO79Efc51QQWaiUDryi8cnHbQ/4PqKj7Pe2kiPJUGvt+mc2jx9zMouHv8dPpzRzaEj
Z1Upt/et9T90v4FObFU3tc41LkvsNwKnCSmVczG3CVZd/IO+rIMEIVKCQjy8HopSwcQKzj7cLlzw
okdBp5I7YnVAwkIO1AI+Z8imsJ3CWCl0DucjZ5cINBAVTaxyAn2C1ABub6HPRPO8fG8wg+1GvSZX
6Wxgc8xQ3aYbJIJvSys3MHt+FSP1T4r5Vq0gAn/2esd6+hWn8VAbsHasut65J4GLvvRxS5BmQXt0
2eJFgLCSp5rlZB7LOE+5TS8rnF/vZQLJl2oaNFA2MZ63R3rtGbz7UZ3LDrbJp3MlDLEQTZS/So4G
Fq9GyU1mqHTK2sTU2TclwWbC6SPyFodKUgdBRTDY5m5F0RS6i8YaLjuqxYq1aJ1JGKEi1Z4pvQDF
XW/6LYAjjHR61QoR+3lfvGOEgOefRMbXueVI1gT6enieDOsm/BvS61Eslj+8Oy460iS+NjTYv67r
fY28pkEZk9uvQl6SVoAl5CjVkBGb3/QIC5txU+fS4rPiymZehk+wfES+arhUBzXo+NMJV8m9hGkk
CqWq2FME4tslWnlfLpjZw004mIbHHibRQVcJEjDlZojl6+eneVUYyfIQtRmQPgYv5kT5xbsO1t1F
+SZDdRPGZt6VYYc+it8QjVOPiT6vkmkixQNB/94IOJhtbYsgabZUerGgXZjlJi0tuRsrGh7vEL3a
Xleitp+KDZ9OOgix+ctWNvp53pz03JzMaKnXDN68QrA4PcxnWUFULbkKSm8t/G/nTR+asuIv6Xpc
Cf4ZFX4Uq07MfU8LUdn+YL3dETAIRCiXkSwYQGseo82ik8IhBTd/iOOiVeBfdA4DuwrV8/sYAWKO
XSqikOsY4pmynsYODXFI2jGsMFc2d775+I1w5drX/wBzSl5w0X1xRO/NQZdoJM9Ip4jctKqCnaAJ
oiNGocwFlKutoNDnvk+PX0kFDesD63R45NYt0Bx9IeZqn7b5YPuwAMZL+5iCYAbcI17vXED4vtTR
RcvaW3adlssowZgxDZOv3tCy+D9T1yqCQVRdFz+rl1vt3vjgKw+ojt/tPSz1lT07szxCCbEnPRFd
WiEtlnzH6pVVW8u5G6xB67+jSgbI3WDC5HW10uA+igXNum+ojRu4ZJhk4uyVHspHNVPY+p6i21Ma
Aw8h/I+JBcIVRotCNcme4oUl6EIQpqPmKDiuaoeNoOYENt0/V9YB64EChXLz1v+Y/jKLxnPqwgeC
IvnJws8DZIJdjHSs+WnJqa+nlQSj9wrsrRpzQx4Zb1LGwM3Xxn6crNsZaB15EEt00foEJZpeUOdI
I9dA0Q0JfVcFH2/gJM1B7EQFtw4fIvvILRjzQdPIR1cvLnRDq7FEr6tG+d6RKsyt3Z0YQhvLos6z
ISbk6DMMhYH8gWaDo7FT2V3WgM9BUothRb76luGKUIWRKE7p+WEGfvjvztLHqoYXMaaBrqjt5TlZ
y5njimOQfNsXBEpj7K5PdWLT30g9CClNZ60VQaTzNDmgRaB7BwYfFiu4EzZrBArTzXggncr+OWLH
t68Pzhbhb+BEN/wnSw3Hhxx2NdU0fttwfEM2mPTbILVNCS1f0SXleyADL3zn3C7fFEhBrYG2jtA0
6E3oxPAjD0iUWX+7LZUcWrGYQsw3UNdUTYcDMhDMjkNAOZenuBAmcq474xQOEvpDxr6I1xfZVCDj
wv877IsK8omJMZ5V1/AkaNs2J4ftaUcdAWHJfjMXioyJ2ukiMWbGRdiH9/uXsONB/X2gllzUN8M8
YOV5j6GfgwghBxUyOONnc+07Xi6HfLWth7oHWtIr2tagEXdwd9t6T9ycTNpHytlTab3/dfNYh8Tp
taEmTGjx8sQjZlTnfxmgjU60Qy9UAR4TRFrihr0WG3s2g4OcDNjwUFDZ4Bmv/RWif7/v8YQDh6Ow
BkE9QLCFypKeAdAPp9HXCbenpUw9j8C+FPYANNREyP9j2Hcb273xyfTBgsfT0yMtFASAZgM1pwOS
hv9nnD7Ol7nDmCiKCrbmK3+HS/rrVL3fatpmW53TjL1L11QRiRVsCjB8UUJO64z+d9gvwWrLvDcy
NwcTbbekbAqGhlSXr2kvxBmTiwCnSxRCAESdPqEzGspY58xq0KSOQlneRqOVvDpJnosdaS6wfV2i
W+38IKXBGmdhOAdf8L04BuuIvHmWf0P2tBlUEsVlId2rYBfCn7Q37I3HOFst5NwkgjKwE3QnDnB9
kBaGsizSvbhuqpnGPa/CYV3+PYySnM+0Cjg1ru+GOsp43NxO8O1EjdhKU3lcqPFcAJpll63//vDo
qCFFH0C9XJfwrDOnLlugNne5z45S92KkvE4X4hgHoy8ZKa3Yu7NHSQbpkcTZVCW3vCT3FZ7KV9Ye
0zuY6nmT+kDsnw4TmjLGqkNgdKLLJ9tZy2K7RTtqmDM7DbGZdcuTv1DV4N6DNWVDYE9/tQi2pd5s
y6n1lKSUJJohssqFgHqvHd6qTrZ9WiUB/l4kepNFwtEtKPxiAl1ECuH53ItnyzV0qrjnXMQ8GvtY
ZXuMlgS738Iv9SP8C1s78+HYTOvqOH3B9bZxRcSFD4kIrbbJxmpHjzvGi8NwXUpEA5NpfVSth3g6
kE+IANYsad3VqJGqFqhHPHMeia5DUCb91I/YArNLgf5O2oREVqqZIl7mg5qetxuIWPpqmXiOzxOE
LYn3bXgvXfBDKSb0V4kbP2womtCfnvy3Q+bYxTBOMu+QMPE0KzRsoIc4/vAjHXEtGi7r7WZwTatG
5Lb6wIc99SO1BJygQDwgwzGZAOYxcl6FUto44GnRNnWcBcaUMpwGcunQMY20gPyW0FfRW4b7e7Pb
toFWHjh3pj3EIQsI+Zh2YM2DdDkAheEyzkw0Kp2DQKud0aksHePvcKtkN2QlNx5zWyJIg6qYD3cl
OQhcSEOR5BFceTHvstS6OIPfQguxIdMcoWc5U1WZLthT1A1rEH3iUW0c1iyvtwH4inqZ0bwF97KR
w7G4cWx6vXLI3ylBqUjPinnAsnI4kk99b3q7ui9T9pjgRjXJuRy6948entyRsq03148iLIIBVFNQ
Gkk7LChTwWPv3RLaYrWpZLkWBBvidpK3jxOrYEDCEn+bRXLPsl5oL/Ke6vzmqBVIiL/w9YX2m2E9
i1eyLSWtgXADTlWrDW4Dk+q9VsUUxpPcst5RzL5uveLyC9ntC9xzxBBjnL7fr5ky5Zd9nM1mZEvx
Va3Zk5dx4IAq+81QE+YW454U4puJc/EN5TReiuLdJN3eIh2zLMMQYAugoH0aFO3QQ4vZysgjYpwK
UNvV4uF1pLAN3RkZaQZ/EyeBah8yPI9s2l23DpDFEyDIFCvFdgue/wbVBgcgHZwj1EwAM9nyCvSG
g1sAvkV0XIgjXA+zNxJPVi0trdnthu0EZHmD2nwTGljwZzARHZLY+pmuAiDuMngnl74LkTstrN9M
rQjCB7HtBTEmt7MCoRvmQgP9/H35S9JkogFIbvaNRJbfA77PcZDeUCUzjenO1WO3+yHKw4a9+WFI
6/bCy36ihuzFwvykpL42SGEdphQNHH3W//zHKZcNVsbFgfZfhVh9eVuDsPl2PIu854h+vwXfl/Od
+TIQmhj0y3DvOxBZd0I/HikZPvBuQFCM9/fzgjLBh68wzlEly7xLYSo103jSboB5SdTYK2FJBdY1
mZsv9nI4rhOCyyniQCCammR5odSIB7DSq6FZL9hEKmwxI0GNtVrzxIPNC5MRL3bnxShlp3kSk5r3
Chg3hS+94hNk6EPCZEBxlf8btutA01n/EiIAsa27D3mCH1O5Zh+8fuSmLSu624EvSOOC8NwGnXGX
oXQMzYScdvDyFvZSBfGsH5uJVsSNdDEGf7AgGcVWJLpFcgLWpvRsDweu4SXJ1V8CAUY2srsqWwST
1TCf3ELc5DoSsJ4ZniCCQ6LbjinuXdIlNGVLkrIhMflBj/y4PEmPUN5Eoxo2dCgDsEoo3mZJSkRt
Yo26QDQLI5mKThEGWnm3xdS9BvKv+0JTExhKOq6qQorV1Vipv+omtFypyTckHPRJPGo2etWU/cZ7
RzV+vAn1kyz60WF3jaiDW5NH+0RKRsQ5kIcfAk4o6daRD87xrc+PVIwsCE/6u4TDA/E6Uzj6YMBr
NX4GzNb4ZqPhsG2++eu4qn/KjbXTubNwMUVxqaXeRdRsadfnpin9yIHpi1bUwmyCuqube35GKRLl
pSfWldwQca6Y5dEjf62UtQWA5xOnnISba1pUBFPWfQ4bGzB4wBvramukKRCZ3JUdfjCkX3U3bCRU
FUA4kB+aFcpAJP5IO6qjQKYotPZr99uk+dBdhUhKGqQITXTE9aXSmbzS0tJIfdFJ0Nl9xcKptp9M
FJ8XFtYxMJmBw22hoIFVtKqDht7qk7h2Q6TKrROgalCzQzxQBU3tUmPBJONSoIegEvRrC3jEOXyA
+qq22pD7jDNicAeC8t1PZ9gWGLe8ztmGP2R8h/D6ZEIa0qwq6/ehHZxYdVdX6y6u8MT2IRGAPbFx
B7THZxsItIVo1KOJ/wapSlE+d49KdrJriE53votsDs8Nu7j1Bo2XqX7ZKf9tF2r16zPiHyXB7Dwv
StMi1iSKaCAVGzrx6Za20MZddPDdTKpUKKG8G4qe3yUT0z1hLl92SY0i6MqpViH6Rj87vjPOKkSa
tj1csMbPGGU/m8r47Iykq1u855j/EIcnhgxJWFuzLjwhjIuRa52xpi1GuoqGLjzxQHBUo36faa2T
Zvae6x0gI33iF8FZHLA2NBTtHKyvLExbUlVZDCsRH1q/o6IKmR3PkXhtbLOyrgYoGJFNzUeMEG27
eKXNrBClsgozB+9MuKeGIZk83PuuAwoF+ckj6GApl1hAJwBlCIMR3MlEW70gAdCn+NludT8b1blX
pR3fdgMxmZ7PgLCWYk2wb6iasqytEc+cH7BSaomAmz0YdNSLZHRlkB/HDWobxTLiiIqP0EOrq1Mu
exb6VUSJmCXmxt4hpT9Nft+6EDlA8tJS8mCi6ZirJugWKwMM/7glUK3ngsKqZwBrVa7dm/001EDI
EleFnoJdpRbuNTcD0MSYSBLwAJhLBXuc0iMsxzK+LgXBgrjqc+mmHh76xEWkFZZARkVOcol8B49d
QwNcaP9HoU6YBeiA8/J23kiAKBRs+5ALhTQNDkJh3yGnpCwXMK7UVHj76zLs0ldYVX0gYqePjM9h
XGMJiow4Nl1H5dyKwntKmHICUkbaWSzzSv3/MTwmjQdmJIycZozQ0m3s9H3Av2w3UmkKWpnzfZcG
ySKJ49OYJz618YdPOkkoEtwPerDqCHrNhMMaI1lPKRZR3+GXWuFH4U0wQ1d5PoEmiNkHKjLbneAt
svLmxDuouZdicgDxuCaXxY0pwQENaVQTayq9bzjTv6k+7ODK0dbazlPW1RDcaYLOYmRCPyBI+Nfs
9elzedWHdPQTQNXrvBEDQfveIT56aFcRRjtaqTvhsYB7x5pAWJ2EF9bm8UEXFpHt6Vh+fP8wKj/Z
laG3t44dWRVS9Nu8kh+9Mw8GJ4YVjLgvWG8JhN04G5bu6oOpsAeoCGzTjySOg77FN7KpRdsT+LMw
JK3nC6wb0dkqVSBTs5TfGiKf0wSW1JqdLLI5ZwMx/EMUhqjMNouT1KA6JYtnVopueo33lbCn/3iH
oO7XP2HeU/dsk9GjiOIclPDhbJwup1rZ1HKaCJjNOD3Qt3JBOcrZCVoFMkrjUVBWCb6rA3pwhFHy
Pyeh7r6lKmlP/rcFDZ7oIwidPMy9Y4H7rQsfsvLRFDmFnryyqfl97o5xF+MTuvPHuxDGrdDFAS9X
ieVt5nmKZb7FNCY5Rs8xIdaFgKQQqPLfN6qFrJVTqdK8CNhTsIdaM/8RRz+8hUhUjq35Jgtpq6/o
sgEqPuNwyiwvg8McXrqsVQyT5GL0O/Onv7gcVxWIg6ITtr7vmd68gPQ1dRTJIJitLpsE/ghNtDkC
BoGwATrhv/9Rdqk6VqKOdZ3MpwM3dmFxJBklAacInOfFUeZ2lGv1hBPDG38TreL1kA1WaskBSWhy
Hc3EHRQg2txeHuZxoMYLFqIKghrMJYBgkVSuaOdex9HldOxU21hvH99iXqzFWLn//PSCgTMS5ubb
mturFfYPTsZFY+ZwYEAqTN8SyGeyJq6v4Q07x0E4FfAOOVToT6vAj0Udw66ToWdqPT53JnvMBs1v
F+hZyrJ1dl3/MXoNbDvaSXz9ituX8xqrHM6XSYwzPtZd5EGGj4VLNH648936CpjAPdBMqV3U4lDS
EUkcRYOKzMxy4UoEb9IjzmJ4ySOhFGLmINGlcUlxQZGCcR5tbsA36Sry28elFHUqoDHWoLnhm7iy
aN6/F60To0DEfqEuYamLMv4vI7mTkk9HWE17r8DYPzQejxspuLB/FqSTvse6W7krP7+OpgVebp0v
x847b/QRsJkdNdYmyVeIiHPnFUgn5E8JUJ3JngrNhU/AKm6ZoI2EQI2A4TRYUW0hELJntYkLGbgH
8CCue8NmgckqYIdZiWqdWZSqdYuGlGgddXyZRYF+kRZHv1GRBUEkpJ7BjvF1IVJ4/tTcugi3pFdk
2vwEr4/ZNg1ynO0zRSO9aPlNOhwt5uMf9ohVMZ+FT6F0EK6P3xuYCjyiPcydLGF2Mb1X/5Lo2xvK
D7Lk5VGah2PY3dNGTViupSPL+pR0y5bFvs1uRdqDgqbe3cWoQqHMjKbTSll5nTCTD0IYxnO0g4i5
ofkqxC7OohPRKbrsLaPnBf08Eu8U3xMTfkQUe0015YWj2UKKfYul3HzxVBlFMC5+uI4qwUWvy8kv
2M4ytMKyyPJfkEL7T06+Oo3vEmFKXpi7j0sob1TglMmXtJ0lGqrB+UdnWvXxquBMNzIbatZXcON+
jt6ukIZ/z2zG7PKRRu3Gka48eV6StzIT0gvQmQ06EdIlCIPgiFPCAk+ruy6+jRN8wYicjeVZ/EJ6
UMgiK68+9QhFnlVSLWl9Q8oNTonq3dmgGkpJiQaz3mURLEUj2hjqZ0hrqo0oAs4Pn6zHeJ/iGikH
Hn7madohfHBjPuXoavg1tXL/E+jrv3LpfRz6w9funcQSGfZOX6CxyFLNVMtNlD++lbxNWovZ6zMS
O3MPwCEvP3kQGB+fBAWYnZb0HnslAJRKFADEcth/FPU4PCxXfqWYZzbp6Cd3iRxiaMk4VUpF188t
4jkx1nt8PL7piS3nW0BvyBq/xmVAYUJP1iO/CqBvvuPCZw2n4QAAv8Bejh44scqceoh0foMeR1l+
DHhoH9Kycp/tcmZLCvcEY8Ba3SWuMtDx0GLOU02cTvRQV1SyU5HBeXDzIFRXiOb8E3uqkz7R+JNo
LK5ZH0VW/hQmPM/eNDz1q1fPYZUGuVd7QlYTVThA2y9vlSD8chq6meCTCo6aC+Pb2T6lwIg34iFU
alRtwfQtZZbdfwdC4AjgBidRa5SkY/jD0EYVf1Oyk6sB8NfgflMosHTSbPtW1/tgOkClBthxr3nJ
Prt9b481hFpK8NOtehUrsXMXFb/g8rd8BzP/9Pzx1OnrchyMlaKtYmB+iw/u3HVf3ja05K1g3CAi
CedknHW7bLHOqXbtxCzw57Eplhidm51+SH3p7Bl5P9H58jCRo/UOfQiMrLr3LkQwN3CXdou8YfL3
mzzl/ev08CI5xTU7xTKteJOaEN6G23jJYFUfYyM4OW6y4hvh1IbmRM/6FIAskMu3WMZYacp5R4+4
G35p9UTqX6wPZn6d1BpNvwuB/beZ9B/XJMnfbWyd6lHmuStZeL/gQK08u3X833qkhKIj1EAoQXCA
1OykzpBqU3+bxwLrNt3Hmsr/BQaksFT4kNRZxR94mOruMbqmYPHKDFGAwGL3TcLdKx0UXCY1yud6
huW6Wj26LIJihnD9uqlh9GcH8D0JbbDLcOLlN1jXjwD4zIgX+mHzhHncYEfQLFCgAhCai039Koxk
Rnc4u4JQ1rPMkASNNWa97FVu8LelO8fh6VDfI2ktL/3a5f0AO1LIEKgrmamZSjM8Yku/gGIoLnoL
bqiIZu+wQ3XaPgn7OE0QBVxBr1rJeSE43H/ywuLT65LVvTy3w9JZ7eGqjkFTRxbyLE8SL8tnWzx7
HvYuG/DNDZ6+tOCauKUib7zBAdgBMKGdV51+7onXZqeEGz0tFUsx2QW4mx+1o7ndsXyWXvoqdX8n
x4g+j78n6Nzdj0bAdj5oCsEtyjLdoqdC5Ve7JQsuOHxYhMUAweiMbRSHq4tscUIzi4nrq4kTc5N5
2Q0mGMLJNQ2mM293LFrUDA4NpMC3evBE2XKmd8UvP/rp8HsJjf5cH038HlRyjUOebQgx1EgSefcy
/9mxIr36C1y3SlwzvI6UeZppAe9su+HnwR6PySW6H1y2S0Aby2qEqUxxHuOtiJCDAetTr4VOL0DB
glWUW29oDMQYnBnd1W260SFWiCybZ//F3wurgKbsDUZ/cGTenJKTfYsuGYRecTHx9jTwVR/zK2nO
bbqVyFPGVUCAHUB6zCYjfF3QVfh+OrrxIeK8zRgmoB5tBZPbLOg0VzMBbz/gKEWGdraVP1xHaLwf
VZqkLnoimHgst3AANAA9MzhWStOMgs8jZBcbp1Y+mCs21vMfa187QLYe6diZfPdvR+r5KtGnkBsh
ACYrRE/zUq0DebNhPU7zbaQxkvbq7YBvrwVpDWZl2ac8N+aBmY3xaCxVs4of4zf04WNuuldfa4fI
8uJqnhDUMEZHLL91AOTLAzY2irnwu795AsROtOJ+YUXgA/vupuMDsIjQuHohk0/4ELI1eix/QRoK
dX9hV+FqcrSUhJNUj+PZdXq3ikpKaITb5PRwwW12Dpz2nJND3xtVc11iFDONR/2vNYzbJ1HooqTV
k8qdWzvBokPwRfp7kuMh0c10zDPc+ppwZHKVZ09if1azd6o7vbwintFhz9VFmZItwjSTsfLh9n07
S/zAXcxtF5hh65hNlr2gFu1mTONbNA9nKQ5+Q/cIy3HjFYkGtco4nCUc+zYgo+3hM4h5ic6bDR1T
vSO1hkRat3ULIyV1e90Nn+mi3dF1LfpfG4lwDoMJCQfdBNbTtTLpD6vH7kMhKz9RRqDoBBC6iXR4
z5h1XF5RPQgk0DFzxxBC7N0JEeLF9/suV6j5SrEyU2C3VnbcW4GCcN/ZE8ozExvvMe2jafX+1H55
8kfhQxIVGg3puvQ+pGUbAieJwkTf4AOCGJovHhZXfFpN2R10gGmh92CxbLb4aqP7TN31VhMtL4b5
SaGShlnXmzvpXVMc37bbjD0Y7hMrFaVG6AgWbw8H4Hdl+8iISUyqEl6jBe49wz9FnSy4pdbsDcP7
Tegu8AYG3ufdNTqYoXbKKVQ1M5u/wZ3NYilHZwy/WTzirLjCVY3Ho5ffNcSW8d+vF1t4ESAmixIJ
j9nyMnI6OrlgsasobeGEp23AQH5N00J9vPga5yx5oYAuegGpQEF6E2yAFMq8YadeaSMpk1aXArur
vGIX070YjvekAboGzLnhvQ7gr7auKFWWCNDDV9gnP7pMebm8eahAXH5E98TmLDIVjBPqvTXNgrL6
u0YLWakDJDobg/gRWSmCyxMONRNBa7xylZqM79AYd/NuRrwkKKtHGtMhtIitPBY1rFm1s8Qnboy/
P7f6Kw2HwpMFew9l8ZYlioiUVCrufkj8XaeRNSxq/9DPjPsH4csqx879yNVW/Ss6XmsX3YFXDIuq
Ewhet0FwJbY4bqtpCtqPL1NLU/rU+dZEySXCkm6Y8Xrobshki+N5nBv3NOT5WQzcgyOKRdj5V1YN
4M8ICVCMUh+a1Pwdj9y3Q3RzdiTDgRbP68Y6yWfwdJjmJfaegNhvx4bnEKmKkWC0IbbVEKj6nHoB
iBTE1cRZkpeKvtbr3Jp7PvA7J1eUyrZvaSSpGKpusogUXGhHcPJCLv14pNx4K7EHgs5szTlsAX6X
pcvcNdbFA0jfN5FRFWkeS1nnQ9h9AdxPja+XOdWhHIaw3qwQ0CAeTJ4S5hT1MCpFgZuRlytH7iTq
h4GdFkXsja/DF3pwqxenFL4wvyRM51Yd7nGgmpwBANYryGiLDKlvUhga7TufXb9oXNUcTu/2x8yj
OVvAuYUNhFgGEbnbzX1t5cd9PM+ipzUe4cwQAXTeqZG7QfwECJnrPbV9rsKpNtDQtRpvfDMRmJ5N
rqAHMXZozfFqc/UxvMAvEMy1z8TkvqK1hATjvGLqg0fJtQPutsbbmmjspFCmUvHRwTTvSvREW3Hv
R65RdvRuyW5qwOvQ4DK8hlmUNGBQ7la8oMWZCQqzsbnyG9KuLlbv1qKCYc5uDEzKzf2WbaxYU4ZW
7YjbS9v0bhDP/3QStX6/GrKjFI2wetR1/IbM53JDPYU8lSW0Z7tEITITyVKm2Lg/EgfXXepX5zdx
fEhpM0LwdpiIyOOcVIOh55WKfRinBhhfx969rQ3AsnDSekgRstdw69Iz9lxfbDnOzyRjxtPRi61b
t5dJ/DBE4v+2Nfw0yCul3PA+CbSCtyLMvy8jHcD61ROEbHEufwTG5de4xaReCoNThX4ZTF//OFuF
59xIFduSyQ82m15VlACwLlkSwBHMH+hgU8dYv83Xnz3coZfzUu8NhQZ2l+sSk9iOTr+w/cZGe0Vv
Sfkw+RFW4KBJBkEoCDA8/PMbw8dxWZ70KK6siifNCin4wQU103HJoBpxO6P+mxyxFPMQvCvc54Zv
Cn1luNvytdolvKfAuj4r2L5RC9KCeoqHxuIN70MdTh9VZSkF83yWhAHhad+Tu0Vi2BuF1HISFA30
9m1HcaqixTQqFyn/0n9oSmjJjDVky7Fe530HeAAQU8H8Irls3Yo4VSs/jPBtTm0BnHcQ9E+HJi/D
JYuRNAIy/0xnm172MCmKXqYoDTZlIVnvd1PzvR4Zw+4Xd7za7sDaDRqBhjCTGXew7mmfHLNZkm6F
LXUcWUbBmJvOeMhvfX5ucVXxKN1ZYaIAX1TyeF1MmHB0+V2TipQiNBvVHRt/v2IuTlUNVJ/21cAj
dFsvLLeeJZno0EUjkF3dsibxc3tKTMGoZzjhRhUHyLquLD8aYJqOh+xy8MMpNai0Rn0ysyxTlTt9
x32IcZ4wQsSsAQlTV+osp+oOnDR7qAcALfKtAVAJdW12cMz7YHttRR2N+3G2msnChmcnNhT9I5ge
4H1UT3IzkewRdx/ySHEtwUWWbqnFZ4eZsBmROfJ1+MQzRUtINe54Zh3oItSsMROeSriMGK78vl5x
jv/i1pYSxyEi/EYkacrPTKBEdeB3HYsTihsp5/FJtSmwxO6eix3O+dBASFLPgUUq/Y8a+A7lin8L
9YuESQ0rUut64Wo/1LhErB31Zggk1wpOHR43JCEkMzsxMpk74VL/aWs73kdPUUCWuM+hyo8r9w+/
YqFOjspJ74sddPq31wEaa2wohwPbB6FjsbvEqsxLyqwd64E8hk/yZuzmSFpddKQBWwcp4JrFLt9f
NmE8VtgXnbk1Z5BEZcFxiWXWS14T3Lv3vuowV+zdhv9s/ubsFfRKecUwJCTqKLb2MCcyol+y5aBF
6ohzL/G3f3KzMHiHzkf5o8uOn0QGWp76iV+lqVASGTznAjceFjq8WHmciChwqdBA+7ZME7LT7vGn
lzEJq0X6y8Hd47AMQqGwOvF77XZD6V8ADPNNUuSQYUEET6+t3FEAz8zcwnCAT7nPD8GyR5MAJ/KL
rY6r6RpWIhFzR1n0mt7YAdRHMh/O2+Uyi+P4qAaBI4ngTFB83AuuKHVRilnXMAM844DRgwDFQPMd
9iqL320lxi9e3ln7jDmglobf9N+7SLeIxwz4GP0BAzXvH8LxrXmEs7bFxWkbDVcKq6dJFTf6FR/y
UltLXc4556v81kGn3HO93rb1r/tuns4sGTxHD0d0T30vErTve9BKkXmY/uycWpPcvUYo2FPQrMh1
tHHO254b/pzIjHYUmnTggjYCfvZK0mFfMwxKgfOxf91T1UMxnwQdB68VvBKxmlZt4imcO2LdWeNo
OpExEhlgWK0YkkcHuLg38vObtqZbpBv5CkE+HK7myDIHnBiKVrH4WneFuWhM9z2nM4i/kC7NM2xi
SUpBQxoO3D0QDJQInwcWSMxkNCc9GTXGmRif+4MuwcWPNRBt/ew3p6lQ3wUmaAQHOKgZgyzscoUH
yZFAu7GlnN1zOlP95izJXrnamKyP+UmFNNkQ2U1Gbpd6Dw5ismEYmEb8zR1kBGkgDQqAC/SpZse+
rQuyjdH2GY7q7k/DcuCLrY7S+xLU0GIrfrvKatJOFP1lb9wOjOtUy3b2AtzC+gWUX+JC8fDgzRB9
D/hd8qEyiS6RXWbsosOYNkE1TqvjP+r4W3V384ZGkmsnlCaq9UgAn6+f/8hVrcWHA5ksbinI2QJz
gO2BrcNdW7/ivk6Q8phYU4T6+R9uiPYIF7EKpWIZwOwiFQSjIRWfsolAJYGGOstXqBM6djilJe+S
80t3LK5C9fzB6T0OAsdwoSKTAEiNZvHomJt8Nwq7b/mOml9u4aLjoWJ0Pj3UEP+QoONX6r7cSVFV
wGn2R1sZN9m0+KLgyyEJz3RwrYcxFP81Ghte3Jb3U8ZHrVcoMPAjm/z+8w4jB4pNVTtO9UCX+TcX
2Yy1/ADdT6BQmCdIzZ26x/FMJlhsiMSMMNf0/fuRoaj5jvwguMMt2fttkx89ZZN81D+Gj6zx5LPg
mkgucoCAm7RuDaX3IWo7JNBN+D1++nGqquJeDlo7sS4lGZlFj9XjFfuGclG0Y3+mj8+kfvI6xohg
usM0f7uDfbBOsu2UP6qS36wqcrclneiboxr+likMUYIL2MWsaC+kp7X/Q+K9Rq6miXp2CKgyrRap
hO94FS9AuMdjkXOLNONUJc9T9TdLgT1NXACWAjU9CwLTlKrBcyJykZY0iZhZD8hIZJtWS5gxPNOr
5dP2PVVkp92hhZN48A3eOL5DPuOIYhKTrF8RyvLUyAy43X0/de0zWOcTBkF4fQvofu1s4wQ1N5uK
3a+ISU8leNDBqyYqQ/BcnWrjlgaG0XeoIb8pCqOhNBETt/wCMLXs3ob0vbNsTEuUs6eHCQ27xVih
OcamqmJdPfLFWpmQcBkfbJ1r+mYjo1UTq0aLycGhBvoAak0KGCg4modYG2D8Yr0RoKR+QdjaOGgo
i/0VhoBJNGqZrRL9ZFX2ga25KME525pNICgINR9U/iFfgu/+AfT4hbDe25UJFrAzPYZUHbi3fH0k
hy1P7NOsQr+Vcmq7te2rtFe1AxKuuqqy9iI8ggEZ8FABgzEzlrQAzUJFD1m/rp9oW04t8HXw7M4o
xWo08iNemO6rxMrVkRe2DS/6vIMPeqrpMXuWoFw12l8xaWMVsfPhSBO29JK/siw7MUQ08YsRQyRQ
LiesGshaOKlMJhjMus3ltOiwK2OJJVaa5yPqt9igAE/jiy+6efGw44YekczKeTMSzhd1kq/chEv3
0X2uCEmsiaTTL/wEqWf1BnAyPvQWVXuL/K7xtqR9o1dxiAq0Ufzies/hdp0G2uGr0VekOndSeUNG
9eMUbzg+uoA0x63U5ydKTiSOHAc7KQUnoPNE731/LOueAHWgD1DwTTcS4UplSfSGTVytHuNBWiY2
0yO9JeeAH1wzDBYefUoBnDvTRv6op0pY4DcHMc2npIaKUK0PWdDIFtgbzEafHrZvapIk9XO3zdS7
iahsyuMXkSzBsrZHfx9eRGHHWsma7NjThFtH2CB+bqYonIL6/EoFmDvfJTE7tYtuOqDwJS+mQfft
9c6QZIHysDuAtFfP2G5vJq94DkKTerg2Z7uxNGrUd8BC4UC6xOPMMT6MkmsV+dTK1Oenb/ZK44bh
Qlqsl3HTdrY46kHfgmoyM/CTq+hTs91SDxfKn0TE3TeeCEgLZFLcPT1iCqWBuaMEUU4Jq79jZzT7
7XGgqu/rgSSleF2cZ+3HIUFwtA9ojM2pwv71To4KjF89YHdCwzhZfw/bAK7z2tElGJNVcH73qJaT
3FAs+GqMyFibRrYCkaFPsdkOp4wlUQ0DayRl/SSz+fThnHC38u9FjDIQ0Uxt532brR1lQlAq7okB
MmiMz0M4tTfJNELjZQndnYPBArTgSzhYaedXWkD89UYcyuor1Jgmx4FGPHGfvuHFD7WobRJdre3X
bWBwRbjZghQIHmyL9S8o6WtyOYZL3U8LUvqDkMRSqnCo/bw0SSDyGsWHxi2qMYOJ8ORcXXskCygi
qre7VJx8MB3B4mQqLwgavPvjCHwFuABorb7if7PdTkSuPIFq2cSWJ+xOzT/2/aIr3sg+eSLsd8il
+WWvNsNf6VVidOs56QhPgWOPp99dHZvWnLf3g7PQAmSfZitOOf07uvGFeiVqB8vsr7TBAvUB1t9+
JRP3jYW583O6oADW87zynSUuzmmSXXNt35j0WijqTlPqoRL532vqeeVaEx2M/hAmLH+hpYO7dk3t
UshtVIZor3hhrutoNDrkhNt7xvMR1KdlsP6dsL/WMV2tNMLnkeH/buDFA/vrXK2ZbKk6DKEzbBhN
S6wr8N8vJNvUHG3dKxuLVkMLJkWM1pCxKqcmuOfRqOU85Or9ypJ36/19zZ+HM9yR9ikJFMPvjJgI
gtQOdOiv7cRKK1ago9aRT2/K7i/JY76YknvfwWA96Hk2E8Qm2hck3ziz5mpyGOrrbHyytcCMurxP
nJnEhnuRE2qvzSCM+uY/rlDNfMqeE7g4bvZbarWQWMIUkvGHXVsmNQIqCcdhUvVTm3A3mnOsVOlE
rBRUgCVRa4TmK57tj6Gu8VjM38mqrbZjFQP7QTrhfA7IrrUB1Vgz8FBrLzGtSeJ5otWf8I0VNAH/
bWbNhe82ENwX1XxAV/j2VhYx/lglS2GJeSiYwXI6AIOrcTGmW+Siq4pzk8YoOWldSlys1Rx8aG6M
Z6og/SOoEjRAfQYH8Uq5M/fqdFYwwtoNWCnx9nILq5uVqj+Cy/yhAAWvazeBnIILhrtVOCUr5vLn
YOrr9ccIKK5MUeWOh+aGRuC3eLjHHqM3TqTj8Vir9GxoDt9jLYw6lGaXMZUQgADryc9a2QvjgbOV
U4pk1gctMwzv6T+aB1oLnFVpvFK9OE1NjMAjHZsSWjGzYUwirBj4YNgA7xWtO9zG9tIJ1o1JyyfF
LrBF2j9z5dJETOBNiW5ACLLfnqShNCzjp8GmWZM2lXoxpkNOZqHY2xbNtZFcFBiJRCAqDmv6P+4B
RQpLUsDkmF2u68ycN9rrlcNcgrj415rNisZIdRLC9U60xFuaGozBVXLbEU1YcbUKkX1iNzZD77wd
WrXyVbg3Po4hVtfPQN1Z2ICErnx38jyDb8LNkbgA9BO/C8mAnCaNVittvyc+Dl6BFH+j4xNyOmG4
m4U3baTAZz5U31ga4IqclClt+qxr93xBWTd/sbSu16jS2sEkJPoNx6/I6Lc6OfY3FKg0CgxAYF/t
BUwbeBLH1y44Np8X0CRzO6fZ9iUnL9J5XkRJfREjYtLqONeK+52X9vqfgORXu6jvfGwkMfD1zvAR
C0AI5pVqeJEJ36oMzMYGoF2LKq0U5C+lJiac2PXydDRZlqC2Ap8UgbQruwDJ3JjxVnJG+qTRa9hh
ruWhmT1SdCXd4tmoUl7kTP9e26tqmLegXWpV9uCFfZtPoChx5094dIhOjSdsfgGhq1wNTsMqa8cg
YmJSTBgu0s6Y8K6lHPc9gmjfLMqxC2HxDrquJ+nmPiife+BSCooiyWVhpjc8mMjwoWnQRR44+QRS
FlKp+oIJHWu/9vbj97wcfG2YiyLbReHQN6R4k1zGcp2U24Z8gyPsvAI11KBoyOt2pc+WxngDQDY7
3r7CzBmn3PtK8pM5iz4rAYvaehivh468pzF+PPOqbO//LdrHA0ZIBI3daJ4UHWGhWCXBhqVgoiTc
8F7cNxXwPfL2Vi8iPFJ1q5n0KJjB7t11G9bgKXVTBs7EBWue2bjgo3Bhik/Lu7NSlJldmtbD6wVb
G3Kgo2ymTFS/aSfUAk+Kkk/hykNmYnnJmPw7tOmgjX5PLpBATWWJ5P8j9EXbRcu51IH650fhbAbA
XXUq4nvimo7njY+MKyAmp6RS0cQboxBV5QjXCm3q6/fe+/TNjJwpcbwfE/r37gQjSohvzQW/zWcJ
U7Ve/3/YDHG2mcr1JnkjLIHvceyoyp86FQ65DlsYFl6Noky0+uss5SR5mwzviDyX2BqsntKtEWY6
yiLYPPorFS616Cjwju2Czzpz6ALkcL9Wu7WKbi+wo9j7+60y/gAP+ouaeunNmWQtdRe9LBJiDHUd
KJDBvXuzPtYEZKuPfxfCza1844xG/VtIxq358fxEV9wg0KnpzMj+4X997AaIGZ/YQDSFg3+shRD1
UPKPH0GJVz9GjH4a4/wVlIy80MRqDZMWuiw3OAYjrZRhq1GoX+GGtYBJM9mkFGaFCNLIs8XVU3Wp
bC5nDnGHd9MUx/72suFdszula+iSQqJigo0PWwe+9qQhZqR/qwzYvMLOHg4cVxNcfqCieO7gwNrr
yh1XFTaFZvLcG5xK5pCTrGV5SWMV6LE34far7B+i8gT0aZppPUV8Lq7o/UjHGEZucK87D85NDHR4
Cp6luHZy7d8r05XonJafzMJ2oGJJoDHeURp8xWdBFp+ZJUzh+XjDGi9aEsy5K3S0VOfyUxpUN5FE
9bfYrtI+JMz5XV6Dpw6McmdvgiY26t5p1Eqc+J13wucuXsX0skh5E6XywQNufwkqfk44jziLUneJ
kfupdxDeGYBEo/hZ2DpWlxPIuDiIy+rLY0cA5UjuELoH6C1Aych2hdDwXmmpf6A6XCkh+lsUeWyj
c7gW09GYXyYdzBG9gZAgo4YvIyC0x3OOqITDU6tVneh0QgWLchnFxKl9NwMt6EL4QX0a8LhoiLZd
W7SlIwfkwdQtu3RYLqnN003SNY85yu80D+zTaeMNKVTvvCkj1RTdnOLMFqxk8HVQHQZMWdJNX3e1
VliyvpNcDy1T3nW6o1/e6t+lyLQOtBPTstlR4cqRWtsy7KZ5ryFNXUjwNmJ7ghXioHjq3d2B6Ogn
v+nL/BEaJmHVsSrw7RXQzzG2aAlyiHrrAQwrVk4+fpHaFpMaUls+k08oJaPcvEc/ysHdtD02/RRr
2enoHv7x8euLh9FtXOAxlORzL6k5TXtAbMeyWGNQrXAvn0+xh4mtSZSqZygkX3DpdaYxxRGe4WM0
GrWylQxGWAyWNkO8M8Sav4r2gwWcxis6UXqu37Dwlqe5PCfbIKbRvOaThbCJr19MhGI4zgC5i7CC
YhkCDl7zRGBlYZxt0k88htwILa034RcEEZjUkr/qgzTAnVjGGax8wZgWtdJd8DOysuP6cJEQJw9O
zvbANjpxHbOREejL862XPs3L7kBnpMQEq36+g5N01UDypVTE9bhAW4IrCsBKKzhijOeJswZEOQCk
+aT8ahYUU4bEv8ST/BsnA68jl5qHH3VXap7Zyp8BiI6V/AolAQTBAXfmyI2TikF7NedFtVJPIqXi
AmNJyvb6N93fkjffOTYyZwXJXPRJioecBjw2Hsucg1WpvG3eEnbiQknMihhj1ZeQnHlfVfNImcVq
sOFrF7Cy9Fjh8nZPQUjj8J2Kvv6a1efnlDpZGI648+CgCIPh29SBriwBJJcZrkHcZag4tj53lMGB
BYzWK7cZ8ZNwDxl3e+0rlQqeUyhSbpn/woGti8jwjkDBxdheWNla2qeUR1fytPBWL6c2dQBjog4Q
pX5NLQ8LsX56mNU/JG2aFWV2imhUAPWp2ILVNOD18yo44uPTIs/hed3jYX7YI+n6v3+Xul8JkUML
7ksm8ziqDbxwuir/+VpdgeLWWX7oljfziIJFWCyudUbcP9WyhZwZC216WELqFHpPTpRLkxv/p90E
UmVWLwCVoEvHYF1QYzjApTG2F/+MRYvo/7zy+eMQG+pUZN/YAIFa
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
