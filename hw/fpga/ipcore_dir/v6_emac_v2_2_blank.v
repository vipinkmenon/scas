////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: P.49d
//  \   \         Application: netgen
//  /   /         Filename: v6_emac_v2_2.v
// /___/   /\     Timestamp: Thu Mar 28 10:57:26 2013
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -intstyle ise -w -sim -ofmt verilog ./tmp/_cg/v6_emac_v2_2.ngc ./tmp/_cg/v6_emac_v2_2.v 
// Device	: 6vlx240tff1156-1
// Input file	: ./tmp/_cg/v6_emac_v2_2.ngc
// Output file	: ./tmp/_cg/v6_emac_v2_2.v
// # of Modules	: 1
// Design Name	: v6_emac_v2_2
// Xilinx        : D:\Xilinx\14.4\ISE_DS\ISE\
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Command Line Tools User Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module v6_emac_v2_2 (
  rx_axi_clk, glbl_rstn, rx_axis_mac_tuser, gmii_col, gmii_crs, gmii_tx_en, tx_axi_rstn, gmii_tx_er, tx_collision, rx_axi_rstn, tx_axis_mac_tlast, 
tx_retransmit, tx_axis_mac_tuser, rx_axis_mac_tvalid, rx_statistics_valid, tx_statistics_valid, rx_axis_mac_tlast, speed_is_10_100, gtx_clk, 
rx_reset_out, tx_reset_out, tx_axi_clk, gmii_rx_dv, gmii_rx_er, tx_axis_mac_tready, tx_axis_mac_tvalid, pause_req, tx_statistics_vector, pause_val, 
rx_statistics_vector, gmii_rxd, tx_ifg_delay, tx_axis_mac_tdata, rx_axis_mac_tdata, gmii_txd
)/* synthesis syn_black_box syn_noprune=1 */;
  input rx_axi_clk;
  input glbl_rstn;
  output rx_axis_mac_tuser;
  input gmii_col;
  input gmii_crs;
  output gmii_tx_en;
  input tx_axi_rstn;
  output gmii_tx_er;
  output tx_collision;
  input rx_axi_rstn;
  input tx_axis_mac_tlast;
  output tx_retransmit;
  input tx_axis_mac_tuser;
  output rx_axis_mac_tvalid;
  output rx_statistics_valid;
  output tx_statistics_valid;
  output rx_axis_mac_tlast;
  output speed_is_10_100;
  input gtx_clk;
  output rx_reset_out;
  output tx_reset_out;
  input tx_axi_clk;
  input gmii_rx_dv;
  input gmii_rx_er;
  output tx_axis_mac_tready;
  input tx_axis_mac_tvalid;
  input pause_req;
  output [31 : 0] tx_statistics_vector;
  input [15 : 0] pause_val;
  output [27 : 0] rx_statistics_vector;
  input [7 : 0] gmii_rxd;
  input [7 : 0] tx_ifg_delay;
  input [7 : 0] tx_axis_mac_tdata;
  output [7 : 0] rx_axis_mac_tdata;
  output [7 : 0] gmii_txd;
  
endmodule
