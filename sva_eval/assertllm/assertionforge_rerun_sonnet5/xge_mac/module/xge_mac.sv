//////////////////////////////////////////////////////////////////////
////                                                              ////
////  File name "xge_mac.v"                                       ////
////                                                              ////
////  This file is part of the "10GE MAC" project                 ////
////  http://www.opencores.org/cores/xge_mac/                     ////
////                                                              ////
////  Author(s):                                                  ////
////      - A. Tanguay (antanguay@opencores.org)                  ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2008 AUTHORS. All rights reserved.             ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "defines.v"

module xge_mac(/*AUTOARG*/
  // Outputs
  xgmii_txd, xgmii_txc, wb_int_o, wb_dat_o, wb_ack_o, pkt_tx_full,
  pkt_rx_val, pkt_rx_sop, pkt_rx_mod, pkt_rx_err, pkt_rx_eop,
  pkt_rx_data, pkt_rx_avail,
  // Inputs
  xgmii_rxd, xgmii_rxc, wb_we_i, wb_stb_i, wb_rst_i, wb_dat_i,
  wb_cyc_i, wb_clk_i, wb_adr_i, reset_xgmii_tx_n, reset_xgmii_rx_n,
  reset_156m25_n, pkt_tx_val, pkt_tx_sop, pkt_tx_mod, pkt_tx_eop,
  pkt_tx_data, pkt_rx_ren, clk_xgmii_tx, clk_xgmii_rx, clk_156m25
  );

/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input                   clk_156m25;             // To rx_dq0 of rx_dequeue.v, ...
input                   clk_xgmii_rx;           // To rx_eq0 of rx_enqueue.v, ...
input                   clk_xgmii_tx;           // To tx_dq0 of tx_dequeue.v, ...
input                   pkt_rx_ren;             // To rx_dq0 of rx_dequeue.v
input [63:0]            pkt_tx_data;            // To tx_eq0 of tx_enqueue.v
input                   pkt_tx_eop;             // To tx_eq0 of tx_enqueue.v
input [2:0]             pkt_tx_mod;             // To tx_eq0 of tx_enqueue.v
input                   pkt_tx_sop;             // To tx_eq0 of tx_enqueue.v
input                   pkt_tx_val;             // To tx_eq0 of tx_enqueue.v
input                   reset_156m25_n;         // To rx_dq0 of rx_dequeue.v, ...
input                   reset_xgmii_rx_n;       // To rx_eq0 of rx_enqueue.v, ...
input                   reset_xgmii_tx_n;       // To tx_dq0 of tx_dequeue.v, ...
input [7:0]             wb_adr_i;               // To wishbone_if0 of wishbone_if.v
input                   wb_clk_i;               // To sync_clk_wb0 of sync_clk_wb.v, ...
input                   wb_cyc_i;               // To wishbone_if0 of wishbone_if.v
input [31:0]            wb_dat_i;               // To wishbone_if0 of wishbone_if.v
input                   wb_rst_i;               // To sync_clk_wb0 of sync_clk_wb.v, ...
input                   wb_stb_i;               // To wishbone_if0 of wishbone_if.v
input                   wb_we_i;                // To wishbone_if0 of wishbone_if.v
input [7:0]             xgmii_rxc;              // To rx_eq0 of rx_enqueue.v
input [63:0]            xgmii_rxd;              // To rx_eq0 of rx_enqueue.v
// End of automatics

/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output                  pkt_rx_avail;           // From rx_dq0 of rx_dequeue.v
output [63:0]           pkt_rx_data;            // From rx_dq0 of rx_dequeue.v
output                  pkt_rx_eop;             // From rx_dq0 of rx_dequeue.v
output                  pkt_rx_err;             // From rx_dq0 of rx_dequeue.v
output [2:0]            pkt_rx_mod;             // From rx_dq0 of rx_dequeue.v
output                  pkt_rx_sop;             // From rx_dq0 of rx_dequeue.v
output                  pkt_rx_val;             // From rx_dq0 of rx_dequeue.v
output                  pkt_tx_full;            // From tx_eq0 of tx_enqueue.v
output                  wb_ack_o;               // From wishbone_if0 of wishbone_if.v
output [31:0]           wb_dat_o;               // From wishbone_if0 of wishbone_if.v
output                  wb_int_o;               // From wishbone_if0 of wishbone_if.v
output [7:0]            xgmii_txc;              // From tx_dq0 of tx_dequeue.v
output [63:0]           xgmii_txd;              // From tx_dq0 of tx_dequeue.v
// End of automatics

/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire                    clear_stats_rx_octets;  // From wishbone_if0 of wishbone_if.v
wire                    clear_stats_rx_pkts;    // From wishbone_if0 of wishbone_if.v
wire                    clear_stats_tx_octets;  // From wishbone_if0 of wishbone_if.v
wire                    clear_stats_tx_pkts;    // From wishbone_if0 of wishbone_if.v
wire                    ctrl_tx_enable;         // From wishbone_if0 of wishbone_if.v
wire                    ctrl_tx_enable_ctx;     // From sync_clk_xgmii_tx0 of sync_clk_xgmii_tx.v
wire [1:0]              local_fault_msg_det;    // From rx_eq0 of rx_enqueue.v
wire [1:0]              remote_fault_msg_det;   // From rx_eq0 of rx_enqueue.v
wire                    rxdfifo_ralmost_empty;  // From rx_data_fifo0 of rx_data_fifo.v
wire [63:0]             rxdfifo_rdata;          // From rx_data_fifo0 of rx_data_fifo.v
wire                    rxdfifo_rempty;         // From rx_data_fifo0 of rx_data_fifo.v
wire                    rxdfifo_ren;            // From rx_dq0 of rx_dequeue.v
wire [7:0]              rxdfifo_rstatus;        // From rx_data_fifo0 of rx_data_fifo.v
wire [63:0]             rxdfifo_wdata;          // From rx_eq0 of rx_enqueue.v
wire                    rxdfifo_wen;            // From rx_eq0 of rx_enqueue.v
wire                    rxdfifo_wfull;          // From rx_data_fifo0 of rx_data_fifo.v
wire [7:0]              rxdfifo_wstatus;        // From rx_eq0 of rx_enqueue.v
wire                    rxhfifo_ralmost_empty;  // From rx_hold_fifo0 of rx_hold_fifo.v
wire [63:0]             rxhfifo_rdata;          // From rx_hold_fifo0 of rx_hold_fifo.v
wire                    rxhfifo_rempty;         // From rx_hold_fifo0 of rx_hold_fifo.v
wire                    rxhfifo_ren;            // From rx_eq0 of rx_enqueue.v
wire [7:0]              rxhfifo_rstatus;        // From rx_hold_fifo0 of rx_hold_fifo.v
wire [63:0]             rxhfifo_wdata;          // From rx_eq0 of rx_enqueue.v
wire                    rxhfifo_wen;            // From rx_eq0 of rx_enqueue.v
wire [7:0]              rxhfifo_wstatus;        // From rx_eq0 of rx_enqueue.v
wire [13:0]             rxsfifo_wdata;          // From rx_eq0 of rx_enqueue.v
wire                    rxsfifo_wen;            // From rx_eq0 of rx_enqueue.v
wire [31:0]             stats_rx_octets;        // From stats0 of stats.v
wire [31:0]             stats_rx_pkts;          // From stats0 of stats.v
wire [31:0]             stats_tx_octets;        // From stats0 of stats.v
wire [31:0]             stats_tx_pkts;          // From stats0 of stats.v
wire                    status_crc_error;       // From sync_clk_wb0 of sync_clk_wb.v
wire                    status_crc_error_tog;   // From rx_eq0 of rx_enqueue.v
wire                    status_fragment_error;  // From sync_clk_wb0 of sync_clk_wb.v
wire                    status_fragment_error_tog;// From rx_eq0 of rx_enqueue.v
wire                    status_lenght_error;    // From sync_clk_wb0 of sync_clk_wb.v
wire                    status_lenght_error_tog;// From rx_eq0 of rx_enqueue.v
wire                    status_local_fault;     // From sync_clk_wb0 of sync_clk_wb.v
wire                    status_local_fault_crx; // From fault_sm0 of fault_sm.v
wire                    status_local_fault_ctx; // From sync_clk_xgmii_tx0 of sync_clk_xgmii_tx.v
wire                    status_pause_frame_rx;  // From sync_clk_wb0 of sync_clk_wb.v
wire                    status_pause_frame_rx_tog;// From rx_eq0 of rx_enqueue.v
wire                    status_remote_fault;    // From sync_clk_wb0 of sync_clk_wb.v
wire                    status_remote_fault_crx;// From fault_sm0 of fault_sm.v
wire                    status_remote_fault_ctx;// From sync_clk_xgmii_tx0 of sync_clk_xgmii_tx.v
wire                    status_rxdfifo_ovflow;  // From sync_clk_wb0 of sync_clk_wb.v
wire                    status_rxdfifo_ovflow_tog;// From rx_eq0 of rx_enqueue.v
wire                    status_rxdfifo_udflow;  // From sync_clk_wb0 of sync_clk_wb.v
wire                    status_rxdfifo_udflow_tog;// From rx_dq0 of rx_dequeue.v
wire                    status_txdfifo_ovflow;  // From sync_clk_wb0 of sync_clk_wb.v
wire                    status_txdfifo_ovflow_tog;// From tx_eq0 of tx_enqueue.v
wire                    status_txdfifo_udflow;  // From sync_clk_wb0 of sync_clk_wb.v
wire                    status_txdfifo_udflow_tog;// From tx_dq0 of tx_dequeue.v
wire                    txdfifo_ralmost_empty;  // From tx_data_fifo0 of tx_data_fifo.v
wire [63:0]             txdfifo_rdata;          // From tx_data_fifo0 of tx_data_fifo.v
wire                    txdfifo_rempty;         // From tx_data_fifo0 of tx_data_fifo.v
wire                    txdfifo_ren;            // From tx_dq0 of tx_dequeue.v
wire [7:0]              txdfifo_rstatus;        // From tx_data_fifo0 of tx_data_fifo.v
wire                    txdfifo_walmost_full;   // From tx_data_fifo0 of tx_data_fifo.v
wire [63:0]             txdfifo_wdata;          // From tx_eq0 of tx_enqueue.v
wire                    txdfifo_wen;            // From tx_eq0 of tx_enqueue.v
wire                    txdfifo_wfull;          // From tx_data_fifo0 of tx_data_fifo.v
wire [7:0]              txdfifo_wstatus;        // From tx_eq0 of tx_enqueue.v
wire                    txhfifo_ralmost_empty;  // From tx_hold_fifo0 of tx_hold_fifo.v
wire [63:0]             txhfifo_rdata;          // From tx_hold_fifo0 of tx_hold_fifo.v
wire                    txhfifo_rempty;         // From tx_hold_fifo0 of tx_hold_fifo.v
wire                    txhfifo_ren;            // From tx_dq0 of tx_dequeue.v
wire [7:0]              txhfifo_rstatus;        // From tx_hold_fifo0 of tx_hold_fifo.v
wire                    txhfifo_walmost_full;   // From tx_hold_fifo0 of tx_hold_fifo.v
wire [63:0]             txhfifo_wdata;          // From tx_dq0 of tx_dequeue.v
wire                    txhfifo_wen;            // From tx_dq0 of tx_dequeue.v
wire                    txhfifo_wfull;          // From tx_hold_fifo0 of tx_hold_fifo.v
wire [7:0]              txhfifo_wstatus;        // From tx_dq0 of tx_dequeue.v
wire [13:0]             txsfifo_wdata;          // From tx_dq0 of tx_dequeue.v
wire                    txsfifo_wen;            // From tx_dq0 of tx_dequeue.v
// End of automatics

rx_enqueue rx_eq0(/*AUTOINST*/
                  // Outputs
                  .rxdfifo_wdata        (rxdfifo_wdata[63:0]),
                  .rxdfifo_wstatus      (rxdfifo_wstatus[7:0]),
                  .rxdfifo_wen          (rxdfifo_wen),
                  .rxhfifo_ren          (rxhfifo_ren),
                  .rxhfifo_wdata        (rxhfifo_wdata[63:0]),
                  .rxhfifo_wstatus      (rxhfifo_wstatus[7:0]),
                  .rxhfifo_wen          (rxhfifo_wen),
                  .local_fault_msg_det  (local_fault_msg_det[1:0]),
                  .remote_fault_msg_det (remote_fault_msg_det[1:0]),
                  .status_crc_error_tog (status_crc_error_tog),
                  .status_fragment_error_tog(status_fragment_error_tog),
                  .status_lenght_error_tog(status_lenght_error_tog),
                  .status_rxdfifo_ovflow_tog(status_rxdfifo_ovflow_tog),
                  .status_pause_frame_rx_tog(status_pause_frame_rx_tog),
                  .rxsfifo_wen          (rxsfifo_wen),
                  .rxsfifo_wdata        (rxsfifo_wdata[13:0]),
                  // Inputs
                  .clk_xgmii_rx         (clk_xgmii_rx),
                  .reset_xgmii_rx_n     (reset_xgmii_rx_n),
                  .xgmii_rxd            (xgmii_rxd[63:0]),
                  .xgmii_rxc            (xgmii_rxc[7:0]),
                  .rxdfifo_wfull        (rxdfifo_wfull),
                  .rxhfifo_rdata        (rxhfifo_rdata[63:0]),
                  .rxhfifo_rstatus      (rxhfifo_rstatus[7:0]),
                  .rxhfifo_rempty       (rxhfifo_rempty),
                  .rxhfifo_ralmost_empty(rxhfifo_ralmost_empty));

rx_dequeue rx_dq0(/*AUTOINST*/
                  // Outputs
                  .rxdfifo_ren          (rxdfifo_ren),
                  .pkt_rx_data          (pkt_rx_data[63:0]),
                  .pkt_rx_val           (pkt_rx_val),
                  .pkt_rx_sop           (pkt_rx_sop),
                  .pkt_rx_eop           (pkt_rx_eop),
                  .pkt_rx_err           (pkt_rx_err),
                  .pkt_rx_mod           (pkt_rx_mod[2:0]),
                  .pkt_rx_avail         (pkt_rx_avail),
                  .status_rxdfifo_udflow_tog(status_rxdfifo_udflow_tog),
                  // Inputs
                  .clk_156m25           (clk_156m25),
                  .reset_156m25_n       (reset_156m25_n),
                  .rxdfifo_rdata        (rxdfifo_rdata[63:0]),
                  .rxdfifo_rstatus      (rxdfifo_rstatus[7:0]),
                  .rxdfifo_rempty       (rxdfifo_rempty),
                  .rxdfifo_ralmost_empty(rxdfifo_ralmost_empty),
                  .pkt_rx_ren           (pkt_rx_ren));

rx_data_fifo rx_data_fifo0(/*AUTOINST*/
                           // Outputs
                           .rxdfifo_wfull       (rxdfifo_wfull),
                           .rxdfifo_rdata       (rxdfifo_rdata[63:0]),
                           .rxdfifo_rstatus     (rxdfifo_rstatus[7:0]),
                           .rxdfifo_rempty      (rxdfifo_rempty),
                           .rxdfifo_ralmost_empty(rxdfifo_ralmost_empty),
                           // Inputs
                           .clk_xgmii_rx        (clk_xgmii_rx),
                           .clk_156m25          (clk_156m25),
                           .reset_xgmii_rx_n    (reset_xgmii_rx_n),
                           .reset_156m25_n      (reset_156m25_n),
                           .rxdfifo_wdata       (rxdfifo_wdata[63:0]),
                           .rxdfifo_wstatus     (rxdfifo_wstatus[7:0]),
                           .rxdfifo_wen         (rxdfifo_wen),
                           .rxdfifo_ren         (rxdfifo_ren));

rx_hold_fifo rx_hold_fifo0(/*AUTOINST*/
                           // Outputs
                           .rxhfifo_rdata       (rxhfifo_rdata[63:0]),
                           .rxhfifo_rstatus     (rxhfifo_rstatus[7:0]),
                           .rxhfifo_rempty      (rxhfifo_rempty),
                           .rxhfifo_ralmost_empty(rxhfifo_ralmost_empty),
                           // Inputs
                           .clk_xgmii_rx        (clk_xgmii_rx),
                           .reset_xgmii_rx_n    (reset_xgmii_rx_n),
                           .rxhfifo_wdata       (rxhfifo_wdata[63:0]),
                           .rxhfifo_wstatus     (rxhfifo_wstatus[7:0]),
                           .rxhfifo_wen         (rxhfifo_wen),
                           .rxhfifo_ren         (rxhfifo_ren));

tx_enqueue tx_eq0 (/*AUTOINST*/
                   // Outputs
                   .pkt_tx_full         (pkt_tx_full),
                   .txdfifo_wdata       (txdfifo_wdata[63:0]),
                   .txdfifo_wstatus     (txdfifo_wstatus[7:0]),
                   .txdfifo_wen         (txdfifo_wen),
                   .status_txdfifo_ovflow_tog(status_txdfifo_ovflow_tog),
                   // Inputs
                   .clk_156m25          (clk_156m25),
                   .reset_156m25_n      (reset_156m25_n),
                   .pkt_tx_data         (pkt_tx_data[63:0]),
                   .pkt_tx_val          (pkt_tx_val),
                   .pkt_tx_sop          (pkt_tx_sop),
                   .pkt_tx_eop          (pkt_tx_eop),
                   .pkt_tx_mod          (pkt_tx_mod[2:0]),
                   .txdfifo_wfull       (txdfifo_wfull),
                   .txdfifo_walmost_full(txdfifo_walmost_full));

tx_dequeue tx_dq0(/*AUTOINST*/
                  // Outputs
                  .txdfifo_ren          (txdfifo_ren),
                  .txhfifo_ren          (txhfifo_ren),
                  .txhfifo_wdata        (txhfifo_wdata[63:0]),
                  .txhfifo_wstatus      (txhfifo_wstatus[7:0]),
                  .txhfifo_wen          (txhfifo_wen),
                  .xgmii_txd            (xgmii_txd[63:0]),
                  .xgmii_txc            (xgmii_txc[7:0]),
                  .status_txdfifo_udflow_tog(status_txdfifo_udflow_tog),
                  .txsfifo_wen          (txsfifo_wen),
                  .txsfifo_wdata        (txsfifo_wdata[13:0]),
                  // Inputs
                  .clk_xgmii_tx         (clk_xgmii_tx),
                  .reset_xgmii_tx_n     (reset_xgmii_tx_n),
                  .ctrl_tx_enable_ctx   (ctrl_tx_enable_ctx),
                  .status_local_fault_ctx(status_local_fault_ctx),
                  .status_remote_fault_ctx(status_remote_fault_ctx),
                  .txdfifo_rdata        (txdfifo_rdata[63:0]),
                  .txdfifo_rstatus      (txdfifo_rstatus[7:0]),
                  .txdfifo_rempty       (txdfifo_rempty),
                  .txdfifo_ralmost_empty(txdfifo_ralmost_empty),
                  .txhfifo_rdata        (txhfifo_rdata[63:0]),
                  .txhfifo_rstatus      (txhfifo_rstatus[7:0]),
                  .txhfifo_rempty       (txhfifo_rempty),
                  .txhfifo_ralmost_empty(txhfifo_ralmost_empty),
                  .txhfifo_wfull        (txhfifo_wfull),
                  .txhfifo_walmost_full (txhfifo_walmost_full));

tx_data_fifo tx_data_fifo0(/*AUTOINST*/
                           // Outputs
                           .txdfifo_wfull       (txdfifo_wfull),
                           .txdfifo_walmost_full(txdfifo_walmost_full),
                           .txdfifo_rdata       (txdfifo_rdata[63:0]),
                           .txdfifo_rstatus     (txdfifo_rstatus[7:0]),
                           .txdfifo_rempty      (txdfifo_rempty),
                           .txdfifo_ralmost_empty(txdfifo_ralmost_empty),
                           // Inputs
                           .clk_xgmii_tx        (clk_xgmii_tx),
                           .clk_156m25          (clk_156m25),
                           .reset_xgmii_tx_n    (reset_xgmii_tx_n),
                           .reset_156m25_n      (reset_156m25_n),
                           .txdfifo_wdata       (txdfifo_wdata[63:0]),
                           .txdfifo_wstatus     (txdfifo_wstatus[7:0]),
                           .txdfifo_wen         (txdfifo_wen),
                           .txdfifo_ren         (txdfifo_ren));

tx_hold_fifo tx_hold_fifo0(/*AUTOINST*/
                           // Outputs
                           .txhfifo_wfull       (txhfifo_wfull),
                           .txhfifo_walmost_full(txhfifo_walmost_full),
                           .txhfifo_rdata       (txhfifo_rdata[63:0]),
                           .txhfifo_rstatus     (txhfifo_rstatus[7:0]),
                           .txhfifo_rempty      (txhfifo_rempty),
                           .txhfifo_ralmost_empty(txhfifo_ralmost_empty),
                           // Inputs
                           .clk_xgmii_tx        (clk_xgmii_tx),
                           .reset_xgmii_tx_n    (reset_xgmii_tx_n),
                           .txhfifo_wdata       (txhfifo_wdata[63:0]),
                           .txhfifo_wstatus     (txhfifo_wstatus[7:0]),
                           .txhfifo_wen         (txhfifo_wen),
                           .txhfifo_ren         (txhfifo_ren));

fault_sm fault_sm0(/*AUTOINST*/
                   // Outputs
                   .status_local_fault_crx(status_local_fault_crx),
                   .status_remote_fault_crx(status_remote_fault_crx),
                   // Inputs
                   .clk_xgmii_rx        (clk_xgmii_rx),
                   .reset_xgmii_rx_n    (reset_xgmii_rx_n),
                   .local_fault_msg_det (local_fault_msg_det[1:0]),
                   .remote_fault_msg_det(remote_fault_msg_det[1:0]));

sync_clk_wb sync_clk_wb0(/*AUTOINST*/
                         // Outputs
                         .status_crc_error      (status_crc_error),
                         .status_fragment_error (status_fragment_error),
                         .status_lenght_error   (status_lenght_error),
                         .status_txdfifo_ovflow (status_txdfifo_ovflow),
                         .status_txdfifo_udflow (status_txdfifo_udflow),
                         .status_rxdfifo_ovflow (status_rxdfifo_ovflow),
                         .status_rxdfifo_udflow (status_rxdfifo_udflow),
                         .status_pause_frame_rx (status_pause_frame_rx),
                         .status_local_fault    (status_local_fault),
                         .status_remote_fault   (status_remote_fault),
                         // Inputs
                         .wb_clk_i              (wb_clk_i),
                         .wb_rst_i              (wb_rst_i),
                         .status_crc_error_tog  (status_crc_error_tog),
                         .status_fragment_error_tog(status_fragment_error_tog),
                         .status_lenght_error_tog(status_lenght_error_tog),
                         .status_txdfifo_ovflow_tog(status_txdfifo_ovflow_tog),
                         .status_txdfifo_udflow_tog(status_txdfifo_udflow_tog),
                         .status_rxdfifo_ovflow_tog(status_rxdfifo_ovflow_tog),
                         .status_rxdfifo_udflow_tog(status_rxdfifo_udflow_tog),
                         .status_pause_frame_rx_tog(status_pause_frame_rx_tog),
                         .status_local_fault_crx(status_local_fault_crx),
                         .status_remote_fault_crx(status_remote_fault_crx));

sync_clk_xgmii_tx sync_clk_xgmii_tx0(/*AUTOINST*/
                                     // Outputs
                                     .ctrl_tx_enable_ctx(ctrl_tx_enable_ctx),
                                     .status_local_fault_ctx(status_local_fault_ctx),
                                     .status_remote_fault_ctx(status_remote_fault_ctx),
                                     // Inputs
                                     .clk_xgmii_tx      (clk_xgmii_tx),
                                     .reset_xgmii_tx_n  (reset_xgmii_tx_n),
                                     .ctrl_tx_enable    (ctrl_tx_enable),
                                     .status_local_fault_crx(status_local_fault_crx),
                                     .status_remote_fault_crx(status_remote_fault_crx));

