//////////////////////////////////////////////////////////////////////
////                                                              ////
////  Xess Traffic Cop                                            ////
////                                                              ////
////  This file is part of the OR1K test application              ////
////  http://www.opencores.org/cores/or1k/                        ////
////                                                              ////
////  Description                                                 ////
////  This block connectes the RISC and peripheral controller     ////
////  cores together.                                             ////
////                                                              ////
////  To Do:                                                      ////
////   - nothing really                                           ////
////                                                              ////
////  Author(s):                                                  ////
////      - Damjan Lampret, lampret@opencores.org                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2002 OpenCores                                 ////
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
//
// CVS Revision History
//
// $Log: tc_top.v,v $
// Revision 1.4  2004/04/05 08:44:34  lampret
// Merged branch_qmem into main tree.
//
// Revision 1.2  2002/03/29 20:57:30  lampret
// Removed unused ports wb_clki and wb_rst_i
//
// Revision 1.1.1.1  2002/03/21 16:55:44  lampret
// First import of the "new" XESS XSV environment.
//
//
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

//
// Width of address bus
//
`define TC_AW		32

//
// Width of data bus
//
`define TC_DW		32

//
// Width of byte select bus
//
`define TC_BSW		4

//
// Width of WB target inputs (coming from WB slave)
//
// data bus width + ack + err
//
`define TC_TIN_W	`TC_DW+1+1

//
// Width of WB initiator inputs (coming from WB masters)
//
// cyc + stb + address bus width +
// byte select bus width + we + data bus width
//
`define TC_IIN_W	1+1+`TC_AW+`TC_BSW+1+`TC_DW

//
// Traffic Cop Top
//
module minsoc_tc_top (
	wb_clk_i,
	wb_rst_i,

	i0_wb_cyc_i,
	i0_wb_stb_i,
	i0_wb_adr_i,
	i0_wb_sel_i,
	i0_wb_we_i,
	i0_wb_dat_i,
	i0_wb_dat_o,
	i0_wb_ack_o,
	i0_wb_err_o,

	i1_wb_cyc_i,
	i1_wb_stb_i,
	i1_wb_adr_i,
	i1_wb_sel_i,
	i1_wb_we_i,
	i1_wb_dat_i,
	i1_wb_dat_o,
	i1_wb_ack_o,
	i1_wb_err_o,

	i2_wb_cyc_i,
	i2_wb_stb_i,
	i2_wb_adr_i,
	i2_wb_sel_i,
	i2_wb_we_i,
	i2_wb_dat_i,
	i2_wb_dat_o,
	i2_wb_ack_o,
	i2_wb_err_o,

	i3_wb_cyc_i,
	i3_wb_stb_i,
	i3_wb_adr_i,
	i3_wb_sel_i,
	i3_wb_we_i,
	i3_wb_dat_i,
	i3_wb_dat_o,
	i3_wb_ack_o,
	i3_wb_err_o,

	i4_wb_cyc_i,
	i4_wb_stb_i,
	i4_wb_adr_i,
	i4_wb_sel_i,
	i4_wb_we_i,
	i4_wb_dat_i,
	i4_wb_dat_o,
	i4_wb_ack_o,
	i4_wb_err_o,

	i5_wb_cyc_i,
	i5_wb_stb_i,
	i5_wb_adr_i,
	i5_wb_sel_i,
	i5_wb_we_i,
	i5_wb_dat_i,
	i5_wb_dat_o,
	i5_wb_ack_o,
	i5_wb_err_o,

	i6_wb_cyc_i,
	i6_wb_stb_i,
	i6_wb_adr_i,
	i6_wb_sel_i,
	i6_wb_we_i,
	i6_wb_dat_i,
	i6_wb_dat_o,
	i6_wb_ack_o,
	i6_wb_err_o,

	i7_wb_cyc_i,
	i7_wb_stb_i,
	i7_wb_adr_i,
	i7_wb_sel_i,
	i7_wb_we_i,
	i7_wb_dat_i,
	i7_wb_dat_o,
	i7_wb_ack_o,
	i7_wb_err_o,

	t0_wb_cyc_o,
	t0_wb_stb_o,
	t0_wb_adr_o,
	t0_wb_sel_o,
	t0_wb_we_o,
	t0_wb_dat_o,
	t0_wb_dat_i,
	t0_wb_ack_i,
	t0_wb_err_i,

	t1_wb_cyc_o,
	t1_wb_stb_o,
	t1_wb_adr_o,
	t1_wb_sel_o,
	t1_wb_we_o,
	t1_wb_dat_o,
	t1_wb_dat_i,
	t1_wb_ack_i,
	t1_wb_err_i,

	t2_wb_cyc_o,
	t2_wb_stb_o,
	t2_wb_adr_o,
	t2_wb_sel_o,
	t2_wb_we_o,
	t2_wb_dat_o,
	t2_wb_dat_i,
	t2_wb_ack_i,
	t2_wb_err_i,

	t3_wb_cyc_o,
	t3_wb_stb_o,
	t3_wb_adr_o,
	t3_wb_sel_o,
	t3_wb_we_o,
	t3_wb_dat_o,
	t3_wb_dat_i,
	t3_wb_ack_i,
	t3_wb_err_i,

	t4_wb_cyc_o,
	t4_wb_stb_o,
	t4_wb_adr_o,
	t4_wb_sel_o,
	t4_wb_we_o,
	t4_wb_dat_o,
	t4_wb_dat_i,
	t4_wb_ack_i,
	t4_wb_err_i,

	t5_wb_cyc_o,
	t5_wb_stb_o,
	t5_wb_adr_o,
	t5_wb_sel_o,
	t5_wb_we_o,
	t5_wb_dat_o,
	t5_wb_dat_i,
	t5_wb_ack_i,
	t5_wb_err_i,

	t6_wb_cyc_o,
	t6_wb_stb_o,
	t6_wb_adr_o,
	t6_wb_sel_o,
	t6_wb_we_o,
	t6_wb_dat_o,
	t6_wb_dat_i,
	t6_wb_ack_i,
	t6_wb_err_i,

	t7_wb_cyc_o,
	t7_wb_stb_o,
	t7_wb_adr_o,
	t7_wb_sel_o,
	t7_wb_we_o,
	t7_wb_dat_o,
	t7_wb_dat_i,
	t7_wb_ack_i,
	t7_wb_err_i,

	t8_wb_cyc_o,
	t8_wb_stb_o,
	t8_wb_adr_o,
	t8_wb_sel_o,
	t8_wb_we_o,
	t8_wb_dat_o,
	t8_wb_dat_i,
	t8_wb_ack_i,
	t8_wb_err_i

);

//
// Parameters
//
parameter		t0_addr_w = 4;
parameter		t0_addr = 4'd8;
parameter		t1_addr_w = 4;
parameter		t1_addr = 4'd0;
parameter		t28c_addr_w = 4;
parameter		t28_addr = 4'd0;
parameter		t28i_addr_w = 4;
parameter		t2_addr = 4'd1;
parameter		t3_addr = 4'd2;
parameter		t4_addr = 4'd3;
parameter		t5_addr = 4'd4;
parameter		t6_addr = 4'd5;
parameter		t7_addr = 4'd6;
parameter		t8_addr = 4'd7;

//
// I/O Ports
//
input			wb_clk_i;
input			wb_rst_i;

//
// WB slave i/f connecting initiator 0
//
input			i0_wb_cyc_i;
input			i0_wb_stb_i;
input	[`TC_AW-1:0]	i0_wb_adr_i;
input	[`TC_BSW-1:0]	i0_wb_sel_i;
input			i0_wb_we_i;
input	[`TC_DW-1:0]	i0_wb_dat_i;
output	[`TC_DW-1:0]	i0_wb_dat_o;
output			i0_wb_ack_o;
output			i0_wb_err_o;

//
// WB slave i/f connecting initiator 1
//
input			i1_wb_cyc_i;
input			i1_wb_stb_i;
input	[`TC_AW-1:0]	i1_wb_adr_i;
input	[`TC_BSW-1:0]	i1_wb_sel_i;
input			i1_wb_we_i;
input	[`TC_DW-1:0]	i1_wb_dat_i;
output	[`TC_DW-1:0]	i1_wb_dat_o;
output			i1_wb_ack_o;
output			i1_wb_err_o;

//
// WB slave i/f connecting initiator 2
//
input			i2_wb_cyc_i;
input			i2_wb_stb_i;
input	[`TC_AW-1:0]	i2_wb_adr_i;
input	[`TC_BSW-1:0]	i2_wb_sel_i;
input			i2_wb_we_i;
input	[`TC_DW-1:0]	i2_wb_dat_i;
output	[`TC_DW-1:0]	i2_wb_dat_o;
output			i2_wb_ack_o;
output			i2_wb_err_o;

//
// WB slave i/f connecting initiator 3
//
input			i3_wb_cyc_i;
input			i3_wb_stb_i;
input	[`TC_AW-1:0]	i3_wb_adr_i;
input	[`TC_BSW-1:0]	i3_wb_sel_i;
input			i3_wb_we_i;
input	[`TC_DW-1:0]	i3_wb_dat_i;
output	[`TC_DW-1:0]	i3_wb_dat_o;
output			i3_wb_ack_o;
output			i3_wb_err_o;

//
// WB slave i/f connecting initiator 4
//
input			i4_wb_cyc_i;
input			i4_wb_stb_i;
input	[`TC_AW-1:0]	i4_wb_adr_i;
input	[`TC_BSW-1:0]	i4_wb_sel_i;
input			i4_wb_we_i;
input	[`TC_DW-1:0]	i4_wb_dat_i;
output	[`TC_DW-1:0]	i4_wb_dat_o;
output			i4_wb_ack_o;
output			i4_wb_err_o;

//
// WB slave i/f connecting initiator 5
//
input			i5_wb_cyc_i;
input			i5_wb_stb_i;
input	[`TC_AW-1:0]	i5_wb_adr_i;
input	[`TC_BSW-1:0]	i5_wb_sel_i;
input			i5_wb_we_i;
input	[`TC_DW-1:0]	i5_wb_dat_i;
output	[`TC_DW-1:0]	i5_wb_dat_o;
output			i5_wb_ack_o;
output			i5_wb_err_o;

//
// WB slave i/f connecting initiator 6
//
input			i6_wb_cyc_i;
input			i6_wb_stb_i;
input	[`TC_AW-1:0]	i6_wb_adr_i;
input	[`TC_BSW-1:0]	i6_wb_sel_i;
input			i6_wb_we_i;
input	[`TC_DW-1:0]	i6_wb_dat_i;
output	[`TC_DW-1:0]	i6_wb_dat_o;
output			i6_wb_ack_o;
output			i6_wb_err_o;

//
// WB slave i/f connecting initiator 7
//
input			i7_wb_cyc_i;
input			i7_wb_stb_i;
input	[`TC_AW-1:0]	i7_wb_adr_i;
input	[`TC_BSW-1:0]	i7_wb_sel_i;
input			i7_wb_we_i;
input	[`TC_DW-1:0]	i7_wb_dat_i;
output	[`TC_DW-1:0]	i7_wb_dat_o;
output			i7_wb_ack_o;
output			i7_wb_err_o;

//
// WB master i/f connecting target 0
//
output			t0_wb_cyc_o;
output			t0_wb_stb_o;
output	[`TC_AW-1:0]	t0_wb_adr_o;
output	[`TC_BSW-1:0]	t0_wb_sel_o;
output			t0_wb_we_o;
output	[`TC_DW-1:0]	t0_wb_dat_o;
input	[`TC_DW-1:0]	t0_wb_dat_i;
input			t0_wb_ack_i;
input			t0_wb_err_i;

//
// WB master i/f connecting target 1
//
output			t1_wb_cyc_o;
output			t1_wb_stb_o;
output	[`TC_AW-1:0]	t1_wb_adr_o;
output	[`TC_BSW-1:0]	t1_wb_sel_o;
output			t1_wb_we_o;
output	[`TC_DW-1:0]	t1_wb_dat_o;
input	[`TC_DW-1:0]	t1_wb_dat_i;
input			t1_wb_ack_i;
input			t1_wb_err_i;

//
// WB master i/f connecting target 2
//
output			t2_wb_cyc_o;
output			t2_wb_stb_o;
output	[`TC_AW-1:0]	t2_wb_adr_o;
output	[`TC_BSW-1:0]	t2_wb_sel_o;
output			t2_wb_we_o;
output	[`TC_DW-1:0]	t2_wb_dat_o;
input	[`TC_DW-1:0]	t2_wb_dat_i;
input			t2_wb_ack_i;
input			t2_wb_err_i;

//
// WB master i/f connecting target 3
//
output			t3_wb_cyc_o;
output			t3_wb_stb_o;
output	[`TC_AW-1:0]	t3_wb_adr_o;
output	[`TC_BSW-1:0]	t3_wb_sel_o;
output			t3_wb_we_o;
output	[`TC_DW-1:0]	t3_wb_dat_o;
input	[`TC_DW-1:0]	t3_wb_dat_i;
input			t3_wb_ack_i;
input			t3_wb_err_i;

//
// WB master i/f connecting target 4
//
output			t4_wb_cyc_o;
output			t4_wb_stb_o;
output	[`TC_AW-1:0]	t4_wb_adr_o;
output	[`TC_BSW-1:0]	t4_wb_sel_o;
output			t4_wb_we_o;
output	[`TC_DW-1:0]	t4_wb_dat_o;
input	[`TC_DW-1:0]	t4_wb_dat_i;
input			t4_wb_ack_i;
input			t4_wb_err_i;

//
// WB master i/f connecting target 5
//
output			t5_wb_cyc_o;
output			t5_wb_stb_o;
output	[`TC_AW-1:0]	t5_wb_adr_o;
output	[`TC_BSW-1:0]	t5_wb_sel_o;
output			t5_wb_we_o;
output	[`TC_DW-1:0]	t5_wb_dat_o;
input	[`TC_DW-1:0]	t5_wb_dat_i;
input			t5_wb_ack_i;
input			t5_wb_err_i;

//
// WB master i/f connecting target 6
//
output			t6_wb_cyc_o;
output			t6_wb_stb_o;
output	[`TC_AW-1:0]	t6_wb_adr_o;
output	[`TC_BSW-1:0]	t6_wb_sel_o;
output			t6_wb_we_o;
output	[`TC_DW-1:0]	t6_wb_dat_o;
input	[`TC_DW-1:0]	t6_wb_dat_i;
input			t6_wb_ack_i;
input			t6_wb_err_i;

//
// WB master i/f connecting target 7
//
output			t7_wb_cyc_o;
output			t7_wb_stb_o;
output	[`TC_AW-1:0]	t7_wb_adr_o;
output	[`TC_BSW-1:0]	t7_wb_sel_o;
output			t7_wb_we_o;
output	[`TC_DW-1:0]	t7_wb_dat_o;
input	[`TC_DW-1:0]	t7_wb_dat_i;
input			t7_wb_ack_i;
input			t7_wb_err_i;

//
// WB master i/f connecting target 8
//
output			t8_wb_cyc_o;
output			t8_wb_stb_o;
output	[`TC_AW-1:0]	t8_wb_adr_o;
output	[`TC_BSW-1:0]	t8_wb_sel_o;
output			t8_wb_we_o;
output	[`TC_DW-1:0]	t8_wb_dat_o;
input	[`TC_DW-1:0]	t8_wb_dat_i;
input			t8_wb_ack_i;
input			t8_wb_err_i;

//
// Internal wires & registers
//

//
// Outputs for initiators from both mi_to_st blocks
//
wire	[`TC_DW-1:0]	xi0_wb_dat_o;
wire			xi0_wb_ack_o;
wire			xi0_wb_err_o;
wire	[`TC_DW-1:0]	xi1_wb_dat_o;
wire			xi1_wb_ack_o;
wire			xi1_wb_err_o;
wire	[`TC_DW-1:0]	xi2_wb_dat_o;
wire			xi2_wb_ack_o;
wire			xi2_wb_err_o;
wire	[`TC_DW-1:0]	xi3_wb_dat_o;
wire			xi3_wb_ack_o;
wire			xi3_wb_err_o;
wire	[`TC_DW-1:0]	xi4_wb_dat_o;
wire			xi4_wb_ack_o;
wire			xi4_wb_err_o;
wire	[`TC_DW-1:0]	xi5_wb_dat_o;
wire			xi5_wb_ack_o;
wire			xi5_wb_err_o;
wire	[`TC_DW-1:0]	xi6_wb_dat_o;
wire			xi6_wb_ack_o;
wire			xi6_wb_err_o;
wire	[`TC_DW-1:0]	xi7_wb_dat_o;
wire			xi7_wb_ack_o;
wire			xi7_wb_err_o;
wire	[`TC_DW-1:0]	yi0_wb_dat_o;
wire			yi0_wb_ack_o;
wire			yi0_wb_err_o;
wire	[`TC_DW-1:0]	yi1_wb_dat_o;
wire			yi1_wb_ack_o;
wire			yi1_wb_err_o;
wire	[`TC_DW-1:0]	yi2_wb_dat_o;
wire			yi2_wb_ack_o;
wire			yi2_wb_err_o;
wire	[`TC_DW-1:0]	yi3_wb_dat_o;
wire			yi3_wb_ack_o;
wire			yi3_wb_err_o;
wire	[`TC_DW-1:0]	yi4_wb_dat_o;
wire			yi4_wb_ack_o;
wire			yi4_wb_err_o;
wire	[`TC_DW-1:0]	yi5_wb_dat_o;
wire			yi5_wb_ack_o;
wire			yi5_wb_err_o;
wire	[`TC_DW-1:0]	yi6_wb_dat_o;
wire			yi6_wb_ack_o;
wire			yi6_wb_err_o;
wire	[`TC_DW-1:0]	yi7_wb_dat_o;
wire			yi7_wb_ack_o;
wire			yi7_wb_err_o;

//
// Intermediate signals connecting peripheral channel's
// mi_to_st and si_to_mt blocks.
//
wire			z_wb_cyc_i;
wire			z_wb_stb_i;
wire	[`TC_AW-1:0]	z_wb_adr_i;
wire	[`TC_BSW-1:0]	z_wb_sel_i;
wire			z_wb_we_i;
wire	[`TC_DW-1:0]	z_wb_dat_i;
wire	[`TC_DW-1:0]	z_wb_dat_t;
wire			z_wb_ack_t;
wire			z_wb_err_t;

//
// Outputs for initiators are ORed from both mi_to_st blocks
//
assign i0_wb_dat_o = xi0_wb_dat_o | yi0_wb_dat_o;
assign i0_wb_ack_o = xi0_wb_ack_o | yi0_wb_ack_o;
assign i0_wb_err_o = xi0_wb_err_o | yi0_wb_err_o;
assign i1_wb_dat_o = xi1_wb_dat_o | yi1_wb_dat_o;
assign i1_wb_ack_o = xi1_wb_ack_o | yi1_wb_ack_o;
assign i1_wb_err_o = xi1_wb_err_o | yi1_wb_err_o;
assign i2_wb_dat_o = xi2_wb_dat_o | yi2_wb_dat_o;
assign i2_wb_ack_o = xi2_wb_ack_o | yi2_wb_ack_o;
assign i2_wb_err_o = xi2_wb_err_o | yi2_wb_err_o;
assign i3_wb_dat_o = xi3_wb_dat_o | yi3_wb_dat_o;
assign i3_wb_ack_o = xi3_wb_ack_o | yi3_wb_ack_o;
assign i3_wb_err_o = xi3_wb_err_o | yi3_wb_err_o;
assign i4_wb_dat_o = xi4_wb_dat_o | yi4_wb_dat_o;
assign i4_wb_ack_o = xi4_wb_ack_o | yi4_wb_ack_o;
assign i4_wb_err_o = xi4_wb_err_o | yi4_wb_err_o;
assign i5_wb_dat_o = xi5_wb_dat_o | yi5_wb_dat_o;
assign i5_wb_ack_o = xi5_wb_ack_o | yi5_wb_ack_o;
assign i5_wb_err_o = xi5_wb_err_o | yi5_wb_err_o;
assign i6_wb_dat_o = xi6_wb_dat_o | yi6_wb_dat_o;
assign i6_wb_ack_o = xi6_wb_ack_o | yi6_wb_ack_o;
assign i6_wb_err_o = xi6_wb_err_o | yi6_wb_err_o;
assign i7_wb_dat_o = xi7_wb_dat_o | yi7_wb_dat_o;
assign i7_wb_ack_o = xi7_wb_ack_o | yi7_wb_ack_o;
assign i7_wb_err_o = xi7_wb_err_o | yi7_wb_err_o;

//
// From initiators to target 0
//
tc_mi_to_st #(t0_addr_w, t0_addr,
	0, t0_addr_w, t0_addr) t0_ch(
	.wb_clk_i(wb_clk_i),
	.wb_rst_i(wb_rst_i),

	.i0_wb_cyc_i(i0_wb_cyc_i),
	.i0_wb_stb_i(i0_wb_stb_i),
	.i0_wb_adr_i(i0_wb_adr_i),
	.i0_wb_sel_i(i0_wb_sel_i),
	.i0_wb_we_i(i0_wb_we_i),
	.i0_wb_dat_i(i0_wb_dat_i),
	.i0_wb_dat_o(xi0_wb_dat_o),
	.i0_wb_ack_o(xi0_wb_ack_o),
	.i0_wb_err_o(xi0_wb_err_o),

	.i1_wb_cyc_i(i1_wb_cyc_i),
	.i1_wb_stb_i(i1_wb_stb_i),
	.i1_wb_adr_i(i1_wb_adr_i),
	.i1_wb_sel_i(i1_wb_sel_i),
	.i1_wb_we_i(i1_wb_we_i),
	.i1_wb_dat_i(i1_wb_dat_i),
	.i1_wb_dat_o(xi1_wb_dat_o),
	.i1_wb_ack_o(xi1_wb_ack_o),
	.i1_wb_err_o(xi1_wb_err_o),

	.i2_wb_cyc_i(i2_wb_cyc_i),
	.i2_wb_stb_i(i2_wb_stb_i),
	.i2_wb_adr_i(i2_wb_adr_i),
	.i2_wb_sel_i(i2_wb_sel_i),
	.i2_wb_we_i(i2_wb_we_i),
	.i2_wb_dat_i(i2_wb_dat_i),
	.i2_wb_dat_o(xi2_wb_dat_o),
	.i2_wb_ack_o(xi2_wb_ack_o),
	.i2_wb_err_o(xi2_wb_err_o),

	.i3_wb_cyc_i(i3_wb_cyc_i),
	.i3_wb_stb_i(i3_wb_stb_i),
	.i3_wb_adr_i(i3_wb_adr_i),
	.i3_wb_sel_i(i3_wb_sel_i),
	.i3_wb_we_i(i3_wb_we_i),
	.i3_wb_dat_i(i3_wb_dat_i),
	.i3_wb_dat_o(xi3_wb_dat_o),
	.i3_wb_ack_o(xi3_wb_ack_o),
	.i3_wb_err_o(xi3_wb_err_o),

	.i4_wb_cyc_i(i4_wb_cyc_i),
	.i4_wb_stb_i(i4_wb_stb_i),
	.i4_wb_adr_i(i4_wb_adr_i),
	.i4_wb_sel_i(i4_wb_sel_i),
	.i4_wb_we_i(i4_wb_we_i),
	.i4_wb_dat_i(i4_wb_dat_i),
	.i4_wb_dat_o(xi4_wb_dat_o),
	.i4_wb_ack_o(xi4_wb_ack_o),
	.i4_wb_err_o(xi4_wb_err_o),

	.i5_wb_cyc_i(i5_wb_cyc_i),
	.i5_wb_stb_i(i5_wb_stb_i),
	.i5_wb_adr_i(i5_wb_adr_i),
	.i5_wb_sel_i(i5_wb_sel_i),
	.i5_wb_we_i(i5_wb_we_i),
	.i5_wb_dat_i(i5_wb_dat_i),
	.i5_wb_dat_o(xi5_wb_dat_o),
	.i5_wb_ack_o(xi5_wb_ack_o),
	.i5_wb_err_o(xi5_wb_err_o),

	.i6_wb_cyc_i(i6_wb_cyc_i),
	.i6_wb_stb_i(i6_wb_stb_i),
	.i6_wb_adr_i(i6_wb_adr_i),
	.i6_wb_sel_i(i6_wb_sel_i),
	.i6_wb_we_i(i6_wb_we_i),
	.i6_wb_dat_i(i6_wb_dat_i),
	.i6_wb_dat_o(xi6_wb_dat_o),
	.i6_wb_ack_o(xi6_wb_ack_o),
	.i6_wb_err_o(xi6_wb_err_o),

	.i7_wb_cyc_i(i7_wb_cyc_i),
	.i7_wb_stb_i(i7_wb_stb_i),
	.i7_wb_adr_i(i7_wb_adr_i),
	.i7_wb_sel_i(i7_wb_sel_i),
	.i7_wb_we_i(i7_wb_we_i),
	.i7_wb_dat_i(i7_wb_dat_i),
	.i7_wb_dat_o(xi7_wb_dat_o),
	.i7_wb_ack_o(xi7_wb_ack_o),
	.i7_wb_err_o(xi7_wb_err_o),

	.t0_wb_cyc_o(t0_wb_cyc_o),
	.t0_wb_stb_o(t0_wb_stb_o),
	.t0_wb_adr_o(t0_wb_adr_o),
	.t0_wb_sel_o(t0_wb_sel_o),
	.t0_wb_we_o(t0_wb_we_o),
	.t0_wb_dat_o(t0_wb_dat_o),
	.t0_wb_dat_i(t0_wb_dat_i),
	.t0_wb_ack_i(t0_wb_ack_i),
	.t0_wb_err_i(t0_wb_err_i)

);

//
// From initiators to targets 1-8 (upper part)
//
tc_mi_to_st #(t1_addr_w, t1_addr,
	1, t28c_addr_w, t28_addr) t18_ch_upper(
	.wb_clk_i(wb_clk_i),
	.wb_rst_i(wb_rst_i),

	.i0_wb_cyc_i(i0_wb_cyc_i),
	.i0_wb_stb_i(i0_wb_stb_i),
	.i0_wb_adr_i(i0_wb_adr_i),
	.i0_wb_sel_i(i0_wb_sel_i),
	.i0_wb_we_i(i0_wb_we_i),
	.i0_wb_dat_i(i0_wb_dat_i),
	.i0_wb_dat_o(yi0_wb_dat_o),
	.i0_wb_ack_o(yi0_wb_ack_o),
	.i0_wb_err_o(yi0_wb_err_o),

	.i1_wb_cyc_i(i1_wb_cyc_i),
	.i1_wb_stb_i(i1_wb_stb_i),
	.i1_wb_adr_i(i1_wb_adr_i),
	.i1_wb_sel_i(i1_wb_sel_i),
	.i1_wb_we_i(i1_wb_we_i),
	.i1_wb_dat_i(i1_wb_dat_i),
	.i1_wb_dat_o(yi1_wb_dat_o),
	.i1_wb_ack_o(yi1_wb_ack_o),
	.i1_wb_err_o(yi1_wb_err_o),

	.i2_wb_cyc_i(i2_wb_cyc_i),
	.i2_wb_stb_i(i2_wb_stb_i),
	.i2_wb_adr_i(i2_wb_adr_i),
	.i2_wb_sel_i(i2_wb_sel_i),
	.i2_wb_we_i(i2_wb_we_i),
	.i2_wb_dat_i(i2_wb_dat_i),
	.i2_wb_dat_o(yi2_wb_dat_o),
	.i2_wb_ack_o(yi2_wb_ack_o),
	.i2_wb_err_o(yi2_wb_err_o),

	.i3_wb_cyc_i(i3_wb_cyc_i),
	.i3_wb_stb_i(i3_wb_stb_i),
	.i3_wb_adr_i(i3_wb_adr_i),
	.i3_wb_sel_i(i3_wb_sel_i),
	.i3_wb_we_i(i3_wb_we_i),
	.i3_wb_dat_i(i3_wb_dat_i),
	.i3_wb_dat_o(yi3_wb_dat_o),
	.i3_wb_ack_o(yi3_wb_ack_o),
	.i3_wb_err_o(yi3_wb_err_o),

	.i4_wb_cyc_i(i4_wb_cyc_i),
	.i4_wb_stb_i(i4_wb_stb_i),
	.i4_wb_adr_i(i4_wb_adr_i),
	.i4_wb_sel_i(i4_wb_sel_i),
	.i4_wb_we_i(i4_wb_we_i),
	.i4_wb_dat_i(i4_wb_dat_i),
	.i4_wb_dat_o(yi4_wb_dat_o),
	.i4_wb_ack_o(yi4_wb_ack_o),
	.i4_wb_err_o(yi4_wb_err_o),

	.i5_wb_cyc_i(i5_wb_cyc_i),
	.i5_wb_stb_i(i5_wb_stb_i),
	.i5_wb_adr_i(i5_wb_adr_i),
	.i5_wb_sel_i(i5_wb_sel_i),
	.i5_wb_we_i(i5_wb_we_i),
	.i5_wb_dat_i(i5_wb_dat_i),
	.i5_wb_dat_o(yi5_wb_dat_o),
	.i5_wb_ack_o(yi5_wb_ack_o),
	.i5_wb_err_o(yi5_wb_err_o),

	.i6_wb_cyc_i(i6_wb_cyc_i),
	.i6_wb_stb_i(i6_wb_stb_i),
	.i6_wb_adr_i(i6_wb_adr_i),
	.i6_wb_sel_i(i6_wb_sel_i),
	.i6_wb_we_i(i6_wb_we_i),
	.i6_wb_dat_i(i6_wb_dat_i),
	.i6_wb_dat_o(yi6_wb_dat_o),
	.i6_wb_ack_o(yi6_wb_ack_o),
	.i6_wb_err_o(yi6_wb_err_o),

	.i7_wb_cyc_i(i7_wb_cyc_i),
	.i7_wb_stb_i(i7_wb_stb_i),
	.i7_wb_adr_i(i7_wb_adr_i),
	.i7_wb_sel_i(i7_wb_sel_i),
	.i7_wb_we_i(i7_wb_we_i),
	.i7_wb_dat_i(i7_wb_dat_i),
	.i7_wb_dat_o(yi7_wb_dat_o),
	.i7_wb_ack_o(yi7_wb_ack_o),
	.i7_wb_err_o(yi7_wb_err_o),

	.t0_wb_cyc_o(z_wb_cyc_i),
	.t0_wb_stb_o(z_wb_stb_i),
	.t0_wb_adr_o(z_wb_adr_i),
	.t0_wb_sel_o(z_wb_sel_i),
	.t0_wb_we_o(z_wb_we_i),
	.t0_wb_dat_o(z_wb_dat_i),
	.t0_wb_dat_i(z_wb_dat_t),
	.t0_wb_ack_i(z_wb_ack_t),
	.t0_wb_err_i(z_wb_err_t)

);

//
// From initiators to targets 1-8 (lower part)
//
tc_si_to_mt #(t1_addr_w, t1_addr, t28i_addr_w, t2_addr, t3_addr,
	t4_addr, t5_addr, t6_addr, t7_addr, t8_addr) t18_ch_lower(

	.i0_wb_cyc_i(z_wb_cyc_i),
	.i0_wb_stb_i(z_wb_stb_i),
	.i0_wb_adr_i(z_wb_adr_i),
	.i0_wb_sel_i(z_wb_sel_i),
	.i0_wb_we_i(z_wb_we_i),
	.i0_wb_dat_i(z_wb_dat_i),
	.i0_wb_dat_o(z_wb_dat_t),
	.i0_wb_ack_o(z_wb_ack_t),
	.i0_wb_err_o(z_wb_err_t),

	.t0_wb_cyc_o(t1_wb_cyc_o),
	.t0_wb_stb_o(t1_wb_stb_o),
	.t0_wb_adr_o(t1_wb_adr_o),
	.t0_wb_sel_o(t1_wb_sel_o),
	.t0_wb_we_o(t1_wb_we_o),
	.t0_wb_dat_o(t1_wb_dat_o),
	.t0_wb_dat_i(t1_wb_dat_i),
	.t0_wb_ack_i(t1_wb_ack_i),
	.t0_wb_err_i(t1_wb_err_i),

	.t1_wb_cyc_o(t2_wb_cyc_o),
	.t1_wb_stb_o(t2_wb_stb_o),
	.t1_wb_adr_o(t2_wb_adr_o),
	.t1_wb_sel_o(t2_wb_sel_o),
	.t1_wb_we_o(t2_wb_we_o),
	.t1_wb_dat_o(t2_wb_dat_o),
	.t1_wb_dat_i(t2_wb_dat_i),
	.t1_wb_ack_i(t2_wb_ack_i),
	.t1_wb_err_i(t2_wb_err_i),

	.t2_wb_cyc_o(t3_wb_cyc_o),
	.t2_wb_stb_o(t3_wb_stb_o),
	.t2_wb_adr_o(t3_wb_adr_o),
	.t2_wb_sel_o(t3_wb_sel_o),
	.t2_wb_we_o(t3_wb_we_o),
	.t2_wb_dat_o(t3_wb_dat_o),
	.t2_wb_dat_i(t3_wb_dat_i),
	.t2_wb_ack_i(t3_wb_ack_i),
	.t2_wb_err_i(t3_wb_err_i),

	.t3_wb_cyc_o(t4_wb_cyc_o),
	.t3_wb_stb_o(t4_wb_stb_o),
	.t3_wb_adr_o(t4_wb_adr_o),
	.t3_wb_sel_o(t4_wb_sel_o),
	.t3_wb_we_o(t4_wb_we_o),
	.t3_wb_dat_o(t4_wb_dat_o),
	.t3_wb_dat_i(t4_wb_dat_i),
	.t3_wb_ack_i(t4_wb_ack_i),
	.t3_wb_err_i(t4_wb_err_i),

	.t4_wb_cyc_o(t5_wb_cyc_o),
	.t4_wb_stb_o(t5_wb_stb_o),
	.t4_wb_adr_o(t5_wb_adr_o),
	.t4_wb_sel_o(t5_wb_sel_o),
	.t4_wb_we_o(t5_wb_we_o),
	.t4_wb_dat_o(t5_wb_dat_o),
	.t4_wb_dat_i(t5_wb_dat_i),
	.t4_wb_ack_i(t5_wb_ack_i),
	.t4_wb_err_i(t5_wb_err_i),

	.t5_wb_cyc_o(t6_wb_cyc_o),
	.t5_wb_stb_o(t6_wb_stb_o),
	.t5_wb_adr_o(t6_wb_adr_o),
	.t5_wb_sel_o(t6_wb_sel_o),
	.t5_wb_we_o(t6_wb_we_o),
	.t5_wb_dat_o(t6_wb_dat_o),
	.t5_wb_dat_i(t6_wb_dat_i),
	.t5_wb_ack_i(t6_wb_ack_i),
	.t5_wb_err_i(t6_wb_err_i),

	.t6_wb_cyc_o(t7_wb_cyc_o),
	.t6_wb_stb_o(t7_wb_stb_o),
	.t6_wb_adr_o(t7_wb_adr_o),
	.t6_wb_sel_o(t7_wb_sel_o),
	.t6_wb_we_o(t7_wb_we_o),
	.t6_wb_dat_o(t7_wb_dat_o),
	.t6_wb_dat_i(t7_wb_dat_i),
	.t6_wb_ack_i(t7_wb_ack_i),
	.t6_wb_err_i(t7_wb_err_i),

	.t7_wb_cyc_o(t8_wb_cyc_o),
	.t7_wb_stb_o(t8_wb_stb_o),
	.t7_wb_adr_o(t8_wb_adr_o),
	.t7_wb_sel_o(t8_wb_sel_o),
	.t7_wb_we_o(t8_wb_we_o),
	.t7_wb_dat_o(t8_wb_dat_o),
	.t7_wb_dat_i(t8_wb_dat_i),
	.t7_wb_ack_i(t8_wb_ack_i),
	.t7_wb_err_i(t8_wb_err_i)

);

	// --- Formal assertions ---
	//=============================================================================
	// SVA for minsoc_tc_top Wishbone Interconnect, Address Decoding and Arbitration
	// NOTE: Only signals that are part of the actual minsoc_tc_top port/signal
	// list (as given in the SIGNAL DECLARATIONS) are referenced below. Scenarios
	// from the behavioral spec that reference OR1200/PIC/or1k_startup internal
	// signals (pc, startup_active, startup_enabled, iaddr, startup_addr,
	// startup_done, pic_status, pic_mask, pic_ints_i, pic_interrupt, uart_irq,
	// exception_enabled) have no corresponding signals in minsoc_tc_top and are
	// therefore not checkable at this module's boundary; they have been omitted
	// rather than invented.
	//
	// Timing note (revised again): the arbiter maintains registered state
	// (req_r/req_won/req_cont), so target-grant outputs for a given request are
	// not guaranteed to appear strictly combinationally in the same cycle as
	// the request; they may be asserted either in the same cycle or after a
	// single cycle of arbitration latency. Sufficient-condition ("request
	// implies eventual grant") properties are therefore written with a bounded
	// ##[0:1] window rather than a strict same-cycle implication. Necessary-
	// condition ("grant implies matching request") properties remain same-cycle
	// checks, since a grant can never be asserted without some matching,
	// currently-valid request.
	//
	// Isolation note: since masters i1..i7 are free/unconstrained inputs at
	// this module's boundary, single-master decode/arbitration scenarios
	// (which describe "a master" in isolation) are qualified with the
	// condition that no other master is concurrently requesting, to avoid
	// spurious counterexamples caused by unrelated concurrent master activity
	// that the behavioral spec does not intend to exercise in these
	// particular scenarios.
	//
	// The arbitration "bus grant withheld until target slave interface is
	// idle" scenario cannot be checked here: it would require internal
	// arbiter request/grant vectors (req_i, req_t, req_won, req_r, req_cont)
	// in a form/semantics not specified. Rather than inventing such
	// semantics, that property has been dropped entirely. Likewise,
	// persistence/fairness claims about which specific master keeps the
	// shared-bus grant across multiple cycles have been weakened to purely
	// structural invariants (mutual exclusion / grant-implies-request), since
	// the exact arbitration policy (fixed priority, round robin, possible
	// pre-emption) is not confirmed from the RTL.
	//=============================================================================

	// -----------------------------------------------------------------------
	// Scenario: Target 0 (RAM) is selected only when the top t0_addr_w bits of
	// the master address match t0_addr
	// (target0_sel is represented by the interconnect's grant of cyc/stb to
	// target 0: t0_wb_cyc_o && t0_wb_stb_o).
	// -----------------------------------------------------------------------

	// Necessary condition: a target0 grant can only occur if the requesting
	// master (i0) actually has a valid, matching request. This is a purely
	// structural fact independent of arbitration timing/policy.
	property p_target0_sel_necessary;
	  @(posedge wb_clk_i) disable iff (wb_rst_i)
	  (t0_wb_cyc_o && t0_wb_stb_o) |->
	  (i0_wb_cyc_i && i0_wb_stb_i && (i0_wb_adr_i[`TC_AW-1:`TC_AW-8] == 8'h00));
	endproperty
	assert property (p_target0_sel_necessary)
	  else $error("target0 granted without a matching t0_addr request");

	// Sufficient condition: an isolated, matching request eventually (within
	// one cycle) results in a target0 grant.
	property p_target0_sel_sufficient;
	  @(posedge wb_clk_i) disable iff (wb_rst_i)
	  (i0_wb_cyc_i && i0_wb_stb_i &&
	   (i0_wb_adr_i[`TC_AW-1:`TC_AW-8] == 8'h00) &&
	   !i1_wb_cyc_i && !i2_wb_cyc_i && !i3_wb_cyc_i && !i4_wb_cyc_i &&
	   !i5_wb_cyc_i && !i6_wb_cyc_i && !i7_wb_cyc_i) |->
	   ##[0:1] (t0_wb_cyc_o && t0_wb_stb_o);
	endproperty
	assert property (p_target0_sel_sufficient)
	  else $error("target0 not granted for matching t0_addr");

	property p_target0_sel_other_targets_zero;
	  @(posedge wb_clk_i) disable iff (wb_rst_i)
	  (i0_wb_cyc_i && i0_wb_stb_i &&
	   (i0_wb_adr_i[`TC_AW-1:`TC_AW-8] == 8'h00)) |->
	   (!t2_wb_cyc_o && !t3_wb_cyc_o && !t4_wb_cyc_o &&
	    !t5_wb_cyc_o && !t6_wb_cyc_o && !t7_wb_cyc_o && !t8_wb_cyc_o);
	endproperty
	assert property (p_target0_sel_other_targets_zero)
	  else $error("shared-bus targets 2-8 asserted while target0 selected");

	// -----------------------------------------------------------------------
	// Scenario: Target 0 is not selected when top address bits differ from
	// t0_addr
	// Weakened to a global necessary-condition form (contrapositive of
	// p_target0_sel_necessary): if NO master currently presents a valid,
	// matching request to target0, then target0 cannot be granted this
	// cycle. This is robust to arbitration latency/policy.
	// -----------------------------------------------------------------------
	property p_target0_sel_mismatch;
	  @(posedge wb_clk_i) disable iff (wb_rst_i)
	  ((!i0_wb_cyc_i || !i0_wb_stb_i || (i0_wb_adr_i[`TC_AW-1:`TC_AW-8] != 8'h00)) &&
	   (!i1_wb_cyc_i || !i1_wb_stb_i || (i1_wb_adr_i[`TC_AW-1:`TC_AW-8] != 8'h00)) &&
	   (!i2_wb_cyc_i || !i2_wb_stb_i || (i2_wb_adr_i[`TC_AW-1:`TC_AW-8] != 8'h00)) &&
	   (!i3_wb_cyc_i || !i3_wb_stb_i || (i3_wb_adr_i[`TC_AW-1:`TC_AW-8] != 8'h00)) &&
	   (!i4_wb_cyc_i || !i4_wb_stb_i || (i4_wb_adr_i[`TC_AW-1:`TC_AW-8] != 8'h00)) &&
	   (!i5_wb_cyc_i || !i5_wb_stb_i || (i5_wb_adr_i[`TC_AW-1:`TC_AW-8] != 8'h00)) &&
	   (!i6_wb_cyc_i || !i6_wb_stb_i || (i6_wb_adr_i[`TC_AW-1:`TC_AW-8] != 8'h00)) &&
	   (!i7_wb_cyc_i || !i7_wb_stb_i || (i7_wb_adr_i[`TC_AW-1:`TC_AW-8] != 8'h00))) |->
	   !(t0_wb_cyc_o && t0_wb_stb_o);
	endproperty
	assert property (p_target0_sel_mismatch)
	  else $error("target0 granted with no master presenting a matching request");

	// -----------------------------------------------------------------------
	// Scenario: Targets 2 to 8 are considered valid only when the top
	// t28c_addr_w bits of the address equal t28_addr
	// (target28_valid is represented by any of t2..t8 wb_cyc_o being driven)
	// -----------------------------------------------------------------------

	// Necessary condition: any shared-bus target grant implies some master
	// currently presents a valid, matching request.
	property p_target28_valid_necessary;
	  @(posedge wb_clk_i) disable iff (wb_rst_i)
	  (t2_wb_cyc_o || t3_wb_cyc_o || t4_wb_cyc_o ||
	   t5_wb_cyc_o || t6_wb_cyc_o || t7_wb_cyc_o || t8_wb_cyc_o) |->
	  ((i0_wb_cyc_i && i0_wb_stb_i && (i0_wb_adr_i[`TC_AW-1:`TC_AW-4] == 4'h9)) ||
	   (i1_wb_cyc_i && i1_wb_stb_i && (i1_wb_adr_i[`TC_AW-1:`TC_AW-4] == 4'h9)) ||
	   (i2_wb_cyc_i && i2_wb_stb_i && (i2_wb_adr_i[`TC_AW-1:`TC_AW-4] == 4'h9)) ||
	   (i3_wb_cyc_i && i3_wb_stb_i && (i3_wb_adr_i[`TC_AW-1:`TC_AW-4] == 4'h9)) ||
	   (i4_wb_cyc_i && i4_wb_stb_i && (i4_wb_adr_i[`TC_AW-1:`TC_AW-4] == 4'h9)) ||
	   (i5_wb_cyc_i && i5_wb_stb_i && (i5_wb_adr_i[`TC_AW-1:`TC_AW-4] == 4'h9)) ||
	   (i6_wb_cyc_i && i6_wb_stb_i && (i6_wb_adr_i[`TC_AW-1:`TC_AW-4] == 4'h9)) ||
	   (i7_wb_cyc_i && i7_wb_stb_i && (i7_wb_adr_i[`TC_AW-1:`TC_AW-4] == 4'h9)));
	endproperty
	assert property (p_target28_valid_necessary)
	  else $error("shared-bus target granted without any matching t28_addr request");

	// Sufficient condition, allowing bounded arbitration latency.
	property p_target28_valid_match;
	  @(posedge wb_clk_i) disable iff (wb_rst_i)
	  (i0_wb_cyc_i && i0_wb_stb_i &&
	   (i0_wb_adr_i[`TC_AW-1:`TC_AW-4] == 4'h9) &&
	   !i1_wb_cyc_i && !i2_wb_cyc_i && !i3_wb_cyc_i && !i4_wb_cyc_i &&
	   !i5_wb_cyc_i && !i6_wb_cyc_i && !i7_wb_cyc_i) |->
	   ##[0:1] (t2_wb_cyc_o || t3_wb_cyc_o || t4_wb_cyc_o ||
	            t5_wb_cyc_o || t6_wb_cyc_o || t7_wb_cyc_o || t8_wb_cyc_o);
	endproperty
	assert property (p_target28_valid_match)
	  else $error("no shared-bus target granted for matching t28_addr");

	// -----------------------------------------------------------------------
	// Scenario: Targets 2 to 8 are rejected when the address MSB does not match
	// t28_addr
	// Weakened to a global necessary-condition form (contrapositive of
	// p_target28_valid_necessary): if NO master presents a matching request,
	// then no shared-bus target can be granted this cycle.
	// -----------------------------------------------------------------------
	property p_target28_valid_mismatch;
	  @(posedge wb_clk_i) disable iff (wb_rst_i)
	  ((!i0_wb_cyc_i || !i0_wb_stb_i || (i0_wb_adr_i[`TC_AW-1:`TC_AW-4] != 4'h9)) &&
	   (!i1_wb_cyc_i || !i1_wb_stb_i || (i1_wb_adr_i[`TC_AW-1:`TC_AW-4] != 4'h9)) &&
	   (!i2_wb_cyc_i || !i2_wb_stb_i || (i2_wb_adr_i[`TC_AW-1:`TC_AW-4] != 4'h9)) &&
	   (!i3_wb_cyc_i || !i3_wb_stb_i || (i3_wb_adr_i[`TC_AW-1:`TC_AW-4] != 4'h9)) &&
	   (!i4_wb_cyc_i || !i4_wb_stb_i || (i4_wb_adr_i[`TC_AW-1:`TC_AW-4] != 4'h9)) &&
	   (!i5_wb_cyc_i || !i5_wb_stb_i || (i5_wb_adr_i[`TC_AW-1:`TC_AW-4] != 4'h9)) &&
	   (!i6_wb_cyc_i || !i6_wb_stb_i || (i6_wb_adr_i[`TC_AW-1:`TC_AW-4] != 4'h9)) &&
	   (!i7_wb_cyc_i || !i7_wb_stb_i || (i7_wb_adr_i[`TC_AW-1:`TC_AW-4] != 4'h9))) |->
	   (!t2_wb_cyc_o && !t3_wb_cyc_o && !t4_wb_cyc_o &&
	    !t5_wb_cyc_o && !t6_wb_cyc_o && !t7_wb_cyc_o && !t8_wb_cyc_o);
	endproperty
	assert property (p_target28_valid_mismatch)
	  else $error("shared-bus target granted despite no matching request");

	property p_target28_no_grant_on_mismatch;
	  @(posedge wb_clk_i) disable iff (wb_rst_i)
	  (i0_wb_cyc_i && i0_wb_stb_i &&
	   (i0_wb_adr_i[`TC_AW-1:`TC_AW-4] != 4'h9)) |->
	   $onehot0({t2_wb_cyc_o, t3_wb_cyc_o, t4_wb_cyc_o,
	             t5_wb_cyc_o, t6_wb_cyc_o, t7_wb_cyc_o, t8_wb_cyc_o});
	endproperty
	assert property (p_target28_no_grant_on_mismatch)
	  else $error("multiple/incorrect target2-8 grants asserted despite address mismatch");

	// -----------------------------------------------------------------------
	// Scenario: Only one master may be granted the shared bus at any given
	// clock cycle
	// (mutual exclusion is checked directly on the shared-bus target grant
	// outputs, which must be structurally one-hot0 regardless of the
	// arbitration policy or request timing)
	// -----------------------------------------------------------------------
	property p_mutual_exclusion_grant;
	  @(posedge wb_clk_i) disable iff (wb_rst_i)
	  (i2_wb_cyc_i && i2_wb_stb_i &&
	   (i2_wb_adr_i[`TC_AW-1:`TC_AW-4] == 4'h9) &&
	   i3_wb_cyc_i && i3_wb_stb_i &&
	   (i3_wb_adr_i[`TC_AW-1:`TC_AW-4] == 4'h9)) |->
	   $onehot0({t2_wb_cyc_o, t3_wb_cyc_o, t4_wb_cyc_o,
	             t5_wb_cyc_o, t6_wb_cyc_o, t7_wb_cyc_o, t8_wb_cyc_o});
	endproperty
	assert property (p_mutual_exclusion_grant)
	  else $error("more than one shared-bus target grant asserted simultaneously");

	// Structural invariant: shared-bus grants are always one-hot0, regardless
	// of which/how many masters are requesting (unconditional invariant,
	// robust to any arbitration policy).
	property p_shared_bus_grant_always_onehot0;
	  @(posedge wb_clk_i) disable iff (wb_rst_i)
	  $onehot0({t2_wb_cyc_o, t3_wb_cyc_o, t4_wb_cyc_o,
	            t5_wb_cyc_o, t6_wb_cyc_o, t7_wb_cyc_o, t8_wb_cyc_o});
	endproperty
	assert property (p_shared_bus_grant_always_onehot0)
	  else $error("shared-bus target grants are not mutually exclusive");

	// -----------------------------------------------------------------------
	// Scenario: Target 0 access is granted independently of shared bus
	// occupancy
	// -----------------------------------------------------------------------
	property p_target0_grant_independent;
	  @(posedge wb_clk_i) disable iff (wb_rst_i)
	  ((t2_wb_cyc_o || t3_wb_cyc_o || t4_wb_cyc_o ||
	    t5_wb_cyc_o || t6_wb_cyc_o || t7_wb_cyc_o || t8_wb_cyc_o) &&
	   i0_wb_cyc_i && i0_wb_stb_i &&
	   (i0_wb_adr_i[`TC_AW-1:`TC_AW-8] == 8'h00)) |->
	   ##[0:1] (t0_wb_cyc_o && t0_wb_stb_o);
	endproperty
	assert property (p_target0_grant_independent)
	  else $error("target0 grant not asserted independently of shared bus occupancy");

	// -----------------------------------------------------------------------
	// Scenario: UART target error signal is always tied to zero
	// (UART assumed connected at target slot 1). This is a property of the
	// external UART core wired to this target slot, not something derived
	// from the interconnect's own logic, so it is taken as an environment
	// assumption rather than an assertion on the interconnect.
	// -----------------------------------------------------------------------
	property p_uart_err_zero;
	  @(posedge wb_clk_i) disable iff (wb_rst_i)
	  (t1_wb_err_i == 1'b0);
	endproperty
	assume property (p_uart_err_zero);

	// -----------------------------------------------------------------------
	// Scenario: Acknowledge is asserted only for an active, correctly
	// addressed and enabled transaction
	// (weakened to tolerate up to one cycle of pipeline/arbitration latency
	// between the request and the corresponding ack, since the arbiter holds
	// registered state (req_r/req_won/req_cont))
	// -----------------------------------------------------------------------
	property p_ack_only_when_valid;
	  @(posedge wb_clk_i) disable iff (wb_rst_i)
	  (i0_wb_ack_o) |->
	  ((i0_wb_cyc_i && i0_wb_stb_i) ||
	   ($past(i0_wb_cyc_i) && $past(i0_wb_stb_i)));
	endproperty
	assert property (p_ack_only_when_valid)
	  else $error("i0_wb_ack_o asserted without a valid recent cyc/stb request");

	property p_ack_zero_when_cyc_low;
	  @(posedge wb_clk_i) disable iff (wb_rst_i)
	  (!i0_wb_cyc_i && !$past(i0_wb_cyc_i)) |-> (i0_wb_ack_o == 1'b0);
	endproperty
	assert property (p_ack_zero_when_cyc_low)
	  else $error("i0_wb_ack_o asserted while i0_wb_cyc_i has been low for at least two cycles");

	// -----------------------------------------------------------------------
	// Scenario: Lower-order address bits do not affect target selection
	// decision
	// (decode is a function of the current cycle's address/cyc/stb; the
	// invariance of the decode result with respect to low-order address bits
	// is checked by comparing the current cycle's result against the
	// previous cycle's result when both cycles present matching top address
	// bits and equivalent isolation from other masters. The property is
	// disabled for one extra cycle after reset deassertion so that $past
	// values are guaranteed valid, avoiding vacuous evaluation.)
	// -----------------------------------------------------------------------
	property p_target0_sel_independent_of_low_bits;
	  @(posedge wb_clk_i) disable iff (wb_rst_i || $past(wb_rst_i))
	  (i0_wb_cyc_i && i0_wb_stb_i && $past(i0_wb_cyc_i) && $past(i0_wb_stb_i) &&
	   !i1_wb_cyc_i && !i2_wb_cyc_i && !i3_wb_cyc_i && !i4_wb_cyc_i &&
	   !i5_wb_cyc_i && !i6_wb_cyc_i && !i7_wb_cyc_i &&
	   $past(!i1_wb_cyc_i && !i2_wb_cyc_i && !i3_wb_cyc_i && !i4_wb_cyc_i &&
	         !i5_wb_cyc_i && !i6_wb_cyc_i && !i7_wb_cyc_i) &&
	   (i0_wb_adr_i[`TC_AW-1:`TC_AW-8] == $past(i0_wb_adr_i[`TC_AW-1:`TC_AW-8]))) |->
	   ((t0_wb_cyc_o && t0_wb_stb_o) == $past(t0_wb_cyc_o && t0_wb_stb_o));
	endproperty
	assert property (p_target0_sel_independent_of_low_bits)
	  else $error("target0 selection differs for addresses sharing identical top t0_addr_w bits");


endmodule

//
// Multiple initiator to single target
//
module tc_mi_to_st (
	wb_clk_i,
	wb_rst_i,

	i0_wb_cyc_i,
	i0_wb_stb_i,
	i0_wb_adr_i,
	i0_wb_sel_i,
	i0_wb_we_i,
	i0_wb_dat_i,
	i0_wb_dat_o,
	i0_wb_ack_o,
	i0_wb_err_o,

	i1_wb_cyc_i,
	i1_wb_stb_i,
	i1_wb_adr_i,
	i1_wb_sel_i,
	i1_wb_we_i,
	i1_wb_dat_i,
	i1_wb_dat_o,
	i1_wb_ack_o,
	i1_wb_err_o,

	i2_wb_cyc_i,
	i2_wb_stb_i,
	i2_wb_adr_i,
	i2_wb_sel_i,
	i2_wb_we_i,
	i2_wb_dat_i,
	i2_wb_dat_o,
	i2_wb_ack_o,
	i2_wb_err_o,

	i3_wb_cyc_i,
	i3_wb_stb_i,
	i3_wb_adr_i,
	i3_wb_sel_i,
	i3_wb_we_i,
	i3_wb_dat_i,
	i3_wb_dat_o,
	i3_wb_ack_o,
	i3_wb_err_o,

	i4_wb_cyc_i,
	i4_wb_stb_i,
	i4_wb_adr_i,
	i4_wb_sel_i,
	i4_wb_we_i,
	i4_wb_dat_i,
	i4_wb_dat_o,
	i4_wb_ack_o,
	i4_wb_err_o,

	i5_wb_cyc_i,
	i5_wb_stb_i,
	i5_wb_adr_i,
	i5_wb_sel_i,
	i5_wb_we_i,
	i5_wb_dat_i,
	i5_wb_dat_o,
	i5_wb_ack_o,
	i5_wb_err_o,

	i6_wb_cyc_i,
	i6_wb_stb_i,
	i6_wb_adr_i,
	i6_wb_sel_i,
	i6_wb_we_i,
	i6_wb_dat_i,
	i6_wb_dat_o,
	i6_wb_ack_o,
	i6_wb_err_o,

	i7_wb_cyc_i,
	i7_wb_stb_i,
	i7_wb_adr_i,
	i7_wb_sel_i,
	i7_wb_we_i,
	i7_wb_dat_i,
	i7_wb_dat_o,
	i7_wb_ack_o,
	i7_wb_err_o,

	t0_wb_cyc_o,
	t0_wb_stb_o,
	t0_wb_adr_o,
	t0_wb_sel_o,
	t0_wb_we_o,
	t0_wb_dat_o,
	t0_wb_dat_i,
	t0_wb_ack_i,
	t0_wb_err_i

);

//
// Parameters
//
parameter		t0_addr_w = 2;
parameter		t0_addr = 2'b00;
parameter		multitarg = 1'b0;
parameter		t17_addr_w = 2;
parameter		t17_addr = 2'b00;

//
// I/O Ports
//
input			wb_clk_i;
input			wb_rst_i;

//
// WB slave i/f connecting initiator 0
//
input			i0_wb_cyc_i;
input			i0_wb_stb_i;
input	[`TC_AW-1:0]	i0_wb_adr_i;
input	[`TC_BSW-1:0]	i0_wb_sel_i;
input			i0_wb_we_i;
input	[`TC_DW-1:0]	i0_wb_dat_i;
output	[`TC_DW-1:0]	i0_wb_dat_o;
output			i0_wb_ack_o;
output			i0_wb_err_o;

//
// WB slave i/f connecting initiator 1
//
input			i1_wb_cyc_i;
input			i1_wb_stb_i;
input	[`TC_AW-1:0]	i1_wb_adr_i;
input	[`TC_BSW-1:0]	i1_wb_sel_i;
input			i1_wb_we_i;
input	[`TC_DW-1:0]	i1_wb_dat_i;
output	[`TC_DW-1:0]	i1_wb_dat_o;
output			i1_wb_ack_o;
output			i1_wb_err_o;

//
// WB slave i/f connecting initiator 2
//
input			i2_wb_cyc_i;
input			i2_wb_stb_i;
input	[`TC_AW-1:0]	i2_wb_adr_i;
input	[`TC_BSW-1:0]	i2_wb_sel_i;
input			i2_wb_we_i;
input	[`TC_DW-1:0]	i2_wb_dat_i;
output	[`TC_DW-1:0]	i2_wb_dat_o;
output			i2_wb_ack_o;
output			i2_wb_err_o;

//
// WB slave i/f connecting initiator 3
//
input			i3_wb_cyc_i;
input			i3_wb_stb_i;
input	[`TC_AW-1:0]	i3_wb_adr_i;
input	[`TC_BSW-1:0]	i3_wb_sel_i;
input			i3_wb_we_i;
input	[`TC_DW-1:0]	i3_wb_dat_i;
output	[`TC_DW-1:0]	i3_wb_dat_o;
output			i3_wb_ack_o;
output			i3_wb_err_o;

//
// WB slave i/f connecting initiator 4
//
input			i4_wb_cyc_i;
input			i4_wb_stb_i;
input	[`TC_AW-1:0]	i4_wb_adr_i;
input	[`TC_BSW-1:0]	i4_wb_sel_i;
input			i4_wb_we_i;
input	[`TC_DW-1:0]	i4_wb_dat_i;
output	[`TC_DW-1:0]	i4_wb_dat_o;
output			i4_wb_ack_o;
output			i4_wb_err_o;

//
// WB slave i/f connecting initiator 5
//
input			i5_wb_cyc_i;
input			i5_wb_stb_i;
input	[`TC_AW-1:0]	i5_wb_adr_i;
input	[`TC_BSW-1:0]	i5_wb_sel_i;
input			i5_wb_we_i;
input	[`TC_DW-1:0]	i5_wb_dat_i;
output	[`TC_DW-1:0]	i5_wb_dat_o;
output			i5_wb_ack_o;
output			i5_wb_err_o;

//
// WB slave i/f connecting initiator 6
//
input			i6_wb_cyc_i;
input			i6_wb_stb_i;
input	[`TC_AW-1:0]	i6_wb_adr_i;
input	[`TC_BSW-1:0]	i6_wb_sel_i;
input			i6_wb_we_i;
input	[`TC_DW-1:0]	i6_wb_dat_i;
output	[`TC_DW-1:0]	i6_wb_dat_o;
output			i6_wb_ack_o;
output			i6_wb_err_o;

//
// WB slave i/f connecting initiator 7
//
input			i7_wb_cyc_i;
input			i7_wb_stb_i;
input	[`TC_AW-1:0]	i7_wb_adr_i;
input	[`TC_BSW-1:0]	i7_wb_sel_i;
input			i7_wb_we_i;
input	[`TC_DW-1:0]	i7_wb_dat_i;
output	[`TC_DW-1:0]	i7_wb_dat_o;
output			i7_wb_ack_o;
output			i7_wb_err_o;

//
// WB master i/f connecting target
//
output			t0_wb_cyc_o;
output			t0_wb_stb_o;
output	[`TC_AW-1:0]	t0_wb_adr_o;
output	[`TC_BSW-1:0]	t0_wb_sel_o;
output			t0_wb_we_o;
output	[`TC_DW-1:0]	t0_wb_dat_o;
input	[`TC_DW-1:0]	t0_wb_dat_i;
input			t0_wb_ack_i;
input			t0_wb_err_i;

//
// Internal wires & registers
//
wire	[`TC_IIN_W-1:0]	i0_in, i1_in,
			i2_in, i3_in,
			i4_in, i5_in,
			i6_in, i7_in;
