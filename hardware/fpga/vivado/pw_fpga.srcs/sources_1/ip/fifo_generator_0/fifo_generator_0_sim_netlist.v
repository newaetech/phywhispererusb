// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Mon Dec 13 12:24:54 2021
// Host        : red running 64-bit Ubuntu 18.04.6 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/jpnewae/git/DesignStartTrace/hardware/phywhisperer/hardware/fpga/vivado/pw_fpga.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_sim_netlist.v
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
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
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