stats stats0(/*AUTOINST*/
             // Outputs
             .stats_rx_octets           (stats_rx_octets[31:0]),
             .stats_rx_pkts             (stats_rx_pkts[31:0]),
             .stats_tx_octets           (stats_tx_octets[31:0]),
             .stats_tx_pkts             (stats_tx_pkts[31:0]),
             // Inputs
             .clear_stats_rx_octets     (clear_stats_rx_octets),
             .clear_stats_rx_pkts       (clear_stats_rx_pkts),
             .clear_stats_tx_octets     (clear_stats_tx_octets),
             .clear_stats_tx_pkts       (clear_stats_tx_pkts),
             .clk_xgmii_rx              (clk_xgmii_rx),
             .clk_xgmii_tx              (clk_xgmii_tx),
             .reset_xgmii_rx_n          (reset_xgmii_rx_n),
             .reset_xgmii_tx_n          (reset_xgmii_tx_n),
             .rxsfifo_wdata             (rxsfifo_wdata[13:0]),
             .rxsfifo_wen               (rxsfifo_wen),
             .txsfifo_wdata             (txsfifo_wdata[13:0]),
             .txsfifo_wen               (txsfifo_wen),
             .wb_clk_i                  (wb_clk_i),
             .wb_rst_i                  (wb_rst_i));

//sync_clk_core sync_clk_core0(/*AUTOINST*/
//                             // Inputs
//                             .clk_xgmii_tx      (clk_xgmii_tx),
//                             .reset_xgmii_tx_n  (reset_xgmii_tx_n));