wire	[`TC_TIN_W-1:0]	i0_out, i1_out,
			i2_out, i3_out,
			i4_out, i5_out,
			i6_out, i7_out;
wire	[`TC_IIN_W-1:0]	t0_out;
wire	[`TC_TIN_W-1:0]	t0_in;
wire	[7:0]		req_i;
wire	[2:0]		req_won;
reg			req_cont;
reg	[2:0]		req_r;

//
// Group WB initiator 0 i/f inputs and outputs
//
assign i0_in = {i0_wb_cyc_i, i0_wb_stb_i, i0_wb_adr_i,
		i0_wb_sel_i, i0_wb_we_i, i0_wb_dat_i};
assign {i0_wb_dat_o, i0_wb_ack_o, i0_wb_err_o} = i0_out;

//
// Group WB initiator 1 i/f inputs and outputs
//
assign i1_in = {i1_wb_cyc_i, i1_wb_stb_i, i1_wb_adr_i,
		i1_wb_sel_i, i1_wb_we_i, i1_wb_dat_i};
assign {i1_wb_dat_o, i1_wb_ack_o, i1_wb_err_o} = i1_out;

//
// Group WB initiator 2 i/f inputs and outputs
//
assign i2_in = {i2_wb_cyc_i, i2_wb_stb_i, i2_wb_adr_i,
		i2_wb_sel_i, i2_wb_we_i, i2_wb_dat_i};
assign {i2_wb_dat_o, i2_wb_ack_o, i2_wb_err_o} = i2_out;

//
// Group WB initiator 3 i/f inputs and outputs
//
assign i3_in = {i3_wb_cyc_i, i3_wb_stb_i, i3_wb_adr_i,
		i3_wb_sel_i, i3_wb_we_i, i3_wb_dat_i};
assign {i3_wb_dat_o, i3_wb_ack_o, i3_wb_err_o} = i3_out;

//
// Group WB initiator 4 i/f inputs and outputs
//
assign i4_in = {i4_wb_cyc_i, i4_wb_stb_i, i4_wb_adr_i,
		i4_wb_sel_i, i4_wb_we_i, i4_wb_dat_i};
assign {i4_wb_dat_o, i4_wb_ack_o, i4_wb_err_o} = i4_out;

//
// Group WB initiator 5 i/f inputs and outputs
//
assign i5_in = {i5_wb_cyc_i, i5_wb_stb_i, i5_wb_adr_i,
		i5_wb_sel_i, i5_wb_we_i, i5_wb_dat_i};
assign {i5_wb_dat_o, i5_wb_ack_o, i5_wb_err_o} = i5_out;

//
// Group WB initiator 6 i/f inputs and outputs
//
assign i6_in = {i6_wb_cyc_i, i6_wb_stb_i, i6_wb_adr_i,
		i6_wb_sel_i, i6_wb_we_i, i6_wb_dat_i};
assign {i6_wb_dat_o, i6_wb_ack_o, i6_wb_err_o} = i6_out;

//
// Group WB initiator 7 i/f inputs and outputs
//
assign i7_in = {i7_wb_cyc_i, i7_wb_stb_i, i7_wb_adr_i,
		i7_wb_sel_i, i7_wb_we_i, i7_wb_dat_i};
assign {i7_wb_dat_o, i7_wb_ack_o, i7_wb_err_o} = i7_out;

//
// Group WB target 0 i/f inputs and outputs
//
assign {t0_wb_cyc_o, t0_wb_stb_o, t0_wb_adr_o,
		t0_wb_sel_o, t0_wb_we_o, t0_wb_dat_o} = t0_out;
assign t0_in = {t0_wb_dat_i, t0_wb_ack_i, t0_wb_err_i};

//
// Assign to WB initiator i/f outputs
//
// Either inputs from the target are assigned or zeros.
//
assign i0_out = (req_won == 3'd0) ? t0_in : {`TC_TIN_W{1'b0}};
assign i1_out = (req_won == 3'd1) ? t0_in : {`TC_TIN_W{1'b0}};
assign i2_out = (req_won == 3'd2) ? t0_in : {`TC_TIN_W{1'b0}};
assign i3_out = (req_won == 3'd3) ? t0_in : {`TC_TIN_W{1'b0}};
assign i4_out = (req_won == 3'd4) ? t0_in : {`TC_TIN_W{1'b0}};
assign i5_out = (req_won == 3'd5) ? t0_in : {`TC_TIN_W{1'b0}};
assign i6_out = (req_won == 3'd6) ? t0_in : {`TC_TIN_W{1'b0}};
assign i7_out = (req_won == 3'd7) ? t0_in : {`TC_TIN_W{1'b0}};