wishbone_if wishbone_if0(/*AUTOINST*/
                         // Outputs
                         .wb_dat_o              (wb_dat_o[31:0]),
                         .wb_ack_o              (wb_ack_o),
                         .wb_int_o              (wb_int_o),
                         .ctrl_tx_enable        (ctrl_tx_enable),
                         .clear_stats_tx_octets (clear_stats_tx_octets),
                         .clear_stats_tx_pkts   (clear_stats_tx_pkts),
                         .clear_stats_rx_octets (clear_stats_rx_octets),
                         .clear_stats_rx_pkts   (clear_stats_rx_pkts),
                         // Inputs
                         .wb_clk_i              (wb_clk_i),
                         .wb_rst_i              (wb_rst_i),
                         .wb_adr_i              (wb_adr_i[7:0]),
                         .wb_dat_i              (wb_dat_i[31:0]),
                         .wb_we_i               (wb_we_i),
                         .wb_stb_i              (wb_stb_i),
                         .wb_cyc_i              (wb_cyc_i),
                         .status_crc_error      (status_crc_error),
                         .status_fragment_error (status_fragment_error),
                         .status_lenght_error   (status_lenght_error),
                         .status_txdfifo_ovflow (status_txdfifo_ovflow),
                         .status_txdfifo_udflow (status_txdfifo_udflow),
                         .status_rxdfifo_ovflow (status_rxdfifo_ovflow),
                         .status_rxdfifo_udflow (status_rxdfifo_udflow),
                         .status_pause_frame_rx (status_pause_frame_rx),
                         .status_local_fault    (status_local_fault),
                         .status_remote_fault   (status_remote_fault),
                         .stats_tx_octets       (stats_tx_octets[31:0]),
                         .stats_tx_pkts         (stats_tx_pkts[31:0]),
                         .stats_rx_octets       (stats_rx_octets[31:0]),
                         .stats_rx_pkts         (stats_rx_pkts[31:0]));

  // --- Formal assertions ---
  // AssertionForge baseline SVA for mac
  // 918 assertions captured from gen_plan.generate_svas

  property af_p0;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> (!pkt_rx_err) [*5];
  endproperty
  assert property(af_p0);

  property af_p1;
  @(posedge clk_156m25) (pkt_tx_val) |-> ##1 (pkt_tx_data !== $past(pkt_tx_data)) || $stable(pkt_tx_data);
  endproperty
  assert property(af_p1);

  property af_p2;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> $stable(reset_156m25_n);
  endproperty
  assert property(af_p2);

  property af_p3;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> (reset_156m25_n) [*10];
  endproperty
  assert property(af_p3);

  property af_p4;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (pkt_tx_val == 1'b0) and (reset_156m25_n throughout (!pkt_tx_val)[*1]);
  endproperty
  assert property(af_p4);

  property af_p5;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (!pkt_rx_sop && !pkt_rx_eop);
  endproperty
  assert property(af_p5);

  property af_p6;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> ##[0:2] $rose(reset_xgmii_tx_n);
  endproperty
  assert property(af_p6);

  property af_p7;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> (pkt_rx_avail !== 1'bx) [*4];
  endproperty
  assert property(af_p7);

  property af_p8;
  @(posedge clk_156m25) (!pkt_rx_val) |-> !(pkt_rx_sop && pkt_rx_eop);
  endproperty
  assert property(af_p8);

  property af_p9;
  @(posedge clk_156m25) 1'b1 |-> ($stable(pkt_rx_mod) || $changed(pkt_rx_mod)) && ($stable(pkt_tx_mod) || $changed(pkt_tx_mod));
  endproperty
  assert property(af_p9);

  property af_p10;
  @(posedge clk_156m25) (reset_156m25_n) |-> (pkt_tx_full !== 1'bx);
  endproperty
  assert property(af_p10);

  property af_p11;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> ##[0:2] (pkt_rx_avail !== 1'bx);
  endproperty
  assert property(af_p11);

  property af_p12;
  @(posedge clk_156m25) $rose(reset_xgmii_tx_n) |-> ##[0:2] $rose(reset_156m25_n);
  endproperty
  assert property(af_p12);

  property af_p13;
  @(posedge clk_156m25) pkt_rx_err |-> pkt_rx_val;
  endproperty
  assert property(af_p13);

  property af_p14;
  @(posedge clk_156m25) pkt_tx_sop |-> ($rose(pkt_tx_val));
  endproperty
  assert property(af_p14);

  property af_p15;
  @(posedge clk_156m25) $rose(pkt_rx_val) |-> pkt_rx_sop;
  endproperty
  assert property(af_p15);

  property af_p16;
  @(posedge clk_156m25) (reset_156m25_n !== $past(reset_156m25_n)) |-> $rose(reset_156m25_n);
  endproperty
  assert property(af_p16);

  property af_p17;
  @(posedge clk_156m25) pkt_rx_val |=> $stable(pkt_rx_data);
  endproperty
  assert property(af_p17);

  property af_p18;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (!pkt_rx_val);
  endproperty
  assert property(af_p18);

  property af_p19;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (!pkt_rx_ren);
  endproperty
  assert property(af_p19);

  property af_p20;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> !$isunknown(pkt_rx_data)[*4];
  endproperty
  assert property(af_p20);

  property af_p21;
  @(posedge clk_156m25) (pkt_rx_avail !== $past(pkt_rx_avail)) |-> $changed(pkt_rx_avail);
  endproperty
  assert property(af_p21);

  property af_p22;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> ##[0:2] (reset_xgmii_rx_n && reset_xgmii_tx_n);
  endproperty
  assert property(af_p22);

  property af_p23;
  @(posedge clk_156m25) (pkt_tx_full) |-> $stable(pkt_tx_data);
  endproperty
  assert property(af_p23);

  property af_p24;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> ##[0:2] $rose(reset_xgmii_rx_n);
  endproperty
  assert property(af_p24);

  property af_p25;
  @(posedge clk_156m25) (pkt_rx_val) |-> $stable(pkt_rx_data);
  endproperty
  assert property(af_p25);

  property af_p26;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (!pkt_tx_val);
  endproperty
  assert property(af_p26);

  property af_p27;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> ##[1:3] (!pkt_tx_full);
  endproperty
  assert property(af_p27);

  property af_p28;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> ##3 (!pkt_tx_full);
  endproperty
  assert property(af_p28);

  property af_p29;
  @(posedge clk_156m25) (pkt_tx_sop || pkt_tx_eop) |-> (pkt_tx_val);
  endproperty
  assert property(af_p29);

  property af_p30;
  @(posedge clk_156m25) (1'b1) |-> (!$isunknown(pkt_rx_ren));
  endproperty
  assert property(af_p30);

  property af_p31;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> (!$isunknown(pkt_tx_data))[*5];
  endproperty
  assert property(af_p31);

  property af_p32;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> ($past(reset_156m25_n,1) == 1'b0 && $past(reset_156m25_n,2) == 1'b0);
  endproperty
  assert property(af_p32);

  property af_p33;
  @(posedge clk_156m25) $rose(reset_xgmii_rx_n) |-> ##[0:2] $rose(reset_156m25_n);
  endproperty
  assert property(af_p33);

  property af_p34;
  @(posedge clk_xgmii_rx) (!$isunknown(xgmii_rxd)) && (!$isunknown(xgmii_rxc));
  endproperty
  assert property(af_p34);

  property af_p35;
  @(posedge clk_xgmii_rx) !$isunknown(xgmii_rxc);
  endproperty
  assert property(af_p35);

  property af_p36;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ##[0:2] (reset_156m25_n && reset_xgmii_tx_n);
  endproperty
  assert property(af_p36);

  property af_p37;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ##[1:2] reset_156m25_n;
  endproperty
  assert property(af_p37);

  property af_p38;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> !pkt_rx_val;
  endproperty
  assert property(af_p38);

  property af_p39;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ##1 $stable(xgmii_rxc);
  endproperty
  assert property(af_p39);

  property af_p40;
  @(posedge clk_xgmii_rx) !$isunknown(xgmii_rxd);
  endproperty
  assert property(af_p40);

  property af_p41;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> reset_xgmii_rx_n;
  endproperty
  assert property(af_p41);

  property af_p42;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ##1 !$isunknown(xgmii_rxc);
  endproperty
  assert property(af_p42);

  property af_p43;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> ($stable(xgmii_rxd) && $stable(xgmii_rxc));
  endproperty
  assert property(af_p43);

  property af_p44;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> (!pkt_rx_err) ##1 (!pkt_rx_err);
  endproperty
  assert property(af_p44);

  property af_p45;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> $stable(xgmii_rxd);
  endproperty
  assert property(af_p45);

  property af_p46;
  @(posedge clk_xgmii_rx) $rose(reset_156m25_n) |-> ##[0:2] $rose(reset_xgmii_rx_n);
  endproperty
  assert property(af_p46);

  property af_p47;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ##[0:2] $rose(reset_xgmii_tx_n);
  endproperty
  assert property(af_p47);

  property af_p48;
  @(posedge clk_xgmii_rx) ($changed(pkt_rx_sop) || $changed(pkt_rx_eop)) |-> $past(!reset_xgmii_rx_n);
  endproperty
  assert property(af_p48);

  property af_p49;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> (!pkt_rx_val) ##1 (!pkt_rx_val);
  endproperty
  assert property(af_p49);

  property af_p50;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ($past(!reset_xgmii_rx_n,1) && $past(!reset_xgmii_rx_n,2));
  endproperty
  assert property(af_p50);

  property af_p51;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> !$isunknown(reset_xgmii_rx_n);
  endproperty
  assert property(af_p51);

  property af_p52;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ##[1:4] (!$isunknown(xgmii_rxc) && $stable(xgmii_rxc));
  endproperty
  assert property(af_p52);

  property af_p53;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ##1 !$isunknown(pkt_rx_avail);
  endproperty
  assert property(af_p53);

  property af_p54;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> (!pkt_rx_sop && !pkt_rx_eop)[*2];
  endproperty
  assert property(af_p54);

  property af_p55;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ##3 !$isunknown(xgmii_rxc);
  endproperty
  assert property(af_p55);

  property af_p56;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> (!pkt_rx_err)[*2];
  endproperty
  assert property(af_p56);

  property af_p57;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> (!$isunknown(xgmii_rxd) && !$isunknown(xgmii_rxc));
  endproperty
  assert property(af_p57);

  property af_p58;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |-> ($stable(xgmii_txd) && $stable(xgmii_txc));
  endproperty
  assert property(af_p58);

  property af_p59;
  @(posedge clk_xgmii_tx) 1'b1 |-> ($changed(reset_xgmii_tx_n) || $stable(reset_xgmii_tx_n));
  endproperty
  assert property(af_p59);

  property af_p60;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> (xgmii_txd == 8'h07);
  endproperty
  assert property(af_p60);

  property af_p61;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> 1'b1;
  endproperty
  assert property(af_p61);

  property af_p62;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> (xgmii_txd == 8'h07)[*4];
  endproperty
  assert property(af_p62);

  property af_p63;
  @(posedge clk_xgmii_tx) (reset_xgmii_tx_n) |-> (xgmii_txd >= 8'd0 && xgmii_txd <= 8'd255);
  endproperty
  assert property(af_p63);

  property af_p64;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ($stable(xgmii_txc) && !$isunknown(xgmii_txc))[*4];
  endproperty
  assert property(af_p64);

  property af_p65;
  @(posedge clk_xgmii_tx) (reset_xgmii_tx_n) |-> !$isunknown(xgmii_txc);
  endproperty
  assert property(af_p65);

  property af_p66;
  @(posedge clk_xgmii_tx) $rose(reset_156m25_n) |-> ##[0:2] $rose(reset_xgmii_tx_n);
  endproperty
  assert property(af_p66);

  property af_p67;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |-> $stable(xgmii_txd);
  endproperty
  assert property(af_p67);

  property af_p68;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##1 (!$isunknown(xgmii_txd) && $stable(xgmii_txd))[*1:$];
  endproperty
  assert property(af_p68);

  property af_p69;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ($past(reset_xgmii_tx_n,1) == 1'b0 && $past(reset_xgmii_tx_n,2) == 1'b0);
  endproperty
  assert property(af_p69);

  property af_p70;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##4 (xgmii_txd >= 0 && xgmii_txd <= 255);
  endproperty
  assert property(af_p70);

  property af_p71;
  @(posedge clk_xgmii_tx) 1'b1 |-> ##1 $stable(xgmii_txc);
  endproperty
  assert property(af_p71);

  property af_p72;
  @(posedge clk_xgmii_tx) (xgmii_txc !== $past(xgmii_txc)) |-> (xgmii_txd !== $past(xgmii_txd));
  endproperty
  assert property(af_p72);

  property af_p73;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> (xgmii_txd == 8'h07)[*3];
  endproperty
  assert property(af_p73);

  property af_p74;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##[0:2] $rose(reset_xgmii_rx_n);
  endproperty
  assert property(af_p74);

  property af_p75;
  @(posedge clk_xgmii_tx) 1'b1 |-> ##1 $stable(xgmii_txd);
  endproperty
  assert property(af_p75);

  property af_p76;
  @(posedge clk_xgmii_tx) $changed(xgmii_txd) |-> $changed(xgmii_txc);
  endproperty
  assert property(af_p76);

  property af_p77;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##[0:2] !$isunknown(xgmii_txc);
  endproperty
  assert property(af_p77);

  property af_p78;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##[0:2] $rose(reset_156m25_n);
  endproperty
  assert property(af_p78);

  property af_p79;
  @(posedge clk_xgmii_rx) $rose(pkt_rx_avail) |-> pkt_rx_avail throughout (##[0:$] pkt_rx_eop);
  endproperty
  assert property(af_p79);

  property af_p80;
  @(posedge clk_xgmii_rx) (pkt_rx_avail) |-> (!pkt_rx_err);
  endproperty
  assert property(af_p80);

  property af_p81;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> (!pkt_rx_avail);
  endproperty
  assert property(af_p81);

  property af_p82;
  @(posedge clk_156m25) $fell(pkt_rx_avail) |-> pkt_rx_eop;
  endproperty
  assert property(af_p82);

  property af_p83;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ##[1:$] $rose(pkt_rx_avail);
  endproperty
  assert property(af_p83);

  property af_p84;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (!pkt_rx_avail);
  endproperty
  assert property(af_p84);

  property af_p85;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> (!pkt_rx_avail)[*3];
  endproperty
  assert property(af_p85);

  property af_p86;
  @(posedge clk_xgmii_rx) pkt_rx_avail |-> ##1 pkt_rx_ren;
  endproperty
  assert property(af_p86);

  property af_p87;
  @(posedge clk_xgmii_rx) pkt_rx_eop |-> ##[1:5] pkt_rx_avail;
  endproperty
  assert property(af_p87);

  property af_p88;
  @(posedge clk_xgmii_rx) pkt_rx_avail |-> ##[1:$] pkt_rx_val;
  endproperty
  assert property(af_p88);

  property af_p89;
  @(posedge clk_156m25) $rose(pkt_rx_avail) |-> (pkt_rx_avail until_with pkt_rx_eop);
  endproperty
  assert property(af_p89);

  property af_p90;
  @(posedge clk_156m25) (pkt_rx_avail && pkt_rx_ren) |-> ##1 pkt_rx_val;
  endproperty
  assert property(af_p90);

  property af_p91;
  @(posedge clk_156m25) disable iff (!reset_156m25_n) (pkt_rx_val && pkt_rx_sop) |-> pkt_rx_avail;
  endproperty
  assert property(af_p91);

  property af_p92;
  @(posedge clk_156m25) $rose(pkt_rx_avail) |-> (pkt_rx_avail throughout (!pkt_rx_eop)[*0:$] ##1 pkt_rx_eop);
  endproperty
  assert property(af_p92);

  property af_p93;
  @(posedge clk_156m25) disable iff (!reset_156m25_n) (!pkt_rx_eop) |=> $stable(pkt_rx_avail);
  endproperty
  assert property(af_p93);

  property af_p94;
  @(posedge clk_156m25) pkt_rx_avail |=> pkt_rx_sop;
  endproperty
  assert property(af_p94);

  property af_p95;
  @(posedge clk_xgmii_rx) pkt_rx_sop |-> (pkt_rx_avail throughout (##[0:$] pkt_rx_eop));
  endproperty
  assert property(af_p95);

  property af_p96;
  @(posedge clk_xgmii_rx) pkt_rx_eop |=> !pkt_rx_avail;
  endproperty
  assert property(af_p96);

  property af_p97;
  @(posedge clk_156m25) disable iff (!reset_156m25_n) (pkt_rx_avail[*4]) |=> pkt_rx_val;
  endproperty
  assert property(af_p97);

  property af_p98;
  @(posedge clk_xgmii_rx) pkt_rx_ren |-> $stable(pkt_rx_avail);
  endproperty
  assert property(af_p98);

  property af_p99;
  @(posedge clk_xgmii_rx) (pkt_rx_ren && !pkt_rx_val) |-> $stable(pkt_rx_data);
  endproperty
  assert property(af_p99);

  property af_p100;
  @(posedge clk_156m25) (!reset_156m25_n) |-> $stable(pkt_rx_data);
  endproperty
  assert property(af_p100);

  property af_p101;
  @(posedge clk_xgmii_rx) (!pkt_rx_ren && !$past(pkt_rx_ren)) |-> $stable(pkt_rx_data);
  endproperty
  assert property(af_p101);

  property af_p102;
  @(posedge clk_156m25) ($changed(pkt_rx_data)) |-> (pkt_rx_val && pkt_rx_ren);
  endproperty
  assert property(af_p102);

  property af_p103;
  @(posedge clk_xgmii_rx) (pkt_rx_eop && (pkt_rx_mod == 3'b000)) |-> (!$isunknown(pkt_rx_data[63:0]));
  endproperty
  assert property(af_p103);

  property af_p104;
  @(posedge clk_156m25) (pkt_rx_val) |-> (!$isunknown(pkt_rx_data));
  endproperty
  assert property(af_p104);

  property af_p105;
  @(posedge clk_156m25) (pkt_rx_eop && (pkt_rx_mod == 3'd1)) |-> (!$isunknown(pkt_rx_data[7:0]));
  endproperty
  assert property(af_p105);

  property af_p106;
  @(posedge clk_156m25) (pkt_rx_err) |-> (1'b1);
  endproperty
  assert property(af_p106);

  property af_p107;
  @(posedge clk_xgmii_rx) (pkt_rx_ren) |=> (!$isunknown(pkt_rx_data));
  endproperty
  assert property(af_p107);

  property af_p108;
  @(posedge clk_xgmii_rx) (pkt_rx_ren && pkt_rx_avail) |=> $changed(pkt_rx_data);
  endproperty
  assert property(af_p108);

  property af_p109;
  @(posedge clk_156m25) (pkt_rx_eop) |-> ( ((pkt_rx_mod == 3'd0) -> !$isunknown(pkt_rx_data[63:0])) && ((pkt_rx_mod == 3'd1) -> !$isunknown(pkt_rx_data[7:0])) && ((pkt_rx_mod == 3'd2) -> !$isunknown(pkt_rx_data[15:0])) && ((pkt_rx_mod == 3'd3) -> !$isunknown(pkt_rx_data[23:0])) && ((pkt_rx_mod == 3'd4) -> !$isunknown(pkt_rx_data[31:0])) && ((pkt_rx_mod == 3'd5) -> !$isunknown(pkt_rx_data[39:0])) && ((pkt_rx_mod == 3'd6) -> !$isunknown(pkt_rx_data[47:0])) && ((pkt_rx_mod == 3'd7) -> !$isunknown(pkt_rx_data[55:0])) );
  endproperty
  assert property(af_p109);

  property af_p110;
  @(posedge clk_156m25) (!pkt_rx_val) |-> $stable(pkt_rx_data);
  endproperty
  assert property(af_p110);

  property af_p111;
  @(posedge clk_xgmii_rx) (pkt_rx_val) |-> (!$isunknown(pkt_rx_data));
  endproperty
  assert property(af_p111);

  property af_p112;
  @(posedge clk_156m25) (pkt_rx_ren) |-> ##1 (!$isunknown(pkt_rx_data));
  endproperty
  assert property(af_p112);

  property af_p113;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> (pkt_rx_data == '0);
  endproperty
  assert property(af_p113);

  property af_p114;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> (pkt_rx_data == '0) ##1 (pkt_rx_data == '0);
  endproperty
  assert property(af_p114);

  property af_p115;
  @(posedge clk_xgmii_rx) (pkt_rx_eop && (pkt_rx_mod == 3'd7)) |-> (!$isunknown(pkt_rx_data[63:8]) && $isunknown(pkt_rx_data[7:0]));
  endproperty
  assert property(af_p115);

  property af_p116;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> (!$isunknown(pkt_rx_data));
  endproperty
  assert property(af_p116);

  property af_p117;
  @(posedge clk_156m25) (!pkt_rx_ren) |-> $stable(pkt_rx_data);
  endproperty
  assert property(af_p117);

  property af_p118;
  @(posedge clk_156m25) (!pkt_rx_avail) |-> $stable(pkt_rx_data);
  endproperty
  assert property(af_p118);

  property af_p119;
  @(posedge clk_xgmii_rx) (pkt_rx_eop && (pkt_rx_mod == 3'd4)) |-> (!$isunknown(pkt_rx_data[31:0]));
  endproperty
  assert property(af_p119);

  property af_p120;
  @(posedge clk_156m25) $fell(reset_156m25_n) |-> ##1 (pkt_rx_data == '0) ##1 (pkt_rx_data == '0);
  endproperty
  assert property(af_p120);

  property af_p121;
  @(posedge clk_xgmii_rx) ($rose(reset_xgmii_rx_n)) |-> (!pkt_rx_avail throughout (!$changed(pkt_rx_data))[*1:$] ##1 pkt_rx_avail);
  endproperty
  assert property(af_p121);

  property af_p122;
  @(posedge clk_xgmii_rx) (pkt_rx_sop) |-> (pkt_rx_data == pkt_rx_data);
  endproperty
  assert property(af_p122);

  property af_p123;
  @(posedge clk_156m25) (pkt_rx_sop) |-> (pkt_rx_data == pkt_rx_data);
  endproperty
  assert property(af_p123);

  property af_p124;
  @(posedge clk_xgmii_rx) (pkt_rx_err) |-> (pkt_rx_data !== 'x);
  endproperty
  assert property(af_p124);

  property af_p125;
  @(posedge clk_156m25) ($rose(reset_156m25_n)) |-> ##3 (pkt_rx_data >= 0 && pkt_rx_data <= 64'hFFFFFFFFFFFFFFFF);
  endproperty
  assert property(af_p125);

  property af_p126;
  @(posedge clk_156m25) (pkt_rx_ren) |-> (pkt_rx_data == pkt_rx_data) until (pkt_rx_val);
  endproperty
  assert property(af_p126);

  property af_p127;
  @(posedge clk_156m25) (!pkt_rx_avail && pkt_rx_ren) |-> (pkt_rx_data === 'x || pkt_rx_data === 64'h0);
  endproperty
  assert property(af_p127);

  property af_p128;
  @(posedge clk_xgmii_rx) (!pkt_rx_val) |=> ($stable(pkt_rx_data));
  endproperty
  assert property(af_p128);

  property af_p129;
  @(posedge clk_156m25) (pkt_rx_sop) |=> (pkt_rx_data !== 'x && pkt_rx_data != 64'h0);
  endproperty
  assert property(af_p129);

  property af_p130;
  @(posedge clk_156m25) (pkt_rx_sop) |=> ($stable(pkt_rx_data) && pkt_rx_data !== 'x);
  endproperty
  assert property(af_p130);

  property af_p131;
  @(posedge clk_156m25) (pkt_rx_err) |-> (pkt_rx_data !== 'x);
  endproperty
  assert property(af_p131);

  property af_p132;
  @(posedge clk_156m25) ($fell(reset_156m25_n)) |-> ##1 (pkt_rx_data == 64'h0);
  endproperty
  assert property(af_p132);

  property af_p133;
  @(posedge clk_156m25) (pkt_rx_eop && (pkt_rx_mod == 3'b000)) |-> (pkt_rx_data[63:0] !== 'x);
  endproperty
  assert property(af_p133);

  property af_p134;
  @(posedge clk_156m25) (pkt_rx_eop) |-> ($past(pkt_rx_avail) || pkt_rx_avail);
  endproperty
  assert property(af_p134);

  property af_p135;
  @(posedge clk_156m25) $fell(reset_156m25_n) |-> !pkt_rx_eop ##1 !pkt_rx_eop;
  endproperty
  assert property(af_p135);

  property af_p136;
  @(posedge clk_xgmii_rx) (pkt_rx_ren) |=> (pkt_rx_eop |-> pkt_rx_val);
  endproperty
  assert property(af_p136);

  property af_p137;
  @(posedge clk_xgmii_rx) (pkt_rx_eop) |-> (pkt_rx_val);
  endproperty
  assert property(af_p137);

  property af_p138;
  @(posedge clk_xgmii_rx) (pkt_rx_err) |-> (!pkt_rx_eop);
  endproperty
  assert property(af_p138);

  property af_p139;
  @(posedge clk_xgmii_rx) $fell(reset_xgmii_rx_n) |-> !pkt_rx_eop ##1 !pkt_rx_eop;
  endproperty
  assert property(af_p139);

  property af_p140;
  @(posedge clk_xgmii_rx) (pkt_rx_eop) |=> (!pkt_rx_eop);
  endproperty
  assert property(af_p140);

  property af_p141;
  @(posedge clk_156m25) (pkt_rx_eop) |-> ($isunknown(pkt_rx_mod) == 0);
  endproperty
  assert property(af_p141);

  property af_p142;
  @(posedge clk_156m25) (pkt_rx_eop) |=> (!pkt_rx_eop);
  endproperty
  assert property(af_p142);

  property af_p143;
  @(posedge clk_xgmii_rx) (pkt_rx_eop) |-> (pkt_rx_avail);
  endproperty
  assert property(af_p143);

  property af_p144;
  @(posedge clk_xgmii_rx) (pkt_rx_eop) |-> ($isunknown(pkt_rx_data) == 0);
  endproperty
  assert property(af_p144);

  property af_p145;
  @(posedge clk_156m25) (pkt_rx_eop) |-> (pkt_rx_val);
  endproperty
  assert property(af_p145);

  property af_p146;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> (!pkt_rx_eop);
  endproperty
  assert property(af_p146);

  property af_p147;
  @(posedge clk_156m25) (pkt_rx_err) |-> (!pkt_rx_eop);
  endproperty
  assert property(af_p147);

  property af_p148;
  @(posedge clk_xgmii_rx) ($rose(reset_xgmii_rx_n)) |-> (!pkt_rx_eop);
  endproperty
  assert property(af_p148);

  property af_p149;
  @(posedge clk_xgmii_rx) (!pkt_rx_avail) |-> (!pkt_rx_eop);
  endproperty
  assert property(af_p149);

  property af_p150;
  @(posedge clk_156m25) (pkt_rx_sop && pkt_rx_eop) |-> ($rose(pkt_rx_sop));
  endproperty
  assert property(af_p150);

  property af_p151;
  @(posedge clk_xgmii_rx) (pkt_rx_eop) |-> (!$isunknown(pkt_rx_mod));
  endproperty
  assert property(af_p151);

  property af_p152;
  @(posedge clk_xgmii_rx) (pkt_rx_eop) |=> (!pkt_rx_val);
  endproperty
  assert property(af_p152);

  property af_p153;
  @(posedge clk_xgmii_rx) ($rose(pkt_rx_ren)) |-> (!pkt_rx_eop);
  endproperty
  assert property(af_p153);

  property af_p154;
  @(posedge clk_xgmii_rx) ($rose(reset_xgmii_rx_n)) |-> ##3 (!$isunknown(pkt_rx_eop));
  endproperty
  assert property(af_p154);

  property af_p155;
  @(posedge clk_156m25) (pkt_rx_eop) |-> (!$isunknown(pkt_rx_data));
  endproperty
  assert property(af_p155);

  property af_p156;
  @(posedge clk_xgmii_rx) pkt_rx_eop |-> (pkt_rx_ren && pkt_rx_val) ##1 !pkt_rx_eop;
  endproperty
  assert property(af_p156);


  property af_p158;
  @(posedge clk_156m25) pkt_rx_eop |=> !pkt_rx_eop;
  endproperty
  assert property(af_p158);

  property af_p159;
  @(posedge clk_xgmii_rx) !pkt_rx_val |-> !pkt_rx_eop;
  endproperty
  assert property(af_p159);

  property af_p160;
  @(posedge clk_156m25) !reset_156m25_n |-> !pkt_rx_eop;
  endproperty
  assert property(af_p160);

  property af_p161;
  @(posedge clk_xgmii_rx) pkt_rx_eop |=> !pkt_rx_eop;
  endproperty
  assert property(af_p161);

  property af_p162;
  @(posedge clk_156m25) pkt_rx_sop |-> ##[1:16] pkt_rx_eop;
  endproperty
  assert property(af_p162);

  property af_p163;
  @(posedge clk_xgmii_rx) pkt_rx_eop |-> (pkt_rx_mod inside {[0:7]});
  endproperty
  assert property(af_p163);

  property af_p164;
  @(posedge clk_xgmii_rx) pkt_rx_eop |-> ##[1:$] pkt_rx_sop;
  endproperty
  assert property(af_p164);

  property af_p165;
  @(posedge clk_xgmii_rx) (pkt_rx_sop && pkt_rx_eop) |-> (pkt_rx_sop == pkt_rx_eop);
  endproperty
  assert property(af_p165);

  property af_p166;
  @(posedge clk_156m25) !pkt_rx_ren |-> !pkt_rx_eop;
  endproperty
  assert property(af_p166);

  property af_p167;
  @(posedge clk_xgmii_rx) (pkt_rx_err && pkt_rx_eop) |-> (pkt_rx_data !== 'x);
  endproperty
  assert property(af_p167);

  property af_p168;
  @(posedge clk_xgmii_rx) $rose(pkt_rx_err) |-> (pkt_rx_data !== 'x);
  endproperty
  assert property(af_p168);

  property af_p169;
  @(posedge clk_xgmii_rx) pkt_rx_err |-> (pkt_rx_eop) ##1 !pkt_rx_err;
  endproperty
  assert property(af_p169);

  property af_p170;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> (!pkt_rx_err)[*2];
  endproperty
  assert property(af_p170);

  property af_p171;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ##[1:2] (pkt_rx_err === 1'b0);
  endproperty
  assert property(af_p171);

  property af_p172;
  @(posedge clk_xgmii_rx) (pkt_rx_err) |-> (pkt_rx_val);
  endproperty
  assert property(af_p172);

  property af_p173;
  @(posedge clk_xgmii_rx) pkt_rx_err |-> pkt_rx_eop;
  endproperty
  assert property(af_p173);

  property af_p174;
  @(posedge clk_xgmii_rx) (pkt_rx_val) |-> $stable(pkt_rx_err);
  endproperty
  assert property(af_p174);

  property af_p175;
  @(posedge clk_xgmii_rx) pkt_rx_sop |-> (pkt_rx_err == $past(pkt_rx_err)) throughout (!pkt_rx_eop)[*0:$] ##1 pkt_rx_eop;
  endproperty
  assert property(af_p175);

  property af_p176;
  @(posedge clk_xgmii_rx) $rose(pkt_rx_err) |-> (pkt_rx_sop == 1'b1 || $past(pkt_rx_sop) throughout (!pkt_rx_eop)[*0:$]);
  endproperty
  assert property(af_p176);

  property af_p177;
  @(posedge clk_xgmii_rx) pkt_rx_err |-> pkt_rx_ren;
  endproperty
  assert property(af_p177);

  property af_p178;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> (pkt_rx_err == 1'b0)[*4];
  endproperty
  assert property(af_p178);

  property af_p179;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> (pkt_rx_err == 1'b0);
  endproperty
  assert property(af_p179);

  property af_p180;
  @(posedge clk_xgmii_rx) (pkt_rx_sop && pkt_rx_err) |-> (pkt_rx_err throughout (!pkt_rx_eop)[*0:$] ##1 pkt_rx_eop);
  endproperty
  assert property(af_p180);

  property af_p181;
  @(posedge clk_xgmii_rx) (pkt_rx_avail && !$isunknown(pkt_rx_err)) |-> (pkt_rx_err == 1'b0) throughout (pkt_rx_avail)[*1:$];
  endproperty
  assert property(af_p181);

  property af_p182;
  @(posedge clk_xgmii_rx) disable iff (!reset_xgmii_rx_n) $fell(reset_xgmii_rx_n) |=> (pkt_rx_err == 1'b0)[*1:$] ##0 pkt_rx_sop;
  endproperty
  assert property(af_p182);

  property af_p183;
  @(posedge reset_xgmii_rx_n or negedge reset_xgmii_rx_n) $fell(reset_xgmii_rx_n) |=> (pkt_rx_err == 1'b0);
  endproperty
  assert property(af_p183);

  property af_p184;
  @(posedge clk_xgmii_rx) pkt_rx_err |-> (pkt_rx_err throughout (!pkt_rx_eop)[*0:$] ##1 pkt_rx_eop);
  endproperty
  assert property(af_p184);

  property af_p185;
  @(posedge clk_xgmii_rx) (pkt_rx_sop && !pkt_rx_val) |-> (!pkt_rx_err);
  endproperty
  assert property(af_p185);

  property af_p186;
  @(posedge clk_xgmii_rx) (!pkt_rx_val) |-> (!pkt_rx_err);
  endproperty
  assert property(af_p186);

  property af_p187;
  @(posedge clk_xgmii_rx) $fell(reset_xgmii_rx_n) |=> (pkt_rx_err == 1'b0);
  endproperty
  assert property(af_p187);

  property af_p188;
  @(posedge clk_xgmii_rx) (!pkt_rx_sop) |-> ($stable(pkt_rx_err));
  endproperty
  assert property(af_p188);

  property af_p189;
  @(posedge clk_xgmii_rx) (pkt_rx_err && pkt_rx_eop) |-> (pkt_rx_avail == $past(pkt_rx_avail));
  endproperty
  assert property(af_p189);

  property af_p190;
  @(posedge clk_xgmii_rx) (pkt_rx_err) |=> (pkt_rx_sop |-> (pkt_rx_err == 1'b0));
  endproperty
  assert property(af_p190);

  property af_p191;
  @(posedge clk_xgmii_rx) (!pkt_rx_val) |-> (pkt_rx_err == 1'b0);
  endproperty
  assert property(af_p191);

  property af_p192;
  @(posedge clk_xgmii_rx) (pkt_rx_err) |-> (pkt_rx_eop);
  endproperty
  assert property(af_p192);

  property af_p193;
  @(posedge clk_156m25) (pkt_rx_mod >= 4 && pkt_rx_mod <= 7) |=> (pkt_rx_mod >= 0 && pkt_rx_mod <= 7);
  endproperty
  assert property(af_p193);

  property af_p194;
  @(posedge clk_156m25) (pkt_rx_eop && (pkt_rx_data[63:0] == pkt_rx_data[63:0])) |-> (pkt_rx_mod == 0);
  endproperty
  assert property(af_p194);

  property af_p195;
  @(posedge clk_156m25) ($rose(reset_156m25_n)) |-> (pkt_rx_mod >= 0 && pkt_rx_mod <= 7) [*3];
  endproperty
  assert property(af_p195);

  property af_p196;
  @(posedge clk_156m25) ($rose(reset_156m25_n)) |-> (pkt_rx_mod == 0);
  endproperty
  assert property(af_p196);

  property af_p197;
  @(posedge clk_156m25) ($rose(reset_156m25_n)) |-> ##4 (pkt_rx_mod >= 0 && pkt_rx_mod <= 7);
  endproperty
  assert property(af_p197);

  property af_p198;
  @(posedge clk_156m25) (pkt_rx_ren) |=> (pkt_rx_mod >= 0 && pkt_rx_mod <= 7);
  endproperty
  assert property(af_p198);

  property af_p199;
  @(posedge clk_156m25) (pkt_rx_eop && (pkt_rx_mod == 0)) |-> (pkt_rx_data[63:0] == pkt_rx_data[63:0]) ##1 (pkt_rx_mod >= 0 && pkt_rx_mod <= 7);
  endproperty
  assert property(af_p199);

  property af_p200;
  @(posedge clk_156m25) (pkt_rx_ren) |=> (pkt_rx_val |-> (pkt_rx_mod >= 0 && pkt_rx_mod <= 7));
  endproperty
  assert property(af_p200);

  property af_p201;
  @(posedge clk_156m25) (pkt_rx_val) |-> (pkt_rx_mod >= 0 && pkt_rx_mod <= 7);
  endproperty
  assert property(af_p201);

  property af_p202;
  @(posedge clk_156m25) (pkt_rx_mod <= 7);
  endproperty
  assert property(af_p202);

  property af_p203;
  @(posedge clk_156m25) (!pkt_rx_eop) |-> ($stable(pkt_rx_mod) && pkt_rx_mod >= 0 && pkt_rx_mod <= 7);
  endproperty
  assert property(af_p203);

  property af_p204;
  @(posedge clk_156m25) (pkt_rx_eop) |-> (pkt_rx_mod >= 0 && pkt_rx_mod <= 7) && $stable(pkt_rx_mod);
  endproperty
  assert property(af_p204);

  property af_p205;
  @(posedge clk_156m25) (pkt_rx_eop && (pkt_rx_mod >= 0 && pkt_rx_mod <= 3)) |=> (!pkt_rx_eop |-> (pkt_rx_mod >= 0 && pkt_rx_mod <= 7));
  endproperty
  assert property(af_p205);

  property af_p206;
  @(posedge clk_156m25) disable iff (!reset_156m25_n) (##4 1'b1) |-> (pkt_rx_mod >= 0 && pkt_rx_mod <= 7);
  endproperty
  assert property(af_p206);

  property af_p207;
  @(posedge clk_156m25) (!pkt_rx_eop) |-> $stable(pkt_rx_mod) && (pkt_rx_mod >= 0 && pkt_rx_mod <= 7);
  endproperty
  assert property(af_p207);

  property af_p208;
  @(posedge clk_156m25) (pkt_rx_val) |-> $stable(pkt_rx_mod) or ##0 (1'b1);
  endproperty
  assert property(af_p208);

  property af_p209;
  @(posedge clk_156m25) (pkt_rx_eop && pkt_rx_val) |-> (pkt_rx_mod >= 0 && pkt_rx_mod <= 7);
  endproperty
  assert property(af_p209);

  property af_p210;
  @(posedge clk_156m25) (pkt_rx_sop) |-> (pkt_rx_mod >= 0 && pkt_rx_mod <= 7);
  endproperty
  assert property(af_p210);

  property af_p211;
  @(posedge clk_156m25) (pkt_rx_val || pkt_rx_eop) |-> (pkt_rx_mod <= 7);
  endproperty
  assert property(af_p211);

  property af_p212;
  @(posedge clk_156m25) (pkt_rx_val && pkt_rx_eop) |-> (pkt_rx_mod >= 0 && pkt_rx_mod <= 7) throughout (!pkt_rx_eop[*0:$] ##1 pkt_rx_eop);
  endproperty
  assert property(af_p212);

  property af_p213;
  @(posedge clk_156m25) disable iff (!reset_156m25_n) (reset_156m25_n) |-> (pkt_rx_mod >= 0 && pkt_rx_mod <= 7);
  endproperty
  assert property(af_p213);

  property af_p214;
  @(posedge clk_156m25) (pkt_rx_val && pkt_rx_eop) |-> (pkt_rx_mod >= 0 && pkt_rx_mod <= 7);
  endproperty
  assert property(af_p214);

  property af_p215;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (pkt_rx_mod >= 0 && pkt_rx_mod <= 7);
  endproperty
  assert property(af_p215);

  property af_p216;
  @(posedge clk_156m25) (pkt_rx_eop && pkt_rx_err) |-> (pkt_rx_mod >= 0 && pkt_rx_mod <= 7);
  endproperty
  assert property(af_p216);

  property af_p217;
  @(posedge clk_156m25) (pkt_rx_mod >= 0 && pkt_rx_mod <= 7);
  endproperty
  assert property(af_p217);

  property af_p218;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (pkt_rx_mod == 3'b000);
  endproperty
  assert property(af_p218);

  property af_p219;
  @(posedge clk_156m25) (!pkt_rx_eop) |-> (1'b1);
  endproperty
  assert property(af_p219);


  property af_p221;
  @(posedge clk_156m25) (pkt_rx_eop) |-> (pkt_rx_mod >= 0 && pkt_rx_mod <= 7);
  endproperty
  assert property(af_p221);

  property af_p222;
  @(posedge clk_156m25) (pkt_rx_eop && pkt_rx_val) |-> ((pkt_rx_mod >= 0 && pkt_rx_mod <= 7) && $stable(pkt_rx_mod));
  endproperty
  assert property(af_p222);

  property af_p223;
  @(posedge clk_156m25) pkt_rx_ren |-> (reset_156m25_n && pkt_rx_avail);
  endproperty
  assert property(af_p223);

  property af_p224;
  @(posedge clk_xgmii_rx) $rose(pkt_rx_ren) |-> $past(pkt_rx_avail);
  endproperty
  assert property(af_p224);

  property af_p225;
  @(posedge clk_156m25) (pkt_rx_ren && !pkt_rx_avail) |=> !pkt_rx_val;
  endproperty
  assert property(af_p225);

  property af_p226;
  @(posedge clk_xgmii_rx) pkt_rx_eop |=> !pkt_rx_ren;
  endproperty
  assert property(af_p226);

  property af_p227;
  @(posedge clk_156m25) (pkt_rx_ren && pkt_rx_avail)[*3] |=> pkt_rx_val[*3];
  endproperty
  assert property(af_p227);

  property af_p228;
  @(posedge clk_xgmii_rx) pkt_rx_ren |-> pkt_rx_avail;
  endproperty
  assert property(af_p228);

  property af_p229;
  @(posedge clk_156m25) $fell(reset_156m25_n) |=> !pkt_rx_ren;
  endproperty
  assert property(af_p229);

  property af_p230;
  @(posedge clk_xgmii_rx) $fell(reset_xgmii_rx_n) |=> !pkt_rx_ren;
  endproperty
  assert property(af_p230);

  property af_p231;
  @(posedge clk_156m25) $fell(reset_156m25_n) |=> (!pkt_rx_ren)[*4];
  endproperty
  assert property(af_p231);

  property af_p232;
  @(posedge clk_156m25) (pkt_rx_avail && !pkt_rx_ren)[*3] |-> (!pkt_rx_ren);
  endproperty
  assert property(af_p232);

  property af_p233;
  @(posedge clk_xgmii_rx) (pkt_rx_ren) |=> (pkt_rx_val);
  endproperty
  assert property(af_p233);

  property af_p234;
  @(posedge clk_156m25) ($rose(pkt_rx_sop)) |-> (pkt_rx_avail);
  endproperty
  assert property(af_p234);

  property af_p235;
  @(posedge clk_xgmii_rx) ($rose(pkt_rx_ren)) |=> (pkt_rx_sop);
  endproperty
  assert property(af_p235);

  property af_p236;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> (pkt_rx_ren == 1'b0);
  endproperty
  assert property(af_p236);

  property af_p237;
  @(posedge clk_156m25) ($rose(pkt_rx_eop)) |=> (!pkt_rx_ren);
  endproperty
  assert property(af_p237);

  property af_p238;
  @(posedge clk_156m25) ($past(pkt_rx_ren) && $past(pkt_rx_avail)) |-> (pkt_rx_val);
  endproperty
  assert property(af_p238);

  property af_p239;
  @(posedge clk_156m25) (pkt_rx_ren && pkt_rx_avail) |=> (pkt_rx_val);
  endproperty
  assert property(af_p239);

  property af_p240;
  @(posedge clk_156m25) (pkt_rx_sop) |-> (pkt_rx_ren);
  endproperty
  assert property(af_p240);

  property af_p241;
  @(posedge clk_156m25) (pkt_rx_sop) |-> (pkt_rx_ren throughout (pkt_rx_eop[->1]));
  endproperty
  assert property(af_p241);

  property af_p242;
  @(posedge clk_156m25) $rose(reset_156m25_n) |=> !pkt_rx_ren;
  endproperty
  assert property(af_p242);

  property af_p243;
  @(posedge clk_xgmii_rx) pkt_rx_ren |=> (pkt_rx_val |-> !$isunknown(pkt_rx_data));
  endproperty
  assert property(af_p243);

  property af_p244;
  @(posedge clk_156m25) ((!pkt_rx_ren) && pkt_rx_avail)[*2] |-> !pkt_rx_val;
  endproperty
  assert property(af_p244);

  property af_p245;
  @(posedge clk_156m25) (pkt_rx_ren && pkt_rx_avail) |=> !$isunknown(pkt_rx_data);
  endproperty
  assert property(af_p245);

  property af_p246;
  @(posedge clk_xgmii_rx) $rose(pkt_rx_ren) |-> (pkt_rx_ren throughout (pkt_rx_ren[->1] ##0 (##[0:$] pkt_rx_eop)));
  endproperty
  assert property(af_p246);

  property af_p247;
  @(posedge clk_156m25) (pkt_rx_ren && pkt_rx_avail) |=> pkt_rx_val;
  endproperty
  assert property(af_p247);

  property af_p248;
  @(posedge clk_156m25) $rose(pkt_rx_ren) |-> (pkt_rx_ren throughout (##[0:$] pkt_rx_eop));
  endproperty
  assert property(af_p248);

  property af_p249;
  @(posedge clk_xgmii_rx) $rose(pkt_rx_ren) |-> (pkt_rx_ren throughout (##[0:$] pkt_rx_eop));
  endproperty
  assert property(af_p249);

  property af_p250;
  @(posedge clk_156m25) (pkt_rx_ren && pkt_rx_avail) |=> (pkt_rx_val && !$isunknown(pkt_rx_data));
  endproperty
  assert property(af_p250);

  property af_p251;
  @(posedge clk_156m25) !reset_156m25_n |-> !pkt_rx_ren;
  endproperty
  assert property(af_p251);

  property af_p252;
  @(posedge clk_156m25) (!pkt_rx_ren) |-> ($stable(pkt_rx_sop));
  endproperty
  assert property(af_p252);


  property af_p254;
  @(posedge clk_156m25) (pkt_rx_eop) |-> (##1 !pkt_rx_sop);
  endproperty
  assert property(af_p254);

  property af_p255;
  @(posedge clk_156m25) (pkt_rx_sop && pkt_rx_val) |-> (##1 !pkt_rx_sop);
  endproperty
  assert property(af_p255);

  property af_p256;
  @(posedge clk_156m25) (pkt_rx_sop) |-> (pkt_rx_val);
  endproperty
  assert property(af_p256);

  property af_p257;
  @(posedge clk_156m25) (pkt_rx_sop && pkt_rx_val) |-> ($isunknown(pkt_rx_data) === 1'b0);
  endproperty
  assert property(af_p257);

  property af_p258;
  @(posedge clk_156m25) (pkt_rx_sop) |-> (pkt_rx_ren);
  endproperty
  assert property(af_p258);


  property af_p260;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (!pkt_rx_sop);
  endproperty
  assert property(af_p260);

  property af_p261;
  @(posedge clk_156m25) (!pkt_rx_val) |-> (!pkt_rx_sop);
  endproperty
  assert property(af_p261);

  property af_p262;
  @(posedge clk_156m25) (pkt_rx_err) |-> (!pkt_rx_sop);
  endproperty
  assert property(af_p262);

  property af_p263;
  @(posedge clk_156m25) (pkt_rx_sop) |=> (!pkt_rx_sop) or (pkt_rx_sop);
  endproperty
  assert property(af_p263);

  property af_p264;
  @(posedge clk_156m25) (pkt_rx_sop) |-> (pkt_rx_avail);
  endproperty
  assert property(af_p264);

  property af_p265;
  @(posedge clk_156m25) ($rose(pkt_rx_val)) |-> (pkt_rx_sop && !$past(pkt_rx_sop));
  endproperty
  assert property(af_p265);

  property af_p266;
  @(posedge clk_156m25) (pkt_rx_sop && pkt_rx_eop) |-> (pkt_rx_sop == pkt_rx_eop);
  endproperty
  assert property(af_p266);

  property af_p267;
  @(posedge clk_156m25) (reset_156m25_n throughout ##3 pkt_rx_val) |-> (pkt_rx_sop);
  endproperty
  assert property(af_p267);

  property af_p268;
  @(posedge clk_156m25) (pkt_rx_sop) |-> (!pkt_rx_eop);
  endproperty
  assert property(af_p268);

  property af_p269;
  @(posedge clk_156m25) pkt_rx_sop |-> (pkt_rx_data !== 'bx);
  endproperty
  assert property(af_p269);

  property af_p270;
  @(posedge clk_156m25) $fell(reset_156m25_n) |-> !pkt_rx_sop;
  endproperty
  assert property(af_p270);

  property af_p271;
  @(posedge clk_156m25) pkt_rx_sop |=> (!pkt_rx_sop throughout (##[0:$] pkt_rx_eop)) |=> (##[0:$] pkt_rx_sop);
  endproperty
  assert property(af_p271);

  property af_p272;
  @(posedge clk_156m25) (pkt_rx_sop && pkt_rx_eop) |-> ($past(pkt_rx_val) == 0 || $past(pkt_rx_eop) == 0);
  endproperty
  assert property(af_p272);

  property af_p273;
  @(posedge clk_156m25) pkt_rx_sop |-> (pkt_rx_data !== 'bx) && (pkt_rx_val);
  endproperty
  assert property(af_p273);

  property af_p274;
  @(posedge clk_156m25) (reset_156m25_n && pkt_rx_val && !$past(pkt_rx_val)) |-> pkt_rx_sop;
  endproperty
  assert property(af_p274);

  property af_p275;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (!pkt_rx_sop) and (reset_156m25_n |-> ##1 (pkt_rx_sop || !pkt_rx_sop));
  endproperty
  assert property(af_p275);

  property af_p276;
  @(posedge clk_156m25) pkt_rx_sop |=> (!pkt_rx_sop until pkt_rx_eop);
  endproperty
  assert property(af_p276);

  property af_p277;
  @(posedge clk_156m25) (pkt_rx_eop) |-> (pkt_rx_val);
  endproperty
  assert property(af_p277);

  property af_p278;
  @(posedge clk_156m25) (pkt_rx_err) |=> ((!pkt_rx_val)[*2]);
  endproperty
  assert property(af_p278);

  property af_p279;
  @(posedge clk_156m25) (pkt_rx_sop && pkt_rx_val) |-> (pkt_rx_val until_with pkt_rx_eop);
  endproperty
  assert property(af_p279);

  property af_p280;
  @(posedge clk_156m25) (!reset_156m25_n) |=> (!pkt_rx_val);
  endproperty
  assert property(af_p280);

  property af_p281;
  @(posedge clk_156m25) (pkt_rx_sop) |-> (pkt_rx_val throughout (##[0:$] pkt_rx_eop));
  endproperty
  assert property(af_p281);

  property af_p282;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (!pkt_rx_val);
  endproperty
  assert property(af_p282);

  property af_p283;
  @(posedge clk_xgmii_rx) ($fell(reset_xgmii_rx_n)) |-> (##[1:2] !pkt_rx_val);
  endproperty
  assert property(af_p283);

  property af_p284;
  @(posedge clk_156m25) (pkt_rx_err) |-> (pkt_rx_val);
  endproperty
  assert property(af_p284);

  property af_p285;
  @(posedge clk_156m25) (pkt_rx_val) |-> (pkt_rx_ren);
  endproperty
  assert property(af_p285);

  property af_p286;
  @(posedge clk_156m25) ($rose(reset_156m25_n)) |-> ((!pkt_rx_val)[*2]);
  endproperty
  assert property(af_p286);

  property af_p287;
  @(posedge clk_156m25) ($fell(reset_156m25_n)) |-> (!pkt_rx_val)[*3];
  endproperty
  assert property(af_p287);

  property af_p288;
  @(posedge clk_156m25) (pkt_rx_val) |-> (!$isunknown(pkt_rx_err));
  endproperty
  assert property(af_p288);

  property af_p289;
  @(posedge clk_156m25) (!pkt_rx_ren) |=> !($rose(pkt_rx_val));
  endproperty
  assert property(af_p289);

  property af_p290;
  @(posedge clk_156m25) (!pkt_rx_avail) |=> (!pkt_rx_val);
  endproperty
  assert property(af_p290);

  property af_p291;
  @(posedge clk_156m25) (pkt_rx_val) |-> (!$isunknown(pkt_rx_data));
  endproperty
  assert property(af_p291);

  property af_p292;
  @(posedge clk_156m25) ($rose(pkt_rx_sop)) |-> (pkt_rx_val throughout (##[1:$] pkt_rx_eop));
  endproperty
  assert property(af_p292);

  property af_p293;
  @(posedge clk_156m25) (pkt_rx_sop) |-> (pkt_rx_val);
  endproperty
  assert property(af_p293);

  property af_p294;
  @(posedge clk_156m25) (pkt_rx_eop && !pkt_rx_avail) |=> (!pkt_rx_val);
  endproperty
  assert property(af_p294);

  property af_p295;
  @(posedge clk_156m25) ($rose(pkt_rx_eop)) |=> (!pkt_rx_val);
  endproperty
  assert property(af_p295);

  property af_p296;
  @(posedge clk_156m25) 1'b1 |-> ($stable(pkt_rx_val) || $changed(pkt_rx_val));
  endproperty
  assert property(af_p296);

  property af_p297;
  @(posedge clk_156m25) (pkt_rx_val) |-> (pkt_rx_avail);
  endproperty
  assert property(af_p297);

  property af_p298;
  @(posedge clk_156m25) (!reset_156m25_n) |=> (!pkt_rx_val) throughout (!reset_156m25_n)[*1:$];
  endproperty
  assert property(af_p298);

  property af_p299;
  @(posedge clk_156m25) (pkt_rx_ren && pkt_rx_avail) |-> ##1 (pkt_rx_ren && pkt_rx_avail) |-> (pkt_rx_val);
  endproperty
  assert property(af_p299);

  property af_p300;
  @(posedge clk_156m25) (pkt_rx_sop && pkt_rx_val) |-> (pkt_rx_val throughout (pkt_rx_sop[->1] ##0 pkt_rx_eop[->1]));
  endproperty
  assert property(af_p300);

  property af_p301;
  @(posedge clk_156m25) (pkt_rx_val && pkt_rx_eop) |-> $stable(pkt_rx_mod);
  endproperty
  assert property(af_p301);

  property af_p302;
  @(posedge clk_156m25) (pkt_rx_ren && pkt_rx_avail) |=> (pkt_rx_val);
  endproperty
  assert property(af_p302);

  property af_p303;
  @(posedge clk_156m25) (pkt_tx_sop && pkt_tx_eop) |-> ((pkt_tx_mod == 3'd0) -> (pkt_tx_data[63:0] !== 64'bx)) && ((pkt_tx_mod == 3'd1) -> (pkt_tx_data[7:0] !== 8'bx)) && ((pkt_tx_mod == 3'd2) -> (pkt_tx_data[15:0] !== 16'bx)) && ((pkt_tx_mod == 3'd3) -> (pkt_tx_data[23:0] !== 24'bx)) && ((pkt_tx_mod == 3'd4) -> (pkt_tx_data[31:0] !== 32'bx)) && ((pkt_tx_mod == 3'd5) -> (pkt_tx_data[39:0] !== 40'bx)) && ((pkt_tx_mod == 3'd6) -> (pkt_tx_data[47:0] !== 48'bx)) && ((pkt_tx_mod == 3'd7) -> (pkt_tx_data[55:0] !== 56'bx));
  endproperty
  assert property(af_p303);

  property af_p304;
  @(posedge clk_156m25) (pkt_tx_eop && (pkt_tx_mod == 3'b000)) |-> (pkt_tx_data[63:0] inside {[64'h0:64'hFFFFFFFFFFFFFFFF]});
  endproperty
  assert property(af_p304);

  property af_p305;
  @(posedge clk_156m25) (pkt_tx_val) |-> (pkt_tx_data >= 64'h0) && (pkt_tx_data <= 64'hFFFFFFFFFFFFFFFF);
  endproperty
  assert property(af_p305);

  property af_p306;
  @(posedge clk_156m25) (!pkt_tx_val) |-> $stable(pkt_tx_data);
  endproperty
  assert property(af_p306);

  property af_p307;
  @(posedge clk_156m25) (pkt_tx_sop && pkt_tx_eop) |-> (pkt_tx_data[7:0] !== 8'bx) && ((pkt_tx_mod == 3'd0) -> (pkt_tx_data[63:0] !== 64'bx)) && ((pkt_tx_mod == 3'd1) -> (pkt_tx_data[7:0] !== 8'bx)) && ((pkt_tx_mod == 3'd2) -> (pkt_tx_data[15:0] !== 16'bx)) && ((pkt_tx_mod == 3'd3) -> (pkt_tx_data[23:0] !== 24'bx)) && ((pkt_tx_mod == 3'd4) -> (pkt_tx_data[31:0] !== 32'bx)) && ((pkt_tx_mod == 3'd5) -> (pkt_tx_data[39:0] !== 40'bx)) && ((pkt_tx_mod == 3'd6) -> (pkt_tx_data[47:0] !== 48'bx)) && ((pkt_tx_mod == 3'd7) -> (pkt_tx_data[55:0] !== 56'bx));
  endproperty
  assert property(af_p307);

  property af_p308;
  @(posedge clk_156m25) (pkt_tx_full) |-> ##1 $stable(pkt_tx_data);
  endproperty
  assert property(af_p308);

  property af_p309;
  @(posedge clk_156m25) (pkt_tx_eop && (pkt_tx_mod == 3'd0)) |-> (pkt_tx_data[63:0] !== 64'bx);
  endproperty
  assert property(af_p309);

  property af_p310;
  @(posedge clk_156m25) (pkt_tx_val && !pkt_tx_full) |-> !$stable(pkt_tx_data) || $changed(pkt_tx_data);
  endproperty
  assert property(af_p310);

  property af_p311;
  @(posedge clk_156m25) ($rose(reset_156m25_n)) |-> ##1 (pkt_tx_data >= 64'h0) && (pkt_tx_data <= 64'hFFFFFFFFFFFFFFFF);
  endproperty
  assert property(af_p311);

  property af_p312;
  @(posedge clk_156m25) (pkt_tx_sop) |-> (pkt_tx_data[7:0] !== 8'bx);
  endproperty
  assert property(af_p312);

  property af_p313;
  @(posedge clk_156m25) $fell(reset_156m25_n) |-> ##1 $stable(pkt_tx_data);
  endproperty
  assert property(af_p313);

  property af_p314;
  @(posedge clk_156m25) pkt_tx_sop |-> (!$isunknown(pkt_tx_data)) throughout (pkt_tx_eop[->1]);
  endproperty
  assert property(af_p314);

  property af_p315;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (pkt_tx_data == 64'h0);
  endproperty
  assert property(af_p315);

  property af_p316;
  @(posedge clk_156m25) (!pkt_tx_val) |-> (1'b1);
  endproperty
  assert property(af_p316);

  property af_p317;
  @(posedge clk_156m25) (pkt_tx_sop && pkt_tx_val) |-> !$isunknown(pkt_tx_data);
  endproperty
  assert property(af_p317);

  property af_p318;
  @(posedge clk_156m25) pkt_tx_eop |-> ( (pkt_tx_mod == 3'd0 && !$isunknown(pkt_tx_data[63:0])) || (pkt_tx_mod == 3'd1 && !$isunknown(pkt_tx_data[7:0])) || (pkt_tx_mod == 3'd2 && !$isunknown(pkt_tx_data[15:0])) || (pkt_tx_mod == 3'd3 && !$isunknown(pkt_tx_data[23:0])) || (pkt_tx_mod == 3'd4 && !$isunknown(pkt_tx_data[31:0])) || (pkt_tx_mod == 3'd5 && !$isunknown(pkt_tx_data[39:0])) || (pkt_tx_mod == 3'd6 && !$isunknown(pkt_tx_data[47:0])) || (pkt_tx_mod == 3'd7 && !$isunknown(pkt_tx_data[55:0])) );
  endproperty
  assert property(af_p318);

  property af_p319;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> ##3 (pkt_tx_data inside {[64'h0000000000000000:64'hFFFFFFFFFFFFFFFF]});
  endproperty
  assert property(af_p319);

  property af_p320;
  @(posedge clk_156m25) (pkt_tx_sop) |-> !$isunknown(pkt_tx_data[7:0]);
  endproperty
  assert property(af_p320);

  property af_p321;
  @(posedge clk_156m25) (pkt_tx_val && $past(pkt_tx_val)) |-> $stable(pkt_tx_data);
  endproperty
  assert property(af_p321);

  property af_p322;
  @(posedge clk_156m25) (pkt_tx_val && $past(pkt_tx_val)) |-> !$stable(pkt_tx_data);
  endproperty
  assert property(af_p322);

  property af_p323;
  @(posedge clk_156m25) (pkt_tx_full) |-> $stable(pkt_tx_data);
  endproperty
  assert property(af_p323);

  property af_p324;
  @(posedge clk_156m25) (pkt_tx_val) |-> !$isunknown(pkt_tx_data);
  endproperty
  assert property(af_p324);

  property af_p325;
  @(posedge clk_156m25) (pkt_tx_eop && pkt_tx_mod == 3'b001) |-> !$isunknown(pkt_tx_data[7:0]);
  endproperty
  assert property(af_p325);

  property af_p326;
  @(posedge clk_156m25) pkt_tx_eop |-> (((pkt_tx_mod == 3'd0) -> !$isunknown(pkt_tx_data[63:0])) && ((pkt_tx_mod == 3'd1) -> !$isunknown(pkt_tx_data[7:0])) && ((pkt_tx_mod == 3'd2) -> !$isunknown(pkt_tx_data[15:0])) && ((pkt_tx_mod == 3'd3) -> !$isunknown(pkt_tx_data[23:0])) && ((pkt_tx_mod == 3'd4) -> !$isunknown(pkt_tx_data[31:0])) && ((pkt_tx_mod == 3'd5) -> !$isunknown(pkt_tx_data[39:0])) && ((pkt_tx_mod == 3'd6) -> !$isunknown(pkt_tx_data[47:0])) && ((pkt_tx_mod == 3'd7) -> !$isunknown(pkt_tx_data[55:0])));
  endproperty
  assert property(af_p326);

  property af_p327;
  @(posedge clk_156m25) (pkt_tx_eop && pkt_tx_mod == 3'd1) |-> !$isunknown(pkt_tx_data[7:0]);
  endproperty
  assert property(af_p327);

  property af_p328;
  @(posedge clk_156m25) (!pkt_tx_val && !pkt_tx_sop && !pkt_tx_eop) |-> $stable(pkt_tx_data);
  endproperty
  assert property(af_p328);

  property af_p329;
  @(posedge clk_156m25) (reset_156m25_n) |-> ##3 ((pkt_tx_data >= 0) && (pkt_tx_data <= 64'hFFFFFFFF_FFFFFFFF));
  endproperty
  assert property(af_p329);

  property af_p330;
  @(posedge clk_156m25) (pkt_tx_full) |=> $stable(pkt_tx_data);
  endproperty
  assert property(af_p330);

  property af_p331;
  @(posedge clk_xgmii_tx) pkt_tx_eop |-> pkt_tx_val;
  endproperty
  assert property(af_p331);

  property af_p332;
  @(posedge clk_156m25) pkt_tx_sop |=> (!pkt_tx_eop)[*0:$] ##1 pkt_tx_eop;
  endproperty
  assert property(af_p332);

  property af_p333;
  @(posedge clk_156m25) pkt_tx_eop ##1 (!pkt_tx_val)[*0:$] ##1 pkt_tx_val |-> pkt_tx_sop;
  endproperty
  assert property(af_p333);

  property af_p334;
  @(posedge clk_xgmii_tx) pkt_tx_val |-> !$isunknown(pkt_tx_eop);
  endproperty
  assert property(af_p334);

  property af_p335;
  @(posedge clk_xgmii_tx) (pkt_tx_sop && pkt_tx_eop) |-> pkt_tx_mod inside {[1:7]};
  endproperty
  assert property(af_p335);

  property af_p336;
  @(posedge clk_xgmii_tx) pkt_tx_eop |-> !$isunknown(pkt_tx_data);
  endproperty
  assert property(af_p336);

  property af_p337;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> !pkt_tx_eop;
  endproperty
  assert property(af_p337);

  property af_p338;
  @(posedge clk_156m25) pkt_tx_eop |=> !pkt_tx_eop;
  endproperty
  assert property(af_p338);

  property af_p339;
  @(posedge clk_156m25) !reset_156m25_n |-> !pkt_tx_eop;
  endproperty
  assert property(af_p339);

  property af_p340;
  @(posedge clk_156m25) pkt_tx_full |-> !pkt_tx_eop;
  endproperty
  assert property(af_p340);

  property af_p341;
  @(posedge clk_156m25) (pkt_tx_sop && pkt_tx_eop) |-> (pkt_tx_mod >= 0 && pkt_tx_mod <= 7);
  endproperty
  assert property(af_p341);

  property af_p342;
  @(posedge clk_156m25) (pkt_tx_eop) |-> (pkt_tx_mod >= 0 && pkt_tx_mod <= 7);
  endproperty
  assert property(af_p342);

  property af_p343;
  @(posedge clk_xgmii_tx) (pkt_tx_eop) |-> ##1 (!pkt_tx_eop || pkt_tx_sop);
  endproperty
  assert property(af_p343);

  property af_p344;
  @(posedge clk_156m25) (pkt_tx_eop) |-> ##1 (!pkt_tx_eop);
  endproperty
  assert property(af_p344);

  property af_p345;
  @(posedge clk_156m25) ($rose(reset_156m25_n)) |-> ((!pkt_tx_eop) until (pkt_tx_val));
  endproperty
  assert property(af_p345);

  property af_p346;
  @(posedge clk_156m25) (pkt_tx_eop) |-> (pkt_tx_val);
  endproperty
  assert property(af_p346);

  property af_p347;
  @(posedge clk_156m25) (pkt_tx_full) |-> (!pkt_tx_eop);
  endproperty
  assert property(af_p347);

  property af_p348;
  @(posedge clk_xgmii_tx) (pkt_tx_sop) |-> (pkt_tx_val throughout (##[1:16] pkt_tx_eop));
  endproperty
  assert property(af_p348);

  property af_p349;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |-> (!pkt_tx_eop);
  endproperty
  assert property(af_p349);

  property af_p350;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##3 (pkt_tx_eop === 1'b0 || pkt_tx_eop === 1'b1);
  endproperty
  assert property(af_p350);

  property af_p351;
  @(posedge clk_xgmii_tx) (pkt_tx_full) |-> !(pkt_tx_eop);
  endproperty
  assert property(af_p351);

  property af_p352;
  @(posedge clk_156m25) (pkt_tx_eop) |=> (pkt_tx_sop || !pkt_tx_sop);
  endproperty
  assert property(af_p352);

  property af_p353;
  @(posedge clk_156m25) (pkt_tx_sop && pkt_tx_eop) |-> (pkt_tx_sop && pkt_tx_eop);
  endproperty
  assert property(af_p353);

  property af_p354;
  @(posedge clk_156m25) (pkt_tx_eop) |-> !$isunknown(pkt_tx_data);
  endproperty
  assert property(af_p354);

  property af_p355;
  @(posedge clk_156m25) (!pkt_tx_val) |-> !(pkt_tx_eop);
  endproperty
  assert property(af_p355);

  property af_p356;
  @(posedge clk_156m25) (pkt_tx_eop) |-> $stable(pkt_tx_mod);
  endproperty
  assert property(af_p356);

  property af_p357;
  @(posedge clk_xgmii_tx) (pkt_tx_eop) |-> (pkt_tx_mod >= 3'd0 && pkt_tx_mod <= 3'd7);
  endproperty
  assert property(af_p357);

  property af_p358;
  @(posedge clk_156m25) $rose(pkt_tx_full) |-> pkt_tx_full[*2];
  endproperty
  assert property(af_p358);

  property af_p359;
  @(posedge clk_xgmii_tx) ($past(pkt_tx_full) && pkt_tx_full) |-> $stable(pkt_tx_mod);
  endproperty
  assert property(af_p359);

  property af_p360;
  @(posedge clk_xgmii_tx) $rose(pkt_tx_full) |-> ##[1:16] !pkt_tx_full;
  endproperty
  assert property(af_p360);

  property af_p361;
  @(posedge clk_xgmii_tx) ($rose(pkt_tx_full) && pkt_tx_val && !pkt_tx_eop) |-> (pkt_tx_val until pkt_tx_eop);
  endproperty
  assert property(af_p361);

  property af_p362;
  @(posedge clk_156m25) (pkt_tx_full && pkt_tx_val && !pkt_tx_eop) |=> pkt_tx_val;
  endproperty
  assert property(af_p362);

  property af_p363;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> !pkt_tx_full;
  endproperty
  assert property(af_p363);

  property af_p364;
  @(posedge clk_xgmii_tx) pkt_tx_full |=> !pkt_tx_sop;
  endproperty
  assert property(af_p364);

  property af_p365;
  @(posedge clk_xgmii_tx) (pkt_tx_full && pkt_tx_eop) |=> (!pkt_tx_sop until_with !pkt_tx_full);
  endproperty
  assert property(af_p365);

  property af_p366;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> !pkt_tx_full[*4];
  endproperty
  assert property(af_p366);

  property af_p367;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> !pkt_tx_full[*8];
  endproperty
  assert property(af_p367);

  property af_p368;
  @(posedge clk_xgmii_tx) $fell(pkt_tx_full) |-> ##[1:4] pkt_tx_val;
  endproperty
  assert property(af_p368);

  property af_p369;
  @(posedge clk_156m25) (!pkt_tx_full && pkt_tx_val) |-> ##1 pkt_tx_val;
  endproperty
  assert property(af_p369);

  property af_p370;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> (!pkt_tx_full until pkt_tx_val);
  endproperty
  assert property(af_p370);

  property af_p371;
  @(posedge clk_xgmii_tx) $fell(pkt_tx_full) |-> ##[1:4] (!$isunknown(pkt_tx_data));
  endproperty
  assert property(af_p371);

  property af_p372;
  @(posedge clk_xgmii_tx) (pkt_tx_full) |-> !$fell(pkt_tx_eop);
  endproperty
  assert property(af_p372);



  property af_p375;
  @(posedge clk_156m25) (pkt_tx_full && pkt_tx_eop) |-> ##1 !pkt_tx_val;
  endproperty
  assert property(af_p375);

  property af_p376;
  @(posedge clk_156m25) (pkt_tx_full) |-> !pkt_tx_sop;
  endproperty
  assert property(af_p376);

  property af_p377;
  @(posedge clk_156m25) $fell(pkt_tx_full) |-> ##[1:$] pkt_tx_sop;
  endproperty
  assert property(af_p377);

  property af_p378;
  @(posedge clk_xgmii_tx) (pkt_tx_full && pkt_tx_eop) |-> ##1 !pkt_tx_val;
  endproperty
  assert property(af_p378);

  property af_p379;
  @(posedge clk_xgmii_tx) (pkt_tx_full && pkt_tx_val) |-> (pkt_tx_val throughout (##[0:$] pkt_tx_eop));
  endproperty
  assert property(af_p379);

  property af_p380;
  @(posedge clk_156m25) (pkt_tx_sop && pkt_tx_val) |-> ($stable(pkt_tx_full) throughout (pkt_tx_val[->1:$] ##0 pkt_tx_eop));
  endproperty
  assert property(af_p380);

  property af_p381;
  @(posedge clk_xgmii_tx) !reset_xgmii_tx_n |-> !pkt_tx_full;
  endproperty
  assert property(af_p381);

  property af_p382;
  @(posedge clk_xgmii_tx) (pkt_tx_full && !pkt_tx_val) |-> ##1 !pkt_tx_val;
  endproperty
  assert property(af_p382);

  property af_p383;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> !pkt_tx_full;
  endproperty
  assert property(af_p383);

  property af_p384;
  @(posedge clk_xgmii_tx) (pkt_tx_full === 1'b0) || (pkt_tx_full === 1'b1);
  endproperty
  assert property(af_p384);

  property af_p385;
  @(posedge clk_xgmii_tx) pkt_tx_sop |-> ($stable(pkt_tx_full) throughout (##[0:$] pkt_tx_eop));
  endproperty
  assert property(af_p385);

  property af_p386;
  @(posedge clk_156m25) $fell(pkt_tx_full) |-> ##1 (pkt_tx_data !== 'x);
  endproperty
  assert property(af_p386);

  property af_p387;
  @(posedge clk_156m25) (!pkt_tx_eop) |=> (pkt_tx_mod == $past(pkt_tx_mod));
  endproperty
  assert property(af_p387);

  property af_p388;
  @(posedge clk_156m25) (pkt_tx_eop) |-> (pkt_tx_mod >= 0 && pkt_tx_mod <= 7);
  endproperty
  assert property(af_p388);

  property af_p389;
  @(posedge clk_xgmii_tx) ($rose(reset_xgmii_tx_n)) |-> ##3 (pkt_tx_mod >= 0 && pkt_tx_mod <= 7);
  endproperty
  assert property(af_p389);

  property af_p390;
  @(posedge clk_xgmii_tx) (1'b1) |-> (pkt_tx_mod <= 7);
  endproperty
  assert property(af_p390);

  property af_p391;
  @(posedge clk_156m25) ($rose(reset_156m25_n)) |-> ##3 (pkt_tx_mod >= 0 && pkt_tx_mod <= 7);
  endproperty
  assert property(af_p391);

  property af_p392;
  @(posedge clk_156m25) ($rose(reset_156m25_n)) |-> ##4 (pkt_tx_mod >= 0 && pkt_tx_mod <= 7);
  endproperty
  assert property(af_p392);

  property af_p393;
  @(posedge clk_xgmii_tx) ($rose(reset_xgmii_tx_n)) |-> ##4 (pkt_tx_mod >= 0 && pkt_tx_mod <= 7);
  endproperty
  assert property(af_p393);

  property af_p394;
  @(posedge clk_xgmii_tx) (pkt_tx_eop && pkt_tx_val && (pkt_tx_mod == 0)) |-> ##1 (pkt_tx_mod >= 0 && pkt_tx_mod <= 7);
  endproperty
  assert property(af_p394);

  property af_p395;
  @(posedge clk_xgmii_tx) (pkt_tx_eop) |-> ((pkt_tx_mod >= 0) && (pkt_tx_mod <= 7) && $stable(pkt_tx_mod));
  endproperty
  assert property(af_p395);

  property af_p396;
  @(posedge clk_xgmii_tx) (pkt_tx_eop) |-> (pkt_tx_mod >= 0 && pkt_tx_mod <= 7);
  endproperty
  assert property(af_p396);

  property af_p397;
  @(posedge clk_xgmii_tx) (pkt_tx_sop && pkt_tx_val) |-> s_eventually (pkt_tx_eop && (pkt_tx_mod >= 0 && pkt_tx_mod <= 7));
  endproperty
  assert property(af_p397);

  property af_p398;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (pkt_tx_mod >= 0 && pkt_tx_mod <= 7);
  endproperty
  assert property(af_p398);

  property af_p399;
  @(posedge clk_xgmii_tx) (pkt_tx_val && pkt_tx_eop) |-> (pkt_tx_mod >= 0 && pkt_tx_mod <= 7);
  endproperty
  assert property(af_p399);


  property af_p401;
  @(posedge clk_xgmii_tx) (!pkt_tx_full && pkt_tx_val && pkt_tx_eop) |-> (pkt_tx_mod >= 0 && pkt_tx_mod <= 7);
  endproperty
  assert property(af_p401);

  property af_p402;
  @(posedge clk_xgmii_tx) (pkt_tx_eop && pkt_tx_val) |-> (pkt_tx_mod >= 0 && pkt_tx_mod <= 7);
  endproperty
  assert property(af_p402);

  property af_p403;
  @(posedge clk_156m25) ((pkt_tx_mod >= 1 && pkt_tx_mod <= 7) && pkt_tx_eop) |-> (pkt_tx_val);
  endproperty
  assert property(af_p403);

  property af_p404;
  @(posedge clk_156m25) (pkt_tx_mod == 0) |-> (pkt_tx_eop);
  endproperty
  assert property(af_p404);

  property af_p405;
  @(posedge clk_xgmii_tx) ((pkt_tx_mod >= 1 && pkt_tx_mod <= 7) && pkt_tx_eop) |-> ##[0:1] (!pkt_tx_full);
  endproperty
  assert property(af_p405);

  property af_p406;
  @(posedge clk_xgmii_tx) (reset_xgmii_tx_n) |-> (pkt_tx_mod >= 0 && pkt_tx_mod <= 7);
  endproperty
  assert property(af_p406);

  property af_p407;
  @(posedge clk_xgmii_tx) (pkt_tx_eop && (pkt_tx_mod inside {[0:3]})) |=> (reset_xgmii_tx_n && (pkt_tx_mod inside {[0:7]}));
  endproperty
  assert property(af_p407);

  property af_p408;
  @(posedge clk_xgmii_tx) (pkt_tx_eop && pkt_tx_val && (pkt_tx_mod inside {[4:7]})) |=> (!pkt_tx_eop |-> (pkt_tx_mod inside {[0:7]}));
  endproperty
  assert property(af_p408);

  property af_p409;
  @(posedge clk_xgmii_tx) (pkt_tx_eop && pkt_tx_val && (pkt_tx_mod == 3'b000)) |-> (!$isunknown(pkt_tx_data));
  endproperty
  assert property(af_p409);

  property af_p410;
  @(posedge clk_xgmii_tx) (pkt_tx_eop && (pkt_tx_mod inside {[4:7]})) |=> (pkt_tx_sop);
  endproperty
  assert property(af_p410);

  property af_p411;
  @(posedge clk_156m25) (pkt_tx_val) |-> (pkt_tx_mod <= 7);
  endproperty
  assert property(af_p411);

  property af_p412;
  @(posedge clk_xgmii_tx) (!pkt_tx_eop) |-> (1'b1);
  endproperty
  assert property(af_p412);

  property af_p413;
  @(posedge clk_156m25) (pkt_tx_eop) |-> ((pkt_tx_mod >= 0) && (pkt_tx_mod <= 7));
  endproperty
  assert property(af_p413);

  property af_p414;
  @(posedge clk_xgmii_tx) (pkt_tx_val && pkt_tx_eop) |-> ((pkt_tx_mod >= 0) && (pkt_tx_mod <= 7));
  endproperty
  assert property(af_p414);

  property af_p415;
  @(posedge clk_156m25) (!pkt_tx_full) |-> ($stable(pkt_tx_mod) && (pkt_tx_mod inside {[0:7]}));
  endproperty
  assert property(af_p415);

  property af_p416;
  @(posedge clk_xgmii_tx) (pkt_tx_eop) |-> ((pkt_tx_mod >= 0) && (pkt_tx_mod <= 7));
  endproperty
  assert property(af_p416);

  property af_p417;
  @(posedge clk_156m25) disable iff (!reset_156m25_n) ($rose(pkt_tx_val)) |-> (pkt_tx_sop);
  endproperty
  assert property(af_p417);

  property af_p418;
  @(posedge clk_156m25) disable iff (!reset_156m25_n) ($rose(pkt_tx_sop)) |=> (!pkt_tx_sop) until_with (pkt_tx_eop);
  endproperty
  assert property(af_p418);

  property af_p419;
  @(posedge clk_156m25) disable iff (!reset_156m25_n) (pkt_tx_sop) |-> (pkt_tx_val);
  endproperty
  assert property(af_p419);

  property af_p420;
  @(posedge clk_156m25) disable iff (!reset_156m25_n) (pkt_tx_full) |-> (!pkt_tx_sop);
  endproperty
  assert property(af_p420);

  property af_p421;
  @(posedge clk_156m25) disable iff (!reset_156m25_n) (!pkt_tx_val) |-> (!pkt_tx_sop);
  endproperty
  assert property(af_p421);

  property af_p422;
  @(posedge clk_156m25) ($rose(reset_156m25_n)) |-> (!pkt_tx_sop)[*3];
  endproperty
  assert property(af_p422);

  property af_p423;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (!pkt_tx_sop);
  endproperty
  assert property(af_p423);

  property af_p424;
  @(posedge clk_156m25) disable iff (!reset_156m25_n) (pkt_tx_sop) |=> (!pkt_tx_sop);
  endproperty
  assert property(af_p424);

  property af_p425;
  @(posedge clk_156m25) disable iff (!reset_156m25_n) (pkt_tx_sop && pkt_tx_val) |=> (pkt_tx_val |-> !pkt_tx_sop);
  endproperty
  assert property(af_p425);

  property af_p426;
  @(posedge clk_156m25) disable iff (!reset_156m25_n) ($past(pkt_tx_eop)) |-> ($stable(pkt_tx_sop) || (pkt_tx_sop == pkt_tx_val));
  endproperty
  assert property(af_p426);

  property af_p427;
  @(posedge clk_156m25) (pkt_tx_sop && pkt_tx_eop) |-> (pkt_tx_val);
  endproperty
  assert property(af_p427);

  property af_p428;
  @(posedge clk_156m25) (pkt_tx_sop) |-> (pkt_tx_val);
  endproperty
  assert property(af_p428);


  property af_p430;
  @(posedge clk_156m25) (!pkt_tx_val) |-> (!pkt_tx_sop);
  endproperty
  assert property(af_p430);

  property af_p431;
  @(posedge clk_156m25) (pkt_tx_sop && pkt_tx_val) |=> (!pkt_tx_sop) until_with (pkt_tx_eop);
  endproperty
  assert property(af_p431);

  property af_p432;
  @(posedge clk_156m25) ($rose(reset_156m25_n)) |=> (!pkt_tx_sop) until_with (pkt_tx_val && pkt_tx_sop);
  endproperty
  assert property(af_p432);

  property af_p433;
  @(posedge clk_156m25) (pkt_tx_full) |-> (!pkt_tx_sop);
  endproperty
  assert property(af_p433);

  property af_p434;
  @(posedge clk_156m25) (pkt_tx_val && pkt_tx_eop) |=> (pkt_tx_val |-> pkt_tx_sop);
  endproperty
  assert property(af_p434);

  property af_p435;
  @(posedge clk_156m25) pkt_tx_sop |=> !pkt_tx_sop;
  endproperty
  assert property(af_p435);

  property af_p436;
  @(posedge clk_156m25) pkt_tx_full |-> !pkt_tx_val;
  endproperty
  assert property(af_p436);

  property af_p437;
  @(posedge clk_156m25) (pkt_tx_val && pkt_tx_sop && pkt_tx_eop) |-> (pkt_tx_mod inside {3'd0,3'd1,3'd2,3'd3,3'd4});
  endproperty
  assert property(af_p437);

  property af_p438;
  @(posedge clk_156m25) pkt_tx_sop |-> !$isunknown(pkt_tx_data[7:0]);
  endproperty
  assert property(af_p438);

  property af_p439;
  @(posedge clk_156m25) pkt_tx_sop |-> pkt_tx_val;
  endproperty
  assert property(af_p439);

  property af_p440;
  @(posedge clk_156m25) (pkt_tx_sop && pkt_tx_eop) |-> pkt_tx_val;
  endproperty
  assert property(af_p440);

  property af_p441;
  @(posedge clk_xgmii_tx) (pkt_tx_val && pkt_tx_eop) |=> (!pkt_tx_val ##1 pkt_tx_sop);
  endproperty
  assert property(af_p441);

  property af_p442;
  @(posedge clk_156m25) (pkt_tx_val && pkt_tx_eop) |-> (pkt_tx_val && pkt_tx_eop);
  endproperty
  assert property(af_p442);

  property af_p443;
  @(posedge clk_xgmii_tx) (pkt_tx_full) |-> (!pkt_tx_val);
  endproperty
  assert property(af_p443);

  property af_p444;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (!pkt_tx_val);
  endproperty
  assert property(af_p444);

  property af_p445;
  @(posedge clk_156m25) (pkt_tx_val && pkt_tx_eop) |-> (pkt_tx_eop);
  endproperty
  assert property(af_p445);

  property af_p446;
  @(posedge clk_156m25) (pkt_tx_val && $past(pkt_tx_val)) |-> (pkt_tx_data !== $past(pkt_tx_data));
  endproperty
  assert property(af_p446);

  property af_p447;
  @(posedge clk_156m25) (pkt_tx_val) |-> (pkt_tx_val until pkt_tx_eop);
  endproperty
  assert property(af_p447);

  property af_p448;
  @(posedge clk_xgmii_tx) (reset_xgmii_tx_n) |-> (!$isunknown(pkt_tx_val));
  endproperty
  assert property(af_p448);

  property af_p449;
  @(posedge clk_xgmii_tx) ($rose(reset_xgmii_tx_n)) |-> (!pkt_tx_val)[*2];
  endproperty
  assert property(af_p449);

  property af_p450;
  @(posedge clk_156m25) (pkt_tx_val) |-> (!$isunknown(pkt_tx_data));
  endproperty
  assert property(af_p450);

  property af_p451;
  @(posedge clk_xgmii_tx) (pkt_tx_val) |-> (pkt_tx_data !== 'x) throughout (pkt_tx_val[->1] ##0 !pkt_tx_eop[*0:$] ##1 pkt_tx_eop);
  endproperty
  assert property(af_p451);

  property af_p452;
  @(posedge clk_xgmii_tx) (pkt_tx_sop) |-> (pkt_tx_val throughout (pkt_tx_sop[->1] ##0 !pkt_tx_eop[*0:$] ##1 pkt_tx_eop));
  endproperty
  assert property(af_p452);

  property af_p453;
  @(posedge clk_156m25) (pkt_tx_full) |-> (!pkt_tx_val);
  endproperty
  assert property(af_p453);

  property af_p454;
  @(posedge clk_156m25) (!pkt_tx_full) |=> ($past(!pkt_tx_full) |-> (pkt_tx_val || !pkt_tx_val));
  endproperty
  assert property(af_p454);

  property af_p455;
  @(posedge clk_156m25) ($rose(reset_156m25_n)) |-> (!pkt_tx_val) [*2];
  endproperty
  assert property(af_p455);

  property af_p456;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (pkt_tx_val == 1'b0);
  endproperty
  assert property(af_p456);

  property af_p457;
  @(posedge clk_156m25) (pkt_tx_val) |-> (pkt_tx_data !== 'x);
  endproperty
  assert property(af_p457);

  property af_p458;
  @(posedge clk_xgmii_tx) (pkt_tx_sop) |-> (pkt_tx_val);
  endproperty
  assert property(af_p458);

  property af_p459;
  @(posedge clk_156m25) (pkt_tx_val && pkt_tx_eop) |-> (pkt_tx_mod !== 'x);
  endproperty
  assert property(af_p459);

  property af_p460;
  @(posedge clk_156m25) (pkt_tx_val) |-> ($stable(pkt_tx_data));
  endproperty
  assert property(af_p460);

  property af_p461;
  @(posedge clk_156m25) (pkt_tx_val && pkt_tx_sop) |-> pkt_tx_sop;
  endproperty
  assert property(af_p461);

  property af_p462;
  @(posedge clk_xgmii_tx) pkt_tx_eop |-> pkt_tx_val;
  endproperty
  assert property(af_p462);

  property af_p463;
  @(posedge clk_156m25) pkt_tx_full |-> !pkt_tx_val;
  endproperty
  assert property(af_p463);

  property af_p464;
  @(posedge clk_xgmii_tx) (pkt_tx_val && pkt_tx_eop) |-> !$isunknown(pkt_tx_mod);
  endproperty
  assert property(af_p464);

  property af_p465;
  @(posedge clk_156m25) (pkt_tx_val && pkt_tx_eop) |=> (!pkt_tx_val) until (pkt_tx_val && pkt_tx_sop);
  endproperty
  assert property(af_p465);

  property af_p466;
  @(posedge clk_156m25) (pkt_tx_val && pkt_tx_sop) |-> (pkt_tx_val until_with pkt_tx_eop);
  endproperty
  assert property(af_p466);

  property af_p467;
  @(posedge clk_156m25) $rose(pkt_tx_val) |-> pkt_tx_sop;
  endproperty
  assert property(af_p467);

  property af_p468;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |=> !pkt_tx_val;
  endproperty
  assert property(af_p468);

  property af_p469;
  @(posedge clk_156m25) (pkt_tx_val && pkt_tx_eop) |=> (!pkt_tx_val) ##[1:$] pkt_tx_sop;
  endproperty
  assert property(af_p469);

  property af_p470;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> !pkt_tx_val;
  endproperty
  assert property(af_p470);

  property af_p471;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> ##[0:2] $rose(reset_xgmii_rx_n);
  endproperty
  assert property(af_p471);

  property af_p472;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> (!pkt_rx_avail);
  endproperty
  assert property(af_p472);

  property af_p473;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (!pkt_tx_val);
  endproperty
  assert property(af_p473);

  property af_p474;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> $stable(reset_156m25_n);
  endproperty
  assert property(af_p474);

  property af_p475;
  @(posedge clk_156m25) $rose(reset_156m25_n) |=> reset_156m25_n;
  endproperty
  assert property(af_p475);

  property af_p476;
  @(posedge clk_156m25) $rose(reset_156m25_n) |=> reset_156m25_n[*100];
  endproperty
  assert property(af_p476);

  property af_p477;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (!pkt_rx_val);
  endproperty
  assert property(af_p477);

  property af_p478;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> (!pkt_rx_sop);
  endproperty
  assert property(af_p478);

  property af_p479;
  @(posedge clk_156m25) $fell(reset_156m25_n) |=> (!pkt_tx_sop);
  endproperty
  assert property(af_p479);

  property af_p480;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> ##[0:2] $rose(reset_xgmii_tx_n);
  endproperty
  assert property(af_p480);

  property af_p481;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (!pkt_rx_err);
  endproperty
  assert property(af_p481);

  property af_p482;
  @(posedge clk_156m25) $fell(reset_156m25_n) |=> (!pkt_rx_sop);
  endproperty
  assert property(af_p482);

  property af_p483;
  @(posedge clk_156m25) (!reset_156m25_n) |-> $stable(pkt_rx_ren);
  endproperty
  assert property(af_p483);

  property af_p484;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (!pkt_rx_avail);
  endproperty
  assert property(af_p484);

  property af_p485;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> ##1 $stable(reset_156m25_n);
  endproperty
  assert property(af_p485);

  property af_p486;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> ##[1:4] (!$isunknown(pkt_rx_avail));
  endproperty
  assert property(af_p486);

  property af_p487;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (pkt_tx_full == 1'b0);
  endproperty
  assert property(af_p487);

  property af_p488;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> $past(!reset_156m25_n);
  endproperty
  assert property(af_p488);

  property af_p489;
  @(posedge clk_156m25) $rose(reset_xgmii_tx_n) |-> ##[0:2] $rose(reset_156m25_n);
  endproperty
  assert property(af_p489);

  property af_p490;
  @(posedge clk_156m25) $rose(reset_156m25_n) |=> (!pkt_tx_sop);
  endproperty
  assert property(af_p490);

  property af_p491;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> ($past(reset_156m25_n) == 1'b0);
  endproperty
  assert property(af_p491);

  property af_p492;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> (!pkt_tx_sop and !pkt_tx_eop);
  endproperty
  assert property(af_p492);

  property af_p493;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> reset_156m25_n[*4];
  endproperty
  assert property(af_p493);

  property af_p494;
  @(posedge clk_156m25) ($rose(reset_156m25_n) or $rose(reset_xgmii_rx_n) or $rose(reset_xgmii_tx_n)) |-> ##[0:2] ($rose(reset_156m25_n) and $rose(reset_xgmii_rx_n) and $rose(reset_xgmii_tx_n));
  endproperty
  assert property(af_p494);

  property af_p495;
  @(posedge clk_156m25) ($rose(reset_156m25_n) |-> ##[0:2] $rose(reset_xgmii_tx_n)) and ($rose(reset_xgmii_tx_n) |-> ##[0:2] $rose(reset_156m25_n));
  endproperty
  assert property(af_p495);

  property af_p496;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> ##1 reset_156m25_n;
  endproperty
  assert property(af_p496);

  property af_p497;
  @(posedge clk_156m25) $fell(reset_156m25_n) |-> ##1 (!reset_156m25_n);
  endproperty
  assert property(af_p497);

  property af_p498;
  @(posedge clk_156m25) $rose(reset_156m25_n) |-> ($past(!reset_156m25_n,1) and $past(!reset_156m25_n,2));
  endproperty
  assert property(af_p498);

  property af_p499;
  @(posedge clk_156m25) (!reset_156m25_n) |-> (!pkt_tx_full);
  endproperty
  assert property(af_p499);

  property af_p500;
  @(posedge clk_156m25) ($rose(reset_156m25_n) |-> ##[0:2] $rose(reset_xgmii_rx_n)) and ($rose(reset_xgmii_rx_n) |-> ##[0:2] $rose(reset_156m25_n));
  endproperty
  assert property(af_p500);

  property af_p501;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> !pkt_rx_err;
  endproperty
  assert property(af_p501);

  property af_p502;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |=> reset_xgmii_rx_n;
  endproperty
  assert property(af_p502);

  property af_p503;
  @(posedge clk_xgmii_rx) reset_xgmii_rx_n |-> !($isunknown(pkt_rx_sop) || $isunknown(pkt_rx_eop) || $isunknown(pkt_rx_val));
  endproperty
  assert property(af_p503);

  property af_p504;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_tx_n) |-> ##[0:2] $rose(reset_xgmii_rx_n);
  endproperty
  assert property(af_p504);

  property af_p505;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> !pkt_rx_val;
  endproperty
  assert property(af_p505);

  property af_p506;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> (xgmii_rxc == 8'hFF);
  endproperty
  assert property(af_p506);

  property af_p507;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> !pkt_rx_avail[*4];
  endproperty
  assert property(af_p507);

  property af_p508;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> (xgmii_rxc == 8'hFF) && (xgmii_rxd == 64'h0707070707070707);
  endproperty
  assert property(af_p508);

  property af_p509;
  @(posedge clk_xgmii_rx) $fell(reset_xgmii_rx_n) |=> !pkt_rx_err;
  endproperty
  assert property(af_p509);

  property af_p510;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |=> (!pkt_rx_sop && !pkt_rx_eop)[*1:$];
  endproperty
  assert property(af_p510);

  property af_p511;
  @(posedge clk_xgmii_rx) (reset_xgmii_rx_n && $past(!reset_xgmii_rx_n)) |-> $rose(clk_xgmii_rx);
  endproperty
  assert property(af_p511);

  property af_p512;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ($past(reset_xgmii_rx_n) == 1'b0);
  endproperty
  assert property(af_p512);

  property af_p513;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |=> (!pkt_rx_avail);
  endproperty
  assert property(af_p513);

  property af_p514;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ##[0:2] $rose(reset_xgmii_tx_n);
  endproperty
  assert property(af_p514);

  property af_p515;
  @(posedge clk_xgmii_rx) $fell(reset_xgmii_rx_n) |=> $stable(reset_xgmii_rx_n);
  endproperty
  assert property(af_p515);

  property af_p516;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> ($stable(xgmii_rxd));
  endproperty
  assert property(af_p516);

  property af_p517;
  @(posedge clk_xgmii_rx) $rose(reset_156m25_n) |-> ##[1:2] $rose(reset_xgmii_rx_n);
  endproperty
  assert property(af_p517);

  property af_p518;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |=> reset_xgmii_rx_n[*1:$];
  endproperty
  assert property(af_p518);

  property af_p519;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |=> (!pkt_rx_err)[*3];
  endproperty
  assert property(af_p519);

  property af_p520;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> (!pkt_rx_val);
  endproperty
  assert property(af_p520);

  property af_p521;
  @(posedge clk_xgmii_rx) $fell(reset_xgmii_rx_n) |=> (!pkt_rx_sop && !pkt_rx_eop);
  endproperty
  assert property(af_p521);

  property af_p522;
  @(posedge clk_xgmii_rx) $rose(reset_156m25_n) |-> ##[0:2] $rose(reset_xgmii_rx_n);
  endproperty
  assert property(af_p522);

  property af_p523;
  @(posedge clk_xgmii_rx) ($rose(reset_xgmii_rx_n) or $rose(reset_xgmii_tx_n)) |-> ##[0:2] ($rose(reset_xgmii_tx_n) or $rose(reset_xgmii_rx_n));
  endproperty
  assert property(af_p523);

  property af_p524;
  @(posedge clk_xgmii_rx) $fell(reset_xgmii_rx_n) |-> (!reset_xgmii_rx_n)[*4];
  endproperty
  assert property(af_p524);

  property af_p525;
  @(posedge clk_156m25) $rose(reset_xgmii_rx_n) |-> ##[0:2] $rose(reset_156m25_n);
  endproperty
  assert property(af_p525);

  property af_p526;
  @(posedge clk_156m25) $rose(reset_xgmii_rx_n) |=> !$isunknown(pkt_rx_avail);
  endproperty
  assert property(af_p526);

  property af_p527;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |-> (xgmii_txd == 64'h0707070707070707) && (xgmii_txc == 8'hFF);
  endproperty
  assert property(af_p527);

  property af_p528;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> $stable(reset_xgmii_tx_n);
  endproperty
  assert property(af_p528);

  property af_p529;
  @(posedge clk_xgmii_tx) $fell(reset_xgmii_tx_n) |-> ##1 (!reset_xgmii_tx_n) ##1 (!reset_xgmii_tx_n);
  endproperty
  assert property(af_p529);

  property af_p530;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ($past(!reset_xgmii_tx_n,1) && $past(!reset_xgmii_tx_n,2));
  endproperty
  assert property(af_p530);

  property af_p531;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> (!pkt_tx_val) ##1 (1'b1);
  endproperty
  assert property(af_p531);

  property af_p532;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |-> ##1 (!pkt_tx_full);
  endproperty
  assert property(af_p532);


  property af_p534;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |-> (xgmii_txc == 8'hFF);
  endproperty
  assert property(af_p534);

  property af_p535;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |-> (!pkt_tx_val);
  endproperty
  assert property(af_p535);

  property af_p536;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##[0:2] $rose(reset_156m25_n);
  endproperty
  assert property(af_p536);

  property af_p537;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |-> ##1 (pkt_tx_mod == 3'b000);
  endproperty
  assert property(af_p537);

  property af_p538;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |=> (xgmii_txd == pkt_tx_data) && (xgmii_txc == 8'h00);
  endproperty
  assert property(af_p538);

  property af_p539;
  @(posedge clk_xgmii_tx) $fell(reset_xgmii_tx_n) |-> ##[0:2] $fell(reset_xgmii_rx_n);
  endproperty
  assert property(af_p539);

  property af_p540;
  @(posedge clk_xgmii_tx) $changed(reset_xgmii_tx_n) |-> ##1 $stable(reset_xgmii_tx_n);
  endproperty
  assert property(af_p540);

  property af_p541;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##[1:$] !pkt_tx_full;
  endproperty
  assert property(af_p541);

  property af_p542;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |=> $stable(xgmii_txd);
  endproperty
  assert property(af_p542);

  property af_p543;
  @(posedge clk_xgmii_tx) $fell(reset_156m25_n) |-> ##[0:2] $fell(reset_xgmii_tx_n);
  endproperty
  assert property(af_p543);

  property af_p544;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ($past(reset_xgmii_tx_n,1) == 1'b0) && ($past(reset_xgmii_tx_n,2) == 1'b0);
  endproperty
  assert property(af_p544);

  property af_p545;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> 1;
  endproperty
  assert property(af_p545);

  property af_p546;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##[1:4] $changed(xgmii_txd);
  endproperty
  assert property(af_p546);

  property af_p547;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##[0:2] $rose(reset_xgmii_rx_n);
  endproperty
  assert property(af_p547);

  property af_p548;
  @(posedge clk_xgmii_tx) $rose(reset_156m25_n) |-> ##[0:2] $rose(reset_xgmii_tx_n);
  endproperty
  assert property(af_p548);

  property af_p549;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |-> ##1 $stable(xgmii_txc);
  endproperty
  assert property(af_p549);

  property af_p550;
  @(posedge clk_xgmii_tx) 1'b1 |-> !($changed(reset_xgmii_tx_n) && $past($changed(reset_xgmii_tx_n)));
  endproperty
  assert property(af_p550);

  property af_p551;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##[0:2] ($rose(reset_xgmii_rx_n) && $rose(reset_156m25_n));
  endproperty
  assert property(af_p551);

  property af_p552;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> reset_xgmii_tx_n throughout (!$fell(reset_xgmii_tx_n))[*1:$];
  endproperty
  assert property(af_p552);

  property af_p553;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |-> (xgmii_txd == {4{8'h07}});
  endproperty
  assert property(af_p553);

  property af_p554;
  @(posedge clk_xgmii_tx) 1'b1 |-> (reset_xgmii_tx_n == $sampled(reset_xgmii_tx_n));
  endproperty
  assert property(af_p554);

  property af_p555;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |-> (pkt_tx_full == 1'b0);
  endproperty
  assert property(af_p555);

  property af_p556;
  @(posedge clk_xgmii_tx) $fell(reset_xgmii_tx_n) |-> (!reset_xgmii_tx_n)[*2];
  endproperty
  assert property(af_p556);

  property af_p557;
  @(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (wb_ack_o == 1'b0) until (wb_stb_i && wb_cyc_i);
  endproperty
  assert property(af_p557);

  property af_p558;
  @(posedge wb_clk_i) (!wb_stb_i && wb_cyc_i) |-> (wb_ack_o == 1'b0);
  endproperty
  assert property(af_p558);

  property af_p559;
  @(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |=> (wb_ack_o == 1'b1);
  endproperty
  assert property(af_p559);

  property af_p560;
  @(posedge wb_clk_i) (wb_rst_i) |-> (wb_ack_o == 1'b0);
  endproperty
  assert property(af_p560);

  property af_p561;
  @(posedge wb_clk_i) ($fell(wb_stb_i) && wb_cyc_i) |=> (wb_ack_o == 1'b0);
  endproperty
  assert property(af_p561);

  property af_p562;
  @(posedge wb_clk_i) (wb_ack_o) |=> ((!wb_ack_o) || (wb_stb_i && wb_cyc_i));
  endproperty
  assert property(af_p562);

  property af_p563;
  @(posedge wb_clk_i) (wb_ack_o && !wb_we_i) |-> (wb_dat_o !== {32{1'bx}});
  endproperty
  assert property(af_p563);

  property af_p564;
  @(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |=> wb_ack_o;
  endproperty
  assert property(af_p564);

  property af_p565;
  @(posedge wb_clk_i) (wb_we_i && wb_stb_i && wb_cyc_i) |=> wb_ack_o;
  endproperty
  assert property(af_p565);


  property af_p567;
  @(posedge wb_clk_i) (!wb_cyc_i) |-> (!wb_ack_o);
  endproperty
  assert property(af_p567);

  property af_p568;
  @(posedge wb_clk_i) ($fell(wb_stb_i)) |-> (!wb_ack_o);
  endproperty
  assert property(af_p568);

  property af_p569;
  @(posedge wb_clk_i) (!wb_cyc_i) |-> !wb_ack_o;
  endproperty
  assert property(af_p569);

  property af_p570;
  @(posedge wb_clk_i) $rose(wb_ack_o) |=> !wb_ack_o;
  endproperty
  assert property(af_p570);

  property af_p571;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && !wb_we_i) |=> (wb_ack_o && !$isunknown(wb_dat_o));
  endproperty
  assert property(af_p571);

  property af_p572;
  @(posedge wb_clk_i) (wb_rst_i) |-> !wb_ack_o;
  endproperty
  assert property(af_p572);

  property af_p573;
  @(posedge wb_clk_i) $fell(wb_rst_i) |-> !wb_ack_o;
  endproperty
  assert property(af_p573);

  property af_p574;
  @(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |-> ##1 (wb_ack_o ##1 !wb_ack_o);
  endproperty
  assert property(af_p574);

  property af_p575;
  @(posedge wb_clk_i) wb_cyc_i |-> (wb_adr_i[1:0] == $past(wb_adr_i[1:0]));
  endproperty
  assert property(af_p575);

  property af_p576;
  @(posedge wb_clk_i) wb_ack_o |-> $past((wb_adr_i >= 0) && (wb_adr_i <= 255));
  endproperty
  assert property(af_p576);

  property af_p577;
  @(posedge wb_clk_i) (!wb_rst_i) |-> ((wb_adr_i >= 0) && (wb_adr_i <= 255));
  endproperty
  assert property(af_p577);

  property af_p578;
  @(posedge wb_clk_i) wb_cyc_i |-> (wb_adr_i[1:0] == 2'b00);
  endproperty
  assert property(af_p578);

  property af_p579;
  @(posedge wb_clk_i) $rose(wb_stb_i) |-> $stable(wb_adr_i) throughout (##[1:$] wb_ack_o);
  endproperty
  assert property(af_p579);

  property af_p580;
  @(posedge wb_clk_i) (wb_adr_i[1:0] == 2'b00);
  endproperty
  assert property(af_p580);

  property af_p581;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> !$isunknown(wb_adr_i);
  endproperty
  assert property(af_p581);

  property af_p582;
  @(posedge wb_clk_i) (wb_adr_i != $past(wb_adr_i)) |-> $past(!wb_cyc_i);
  endproperty
  assert property(af_p582);

  property af_p583;
  @(posedge wb_clk_i) $rose(wb_stb_i) |=> $stable(wb_adr_i) throughout (wb_stb_i[*1:$]);
  endproperty
  assert property(af_p583);

  property af_p584;
  @(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((wb_adr_i >= 0) && (wb_adr_i <= 255))[*1:$];
  endproperty
  assert property(af_p584);

  property af_p585;
  @(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((wb_adr_i >= 0) && (wb_adr_i <= 255));
  endproperty
  assert property(af_p585);

  property af_p586;
  @(posedge wb_clk_i) (wb_we_i && wb_cyc_i && wb_stb_i) |-> (!$isunknown(wb_adr_i) && (wb_adr_i >= 0) && (wb_adr_i <= 255));
  endproperty
  assert property(af_p586);

  property af_p587;
  @(posedge wb_clk_i) ((wb_adr_i >= 0) && (wb_adr_i <= 255)) |-> ##1 (wb_adr_i >= 0) && (wb_adr_i <= 255);
  endproperty
  assert property(af_p587);

  property af_p588;
  @(posedge wb_clk_i) ((wb_adr_i >= 4) && (wb_adr_i <= 251)) |-> ##1 (wb_adr_i >= 0) && (wb_adr_i <= 255);
  endproperty
  assert property(af_p588);

  property af_p589;
  @(posedge wb_rst_i) (wb_rst_i) |=> (##[1:$] !wb_rst_i throughout ((wb_adr_i >= 0) && (wb_adr_i <= 255)));
  endproperty
  assert property(af_p589);

  property af_p590;
  @(posedge wb_clk_i) ((wb_adr_i >= 4) && (wb_adr_i <= 251) && wb_we_i) |-> ##1 (wb_adr_i >= 0) && (wb_adr_i <= 255);
  endproperty
  assert property(af_p590);

  property af_p591;
  @(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ((wb_adr_i >= 0) && (wb_adr_i <= 255))[*3];
  endproperty
  assert property(af_p591);

  property af_p592;
  @(posedge wb_clk_i) (wb_we_i && !wb_ack_o) |=> $stable(wb_adr_i);
  endproperty
  assert property(af_p592);


  property af_p594;
  @(posedge wb_clk_i) ((wb_adr_i >= 4) && (wb_adr_i <= 255)) |-> ##1 (wb_adr_i >= 0) && (wb_adr_i <= 255);
  endproperty
  assert property(af_p594);

  property af_p595;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> $stable(wb_adr_i) until_with (wb_ack_o);
  endproperty
  assert property(af_p595);

  property af_p596;
  @(posedge wb_clk_i) (wb_rst_i) |-> (wb_adr_i inside {[0:255]});
  endproperty
  assert property(af_p596);

  property af_p597;
  @(posedge wb_clk_i) $rose(wb_rst_i == 0) |-> ##[1:2] $stable(wb_adr_i);
  endproperty
  assert property(af_p597);

  property af_p598;
  @(posedge wb_clk_i) (wb_we_i && wb_cyc_i && wb_stb_i) |-> $stable(wb_adr_i) until (wb_ack_o);
  endproperty
  assert property(af_p598);

  property af_p599;
  @(posedge wb_clk_i) 1 |-> (wb_adr_i[1:0] == $past(wb_adr_i[1:0]));
  endproperty
  assert property(af_p599);

  property af_p600;
  @(posedge wb_clk_i) ($changed(wb_adr_i) && !wb_cyc_i) |-> (wb_ack_o == 1'b0) until (wb_cyc_i && wb_stb_i);
  endproperty
  assert property(af_p600);

  property af_p601;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> (wb_we_i ? (wb_adr_i == wb_adr_i) : (wb_adr_i == wb_adr_i)) && $stable(wb_adr_i);
  endproperty
  assert property(af_p601);

  property af_p602;
  @(posedge wb_clk_i) (wb_stb_i) |-> (wb_adr_i[1:0] == 2'b00);
  endproperty
  assert property(af_p602);

  property af_p603;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> $stable(wb_adr_i);
  endproperty
  assert property(af_p603);

  property af_p604;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> !$isunknown(wb_we_i);
  endproperty
  assert property(af_p604);

  property af_p605;
  @(posedge wb_clk_i) (!wb_rst_i) |-> ($stable(wb_ack_o) || $rose(wb_ack_o) || $fell(wb_ack_o));
  endproperty
  assert property(af_p605);

  property af_p606;
  @(posedge wb_clk_i) $fell(wb_rst_i) |-> (!wb_ack_o) ##1 (!wb_ack_o);
  endproperty
  assert property(af_p606);

  property af_p607;
  @(posedge wb_clk_i) $fell(wb_rst_i) |-> !wb_rst_i;
  endproperty
  assert property(af_p607);

  property af_p608;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> !$isunknown(wb_adr_i);
  endproperty
  assert property(af_p608);

  property af_p609;
  @(posedge wb_clk_i) (!wb_ack_o) |-> $stable(wb_dat_o);
  endproperty
  assert property(af_p609);

  property af_p610;
  @(posedge wb_clk_i) $rose(wb_cyc_i) |-> ##1 $stable(wb_cyc_i);
  endproperty
  assert property(af_p610);

  property af_p611;
  @(posedge wb_clk_i) $rose(wb_stb_i) |-> (wb_stb_i throughout (wb_ack_o[->1]));
  endproperty
  assert property(af_p611);

  property af_p612;
  @(posedge wb_clk_i) $changed(wb_ack_o) |-> (wb_stb_i && wb_cyc_i);
  endproperty
  assert property(af_p612);

  property af_p613;
  @(posedge wb_clk_i) (wb_we_i) |-> !$isunknown(wb_dat_i);
  endproperty
  assert property(af_p613);

  property af_p614;
  @(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 !wb_rst_i;
  endproperty
  assert property(af_p614);

  property af_p615;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> ##1 ($stable(wb_cyc_i) && $stable(wb_stb_i));
  endproperty
  assert property(af_p615);

  property af_p616;
  @(posedge wb_clk_i) $changed(wb_int_o) |-> $rose(wb_clk_i);
  endproperty
  assert property(af_p616);

  property af_p617;
  @(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |=> wb_ack_o;
  endproperty
  assert property(af_p617);

  property af_p618;
  @(posedge wb_clk_i) (wb_rst_i) |-> (!wb_ack_o);
  endproperty
  assert property(af_p618);

  property af_p619;
  @(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (!$isunknown(wb_adr_i) && !$isunknown(wb_dat_i) && !$isunknown(wb_we_i));
  endproperty
  assert property(af_p619);

  property af_p620;
  @(posedge wb_clk_i) (wb_we_i) |-> (wb_dat_i == $past(wb_dat_i));
  endproperty
  assert property(af_p620);

  property af_p621;
  @(posedge wb_clk_i) ($changed(wb_int_o)) |-> $rose(wb_clk_i);
  endproperty
  assert property(af_p621);

  property af_p622;
  @(posedge wb_clk_i) (1'b1) |-> (wb_we_i ? !$isunknown(wb_dat_i) : !$isunknown(wb_dat_o));
  endproperty
  assert property(af_p622);

  property af_p623;
  @(posedge wb_clk_i) (!wb_stb_i) |-> $stable(wb_dat_o);
  endproperty
  assert property(af_p623);

  property af_p624;
  @(posedge wb_clk_i) (wb_cyc_i) |-> (wb_cyc_i throughout (wb_stb_i ##1 !wb_stb_i ##1 wb_stb_i));
  endproperty
  assert property(af_p624);

  property af_p625;
  @(posedge wb_clk_i) ($fell(wb_cyc_i)) |=> (!wb_ack_o);
  endproperty
  assert property(af_p625);

  property af_p626;
  @(posedge wb_clk_i) (wb_rst_i) |-> (!wb_ack_o);
  endproperty
  assert property(af_p626);

  property af_p627;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> ##[0:15] (wb_ack_o);
  endproperty
  assert property(af_p627);

  property af_p628;
  @(posedge wb_clk_i) (wb_cyc_i && !wb_stb_i) |-> ($stable(wb_dat_o) && !wb_ack_o);
  endproperty
  assert property(af_p628);

  property af_p629;
  @(posedge wb_clk_i) ($fell(wb_cyc_i) && $past(wb_ack_o)) |=> (!wb_ack_o);
  endproperty
  assert property(af_p629);

  property af_p630;
  @(posedge wb_clk_i) (!wb_cyc_i) |-> (!wb_ack_o);
  endproperty
  assert property(af_p630);

  property af_p631;
  @(posedge wb_clk_i) (!wb_cyc_i) |-> ($stable(wb_dat_o));
  endproperty
  assert property(af_p631);

  property af_p632;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_we_i) |-> ##[0:1] wb_ack_o;
  endproperty
  assert property(af_p632);

  property af_p633;
  @(posedge wb_clk_i) ($rose(wb_cyc_i) && wb_rst_i) |-> (!wb_ack_o) until (!wb_rst_i);
  endproperty
  assert property(af_p633);

  property af_p634;
  @(posedge wb_clk_i) ($fell(wb_rst_i) ##1 wb_cyc_i) |-> !$isunknown(wb_adr_i);
  endproperty
  assert property(af_p634);

  property af_p635;
  @(posedge wb_clk_i) ((wb_cyc_i && wb_stb_i && !wb_we_i) ##[1:$] wb_ack_o) |-> !$isunknown(wb_dat_o);
  endproperty
  assert property(af_p635);

  property af_p636;
  @(posedge wb_clk_i) wb_ack_o |-> (wb_cyc_i && wb_stb_i);
  endproperty
  assert property(af_p636);

  property af_p637;
  @(posedge wb_clk_i) $rose(wb_cyc_i) |-> (wb_cyc_i throughout wb_ack_o[->1]);
  endproperty
  assert property(af_p637);

  property af_p638;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_we_i) |-> ##[1:$] wb_ack_o;
  endproperty
  assert property(af_p638);

  property af_p639;
  @(posedge wb_clk_i) wb_rst_i |-> !(wb_ack_o || wb_int_o);
  endproperty
  assert property(af_p639);

  property af_p640;
  @(posedge wb_clk_i) (wb_cyc_i && !wb_stb_i) |-> !wb_ack_o;
  endproperty
  assert property(af_p640);

  property af_p641;
  @(posedge wb_clk_i) (!wb_rst_i && wb_cyc_i && wb_stb_i) |-> (!$isunknown(wb_adr_i) && !$isunknown(wb_dat_i) && !$isunknown(wb_we_i));
  endproperty
  assert property(af_p641);

  property af_p642;
  @(posedge wb_clk_i) wb_cyc_i |-> (wb_cyc_i until wb_ack_o);
  endproperty
  assert property(af_p642);

  property af_p643;
  @(posedge wb_clk_i) $rose(wb_cyc_i) |-> wb_stb_i;
  endproperty
  assert property(af_p643);

  property af_p644;
  @(posedge wb_clk_i) disable iff (wb_rst_i) ($rose(wb_cyc_i) && !wb_stb_i) |-> (!wb_ack_o until wb_stb_i);
  endproperty
  assert property(af_p644);

  property af_p645;
  @(posedge wb_clk_i) wb_stb_i |-> wb_cyc_i;
  endproperty
  assert property(af_p645);

  property af_p646;
  @(posedge wb_clk_i) wb_stb_i |-> (wb_cyc_i until wb_ack_o);
  endproperty
  assert property(af_p646);

  property af_p647;
  @(posedge wb_clk_i) ($fell(wb_cyc_i) && $past(wb_stb_i)) |-> not (##[1:$] wb_ack_o);
  endproperty
  assert property(af_p647);

  property af_p648;
  @(posedge wb_clk_i) disable iff (wb_rst_i) (wb_cyc_i === 1'b0 || wb_cyc_i === 1'b1);
  endproperty
  assert property(af_p648);

  property af_p649;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_we_i) |-> $stable(wb_dat_i) throughout (wb_stb_i[->1]);
  endproperty
  assert property(af_p649);

  property af_p650;
  @(posedge wb_clk_i) (!wb_we_i) |-> 1'b1;
  endproperty
  assert property(af_p650);

  property af_p651;
  @(posedge wb_clk_i) (wb_rst_i) |-> (!wb_ack_o && !wb_int_o);
  endproperty
  assert property(af_p651);

  property af_p652;
  @(posedge wb_clk_i) (wb_stb_i && wb_we_i) |-> ($stable(wb_dat_i) && (wb_dat_i >= 0) && (wb_dat_i <= 32'hFFFFFFFF));
  endproperty
  assert property(af_p652);

  property af_p653;
  @(posedge wb_clk_i) (!wb_we_i) |-> (!$isunknown(wb_dat_o));
  endproperty
  assert property(af_p653);

  property af_p654;
  @(posedge wb_clk_i) $rose(!wb_rst_i) |-> ((wb_dat_i >= 0) && (wb_dat_i <= 32'hFFFFFFFF))[*2];
  endproperty
  assert property(af_p654);

  property af_p655;
  @(posedge wb_clk_i) (!wb_stb_i) |-> $stable(wb_dat_o);
  endproperty
  assert property(af_p655);

  property af_p656;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_we_i) |-> ((wb_dat_i >= 0) && (wb_dat_i <= 32'hFFFFFFFF)) until_with (wb_ack_o);
  endproperty
  assert property(af_p656);

  property af_p657;
  @(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |-> ((wb_dat_i >= 0) && (wb_dat_i <= 32'hFFFFFFFF));
  endproperty
  assert property(af_p657);

  property af_p658;
  @(posedge wb_clk_i) disable iff (wb_rst_i) (wb_stb_i && wb_we_i) |=> (wb_dat_o == $past(wb_dat_i));
  endproperty
  assert property(af_p658);

  property af_p659;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_we_i && (wb_dat_i >= 0) && (wb_dat_i <= 65535)) |=> wb_ack_o;
  endproperty
  assert property(af_p659);

  property af_p660;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_we_i) |=> (wb_dat_o !== $past(wb_dat_i)) until_with (wb_cyc_i && wb_stb_i && !wb_we_i);
  endproperty
  assert property(af_p660);

  property af_p661;
  @(posedge wb_clk_i) ((wb_we_i && wb_stb_i && wb_cyc_i) && (wb_dat_i >= 0) && (wb_dat_i <= 65535)) |=> ((wb_dat_o >= 0) && (wb_dat_o <= 65535));
  endproperty
  assert property(af_p661);

  property af_p662;
  @(posedge wb_clk_i) ($past(!wb_rst_i,3) && wb_stb_i) |-> !$isunknown(wb_dat_i);
  endproperty
  assert property(af_p662);

  property af_p663;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_we_i) |-> !$isunknown(wb_dat_i);
  endproperty
  assert property(af_p663);

  property af_p664;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && $past(wb_cyc_i) && $past(wb_stb_i)) |-> $stable(wb_dat_i);
  endproperty
  assert property(af_p664);

  property af_p665;
  @(posedge wb_clk_i) (($past(wb_dat_i) == 32'h00000000 && wb_dat_i == 32'hFFFFFFFF) || ($past(wb_dat_i) == 32'hFFFFFFFF && wb_dat_i == 32'h00000000)) |-> !wb_int_o;
  endproperty
  assert property(af_p665);

  property af_p666;
  @(posedge wb_clk_i) (!wb_rst_i && wb_stb_i && wb_we_i) |-> $stable(wb_dat_i);
  endproperty
  assert property(af_p666);



  property af_p669;
  @(posedge wb_clk_i) (wb_ack_o) |-> $stable(wb_dat_o);
  endproperty
  assert property(af_p669);

  property af_p670;
  @(posedge wb_clk_i) (wb_stb_i && wb_cyc_i && !wb_we_i) |-> ($stable(wb_dat_o) until wb_ack_o);
  endproperty
  assert property(af_p670);

  property af_p671;
  @(posedge wb_clk_i) $rose(wb_rst_i) |-> ##3 (wb_dat_o == 32'h00000000);
  endproperty
  assert property(af_p671);

  property af_p672;
  @(posedge wb_clk_i) (wb_we_i) |-> ((wb_dat_o != wb_dat_i) && (wb_dat_o == $past(wb_dat_o)));
  endproperty
  assert property(af_p672);

  property af_p673;
  @(posedge wb_clk_i) (!wb_rst_i) |-> (wb_dat_o >= 32'h00000000 && wb_dat_o <= 32'hFFFFFFFF);
  endproperty
  assert property(af_p673);

  property af_p674;
  @(posedge wb_clk_i) (!wb_we_i && wb_stb_i && wb_ack_o) |-> !$isunknown(wb_dat_o);
  endproperty
  assert property(af_p674);

  property af_p675;
  @(posedge wb_clk_i) $rose(wb_rst_i) |-> (wb_dat_o == 32'h00000000)[*2];
  endproperty
  assert property(af_p675);

  property af_p676;
  @(posedge wb_clk_i) (!wb_we_i && wb_ack_o) |-> ($stable(wb_dat_o) until wb_stb_i);
  endproperty
  assert property(af_p676);

  property af_p677;
  @(posedge wb_clk_i) $fell(wb_ack_o) |-> (wb_dat_o == $past(wb_dat_o));
  endproperty
  assert property(af_p677);

  property af_p678;
  @(posedge wb_clk_i) (!wb_stb_i) |-> $stable(wb_dat_o);
  endproperty
  assert property(af_p678);

  property af_p679;
  @(posedge wb_clk_i) $rose(reset_156m25_n) |-> ##[1:5] !$isunknown(wb_dat_o);
  endproperty
  assert property(af_p679);

  property af_p680;
  @(posedge wb_clk_i) $rose(wb_ack_o) |-> !$isunknown(wb_dat_o);
  endproperty
  assert property(af_p680);

  property af_p681;
  @(posedge wb_clk_i) $rose(wb_ack_o) |-> !$isunknown(wb_dat_o) && $stable(wb_dat_o);
  endproperty
  assert property(af_p681);

  property af_p682;
  @(posedge wb_clk_i) (wb_ack_o && !wb_we_i) |=> !$isunknown(wb_dat_o);
  endproperty
  assert property(af_p682);

  property af_p683;
  @(posedge wb_clk_i) (wb_we_i) |-> $stable(wb_dat_o);
  endproperty
  assert property(af_p683);

  property af_p684;
  @(posedge wb_clk_i) $changed(wb_dat_o) |-> $past(wb_ack_o);
  endproperty
  assert property(af_p684);

  property af_p685;
  @(posedge wb_clk_i) (!wb_ack_o) |-> $stable(wb_dat_o);
  endproperty
  assert property(af_p685);


  property af_p687;
  @(posedge wb_clk_i) wb_rst_i |=> (wb_dat_o == 32'h00000000);
  endproperty
  assert property(af_p687);

  property af_p688;
  @(posedge wb_clk_i) (wb_cyc_i && !wb_stb_i) |-> !$isunknown(wb_dat_o);
  endproperty
  assert property(af_p688);

  property af_p689;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && !wb_we_i && wb_ack_o) |-> !$isunknown(wb_dat_o);
  endproperty
  assert property(af_p689);

  property af_p690;
  @(posedge wb_clk_i) (!wb_cyc_i) |-> $stable(wb_dat_o);
  endproperty
  assert property(af_p690);

  property af_p691;
  @(posedge wb_clk_i) ($rose(wb_ack_o)) |-> (!$isunknown(wb_dat_o) ##1 !wb_ack_o);
  endproperty
  assert property(af_p691);

  property af_p692;
  @(posedge wb_clk_i) (wb_stb_i) |=> !$isunknown(wb_dat_o);
  endproperty
  assert property(af_p692);

  property af_p693;
  @(posedge wb_clk_i) (wb_ack_o) |-> (wb_dat_o >= 32'h00000000 && wb_dat_o <= 32'hFFFFFFFF);
  endproperty
  assert property(af_p693);

  property af_p694;
  @(posedge wb_clk_i) ($fell(wb_rst_i)) |=> !$isunknown(wb_dat_o);
  endproperty
  assert property(af_p694);

  property af_p695;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && !wb_we_i) |-> !$isunknown(wb_dat_o);
  endproperty
  assert property(af_p695);

  property af_p696;
  @(posedge wb_clk_i) (wb_we_i && $changed(wb_dat_i)) |-> $stable(wb_dat_o);
  endproperty
  assert property(af_p696);

  property af_p697;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && !wb_we_i && wb_int_o) |-> ##[1:4] (wb_ack_o && $stable(wb_int_o));
  endproperty
  assert property(af_p697);

  property af_p698;
  @(posedge wb_clk_i) (wb_int_o && wb_we_i && wb_ack_o) |-> ##1 (wb_int_o == 1'b0);
  endproperty
  assert property(af_p698);

  property af_p699;
  @(posedge wb_clk_i) (!wb_cyc_i && !wb_stb_i) |-> $stable(wb_int_o);
  endproperty
  assert property(af_p699);

  property af_p700;
  @(posedge wb_clk_i) (!$rose(wb_int_o)) |-> $stable(wb_int_o);
  endproperty
  assert property(af_p700);

  property af_p701;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_we_i && (wb_adr_i == 8'h04)) |-> ##1 (wb_int_o == 1'b0);
  endproperty
  assert property(af_p701);

  property af_p702;
  @(posedge wb_clk_i) $rose(wb_int_o) |-> (wb_cyc_i && wb_stb_i);
  endproperty
  assert property(af_p702);

  property af_p703;
  @(posedge wb_clk_i) (!wb_cyc_i) |-> $stable(wb_int_o);
  endproperty
  assert property(af_p703);

  property af_p704;
  @(posedge wb_clk_i) (!wb_rst_i) |-> (wb_int_o inside {1'b0, 1'b1});
  endproperty
  assert property(af_p704);

  property af_p705;
  @(posedge wb_clk_i) $rose(pkt_rx_err) |-> ##1 (wb_int_o == 1'b1);
  endproperty
  assert property(af_p705);

  property af_p706;
  @(posedge wb_clk_i) (wb_rst_i) |-> (wb_int_o == 1'b0);
  endproperty
  assert property(af_p706);

  property af_p707;
  @(posedge wb_clk_i) ($changed(wb_int_o) && wb_int_o == 1'b1) |-> $stable(wb_int_o);
  endproperty
  assert property(af_p707);

  property af_p708;
  @(posedge wb_clk_i) ($rose(wb_int_o)) |-> ##1 $stable(wb_int_o);
  endproperty
  assert property(af_p708);

  property af_p709;
  @(posedge wb_clk_i) (wb_int_o == 1'b1) |=> (wb_int_o == 1'b1) || (wb_we_i);
  endproperty
  assert property(af_p709);

  property af_p710;
  @(posedge wb_clk_i) (!wb_stb_i) |-> $stable(wb_int_o);
  endproperty
  assert property(af_p710);

  property af_p711;
  @(posedge wb_clk_i) $rose(~wb_rst_i) |-> (wb_int_o == 1'b0) ##1 (wb_int_o == 1'b0);
  endproperty
  assert property(af_p711);

  property af_p712;
  @(posedge wb_clk_i) (!wb_rst_i && !pkt_rx_err) |-> (wb_int_o == 1'b0);
  endproperty
  assert property(af_p712);

  property af_p713;
  @(posedge wb_clk_i) ($rose(wb_int_o)) |-> (wb_int_o throughout (!(wb_cyc_i && wb_stb_i && wb_we_i))[->1]);
  endproperty
  assert property(af_p713);

  property af_p714;
  @(posedge wb_clk_i) (1'b1) |-> (wb_int_o === 1'b0 || wb_int_o === 1'b1);
  endproperty
  assert property(af_p714);

  property af_p715;
  @(posedge wb_clk_i) (~wb_rst_i) |-> (wb_int_o inside {1'b0, 1'b1});
  endproperty
  assert property(af_p715);

  property af_p716;
  @(posedge wb_clk_i) $rose(~wb_rst_i) |-> ##3 (wb_int_o == 1'b0);
  endproperty
  assert property(af_p716);

  property af_p717;
  @(posedge wb_clk_i) (wb_rst_i) |-> (!wb_int_o);
  endproperty
  assert property(af_p717);

  property af_p718;
  @(posedge wb_clk_i) (wb_int_o) |-> (##1 (wb_int_o || (wb_cyc_i && wb_stb_i && wb_we_i)));
  endproperty
  assert property(af_p718);

  property af_p719;
  @(posedge wb_clk_i) (wb_ack_o && wb_dat_o[0]) |-> ##1 (!wb_int_o);
  endproperty
  assert property(af_p719);

  property af_p720;
  @(posedge wb_clk_i) (wb_int_o) |-> (1'b1);
  endproperty
  assert property(af_p720);

  property af_p721;
  @(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (!wb_int_o);
  endproperty
  assert property(af_p721);

  property af_p722;
  @(posedge wb_clk_i) (wb_int_o === 1'b0) || (wb_int_o === 1'b1);
  endproperty
  assert property(af_p722);

  property af_p723;
  @(posedge wb_clk_i) (pkt_rx_avail && !pkt_rx_ren) |-> ##[1:8] (wb_int_o);
  endproperty
  assert property(af_p723);

  property af_p724;
  @(posedge wb_clk_i) (wb_int_o) |-> (wb_int_o until wb_ack_o);
  endproperty
  assert property(af_p724);

  property af_p725;
  @(posedge wb_clk_i) $rose(wb_rst_i == 1'b0) |-> (!wb_int_o) [*2];
  endproperty
  assert property(af_p725);

  property af_p726;
  @(posedge wb_clk_i) (wb_ack_o && wb_adr_i == 8'h00) |-> ##1 (!wb_int_o);
  endproperty
  assert property(af_p726);

  property af_p727;
  @(posedge wb_clk_i) (wb_rst_i) |=> (wb_ack_o == 1'b0);
  endproperty
  assert property(af_p727);

  property af_p728;
  @(posedge wb_clk_i) $fell(wb_rst_i) |=> $stable(wb_we_i);
  endproperty
  assert property(af_p728);

  property af_p729;
  @(posedge wb_clk_i) (wb_rst_i && wb_we_i) |-> $stable(wb_dat_o);
  endproperty
  assert property(af_p729);

  property af_p730;
  @(posedge wb_clk_i) $fell(wb_rst_i) |=> (wb_int_o == 1'b0)[*2];
  endproperty
  assert property(af_p730);

  property af_p731;
  @(posedge wb_clk_i) (wb_rst_i) |-> (wb_ack_o == 1'b0);
  endproperty
  assert property(af_p731);

  property af_p732;
  @(posedge wb_clk_i) $rose(wb_rst_i) |-> (wb_rst_i throughout ##1 $fell(wb_rst_i)[->1]);
  endproperty
  assert property(af_p732);

  property af_p733;
  @(posedge wb_clk_i) (wb_rst_i) |-> (wb_int_o == 1'b0) throughout (wb_rst_i[*1:$]);
  endproperty
  assert property(af_p733);

  property af_p734;
  @(posedge wb_clk_i) $fell(wb_rst_i) |-> $stable(wb_rst_i);
  endproperty
  assert property(af_p734);

  property af_p735;
  @(posedge wb_clk_i) $rose(wb_rst_i) |=> (wb_ack_o == 1'b0);
  endproperty
  assert property(af_p735);

  property af_p736;
  @(posedge wb_clk_i) (wb_rst_i && wb_cyc_i && wb_stb_i) |-> (wb_ack_o == 1'b0);
  endproperty
  assert property(af_p736);

  property af_p737;
  @(posedge wb_clk_i) ($fell(wb_rst_i) ##1 $rose(wb_rst_i)) |=> (wb_ack_o == 1'b0) && (wb_int_o == 1'b0);
  endproperty
  assert property(af_p737);

  property af_p738;
  @(posedge wb_clk_i) (wb_rst_i) |-> (wb_dat_o == '0);
  endproperty
  assert property(af_p738);

  property af_p739;
  @(posedge wb_clk_i) (wb_rst_i) |-> (wb_int_o == 1'b0);
  endproperty
  assert property(af_p739);

  property af_p740;
  @(posedge clk_156m25) $fell(wb_rst_i) |-> ##[0:2] $fell(reset_156m25_n);
  endproperty
  assert property(af_p740);

  property af_p741;
  @(posedge wb_clk_i) $fell(wb_rst_i) |=> !$isunknown({wb_stb_i, wb_cyc_i});
  endproperty
  assert property(af_p741);

  property af_p742;
  @(posedge clk_156m25) $fell(wb_rst_i) |-> ##[0:2] ($fell(reset_156m25_n) && $fell(reset_xgmii_rx_n) && $fell(reset_xgmii_tx_n));
  endproperty
  assert property(af_p742);

  property af_p743;
  @(posedge wb_clk_i) $fell(wb_rst_i) |=> (!wb_ack_o) until (wb_cyc_i && wb_stb_i);
  endproperty
  assert property(af_p743);

  property af_p744;
  @(posedge wb_clk_i) wb_rst_i |-> $stable(wb_dat_o);
  endproperty
  assert property(af_p744);

  property af_p745;
  @(posedge wb_clk_i) $fell(wb_rst_i) |=> !$isunknown(wb_dat_o);
  endproperty
  assert property(af_p745);

  property af_p746;
  @(posedge wb_clk_i) (wb_stb_i && !wb_we_i && wb_ack_o) |-> (!$isunknown(wb_dat_o));
  endproperty
  assert property(af_p746);

  property af_p747;
  @(posedge wb_clk_i) (!wb_stb_i) |=> (!wb_ack_o);
  endproperty
  assert property(af_p747);

  property af_p748;
  @(posedge wb_clk_i) (wb_rst_i) |-> (!wb_ack_o);
  endproperty
  assert property(af_p748);

  property af_p749;
  @(posedge wb_clk_i) ($rose(!wb_rst_i)) |=> (wb_stb_i |-> !$isunknown(wb_ack_o));
  endproperty
  assert property(af_p749);

  property af_p750;
  @(posedge wb_clk_i) (wb_ack_o) |=> (!wb_stb_i);
  endproperty
  assert property(af_p750);

  property af_p751;
  @(posedge wb_clk_i) (wb_stb_i && !wb_cyc_i) |=> (!wb_ack_o);
  endproperty
  assert property(af_p751);

  property af_p752;
  @(posedge wb_clk_i) ($rose(wb_stb_i) && !wb_we_i) |=> (!$isunknown(wb_dat_o));
  endproperty
  assert property(af_p752);

  property af_p753;
  @(posedge wb_clk_i) (wb_stb_i && wb_cyc_i && !wb_we_i && !wb_rst_i) |=> wb_ack_o;
  endproperty
  assert property(af_p753);

  property af_p754;
  @(posedge wb_clk_i) (wb_rst_i) |-> (!wb_stb_i);
  endproperty
  assert property(af_p754);

  property af_p755;
  @(posedge wb_clk_i) ($fell(wb_stb_i) && !wb_ack_o) |-> (!wb_int_o);
  endproperty
  assert property(af_p755);



  property af_p758;
  @(posedge wb_clk_i) ($rose(wb_ack_o)) |=> (!wb_stb_i);
  endproperty
  assert property(af_p758);

  property af_p759;
  @(posedge wb_clk_i) (wb_stb_i) |-> (wb_cyc_i);
  endproperty
  assert property(af_p759);

  property af_p760;
  @(posedge wb_clk_i) (wb_stb_i) |-> ($past(wb_rst_i,4) == 1'b1);
  endproperty
  assert property(af_p760);

  property af_p761;
  @(posedge wb_clk_i) (wb_ack_o) |-> (!wb_stb_i);
  endproperty
  assert property(af_p761);

  property af_p762;
  @(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |-> ##[1:$] (wb_ack_o ##1 !wb_ack_o);
  endproperty
  assert property(af_p762);


  property af_p764;
  @(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |-> ##[1:4] wb_ack_o;
  endproperty
  assert property(af_p764);

  property af_p765;
  @(posedge wb_clk_i) $fell(wb_rst_i) |-> (!wb_stb_i)[*4];
  endproperty
  assert property(af_p765);

  property af_p766;
  @(posedge wb_clk_i) (wb_stb_i && wb_cyc_i && wb_we_i) |=> (wb_dat_o == $past(wb_dat_i));
  endproperty
  assert property(af_p766);

  property af_p767;
  @(posedge wb_clk_i) (wb_stb_i && wb_we_i) |=> (wb_dat_i === $past(wb_dat_i));
  endproperty
  assert property(af_p767);

  property af_p768;
  @(posedge wb_clk_i) (wb_stb_i && !wb_cyc_i) |-> (!wb_ack_o);
  endproperty
  assert property(af_p768);

  property af_p769;
  @(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |=> (wb_ack_o);
  endproperty
  assert property(af_p769);

  property af_p770;
  @(posedge wb_clk_i) (wb_stb_i && !$past(wb_stb_i)) |-> (wb_stb_i throughout wb_ack_o[->1]);
  endproperty
  assert property(af_p770);

  property af_p771;
  @(posedge wb_clk_i) (wb_stb_i && wb_cyc_i && $stable(wb_adr_i)) |-> ($rose(wb_ack_o) |=> !wb_ack_o);
  endproperty
  assert property(af_p771);

  property af_p772;
  @(posedge wb_clk_i) (!wb_cyc_i) |-> (!wb_ack_o);
  endproperty
  assert property(af_p772);

  property af_p773;
  @(posedge wb_clk_i) (wb_rst_i) |=> (!wb_stb_i);
  endproperty
  assert property(af_p773);

  property af_p774;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && !$past(wb_stb_i)) |=> (wb_ack_o);
  endproperty
  assert property(af_p774);

  property af_p775;
  @(posedge wb_clk_i) (wb_we_i && wb_stb_i) |=> (wb_dat_o == $past(wb_dat_i));
  endproperty
  assert property(af_p775);

  property af_p776;
  @(posedge wb_clk_i) (1'b1) |-> ($sampled(wb_we_i) === wb_we_i);
  endproperty
  assert property(af_p776);

  property af_p777;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> $stable(wb_we_i);
  endproperty
  assert property(af_p777);

  property af_p778;
  @(posedge wb_clk_i) (wb_we_i && !wb_stb_i && !wb_cyc_i) |-> !wb_ack_o;
  endproperty
  assert property(af_p778);

  property af_p779;
  @(posedge wb_clk_i) (($past(wb_we_i) == 1'b0) && (wb_we_i == 1'b1) && wb_cyc_i && wb_stb_i) |-> ##[1:$] wb_ack_o;
  endproperty
  assert property(af_p779);

  property af_p780;
  @(posedge wb_clk_i) (($past(wb_we_i) != wb_we_i) && wb_cyc_i && wb_stb_i) |-> ##[1:$] wb_ack_o;
  endproperty
  assert property(af_p780);

  property af_p781;
  @(posedge wb_clk_i) (wb_we_i && wb_cyc_i && wb_stb_i) |=> (wb_dat_o == $past(wb_dat_i));
  endproperty
  assert property(af_p781);

  property af_p782;
  @(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && !wb_ack_o) |-> $stable(wb_we_i);
  endproperty
  assert property(af_p782);

  property af_p783;
  @(posedge wb_clk_i) (wb_we_i && wb_stb_i && wb_cyc_i) |=> (wb_dat_o == $past(wb_dat_i));
  endproperty
  assert property(af_p783);

  property af_p784;
  @(posedge wb_clk_i) $changed(wb_we_i) |-> $stable(wb_int_o);
  endproperty
  assert property(af_p784);

  property af_p785;
  @(posedge wb_clk_i) (!wb_we_i && wb_cyc_i && wb_stb_i) |-> !$isunknown(wb_dat_o);
  endproperty
  assert property(af_p785);

  property af_p786;
  @(posedge wb_clk_i) (wb_rst_i) |-> ##1 (wb_ack_o == 1'b0);
  endproperty
  assert property(af_p786);

  property af_p787;
  @(posedge wb_clk_i) (wb_we_i && wb_ack_o) |-> (wb_dat_i == $past(wb_dat_i)) or (1'b1);
  endproperty
  assert property(af_p787);

  property af_p788;
  @(posedge wb_clk_i) (!wb_rst_i ##4 1'b1) |-> !$isunknown(wb_we_i) && !$isunknown(wb_ack_o);
  endproperty
  assert property(af_p788);

  property af_p789;
  @(posedge wb_clk_i) (!wb_cyc_i || !wb_stb_i) |-> (wb_ack_o == 1'b0);
  endproperty
  assert property(af_p789);

  property af_p790;
  @(posedge wb_clk_i) (!wb_rst_i) |-> !$isunknown(wb_we_i);
  endproperty
  assert property(af_p790);

  property af_p791;
  @(posedge wb_clk_i) (!wb_we_i && wb_stb_i && wb_cyc_i && wb_ack_o) |-> !$isunknown(wb_dat_o);
  endproperty
  assert property(af_p791);

  property af_p792;
  @(posedge wb_clk_i) (wb_we_i && wb_stb_i && wb_cyc_i) |-> ##[1:1] wb_ack_o;
  endproperty
  assert property(af_p792);

  property af_p793;
  @(posedge wb_clk_i) (wb_stb_i && $past(wb_we_i)) |-> ($stable(wb_we_i) until_with wb_ack_o);
  endproperty
  assert property(af_p793);

  property af_p794;
  @(posedge wb_clk_i) (wb_we_i && wb_stb_i && wb_cyc_i) |=> wb_ack_o;
  endproperty
  assert property(af_p794);

  property af_p795;
  @(posedge wb_clk_i) $rose(wb_rst_i) |-> (!wb_we_i)[*2];
  endproperty
  assert property(af_p795);

  property af_p796;
  @(posedge wb_clk_i) ($rose(wb_we_i) && wb_cyc_i) |-> !wb_ack_o;
  endproperty
  assert property(af_p796);

  property af_p797;
  @(posedge wb_clk_i) (wb_we_i && !(wb_stb_i && wb_cyc_i)) |=> $stable(wb_dat_o);
  endproperty
  assert property(af_p797);

  property af_p798;
  @(posedge wb_clk_i) ($fell(wb_rst_i) && wb_we_i) |-> !(wb_cyc_i && wb_stb_i) throughout (!wb_ack_o)[*1:$];
  endproperty
  assert property(af_p798);

  property af_p799;
  @(posedge wb_clk_i) (wb_rst_i) |-> !wb_we_i;
  endproperty
  assert property(af_p799);

  property af_p800;
  @(posedge wb_clk_i) (1) |-> ($sampled(wb_we_i) && $sampled(wb_stb_i) && $sampled(wb_cyc_i)) || (!$sampled(wb_we_i) || !$sampled(wb_stb_i) || !$sampled(wb_cyc_i));
  endproperty
  assert property(af_p800);

  property af_p801;
  @(posedge wb_clk_i) (wb_we_i && wb_cyc_i && wb_stb_i) |-> ##[1:16] wb_ack_o;
  endproperty
  assert property(af_p801);



  property af_p804;
  @(posedge clk_xgmii_rx) (pkt_rx_sop) |-> (xgmii_rxc[0] == 1'b0);
  endproperty
  assert property(af_p804);



  property af_p807;
  @(posedge clk_xgmii_rx) ($rose(pkt_rx_avail)) |-> ($past(xgmii_rxc) != 8'hFF);
  endproperty
  assert property(af_p807);

  property af_p808;
  @(posedge clk_xgmii_rx) (xgmii_rxc == 8'hFF) |=> (xgmii_rxc inside {[8'h00:8'hFF]});
  endproperty
  assert property(af_p808);

  property af_p809;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |=> (xgmii_rxc == 8'hFF);
  endproperty
  assert property(af_p809);

  property af_p810;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> (!$isunknown(xgmii_rxc));
  endproperty
  assert property(af_p810);

  property af_p811;
  @(posedge clk_xgmii_rx) (!$isunknown(xgmii_rxc));
  endproperty
  assert property(af_p811);

  property af_p812;
  @(posedge clk_xgmii_rx) (pkt_rx_eop) |-> ((xgmii_rxc >> pkt_rx_mod) == (8'hFF >> pkt_rx_mod));
  endproperty
  assert property(af_p812);

  property af_p813;
  @(posedge clk_xgmii_rx) ($changed(xgmii_rxd)) |-> (xgmii_rxc == 8'h00);
  endproperty
  assert property(af_p813);

  property af_p814;
  @(posedge clk_xgmii_rx) ($past(reset_xgmii_rx_n,2) && reset_xgmii_rx_n) |-> $stable(xgmii_rxc);
  endproperty
  assert property(af_p814);

  property af_p815;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |=> (xgmii_rxc == 8'hFF);
  endproperty
  assert property(af_p815);

  property af_p816;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> (xgmii_rxc == 8'hFF);
  endproperty
  assert property(af_p816);

  property af_p817;
  @(posedge clk_xgmii_rx) (reset_xgmii_rx_n) |-> (xgmii_rxc >= 0 && xgmii_rxc <= 255);
  endproperty
  assert property(af_p817);

  property af_p818;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |=> (xgmii_rxc inside {[0:255]});
  endproperty
  assert property(af_p818);

  property af_p819;
  @(posedge clk_xgmii_rx) (reset_xgmii_rx_n) |-> (xgmii_rxc inside {[0:255]});
  endproperty
  assert property(af_p819);

  property af_p820;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ##4 ((xgmii_rxc inside {[0:255]}) && (xgmii_rxc != 8'hFF));
  endproperty
  assert property(af_p820);

  property af_p821;
  @(posedge clk_xgmii_rx) (pkt_rx_eop) |-> (xgmii_rxc != 8'h00);
  endproperty
  assert property(af_p821);

  property af_p822;
  @(posedge clk_xgmii_rx) ($stable(xgmii_rxd)) |-> $stable(xgmii_rxc);
  endproperty
  assert property(af_p822);

  property af_p823;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ##3 (xgmii_rxc inside {[0:255]});
  endproperty
  assert property(af_p823);

  property af_p824;
  @(posedge clk_xgmii_rx) (((xgmii_rxc >= 8'h00) && (xgmii_rxc <= 8'h0F))[*2]) |=> ((xgmii_rxc >= 8'h00) && (xgmii_rxc <= 8'hFF));
  endproperty
  assert property(af_p824);

  property af_p825;
  @(posedge clk_xgmii_rx) (pkt_rx_err) |-> (xgmii_rxc > 8'h00);
  endproperty
  assert property(af_p825);

  property af_p826;
  @(posedge clk_xgmii_rx) (xgmii_rxc == 8'h00) |-> ##1 (xgmii_rxc == 8'h00);
  endproperty
  assert property(af_p826);

  property af_p827;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ##3 ((xgmii_rxc >= 8'h00) && (xgmii_rxc <= 8'hFF));
  endproperty
  assert property(af_p827);

  property af_p828;
  @(posedge clk_xgmii_rx) (reset_xgmii_rx_n) |-> ((xgmii_rxc >= 8'h00) && (xgmii_rxc <= 8'hFF));
  endproperty
  assert property(af_p828);

  property af_p829;
  @(posedge clk_xgmii_rx) ((xgmii_rxc >= 8'h00) && (xgmii_rxc <= 8'h7F)) |=> (xgmii_rxc >= 8'h00) && (xgmii_rxc <= 8'hFF);
  endproperty
  assert property(af_p829);

  property af_p830;
  @(posedge clk_xgmii_rx) disable iff (reset_xgmii_rx_n) (1) |-> (1);
  endproperty
  assert property(af_p830);

  property af_p831;
  @(posedge clk_xgmii_rx) ((xgmii_rxc >= 8'h00) && (xgmii_rxc <= 8'h7F)) |-> (pkt_rx_val);
  endproperty
  assert property(af_p831);

  property af_p832;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ##4 ((xgmii_rxc >= 8'h00) && (xgmii_rxc <= 8'hFF));
  endproperty
  assert property(af_p832);

  property af_p833;
  @(posedge clk_xgmii_rx) 1 |-> !$isunknown(xgmii_rxc);
  endproperty
  assert property(af_p833);

  property af_p834;
  @(posedge clk_xgmii_rx) ($fell(reset_xgmii_rx_n)) |=> (xgmii_rxd == 64'h0);
  endproperty
  assert property(af_p834);

  property af_p835;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> $stable(xgmii_rxd);
  endproperty
  assert property(af_p835);

  property af_p836;
  @(posedge clk_xgmii_rx) ($rose(reset_xgmii_rx_n)) |-> ##[1:2] (!$isunknown(xgmii_rxd) && $stable(xgmii_rxd));
  endproperty
  assert property(af_p836);

  property af_p837;
  @(posedge clk_xgmii_rx) ($rose(reset_xgmii_rx_n)) |-> (xgmii_rxd == 64'h0) ##1 !$isunknown(xgmii_rxd);
  endproperty
  assert property(af_p837);

  property af_p838;
  @(posedge clk_xgmii_rx) (xgmii_rxc == 8'hFF) |-> (xgmii_rxd inside {64'h07070707_07070707, 64'h9c9c9c9c_9c9c9c9c, 64'hfbfbfbfb_fbfbfbfb});
  endproperty
  assert property(af_p838);

  property af_p839;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |=> (xgmii_rxd == 64'h0);
  endproperty
  assert property(af_p839);

  property af_p840;
  @(posedge clk_xgmii_rx) disable iff (!reset_xgmii_rx_n) (1'b1) |-> !$isunknown(xgmii_rxd);
  endproperty
  assert property(af_p840);

  property af_p841;
  @(posedge clk_xgmii_rx) ($rose(reset_xgmii_rx_n)) |-> ##[1:2] !$isunknown(xgmii_rxd);
  endproperty
  assert property(af_p841);


  property af_p843;
  @(posedge clk_xgmii_rx) (reset_xgmii_rx_n) |-> (xgmii_rxd >= 64'd0 && xgmii_rxd <= 64'hFFFFFFFFFFFFFFFF);
  endproperty
  assert property(af_p843);

  property af_p844;
  @(posedge clk_xgmii_rx) (xgmii_rxc == 8'd0) |-> ##1 $stable(xgmii_rxd);
  endproperty
  assert property(af_p844);


  property af_p846;
  @(posedge clk_xgmii_rx) (xgmii_rxc[0] == 1'b0) |-> (xgmii_rxd[7:0] >= 8'd0) && (xgmii_rxd[7:0] <= 8'd255);
  endproperty
  assert property(af_p846);

  property af_p847;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> (xgmii_rxd == 64'd0);
  endproperty
  assert property(af_p847);

  property af_p848;
  @(posedge clk_xgmii_rx) (xgmii_rxd[63:32] == $past(xgmii_rxd[31:0]));
  endproperty
  assert property(af_p848);

  property af_p849;
  @(posedge clk_xgmii_rx) $rose(reset_xgmii_rx_n) |-> ##3 ((xgmii_rxd[7:0] >= 0 && xgmii_rxd[7:0] <= 255) && (xgmii_rxd[15:8] >= 0 && xgmii_rxd[15:8] <= 255) && (xgmii_rxd[23:16] >= 0 && xgmii_rxd[23:16] <= 255) && (xgmii_rxd[31:24] >= 0 && xgmii_rxd[31:24] <= 255) && (xgmii_rxd[39:32] >= 0 && xgmii_rxd[39:32] <= 255) && (xgmii_rxd[47:40] >= 0 && xgmii_rxd[47:40] <= 255) && (xgmii_rxd[55:48] >= 0 && xgmii_rxd[55:48] <= 255) && (xgmii_rxd[63:56] >= 0 && xgmii_rxd[63:56] <= 255));
  endproperty
  assert property(af_p849);

  property af_p850;
  @(posedge clk_xgmii_rx) (xgmii_rxc == 8'h00) |-> (!$isunknown(xgmii_rxd) && $stable(xgmii_rxd));
  endproperty
  assert property(af_p850);

  property af_p851;
  @(posedge clk_xgmii_rx) (xgmii_rxc == 8'h00) |=> ((xgmii_rxc != 8'h00) -> !$stable(xgmii_rxd));
  endproperty
  assert property(af_p851);

  property af_p852;
  @(posedge clk_xgmii_rx) (xgmii_rxc == 8'h00) |-> (xgmii_rxd[63:0] >= 64'h0 && xgmii_rxd[63:0] <= 64'hFFFFFFFFFFFFFFFF);
  endproperty
  assert property(af_p852);

  property af_p853;
  @(posedge clk_xgmii_rx) (xgmii_rxd[31:0] !== $past(xgmii_rxd[31:0])) |-> (xgmii_rxd[63:32] !== $past(xgmii_rxd[63:32]));
  endproperty
  assert property(af_p853);

  property af_p854;
  @(posedge clk_xgmii_rx) (xgmii_rxc[7:4] == 4'b0000) |=> $stable(xgmii_rxd[63:32]);
  endproperty
  assert property(af_p854);

  property af_p855;
  @(posedge clk_xgmii_rx) ($past(xgmii_rxc) == xgmii_rxc) |-> $stable(xgmii_rxd);
  endproperty
  assert property(af_p855);

  property af_p856;
  @(posedge clk_xgmii_rx) (!reset_xgmii_rx_n) |-> (xgmii_rxd[63:0] >= 64'h0 && xgmii_rxd[63:0] <= 64'hFFFFFFFFFFFFFFFF);
  endproperty
  assert property(af_p856);

  property af_p857;
  @(posedge clk_xgmii_tx) 1'b1 |-> $stable(xgmii_txc) until_with $rose(clk_xgmii_tx);
  endproperty
  assert property(af_p857);

  property af_p858;
  @(posedge clk_xgmii_tx) (!pkt_tx_val) |-> (xgmii_txc == 8'hFF);
  endproperty
  assert property(af_p858);

  property af_p859;
  @(posedge clk_xgmii_tx) ((xgmii_txc >= 0) && (xgmii_txc <= 127)) |=> (xgmii_txc >= 0) && (xgmii_txc <= 255);
  endproperty
  assert property(af_p859);



  property af_p862;
  @(posedge clk_xgmii_tx) (reset_xgmii_tx_n) |-> (xgmii_txc >= 0) && (xgmii_txc <= 255);
  endproperty
  assert property(af_p862);

  property af_p863;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |-> (xgmii_txc >= 0) && (xgmii_txc <= 255);
  endproperty
  assert property(af_p863);

  property af_p864;
  @(posedge clk_xgmii_tx) (xgmii_txc == 8'hFF) |=> ((xgmii_txc == 8'h00) && (xgmii_txc >= 0) && (xgmii_txc <= 255));
  endproperty
  assert property(af_p864);

  property af_p865;
  @(posedge clk_xgmii_tx) $changed(xgmii_txc) |-> ##1 $stable(xgmii_txc);
  endproperty
  assert property(af_p865);

  property af_p866;
  @(posedge clk_xgmii_tx) $fell(reset_xgmii_tx_n) |-> (xgmii_txc == 8'hFF) ##1 (xgmii_txc == 8'hFF) ##1 (xgmii_txc == 8'hFF);
  endproperty
  assert property(af_p866);

  property af_p867;
  @(posedge clk_xgmii_tx) (pkt_tx_val) |-> (xgmii_txc >= 8'h00 && xgmii_txc <= 8'hFF);
  endproperty
  assert property(af_p867);

  property af_p868;
  @(posedge clk_xgmii_tx) (pkt_tx_sop) |-> (xgmii_txc >= 8'h00 && xgmii_txc <= 8'hFF);
  endproperty
  assert property(af_p868);

  property af_p869;
  @(posedge clk_xgmii_tx) (pkt_tx_full) |-> (xgmii_txc != 8'h00);
  endproperty
  assert property(af_p869);

  property af_p870;
  @(posedge clk_xgmii_tx) (xgmii_txc >= 8'h00 && xgmii_txc <= 8'h7F) |-> ##1 (xgmii_txc >= 8'h00 && xgmii_txc <= 8'hFF);
  endproperty
  assert property(af_p870);

  property af_p871;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> (xgmii_txc == 8'h00) ##1 (xgmii_txc == 8'h00);
  endproperty
  assert property(af_p871);

  property af_p872;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |-> (xgmii_txc >= 8'h00 && xgmii_txc <= 8'hFF);
  endproperty
  assert property(af_p872);

  property af_p873;
  @(posedge clk_xgmii_tx) !$stable(xgmii_txc) |-> $rose(clk_xgmii_tx);
  endproperty
  assert property(af_p873);

  property af_p874;
  @(posedge clk_xgmii_tx) (xgmii_txc == 8'hFF) |-> ##1 (xgmii_txc >= 8'h00 && xgmii_txc <= 8'hFF);
  endproperty
  assert property(af_p874);

  property af_p875;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##4 (xgmii_txc >= 8'h00 && xgmii_txc <= 8'hFF);
  endproperty
  assert property(af_p875);

  property af_p876;
  @(posedge clk_xgmii_tx) (xgmii_txd != 64'h0) |-> (xgmii_txc == 8'h00);
  endproperty
  assert property(af_p876);

  property af_p877;
  @(posedge clk_xgmii_tx) (1'b1) |-> (!$isunknown(xgmii_txc) && !$isunknown(xgmii_txd));
  endproperty
  assert property(af_p877);

  property af_p878;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ((xgmii_txc >= 8'h00) && (xgmii_txc <= 8'hFF))[*4];
  endproperty
  assert property(af_p878);

  property af_p879;
  @(posedge clk_xgmii_tx) (xgmii_txd[7:0] == 8'hFB) |-> (xgmii_txc[0] == 1'b1);
  endproperty
  assert property(af_p879);

  property af_p880;
  @(posedge clk_xgmii_tx) (pkt_tx_sop || pkt_tx_eop) |-> (xgmii_txc != 8'h00);
  endproperty
  assert property(af_p880);

  property af_p881;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> (xgmii_txc == 8'hFF)[*3];
  endproperty
  assert property(af_p881);

  property af_p882;
  @(posedge clk_xgmii_tx) (!pkt_tx_val) |-> ##[0:2] (xgmii_txc == 8'hFF);
  endproperty
  assert property(af_p882);

  property af_p883;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##[1:3] ((xgmii_txc >= 8'h00) && (xgmii_txc <= 8'hFF));
  endproperty
  assert property(af_p883);

  property af_p884;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##4 ((xgmii_txc >= 8'h00) && (xgmii_txc <= 8'hFF));
  endproperty
  assert property(af_p884);

  property af_p885;
  @(posedge clk_xgmii_tx) (pkt_tx_eop) |-> ((xgmii_txc >= 8'h00) && (xgmii_txc <= 8'hFF));
  endproperty
  assert property(af_p885);

  property af_p886;
  @(posedge clk_xgmii_tx) (|xgmii_txc) |-> (xgmii_txc != 8'h00);
  endproperty
  assert property(af_p886);

  property af_p887;
  @(posedge clk_xgmii_tx) (!xgmii_txc[0]) |-> (xgmii_txd[7:0] >= 8'h00 && xgmii_txd[7:0] <= 8'hFF);
  endproperty
  assert property(af_p887);

  property af_p888;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> (xgmii_txd == 64'h0)[*2];
  endproperty
  assert property(af_p888);

  property af_p889;
  @(posedge clk_xgmii_tx) pkt_tx_sop |=> (xgmii_txc[0] && (xgmii_txd[7:0] == 8'hFB));
  endproperty
  assert property(af_p889);

  property af_p890;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |-> (xgmii_txd == 64'h0);
  endproperty
  assert property(af_p890);

  property af_p891;
  @(posedge clk_xgmii_tx) (reset_xgmii_tx_n) |-> (xgmii_txd >= 64'h0000000000000000 && xgmii_txd <= 64'hFFFFFFFFFFFFFFFF);
  endproperty
  assert property(af_p891);

  property af_p892;
  @(posedge clk_xgmii_tx) (xgmii_txc[0]) |-> (xgmii_txd[7:0] inside {8'h07, 8'hFB, 8'hFD, 8'hFE, 8'h9C});
  endproperty
  assert property(af_p892);

  property af_p893;
  @(posedge clk_xgmii_tx) pkt_tx_sop |-> (xgmii_txc[0] && (xgmii_txd[7:0] == 8'hFB));
  endproperty
  assert property(af_p893);

  property af_p894;
  @(posedge clk_xgmii_tx) (!pkt_tx_val && !$past(pkt_tx_val)) |-> (xgmii_txd == $past(xgmii_txd));
  endproperty
  assert property(af_p894);

  property af_p895;
  @(posedge clk_xgmii_tx) pkt_tx_full |-> ((xgmii_txc == 8'hFF) && (xgmii_txd == {8{8'h07}}));
  endproperty
  assert property(af_p895);

  property af_p896;
  @(posedge clk_xgmii_tx) (xgmii_txc == 8'hFF) |-> (xgmii_txd == {8{8'h07}});
  endproperty
  assert property(af_p896);


  property af_p898;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##4 ((xgmii_txc == 8'hFF) && (xgmii_txd == 64'h0707070707070707));
  endproperty
  assert property(af_p898);

  property af_p899;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##4 (xgmii_txd == 64'h0707070707070707);
  endproperty
  assert property(af_p899);

  property af_p900;
  @(posedge clk_xgmii_tx) (pkt_tx_eop && (pkt_tx_mod != 0)) |-> ((xgmii_txc & ~((8'b1 << pkt_tx_mod) - 1'b1)) == (~((8'b1 << pkt_tx_mod) - 1'b1)));
  endproperty
  assert property(af_p900);

  property af_p901;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |-> ($stable(xgmii_txd) && (xgmii_txd == 64'h0707070707070707) && (xgmii_txc == 8'hFF));
  endproperty
  assert property(af_p901);


  property af_p903;
  @(posedge clk_xgmii_tx) (!pkt_tx_val) |=> $stable(xgmii_txd);
  endproperty
  assert property(af_p903);

  property af_p904;
  @(posedge clk_xgmii_tx) pkt_tx_full |-> ((xgmii_txc == 8'hFF) && (xgmii_txd == 64'h0707070707070707));
  endproperty
  assert property(af_p904);

  property af_p905;
  @(posedge clk_xgmii_tx) pkt_tx_eop |=> ((xgmii_txd >> (pkt_tx_mod*8)) & 8'hFF) == 8'hFD;
  endproperty
  assert property(af_p905);

  property af_p906;
  @(posedge clk_xgmii_tx) (!reset_xgmii_tx_n) |-> $stable(xgmii_txd);
  endproperty
  assert property(af_p906);



  property af_p909;
  @(posedge clk_xgmii_tx) (pkt_tx_val && $past(pkt_tx_val)) |-> (xgmii_txd == pkt_tx_data);
  endproperty
  assert property(af_p909);

  property af_p910;
  @(posedge clk_xgmii_tx) pkt_tx_eop |-> ((xgmii_txd[(pkt_tx_mod*8) +: 8] == 8'hFD) && (xgmii_txc[pkt_tx_mod] == 1'b1));
  endproperty
  assert property(af_p910);

  property af_p911;
  @(posedge clk_xgmii_tx) pkt_tx_val |=> (xgmii_txd == pkt_tx_data);
  endproperty
  assert property(af_p911);

  property af_p912;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |=> $stable(xgmii_txd);
  endproperty
  assert property(af_p912);

  property af_p913;
  @(posedge clk_xgmii_tx) $rose(reset_xgmii_tx_n) |-> ##[1:2] $stable(xgmii_txd);
  endproperty
  assert property(af_p913);

  property af_p914;
  @(posedge clk_xgmii_tx) reset_xgmii_tx_n |-> !$isunknown(xgmii_txd);
  endproperty
  assert property(af_p914);

  property af_p915;
  @(posedge clk_xgmii_tx) disable iff (reset_xgmii_tx_n) (!reset_xgmii_tx_n) |-> !$isunknown(xgmii_txd);
  endproperty
  assert property(af_p915);

  property af_p916;
  @(posedge clk_xgmii_tx) (!pkt_tx_val) |-> ##1 $stable(xgmii_txd);
  endproperty
  assert property(af_p916);





endmodule