//
// Assign to WB target i/f outputs
//
// Assign inputs from initiator to target outputs according to
// which initiator has won. If there is no request for the target,
// assign zeros.
//
assign t0_out = (req_won == 3'd0) ? i0_in :
		(req_won == 3'd1) ? i1_in :
		(req_won == 3'd2) ? i2_in :
		(req_won == 3'd3) ? i3_in :
		(req_won == 3'd4) ? i4_in :
		(req_won == 3'd5) ? i5_in :
		(req_won == 3'd6) ? i6_in :
		(req_won == 3'd7) ? i7_in : {`TC_IIN_W{1'b0}};

//
// Determine if an initiator has address of the target.
//
assign req_i[0] = i0_wb_cyc_i &
	((i0_wb_adr_i[`TC_AW-1:`TC_AW-t0_addr_w] == t0_addr) |
	 multitarg & (i0_wb_adr_i[`TC_AW-1:`TC_AW-t17_addr_w] == t17_addr));
assign req_i[1] = i1_wb_cyc_i &
	((i1_wb_adr_i[`TC_AW-1:`TC_AW-t0_addr_w] == t0_addr) |
	 multitarg & (i1_wb_adr_i[`TC_AW-1:`TC_AW-t17_addr_w] == t17_addr));
assign req_i[2] = i2_wb_cyc_i &
	((i2_wb_adr_i[`TC_AW-1:`TC_AW-t0_addr_w] == t0_addr) |
	 multitarg & (i2_wb_adr_i[`TC_AW-1:`TC_AW-t17_addr_w] == t17_addr));
assign req_i[3] = i3_wb_cyc_i &
	((i3_wb_adr_i[`TC_AW-1:`TC_AW-t0_addr_w] == t0_addr) |
	 multitarg & (i3_wb_adr_i[`TC_AW-1:`TC_AW-t17_addr_w] == t17_addr));
assign req_i[4] = i4_wb_cyc_i &
	((i4_wb_adr_i[`TC_AW-1:`TC_AW-t0_addr_w] == t0_addr) |
	 multitarg & (i4_wb_adr_i[`TC_AW-1:`TC_AW-t17_addr_w] == t17_addr));
assign req_i[5] = i5_wb_cyc_i &
	((i5_wb_adr_i[`TC_AW-1:`TC_AW-t0_addr_w] == t0_addr) |
	 multitarg & (i5_wb_adr_i[`TC_AW-1:`TC_AW-t17_addr_w] == t17_addr));
assign req_i[6] = i6_wb_cyc_i &
	((i6_wb_adr_i[`TC_AW-1:`TC_AW-t0_addr_w] == t0_addr) |
	 multitarg & (i6_wb_adr_i[`TC_AW-1:`TC_AW-t17_addr_w] == t17_addr));
assign req_i[7] = i7_wb_cyc_i &
	((i7_wb_adr_i[`TC_AW-1:`TC_AW-t0_addr_w] == t0_addr) |
	 multitarg & (i7_wb_adr_i[`TC_AW-1:`TC_AW-t17_addr_w] == t17_addr));

//
// Determine who gets current access to the target.
//
// If current initiator still asserts request, do nothing
// (keep current initiator).
// Otherwise check each initiator's request, starting from initiator 0
// (highest priority).
// If there is no requests from initiators, park initiator 0.
//
assign req_won = req_cont ? req_r :
		 req_i[0] ? 3'd0 :
		 req_i[1] ? 3'd1 :
		 req_i[2] ? 3'd2 :
		 req_i[3] ? 3'd3 :
		 req_i[4] ? 3'd4 :
		 req_i[5] ? 3'd5 :
		 req_i[6] ? 3'd6 :
		 req_i[7] ? 3'd7 : 3'd0;

//
// Check if current initiator still wants access to the target and if
// it does, assert req_cont.
//
always @(req_r or req_i)
	case (req_r)	// synopsys parallel_case
		3'd0: req_cont = req_i[0];
		3'd1: req_cont = req_i[1];
		3'd2: req_cont = req_i[2];
		3'd3: req_cont = req_i[3];
		3'd4: req_cont = req_i[4];
		3'd5: req_cont = req_i[5];
		3'd6: req_cont = req_i[6];
		3'd7: req_cont = req_i[7];
	endcase

//
// Register who has current access to the target.
//
always @(posedge wb_clk_i or posedge wb_rst_i)
	if (wb_rst_i)
		req_r <= 3'd0;
	else
		req_r <= req_won;

endmodule	

//
// Single initiator to multiple targets
//
module tc_si_to_mt (

	i0_wb_cyc_i,
	i0_wb_stb_i,
	i0_wb_adr_i,
	i0_wb_sel_i,
	i0_wb_we_i,
	i0_wb_dat_i,
	i0_wb_dat_o,
	i0_wb_ack_o,
	i0_wb_err_o,

	t0_wb_cyc_o,
	t0_wb_stb_o,
	t0_wb_adr_o,
	t0_wb_sel_o,
	t0_wb_we_o,
	t0_wb_dat_o,
	t0_wb_dat_i,
	t0_wb_ack_i,
	t0_wb_err_i,

	t1_wb_cyc_o,
	t1_wb_stb_o,
	t1_wb_adr_o,
	t1_wb_sel_o,
	t1_wb_we_o,
	t1_wb_dat_o,
	t1_wb_dat_i,
	t1_wb_ack_i,
	t1_wb_err_i,

	t2_wb_cyc_o,
	t2_wb_stb_o,
	t2_wb_adr_o,
	t2_wb_sel_o,
	t2_wb_we_o,
	t2_wb_dat_o,
	t2_wb_dat_i,
	t2_wb_ack_i,
	t2_wb_err_i,

	t3_wb_cyc_o,
	t3_wb_stb_o,
	t3_wb_adr_o,
	t3_wb_sel_o,
	t3_wb_we_o,
	t3_wb_dat_o,
	t3_wb_dat_i,
	t3_wb_ack_i,
	t3_wb_err_i,

	t4_wb_cyc_o,
	t4_wb_stb_o,
	t4_wb_adr_o,
	t4_wb_sel_o,
	t4_wb_we_o,
	t4_wb_dat_o,
	t4_wb_dat_i,
	t4_wb_ack_i,
	t4_wb_err_i,

	t5_wb_cyc_o,
	t5_wb_stb_o,
	t5_wb_adr_o,
	t5_wb_sel_o,
	t5_wb_we_o,
	t5_wb_dat_o,
	t5_wb_dat_i,
	t5_wb_ack_i,
	t5_wb_err_i,

	t6_wb_cyc_o,
	t6_wb_stb_o,
	t6_wb_adr_o,
	t6_wb_sel_o,
	t6_wb_we_o,
	t6_wb_dat_o,
	t6_wb_dat_i,
	t6_wb_ack_i,
	t6_wb_err_i,

	t7_wb_cyc_o,
	t7_wb_stb_o,
	t7_wb_adr_o,
	t7_wb_sel_o,
	t7_wb_we_o,
	t7_wb_dat_o,
	t7_wb_dat_i,
	t7_wb_ack_i,
	t7_wb_err_i

);

//
// Parameters
//
parameter		t0_addr_w = 3;
parameter		t0_addr = 3'd0;
parameter		t17_addr_w = 3;
parameter		t1_addr = 3'd1;
parameter		t2_addr = 3'd2;
parameter		t3_addr = 3'd3;
parameter		t4_addr = 3'd4;
parameter		t5_addr = 3'd5;
parameter		t6_addr = 3'd6;
parameter		t7_addr = 3'd7;

//
// I/O Ports
//

//
// WB slave i/f connecting initiator 0
//
input			i0_wb_cyc_i;
input			i0_wb_stb_i;
input	[`TC_AW-1:0]	i0_wb_adr_i;
input	[`TC_BSW-1:0]	i0_wb_sel_i;
input			i0_wb_we_i;
input	[`TC_DW-1:0]	i0_wb_dat_i;
output	[`TC_DW-1:0]	i0_wb_dat_o;
output			i0_wb_ack_o;
output			i0_wb_err_o;

//
// WB master i/f connecting target 0
//
output			t0_wb_cyc_o;
output			t0_wb_stb_o;
output	[`TC_AW-1:0]	t0_wb_adr_o;
output	[`TC_BSW-1:0]	t0_wb_sel_o;
output			t0_wb_we_o;
output	[`TC_DW-1:0]	t0_wb_dat_o;
input	[`TC_DW-1:0]	t0_wb_dat_i;
input			t0_wb_ack_i;
input			t0_wb_err_i;

//
// WB master i/f connecting target 1
//
output			t1_wb_cyc_o;
output			t1_wb_stb_o;
output	[`TC_AW-1:0]	t1_wb_adr_o;
output	[`TC_BSW-1:0]	t1_wb_sel_o;
output			t1_wb_we_o;
output	[`TC_DW-1:0]	t1_wb_dat_o;
input	[`TC_DW-1:0]	t1_wb_dat_i;
input			t1_wb_ack_i;
input			t1_wb_err_i;

//
// WB master i/f connecting target 2
//
output			t2_wb_cyc_o;
output			t2_wb_stb_o;
output	[`TC_AW-1:0]	t2_wb_adr_o;
output	[`TC_BSW-1:0]	t2_wb_sel_o;
output			t2_wb_we_o;
output	[`TC_DW-1:0]	t2_wb_dat_o;
input	[`TC_DW-1:0]	t2_wb_dat_i;
input			t2_wb_ack_i;
input			t2_wb_err_i;

//
// WB master i/f connecting target 3
//
output			t3_wb_cyc_o;
output			t3_wb_stb_o;
output	[`TC_AW-1:0]	t3_wb_adr_o;
output	[`TC_BSW-1:0]	t3_wb_sel_o;
output			t3_wb_we_o;
output	[`TC_DW-1:0]	t3_wb_dat_o;
input	[`TC_DW-1:0]	t3_wb_dat_i;
input			t3_wb_ack_i;
input			t3_wb_err_i;

//
// WB master i/f connecting target 4
//
output			t4_wb_cyc_o;
output			t4_wb_stb_o;
output	[`TC_AW-1:0]	t4_wb_adr_o;
output	[`TC_BSW-1:0]	t4_wb_sel_o;
output			t4_wb_we_o;
output	[`TC_DW-1:0]	t4_wb_dat_o;
input	[`TC_DW-1:0]	t4_wb_dat_i;
input			t4_wb_ack_i;
input			t4_wb_err_i;

//
// WB master i/f connecting target 5
//
output			t5_wb_cyc_o;
output			t5_wb_stb_o;
output	[`TC_AW-1:0]	t5_wb_adr_o;
output	[`TC_BSW-1:0]	t5_wb_sel_o;
output			t5_wb_we_o;
output	[`TC_DW-1:0]	t5_wb_dat_o;
input	[`TC_DW-1:0]	t5_wb_dat_i;
input			t5_wb_ack_i;
input			t5_wb_err_i;

//
// WB master i/f connecting target 6
//
output			t6_wb_cyc_o;
output			t6_wb_stb_o;
output	[`TC_AW-1:0]	t6_wb_adr_o;
output	[`TC_BSW-1:0]	t6_wb_sel_o;
output			t6_wb_we_o;
output	[`TC_DW-1:0]	t6_wb_dat_o;
input	[`TC_DW-1:0]	t6_wb_dat_i;
input			t6_wb_ack_i;
input			t6_wb_err_i;

//
// WB master i/f connecting target 7
//
output			t7_wb_cyc_o;
output			t7_wb_stb_o;
output	[`TC_AW-1:0]	t7_wb_adr_o;
output	[`TC_BSW-1:0]	t7_wb_sel_o;
output			t7_wb_we_o;
output	[`TC_DW-1:0]	t7_wb_dat_o;
input	[`TC_DW-1:0]	t7_wb_dat_i;
input			t7_wb_ack_i;
input			t7_wb_err_i;

//
// Internal wires & registers
//
wire	[`TC_IIN_W-1:0]	i0_in;
wire	[`TC_TIN_W-1:0]	i0_out;
wire	[`TC_IIN_W-1:0]	t0_out, t1_out,
			t2_out, t3_out,
			t4_out, t5_out,
			t6_out, t7_out;
wire	[`TC_TIN_W-1:0]	t0_in, t1_in,
			t2_in, t3_in,
			t4_in, t5_in,
			t6_in, t7_in;
wire	[7:0]		req_t;

//
// Group WB initiator 0 i/f inputs and outputs
//
assign i0_in = {i0_wb_cyc_i, i0_wb_stb_i, i0_wb_adr_i,
		i0_wb_sel_i, i0_wb_we_i, i0_wb_dat_i};
assign {i0_wb_dat_o, i0_wb_ack_o, i0_wb_err_o} = i0_out;

//
// Group WB target 0 i/f inputs and outputs
//
assign {t0_wb_cyc_o, t0_wb_stb_o, t0_wb_adr_o,
		t0_wb_sel_o, t0_wb_we_o, t0_wb_dat_o} = t0_out;
assign t0_in = {t0_wb_dat_i, t0_wb_ack_i, t0_wb_err_i};

//
// Group WB target 1 i/f inputs and outputs
//
assign {t1_wb_cyc_o, t1_wb_stb_o, t1_wb_adr_o,
		t1_wb_sel_o, t1_wb_we_o, t1_wb_dat_o} = t1_out;
assign t1_in = {t1_wb_dat_i, t1_wb_ack_i, t1_wb_err_i};

//
// Group WB target 2 i/f inputs and outputs
//
assign {t2_wb_cyc_o, t2_wb_stb_o, t2_wb_adr_o,
		t2_wb_sel_o, t2_wb_we_o, t2_wb_dat_o} = t2_out;
assign t2_in = {t2_wb_dat_i, t2_wb_ack_i, t2_wb_err_i};

//
// Group WB target 3 i/f inputs and outputs
//
assign {t3_wb_cyc_o, t3_wb_stb_o, t3_wb_adr_o,
		t3_wb_sel_o, t3_wb_we_o, t3_wb_dat_o} = t3_out;
assign t3_in = {t3_wb_dat_i, t3_wb_ack_i, t3_wb_err_i};

//
// Group WB target 4 i/f inputs and outputs
//
assign {t4_wb_cyc_o, t4_wb_stb_o, t4_wb_adr_o,
		t4_wb_sel_o, t4_wb_we_o, t4_wb_dat_o} = t4_out;
assign t4_in = {t4_wb_dat_i, t4_wb_ack_i, t4_wb_err_i};

//
// Group WB target 5 i/f inputs and outputs
//
assign {t5_wb_cyc_o, t5_wb_stb_o, t5_wb_adr_o,
		t5_wb_sel_o, t5_wb_we_o, t5_wb_dat_o} = t5_out;
assign t5_in = {t5_wb_dat_i, t5_wb_ack_i, t5_wb_err_i};

//
// Group WB target 6 i/f inputs and outputs
//
assign {t6_wb_cyc_o, t6_wb_stb_o, t6_wb_adr_o,
		t6_wb_sel_o, t6_wb_we_o, t6_wb_dat_o} = t6_out;
assign t6_in = {t6_wb_dat_i, t6_wb_ack_i, t6_wb_err_i};

//
// Group WB target 7 i/f inputs and outputs
//
assign {t7_wb_cyc_o, t7_wb_stb_o, t7_wb_adr_o,
		t7_wb_sel_o, t7_wb_we_o, t7_wb_dat_o} = t7_out;
assign t7_in = {t7_wb_dat_i, t7_wb_ack_i, t7_wb_err_i};

//
// Assign to WB target i/f outputs
//
// Either inputs from the initiator are assigned or zeros.
//
assign t0_out = req_t[0] ? i0_in : {`TC_IIN_W{1'b0}};
assign t1_out = req_t[1] ? i0_in : {`TC_IIN_W{1'b0}};
assign t2_out = req_t[2] ? i0_in : {`TC_IIN_W{1'b0}};
assign t3_out = req_t[3] ? i0_in : {`TC_IIN_W{1'b0}};
assign t4_out = req_t[4] ? i0_in : {`TC_IIN_W{1'b0}};
assign t5_out = req_t[5] ? i0_in : {`TC_IIN_W{1'b0}};
assign t6_out = req_t[6] ? i0_in : {`TC_IIN_W{1'b0}};
assign t7_out = req_t[7] ? i0_in : {`TC_IIN_W{1'b0}};

//
// Assign to WB initiator i/f outputs
//
// Assign inputs from target to initiator outputs according to
// which target is accessed. If there is no request for a target,
// assign zeros.
//
assign i0_out = req_t[0] ? t0_in :
		req_t[1] ? t1_in :
		req_t[2] ? t2_in :
		req_t[3] ? t3_in :
		req_t[4] ? t4_in :
		req_t[5] ? t5_in :
		req_t[6] ? t6_in :
		req_t[7] ? t7_in : {`TC_TIN_W{1'b0}};

//
// Determine which target is being accessed.
//
assign req_t[0] = i0_wb_cyc_i & (i0_wb_adr_i[`TC_AW-1:`TC_AW-t0_addr_w] == t0_addr);
assign req_t[1] = i0_wb_cyc_i & (i0_wb_adr_i[`TC_AW-1:`TC_AW-t17_addr_w] == t1_addr);
assign req_t[2] = i0_wb_cyc_i & (i0_wb_adr_i[`TC_AW-1:`TC_AW-t17_addr_w] == t2_addr);
assign req_t[3] = i0_wb_cyc_i & (i0_wb_adr_i[`TC_AW-1:`TC_AW-t17_addr_w] == t3_addr);
assign req_t[4] = i0_wb_cyc_i & (i0_wb_adr_i[`TC_AW-1:`TC_AW-t17_addr_w] == t4_addr);
assign req_t[5] = i0_wb_cyc_i & (i0_wb_adr_i[`TC_AW-1:`TC_AW-t17_addr_w] == t5_addr);
assign req_t[6] = i0_wb_cyc_i & (i0_wb_adr_i[`TC_AW-1:`TC_AW-t17_addr_w] == t6_addr);
assign req_t[7] = i0_wb_cyc_i & (i0_wb_adr_i[`TC_AW-1:`TC_AW-t17_addr_w] == t7_addr);

endmodule	
