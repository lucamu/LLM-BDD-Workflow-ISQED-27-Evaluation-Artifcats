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
	// AssertionForge baseline SVA for minisoc
	// 4364 assertions captured from gen_plan.generate_svas

	property af_p0;
	@(posedge wb_clk_i) (i0_wb_ack_o && i0_wb_we_i) |-> (i0_wb_cyc_i && i0_wb_stb_i);
	endproperty
	assert property(af_p0);

	property af_p1;
	@(posedge wb_clk_i) (!i0_wb_cyc_i && !i0_wb_stb_i) |-> (i0_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p1);

	property af_p2;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i0_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p2);

	property af_p3;
	@(posedge wb_clk_i) (!i0_wb_we_i && i0_wb_ack_o) |-> ($isunknown(i0_wb_dat_o) == 1'b0);
	endproperty
	assert property(af_p3);

	property af_p4;
	@(posedge wb_clk_i) (i0_wb_ack_o) |-> (i0_wb_cyc_i && i0_wb_stb_i);
	endproperty
	assert property(af_p4);

	property af_p5;
	@(posedge wb_clk_i) (!i0_wb_cyc_i) |-> (i0_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p5);

	property af_p6;
	@(posedge wb_clk_i) ($rose(i0_wb_stb_i) && i0_wb_ack_o) |=> (!i0_wb_ack_o);
	endproperty
	assert property(af_p6);

	property af_p7;
	@(posedge wb_clk_i) (i0_wb_we_i && i0_wb_stb_i && i0_wb_cyc_i) |=> (i0_wb_ack_o == 1'b1);
	endproperty
	assert property(af_p7);

	property af_p8;
	@(posedge wb_clk_i) !(i0_wb_ack_o && i0_wb_err_o);
	endproperty
	assert property(af_p8);

	property af_p9;
	@(posedge wb_clk_i) ($fell(i0_wb_cyc_i)) |=> (i0_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p9);

	property af_p10;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i0_wb_ack_o;
	endproperty
	assert property(af_p10);

	property af_p11;
	@(posedge wb_clk_i) (i0_wb_ack_o && !i0_wb_stb_i) |=> !i0_wb_ack_o;
	endproperty
	assert property(af_p11);

	property af_p12;
	@(posedge wb_clk_i) i0_wb_ack_o |-> (i0_wb_cyc_i && i0_wb_stb_i);
	endproperty
	assert property(af_p12);

	property af_p13;
	@(posedge wb_clk_i) (i0_wb_stb_i && i0_wb_cyc_i) |-> ##[1:4] i0_wb_ack_o;
	endproperty
	assert property(af_p13);

	property af_p14;
	@(posedge wb_clk_i) !i0_wb_cyc_i |-> !i0_wb_ack_o;
	endproperty
	assert property(af_p14);

	property af_p15;
	@(posedge wb_clk_i) (i0_wb_stb_i && i0_wb_cyc_i) |=> (i0_wb_ack_o ##1 !i0_wb_ack_o);
	endproperty
	assert property(af_p15);

	property af_p16;
	@(posedge wb_clk_i) (i0_wb_ack_o ##1 i0_wb_stb_i) |=> i0_wb_ack_o;
	endproperty
	assert property(af_p16);

	property af_p17;
	@(posedge wb_clk_i) wb_rst_i |-> !i0_wb_ack_o;
	endproperty
	assert property(af_p17);

	property af_p18;
	@(posedge wb_clk_i) (i0_wb_ack_o && i0_wb_we_i) |-> i0_wb_we_i;
	endproperty
	assert property(af_p18);

	property af_p19;
	@(posedge wb_clk_i) wb_rst_i |=> !i0_wb_ack_o;
	endproperty
	assert property(af_p19);

	property af_p20;
	@(posedge wb_clk_i) i0_wb_ack_o |-> (i0_wb_stb_i && i0_wb_cyc_i);
	endproperty
	assert property(af_p20);

	property af_p21;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i0_wb_ack_o ##1 !i0_wb_ack_o);
	endproperty
	assert property(af_p21);

	property af_p22;
	@(posedge wb_clk_i) (i0_wb_stb_i && i0_wb_cyc_i) |-> ##1 (i0_wb_ack_o ##1 !i0_wb_ack_o);
	endproperty
	assert property(af_p22);

	property af_p23;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 !i0_wb_ack_o;
	endproperty
	assert property(af_p23);

	property af_p24;
	@(posedge wb_clk_i) (!i0_wb_stb_i && i0_wb_cyc_i) |-> !i0_wb_ack_o;
	endproperty
	assert property(af_p24);

	property af_p25;
	@(posedge wb_clk_i) ($changed(i0_wb_adr_i) && i0_wb_stb_i && i0_wb_cyc_i) |-> ##1 i0_wb_ack_o;
	endproperty
	assert property(af_p25);

	property af_p26;
	@(posedge wb_clk_i) $fell(i0_wb_stb_i) |-> ##1 !i0_wb_ack_o;
	endproperty
	assert property(af_p26);

	property af_p27;
	@(posedge wb_clk_i) (i0_wb_cyc_i && !i0_wb_ack_o) |-> $stable(i0_wb_adr_i);
	endproperty
	assert property(af_p27);

	property af_p28;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i && !i0_wb_ack_o) |-> $stable(i0_wb_adr_i);
	endproperty
	assert property(af_p28);

	property af_p29;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i) |-> $stable(i0_wb_adr_i);
	endproperty
	assert property(af_p29);

	property af_p30;
	@(posedge wb_clk_i) (i0_wb_we_i && i0_wb_stb_i && !i0_wb_ack_o) |-> (i0_wb_adr_i >= 0 && i0_wb_adr_i <= 65535);
	endproperty
	assert property(af_p30);

	property af_p31;
	@(posedge wb_clk_i) (i0_wb_we_i && i0_wb_stb_i && $past(i0_wb_stb_i)) |-> $stable(i0_wb_adr_i);
	endproperty
	assert property(af_p31);

	property af_p32;
	@(posedge wb_clk_i) (i0_wb_cyc_i && !i0_wb_stb_i) |-> $stable(i0_wb_adr_i);
	endproperty
	assert property(af_p32);

	property af_p33;
	@(posedge wb_clk_i) (i0_wb_we_i && i0_wb_stb_i && !i0_wb_ack_o) |-> $stable(i0_wb_adr_i);
	endproperty
	assert property(af_p33);

	property af_p34;
	@(posedge wb_clk_i) (i0_wb_stb_i && $past(i0_wb_stb_i)) |-> $stable(i0_wb_adr_i);
	endproperty
	assert property(af_p34);

	property af_p35;
	@(posedge wb_clk_i) (!i0_wb_we_i && i0_wb_cyc_i && $past(i0_wb_cyc_i)) |-> $stable(i0_wb_adr_i);
	endproperty
	assert property(af_p35);

	property af_p36;
	@(posedge wb_clk_i) $rose(i0_wb_ack_o) |=> $stable(i0_wb_adr_i);
	endproperty
	assert property(af_p36);


	property af_p38;
	@(posedge wb_clk_i) (i0_wb_adr_i != $past(i0_wb_adr_i)) |-> $past(i0_wb_ack_o);
	endproperty
	assert property(af_p38);

	property af_p39;
	@(posedge wb_clk_i) (i0_wb_stb_i) |-> !$isunknown(i0_wb_adr_i);
	endproperty
	assert property(af_p39);

	property af_p40;
	@(posedge wb_clk_i) (!wb_rst_i && i0_wb_cyc_i) |-> (i0_wb_adr_i >= 0 && i0_wb_adr_i <= 65535);
	endproperty
	assert property(af_p40);

	property af_p41;
	@(posedge wb_clk_i) (!wb_rst_i && i0_wb_stb_i) |-> !$isunknown(i0_wb_adr_i);
	endproperty
	assert property(af_p41);


	property af_p43;
	@(posedge wb_clk_i) ($rose(wb_rst_i) |-> !$isunknown(i0_wb_adr_i)) and ($fell(wb_rst_i) |-> (i0_wb_adr_i >= 0 && i0_wb_adr_i <= 65535));
	endproperty
	assert property(af_p43);

	property af_p44;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i) |-> !$isunknown(i0_wb_adr_i);
	endproperty
	assert property(af_p44);

	property af_p45;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((i0_wb_adr_i >= 0) && (i0_wb_adr_i <= 65535));
	endproperty
	assert property(af_p45);

	property af_p46;
	@(posedge wb_clk_i) ((i0_wb_adr_i >= 0) && (i0_wb_adr_i <= 65535) && i0_wb_cyc_i && i0_wb_stb_i) |=> ((i0_wb_adr_i >= 0) && (i0_wb_adr_i <= 65535));
	endproperty
	assert property(af_p46);

	property af_p47;
	@(posedge wb_clk_i) i0_wb_ack_o |-> ($stable(i0_wb_adr_i) throughout i0_wb_stb_i[->1]);
	endproperty
	assert property(af_p47);

	property af_p48;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (!i0_wb_cyc_i) |-> 1'b1;
	endproperty
	assert property(af_p48);

	property af_p49;
	@(posedge wb_clk_i) wb_rst_i |-> 1'b1;
	endproperty
	assert property(af_p49);

	property af_p50;
	@(posedge wb_clk_i) wb_rst_i |=> $stable(i0_wb_adr_i);
	endproperty
	assert property(af_p50);

	property af_p51;
	@(posedge wb_clk_i) (i0_wb_stb_i && (i0_wb_adr_i >= 4096) && (i0_wb_adr_i <= 8191)) |-> ((i0_wb_adr_i >= 4096) && (i0_wb_adr_i <= 8191)) until_with i0_wb_ack_o;
	endproperty
	assert property(af_p51);

	property af_p52;
	@(posedge wb_clk_i) i0_wb_err_o |-> ($stable(i0_wb_adr_i) until (!i0_wb_cyc_i));
	endproperty
	assert property(af_p52);

	property af_p53;
	@(posedge wb_clk_i) $rose(i0_wb_cyc_i) |-> i0_wb_stb_i;
	endproperty
	assert property(af_p53);

	property af_p54;
	@(posedge wb_clk_i) i0_wb_cyc_i |-> i0_wb_stb_i;
	endproperty
	assert property(af_p54);

	property af_p55;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i0_wb_cyc_i[*2];
	endproperty
	assert property(af_p55);

	property af_p56;
	@(posedge wb_clk_i) !$isunknown(i0_wb_dat_o) |-> i0_wb_cyc_i;
	endproperty
	assert property(af_p56);

	property af_p57;
	@(posedge wb_clk_i) i0_wb_ack_o |=> !i0_wb_cyc_i;
	endproperty
	assert property(af_p57);

	property af_p58;
	@(posedge wb_clk_i) $rose(i0_wb_cyc_i) |-> i0_wb_cyc_i throughout i0_wb_ack_o[->1];
	endproperty
	assert property(af_p58);

	property af_p59;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i0_wb_cyc_i[*3];
	endproperty
	assert property(af_p59);

	property af_p60;
	@(posedge wb_clk_i) i0_wb_ack_o |-> i0_wb_cyc_i;
	endproperty
	assert property(af_p60);

	property af_p61;
	@(posedge wb_clk_i) $rose(i0_wb_cyc_i) |=> i0_wb_cyc_i;
	endproperty
	assert property(af_p61);

	property af_p62;
	@(posedge wb_clk_i) wb_rst_i |-> !i0_wb_cyc_i;
	endproperty
	assert property(af_p62);

	property af_p63;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_err_o) |=> !i0_wb_cyc_i;
	endproperty
	assert property(af_p63);

	property af_p64;
	@(posedge wb_clk_i) i0_wb_cyc_i |-> (i0_wb_cyc_i throughout (##[1:$] i0_wb_ack_o));
	endproperty
	assert property(af_p64);

	property af_p65;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> !i0_wb_cyc_i;
	endproperty
	assert property(af_p65);

	property af_p66;
	@(posedge wb_clk_i) (!i0_wb_cyc_i) |-> (!i0_wb_err_o);
	endproperty
	assert property(af_p66);

	property af_p67;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (!i0_wb_cyc_i)[*2];
	endproperty
	assert property(af_p67);

	property af_p68;
	@(posedge wb_clk_i) (!i0_wb_cyc_i) |-> (!i0_wb_stb_i);
	endproperty
	assert property(af_p68);

	property af_p69;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_we_i) |-> (i0_wb_cyc_i throughout (##[1:$] i0_wb_ack_o));
	endproperty
	assert property(af_p69);

	property af_p70;
	@(posedge wb_clk_i) i0_wb_cyc_i |-> $stable(i0_wb_we_i);
	endproperty
	assert property(af_p70);

	property af_p71;
	@(posedge wb_clk_i) (i0_wb_cyc_i && !i0_wb_ack_o) |-> $stable(i0_wb_sel_i);
	endproperty
	assert property(af_p71);

	property af_p72;
	@(posedge wb_clk_i) (i0_wb_cyc_i && !wb_rst_i) |=> i0_wb_cyc_i;
	endproperty
	assert property(af_p72);

	property af_p73;
	@(posedge wb_clk_i) $rose(i0_wb_cyc_i) |-> i0_wb_cyc_i[*2];
	endproperty
	assert property(af_p73);

	property af_p74;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (!$isunknown(i0_wb_cyc_i));
	endproperty
	assert property(af_p74);

	property af_p75;
	@(posedge wb_clk_i) $fell(i0_wb_cyc_i) |-> ($past(i0_wb_ack_o) || i0_wb_ack_o);
	endproperty
	assert property(af_p75);

	property af_p76;
	@(posedge wb_clk_i) $rose(i0_wb_cyc_i) |-> ##1 i0_wb_cyc_i;
	endproperty
	assert property(af_p76);

	property af_p77;
	@(posedge wb_clk_i) (i0_wb_cyc_i && !i0_wb_ack_o) |-> $stable(i0_wb_adr_i);
	endproperty
	assert property(af_p77);

	property af_p78;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i) |-> (i0_wb_cyc_i until (i0_wb_ack_o || i0_wb_err_o));
	endproperty
	assert property(af_p78);

	property af_p79;
	@(posedge wb_clk_i) i0_wb_stb_i |-> i0_wb_cyc_i;
	endproperty
	assert property(af_p79);

	property af_p80;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (i0_wb_cyc_i == 1'b0);
	endproperty
	assert property(af_p80);

	property af_p81;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_we_i) |-> (($stable(i0_wb_adr_i) && $stable(i0_wb_dat_i)) until i0_wb_ack_o);
	endproperty
	assert property(af_p81);


	property af_p83;
	@(posedge wb_clk_i) ((i0_wb_dat_i >= 100) && (i0_wb_dat_i <= 150)) |=> ((i0_wb_dat_i >= 80) && (i0_wb_dat_i <= 170));
	endproperty
	assert property(af_p83);

	property af_p84;
	@(posedge wb_clk_i) ((i0_wb_cyc_i && !i0_wb_we_i)[*3]) |-> ($stable(i0_wb_dat_i));
	endproperty
	assert property(af_p84);

	property af_p85;
	@(posedge wb_clk_i) (i0_wb_err_o) |-> $stable(i0_wb_dat_i);
	endproperty
	assert property(af_p85);

	property af_p86;
	@(posedge wb_clk_i) ($past(!wb_rst_i, 4)) |-> ((i0_wb_dat_i >= 0) && (i0_wb_dat_i <= 45));
	endproperty
	assert property(af_p86);

	property af_p87;
	@(posedge wb_clk_i) (!i0_wb_we_i && i0_wb_ack_o) |=> (i0_wb_dat_o == $past(i0_wb_dat_i));
	endproperty
	assert property(af_p87);

	property af_p88;
	@(posedge wb_clk_i) ((i0_wb_dat_i >= 138) && (i0_wb_dat_i <= 153) && i0_wb_ack_o) |=> ((i0_wb_dat_i >= 98) && (i0_wb_dat_i <= 153));
	endproperty
	assert property(af_p88);

	property af_p89;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i && !i0_wb_we_i) |-> $stable(i0_wb_dat_i);
	endproperty
	assert property(af_p89);

	property af_p90;
	@(posedge wb_clk_i) (i0_wb_ack_o) |-> $stable(i0_wb_dat_i);
	endproperty
	assert property(af_p90);

	property af_p91;
	@(posedge wb_clk_i) ($rose(!wb_rst_i)) |-> ##[1:5] ((i0_wb_dat_i >= 0) && (i0_wb_dat_i <= 255));
	endproperty
	assert property(af_p91);

	property af_p92;
	@(posedge wb_clk_i) disable iff (wb_rst_i) ($rose(i0_wb_cyc_i)) |-> (!$isunknown(i0_wb_dat_i));
	endproperty
	assert property(af_p92);

	property af_p93;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i) |-> !$isunknown(i0_wb_dat_i);
	endproperty
	assert property(af_p93);

	property af_p94;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i) |-> (i0_wb_dat_i >= 100) && (i0_wb_dat_i <= 200);
	endproperty
	assert property(af_p94);


	property af_p96;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i && (|i0_wb_sel_i)) |-> !$isunknown(i0_wb_dat_i);
	endproperty
	assert property(af_p96);

	property af_p97;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i && i0_wb_ack_o) |-> (i0_wb_dat_i inside {[0:255]});
	endproperty
	assert property(af_p97);

	property af_p98;
	@(posedge wb_clk_i) (i0_wb_stb_i && i0_wb_cyc_i) |-> (i0_wb_dat_i >= 0) && (i0_wb_dat_i <= 255);
	endproperty
	assert property(af_p98);

	property af_p99;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (i0_wb_dat_i >= 0) && (i0_wb_dat_i <= 255);
	endproperty
	assert property(af_p99);

	property af_p100;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ((i0_wb_dat_i >= 0) && (i0_wb_dat_i <= 255)) ##1 $stable(i0_wb_dat_i);
	endproperty
	assert property(af_p100);

	property af_p101;
	@(posedge wb_clk_i) ((i0_wb_dat_i >= 200) && (i0_wb_dat_i <= 255)) |-> (i0_wb_dat_i >= 180) && (i0_wb_dat_i <= 255);
	endproperty
	assert property(af_p101);

	property af_p102;
	@(posedge wb_clk_i) (##3 !wb_rst_i) |-> (i0_wb_dat_i >= 0) && (i0_wb_dat_i <= 255);
	endproperty
	assert property(af_p102);

	property af_p103;
	@(posedge wb_clk_i) ((i0_wb_dat_i >= 230 && i0_wb_dat_i <= 255) && i0_wb_ack_o) |=> (i0_wb_dat_i >= 205 && i0_wb_dat_i <= 255);
	endproperty
	assert property(af_p103);

	property af_p104;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 (i0_wb_dat_i >= 0 && i0_wb_dat_i <= 45);
	endproperty
	assert property(af_p104);

	property af_p105;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 (i0_wb_we_i -> (i0_wb_dat_i >= 83 && i0_wb_dat_i <= 165));
	endproperty
	assert property(af_p105);

	property af_p106;
	@(posedge wb_clk_i) (i0_wb_sel_i && i0_wb_stb_i) |-> (i0_wb_dat_i >= 50 && i0_wb_dat_i <= 120);
	endproperty
	assert property(af_p106);


	property af_p108;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i && !i0_wb_ack_o) |=> $stable(i0_wb_dat_i);
	endproperty
	assert property(af_p108);

	property af_p109;
	@(posedge wb_clk_i) (i0_wb_err_o) |-> 1;
	endproperty
	assert property(af_p109);

	property af_p110;
	@(posedge wb_clk_i) (!i0_wb_err_o && i0_wb_ack_o) |-> (i0_wb_dat_i >= 0 && i0_wb_dat_i <= 255);
	endproperty
	assert property(af_p110);

	property af_p111;
	@(posedge wb_clk_i) $fell(i0_wb_we_i) |=> (i0_wb_dat_i >= 50 && i0_wb_dat_i <= 200)[*2];
	endproperty
	assert property(af_p111);

	property af_p112;
	@(posedge wb_clk_i) (i0_wb_stb_i) |=> !$isunknown(i0_wb_dat_o);
	endproperty
	assert property(af_p112);

	property af_p113;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> ##3 ((i0_wb_dat_o >= 0) && (i0_wb_dat_o <= 255));
	endproperty
	assert property(af_p113);

	property af_p114;
	@(posedge wb_clk_i) !(i0_wb_cyc_i && i0_wb_stb_i) |-> $stable(i0_wb_dat_o);
	endproperty
	assert property(af_p114);


	property af_p116;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (i0_wb_dat_o == '0);
	endproperty
	assert property(af_p116);

	property af_p117;
	@(posedge wb_clk_i) ((i0_wb_dat_o >= 100) && (i0_wb_dat_o <= 200)) |=> (i0_wb_dat_o >= 80) && (i0_wb_dat_o <= 220);
	endproperty
	assert property(af_p117);

	property af_p118;
	@(posedge wb_clk_i) (i0_wb_cyc_i) |-> ((i0_wb_dat_o >= 0) && (i0_wb_dat_o <= 255));
	endproperty
	assert property(af_p118);

	property af_p119;
	@(posedge wb_clk_i) !(i0_wb_cyc_i) |=> $stable(i0_wb_dat_o);
	endproperty
	assert property(af_p119);

	property af_p120;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i && i0_wb_ack_o) |-> !$isunknown(i0_wb_dat_o);
	endproperty
	assert property(af_p120);

	property af_p121;
	@(posedge wb_clk_i) (i0_wb_sel_i != '1) |-> !$isunknown(i0_wb_dat_o);
	endproperty
	assert property(af_p121);

	property af_p122;
	@(posedge wb_clk_i) (wb_rst_i) |=> (i0_wb_dat_o == '0);
	endproperty
	assert property(af_p122);

	property af_p123;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i && !i0_wb_we_i && i0_wb_ack_o) |-> !$isunknown(i0_wb_dat_o);
	endproperty
	assert property(af_p123);

	property af_p124;
	@(posedge wb_clk_i) (i0_wb_ack_o) |-> ##1 $stable(i0_wb_dat_o);
	endproperty
	assert property(af_p124);

	property af_p125;
	@(posedge wb_clk_i) ($fell(i0_wb_ack_o)) |-> $stable(i0_wb_dat_o);
	endproperty
	assert property(af_p125);

	property af_p126;
	@(posedge wb_clk_i) (i0_wb_cyc_i && !i0_wb_err_o) |-> (i0_wb_dat_o == i0_wb_dat_o);
	endproperty
	assert property(af_p126);

	property af_p127;
	@(posedge wb_clk_i) (i0_wb_ack_o) |=> $stable(i0_wb_dat_o);
	endproperty
	assert property(af_p127);

	property af_p128;
	@(posedge wb_clk_i) (i0_wb_we_i) |-> $stable(i0_wb_dat_o);
	endproperty
	assert property(af_p128);

	property af_p129;
	@(posedge wb_clk_i) (i0_wb_ack_o) |-> $stable(i0_wb_dat_o);
	endproperty
	assert property(af_p129);

	property af_p130;
	@(posedge wb_clk_i) (!i0_wb_we_i) |-> $stable(i0_wb_dat_o);
	endproperty
	assert property(af_p130);

	property af_p131;
	@(posedge wb_clk_i) (!wb_rst_i && i0_wb_ack_o) |-> (i0_wb_dat_o >= 0) && (i0_wb_dat_o <= 255);
	endproperty
	assert property(af_p131);

	property af_p132;
	@(posedge wb_clk_i) ($fell(i0_wb_cyc_i)) |=> $stable(i0_wb_dat_o);
	endproperty
	assert property(af_p132);

	property af_p133;
	@(posedge wb_clk_i) ($fell(i0_wb_stb_i)) |=> $stable(i0_wb_dat_o);
	endproperty
	assert property(af_p133);

	property af_p134;
	@(posedge wb_clk_i) (wb_rst_i) |=> ##4 (i0_wb_dat_o >= 0) && (i0_wb_dat_o <= 255);
	endproperty
	assert property(af_p134);

	property af_p135;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i0_wb_dat_o == 0);
	endproperty
	assert property(af_p135);

	property af_p136;
	@(posedge wb_clk_i) (!i0_wb_we_i) |-> (!$isunknown(i0_wb_dat_o));
	endproperty
	assert property(af_p136);

	property af_p137;
	@(posedge wb_clk_i) ((i0_wb_dat_o >= 50) && (i0_wb_dat_o <= 150)) |=> ((i0_wb_dat_o >= 30) && (i0_wb_dat_o <= 170));
	endproperty
	assert property(af_p137);

	property af_p138;
	@(posedge wb_clk_i) ($past(wb_rst_i) && !wb_rst_i) |-> (i0_wb_dat_o == 0) throughout (!i0_wb_ack_o)[->1];
	endproperty
	assert property(af_p138);

	property af_p139;
	@(posedge wb_clk_i) ($past(wb_rst_i,2) && !$past(wb_rst_i,1) && !wb_rst_i) |-> (!$isunknown(i0_wb_dat_o));
	endproperty
	assert property(af_p139);

	property af_p140;
	@(posedge wb_clk_i) (i0_wb_err_o) |-> ($stable(i0_wb_dat_o));
	endproperty
	assert property(af_p140);

	property af_p141;
	@(posedge wb_clk_i) ($past(wb_rst_i) && !wb_rst_i && (i0_wb_dat_o >= 10) && (i0_wb_dat_o <= 245)) |=> ((i0_wb_dat_o >= 0) && (i0_wb_dat_o <= 255)) [*2];
	endproperty
	assert property(af_p141);

	property af_p142;
	@(posedge wb_clk_i) (i0_wb_ack_o) |-> ($stable(i0_wb_dat_o) && !$isunknown(i0_wb_dat_o));
	endproperty
	assert property(af_p142);

	property af_p143;
	@(posedge wb_clk_i) (!i0_wb_stb_i) |=> ($stable(i0_wb_dat_o));
	endproperty
	assert property(af_p143);

	property af_p144;
	@(posedge wb_clk_i) (i0_wb_we_i) |=> ($stable(i0_wb_dat_o));
	endproperty
	assert property(af_p144);

	property af_p145;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:3] (i0_wb_err_o == 1'b0)[*3];
	endproperty
	assert property(af_p145);


	property af_p147;
	@(posedge wb_clk_i) i0_wb_err_o |-> (i0_wb_cyc_i && i0_wb_stb_i);
	endproperty
	assert property(af_p147);

	property af_p148;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i && (i0_wb_sel_i inside {4'b0001,4'b0010,4'b0100,4'b1000,4'b0011,4'b1100,4'b1111})) |-> !i0_wb_err_o;
	endproperty
	assert property(af_p148);

	property af_p149;
	@(posedge wb_clk_i) disable iff (wb_rst_i) $rose(i0_wb_err_o) |-> $past(i0_wb_cyc_i) && $past(i0_wb_we_i);
	endproperty
	assert property(af_p149);


	property af_p151;
	@(posedge wb_clk_i) !(i0_wb_err_o && i0_wb_ack_o);
	endproperty
	assert property(af_p151);

	property af_p152;
	@(posedge wb_clk_i) $fell(i0_wb_cyc_i) |-> ##1 (i0_wb_err_o == 1'b0);
	endproperty
	assert property(af_p152);

	property af_p153;
	@(posedge wb_clk_i) (i0_wb_err_o == 1'b0) || (i0_wb_err_o == 1'b1);
	endproperty
	assert property(af_p153);

	property af_p154;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> always i0_wb_err_o == 1'b0;
	endproperty
	assert property(af_p154);

	property af_p155;
	@(posedge wb_clk_i) (i0_wb_cyc_i && $changed(i0_wb_we_i)) |-> !i0_wb_err_o;
	endproperty
	assert property(af_p155);


	property af_p157;
	@(posedge wb_clk_i) (i0_wb_err_o) |-> (i0_wb_cyc_i && i0_wb_stb_i);
	endproperty
	assert property(af_p157);

	property af_p158;
	@(posedge wb_clk_i) (!i0_wb_stb_i) |-> (i0_wb_err_o == 1'b0);
	endproperty
	assert property(af_p158);

	property af_p159;
	@(posedge wb_clk_i) (!i0_wb_cyc_i) |=> (i0_wb_err_o == 1'b0);
	endproperty
	assert property(af_p159);

	property af_p160;
	@(posedge wb_clk_i) (i0_wb_we_i && i0_wb_ack_o) |-> (i0_wb_err_o == 1'b0);
	endproperty
	assert property(af_p160);

	property af_p161;
	@(posedge wb_clk_i) (i0_wb_we_i && i0_wb_stb_i && (i0_wb_dat_i !== 'x)) |-> (i0_wb_err_o == 1'b0);
	endproperty
	assert property(af_p161);

	property af_p162;
	@(posedge wb_clk_i) (!i0_wb_stb_i) |=> (i0_wb_err_o == 1'b0);
	endproperty
	assert property(af_p162);

	property af_p163;
	@(posedge wb_clk_i) ((i0_wb_stb_i && i0_wb_cyc_i) && $past(i0_wb_adr_i) !== i0_wb_adr_i && i0_wb_err_o) |=> (!i0_wb_err_o);
	endproperty
	assert property(af_p163);

	property af_p164;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i0_wb_err_o == 1'b0);
	endproperty
	assert property(af_p164);











	property af_p175;
	@(posedge wb_clk_i) (i0_wb_cyc_i && !i0_wb_ack_o) |=> $stable(i0_wb_sel_i);
	endproperty
	assert property(af_p175);

	property af_p176;
	@(posedge wb_clk_i) (!i0_wb_we_i && (i0_wb_sel_i != 4'b0000)) |-> !$isunknown(i0_wb_dat_o);
	endproperty
	assert property(af_p176);

	property af_p177;
	@(posedge wb_clk_i) (i0_wb_ack_o) |-> $stable(i0_wb_sel_i);
	endproperty
	assert property(af_p177);

	property af_p178;
	@(posedge wb_clk_i) (1'b1) |-> ((i0_wb_sel_i >= 4'd0) && (i0_wb_sel_i <= 4'd15));
	endproperty
	assert property(af_p178);

	property af_p179;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i && !i0_wb_ack_o) |=> $stable(i0_wb_sel_i);
	endproperty
	assert property(af_p179);

	property af_p180;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((i0_wb_sel_i >= 4'd0) && (i0_wb_sel_i <= 4'd15));
	endproperty
	assert property(af_p180);

	property af_p181;
	@(posedge wb_clk_i) (i0_wb_we_i) |-> $stable(i0_wb_sel_i) && $stable(i0_wb_dat_i);
	endproperty
	assert property(af_p181);

	property af_p182;
	@(posedge wb_clk_i) ((i0_wb_sel_i >= 4'd5) && (i0_wb_sel_i <= 4'd15)) |=> ((i0_wb_sel_i >= 4'd0) && (i0_wb_sel_i <= 4'd15))[*2];
	endproperty
	assert property(af_p182);

	property af_p183;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i) |-> $stable(i0_wb_sel_i);
	endproperty
	assert property(af_p183);

	property af_p184;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ((i0_wb_sel_i == 4'b0000) until_with i0_wb_stb_i);
	endproperty
	assert property(af_p184);

	property af_p185;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((i0_wb_sel_i >= 0) && (i0_wb_sel_i <= 15));
	endproperty
	assert property(af_p185);

	property af_p186;
	@(posedge wb_clk_i) (i0_wb_we_i && i0_wb_stb_i) |-> ((i0_wb_sel_i >= 1) && (i0_wb_sel_i <= 15));
	endproperty
	assert property(af_p186);

	property af_p187;
	@(posedge wb_clk_i) ($past(!wb_rst_i,4) && i0_wb_cyc_i) |-> ((i0_wb_sel_i >= 1) && (i0_wb_sel_i <= 15));
	endproperty
	assert property(af_p187);

	property af_p188;
	@(posedge wb_clk_i) (i0_wb_cyc_i) |-> ((i0_wb_sel_i >= 0) && (i0_wb_sel_i <= 15));
	endproperty
	assert property(af_p188);

	property af_p189;
	@(posedge wb_clk_i) ($changed(i0_wb_adr_i)) |-> ((i0_wb_sel_i >= 0) && (i0_wb_sel_i <= 15));
	endproperty
	assert property(af_p189);

	property af_p190;
	@(posedge wb_clk_i) (i0_wb_stb_i) |-> ((i0_wb_sel_i >= 0) && (i0_wb_sel_i <= 15));
	endproperty
	assert property(af_p190);

	property af_p191;
	@(posedge wb_clk_i) (!wb_rst_i && i0_wb_cyc_i) |-> ((i0_wb_sel_i >= 0) && (i0_wb_sel_i <= 15));
	endproperty
	assert property(af_p191);

	property af_p192;
	@(posedge wb_clk_i) ($past(!wb_rst_i,4) && !wb_rst_i) |-> ($stable(i0_wb_sel_i) && (i0_wb_sel_i >= 0) && (i0_wb_sel_i <= 15));
	endproperty
	assert property(af_p192);


	property af_p194;
	@(posedge wb_clk_i) ((i0_wb_sel_i >= 1) && (i0_wb_sel_i <= 7) && i0_wb_stb_i) |=> ((i0_wb_sel_i >= 0) && (i0_wb_sel_i <= 15));
	endproperty
	assert property(af_p194);

	property af_p195;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (i0_wb_sel_i == 0);
	endproperty
	assert property(af_p195);

	property af_p196;
	@(posedge wb_clk_i) ((i0_wb_sel_i >= 1) && (i0_wb_sel_i <= 15)) |=> ((i0_wb_sel_i >= 0) && (i0_wb_sel_i <= 15));
	endproperty
	assert property(af_p196);

	property af_p197;
	@(posedge wb_clk_i) (i0_wb_we_i && i0_wb_stb_i) |-> $stable(i0_wb_sel_i) && ((i0_wb_sel_i >= 0) && (i0_wb_sel_i <= 15));
	endproperty
	assert property(af_p197);

	property af_p198;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i0_wb_sel_i == 0);
	endproperty
	assert property(af_p198);

	property af_p199;
	@(posedge wb_clk_i) $rose(i0_wb_err_o) |=> (i0_wb_sel_i == 0);
	endproperty
	assert property(af_p199);

	property af_p200;
	@(posedge wb_clk_i) (i0_wb_stb_i && i0_wb_cyc_i) |-> ((i0_wb_sel_i >= 1) && (i0_wb_sel_i <= 15));
	endproperty
	assert property(af_p200);

	property af_p201;
	@(posedge wb_clk_i) ((i0_wb_sel_i >= 12) && (i0_wb_sel_i <= 15)) |-> ($stable(i0_wb_dat_i) && (i0_wb_dat_i !== 'x));
	endproperty
	assert property(af_p201);

	property af_p202;
	@(posedge wb_clk_i) (!i0_wb_stb_i) |-> (1'b1);
	endproperty
	assert property(af_p202);

	property af_p203;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i0_wb_stb_i == 1'b0) ##1 (i0_wb_stb_i == 1'b0);
	endproperty
	assert property(af_p203);

	property af_p204;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> (i0_wb_stb_i == 1'b0) ##1 (i0_wb_stb_i == 1'b0);
	endproperty
	assert property(af_p204);

	property af_p205;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i0_wb_stb_i == 1'b0) ##1 (i0_wb_stb_i == 1'b0) ##1 (i0_wb_stb_i == 1'b0);
	endproperty
	assert property(af_p205);

	property af_p206;
	@(posedge wb_clk_i) (i0_wb_ack_o) |=> (!i0_wb_stb_i && !i0_wb_cyc_i);
	endproperty
	assert property(af_p206);

	property af_p207;
	@(posedge wb_clk_i) (i0_wb_ack_o) |=> (!i0_wb_stb_i);
	endproperty
	assert property(af_p207);

	property af_p208;
	@(posedge wb_clk_i) (i0_wb_err_o) |-> !(i0_wb_stb_i);
	endproperty
	assert property(af_p208);

	property af_p209;
	@(posedge wb_clk_i) (i0_wb_stb_i && i0_wb_we_i) |=> $stable(i0_wb_dat_i);
	endproperty
	assert property(af_p209);

	property af_p210;
	@(posedge wb_clk_i) $stable(i0_wb_stb_i) or $changed(i0_wb_stb_i);
	endproperty
	assert property(af_p210);

	property af_p211;
	@(posedge wb_clk_i) (i0_wb_stb_i && !i0_wb_ack_o) |=> (i0_wb_stb_i || i0_wb_ack_o);
	endproperty
	assert property(af_p211);

	property af_p212;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i0_wb_stb_i == 1'b0);
	endproperty
	assert property(af_p212);

	property af_p213;
	@(posedge wb_clk_i) $rose(i0_wb_stb_i) |-> $past(!wb_rst_i);
	endproperty
	assert property(af_p213);

	property af_p214;
	@(posedge wb_clk_i) (i0_wb_cyc_i && $past(i0_wb_cyc_i)) |-> $stable(i0_wb_stb_i);
	endproperty
	assert property(af_p214);

	property af_p215;
	@(posedge wb_clk_i) (i0_wb_stb_i && i0_wb_we_i) |-> (i0_wb_sel_i != '0);
	endproperty
	assert property(af_p215);

	property af_p216;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> !i0_wb_stb_i;
	endproperty
	assert property(af_p216);

	property af_p217;
	@(posedge wb_clk_i) (i0_wb_stb_i && i0_wb_we_i) |-> !$isunknown(i0_wb_dat_i);
	endproperty
	assert property(af_p217);

	property af_p218;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (!i0_wb_stb_i)[*3];
	endproperty
	assert property(af_p218);

	property af_p219;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (!i0_wb_stb_i)[*2];
	endproperty
	assert property(af_p219);

	property af_p220;
	@(posedge wb_clk_i) i0_wb_stb_i |-> !$isunknown(i0_wb_adr_i);
	endproperty
	assert property(af_p220);

	property af_p221;
	@(posedge wb_clk_i) i0_wb_stb_i |-> i0_wb_cyc_i;
	endproperty
	assert property(af_p221);

	property af_p222;
	@(posedge wb_clk_i) i0_wb_err_o |-> !i0_wb_stb_i;
	endproperty
	assert property(af_p222);

	property af_p223;
	@(posedge wb_clk_i) (i0_wb_stb_i && $past(i0_wb_stb_i)) |-> $stable(i0_wb_adr_i);
	endproperty
	assert property(af_p223);

	property af_p224;
	@(posedge wb_clk_i) i0_wb_ack_o |=> !i0_wb_stb_i;
	endproperty
	assert property(af_p224);


	property af_p226;
	@(posedge wb_clk_i) (i0_wb_stb_i && !i0_wb_ack_o) |=> (i0_wb_stb_i);
	endproperty
	assert property(af_p226);

	property af_p227;
	@(posedge wb_clk_i) (i0_wb_stb_i && $past(i0_wb_stb_i)) |-> $stable(i0_wb_we_i);
	endproperty
	assert property(af_p227);

	property af_p228;
	@(posedge wb_clk_i) $rose(i0_wb_stb_i) |-> (i0_wb_stb_i throughout ((i0_wb_ack_o || i0_wb_err_o)[->1]));
	endproperty
	assert property(af_p228);

	property af_p229;
	@(posedge wb_clk_i) (i0_wb_stb_i) |-> (i0_wb_cyc_i);
	endproperty
	assert property(af_p229);

	property af_p230;
	@(posedge wb_clk_i) (i0_wb_err_o) |=> (!i0_wb_stb_i);
	endproperty
	assert property(af_p230);

	property af_p231;
	@(posedge wb_clk_i) $rose(i0_wb_stb_i && i0_wb_cyc_i) |-> (i0_wb_stb_i throughout (i0_wb_ack_o[->1]));
	endproperty
	assert property(af_p231);

	property af_p232;
	@(posedge wb_clk_i) (i0_wb_stb_i && $past(i0_wb_stb_i)) |-> $stable(i0_wb_sel_i);
	endproperty
	assert property(af_p232);

	property af_p233;
	@(posedge wb_clk_i) (i0_wb_stb_i) |-> ($past(i0_wb_cyc_i));
	endproperty
	assert property(af_p233);

	property af_p234;
	@(posedge wb_clk_i) disable iff (!i0_wb_cyc_i || !i0_wb_stb_i) $changed(i0_wb_we_i) |-> ##1 (i0_wb_we_i !== $past(i0_wb_we_i)) || (i0_wb_we_i === $past(i0_wb_we_i));
	endproperty
	assert property(af_p234);

	property af_p235;
	@(posedge wb_clk_i) $rose(i0_wb_we_i) |-> i0_wb_stb_i;
	endproperty
	assert property(af_p235);

	property af_p236;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i0_wb_we_i;
	endproperty
	assert property(af_p236);

	property af_p237;
	@(posedge wb_clk_i) i0_wb_cyc_i |-> !$isunknown(i0_wb_we_i);
	endproperty
	assert property(af_p237);

	property af_p238;
	@(posedge wb_clk_i) $changed(i0_wb_we_i) |-> !i0_wb_err_o || (i0_wb_adr_i < 0) || (i0_wb_adr_i > 32'hFFFFFFFF);
	endproperty
	assert property(af_p238);

	property af_p239;
	@(posedge wb_clk_i) (!i0_wb_we_i && i0_wb_cyc_i && i0_wb_stb_i && i0_wb_ack_o) |-> !$isunknown(i0_wb_dat_o);
	endproperty
	assert property(af_p239);

	property af_p240;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> !i0_wb_we_i ##1 !i0_wb_we_i;
	endproperty
	assert property(af_p240);


	property af_p242;
	@(posedge wb_clk_i) (i0_wb_we_i && i0_wb_stb_i && i0_wb_cyc_i) |-> ##[0:1] i0_wb_ack_o;
	endproperty
	assert property(af_p242);

	property af_p243;
	@(posedge wb_clk_i) i0_wb_ack_o |-> $past(i0_wb_we_i && i0_wb_stb_i);
	endproperty
	assert property(af_p243);

	property af_p244;
	@(posedge wb_clk_i) disable iff (wb_rst_i) $rose(i0_wb_we_i) |-> (i0_wb_cyc_i && i0_wb_stb_i);
	endproperty
	assert property(af_p244);

	property af_p245;
	@(posedge wb_clk_i) (!i0_wb_stb_i && !$past(i0_wb_stb_i)) |-> $stable(i0_wb_we_i);
	endproperty
	assert property(af_p245);



	property af_p248;
	@(posedge wb_clk_i) (i0_wb_we_i && i0_wb_cyc_i && i0_wb_stb_i) |-> !i0_wb_err_o;
	endproperty
	assert property(af_p248);

	property af_p249;
	@(posedge wb_clk_i) (i0_wb_cyc_i && $past(i0_wb_cyc_i)) |-> $stable(i0_wb_we_i);
	endproperty
	assert property(af_p249);

	property af_p250;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i) |-> !$isunknown(i0_wb_we_i);
	endproperty
	assert property(af_p250);

	property af_p251;
	@(posedge wb_clk_i) (i0_wb_we_i && i0_wb_ack_o) |-> !$isunknown(i0_wb_dat_i);
	endproperty
	assert property(af_p251);

	property af_p252;
	@(posedge wb_clk_i) (i0_wb_we_i && i0_wb_stb_i && i0_wb_cyc_i) |=> $stable(i0_wb_dat_i);
	endproperty
	assert property(af_p252);

	property af_p253;
	@(posedge wb_clk_i) (!i0_wb_we_i) |-> (!$isunknown(i0_wb_dat_o) && !$isunknown(i0_wb_adr_i));
	endproperty
	assert property(af_p253);

	property af_p254;
	@(posedge wb_clk_i) (i0_wb_we_i && i0_wb_cyc_i) |-> (!$isunknown(i0_wb_sel_i) && !$isunknown(i0_wb_dat_i));
	endproperty
	assert property(af_p254);

	property af_p255;
	@(posedge wb_clk_i) disable iff (!i0_wb_cyc_i) $stable(i0_wb_we_i);
	endproperty
	assert property(af_p255);

	property af_p256;
	@(posedge wb_clk_i) (i0_wb_cyc_i && i0_wb_stb_i && i0_wb_we_i) |-> ##[1:16] i0_wb_ack_o;
	endproperty
	assert property(af_p256);

	property af_p257;
	@(posedge wb_clk_i) (i0_wb_cyc_i && !i0_wb_ack_o) |-> $stable(i0_wb_we_i);
	endproperty
	assert property(af_p257);

	property af_p258;
	@(posedge wb_clk_i) (i0_wb_stb_i && !i0_wb_ack_o) |-> $stable(i0_wb_we_i);
	endproperty
	assert property(af_p258);

	property af_p259;
	@(posedge wb_clk_i) (!i0_wb_we_i && i0_wb_ack_o) |-> !$isunknown(i0_wb_dat_o);
	endproperty
	assert property(af_p259);

	property af_p260;
	@(posedge wb_clk_i) (!i0_wb_stb_i) |-> $stable(i0_wb_dat_o);
	endproperty
	assert property(af_p260);

	property af_p261;
	@(posedge wb_clk_i) (i0_wb_we_i && i0_wb_err_o) |-> !i0_wb_ack_o;
	endproperty
	assert property(af_p261);

	property af_p262;
	@(posedge wb_clk_i) (i0_wb_we_i && (i0_wb_sel_i != '0)) |-> ##1 $stable(i0_wb_dat_i & {8{i0_wb_sel_i}});
	endproperty
	assert property(af_p262);

	property af_p263;
	@(posedge wb_clk_i) (wb_rst_i) |-> !i0_wb_we_i;
	endproperty
	assert property(af_p263);

	property af_p264;
	@(posedge wb_clk_i) (i0_wb_we_i && i0_wb_ack_o) |-> ##1 (i0_wb_dat_o == $past(i0_wb_dat_i));
	endproperty
	assert property(af_p264);

	property af_p265;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> !i0_wb_we_i;
	endproperty
	assert property(af_p265);

	property af_p266;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i) |=> i1_wb_ack_o ##1 !i1_wb_ack_o;
	endproperty
	assert property(af_p266);

	property af_p267;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i1_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p267);

	property af_p268;
	@(posedge wb_clk_i) (i1_wb_stb_i && i1_wb_ack_o) |=> !i1_wb_ack_o;
	endproperty
	assert property(af_p268);

	property af_p269;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i1_wb_ack_o)[*2];
	endproperty
	assert property(af_p269);

	property af_p270;
	@(posedge wb_clk_i) (i1_wb_stb_i && i1_wb_cyc_i && i1_wb_ack_o) |=> !i1_wb_ack_o;
	endproperty
	assert property(af_p270);

	property af_p271;
	@(posedge wb_clk_i) $fell(i1_wb_cyc_i) |=> !i1_wb_ack_o;
	endproperty
	assert property(af_p271);

	property af_p272;
	@(posedge wb_clk_i) !(i1_wb_ack_o && i1_wb_err_o);
	endproperty
	assert property(af_p272);

	property af_p273;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(i1_wb_ack_o);
	endproperty
	assert property(af_p273);

	property af_p274;
	@(posedge wb_clk_i) (!i1_wb_cyc_i && !i1_wb_stb_i) |=> $stable(i1_wb_ack_o);
	endproperty
	assert property(af_p274);

	property af_p275;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i1_wb_ack_o == 1'b0) until (i1_wb_cyc_i && i1_wb_stb_i);
	endproperty
	assert property(af_p275);

	property af_p276;
	@(posedge wb_clk_i) (i1_wb_ack_o && !i1_wb_stb_i) |=> !i1_wb_ack_o;
	endproperty
	assert property(af_p276);

	property af_p277;
	@(posedge wb_clk_i) !i1_wb_cyc_i |-> !i1_wb_ack_o;
	endproperty
	assert property(af_p277);

	property af_p278;
	@(posedge wb_clk_i) i1_wb_stb_i |-> ##1 i1_wb_ack_o;
	endproperty
	assert property(af_p278);

	property af_p279;
	@(posedge wb_clk_i) i1_wb_ack_o |-> (i1_wb_cyc_i && i1_wb_stb_i);
	endproperty
	assert property(af_p279);

	property af_p280;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i && i1_wb_ack_o) |=> !i1_wb_ack_o;
	endproperty
	assert property(af_p280);

	property af_p281;
	@(posedge wb_clk_i) (!i1_wb_cyc_i && i1_wb_stb_i) |-> !i1_wb_ack_o;
	endproperty
	assert property(af_p281);

	property af_p282;
	@(posedge wb_clk_i) wb_rst_i |=> !i1_wb_ack_o;
	endproperty
	assert property(af_p282);

	property af_p283;
	@(posedge wb_clk_i) (i1_wb_we_i && i1_wb_stb_i && i1_wb_cyc_i) |-> i1_wb_ack_o;
	endproperty
	assert property(af_p283);

	property af_p284;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (!i1_wb_ack_o) ##1 (!i1_wb_ack_o);
	endproperty
	assert property(af_p284);

	property af_p285;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i) |=> i1_wb_ack_o;
	endproperty
	assert property(af_p285);

	property af_p286;
	@(posedge wb_clk_i) (wb_rst_i) |-> ##[0:1] !i1_wb_ack_o;
	endproperty
	assert property(af_p286);

	property af_p287;
	@(posedge wb_clk_i) (!i1_wb_cyc_i && !i1_wb_stb_i) |-> !i1_wb_ack_o;
	endproperty
	assert property(af_p287);

	property af_p288;
	@(posedge wb_clk_i) (i1_wb_ack_o && !i1_wb_we_i) |-> !$isunknown(i1_wb_dat_o);
	endproperty
	assert property(af_p288);

	property af_p289;
	@(posedge wb_clk_i) (!i1_wb_cyc_i) |-> !i1_wb_ack_o;
	endproperty
	assert property(af_p289);

	property af_p290;
	@(posedge wb_clk_i) (i1_wb_we_i && i1_wb_stb_i && i1_wb_cyc_i) |=> i1_wb_ack_o;
	endproperty
	assert property(af_p290);

	property af_p291;
	@(posedge wb_clk_i) (i1_wb_ack_o) |-> (i1_wb_stb_i && (i1_wb_sel_i != '0));
	endproperty
	assert property(af_p291);

	property af_p292;
	@(posedge wb_clk_i) ($rose(i1_wb_cyc_i) && i1_wb_stb_i) |-> !$isunknown(i1_wb_adr_i);
	endproperty
	assert property(af_p292);

	property af_p293;
	@(posedge wb_clk_i) (i1_wb_sel_i) |-> $stable(i1_wb_adr_i);
	endproperty
	assert property(af_p293);

	property af_p294;
	@(posedge wb_clk_i) (i1_wb_we_i) |-> $stable(i1_wb_adr_i);
	endproperty
	assert property(af_p294);

	property af_p295;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i && !i1_wb_ack_o) |=> $stable(i1_wb_adr_i);
	endproperty
	assert property(af_p295);

	property af_p296;
	@(posedge wb_clk_i) (i1_wb_cyc_i) |-> (i1_wb_adr_i >= 0) && (i1_wb_adr_i <= 4294967295);
	endproperty
	assert property(af_p296);

	property af_p297;
	@(posedge wb_clk_i) (i1_wb_we_i && i1_wb_stb_i && !i1_wb_ack_o) |=> $stable(i1_wb_adr_i);
	endproperty
	assert property(af_p297);

	property af_p298;
	@(posedge wb_clk_i) (|i1_wb_sel_i) |-> !$isunknown(i1_wb_adr_i);
	endproperty
	assert property(af_p298);

	property af_p299;
	@(posedge wb_clk_i) (i1_wb_stb_i && !i1_wb_ack_o) |-> $stable(i1_wb_adr_i);
	endproperty
	assert property(af_p299);

	property af_p300;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i1_wb_adr_i == '0);
	endproperty
	assert property(af_p300);

	property af_p301;
	@(posedge wb_clk_i) (i1_wb_stb_i && !i1_wb_ack_o) |-> ##1 $stable(i1_wb_adr_i);
	endproperty
	assert property(af_p301);


	property af_p303;
	@(posedge wb_clk_i) ($past(i1_wb_stb_i) && (i1_wb_adr_i != $past(i1_wb_adr_i))) |-> !$past(i1_wb_stb_i);
	endproperty
	assert property(af_p303);

	property af_p304;
	@(posedge wb_clk_i) ($fell(wb_rst_i) && i1_wb_we_i && i1_wb_stb_i) |=> (i1_wb_adr_i == $past(i1_wb_dat_i));
	endproperty
	assert property(af_p304);

	property af_p305;
	@(posedge wb_clk_i) (!i1_wb_cyc_i) |-> $stable(i1_wb_adr_i);
	endproperty
	assert property(af_p305);

	property af_p306;
	@(posedge wb_clk_i) $rose(i1_wb_ack_o) |=> (i1_wb_adr_i != $past(i1_wb_adr_i)) or $stable(i1_wb_adr_i);
	endproperty
	assert property(af_p306);

	property af_p307;
	@(posedge wb_clk_i) (wb_rst_i) |=> (!$isunknown(i1_wb_adr_i));
	endproperty
	assert property(af_p307);

	property af_p308;
	@(posedge wb_clk_i) (i1_wb_stb_i) |-> (!$isunknown(i1_wb_adr_i));
	endproperty
	assert property(af_p308);

	property af_p309;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##3 (!$isunknown(i1_wb_adr_i));
	endproperty
	assert property(af_p309);


	property af_p311;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 !$isunknown(i1_wb_adr_i) ##1 !$isunknown(i1_wb_adr_i);
	endproperty
	assert property(af_p311);

	property af_p312;
	@(posedge wb_clk_i) ((i1_wb_sel_i != '0) && i1_wb_cyc_i) |-> $stable(i1_wb_adr_i) throughout ((i1_wb_ack_o || i1_wb_err_o)[->1]);
	endproperty
	assert property(af_p312);

	property af_p313;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i) |-> ##1 (i1_wb_ack_o || $stable(i1_wb_adr_i));
	endproperty
	assert property(af_p313);

	property af_p314;
	@(posedge wb_clk_i) i1_wb_we_i |-> $stable(i1_wb_adr_i) throughout (i1_wb_we_i[->1]);
	endproperty
	assert property(af_p314);

	property af_p315;
	@(posedge wb_clk_i) (i1_wb_cyc_i && $changed(i1_wb_adr_i)) |-> $past(i1_wb_ack_o);
	endproperty
	assert property(af_p315);

	property af_p316;
	@(posedge wb_clk_i) (!i1_wb_cyc_i) |-> ##1 (1);
	endproperty
	assert property(af_p316);

	property af_p317;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 $stable(i1_wb_adr_i) throughout (!i1_wb_stb_i)[->1];
	endproperty
	assert property(af_p317);

	property af_p318;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i) |-> $stable(i1_wb_adr_i) throughout (i1_wb_ack_o[->1]);
	endproperty
	assert property(af_p318);

	property af_p319;
	@(posedge wb_clk_i) (i1_wb_ack_o && !$isunknown(i1_wb_adr_i)) |-> ##1 (1);
	endproperty
	assert property(af_p319);

	property af_p320;
	@(posedge wb_clk_i) ($rose(i1_wb_cyc_i)) |-> (i1_wb_stb_i);
	endproperty
	assert property(af_p320);

	property af_p321;
	@(posedge wb_clk_i) (i1_wb_cyc_i) |-> ##[1:16] (i1_wb_ack_o);
	endproperty
	assert property(af_p321);

	property af_p322;
	@(posedge wb_clk_i) (i1_wb_cyc_i) |-> (i1_wb_stb_i);
	endproperty
	assert property(af_p322);

	property af_p323;
	@(posedge wb_clk_i) (i1_wb_err_o) |=> (!i1_wb_cyc_i);
	endproperty
	assert property(af_p323);

	property af_p324;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i && i1_wb_we_i) |-> (!$isunknown(i1_wb_dat_i));
	endproperty
	assert property(af_p324);

	property af_p325;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_ack_o && i1_wb_stb_i) |=> (i1_wb_cyc_i);
	endproperty
	assert property(af_p325);

	property af_p326;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:$] (i1_wb_cyc_i);
	endproperty
	assert property(af_p326);

	property af_p327;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i1_wb_cyc_i !== i1_wb_cyc_i) |-> (i1_wb_stb_i === i1_wb_stb_i);
	endproperty
	assert property(af_p327);

	property af_p328;
	@(posedge wb_clk_i) (!i1_wb_cyc_i) |=> (!i1_wb_ack_o && !i1_wb_err_o);
	endproperty
	assert property(af_p328);

	property af_p329;
	@(posedge wb_clk_i) (i1_wb_cyc_i && !i1_wb_ack_o) |=> (i1_wb_cyc_i || $past(i1_wb_ack_o));
	endproperty
	assert property(af_p329);

	property af_p330;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!i1_wb_cyc_i);
	endproperty
	assert property(af_p330);

	property af_p331;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_we_i) |=> ($past(i1_wb_dat_i) === i1_wb_dat_i);
	endproperty
	assert property(af_p331);

	property af_p332;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!i1_wb_cyc_i ##1 !i1_wb_cyc_i);
	endproperty
	assert property(af_p332);

	property af_p333;
	@(posedge wb_clk_i) i1_wb_cyc_i |-> i1_wb_stb_i;
	endproperty
	assert property(af_p333);

	property af_p334;
	@(posedge wb_clk_i) wb_rst_i |-> !i1_wb_cyc_i;
	endproperty
	assert property(af_p334);

	property af_p335;
	@(posedge wb_clk_i) !i1_wb_cyc_i |-> !i1_wb_stb_i;
	endproperty
	assert property(af_p335);

	property af_p336;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i) |-> !$isunknown(i1_wb_sel_i);
	endproperty
	assert property(af_p336);

	property af_p337;
	@(posedge wb_clk_i) i1_wb_cyc_i |-> (i1_wb_cyc_i throughout (!i1_wb_ack_o[*0:$] ##1 i1_wb_ack_o));
	endproperty
	assert property(af_p337);

	property af_p338;
	@(posedge wb_clk_i) i1_wb_ack_o |-> $past(i1_wb_cyc_i && i1_wb_stb_i);
	endproperty
	assert property(af_p338);



	property af_p341;
	@(posedge wb_clk_i) $fell(i1_wb_cyc_i) |-> ##[0:1] !i1_wb_stb_i;
	endproperty
	assert property(af_p341);

	property af_p342;
	@(posedge wb_clk_i) (i1_wb_cyc_i && !i1_wb_ack_o && !i1_wb_err_o) |=> i1_wb_cyc_i;
	endproperty
	assert property(af_p342);

	property af_p343;
	@(posedge wb_clk_i) i1_wb_cyc_i |=> $stable(i1_wb_cyc_i) || i1_wb_ack_o || i1_wb_err_o;
	endproperty
	assert property(af_p343);

	property af_p344;
	@(posedge wb_clk_i) i1_wb_err_o |=> !i1_wb_cyc_i;
	endproperty
	assert property(af_p344);

	property af_p345;
	@(posedge wb_clk_i) i1_wb_cyc_i |-> $stable(i1_wb_we_i) && !$isunknown(i1_wb_we_i);
	endproperty
	assert property(af_p345);

	property af_p346;
	@(posedge wb_clk_i) i1_wb_cyc_i |-> $stable(i1_wb_adr_i) && !$isunknown(i1_wb_adr_i);
	endproperty
	assert property(af_p346);

	property af_p347;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i) |-> ##[1:16] i1_wb_ack_o;
	endproperty
	assert property(af_p347);

	property af_p348;
	@(posedge wb_clk_i) i1_wb_err_o |-> !i1_wb_cyc_i;
	endproperty
	assert property(af_p348);

	property af_p349;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i) |-> (i1_wb_cyc_i throughout (i1_wb_ack_o || i1_wb_err_o)[->1]);
	endproperty
	assert property(af_p349);

	property af_p350;
	@(posedge wb_clk_i) wb_rst_i |=> !i1_wb_cyc_i;
	endproperty
	assert property(af_p350);

	property af_p351;
	@(posedge wb_clk_i) $changed(i1_wb_cyc_i) |-> $past(i1_wb_ack_o) || $past(i1_wb_err_o) || $past(!i1_wb_cyc_i);
	endproperty
	assert property(af_p351);

	property af_p352;
	@(posedge wb_clk_i) wb_rst_i |=> (!i1_wb_cyc_i)[*2];
	endproperty
	assert property(af_p352);

	property af_p353;
	@(posedge wb_clk_i) (!i1_wb_we_i && i1_wb_cyc_i && i1_wb_stb_i) |=> ((i1_wb_dat_i >= 0) && (i1_wb_dat_i <= 255));
	endproperty
	assert property(af_p353);

	property af_p354;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i && i1_wb_we_i) |-> !$isunknown(i1_wb_dat_i);
	endproperty
	assert property(af_p354);

	property af_p355;
	@(posedge wb_clk_i) ((i1_wb_dat_i >= 100) && (i1_wb_dat_i <= 200)) |=> ((i1_wb_dat_i >= 80) && (i1_wb_dat_i <= 220));
	endproperty
	assert property(af_p355);

	property af_p356;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((i1_wb_dat_i >= 0) && (i1_wb_dat_i <= 255));
	endproperty
	assert property(af_p356);

	property af_p357;
	@(posedge wb_clk_i) (i1_wb_cyc_i && !i1_wb_ack_o) |=> $stable(i1_wb_dat_i);
	endproperty
	assert property(af_p357);

	property af_p358;
	@(posedge wb_clk_i) i1_wb_stb_i |=> ((i1_wb_dat_i >= 60) && (i1_wb_dat_i <= 190));
	endproperty
	assert property(af_p358);

	property af_p359;
	@(posedge wb_clk_i) (i1_wb_stb_i && i1_wb_cyc_i) |-> $stable(i1_wb_dat_i);
	endproperty
	assert property(af_p359);

	property af_p360;
	@(posedge wb_clk_i) ((i1_wb_dat_i >= 50) && (i1_wb_dat_i <= 200)) |=> ((i1_wb_dat_i >= 30) && (i1_wb_dat_i <= 220));
	endproperty
	assert property(af_p360);

	property af_p361;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((i1_wb_dat_i >= 50) && (i1_wb_dat_i <= 120));
	endproperty
	assert property(af_p361);

	property af_p362;
	@(posedge wb_clk_i) (!i1_wb_stb_i) |=> $stable(i1_wb_dat_i);
	endproperty
	assert property(af_p362);

	property af_p363;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ((i1_wb_dat_i >= 0) && (i1_wb_dat_i <= 15));
	endproperty
	assert property(af_p363);

	property af_p364;
	@(posedge wb_clk_i) ((i1_wb_dat_i >= 200) && (i1_wb_dat_i <= 255)) |=> ((i1_wb_dat_i >= 180) && (i1_wb_dat_i <= 255));
	endproperty
	assert property(af_p364);

	property af_p365;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i1_wb_dat_i == 0);
	endproperty
	assert property(af_p365);

	property af_p366;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (i1_wb_dat_i >= 0) && (i1_wb_dat_i <= 255);
	endproperty
	assert property(af_p366);

	property af_p367;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:2] (i1_wb_dat_i >= 0) && (i1_wb_dat_i <= 255);
	endproperty
	assert property(af_p367);

	property af_p368;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##3 (i1_wb_dat_i >= 10) && (i1_wb_dat_i <= 245);
	endproperty
	assert property(af_p368);

	property af_p369;
	@(posedge wb_clk_i) (i1_wb_ack_o) |-> ($stable(i1_wb_dat_i));
	endproperty
	assert property(af_p369);

	property af_p370;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 (i1_wb_dat_i >= 10) && (i1_wb_dat_i <= 90);
	endproperty
	assert property(af_p370);

	property af_p371;
	@(posedge wb_clk_i) ((i1_wb_dat_i >= 100) && (i1_wb_dat_i <= 255)) |-> ##1 (i1_wb_dat_i >= 80) && (i1_wb_dat_i <= 255);
	endproperty
	assert property(af_p371);

	property af_p372;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 (i1_wb_dat_i >= 0) && (i1_wb_dat_i <= 60);
	endproperty
	assert property(af_p372);

	property af_p373;
	@(posedge wb_clk_i) (i1_wb_sel_i == 2'b01) |-> (i1_wb_dat_i[7:0] >= 0) && (i1_wb_dat_i[7:0] <= 255);
	endproperty
	assert property(af_p373);

	property af_p374;
	@(posedge wb_clk_i) (!i1_wb_we_i) |-> (i1_wb_dat_i >= 0) && (i1_wb_dat_i <= 255);
	endproperty
	assert property(af_p374);

	property af_p375;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##1 (i1_wb_dat_i >= 0) && (i1_wb_dat_i <= 10);
	endproperty
	assert property(af_p375);

	property af_p376;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i && i1_wb_we_i && !i1_wb_ack_o) |=> ($stable(i1_wb_dat_i) || i1_wb_ack_o);
	endproperty
	assert property(af_p376);

	property af_p377;
	@(posedge wb_clk_i) (i1_wb_cyc_i && !$stable(i1_wb_dat_i)) |-> $past(!i1_wb_ack_o);
	endproperty
	assert property(af_p377);

	property af_p378;
	@(posedge wb_clk_i) ($past(!wb_rst_i,4)) |-> ((i1_wb_dat_i >= 0) && (i1_wb_dat_i <= 128));
	endproperty
	assert property(af_p378);

	property af_p379;
	@(posedge wb_clk_i) (i1_wb_stb_i && i1_wb_cyc_i && !i1_wb_ack_o) |=> $stable(i1_wb_dat_i);
	endproperty
	assert property(af_p379);

	property af_p380;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((i1_wb_dat_i >= 0) && (i1_wb_dat_i <= 255));
	endproperty
	assert property(af_p380);

	property af_p381;
	@(posedge wb_clk_i) (i1_wb_sel_i[0] && !i1_wb_sel_i[1]) |-> ((i1_wb_dat_i[7:0] >= 0) && (i1_wb_dat_i[7:0] <= 255));
	endproperty
	assert property(af_p381);

	property af_p382;
	@(posedge wb_clk_i) (i1_wb_cyc_i && (i1_wb_dat_i >= 10) && (i1_wb_dat_i <= 25)) |-> ((i1_wb_dat_i >= 5) && (i1_wb_dat_i <= 30)) throughout (i1_wb_cyc_i[*1:$]);
	endproperty
	assert property(af_p382);

	property af_p383;
	@(posedge wb_clk_i) (i1_wb_we_i && i1_wb_cyc_i && i1_wb_stb_i) |-> ((i1_wb_dat_i >= 0) && (i1_wb_dat_i <= 255));
	endproperty
	assert property(af_p383);

	property af_p384;
	@(posedge wb_clk_i) ((i1_wb_dat_i >= 100) && (i1_wb_dat_i <= 150)) |=> ((i1_wb_dat_i >= 80) && (i1_wb_dat_i <= 150));
	endproperty
	assert property(af_p384);

	property af_p385;
	@(posedge wb_clk_i) ((i1_wb_dat_i >= 50) && (i1_wb_dat_i <= 75)) |=> ((i1_wb_dat_i >= 30) && (i1_wb_dat_i <= 100));
	endproperty
	assert property(af_p385);

	property af_p386;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (i1_wb_dat_o >= 0) && (i1_wb_dat_o <= 255);
	endproperty
	assert property(af_p386);

	property af_p387;
	@(posedge wb_clk_i) (!i1_wb_cyc_i) |=> $stable(i1_wb_dat_o);
	endproperty
	assert property(af_p387);

	property af_p388;
	@(posedge wb_clk_i) (i1_wb_stb_i) |=> ((i1_wb_dat_o >= 50) && (i1_wb_dat_o <= 150)) [*2];
	endproperty
	assert property(af_p388);

	property af_p389;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i && !i1_wb_ack_o) |=> (i1_wb_ack_o || $stable(i1_wb_dat_o));
	endproperty
	assert property(af_p389);

	property af_p390;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i && i1_wb_ack_o && !$stable(i1_wb_dat_o)) |-> (i1_wb_cyc_i && i1_wb_stb_i && i1_wb_ack_o);
	endproperty
	assert property(af_p390);

	property af_p391;
	@(posedge wb_clk_i) (i1_wb_stb_i && i1_wb_cyc_i && !i1_wb_we_i) |-> (i1_wb_dat_o !== 'x);
	endproperty
	assert property(af_p391);

	property af_p392;
	@(posedge wb_clk_i) ((i1_wb_dat_o >= 100) && (i1_wb_dat_o <= 200) && i1_wb_cyc_i) |=> (i1_wb_dat_o >= 90) && (i1_wb_dat_o <= 210);
	endproperty
	assert property(af_p392);

	property af_p393;
	@(posedge wb_clk_i) ((i1_wb_dat_o >= 0) && (i1_wb_dat_o <= 127)) |=> ((i1_wb_dat_o >= 0) && (i1_wb_dat_o <= 255));
	endproperty
	assert property(af_p393);

	property af_p394;
	@(posedge wb_clk_i) (!i1_wb_ack_o) |-> $stable(i1_wb_dat_o);
	endproperty
	assert property(af_p394);

	property af_p395;
	@(posedge wb_clk_i) (wb_rst_i) |=> (i1_wb_dat_o == 0);
	endproperty
	assert property(af_p395);

	property af_p396;
	@(posedge wb_clk_i) (!(i1_wb_stb_i && i1_wb_cyc_i)) |-> $stable(i1_wb_dat_o);
	endproperty
	assert property(af_p396);

	property af_p397;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i1_wb_dat_o == 0);
	endproperty
	assert property(af_p397);

	property af_p398;
	@(posedge wb_clk_i) (i1_wb_err_o) |-> $stable(i1_wb_dat_o);
	endproperty
	assert property(af_p398);

	property af_p399;
	@(posedge wb_clk_i) (!i1_wb_stb_i) |-> $stable(i1_wb_dat_o);
	endproperty
	assert property(af_p399);

	property af_p400;
	@(posedge wb_clk_i) (!i1_wb_we_i && i1_wb_ack_o) |-> $isunknown(i1_wb_dat_o) === 0;
	endproperty
	assert property(af_p400);


	property af_p402;
	@(posedge wb_clk_i) (i1_wb_we_i) |-> $stable(i1_wb_dat_o);
	endproperty
	assert property(af_p402);

	property af_p403;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 (i1_wb_dat_o >= 0 && i1_wb_dat_o <= 255);
	endproperty
	assert property(af_p403);

	property af_p404;
	@(posedge wb_clk_i) (!i1_wb_cyc_i) |-> $stable(i1_wb_dat_o);
	endproperty
	assert property(af_p404);

	property af_p405;
	@(posedge wb_clk_i) $fell(i1_wb_ack_o) |-> ##1 $stable(i1_wb_dat_o);
	endproperty
	assert property(af_p405);

	property af_p406;
	@(posedge wb_clk_i) (i1_wb_err_o && !$past(i1_wb_err_o)) |=> $stable(i1_wb_err_o) || !i1_wb_err_o;
	endproperty
	assert property(af_p406);

	property af_p407;
	@(posedge wb_clk_i) ($fell(i1_wb_cyc_i)) |=> !i1_wb_err_o;
	endproperty
	assert property(af_p407);

	property af_p408;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i1_wb_err_o) until (i1_wb_cyc_i && i1_wb_stb_i);
	endproperty
	assert property(af_p408);

	property af_p409;
	@(posedge wb_clk_i) (wb_rst_i) |-> !i1_wb_err_o;
	endproperty
	assert property(af_p409);

	property af_p410;
	@(posedge wb_clk_i) (i1_wb_err_o) |-> ##1 (!i1_wb_cyc_i -> !i1_wb_err_o);
	endproperty
	assert property(af_p410);

	property af_p411;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i1_wb_err_o ##1 !i1_wb_err_o);
	endproperty
	assert property(af_p411);


	property af_p413;
	@(posedge wb_clk_i) (i1_wb_err_o && !i1_wb_cyc_i) |=> !i1_wb_err_o;
	endproperty
	assert property(af_p413);

	property af_p414;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i && i1_wb_we_i && (i1_wb_sel_i != '0)) |-> !i1_wb_err_o;
	endproperty
	assert property(af_p414);

	property af_p415;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i) |-> !(i1_wb_err_o && i1_wb_ack_o);
	endproperty
	assert property(af_p415);

	property af_p416;
	@(posedge wb_clk_i) (i1_wb_err_o && !i1_wb_cyc_i) |=> (i1_wb_err_o == 1'b0);
	endproperty
	assert property(af_p416);

	property af_p417;
	@(posedge wb_clk_i) (!i1_wb_cyc_i && $changed(i1_wb_dat_i)) |-> (i1_wb_err_o == $past(i1_wb_err_o));
	endproperty
	assert property(af_p417);

	property af_p418;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i && i1_wb_we_i && !i1_wb_err_o) |-> !i1_wb_err_o;
	endproperty
	assert property(af_p418);

	property af_p419;
	@(posedge wb_clk_i) !i1_wb_stb_i |-> (i1_wb_err_o == 1'b0);
	endproperty
	assert property(af_p419);

	property af_p420;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i1_wb_err_o == 1'b0) ##1 (i1_wb_err_o == 1'b0);
	endproperty
	assert property(af_p420);

	property af_p421;
	@(posedge wb_clk_i) !(i1_wb_err_o && i1_wb_ack_o);
	endproperty
	assert property(af_p421);

	property af_p422;
	@(posedge wb_clk_i) (!i1_wb_cyc_i && !i1_wb_stb_i) |-> (i1_wb_err_o == 1'b0);
	endproperty
	assert property(af_p422);

	property af_p423;
	@(posedge wb_clk_i) i1_wb_err_o |-> (i1_wb_cyc_i && i1_wb_stb_i);
	endproperty
	assert property(af_p423);

	property af_p424;
	@(posedge wb_clk_i) (i1_wb_we_i && |i1_wb_sel_i) |-> (i1_wb_err_o == 1'b0);
	endproperty
	assert property(af_p424);

	property af_p425;
	@(posedge wb_clk_i) i1_wb_err_o |-> i1_wb_cyc_i;
	endproperty
	assert property(af_p425);

	property af_p426;
	@(posedge wb_clk_i) (!i1_wb_cyc_i && !$past(i1_wb_cyc_i)) |-> (i1_wb_err_o == 1'b0) && ($past(i1_wb_err_o) == 1'b0);
	endproperty
	assert property(af_p426);

	property af_p427;
	@(posedge wb_clk_i) disable iff (wb_rst_i) i1_wb_err_o |-> $past(i1_wb_cyc_i) && $past(i1_wb_stb_i);
	endproperty
	assert property(af_p427);

	property af_p428;
	@(posedge wb_clk_i) wb_rst_i |-> !i1_wb_err_o;
	endproperty
	assert property(af_p428);

	property af_p429;
	@(posedge wb_clk_i) disable iff (wb_rst_i) i1_wb_err_o |=> (i1_wb_dat_o == $past(i1_wb_dat_o)) throughout !(i1_wb_cyc_i && i1_wb_stb_i && i1_wb_ack_o)[->1];
	endproperty
	assert property(af_p429);

	property af_p430;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i1_wb_cyc_i && i1_wb_stb_i && !i1_wb_we_i) |-> !i1_wb_err_o;
	endproperty
	assert property(af_p430);

	property af_p431;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i1_wb_sel_i == '0 && i1_wb_cyc_i) |=> i1_wb_err_o;
	endproperty
	assert property(af_p431);

	property af_p432;
	@(posedge wb_clk_i) disable iff (wb_rst_i) $rose(i1_wb_err_o) |=> !i1_wb_err_o;
	endproperty
	assert property(af_p432);

	property af_p433;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i1_wb_err_o && i1_wb_cyc_i) |-> !i1_wb_ack_o;
	endproperty
	assert property(af_p433);

	property af_p434;
	@(posedge wb_clk_i) disable iff (wb_rst_i) !(i1_wb_err_o && i1_wb_ack_o);
	endproperty
	assert property(af_p434);

	property af_p435;
	@(posedge wb_clk_i) disable iff (wb_rst_i) !i1_wb_stb_i |=> !i1_wb_err_o;
	endproperty
	assert property(af_p435);

	property af_p436;
	@(posedge wb_clk_i) disable iff (wb_rst_i) i1_wb_err_o |-> !i1_wb_ack_o;
	endproperty
	assert property(af_p436);

	property af_p437;
	@(posedge wb_clk_i) (i1_wb_err_o === 1'b0) || (i1_wb_err_o === 1'b1);
	endproperty
	assert property(af_p437);

	property af_p438;
	@(posedge wb_clk_i) 1'b1 |-> $stable(i1_wb_sel_i) throughout (@(posedge wb_clk_i) 1'b1);
	endproperty
	assert property(af_p438);

	property af_p439;
	@(posedge wb_clk_i) (i1_wb_stb_i) |-> $stable(i1_wb_sel_i);
	endproperty
	assert property(af_p439);

	property af_p440;
	@(posedge wb_clk_i) (i1_wb_we_i) |-> (i1_wb_sel_i != 4'b0000);
	endproperty
	assert property(af_p440);

	property af_p441;
	@(posedge wb_clk_i) (i1_wb_stb_i) |-> (i1_wb_sel_i != 4'b0000);
	endproperty
	assert property(af_p441);

	property af_p442;
	@(posedge wb_clk_i) ((i1_wb_sel_i >= 4) && (i1_wb_sel_i <= 7)) |=> (i1_wb_sel_i >= 0) && (i1_wb_sel_i <= 15);
	endproperty
	assert property(af_p442);

	property af_p443;
	@(posedge wb_clk_i) (i1_wb_we_i && i1_wb_stb_i) |-> (i1_wb_sel_i != 4'b0000);
	endproperty
	assert property(af_p443);

	property af_p444;
	@(posedge wb_clk_i) (i1_wb_we_i && (i1_wb_sel_i >= 8) && (i1_wb_sel_i <= 15)) |=> (i1_wb_sel_i >= 8) && (i1_wb_sel_i <= 15);
	endproperty
	assert property(af_p444);

	property af_p445;
	@(posedge wb_clk_i) (i1_wb_stb_i throughout (i1_wb_stb_i[->1] ##0 i1_wb_ack_o[->1])) |-> $stable(i1_wb_sel_i);
	endproperty
	assert property(af_p445);

	property af_p446;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i1_wb_sel_i == 4'b0000);
	endproperty
	assert property(af_p446);

	property af_p447;
	@(posedge wb_clk_i) (!i1_wb_stb_i) |-> ($past(i1_wb_sel_i) == i1_wb_sel_i);
	endproperty
	assert property(af_p447);

	property af_p448;
	@(posedge wb_clk_i) (!i1_wb_we_i) |-> (!$isunknown(i1_wb_sel_i) && !$isunknown(i1_wb_dat_o));
	endproperty
	assert property(af_p448);

	property af_p449;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i1_wb_sel_i == '0);
	endproperty
	assert property(af_p449);

	property af_p450;
	@(posedge wb_clk_i) (!i1_wb_ack_o && !$past(i1_wb_ack_o)) |-> $stable(i1_wb_sel_i);
	endproperty
	assert property(af_p450);

	property af_p451;
	@(posedge wb_clk_i) (i1_wb_cyc_i && $past(i1_wb_cyc_i) && !i1_wb_stb_i) |-> ($stable(i1_wb_sel_i));
	endproperty
	assert property(af_p451);

	property af_p452;
	@(posedge wb_clk_i) (!wb_rst_i && i1_wb_cyc_i && i1_wb_stb_i) |-> !$isunknown(i1_wb_sel_i);
	endproperty
	assert property(af_p452);

	property af_p453;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i) |-> !$isunknown(i1_wb_sel_i);
	endproperty
	assert property(af_p453);

	property af_p454;
	@(posedge wb_clk_i) ($fell(wb_rst_i) ##3 1'b1) |-> (i1_wb_sel_i >= 0 && i1_wb_sel_i <= 15);
	endproperty
	assert property(af_p454);

	property af_p455;
	@(posedge wb_clk_i) (i1_wb_cyc_i && $past(i1_wb_cyc_i)) |-> $stable(i1_wb_sel_i);
	endproperty
	assert property(af_p455);

	property af_p456;
	@(posedge wb_clk_i) (!i1_wb_cyc_i) |-> $stable(i1_wb_sel_i);
	endproperty
	assert property(af_p456);

	property af_p457;
	@(posedge wb_clk_i) (i1_wb_cyc_i) |=> (!$isunknown(i1_wb_sel_i));
	endproperty
	assert property(af_p457);

	property af_p458;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i) |-> $stable(i1_wb_sel_i);
	endproperty
	assert property(af_p458);

	property af_p459;
	@(posedge wb_clk_i) i1_wb_ack_o |-> $stable(i1_wb_sel_i);
	endproperty
	assert property(af_p459);

	property af_p460;
	@(posedge wb_clk_i) i1_wb_stb_i |-> (i1_wb_sel_i >= 1 && i1_wb_sel_i <= 15);
	endproperty
	assert property(af_p460);

	property af_p461;
	@(posedge wb_clk_i) i1_wb_cyc_i |-> $stable(i1_wb_sel_i);
	endproperty
	assert property(af_p461);

	property af_p462;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (i1_wb_sel_i >= 0 && i1_wb_sel_i <= 15);
	endproperty
	assert property(af_p462);

	property af_p463;
	@(posedge wb_clk_i) wb_rst_i |-> !i1_wb_ack_o;
	endproperty
	assert property(af_p463);

	property af_p464;
	@(posedge wb_clk_i) i1_wb_ack_o |-> ($past(i1_wb_stb_i,1) && $stable(i1_wb_sel_i));
	endproperty
	assert property(af_p464);

	property af_p465;
	@(posedge wb_clk_i) (!wb_rst_i && i1_wb_stb_i) |-> !$isunknown(i1_wb_sel_i);
	endproperty
	assert property(af_p465);

	property af_p466;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 (i1_wb_sel_i >= 0 && i1_wb_sel_i <= 15);
	endproperty
	assert property(af_p466);

	property af_p467;
	@(posedge wb_clk_i) (i1_wb_sel_i >= 0 && i1_wb_sel_i <= 15) |=> (i1_wb_sel_i >= 0 && i1_wb_sel_i <= 15);
	endproperty
	assert property(af_p467);

	property af_p468;
	@(posedge wb_clk_i) (i1_wb_stb_i && !i1_wb_ack_o && !i1_wb_err_o) |-> ##[1:8] (i1_wb_ack_o || i1_wb_err_o);
	endproperty
	assert property(af_p468);

	property af_p469;
	@(posedge wb_clk_i) $rose(i1_wb_stb_i) |-> ($stable(i1_wb_stb_i) until i1_wb_ack_o);
	endproperty
	assert property(af_p469);

	property af_p470;
	@(posedge wb_clk_i) $rose(i1_wb_stb_i) |-> (i1_wb_stb_i until (i1_wb_ack_o || i1_wb_err_o));
	endproperty
	assert property(af_p470);

	property af_p471;
	@(posedge wb_clk_i) (i1_wb_stb_i && !i1_wb_cyc_i) |-> (!i1_wb_ack_o && !i1_wb_err_o);
	endproperty
	assert property(af_p471);

	property af_p472;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i1_wb_stb_i;
	endproperty
	assert property(af_p472);

	property af_p473;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!i1_wb_stb_i)[*2];
	endproperty
	assert property(af_p473);

	property af_p474;
	@(posedge wb_clk_i) (i1_wb_stb_i && i1_wb_cyc_i) |-> ##[1:4] i1_wb_ack_o;
	endproperty
	assert property(af_p474);

	property af_p475;
	@(posedge wb_clk_i) (i1_wb_stb_i && i1_wb_we_i) |-> ($stable(i1_wb_dat_i) until i1_wb_ack_o);
	endproperty
	assert property(af_p475);

	property af_p476;
	@(posedge wb_clk_i) i1_wb_stb_i |-> i1_wb_cyc_i;
	endproperty
	assert property(af_p476);

	property af_p477;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i1_wb_stb_i)[*3];
	endproperty
	assert property(af_p477);

	property af_p478;
	@(posedge wb_clk_i) (i1_wb_stb_i && i1_wb_we_i) |-> $stable(i1_wb_dat_i) until_with (i1_wb_ack_o);
	endproperty
	assert property(af_p478);

	property af_p479;
	@(posedge wb_clk_i) wb_rst_i |-> ##1 !i1_wb_stb_i;
	endproperty
	assert property(af_p479);

	property af_p480;
	@(posedge wb_clk_i) i1_wb_stb_i |-> $stable(i1_wb_sel_i) until_with (i1_wb_ack_o || i1_wb_err_o);
	endproperty
	assert property(af_p480);

	property af_p481;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i) |-> $stable(i1_wb_adr_i) until_with (i1_wb_ack_o);
	endproperty
	assert property(af_p481);

	property af_p482;
	@(posedge wb_clk_i) i1_wb_ack_o |-> !i1_wb_stb_i;
	endproperty
	assert property(af_p482);

	property af_p483;
	@(posedge wb_clk_i) (i1_wb_stb_i && !i1_wb_ack_o) |-> $stable(i1_wb_adr_i);
	endproperty
	assert property(af_p483);

	property af_p484;
	@(posedge wb_clk_i) i1_wb_ack_o |-> ##1 !i1_wb_stb_i;
	endproperty
	assert property(af_p484);

	property af_p485;
	@(posedge wb_clk_i) i1_wb_stb_i |-> $stable(i1_wb_sel_i);
	endproperty
	assert property(af_p485);

	property af_p486;
	@(posedge wb_clk_i) $rose(i1_wb_stb_i) |-> (i1_wb_stb_i throughout (##[1:$] i1_wb_ack_o));
	endproperty
	assert property(af_p486);

	property af_p487;
	@(posedge wb_clk_i) $rose(i1_wb_stb_i) |-> (i1_wb_stb_i throughout (##[1:$] (i1_wb_ack_o || i1_wb_err_o)));
	endproperty
	assert property(af_p487);

	property af_p488;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i) |-> ($stable(i1_wb_adr_i) throughout (##[1:$] i1_wb_ack_o));
	endproperty
	assert property(af_p488);

	property af_p489;
	@(posedge wb_clk_i) wb_rst_i |-> !i1_wb_stb_i;
	endproperty
	assert property(af_p489);

	property af_p490;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (!$isunknown(i1_wb_stb_i));
	endproperty
	assert property(af_p490);

	property af_p491;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i && !i1_wb_ack_o) |-> ##1 i1_wb_stb_i;
	endproperty
	assert property(af_p491);

	property af_p492;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[0:2] (i1_wb_stb_i inside {1'b0, 1'b1});
	endproperty
	assert property(af_p492);

	property af_p493;
	@(posedge wb_clk_i) ($past(i1_wb_stb_i) && !$past(i1_wb_ack_o) && i1_wb_stb_i) |-> $stable(i1_wb_adr_i);
	endproperty
	assert property(af_p493);

	property af_p494;
	@(posedge wb_clk_i) wb_rst_i |-> !i1_wb_we_i;
	endproperty
	assert property(af_p494);

	property af_p495;
	@(posedge wb_clk_i) i1_wb_we_i |-> i1_wb_cyc_i;
	endproperty
	assert property(af_p495);

	property af_p496;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i) |-> (t0_wb_we_o == i1_wb_we_i);
	endproperty
	assert property(af_p496);

	property af_p497;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i) |-> ($stable(i1_wb_we_i) throughout i1_wb_ack_o[->1]);
	endproperty
	assert property(af_p497);

	property af_p498;
	@(posedge wb_clk_i) !i1_wb_cyc_i |-> !i1_wb_we_i;
	endproperty
	assert property(af_p498);

	property af_p499;
	@(posedge wb_clk_i) $rose(i1_wb_we_i) |-> !$isunknown(i1_wb_sel_i);
	endproperty
	assert property(af_p499);

	property af_p500;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i1_wb_we_i;
	endproperty
	assert property(af_p500);

	property af_p501;
	@(posedge wb_clk_i) (i1_wb_stb_i && i1_wb_cyc_i) |-> (!$isunknown(i1_wb_we_i));
	endproperty
	assert property(af_p501);

	property af_p502;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!i1_wb_we_i) ##1 (!i1_wb_we_i);
	endproperty
	assert property(af_p502);

	property af_p503;
	@(posedge wb_clk_i) (i1_wb_we_i && i1_wb_stb_i && i1_wb_cyc_i) |-> (!$isunknown(i1_wb_dat_i));
	endproperty
	assert property(af_p503);

	property af_p504;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i1_wb_we_i === 1'b0) until (i1_wb_stb_i && i1_wb_cyc_i);
	endproperty
	assert property(af_p504);

	property af_p505;
	@(posedge wb_clk_i) (i1_wb_we_i && i1_wb_stb_i && i1_wb_cyc_i) |-> ##[1:$] i1_wb_ack_o;
	endproperty
	assert property(af_p505);

	property af_p506;
	@(posedge wb_clk_i) (!i1_wb_we_i && i1_wb_cyc_i && i1_wb_stb_i) |-> (!$isunknown(i1_wb_dat_o));
	endproperty
	assert property(af_p506);

	property af_p507;
	@(posedge wb_clk_i) (!(i1_wb_stb_i && i1_wb_cyc_i)) |-> $stable(i1_wb_we_i);
	endproperty
	assert property(af_p507);

	property af_p508;
	@(posedge wb_clk_i) (i1_wb_cyc_i && $past(i1_wb_cyc_i)) |-> $stable(i1_wb_we_i);
	endproperty
	assert property(af_p508);

	property af_p509;
	@(posedge wb_clk_i) (i1_wb_cyc_i && $past(i1_wb_cyc_i)) |-> ($stable(i1_wb_we_i));
	endproperty
	assert property(af_p509);

	property af_p510;
	@(posedge wb_clk_i) ($changed(i1_wb_we_i) && (i1_wb_adr_i inside {[0:{$bits(i1_wb_adr_i){1'b1}}]})) |-> !i1_wb_err_o;
	endproperty
	assert property(af_p510);

	property af_p511;
	@(posedge wb_clk_i) (i1_wb_we_i && i1_wb_stb_i && i1_wb_cyc_i) |-> ##[0:1] i1_wb_ack_o;
	endproperty
	assert property(af_p511);

	property af_p512;
	@(posedge wb_clk_i) (!i1_wb_we_i && i1_wb_stb_i && i1_wb_cyc_i) |-> !$isunknown(i1_wb_dat_o);
	endproperty
	assert property(af_p512);

	property af_p513;
	@(posedge wb_clk_i) (i1_wb_we_i && i1_wb_stb_i && i1_wb_cyc_i && i1_wb_ack_o) |-> ($past(i1_wb_dat_i) == i1_wb_dat_i) || (i1_wb_dat_i == i1_wb_dat_i);
	endproperty
	assert property(af_p513);

	property af_p514;
	@(posedge wb_clk_i) (i2_wb_we_i && i2_wb_ack_o) |-> (i2_wb_sel_i != '0);
	endproperty
	assert property(af_p514);

	property af_p515;
	@(posedge wb_clk_i) (i2_wb_stb_i && i2_wb_ack_o) |-> (##1 !i2_wb_ack_o);
	endproperty
	assert property(af_p515);

	property af_p516;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i2_wb_ack_o ##1 !i2_wb_ack_o);
	endproperty
	assert property(af_p516);

	property af_p517;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!i2_wb_ack_o);
	endproperty
	assert property(af_p517);

	property af_p518;
	@(posedge wb_clk_i) (!i2_wb_we_i && i2_wb_ack_o) |-> (!$isunknown(i2_wb_dat_o));
	endproperty
	assert property(af_p518);

	property af_p519;
	@(posedge wb_clk_i) (!i2_wb_stb_i) |-> (!i2_wb_ack_o);
	endproperty
	assert property(af_p519);

	property af_p520;
	@(posedge wb_clk_i) (!i2_wb_cyc_i) |-> (!i2_wb_ack_o);
	endproperty
	assert property(af_p520);

	property af_p521;
	@(posedge wb_clk_i) (i2_wb_ack_o) |-> (!$changed(i2_wb_adr_i));
	endproperty
	assert property(af_p521);

	property af_p522;
	@(posedge wb_clk_i) (wb_rst_i) |-> !i2_wb_ack_o;
	endproperty
	assert property(af_p522);


	property af_p524;
	@(posedge wb_clk_i) !(i2_wb_ack_o && i2_wb_err_o);
	endproperty
	assert property(af_p524);

	property af_p525;
	@(posedge wb_clk_i) ($fell(wb_rst_i) && !i2_wb_cyc_i && !i2_wb_stb_i) |-> ##2 !i2_wb_ack_o;
	endproperty
	assert property(af_p525);

	property af_p526;
	@(posedge wb_clk_i) (i2_wb_ack_o) |=> !i2_wb_ack_o;
	endproperty
	assert property(af_p526);

	property af_p527;
	@(posedge wb_clk_i) ($fell(i2_wb_stb_i)) |=> !i2_wb_ack_o;
	endproperty
	assert property(af_p527);

	property af_p528;
	@(posedge wb_clk_i) (i2_wb_cyc_i && i2_wb_stb_i && !i2_wb_we_i) |=> (i2_wb_ack_o ##1 !i2_wb_ack_o);
	endproperty
	assert property(af_p528);

	property af_p529;
	@(posedge wb_clk_i) (i2_wb_ack_o) |-> (i2_wb_stb_i && (i2_wb_sel_i != '0));
	endproperty
	assert property(af_p529);

	property af_p530;
	@(posedge wb_clk_i) (i2_wb_stb_i && i2_wb_cyc_i) |=> i2_wb_ack_o;
	endproperty
	assert property(af_p530);

	property af_p531;
	@(posedge wb_clk_i) (i2_wb_cyc_i && i2_wb_stb_i && i2_wb_we_i) |=> (i2_wb_ack_o ##1 !i2_wb_ack_o);
	endproperty
	assert property(af_p531);


	property af_p533;
	@(posedge wb_clk_i) $fell(i2_wb_cyc_i) |=> !i2_wb_ack_o;
	endproperty
	assert property(af_p533);

	property af_p534;
	@(posedge wb_clk_i) (i2_wb_we_i && i2_wb_stb_i) |=> (i2_wb_ack_o ##1 !i2_wb_ack_o);
	endproperty
	assert property(af_p534);

	property af_p535;
	@(posedge wb_clk_i) (!i2_wb_stb_i && i2_wb_cyc_i) |-> !i2_wb_ack_o;
	endproperty
	assert property(af_p535);


	property af_p537;
	@(posedge wb_clk_i) (i2_wb_ack_o && !i2_wb_stb_i) |=> !i2_wb_ack_o;
	endproperty
	assert property(af_p537);

	property af_p538;
	@(posedge wb_clk_i) $fell(i2_wb_cyc_i) |=> ($stable(i2_wb_adr_i) || !$stable(i2_wb_adr_i));
	endproperty
	assert property(af_p538);

	property af_p539;
	@(posedge wb_clk_i) $past(!wb_rst_i,3) |-> (i2_wb_adr_i >= 0 && i2_wb_adr_i <= 4294967295);
	endproperty
	assert property(af_p539);

	property af_p540;
	@(posedge wb_clk_i) ($past(i2_wb_ack_o) && $past(i2_wb_cyc_i)) |-> (i2_wb_stb_i || $stable(i2_wb_adr_i));
	endproperty
	assert property(af_p540);

	property af_p541;
	@(posedge wb_clk_i) i2_wb_cyc_i |-> $stable(i2_wb_adr_i);
	endproperty
	assert property(af_p541);

	property af_p542;
	@(posedge wb_clk_i) (!$stable(i2_wb_adr_i)) |-> !i2_wb_stb_i;
	endproperty
	assert property(af_p542);

	property af_p543;
	@(posedge wb_clk_i) (i2_wb_cyc_i && i2_wb_stb_i && !i2_wb_ack_o) |=> $stable(i2_wb_adr_i);
	endproperty
	assert property(af_p543);

	property af_p544;
	@(posedge wb_clk_i) (i2_wb_sel_i && i2_wb_stb_i) |-> $stable(i2_wb_adr_i);
	endproperty
	assert property(af_p544);

	property af_p545;
	@(posedge wb_clk_i) (i2_wb_cyc_i && !i2_wb_ack_o) |-> $stable(i2_wb_adr_i);
	endproperty
	assert property(af_p545);

	property af_p546;
	@(posedge wb_clk_i) (i2_wb_stb_i && !i2_wb_ack_o) |-> $stable(i2_wb_adr_i);
	endproperty
	assert property(af_p546);

	property af_p547;
	@(posedge wb_clk_i) $fell(i2_wb_cyc_i) |=> 1'b1;
	endproperty
	assert property(af_p547);

	property af_p548;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (i2_wb_adr_i >= 0 && i2_wb_adr_i <= 255);
	endproperty
	assert property(af_p548);

	property af_p549;
	@(posedge wb_clk_i) (i2_wb_we_i && i2_wb_stb_i) |-> ($stable(i2_wb_adr_i) throughout (##[1:$] i2_wb_ack_o));
	endproperty
	assert property(af_p549);

	property af_p550;
	@(posedge wb_clk_i) i2_wb_ack_o |=> $changed(i2_wb_adr_i);
	endproperty
	assert property(af_p550);

	property af_p551;
	@(posedge wb_clk_i) (i2_wb_adr_i >= 1024 && i2_wb_adr_i <= 2047) |=> (i2_wb_adr_i >= 1024 && i2_wb_adr_i <= 4095);
	endproperty
	assert property(af_p551);

	property af_p552;
	@(posedge wb_clk_i) (!wb_rst_i && i2_wb_cyc_i) |-> $stable(i2_wb_adr_i);
	endproperty
	assert property(af_p552);

	property af_p553;
	@(posedge wb_clk_i) i2_wb_ack_o |-> $stable(i2_wb_adr_i);
	endproperty
	assert property(af_p553);

	property af_p554;
	@(posedge wb_clk_i) ($past(i2_wb_cyc_i && i2_wb_stb_i) && i2_wb_cyc_i && i2_wb_stb_i) |-> $stable(i2_wb_adr_i);
	endproperty
	assert property(af_p554);

	property af_p555;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##1 (!$isunknown(i2_wb_adr_i));
	endproperty
	assert property(af_p555);

	property af_p556;
	@(posedge wb_clk_i) (i2_wb_we_i && (i2_wb_adr_i inside {[512:1023]})) |-> ##1 (i2_wb_adr_i inside {[0:1023]});
	endproperty
	assert property(af_p556);

	property af_p557;
	@(posedge wb_clk_i) (i2_wb_stb_i && i2_wb_cyc_i && (i2_wb_adr_i inside {[0:65535]})) |-> ((i2_wb_adr_i inside {[0:65535]}) until i2_wb_ack_o);
	endproperty
	assert property(af_p557);

	property af_p558;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##3 (!$isunknown(i2_wb_adr_i));
	endproperty
	assert property(af_p558);

	property af_p559;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (!$isunknown(i2_wb_adr_i));
	endproperty
	assert property(af_p559);

	property af_p560;
	@(posedge wb_clk_i) (i2_wb_err_o && i2_wb_cyc_i) |-> ($stable(i2_wb_adr_i) until (!i2_wb_cyc_i));
	endproperty
	assert property(af_p560);

	property af_p561;
	@(posedge wb_clk_i) (i2_wb_stb_i) |-> (!$isunknown(i2_wb_adr_i));
	endproperty
	assert property(af_p561);

	property af_p562;
	@(posedge wb_clk_i) (i2_wb_cyc_i) |-> (!$isunknown(i2_wb_adr_i));
	endproperty
	assert property(af_p562);

	property af_p563;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> ##1 (!i2_wb_cyc_i);
	endproperty
	assert property(af_p563);

	property af_p564;
	@(posedge wb_clk_i) (!$isunknown(i2_wb_cyc_i)) |-> ($stable(i2_wb_cyc_i) || $changed(i2_wb_cyc_i));
	endproperty
	assert property(af_p564);

	property af_p565;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!i2_wb_cyc_i) throughout (##[0:$] i2_wb_cyc_i[->1]);
	endproperty
	assert property(af_p565);

	property af_p566;
	@(posedge wb_clk_i) (i2_wb_cyc_i) |-> (!wb_rst_i);
	endproperty
	assert property(af_p566);

	property af_p567;
	@(posedge wb_clk_i) (i2_wb_cyc_i && i2_wb_ack_o) |-> ##1 (!i2_wb_cyc_i || $past(i2_wb_cyc_i) == 0);
	endproperty
	assert property(af_p567);

	property af_p568;
	@(posedge wb_clk_i) (i2_wb_err_o && i2_wb_cyc_i) |-> ##1 (!i2_wb_cyc_i);
	endproperty
	assert property(af_p568);

	property af_p569;
	@(posedge wb_clk_i) ($rose(i2_wb_cyc_i)) |-> (!$past(i2_wb_cyc_i) || $past(i2_wb_ack_o));
	endproperty
	assert property(af_p569);

	property af_p570;
	@(posedge wb_clk_i) (i2_wb_err_o) |-> ##1 (!i2_wb_cyc_i);
	endproperty
	assert property(af_p570);

	property af_p571;
	@(posedge wb_clk_i) ($rose(i2_wb_cyc_i)) |-> ($stable(i2_wb_adr_i) && !$isunknown(i2_wb_adr_i));
	endproperty
	assert property(af_p571);

	property af_p572;
	@(posedge wb_clk_i) (i2_wb_cyc_i && i2_wb_stb_i) |-> ##[1:16] i2_wb_ack_o;
	endproperty
	assert property(af_p572);

	property af_p573;
	@(posedge wb_clk_i) (!i2_wb_cyc_i) |-> (!i2_wb_stb_i);
	endproperty
	assert property(af_p573);

	property af_p574;
	@(posedge wb_clk_i) (i2_wb_cyc_i && i2_wb_we_i) |-> (##1 $stable(i2_wb_dat_i));
	endproperty
	assert property(af_p574);

	property af_p575;
	@(posedge wb_clk_i) $rose(i2_wb_cyc_i) |-> (i2_wb_cyc_i throughout (i2_wb_ack_o[->1]));
	endproperty
	assert property(af_p575);

	property af_p576;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i2_wb_cyc_i;
	endproperty
	assert property(af_p576);

	property af_p577;
	@(posedge wb_clk_i) (i2_wb_cyc_i && !i2_wb_ack_o) |-> (i2_wb_cyc_i throughout (i2_wb_ack_o[->1]));
	endproperty
	assert property(af_p577);

	property af_p578;
	@(posedge wb_clk_i) (i2_wb_cyc_i) |-> (i2_wb_stb_i);
	endproperty
	assert property(af_p578);

	property af_p579;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!i2_wb_cyc_i);
	endproperty
	assert property(af_p579);

	property af_p580;
	@(posedge wb_clk_i) (i2_wb_cyc_i) |-> ($stable(i2_wb_sel_i) throughout (i2_wb_ack_o[->1]));
	endproperty
	assert property(af_p580);

	property af_p581;
	@(posedge wb_clk_i) (i2_wb_cyc_i && i2_wb_we_i) |-> ($stable(i2_wb_dat_i) throughout (i2_wb_ack_o[->1]));
	endproperty
	assert property(af_p581);

	property af_p582;
	@(posedge wb_clk_i) !i2_wb_cyc_i |-> !i2_wb_ack_o;
	endproperty
	assert property(af_p582);

	property af_p583;
	@(posedge wb_clk_i) $fell(i2_wb_cyc_i) |-> ##[0:1] (!i2_wb_ack_o && !i2_wb_err_o);
	endproperty
	assert property(af_p583);

	property af_p584;
	@(posedge wb_clk_i) i2_wb_cyc_i |-> i2_wb_adr_i throughout (##[0:$] i2_wb_ack_o);
	endproperty
	assert property(af_p584);

	property af_p585;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> !i2_wb_cyc_i;
	endproperty
	assert property(af_p585);

	property af_p586;
	@(posedge wb_clk_i) $fell(i2_wb_stb_i) |-> i2_wb_cyc_i;
	endproperty
	assert property(af_p586);

	property af_p587;
	@(posedge wb_clk_i) $rose(i2_wb_stb_i) |-> i2_wb_cyc_i throughout (##[0:$] i2_wb_ack_o);
	endproperty
	assert property(af_p587);

	property af_p588;
	@(posedge wb_clk_i) $rose(i2_wb_cyc_i) |-> i2_wb_cyc_i throughout (##[0:$] (i2_wb_ack_o || i2_wb_err_o));
	endproperty
	assert property(af_p588);

	property af_p589;
	@(posedge wb_clk_i) $changed(i2_wb_cyc_i) |-> $stable(i2_wb_cyc_i)[->1];
	endproperty
	assert property(af_p589);

	property af_p590;
	@(posedge wb_clk_i) i2_wb_stb_i |-> i2_wb_cyc_i;
	endproperty
	assert property(af_p590);

	property af_p591;
	@(posedge wb_clk_i) i2_wb_cyc_i |-> i2_wb_stb_i;
	endproperty
	assert property(af_p591);

	property af_p592;
	@(posedge wb_clk_i) ($rose(i2_wb_cyc_i)) |-> ##[0:1] ((i2_wb_dat_i >= 50) && (i2_wb_dat_i <= 200));
	endproperty
	assert property(af_p592);

	property af_p593;
	@(posedge wb_clk_i) ((i2_wb_dat_i >= 230) && (i2_wb_dat_i <= 255)) |=> ((i2_wb_dat_i >= 205) && (i2_wb_dat_i <= 255));
	endproperty
	assert property(af_p593);

	property af_p594;
	@(posedge wb_clk_i) disable iff (wb_rst_i) ($rose(!wb_rst_i)) |-> ##3 ((i2_wb_dat_i >= 83) && (i2_wb_dat_i <= 165));
	endproperty
	assert property(af_p594);

	property af_p595;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |=> (i2_wb_dat_i == 0);
	endproperty
	assert property(af_p595);

	property af_p596;
	@(posedge wb_clk_i) (i2_wb_ack_o) |-> ((i2_wb_dat_i >= 0) && (i2_wb_dat_i <= 255));
	endproperty
	assert property(af_p596);

	property af_p597;
	@(posedge wb_clk_i) (i2_wb_cyc_i && i2_wb_stb_i && i2_wb_ack_o) |-> ((i2_wb_dat_i >= 0) && (i2_wb_dat_i <= 255));
	endproperty
	assert property(af_p597);

	property af_p598;
	@(posedge wb_clk_i) (i2_wb_stb_i && i2_wb_cyc_i) |-> ($stable(i2_wb_dat_i) throughout (i2_wb_stb_i && i2_wb_cyc_i && !i2_wb_ack_o)[*0:$] ##1 i2_wb_ack_o);
	endproperty
	assert property(af_p598);

	property af_p599;
	@(posedge wb_clk_i) ((i2_wb_dat_i >= 100) && (i2_wb_dat_i <= 255)) |=> ((i2_wb_dat_i >= 80) && (i2_wb_dat_i <= 255));
	endproperty
	assert property(af_p599);

	property af_p600;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((i2_wb_dat_i >= 0) && (i2_wb_dat_i <= 255));
	endproperty
	assert property(af_p600);

	property af_p601;
	@(posedge wb_clk_i) (i2_wb_ack_o) |-> ((i2_wb_dat_i === $past(i2_wb_dat_i)) || $stable(i2_wb_dat_i)) throughout (!i2_wb_ack_o)[*0:$];
	endproperty
	assert property(af_p601);

	property af_p602;
	@(posedge wb_clk_i) disable iff (wb_rst_i) ($rose(!wb_rst_i)) |-> ##3 ((i2_wb_dat_i >= 0) && (i2_wb_dat_i <= 255));
	endproperty
	assert property(af_p602);

	property af_p603;
	@(posedge wb_clk_i) (!i2_wb_we_i) |-> (i2_wb_dat_i >= 0) && (i2_wb_dat_i <= 255);
	endproperty
	assert property(af_p603);

	property af_p604;
	@(posedge wb_clk_i) ((i2_wb_stb_i) && (i2_wb_dat_i >= 1) && (i2_wb_dat_i <= 127)) |=> (i2_wb_dat_i <= 127);
	endproperty
	assert property(af_p604);

	property af_p605;
	@(posedge wb_clk_i) 1'b1 |-> ($past(i2_wb_dat_i) == i2_wb_dat_i || i2_wb_adr_i != $past(i2_wb_adr_i));
	endproperty
	assert property(af_p605);

	property af_p606;
	@(posedge wb_clk_i) (!i2_wb_we_i) |-> ##0 $rose(wb_clk_i) == 1'b1;
	endproperty
	assert property(af_p606);

	property af_p607;
	@(posedge wb_clk_i) ((i2_wb_dat_i >= 60) && (i2_wb_dat_i <= 180)) |=> (i2_wb_dat_i >= 40) && (i2_wb_dat_i <= 200);
	endproperty
	assert property(af_p607);

	property af_p608;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (($past(wb_rst_i,4) == 1'b0) && ($past(wb_rst_i,5) == 1'b1)) |-> (i2_wb_dat_i >= 0) && (i2_wb_dat_i <= 45);
	endproperty
	assert property(af_p608);

	property af_p609;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (i2_wb_dat_i >= 0) && (i2_wb_dat_i <= 255);
	endproperty
	assert property(af_p609);

	property af_p610;
	@(posedge wb_clk_i) (!i2_wb_we_i) |-> ($stable(i2_wb_dat_i) || !$stable(i2_wb_dat_i));
	endproperty
	assert property(af_p610);

	property af_p611;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (i2_wb_dat_i >= 0) && (i2_wb_dat_i <= 45);
	endproperty
	assert property(af_p611);

	property af_p612;
	@(posedge wb_clk_i) (i2_wb_sel_i) |-> ((i2_wb_dat_i >= 50) && (i2_wb_dat_i <= 200)) ##1 ((i2_wb_dat_i >= 50) && (i2_wb_dat_i <= 200));
	endproperty
	assert property(af_p612);

	property af_p613;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (($past(wb_rst_i,4) == 1'b0) && ($past(wb_rst_i,5) == 1'b1)) |-> (i2_wb_dat_i >= 0) && (i2_wb_dat_i <= 63);
	endproperty
	assert property(af_p613);

	property af_p614;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (i2_wb_dat_i >= 0) && (i2_wb_dat_i <= 128);
	endproperty
	assert property(af_p614);

	property af_p615;
	@(posedge wb_clk_i) (!wb_rst_i) |-> !$isunknown(i2_wb_dat_i);
	endproperty
	assert property(af_p615);

	property af_p616;
	@(posedge wb_clk_i) ((i2_wb_dat_i >= 16) && (i2_wb_dat_i <= 32) && i2_wb_sel_i) |-> $stable(i2_wb_dat_i);
	endproperty
	assert property(af_p616);

	property af_p617;
	@(posedge wb_clk_i) $rose(i2_wb_cyc_i) |-> ((i2_wb_dat_i >= 0) && (i2_wb_dat_i <= 255))[*2];
	endproperty
	assert property(af_p617);

	property af_p618;
	@(posedge wb_clk_i) (i2_wb_stb_i && i2_wb_cyc_i && i2_wb_we_i) |-> $stable(i2_wb_dat_i);
	endproperty
	assert property(af_p618);

	property af_p619;
	@(posedge wb_clk_i) ((i2_wb_dat_i >= 138) && (i2_wb_dat_i <= 153)) |-> ##1 (i2_wb_dat_i >= 98) && (i2_wb_dat_i <= 153);
	endproperty
	assert property(af_p619);

	property af_p620;
	@(posedge wb_clk_i) ((i2_wb_dat_i >= 50) && (i2_wb_dat_i <= 120)) |-> ##1 (i2_wb_dat_i >= 30) && (i2_wb_dat_i <= 150);
	endproperty
	assert property(af_p620);

	property af_p621;
	@(posedge wb_clk_i) (i2_wb_stb_i && i2_wb_cyc_i) |-> $stable(i2_wb_dat_i);
	endproperty
	assert property(af_p621);

	property af_p622;
	@(posedge wb_clk_i) $rose(i2_wb_ack_o) |-> ((i2_wb_dat_i >= 100) && (i2_wb_dat_i <= 200))[*2];
	endproperty
	assert property(af_p622);

	property af_p623;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i2_wb_dat_i == 0);
	endproperty
	assert property(af_p623);

	property af_p624;
	@(posedge wb_clk_i) (!i2_wb_cyc_i) |-> (i2_wb_dat_i >= 0) && (i2_wb_dat_i <= 255);
	endproperty
	assert property(af_p624);

	property af_p625;
	@(posedge wb_clk_i) (i2_wb_ack_o) |-> ((i2_wb_dat_o >= 0) && (i2_wb_dat_o <= 255));
	endproperty
	assert property(af_p625);

	property af_p626;
	@(posedge wb_clk_i) (i2_wb_cyc_i && i2_wb_stb_i && !i2_wb_we_i) |-> (!$isunknown(i2_wb_dat_o));
	endproperty
	assert property(af_p626);

	property af_p627;
	@(posedge wb_clk_i) ((i2_wb_dat_o >= 100) && (i2_wb_dat_o <= 150)) |-> ##1 ((i2_wb_dat_o >= 80) && (i2_wb_dat_o <= 170));
	endproperty
	assert property(af_p627);

	property af_p628;
	@(posedge wb_clk_i) ($fell(wb_rst_i) && i2_wb_cyc_i && i2_wb_stb_i) |-> ##[1:4] ((i2_wb_dat_o >= 0) && (i2_wb_dat_o <= 255));
	endproperty
	assert property(af_p628);

	property af_p629;
	@(posedge wb_clk_i) ((i2_wb_dat_o >= 50) && (i2_wb_dat_o <= 75) && i2_wb_stb_i) |-> ##1 (i2_wb_stb_i && (i2_wb_dat_o >= 40) && (i2_wb_dat_o <= 90));
	endproperty
	assert property(af_p629);

	property af_p630;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 ((i2_wb_dat_o >= 0) && (i2_wb_dat_o <= 255));
	endproperty
	assert property(af_p630);

	property af_p631;
	@(posedge wb_clk_i) ((i2_wb_sel_i != '0) && i2_wb_ack_o) |-> ((i2_wb_dat_o >= 0) && (i2_wb_dat_o <= 255));
	endproperty
	assert property(af_p631);

	property af_p632;
	@(posedge wb_clk_i) (i2_wb_stb_i && i2_wb_cyc_i && !i2_wb_we_i && i2_wb_ack_o) |-> (!$isunknown(i2_wb_dat_o));
	endproperty
	assert property(af_p632);

	property af_p633;
	@(posedge wb_clk_i) (!i2_wb_cyc_i) |-> (i2_wb_dat_o == '0);
	endproperty
	assert property(af_p633);

	property af_p634;
	@(posedge wb_clk_i) (i2_wb_err_o) |-> (1'b1);
	endproperty
	assert property(af_p634);

	property af_p635;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (!i2_wb_ack_o) |-> $stable(i2_wb_dat_o);
	endproperty
	assert property(af_p635);

	property af_p636;
	@(posedge wb_clk_i) (i2_wb_ack_o) |-> (i2_wb_dat_o >= 0) && (i2_wb_dat_o <= 255);
	endproperty
	assert property(af_p636);

	property af_p637;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (!i2_wb_ack_o) |-> ($stable(i2_wb_dat_o));
	endproperty
	assert property(af_p637);

	property af_p638;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i2_wb_ack_o) |-> ##1 $stable(i2_wb_dat_o);
	endproperty
	assert property(af_p638);

	property af_p639;
	@(posedge wb_clk_i) (wb_rst_i) |-> ##3 ((i2_wb_dat_o >= 0) && (i2_wb_dat_o <= 255));
	endproperty
	assert property(af_p639);

	property af_p640;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 (i2_wb_dat_o !== 'x);
	endproperty
	assert property(af_p640);

	property af_p641;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (!i2_wb_cyc_i) |-> $stable(i2_wb_dat_o);
	endproperty
	assert property(af_p641);

	property af_p642;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i2_wb_cyc_i && i2_wb_stb_i && !i2_wb_ack_o) |-> $stable(i2_wb_dat_o);
	endproperty
	assert property(af_p642);

	property af_p643;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(i2_wb_dat_o);
	endproperty
	assert property(af_p643);

	property af_p644;
	@(posedge wb_clk_i) ((i2_wb_dat_o >= 200) && (i2_wb_dat_o <= 255)) |-> (i2_wb_dat_o >= 180) && (i2_wb_dat_o <= 255);
	endproperty
	assert property(af_p644);

	property af_p645;
	@(posedge wb_clk_i) (!i2_wb_we_i && i2_wb_stb_i && i2_wb_ack_o) |-> (i2_wb_dat_o >= 0) && (i2_wb_dat_o <= 255);
	endproperty
	assert property(af_p645);

	property af_p646;
	@(posedge wb_clk_i) ($fell(wb_rst_i) && i2_wb_cyc_i && i2_wb_stb_i) |-> ##2 ((i2_wb_dat_o >= 0) && (i2_wb_dat_o <= 255));
	endproperty
	assert property(af_p646);

	property af_p647;
	@(posedge wb_clk_i) ($fell(i2_wb_err_o)) |-> ##1 ((i2_wb_dat_o >= 0) && (i2_wb_dat_o <= 255));
	endproperty
	assert property(af_p647);

	property af_p648;
	@(posedge wb_clk_i) (!$rose(i2_wb_ack_o)) |-> $stable(i2_wb_dat_o);
	endproperty
	assert property(af_p648);


	property af_p650;
	@(posedge wb_clk_i) ($fell(i2_wb_cyc_i)) |-> ##1 (i2_wb_dat_o == '0);
	endproperty
	assert property(af_p650);

	property af_p651;
	@(posedge wb_clk_i) (i2_wb_ack_o) |-> $stable(i2_wb_dat_o);
	endproperty
	assert property(af_p651);

	property af_p652;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 ((i2_wb_dat_o >= 0) && (i2_wb_dat_o <= 255));
	endproperty
	assert property(af_p652);

	property af_p653;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> ##1 (i2_wb_dat_o == '0);
	endproperty
	assert property(af_p653);

	property af_p654;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (i2_wb_dat_o >= 0) && (i2_wb_dat_o <= 255);
	endproperty
	assert property(af_p654);

	property af_p655;
	@(posedge wb_clk_i) (i2_wb_cyc_i && $stable(i2_wb_cyc_i)) |-> $stable(i2_wb_err_o);
	endproperty
	assert property(af_p655);

	property af_p656;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (i2_wb_err_o == 1'b0);
	endproperty
	assert property(af_p656);

	property af_p657;
	@(posedge wb_clk_i) ($fell(i2_wb_cyc_i)) |=> (i2_wb_err_o == 1'b0);
	endproperty
	assert property(af_p657);

	property af_p658;
	@(posedge wb_clk_i) ($rose(i2_wb_err_o)) |=> (!i2_wb_err_o);
	endproperty
	assert property(af_p658);

	property af_p659;
	@(posedge wb_clk_i) (i2_wb_cyc_i && i2_wb_ack_o) |-> (i2_wb_err_o == 1'b0);
	endproperty
	assert property(af_p659);

	property af_p660;
	@(posedge wb_clk_i) (i2_wb_err_o) |=> !i2_wb_err_o;
	endproperty
	assert property(af_p660);

	property af_p661;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i2_wb_err_o == 1'b0);
	endproperty
	assert property(af_p661);

	property af_p662;
	@(posedge wb_clk_i) !(i2_wb_err_o && i2_wb_ack_o);
	endproperty
	assert property(af_p662);

	property af_p663;
	@(posedge wb_clk_i) (i2_wb_err_o) |=> (!i2_wb_stb_i);
	endproperty
	assert property(af_p663);

	property af_p664;
	@(posedge wb_clk_i) (i2_wb_err_o) |-> (i2_wb_cyc_i && i2_wb_stb_i);
	endproperty
	assert property(af_p664);

	property af_p665;
	@(posedge wb_clk_i) ($changed(i2_wb_we_i) && !i2_wb_stb_i) |-> !i2_wb_err_o;
	endproperty
	assert property(af_p665);

	property af_p666;
	@(posedge wb_clk_i) $changed(i2_wb_err_o) |-> i2_wb_stb_i;
	endproperty
	assert property(af_p666);

	property af_p667;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 !i2_wb_err_o;
	endproperty
	assert property(af_p667);

	property af_p668;
	@(posedge wb_clk_i) (i2_wb_sel_i != '0) |-> !i2_wb_err_o;
	endproperty
	assert property(af_p668);

	property af_p669;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i2_wb_err_o) ##1 (!i2_wb_err_o);
	endproperty
	assert property(af_p669);

	property af_p670;
	@(posedge wb_clk_i) $fell(i2_wb_cyc_i) |-> !i2_wb_err_o;
	endproperty
	assert property(af_p670);

	property af_p671;
	@(posedge wb_clk_i) i2_wb_err_o |-> ##1 !i2_wb_err_o;
	endproperty
	assert property(af_p671);

	property af_p672;
	@(posedge wb_clk_i) $changed(i2_wb_adr_i) |-> ##1 $changed(i2_wb_err_o);
	endproperty
	assert property(af_p672);

	property af_p673;
	@(posedge wb_clk_i) !i2_wb_cyc_i |-> !i2_wb_err_o;
	endproperty
	assert property(af_p673);

	property af_p674;
	@(posedge wb_clk_i) $fell(i2_wb_cyc_i) |-> ##1 !i2_wb_err_o;
	endproperty
	assert property(af_p674);

	property af_p675;
	@(posedge wb_clk_i) i2_wb_err_o |-> (t0_wb_err_i || t1_wb_err_i || t2_wb_err_i || t3_wb_err_i || t4_wb_err_i || t5_wb_err_i || t6_wb_err_i || t7_wb_err_i || t8_wb_err_i);
	endproperty
	assert property(af_p675);

	property af_p676;
	@(posedge wb_clk_i) i2_wb_we_i |-> !i2_wb_err_o;
	endproperty
	assert property(af_p676);

	property af_p677;
	@(posedge wb_clk_i) i2_wb_ack_o |-> !i2_wb_err_o;
	endproperty
	assert property(af_p677);

	property af_p678;
	@(posedge wb_clk_i) i2_wb_err_o |-> !(i2_wb_adr_i inside {[0:$]});
	endproperty
	assert property(af_p678);

	property af_p679;
	@(posedge wb_clk_i) i2_wb_err_o |-> (i2_wb_stb_i && i2_wb_cyc_i);
	endproperty
	assert property(af_p679);

	property af_p680;
	@(posedge wb_clk_i) (i2_wb_adr_i inside {[0:$]}) |-> !i2_wb_err_o;
	endproperty
	assert property(af_p680);

	property af_p681;
	@(posedge wb_clk_i) (!i2_wb_we_i && i2_wb_ack_o) |-> !i2_wb_err_o;
	endproperty
	assert property(af_p681);

	property af_p682;
	@(posedge wb_clk_i) i2_wb_stb_i |=> i2_wb_err_o;
	endproperty
	assert property(af_p682);

	property af_p683;
	@(posedge wb_clk_i) (i2_wb_cyc_i && (i2_wb_sel_i != '0)) |-> !i2_wb_err_o;
	endproperty
	assert property(af_p683);

	property af_p684;
	@(posedge wb_clk_i) i2_wb_err_o |-> (i2_wb_cyc_i && i2_wb_stb_i);
	endproperty
	assert property(af_p684);

	property af_p685;
	@(posedge wb_clk_i) (wb_rst_i) |-> ##1 (i2_wb_sel_i == 4'b0000);
	endproperty
	assert property(af_p685);

	property af_p686;
	@(posedge wb_clk_i) (i2_wb_sel_i == 4'b1111) |-> !$isunknown(i2_wb_dat_i);
	endproperty
	assert property(af_p686);

	property af_p687;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> ##1 $stable(i2_wb_sel_i);
	endproperty
	assert property(af_p687);

	property af_p688;
	@(posedge wb_clk_i) (i2_wb_cyc_i && i2_wb_stb_i) |-> $stable(i2_wb_sel_i);
	endproperty
	assert property(af_p688);

	property af_p689;
	@(posedge wb_clk_i) (i2_wb_we_i) |-> (i2_wb_sel_i != 4'b0000);
	endproperty
	assert property(af_p689);

	property af_p690;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(i2_wb_sel_i);
	endproperty
	assert property(af_p690);

	property af_p691;
	@(posedge wb_clk_i) (i2_wb_cyc_i && !i2_wb_stb_i && !i2_wb_ack_o) |-> $stable(i2_wb_sel_i);
	endproperty
	assert property(af_p691);

	property af_p692;
	@(posedge wb_clk_i) (i2_wb_stb_i) |-> (i2_wb_sel_i inside {[4'b0000:4'b1111]});
	endproperty
	assert property(af_p692);

	property af_p693;
	@(posedge wb_clk_i) (i2_wb_we_i && (i2_wb_sel_i == 4'b0001)) |-> !$isunknown(i2_wb_dat_i[7:0]);
	endproperty
	assert property(af_p693);

	property af_p694;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (i2_wb_sel_i inside {[4'b0000:4'b1111]});
	endproperty
	assert property(af_p694);











	property af_p705;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !$isunknown(i2_wb_sel_i);
	endproperty
	assert property(af_p705);

	property af_p706;
	@(posedge wb_clk_i) (i2_wb_cyc_i && i2_wb_stb_i) |-> !$isunknown(i2_wb_sel_i);
	endproperty
	assert property(af_p706);

	property af_p707;
	@(posedge wb_clk_i) $rose(i2_wb_stb_i) |-> !$isunknown(i2_wb_sel_i);
	endproperty
	assert property(af_p707);

	property af_p708;
	@(posedge wb_clk_i) (i2_wb_we_i && i2_wb_cyc_i) |=> $stable(i2_wb_sel_i);
	endproperty
	assert property(af_p708);

	property af_p709;
	@(posedge wb_clk_i) (i2_wb_cyc_i && !i2_wb_err_o) |=> $stable(i2_wb_sel_i);
	endproperty
	assert property(af_p709);

	property af_p710;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 !$isunknown(i2_wb_sel_i) && $stable(i2_wb_sel_i);
	endproperty
	assert property(af_p710);

	property af_p711;
	@(posedge wb_clk_i) (!wb_rst_i && !i2_wb_cyc_i) |-> $isunknown(i2_wb_sel_i);
	endproperty
	assert property(af_p711);

	property af_p712;
	@(posedge wb_clk_i) i2_wb_stb_i |-> i2_wb_cyc_i;
	endproperty
	assert property(af_p712);

	property af_p713;
	@(posedge wb_clk_i) (i2_wb_stb_i && i2_wb_cyc_i) |-> (i2_wb_sel_i != '0);
	endproperty
	assert property(af_p713);

	property af_p714;
	@(posedge wb_clk_i) (i2_wb_stb_i && i2_wb_we_i) |-> ($stable(i2_wb_dat_i) throughout i2_wb_ack_o[->1]);
	endproperty
	assert property(af_p714);

	property af_p715;
	@(posedge wb_clk_i) $fell(i2_wb_ack_o) |-> !i2_wb_stb_i;
	endproperty
	assert property(af_p715);

	property af_p716;
	@(posedge wb_clk_i) $rose(i2_wb_stb_i) |-> (i2_wb_stb_i throughout i2_wb_ack_o[->1]);
	endproperty
	assert property(af_p716);

	property af_p717;
	@(posedge wb_clk_i) i2_wb_ack_o |=> !i2_wb_stb_i;
	endproperty
	assert property(af_p717);

	property af_p718;
	@(posedge wb_clk_i) wb_rst_i |-> !i2_wb_stb_i;
	endproperty
	assert property(af_p718);

	property af_p719;
	@(posedge wb_clk_i) wb_rst_i |-> (!i2_wb_stb_i && !i2_wb_cyc_i);
	endproperty
	assert property(af_p719);

	property af_p720;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (!i2_wb_stb_i)[*2];
	endproperty
	assert property(af_p720);

	property af_p721;
	@(posedge wb_clk_i) (i2_wb_stb_i && i2_wb_cyc_i) |=> (i2_wb_stb_i || !i2_wb_cyc_i);
	endproperty
	assert property(af_p721);

	property af_p722;
	@(posedge wb_clk_i) $rose(i2_wb_ack_o) |=> (!i2_wb_stb_i || $rose(i2_wb_stb_i));
	endproperty
	assert property(af_p722);

	property af_p723;
	@(posedge wb_clk_i) i2_wb_err_o |=> !i2_wb_stb_i;
	endproperty
	assert property(af_p723);

	property af_p724;
	@(posedge wb_clk_i) (i2_wb_stb_i && i2_wb_we_i) |-> i2_wb_adr_i throughout (!i2_wb_ack_o)[->1];
	endproperty
	assert property(af_p724);

	property af_p725;
	@(posedge wb_clk_i) (i2_wb_cyc_i && !i2_wb_ack_o) |-> $stable(i2_wb_stb_i);
	endproperty
	assert property(af_p725);

	property af_p726;
	@(posedge wb_clk_i) not ((i2_wb_stb_i && !i2_wb_ack_o && !i2_wb_err_o)[*17]);
	endproperty
	assert property(af_p726);

	property af_p727;
	@(posedge wb_clk_i) (i2_wb_stb_i && i2_wb_cyc_i && !i2_wb_ack_o && !i2_wb_err_o)[*3] |-> i2_wb_stb_i until_with (i2_wb_ack_o || i2_wb_err_o);
	endproperty
	assert property(af_p727);

	property af_p728;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i2_wb_cyc_i && $changed(i2_wb_stb_i)) |-> $changed(i2_wb_adr_i);
	endproperty
	assert property(af_p728);

	property af_p729;
	@(posedge wb_clk_i) disable iff (wb_rst_i) ($rose(i2_wb_stb_i)) |-> (i2_wb_stb_i throughout (i2_wb_ack_o || i2_wb_err_o)[->1]);
	endproperty
	assert property(af_p729);

	property af_p730;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> (!i2_wb_stb_i)[*2];
	endproperty
	assert property(af_p730);

	property af_p731;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!i2_wb_stb_i)[*4];
	endproperty
	assert property(af_p731);

	property af_p732;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!i2_wb_stb_i);
	endproperty
	assert property(af_p732);

	property af_p733;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i2_wb_stb_i) |-> ($stable(i2_wb_adr_i) && $stable(i2_wb_we_i));
	endproperty
	assert property(af_p733);

	property af_p734;
	@(posedge wb_clk_i) (i2_wb_stb_i) |-> (i2_wb_cyc_i);
	endproperty
	assert property(af_p734);

	property af_p735;
	@(posedge wb_clk_i) disable iff (wb_rst_i) ($rose(i2_wb_stb_i)) |-> (i2_wb_cyc_i || $past(i2_wb_cyc_i));
	endproperty
	assert property(af_p735);

	property af_p736;
	@(posedge wb_clk_i) disable iff (wb_rst_i) ($rose(i2_wb_stb_i)) |-> (i2_wb_stb_i throughout (i2_wb_ack_o)[->1]);
	endproperty
	assert property(af_p736);

	property af_p737;
	@(posedge wb_clk_i) ($rose(i2_wb_we_i) && i2_wb_cyc_i) |-> (i2_wb_dat_i == i2_wb_dat_i);
	endproperty
	assert property(af_p737);

	property af_p738;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (i2_wb_we_i == 1'b0);
	endproperty
	assert property(af_p738);

	property af_p739;
	@(posedge wb_clk_i) (i2_wb_cyc_i && i2_wb_stb_i && !i2_wb_we_i) |-> (!$isunknown(i2_wb_dat_o) && (i2_wb_dat_o !== i2_wb_dat_i));
	endproperty
	assert property(af_p739);

	property af_p740;
	@(posedge wb_clk_i) (i2_wb_cyc_i && i2_wb_stb_i && !i2_wb_ack_o) |-> $stable(i2_wb_we_i);
	endproperty
	assert property(af_p740);

	property af_p741;
	@(posedge wb_clk_i) (i2_wb_cyc_i && i2_wb_stb_i) |-> $stable(i2_wb_we_i);
	endproperty
	assert property(af_p741);

	property af_p742;
	@(posedge wb_clk_i) (i2_wb_we_i && i2_wb_stb_i && i2_wb_cyc_i) |-> (t0_wb_we_o == i2_wb_we_i);
	endproperty
	assert property(af_p742);

	property af_p743;
	@(posedge wb_clk_i) (!i2_wb_we_i && i2_wb_stb_i && i2_wb_ack_o) |-> !$isunknown(i2_wb_dat_o);
	endproperty
	assert property(af_p743);

	property af_p744;
	@(posedge wb_clk_i) (i2_wb_we_i) |-> $stable(i2_wb_dat_o);
	endproperty
	assert property(af_p744);

	property af_p745;
	@(posedge wb_clk_i) (i2_wb_stb_i) |-> $stable(i2_wb_we_i) throughout (i2_wb_stb_i)[*1:$];
	endproperty
	assert property(af_p745);

	property af_p746;
	@(posedge wb_clk_i) (i2_wb_we_i && i2_wb_adr_i inside {[2:2]}) |-> (t2_wb_we_o == i2_wb_we_i) && (t3_wb_we_o == 1'b0);
	endproperty
	assert property(af_p746);

	property af_p747;
	@(posedge wb_clk_i) (i2_wb_cyc_i && $past(i2_wb_cyc_i)) |-> $stable(i2_wb_we_i);
	endproperty
	assert property(af_p747);

	property af_p748;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (!$isunknown(i2_wb_we_i));
	endproperty
	assert property(af_p748);

	property af_p749;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (i2_wb_we_i == 1'b0 || i2_wb_we_i == 1'b1);
	endproperty
	assert property(af_p749);

	property af_p750;
	@(posedge wb_clk_i) (i2_wb_we_i && i2_wb_stb_i && i2_wb_cyc_i) |-> ##[0:1] i2_wb_ack_o;
	endproperty
	assert property(af_p750);

	property af_p751;
	@(posedge wb_clk_i) 1'b1 |-> (i2_wb_we_i === i2_wb_we_i);
	endproperty
	assert property(af_p751);

	property af_p752;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (i2_wb_we_i == 1'b0)[*2];
	endproperty
	assert property(af_p752);

	property af_p753;
	@(posedge wb_clk_i) (i2_wb_cyc_i && !i2_wb_ack_o) |=> $stable(i2_wb_we_i);
	endproperty
	assert property(af_p753);

	property af_p754;
	@(posedge wb_clk_i) (!i2_wb_stb_i) |-> (!i2_wb_ack_o);
	endproperty
	assert property(af_p754);

	property af_p755;
	@(posedge wb_clk_i) (i2_wb_we_i && i2_wb_stb_i && i2_wb_cyc_i) |-> !$isunknown(i2_wb_dat_i);
	endproperty
	assert property(af_p755);

	property af_p756;
	@(posedge wb_clk_i) (i2_wb_we_i) |-> (i2_wb_cyc_i);
	endproperty
	assert property(af_p756);

	property af_p757;
	@(posedge wb_clk_i) $rose(i2_wb_cyc_i) |-> (i2_wb_we_i throughout (i2_wb_ack_o || i2_wb_err_o)[->1]) or (!i2_wb_we_i throughout (i2_wb_ack_o || i2_wb_err_o)[->1]);
	endproperty
	assert property(af_p757);

	property af_p758;
	@(posedge wb_clk_i) (!i2_wb_we_i && i2_wb_stb_i && i2_wb_cyc_i && i2_wb_ack_o) |-> (i2_wb_dat_o == t0_wb_dat_i);
	endproperty
	assert property(af_p758);

	property af_p759;
	@(posedge wb_clk_i) (i2_wb_we_i) |-> (!$isunknown(i2_wb_sel_i) && !i2_wb_err_o);
	endproperty
	assert property(af_p759);

	property af_p760;
	@(posedge wb_clk_i) (wb_rst_i) |-> !$isunknown(i2_wb_we_i);
	endproperty
	assert property(af_p760);

	property af_p761;
	@(posedge wb_clk_i) (!i2_wb_cyc_i) |-> (t1_wb_we_o == 1'b0);
	endproperty
	assert property(af_p761);

	property af_p762;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (i2_wb_we_i == 1'b0);
	endproperty
	assert property(af_p762);

	property af_p763;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (i2_wb_we_i == 1'b0);
	endproperty
	assert property(af_p763);

	property af_p764;
	@(posedge wb_clk_i) ($rose(i3_wb_ack_o)) |=> ($fell(i3_wb_ack_o));
	endproperty
	assert property(af_p764);

	property af_p765;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i3_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p765);

	property af_p766;
	@(posedge wb_clk_i) ($rose(wb_rst_i) && i3_wb_cyc_i) |-> (i3_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p766);

	property af_p767;
	@(posedge wb_clk_i) ($fell(i3_wb_stb_i)) |=> (i3_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p767);

	property af_p768;
	@(posedge wb_clk_i) (i3_wb_ack_o) |-> (i3_wb_cyc_i && i3_wb_stb_i);
	endproperty
	assert property(af_p768);

	property af_p769;
	@(posedge wb_clk_i) ($fell(wb_rst_i) && !i3_wb_cyc_i) |-> (i3_wb_ack_o == 1'b0) [*2];
	endproperty
	assert property(af_p769);

	property af_p770;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (i3_wb_ack_o == 1'b0) [*2];
	endproperty
	assert property(af_p770);

	property af_p771;
	@(posedge wb_clk_i) ($rose(i3_wb_ack_o) && i3_wb_stb_i) |=> (i3_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p771);

	property af_p772;
	@(posedge wb_clk_i) (!i3_wb_cyc_i) |-> (i3_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p772);

	property af_p773;
	@(posedge wb_clk_i) i3_wb_ack_o |-> (i3_wb_cyc_i && i3_wb_stb_i);
	endproperty
	assert property(af_p773);

	property af_p774;
	@(posedge wb_clk_i) $fell(i3_wb_cyc_i) |=> !i3_wb_ack_o;
	endproperty
	assert property(af_p774);

	property af_p775;
	@(posedge wb_clk_i) (i3_wb_ack_o && !i3_wb_stb_i) |=> !i3_wb_ack_o;
	endproperty
	assert property(af_p775);

	property af_p776;
	@(posedge wb_clk_i) i3_wb_ack_o |-> $past(i3_wb_we_i && i3_wb_stb_i && i3_wb_cyc_i);
	endproperty
	assert property(af_p776);

	property af_p777;
	@(posedge wb_clk_i) (i3_wb_sel_i == '0) |-> !i3_wb_ack_o;
	endproperty
	assert property(af_p777);

	property af_p778;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i3_wb_ack_o ##1 !i3_wb_ack_o);
	endproperty
	assert property(af_p778);

	property af_p779;
	@(posedge wb_clk_i) !(i3_wb_ack_o && i3_wb_err_o);
	endproperty
	assert property(af_p779);

	property af_p780;
	@(posedge wb_clk_i) wb_rst_i |-> !i3_wb_ack_o;
	endproperty
	assert property(af_p780);

	property af_p781;
	@(posedge wb_clk_i) (i3_wb_cyc_i && i3_wb_stb_i) |=> i3_wb_ack_o;
	endproperty
	assert property(af_p781);

	property af_p782;
	@(posedge wb_clk_i) (i3_wb_cyc_i && i3_wb_stb_i && i3_wb_ack_o) |=> !i3_wb_ack_o;
	endproperty
	assert property(af_p782);

	property af_p783;
	@(posedge wb_clk_i) !i3_wb_cyc_i |-> $stable(i3_wb_ack_o);
	endproperty
	assert property(af_p783);

	property af_p784;
	@(posedge wb_clk_i) (i3_wb_ack_o && !i3_wb_we_i) |-> !$isunknown(i3_wb_dat_o);
	endproperty
	assert property(af_p784);

	property af_p785;
	@(posedge wb_clk_i) (i3_wb_stb_i && i3_wb_cyc_i) |=> i3_wb_ack_o;
	endproperty
	assert property(af_p785);

	property af_p786;
	@(posedge wb_clk_i) (i3_wb_we_i && i3_wb_stb_i && i3_wb_cyc_i) |=> i3_wb_ack_o;
	endproperty
	assert property(af_p786);

	property af_p787;
	@(posedge wb_clk_i) (i3_wb_cyc_i && !i3_wb_stb_i) |-> !i3_wb_ack_o;
	endproperty
	assert property(af_p787);

	property af_p788;
	@(posedge wb_clk_i) i3_wb_ack_o |-> $past(i3_wb_cyc_i && i3_wb_stb_i && !i3_wb_we_i);
	endproperty
	assert property(af_p788);

	property af_p789;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((i3_wb_adr_i >= 0) && (i3_wb_adr_i <= 2047));
	endproperty
	assert property(af_p789);

	property af_p790;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((i3_wb_adr_i >= 0) && (i3_wb_adr_i <= 127));
	endproperty
	assert property(af_p790);

	property af_p791;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i3_wb_adr_i == 0);
	endproperty
	assert property(af_p791);

	property af_p792;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((i3_wb_adr_i >= 0) && (i3_wb_adr_i <= 4095));
	endproperty
	assert property(af_p792);

	property af_p793;
	@(posedge wb_clk_i) ((i3_wb_adr_i >= 0) && (i3_wb_adr_i <= 1023) && i3_wb_cyc_i) |=> ((i3_wb_adr_i >= 0) && (i3_wb_adr_i <= 1023));
	endproperty
	assert property(af_p793);

	property af_p794;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((i3_wb_adr_i >= 0) && (i3_wb_adr_i <= 65535));
	endproperty
	assert property(af_p794);

	property af_p795;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((i3_wb_adr_i >= 0) && (i3_wb_adr_i <= 65535));
	endproperty
	assert property(af_p795);

	property af_p796;
	@(posedge wb_clk_i) ((i3_wb_sel_i != 0) && i3_wb_cyc_i) |-> ((i3_wb_adr_i >= 0) && (i3_wb_adr_i <= 255));
	endproperty
	assert property(af_p796);

	property af_p797;
	@(posedge wb_clk_i) (i3_wb_stb_i && i3_wb_cyc_i) |-> ($stable(i3_wb_adr_i) until i3_wb_ack_o);
	endproperty
	assert property(af_p797);

	property af_p798;
	@(posedge wb_clk_i) ((i3_wb_adr_i >= 512) && (i3_wb_adr_i <= 1023) && i3_wb_stb_i) |=> (((i3_wb_adr_i >= 0) && (i3_wb_adr_i <= 1023)) until i3_wb_err_o);
	endproperty
	assert property(af_p798);

	property af_p799;
	@(posedge wb_clk_i) ((i3_wb_adr_i >= 0) && (i3_wb_adr_i <= 4095) && i3_wb_cyc_i && i3_wb_stb_i) |=> (((i3_wb_adr_i >= 0) && (i3_wb_adr_i <= 4095)) until i3_wb_ack_o);
	endproperty
	assert property(af_p799);

	property af_p800;
	@(posedge wb_clk_i) (i3_wb_cyc_i && i3_wb_we_i) |-> (((i3_wb_adr_i >= 0) && (i3_wb_adr_i <= 1023)) until (!i3_wb_cyc_i));
	endproperty
	assert property(af_p800);

	property af_p801;
	@(posedge wb_clk_i) (i3_wb_cyc_i && i3_wb_stb_i) |-> ##1 ($stable(i3_wb_adr_i) || i3_wb_ack_o || i3_wb_err_o);
	endproperty
	assert property(af_p801);

	property af_p802;
	@(posedge wb_clk_i) ((i3_wb_adr_i >= 256) && (i3_wb_adr_i <= 511) && i3_wb_cyc_i) |-> ##1 ($stable(i3_wb_we_i) -> ((i3_wb_adr_i >= 256) && (i3_wb_adr_i <= 511)));
	endproperty
	assert property(af_p802);

	property af_p803;
	@(posedge wb_clk_i) (i3_wb_stb_i && !i3_wb_ack_o) |-> $stable(i3_wb_adr_i);
	endproperty
	assert property(af_p803);

	property af_p804;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (i3_wb_adr_i >= 0 && i3_wb_adr_i <= 4095);
	endproperty
	assert property(af_p804);

	property af_p805;
	@(posedge wb_clk_i) (i3_wb_cyc_i && !i3_wb_stb_i) |-> $stable(i3_wb_adr_i);
	endproperty
	assert property(af_p805);

	property af_p806;
	@(posedge wb_clk_i) $changed(i3_wb_adr_i) |-> $past(i3_wb_ack_o);
	endproperty
	assert property(af_p806);

	property af_p807;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (i3_wb_adr_i == 0) until_with i3_wb_stb_i;
	endproperty
	assert property(af_p807);

	property af_p808;
	@(posedge wb_clk_i) $changed(i3_wb_adr_i) |-> ($past(i3_wb_cyc_i) && $past(i3_wb_ack_o));
	endproperty
	assert property(af_p808);

	property af_p809;
	@(posedge wb_clk_i) ($rose(i3_wb_cyc_i)) |-> (i3_wb_cyc_i throughout (!i3_wb_ack_o)[->1]);
	endproperty
	assert property(af_p809);

	property af_p810;
	@(posedge wb_clk_i) (i3_wb_cyc_i && $past(i3_wb_cyc_i)) |-> $stable(i3_wb_adr_i);
	endproperty
	assert property(af_p810);

	property af_p811;
	@(posedge wb_clk_i) (i3_wb_stb_i) |-> (i3_wb_cyc_i);
	endproperty
	assert property(af_p811);

	property af_p812;
	@(posedge wb_clk_i) (i3_wb_cyc_i && i3_wb_we_i) |-> ($stable(i3_wb_dat_i) throughout (!i3_wb_ack_o)[->1]);
	endproperty
	assert property(af_p812);

	property af_p813;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!i3_wb_cyc_i)[*4];
	endproperty
	assert property(af_p813);

	property af_p814;
	@(posedge wb_clk_i) (!i3_wb_cyc_i) |-> (!i3_wb_ack_o);
	endproperty
	assert property(af_p814);

	property af_p815;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!i3_wb_cyc_i) ##1 (!i3_wb_cyc_i);
	endproperty
	assert property(af_p815);

	property af_p816;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i3_wb_cyc_i == 1'b0);
	endproperty
	assert property(af_p816);

	property af_p817;
	@(posedge wb_clk_i) (i3_wb_stb_i) |-> $stable(i3_wb_cyc_i);
	endproperty
	assert property(af_p817);

	property af_p818;
	@(posedge wb_clk_i) (i3_wb_err_o) |-> (i3_wb_cyc_i);
	endproperty
	assert property(af_p818);

	property af_p819;
	@(posedge wb_clk_i) (i3_wb_ack_o) |=> (!i3_wb_cyc_i);
	endproperty
	assert property(af_p819);

	property af_p820;
	@(posedge wb_clk_i) $rose(i3_wb_cyc_i) |-> i3_wb_cyc_i throughout (##[1:$] i3_wb_ack_o);
	endproperty
	assert property(af_p820);

	property af_p821;
	@(posedge wb_clk_i) $rose(i3_wb_cyc_i) |-> i3_wb_adr_i throughout (i3_wb_cyc_i[*1:$]);
	endproperty
	assert property(af_p821);

	property af_p822;
	@(posedge wb_clk_i) (i3_wb_cyc_i) |-> $stable(i3_wb_we_i);
	endproperty
	assert property(af_p822);

	property af_p823;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!i3_wb_cyc_i);
	endproperty
	assert property(af_p823);

	property af_p824;
	@(posedge wb_clk_i) $rose(i3_wb_cyc_i) |-> (i3_wb_stb_i[->1] ##1 i3_wb_stb_i[->1]);
	endproperty
	assert property(af_p824);

	property af_p825;
	@(posedge wb_clk_i) (i3_wb_cyc_i) |-> (i3_wb_stb_i);
	endproperty
	assert property(af_p825);

	property af_p826;
	@(posedge wb_clk_i) (i3_wb_adr_i != $past(i3_wb_adr_i)) |-> $past(i3_wb_cyc_i);
	endproperty
	assert property(af_p826);

	property af_p827;
	@(posedge wb_clk_i) i3_wb_err_o |-> ##1 !i3_wb_cyc_i;
	endproperty
	assert property(af_p827);

	property af_p828;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> !i3_wb_cyc_i;
	endproperty
	assert property(af_p828);

	property af_p829;
	@(posedge wb_clk_i) i3_wb_cyc_i |-> i3_wb_stb_i;
	endproperty
	assert property(af_p829);

	property af_p830;
	@(posedge wb_clk_i) i3_wb_err_o |-> i3_wb_cyc_i;
	endproperty
	assert property(af_p830);

	property af_p831;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i3_wb_cyc_i;
	endproperty
	assert property(af_p831);

	property af_p832;
	@(posedge wb_clk_i) (i3_wb_cyc_i && !i3_wb_err_o) |-> ##[1:16] i3_wb_ack_o;
	endproperty
	assert property(af_p832);

	property af_p833;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 i3_wb_cyc_i;
	endproperty
	assert property(af_p833);

	property af_p834;
	@(posedge wb_clk_i) $fell(i3_wb_cyc_i) |-> ##1 i3_wb_cyc_i;
	endproperty
	assert property(af_p834);

	property af_p835;
	@(posedge wb_clk_i) i3_wb_cyc_i |-> (i3_wb_cyc_i until_with i3_wb_ack_o);
	endproperty
	assert property(af_p835);

	property af_p836;
	@(posedge wb_clk_i) ((i3_wb_dat_i >= 100) && (i3_wb_dat_i <= 150)) |-> ##1 ((i3_wb_dat_i >= 80) && (i3_wb_dat_i <= 150));
	endproperty
	assert property(af_p836);

	property af_p837;
	@(posedge wb_clk_i) (!i3_wb_cyc_i) |-> 1'b1;
	endproperty
	assert property(af_p837);

	property af_p838;
	@(posedge wb_clk_i) (i3_wb_stb_i && (i3_wb_dat_i >= 200) && (i3_wb_dat_i <= 255)) |-> ##1 (i3_wb_stb_i throughout ((i3_wb_dat_i >= 180) && (i3_wb_dat_i <= 255)));
	endproperty
	assert property(af_p838);

	property af_p839;
	@(posedge wb_clk_i) (i3_wb_cyc_i && !i3_wb_ack_o) |-> $stable(i3_wb_dat_i);
	endproperty
	assert property(af_p839);

	property af_p840;
	@(posedge wb_clk_i) (i3_wb_stb_i && !i3_wb_ack_o) |-> $stable(i3_wb_dat_i);
	endproperty
	assert property(af_p840);

	property af_p841;
	@(posedge wb_clk_i) $rose(wb_rst_i === 1'b0) |-> ##3 ((i3_wb_dat_i >= 0) && (i3_wb_dat_i <= 255));
	endproperty
	assert property(af_p841);

	property af_p842;
	@(posedge wb_clk_i) disable iff (wb_rst_i) ((i3_wb_dat_i >= 0) && (i3_wb_dat_i <= 255)) |-> ##1 ((i3_wb_dat_i >= 0) && (i3_wb_dat_i <= 255));
	endproperty
	assert property(af_p842);

	property af_p843;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i3_wb_cyc_i && i3_wb_stb_i) |-> (i3_wb_dat_i >= 0 && i3_wb_dat_i <= 255);
	endproperty
	assert property(af_p843);

	property af_p844;
	@(posedge wb_clk_i) (!i3_wb_we_i && i3_wb_ack_o) |-> (i3_wb_dat_i >= 0 && i3_wb_dat_i <= 255);
	endproperty
	assert property(af_p844);


	property af_p846;
	@(posedge wb_clk_i) (i3_wb_dat_i >= 200 && i3_wb_dat_i <= 255) |=> (i3_wb_dat_i >= 180 && i3_wb_dat_i <= 255);
	endproperty
	assert property(af_p846);

	property af_p847;
	@(posedge wb_clk_i) (($countones(i3_wb_sel_i) > 0) && !i3_wb_we_i && i3_wb_ack_o) |-> (i3_wb_dat_i >= 0 && i3_wb_dat_i <= 255);
	endproperty
	assert property(af_p847);

	property af_p848;
	@(posedge wb_clk_i) (i3_wb_cyc_i && i3_wb_stb_i && (i3_wb_dat_i >= 50 && i3_wb_dat_i <= 199)) |-> (i3_wb_dat_i >= 30 && i3_wb_dat_i <= 219) ##1 (i3_wb_dat_i >= 30 && i3_wb_dat_i <= 219) ##1 (i3_wb_dat_i >= 30 && i3_wb_dat_i <= 219);
	endproperty
	assert property(af_p848);

	property af_p849;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (i3_wb_dat_i >= 0 && i3_wb_dat_i <= 127);
	endproperty
	assert property(af_p849);

	property af_p850;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (i3_wb_dat_i >= 0) && (i3_wb_dat_i <= 127);
	endproperty
	assert property(af_p850);

	property af_p851;
	@(posedge wb_clk_i) ((i3_wb_dat_i >= 100) && (i3_wb_dat_i <= 150) && !i3_wb_we_i) |=> (i3_wb_dat_i >= 90) && (i3_wb_dat_i <= 160);
	endproperty
	assert property(af_p851);


	property af_p853;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!$isunknown(i3_wb_dat_i) && (i3_wb_dat_i >= 0) && (i3_wb_dat_i <= 255))[*5];
	endproperty
	assert property(af_p853);

	property af_p854;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i3_wb_cyc_i && i3_wb_stb_i) |-> (i3_wb_dat_i >= 0) && (i3_wb_dat_i <= 255);
	endproperty
	assert property(af_p854);

	property af_p855;
	@(posedge wb_clk_i) (i3_wb_ack_o) |=> $stable(i3_wb_dat_i);
	endproperty
	assert property(af_p855);

	property af_p856;
	@(posedge wb_clk_i) i3_wb_ack_o |-> ($stable(i3_wb_dat_o) && (i3_wb_dat_o >= 0) && (i3_wb_dat_o <= 255));
	endproperty
	assert property(af_p856);

	property af_p857;
	@(posedge wb_clk_i) (!i3_wb_we_i && i3_wb_ack_o) |-> !$isunknown(i3_wb_dat_o);
	endproperty
	assert property(af_p857);

	property af_p858;
	@(posedge wb_clk_i) i3_wb_err_o |-> $stable(i3_wb_dat_o);
	endproperty
	assert property(af_p858);

	property af_p859;
	@(posedge wb_clk_i) !(i3_wb_stb_i && i3_wb_cyc_i) |-> $stable(i3_wb_dat_o);
	endproperty
	assert property(af_p859);

	property af_p860;
	@(posedge wb_clk_i) i3_wb_cyc_i |-> ((i3_wb_dat_o >= 0) && (i3_wb_dat_o <= 255));
	endproperty
	assert property(af_p860);

	property af_p861;
	@(posedge wb_clk_i) i3_wb_ack_o |-> $stable(i3_wb_dat_o);
	endproperty
	assert property(af_p861);

	property af_p862;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 !$isunknown(i3_wb_dat_o);
	endproperty
	assert property(af_p862);

	property af_p863;
	@(posedge wb_clk_i) (!i3_wb_cyc_i && !i3_wb_stb_i) |-> $stable(i3_wb_dat_o);
	endproperty
	assert property(af_p863);

	property af_p864;
	@(posedge wb_clk_i) i3_wb_ack_o |-> ($stable(i3_wb_adr_i) && !$isunknown(i3_wb_dat_o));
	endproperty
	assert property(af_p864);

	property af_p865;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (($stable(i3_wb_dat_o)) && (i3_wb_dat_o >= 0) && (i3_wb_dat_o <= 255));
	endproperty
	assert property(af_p865);

	property af_p866;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (i3_wb_dat_o == 8'h00) ##1 (i3_wb_dat_o == 8'h00);
	endproperty
	assert property(af_p866);

	property af_p867;
	@(posedge wb_clk_i) $fell(i3_wb_cyc_i) |-> $stable(i3_wb_dat_o);
	endproperty
	assert property(af_p867);

	property af_p868;
	@(posedge wb_clk_i) $fell(i3_wb_cyc_i) |=> $stable(i3_wb_dat_o);
	endproperty
	assert property(af_p868);

	property af_p869;
	@(posedge wb_clk_i) (!i3_wb_we_i && i3_wb_ack_o) |-> (i3_wb_dat_o >= 1 && i3_wb_dat_o <= 254);
	endproperty
	assert property(af_p869);

	property af_p870;
	@(posedge wb_clk_i) (!i3_wb_we_i && i3_wb_stb_i) |=> (i3_wb_dat_o >= 0 && i3_wb_dat_o <= 255);
	endproperty
	assert property(af_p870);

	property af_p871;
	@(posedge wb_clk_i) !i3_wb_ack_o |=> $stable(i3_wb_dat_o);
	endproperty
	assert property(af_p871);

	property af_p872;
	@(posedge wb_clk_i) (i3_wb_ack_o && i3_wb_cyc_i && i3_wb_stb_i) |=> (i3_wb_dat_o >= 0 && i3_wb_dat_o <= 255);
	endproperty
	assert property(af_p872);

	property af_p873;
	@(posedge wb_clk_i) ($past(!wb_rst_i, 3) && i3_wb_stb_i) |-> (i3_wb_dat_o >= 0 && i3_wb_dat_o <= 255);
	endproperty
	assert property(af_p873);

	property af_p874;
	@(posedge wb_clk_i) i3_wb_cyc_i |-> !$isunknown(i3_wb_dat_o);
	endproperty
	assert property(af_p874);

	property af_p875;
	@(posedge wb_clk_i) wb_rst_i |-> (i3_wb_dat_o == '0);
	endproperty
	assert property(af_p875);

	property af_p876;
	@(posedge wb_clk_i) i3_wb_ack_o |=> (i3_wb_dat_o >= 0 && i3_wb_dat_o <= 127);
	endproperty
	assert property(af_p876);

	property af_p877;
	@(posedge wb_clk_i) ($rose(i3_wb_sel_i)) |-> (i3_wb_dat_o >= 128 && i3_wb_dat_o <= 255)[*2];
	endproperty
	assert property(af_p877);


	property af_p879;
	@(posedge wb_clk_i) (i3_wb_err_o) |-> $stable(i3_wb_dat_o);
	endproperty
	assert property(af_p879);

	property af_p880;
	@(posedge wb_clk_i) (!i3_wb_stb_i) |-> $stable(i3_wb_dat_o);
	endproperty
	assert property(af_p880);

	property af_p881;
	@(posedge wb_clk_i) (i3_wb_stb_i && i3_wb_cyc_i) |-> ##1 (!$isunknown(i3_wb_dat_o));
	endproperty
	assert property(af_p881);

	property af_p882;
	@(posedge wb_clk_i) (i3_wb_cyc_i && !$isunknown(i3_wb_adr_i)) |-> (i3_wb_dat_o >= 0 && i3_wb_dat_o <= 255);
	endproperty
	assert property(af_p882);

	property af_p883;
	@(posedge wb_clk_i) (i3_wb_cyc_i && i3_wb_stb_i) |-> ##1 (i3_wb_dat_o >= 0 && i3_wb_dat_o <= 255);
	endproperty
	assert property(af_p883);

	property af_p884;
	@(posedge wb_clk_i) (wb_rst_i) |-> ##1 (i3_wb_dat_o == 0);
	endproperty
	assert property(af_p884);

	property af_p885;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (i3_wb_dat_o >= 0 && i3_wb_dat_o <= 255)[*3];
	endproperty
	assert property(af_p885);

	property af_p886;
	@(posedge wb_clk_i) (i3_wb_stb_i && !i3_wb_ack_o) |-> $stable(i3_wb_dat_o);
	endproperty
	assert property(af_p886);

	property af_p887;
	@(posedge wb_clk_i) $fell(i3_wb_stb_i) |-> ##1 (i3_wb_err_o == 1'b0);
	endproperty
	assert property(af_p887);

	property af_p888;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i3_wb_err_o == 1'b0)[*4];
	endproperty
	assert property(af_p888);

	property af_p889;
	@(posedge wb_clk_i) $rose(i3_wb_err_o) |-> ##1 (i3_wb_err_o == 1'b0);
	endproperty
	assert property(af_p889);

	property af_p890;
	@(posedge wb_clk_i) (i3_wb_we_i && i3_wb_err_o) |-> !i3_wb_ack_o;
	endproperty
	assert property(af_p890);

	property af_p891;
	@(posedge wb_clk_i) wb_rst_i |-> (i3_wb_err_o == 1'b0);
	endproperty
	assert property(af_p891);

	property af_p892;
	@(posedge wb_clk_i) (i3_wb_err_o) |-> ##1 ($stable(i3_wb_dat_o));
	endproperty
	assert property(af_p892);

	property af_p893;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (i3_wb_err_o == 1'b0) ##1 (i3_wb_err_o == 1'b0);
	endproperty
	assert property(af_p893);

	property af_p894;
	@(posedge wb_clk_i) !(i3_wb_err_o && i3_wb_ack_o);
	endproperty
	assert property(af_p894);

	property af_p895;
	@(posedge wb_clk_i) (!i3_wb_we_i && i3_wb_ack_o) |-> (i3_wb_err_o == 1'b0);
	endproperty
	assert property(af_p895);

	property af_p896;
	@(posedge wb_clk_i) (i3_wb_err_o) |-> (i3_wb_cyc_i && i3_wb_stb_i);
	endproperty
	assert property(af_p896);

	property af_p897;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (1'b1) |-> (i3_wb_err_o inside {1'b0, 1'b1});
	endproperty
	assert property(af_p897);

	property af_p898;
	@(posedge wb_clk_i) (!i3_wb_cyc_i) |-> (i3_wb_err_o == 1'b0);
	endproperty
	assert property(af_p898);

	property af_p899;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (i3_wb_err_o == 1'b0) ##1 (i3_wb_err_o == 1'b0);
	endproperty
	assert property(af_p899);

	property af_p900;
	@(posedge wb_clk_i) (i3_wb_err_o) |=> (i3_wb_err_o == 1'b0);
	endproperty
	assert property(af_p900);

	property af_p901;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i3_wb_err_o == 1'b0);
	endproperty
	assert property(af_p901);

	property af_p902;
	@(posedge wb_clk_i) ($fell(i3_wb_cyc_i)) |=> (i3_wb_err_o == 1'b0);
	endproperty
	assert property(af_p902);

	property af_p903;
	@(posedge wb_clk_i) (i3_wb_err_o) |-> (i3_wb_cyc_i);
	endproperty
	assert property(af_p903);

	property af_p904;
	@(posedge wb_clk_i) ($changed(i3_wb_err_o)) |-> ($changed(i3_wb_adr_i) || $past($changed(i3_wb_adr_i)));
	endproperty
	assert property(af_p904);

	property af_p905;
	@(posedge wb_clk_i) (i3_wb_err_o) |-> (i3_wb_cyc_i || $past(i3_wb_cyc_i));
	endproperty
	assert property(af_p905);

	property af_p906;
	@(posedge wb_clk_i) ($changed(i3_wb_err_o)) |-> (i3_wb_cyc_i);
	endproperty
	assert property(af_p906);

	property af_p907;
	@(posedge wb_clk_i) (i3_wb_err_o && i3_wb_cyc_i) |=> !(i3_wb_err_o && i3_wb_cyc_i);
	endproperty
	assert property(af_p907);

	property af_p908;
	@(posedge wb_clk_i) (!i3_wb_stb_i) |-> (i3_wb_err_o == 1'b0);
	endproperty
	assert property(af_p908);

	property af_p909;
	@(posedge wb_clk_i) ($rose(i3_wb_err_o)) |-> (i3_wb_cyc_i && i3_wb_stb_i);
	endproperty
	assert property(af_p909);

	property af_p910;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[0:2] (i3_wb_sel_i >= 0 && i3_wb_sel_i <= 15);
	endproperty
	assert property(af_p910);

	property af_p911;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (i3_wb_sel_i >= 0 && i3_wb_sel_i <= 15);
	endproperty
	assert property(af_p911);

	property af_p912;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (i3_wb_sel_i == 0);
	endproperty
	assert property(af_p912);

	property af_p913;
	@(posedge wb_clk_i) $rose(i3_wb_stb_i) |-> (i3_wb_sel_i >= 0 && i3_wb_sel_i <= 15);
	endproperty
	assert property(af_p913);

	property af_p914;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 (i3_wb_sel_i >= 0 && i3_wb_sel_i <= 15);
	endproperty
	assert property(af_p914);

	property af_p915;
	@(posedge wb_clk_i) (i3_wb_cyc_i && i3_wb_stb_i) |-> (i3_wb_sel_i >= 0 && i3_wb_sel_i <= 15);
	endproperty
	assert property(af_p915);

	property af_p916;
	@(posedge wb_clk_i) (i3_wb_cyc_i && i3_wb_stb_i && $past(i3_wb_cyc_i) && $past(i3_wb_stb_i)) |-> ((i3_wb_sel_i >= 0) && (i3_wb_sel_i <= 15) && (i3_wb_sel_i == $past(i3_wb_sel_i)));
	endproperty
	assert property(af_p916);

	property af_p917;
	@(posedge wb_clk_i) (i3_wb_we_i && i3_wb_stb_i) |-> (i3_wb_sel_i >= 0) && (i3_wb_sel_i <= 15);
	endproperty
	assert property(af_p917);

	property af_p918;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (i3_wb_sel_i >= 0) && (i3_wb_sel_i <= 15);
	endproperty
	assert property(af_p918);

	property af_p919;
	@(posedge wb_clk_i) (i3_wb_ack_o) |-> $stable(i3_wb_sel_i);
	endproperty
	assert property(af_p919);

	property af_p920;
	@(posedge wb_clk_i) ($past(i3_wb_sel_i) != '0 && i3_wb_cyc_i && i3_wb_stb_i) |-> $stable(i3_wb_sel_i);
	endproperty
	assert property(af_p920);

	property af_p921;
	@(posedge wb_clk_i) ((i3_wb_sel_i >= 1) && (i3_wb_sel_i <= 15) && i3_wb_stb_i) |-> (i3_wb_cyc_i throughout ((i3_wb_sel_i >= 1) && (i3_wb_sel_i <= 15))[->1]);
	endproperty
	assert property(af_p921);

	property af_p922;
	@(posedge wb_clk_i) (i3_wb_we_i && i3_wb_stb_i) |-> (i3_wb_sel_i != 4'b0000);
	endproperty
	assert property(af_p922);

	property af_p923;
	@(posedge wb_clk_i) (i3_wb_stb_i) |-> (i3_wb_sel_i != 4'b0000);
	endproperty
	assert property(af_p923);

	property af_p924;
	@(posedge wb_clk_i) (i3_wb_cyc_i && !i3_wb_ack_o) |=> ($stable(i3_wb_sel_i));
	endproperty
	assert property(af_p924);

	property af_p925;
	@(posedge wb_clk_i) ((i3_wb_sel_i >= 1) && (i3_wb_sel_i <= 15) && i3_wb_cyc_i) |=> ((i3_wb_sel_i >= 0) && (i3_wb_sel_i <= 15));
	endproperty
	assert property(af_p925);

	property af_p926;
	@(posedge wb_clk_i) ((i3_wb_sel_i >= 8) && (i3_wb_sel_i <= 15) && !i3_wb_ack_o) |=> (!$past(i3_wb_ack_o) |-> ((i3_wb_sel_i >= 8) && (i3_wb_sel_i <= 15)));
	endproperty
	assert property(af_p926);

	property af_p927;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((i3_wb_sel_i >= 0) && (i3_wb_sel_i <= 15));
	endproperty
	assert property(af_p927);

	property af_p928;
	@(posedge wb_clk_i) (i3_wb_cyc_i) |-> ($stable(i3_wb_sel_i) && (i3_wb_sel_i >= 0) && (i3_wb_sel_i <= 15));
	endproperty
	assert property(af_p928);

	property af_p929;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> ((i3_wb_sel_i >= 0) && (i3_wb_sel_i <= 15));
	endproperty
	assert property(af_p929);

	property af_p930;
	@(posedge wb_clk_i) (i3_wb_stb_i && i3_wb_cyc_i) |-> ##[1:3] i3_wb_ack_o;
	endproperty
	assert property(af_p930);

	property af_p931;
	@(posedge wb_clk_i) (i3_wb_stb_i && !i3_wb_cyc_i) |=> !i3_wb_ack_o;
	endproperty
	assert property(af_p931);

	property af_p932;
	@(posedge wb_clk_i) (i3_wb_stb_i && i3_wb_we_i) |-> ($stable(i3_wb_dat_i) throughout (i3_wb_stb_i && i3_wb_we_i)[->1] ##0 i3_wb_ack_o);
	endproperty
	assert property(af_p932);

	property af_p933;
	@(posedge wb_clk_i) i3_wb_stb_i |-> ($stable(i3_wb_stb_i) && $stable(i3_wb_we_i)) throughout (i3_wb_stb_i)[->1];
	endproperty
	assert property(af_p933);

	property af_p934;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[0:2] !i3_wb_stb_i;
	endproperty
	assert property(af_p934);

	property af_p935;
	@(posedge wb_clk_i) i3_wb_stb_i |-> $stable(i3_wb_sel_i);
	endproperty
	assert property(af_p935);

	property af_p936;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i3_wb_stb_i;
	endproperty
	assert property(af_p936);

	property af_p937;
	@(posedge wb_clk_i) wb_rst_i |-> (i3_wb_stb_i == 1'b0);
	endproperty
	assert property(af_p937);

	property af_p938;
	@(posedge wb_clk_i) (i3_wb_stb_i && !i3_wb_cyc_i) |=> (!i3_wb_ack_o && !i3_wb_err_o);
	endproperty
	assert property(af_p938);

	property af_p939;
	@(posedge wb_clk_i) $rose(i3_wb_stb_i) |-> $rose(wb_clk_i);
	endproperty
	assert property(af_p939);

	property af_p940;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (i3_wb_stb_i == 1'b0);
	endproperty
	assert property(af_p940);

	property af_p941;
	@(posedge wb_clk_i) wb_rst_i |-> !i3_wb_stb_i;
	endproperty
	assert property(af_p941);

	property af_p942;
	@(posedge wb_clk_i) (i3_wb_stb_i && i3_wb_we_i) |-> (($stable(i3_wb_adr_i) && $stable(i3_wb_dat_i)) until i3_wb_ack_o);
	endproperty
	assert property(af_p942);

	property af_p943;
	@(posedge wb_clk_i) (i3_wb_stb_i && (i3_wb_sel_i != '0)) |-> ##[1:$] (i3_wb_ack_o && !$isunknown(i3_wb_dat_o));
	endproperty
	assert property(af_p943);

	property af_p944;
	@(posedge wb_clk_i) i3_wb_ack_o |=> !i3_wb_stb_i;
	endproperty
	assert property(af_p944);

	property af_p945;
	@(posedge wb_clk_i) (i3_wb_stb_i && i3_wb_err_o) |-> i3_wb_cyc_i;
	endproperty
	assert property(af_p945);

	property af_p946;
	@(posedge wb_clk_i) (i3_wb_stb_i && i3_wb_cyc_i) |=> i3_wb_ack_o;
	endproperty
	assert property(af_p946);

	property af_p947;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i3_wb_stb_i) ##1 (!i3_wb_stb_i);
	endproperty
	assert property(af_p947);

	property af_p948;
	@(posedge wb_clk_i) (i3_wb_stb_i && !i3_wb_we_i) |-> ##[1:$] (i3_wb_ack_o && !$isunknown(i3_wb_dat_o));
	endproperty
	assert property(af_p948);

	property af_p949;
	@(posedge wb_clk_i) i3_wb_stb_i |-> (i3_wb_cyc_i ##[0:$] i3_wb_ack_o);
	endproperty
	assert property(af_p949);

	property af_p950;
	@(posedge wb_clk_i) i3_wb_stb_i |-> i3_wb_cyc_i;
	endproperty
	assert property(af_p950);

	property af_p951;
	@(posedge wb_clk_i) i3_wb_stb_i |-> (i3_wb_stb_i until i3_wb_ack_o);
	endproperty
	assert property(af_p951);

	property af_p952;
	@(posedge wb_clk_i) (i3_wb_stb_i) |-> (i3_wb_sel_i);
	endproperty
	assert property(af_p952);

	property af_p953;
	@(posedge wb_clk_i) (i3_wb_stb_i) |-> ($stable(i3_wb_adr_i) throughout (i3_wb_stb_i[->1]));
	endproperty
	assert property(af_p953);

	property af_p954;
	@(posedge wb_clk_i) ($rose(i3_wb_stb_i)) |-> (##1 $fell(i3_wb_ack_o) |-> ##[1:$] $rose(i3_wb_stb_i));
	endproperty
	assert property(af_p954);

	property af_p955;
	@(posedge wb_clk_i) (i3_wb_stb_i) |-> (i3_wb_cyc_i);
	endproperty
	assert property(af_p955);

	property af_p956;
	@(posedge wb_clk_i) (i3_wb_stb_i && !i3_wb_ack_o) |-> $stable(i3_wb_adr_i) throughout (i3_wb_stb_i[->1] ##0 !i3_wb_ack_o[*0:$] ##0 i3_wb_ack_o);
	endproperty
	assert property(af_p956);

	property af_p957;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!i3_wb_stb_i)[*2];
	endproperty
	assert property(af_p957);

	property af_p958;
	@(posedge wb_clk_i) (i3_wb_stb_i && !i3_wb_ack_o && !i3_wb_err_o) |-> (i3_wb_stb_i && $stable(i3_wb_stb_i));
	endproperty
	assert property(af_p958);

	property af_p959;
	@(posedge wb_clk_i) (i3_wb_stb_i) |-> (i3_wb_stb_i throughout ((i3_wb_ack_o || i3_wb_err_o)[->1]));
	endproperty
	assert property(af_p959);

	property af_p960;
	@(posedge wb_clk_i) (i3_wb_ack_o) |-> (!i3_wb_stb_i);
	endproperty
	assert property(af_p960);

	property af_p961;
	@(posedge wb_clk_i) (i3_wb_stb_i) |-> (i3_wb_stb_i throughout (i3_wb_ack_o[->1]));
	endproperty
	assert property(af_p961);

	property af_p962;
	@(posedge wb_clk_i) (!i3_wb_ack_o && $past(i3_wb_stb_i)) |-> ($stable(i3_wb_stb_i));
	endproperty
	assert property(af_p962);

	property af_p963;
	@(posedge wb_clk_i) (i3_wb_stb_i && !i3_wb_cyc_i) |-> ##1 (i3_wb_err_o);
	endproperty
	assert property(af_p963);

	property af_p964;
	@(posedge wb_clk_i) i3_wb_stb_i |-> $stable(i3_wb_we_i);
	endproperty
	assert property(af_p964);

	property af_p965;
	@(posedge wb_clk_i) disable iff (!i3_wb_cyc_i) $stable(i3_wb_we_i);
	endproperty
	assert property(af_p965);

	property af_p966;
	@(posedge wb_clk_i) i3_wb_stb_i |-> ($stable(i3_wb_we_i) || $changed(i3_wb_we_i));
	endproperty
	assert property(af_p966);

	property af_p967;
	@(posedge wb_clk_i) $changed(i3_wb_we_i) |-> (!i3_wb_cyc_i);
	endproperty
	assert property(af_p967);

	property af_p968;
	@(posedge wb_clk_i) (!i3_wb_cyc_i) |-> $stable(i3_wb_we_i);
	endproperty
	assert property(af_p968);

	property af_p969;
	@(posedge wb_clk_i) (!i3_wb_we_i && i3_wb_ack_o) |-> (!$isunknown(i3_wb_dat_o));
	endproperty
	assert property(af_p969);

	property af_p970;
	@(posedge wb_clk_i) (i3_wb_cyc_i && $past(i3_wb_cyc_i)) |-> $stable(i3_wb_we_i);
	endproperty
	assert property(af_p970);

	property af_p971;
	@(posedge wb_clk_i) (i3_wb_we_i && i3_wb_err_o) |-> (!i3_wb_ack_o);
	endproperty
	assert property(af_p971);

	property af_p972;
	@(posedge wb_clk_i) (i3_wb_we_i && i3_wb_stb_i) |=> $stable(i3_wb_dat_i);
	endproperty
	assert property(af_p972);

	property af_p973;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!i3_wb_we_i) ##1 (!i3_wb_we_i);
	endproperty
	assert property(af_p973);

	property af_p974;
	@(posedge wb_clk_i) (i3_wb_we_i) |-> (i3_wb_sel_i != '0);
	endproperty
	assert property(af_p974);

	property af_p975;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i3_wb_we_i == 1'b0);
	endproperty
	assert property(af_p975);

	property af_p976;
	@(posedge wb_clk_i) (i3_wb_stb_i) |-> ($stable(i3_wb_we_i) throughout (i3_wb_stb_i)[*1:$]);
	endproperty
	assert property(af_p976);

	property af_p977;
	@(posedge wb_clk_i) (i3_wb_cyc_i && i3_wb_stb_i) |-> ##1 (i3_wb_cyc_i && i3_wb_stb_i) |-> $stable(i3_wb_we_i);
	endproperty
	assert property(af_p977);

	property af_p978;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (i3_wb_we_i) throughout (!(i3_wb_cyc_i && i3_wb_stb_i))[*1:$];
	endproperty
	assert property(af_p978);

	property af_p979;
	@(posedge wb_clk_i) (i3_wb_we_i) |-> (i3_wb_cyc_i && i3_wb_stb_i);
	endproperty
	assert property(af_p979);

	property af_p980;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (i3_wb_we_i == 1'b0 || i3_wb_we_i == 1'b1);
	endproperty
	assert property(af_p980);

	property af_p981;
	@(posedge wb_clk_i) (i3_wb_we_i) |-> (i3_wb_stb_i);
	endproperty
	assert property(af_p981);

	property af_p982;
	@(posedge wb_clk_i) (i3_wb_we_i && i3_wb_stb_i && i3_wb_cyc_i) |-> (i3_wb_ack_o);
	endproperty
	assert property(af_p982);

	property af_p983;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(i3_wb_we_i);
	endproperty
	assert property(af_p983);

	property af_p984;
	@(posedge wb_clk_i) (i3_wb_cyc_i && i3_wb_stb_i) |-> $stable(i3_wb_we_i) throughout (i3_wb_cyc_i && i3_wb_stb_i)[*1:$] ##0 i3_wb_ack_o;
	endproperty
	assert property(af_p984);

	property af_p985;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (i3_wb_we_i == 1'b0 || i3_wb_we_i == 1'b1);
	endproperty
	assert property(af_p985);

	property af_p986;
	@(posedge wb_clk_i) (!i3_wb_we_i && i3_wb_ack_o) |-> !$isunknown(i3_wb_dat_o);
	endproperty
	assert property(af_p986);

	property af_p987;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (i3_wb_we_i === 1'b0);
	endproperty
	assert property(af_p987);

	property af_p988;
	@(posedge wb_clk_i) (i3_wb_we_i && |i3_wb_sel_i) |-> !$isunknown(i3_wb_dat_i & {8{i3_wb_sel_i[0]}});
	endproperty
	assert property(af_p988);

	property af_p989;
	@(posedge wb_clk_i) (i3_wb_we_i && i3_wb_cyc_i && i3_wb_stb_i) |-> (i3_wb_dat_i throughout i3_wb_ack_o[->1]);
	endproperty
	assert property(af_p989);

	property af_p990;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i3_wb_we_i === 1'b0) throughout !(i3_wb_stb_i && i3_wb_cyc_i)[->1];
	endproperty
	assert property(af_p990);

	property af_p991;
	@(posedge wb_clk_i) (i3_wb_stb_i && i3_wb_cyc_i && i3_wb_we_i) |-> !$isunknown(i3_wb_dat_i);
	endproperty
	assert property(af_p991);

	property af_p992;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 (i3_wb_we_i === 1'b0 || i3_wb_we_i === 1'b1);
	endproperty
	assert property(af_p992);

	property af_p993;
	@(posedge wb_clk_i) i3_wb_cyc_i |-> (i3_wb_we_i === 1'b0 || i3_wb_we_i === 1'b1);
	endproperty
	assert property(af_p993);

	property af_p994;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (i3_wb_we_i === 1'b0 || i3_wb_we_i === 1'b1);
	endproperty
	assert property(af_p994);

	property af_p995;
	@(posedge wb_clk_i) !(i4_wb_ack_o && i4_wb_err_o);
	endproperty
	assert property(af_p995);

	property af_p996;
	@(posedge wb_clk_i) (i4_wb_ack_o) |=> !(i4_wb_ack_o);
	endproperty
	assert property(af_p996);

	property af_p997;
	@(posedge wb_clk_i) (!i4_wb_we_i && i4_wb_stb_i && i4_wb_cyc_i) |-> ##[0:1] (i4_wb_ack_o == 1'b1);
	endproperty
	assert property(af_p997);

	property af_p998;
	@(posedge wb_clk_i) ($fell(i4_wb_cyc_i)) |=> (i4_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p998);

	property af_p999;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i4_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p999);

	property af_p1000;
	@(posedge wb_clk_i) (i4_wb_stb_i && i4_wb_cyc_i) |-> ##[0:1] (i4_wb_ack_o == 1'b1);
	endproperty
	assert property(af_p1000);

	property af_p1001;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> ##[0:2] (i4_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p1001);

	property af_p1002;
	@(posedge wb_clk_i) (i4_wb_ack_o) |-> !(i4_wb_err_o);
	endproperty
	assert property(af_p1002);

	property af_p1003;
	@(posedge wb_clk_i) ($fell(i4_wb_stb_i)) |-> ##[0:1] (i4_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p1003);

	property af_p1004;
	@(posedge wb_clk_i) (i4_wb_ack_o && !i4_wb_we_i) |-> $stable(i4_wb_dat_o);
	endproperty
	assert property(af_p1004);

	property af_p1005;
	@(posedge wb_clk_i) $fell(i4_wb_cyc_i) |=> !i4_wb_ack_o;
	endproperty
	assert property(af_p1005);

	property af_p1006;
	@(posedge wb_clk_i) ($past(!i4_wb_cyc_i) && !i4_wb_cyc_i) |-> $stable(i4_wb_ack_o);
	endproperty
	assert property(af_p1006);

	property af_p1007;
	@(posedge wb_clk_i) (i4_wb_ack_o && !i4_wb_stb_i) |=> !i4_wb_ack_o;
	endproperty
	assert property(af_p1007);

	property af_p1008;
	@(posedge wb_clk_i) (i4_wb_stb_i && i4_wb_cyc_i && !i4_wb_we_i) |=> (i4_wb_ack_o ##1 !i4_wb_ack_o);
	endproperty
	assert property(af_p1008);

	property af_p1009;
	@(posedge wb_clk_i) i4_wb_ack_o |-> (i4_wb_cyc_i && i4_wb_stb_i);
	endproperty
	assert property(af_p1009);

	property af_p1010;
	@(posedge wb_clk_i) $changed(i4_wb_adr_i) |-> !i4_wb_ack_o;
	endproperty
	assert property(af_p1010);

	property af_p1011;
	@(posedge wb_clk_i) (i4_wb_sel_i == '0) |-> !i4_wb_ack_o;
	endproperty
	assert property(af_p1011);

	property af_p1012;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i4_wb_ack_o [*2]);
	endproperty
	assert property(af_p1012);

	property af_p1013;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i4_wb_ack_o [*3]);
	endproperty
	assert property(af_p1013);

	property af_p1014;
	@(posedge wb_clk_i) (i4_wb_ack_o) |-> (i4_wb_sel_i != '0) && (i4_wb_cyc_i) && (i4_wb_stb_i);
	endproperty
	assert property(af_p1014);

	property af_p1015;
	@(posedge wb_clk_i) (i4_wb_ack_o) |=> (!i4_wb_ack_o);
	endproperty
	assert property(af_p1015);

	property af_p1016;
	@(posedge wb_clk_i) (i4_wb_we_i && i4_wb_stb_i && i4_wb_cyc_i) |-> ##[0:1] (i4_wb_ack_o);
	endproperty
	assert property(af_p1016);

	property af_p1017;
	@(posedge wb_clk_i) (!i4_wb_cyc_i) |-> (!i4_wb_ack_o);
	endproperty
	assert property(af_p1017);

	property af_p1018;
	@(posedge wb_clk_i) (i4_wb_stb_i && i4_wb_cyc_i && i4_wb_we_i) |-> ##1 (i4_wb_ack_o) ##1 (!i4_wb_ack_o);
	endproperty
	assert property(af_p1018);

	property af_p1019;
	@(posedge wb_clk_i) (i4_wb_ack_o) |-> ##1 $stable(i4_wb_ack_o) || $changed(i4_wb_ack_o);
	endproperty
	assert property(af_p1019);

	property af_p1020;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!i4_wb_ack_o);
	endproperty
	assert property(af_p1020);

	property af_p1021;
	@(posedge wb_clk_i) (i4_wb_ack_o && !i4_wb_we_i) |-> ($isunknown(i4_wb_dat_o) == 0);
	endproperty
	assert property(af_p1021);

	property af_p1022;
	@(posedge wb_clk_i) (!i4_wb_stb_i) |-> (!i4_wb_ack_o);
	endproperty
	assert property(af_p1022);

	property af_p1023;
	@(posedge wb_clk_i) $changed(i4_wb_adr_i) |-> !i4_wb_cyc_i;
	endproperty
	assert property(af_p1023);

	property af_p1024;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_stb_i && !i4_wb_ack_o) |-> $stable(i4_wb_adr_i);
	endproperty
	assert property(af_p1024);

	property af_p1025;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_stb_i) |-> $stable(i4_wb_adr_i);
	endproperty
	assert property(af_p1025);

	property af_p1026;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_stb_i && (i4_wb_sel_i != 4'b1111)) |-> (i4_wb_adr_i[1:0] == 2'b00);
	endproperty
	assert property(af_p1026);

	property af_p1027;
	@(posedge wb_clk_i) $changed(i4_wb_adr_i) |-> $rose(i4_wb_stb_i);
	endproperty
	assert property(af_p1027);

	property af_p1028;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_stb_i && (i4_wb_adr_i inside {[32'h0000_0000:32'hFFFF_FFFF]})) |-> !i4_wb_err_o;
	endproperty
	assert property(af_p1028);

	property af_p1029;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> !(i4_wb_cyc_i && i4_wb_stb_i);
	endproperty
	assert property(af_p1029);

	property af_p1030;
	@(posedge wb_clk_i) disable iff (wb_rst_i) $fell(wb_rst_i) |=> !$isunknown(i4_wb_adr_i);
	endproperty
	assert property(af_p1030);

	property af_p1031;
	@(posedge wb_clk_i) (i4_wb_we_i && i4_wb_cyc_i && !i4_wb_ack_o) |-> $stable(i4_wb_adr_i);
	endproperty
	assert property(af_p1031);


	property af_p1033;
	@(posedge wb_clk_i) (i4_wb_we_i && i4_wb_cyc_i && i4_wb_stb_i) |-> ($stable(i4_wb_adr_i) until_with i4_wb_ack_o);
	endproperty
	assert property(af_p1033);

	property af_p1034;
	@(posedge wb_clk_i) (i4_wb_stb_i) |-> !$isunknown(i4_wb_adr_i);
	endproperty
	assert property(af_p1034);

	property af_p1035;
	@(posedge wb_clk_i) (i4_wb_we_i && !$isunknown(i4_wb_adr_i)) |=> $stable(i4_wb_dat_i);
	endproperty
	assert property(af_p1035);

	property af_p1036;
	@(posedge wb_clk_i) ($rose(i4_wb_cyc_i)) |-> ($stable(i4_wb_adr_i) until_with i4_wb_ack_o);
	endproperty
	assert property(af_p1036);

	property af_p1037;
	@(posedge wb_clk_i) (!i4_wb_we_i && i4_wb_cyc_i && i4_wb_stb_i) |-> ($stable(i4_wb_adr_i) until_with i4_wb_ack_o);
	endproperty
	assert property(af_p1037);

	property af_p1038;
	@(posedge wb_clk_i) ($rose(i4_wb_stb_i)) |-> !$isunknown(i4_wb_adr_i);
	endproperty
	assert property(af_p1038);

	property af_p1039;
	@(posedge wb_clk_i) (i4_wb_err_o) |-> ($stable(i4_wb_adr_i) until_with (!i4_wb_cyc_i));
	endproperty
	assert property(af_p1039);

	property af_p1040;
	@(posedge wb_clk_i) (i4_wb_adr_i != $past(i4_wb_adr_i)) |-> $past(!i4_wb_cyc_i);
	endproperty
	assert property(af_p1040);

	property af_p1041;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_stb_i) |-> ($stable(i4_wb_adr_i) until_with i4_wb_ack_o);
	endproperty
	assert property(af_p1041);

	property af_p1042;
	@(posedge wb_clk_i) wb_rst_i |=> !i4_wb_ack_o;
	endproperty
	assert property(af_p1042);

	property af_p1043;
	@(posedge wb_clk_i) ($fell(wb_rst_i) && !i4_wb_stb_i) |-> !$isunknown(i4_wb_adr_i);
	endproperty
	assert property(af_p1043);

	property af_p1044;
	@(posedge wb_clk_i) (!i4_wb_we_i && i4_wb_ack_o) |-> !$isunknown(i4_wb_dat_o) && !$isunknown(i4_wb_adr_i);
	endproperty
	assert property(af_p1044);

	property af_p1045;
	@(posedge wb_clk_i) i4_wb_cyc_i |-> !$isunknown(i4_wb_adr_i);
	endproperty
	assert property(af_p1045);

	property af_p1046;
	@(posedge wb_clk_i) (i4_wb_cyc_i && (i4_wb_sel_i != '0) && !i4_wb_ack_o) |-> $stable(i4_wb_adr_i);
	endproperty
	assert property(af_p1046);

	property af_p1047;
	@(posedge wb_clk_i) i4_wb_ack_o |=> !$isunknown(i4_wb_adr_i);
	endproperty
	assert property(af_p1047);

	property af_p1048;
	@(posedge wb_clk_i) wb_rst_i |-> ##1 (wb_rst_i || !i4_wb_ack_o);
	endproperty
	assert property(af_p1048);

	property af_p1049;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] !$isunknown(i4_wb_adr_i);
	endproperty
	assert property(af_p1049);

	property af_p1050;
	@(posedge wb_clk_i) (i4_wb_stb_i && !i4_wb_ack_o) |-> $stable(i4_wb_adr_i);
	endproperty
	assert property(af_p1050);

	property af_p1051;
	@(posedge wb_clk_i) i4_wb_cyc_i |-> (i4_wb_cyc_i) until_with (i4_wb_ack_o);
	endproperty
	assert property(af_p1051);

	property af_p1052;
	@(posedge wb_clk_i) (i4_wb_cyc_i && !i4_wb_ack_o) |-> ##1 i4_wb_cyc_i;
	endproperty
	assert property(af_p1052);

	property af_p1053;
	@(posedge wb_clk_i) ($rose(i4_wb_cyc_i) |-> i4_wb_stb_i) and ($fell(i4_wb_cyc_i) |-> !i4_wb_stb_i);
	endproperty
	assert property(af_p1053);

	property af_p1054;
	@(posedge wb_clk_i) wb_rst_i |-> !i4_wb_cyc_i;
	endproperty
	assert property(af_p1054);

	property af_p1055;
	@(posedge wb_clk_i) !i4_wb_cyc_i |-> !i4_wb_ack_o;
	endproperty
	assert property(af_p1055);

	property af_p1056;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_we_i) |-> (!$isunknown(i4_wb_dat_i) && $stable(i4_wb_dat_i));
	endproperty
	assert property(af_p1056);

	property af_p1057;
	@(posedge wb_clk_i) !($rose(i4_wb_cyc_i) && $fell(i4_wb_cyc_i));
	endproperty
	assert property(af_p1057);

	property af_p1058;
	@(posedge wb_clk_i) $changed(i4_wb_cyc_i) |-> $changed(i4_wb_ack_o);
	endproperty
	assert property(af_p1058);

	property af_p1059;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 !$isunknown(i4_wb_cyc_i);
	endproperty
	assert property(af_p1059);



	property af_p1062;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!i4_wb_cyc_i) ##1 (!i4_wb_cyc_i);
	endproperty
	assert property(af_p1062);

	property af_p1063;
	@(posedge wb_clk_i) (!i4_wb_cyc_i) |-> (!i4_wb_ack_o);
	endproperty
	assert property(af_p1063);

	property af_p1064;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!i4_wb_cyc_i);
	endproperty
	assert property(af_p1064);

	property af_p1065;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (!i4_wb_cyc_i);
	endproperty
	assert property(af_p1065);

	property af_p1066;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 (i4_wb_cyc_i === i4_wb_cyc_i) and not (##[0:2] i4_wb_cyc_i);
	endproperty
	assert property(af_p1066);

	property af_p1067;
	@(posedge wb_clk_i) (i4_wb_cyc_i) |-> (i4_wb_stb_i);
	endproperty
	assert property(af_p1067);

	property af_p1068;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_stb_i) |-> (i4_wb_sel_i != '0);
	endproperty
	assert property(af_p1068);

	property af_p1069;
	@(posedge wb_clk_i) (i4_wb_stb_i) |-> $stable(i4_wb_cyc_i);
	endproperty
	assert property(af_p1069);

	property af_p1070;
	@(posedge wb_clk_i) (!i4_wb_cyc_i) |-> (!i4_wb_stb_i);
	endproperty
	assert property(af_p1070);

	property af_p1071;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_we_i) |-> (i4_wb_cyc_i throughout (##[0:$] (i4_wb_ack_o || i4_wb_err_o)));
	endproperty
	assert property(af_p1071);

	property af_p1072;
	@(posedge wb_clk_i) i4_wb_cyc_i |-> i4_wb_stb_i;
	endproperty
	assert property(af_p1072);

	property af_p1073;
	@(posedge wb_clk_i) i4_wb_cyc_i |-> (i4_wb_cyc_i throughout (##[0:$] (i4_wb_ack_o || i4_wb_err_o)));
	endproperty
	assert property(af_p1073);

	property af_p1074;
	@(posedge wb_clk_i) $rose(i4_wb_cyc_i) |-> i4_wb_cyc_i;
	endproperty
	assert property(af_p1074);

	property af_p1075;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i4_wb_cyc_i;
	endproperty
	assert property(af_p1075);

	property af_p1076;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_we_i) |-> $stable(i4_wb_adr_i);
	endproperty
	assert property(af_p1076);

	property af_p1077;
	@(posedge wb_clk_i) i4_wb_cyc_i |-> (i4_wb_cyc_i throughout (##[0:$] i4_wb_ack_o));
	endproperty
	assert property(af_p1077);

	property af_p1078;
	@(posedge wb_clk_i) i4_wb_stb_i |-> i4_wb_cyc_i;
	endproperty
	assert property(af_p1078);

	property af_p1079;
	@(posedge wb_clk_i) i4_wb_err_o |-> ##1 !i4_wb_cyc_i;
	endproperty
	assert property(af_p1079);

	property af_p1080;
	@(posedge wb_clk_i) (i4_wb_cyc_i && !i4_wb_ack_o) |-> !$stable(i4_wb_dat_i) || 1'b1;
	endproperty
	assert property(af_p1080);

	property af_p1081;
	@(posedge wb_clk_i) (!i4_wb_stb_i) |=> $stable(i4_wb_dat_i);
	endproperty
	assert property(af_p1081);

	property af_p1082;
	@(posedge wb_clk_i) ((i4_wb_dat_i >= 200) && (i4_wb_dat_i <= 255)) |=> ((i4_wb_dat_i >= 180) && (i4_wb_dat_i <= 255));
	endproperty
	assert property(af_p1082);

	property af_p1083;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##2 ((i4_wb_dat_i >= 0) && (i4_wb_dat_i <= 255));
	endproperty
	assert property(af_p1083);

	property af_p1084;
	@(posedge wb_clk_i) (!i4_wb_we_i) |-> ((i4_wb_dat_i >= 0) && (i4_wb_dat_i <= 255));
	endproperty
	assert property(af_p1084);

	property af_p1085;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((i4_wb_dat_i >= 83) && (i4_wb_dat_i <= 165));
	endproperty
	assert property(af_p1085);

	property af_p1086;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> ((i4_wb_dat_i >= 0) && (i4_wb_dat_i <= 10));
	endproperty
	assert property(af_p1086);

	property af_p1087;
	@(posedge wb_clk_i) (!i4_wb_we_i && i4_wb_stb_i) |-> $stable(i4_wb_dat_i);
	endproperty
	assert property(af_p1087);

	property af_p1088;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_stb_i && !i4_wb_ack_o) |-> $stable(i4_wb_dat_i);
	endproperty
	assert property(af_p1088);

	property af_p1089;
	@(posedge wb_clk_i) ($past(!wb_rst_i,4)) |-> (i4_wb_dat_i >= 0) && (i4_wb_dat_i <= 45);
	endproperty
	assert property(af_p1089);

	property af_p1090;
	@(posedge wb_clk_i) ($past(!wb_rst_i,3)) |-> (i4_wb_dat_i >= 0) && (i4_wb_dat_i <= 63);
	endproperty
	assert property(af_p1090);

	property af_p1091;
	@(posedge wb_clk_i) (!wb_rst_i) |-> !$isunknown(i4_wb_dat_i);
	endproperty
	assert property(af_p1091);

	property af_p1092;
	@(posedge wb_clk_i) (i4_wb_we_i && (i4_wb_dat_i >= 60) && (i4_wb_dat_i <= 90)) |=> (i4_wb_dat_i >= 40) && (i4_wb_dat_i <= 100);
	endproperty
	assert property(af_p1092);

	property af_p1093;
	@(posedge wb_clk_i) (!i4_wb_cyc_i) |-> (i4_wb_dat_i >= 0) && (i4_wb_dat_i <= 255);
	endproperty
	assert property(af_p1093);

	property af_p1094;
	@(posedge wb_clk_i) i4_wb_ack_o |-> ##1 ((i4_wb_dat_i >= 50) && (i4_wb_dat_i <= 200)) ##1 ((i4_wb_dat_i >= 50) && (i4_wb_dat_i <= 200));
	endproperty
	assert property(af_p1094);

	property af_p1095;
	@(posedge wb_clk_i) ((i4_wb_dat_i >= 200) && (i4_wb_dat_i <= 255)) |-> ##1 ((i4_wb_dat_i >= 180) && (i4_wb_dat_i <= 255));
	endproperty
	assert property(af_p1095);

	property af_p1096;
	@(posedge wb_clk_i) ((i4_wb_dat_i >= 138) && (i4_wb_dat_i <= 153)) |-> ##[1:$] ((i4_wb_dat_i >= 98) && (i4_wb_dat_i <= 153));
	endproperty
	assert property(af_p1096);

	property af_p1097;
	@(posedge wb_clk_i) ((i4_wb_dat_i >= 100) && (i4_wb_dat_i <= 150)) |-> ##1 ((i4_wb_dat_i >= 80) && (i4_wb_dat_i <= 150));
	endproperty
	assert property(af_p1097);

	property af_p1098;
	@(posedge wb_clk_i) (i4_wb_stb_i && i4_wb_cyc_i && !i4_wb_ack_o) |-> $stable(i4_wb_dat_i);
	endproperty
	assert property(af_p1098);

	property af_p1099;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i4_wb_cyc_i) |-> ((i4_wb_dat_i >= 0) && (i4_wb_dat_i <= 255));
	endproperty
	assert property(af_p1099);

	property af_p1100;
	@(posedge wb_clk_i) ((i4_wb_ack_o) && (!i4_wb_we_i)) |-> (i4_wb_dat_o == i4_wb_dat_i);
	endproperty
	assert property(af_p1100);

	property af_p1101;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i4_wb_dat_o == 0);
	endproperty
	assert property(af_p1101);

	property af_p1102;
	@(posedge wb_clk_i) ((i4_wb_dat_o >= 200) && (i4_wb_dat_o <= 230)) |=> (i4_wb_dat_o >= 180) && (i4_wb_dat_o <= 255);
	endproperty
	assert property(af_p1102);

	property af_p1103;
	@(posedge wb_clk_i) (!wb_rst_i throughout ##3 1'b1) |-> (i4_wb_dat_o >= 0) && (i4_wb_dat_o <= 255);
	endproperty
	assert property(af_p1103);

	property af_p1104;
	@(posedge wb_clk_i) ($fell(i4_wb_stb_i)) |=> $stable(i4_wb_dat_o);
	endproperty
	assert property(af_p1104);

	property af_p1105;
	@(posedge wb_clk_i) (i4_wb_stb_i) |-> ((i4_wb_sel_i[0] || !i4_wb_sel_i[0]) && (i4_wb_dat_o[7:0] == i4_wb_dat_o[7:0]));
	endproperty
	assert property(af_p1105);

	property af_p1106;
	@(posedge wb_clk_i) ((!i4_wb_we_i) && (i4_wb_cyc_i)) |-> (i4_wb_ack_o) [->1] ##0 (!$isunknown(i4_wb_dat_o));
	endproperty
	assert property(af_p1106);

	property af_p1107;
	@(posedge wb_clk_i) ((i4_wb_dat_o >= 100) && (i4_wb_dat_o <= 150)) |=> (i4_wb_dat_o >= 80) && (i4_wb_dat_o <= 170);
	endproperty
	assert property(af_p1107);

	property af_p1108;
	@(posedge wb_clk_i) (i4_wb_err_o) |-> $stable(i4_wb_dat_o);
	endproperty
	assert property(af_p1108);

	property af_p1109;
	@(posedge wb_clk_i) (i4_wb_ack_o) |-> $stable(i4_wb_dat_o);
	endproperty
	assert property(af_p1109);

	property af_p1110;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((i4_wb_dat_o >= 0) && (i4_wb_dat_o <= 255));
	endproperty
	assert property(af_p1110);

	property af_p1111;
	@(posedge wb_clk_i) (!i4_wb_we_i && i4_wb_stb_i) |-> ##1 ((i4_wb_dat_o >= 0) && (i4_wb_dat_o <= 255));
	endproperty
	assert property(af_p1111);

	property af_p1112;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 ((i4_wb_dat_o >= 0) && (i4_wb_dat_o <= 255));
	endproperty
	assert property(af_p1112);

	property af_p1113;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (((i4_wb_dat_o >= 0) && (i4_wb_dat_o <= 255))[*1:$]);
	endproperty
	assert property(af_p1113);

	property af_p1114;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_ack_o) |-> (($stable(i4_wb_dat_o)) && (i4_wb_dat_o >= 0) && (i4_wb_dat_o <= 255));
	endproperty
	assert property(af_p1114);

	property af_p1115;
	@(posedge wb_clk_i) (i4_wb_ack_o) |-> ##1 ((i4_wb_dat_o >= 0) && (i4_wb_dat_o <= 255));
	endproperty
	assert property(af_p1115);

	property af_p1116;
	@(posedge wb_clk_i) (i4_wb_ack_o) |-> (($stable(i4_wb_dat_o)) && (i4_wb_dat_o >= 0) && (i4_wb_dat_o <= 255));
	endproperty
	assert property(af_p1116);

	property af_p1117;
	@(posedge wb_clk_i) ((i4_wb_dat_o >= 100) && (i4_wb_dat_o <= 150)) |-> ##1 ((i4_wb_dat_o >= 80) && (i4_wb_dat_o <= 170));
	endproperty
	assert property(af_p1117);

	property af_p1118;
	@(posedge wb_clk_i) (i4_wb_ack_o) |-> ($stable(i4_wb_dat_o));
	endproperty
	assert property(af_p1118);

	property af_p1119;
	@(posedge wb_clk_i) (i4_wb_stb_i) |-> (((i4_wb_dat_o >= 0) && (i4_wb_dat_o <= 255))[*3]);
	endproperty
	assert property(af_p1119);

	property af_p1120;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((i4_wb_dat_o >= 0) && (i4_wb_dat_o <= 255));
	endproperty
	assert property(af_p1120);

	property af_p1121;
	@(posedge wb_clk_i) (i4_wb_err_o) |-> (i4_wb_dat_o == $past(i4_wb_dat_o));
	endproperty
	assert property(af_p1121);

	property af_p1122;
	@(posedge wb_clk_i) (!i4_wb_cyc_i) |=> $stable(i4_wb_dat_o);
	endproperty
	assert property(af_p1122);

	property af_p1123;
	@(posedge wb_clk_i) (!i4_wb_cyc_i && !i4_wb_stb_i) |-> $stable(i4_wb_dat_o);
	endproperty
	assert property(af_p1123);

	property af_p1124;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_stb_i && !i4_wb_we_i && i4_wb_ack_o) |-> !$isunknown(i4_wb_dat_o);
	endproperty
	assert property(af_p1124);

	property af_p1125;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_stb_i && !i4_wb_we_i) |-> (i4_wb_dat_o >= 0 && i4_wb_dat_o <= 255);
	endproperty
	assert property(af_p1125);

	property af_p1126;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!$isunknown(i4_wb_dat_o));
	endproperty
	assert property(af_p1126);

	property af_p1127;
	@(posedge wb_clk_i) (1) |-> $stable(i4_wb_dat_o) or $changed(i4_wb_dat_o);
	endproperty
	assert property(af_p1127);

	property af_p1128;
	@(posedge wb_clk_i) (!(i4_wb_cyc_i && i4_wb_stb_i)) |-> $stable(i4_wb_dat_o);
	endproperty
	assert property(af_p1128);

	property af_p1129;
	@(posedge wb_clk_i) (!i4_wb_cyc_i) |-> $stable(i4_wb_dat_o);
	endproperty
	assert property(af_p1129);

	property af_p1130;
	@(posedge wb_clk_i) (i4_wb_we_i && (i4_wb_adr_i !== 'bx)) |-> (i4_wb_err_o == 1'b0);
	endproperty
	assert property(af_p1130);

	property af_p1131;
	@(posedge wb_clk_i) (i4_wb_err_o) |=> (!i4_wb_cyc_i -> !i4_wb_err_o);
	endproperty
	assert property(af_p1131);

	property af_p1132;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i4_wb_err_o == 1'b0) throughout (!(i4_wb_cyc_i && i4_wb_stb_i))[->1];
	endproperty
	assert property(af_p1132);

	property af_p1133;
	@(posedge wb_clk_i) ($stable(i4_wb_we_i) && $stable(i4_wb_adr_i)) |-> $stable(i4_wb_err_o);
	endproperty
	assert property(af_p1133);

	property af_p1134;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i4_wb_err_o == 1'b0);
	endproperty
	assert property(af_p1134);

	property af_p1135;
	@(posedge wb_clk_i) (!i4_wb_stb_i) |-> $stable(i4_wb_err_o);
	endproperty
	assert property(af_p1135);


	property af_p1137;
	@(posedge wb_clk_i) (i4_wb_err_o && i4_wb_cyc_i) |=> (!i4_wb_cyc_i -> !i4_wb_err_o);
	endproperty
	assert property(af_p1137);

	property af_p1138;
	@(posedge wb_clk_i) !(i4_wb_err_o && i4_wb_ack_o);
	endproperty
	assert property(af_p1138);

	property af_p1139;
	@(posedge wb_clk_i) $rose(i4_wb_err_o) |-> ##1 !i4_wb_err_o;
	endproperty
	assert property(af_p1139);

	property af_p1140;
	@(posedge wb_clk_i) (!i4_wb_cyc_i && $changed(i4_wb_we_i)) |-> $stable(i4_wb_err_o);
	endproperty
	assert property(af_p1140);

	property af_p1141;
	@(posedge wb_clk_i) (i4_wb_cyc_i && $rose(i4_wb_err_o)) |-> ##1 !i4_wb_err_o;
	endproperty
	assert property(af_p1141);

	property af_p1142;
	@(posedge wb_clk_i) wb_rst_i |-> !i4_wb_err_o;
	endproperty
	assert property(af_p1142);

	property af_p1143;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i4_wb_err_o[*4];
	endproperty
	assert property(af_p1143);

	property af_p1144;
	@(posedge wb_clk_i) (!i4_wb_cyc_i && !i4_wb_stb_i) |-> !i4_wb_err_o;
	endproperty
	assert property(af_p1144);

	property af_p1145;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i4_wb_err_o[*3];
	endproperty
	assert property(af_p1145);

	property af_p1146;
	@(posedge wb_clk_i) i4_wb_err_o |-> (i4_wb_cyc_i && i4_wb_stb_i);
	endproperty
	assert property(af_p1146);

	property af_p1147;
	@(posedge wb_clk_i) i4_wb_err_o |-> i4_wb_cyc_i;
	endproperty
	assert property(af_p1147);

	property af_p1148;
	@(posedge wb_clk_i) (!i4_wb_cyc_i) |-> $stable(i4_wb_err_o);
	endproperty
	assert property(af_p1148);

	property af_p1149;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i4_wb_err_o == 0) ##1 (i4_wb_err_o == 0);
	endproperty
	assert property(af_p1149);

	property af_p1150;
	@(posedge wb_clk_i) $fell(i4_wb_cyc_i) |-> ##1 (i4_wb_err_o == 0);
	endproperty
	assert property(af_p1150);

	property af_p1151;
	@(posedge wb_clk_i) (!i4_wb_stb_i) |-> (i4_wb_err_o == 0);
	endproperty
	assert property(af_p1151);

	property af_p1152;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_stb_i) |-> (i4_wb_err_o === i4_wb_err_o);
	endproperty
	assert property(af_p1152);


	property af_p1154;
	@(posedge wb_clk_i) (i4_wb_stb_i && $isunknown(i4_wb_sel_i) == 0) |-> (i4_wb_err_o == 0);
	endproperty
	assert property(af_p1154);

	property af_p1155;
	@(posedge wb_clk_i) (!wb_rst_i && !i4_wb_cyc_i) |-> (i4_wb_err_o == 0);
	endproperty
	assert property(af_p1155);

	property af_p1156;
	@(posedge wb_clk_i) ($past(!i4_wb_cyc_i && !i4_wb_stb_i) && (!i4_wb_cyc_i && !i4_wb_stb_i)) |-> (i4_wb_err_o == 0);
	endproperty
	assert property(af_p1156);

	property af_p1157;
	@(posedge wb_clk_i) (i4_wb_err_o) |-> (i4_wb_cyc_i && i4_wb_stb_i);
	endproperty
	assert property(af_p1157);

	property af_p1158;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_stb_i) |-> ($stable(i4_wb_sel_i) && $stable(i4_wb_adr_i));
	endproperty
	assert property(af_p1158);

	property af_p1159;
	@(posedge wb_clk_i) (i4_wb_cyc_i) |-> (i4_wb_sel_i == $past(i4_wb_sel_i)) until_with (i4_wb_ack_o);
	endproperty
	assert property(af_p1159);

	property af_p1160;
	@(posedge wb_clk_i) (i4_wb_we_i && i4_wb_cyc_i && i4_wb_stb_i) |-> (i4_wb_sel_i != 4'b0000);
	endproperty
	assert property(af_p1160);

	property af_p1161;
	@(posedge wb_clk_i) (i4_wb_stb_i) |-> ($stable(i4_wb_sel_i) && (i4_wb_sel_i >= 0) && (i4_wb_sel_i <= 15));
	endproperty
	assert property(af_p1161);

	property af_p1162;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i4_wb_sel_i == 4'b0000);
	endproperty
	assert property(af_p1162);

	property af_p1163;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_stb_i) |-> ($stable(i4_wb_sel_i) until_with i4_wb_ack_o);
	endproperty
	assert property(af_p1163);

	property af_p1164;
	@(posedge wb_clk_i) (!i4_wb_cyc_i) |=> ((i4_wb_sel_i >= 0) && (i4_wb_sel_i <= 15));
	endproperty
	assert property(af_p1164);

	property af_p1165;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_stb_i) |-> $stable(i4_wb_sel_i);
	endproperty
	assert property(af_p1165);

	property af_p1166;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> ((i4_wb_sel_i >= 0) && (i4_wb_sel_i <= 15));
	endproperty
	assert property(af_p1166);

	property af_p1167;
	@(posedge wb_clk_i) (i4_wb_stb_i && i4_wb_cyc_i) |-> ((i4_wb_sel_i >= 1) && (i4_wb_sel_i <= 15));
	endproperty
	assert property(af_p1167);

	property af_p1168;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ((i4_wb_sel_i >= 0) && (i4_wb_sel_i <= 15)) [*2];
	endproperty
	assert property(af_p1168);

	property af_p1169;
	@(posedge wb_clk_i) (i4_wb_ack_o) |-> $stable(i4_wb_sel_i);
	endproperty
	assert property(af_p1169);

	property af_p1170;
	@(posedge wb_clk_i) (!$rose(i4_wb_cyc_i)) |-> $stable(i4_wb_sel_i);
	endproperty
	assert property(af_p1170);

	property af_p1171;
	@(posedge wb_clk_i) (i4_wb_stb_i) |=> $stable(i4_wb_sel_i);
	endproperty
	assert property(af_p1171);

	property af_p1172;
	@(posedge wb_clk_i) (i4_wb_cyc_i) |-> !$isunknown(i4_wb_sel_i);
	endproperty
	assert property(af_p1172);

	property af_p1173;
	@(posedge wb_clk_i) (i4_wb_cyc_i) |-> $stable(i4_wb_sel_i);
	endproperty
	assert property(af_p1173);

	property af_p1174;
	@(posedge wb_clk_i) ((i4_wb_sel_i >= 1) && (i4_wb_sel_i <= 15) && i4_wb_we_i) |=> (i4_wb_sel_i >= 0) && (i4_wb_sel_i <= 15);
	endproperty
	assert property(af_p1174);

	property af_p1175;
	@(posedge wb_clk_i) (i4_wb_stb_i) |-> (i4_wb_sel_i != 4'b0000);
	endproperty
	assert property(af_p1175);

	property af_p1176;
	@(posedge wb_clk_i) (i4_wb_cyc_i) |-> (i4_wb_sel_i == (4'b1111 << i4_wb_adr_i[1:0]));
	endproperty
	assert property(af_p1176);

	property af_p1177;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (i4_wb_sel_i >= 0) && (i4_wb_sel_i <= 15);
	endproperty
	assert property(af_p1177);

	property af_p1178;
	@(posedge wb_clk_i) (i4_wb_stb_i && i4_wb_we_i) |-> (!$isunknown(i4_wb_sel_i) && (i4_wb_sel_i >= 0) && (i4_wb_sel_i <= 15));
	endproperty
	assert property(af_p1178);

	property af_p1179;
	@(posedge wb_clk_i) (i4_wb_ack_o) |-> ($past(i4_wb_sel_i) >= 0) && ($past(i4_wb_sel_i) <= 15) && $stable(i4_wb_sel_i);
	endproperty
	assert property(af_p1179);

	property af_p1180;
	@(posedge wb_clk_i) (i4_wb_cyc_i && !i4_wb_we_i && i4_wb_ack_o) |-> (i4_wb_sel_i != 4'b0000);
	endproperty
	assert property(af_p1180);

	property af_p1181;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 ($stable(i4_wb_sel_i) && (i4_wb_sel_i inside {[0:15]}));
	endproperty
	assert property(af_p1181);

	property af_p1182;
	@(posedge wb_clk_i) (wb_rst_i) |=> (!$isunknown(i4_wb_sel_i));
	endproperty
	assert property(af_p1182);

	property af_p1183;
	@(posedge wb_clk_i) (i4_wb_we_i && (i4_wb_sel_i inside {[8:15]})) |=> (i4_wb_sel_i inside {[8:15]});
	endproperty
	assert property(af_p1183);

	property af_p1184;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##[1:2] (!$isunknown(i4_wb_sel_i));
	endproperty
	assert property(af_p1184);

	property af_p1185;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 (i4_wb_sel_i inside {[0:15]});
	endproperty
	assert property(af_p1185);

	property af_p1186;
	@(posedge wb_clk_i) (i4_wb_stb_i) |-> ($stable(i4_wb_sel_i) throughout (i4_wb_stb_i[*0:$] ##1 i4_wb_ack_o));
	endproperty
	assert property(af_p1186);

	property af_p1187;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ((i4_wb_sel_i == 4'b0000) until (i4_wb_stb_i));
	endproperty
	assert property(af_p1187);

	property af_p1188;
	@(posedge wb_clk_i) (i4_wb_stb_i && $past(i4_wb_stb_i)) |-> $stable(i4_wb_sel_i);
	endproperty
	assert property(af_p1188);

	property af_p1189;
	@(posedge wb_clk_i) (i4_wb_cyc_i && $past(i4_wb_cyc_i)) |-> $stable(i4_wb_sel_i);
	endproperty
	assert property(af_p1189);

	property af_p1190;
	@(posedge wb_clk_i) i4_wb_stb_i |-> !$isunknown(i4_wb_sel_i);
	endproperty
	assert property(af_p1190);

	property af_p1191;
	@(posedge wb_clk_i) (i4_wb_stb_i && !i4_wb_ack_o) |-> (i4_wb_stb_i throughout (!i4_wb_ack_o[*0:$] ##1 i4_wb_ack_o));
	endproperty
	assert property(af_p1191);

	property af_p1192;
	@(posedge wb_clk_i) i4_wb_stb_i |-> !$isunknown(i4_wb_adr_i);
	endproperty
	assert property(af_p1192);

	property af_p1193;
	@(posedge wb_clk_i) $rose(i4_wb_stb_i) |-> ($stable(i4_wb_sel_i) throughout (i4_wb_stb_i[*1:$]));
	endproperty
	assert property(af_p1193);

	property af_p1194;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!i4_wb_stb_i ##1 !i4_wb_stb_i);
	endproperty
	assert property(af_p1194);

	property af_p1195;
	@(posedge wb_clk_i) $rose(i4_wb_stb_i) |-> (i4_wb_stb_i throughout (!i4_wb_ack_o[*0:$] ##1 i4_wb_ack_o));
	endproperty
	assert property(af_p1195);

	property af_p1196;
	@(posedge wb_clk_i) i4_wb_stb_i |-> ($stable(i4_wb_we_i) throughout (!i4_wb_ack_o[*0:$] ##1 i4_wb_ack_o));
	endproperty
	assert property(af_p1196);

	property af_p1197;
	@(posedge wb_clk_i) i4_wb_ack_o |=> !i4_wb_stb_i;
	endproperty
	assert property(af_p1197);

	property af_p1198;
	@(posedge wb_clk_i) (i4_wb_stb_i && i4_wb_we_i) |-> (i4_wb_stb_i && i4_wb_we_i);
	endproperty
	assert property(af_p1198);

	property af_p1199;
	@(posedge wb_clk_i) i4_wb_stb_i |-> ##[0:10] (i4_wb_ack_o || i4_wb_err_o);
	endproperty
	assert property(af_p1199);

	property af_p1200;
	@(posedge wb_clk_i) i4_wb_stb_i |-> ##[0:16] (i4_wb_ack_o || i4_wb_err_o);
	endproperty
	assert property(af_p1200);

	property af_p1201;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> !i4_wb_stb_i;
	endproperty
	assert property(af_p1201);

	property af_p1202;
	@(posedge wb_clk_i) wb_rst_i |-> !i4_wb_stb_i;
	endproperty
	assert property(af_p1202);

	property af_p1203;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i4_wb_stb_i ##1 !i4_wb_stb_i);
	endproperty
	assert property(af_p1203);


	property af_p1205;
	@(posedge wb_clk_i) ($fell(i4_wb_stb_i) && i4_wb_cyc_i) |-> ##1 i4_wb_stb_i;
	endproperty
	assert property(af_p1205);

	property af_p1206;
	@(posedge wb_clk_i) i4_wb_stb_i |-> i4_wb_cyc_i;
	endproperty
	assert property(af_p1206);

	property af_p1207;
	@(posedge wb_clk_i) (i4_wb_stb_i && $past(i4_wb_stb_i)) |-> $stable(i4_wb_adr_i);
	endproperty
	assert property(af_p1207);

	property af_p1208;
	@(posedge wb_clk_i) i4_wb_stb_i |-> (i4_wb_stb_i until i4_wb_ack_o);
	endproperty
	assert property(af_p1208);

	property af_p1209;
	@(posedge wb_clk_i) (i4_wb_stb_i && i4_wb_we_i) |-> ($stable(i4_wb_dat_i) until i4_wb_ack_o);
	endproperty
	assert property(af_p1209);

	property af_p1210;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!i4_wb_stb_i)[*2];
	endproperty
	assert property(af_p1210);

	property af_p1211;
	@(posedge wb_clk_i) ((i4_wb_stb_i && i4_wb_cyc_i && !i4_wb_ack_o)[*5]) |=> i4_wb_err_o;
	endproperty
	assert property(af_p1211);

	property af_p1212;
	@(posedge wb_clk_i) i4_wb_stb_i |-> (i4_wb_stb_i until (i4_wb_ack_o || i4_wb_err_o));
	endproperty
	assert property(af_p1212);

	property af_p1213;
	@(posedge wb_clk_i) i4_wb_cyc_i |-> ##[0:1] i4_wb_stb_i;
	endproperty
	assert property(af_p1213);

	property af_p1214;
	@(posedge wb_clk_i) (i4_wb_cyc_i && !(i4_wb_ack_o || i4_wb_err_o)) |=> $stable(i4_wb_we_i);
	endproperty
	assert property(af_p1214);

	property af_p1215;
	@(posedge wb_clk_i) (i4_wb_stb_i) |-> (!$isunknown(i4_wb_we_i));
	endproperty
	assert property(af_p1215);

	property af_p1216;
	@(posedge wb_clk_i) (i4_wb_we_i && i4_wb_ack_o) |=> (i4_wb_we_i == 1'b0);
	endproperty
	assert property(af_p1216);

	property af_p1217;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_stb_i) |-> (!$isunknown(i4_wb_we_i));
	endproperty
	assert property(af_p1217);

	property af_p1218;
	@(posedge wb_clk_i) (i4_wb_we_i && i4_wb_ack_o) |-> (!$isunknown(i4_wb_dat_i));
	endproperty
	assert property(af_p1218);

	property af_p1219;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (!$isunknown(i4_wb_we_i));
	endproperty
	assert property(af_p1219);

	property af_p1220;
	@(posedge wb_clk_i) (!i4_wb_cyc_i) |-> (i4_wb_we_i == 1'b0);
	endproperty
	assert property(af_p1220);

	property af_p1221;
	@(posedge wb_clk_i) (i4_wb_we_i) |-> (i4_wb_cyc_i && i4_wb_stb_i);
	endproperty
	assert property(af_p1221);

	property af_p1222;
	@(posedge wb_clk_i) (i4_wb_we_i && i4_wb_err_o) |=> $stable(i4_wb_dat_o);
	endproperty
	assert property(af_p1222);

	property af_p1223;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (i4_wb_we_i == 1'b0);
	endproperty
	assert property(af_p1223);

	property af_p1224;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i4_wb_we_i == 1'b0);
	endproperty
	assert property(af_p1224);

	property af_p1225;
	@(posedge wb_clk_i) (i4_wb_stb_i && !i4_wb_ack_o) |=> $stable(i4_wb_we_i) throughout (i4_wb_stb_i[->1] ##0 i4_wb_ack_o[->1]);
	endproperty
	assert property(af_p1225);

	property af_p1226;
	@(posedge wb_clk_i) (!i4_wb_we_i && i4_wb_ack_o) |-> ($isunknown(i4_wb_dat_o) === 0);
	endproperty
	assert property(af_p1226);

	property af_p1227;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (!$isunknown(i4_wb_we_i));
	endproperty
	assert property(af_p1227);

	property af_p1228;
	@(posedge wb_clk_i) (!i4_wb_we_i && i4_wb_stb_i) |=> $stable(i4_wb_dat_o);
	endproperty
	assert property(af_p1228);

	property af_p1229;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_stb_i) |=> $stable(i4_wb_we_i);
	endproperty
	assert property(af_p1229);

	property af_p1230;
	@(posedge wb_clk_i) (!i4_wb_stb_i) |=> $stable(i4_wb_we_i);
	endproperty
	assert property(af_p1230);

	property af_p1231;
	@(posedge wb_clk_i) (i4_wb_ack_o) |-> $stable(i4_wb_we_i);
	endproperty
	assert property(af_p1231);

	property af_p1232;
	@(posedge wb_clk_i) (i4_wb_cyc_i && !i4_wb_stb_i) |=> $stable(i4_wb_we_i);
	endproperty
	assert property(af_p1232);

	property af_p1233;
	@(posedge wb_clk_i) (i4_wb_err_o) |-> (!i4_wb_we_i);
	endproperty
	assert property(af_p1233);

	property af_p1234;
	@(posedge wb_clk_i) (i4_wb_cyc_i && i4_wb_stb_i) |-> (i4_wb_we_i === i4_wb_we_i);
	endproperty
	assert property(af_p1234);

	property af_p1235;
	@(posedge wb_clk_i) (i4_wb_we_i) |=> ($past(i4_wb_dat_i) === i4_wb_dat_i);
	endproperty
	assert property(af_p1235);

	property af_p1236;
	@(posedge wb_clk_i) (i4_wb_we_i && i4_wb_stb_i) |-> (i4_wb_ack_o);
	endproperty
	assert property(af_p1236);

	property af_p1237;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!$isunknown(i4_wb_we_i)) ##1 (i4_wb_we_i == 1'b1);
	endproperty
	assert property(af_p1237);

	property af_p1238;
	@(posedge wb_clk_i) (i4_wb_cyc_i) |-> ($stable(i4_wb_we_i));
	endproperty
	assert property(af_p1238);

	property af_p1239;
	@(posedge wb_clk_i) (i4_wb_cyc_i && $past(i4_wb_cyc_i)) |-> ($stable(i4_wb_we_i));
	endproperty
	assert property(af_p1239);

	property af_p1240;
	@(posedge wb_clk_i) (i4_wb_we_i) |-> (i4_wb_sel_i != '0);
	endproperty
	assert property(af_p1240);

	property af_p1241;
	@(posedge wb_clk_i) (i4_wb_we_i && i4_wb_stb_i) |-> (!$isunknown(i4_wb_adr_i));
	endproperty
	assert property(af_p1241);

	property af_p1242;
	@(posedge wb_clk_i) (i4_wb_we_i && i4_wb_stb_i && i4_wb_cyc_i) |-> (i4_wb_dat_i === i4_wb_dat_o);
	endproperty
	assert property(af_p1242);

	property af_p1243;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (i4_wb_we_i == 1'b0) [*2];
	endproperty
	assert property(af_p1243);

	property af_p1244;
	@(posedge wb_clk_i) (i4_wb_stb_i) |-> ($stable(i4_wb_we_i));
	endproperty
	assert property(af_p1244);

	property af_p1245;
	@(posedge wb_clk_i) (i4_wb_stb_i && !i4_wb_we_i) |-> ($isunknown(i4_wb_dat_o) == 0);
	endproperty
	assert property(af_p1245);

	property af_p1246;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 (!$isunknown(i4_wb_we_i));
	endproperty
	assert property(af_p1246);

	property af_p1247;
	@(posedge wb_clk_i) (!i5_wb_cyc_i) |-> (i5_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p1247);

	property af_p1248;
	@(posedge wb_clk_i) (!i5_wb_stb_i) |-> (i5_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p1248);

	property af_p1249;
	@(posedge wb_clk_i) ($rose(i5_wb_stb_i) && !$past(i5_wb_stb_i,1) && i5_wb_ack_o) |=> (i5_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p1249);

	property af_p1250;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i5_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p1250);

	property af_p1251;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i5_wb_ack_o == 1'b0) ##1 (i5_wb_ack_o == 1'b0)[*2];
	endproperty
	assert property(af_p1251);

	property af_p1252;
	@(posedge wb_clk_i) (i5_wb_we_i && i5_wb_cyc_i && i5_wb_stb_i) |-> ##[1:4] (i5_wb_ack_o == 1'b1);
	endproperty
	assert property(af_p1252);

	property af_p1253;
	@(posedge wb_clk_i) (i5_wb_we_i && i5_wb_stb_i && i5_wb_cyc_i) |-> ##1 (i5_wb_ack_o == 1'b1);
	endproperty
	assert property(af_p1253);

	property af_p1254;
	@(posedge wb_clk_i) (i5_wb_ack_o && i5_wb_err_o) |-> 1'b0;
	endproperty
	assert property(af_p1254);

	property af_p1255;
	@(posedge wb_clk_i) (i5_wb_ack_o && !i5_wb_stb_i) |=> (i5_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p1255);

	property af_p1256;
	@(posedge wb_clk_i) (i5_wb_ack_o) |-> ($stable(i5_wb_adr_i));
	endproperty
	assert property(af_p1256);

	property af_p1257;
	@(posedge wb_clk_i) i5_wb_ack_o |-> (i5_wb_cyc_i && i5_wb_stb_i);
	endproperty
	assert property(af_p1257);

	property af_p1258;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i && !i5_wb_we_i) |-> (i5_wb_ack_o && !$isunknown(i5_wb_dat_o));
	endproperty
	assert property(af_p1258);

	property af_p1259;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i5_wb_ack_o ##1 !i5_wb_ack_o);
	endproperty
	assert property(af_p1259);

	property af_p1260;
	@(posedge wb_clk_i) i5_wb_ack_o |-> $stable(i5_wb_adr_i);
	endproperty
	assert property(af_p1260);

	property af_p1261;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i5_wb_cyc_i && i5_wb_stb_i) |-> ##[0:1] i5_wb_ack_o;
	endproperty
	assert property(af_p1261);

	property af_p1262;
	@(posedge wb_clk_i) i5_wb_ack_o |-> !$isunknown(i5_wb_dat_o);
	endproperty
	assert property(af_p1262);

	property af_p1263;
	@(posedge wb_clk_i) !(i5_wb_ack_o && i5_wb_err_o);
	endproperty
	assert property(af_p1263);

	property af_p1264;
	@(posedge wb_clk_i) !i5_wb_cyc_i |-> !i5_wb_ack_o;
	endproperty
	assert property(af_p1264);

	property af_p1265;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i && i5_wb_ack_o) |-> (i5_wb_sel_i != '0);
	endproperty
	assert property(af_p1265);

	property af_p1266;
	@(posedge wb_clk_i) (!i5_wb_stb_i) |-> !i5_wb_ack_o;
	endproperty
	assert property(af_p1266);

	property af_p1267;
	@(posedge wb_clk_i) (i5_wb_stb_i && i5_wb_cyc_i) |=> i5_wb_ack_o;
	endproperty
	assert property(af_p1267);

	property af_p1268;
	@(posedge wb_clk_i) i5_wb_ack_o |=> !i5_wb_ack_o;
	endproperty
	assert property(af_p1268);

	property af_p1269;
	@(posedge wb_clk_i) (i5_wb_ack_o && !i5_wb_stb_i) |=> !i5_wb_ack_o;
	endproperty
	assert property(af_p1269);

	property af_p1270;
	@(posedge wb_clk_i) (!i5_wb_cyc_i) |-> !i5_wb_ack_o;
	endproperty
	assert property(af_p1270);

	property af_p1271;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i5_wb_ack_o)[*3];
	endproperty
	assert property(af_p1271);

	property af_p1272;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i) |-> !i5_wb_ack_o;
	endproperty
	assert property(af_p1272);

	property af_p1273;
	@(posedge wb_clk_i) i5_wb_stb_i |=> (i5_wb_ack_o ##1 !i5_wb_ack_o);
	endproperty
	assert property(af_p1273);

	property af_p1274;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i5_wb_ack_o;
	endproperty
	assert property(af_p1274);

	property af_p1275;
	@(posedge wb_clk_i) (!wb_rst_i && i5_wb_we_i && i5_wb_stb_i && i5_wb_cyc_i) |=> i5_wb_ack_o;
	endproperty
	assert property(af_p1275);

	property af_p1276;
	@(posedge wb_clk_i) (!wb_rst_i) |-> !$isunknown(i5_wb_ack_o);
	endproperty
	assert property(af_p1276);

	property af_p1277;
	@(posedge wb_clk_i) ((i5_wb_adr_i >= 100) && (i5_wb_adr_i <= 200) && i5_wb_stb_i) |=> ((i5_wb_adr_i >= 100) && (i5_wb_adr_i <= 200)) throughout (i5_wb_ack_o[->1]);
	endproperty
	assert property(af_p1277);

	property af_p1278;
	@(posedge wb_clk_i) $rose(i5_wb_err_o) |=> (i5_wb_adr_i != $past(i5_wb_adr_i));
	endproperty
	assert property(af_p1278);

	property af_p1279;
	@(posedge wb_clk_i) $stable(i5_wb_adr_i) or (i5_wb_cyc_i && i5_wb_stb_i);
	endproperty
	assert property(af_p1279);

	property af_p1280;
	@(posedge wb_clk_i) ((i5_wb_adr_i >= 512) && (i5_wb_adr_i <= 1023)) |-> ((i5_wb_adr_i >= 256) && (i5_wb_adr_i <= 1023)) throughout (i5_wb_ack_o[->1]);
	endproperty
	assert property(af_p1280);

	property af_p1281;
	@(posedge wb_clk_i) (i5_wb_cyc_i && !i5_wb_ack_o && !$stable(i5_wb_adr_i)) |-> 0;
	endproperty
	assert property(af_p1281);

	property af_p1282;
	@(posedge wb_clk_i) ((i5_wb_adr_i >= 0) && (i5_wb_adr_i <= 1023) && i5_wb_cyc_i) |-> ($stable(i5_wb_adr_i) throughout (i5_wb_cyc_i[*1:$] ##0 i5_wb_ack_o));
	endproperty
	assert property(af_p1282);

	property af_p1283;
	@(posedge wb_clk_i) ((i5_wb_adr_i >= 0) && (i5_wb_adr_i <= 4095)) |=> ((i5_wb_adr_i >= 0) && (i5_wb_adr_i <= 4095));
	endproperty
	assert property(af_p1283);

	property af_p1284;
	@(posedge wb_clk_i) (i5_wb_we_i && i5_wb_stb_i) |-> ((i5_wb_adr_i >= 0) && (i5_wb_adr_i <= 4095));
	endproperty
	assert property(af_p1284);

	property af_p1285;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> ((i5_wb_stb_i && i5_wb_cyc_i) |-> $stable(i5_wb_adr_i));
	endproperty
	assert property(af_p1285);

	property af_p1286;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i) |-> $stable(i5_wb_adr_i);
	endproperty
	assert property(af_p1286);

	property af_p1287;
	@(posedge wb_clk_i) (i5_wb_stb_i && i5_wb_cyc_i) |-> ($stable(i5_wb_adr_i) throughout (i5_wb_ack_o[->1]));
	endproperty
	assert property(af_p1287);

	property af_p1288;
	@(posedge wb_clk_i) !i5_wb_cyc_i |-> $stable(i5_wb_adr_i);
	endproperty
	assert property(af_p1288);

	property af_p1289;
	@(posedge wb_clk_i) i5_wb_we_i |-> ($stable(i5_wb_adr_i) throughout (i5_wb_ack_o[->1]));
	endproperty
	assert property(af_p1289);

	property af_p1290;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i5_wb_adr_i == '0);
	endproperty
	assert property(af_p1290);

	property af_p1291;
	@(posedge wb_clk_i) i5_wb_cyc_i |-> $stable(i5_wb_adr_i);
	endproperty
	assert property(af_p1291);

	property af_p1292;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (i5_wb_adr_i inside {[0:4095]});
	endproperty
	assert property(af_p1292);

	property af_p1293;
	@(posedge wb_clk_i) (i5_wb_stb_i && $past(i5_wb_stb_i)) |-> $stable(i5_wb_adr_i);
	endproperty
	assert property(af_p1293);

	property af_p1294;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (i5_wb_cyc_i -> ($stable(i5_wb_adr_i) && (i5_wb_adr_i != '0)));
	endproperty
	assert property(af_p1294);

	property af_p1295;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (i5_wb_adr_i == '0);
	endproperty
	assert property(af_p1295);

	property af_p1296;
	@(posedge wb_clk_i) (&i5_wb_sel_i) |-> ((i5_wb_adr_i >= 0) && (i5_wb_adr_i <= 1023))[*2];
	endproperty
	assert property(af_p1296);

	property af_p1297;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_we_i) |-> (i5_wb_adr_i >= 0) && (i5_wb_adr_i <= 8191);
	endproperty
	assert property(af_p1297);

	property af_p1298;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (i5_wb_adr_i == 0);
	endproperty
	assert property(af_p1298);

	property af_p1299;
	@(posedge wb_clk_i) $rose(i5_wb_ack_o) |-> ##1 !i5_wb_stb_i;
	endproperty
	assert property(af_p1299);

	property af_p1300;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i5_wb_cyc_i throughout (##1 i5_wb_cyc_i[->1]);
	endproperty
	assert property(af_p1300);

	property af_p1301;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((i5_wb_adr_i >= 0) && (i5_wb_adr_i <= 65535));
	endproperty
	assert property(af_p1301);

	property af_p1302;
	@(posedge wb_clk_i) (i5_wb_sel_i && i5_wb_cyc_i) |-> $stable(i5_wb_adr_i);
	endproperty
	assert property(af_p1302);

	property af_p1303;
	@(posedge wb_clk_i) (i5_wb_stb_i) |-> (i5_wb_adr_i >= 0) && (i5_wb_adr_i <= 2047);
	endproperty
	assert property(af_p1303);

	property af_p1304;
	@(posedge wb_clk_i) i5_wb_stb_i |-> i5_wb_cyc_i ##1 i5_wb_cyc_i;
	endproperty
	assert property(af_p1304);

	property af_p1305;
	@(posedge wb_clk_i) !i5_wb_cyc_i |-> !i5_wb_stb_i;
	endproperty
	assert property(af_p1305);

	property af_p1306;
	@(posedge wb_clk_i) i5_wb_cyc_i |-> !$isunknown(i5_wb_sel_i);
	endproperty
	assert property(af_p1306);

	property af_p1307;
	@(posedge wb_clk_i) $rose(i5_wb_cyc_i) |-> ##1 i5_wb_cyc_i;
	endproperty
	assert property(af_p1307);

	property af_p1308;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i5_wb_cyc_i;
	endproperty
	assert property(af_p1308);

	property af_p1309;
	@(posedge wb_clk_i) i5_wb_cyc_i |-> $stable(i5_wb_we_i);
	endproperty
	assert property(af_p1309);

	property af_p1310;
	@(posedge wb_clk_i) wb_rst_i |-> !i5_wb_cyc_i;
	endproperty
	assert property(af_p1310);

	property af_p1311;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i) |-> $stable(i5_wb_we_i);
	endproperty
	assert property(af_p1311);

	property af_p1312;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i5_wb_cyc_i[*2] ##1 $rose(i5_wb_cyc_i));
	endproperty
	assert property(af_p1312);

	property af_p1313;
	@(posedge wb_clk_i) i5_wb_cyc_i |-> (i5_wb_cyc_i until_with i5_wb_ack_o);
	endproperty
	assert property(af_p1313);

	property af_p1314;
	@(posedge wb_clk_i) $rose(i5_wb_cyc_i) |-> (i5_wb_cyc_i throughout (i5_wb_ack_o[->1]));
	endproperty
	assert property(af_p1314);

	property af_p1315;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i) |-> ##[1:16] i5_wb_ack_o;
	endproperty
	assert property(af_p1315);

	property af_p1316;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!i5_wb_cyc_i) [*2];
	endproperty
	assert property(af_p1316);

	property af_p1317;
	@(posedge wb_clk_i) (!i5_wb_cyc_i) |-> (!i5_wb_err_o);
	endproperty
	assert property(af_p1317);

	property af_p1318;
	@(posedge wb_clk_i) $rose(i5_wb_cyc_i) |=> (i5_wb_cyc_i throughout (i5_wb_ack_o[->1]));
	endproperty
	assert property(af_p1318);

	property af_p1319;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_err_o) |=> !i5_wb_cyc_i;
	endproperty
	assert property(af_p1319);

	property af_p1320;
	@(posedge wb_clk_i) (i5_wb_cyc_i && !i5_wb_ack_o) |-> $stable(i5_wb_adr_i);
	endproperty
	assert property(af_p1320);

	property af_p1321;
	@(posedge wb_clk_i) $rose(i5_wb_ack_o) |=> !i5_wb_cyc_i;
	endproperty
	assert property(af_p1321);

	property af_p1322;
	@(posedge wb_clk_i) (!i5_wb_cyc_i) |-> (!i5_wb_stb_i);
	endproperty
	assert property(af_p1322);

	property af_p1323;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_we_i) |-> ($stable(i5_wb_dat_i) throughout (i5_wb_ack_o[->1]));
	endproperty
	assert property(af_p1323);

	property af_p1324;
	@(posedge wb_clk_i) (i5_wb_cyc_i !== $past(i5_wb_cyc_i)) |-> ##1 $stable(i5_wb_cyc_i);
	endproperty
	assert property(af_p1324);

	property af_p1325;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i) |=> ($stable(i5_wb_adr_i) until_with i5_wb_ack_o);
	endproperty
	assert property(af_p1325);

	property af_p1326;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> !i5_wb_cyc_i[*2];
	endproperty
	assert property(af_p1326);

	property af_p1327;
	@(posedge wb_clk_i) i5_wb_ack_o |-> ##[1:4] !i5_wb_cyc_i;
	endproperty
	assert property(af_p1327);

	property af_p1328;
	@(posedge wb_clk_i) $rose(i5_wb_cyc_i) |-> (!i5_wb_ack_o) until i5_wb_ack_o;
	endproperty
	assert property(af_p1328);

	property af_p1329;
	@(posedge wb_clk_i) i5_wb_stb_i |-> i5_wb_cyc_i;
	endproperty
	assert property(af_p1329);

	property af_p1330;
	@(posedge wb_clk_i) i5_wb_cyc_i |-> ($stable(i5_wb_adr_i) until_with i5_wb_ack_o);
	endproperty
	assert property(af_p1330);

	property af_p1331;
	@(posedge wb_clk_i) i5_wb_err_o |=> !i5_wb_cyc_i;
	endproperty
	assert property(af_p1331);

	property af_p1332;
	@(posedge wb_clk_i) wb_rst_i |=> !i5_wb_cyc_i;
	endproperty
	assert property(af_p1332);

	property af_p1333;
	@(posedge wb_clk_i) $rose(~wb_rst_i) |-> ##3 ((i5_wb_dat_i >= 50) && (i5_wb_dat_i <= 200));
	endproperty
	assert property(af_p1333);

	property af_p1334;
	@(posedge wb_clk_i) (!i5_wb_we_i) |-> ((i5_wb_dat_i >= 0) && (i5_wb_dat_i <= 255));
	endproperty
	assert property(af_p1334);

	property af_p1335;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((i5_wb_dat_i >= 0) && (i5_wb_dat_i <= 255));
	endproperty
	assert property(af_p1335);

	property af_p1336;
	@(posedge wb_clk_i) (!i5_wb_cyc_i) |-> ($stable(i5_wb_dat_i));
	endproperty
	assert property(af_p1336);

	property af_p1337;
	@(posedge wb_clk_i) (!i5_wb_err_o) |-> ((i5_wb_dat_i >= 0) && (i5_wb_dat_i <= 255));
	endproperty
	assert property(af_p1337);

	property af_p1338;
	@(posedge wb_clk_i) (!i5_wb_stb_i) |-> ($stable(i5_wb_dat_i));
	endproperty
	assert property(af_p1338);

	property af_p1339;
	@(posedge wb_clk_i) ((i5_wb_dat_i >= 0) && (i5_wb_dat_i <= 127)) |=> (i5_wb_dat_i >= 0) && (i5_wb_dat_i <= 255);
	endproperty
	assert property(af_p1339);

	property af_p1340;
	@(posedge wb_clk_i) $rose(~wb_rst_i) |-> ##4 ((i5_wb_dat_i >= 0) && (i5_wb_dat_i <= 64));
	endproperty
	assert property(af_p1340);

	property af_p1341;
	@(posedge wb_clk_i) $rose(~wb_rst_i) |-> ##3 ((i5_wb_dat_i >= 0) && (i5_wb_dat_i <= 255));
	endproperty
	assert property(af_p1341);

	property af_p1342;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i) || (!(i5_wb_cyc_i && i5_wb_stb_i) && 1'b1);
	endproperty
	assert property(af_p1342);

	property af_p1343;
	@(posedge wb_clk_i) ($rose(i5_wb_cyc_i)) |-> ((i5_wb_dat_i >= 0) && (i5_wb_dat_i <= 255)) [*2];
	endproperty
	assert property(af_p1343);

	property af_p1344;
	@(posedge wb_clk_i) ((i5_wb_dat_i >= 200) && (i5_wb_dat_i <= 255)) |=> (i5_wb_dat_i >= 180) && (i5_wb_dat_i <= 255);
	endproperty
	assert property(af_p1344);

	property af_p1345;
	@(posedge wb_clk_i) (i5_wb_stb_i && i5_wb_cyc_i) |-> $stable(i5_wb_dat_i);
	endproperty
	assert property(af_p1345);

	property af_p1346;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i5_wb_dat_i >= 0) && (i5_wb_dat_i <= 10);
	endproperty
	assert property(af_p1346);

	property af_p1347;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ##4 (i5_wb_dat_i >= 0) && (i5_wb_dat_i <= 60);
	endproperty
	assert property(af_p1347);

	property af_p1348;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ##4 (i5_wb_dat_i >= 0) && (i5_wb_dat_i <= 255);
	endproperty
	assert property(af_p1348);

	property af_p1349;
	@(posedge wb_clk_i) (i5_wb_we_i) |-> ((i5_wb_sel_i != '0) && $isunknown(i5_wb_dat_i) == 0);
	endproperty
	assert property(af_p1349);

	property af_p1350;
	@(posedge wb_clk_i) ((i5_wb_dat_i >= 100) && (i5_wb_dat_i <= 150)) |=> (i5_wb_dat_i >= 80) && (i5_wb_dat_i <= 150);
	endproperty
	assert property(af_p1350);

	property af_p1351;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (i5_wb_dat_i >= 0) && (i5_wb_dat_i <= 255);
	endproperty
	assert property(af_p1351);

	property af_p1352;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##[1:2] $isunknown(i5_wb_dat_i) == 0;
	endproperty
	assert property(af_p1352);

	property af_p1353;
	@(posedge wb_clk_i) (!i5_wb_we_i && i5_wb_ack_o) |-> (!$isunknown(i5_wb_dat_i));
	endproperty
	assert property(af_p1353);

	property af_p1354;
	@(posedge wb_clk_i) ((i5_wb_dat_i >= 64) && (i5_wb_dat_i <= 191)) |=> (i5_wb_dat_i >= 32) && (i5_wb_dat_i <= 223);
	endproperty
	assert property(af_p1354);

	property af_p1355;
	@(posedge wb_clk_i) (i5_wb_we_i && i5_wb_ack_o) |-> ((i5_wb_dat_i >= 0) && (i5_wb_dat_i <= 255));
	endproperty
	assert property(af_p1355);

	property af_p1356;
	@(posedge wb_clk_i) ((i5_wb_dat_i >= 1) && (i5_wb_dat_i <= 25)) |=> (i5_wb_stb_i -> ((i5_wb_dat_i >= 1) && (i5_wb_dat_i <= 50)));
	endproperty
	assert property(af_p1356);

	property af_p1357;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i) |-> ($stable(i5_wb_dat_i) && !$isunknown(i5_wb_dat_i));
	endproperty
	assert property(af_p1357);

	property af_p1358;
	@(posedge wb_clk_i) (i5_wb_stb_i && !i5_wb_ack_o) |-> $stable(i5_wb_dat_i);
	endproperty
	assert property(af_p1358);

	property af_p1359;
	@(posedge wb_clk_i) (wb_rst_i) |-> ((i5_wb_dat_i == 0) && $stable(i5_wb_dat_i));
	endproperty
	assert property(af_p1359);

	property af_p1360;
	@(posedge wb_clk_i) ($past(!wb_rst_i,3)) |-> ((i5_wb_dat_i >= 50) && (i5_wb_dat_i <= 120));
	endproperty
	assert property(af_p1360);

	property af_p1361;
	@(posedge wb_clk_i) (i5_wb_ack_o) |-> ((i5_wb_dat_i >= 120) && (i5_wb_dat_i <= 255));
	endproperty
	assert property(af_p1361);

	property af_p1362;
	@(posedge wb_clk_i) $rose(i5_wb_stb_i) |=> !$isunknown(i5_wb_dat_o);
	endproperty
	assert property(af_p1362);

	property af_p1363;
	@(posedge wb_clk_i) (!i5_wb_ack_o) |-> $stable(i5_wb_dat_o);
	endproperty
	assert property(af_p1363);

	property af_p1364;
	@(posedge wb_clk_i) (((i5_wb_dat_o >= 100) && (i5_wb_dat_o <= 200))) |-> (i5_wb_stb_i |=> ((i5_wb_dat_o >= 80) && (i5_wb_dat_o <= 220)));
	endproperty
	assert property(af_p1364);

	property af_p1365;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i && i5_wb_ack_o) |-> $stable(i5_wb_dat_o);
	endproperty
	assert property(af_p1365);

	property af_p1366;
	@(posedge wb_clk_i) !(i5_wb_cyc_i && i5_wb_stb_i) |-> $stable(i5_wb_dat_o);
	endproperty
	assert property(af_p1366);

	property af_p1367;
	@(posedge wb_clk_i) (!i5_wb_cyc_i) |-> $stable(i5_wb_dat_o);
	endproperty
	assert property(af_p1367);

	property af_p1368;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((i5_wb_dat_o >= 0) && (i5_wb_dat_o <= 255));
	endproperty
	assert property(af_p1368);

	property af_p1369;
	@(posedge wb_clk_i) (i5_wb_ack_o && i5_wb_stb_i && i5_wb_cyc_i) |-> $stable(i5_wb_dat_o);
	endproperty
	assert property(af_p1369);

	property af_p1370;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 ((i5_wb_dat_o >= 0) && (i5_wb_dat_o <= 255));
	endproperty
	assert property(af_p1370);

	property af_p1371;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i5_wb_dat_o == 0) ##1 (i5_wb_dat_o == 0);
	endproperty
	assert property(af_p1371);

	property af_p1372;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> (i5_wb_dat_o == 0);
	endproperty
	assert property(af_p1372);

	property af_p1373;
	@(posedge wb_clk_i) (i5_wb_ack_o && i5_wb_stb_i) |-> (!$isunknown(i5_wb_dat_o));
	endproperty
	assert property(af_p1373);

	property af_p1374;
	@(posedge wb_clk_i) (i5_wb_stb_i && i5_wb_cyc_i && !i5_wb_we_i) |-> (!$isunknown(i5_wb_dat_o));
	endproperty
	assert property(af_p1374);

	property af_p1375;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ($stable(i5_wb_dat_o) [*3]);
	endproperty
	assert property(af_p1375);

	property af_p1376;
	@(posedge wb_clk_i) (i5_wb_ack_o) |-> ##[0:1] ((i5_wb_dat_o >= 0) && (i5_wb_dat_o <= 255));
	endproperty
	assert property(af_p1376);

	property af_p1377;
	@(posedge wb_clk_i) ((i5_wb_dat_o >= 100) && (i5_wb_dat_o <= 150) && i5_wb_ack_o) |=> (i5_wb_ack_o -> ((i5_wb_dat_o >= 80) && (i5_wb_dat_o <= 170)));
	endproperty
	assert property(af_p1377);

	property af_p1378;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i5_wb_dat_o == 0);
	endproperty
	assert property(af_p1378);

	property af_p1379;
	@(posedge wb_clk_i) (i5_wb_cyc_i && !i5_wb_err_o) |-> ((i5_wb_dat_o >= 0) && (i5_wb_dat_o <= 255));
	endproperty
	assert property(af_p1379);


	property af_p1381;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i && !i5_wb_we_i) |=> !$isunknown(i5_wb_dat_o);
	endproperty
	assert property(af_p1381);

	property af_p1382;
	@(posedge wb_clk_i) (!i5_wb_we_i && i5_wb_stb_i) |=> ((i5_wb_dat_o >= 0) && (i5_wb_dat_o <= 255));
	endproperty
	assert property(af_p1382);

	property af_p1383;
	@(posedge wb_clk_i) ((i5_wb_dat_o >= 100) && (i5_wb_dat_o <= 150)) |=> ((i5_wb_dat_o >= 80) && (i5_wb_dat_o <= 150));
	endproperty
	assert property(af_p1383);


	property af_p1385;
	@(posedge wb_clk_i) (i5_wb_ack_o) |-> (!$isunknown(i5_wb_dat_o));
	endproperty
	assert property(af_p1385);

	property af_p1386;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 !$isunknown(i5_wb_dat_o);
	endproperty
	assert property(af_p1386);

	property af_p1387;
	@(posedge wb_clk_i) (i5_wb_cyc_i && (i5_wb_dat_o >= 50) && (i5_wb_dat_o <= 75)) |=> (i5_wb_cyc_i |-> ((i5_wb_dat_o >= 30) && (i5_wb_dat_o <= 95)));
	endproperty
	assert property(af_p1387);

	property af_p1388;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ((i5_wb_dat_o >= 0) && (i5_wb_dat_o <= 255))[*3];
	endproperty
	assert property(af_p1388);

	property af_p1389;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i && !i5_wb_we_i) |-> !$isunknown(i5_wb_dat_o);
	endproperty
	assert property(af_p1389);

	property af_p1390;
	@(posedge wb_clk_i) !(i5_wb_cyc_i && i5_wb_stb_i) |-> !i5_wb_err_o;
	endproperty
	assert property(af_p1390);


	property af_p1392;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##[1:2] !i5_wb_err_o;
	endproperty
	assert property(af_p1392);

	property af_p1393;
	@(posedge wb_clk_i) !i5_wb_cyc_i |-> !i5_wb_err_o;
	endproperty
	assert property(af_p1393);

	property af_p1394;
	@(posedge wb_clk_i) (!i5_wb_we_i && i5_wb_cyc_i && i5_wb_stb_i) |-> !i5_wb_err_o;
	endproperty
	assert property(af_p1394);

	property af_p1395;
	@(posedge wb_clk_i) !i5_wb_stb_i |-> !i5_wb_err_o;
	endproperty
	assert property(af_p1395);


	property af_p1397;
	@(posedge wb_clk_i) $rose(i5_wb_err_o) |-> (i5_wb_cyc_i && i5_wb_stb_i);
	endproperty
	assert property(af_p1397);


	property af_p1399;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i5_wb_err_o)[*3];
	endproperty
	assert property(af_p1399);

	property af_p1400;
	@(posedge wb_clk_i) i5_wb_err_o |-> ((i5_wb_stb_i || $past(i5_wb_stb_i)) && (i5_wb_cyc_i || $past(i5_wb_cyc_i)));
	endproperty
	assert property(af_p1400);

	property af_p1401;
	@(posedge wb_clk_i) $fell(i5_wb_cyc_i) |=> !i5_wb_err_o;
	endproperty
	assert property(af_p1401);

	property af_p1402;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i5_wb_err_o == 1'b0)[*3];
	endproperty
	assert property(af_p1402);


	property af_p1404;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i5_wb_cyc_i && !i5_wb_err_o)[*5];
	endproperty
	assert property(af_p1404);

	property af_p1405;
	@(posedge wb_clk_i) wb_rst_i |-> (i5_wb_err_o == 1'b0);
	endproperty
	assert property(af_p1405);

	property af_p1406;
	@(posedge wb_clk_i) wb_rst_i |-> !i5_wb_err_o;
	endproperty
	assert property(af_p1406);

	property af_p1407;
	@(posedge wb_clk_i) i5_wb_err_o |-> (i5_wb_dat_o == $past(i5_wb_dat_o));
	endproperty
	assert property(af_p1407);

	property af_p1408;
	@(posedge wb_clk_i) i5_wb_err_o |=> !i5_wb_err_o;
	endproperty
	assert property(af_p1408);

	property af_p1409;
	@(posedge wb_clk_i) !(i5_wb_err_o && i5_wb_ack_o);
	endproperty
	assert property(af_p1409);

	property af_p1410;
	@(posedge wb_clk_i) (!i5_wb_cyc_i) |-> (!i5_wb_err_o);
	endproperty
	assert property(af_p1410);

	property af_p1411;
	@(posedge wb_clk_i) (i5_wb_err_o) |-> (!i5_wb_ack_o);
	endproperty
	assert property(af_p1411);

	property af_p1412;
	@(posedge wb_clk_i) (i5_wb_err_o) |-> (i5_wb_cyc_i && i5_wb_stb_i);
	endproperty
	assert property(af_p1412);

	property af_p1413;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i && ((i5_wb_we_i == 1'b0) || (i5_wb_we_i == 1'b1)) && (i5_wb_adr_i inside {[32'h0000_0000:32'hFFFF_FFFF]})) |-> (i5_wb_err_o == 1'b0);
	endproperty
	assert property(af_p1413);

	property af_p1414;
	@(posedge wb_clk_i) ((i5_wb_sel_i != 4'b0000) && (i5_wb_adr_i inside {[32'h0000_0000:32'hFFFF_FFFF]})) |-> (i5_wb_err_o == 1'b0);
	endproperty
	assert property(af_p1414);

	property af_p1415;
	@(posedge wb_clk_i) (i5_wb_adr_i inside {[32'h0000_0000:32'hFFFF_FFFF]}) |-> (i5_wb_err_o == 1'b0);
	endproperty
	assert property(af_p1415);

	property af_p1416;
	@(posedge wb_clk_i) (!i5_wb_cyc_i) |-> (i5_wb_err_o == 1'b0);
	endproperty
	assert property(af_p1416);

	property af_p1417;
	@(posedge wb_clk_i) (i5_wb_err_o) |=> ($fell(i5_wb_err_o) || i5_wb_err_o);
	endproperty
	assert property(af_p1417);

	property af_p1418;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((i5_wb_sel_i >= 0) && (i5_wb_sel_i <= 15));
	endproperty
	assert property(af_p1418);

	property af_p1419;
	@(posedge wb_clk_i) $changed(i5_wb_sel_i) |-> !i5_wb_cyc_i;
	endproperty
	assert property(af_p1419);

	property af_p1420;
	@(posedge wb_clk_i) ((i5_wb_sel_i >= 8) && (i5_wb_sel_i <= 15)) |=> ((i5_wb_sel_i >= 4) && (i5_wb_sel_i <= 15));
	endproperty
	assert property(af_p1420);

	property af_p1421;
	@(posedge wb_clk_i) i5_wb_cyc_i |-> $stable(i5_wb_sel_i);
	endproperty
	assert property(af_p1421);

	property af_p1422;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !$isunknown(i5_wb_sel_i);
	endproperty
	assert property(af_p1422);

	property af_p1423;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i) |-> (i5_wb_sel_i != 4'b0000);
	endproperty
	assert property(af_p1423);

	property af_p1424;
	@(posedge wb_clk_i) (i5_wb_cyc_i && (i5_wb_sel_i >= 1) && (i5_wb_sel_i <= 15)) |=> (i5_wb_cyc_i |-> ((i5_wb_sel_i >= 1) && (i5_wb_sel_i <= 15)));
	endproperty
	assert property(af_p1424);

	property af_p1425;
	@(posedge wb_clk_i) $rose(i5_wb_cyc_i) |-> ($stable(i5_wb_sel_i) throughout i5_wb_cyc_i[*1:$]);
	endproperty
	assert property(af_p1425);

	property af_p1426;
	@(posedge wb_clk_i) wb_rst_i |-> (i5_wb_sel_i == 4'b0000);
	endproperty
	assert property(af_p1426);

	property af_p1427;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i) |-> ($stable(i5_wb_sel_i) until_with i5_wb_ack_o);
	endproperty
	assert property(af_p1427);

	property af_p1428;
	@(posedge wb_clk_i) ($past(!wb_rst_i,4) && !wb_rst_i) |-> (i5_wb_sel_i >= 0 && i5_wb_sel_i <= 15);
	endproperty
	assert property(af_p1428);

	property af_p1429;
	@(posedge wb_clk_i) (i5_wb_err_o) |=> (i5_wb_sel_i != $past(i5_wb_sel_i));
	endproperty
	assert property(af_p1429);

	property af_p1430;
	@(posedge wb_clk_i) (!i5_wb_stb_i) |-> 1'b1;
	endproperty
	assert property(af_p1430);

	property af_p1431;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (i5_wb_sel_i >= 0 && i5_wb_sel_i <= 15);
	endproperty
	assert property(af_p1431);

	property af_p1432;
	@(posedge wb_clk_i) (i5_wb_sel_i >= 0 && i5_wb_sel_i <= 15);
	endproperty
	assert property(af_p1432);

	property af_p1433;
	@(posedge wb_clk_i) (i5_wb_we_i && i5_wb_stb_i && i5_wb_cyc_i) |-> (i5_wb_sel_i != 4'b0000);
	endproperty
	assert property(af_p1433);

	property af_p1434;
	@(posedge wb_clk_i) (i5_wb_we_i && i5_wb_cyc_i) |-> (i5_wb_sel_i >= 1 && i5_wb_sel_i <= 15);
	endproperty
	assert property(af_p1434);

	property af_p1435;
	@(posedge wb_clk_i) (i5_wb_stb_i && i5_wb_cyc_i && !i5_wb_ack_o) |=> $stable(i5_wb_sel_i);
	endproperty
	assert property(af_p1435);

	property af_p1436;
	@(posedge wb_clk_i) (i5_wb_cyc_i && $past(i5_wb_cyc_i)) |-> $stable(i5_wb_sel_i);
	endproperty
	assert property(af_p1436);

	property af_p1437;
	@(posedge wb_clk_i) (i5_wb_we_i && i5_wb_stb_i) |-> (i5_wb_sel_i != 4'b0000);
	endproperty
	assert property(af_p1437);

	property af_p1438;
	@(posedge wb_clk_i) (wb_rst_i) |-> !$isunknown(i5_wb_sel_i);
	endproperty
	assert property(af_p1438);

	property af_p1439;
	@(posedge wb_clk_i) ($rose(i5_wb_stb_i)) |-> ##[1:$] (i5_wb_ack_o && $stable(i5_wb_sel_i));
	endproperty
	assert property(af_p1439);

	property af_p1440;
	@(posedge wb_clk_i) (i5_wb_stb_i) |-> (i5_wb_sel_i != '0);
	endproperty
	assert property(af_p1440);

	property af_p1441;
	@(posedge wb_clk_i) (i5_wb_stb_i && !i5_wb_ack_o) |=> $stable(i5_wb_sel_i);
	endproperty
	assert property(af_p1441);

	property af_p1442;
	@(posedge wb_clk_i) (i5_wb_sel_i >= 1 && i5_wb_sel_i <= 7) |=> (i5_wb_sel_i >= 0 && i5_wb_sel_i <= 7);
	endproperty
	assert property(af_p1442);

	property af_p1443;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (i5_wb_sel_i == '0);
	endproperty
	assert property(af_p1443);

	property af_p1444;
	@(posedge wb_clk_i) (i5_wb_cyc_i && !wb_rst_i) |-> (i5_wb_sel_i != '0);
	endproperty
	assert property(af_p1444);

	property af_p1445;
	@(posedge wb_clk_i) ($rose(i5_wb_ack_o)) |=> $stable(i5_wb_sel_i);
	endproperty
	assert property(af_p1445);

	property af_p1446;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (i5_wb_sel_i == '0);
	endproperty
	assert property(af_p1446);

	property af_p1447;
	@(posedge wb_clk_i) (i5_wb_ack_o) |-> $stable(i5_wb_sel_i);
	endproperty
	assert property(af_p1447);

	property af_p1448;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> !i5_wb_stb_i;
	endproperty
	assert property(af_p1448);

	property af_p1449;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (i5_wb_stb_i || !i5_wb_stb_i);
	endproperty
	assert property(af_p1449);

	property af_p1450;
	@(posedge wb_clk_i) (i5_wb_stb_i && i5_wb_ack_o) |=> ##1 (!i5_wb_stb_i || i5_wb_stb_i);
	endproperty
	assert property(af_p1450);

	property af_p1451;
	@(posedge wb_clk_i) (i5_wb_stb_i && i5_wb_we_i) |-> $stable(i5_wb_dat_i);
	endproperty
	assert property(af_p1451);

	property af_p1452;
	@(posedge wb_clk_i) $rose(i5_wb_ack_o) |=> !i5_wb_stb_i;
	endproperty
	assert property(af_p1452);

	property af_p1453;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i5_wb_stb_i ##1 !i5_wb_stb_i);
	endproperty
	assert property(af_p1453);

	property af_p1454;
	@(posedge wb_clk_i) (i5_wb_stb_i && !i5_wb_ack_o) |=> (i5_wb_stb_i throughout (i5_wb_ack_o[->1]));
	endproperty
	assert property(af_p1454);

	property af_p1455;
	@(posedge wb_clk_i) $rose(i5_wb_stb_i) |-> !wb_rst_i;
	endproperty
	assert property(af_p1455);

	property af_p1456;
	@(posedge wb_clk_i) (i5_wb_stb_i) |-> ($stable(i5_wb_we_i)) throughout (i5_wb_stb_i[*1:$]);
	endproperty
	assert property(af_p1456);

	property af_p1457;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!i5_wb_stb_i)[*2];
	endproperty
	assert property(af_p1457);

	property af_p1458;
	@(posedge wb_clk_i) (i5_wb_stb_i) |-> (i5_wb_cyc_i);
	endproperty
	assert property(af_p1458);

	property af_p1459;
	@(posedge wb_clk_i) (i5_wb_stb_i && i5_wb_we_i) |-> ($stable(i5_wb_adr_i) && $stable(i5_wb_dat_i)) throughout (i5_wb_ack_o[->1]);
	endproperty
	assert property(af_p1459);

	property af_p1460;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!i5_wb_stb_i);
	endproperty
	assert property(af_p1460);

	property af_p1461;
	@(posedge wb_clk_i) (i5_wb_stb_i && !i5_wb_ack_o && !i5_wb_err_o) |=> (i5_wb_stb_i);
	endproperty
	assert property(af_p1461);

	property af_p1462;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i5_wb_stb_i == 1'b0);
	endproperty
	assert property(af_p1462);

	property af_p1463;
	@(posedge wb_clk_i) (i5_wb_stb_i) |-> $stable(i5_wb_sel_i);
	endproperty
	assert property(af_p1463);

	property af_p1464;
	@(posedge wb_clk_i) ($rose(i5_wb_stb_i)) |-> (i5_wb_cyc_i);
	endproperty
	assert property(af_p1464);

	property af_p1465;
	@(posedge wb_clk_i) (wb_rst_i) |-> !(i5_wb_stb_i);
	endproperty
	assert property(af_p1465);

	property af_p1466;
	@(posedge wb_clk_i) $stable(i5_wb_stb_i) until_with $changed(wb_clk_i);
	endproperty
	assert property(af_p1466);

	property af_p1467;
	@(posedge wb_clk_i) (i5_wb_stb_i) |-> $stable(i5_wb_adr_i);
	endproperty
	assert property(af_p1467);

	property af_p1468;
	@(posedge wb_clk_i) (wb_rst_i) |-> !i5_wb_we_i;
	endproperty
	assert property(af_p1468);

	property af_p1469;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !$isunknown(i5_wb_we_i);
	endproperty
	assert property(af_p1469);

	property af_p1470;
	@(posedge wb_clk_i) $changed(i5_wb_we_i) |-> i5_wb_stb_i;
	endproperty
	assert property(af_p1470);

	property af_p1471;
	@(posedge wb_clk_i) (!i5_wb_we_i && i5_wb_cyc_i && i5_wb_stb_i) |-> !i5_wb_err_o;
	endproperty
	assert property(af_p1471);

	property af_p1472;
	@(posedge wb_clk_i) (i5_wb_we_i && !i5_wb_cyc_i) |-> !i5_wb_ack_o;
	endproperty
	assert property(af_p1472);

	property af_p1473;
	@(posedge wb_clk_i) (!i5_wb_we_i && i5_wb_ack_o) |-> !$isunknown(i5_wb_dat_o);
	endproperty
	assert property(af_p1473);

	property af_p1474;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!i5_wb_we_i)[*2];
	endproperty
	assert property(af_p1474);

	property af_p1475;
	@(posedge wb_clk_i) (i5_wb_we_i && i5_wb_cyc_i && i5_wb_stb_i) |-> !i5_wb_err_o;
	endproperty
	assert property(af_p1475);

	property af_p1476;
	@(posedge wb_clk_i) (i5_wb_cyc_i && $rose(i5_wb_we_i)) |-> $past(!i5_wb_stb_i);
	endproperty
	assert property(af_p1476);

	property af_p1477;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i) |-> $stable(i5_wb_we_i);
	endproperty
	assert property(af_p1477);

	property af_p1478;
	@(posedge wb_clk_i) (i5_wb_we_i && i5_wb_ack_o) |-> (i5_wb_sel_i != '0);
	endproperty
	assert property(af_p1478);

	property af_p1479;
	@(posedge wb_clk_i) (i5_wb_we_i && i5_wb_cyc_i && i5_wb_stb_i) |-> ##[1:4] (i5_wb_ack_o && $stable(i5_wb_dat_i));
	endproperty
	assert property(af_p1479);

	property af_p1480;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(i5_wb_we_i);
	endproperty
	assert property(af_p1480);

	property af_p1481;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i5_wb_we_i == 1'b0)[*3];
	endproperty
	assert property(af_p1481);

	property af_p1482;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_we_i) |-> (i5_wb_we_i throughout (i5_wb_cyc_i[*1:$] ##0 i5_wb_ack_o));
	endproperty
	assert property(af_p1482);

	property af_p1483;
	@(posedge wb_clk_i) (i5_wb_we_i && i5_wb_stb_i) |-> (!$isunknown(i5_wb_sel_i));
	endproperty
	assert property(af_p1483);

	property af_p1484;
	@(posedge wb_clk_i) (i5_wb_we_i && i5_wb_cyc_i && i5_wb_stb_i) |-> (i5_wb_adr_i throughout (i5_wb_we_i[*1:$] ##0 i5_wb_ack_o));
	endproperty
	assert property(af_p1484);

	property af_p1485;
	@(posedge wb_clk_i) (i5_wb_we_i && i5_wb_cyc_i && i5_wb_stb_i) |-> (!$isunknown(i5_wb_dat_i));
	endproperty
	assert property(af_p1485);

	property af_p1486;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i5_wb_we_i == 1'b0);
	endproperty
	assert property(af_p1486);

	property af_p1487;
	@(posedge wb_clk_i) (i5_wb_we_i) |-> (!$isunknown(i5_wb_dat_i));
	endproperty
	assert property(af_p1487);

	property af_p1488;
	@(posedge wb_clk_i) (!i5_wb_cyc_i) |-> (i5_wb_ack_o == 0 && $stable(i5_wb_dat_o));
	endproperty
	assert property(af_p1488);

	property af_p1489;
	@(posedge wb_clk_i) (i5_wb_we_i && i5_wb_cyc_i && i5_wb_stb_i) |-> ##[1:4] i5_wb_ack_o;
	endproperty
	assert property(af_p1489);

	property af_p1490;
	@(posedge wb_clk_i) (i5_wb_stb_i && i5_wb_cyc_i && !i5_wb_ack_o) |-> $stable(i5_wb_we_i);
	endproperty
	assert property(af_p1490);

	property af_p1491;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i && !i5_wb_ack_o) |-> $stable(i5_wb_we_i);
	endproperty
	assert property(af_p1491);

	property af_p1492;
	@(posedge wb_clk_i) ($past(i5_wb_cyc_i) && $past(i5_wb_stb_i) && $past(i5_wb_ack_o) && i5_wb_cyc_i && i5_wb_stb_i && ($past(i5_wb_we_i) != i5_wb_we_i)) |-> !i5_wb_err_o;
	endproperty
	assert property(af_p1492);

	property af_p1493;
	@(posedge wb_clk_i) (!(i5_wb_cyc_i && i5_wb_stb_i)) |-> 1'b1;
	endproperty
	assert property(af_p1493);

	property af_p1494;
	@(posedge wb_clk_i) (!i5_wb_cyc_i) |-> (i5_wb_we_i == 1'b0);
	endproperty
	assert property(af_p1494);

	property af_p1495;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!i5_wb_ack_o) throughout (wb_rst_i)[*1:$];
	endproperty
	assert property(af_p1495);

	property af_p1496;
	@(posedge wb_clk_i) ($rose(i5_wb_we_i)) |-> ($stable(i5_wb_adr_i) throughout (i5_wb_we_i && i5_wb_cyc_i && i5_wb_stb_i));
	endproperty
	assert property(af_p1496);

	property af_p1497;
	@(posedge wb_clk_i) (i5_wb_we_i && i5_wb_cyc_i && i5_wb_stb_i) |-> (i5_wb_we_i throughout (##[0:$] i5_wb_ack_o));
	endproperty
	assert property(af_p1497);

	property af_p1498;
	@(posedge wb_clk_i) (i5_wb_cyc_i && i5_wb_stb_i && !i5_wb_we_i && i5_wb_ack_o) |-> (i5_wb_dat_o !== 'x);
	endproperty
	assert property(af_p1498);

	property af_p1499;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 (i5_wb_we_i === 1'b0 || i5_wb_we_i === 1'b1);
	endproperty
	assert property(af_p1499);

	property af_p1500;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (##1 (i6_wb_ack_o == 1'b0) ##1 (i6_wb_ack_o == 1'b0));
	endproperty
	assert property(af_p1500);

	property af_p1501;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i6_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p1501);

	property af_p1502;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_stb_i && i6_wb_we_i) |=> (i6_wb_ack_o);
	endproperty
	assert property(af_p1502);

	property af_p1503;
	@(posedge wb_clk_i) (!i6_wb_we_i && i6_wb_cyc_i && i6_wb_stb_i) |=> (i6_wb_ack_o) ##1 (!i6_wb_ack_o);
	endproperty
	assert property(af_p1503);


	property af_p1505;
	@(posedge wb_clk_i) !(i6_wb_ack_o && i6_wb_err_o);
	endproperty
	assert property(af_p1505);

	property af_p1506;
	@(posedge wb_clk_i) (!i6_wb_cyc_i) |-> (i6_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p1506);

	property af_p1507;
	@(posedge wb_clk_i) (i6_wb_sel_i != '0 && i6_wb_cyc_i) |=> (i6_wb_ack_o);
	endproperty
	assert property(af_p1507);

	property af_p1508;
	@(posedge wb_clk_i) (i6_wb_we_i && i6_wb_cyc_i && i6_wb_stb_i) |=> (i6_wb_ack_o);
	endproperty
	assert property(af_p1508);

	property af_p1509;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i6_wb_ack_o[*2];
	endproperty
	assert property(af_p1509);

	property af_p1510;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i6_wb_cyc_i && i6_wb_stb_i) |=> i6_wb_ack_o;
	endproperty
	assert property(af_p1510);

	property af_p1511;
	@(posedge wb_clk_i) (i6_wb_ack_o && !i6_wb_we_i) |-> $stable(i6_wb_dat_o);
	endproperty
	assert property(af_p1511);

	property af_p1512;
	@(posedge wb_clk_i) !i6_wb_cyc_i |-> !i6_wb_ack_o;
	endproperty
	assert property(af_p1512);

	property af_p1513;
	@(posedge wb_clk_i) i6_wb_cyc_i |-> $onehot0({$rose(i6_wb_ack_o), $fell(i6_wb_ack_o)});
	endproperty
	assert property(af_p1513);

	property af_p1514;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_stb_i) |=> i6_wb_ack_o;
	endproperty
	assert property(af_p1514);

	property af_p1515;
	@(posedge wb_clk_i) $fell(i6_wb_cyc_i) |-> !i6_wb_ack_o;
	endproperty
	assert property(af_p1515);

	property af_p1516;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i6_wb_ack_o) until (i6_wb_cyc_i && i6_wb_stb_i);
	endproperty
	assert property(af_p1516);

	property af_p1517;
	@(posedge wb_clk_i) i6_wb_ack_o |-> ((|i6_wb_sel_i) && i6_wb_cyc_i && i6_wb_stb_i);
	endproperty
	assert property(af_p1517);

	property af_p1518;
	@(posedge wb_clk_i) (!i6_wb_we_i && i6_wb_cyc_i && i6_wb_stb_i) |=> i6_wb_ack_o;
	endproperty
	assert property(af_p1518);

	property af_p1519;
	@(posedge wb_clk_i) i6_wb_ack_o |-> (i6_wb_cyc_i && i6_wb_stb_i);
	endproperty
	assert property(af_p1519);

	property af_p1520;
	@(posedge wb_clk_i) (!i6_wb_we_i && i6_wb_ack_o) |-> ($isunknown(i6_wb_dat_o) == 0);
	endproperty
	assert property(af_p1520);

	property af_p1521;
	@(posedge wb_clk_i) ($fell(i6_wb_cyc_i)) |=> (!i6_wb_ack_o);
	endproperty
	assert property(af_p1521);

	property af_p1522;
	@(posedge wb_clk_i) (i6_wb_stb_i && !$past(i6_wb_stb_i) && $past(i6_wb_ack_o)==0 && i6_wb_ack_o) |=> (!i6_wb_ack_o);
	endproperty
	assert property(af_p1522);

	property af_p1523;
	@(posedge wb_clk_i) (i6_wb_we_i && i6_wb_cyc_i && i6_wb_stb_i) |=> (i6_wb_ack_o) ##1 (!i6_wb_ack_o);
	endproperty
	assert property(af_p1523);

	property af_p1524;
	@(posedge wb_clk_i) (!i6_wb_we_i && i6_wb_ack_o) |-> (!$isunknown(i6_wb_dat_o));
	endproperty
	assert property(af_p1524);

	property af_p1525;
	@(posedge wb_clk_i) ($fell(i6_wb_stb_i)) |=> (!i6_wb_ack_o);
	endproperty
	assert property(af_p1525);

	property af_p1526;
	@(posedge wb_clk_i) (!i6_wb_stb_i && i6_wb_cyc_i) |-> (!i6_wb_ack_o);
	endproperty
	assert property(af_p1526);

	property af_p1527;
	@(posedge wb_clk_i) (!i6_wb_stb_i) |-> (!i6_wb_ack_o);
	endproperty
	assert property(af_p1527);

	property af_p1528;
	@(posedge wb_clk_i) (i6_wb_ack_o) |=> (!i6_wb_stb_i) || (i6_wb_stb_i && !i6_wb_ack_o) |-> (!i6_wb_ack_o) or (i6_wb_stb_i);
	endproperty
	assert property(af_p1528);

	property af_p1529;
	@(posedge wb_clk_i) (i6_wb_ack_o) |-> $stable(i6_wb_adr_i);
	endproperty
	assert property(af_p1529);

	property af_p1530;
	@(posedge wb_clk_i) (wb_rst_i && i6_wb_cyc_i && i6_wb_stb_i) |=> (!i6_wb_ack_o);
	endproperty
	assert property(af_p1530);

	property af_p1531;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_stb_i && (i6_wb_sel_i == '0)) |-> (!i6_wb_ack_o);
	endproperty
	assert property(af_p1531);

	property af_p1532;
	@(posedge wb_clk_i) (i6_wb_stb_i && $stable(i6_wb_adr_i)) |=> ($stable(i6_wb_adr_i) throughout (i6_wb_stb_i && !i6_wb_ack_o));
	endproperty
	assert property(af_p1532);

	property af_p1533;
	@(posedge wb_clk_i) (!i6_wb_we_i && i6_wb_stb_i && i6_wb_ack_o) |-> (i6_wb_adr_i == i6_wb_dat_o);
	endproperty
	assert property(af_p1533);

	property af_p1534;
	@(posedge wb_clk_i) (i6_wb_we_i && i6_wb_cyc_i) |=> ($stable(i6_wb_adr_i) throughout (i6_wb_cyc_i && !i6_wb_ack_o));
	endproperty
	assert property(af_p1534);

	property af_p1535;
	@(posedge wb_clk_i) (i6_wb_stb_i && !i6_wb_ack_o) |=> $stable(i6_wb_adr_i);
	endproperty
	assert property(af_p1535);

	property af_p1536;
	@(posedge wb_clk_i) (!i6_wb_stb_i) |=> $stable(i6_wb_adr_i);
	endproperty
	assert property(af_p1536);

	property af_p1537;
	@(posedge wb_clk_i) (i6_wb_stb_i) |-> (!$isunknown(i6_wb_adr_i));
	endproperty
	assert property(af_p1537);

	property af_p1538;
	@(posedge wb_clk_i) (wb_rst_i) |-> (1'b1);
	endproperty
	assert property(af_p1538);

	property af_p1539;
	@(posedge wb_clk_i) (i6_wb_cyc_i) |=> ($stable(i6_wb_adr_i) throughout i6_wb_cyc_i);
	endproperty
	assert property(af_p1539);

	property af_p1540;
	@(posedge wb_clk_i) (i6_wb_we_i && i6_wb_stb_i) |=> ($stable(i6_wb_adr_i) throughout (i6_wb_stb_i && !i6_wb_ack_o));
	endproperty
	assert property(af_p1540);

	property af_p1541;
	@(posedge wb_clk_i) (i6_wb_cyc_i && !i6_wb_ack_o) |-> $stable(i6_wb_adr_i);
	endproperty
	assert property(af_p1541);

	property af_p1542;
	@(posedge wb_clk_i) ($past(wb_rst_i) && !wb_rst_i) |-> !$isunknown(i6_wb_adr_i);
	endproperty
	assert property(af_p1542);

	property af_p1543;
	@(posedge wb_clk_i) $past(i6_wb_ack_o) |-> $stable(i6_wb_adr_i);
	endproperty
	assert property(af_p1543);

	property af_p1544;
	@(posedge wb_clk_i) (i6_wb_cyc_i) |-> $stable(i6_wb_adr_i);
	endproperty
	assert property(af_p1544);

	property af_p1545;
	@(posedge wb_clk_i) (i6_wb_stb_i) |-> ##1 $stable(i6_wb_adr_i);
	endproperty
	assert property(af_p1545);


	property af_p1547;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(i6_wb_adr_i);
	endproperty
	assert property(af_p1547);

	property af_p1548;
	@(posedge wb_clk_i) ($stable(i6_wb_adr_i) && i6_wb_cyc_i && i6_wb_stb_i) |-> i6_wb_ack_o;
	endproperty
	assert property(af_p1548);

	property af_p1549;
	@(posedge wb_clk_i) (!i6_wb_cyc_i) |-> !i6_wb_ack_o;
	endproperty
	assert property(af_p1549);

	property af_p1550;
	@(posedge wb_clk_i) (i6_wb_stb_i && !i6_wb_ack_o) |-> $stable(i6_wb_adr_i);
	endproperty
	assert property(af_p1550);

	property af_p1551;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 !$isunknown(i6_wb_adr_i)[*3];
	endproperty
	assert property(af_p1551);

	property af_p1552;
	@(posedge wb_clk_i) (i6_wb_we_i && i6_wb_cyc_i && i6_wb_stb_i) |-> $stable(i6_wb_adr_i) throughout (!i6_wb_ack_o)[*1:$];
	endproperty
	assert property(af_p1552);

	property af_p1553;
	@(posedge wb_clk_i) i6_wb_stb_i |-> $stable(i6_wb_adr_i);
	endproperty
	assert property(af_p1553);

	property af_p1554;
	@(posedge wb_clk_i) $rose(i6_wb_cyc_i) |-> !$isunknown(i6_wb_adr_i);
	endproperty
	assert property(af_p1554);

	property af_p1555;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] !$isunknown(i6_wb_adr_i);
	endproperty
	assert property(af_p1555);

	property af_p1556;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_stb_i) |-> $stable(i6_wb_adr_i);
	endproperty
	assert property(af_p1556);

	property af_p1557;
	@(posedge wb_clk_i) (i6_wb_cyc_i && !i6_wb_stb_i) |-> (!i6_wb_stb_i[*3]) |=> !i6_wb_ack_o;
	endproperty
	assert property(af_p1557);

	property af_p1558;
	@(posedge wb_clk_i) $rose(i6_wb_cyc_i) |=> ($stable(i6_wb_adr_i) throughout i6_wb_cyc_i[*1:$]);
	endproperty
	assert property(af_p1558);

	property af_p1559;
	@(posedge wb_clk_i) (wb_rst_i) |-> !i6_wb_cyc_i;
	endproperty
	assert property(af_p1559);

	property af_p1560;
	@(posedge wb_clk_i) ($rose(i6_wb_cyc_i) && i6_wb_ack_o) |=> !i6_wb_cyc_i;
	endproperty
	assert property(af_p1560);

	property af_p1561;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_err_o) |=> !i6_wb_cyc_i;
	endproperty
	assert property(af_p1561);



	property af_p1564;
	@(posedge wb_clk_i) !(i6_wb_stb_i && !i6_wb_cyc_i);
	endproperty
	assert property(af_p1564);

	property af_p1565;
	@(posedge wb_clk_i) $rose(i6_wb_cyc_i) |-> (i6_wb_cyc_i s_until_with i6_wb_ack_o);
	endproperty
	assert property(af_p1565);

	property af_p1566;
	@(posedge wb_clk_i) $rose(i6_wb_cyc_i) |-> !wb_rst_i;
	endproperty
	assert property(af_p1566);

	property af_p1567;
	@(posedge wb_clk_i) (i6_wb_sel_i != '0) |-> i6_wb_cyc_i;
	endproperty
	assert property(af_p1567);

	property af_p1568;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i6_wb_cyc_i;
	endproperty
	assert property(af_p1568);

	property af_p1569;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_stb_i && i6_wb_we_i && !i6_wb_ack_o) |-> ($stable(i6_wb_adr_i) throughout (##[0:$] i6_wb_ack_o));
	endproperty
	assert property(af_p1569);

	property af_p1570;
	@(posedge wb_clk_i) i6_wb_cyc_i |-> (i6_wb_cyc_i throughout (##[0:$] i6_wb_ack_o));
	endproperty
	assert property(af_p1570);

	property af_p1571;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_we_i && !i6_wb_ack_o) |-> ($stable(i6_wb_dat_i) throughout (##[0:$] i6_wb_ack_o));
	endproperty
	assert property(af_p1571);

	property af_p1572;
	@(posedge wb_clk_i) i6_wb_ack_o |-> (!i6_wb_cyc_i or ##1 !i6_wb_cyc_i);
	endproperty
	assert property(af_p1572);

	property af_p1573;
	@(posedge wb_clk_i) $rose(i6_wb_cyc_i) |-> ($stable(i6_wb_we_i) throughout (##[0:$] i6_wb_ack_o));
	endproperty
	assert property(af_p1573);

	property af_p1574;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!i6_wb_cyc_i ##1 !i6_wb_cyc_i);
	endproperty
	assert property(af_p1574);

	property af_p1575;
	@(posedge wb_clk_i) $fell(i6_wb_stb_i) |-> (!i6_wb_cyc_i or ##1 !i6_wb_cyc_i);
	endproperty
	assert property(af_p1575);

	property af_p1576;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_stb_i) |-> (i6_wb_cyc_i throughout (##[0:$] i6_wb_ack_o));
	endproperty
	assert property(af_p1576);

	property af_p1577;
	@(posedge wb_clk_i) (i6_wb_cyc_i && !i6_wb_ack_o) |=> i6_wb_cyc_i;
	endproperty
	assert property(af_p1577);

	property af_p1578;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (!i6_wb_cyc_i ##1 !i6_wb_cyc_i);
	endproperty
	assert property(af_p1578);

	property af_p1579;
	@(posedge wb_clk_i) (!$rose(i6_wb_cyc_i) && !$fell(i6_wb_cyc_i)) |-> $stable(i6_wb_cyc_i);
	endproperty
	assert property(af_p1579);

	property af_p1580;
	@(posedge wb_clk_i) !($rose(i6_wb_cyc_i) && $fell(i6_wb_cyc_i));
	endproperty
	assert property(af_p1580);

	property af_p1581;
	@(posedge wb_clk_i) (!i6_wb_cyc_i) |-> (!i6_wb_ack_o && !i6_wb_err_o);
	endproperty
	assert property(af_p1581);

	property af_p1582;
	@(posedge wb_clk_i) (!i6_wb_cyc_i) |-> (!i6_wb_stb_i);
	endproperty
	assert property(af_p1582);

	property af_p1583;
	@(posedge wb_clk_i) wb_rst_i |-> !i6_wb_cyc_i;
	endproperty
	assert property(af_p1583);

	property af_p1584;
	@(posedge wb_clk_i) $changed(i6_wb_adr_i) |=> i6_wb_cyc_i;
	endproperty
	assert property(af_p1584);

	property af_p1585;
	@(posedge wb_clk_i) $rose(i6_wb_cyc_i) |-> ##[1:16] i6_wb_ack_o;
	endproperty
	assert property(af_p1585);

	property af_p1586;
	@(posedge wb_clk_i) (i6_wb_we_i && (i6_wb_dat_i >= 100) && (i6_wb_dat_i <= 150)) |-> ##1 (i6_wb_dat_i >= 80) && (i6_wb_dat_i <= 170);
	endproperty
	assert property(af_p1586);

	property af_p1587;
	@(posedge wb_clk_i) ((i6_wb_dat_i >= 200) && (i6_wb_dat_i <= 255) && (i6_wb_sel_i)) |-> ##1 (i6_wb_dat_i >= 180) && (i6_wb_dat_i <= 255);
	endproperty
	assert property(af_p1587);

	property af_p1588;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##[1:2] (i6_wb_dat_i >= 0) && (i6_wb_dat_i <= 10);
	endproperty
	assert property(af_p1588);

	property af_p1589;
	@(posedge wb_clk_i) (i6_wb_sel_i == 2'b01) |-> (i6_wb_dat_i[15:8] == 8'h00) && (i6_wb_dat_i[7:0] >= 0) && (i6_wb_dat_i[7:0] <= 255);
	endproperty
	assert property(af_p1589);

	property af_p1590;
	@(posedge wb_clk_i) (i6_wb_stb_i && i6_wb_cyc_i && !i6_wb_ack_o) |-> $stable(i6_wb_dat_i);
	endproperty
	assert property(af_p1590);

	property af_p1591;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_stb_i) |-> $isunknown(i6_wb_dat_i) === 1'b0;
	endproperty
	assert property(af_p1591);

	property af_p1592;
	@(posedge wb_clk_i) (!i6_wb_we_i) |-> 1'b1;
	endproperty
	assert property(af_p1592);

	property af_p1593;
	@(posedge wb_clk_i) ((i6_wb_dat_i >= 100) && (i6_wb_dat_i <= 150)) |-> ##1 (i6_wb_dat_i >= 80) && (i6_wb_dat_i <= 170);
	endproperty
	assert property(af_p1593);

	property af_p1594;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (i6_wb_dat_i >= 0) && (i6_wb_dat_i <= 255);
	endproperty
	assert property(af_p1594);

	property af_p1595;
	@(posedge wb_clk_i) (i6_wb_stb_i && !i6_wb_ack_o) |-> $stable(i6_wb_dat_i);
	endproperty
	assert property(af_p1595);

	property af_p1596;
	@(posedge wb_clk_i) ((i6_wb_dat_i >= 200) && (i6_wb_dat_i <= 255)) |-> ##1 (i6_wb_dat_i >= 180) && (i6_wb_dat_i <= 255);
	endproperty
	assert property(af_p1596);

	property af_p1597;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 (i6_wb_dat_i !== 'x);
	endproperty
	assert property(af_p1597);

	property af_p1598;
	@(posedge wb_clk_i) ((i6_wb_dat_i >= 200) && (i6_wb_dat_i <= 255)) |-> (i6_wb_dat_i >= 180) && (i6_wb_dat_i <= 255);
	endproperty
	assert property(af_p1598);

	property af_p1599;
	@(posedge wb_clk_i) (!i6_wb_we_i && i6_wb_cyc_i && i6_wb_ack_o) |-> $stable(i6_wb_dat_i);
	endproperty
	assert property(af_p1599);

	property af_p1600;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (i6_wb_dat_i >= 0) && (i6_wb_dat_i <= 255);
	endproperty
	assert property(af_p1600);

	property af_p1601;
	@(posedge wb_clk_i) ((i6_wb_dat_i >= 128) && (i6_wb_dat_i <= 255) && i6_wb_cyc_i && i6_wb_stb_i) |-> i6_wb_ack_o;
	endproperty
	assert property(af_p1601);

	property af_p1602;
	@(posedge wb_clk_i) ($rose(i6_wb_dat_i > 128)) |-> ##1 i6_wb_ack_o;
	endproperty
	assert property(af_p1602);

	property af_p1603;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 ((i6_wb_dat_i >= 50) && (i6_wb_dat_i <= 200));
	endproperty
	assert property(af_p1603);

	property af_p1604;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 ((i6_wb_dat_i >= 0) && (i6_wb_dat_i <= 63));
	endproperty
	assert property(af_p1604);

	property af_p1605;
	@(posedge wb_clk_i) (!i6_wb_cyc_i) |-> $stable(i6_wb_dat_i);
	endproperty
	assert property(af_p1605);

	property af_p1606;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_we_i && i6_wb_ack_o) |-> $stable(i6_wb_dat_i);
	endproperty
	assert property(af_p1606);

	property af_p1607;
	@(posedge wb_clk_i) (i6_wb_cyc_i && !i6_wb_err_o) |-> $stable(i6_wb_dat_i);
	endproperty
	assert property(af_p1607);

	property af_p1608;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ##4 (i6_wb_dat_i >= 0) && (i6_wb_dat_i <= 45);
	endproperty
	assert property(af_p1608);

	property af_p1609;
	@(posedge wb_clk_i) ((i6_wb_dat_i >= 100) && (i6_wb_dat_i <= 150)) |=> (i6_wb_dat_i >= 80) && (i6_wb_dat_i <= 170);
	endproperty
	assert property(af_p1609);

	property af_p1610;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i6_wb_dat_i == 0);
	endproperty
	assert property(af_p1610);

	property af_p1611;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((i6_wb_dat_i >= 50) && (i6_wb_dat_i <= 200)) [*2];
	endproperty
	assert property(af_p1611);

	property af_p1612;
	@(posedge wb_clk_i) (i6_wb_sel_i[0]) |-> (i6_wb_dat_i[7:0] >= 0) && (i6_wb_dat_i[7:0] <= 255);
	endproperty
	assert property(af_p1612);

	property af_p1613;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ##4 (i6_wb_dat_i >= 0) && (i6_wb_dat_i <= 63);
	endproperty
	assert property(af_p1613);

	property af_p1614;
	@(posedge wb_clk_i) $fell(i6_wb_cyc_i) |=> $stable(i6_wb_dat_i) throughout (!$rose(wb_clk_i)[*1]);
	endproperty
	assert property(af_p1614);

	property af_p1615;
	@(posedge wb_clk_i) 1 |-> (i6_wb_dat_i >= 0) && (i6_wb_dat_i <= 255);
	endproperty
	assert property(af_p1615);

	property af_p1616;
	@(posedge wb_clk_i) (i6_wb_stb_i && i6_wb_we_i) |-> $stable(i6_wb_dat_i);
	endproperty
	assert property(af_p1616);

	property af_p1617;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##3 ((i6_wb_dat_o >= 0) && (i6_wb_dat_o <= 255));
	endproperty
	assert property(af_p1617);

	property af_p1618;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(i6_wb_dat_o);
	endproperty
	assert property(af_p1618);

	property af_p1619;
	@(posedge wb_clk_i) ((&i6_wb_sel_i) && i6_wb_ack_o) |-> ((i6_wb_dat_o >= 0) && (i6_wb_dat_o <= 255));
	endproperty
	assert property(af_p1619);

	property af_p1620;
	@(posedge wb_clk_i) ((i6_wb_dat_o >= 100) && (i6_wb_dat_o <= 150)) |=> (i6_wb_cyc_i |-> ((i6_wb_dat_o >= 80) && (i6_wb_dat_o <= 170)));
	endproperty
	assert property(af_p1620);

	property af_p1621;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_stb_i && i6_wb_ack_o) |-> ((i6_wb_dat_o >= 0) && (i6_wb_dat_o <= 255)) throughout (i6_wb_ack_o[*1:$]);
	endproperty
	assert property(af_p1621);

	property af_p1622;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i6_wb_dat_o == 0);
	endproperty
	assert property(af_p1622);

	property af_p1623;
	@(posedge wb_clk_i) ($changed(i6_wb_adr_i)) |-> ##[1:2] ((i6_wb_dat_o >= 0) && (i6_wb_dat_o <= 127));
	endproperty
	assert property(af_p1623);

	property af_p1624;
	@(posedge wb_clk_i) ($rose(i6_wb_cyc_i)) |-> (i6_wb_dat_o == $past(i6_wb_dat_o)) throughout (!i6_wb_ack_o)[*0:$] ##0 (i6_wb_ack_o) ;
	endproperty
	assert property(af_p1624);

	property af_p1625;
	@(posedge wb_clk_i) (i6_wb_stb_i) |-> ##[1:2] ((i6_wb_dat_o >= 0) && (i6_wb_dat_o <= 255));
	endproperty
	assert property(af_p1625);

	property af_p1626;
	@(posedge wb_clk_i) (!i6_wb_ack_o) |-> ($stable(i6_wb_dat_o) && (i6_wb_dat_o >= 0) && (i6_wb_dat_o <= 255));
	endproperty
	assert property(af_p1626);

	property af_p1627;
	@(posedge wb_clk_i) (i6_wb_ack_o) |-> $stable(i6_wb_dat_o);
	endproperty
	assert property(af_p1627);

	property af_p1628;
	@(posedge wb_clk_i) (i6_wb_we_i) |-> ##1 $stable(i6_wb_dat_o);
	endproperty
	assert property(af_p1628);

	property af_p1629;
	@(posedge wb_clk_i) i6_wb_ack_o |-> (i6_wb_dat_o >= 0) && (i6_wb_dat_o <= 255);
	endproperty
	assert property(af_p1629);

	property af_p1630;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:3] (i6_wb_dat_o >= 0) && (i6_wb_dat_o <= 255);
	endproperty
	assert property(af_p1630);

	property af_p1631;
	@(posedge wb_clk_i) (!i6_wb_we_i) |-> $stable(i6_wb_dat_o);
	endproperty
	assert property(af_p1631);

	property af_p1632;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_stb_i) |-> (i6_wb_dat_o >= 0) && (i6_wb_dat_o <= 255);
	endproperty
	assert property(af_p1632);

	property af_p1633;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((!i6_wb_cyc_i || !i6_wb_stb_i) -> ((i6_wb_dat_o >= 0) && (i6_wb_dat_o <= 255)));
	endproperty
	assert property(af_p1633);

	property af_p1634;
	@(posedge wb_clk_i) i6_wb_ack_o |=> (i6_wb_dat_o >= 0) && (i6_wb_dat_o <= 255);
	endproperty
	assert property(af_p1634);

	property af_p1635;
	@(posedge wb_clk_i) (!i6_wb_cyc_i) |-> $stable(i6_wb_dat_o);
	endproperty
	assert property(af_p1635);

	property af_p1636;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (i6_wb_dat_o >= 0) && (i6_wb_dat_o <= 255);
	endproperty
	assert property(af_p1636);

	property af_p1637;
	@(posedge wb_clk_i) wb_rst_i |=> (i6_wb_dat_o == 0);
	endproperty
	assert property(af_p1637);

	property af_p1638;
	@(posedge wb_clk_i) (!i6_wb_we_i && i6_wb_ack_o) |-> ((i6_wb_dat_o >= 0) && (i6_wb_dat_o <= 255));
	endproperty
	assert property(af_p1638);

	property af_p1639;
	@(posedge wb_clk_i) (i6_wb_err_o) |-> ##1 $stable(i6_wb_dat_o);
	endproperty
	assert property(af_p1639);

	property af_p1640;
	@(posedge wb_clk_i) (!i6_wb_cyc_i) |-> ($stable(i6_wb_dat_o));
	endproperty
	assert property(af_p1640);

	property af_p1641;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ##4 ((i6_wb_dat_o >= 0) && (i6_wb_dat_o <= 255));
	endproperty
	assert property(af_p1641);

	property af_p1642;
	@(posedge wb_clk_i) ($fell(i6_wb_stb_i)) |-> ##1 $stable(i6_wb_dat_o);
	endproperty
	assert property(af_p1642);

	property af_p1643;
	@(posedge wb_clk_i) (!i6_wb_stb_i) |-> ($stable(i6_wb_dat_o));
	endproperty
	assert property(af_p1643);

	property af_p1644;
	@(posedge wb_clk_i) (i6_wb_err_o) |-> ##[1:3] $stable(i6_wb_dat_o);
	endproperty
	assert property(af_p1644);

	property af_p1645;
	@(posedge wb_clk_i) ((i6_wb_dat_o >= 100) && (i6_wb_dat_o <= 200)) |=> ((i6_wb_dat_o >= 80) && (i6_wb_dat_o <= 220));
	endproperty
	assert property(af_p1645);

	property af_p1646;
	@(posedge wb_clk_i) (i6_wb_stb_i && i6_wb_cyc_i) |-> ##1 (!$isunknown(i6_wb_dat_o));
	endproperty
	assert property(af_p1646);

	property af_p1647;
	@(posedge wb_clk_i) (i6_wb_err_o) |-> (!$isunknown(i6_wb_dat_o) === 0 || $isunknown(i6_wb_dat_o));
	endproperty
	assert property(af_p1647);

	property af_p1648;
	@(posedge wb_clk_i) (!i6_wb_we_i && i6_wb_stb_i) |=> ((i6_wb_dat_o >= 0) && (i6_wb_dat_o <= 255));
	endproperty
	assert property(af_p1648);

	property af_p1649;
	@(posedge wb_clk_i) (i6_wb_err_o && !i6_wb_cyc_i) |-> ##1 (i6_wb_err_o == 0);
	endproperty
	assert property(af_p1649);

	property af_p1650;
	@(posedge wb_clk_i) i6_wb_err_o |-> i6_wb_stb_i || $past(i6_wb_stb_i);
	endproperty
	assert property(af_p1650);

	property af_p1651;
	@(posedge wb_clk_i) (!i6_wb_cyc_i) |-> (i6_wb_err_o == 0);
	endproperty
	assert property(af_p1651);

	property af_p1652;
	@(posedge wb_clk_i) wb_rst_i |-> ##1 (i6_wb_err_o == 0);
	endproperty
	assert property(af_p1652);

	property af_p1653;
	@(posedge wb_clk_i) (wb_rst_i && i6_wb_cyc_i && i6_wb_stb_i) |-> (i6_wb_err_o == 0);
	endproperty
	assert property(af_p1653);

	property af_p1654;
	@(posedge wb_clk_i) (i6_wb_err_o && $fell(i6_wb_cyc_i)) |-> ##1 (i6_wb_err_o == 0);
	endproperty
	assert property(af_p1654);

	property af_p1655;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] (i6_wb_err_o == 0);
	endproperty
	assert property(af_p1655);

	property af_p1656;
	@(posedge wb_clk_i) !(i6_wb_err_o && i6_wb_ack_o);
	endproperty
	assert property(af_p1656);

	property af_p1657;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_stb_i && i6_wb_we_i) |-> ##1 i6_wb_err_o;
	endproperty
	assert property(af_p1657);

	property af_p1658;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:4] (i6_wb_err_o == 0);
	endproperty
	assert property(af_p1658);












	property af_p1670;
	@(posedge wb_clk_i) not (i6_wb_err_o && i6_wb_ack_o);
	endproperty
	assert property(af_p1670);

	property af_p1671;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i6_wb_err_o == 1'b0);
	endproperty
	assert property(af_p1671);

	property af_p1672;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (!i6_wb_err_o);
	endproperty
	assert property(af_p1672);

	property af_p1673;
	@(posedge wb_clk_i) ($fell(i6_wb_cyc_i)) |=> (!i6_wb_err_o);
	endproperty
	assert property(af_p1673);

	property af_p1674;
	@(posedge wb_clk_i) (i6_wb_cyc_i) |-> (!i6_wb_err_o);
	endproperty
	assert property(af_p1674);

	property af_p1675;
	@(posedge wb_clk_i) (i6_wb_err_o) |-> (i6_wb_cyc_i && i6_wb_stb_i);
	endproperty
	assert property(af_p1675);


	property af_p1677;
	@(posedge wb_clk_i) (i6_wb_err_o) |=> (!i6_wb_err_o);
	endproperty
	assert property(af_p1677);

	property af_p1678;
	@(posedge wb_clk_i) (!i6_wb_stb_i) |-> $stable(i6_wb_err_o);
	endproperty
	assert property(af_p1678);

	property af_p1679;
	@(posedge wb_clk_i) (i6_wb_err_o) |-> (i6_wb_stb_i);
	endproperty
	assert property(af_p1679);

	property af_p1680;
	@(posedge wb_clk_i) (i6_wb_we_i && i6_wb_stb_i) |=> (i6_wb_sel_i != '0);
	endproperty
	assert property(af_p1680);

	property af_p1681;
	@(posedge wb_clk_i) (i6_wb_cyc_i && !i6_wb_ack_o) |-> $stable(i6_wb_sel_i);
	endproperty
	assert property(af_p1681);

	property af_p1682;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (!$isunknown(i6_wb_sel_i))[*2];
	endproperty
	assert property(af_p1682);

	property af_p1683;
	@(posedge wb_clk_i) (i6_wb_stb_i) |-> $stable(i6_wb_sel_i);
	endproperty
	assert property(af_p1683);

	property af_p1684;
	@(posedge wb_clk_i) (!i6_wb_stb_i) |-> $stable(i6_wb_sel_i);
	endproperty
	assert property(af_p1684);

	property af_p1685;
	@(posedge wb_clk_i) (!i6_wb_cyc_i) |-> $stable(i6_wb_sel_i);
	endproperty
	assert property(af_p1685);

	property af_p1686;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_stb_i && (i6_wb_sel_i == '0)) |-> !i6_wb_ack_o;
	endproperty
	assert property(af_p1686);

	property af_p1687;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i6_wb_sel_i == '0);
	endproperty
	assert property(af_p1687);

	property af_p1688;
	@(posedge wb_clk_i) (i6_wb_cyc_i) |-> ($stable(i6_wb_sel_i) until i6_wb_ack_o);
	endproperty
	assert property(af_p1688);

	property af_p1689;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_stb_i) |-> $stable(i6_wb_sel_i);
	endproperty
	assert property(af_p1689);

	property af_p1690;
	@(posedge wb_clk_i) ($rose(i6_wb_cyc_i)) |-> (i6_wb_sel_i != $past(i6_wb_sel_i));
	endproperty
	assert property(af_p1690);

	property af_p1691;
	@(posedge wb_clk_i) (!i6_wb_stb_i) |-> (i6_wb_sel_i == i6_wb_sel_i);
	endproperty
	assert property(af_p1691);

	property af_p1692;
	@(posedge wb_clk_i) (i6_wb_cyc_i) |-> $stable(i6_wb_sel_i);
	endproperty
	assert property(af_p1692);

	property af_p1693;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_stb_i) |-> (!$isunknown(i6_wb_sel_i));
	endproperty
	assert property(af_p1693);

	property af_p1694;
	@(posedge wb_clk_i) (i6_wb_we_i) |-> (i6_wb_sel_i != '0);
	endproperty
	assert property(af_p1694);

	property af_p1695;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_stb_i && i6_wb_we_i) |-> (i6_wb_sel_i != '0);
	endproperty
	assert property(af_p1695);

	property af_p1696;
	@(posedge wb_clk_i) ($changed(i6_wb_sel_i)) |-> (!i6_wb_cyc_i);
	endproperty
	assert property(af_p1696);

	property af_p1697;
	@(posedge wb_clk_i) (!i6_wb_cyc_i) |-> (!i6_wb_ack_o);
	endproperty
	assert property(af_p1697);

	property af_p1698;
	@(posedge wb_clk_i) i6_wb_stb_i |-> $stable(i6_wb_sel_i) throughout (i6_wb_stb_i[*1:$] ##0 i6_wb_ack_o);
	endproperty
	assert property(af_p1698);

	property af_p1699;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 !$isunknown(i6_wb_sel_i);
	endproperty
	assert property(af_p1699);

	property af_p1700;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i6_wb_sel_i == '0) until (i6_wb_stb_i);
	endproperty
	assert property(af_p1700);

	property af_p1701;
	@(posedge wb_clk_i) i6_wb_stb_i |-> (i6_wb_sel_i != '0);
	endproperty
	assert property(af_p1701);

	property af_p1702;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (i6_wb_sel_i == '0);
	endproperty
	assert property(af_p1702);

	property af_p1703;
	@(posedge wb_clk_i) (i6_wb_we_i && i6_wb_cyc_i && i6_wb_stb_i) |-> (i6_wb_sel_i != '0) && $stable(i6_wb_sel_i);
	endproperty
	assert property(af_p1703);

	property af_p1704;
	@(posedge wb_clk_i) i6_wb_err_o |-> ##[1:3] !i6_wb_stb_i;
	endproperty
	assert property(af_p1704);

	property af_p1705;
	@(posedge wb_clk_i) !( (i6_wb_stb_i !== $past(i6_wb_stb_i)) && (i6_wb_stb_i !== $past(i6_wb_stb_i,2)) );
	endproperty
	assert property(af_p1705);

	property af_p1706;
	@(posedge wb_clk_i) i6_wb_stb_i |-> i6_wb_cyc_i;
	endproperty
	assert property(af_p1706);

	property af_p1707;
	@(posedge wb_clk_i) i6_wb_stb_i |-> $stable(i6_wb_we_i);
	endproperty
	assert property(af_p1707);

	property af_p1708;
	@(posedge wb_clk_i) wb_rst_i |=> (!i6_wb_stb_i)[*2];
	endproperty
	assert property(af_p1708);

	property af_p1709;
	@(posedge wb_clk_i) i6_wb_stb_i |-> (i6_wb_sel_i != '0);
	endproperty
	assert property(af_p1709);

	property af_p1710;
	@(posedge wb_clk_i) i6_wb_stb_i |-> (i6_wb_stb_i until i6_wb_ack_o);
	endproperty
	assert property(af_p1710);

	property af_p1711;
	@(posedge wb_clk_i) i6_wb_ack_o |=> !i6_wb_stb_i;
	endproperty
	assert property(af_p1711);

	property af_p1712;
	@(posedge wb_clk_i) wb_rst_i |-> !i6_wb_stb_i;
	endproperty
	assert property(af_p1712);

	property af_p1713;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> !i6_wb_stb_i [*2];
	endproperty
	assert property(af_p1713);

	property af_p1714;
	@(posedge wb_clk_i) i6_wb_err_o |=> !i6_wb_stb_i;
	endproperty
	assert property(af_p1714);

	property af_p1715;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i6_wb_stb_i [*3];
	endproperty
	assert property(af_p1715);

	property af_p1716;
	@(posedge wb_clk_i) (i6_wb_stb_i && i6_wb_we_i) |-> ($stable(i6_wb_dat_i) until i6_wb_ack_o);
	endproperty
	assert property(af_p1716);

	property af_p1717;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i6_wb_stb_i [*2];
	endproperty
	assert property(af_p1717);

	property af_p1718;
	@(posedge wb_clk_i) i6_wb_stb_i |=> (i6_wb_stb_i -> $stable(i6_wb_adr_i));
	endproperty
	assert property(af_p1718);

	property af_p1719;
	@(posedge wb_clk_i) (i6_wb_stb_i && i6_wb_we_i) |=> $stable(i6_wb_dat_i);
	endproperty
	assert property(af_p1719);

	property af_p1720;
	@(posedge wb_clk_i) $rose(i6_wb_stb_i) |-> i6_wb_stb_i s_until (i6_wb_ack_o || i6_wb_err_o);
	endproperty
	assert property(af_p1720);

	property af_p1721;
	@(posedge wb_clk_i) !i6_wb_cyc_i |-> $stable(i6_wb_stb_i);
	endproperty
	assert property(af_p1721);

	property af_p1722;
	@(posedge wb_clk_i) (i6_wb_stb_i && i6_wb_cyc_i) |-> $stable(i6_wb_adr_i) s_until i6_wb_ack_o;
	endproperty
	assert property(af_p1722);

	property af_p1723;
	@(posedge wb_clk_i) i6_wb_ack_o |-> ##1 !i6_wb_stb_i;
	endproperty
	assert property(af_p1723);

	property af_p1724;
	@(posedge wb_clk_i) i6_wb_stb_i |-> $stable(i6_wb_adr_i) s_until i6_wb_ack_o;
	endproperty
	assert property(af_p1724);

	property af_p1725;
	@(posedge wb_clk_i) i6_wb_stb_i |-> ##[1:4] i6_wb_ack_o;
	endproperty
	assert property(af_p1725);

	property af_p1726;
	@(posedge wb_clk_i) i6_wb_stb_i |-> i6_wb_stb_i s_until (i6_wb_ack_o || i6_wb_err_o);
	endproperty
	assert property(af_p1726);

	property af_p1727;
	@(posedge wb_clk_i) i6_wb_stb_i |-> $stable(i6_wb_sel_i);
	endproperty
	assert property(af_p1727);

	property af_p1728;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> !i6_wb_we_i ##1 !i6_wb_we_i;
	endproperty
	assert property(af_p1728);

	property af_p1729;
	@(posedge wb_clk_i) (i6_wb_cyc_i && $rose(i6_wb_we_i)) |-> i6_wb_err_o;
	endproperty
	assert property(af_p1729);

	property af_p1730;
	@(posedge wb_clk_i) (i6_wb_we_i && i6_wb_stb_i && i6_wb_cyc_i) |-> ##[1:16] i6_wb_ack_o;
	endproperty
	assert property(af_p1730);

	property af_p1731;
	@(posedge wb_clk_i) (i6_wb_we_i != $past(i6_wb_we_i)) |-> !i6_wb_err_o;
	endproperty
	assert property(af_p1731);

	property af_p1732;
	@(posedge wb_clk_i) (!i6_wb_we_i && i6_wb_stb_i) |=> $isunknown(i6_wb_dat_o) == 0;
	endproperty
	assert property(af_p1732);

	property af_p1733;
	@(posedge wb_clk_i) i6_wb_we_i |-> ($isunknown(i6_wb_dat_i) == 0);
	endproperty
	assert property(af_p1733);

	property af_p1734;
	@(posedge wb_clk_i) (!i6_wb_we_i && i6_wb_stb_i && i6_wb_ack_o) |-> ($isunknown(i6_wb_dat_o) == 0);
	endproperty
	assert property(af_p1734);

	property af_p1735;
	@(posedge wb_clk_i) $fell(i6_wb_we_i) |=> ($isunknown(i6_wb_dat_o) == 0);
	endproperty
	assert property(af_p1735);

	property af_p1736;
	@(posedge wb_clk_i) (i6_wb_we_i && i6_wb_cyc_i && i6_wb_stb_i) |=> $stable(i6_wb_dat_i) throughout (i6_wb_we_i && i6_wb_cyc_i && i6_wb_stb_i)[->1];
	endproperty
	assert property(af_p1736);

	property af_p1737;
	@(posedge wb_clk_i) (i6_wb_we_i && i6_wb_stb_i && i6_wb_ack_o) |-> ($isunknown(i6_wb_dat_i) == 0);
	endproperty
	assert property(af_p1737);

	property af_p1738;
	@(posedge wb_clk_i) i6_wb_ack_o |-> ##1 (!i6_wb_cyc_i || $stable(i6_wb_we_i));
	endproperty
	assert property(af_p1738);

	property af_p1739;
	@(posedge wb_clk_i) (i6_wb_stb_i && $past(i6_wb_stb_i)) |-> $stable(i6_wb_we_i);
	endproperty
	assert property(af_p1739);

	property af_p1740;
	@(posedge wb_clk_i) $rose(i6_wb_cyc_i) |-> ##1 $stable(i6_wb_we_i);
	endproperty
	assert property(af_p1740);

	property af_p1741;
	@(posedge wb_clk_i) (i6_wb_cyc_i && $past(i6_wb_cyc_i)) |-> $stable(i6_wb_we_i);
	endproperty
	assert property(af_p1741);

	property af_p1742;
	@(posedge wb_clk_i) wb_rst_i |-> (i6_wb_we_i == 1'b0);
	endproperty
	assert property(af_p1742);

	property af_p1743;
	@(posedge wb_clk_i) (i6_wb_we_i && i6_wb_cyc_i && i6_wb_stb_i) |-> ##1 i6_wb_ack_o;
	endproperty
	assert property(af_p1743);

	property af_p1744;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_stb_i && !i6_wb_ack_o) |-> $stable(i6_wb_we_i) throughout (i6_wb_cyc_i && i6_wb_stb_i)[->1] ##0 i6_wb_ack_o;
	endproperty
	assert property(af_p1744);

	property af_p1745;
	@(posedge wb_clk_i) i6_wb_cyc_i |-> (i6_wb_ack_o |-> $stable(i6_wb_we_i));
	endproperty
	assert property(af_p1745);

	property af_p1746;
	@(posedge wb_clk_i) (i6_wb_cyc_i && i6_wb_stb_i) |-> !$isunknown(i6_wb_we_i);
	endproperty
	assert property(af_p1746);

	property af_p1747;
	@(posedge wb_clk_i) i6_wb_stb_i |-> !$isunknown(i6_wb_we_i);
	endproperty
	assert property(af_p1747);

	property af_p1748;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] !$isunknown(i6_wb_we_i);
	endproperty
	assert property(af_p1748);

	property af_p1749;
	@(posedge wb_clk_i) ($fell(wb_rst_i) ##3 i6_wb_we_i) |-> i6_wb_cyc_i;
	endproperty
	assert property(af_p1749);

	property af_p1750;
	@(posedge wb_clk_i) wb_rst_i |-> !i6_wb_we_i;
	endproperty
	assert property(af_p1750);

	property af_p1751;
	@(posedge wb_clk_i) ($past(i6_wb_we_i) == 1'b1 && i6_wb_we_i == 1'b0) |-> !i6_wb_err_o;
	endproperty
	assert property(af_p1751);

	property af_p1752;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!i6_wb_we_i ##1 !i6_wb_we_i);
	endproperty
	assert property(af_p1752);

	property af_p1753;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i6_wb_we_i;
	endproperty
	assert property(af_p1753);

	property af_p1754;
	@(posedge wb_clk_i) (i6_wb_cyc_i && !i6_wb_ack_o) |-> $stable(i6_wb_we_i);
	endproperty
	assert property(af_p1754);

	property af_p1755;
	@(posedge wb_clk_i) i6_wb_cyc_i |-> $stable(i6_wb_we_i);
	endproperty
	assert property(af_p1755);

	property af_p1756;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i7_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p1756);

	property af_p1757;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (i7_wb_ack_o == 1'b0) ##1 (i7_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p1757);

	property af_p1758;
	@(posedge wb_clk_i) ($fell(i7_wb_cyc_i)) |-> ##[0:1] (i7_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p1758);

	property af_p1759;
	@(posedge wb_clk_i) (i7_wb_ack_o && !i7_wb_stb_i) |-> ##1 (i7_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p1759);


	property af_p1761;
	@(posedge wb_clk_i) (i7_wb_we_i && i7_wb_cyc_i && i7_wb_stb_i) |-> (i7_wb_ack_o == 1'b1);
	endproperty
	assert property(af_p1761);

	property af_p1762;
	@(posedge wb_clk_i) (i7_wb_stb_i && i7_wb_cyc_i) |-> (i7_wb_ack_o == 1'b1);
	endproperty
	assert property(af_p1762);

	property af_p1763;
	@(posedge wb_clk_i) (i7_wb_ack_o) |-> (i7_wb_err_o == 1'b0);
	endproperty
	assert property(af_p1763);

	property af_p1764;
	@(posedge wb_clk_i) !(i7_wb_ack_o && i7_wb_err_o);
	endproperty
	assert property(af_p1764);

	property af_p1765;
	@(posedge wb_clk_i) (!i7_wb_cyc_i) |-> (i7_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p1765);

	property af_p1766;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i && (i7_wb_sel_i == '0)) |-> !i7_wb_ack_o;
	endproperty
	assert property(af_p1766);

	property af_p1767;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i && !i7_wb_we_i) |-> i7_wb_ack_o;
	endproperty
	assert property(af_p1767);

	property af_p1768;
	@(posedge wb_clk_i) i7_wb_ack_o |-> (i7_wb_cyc_i && i7_wb_stb_i);
	endproperty
	assert property(af_p1768);

	property af_p1769;
	@(posedge wb_clk_i) $fell(i7_wb_stb_i) |=> !i7_wb_ack_o;
	endproperty
	assert property(af_p1769);

	property af_p1770;
	@(posedge wb_clk_i) (i7_wb_stb_i && i7_wb_we_i) |-> ##[0:1] i7_wb_ack_o;
	endproperty
	assert property(af_p1770);

	property af_p1771;
	@(posedge wb_clk_i) wb_rst_i |-> !i7_wb_ack_o;
	endproperty
	assert property(af_p1771);


	property af_p1773;
	@(posedge wb_clk_i) $fell(i7_wb_cyc_i) |=> !i7_wb_ack_o;
	endproperty
	assert property(af_p1773);

	property af_p1774;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> !i7_wb_ack_o;
	endproperty
	assert property(af_p1774);

	property af_p1775;
	@(posedge wb_clk_i) (!i7_wb_cyc_i) |-> (!i7_wb_ack_o);
	endproperty
	assert property(af_p1775);

	property af_p1776;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i && !i7_wb_we_i && i7_wb_ack_o) |=> !i7_wb_ack_o;
	endproperty
	assert property(af_p1776);

	property af_p1777;
	@(posedge wb_clk_i) (i7_wb_ack_o && !i7_wb_we_i) |-> !$isunknown(i7_wb_dat_o);
	endproperty
	assert property(af_p1777);

	property af_p1778;
	@(posedge wb_clk_i) !i7_wb_cyc_i |-> !i7_wb_ack_o;
	endproperty
	assert property(af_p1778);

	property af_p1779;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i) |-> ##[0:1] i7_wb_ack_o;
	endproperty
	assert property(af_p1779);

	property af_p1780;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i && $rose(i7_wb_ack_o)) |=> $fell(i7_wb_ack_o);
	endproperty
	assert property(af_p1780);

	property af_p1781;
	@(posedge wb_clk_i) (i7_wb_ack_o && !i7_wb_stb_i) |=> !i7_wb_ack_o;
	endproperty
	assert property(af_p1781);

	property af_p1782;
	@(posedge wb_clk_i) ($stable(i7_wb_adr_i) && i7_wb_cyc_i && i7_wb_stb_i) |-> i7_wb_ack_o;
	endproperty
	assert property(af_p1782);

	property af_p1783;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (!i7_wb_ack_o)[*2];
	endproperty
	assert property(af_p1783);

	property af_p1784;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i) |-> ##[1:2] i7_wb_ack_o;
	endproperty
	assert property(af_p1784);

	property af_p1785;
	@(posedge wb_clk_i) ((i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 1023) && i7_wb_stb_i) |=> (i7_wb_cyc_i -> ((i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 1023)));
	endproperty
	assert property(af_p1785);

	property af_p1786;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 4294967295));
	endproperty
	assert property(af_p1786);

	property af_p1787;
	@(posedge wb_clk_i) disable iff (!i7_wb_cyc_i) $stable(i7_wb_adr_i) or $changed(i7_wb_adr_i);
	endproperty
	assert property(af_p1787);

	property af_p1788;
	@(posedge wb_clk_i) $fell(i7_wb_cyc_i) |=> 1;
	endproperty
	assert property(af_p1788);

	property af_p1789;
	@(posedge wb_clk_i) (wb_rst_i) |=> ((i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 0));
	endproperty
	assert property(af_p1789);

	property af_p1790;
	@(posedge wb_clk_i) ($fell(i7_wb_cyc_i)) |=> ((i7_wb_adr_i < 0) || (i7_wb_adr_i > 1023));
	endproperty
	assert property(af_p1790);

	property af_p1791;
	@(posedge wb_clk_i) ((i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 1023)) |=> ((i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 2047));
	endproperty
	assert property(af_p1791);

	property af_p1792;
	@(posedge wb_clk_i) (wb_rst_i) |-> ((i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 0)) throughout wb_rst_i[->1];
	endproperty
	assert property(af_p1792);

	property af_p1793;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##3 ((i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 4095));
	endproperty
	assert property(af_p1793);

	property af_p1794;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 65535));
	endproperty
	assert property(af_p1794);

	property af_p1795;
	@(posedge wb_clk_i) (i7_wb_we_i && i7_wb_stb_i) |=> (i7_wb_adr_i inside {[0:8191]});
	endproperty
	assert property(af_p1795);

	property af_p1796;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i) |-> !$isunknown(i7_wb_adr_i);
	endproperty
	assert property(af_p1796);

	property af_p1797;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 (i7_wb_adr_i >= 0 && i7_wb_adr_i <= 255);
	endproperty
	assert property(af_p1797);

	property af_p1798;
	@(posedge wb_clk_i) (i7_wb_adr_i inside {[512:1535]}) |=> (i7_wb_adr_i inside {[256:1535]});
	endproperty
	assert property(af_p1798);

	property af_p1799;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##2 (i7_wb_adr_i inside {[0:4095]});
	endproperty
	assert property(af_p1799);

	property af_p1800;
	@(posedge wb_clk_i) ($rose(!wb_rst_i) ##0 (i7_wb_stb_i[*4])) |-> (i7_wb_adr_i inside {[100:200]});
	endproperty
	assert property(af_p1800);

	property af_p1801;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (i7_wb_adr_i == '0);
	endproperty
	assert property(af_p1801);

	property af_p1802;
	@(posedge wb_clk_i) (i7_wb_stb_i && !i7_wb_ack_o) |-> $stable(i7_wb_adr_i);
	endproperty
	assert property(af_p1802);


	property af_p1804;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i) |-> ((i7_wb_adr_i inside {[0:4095]}) && $stable(i7_wb_adr_i));
	endproperty
	assert property(af_p1804);

	property af_p1805;
	@(posedge wb_clk_i) (i7_wb_stb_i && !i7_wb_ack_o) |=> $stable(i7_wb_adr_i);
	endproperty
	assert property(af_p1805);

	property af_p1806;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##2 ((i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 65535));
	endproperty
	assert property(af_p1806);

	property af_p1807;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 ((i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 255));
	endproperty
	assert property(af_p1807);

	property af_p1808;
	@(posedge wb_clk_i) (i7_wb_we_i && i7_wb_stb_i) |-> (i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 4095);
	endproperty
	assert property(af_p1808);

	property af_p1809;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i) |-> (i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 4095);
	endproperty
	assert property(af_p1809);

	property af_p1810;
	@(posedge wb_clk_i) ((i7_wb_adr_i >= 512) && (i7_wb_adr_i <= 767)) |=> (i7_wb_adr_i >= 256) && (i7_wb_adr_i <= 1023);
	endproperty
	assert property(af_p1810);

	property af_p1811;
	@(posedge wb_clk_i) ((i7_wb_adr_i >= 1024) && (i7_wb_adr_i <= 2047)) |=> ((i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 4095)) ##1 ((i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 4095));
	endproperty
	assert property(af_p1811);

	property af_p1812;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 ((i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 4095));
	endproperty
	assert property(af_p1812);

	property af_p1813;
	@(posedge wb_clk_i) ((i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 1023)) |=> (i7_wb_adr_i >= 0) && (i7_wb_adr_i <= 2047);
	endproperty
	assert property(af_p1813);

	property af_p1814;
	@(posedge wb_clk_i) $rose(i7_wb_cyc_i) |-> (i7_wb_cyc_i throughout (!i7_wb_ack_o && !i7_wb_err_o)[*0:$] ##1 (i7_wb_ack_o || i7_wb_err_o));
	endproperty
	assert property(af_p1814);

	property af_p1815;
	@(posedge wb_clk_i) $rose(i7_wb_cyc_i) |-> (i7_wb_cyc_i && $stable(i7_wb_adr_i)) throughout (!i7_wb_ack_o)[*0:$] ##1 i7_wb_ack_o;
	endproperty
	assert property(af_p1815);

	property af_p1816;
	@(posedge wb_clk_i) (!i7_wb_cyc_i) |-> (!i7_wb_ack_o && !i7_wb_err_o);
	endproperty
	assert property(af_p1816);

	property af_p1817;
	@(posedge wb_clk_i) $rose(i7_wb_err_o) |=> !i7_wb_cyc_i;
	endproperty
	assert property(af_p1817);

	property af_p1818;
	@(posedge wb_clk_i) (!i7_wb_cyc_i) |-> (!i7_wb_stb_i);
	endproperty
	assert property(af_p1818);

	property af_p1819;
	@(posedge wb_clk_i) $rose(i7_wb_cyc_i) |-> $fell(wb_rst_i) || !wb_rst_i;
	endproperty
	assert property(af_p1819);

	property af_p1820;
	@(posedge wb_clk_i) (i7_wb_cyc_i && !i7_wb_ack_o) |=> i7_wb_cyc_i;
	endproperty
	assert property(af_p1820);

	property af_p1821;
	@(posedge wb_clk_i) $fell(i7_wb_cyc_i) |-> ##1 1;
	endproperty
	assert property(af_p1821);

	property af_p1822;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i7_wb_cyc_i == 1'b0)[*3];
	endproperty
	assert property(af_p1822);

	property af_p1823;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i7_wb_cyc_i == 1'b0);
	endproperty
	assert property(af_p1823);

	property af_p1824;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!i7_wb_cyc_i ##1 !i7_wb_cyc_i);
	endproperty
	assert property(af_p1824);

	property af_p1825;
	@(posedge wb_clk_i) disable iff (wb_rst_i) 1 |-> !$isunknown(i7_wb_cyc_i);
	endproperty
	assert property(af_p1825);

	property af_p1826;
	@(posedge wb_clk_i) (!i7_wb_cyc_i && i7_wb_err_o) |-> ##0 !i7_wb_cyc_i;
	endproperty
	assert property(af_p1826);

	property af_p1827;
	@(posedge wb_clk_i) $rose(i7_wb_cyc_i) |-> ##1 i7_wb_cyc_i ##0 !$isunknown(i7_wb_we_i);
	endproperty
	assert property(af_p1827);

	property af_p1828;
	@(posedge wb_clk_i) (i7_wb_cyc_i && !i7_wb_we_i) |-> (!$isunknown(i7_wb_dat_o) until_with i7_wb_ack_o);
	endproperty
	assert property(af_p1828);


	property af_p1830;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_we_i) |-> i7_wb_adr_i throughout (!i7_wb_ack_o)[->1];
	endproperty
	assert property(af_p1830);

	property af_p1831;
	@(posedge wb_clk_i) $rose(i7_wb_ack_o) |-> ##1 !i7_wb_cyc_i;
	endproperty
	assert property(af_p1831);

	property af_p1832;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i && i7_wb_we_i) |-> ##1 !$isunknown(i7_wb_dat_i);
	endproperty
	assert property(af_p1832);

	property af_p1833;
	@(posedge wb_clk_i) ($rose(i7_wb_cyc_i) && i7_wb_stb_i) |-> (i7_wb_cyc_i && i7_wb_stb_i) throughout i7_wb_ack_o[->1];
	endproperty
	assert property(af_p1833);

	property af_p1834;
	@(posedge wb_clk_i) i7_wb_cyc_i |-> i7_wb_stb_i;
	endproperty
	assert property(af_p1834);

	property af_p1835;
	@(posedge wb_clk_i) $rose(i7_wb_cyc_i) |-> ($stable(i7_wb_sel_i) && i7_wb_cyc_i) throughout i7_wb_ack_o[->1];
	endproperty
	assert property(af_p1835);

	property af_p1836;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i7_wb_cyc_i ##1 !i7_wb_cyc_i ##1 !i7_wb_cyc_i);
	endproperty
	assert property(af_p1836);

	property af_p1837;
	@(posedge wb_clk_i) i7_wb_err_o |-> i7_wb_cyc_i;
	endproperty
	assert property(af_p1837);

	property af_p1838;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> !i7_wb_cyc_i;
	endproperty
	assert property(af_p1838);

	property af_p1839;
	@(posedge wb_clk_i) $rose(i7_wb_cyc_i) |-> i7_wb_stb_i;
	endproperty
	assert property(af_p1839);

	property af_p1840;
	@(posedge wb_clk_i) $rose(i7_wb_cyc_i) |-> ($past(!wb_rst_i) && !wb_rst_i);
	endproperty
	assert property(af_p1840);

	property af_p1841;
	@(posedge wb_clk_i) $rose(i7_wb_cyc_i) |-> i7_wb_cyc_i throughout i7_wb_ack_o[->1];
	endproperty
	assert property(af_p1841);

	property af_p1842;
	@(posedge wb_clk_i) ($onehot(i7_wb_sel_i)) |=> ((i7_wb_dat_i >= 50) && (i7_wb_dat_i <= 200))[*2];
	endproperty
	assert property(af_p1842);

	property af_p1843;
	@(posedge wb_clk_i) (i7_wb_ack_o) |=> ($stable(i7_wb_dat_i) until_with i7_wb_ack_o);
	endproperty
	assert property(af_p1843);

	property af_p1844;
	@(posedge wb_clk_i) ((i7_wb_ack_o) && (i7_wb_dat_i >= 10) && (i7_wb_dat_i <= 20)) |-> ##[1:2] ((i7_wb_dat_i >= 200) && (i7_wb_dat_i <= 255));
	endproperty
	assert property(af_p1844);

	property af_p1845;
	@(posedge wb_clk_i) ((i7_wb_dat_i >= 100) && (i7_wb_dat_i <= 200)) |=> ((i7_wb_dat_i >= 80) && (i7_wb_dat_i <= 220));
	endproperty
	assert property(af_p1845);

	property af_p1846;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##3 ((i7_wb_dat_i >= 83) && (i7_wb_dat_i <= 165));
	endproperty
	assert property(af_p1846);

	property af_p1847;
	@(posedge wb_clk_i) (!i7_wb_we_i && i7_wb_ack_o) |-> (!$isunknown(i7_wb_dat_i));
	endproperty
	assert property(af_p1847);

	property af_p1848;
	@(posedge wb_clk_i) (i7_wb_cyc_i && (i7_wb_dat_i >= 100) && (i7_wb_dat_i <= 150)) |=> ((i7_wb_dat_i >= 90) && (i7_wb_dat_i <= 160));
	endproperty
	assert property(af_p1848);

	property af_p1849;
	@(posedge wb_clk_i) ((i7_wb_dat_i >= 230) && (i7_wb_dat_i <= 255)) |=> ((i7_wb_dat_i >= 205) && (i7_wb_dat_i <= 255));
	endproperty
	assert property(af_p1849);

	property af_p1850;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##3 ((i7_wb_dat_i >= 0) && (i7_wb_dat_i <= 255));
	endproperty
	assert property(af_p1850);

	property af_p1851;
	@(posedge wb_clk_i) ((i7_wb_dat_i >= 64) && (i7_wb_dat_i <= 127)) |=> ((i7_wb_dat_i >= 32) && (i7_wb_dat_i <= 191));
	endproperty
	assert property(af_p1851);

	property af_p1852;
	@(posedge wb_clk_i) disable iff (!i7_wb_ack_o) (1'b1) |-> (!$isunknown(i7_wb_dat_i));
	endproperty
	assert property(af_p1852);

	property af_p1853;
	@(posedge wb_clk_i) (i7_wb_we_i) |-> (i7_wb_dat_i >= 0) && (i7_wb_dat_i <= 255);
	endproperty
	assert property(af_p1853);

	property af_p1854;
	@(posedge wb_clk_i) (!i7_wb_we_i) |-> (i7_wb_dat_i >= 0) && (i7_wb_dat_i <= 255);
	endproperty
	assert property(af_p1854);

	property af_p1855;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (i7_wb_dat_i >= 0) && (i7_wb_dat_i <= 255);
	endproperty
	assert property(af_p1855);

	property af_p1856;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (i7_wb_dat_i >= 0) && (i7_wb_dat_i <= 45);
	endproperty
	assert property(af_p1856);

	property af_p1857;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (i7_wb_dat_i >= 0) && (i7_wb_dat_i <= 255);
	endproperty
	assert property(af_p1857);

	property af_p1858;
	@(posedge wb_clk_i) $rose(i7_wb_err_o) |=> $stable(i7_wb_dat_i);
	endproperty
	assert property(af_p1858);

	property af_p1859;
	@(posedge wb_clk_i) (!i7_wb_cyc_i) |-> !$isunknown(i7_wb_dat_i) || 1;
	endproperty
	assert property(af_p1859);

	property af_p1860;
	@(posedge wb_clk_i) $changed(i7_wb_adr_i) |-> ##[1:2] (i7_wb_dat_i >= 100) && (i7_wb_dat_i <= 150);
	endproperty
	assert property(af_p1860);

	property af_p1861;
	@(posedge wb_clk_i) (i7_wb_sel_i) |-> $stable(i7_wb_dat_i);
	endproperty
	assert property(af_p1861);

	property af_p1862;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i && !i7_wb_ack_o) |=> $stable(i7_wb_dat_i) throughout (i7_wb_cyc_i && i7_wb_stb_i && !i7_wb_ack_o)[->1];
	endproperty
	assert property(af_p1862);

	property af_p1863;
	@(posedge wb_clk_i) ((i7_wb_dat_i >= 50) && (i7_wb_dat_i <= 75)) |=> (i7_wb_dat_i >= 30) && (i7_wb_dat_i <= 90);
	endproperty
	assert property(af_p1863);

	property af_p1864;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (i7_wb_dat_i == 0) throughout wb_rst_i[->1];
	endproperty
	assert property(af_p1864);

	property af_p1865;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 ((i7_wb_dat_i >= 10) && (i7_wb_dat_i <= 245));
	endproperty
	assert property(af_p1865);

	property af_p1866;
	@(posedge wb_clk_i) ((i7_wb_dat_i >= 138) && (i7_wb_dat_i <= 153)) |=> (i7_wb_dat_i >= 98) && (i7_wb_dat_i <= 153);
	endproperty
	assert property(af_p1866);

	property af_p1867;
	@(posedge wb_clk_i) (i7_wb_stb_i && i7_wb_cyc_i && !i7_wb_ack_o) |=> $stable(i7_wb_dat_i) throughout (i7_wb_stb_i && i7_wb_cyc_i && !i7_wb_ack_o)[->1];
	endproperty
	assert property(af_p1867);

	property af_p1868;
	@(posedge wb_clk_i) (i7_wb_stb_i && i7_wb_cyc_i) |=> $stable(i7_wb_dat_i);
	endproperty
	assert property(af_p1868);

	property af_p1869;
	@(posedge wb_clk_i) (wb_rst_i) |=> $stable(i7_wb_dat_i);
	endproperty
	assert property(af_p1869);

	property af_p1870;
	@(posedge wb_clk_i) ((i7_wb_dat_i >= 200) && (i7_wb_dat_i <= 255)) |=> (i7_wb_dat_i >= 180) && (i7_wb_dat_i <= 255);
	endproperty
	assert property(af_p1870);

	property af_p1871;
	@(posedge wb_clk_i) (wb_rst_i == 1'b0) |-> (i7_wb_dat_i >= 0) && (i7_wb_dat_i <= 255);
	endproperty
	assert property(af_p1871);

	property af_p1872;
	@(posedge wb_clk_i) (!i7_wb_ack_o) |-> $stable(i7_wb_dat_o);
	endproperty
	assert property(af_p1872);

	property af_p1873;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ((i7_wb_dat_o >= 0) && (i7_wb_dat_o <= 255)) [*3];
	endproperty
	assert property(af_p1873);

	property af_p1874;
	@(posedge wb_clk_i) (i7_wb_stb_i && i7_wb_cyc_i) |-> ##[0:1] (!$isunknown(i7_wb_dat_o) && (i7_wb_dat_o >= 0) && (i7_wb_dat_o <= 255));
	endproperty
	assert property(af_p1874);

	property af_p1875;
	@(posedge wb_clk_i) i7_wb_err_o |=> $stable(i7_wb_dat_o);
	endproperty
	assert property(af_p1875);

	property af_p1876;
	@(posedge wb_clk_i) ($changed(i7_wb_adr_i) && i7_wb_cyc_i) |-> ##[0:1] ((i7_wb_dat_o >= 0) && (i7_wb_dat_o <= 255));
	endproperty
	assert property(af_p1876);

	property af_p1877;
	@(posedge wb_clk_i) i7_wb_err_o |-> $stable(i7_wb_dat_o);
	endproperty
	assert property(af_p1877);

	property af_p1878;
	@(posedge wb_clk_i) ((i7_wb_dat_o >= 138) && (i7_wb_dat_o <= 153)) |=> ((i7_wb_dat_o >= 98) && (i7_wb_dat_o <= 153));
	endproperty
	assert property(af_p1878);

	property af_p1879;
	@(posedge wb_clk_i) wb_rst_i |-> (i7_wb_dat_o == 0);
	endproperty
	assert property(af_p1879);

	property af_p1880;
	@(posedge wb_clk_i) $fell(i7_wb_stb_i) |-> ##1 $stable(i7_wb_dat_o);
	endproperty
	assert property(af_p1880);

	property af_p1881;
	@(posedge wb_clk_i) (i7_wb_we_i && i7_wb_ack_o) |=> $stable(i7_wb_dat_o);
	endproperty
	assert property(af_p1881);

	property af_p1882;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (i7_wb_dat_o == 0) [*2];
	endproperty
	assert property(af_p1882);

	property af_p1883;
	@(posedge wb_clk_i) (i7_wb_ack_o) |-> ($stable(i7_wb_dat_o) && (i7_wb_dat_o >= 0) && (i7_wb_dat_o <= 255));
	endproperty
	assert property(af_p1883);

	property af_p1884;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 ((i7_wb_dat_o >= 83) && (i7_wb_dat_o <= 165));
	endproperty
	assert property(af_p1884);

	property af_p1885;
	@(posedge wb_clk_i) (i7_wb_ack_o && i7_wb_stb_i && i7_wb_cyc_i) |=> $stable(i7_wb_dat_o);
	endproperty
	assert property(af_p1885);

	property af_p1886;
	@(posedge wb_clk_i) ((i7_wb_dat_o >= 230) && (i7_wb_dat_o <= 255)) |=> ((i7_wb_dat_o >= 205) && (i7_wb_dat_o <= 255));
	endproperty
	assert property(af_p1886);

	property af_p1887;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((i7_wb_dat_o >= 0) && (i7_wb_dat_o <= 255));
	endproperty
	assert property(af_p1887);

	property af_p1888;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> $stable(i7_wb_dat_o);
	endproperty
	assert property(af_p1888);

	property af_p1889;
	@(posedge wb_clk_i) (i7_wb_ack_o && (i7_wb_sel_i != '0)) |=> ($stable(i7_wb_dat_o) && (i7_wb_dat_o >= 0) && (i7_wb_dat_o <= 255));
	endproperty
	assert property(af_p1889);

	property af_p1890;
	@(posedge wb_clk_i) (!i7_wb_we_i && i7_wb_ack_o) |=> $stable(i7_wb_dat_o);
	endproperty
	assert property(af_p1890);

	property af_p1891;
	@(posedge wb_clk_i) (!i7_wb_stb_i && !i7_wb_cyc_i) |-> $stable(i7_wb_dat_o);
	endproperty
	assert property(af_p1891);

	property af_p1892;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i && $changed(i7_wb_adr_i)) |=> $changed(i7_wb_dat_o);
	endproperty
	assert property(af_p1892);

	property af_p1893;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i && !i7_wb_we_i && i7_wb_ack_o) |=> !$isunknown(i7_wb_dat_o);
	endproperty
	assert property(af_p1893);

	property af_p1894;
	@(posedge wb_clk_i) (!i7_wb_cyc_i) |-> $stable(i7_wb_dat_o);
	endproperty
	assert property(af_p1894);

	property af_p1895;
	@(posedge wb_clk_i) (!i7_wb_we_i) |-> !$isunknown(i7_wb_dat_o);
	endproperty
	assert property(af_p1895);

	property af_p1896;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i && !i7_wb_we_i && i7_wb_ack_o) |=> !$stable(i7_wb_dat_o) && !$isunknown(i7_wb_dat_o);
	endproperty
	assert property(af_p1896);

	property af_p1897;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 (i7_wb_dat_o >= 0 && i7_wb_dat_o <= 45);
	endproperty
	assert property(af_p1897);

	property af_p1898;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i && i7_wb_ack_o) |=> !$isunknown(i7_wb_dat_o);
	endproperty
	assert property(af_p1898);

	property af_p1899;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i) |-> $stable(i7_wb_dat_o) throughout (##1 1);
	endproperty
	assert property(af_p1899);

	property af_p1900;
	@(posedge wb_clk_i) (i7_wb_err_o) |-> ##1 $stable(i7_wb_dat_o);
	endproperty
	assert property(af_p1900);

	property af_p1901;
	@(posedge wb_clk_i) (!i7_wb_cyc_i) |=> $stable(i7_wb_dat_o);
	endproperty
	assert property(af_p1901);

	property af_p1902;
	@(posedge wb_clk_i) (!wb_rst_i) |-> !$isunknown(i7_wb_dat_o);
	endproperty
	assert property(af_p1902);

	property af_p1903;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 !i7_wb_err_o;
	endproperty
	assert property(af_p1903);

	property af_p1904;
	@(posedge wb_clk_i) (i7_wb_stb_i && (i7_wb_sel_i != '0)) |-> !i7_wb_err_o;
	endproperty
	assert property(af_p1904);

	property af_p1905;
	@(posedge wb_clk_i) $rose(i7_wb_cyc_i && i7_wb_stb_i) |-> !i7_wb_err_o;
	endproperty
	assert property(af_p1905);

	property af_p1906;
	@(posedge wb_clk_i) !i7_wb_stb_i |-> !i7_wb_err_o;
	endproperty
	assert property(af_p1906);

	property af_p1907;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i7_wb_err_o;
	endproperty
	assert property(af_p1907);

	property af_p1908;
	@(posedge wb_clk_i) wb_rst_i |-> !i7_wb_err_o;
	endproperty
	assert property(af_p1908);


	property af_p1910;
	@(posedge wb_clk_i) !i7_wb_cyc_i |-> !i7_wb_err_o;
	endproperty
	assert property(af_p1910);

	property af_p1911;
	@(posedge wb_clk_i) i7_wb_err_o |=> !i7_wb_ack_o;
	endproperty
	assert property(af_p1911);

	property af_p1912;
	@(posedge wb_clk_i) $changed(i7_wb_err_o) |-> i7_wb_cyc_i;
	endproperty
	assert property(af_p1912);

	property af_p1913;
	@(posedge wb_clk_i) i7_wb_err_o |=> !i7_wb_err_o;
	endproperty
	assert property(af_p1913);

	property af_p1914;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i7_wb_err_o)[*4];
	endproperty
	assert property(af_p1914);

	property af_p1915;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i && i7_wb_err_o) |=> !i7_wb_err_o;
	endproperty
	assert property(af_p1915);

	property af_p1916;
	@(posedge wb_clk_i) $rose(i7_wb_err_o) |-> $stable(i7_wb_dat_o);
	endproperty
	assert property(af_p1916);


	property af_p1918;
	@(posedge wb_clk_i) ((i7_wb_sel_i == '0) && i7_wb_cyc_i && i7_wb_stb_i) |-> i7_wb_err_o;
	endproperty
	assert property(af_p1918);

	property af_p1919;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i && i7_wb_we_i && (i7_wb_sel_i != '0)) |-> !i7_wb_err_o;
	endproperty
	assert property(af_p1919);

	property af_p1920;
	@(posedge wb_clk_i) (!i7_wb_cyc_i && !i7_wb_stb_i) |-> !i7_wb_err_o;
	endproperty
	assert property(af_p1920);

	property af_p1921;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> !i7_wb_err_o;
	endproperty
	assert property(af_p1921);

	property af_p1922;
	@(posedge wb_clk_i) i7_wb_err_o |-> (i7_wb_cyc_i && i7_wb_stb_i);
	endproperty
	assert property(af_p1922);

	property af_p1923;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i7_wb_err_o[*3];
	endproperty
	assert property(af_p1923);

	property af_p1924;
	@(posedge wb_clk_i) i7_wb_err_o |-> !i7_wb_ack_o;
	endproperty
	assert property(af_p1924);

	property af_p1925;
	@(posedge wb_clk_i) !(i7_wb_err_o && i7_wb_ack_o);
	endproperty
	assert property(af_p1925);

	property af_p1926;
	@(posedge wb_clk_i) $rose(i7_wb_err_o) |-> ##1 (wb_clk_i === 1'b1);
	endproperty
	assert property(af_p1926);


	property af_p1928;
	@(posedge wb_clk_i) i7_wb_err_o |-> i7_wb_cyc_i;
	endproperty
	assert property(af_p1928);

	property af_p1929;
	@(posedge wb_clk_i) i7_wb_ack_o |-> !i7_wb_err_o;
	endproperty
	assert property(af_p1929);

	property af_p1930;
	@(posedge wb_clk_i) (i7_wb_we_i && (i7_wb_adr_i inside {[32'h0000_0000:32'hFFFF_FFFF]})) |-> !i7_wb_err_o;
	endproperty
	assert property(af_p1930);

	property af_p1931;
	@(posedge wb_clk_i) (i7_wb_stb_i && i7_wb_cyc_i) |-> $stable(i7_wb_sel_i);
	endproperty
	assert property(af_p1931);

	property af_p1932;
	@(posedge wb_clk_i) (i7_wb_we_i && (i7_wb_sel_i inside {[0:15]})) |-> ((i7_wb_sel_i[0] -> !$isunknown(i7_wb_dat_i[7:0])) && (i7_wb_sel_i[1] -> !$isunknown(i7_wb_dat_i[15:8])) && (i7_wb_sel_i[2] -> !$isunknown(i7_wb_dat_i[23:16])) && (i7_wb_sel_i[3] -> !$isunknown(i7_wb_dat_i[31:24])));
	endproperty
	assert property(af_p1932);

	property af_p1933;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((i7_wb_sel_i >= 0) && (i7_wb_sel_i <= 15));
	endproperty
	assert property(af_p1933);

	property af_p1934;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##[1:4] ((i7_wb_sel_i >= 0) && (i7_wb_sel_i <= 15));
	endproperty
	assert property(af_p1934);

	property af_p1935;
	@(posedge wb_clk_i) (i7_wb_we_i) |-> ($stable(i7_wb_sel_i) && (i7_wb_sel_i >= 0) && (i7_wb_sel_i <= 15));
	endproperty
	assert property(af_p1935);

	property af_p1936;
	@(posedge wb_clk_i) (wb_rst_i) |-> (i7_wb_sel_i == 4'b0000);
	endproperty
	assert property(af_p1936);

	property af_p1937;
	@(posedge wb_clk_i) (i7_wb_stb_i && i7_wb_cyc_i) |-> ((i7_wb_sel_i != 0) throughout ((!i7_wb_ack_o)[*0:$] ##1 i7_wb_ack_o));
	endproperty
	assert property(af_p1937);

	property af_p1938;
	@(posedge wb_clk_i) ((i7_wb_sel_i >= 4) && (i7_wb_sel_i <= 15)) |-> ($stable(i7_wb_sel_i) throughout ((!i7_wb_ack_o)[*0:$] ##1 i7_wb_ack_o));
	endproperty
	assert property(af_p1938);

	property af_p1939;
	@(posedge wb_clk_i) (i7_wb_stb_i && i7_wb_cyc_i) |-> ($stable(i7_wb_sel_i) && (i7_wb_sel_i >= 0) && (i7_wb_sel_i <= 15));
	endproperty
	assert property(af_p1939);

	property af_p1940;
	@(posedge wb_clk_i) (i7_wb_cyc_i) |-> ($stable(i7_wb_sel_i) throughout ((!i7_wb_ack_o)[*0:$] ##1 i7_wb_ack_o));
	endproperty
	assert property(af_p1940);

	property af_p1941;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |=> (i7_wb_sel_i == 4'b0000);
	endproperty
	assert property(af_p1941);

	property af_p1942;
	@(posedge wb_clk_i) (i7_wb_stb_i && !i7_wb_ack_o) |-> $stable(i7_wb_sel_i);
	endproperty
	assert property(af_p1942);

	property af_p1943;
	@(posedge wb_clk_i) (i7_wb_cyc_i) |-> ((i7_wb_sel_i >= 0) && (i7_wb_sel_i <= 15));
	endproperty
	assert property(af_p1943);

	property af_p1944;
	@(posedge wb_clk_i) (i7_wb_stb_i && i7_wb_cyc_i) |-> (!$isunknown(i7_wb_sel_i));
	endproperty
	assert property(af_p1944);

	property af_p1945;
	@(posedge wb_clk_i) ((i7_wb_sel_i >= 1) && (i7_wb_sel_i <= 7)) |=> ((i7_wb_sel_i >= 0) && (i7_wb_sel_i <= 15));
	endproperty
	assert property(af_p1945);

	property af_p1946;
	@(posedge wb_clk_i) (i7_wb_cyc_i) |-> ((i7_wb_sel_i >= 1) && (i7_wb_sel_i <= 15));
	endproperty
	assert property(af_p1946);

	property af_p1947;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 ((i7_wb_sel_i >= 0) && (i7_wb_sel_i <= 15));
	endproperty
	assert property(af_p1947);

	property af_p1948;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:2] ((i7_wb_sel_i >= 0) && (i7_wb_sel_i <= 15));
	endproperty
	assert property(af_p1948);

	property af_p1949;
	@(posedge wb_clk_i) (i7_wb_stb_i && (i7_wb_sel_i >= 1) && (i7_wb_sel_i <= 15)) |=> ((i7_wb_sel_i >= 0) && (i7_wb_sel_i <= 15));
	endproperty
	assert property(af_p1949);

	property af_p1950;
	@(posedge wb_clk_i) (i7_wb_we_i && (i7_wb_sel_i >= 1) && (i7_wb_sel_i <= 15)) |-> (!$isunknown(i7_wb_dat_i));
	endproperty
	assert property(af_p1950);

	property af_p1951;
	@(posedge wb_clk_i) (!wb_rst_i && (i7_wb_sel_i >= 0) && (i7_wb_sel_i <= 15)) |-> ((i7_wb_sel_i >= 0) && (i7_wb_sel_i <= 15))[*5];
	endproperty
	assert property(af_p1951);

	property af_p1952;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i) |-> !$isunknown(i7_wb_sel_i);
	endproperty
	assert property(af_p1952);

	property af_p1953;
	@(posedge wb_clk_i) ((i7_wb_sel_i >= 8) && (i7_wb_sel_i <= 15)) |-> ##1 ((i7_wb_sel_i >= 4) && (i7_wb_sel_i <= 15));
	endproperty
	assert property(af_p1953);

	property af_p1954;
	@(posedge wb_clk_i) $rose(i7_wb_stb_i) |-> (i7_wb_sel_i inside {[0:15]});
	endproperty
	assert property(af_p1954);

	property af_p1955;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i7_wb_sel_i == 4'b0) until i7_wb_stb_i;
	endproperty
	assert property(af_p1955);

	property af_p1956;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((i7_wb_sel_i >= 0) && (i7_wb_sel_i <= 15));
	endproperty
	assert property(af_p1956);

	property af_p1957;
	@(posedge wb_clk_i) !i7_wb_cyc_i |-> (i7_wb_ack_o == 1'b0);
	endproperty
	assert property(af_p1957);

	property af_p1958;
	@(posedge wb_clk_i) (i7_wb_stb_i && i7_wb_ack_o) |-> $stable(i7_wb_sel_i);
	endproperty
	assert property(af_p1958);

	property af_p1959;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i7_wb_sel_i)[*1:3] until i7_wb_stb_i;
	endproperty
	assert property(af_p1959);

	property af_p1960;
	@(posedge wb_clk_i) i7_wb_cyc_i |-> $stable(i7_wb_sel_i);
	endproperty
	assert property(af_p1960);

	property af_p1961;
	@(posedge wb_clk_i) $rose(i7_wb_stb_i) |-> ##1 $stable(i7_wb_sel_i) ##1 $stable(i7_wb_sel_i);
	endproperty
	assert property(af_p1961);

	property af_p1962;
	@(posedge wb_clk_i) i7_wb_err_o |-> !i7_wb_stb_i;
	endproperty
	assert property(af_p1962);

	property af_p1963;
	@(posedge wb_clk_i) i7_wb_stb_i |-> (i7_wb_stb_i until (i7_wb_ack_o || i7_wb_err_o));
	endproperty
	assert property(af_p1963);

	property af_p1964;
	@(posedge wb_clk_i) i7_wb_stb_i |-> i7_wb_cyc_i;
	endproperty
	assert property(af_p1964);

	property af_p1965;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!i7_wb_stb_i ##1 !i7_wb_stb_i);
	endproperty
	assert property(af_p1965);

	property af_p1966;
	@(posedge wb_clk_i) (i7_wb_stb_i && i7_wb_we_i) |-> ($stable(i7_wb_adr_i) until_with !i7_wb_stb_i);
	endproperty
	assert property(af_p1966);

	property af_p1967;
	@(posedge wb_clk_i) i7_wb_stb_i |-> ##[0:16] (i7_wb_ack_o || i7_wb_err_o);
	endproperty
	assert property(af_p1967);

	property af_p1968;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !i7_wb_stb_i;
	endproperty
	assert property(af_p1968);

	property af_p1969;
	@(posedge wb_clk_i) (i7_wb_stb_i && i7_wb_cyc_i) |-> ##[1:16] i7_wb_ack_o;
	endproperty
	assert property(af_p1969);

	property af_p1970;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i7_wb_stb_i ##1 !i7_wb_stb_i);
	endproperty
	assert property(af_p1970);

	property af_p1971;
	@(posedge wb_clk_i) i7_wb_ack_o |=> !i7_wb_stb_i;
	endproperty
	assert property(af_p1971);

	property af_p1972;
	@(posedge wb_clk_i) (i7_wb_stb_i && !i7_wb_ack_o) |=> $stable(i7_wb_adr_i);
	endproperty
	assert property(af_p1972);

	property af_p1973;
	@(posedge wb_clk_i) (i7_wb_stb_i) |-> (i7_wb_cyc_i);
	endproperty
	assert property(af_p1973);

	property af_p1974;
	@(posedge wb_clk_i) (i7_wb_stb_i && i7_wb_ack_o) |-> (!$past(i7_wb_stb_i) || $past(i7_wb_ack_o));
	endproperty
	assert property(af_p1974);

	property af_p1975;
	@(posedge wb_clk_i) (i7_wb_stb_i && i7_wb_we_i) |-> (i7_wb_dat_i !== 'x);
	endproperty
	assert property(af_p1975);

	property af_p1976;
	@(posedge wb_clk_i) (i7_wb_stb_i) |-> (!wb_rst_i);
	endproperty
	assert property(af_p1976);

	property af_p1977;
	@(posedge wb_clk_i) (!i7_wb_cyc_i) |-> $stable(i7_wb_stb_i);
	endproperty
	assert property(af_p1977);

	property af_p1978;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (!i7_wb_stb_i);
	endproperty
	assert property(af_p1978);

	property af_p1979;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(i7_wb_stb_i);
	endproperty
	assert property(af_p1979);

	property af_p1980;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!i7_wb_stb_i);
	endproperty
	assert property(af_p1980);

	property af_p1981;
	@(posedge wb_clk_i) (i7_wb_stb_i) |-> (i7_wb_adr_i !== 'x);
	endproperty
	assert property(af_p1981);

	property af_p1982;
	@(posedge wb_clk_i) (i7_wb_cyc_i) |-> (i7_wb_stb_i);
	endproperty
	assert property(af_p1982);

	property af_p1983;
	@(posedge wb_clk_i) (i7_wb_stb_i && !i7_wb_ack_o) |=> i7_wb_stb_i;
	endproperty
	assert property(af_p1983);

	property af_p1984;
	@(posedge wb_clk_i) (i7_wb_stb_i && i7_wb_we_i) |-> $stable(i7_wb_dat_i);
	endproperty
	assert property(af_p1984);

	property af_p1985;
	@(posedge wb_clk_i) (i7_wb_stb_i && !i7_wb_ack_o && !i7_wb_err_o) |=> i7_wb_stb_i;
	endproperty
	assert property(af_p1985);

	property af_p1986;
	@(posedge wb_clk_i) !i7_wb_ack_o |-> $stable(i7_wb_stb_i);
	endproperty
	assert property(af_p1986);

	property af_p1987;
	@(posedge wb_clk_i) i7_wb_stb_i |-> ##[0:15] i7_wb_ack_o;
	endproperty
	assert property(af_p1987);

	property af_p1988;
	@(posedge wb_clk_i) wb_rst_i |-> !i7_wb_stb_i;
	endproperty
	assert property(af_p1988);

	property af_p1989;
	@(posedge wb_clk_i) $rose(i7_wb_stb_i) |-> i7_wb_cyc_i;
	endproperty
	assert property(af_p1989);

	property af_p1990;
	@(posedge wb_clk_i) (i7_wb_stb_i && i7_wb_cyc_i && !i7_wb_ack_o && !i7_wb_err_o) |=> i7_wb_stb_i;
	endproperty
	assert property(af_p1990);

	property af_p1991;
	@(posedge wb_clk_i) i7_wb_stb_i |-> (i7_wb_sel_i != 0);
	endproperty
	assert property(af_p1991);

	property af_p1992;
	@(posedge wb_clk_i) (i7_wb_ack_o) |=> (!i7_wb_ack_o || $stable(i7_wb_we_i));
	endproperty
	assert property(af_p1992);

	property af_p1993;
	@(posedge wb_clk_i) (i7_wb_we_i && i7_wb_cyc_i) |-> (i7_wb_stb_i);
	endproperty
	assert property(af_p1993);

	property af_p1994;
	@(posedge wb_clk_i) (i7_wb_we_i && i7_wb_stb_i && i7_wb_cyc_i) |-> ##[1:8] i7_wb_ack_o;
	endproperty
	assert property(af_p1994);

	property af_p1995;
	@(posedge wb_clk_i) ($rose(i7_wb_we_i)) |-> (i7_wb_stb_i);
	endproperty
	assert property(af_p1995);

	property af_p1996;
	@(posedge wb_clk_i) (1'b1) |-> (!$isunknown(i7_wb_we_i));
	endproperty
	assert property(af_p1996);

	property af_p1997;
	@(posedge wb_clk_i) (!i7_wb_cyc_i) |-> (!(i7_wb_stb_i && i7_wb_we_i));
	endproperty
	assert property(af_p1997);

	property af_p1998;
	@(posedge wb_clk_i) disable iff (!i7_wb_cyc_i) (i7_wb_cyc_i && i7_wb_stb_i && !i7_wb_ack_o) |=> $stable(i7_wb_we_i);
	endproperty
	assert property(af_p1998);

	property af_p1999;
	@(posedge wb_clk_i) disable iff (!i7_wb_cyc_i) (!i7_wb_ack_o) |=> $stable(i7_wb_we_i);
	endproperty
	assert property(af_p1999);

	property af_p2000;
	@(posedge wb_clk_i) (!i7_wb_we_i && i7_wb_ack_o) |-> (!$isunknown(i7_wb_dat_o));
	endproperty
	assert property(af_p2000);

	property af_p2001;
	@(posedge wb_clk_i) (i7_wb_we_i) |-> (!i7_wb_err_o);
	endproperty
	assert property(af_p2001);

	property af_p2002;
	@(posedge wb_clk_i) disable iff (!i7_wb_cyc_i) (i7_wb_cyc_i && i7_wb_stb_i && !i7_wb_we_i) |-> (i7_wb_we_i == 1'b0) throughout (i7_wb_ack_o[->1]);
	endproperty
	assert property(af_p2002);

	property af_p2003;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (i7_wb_we_i === 1'b0 || i7_wb_we_i === 1'b1);
	endproperty
	assert property(af_p2003);

	property af_p2004;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i) |-> $stable(i7_wb_we_i);
	endproperty
	assert property(af_p2004);

	property af_p2005;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (i7_wb_we_i === 1'b0 || i7_wb_we_i === 1'b1);
	endproperty
	assert property(af_p2005);

	property af_p2006;
	@(posedge wb_clk_i) (i7_wb_cyc_i && i7_wb_stb_i && i7_wb_we_i) |-> $stable(i7_wb_adr_i);
	endproperty
	assert property(af_p2006);

	property af_p2007;
	@(posedge wb_clk_i) $changed(i7_wb_we_i) |-> !i7_wb_cyc_i;
	endproperty
	assert property(af_p2007);

	property af_p2008;
	@(posedge wb_clk_i) (i7_wb_we_i && !i7_wb_ack_o) |-> $stable(i7_wb_adr_i);
	endproperty
	assert property(af_p2008);

	property af_p2009;
	@(posedge wb_clk_i) (i7_wb_we_i && i7_wb_stb_i && i7_wb_cyc_i && i7_wb_ack_o) |-> $stable(i7_wb_dat_i);
	endproperty
	assert property(af_p2009);

	property af_p2010;
	@(posedge wb_clk_i) (i7_wb_cyc_i && !i7_wb_ack_o) |-> $stable(i7_wb_we_i);
	endproperty
	assert property(af_p2010);

	property af_p2011;
	@(posedge wb_clk_i) (i7_wb_cyc_i && (i7_wb_sel_i != '0)) |-> i7_wb_we_i;
	endproperty
	assert property(af_p2011);

	property af_p2012;
	@(posedge wb_clk_i) (!wb_rst_i && i7_wb_cyc_i) |-> ##[1:4] $stable(i7_wb_we_i);
	endproperty
	assert property(af_p2012);

	property af_p2013;
	@(posedge wb_clk_i) i7_wb_we_i |-> i7_wb_cyc_i;
	endproperty
	assert property(af_p2013);

	property af_p2014;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i7_wb_we_i && i7_wb_cyc_i && i7_wb_stb_i) |-> (i7_wb_sel_i != '0);
	endproperty
	assert property(af_p2014);

	property af_p2015;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i7_wb_we_i && i7_wb_cyc_i) |-> !$isunknown(i7_wb_dat_i);
	endproperty
	assert property(af_p2015);

	property af_p2016;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (i7_wb_we_i == 1'b0);
	endproperty
	assert property(af_p2016);

	property af_p2017;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i7_wb_we_i && i7_wb_cyc_i && i7_wb_stb_i) |-> !i7_wb_err_o;
	endproperty
	assert property(af_p2017);

	property af_p2018;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i7_wb_we_i && i7_wb_ack_o) |-> !$isunknown(i7_wb_dat_i);
	endproperty
	assert property(af_p2018);

	property af_p2019;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (i7_wb_we_i && i7_wb_ack_o) |=> 1'b1;
	endproperty
	assert property(af_p2019);

	property af_p2020;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (!i7_wb_we_i && i7_wb_ack_o) |-> !$isunknown(i7_wb_dat_o);
	endproperty
	assert property(af_p2020);

	property af_p2021;
	@(posedge wb_clk_i) wb_rst_i |-> (i7_wb_we_i == 1'b0);
	endproperty
	assert property(af_p2021);

	property af_p2022;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (!i7_wb_we_i && i7_wb_stb_i && i7_wb_cyc_i) |-> !$isunknown(i7_wb_dat_o);
	endproperty
	assert property(af_p2022);

	property af_p2023;
	@(posedge wb_clk_i) (t0_wb_ack_i) |=> (!t0_wb_cyc_o);
	endproperty
	assert property(af_p2023);

	property af_p2024;
	@(posedge wb_clk_i) ($isunknown(t0_wb_adr_o) === 0 && t0_wb_stb_o) |-> ##[1:4] (t0_wb_ack_i);
	endproperty
	assert property(af_p2024);

	property af_p2025;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t0_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p2025);

	property af_p2026;
	@(posedge wb_clk_i) (!t0_wb_we_o && t0_wb_stb_o && t0_wb_cyc_o) |=> (t0_wb_ack_i);
	endproperty
	assert property(af_p2026);

	property af_p2027;
	@(posedge wb_clk_i) (t0_wb_we_o && t0_wb_stb_o && t0_wb_cyc_o) |-> ##[1:4] (t0_wb_ack_i);
	endproperty
	assert property(af_p2027);

	property af_p2028;
	@(posedge wb_clk_i) (t0_wb_ack_i && !t0_wb_stb_o) |=> (!t0_wb_ack_i);
	endproperty
	assert property(af_p2028);

	property af_p2029;
	@(posedge wb_clk_i) (!t0_wb_cyc_o && !t0_wb_stb_o) |-> (!t0_wb_ack_i);
	endproperty
	assert property(af_p2029);

	property af_p2030;
	@(posedge wb_clk_i) (t0_wb_ack_i && t0_wb_stb_o && t0_wb_cyc_o) |=> (!t0_wb_ack_i || (t0_wb_stb_o && t0_wb_cyc_o));
	endproperty
	assert property(af_p2030);

	property af_p2031;
	@(posedge wb_clk_i) (!t0_wb_cyc_o && !t0_wb_stb_o) |-> (!t0_wb_ack_i) [*1:$];
	endproperty
	assert property(af_p2031);

	property af_p2032;
	@(posedge wb_clk_i) ($fell(t0_wb_stb_o)) |=> (!t0_wb_ack_i);
	endproperty
	assert property(af_p2032);

	property af_p2033;
	@(posedge wb_clk_i) (t0_wb_ack_i) |-> (!$isunknown(t0_wb_dat_i));
	endproperty
	assert property(af_p2033);

	property af_p2034;
	@(posedge wb_clk_i) t0_wb_ack_i |-> ##1 (!t0_wb_ack_i || t0_wb_stb_o);
	endproperty
	assert property(af_p2034);

	property af_p2035;
	@(posedge wb_clk_i) wb_rst_i |-> !t0_wb_ack_i;
	endproperty
	assert property(af_p2035);

	property af_p2036;
	@(posedge wb_clk_i) (t0_wb_we_o && t0_wb_ack_i) |-> $stable(t0_wb_dat_o);
	endproperty
	assert property(af_p2036);

	property af_p2037;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t0_wb_ack_i ##1 !t0_wb_ack_i);
	endproperty
	assert property(af_p2037);

	property af_p2038;
	@(posedge wb_clk_i) !t0_wb_cyc_o |-> !t0_wb_ack_i;
	endproperty
	assert property(af_p2038);

	property af_p2039;
	@(posedge wb_clk_i) t0_wb_ack_i |-> (t0_wb_cyc_o && t0_wb_stb_o) || $past(t0_wb_cyc_o && t0_wb_stb_o);
	endproperty
	assert property(af_p2039);

	property af_p2040;
	@(posedge wb_clk_i) (t0_wb_cyc_o && t0_wb_stb_o) |-> ##[1:$] t0_wb_ack_i;
	endproperty
	assert property(af_p2040);

	property af_p2041;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t0_wb_ack_i;
	endproperty
	assert property(af_p2041);

	property af_p2042;
	@(posedge wb_clk_i) (t0_wb_ack_i && t0_wb_stb_o) |-> ##1 !t0_wb_ack_i;
	endproperty
	assert property(af_p2042);

	property af_p2043;
	@(posedge wb_clk_i) (t0_wb_cyc_o && t0_wb_stb_o) |-> ##[1:8] (t0_wb_ack_i);
	endproperty
	assert property(af_p2043);

	property af_p2044;
	@(posedge wb_clk_i) ($past(t0_wb_stb_o) == 0) |-> !($past(t0_wb_ack_i) == 0 && t0_wb_ack_i == 1);
	endproperty
	assert property(af_p2044);

	property af_p2045;
	@(posedge wb_clk_i) !(t0_wb_ack_i && t0_wb_err_i);
	endproperty
	assert property(af_p2045);

	property af_p2046;
	@(posedge wb_clk_i) (t0_wb_ack_i) |-> (t0_wb_dat_i !== 'x);
	endproperty
	assert property(af_p2046);

	property af_p2047;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:3] (t0_wb_ack_i === 1'b0 || t0_wb_ack_i === 1'b1);
	endproperty
	assert property(af_p2047);

	property af_p2048;
	@(posedge wb_clk_i) (!t0_wb_cyc_o) |-> (!t0_wb_ack_i or !$past(t0_wb_ack_i,1) == 0);
	endproperty
	assert property(af_p2048);

	property af_p2049;
	@(posedge wb_clk_i) (t0_wb_we_o && t0_wb_stb_o && t0_wb_cyc_o) |-> ##1 (t0_wb_ack_i);
	endproperty
	assert property(af_p2049);

	property af_p2050;
	@(posedge wb_clk_i) ($fell(t0_wb_ack_i)) |-> (!t0_wb_ack_i) throughout (##1 t0_wb_cyc_o[->1]);
	endproperty
	assert property(af_p2050);

	property af_p2051;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> (!t0_wb_ack_i);
	endproperty
	assert property(af_p2051);

	property af_p2052;
	@(posedge wb_clk_i) (t0_wb_ack_i) |-> (!t0_wb_err_i);
	endproperty
	assert property(af_p2052);

	property af_p2053;
	@(posedge wb_clk_i) (t0_wb_stb_o && !t0_wb_ack_i) |=> $stable(t0_wb_adr_o);
	endproperty
	assert property(af_p2053);

	property af_p2054;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (!$isunknown(t0_wb_adr_o));
	endproperty
	assert property(af_p2054);

	property af_p2055;
	@(posedge wb_clk_i) wb_rst_i |=> (t0_wb_adr_o == '0);
	endproperty
	assert property(af_p2055);

	property af_p2056;
	@(posedge wb_clk_i) (!t0_wb_cyc_o) |-> $stable(t0_wb_adr_o);
	endproperty
	assert property(af_p2056);

	property af_p2057;
	@(posedge wb_clk_i) t0_wb_ack_i |=> (t0_wb_stb_o -> !$isunknown(t0_wb_adr_o));
	endproperty
	assert property(af_p2057);

	property af_p2058;
	@(posedge wb_clk_i) ($fell(wb_rst_i) && t0_wb_cyc_o) |-> ##[1:2] (!$isunknown(t0_wb_adr_o));
	endproperty
	assert property(af_p2058);

	property af_p2059;
	@(posedge wb_clk_i) t0_wb_ack_i |-> $changed(t0_wb_adr_o);
	endproperty
	assert property(af_p2059);

	property af_p2060;
	@(posedge wb_clk_i) (t0_wb_stb_o && !t0_wb_ack_i) |-> $stable(t0_wb_adr_o);
	endproperty
	assert property(af_p2060);

	property af_p2061;
	@(posedge wb_clk_i) (t0_wb_cyc_o && t0_wb_stb_o && !t0_wb_ack_i) |-> $stable(t0_wb_adr_o);
	endproperty
	assert property(af_p2061);



	property af_p2064;
	@(posedge wb_clk_i) (t0_wb_cyc_o && (t0_wb_adr_o inside {[32'h0000_0000:32'hFFFF_FFFF]})) |=> (t0_wb_cyc_o |-> (t0_wb_adr_o inside {[32'h0000_0000:32'hFFFF_FFFF]}));
	endproperty
	assert property(af_p2064);

	property af_p2065;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> ($stable(t0_wb_adr_o) && !$isunknown(t0_wb_adr_o)) until t0_wb_cyc_o;
	endproperty
	assert property(af_p2065);

	property af_p2066;
	@(posedge wb_clk_i) t0_wb_cyc_o |=> !$isunknown(t0_wb_adr_o);
	endproperty
	assert property(af_p2066);

	property af_p2067;
	@(posedge wb_clk_i) t0_wb_stb_o |-> $stable(t0_wb_adr_o);
	endproperty
	assert property(af_p2067);

	property af_p2068;
	@(posedge wb_clk_i) (t0_wb_cyc_o && t0_wb_stb_o) |-> ($stable(t0_wb_adr_o) until t0_wb_ack_i);
	endproperty
	assert property(af_p2068);

	property af_p2069;
	@(posedge wb_clk_i) t0_wb_err_i |=> ($stable(t0_wb_adr_o) until !t0_wb_cyc_o);
	endproperty
	assert property(af_p2069);

	property af_p2070;
	@(posedge wb_clk_i) $fell(t0_wb_cyc_o) |=> 1'b1;
	endproperty
	assert property(af_p2070);

	property af_p2071;
	@(posedge wb_clk_i) (t0_wb_we_o && t0_wb_stb_o) |=> $stable(t0_wb_adr_o);
	endproperty
	assert property(af_p2071);

	property af_p2072;
	@(posedge wb_clk_i) disable iff (wb_rst_i) ($changed(t0_wb_adr_o)) |-> (t0_wb_stb_o);
	endproperty
	assert property(af_p2072);


	property af_p2074;
	@(posedge wb_clk_i) (t0_wb_we_o && t0_wb_cyc_o) |-> (t0_wb_adr_o !== 'x);
	endproperty
	assert property(af_p2074);

	property af_p2075;
	@(posedge wb_clk_i) (wb_rst_i) |=> (t0_wb_adr_o == '0);
	endproperty
	assert property(af_p2075);

	property af_p2076;
	@(posedge wb_clk_i) (t0_wb_cyc_o && $changed(t0_wb_adr_o)) |-> !(t0_wb_stb_o && !t0_wb_ack_i);
	endproperty
	assert property(af_p2076);

	property af_p2077;
	@(posedge wb_clk_i) disable iff (wb_rst_i) ($changed(t0_wb_adr_o)) |-> (t0_wb_cyc_o);
	endproperty
	assert property(af_p2077);

	property af_p2078;
	@(posedge wb_clk_i) (t0_wb_err_i) |-> ($stable(t0_wb_adr_o) until_with (!t0_wb_cyc_o));
	endproperty
	assert property(af_p2078);


	property af_p2080;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t0_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2080);

	property af_p2081;
	@(posedge wb_clk_i) (t0_wb_cyc_o) |-> ($stable(t0_wb_we_o));
	endproperty
	assert property(af_p2081);

	property af_p2082;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t0_wb_cyc_o);
	endproperty
	assert property(af_p2082);

	property af_p2083;
	@(posedge wb_clk_i) $rose(t0_wb_stb_o) |-> (t0_wb_cyc_o == 1'b1);
	endproperty
	assert property(af_p2083);

	property af_p2084;
	@(posedge wb_clk_i) (t0_wb_ack_i) |=> (t0_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2084);

	property af_p2085;
	@(posedge wb_clk_i) (t0_wb_err_i) |=> (t0_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2085);

	property af_p2086;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:4] (!t0_wb_cyc_o);
	endproperty
	assert property(af_p2086);

	property af_p2087;
	@(posedge wb_clk_i) $rose(t0_wb_cyc_o) |-> (t0_wb_cyc_o throughout t0_wb_ack_i[->1]);
	endproperty
	assert property(af_p2087);

	property af_p2088;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t0_wb_cyc_o);
	endproperty
	assert property(af_p2088);

	property af_p2089;
	@(posedge wb_clk_i) t0_wb_cyc_o |-> t0_wb_stb_o;
	endproperty
	assert property(af_p2089);

	property af_p2090;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (t0_wb_cyc_o !== 1'bx);
	endproperty
	assert property(af_p2090);

	property af_p2091;
	@(posedge wb_clk_i) $changed(t0_wb_cyc_o) |-> $changed(t0_wb_stb_o);
	endproperty
	assert property(af_p2091);

	property af_p2092;
	@(posedge wb_clk_i) (t0_wb_cyc_o && t0_wb_we_o) |-> !$isunknown(t0_wb_adr_o);
	endproperty
	assert property(af_p2092);

	property af_p2093;
	@(posedge wb_clk_i) t0_wb_cyc_o |-> $stable(t0_wb_sel_o);
	endproperty
	assert property(af_p2093);

	property af_p2094;
	@(posedge wb_clk_i) t0_wb_ack_i |=> !t0_wb_cyc_o;
	endproperty
	assert property(af_p2094);

	property af_p2095;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> t0_wb_cyc_o;
	endproperty
	assert property(af_p2095);

	property af_p2096;
	@(posedge wb_clk_i) t0_wb_err_i |=> !t0_wb_cyc_o;
	endproperty
	assert property(af_p2096);

	property af_p2097;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> !t0_wb_cyc_o[*2];
	endproperty
	assert property(af_p2097);

	property af_p2098;
	@(posedge wb_clk_i) t0_wb_cyc_o |-> t0_wb_cyc_o until (t0_wb_ack_i || t0_wb_err_i);
	endproperty
	assert property(af_p2098);

	property af_p2099;
	@(posedge wb_clk_i) (t0_wb_cyc_o) |-> (t0_wb_stb_o);
	endproperty
	assert property(af_p2099);

	property af_p2100;
	@(posedge wb_clk_i) (wb_rst_i) |=> (!t0_wb_cyc_o) ##1 (!t0_wb_cyc_o);
	endproperty
	assert property(af_p2100);

	property af_p2101;
	@(posedge wb_clk_i) ($rose(t0_wb_cyc_o)) |-> (t0_wb_cyc_o throughout (##[0:$] (t0_wb_ack_i || t0_wb_err_i)));
	endproperty
	assert property(af_p2101);

	property af_p2102;
	@(posedge wb_clk_i) ($rose(t0_wb_ack_i)) |-> (!t0_wb_cyc_o && !t0_wb_stb_o);
	endproperty
	assert property(af_p2102);

	property af_p2103;
	@(posedge wb_clk_i) (t0_wb_cyc_o) |-> ($stable(t0_wb_adr_o));
	endproperty
	assert property(af_p2103);

	property af_p2104;
	@(posedge wb_clk_i) (t0_wb_stb_o) |-> (t0_wb_cyc_o);
	endproperty
	assert property(af_p2104);

	property af_p2105;
	@(posedge wb_clk_i) (t0_wb_cyc_o && t0_wb_we_o) |-> ($stable(t0_wb_dat_o));
	endproperty
	assert property(af_p2105);

	property af_p2106;
	@(posedge wb_clk_i) (t0_wb_cyc_o && !t0_wb_err_i && !t0_wb_ack_i) |=> (t0_wb_cyc_o);
	endproperty
	assert property(af_p2106);

	property af_p2107;
	@(posedge wb_clk_i) ($changed(t0_wb_cyc_o) && !$past(t0_wb_ack_i) && !$past(t0_wb_err_i)) |-> (t0_wb_ack_i || t0_wb_err_i);
	endproperty
	assert property(af_p2107);

	property af_p2108;
	@(posedge wb_clk_i) (t0_wb_cyc_o) |-> ($stable(t0_wb_cyc_o) || $rose(t0_wb_cyc_o) || $fell(t0_wb_cyc_o));
	endproperty
	assert property(af_p2108);

	property af_p2109;
	@(posedge wb_clk_i) ($fell(t0_wb_ack_i) && $fell(t0_wb_err_i)) |=> (!t0_wb_cyc_o);
	endproperty
	assert property(af_p2109);

	property af_p2110;
	@(posedge wb_clk_i) (t0_wb_stb_o && !t0_wb_ack_i) |-> $stable(t0_wb_dat_i);
	endproperty
	assert property(af_p2110);

	property af_p2111;
	@(posedge wb_clk_i) ((t0_wb_dat_i >= 138) && (t0_wb_dat_i <= 153)) |-> (t0_wb_dat_i >= 98) && (t0_wb_dat_i <= 153);
	endproperty
	assert property(af_p2111);

	property af_p2112;
	@(posedge wb_clk_i) (t0_wb_cyc_o && t0_wb_stb_o && t0_wb_ack_i) |-> !$isunknown(t0_wb_dat_i);
	endproperty
	assert property(af_p2112);

	property af_p2113;
	@(posedge wb_clk_i) (!t0_wb_we_o && t0_wb_ack_i) |-> !$isunknown(t0_wb_dat_i);
	endproperty
	assert property(af_p2113);

	property af_p2114;
	@(posedge wb_clk_i) (!t0_wb_cyc_o) |-> $stable(t0_wb_dat_i);
	endproperty
	assert property(af_p2114);

	property af_p2115;
	@(posedge wb_clk_i) (t0_wb_stb_o && !$isunknown(t0_wb_adr_o)) |-> !$isunknown(t0_wb_dat_i);
	endproperty
	assert property(af_p2115);

	property af_p2116;
	@(posedge wb_clk_i) (t0_wb_cyc_o) |-> $stable(t0_wb_dat_i);
	endproperty
	assert property(af_p2116);

	property af_p2117;
	@(posedge wb_clk_i) (t0_wb_stb_o) |-> ((t0_wb_dat_i >= 50) && (t0_wb_dat_i <= 200))[*2];
	endproperty
	assert property(af_p2117);

	property af_p2118;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:2] !$isunknown(t0_wb_dat_i);
	endproperty
	assert property(af_p2118);

	property af_p2119;
	@(posedge wb_clk_i) (1'b1) |-> ($stable(t0_wb_dat_i) || $changed(t0_wb_dat_i));
	endproperty
	assert property(af_p2119);

	property af_p2120;
	@(posedge wb_clk_i) (t0_wb_err_i) |-> (1'b1);
	endproperty
	assert property(af_p2120);

	property af_p2121;
	@(posedge wb_clk_i) ($fell(wb_rst_i) && t0_wb_stb_o && t0_wb_cyc_o) |-> ##[1:3] ((t0_wb_dat_i >= 0) && (t0_wb_dat_i <= 255));
	endproperty
	assert property(af_p2121);

	property af_p2122;
	@(posedge wb_clk_i) (t0_wb_ack_i) |-> (t0_wb_dat_i >= 0) && (t0_wb_dat_i <= 255);
	endproperty
	assert property(af_p2122);

	property af_p2123;
	@(posedge wb_clk_i) (t0_wb_ack_i) |-> ((t0_wb_dat_i >= 0) && (t0_wb_dat_i <= 255)) throughout (##3 1'b1);
	endproperty
	assert property(af_p2123);

	property af_p2124;
	@(posedge wb_clk_i) (t0_wb_we_o) |-> (1'b1);
	endproperty
	assert property(af_p2124);

	property af_p2125;
	@(posedge wb_clk_i) ((t0_wb_dat_i >= 0) && (t0_wb_dat_i <= 255)) |=> ((t0_wb_dat_i >= 0) && (t0_wb_dat_i <= 255));
	endproperty
	assert property(af_p2125);

	property af_p2126;
	@(posedge wb_clk_i) (!t0_wb_ack_i) |-> ($stable(t0_wb_dat_i));
	endproperty
	assert property(af_p2126);

	property af_p2127;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:2] ((t0_wb_dat_i >= 0) && (t0_wb_dat_i <= 255));
	endproperty
	assert property(af_p2127);

	property af_p2128;
	@(posedge wb_clk_i) (wb_rst_i) |-> ($stable(t0_wb_dat_i) && (t0_wb_dat_i >= 0) && (t0_wb_dat_i <= 0));
	endproperty
	assert property(af_p2128);

	property af_p2129;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] (t0_wb_dat_i inside {[0:255]});
	endproperty
	assert property(af_p2129);

	property af_p2130;
	@(posedge wb_clk_i) t0_wb_ack_i |-> !$isunknown(t0_wb_dat_i);
	endproperty
	assert property(af_p2130);

	property af_p2131;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t0_wb_cyc_o) until_with (t0_wb_cyc_o);
	endproperty
	assert property(af_p2131);

	property af_p2132;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (t0_wb_dat_i inside {[0:255]});
	endproperty
	assert property(af_p2132);

	property af_p2133;
	@(posedge wb_clk_i) (!t0_wb_ack_i) |=> $stable(t0_wb_dat_i);
	endproperty
	assert property(af_p2133);

	property af_p2134;
	@(posedge wb_clk_i) t0_wb_err_i |-> 1'b1;
	endproperty
	assert property(af_p2134);

	property af_p2135;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t0_wb_dat_i inside {[0:255]});
	endproperty
	assert property(af_p2135);

	property af_p2136;
	@(posedge wb_clk_i) (!t0_wb_we_o && t0_wb_ack_i) |=> (t0_wb_dat_i inside {[0:255]});
	endproperty
	assert property(af_p2136);

	property af_p2137;
	@(posedge wb_clk_i) (t0_wb_cyc_o && t0_wb_stb_o) |-> !$isunknown(t0_wb_dat_i);
	endproperty
	assert property(af_p2137);

	property af_p2138;
	@(posedge wb_clk_i) $rose(t0_wb_ack_i) |-> (t0_wb_dat_i inside {[0:255]});
	endproperty
	assert property(af_p2138);

	property af_p2139;
	@(posedge wb_clk_i) (t0_wb_we_o && t0_wb_ack_i) |-> $stable(t0_wb_dat_o);
	endproperty
	assert property(af_p2139);

	property af_p2140;
	@(posedge wb_clk_i) (t0_wb_cyc_o && t0_wb_stb_o && !t0_wb_we_o && t0_wb_ack_i) |-> (!$isunknown(t0_wb_dat_o));
	endproperty
	assert property(af_p2140);

	property af_p2141;
	@(posedge wb_clk_i) (!t0_wb_we_o && t0_wb_cyc_o && t0_wb_stb_o) |-> ##[1:3] (!$isunknown(t0_wb_dat_o));
	endproperty
	assert property(af_p2141);

	property af_p2142;
	@(posedge wb_clk_i) (t0_wb_err_i) |=> $stable(t0_wb_dat_o);
	endproperty
	assert property(af_p2142);

	property af_p2143;
	@(posedge wb_clk_i) (t0_wb_cyc_o && t0_wb_stb_o && !t0_wb_ack_i) |-> $stable(t0_wb_dat_o);
	endproperty
	assert property(af_p2143);

	property af_p2144;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (!$isunknown(t0_wb_dat_o));
	endproperty
	assert property(af_p2144);

	property af_p2145;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> (t0_wb_dat_o == '0) throughout (!t0_wb_ack_i)[*1:$];
	endproperty
	assert property(af_p2145);

	property af_p2146;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t0_wb_dat_o == '0);
	endproperty
	assert property(af_p2146);

	property af_p2147;
	@(posedge wb_clk_i) (!t0_wb_ack_i) |-> $stable(t0_wb_dat_o);
	endproperty
	assert property(af_p2147);

	property af_p2148;
	@(posedge wb_clk_i) (!t0_wb_cyc_o) |-> $stable(t0_wb_dat_o);
	endproperty
	assert property(af_p2148);

	property af_p2149;
	@(posedge wb_clk_i) ($past(t0_wb_cyc_o) && !t0_wb_cyc_o) |-> $stable(t0_wb_dat_o);
	endproperty
	assert property(af_p2149);

	property af_p2150;
	@(posedge wb_clk_i) (t0_wb_we_o) |-> ($isunknown(t0_wb_dat_o) == 0);
	endproperty
	assert property(af_p2150);

	property af_p2151;
	@(posedge wb_clk_i) (t0_wb_err_i) |-> $stable(t0_wb_dat_o);
	endproperty
	assert property(af_p2151);

	property af_p2152;
	@(posedge wb_clk_i) (t0_wb_stb_o && t0_wb_ack_i) |-> !$stable(t0_wb_dat_o);
	endproperty
	assert property(af_p2152);

	property af_p2153;
	@(posedge wb_clk_i) (t0_wb_cyc_o && t0_wb_ack_i) |-> ($isunknown(t0_wb_dat_o) == 0);
	endproperty
	assert property(af_p2153);

	property af_p2154;
	@(posedge wb_clk_i) ($past(t0_wb_stb_o) && $past(t0_wb_we_o)) |-> !$stable(t0_wb_dat_o);
	endproperty
	assert property(af_p2154);

	property af_p2155;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t0_wb_dat_o == 0);
	endproperty
	assert property(af_p2155);

	property af_p2156;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t0_wb_dat_o >= 0) && (t0_wb_dat_o <= 255);
	endproperty
	assert property(af_p2156);

	property af_p2157;
	@(posedge wb_clk_i) ($past(t0_wb_err_i)) |-> $stable(t0_wb_dat_o);
	endproperty
	assert property(af_p2157);

	property af_p2158;
	@(posedge wb_clk_i) (t0_wb_dat_o inside {[100:150]}) |=> (t0_wb_dat_o inside {[80:170]});
	endproperty
	assert property(af_p2158);

	property af_p2159;
	@(posedge wb_clk_i) (t0_wb_stb_o && t0_wb_cyc_o && !t0_wb_ack_i) |-> $stable(t0_wb_dat_o);
	endproperty
	assert property(af_p2159);

	property af_p2160;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (!(t0_wb_cyc_o && t0_wb_stb_o)) |-> $stable(t0_wb_dat_o);
	endproperty
	assert property(af_p2160);

	property af_p2161;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (t0_wb_dat_o inside {[0:127]})[*4];
	endproperty
	assert property(af_p2161);

	property af_p2162;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (t0_wb_dat_o inside {[0:255]});
	endproperty
	assert property(af_p2162);

	property af_p2163;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (t0_wb_dat_o == '0);
	endproperty
	assert property(af_p2163);

	property af_p2164;
	@(posedge wb_clk_i) (!t0_wb_stb_o) |-> $stable(t0_wb_dat_o);
	endproperty
	assert property(af_p2164);

	property af_p2165;
	@(posedge wb_clk_i) t0_wb_ack_i |-> !$isunknown(t0_wb_dat_o);
	endproperty
	assert property(af_p2165);

	property af_p2166;
	@(posedge wb_clk_i) (t0_wb_sel_o != '0) |-> $stable(t0_wb_dat_o);
	endproperty
	assert property(af_p2166);

	property af_p2167;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t0_wb_err_i)[*4];
	endproperty
	assert property(af_p2167);

	property af_p2168;
	@(posedge wb_clk_i) disable iff (wb_rst_i) $rose(!wb_rst_i) |-> (!t0_wb_err_i throughout (t0_wb_cyc_o[->1]));
	endproperty
	assert property(af_p2168);

	property af_p2169;
	@(posedge wb_clk_i) (t0_wb_err_i && t0_wb_we_o) |-> ##1 (!t0_wb_stb_o);
	endproperty
	assert property(af_p2169);

	property af_p2170;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t0_wb_err_i)[*3];
	endproperty
	assert property(af_p2170);

	property af_p2171;
	@(posedge wb_clk_i) (!t0_wb_cyc_o) |-> ($stable(t0_wb_dat_i));
	endproperty
	assert property(af_p2171);

	property af_p2172;
	@(posedge wb_clk_i) (!t0_wb_stb_o) |-> ##1 (!t0_wb_err_i);
	endproperty
	assert property(af_p2172);

	property af_p2173;
	@(posedge wb_clk_i) (t0_wb_err_i) |-> ##1 (!t0_wb_cyc_o);
	endproperty
	assert property(af_p2173);

	property af_p2174;
	@(posedge wb_clk_i) (t0_wb_err_i && t0_wb_stb_o) |-> (!t0_wb_ack_i);
	endproperty
	assert property(af_p2174);

	property af_p2175;
	@(posedge wb_clk_i) !(t0_wb_err_i && t0_wb_ack_i);
	endproperty
	assert property(af_p2175);

	property af_p2176;
	@(posedge wb_clk_i) t0_wb_err_i |-> (t0_wb_cyc_o && t0_wb_stb_o && (t0_wb_sel_o == 4'b0000));
	endproperty
	assert property(af_p2176);

	property af_p2177;
	@(posedge wb_clk_i) (t0_wb_stb_o && t0_wb_ack_i) |-> !t0_wb_err_i;
	endproperty
	assert property(af_p2177);

	property af_p2178;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t0_wb_err_i ##1 !t0_wb_err_i);
	endproperty
	assert property(af_p2178);

	property af_p2179;
	@(posedge wb_clk_i) wb_rst_i |-> !t0_wb_err_i;
	endproperty
	assert property(af_p2179);

	property af_p2180;
	@(posedge wb_clk_i) t0_wb_err_i |=> !t0_wb_err_i;
	endproperty
	assert property(af_p2180);

	property af_p2181;
	@(posedge wb_clk_i) t0_wb_err_i |-> ##1 $stable(t0_wb_adr_o);
	endproperty
	assert property(af_p2181);

	property af_p2182;
	@(posedge wb_clk_i) (t0_wb_we_o && t0_wb_cyc_o && t0_wb_stb_o) |-> !t0_wb_err_i;
	endproperty
	assert property(af_p2182);

	property af_p2183;
	@(posedge wb_clk_i) (!t0_wb_cyc_o && !t0_wb_stb_o) |-> !t0_wb_err_i;
	endproperty
	assert property(af_p2183);

	property af_p2184;
	@(posedge wb_clk_i) t0_wb_err_i |=> !t0_wb_cyc_o;
	endproperty
	assert property(af_p2184);

	property af_p2185;
	@(posedge wb_clk_i) (wb_rst_i) |-> ##1 (t0_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2185);

	property af_p2186;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (t0_wb_err_i == 1'b0) ##1 (t0_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2186);

	property af_p2187;
	@(posedge wb_clk_i) ($rose(t0_wb_err_i)) |-> ($past(t0_wb_cyc_o) && $past(t0_wb_stb_o)) || (t0_wb_cyc_o && t0_wb_stb_o);
	endproperty
	assert property(af_p2187);

	property af_p2188;
	@(posedge wb_clk_i) ($rose(t0_wb_err_i)) |-> ##1 (t0_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2188);

	property af_p2189;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t0_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2189);

	property af_p2190;
	@(posedge wb_clk_i) (t0_wb_err_i) |-> (t0_wb_cyc_o && t0_wb_stb_o);
	endproperty
	assert property(af_p2190);

	property af_p2191;
	@(posedge wb_clk_i) ($rose(t0_wb_err_i)) |-> ##1 (t0_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2191);

	property af_p2192;
	@(posedge wb_clk_i) (t0_wb_cyc_o && t0_wb_stb_o && t0_wb_ack_i) |-> (t0_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2192);

	property af_p2193;
	@(posedge wb_clk_i) (!t0_wb_cyc_o) |-> (t0_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2193);

	property af_p2194;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> ##1 (t0_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2194);

	property af_p2195;
	@(posedge wb_clk_i) (t0_wb_stb_o) |-> (t0_wb_sel_o != 4'b0000);
	endproperty
	assert property(af_p2195);

	property af_p2196;
	@(posedge wb_clk_i) (t0_wb_cyc_o && !t0_wb_ack_i) |=> (t0_wb_sel_o == $past(t0_wb_sel_o));
	endproperty
	assert property(af_p2196);

	property af_p2197;
	@(posedge wb_clk_i) (t0_wb_stb_o && !t0_wb_ack_i) |=> $stable(t0_wb_sel_o);
	endproperty
	assert property(af_p2197);

	property af_p2198;
	@(posedge wb_clk_i) (t0_wb_we_o && t0_wb_stb_o) |-> (t0_wb_sel_o != 4'b0000);
	endproperty
	assert property(af_p2198);

	property af_p2199;
	@(posedge wb_clk_i) (t0_wb_sel_o >= 4 && t0_wb_sel_o <= 15) |=> (t0_wb_sel_o >= 0 && t0_wb_sel_o <= 15);
	endproperty
	assert property(af_p2199);

	property af_p2200;
	@(posedge wb_clk_i) (t0_wb_we_o) |-> (t0_wb_sel_o >= 1 && t0_wb_sel_o <= 15);
	endproperty
	assert property(af_p2200);

	property af_p2201;
	@(posedge wb_clk_i) (t0_wb_stb_o) |-> !$isunknown(t0_wb_sel_o);
	endproperty
	assert property(af_p2201);

	property af_p2202;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t0_wb_sel_o >= 0 && t0_wb_sel_o <= 15);
	endproperty
	assert property(af_p2202);

	property af_p2203;
	@(posedge wb_clk_i) ($past(wb_rst_i,3) == 1'b0) |-> (t0_wb_sel_o >= 0 && t0_wb_sel_o <= 15);
	endproperty
	assert property(af_p2203);

	property af_p2204;
	@(posedge wb_clk_i) (t0_wb_sel_o >= 1 && t0_wb_sel_o <= 15) |=> (t0_wb_sel_o >= 0 && t0_wb_sel_o <= 15);
	endproperty
	assert property(af_p2204);

	property af_p2205;
	@(posedge wb_clk_i) (t0_wb_we_o && t0_wb_stb_o) |-> (t0_wb_sel_o != '0);
	endproperty
	assert property(af_p2205);

	property af_p2206;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((t0_wb_sel_o >= 0) && (t0_wb_sel_o <= 15));
	endproperty
	assert property(af_p2206);

	property af_p2207;
	@(posedge wb_clk_i) (t0_wb_cyc_o && !t0_wb_ack_i) |-> (t0_wb_sel_o == $past(t0_wb_sel_o));
	endproperty
	assert property(af_p2207);

	property af_p2208;
	@(posedge wb_clk_i) (t0_wb_cyc_o && t0_wb_stb_o && $past(t0_wb_cyc_o) && $past(t0_wb_stb_o)) |-> (t0_wb_sel_o == $past(t0_wb_sel_o));
	endproperty
	assert property(af_p2208);

	property af_p2209;
	@(posedge wb_clk_i) (t0_wb_sel_o != $past(t0_wb_sel_o)) |-> ($past(t0_wb_ack_i));
	endproperty
	assert property(af_p2209);

	property af_p2210;
	@(posedge wb_clk_i) ((t0_wb_sel_o >= 0) && (t0_wb_sel_o <= 15));
	endproperty
	assert property(af_p2210);

	property af_p2211;
	@(posedge wb_clk_i) (wb_rst_i) |-> ##2 (t0_wb_sel_o == '0);
	endproperty
	assert property(af_p2211);

	property af_p2212;
	@(posedge wb_clk_i) ((t0_wb_sel_o >= 1) && (t0_wb_sel_o <= 15)) |-> (t0_wb_sel_o == $past(t0_wb_sel_o)) until (t0_wb_ack_i);
	endproperty
	assert property(af_p2212);

	property af_p2213;
	@(posedge wb_clk_i) (t0_wb_cyc_o) |-> ((t0_wb_sel_o >= 1) && (t0_wb_sel_o <= 15));
	endproperty
	assert property(af_p2213);

	property af_p2214;
	@(posedge wb_clk_i) (t0_wb_cyc_o && $past(t0_wb_cyc_o)) |-> (t0_wb_sel_o == $past(t0_wb_sel_o));
	endproperty
	assert property(af_p2214);

	property af_p2215;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t0_wb_sel_o == '0);
	endproperty
	assert property(af_p2215);

	property af_p2216;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t0_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p2216);

	property af_p2217;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (t0_wb_sel_o >= 0 && t0_wb_sel_o <= 15);
	endproperty
	assert property(af_p2217);

	property af_p2218;
	@(posedge wb_clk_i) ($fell(t0_wb_cyc_o) && $past(t0_wb_ack_i)) |-> (t0_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p2218);

	property af_p2219;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:4] (t0_wb_sel_o >= 0 && t0_wb_sel_o <= 15);
	endproperty
	assert property(af_p2219);

	property af_p2220;
	@(posedge wb_clk_i) (t0_wb_cyc_o) |-> (t0_wb_sel_o >= 0 && t0_wb_sel_o <= 15);
	endproperty
	assert property(af_p2220);

	property af_p2221;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 $stable(t0_wb_sel_o);
	endproperty
	assert property(af_p2221);

	property af_p2222;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (t0_wb_sel_o >= 0 && t0_wb_sel_o <= 15);
	endproperty
	assert property(af_p2222);

	property af_p2223;
	@(posedge wb_clk_i) (t0_wb_stb_o) |-> (t0_wb_sel_o >= 0 && t0_wb_sel_o <= 15);
	endproperty
	assert property(af_p2223);

	property af_p2224;
	@(posedge wb_clk_i) ($fell(t0_wb_stb_o)) |-> ##1 (t0_wb_sel_o >= 0 && t0_wb_sel_o <= 15);
	endproperty
	assert property(af_p2224);

	property af_p2225;
	@(posedge wb_clk_i) (t0_wb_cyc_o && t0_wb_stb_o) |-> (t0_wb_sel_o != 4'b0000);
	endproperty
	assert property(af_p2225);

	property af_p2226;
	@(posedge wb_clk_i) (wb_rst_i) |-> !t0_wb_stb_o;
	endproperty
	assert property(af_p2226);

	property af_p2227;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (!t0_wb_stb_o)[*2];
	endproperty
	assert property(af_p2227);

	property af_p2228;
	@(posedge wb_clk_i) (t0_wb_stb_o && t0_wb_we_o) |-> $stable(t0_wb_adr_o);
	endproperty
	assert property(af_p2228);

	property af_p2229;
	@(posedge wb_clk_i) $rose(t0_wb_ack_i) |=> !t0_wb_stb_o;
	endproperty
	assert property(af_p2229);


	property af_p2231;
	@(posedge wb_clk_i) $rose(t0_wb_err_i) |=> !t0_wb_stb_o;
	endproperty
	assert property(af_p2231);

	property af_p2232;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> !t0_wb_stb_o;
	endproperty
	assert property(af_p2232);

	property af_p2233;
	@(posedge wb_clk_i) !(t0_wb_ack_i && t0_wb_err_i && t0_wb_stb_o);
	endproperty
	assert property(af_p2233);

	property af_p2234;
	@(posedge wb_clk_i) (t0_wb_stb_o && !t0_wb_ack_i && !t0_wb_err_i) |=> (t0_wb_stb_o throughout (t0_wb_ack_i || t0_wb_err_i)[->1]);
	endproperty
	assert property(af_p2234);

	property af_p2235;
	@(posedge wb_clk_i) (t0_wb_stb_o) |-> (t0_wb_cyc_o);
	endproperty
	assert property(af_p2235);

	property af_p2236;
	@(posedge wb_clk_i) (t0_wb_stb_o) |-> ($stable(t0_wb_adr_o) && !$isunknown(t0_wb_adr_o));
	endproperty
	assert property(af_p2236);

	property af_p2237;
	@(posedge wb_clk_i) (!t0_wb_cyc_o) |-> (!t0_wb_stb_o);
	endproperty
	assert property(af_p2237);

	property af_p2238;
	@(posedge wb_clk_i) ($rose(t0_wb_stb_o)) |-> (t0_wb_cyc_o);
	endproperty
	assert property(af_p2238);

	property af_p2239;
	@(posedge wb_clk_i) (t0_wb_err_i) |=> (!t0_wb_stb_o);
	endproperty
	assert property(af_p2239);

	property af_p2240;
	@(posedge wb_clk_i) (t0_wb_stb_o && t0_wb_ack_i) |-> ##1 !t0_wb_stb_o;
	endproperty
	assert property(af_p2240);

	property af_p2241;
	@(posedge wb_clk_i) $rose(t0_wb_stb_o) |-> ($stable(t0_wb_sel_o) throughout (t0_wb_stb_o[*1:$] ##1 t0_wb_ack_i));
	endproperty
	assert property(af_p2241);

	property af_p2242;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t0_wb_stb_o ##1 !t0_wb_stb_o);
	endproperty
	assert property(af_p2242);

	property af_p2243;
	@(posedge wb_clk_i) (t0_wb_stb_o && t0_wb_ack_i) |=> !t0_wb_stb_o;
	endproperty
	assert property(af_p2243);

	property af_p2244;
	@(posedge wb_clk_i) wb_rst_i |-> $stable(t0_wb_stb_o);
	endproperty
	assert property(af_p2244);

	property af_p2245;
	@(posedge wb_clk_i) $rose(t0_wb_stb_o) |-> (t0_wb_stb_o throughout (##[1:$] (t0_wb_ack_i || t0_wb_err_i)));
	endproperty
	assert property(af_p2245);

	property af_p2246;
	@(posedge wb_clk_i) (t0_wb_stb_o && !t0_wb_ack_i) |-> ##1 t0_wb_stb_o;
	endproperty
	assert property(af_p2246);

	property af_p2247;
	@(posedge wb_clk_i) t0_wb_ack_i |-> ##1 !t0_wb_stb_o;
	endproperty
	assert property(af_p2247);

	property af_p2248;
	@(posedge wb_clk_i) (t0_wb_stb_o && !$isunknown(t0_wb_dat_o)) |-> t0_wb_we_o;
	endproperty
	assert property(af_p2248);

	property af_p2249;
	@(posedge wb_clk_i) ($stable(t0_wb_adr_o) && !$isunknown(t0_wb_adr_o)) |-> $stable(t0_wb_we_o);
	endproperty
	assert property(af_p2249);

	property af_p2250;
	@(posedge wb_clk_i) $fell(t0_wb_cyc_o) |-> !t0_wb_we_o;
	endproperty
	assert property(af_p2250);

	property af_p2251;
	@(posedge wb_clk_i) (t0_wb_sel_o != '0) |-> t0_wb_we_o;
	endproperty
	assert property(af_p2251);

	property af_p2252;
	@(posedge wb_clk_i) t0_wb_we_o |-> $stable(t0_wb_adr_o);
	endproperty
	assert property(af_p2252);

	property af_p2253;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (t0_wb_we_o === 1'b0);
	endproperty
	assert property(af_p2253);

	property af_p2254;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[0:1] (t0_wb_we_o === 1'b0 || t0_wb_we_o === 1'b1);
	endproperty
	assert property(af_p2254);

	property af_p2255;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] (t0_wb_we_o === 1'b0 || t0_wb_we_o === 1'b1);
	endproperty
	assert property(af_p2255);


	property af_p2257;
	@(posedge wb_clk_i) (t0_wb_we_o) |-> (t0_wb_sel_o != 4'b0000);
	endproperty
	assert property(af_p2257);

	property af_p2258;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t0_wb_we_o == 1'b0);
	endproperty
	assert property(af_p2258);

	property af_p2259;
	@(posedge wb_clk_i) (t0_wb_cyc_o && !t0_wb_ack_i) |=> (t0_wb_we_o == $past(t0_wb_we_o));
	endproperty
	assert property(af_p2259);

	property af_p2260;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 (t0_wb_we_o inside {1'b0, 1'b1});
	endproperty
	assert property(af_p2260);

	property af_p2261;
	@(posedge wb_clk_i) (t0_wb_we_o) |-> (t0_wb_cyc_o);
	endproperty
	assert property(af_p2261);

	property af_p2262;
	@(posedge wb_clk_i) (t0_wb_we_o && t0_wb_ack_i) |-> (!$isunknown(t0_wb_dat_o));
	endproperty
	assert property(af_p2262);

	property af_p2263;
	@(posedge wb_clk_i) (!t0_wb_cyc_o) |-> (t0_wb_we_o == 1'b0);
	endproperty
	assert property(af_p2263);

	property af_p2264;
	@(posedge wb_clk_i) (t0_wb_we_o && t0_wb_cyc_o && t0_wb_stb_o) |-> ($stable(t0_wb_dat_o) until t0_wb_ack_i);
	endproperty
	assert property(af_p2264);

	property af_p2265;
	@(posedge wb_clk_i) (t0_wb_ack_i) |=> (t0_wb_we_o == 1'b0);
	endproperty
	assert property(af_p2265);

	property af_p2266;
	@(posedge wb_clk_i) (t0_wb_we_o) |-> (t0_wb_we_o throughout (t0_wb_ack_i || t0_wb_err_i)[->1]);
	endproperty
	assert property(af_p2266);

	property af_p2267;
	@(posedge wb_clk_i) (t0_wb_ack_i) |=> (!t0_wb_we_o);
	endproperty
	assert property(af_p2267);

	property af_p2268;
	@(posedge wb_clk_i) (t0_wb_we_o) |-> (t0_wb_stb_o);
	endproperty
	assert property(af_p2268);

	property af_p2269;
	@(posedge wb_clk_i) (t0_wb_we_o) |-> (t0_wb_cyc_o && t0_wb_stb_o);
	endproperty
	assert property(af_p2269);

	property af_p2270;
	@(posedge wb_clk_i) (t0_wb_cyc_o) |-> ($stable(t0_wb_we_o));
	endproperty
	assert property(af_p2270);

	property af_p2271;
	@(posedge wb_clk_i) (!t0_wb_stb_o) |-> ($stable(t0_wb_we_o));
	endproperty
	assert property(af_p2271);

	property af_p2272;
	@(posedge wb_clk_i) (t0_wb_cyc_o && !t0_wb_ack_i) |-> ($stable(t0_wb_we_o));
	endproperty
	assert property(af_p2272);

	property af_p2273;
	@(posedge wb_clk_i) (t0_wb_stb_o) |-> (t0_wb_we_o == $past(t0_wb_we_o));
	endproperty
	assert property(af_p2273);

	property af_p2274;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t1_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p2274);

	property af_p2275;
	@(posedge wb_clk_i) $fell(t1_wb_cyc_o) |-> ##1 (!t1_wb_ack_i);
	endproperty
	assert property(af_p2275);

	property af_p2276;
	@(posedge wb_clk_i) (!t1_wb_stb_o) |-> (!t1_wb_ack_i) ##1 (!t1_wb_ack_i);
	endproperty
	assert property(af_p2276);

	property af_p2277;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_stb_o) |-> ##[1:16] t1_wb_ack_i;
	endproperty
	assert property(af_p2277);

	property af_p2278;
	@(posedge wb_clk_i) t1_wb_ack_i |-> $stable(t1_wb_adr_o) throughout (t1_wb_stb_o[->1] ##0 1);
	endproperty
	assert property(af_p2278);

	property af_p2279;
	@(posedge wb_clk_i) not (t1_wb_ack_i && t1_wb_err_i);
	endproperty
	assert property(af_p2279);

	property af_p2280;
	@(posedge wb_clk_i) (!t1_wb_cyc_o) |-> (!t1_wb_ack_i);
	endproperty
	assert property(af_p2280);

	property af_p2281;
	@(posedge wb_clk_i) (t1_wb_ack_i && $fell(t1_wb_cyc_o)) |-> ##1 (!t1_wb_ack_i);
	endproperty
	assert property(af_p2281);

	property af_p2282;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t1_wb_ack_i);
	endproperty
	assert property(af_p2282);

	property af_p2283;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (t1_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p2283);

	property af_p2284;
	@(posedge wb_clk_i) (t1_wb_stb_o && t1_wb_ack_i) |-> ##1 (!t1_wb_ack_i);
	endproperty
	assert property(af_p2284);

	property af_p2285;
	@(posedge wb_clk_i) (t1_wb_we_o && !t1_wb_cyc_o) |-> (!t1_wb_ack_i);
	endproperty
	assert property(af_p2285);

	property af_p2286;
	@(posedge wb_clk_i) ($rose(t1_wb_ack_i) && t1_wb_stb_o) |=> (!t1_wb_ack_i || !t1_wb_stb_o);
	endproperty
	assert property(af_p2286);

	property af_p2287;
	@(posedge wb_clk_i) (t1_wb_ack_i) |-> (!$isunknown(t1_wb_dat_i) && $stable(t1_wb_dat_i));
	endproperty
	assert property(af_p2287);

	property af_p2288;
	@(posedge wb_clk_i) (1'b1) |-> !(t1_wb_ack_i && t1_wb_err_i);
	endproperty
	assert property(af_p2288);

	property af_p2289;
	@(posedge wb_clk_i) (t1_wb_ack_i) |-> (t1_wb_stb_o);
	endproperty
	assert property(af_p2289);

	property af_p2290;
	@(posedge wb_clk_i) (t1_wb_we_o && t1_wb_ack_i) |-> (!$isunknown(t1_wb_dat_o) && $stable(t1_wb_dat_o));
	endproperty
	assert property(af_p2290);

	property af_p2291;
	@(posedge wb_clk_i) (t1_wb_cyc_o && $rose(t1_wb_ack_i)) |-> (!t1_wb_ack_i throughout (t1_wb_cyc_o[*1:$] ##1 !t1_wb_cyc_o));
	endproperty
	assert property(af_p2291);

	property af_p2292;
	@(posedge wb_clk_i) (t1_wb_ack_i) |-> (t1_wb_cyc_o && t1_wb_stb_o);
	endproperty
	assert property(af_p2292);

	property af_p2293;
	@(posedge wb_clk_i) (1'b1) |-> (!$isunknown(t1_wb_ack_i));
	endproperty
	assert property(af_p2293);

	property af_p2294;
	@(posedge wb_clk_i) (t1_wb_ack_i) |-> ($isunknown(t1_wb_dat_i) == 1'b0);
	endproperty
	assert property(af_p2294);

	property af_p2295;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (t1_wb_ack_i == 1'b0) ##1 (t1_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p2295);

	property af_p2296;
	@(posedge wb_clk_i) (t1_wb_ack_i) |=> (t1_wb_ack_i && !t1_wb_stb_o) |-> 1'b0;
	endproperty
	assert property(af_p2296);

	property af_p2297;
	@(posedge wb_clk_i) ((!t1_wb_cyc_o) && (!t1_wb_stb_o)) |=> ($stable(t1_wb_ack_i));
	endproperty
	assert property(af_p2297);

	property af_p2298;
	@(posedge wb_clk_i) (t1_wb_ack_i && t1_wb_we_o) |-> (t1_wb_we_o);
	endproperty
	assert property(af_p2298);

	property af_p2299;
	@(posedge wb_clk_i) (t1_wb_ack_i) |=> (!t1_wb_stb_o) ? (t1_wb_ack_i == 1'b0) : 1'b1;
	endproperty
	assert property(af_p2299);

	property af_p2300;
	@(posedge wb_clk_i) (t1_wb_ack_i && !t1_wb_stb_o) |=> (t1_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p2300);

	property af_p2301;
	@(posedge wb_clk_i) (t1_wb_ack_i && !t1_wb_we_o) |-> ($isunknown(t1_wb_dat_i) == 1'b0);
	endproperty
	assert property(af_p2301);

	property af_p2302;
	@(posedge wb_clk_i) (!t1_wb_cyc_o) |-> (t1_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p2302);

	property af_p2303;
	@(posedge wb_clk_i) (1'b1) |=> ($stable(t1_wb_adr_o) throughout 1);
	endproperty
	assert property(af_p2303);

	property af_p2304;
	@(posedge wb_clk_i) (t1_wb_stb_o) |-> (!$isunknown(t1_wb_adr_o));
	endproperty
	assert property(af_p2304);

	property af_p2305;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_stb_o) |-> ($stable(t1_wb_adr_o));
	endproperty
	assert property(af_p2305);

	property af_p2306;
	@(posedge wb_clk_i) (t1_wb_stb_o) |-> (t1_wb_adr_o == t1_wb_adr_o) throughout (!t1_wb_ack_i)[*1:$] ##1 t1_wb_ack_i;
	endproperty
	assert property(af_p2306);

	property af_p2307;
	@(posedge wb_clk_i) disable iff (!wb_clk_i) (1'b1) |-> ($stable(t1_wb_adr_o) or !$stable(t1_wb_adr_o));
	endproperty
	assert property(af_p2307);

	property af_p2308;
	@(posedge wb_clk_i) (t1_wb_sel_o && t1_wb_we_o) |-> ($stable(t1_wb_adr_o));
	endproperty
	assert property(af_p2308);


	property af_p2310;
	@(posedge wb_clk_i) (t1_wb_we_o) |-> ($stable(t1_wb_adr_o));
	endproperty
	assert property(af_p2310);

	property af_p2311;
	@(posedge wb_clk_i) (!t1_wb_cyc_o && !t1_wb_stb_o) |-> ($stable(t1_wb_adr_o));
	endproperty
	assert property(af_p2311);

	property af_p2312;
	@(posedge wb_clk_i) ($past(wb_rst_i)) |-> (t1_wb_adr_o == '0);
	endproperty
	assert property(af_p2312);

	property af_p2313;
	@(posedge wb_clk_i) ($past(t1_wb_ack_i)) |-> (t1_wb_adr_o == $past(t1_wb_adr_o)) or (t1_wb_adr_o != $past(t1_wb_adr_o));
	endproperty
	assert property(af_p2313);

	property af_p2314;
	@(posedge wb_clk_i) (t1_wb_cyc_o && !t1_wb_ack_i) |-> ($stable(t1_wb_adr_o));
	endproperty
	assert property(af_p2314);

	property af_p2315;
	@(posedge wb_clk_i) (t1_wb_adr_o !== $past(t1_wb_adr_o)) |-> $rose(t1_wb_cyc_o);
	endproperty
	assert property(af_p2315);

	property af_p2316;
	@(posedge wb_clk_i) (!t1_wb_cyc_o) |-> (t1_wb_adr_o == $past(t1_wb_adr_o));
	endproperty
	assert property(af_p2316);

	property af_p2317;
	@(posedge wb_clk_i) (t1_wb_adr_o !== $past(t1_wb_adr_o)) |-> t1_wb_stb_o;
	endproperty
	assert property(af_p2317);

	property af_p2318;
	@(posedge wb_clk_i) (t1_wb_adr_o >= 0 && t1_wb_adr_o <= 4095) |=> (t1_wb_adr_o >= 0 && t1_wb_adr_o <= 8191);
	endproperty
	assert property(af_p2318);

	property af_p2319;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (t1_wb_adr_o == '0);
	endproperty
	assert property(af_p2319);

	property af_p2320;
	@(posedge wb_clk_i) (!t1_wb_cyc_o) |-> $stable(t1_wb_adr_o);
	endproperty
	assert property(af_p2320);

	property af_p2321;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (t1_wb_adr_o >= 0 && t1_wb_adr_o <= 32'hFFFFFFFF);
	endproperty
	assert property(af_p2321);

	property af_p2322;
	@(posedge wb_clk_i) wb_rst_i |-> !$isunknown(t1_wb_adr_o);
	endproperty
	assert property(af_p2322);

	property af_p2323;
	@(posedge wb_clk_i) (t1_wb_adr_o !== $past(t1_wb_adr_o)) |-> ($past(t1_wb_ack_i) || $past(t1_wb_err_i));
	endproperty
	assert property(af_p2323);

	property af_p2324;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 ((t1_wb_adr_o inside {[0:32'hFFFFFFFF]}) && $stable(t1_wb_adr_o) throughout (!t1_wb_stb_o)[->1]);
	endproperty
	assert property(af_p2324);

	property af_p2325;
	@(posedge wb_clk_i) $rose(t1_wb_cyc_o) |-> $stable(t1_wb_adr_o);
	endproperty
	assert property(af_p2325);

	property af_p2326;
	@(posedge wb_clk_i) ($fell(wb_rst_i) && t1_wb_cyc_o) |-> ##[1:3] (t1_wb_adr_o !== 'x);
	endproperty
	assert property(af_p2326);

	property af_p2327;
	@(posedge wb_clk_i) (i2_wb_cyc_i && i2_wb_stb_i) |=> (t1_wb_adr_o == $past(i2_wb_adr_i));
	endproperty
	assert property(af_p2327);

	property af_p2328;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (t1_wb_adr_o !== 'x);
	endproperty
	assert property(af_p2328);

	property af_p2329;
	@(posedge wb_clk_i) (!t1_wb_we_o) |-> (t1_wb_adr_o >= 0) && (t1_wb_adr_o <= 65535);
	endproperty
	assert property(af_p2329);

	property af_p2330;
	@(posedge wb_clk_i) (t1_wb_ack_i) |=> (t1_wb_adr_o == $past(t1_wb_adr_o));
	endproperty
	assert property(af_p2330);

	property af_p2331;
	@(posedge wb_clk_i) (t1_wb_err_i) |=> (t1_wb_adr_o != $past(t1_wb_adr_o));
	endproperty
	assert property(af_p2331);

	property af_p2332;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (t1_wb_adr_o == '0) ##1 (t1_wb_adr_o == '0);
	endproperty
	assert property(af_p2332);

	property af_p2333;
	@(posedge wb_clk_i) (i0_wb_cyc_i) |=> (t1_wb_adr_o == $past(i0_wb_adr_i));
	endproperty
	assert property(af_p2333);

	property af_p2334;
	@(posedge wb_clk_i) (t1_wb_we_o && !t1_wb_ack_i) |=> (t1_wb_adr_o == $past(t1_wb_adr_o));
	endproperty
	assert property(af_p2334);

	property af_p2335;
	@(posedge wb_clk_i) (t1_wb_ack_i == 0) |=> (t1_wb_adr_o == $past(t1_wb_adr_o)) or (t1_wb_adr_o != $past(t1_wb_adr_o) && $past(t1_wb_ack_i));
	endproperty
	assert property(af_p2335);

	property af_p2336;
	@(posedge wb_clk_i) (!t1_wb_cyc_o && !t1_wb_stb_o) |-> !(t1_wb_adr_o !== '0);
	endproperty
	assert property(af_p2336);

	property af_p2337;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (t1_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2337);

	property af_p2338;
	@(posedge wb_clk_i) $rose(t1_wb_cyc_o) |-> (t1_wb_adr_o === $past(t1_wb_adr_o)) throughout (t1_wb_ack_i || t1_wb_err_i)[->1];
	endproperty
	assert property(af_p2338);

	property af_p2339;
	@(posedge wb_clk_i) $rose(t1_wb_cyc_o) |-> !$fell(t1_wb_cyc_o);
	endproperty
	assert property(af_p2339);

	property af_p2340;
	@(posedge wb_clk_i) $rose(t1_wb_cyc_o) |-> (t1_wb_adr_o === $past(t1_wb_adr_o) && t1_wb_we_o === $past(t1_wb_we_o)) throughout (t1_wb_cyc_o)[->1];
	endproperty
	assert property(af_p2340);

	property af_p2341;
	@(posedge wb_clk_i) (t1_wb_stb_o) |-> (t1_wb_cyc_o);
	endproperty
	assert property(af_p2341);

	property af_p2342;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t1_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2342);

	property af_p2343;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[0:2] (t1_wb_cyc_o == 1'b1);
	endproperty
	assert property(af_p2343);

	property af_p2344;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_err_i) |-> (!t1_wb_cyc_o) or ##1 (!t1_wb_cyc_o);
	endproperty
	assert property(af_p2344);

	property af_p2345;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!t1_wb_cyc_o) throughout (!t1_wb_stb_o)[*1:$];
	endproperty
	assert property(af_p2345);

	property af_p2346;
	@(posedge wb_clk_i) (t1_wb_stb_o) |-> (t1_wb_cyc_o) or ##1 (t1_wb_cyc_o);
	endproperty
	assert property(af_p2346);

	property af_p2347;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_err_i) |=> (!t1_wb_cyc_o);
	endproperty
	assert property(af_p2347);

	property af_p2348;
	@(posedge wb_clk_i) (t1_wb_ack_i) |=> (!t1_wb_cyc_o);
	endproperty
	assert property(af_p2348);

	property af_p2349;
	@(posedge wb_clk_i) (t1_wb_ack_i) |-> (!t1_wb_cyc_o) or ##1 (!t1_wb_cyc_o);
	endproperty
	assert property(af_p2349);

	property af_p2350;
	@(posedge wb_clk_i) (t1_wb_cyc_o) |-> $stable(t1_wb_adr_o);
	endproperty
	assert property(af_p2350);

	property af_p2351;
	@(posedge wb_clk_i) (t1_wb_cyc_o && !t1_wb_ack_i) |-> ##1 (t1_wb_cyc_o) until_with (t1_wb_ack_i);
	endproperty
	assert property(af_p2351);

	property af_p2352;
	@(posedge wb_clk_i) $rose(t1_wb_stb_o) |-> (t1_wb_cyc_o until t1_wb_ack_i);
	endproperty
	assert property(af_p2352);

	property af_p2353;
	@(posedge wb_clk_i) t1_wb_ack_i |-> !t1_wb_cyc_o;
	endproperty
	assert property(af_p2353);

	property af_p2354;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t1_wb_cyc_o;
	endproperty
	assert property(af_p2354);

	property af_p2355;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_err_i) |=> !t1_wb_cyc_o;
	endproperty
	assert property(af_p2355);

	property af_p2356;
	@(posedge wb_clk_i) t1_wb_cyc_o |-> $stable(t1_wb_we_o);
	endproperty
	assert property(af_p2356);

	property af_p2357;
	@(posedge wb_clk_i) $rose(t1_wb_cyc_o) |-> (t1_wb_cyc_o until t1_wb_ack_i);
	endproperty
	assert property(af_p2357);

	property af_p2358;
	@(posedge wb_clk_i) 1'b1 |-> ($stable(t1_wb_cyc_o) || $changed(t1_wb_cyc_o));
	endproperty
	assert property(af_p2358);

	property af_p2359;
	@(posedge wb_clk_i) t1_wb_stb_o |-> t1_wb_cyc_o;
	endproperty
	assert property(af_p2359);

	property af_p2360;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((t1_wb_dat_i >= 0) && (t1_wb_dat_i <= 255));
	endproperty
	assert property(af_p2360);

	property af_p2361;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t1_wb_dat_i >= 50) && (t1_wb_dat_i <= 150));
	endproperty
	assert property(af_p2361);

	property af_p2362;
	@(posedge wb_clk_i) ((t1_wb_dat_i >= 100) && (t1_wb_dat_i <= 255)) |=> (t1_wb_dat_i >= 50) && (t1_wb_dat_i <= 255);
	endproperty
	assert property(af_p2362);

	property af_p2363;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 ((t1_wb_dat_i >= 0) && (t1_wb_dat_i <= 10));
	endproperty
	assert property(af_p2363);

	property af_p2364;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_stb_o && !t1_wb_we_o && t1_wb_ack_i) |-> ##1 $stable(t1_wb_dat_i);
	endproperty
	assert property(af_p2364);

	property af_p2365;
	@(posedge wb_clk_i) (!t1_wb_we_o) |-> ((t1_wb_dat_i >= 0) && (t1_wb_dat_i <= 255));
	endproperty
	assert property(af_p2365);

	property af_p2366;
	@(posedge wb_clk_i) (t1_wb_err_i) |-> 1'b1;
	endproperty
	assert property(af_p2366);

	property af_p2367;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 (t1_wb_dat_i <= 255);
	endproperty
	assert property(af_p2367);

	property af_p2368;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_stb_o) |-> !$isunknown(t1_wb_dat_i);
	endproperty
	assert property(af_p2368);

	property af_p2369;
	@(posedge wb_clk_i) ((t1_wb_dat_i >= 100) && (t1_wb_dat_i <= 255)) |=> (t1_wb_dat_i >= 80) && (t1_wb_dat_i <= 255);
	endproperty
	assert property(af_p2369);

	property af_p2370;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((t1_wb_dat_i >= 0) && (t1_wb_dat_i <= 200));
	endproperty
	assert property(af_p2370);

	property af_p2371;
	@(posedge wb_clk_i) ((t1_wb_dat_i >= 64) && (t1_wb_dat_i <= 127)) |-> ##1 (t1_wb_dat_i >= 32) && (t1_wb_dat_i <= 127);
	endproperty
	assert property(af_p2371);

	property af_p2372;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (!(t1_wb_cyc_o && t1_wb_stb_o)) |-> $stable(t1_wb_dat_i);
	endproperty
	assert property(af_p2372);

	property af_p2373;
	@(posedge wb_clk_i) ((t1_wb_dat_i >= 100) && (t1_wb_dat_i <= 150)) |-> ##1 (t1_wb_dat_i >= 80) && (t1_wb_dat_i <= 170);
	endproperty
	assert property(af_p2373);

	property af_p2374;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 (t1_wb_dat_i >= 0) && (t1_wb_dat_i <= 100);
	endproperty
	assert property(af_p2374);

	property af_p2375;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t1_wb_dat_i >= 0) && (t1_wb_dat_i <= 255);
	endproperty
	assert property(af_p2375);

	property af_p2376;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_stb_o && !t1_wb_ack_i) |-> $stable(t1_wb_dat_i);
	endproperty
	assert property(af_p2376);

	property af_p2377;
	@(posedge wb_clk_i) (!t1_wb_we_o && $rose(t1_wb_ack_i)) |=> (t1_wb_dat_i >= 0) && (t1_wb_dat_i <= 255);
	endproperty
	assert property(af_p2377);

	property af_p2378;
	@(posedge wb_clk_i) $rose(wb_rst_i == 0) |-> ##4 (t1_wb_dat_i >= 0) && (t1_wb_dat_i <= 63);
	endproperty
	assert property(af_p2378);

	property af_p2379;
	@(posedge wb_clk_i) $fell(t1_wb_err_i) |-> (t1_wb_dat_i >= 0) && (t1_wb_dat_i <= 255);
	endproperty
	assert property(af_p2379);

	property af_p2380;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t1_wb_dat_i == 0);
	endproperty
	assert property(af_p2380);

	property af_p2381;
	@(posedge wb_clk_i) ((t1_wb_dat_i >= 200) && (t1_wb_dat_i <= 255)) |=> ((t1_wb_dat_i >= 180) && (t1_wb_dat_i <= 255));
	endproperty
	assert property(af_p2381);

	property af_p2382;
	@(posedge wb_clk_i) ((t1_wb_dat_i >= 120) && (t1_wb_dat_i <= 200)) |=> ((t1_wb_dat_i >= 90) && (t1_wb_dat_i <= 200));
	endproperty
	assert property(af_p2382);

	property af_p2383;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t1_wb_dat_i >= 0) && (t1_wb_dat_i <= 255));
	endproperty
	assert property(af_p2383);

	property af_p2384;
	@(posedge wb_clk_i) $rose(wb_rst_i === 1'b0) |-> !$isunknown(t1_wb_dat_i);
	endproperty
	assert property(af_p2384);

	property af_p2385;
	@(posedge wb_clk_i) (!t1_wb_ack_i) |=> $stable(t1_wb_dat_i);
	endproperty
	assert property(af_p2385);

	property af_p2386;
	@(posedge wb_clk_i) ((t1_wb_dat_i >= 50) && (t1_wb_dat_i <= 75) && !t1_wb_ack_i) |=> ((t1_wb_dat_i >= 0) && (t1_wb_dat_i <= 100));
	endproperty
	assert property(af_p2386);

	property af_p2387;
	@(posedge wb_clk_i) (t1_wb_ack_i) |=> ((t1_wb_dat_i >= 0) && (t1_wb_dat_i <= 255));
	endproperty
	assert property(af_p2387);

	property af_p2388;
	@(posedge wb_clk_i) $rose(t1_wb_stb_o) |-> ((t1_wb_dat_i >= 16) && (t1_wb_dat_i <= 240))[*2];
	endproperty
	assert property(af_p2388);

	property af_p2389;
	@(posedge wb_clk_i) $past((t1_wb_dat_i >= 200) && (t1_wb_dat_i <= 255)) && (t1_wb_dat_i < 200) |-> $rose(wb_clk_i);
	endproperty
	assert property(af_p2389);

	property af_p2390;
	@(posedge wb_clk_i) (t1_wb_ack_i) |-> $stable(t1_wb_dat_i);
	endproperty
	assert property(af_p2390);

	property af_p2391;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_stb_o && !t1_wb_we_o && t1_wb_ack_i) |=> $changed(t1_wb_dat_o);
	endproperty
	assert property(af_p2391);

	property af_p2392;
	@(posedge wb_clk_i) (t1_wb_err_i) |=> $stable(t1_wb_dat_o);
	endproperty
	assert property(af_p2392);

	property af_p2393;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_stb_o && !t1_wb_ack_i) |=> $stable(t1_wb_dat_o);
	endproperty
	assert property(af_p2393);

	property af_p2394;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> !$isunknown(t1_wb_dat_o);
	endproperty
	assert property(af_p2394);

	property af_p2395;
	@(posedge wb_clk_i) (t1_wb_cyc_o && !t1_wb_we_o && $changed(t1_wb_dat_o)) |-> t1_wb_ack_i;
	endproperty
	assert property(af_p2395);

	property af_p2396;
	@(posedge wb_clk_i) (t1_wb_stb_o && !t1_wb_ack_i) |-> $stable(t1_wb_dat_o);
	endproperty
	assert property(af_p2396);

	property af_p2397;
	@(posedge wb_clk_i) (!t1_wb_cyc_o) |-> (!$isunknown(t1_wb_dat_o) && (t1_wb_dat_o >= 0) && (t1_wb_dat_o <= 255));
	endproperty
	assert property(af_p2397);

	property af_p2398;
	@(posedge wb_clk_i) ((t1_wb_dat_o >= 138) && (t1_wb_dat_o <= 153)) |=> (t1_wb_dat_o >= 98) && (t1_wb_dat_o <= 153);
	endproperty
	assert property(af_p2398);

	property af_p2399;
	@(posedge wb_clk_i) ((t1_wb_dat_o >= 10) && (t1_wb_dat_o <= 20) && (t1_wb_sel_o == '1)) |=> (t1_wb_dat_o >= 0) && (t1_wb_dat_o <= 30);
	endproperty
	assert property(af_p2399);

	property af_p2400;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t1_wb_dat_o == 0);
	endproperty
	assert property(af_p2400);

	property af_p2401;
	@(posedge wb_clk_i) (t1_wb_ack_i) |=> ($stable(t1_wb_dat_o) until_with t1_wb_ack_i);
	endproperty
	assert property(af_p2401);

	property af_p2402;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_stb_o) |-> ((t1_wb_dat_o >= 50) && (t1_wb_dat_o <= 200)) [*2];
	endproperty
	assert property(af_p2402);

	property af_p2403;
	@(posedge wb_clk_i) (t1_wb_stb_o && !t1_wb_ack_i) |=> $stable(t1_wb_dat_o);
	endproperty
	assert property(af_p2403);

	property af_p2404;
	@(posedge wb_clk_i) (t1_wb_dat_o != $past(t1_wb_dat_o)) |-> (t1_wb_sel_o != 0);
	endproperty
	assert property(af_p2404);

	property af_p2405;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (t1_wb_dat_o == 0);
	endproperty
	assert property(af_p2405);

	property af_p2406;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 ((t1_wb_dat_o >= 0) && (t1_wb_dat_o <= 255));
	endproperty
	assert property(af_p2406);

	property af_p2407;
	@(posedge wb_clk_i) (t1_wb_dat_o != $past(t1_wb_dat_o)) |-> t1_wb_cyc_o;
	endproperty
	assert property(af_p2407);

	property af_p2408;
	@(posedge wb_clk_i) (!t1_wb_stb_o) |=> $stable(t1_wb_dat_o);
	endproperty
	assert property(af_p2408);

	property af_p2409;
	@(posedge wb_clk_i) t1_wb_ack_i |=> (t1_wb_dat_o >= 0) && (t1_wb_dat_o <= 255);
	endproperty
	assert property(af_p2409);

	property af_p2410;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t1_wb_dat_o >= 83) && (t1_wb_dat_o <= 165));
	endproperty
	assert property(af_p2410);

	property af_p2411;
	@(posedge wb_clk_i) ((t1_wb_dat_o >= 230) && (t1_wb_dat_o <= 255)) |=> (t1_wb_dat_o >= 205) && (t1_wb_dat_o <= 255);
	endproperty
	assert property(af_p2411);

	property af_p2412;
	@(posedge wb_clk_i) (t1_wb_ack_i && (t1_wb_dat_o >= 100) && (t1_wb_dat_o <= 200)) |=> (t1_wb_dat_o >= 90) && (t1_wb_dat_o <= 210);
	endproperty
	assert property(af_p2412);

	property af_p2413;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((t1_wb_dat_o >= 0) && (t1_wb_dat_o <= 255));
	endproperty
	assert property(af_p2413);

	property af_p2414;
	@(posedge wb_clk_i) (!t1_wb_we_o && !t1_wb_ack_i) |=> $stable(t1_wb_dat_o);
	endproperty
	assert property(af_p2414);

	property af_p2415;
	@(posedge wb_clk_i) $fell(t1_wb_stb_o) |=> $stable(t1_wb_dat_o);
	endproperty
	assert property(af_p2415);

	property af_p2416;
	@(posedge wb_clk_i) (wb_rst_i) |=> $stable(t1_wb_dat_o);
	endproperty
	assert property(af_p2416);

	property af_p2417;
	@(posedge wb_clk_i) (t1_wb_ack_i) |=> (t1_wb_dat_o >= 0) && (t1_wb_dat_o <= 255);
	endproperty
	assert property(af_p2417);

	property af_p2418;
	@(posedge wb_clk_i) $past(!wb_rst_i, 4) |-> (t1_wb_dat_o >= 0) && (t1_wb_dat_o <= 45);
	endproperty
	assert property(af_p2418);

	property af_p2419;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (t1_wb_dat_o == '0)[*2];
	endproperty
	assert property(af_p2419);

	property af_p2420;
	@(posedge wb_clk_i) (!t1_wb_cyc_o) |=> $stable(t1_wb_dat_o);
	endproperty
	assert property(af_p2420);

	property af_p2421;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t1_wb_dat_o >= 0) && (t1_wb_dat_o <= 255);
	endproperty
	assert property(af_p2421);

	property af_p2422;
	@(posedge wb_clk_i) (t1_wb_we_o) |-> (t1_wb_dat_o >= 0) && (t1_wb_dat_o <= 255);
	endproperty
	assert property(af_p2422);

	property af_p2423;
	@(posedge wb_clk_i) (!t1_wb_cyc_o) |-> (t1_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2423);

	property af_p2424;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (t1_wb_err_i == 1'b0) ##1 (t1_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2424);

	property af_p2425;
	@(posedge wb_clk_i) !(t1_wb_err_i && t1_wb_ack_i);
	endproperty
	assert property(af_p2425);

	property af_p2426;
	@(posedge wb_clk_i) (t1_wb_err_i) |=> (t1_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2426);

	property af_p2427;
	@(posedge wb_clk_i) ($rose(t1_wb_err_i)) |-> (!wb_rst_i);
	endproperty
	assert property(af_p2427);

	property af_p2428;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_stb_o && t1_wb_err_i) |-> (t1_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p2428);

	property af_p2429;
	@(posedge wb_clk_i) (t1_wb_err_i) |-> (t1_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p2429);

	property af_p2430;
	@(posedge wb_clk_i) (!t1_wb_stb_o && !$past(t1_wb_stb_o)) |-> ($stable(t1_wb_err_i));
	endproperty
	assert property(af_p2430);

	property af_p2431;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t1_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2431);

	property af_p2432;
	@(posedge wb_clk_i) (t1_wb_err_i) |-> (1'b1);
	endproperty
	assert property(af_p2432);

	property af_p2433;
	@(posedge wb_clk_i) (!t1_wb_stb_o) |-> (!t1_wb_err_i);
	endproperty
	assert property(af_p2433);

	property af_p2434;
	@(posedge wb_clk_i) (!t1_wb_cyc_o) |-> (!t1_wb_err_i);
	endproperty
	assert property(af_p2434);

	property af_p2435;
	@(posedge wb_rst_i) ##1 (!wb_rst_i)[->1] ##3 (!t1_wb_stb_o) |-> (t1_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2435);

	property af_p2436;
	@(posedge wb_clk_i) (t1_wb_err_i) |-> (t1_wb_cyc_o);
	endproperty
	assert property(af_p2436);

	property af_p2437;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (t1_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2437);

	property af_p2438;
	@(posedge wb_clk_i) (t1_wb_err_i) |-> (t1_wb_cyc_o && t1_wb_stb_o);
	endproperty
	assert property(af_p2438);

	property af_p2439;
	@(posedge wb_clk_i) (t1_wb_err_i) |=> (!t1_wb_err_i);
	endproperty
	assert property(af_p2439);

	property af_p2440;
	@(posedge wb_clk_i) ($rose(t1_wb_err_i)) |=> (!t1_wb_we_o);
	endproperty
	assert property(af_p2440);

	property af_p2441;
	@(posedge wb_clk_i) (t1_wb_err_i) |=> (!t1_wb_stb_o);
	endproperty
	assert property(af_p2441);

	property af_p2442;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_stb_o && t1_wb_err_i) |=> (!t1_wb_err_i);
	endproperty
	assert property(af_p2442);

	property af_p2443;
	@(posedge wb_clk_i) (t1_wb_err_i && t1_wb_stb_o && t1_wb_cyc_o) |=> (!t1_wb_cyc_o);
	endproperty
	assert property(af_p2443);

	property af_p2444;
	@(posedge wb_clk_i) (t1_wb_err_i) |=> (##[0:1] !t1_wb_cyc_o);
	endproperty
	assert property(af_p2444);

	property af_p2445;
	@(posedge wb_clk_i) (t1_wb_err_i) |-> ($stable(t1_wb_adr_o));
	endproperty
	assert property(af_p2445);

	property af_p2446;
	@(posedge wb_clk_i) not (t1_wb_err_i && t1_wb_ack_i);
	endproperty
	assert property(af_p2446);

	property af_p2447;
	@(posedge wb_clk_i) (t1_wb_stb_o) |=> ($stable(t1_wb_sel_o) || !t1_wb_stb_o);
	endproperty
	assert property(af_p2447);

	property af_p2448;
	@(posedge wb_clk_i) (t1_wb_err_i) |-> $stable(t1_wb_sel_o);
	endproperty
	assert property(af_p2448);

	property af_p2449;
	@(posedge wb_clk_i) (t1_wb_we_o && t1_wb_stb_o) |-> (t1_wb_sel_o != '0);
	endproperty
	assert property(af_p2449);

	property af_p2450;
	@(posedge wb_clk_i) (t1_wb_cyc_o && !t1_wb_ack_i) |=> ($stable(t1_wb_sel_o) || !t1_wb_cyc_o || t1_wb_ack_i);
	endproperty
	assert property(af_p2450);

	property af_p2451;
	@(posedge wb_clk_i) (t1_wb_cyc_o) |-> (t1_wb_sel_o != '0);
	endproperty
	assert property(af_p2451);

	property af_p2452;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 (t1_wb_sel_o inside {[1:'1]});
	endproperty
	assert property(af_p2452);

	property af_p2453;
	@(posedge wb_clk_i) ($past(t1_wb_ack_i) && !$stable(t1_wb_sel_o)) |-> t1_wb_stb_o;
	endproperty
	assert property(af_p2453);

	property af_p2454;
	@(posedge t1_wb_cyc_o) t1_wb_cyc_o throughout (t1_wb_sel_o == $past(t1_wb_sel_o))[->1] ##0 t1_wb_ack_i;
	endproperty
	assert property(af_p2454);

	property af_p2455;
	@(posedge wb_clk_i) (wb_rst_i) |=> (t1_wb_sel_o == '0);
	endproperty
	assert property(af_p2455);

	property af_p2456;
	@(posedge wb_clk_i) (t1_wb_ack_i) |-> $stable(t1_wb_sel_o);
	endproperty
	assert property(af_p2456);


	property af_p2458;
	@(posedge wb_clk_i) (1'b1) |-> ($stable(t1_wb_sel_o) || $changed(t1_wb_sel_o));
	endproperty
	assert property(af_p2458);

	property af_p2459;
	@(posedge wb_clk_i) (t1_wb_stb_o && !t1_wb_ack_i) |-> ##1 (t1_wb_sel_o == $past(t1_wb_sel_o));
	endproperty
	assert property(af_p2459);

	property af_p2460;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t1_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p2460);

	property af_p2461;
	@(posedge wb_clk_i) (wb_rst_i) |-> ##[1:2] (t1_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p2461);

	property af_p2462;
	@(posedge wb_clk_i) (t1_wb_we_o) |-> (t1_wb_sel_o != 4'b0000);
	endproperty
	assert property(af_p2462);

	property af_p2463;
	@(posedge wb_clk_i) (t1_wb_stb_o) |-> (t1_wb_sel_o != 4'b0000);
	endproperty
	assert property(af_p2463);

	property af_p2464;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (1) |-> (t1_wb_sel_o >= 4'h0) && (t1_wb_sel_o <= 4'hF);
	endproperty
	assert property(af_p2464);

	property af_p2465;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_stb_o) |-> (t1_wb_sel_o !== '0);
	endproperty
	assert property(af_p2465);

	property af_p2466;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] (t1_wb_sel_o !== 'x);
	endproperty
	assert property(af_p2466);

	property af_p2467;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t1_wb_sel_o !== '0) && (t1_wb_sel_o !== 'x));
	endproperty
	assert property(af_p2467);

	property af_p2468;
	@(posedge wb_clk_i) (t1_wb_cyc_o) |-> (t1_wb_sel_o !== 'x);
	endproperty
	assert property(af_p2468);

	property af_p2469;
	@(posedge wb_clk_i) $fell(t1_wb_cyc_o) |=> (t1_wb_sel_o == '0);
	endproperty
	assert property(af_p2469);

	property af_p2470;
	@(posedge wb_clk_i) (t1_wb_we_o && (t1_wb_dat_o !== 'x)) |-> ((t1_wb_sel_o !== 'x) && $stable(t1_wb_sel_o));
	endproperty
	assert property(af_p2470);

	property af_p2471;
	@(posedge wb_clk_i) (!t1_wb_cyc_o) |-> $stable(t1_wb_sel_o);
	endproperty
	assert property(af_p2471);

	property af_p2472;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!t1_wb_stb_o ##1 !t1_wb_stb_o);
	endproperty
	assert property(af_p2472);

	property af_p2473;
	@(posedge wb_clk_i) !t1_wb_cyc_o |-> !t1_wb_stb_o;
	endproperty
	assert property(af_p2473);

	property af_p2474;
	@(posedge wb_clk_i) (t1_wb_stb_o && t1_wb_we_o) |-> ((t1_wb_adr_o == $past(t1_wb_adr_o)) && (t1_wb_dat_o == $past(t1_wb_dat_o))) until t1_wb_ack_i;
	endproperty
	assert property(af_p2474);

	property af_p2475;
	@(posedge wb_clk_i) t1_wb_stb_o |-> $stable(t1_wb_adr_o);
	endproperty
	assert property(af_p2475);

	property af_p2476;
	@(posedge wb_clk_i) $fell(t1_wb_stb_o) |-> (!t1_wb_stb_o until t1_wb_cyc_o);
	endproperty
	assert property(af_p2476);

	property af_p2477;
	@(posedge wb_clk_i) $rose(t1_wb_ack_i) |-> ##1 !t1_wb_stb_o;
	endproperty
	assert property(af_p2477);

	property af_p2478;
	@(posedge wb_clk_i) t1_wb_stb_o |-> t1_wb_cyc_o;
	endproperty
	assert property(af_p2478);

	property af_p2479;
	@(posedge wb_clk_i) wb_rst_i |-> !t1_wb_stb_o;
	endproperty
	assert property(af_p2479);

	property af_p2480;
	@(posedge wb_clk_i) t1_wb_cyc_o |-> ($stable(t1_wb_stb_o) || $rose(t1_wb_stb_o) || $fell(t1_wb_stb_o));
	endproperty
	assert property(af_p2480);

	property af_p2481;
	@(posedge wb_clk_i) t1_wb_stb_o |-> (t1_wb_stb_o until (t1_wb_ack_i || t1_wb_err_i));
	endproperty
	assert property(af_p2481);

	property af_p2482;
	@(posedge wb_clk_i) 1 |-> ($stable(t1_wb_stb_o) || $rose(t1_wb_stb_o) || $fell(t1_wb_stb_o));
	endproperty
	assert property(af_p2482);

	property af_p2483;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t1_wb_stb_o ##1 !t1_wb_stb_o ##1 !t1_wb_stb_o);
	endproperty
	assert property(af_p2483);

	property af_p2484;
	@(posedge wb_clk_i) (t1_wb_stb_o && t1_wb_cyc_o) |-> ($rose(t1_wb_stb_o) && $rose(t1_wb_cyc_o));
	endproperty
	assert property(af_p2484);

	property af_p2485;
	@(posedge wb_clk_i) (t1_wb_stb_o && t1_wb_ack_i) |=> !t1_wb_stb_o;
	endproperty
	assert property(af_p2485);

	property af_p2486;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (!t1_wb_stb_o)[*3];
	endproperty
	assert property(af_p2486);

	property af_p2487;
	@(posedge wb_clk_i) t1_wb_stb_o |-> (!wb_rst_i && $past(!wb_rst_i));
	endproperty
	assert property(af_p2487);

	property af_p2488;
	@(posedge wb_clk_i) t1_wb_ack_i |-> ##1 !t1_wb_stb_o;
	endproperty
	assert property(af_p2488);

	property af_p2489;
	@(posedge wb_clk_i) $changed(t1_wb_we_o) |-> t1_wb_stb_o;
	endproperty
	assert property(af_p2489);

	property af_p2490;
	@(posedge wb_clk_i) t1_wb_stb_o |-> (t1_wb_stb_o until t1_wb_ack_i);
	endproperty
	assert property(af_p2490);

	property af_p2491;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> !t1_wb_stb_o;
	endproperty
	assert property(af_p2491);

	property af_p2492;
	@(posedge wb_clk_i) (t1_wb_stb_o && t1_wb_we_o) |-> $stable(t1_wb_dat_o) until t1_wb_ack_i;
	endproperty
	assert property(af_p2492);

	property af_p2493;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (!t1_wb_stb_o)[*2];
	endproperty
	assert property(af_p2493);

	property af_p2494;
	@(posedge wb_clk_i) t1_wb_stb_o |-> ##[0:16] t1_wb_ack_i;
	endproperty
	assert property(af_p2494);

	property af_p2495;
	@(posedge wb_clk_i) t1_wb_stb_o |-> (t1_wb_stb_o until_with t1_wb_ack_i);
	endproperty
	assert property(af_p2495);

	property af_p2496;
	@(posedge wb_clk_i) t1_wb_stb_o |-> (!$isunknown(t1_wb_adr_o) && $stable(t1_wb_adr_o));
	endproperty
	assert property(af_p2496);

	property af_p2497;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t1_wb_stb_o[*2];
	endproperty
	assert property(af_p2497);

	property af_p2498;
	@(posedge wb_clk_i) (t1_wb_stb_o && t1_wb_err_i) |-> ##1 !t1_wb_stb_o;
	endproperty
	assert property(af_p2498);

	property af_p2499;
	@(posedge wb_clk_i) t1_wb_stb_o |-> !$isunknown(t1_wb_sel_o);
	endproperty
	assert property(af_p2499);

	property af_p2500;
	@(posedge wb_clk_i) t1_wb_err_i |-> ##[0:1] !t1_wb_stb_o;
	endproperty
	assert property(af_p2500);

	property af_p2501;
	@(posedge wb_clk_i) (!t1_wb_stb_o) |-> !(t1_wb_we_o && t1_wb_stb_o);
	endproperty
	assert property(af_p2501);

	property af_p2502;
	@(posedge wb_clk_i) (!t1_wb_cyc_o) |-> (t1_wb_we_o == 1'b0);
	endproperty
	assert property(af_p2502);

	property af_p2503;
	@(posedge wb_clk_i) (t1_wb_stb_o) |-> $stable(t1_wb_we_o);
	endproperty
	assert property(af_p2503);

	property af_p2504;
	@(posedge wb_clk_i) (t1_wb_ack_i) |-> $stable(t1_wb_we_o);
	endproperty
	assert property(af_p2504);

	property af_p2505;
	@(posedge wb_clk_i) (t1_wb_cyc_o) |-> $stable(t1_wb_we_o) throughout (t1_wb_cyc_o[->1] ##0 t1_wb_ack_i[->1]);
	endproperty
	assert property(af_p2505);

	property af_p2506;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 !$isunknown(t1_wb_we_o);
	endproperty
	assert property(af_p2506);

	property af_p2507;
	@(posedge wb_clk_i) (t1_wb_we_o && t1_wb_stb_o) |-> $stable(t1_wb_dat_o) || !$isunknown(t1_wb_dat_o);
	endproperty
	assert property(af_p2507);

	property af_p2508;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_stb_o) |-> !$isunknown(t1_wb_we_o) throughout (t1_wb_cyc_o && t1_wb_stb_o)[*1:$];
	endproperty
	assert property(af_p2508);

	property af_p2509;
	@(posedge wb_clk_i) (i0_wb_we_i) |-> (t1_wb_we_o == i0_wb_we_i);
	endproperty
	assert property(af_p2509);

	property af_p2510;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t1_wb_we_o == 1'b0);
	endproperty
	assert property(af_p2510);

	property af_p2511;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (!t1_wb_we_o)[*2];
	endproperty
	assert property(af_p2511);

	property af_p2512;
	@(posedge wb_clk_i) !t1_wb_cyc_o |-> ##1 $stable(t1_wb_we_o);
	endproperty
	assert property(af_p2512);

	property af_p2513;
	@(posedge wb_clk_i) !wb_rst_i |-> !$isunknown(t1_wb_we_o);
	endproperty
	assert property(af_p2513);

	property af_p2514;
	@(posedge wb_clk_i) t1_wb_ack_i |-> ##1 !t1_wb_we_o;
	endproperty
	assert property(af_p2514);

	property af_p2515;
	@(posedge wb_clk_i) t1_wb_we_o |-> (t1_wb_cyc_o && !$isunknown(t1_wb_adr_o));
	endproperty
	assert property(af_p2515);

	property af_p2516;
	@(posedge wb_clk_i) t1_wb_cyc_o |-> !$isunknown(t1_wb_we_o);
	endproperty
	assert property(af_p2516);

	property af_p2517;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_we_o) |-> (t1_wb_we_o until t1_wb_ack_i);
	endproperty
	assert property(af_p2517);

	property af_p2518;
	@(posedge wb_clk_i) $fell(t1_wb_we_o) |-> (!$past(t1_wb_cyc_o) || !t1_wb_we_o);
	endproperty
	assert property(af_p2518);

	property af_p2519;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_stb_o && !t1_wb_ack_i) |-> $stable(t1_wb_we_o);
	endproperty
	assert property(af_p2519);

	property af_p2520;
	@(posedge wb_clk_i) (i1_wb_cyc_i && i1_wb_stb_i) |-> (t1_wb_we_o == i1_wb_we_i);
	endproperty
	assert property(af_p2520);

	property af_p2521;
	@(posedge wb_clk_i) wb_rst_i |-> !t1_wb_we_o;
	endproperty
	assert property(af_p2521);

	property af_p2522;
	@(posedge wb_clk_i) t1_wb_we_o |-> (t1_wb_cyc_o && t1_wb_stb_o);
	endproperty
	assert property(af_p2522);

	property af_p2523;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_stb_o && !t1_wb_ack_i) |=> $stable(t1_wb_we_o);
	endproperty
	assert property(af_p2523);

	property af_p2524;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t1_wb_we_o;
	endproperty
	assert property(af_p2524);

	property af_p2525;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_stb_o) |-> (t1_wb_we_o == i0_wb_we_i);
	endproperty
	assert property(af_p2525);

	property af_p2526;
	@(posedge wb_clk_i) (t1_wb_cyc_o && t1_wb_stb_o && i2_wb_we_i) |-> t1_wb_we_o;
	endproperty
	assert property(af_p2526);

	property af_p2527;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> !t1_wb_we_o;
	endproperty
	assert property(af_p2527);

	property af_p2528;
	@(posedge wb_clk_i) (!t1_wb_stb_o) |-> !t1_wb_we_o;
	endproperty
	assert property(af_p2528);

	property af_p2529;
	@(posedge wb_clk_i) (t2_wb_we_o && t2_wb_stb_o && t2_wb_cyc_o) |=> t2_wb_ack_i;
	endproperty
	assert property(af_p2529);

	property af_p2530;
	@(posedge wb_clk_i) (t2_wb_ack_i) |-> (t2_wb_cyc_o && t2_wb_stb_o);
	endproperty
	assert property(af_p2530);

	property af_p2531;
	@(posedge wb_clk_i) (t2_wb_cyc_o && t2_wb_stb_o) |=> (t2_wb_ack_i) ##1 !t2_wb_ack_i;
	endproperty
	assert property(af_p2531);

	property af_p2532;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (!t2_wb_ack_i throughout (!t2_wb_stb_o)[*1:$]);
	endproperty
	assert property(af_p2532);

	property af_p2533;
	@(posedge wb_clk_i) (t2_wb_ack_i && !t2_wb_we_o) |-> ($stable(t2_wb_dat_i) && !$isunknown(t2_wb_dat_i));
	endproperty
	assert property(af_p2533);

	property af_p2534;
	@(posedge wb_clk_i) (t2_wb_we_o && t2_wb_ack_i) |=> !t2_wb_ack_i;
	endproperty
	assert property(af_p2534);

	property af_p2535;
	@(posedge wb_clk_i) (t2_wb_cyc_o && t2_wb_stb_o) |=> (t2_wb_ack_i && !$past(t2_wb_ack_i)) ##1 !t2_wb_ack_i;
	endproperty
	assert property(af_p2535);

	property af_p2536;
	@(posedge wb_clk_i) (t2_wb_cyc_o && t2_wb_stb_o) |=> t2_wb_ack_i;
	endproperty
	assert property(af_p2536);

	property af_p2537;
	@(posedge wb_clk_i) (!t2_wb_stb_o) |-> (!t2_wb_ack_i);
	endproperty
	assert property(af_p2537);

	property af_p2538;
	@(posedge wb_clk_i) (t2_wb_ack_i) |-> ($stable(t2_wb_dat_i) && !$isunknown(t2_wb_dat_i));
	endproperty
	assert property(af_p2538);

	property af_p2539;
	@(posedge wb_clk_i) ($past(t2_wb_ack_i) && !t2_wb_stb_o) |-> (t2_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p2539);

	property af_p2540;
	@(posedge wb_clk_i) !(t2_wb_ack_i && t2_wb_err_i);
	endproperty
	assert property(af_p2540);

	property af_p2541;
	@(posedge wb_clk_i) (t2_wb_ack_i) |=> !t2_wb_ack_i;
	endproperty
	assert property(af_p2541);

	property af_p2542;
	@(posedge wb_clk_i) (!t2_wb_cyc_o) |-> (!t2_wb_ack_i);
	endproperty
	assert property(af_p2542);

	property af_p2543;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (t2_wb_ack_i == 1'b0) throughout (!(t2_wb_cyc_o && t2_wb_stb_o))[*0:$];
	endproperty
	assert property(af_p2543);

	property af_p2544;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t2_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p2544);

	property af_p2545;
	@(posedge wb_clk_i) (t2_wb_ack_i) |-> !(t2_wb_err_i);
	endproperty
	assert property(af_p2545);

	property af_p2546;
	@(posedge wb_clk_i) (t2_wb_stb_o && t2_wb_cyc_o) |-> ##[1:16] (t2_wb_ack_i);
	endproperty
	assert property(af_p2546);

	property af_p2547;
	@(posedge wb_clk_i) $fell(t2_wb_cyc_o) |=> !t2_wb_ack_i;
	endproperty
	assert property(af_p2547);

	property af_p2548;
	@(posedge wb_clk_i) t2_wb_ack_i |-> (t2_wb_cyc_o && t2_wb_stb_o);
	endproperty
	assert property(af_p2548);

	property af_p2549;
	@(posedge wb_clk_i) t2_wb_ack_i |=> !t2_wb_stb_o;
	endproperty
	assert property(af_p2549);

	property af_p2550;
	@(posedge wb_clk_i) t2_wb_ack_i |-> t2_wb_cyc_o;
	endproperty
	assert property(af_p2550);

	property af_p2551;
	@(posedge wb_clk_i) wb_rst_i |-> !t2_wb_ack_i;
	endproperty
	assert property(af_p2551);

	property af_p2552;
	@(posedge wb_clk_i) $rose(t2_wb_stb_o) |-> !t2_wb_ack_i;
	endproperty
	assert property(af_p2552);

	property af_p2553;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t2_wb_ack_i;
	endproperty
	assert property(af_p2553);

	property af_p2554;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (t2_wb_adr_o == '0);
	endproperty
	assert property(af_p2554);

	property af_p2555;
	@(posedge wb_clk_i) wb_rst_i |-> (!$isunknown(t2_wb_adr_o) && $stable(t2_wb_adr_o));
	endproperty
	assert property(af_p2555);

	property af_p2556;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> !$isunknown(t2_wb_adr_o);
	endproperty
	assert property(af_p2556);

	property af_p2557;
	@(posedge wb_clk_i) t2_wb_we_o |-> (t2_wb_adr_o inside {[0:65535]});
	endproperty
	assert property(af_p2557);

	property af_p2558;
	@(posedge wb_clk_i) t2_wb_cyc_o |-> !$isunknown(t2_wb_adr_o);
	endproperty
	assert property(af_p2558);

	property af_p2559;
	@(posedge wb_clk_i) $fell(t2_wb_cyc_o) |=> 1'b1;
	endproperty
	assert property(af_p2559);

	property af_p2560;
	@(posedge wb_clk_i) (t2_wb_cyc_o && t2_wb_stb_o) |-> $stable(t2_wb_adr_o) until_with (t2_wb_ack_i);
	endproperty
	assert property(af_p2560);

	property af_p2561;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] !$isunknown(t2_wb_adr_o);
	endproperty
	assert property(af_p2561);

	property af_p2562;
	@(posedge wb_clk_i) (t2_wb_stb_o && !t2_wb_ack_i) |=> $stable(t2_wb_adr_o);
	endproperty
	assert property(af_p2562);

	property af_p2563;
	@(posedge wb_clk_i) (t2_wb_ack_i || t2_wb_err_i) |-> $stable(t2_wb_adr_o);
	endproperty
	assert property(af_p2563);

	property af_p2564;
	@(posedge wb_clk_i) (t2_wb_cyc_o) |-> ($stable(t2_wb_adr_o) || $changed(t2_wb_adr_o));
	endproperty
	assert property(af_p2564);

	property af_p2565;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t2_wb_adr_o == 0);
	endproperty
	assert property(af_p2565);

	property af_p2566;
	@(posedge wb_clk_i) (t2_wb_cyc_o && t2_wb_stb_o && (t2_wb_adr_o >= 0) && (t2_wb_adr_o <= 4095)) |=> (((t2_wb_adr_o >= 0) && (t2_wb_adr_o <= 4095)) until (t2_wb_ack_i));
	endproperty
	assert property(af_p2566);

	property af_p2567;
	@(posedge wb_clk_i) (!t2_wb_ack_i) |-> (t2_wb_adr_o == $past(t2_wb_adr_o));
	endproperty
	assert property(af_p2567);

	property af_p2568;
	@(posedge wb_clk_i) (t2_wb_we_o && t2_wb_stb_o) |=> $stable(t2_wb_adr_o);
	endproperty
	assert property(af_p2568);

	property af_p2569;
	@(posedge wb_clk_i) (!t2_wb_ack_i) |=> $stable(t2_wb_adr_o);
	endproperty
	assert property(af_p2569);

	property af_p2570;
	@(posedge wb_clk_i) ($fell(t2_wb_cyc_o)) |=> ($changed(t2_wb_adr_o));
	endproperty
	assert property(af_p2570);

	property af_p2571;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##3 (t2_wb_cyc_o -> (t2_wb_adr_o >= 0 && t2_wb_adr_o <= 65535));
	endproperty
	assert property(af_p2571);

	property af_p2572;
	@(posedge wb_clk_i) (t2_wb_cyc_o && t2_wb_stb_o) |-> ($stable(t2_wb_adr_o) until (t2_wb_ack_i || t2_wb_err_i));
	endproperty
	assert property(af_p2572);

	property af_p2573;
	@(posedge wb_clk_i) ($past(t2_wb_ack_i) && t2_wb_stb_o) |-> (t2_wb_adr_o != $past(t2_wb_adr_o));
	endproperty
	assert property(af_p2573);

	property af_p2574;
	@(posedge wb_clk_i) (t2_wb_stb_o) |-> (!$isunknown(t2_wb_adr_o));
	endproperty
	assert property(af_p2574);

	property af_p2575;
	@(posedge wb_clk_i) (t2_wb_stb_o && !t2_wb_ack_i) |=> ($stable(t2_wb_adr_o));
	endproperty
	assert property(af_p2575);

	property af_p2576;
	@(posedge wb_clk_i) (t2_wb_cyc_o && t2_wb_stb_o && !t2_wb_ack_i) |=> ($stable(t2_wb_adr_o));
	endproperty
	assert property(af_p2576);

	property af_p2577;
	@(posedge wb_clk_i) (!t2_wb_stb_o) |=> (t2_wb_adr_o == $past(t2_wb_adr_o));
	endproperty
	assert property(af_p2577);

	property af_p2578;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t2_wb_adr_o == '0);
	endproperty
	assert property(af_p2578);

	property af_p2579;
	@(posedge wb_clk_i) (t2_wb_err_i) |=> (t2_wb_adr_o == $past(t2_wb_adr_o));
	endproperty
	assert property(af_p2579);

	property af_p2580;
	@(posedge wb_clk_i) (t2_wb_ack_i && !t2_wb_cyc_o) |=> (t2_wb_adr_o != $past(t2_wb_adr_o));
	endproperty
	assert property(af_p2580);

	property af_p2581;
	@(posedge wb_clk_i) (t2_wb_we_o && t2_wb_cyc_o && t2_wb_stb_o) |-> ($stable(t2_wb_adr_o));
	endproperty
	assert property(af_p2581);

	property af_p2582;
	@(posedge wb_clk_i) (!wb_rst_i && !t2_wb_cyc_o) |-> (!$isunknown(t2_wb_adr_o));
	endproperty
	assert property(af_p2582);

	property af_p2583;
	@(posedge t2_wb_cyc_o) (t2_wb_cyc_o) |-> ($stable(t2_wb_adr_o) || $changed(t2_wb_adr_o));
	endproperty
	assert property(af_p2583);

	property af_p2584;
	@(posedge wb_clk_i) (t2_wb_ack_i) |=> (t2_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2584);

	property af_p2585;
	@(posedge wb_clk_i) ($fell(t2_wb_cyc_o) && $past(t2_wb_ack_i)) |=> (t2_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2585);

	property af_p2586;
	@(posedge wb_clk_i) ($rose(t2_wb_cyc_o)) |-> ($past(t2_wb_cyc_o) == 1'b0);
	endproperty
	assert property(af_p2586);

	property af_p2587;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 (t2_wb_cyc_o == 1'b0) throughout (!$rose(t2_wb_cyc_o))[*1:$];
	endproperty
	assert property(af_p2587);

	property af_p2588;
	@(posedge wb_clk_i) (t2_wb_cyc_o) |-> ($stable(t2_wb_adr_o) until t2_wb_ack_i);
	endproperty
	assert property(af_p2588);

	property af_p2589;
	@(posedge wb_rst_i) (wb_rst_i) |-> (t2_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2589);

	property af_p2590;
	@(posedge wb_clk_i) ($rose(t2_wb_cyc_o)) |-> (t2_wb_cyc_o == 1'b1);
	endproperty
	assert property(af_p2590);

	property af_p2591;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (t2_wb_cyc_o == 1'b1);
	endproperty
	assert property(af_p2591);

	property af_p2592;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t2_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2592);

	property af_p2593;
	@(posedge wb_clk_i) ($rose(t2_wb_cyc_o)) |-> (t2_wb_cyc_o until t2_wb_ack_i);
	endproperty
	assert property(af_p2593);

	property af_p2594;
	@(posedge t2_wb_ack_i) ($fell(t2_wb_cyc_o)) |-> ($past(t2_wb_ack_i) || $past(t2_wb_err_i));
	endproperty
	assert property(af_p2594);

	property af_p2595;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |=> (t2_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2595);

	property af_p2596;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> !t2_wb_cyc_o[*2];
	endproperty
	assert property(af_p2596);

	property af_p2597;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##[1:2] !t2_wb_cyc_o;
	endproperty
	assert property(af_p2597);

	property af_p2598;
	@(posedge wb_clk_i) t2_wb_we_o |-> $stable(t2_wb_cyc_o);
	endproperty
	assert property(af_p2598);

	property af_p2599;
	@(posedge wb_clk_i) $rose(t2_wb_stb_o) |-> t2_wb_cyc_o;
	endproperty
	assert property(af_p2599);

	property af_p2600;
	@(posedge wb_clk_i) t2_wb_ack_i |-> ##[0:1] !t2_wb_cyc_o;
	endproperty
	assert property(af_p2600);

	property af_p2601;
	@(posedge wb_clk_i) t2_wb_cyc_o |-> $stable(t2_wb_dat_o) throughout (t2_wb_ack_i[->1]);
	endproperty
	assert property(af_p2601);

	property af_p2602;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t2_wb_cyc_o;
	endproperty
	assert property(af_p2602);

	property af_p2603;
	@(posedge wb_clk_i) t2_wb_cyc_o |-> $stable(t2_wb_we_o) throughout (t2_wb_ack_i[->1]);
	endproperty
	assert property(af_p2603);

	property af_p2604;
	@(posedge wb_clk_i) $rose(t2_wb_err_i) |=> !t2_wb_cyc_o;
	endproperty
	assert property(af_p2604);

	property af_p2605;
	@(posedge wb_clk_i) t2_wb_ack_i |=> !t2_wb_cyc_o;
	endproperty
	assert property(af_p2605);

	property af_p2606;
	@(posedge wb_clk_i) t2_wb_cyc_o |-> $stable(t2_wb_adr_o);
	endproperty
	assert property(af_p2606);

	property af_p2607;
	@(posedge wb_clk_i) $fell(t2_wb_cyc_o) |-> ##1 (t2_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2607);

	property af_p2608;
	@(posedge wb_clk_i) t2_wb_stb_o |-> t2_wb_cyc_o;
	endproperty
	assert property(af_p2608);

	property af_p2609;
	@(posedge wb_clk_i) (t2_wb_cyc_o && !$past(t2_wb_ack_i) && !$past(t2_wb_err_i)) |-> $stable(t2_wb_cyc_o);
	endproperty
	assert property(af_p2609);

	property af_p2610;
	@(posedge wb_clk_i) $rose(t2_wb_err_i) |-> ##1 (t2_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2610);

	property af_p2611;
	@(posedge wb_clk_i) (!t2_wb_stb_o) |-> (t2_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2611);

	property af_p2612;
	@(posedge wb_clk_i) $fell(t2_wb_cyc_o) |-> ##1 $stable(t2_wb_sel_o);
	endproperty
	assert property(af_p2612);

	property af_p2613;
	@(posedge wb_clk_i) $rose(t2_wb_cyc_o) |-> t2_wb_stb_o;
	endproperty
	assert property(af_p2613);

	property af_p2614;
	@(posedge wb_clk_i) t2_wb_cyc_o |-> t2_wb_stb_o;
	endproperty
	assert property(af_p2614);

	property af_p2615;
	@(posedge wb_clk_i) $rose(t2_wb_cyc_o) |-> t2_wb_cyc_o until_with (t2_wb_ack_i);
	endproperty
	assert property(af_p2615);

	property af_p2616;
	@(posedge wb_clk_i) (t2_wb_stb_o && $stable(t2_wb_stb_o)) |-> $stable(t2_wb_cyc_o);
	endproperty
	assert property(af_p2616);

	property af_p2617;
	@(posedge wb_clk_i) ((t2_wb_dat_i >= 100) && (t2_wb_dat_i <= 150)) |-> ##1 ((t2_wb_dat_i >= 80) && (t2_wb_dat_i <= 170));
	endproperty
	assert property(af_p2617);

	property af_p2618;
	@(posedge wb_clk_i) ($past(t2_wb_ack_i) && !t2_wb_ack_i && ($past(t2_wb_dat_i) >= 200) && ($past(t2_wb_dat_i) <= 255)) |-> ##[1:2] ((t2_wb_dat_i >= 0) && (t2_wb_dat_i <= 55));
	endproperty
	assert property(af_p2618);

	property af_p2619;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##5 ((t2_wb_dat_i >= 0) && (t2_wb_dat_i <= 128));
	endproperty
	assert property(af_p2619);

	property af_p2620;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t2_wb_dat_i >= 0) && (t2_wb_dat_i <= 255));
	endproperty
	assert property(af_p2620);

	property af_p2621;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t2_wb_dat_i >= 16) && (t2_wb_dat_i <= 239));
	endproperty
	assert property(af_p2621);

	property af_p2622;
	@(posedge wb_clk_i) ((t2_wb_dat_i >= 100) && (t2_wb_dat_i <= 200)) |-> ##1 ((t2_wb_dat_i >= 80) && (t2_wb_dat_i <= 220));
	endproperty
	assert property(af_p2622);

	property af_p2623;
	@(posedge wb_clk_i) t2_wb_ack_i |-> !$isunknown(t2_wb_dat_i);
	endproperty
	assert property(af_p2623);

	property af_p2624;
	@(posedge wb_clk_i) (t2_wb_cyc_o && t2_wb_stb_o) |-> !$isunknown(t2_wb_dat_i);
	endproperty
	assert property(af_p2624);

	property af_p2625;
	@(posedge wb_clk_i) (($past(t2_wb_dat_i) >= 10) && ($past(t2_wb_dat_i) <= 20) && $past(t2_wb_ack_i) && !t2_wb_ack_i) |-> 1'b1;
	endproperty
	assert property(af_p2625);

	property af_p2626;
	@(posedge wb_clk_i) (!t2_wb_we_o && (t2_wb_dat_i >= 50) && (t2_wb_dat_i <= 200)) |-> (##1 ((t2_wb_dat_i >= 30) && (t2_wb_dat_i <= 220)) ##1 ((t2_wb_dat_i >= 30) && (t2_wb_dat_i <= 220)));
	endproperty
	assert property(af_p2626);

	property af_p2627;
	@(posedge wb_clk_i) (t2_wb_cyc_o && t2_wb_stb_o) |-> ##1 ((t2_wb_dat_i >= 0) && (t2_wb_dat_i <= 255));
	endproperty
	assert property(af_p2627);

	property af_p2628;
	@(posedge wb_clk_i) (!t2_wb_we_o && t2_wb_ack_i) |-> (t2_wb_dat_i >= 0) && (t2_wb_dat_i <= 255);
	endproperty
	assert property(af_p2628);

	property af_p2629;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (t2_wb_dat_i >= 0) && (t2_wb_dat_i <= 128);
	endproperty
	assert property(af_p2629);

	property af_p2630;
	@(posedge wb_clk_i) (!t2_wb_cyc_o) |-> 1'b1;
	endproperty
	assert property(af_p2630);

	property af_p2631;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (t2_wb_dat_i >= 0) && (t2_wb_dat_i <= 63);
	endproperty
	assert property(af_p2631);

	property af_p2632;
	@(posedge wb_clk_i) (t2_wb_cyc_o && t2_wb_stb_o && !t2_wb_we_o) |-> s_eventually (t2_wb_ack_i && (t2_wb_dat_i >= 0) && (t2_wb_dat_i <= 255));
	endproperty
	assert property(af_p2632);

	property af_p2633;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t2_wb_dat_i == $past(t2_wb_dat_i));
	endproperty
	assert property(af_p2633);

	property af_p2634;
	@(posedge wb_clk_i) ((t2_wb_dat_i >= 200) && (t2_wb_dat_i <= 255)) |-> (t2_wb_dat_i >= 180) && (t2_wb_dat_i <= 255);
	endproperty
	assert property(af_p2634);

	property af_p2635;
	@(posedge wb_clk_i) (!t2_wb_stb_o) |-> (t2_wb_dat_i == $past(t2_wb_dat_i));
	endproperty
	assert property(af_p2635);

	property af_p2636;
	@(posedge wb_clk_i) (t2_wb_ack_i) |-> $sampled(t2_wb_dat_i);
	endproperty
	assert property(af_p2636);

	property af_p2637;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (t2_wb_dat_i >= 0) && (t2_wb_dat_i <= 64);
	endproperty
	assert property(af_p2637);

	property af_p2638;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t2_wb_dat_i >= 0) && (t2_wb_dat_i <= 255);
	endproperty
	assert property(af_p2638);

	property af_p2639;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (t2_wb_dat_i == 0);
	endproperty
	assert property(af_p2639);

	property af_p2640;
	@(posedge wb_clk_i) ((t2_wb_dat_i >= 64) && (t2_wb_dat_i <= 191)) |=> (t2_wb_dat_i >= 32) && (t2_wb_dat_i <= 223);
	endproperty
	assert property(af_p2640);

	property af_p2641;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (t2_wb_dat_i >= 0) && (t2_wb_dat_i <= 15);
	endproperty
	assert property(af_p2641);

	property af_p2642;
	@(posedge wb_clk_i) $changed(t2_wb_adr_o) |-> $changed(t2_wb_dat_i);
	endproperty
	assert property(af_p2642);

	property af_p2643;
	@(posedge wb_clk_i) ((t2_wb_dat_i >= 50) && (t2_wb_dat_i <= 150)) |=> (t2_wb_dat_i >= 30) && (t2_wb_dat_i <= 170);
	endproperty
	assert property(af_p2643);

	property af_p2644;
	@(posedge wb_clk_i) (t2_wb_ack_i) |-> $stable(t2_wb_dat_i);
	endproperty
	assert property(af_p2644);

	property af_p2645;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(t2_wb_dat_i);
	endproperty
	assert property(af_p2645);

	property af_p2646;
	@(posedge wb_clk_i) (t2_wb_err_i) |-> (t2_wb_dat_i == $past(t2_wb_dat_i));
	endproperty
	assert property(af_p2646);

	property af_p2647;
	@(posedge wb_clk_i) $changed(t2_wb_we_o) |-> !$isunknown(t2_wb_dat_i);
	endproperty
	assert property(af_p2647);

	property af_p2648;
	@(posedge wb_clk_i) (!t2_wb_stb_o) |-> $stable(t2_wb_dat_i);
	endproperty
	assert property(af_p2648);

	property af_p2649;
	@(posedge wb_clk_i) (t2_wb_cyc_o && !t2_wb_stb_o) |-> $stable(t2_wb_dat_o);
	endproperty
	assert property(af_p2649);

	property af_p2650;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 ((t2_wb_dat_o >= 0) && (t2_wb_dat_o <= 255));
	endproperty
	assert property(af_p2650);

	property af_p2651;
	@(posedge wb_clk_i) ((t2_wb_dat_o >= 200) && (t2_wb_dat_o <= 255) && t2_wb_stb_o) |=> ((t2_wb_dat_o >= 200) && (t2_wb_dat_o <= 255));
	endproperty
	assert property(af_p2651);

	property af_p2652;
	@(posedge wb_clk_i) (t2_wb_err_i) |=> ($stable(t2_wb_dat_o) until_with t2_wb_stb_o);
	endproperty
	assert property(af_p2652);

	property af_p2653;
	@(posedge wb_clk_i) (t2_wb_cyc_o && t2_wb_stb_o && !t2_wb_we_o) |-> ($stable(t2_wb_dat_o) until_with t2_wb_ack_i);
	endproperty
	assert property(af_p2653);

	property af_p2654;
	@(posedge wb_clk_i) (!t2_wb_we_o && t2_wb_stb_o) |=> ((t2_wb_dat_o >= 0) && (t2_wb_dat_o <= 255));
	endproperty
	assert property(af_p2654);

	property af_p2655;
	@(posedge wb_clk_i) (t2_wb_adr_o[$bits(t2_wb_adr_o)-1] == 1'b1) |-> ((t2_wb_dat_o >= 128) && (t2_wb_dat_o <= 255));
	endproperty
	assert property(af_p2655);

	property af_p2656;
	@(posedge wb_clk_i) (!t2_wb_we_o && t2_wb_stb_o) |-> ((t2_wb_dat_o >= 0) && (t2_wb_dat_o <= 255)) until_with (!t2_wb_stb_o);
	endproperty
	assert property(af_p2656);

	property af_p2657;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t2_wb_dat_o >= 0) && (t2_wb_dat_o <= 255));
	endproperty
	assert property(af_p2657);

	property af_p2658;
	@(posedge wb_clk_i) ((t2_wb_dat_o >= 100) && (t2_wb_dat_o <= 150)) |=> ((t2_wb_dat_o >= 80) && (t2_wb_dat_o <= 150));
	endproperty
	assert property(af_p2658);

	property af_p2659;
	@(posedge wb_clk_i) $changed(t2_wb_dat_o) |-> (t2_wb_cyc_o && t2_wb_stb_o);
	endproperty
	assert property(af_p2659);

	property af_p2660;
	@(posedge wb_clk_i) ((t2_wb_dat_o >= 100) && (t2_wb_dat_o <= 150)) |-> ##[1:$] ((t2_wb_dat_o >= 80) && (t2_wb_dat_o <= 150));
	endproperty
	assert property(af_p2660);

	property af_p2661;
	@(posedge wb_clk_i) (t2_wb_dat_o >= 200 && t2_wb_dat_o <= 255) |=> (t2_wb_dat_o >= 180 && t2_wb_dat_o <= 255);
	endproperty
	assert property(af_p2661);

	property af_p2662;
	@(posedge wb_clk_i) t2_wb_ack_i |-> ($stable(t2_wb_dat_o) && (t2_wb_dat_o >= 0 && t2_wb_dat_o <= 255));
	endproperty
	assert property(af_p2662);

	property af_p2663;
	@(posedge wb_clk_i) ((t2_wb_dat_o >= 100 && t2_wb_dat_o <= 150) && t2_wb_cyc_o) |=> (t2_wb_cyc_o && (t2_wb_dat_o >= 90 && t2_wb_dat_o <= 150));
	endproperty
	assert property(af_p2663);

	property af_p2664;
	@(posedge wb_clk_i) (!t2_wb_we_o && t2_wb_ack_i) |-> (!$isunknown(t2_wb_dat_o));
	endproperty
	assert property(af_p2664);

	property af_p2665;
	@(posedge wb_clk_i) !$past(t2_wb_ack_i) |-> $stable(t2_wb_dat_o);
	endproperty
	assert property(af_p2665);

	property af_p2666;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (t2_wb_dat_o >= 0 && t2_wb_dat_o <= 255);
	endproperty
	assert property(af_p2666);

	property af_p2667;
	@(posedge wb_clk_i) t2_wb_ack_i |=> (t2_wb_dat_o >= 50 && t2_wb_dat_o <= 200)[*2];
	endproperty
	assert property(af_p2667);

	property af_p2668;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (t2_wb_dat_o >= 50 && t2_wb_dat_o <= 200);
	endproperty
	assert property(af_p2668);

	property af_p2669;
	@(posedge wb_clk_i) !t2_wb_cyc_o |-> ($stable(t2_wb_dat_o) && (t2_wb_dat_o >= 0 && t2_wb_dat_o <= 255));
	endproperty
	assert property(af_p2669);

	property af_p2670;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (t2_wb_dat_o == 0) until_with (t2_wb_dat_o != 0);
	endproperty
	assert property(af_p2670);

	property af_p2671;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t2_wb_dat_o >= 0) && (t2_wb_dat_o <= 255);
	endproperty
	assert property(af_p2671);

	property af_p2672;
	@(posedge wb_clk_i) (t2_wb_err_i) |-> $stable(t2_wb_dat_o);
	endproperty
	assert property(af_p2672);

	property af_p2673;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (t2_wb_dat_o >= 0) && (t2_wb_dat_o <= 10);
	endproperty
	assert property(af_p2673);

	property af_p2674;
	@(posedge wb_clk_i) (t2_wb_stb_o && t2_wb_ack_i) |-> !$isunknown(t2_wb_dat_o);
	endproperty
	assert property(af_p2674);

	property af_p2675;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (t2_wb_dat_o == 0);
	endproperty
	assert property(af_p2675);

	property af_p2676;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 (t2_wb_dat_o >= 0) && (t2_wb_dat_o <= 60);
	endproperty
	assert property(af_p2676);

	property af_p2677;
	@(posedge wb_clk_i) (!t2_wb_cyc_o) |-> $stable(t2_wb_dat_o);
	endproperty
	assert property(af_p2677);

	property af_p2678;
	@(posedge wb_clk_i) ((t2_wb_dat_o >= 60) && (t2_wb_dat_o <= 120) && t2_wb_ack_i) |-> ##1 (t2_wb_dat_o >= 60) && (t2_wb_dat_o <= 200);
	endproperty
	assert property(af_p2678);

	property af_p2679;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 (t2_wb_dat_o >= 0) && (t2_wb_dat_o <= 63);
	endproperty
	assert property(af_p2679);

	property af_p2680;
	@(posedge wb_clk_i) (t2_wb_ack_i) |-> (t2_wb_dat_o >= 0) && (t2_wb_dat_o <= 255);
	endproperty
	assert property(af_p2680);


	property af_p2682;
	@(posedge wb_clk_i) (t2_wb_err_i) |-> ##[1:2] (t2_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2682);

	property af_p2683;
	@(posedge wb_clk_i) (t2_wb_err_i) |-> (t2_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p2683);

	property af_p2684;
	@(posedge wb_clk_i) (t2_wb_err_i) |=> (t2_wb_stb_o == 1'b0);
	endproperty
	assert property(af_p2684);

	property af_p2685;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t2_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2685);

	property af_p2686;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (t2_wb_err_i == 1'b0) ##1 (t2_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2686);

	property af_p2687;
	@(posedge wb_clk_i) (t2_wb_we_o && t2_wb_cyc_o && t2_wb_stb_o) |-> ##[0:1] (t2_wb_err_i == 1'b1);
	endproperty
	assert property(af_p2687);

	property af_p2688;
	@(posedge wb_clk_i) (t2_wb_err_i) |=> (t2_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2688);

	property af_p2689;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:3] (!t2_wb_err_i);
	endproperty
	assert property(af_p2689);

	property af_p2690;
	@(posedge wb_clk_i) (t2_wb_err_i) |-> ##1 $stable(t2_wb_adr_o);
	endproperty
	assert property(af_p2690);

	property af_p2691;
	@(posedge wb_clk_i) (t2_wb_err_i) |-> (t2_wb_cyc_o);
	endproperty
	assert property(af_p2691);

	property af_p2692;
	@(posedge wb_clk_i) (t2_wb_err_i) |=> (!t2_wb_cyc_o);
	endproperty
	assert property(af_p2692);

	property af_p2693;
	@(posedge wb_clk_i) (t2_wb_err_i && !t2_wb_cyc_o) |=> (!t2_wb_err_i);
	endproperty
	assert property(af_p2693);

	property af_p2694;
	@(posedge wb_clk_i) (t2_wb_cyc_o && t2_wb_stb_o) |-> (1'b1);
	endproperty
	assert property(af_p2694);

	property af_p2695;
	@(posedge wb_clk_i) (!t2_wb_stb_o) |-> (!t2_wb_err_i);
	endproperty
	assert property(af_p2695);

	property af_p2696;
	@(posedge wb_clk_i) (!t2_wb_cyc_o) |-> (!t2_wb_err_i);
	endproperty
	assert property(af_p2696);

	property af_p2697;
	@(posedge wb_clk_i) (t2_wb_err_i) |-> (t2_wb_cyc_o && t2_wb_stb_o);
	endproperty
	assert property(af_p2697);

	property af_p2698;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (!t2_wb_err_i)[*2];
	endproperty
	assert property(af_p2698);

	property af_p2699;
	@(posedge wb_clk_i) (t2_wb_cyc_o && !t2_wb_stb_o) |-> (!t2_wb_err_i);
	endproperty
	assert property(af_p2699);

	property af_p2700;
	@(posedge wb_clk_i) (t2_wb_err_i) |=> (!t2_wb_stb_o);
	endproperty
	assert property(af_p2700);

	property af_p2701;
	@(posedge wb_clk_i) not (t2_wb_err_i && t2_wb_ack_i);
	endproperty
	assert property(af_p2701);

	property af_p2702;
	@(posedge wb_clk_i) (t2_wb_we_o && !t2_wb_stb_o) |-> (!t2_wb_err_i);
	endproperty
	assert property(af_p2702);

	property af_p2703;
	@(posedge wb_clk_i) ($changed(t2_wb_err_i)) |-> (t2_wb_stb_o);
	endproperty
	assert property(af_p2703);

	property af_p2704;
	@(posedge wb_clk_i) ($fell(t2_wb_err_i)) |-> ($fell(t2_wb_cyc_o) || $past(!t2_wb_cyc_o));
	endproperty
	assert property(af_p2704);

	property af_p2705;
	@(posedge wb_clk_i) (t2_wb_ack_i) |-> (!t2_wb_err_i);
	endproperty
	assert property(af_p2705);

	property af_p2706;
	@(posedge wb_clk_i) (wb_rst_i) |=> (t2_wb_sel_o == '0) throughout wb_rst_i[*1:$];
	endproperty
	assert property(af_p2706);

	property af_p2707;
	@(posedge wb_clk_i) ($past(t2_wb_cyc_o) && $past(t2_wb_stb_o) && t2_wb_cyc_o && t2_wb_stb_o) |-> $stable(t2_wb_sel_o);
	endproperty
	assert property(af_p2707);

	property af_p2708;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t2_wb_sel_o == '0);
	endproperty
	assert property(af_p2708);

	property af_p2709;
	@(posedge wb_clk_i) (t2_wb_cyc_o) |-> (t2_wb_sel_o == (4'b0001 << t2_wb_adr_o[1:0]));
	endproperty
	assert property(af_p2709);

	property af_p2710;
	@(posedge wb_clk_i) (!t2_wb_cyc_o) |-> (t2_wb_sel_o == '0);
	endproperty
	assert property(af_p2710);

	property af_p2711;
	@(posedge wb_clk_i) ($past(t2_wb_cyc_o) && !$past(t2_wb_ack_i) && t2_wb_cyc_o) |-> $stable(t2_wb_sel_o);
	endproperty
	assert property(af_p2711);

	property af_p2712;
	@(posedge wb_clk_i) (t2_wb_cyc_o) |-> $stable(t2_wb_sel_o);
	endproperty
	assert property(af_p2712);

	property af_p2713;
	@(posedge wb_clk_i) (t2_wb_stb_o) |-> (t2_wb_sel_o != '0);
	endproperty
	assert property(af_p2713);

	property af_p2714;
	@(posedge wb_clk_i) $fell(t2_wb_ack_i) |=> $changed(t2_wb_sel_o);
	endproperty
	assert property(af_p2714);

	property af_p2715;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] !$isunknown(t2_wb_sel_o);
	endproperty
	assert property(af_p2715);

	property af_p2716;
	@(posedge wb_clk_i) (t2_wb_cyc_o && t2_wb_stb_o) |-> $stable(t2_wb_sel_o);
	endproperty
	assert property(af_p2716);

	property af_p2717;
	@(posedge wb_clk_i) (t2_wb_we_o) |-> (((t2_wb_adr_o[1:0] == 2'b00) -> (t2_wb_sel_o == 4'b0001)) && ((t2_wb_adr_o[1:0] == 2'b01) -> (t2_wb_sel_o == 4'b0010)) && ((t2_wb_adr_o[1:0] == 2'b10) -> (t2_wb_sel_o == 4'b0100)) && ((t2_wb_adr_o[1:0] == 2'b11) -> (t2_wb_sel_o == 4'b1000)));
	endproperty
	assert property(af_p2717);

	property af_p2718;
	@(posedge wb_clk_i) disable iff (!wb_rst_i) (t2_wb_stb_o) |-> (t2_wb_sel_o != '0);
	endproperty
	assert property(af_p2718);

	property af_p2719;
	@(posedge wb_clk_i) disable iff (!wb_rst_i) (t2_wb_cyc_o && !t2_wb_ack_i) |-> $stable(t2_wb_sel_o);
	endproperty
	assert property(af_p2719);

	property af_p2720;
	@(posedge wb_clk_i) disable iff (!wb_rst_i) ((!t2_wb_we_o) && $past(t2_wb_adr_o) == t2_wb_adr_o) |-> (t2_wb_sel_o == $past(t2_wb_sel_o));
	endproperty
	assert property(af_p2720);

	property af_p2721;
	@(posedge wb_clk_i) disable iff (!wb_rst_i) (t2_wb_we_o && t2_wb_stb_o) |=> (t2_wb_we_o && $changed(t2_wb_stb_o)) |-> $stable(t2_wb_sel_o);
	endproperty
	assert property(af_p2721);

	property af_p2722;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (wb_rst_i throughout (t2_wb_stb_o == 0)[*1:$]) or (t2_wb_sel_o == '0);
	endproperty
	assert property(af_p2722);

	property af_p2723;
	@(posedge wb_clk_i) disable iff (!wb_rst_i) ($rose(t2_wb_stb_o) && $changed(t2_wb_adr_o)) |-> $changed(t2_wb_sel_o);
	endproperty
	assert property(af_p2723);

	property af_p2724;
	@(posedge wb_clk_i) (t2_wb_stb_o) |-> $stable(t2_wb_we_o);
	endproperty
	assert property(af_p2724);

	property af_p2725;
	@(posedge wb_clk_i) (t2_wb_ack_i) |=> (t2_wb_stb_o == 1'b0);
	endproperty
	assert property(af_p2725);

	property af_p2726;
	@(posedge wb_clk_i) (t2_wb_stb_o) |-> (!$isunknown(t2_wb_adr_o) && $stable(t2_wb_adr_o));
	endproperty
	assert property(af_p2726);

	property af_p2727;
	@(posedge wb_clk_i) (t2_wb_stb_o) |-> (t2_wb_cyc_o);
	endproperty
	assert property(af_p2727);

	property af_p2728;
	@(posedge wb_clk_i) (t2_wb_err_i) |=> (t2_wb_stb_o == 1'b0);
	endproperty
	assert property(af_p2728);

	property af_p2729;
	@(posedge wb_clk_i) !(t2_wb_stb_o && t3_wb_stb_o);
	endproperty
	assert property(af_p2729);


	property af_p2731;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (t2_wb_stb_o == 1'b0)[*2];
	endproperty
	assert property(af_p2731);

	property af_p2732;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t2_wb_stb_o == 1'b0);
	endproperty
	assert property(af_p2732);

	property af_p2733;
	@(posedge wb_clk_i) (!t2_wb_cyc_o) |-> (!t2_wb_stb_o);
	endproperty
	assert property(af_p2733);

	property af_p2734;
	@(posedge wb_clk_i) disable iff (wb_rst_i) $fell(t2_wb_stb_o) |=> !t2_wb_stb_o;
	endproperty
	assert property(af_p2734);

	property af_p2735;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(t2_wb_stb_o);
	endproperty
	assert property(af_p2735);

	property af_p2736;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (!t2_wb_stb_o);
	endproperty
	assert property(af_p2736);

	property af_p2737;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (t2_wb_stb_o) |-> (t2_wb_stb_o throughout (!t2_wb_ack_i)[*0:$] ##1 t2_wb_ack_i);
	endproperty
	assert property(af_p2737);

	property af_p2738;
	@(posedge wb_clk_i) disable iff (wb_rst_i) ($rose(t2_wb_stb_o)) |-> $past(!t2_wb_stb_o);
	endproperty
	assert property(af_p2738);

	property af_p2739;
	@(posedge wb_clk_i) (t2_wb_cyc_o) |-> (t2_wb_stb_o);
	endproperty
	assert property(af_p2739);

	property af_p2740;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t2_wb_stb_o);
	endproperty
	assert property(af_p2740);

	property af_p2741;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 !t2_wb_stb_o[*1] ##1 (t2_wb_stb_o || !t2_wb_stb_o);
	endproperty
	assert property(af_p2741);

	property af_p2742;
	@(posedge wb_clk_i) $changed(t2_wb_stb_o) |=> $stable(t2_wb_stb_o);
	endproperty
	assert property(af_p2742);

	property af_p2743;
	@(posedge wb_clk_i) (t2_wb_ack_i) |-> (!t2_wb_stb_o);
	endproperty
	assert property(af_p2743);

	property af_p2744;
	@(posedge wb_clk_i) (!wb_rst_i && !i1_wb_stb_i) |-> ($stable(t2_wb_stb_o));
	endproperty
	assert property(af_p2744);

	property af_p2745;
	@(posedge wb_clk_i) (t2_wb_stb_o) |-> (!wb_rst_i);
	endproperty
	assert property(af_p2745);

	property af_p2746;
	@(posedge wb_clk_i) (t2_wb_stb_o) |-> (t2_wb_stb_o throughout ((!t2_wb_ack_i && !t2_wb_err_i)[*0:$] ##1 (t2_wb_ack_i || t2_wb_err_i)));
	endproperty
	assert property(af_p2746);

	property af_p2747;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!t2_wb_stb_o)[*2];
	endproperty
	assert property(af_p2747);

	property af_p2748;
	@(posedge wb_clk_i) (t2_wb_stb_o && !t2_wb_ack_i) |-> ($stable(t2_wb_adr_o) throughout (t2_wb_stb_o[*1:$] ##0 t2_wb_ack_i));
	endproperty
	assert property(af_p2748);

	property af_p2749;
	@(posedge wb_clk_i) (t2_wb_stb_o) |-> (t2_wb_sel_o);
	endproperty
	assert property(af_p2749);

	property af_p2750;
	@(posedge wb_clk_i) (i0_wb_stb_i) |-> (t2_wb_stb_o);
	endproperty
	assert property(af_p2750);

	property af_p2751;
	@(posedge wb_clk_i) (t2_wb_stb_o && !t2_wb_ack_i) |=> (t2_wb_stb_o throughout (!t2_wb_ack_i[*0:$] ##1 t2_wb_ack_i));
	endproperty
	assert property(af_p2751);

	property af_p2752;
	@(posedge wb_clk_i) (!i0_wb_we_i) |-> (t2_wb_we_o == 1'b0);
	endproperty
	assert property(af_p2752);

	property af_p2753;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##[0:1] (t2_wb_we_o == 1'b0);
	endproperty
	assert property(af_p2753);

	property af_p2754;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (t2_wb_we_o == 1'b0);
	endproperty
	assert property(af_p2754);

	property af_p2755;
	@(posedge wb_clk_i) (t2_wb_cyc_o && t2_wb_stb_o) |-> $stable(t2_wb_we_o) || 1'b1;
	endproperty
	assert property(af_p2755);

	property af_p2756;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t2_wb_we_o == 1'b0);
	endproperty
	assert property(af_p2756);

	property af_p2757;
	@(posedge wb_clk_i) $fell(t2_wb_cyc_o) |-> ##[0:1] (t2_wb_we_o == 1'b0);
	endproperty
	assert property(af_p2757);


	property af_p2759;
	@(posedge wb_clk_i) (t2_wb_we_o) |-> (t2_wb_dat_o inside {[0:$]}) throughout (t2_wb_ack_i)[->1];
	endproperty
	assert property(af_p2759);

	property af_p2760;
	@(posedge wb_clk_i) (t2_wb_we_o) |-> (t2_wb_dat_o !== 'x);
	endproperty
	assert property(af_p2760);

	property af_p2761;
	@(posedge wb_clk_i) (wb_rst_i && $past(wb_rst_i)) |-> ($stable(t2_wb_we_o));
	endproperty
	assert property(af_p2761);

	property af_p2762;
	@(posedge wb_clk_i) (t2_wb_cyc_o && !t2_wb_ack_i) |-> $stable(t2_wb_we_o);
	endproperty
	assert property(af_p2762);

	property af_p2763;
	@(posedge wb_clk_i) (t2_wb_cyc_o && !t2_wb_ack_i) |=> $stable(t2_wb_we_o);
	endproperty
	assert property(af_p2763);

	property af_p2764;
	@(posedge wb_clk_i) (!t2_wb_stb_o) |-> $stable(t2_wb_we_o);
	endproperty
	assert property(af_p2764);

	property af_p2765;
	@(posedge wb_clk_i) (t2_wb_we_o && t2_wb_stb_o) |-> t2_wb_ack_i;
	endproperty
	assert property(af_p2765);

	property af_p2766;
	@(posedge wb_clk_i) (t2_wb_sel_o != '0) |-> (t2_wb_we_o == i0_wb_we_i);
	endproperty
	assert property(af_p2766);

	property af_p2767;
	@(posedge wb_clk_i) t2_wb_we_o |-> i0_wb_we_i;
	endproperty
	assert property(af_p2767);

	property af_p2768;
	@(posedge wb_clk_i) (i0_wb_we_i && i0_wb_cyc_i && i0_wb_stb_i) |-> t2_wb_we_o;
	endproperty
	assert property(af_p2768);

	property af_p2769;
	@(posedge wb_clk_i) (t2_wb_we_o) |-> (t2_wb_cyc_o && t2_wb_stb_o);
	endproperty
	assert property(af_p2769);

	property af_p2770;
	@(posedge wb_clk_i) (t2_wb_cyc_o && t2_wb_stb_o && !i0_wb_we_i) |-> !t2_wb_we_o;
	endproperty
	assert property(af_p2770);

	property af_p2771;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t2_wb_we_o) ##1 (!t2_wb_we_o);
	endproperty
	assert property(af_p2771);

	property af_p2772;
	@(posedge wb_clk_i) (t2_wb_ack_i && !t2_wb_cyc_o) |=> (t2_wb_we_o == 1'b0);
	endproperty
	assert property(af_p2772);

	property af_p2773;
	@(posedge wb_clk_i) (t2_wb_stb_o) |-> ($stable(t2_wb_we_o) && $stable(t2_wb_adr_o));
	endproperty
	assert property(af_p2773);

	property af_p2774;
	@(posedge wb_clk_i) (!t2_wb_stb_o) |=> $stable(t2_wb_we_o);
	endproperty
	assert property(af_p2774);

	property af_p2775;
	@(posedge wb_clk_i) (t2_wb_cyc_o && !t2_wb_ack_i) |=> $stable(t2_wb_we_o) until_with (t2_wb_ack_i);
	endproperty
	assert property(af_p2775);

	property af_p2776;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (t2_wb_we_o inside {1'b0, 1'b1});
	endproperty
	assert property(af_p2776);


	property af_p2778;
	@(posedge wb_clk_i) ($stable(t2_wb_cyc_o) && $stable(t2_wb_stb_o)) |=> $stable(t2_wb_we_o);
	endproperty
	assert property(af_p2778);

	property af_p2779;
	@(posedge wb_clk_i) (t3_wb_stb_o) |=> (t3_wb_ack_i) ##1 (!t3_wb_ack_i);
	endproperty
	assert property(af_p2779);

	property af_p2780;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (!t3_wb_ack_i);
	endproperty
	assert property(af_p2780);

	property af_p2781;
	@(posedge wb_clk_i) not (t3_wb_ack_i && t3_wb_err_i);
	endproperty
	assert property(af_p2781);

	property af_p2782;
	@(posedge wb_clk_i) ($rose(t3_wb_ack_i)) |-> 1'b1;
	endproperty
	assert property(af_p2782);

	property af_p2783;
	@(posedge wb_clk_i) (t3_wb_ack_i && !t3_wb_stb_o) |=> (!t3_wb_ack_i);
	endproperty
	assert property(af_p2783);

	property af_p2784;
	@(posedge wb_clk_i) (t3_wb_ack_i) |-> (!$isunknown(t3_wb_dat_i));
	endproperty
	assert property(af_p2784);

	property af_p2785;
	@(posedge wb_clk_i) (t3_wb_stb_o && t3_wb_we_o) |-> ##[1:4] t3_wb_ack_i;
	endproperty
	assert property(af_p2785);

	property af_p2786;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t3_wb_ack_i);
	endproperty
	assert property(af_p2786);

	property af_p2787;
	@(posedge wb_clk_i) (t3_wb_ack_i && !$past(t3_wb_stb_o)) |=> (!t3_wb_cyc_o && !t3_wb_stb_o);
	endproperty
	assert property(af_p2787);

	property af_p2788;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!t3_wb_ack_i) ##1 (!t3_wb_ack_i);
	endproperty
	assert property(af_p2788);

	property af_p2789;
	@(posedge wb_clk_i) (t3_wb_ack_i) |-> ($stable(t3_wb_adr_o) throughout (1'b1 [*1:$] ##0 t3_wb_ack_i));
	endproperty
	assert property(af_p2789);

	property af_p2790;
	@(posedge wb_clk_i) (t3_wb_cyc_o == 0) |-> (t3_wb_ack_i == 0);
	endproperty
	assert property(af_p2790);

	property af_p2791;
	@(posedge wb_clk_i) (t3_wb_we_o && t3_wb_ack_i) |-> $stable(t3_wb_dat_o);
	endproperty
	assert property(af_p2791);

	property af_p2792;
	@(posedge wb_clk_i) !(t3_wb_ack_i && t3_wb_err_i);
	endproperty
	assert property(af_p2792);

	property af_p2793;
	@(posedge wb_clk_i) (t3_wb_cyc_o && t3_wb_stb_o) |-> ##[1:16] t3_wb_ack_i;
	endproperty
	assert property(af_p2793);

	property af_p2794;
	@(posedge wb_clk_i) $rose(t3_wb_ack_i) |=> (!t3_wb_ack_i || t3_wb_stb_o);
	endproperty
	assert property(af_p2794);

	property af_p2795;
	@(posedge wb_clk_i) (t3_wb_ack_i && !t3_wb_we_o) |-> !$isunknown(t3_wb_dat_i);
	endproperty
	assert property(af_p2795);

	property af_p2796;
	@(posedge wb_clk_i) t3_wb_stb_o |-> ##[1:4] t3_wb_ack_i;
	endproperty
	assert property(af_p2796);

	property af_p2797;
	@(posedge wb_clk_i) !t3_wb_stb_o |-> !t3_wb_ack_i;
	endproperty
	assert property(af_p2797);

	property af_p2798;
	@(posedge wb_clk_i) !t3_wb_cyc_o |-> !$changed(t3_wb_ack_i);
	endproperty
	assert property(af_p2798);

	property af_p2799;
	@(posedge wb_clk_i) (t3_wb_we_o && t3_wb_cyc_o && t3_wb_stb_o) |-> ##[1:16] t3_wb_ack_i;
	endproperty
	assert property(af_p2799);

	property af_p2800;
	@(posedge wb_clk_i) $changed(t3_wb_adr_o) |-> $past(!t3_wb_ack_i);
	endproperty
	assert property(af_p2800);

	property af_p2801;
	@(posedge wb_clk_i) t3_wb_ack_i |-> (t3_wb_cyc_o && t3_wb_stb_o);
	endproperty
	assert property(af_p2801);

	property af_p2802;
	@(posedge wb_clk_i) $fell(t3_wb_cyc_o) |-> ##1 !t3_wb_ack_i;
	endproperty
	assert property(af_p2802);

	property af_p2803;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ($stable(t3_wb_ack_i) throughout (!t3_wb_stb_o)[->1]);
	endproperty
	assert property(af_p2803);

	property af_p2804;
	@(posedge wb_clk_i) $changed(t3_wb_adr_o) |-> !t3_wb_ack_i;
	endproperty
	assert property(af_p2804);

	property af_p2805;
	@(posedge wb_clk_i) $rose(t3_wb_stb_o) |-> ##1 t3_wb_ack_i ##1 !t3_wb_ack_i;
	endproperty
	assert property(af_p2805);

	property af_p2806;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 !t3_wb_ack_i;
	endproperty
	assert property(af_p2806);

	property af_p2807;
	@(posedge wb_clk_i) $rose(t3_wb_stb_o) |-> ##[1:4] t3_wb_ack_i;
	endproperty
	assert property(af_p2807);

	property af_p2808;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t3_wb_ack_i[*3];
	endproperty
	assert property(af_p2808);

	property af_p2809;
	@(posedge wb_clk_i) wb_rst_i |-> !t3_wb_ack_i;
	endproperty
	assert property(af_p2809);

	property af_p2810;
	@(posedge wb_clk_i) (t3_wb_ack_i && t3_wb_we_o) |-> $stable(t3_wb_dat_o);
	endproperty
	assert property(af_p2810);

	property af_p2811;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t3_wb_ack_i;
	endproperty
	assert property(af_p2811);

	property af_p2812;
	@(posedge wb_clk_i) (t3_wb_cyc_o && t3_wb_stb_o) |=> $stable(t3_wb_adr_o);
	endproperty
	assert property(af_p2812);

	property af_p2813;
	@(posedge wb_clk_i) (t3_wb_cyc_o && (t3_wb_adr_o inside {[0:1023]})) |=> (t3_wb_cyc_o && (t3_wb_adr_o inside {[0:2047]}));
	endproperty
	assert property(af_p2813);

	property af_p2814;
	@(posedge wb_clk_i) (t3_wb_cyc_o) |=> $stable(t3_wb_adr_o);
	endproperty
	assert property(af_p2814);

	property af_p2815;
	@(posedge wb_clk_i) (t3_wb_we_o && !t3_wb_ack_i) |=> $stable(t3_wb_adr_o);
	endproperty
	assert property(af_p2815);

	property af_p2816;
	@(posedge wb_clk_i) (wb_rst_i) |=> $stable(t3_wb_adr_o);
	endproperty
	assert property(af_p2816);

	property af_p2817;
	@(posedge wb_clk_i) (t3_wb_cyc_o && !t3_wb_err_i) |=> $stable(t3_wb_adr_o);
	endproperty
	assert property(af_p2817);

	property af_p2818;
	@(posedge wb_clk_i) (t3_wb_ack_i) |-> $stable(t3_wb_adr_o);
	endproperty
	assert property(af_p2818);

	property af_p2819;
	@(posedge wb_clk_i) (!t3_wb_cyc_o) |=> $stable(t3_wb_adr_o);
	endproperty
	assert property(af_p2819);

	property af_p2820;
	@(posedge wb_clk_i) (t3_wb_ack_i) |=> ($stable(t3_wb_adr_o) until t3_wb_stb_o);
	endproperty
	assert property(af_p2820);

	property af_p2821;
	@(posedge wb_clk_i) (t3_wb_we_o && (t3_wb_adr_o inside {[512:767]})) |=> (t3_wb_we_o && (t3_wb_adr_o inside {[0:1023]}));
	endproperty
	assert property(af_p2821);

	property af_p2822;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 (!$isunknown(t3_wb_adr_o))[*4];
	endproperty
	assert property(af_p2822);

	property af_p2823;
	@(posedge wb_clk_i) (t3_wb_stb_o && !t3_wb_ack_i) |=> $stable(t3_wb_adr_o);
	endproperty
	assert property(af_p2823);

	property af_p2824;
	@(posedge wb_clk_i) $changed(t3_wb_adr_o) |-> (t3_wb_cyc_o && t3_wb_stb_o);
	endproperty
	assert property(af_p2824);

	property af_p2825;
	@(posedge wb_clk_i) (t3_wb_cyc_o && !t3_wb_ack_i) |=> $stable(t3_wb_adr_o);
	endproperty
	assert property(af_p2825);

	property af_p2826;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##[1:3] !$isunknown(t3_wb_adr_o);
	endproperty
	assert property(af_p2826);

	property af_p2827;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (t3_wb_adr_o == '0)[*2];
	endproperty
	assert property(af_p2827);

	property af_p2828;
	@(posedge wb_clk_i) (!t3_wb_stb_o) |-> ##1 1;
	endproperty
	assert property(af_p2828);

	property af_p2829;
	@(posedge wb_clk_i) (t3_wb_stb_o) |-> (t3_wb_adr_o >= 0 && t3_wb_adr_o <= 4095);
	endproperty
	assert property(af_p2829);

	property af_p2830;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (t3_wb_adr_o == '0);
	endproperty
	assert property(af_p2830);

	property af_p2831;
	@(posedge wb_clk_i) (!t3_wb_stb_o) |-> ##1 (1);
	endproperty
	assert property(af_p2831);

	property af_p2832;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((t3_wb_adr_o >= 0) && (t3_wb_adr_o <= 4095));
	endproperty
	assert property(af_p2832);

	property af_p2833;
	@(posedge wb_clk_i) (t3_wb_cyc_o) |-> $stable(t3_wb_adr_o) or ($changed(t3_wb_adr_o) && $rose(wb_clk_i));
	endproperty
	assert property(af_p2833);

	property af_p2834;
	@(posedge wb_clk_i) (t3_wb_ack_i && t3_wb_stb_o) |-> ##1 ($changed(t3_wb_adr_o));
	endproperty
	assert property(af_p2834);

	property af_p2835;
	@(posedge wb_clk_i) (t3_wb_cyc_o && t3_wb_stb_o && !t3_wb_ack_i) |-> $stable(t3_wb_adr_o);
	endproperty
	assert property(af_p2835);


	property af_p2837;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 ((t3_wb_adr_o >= 0) && (t3_wb_adr_o <= 4095));
	endproperty
	assert property(af_p2837);

	property af_p2838;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (t3_wb_adr_o == 0);
	endproperty
	assert property(af_p2838);

	property af_p2839;
	@(posedge wb_clk_i) ($fell(wb_rst_i) && t3_wb_stb_o) |-> ##[1:2] ((t3_wb_adr_o >= 0) && (t3_wb_adr_o <= 4095));
	endproperty
	assert property(af_p2839);

	property af_p2840;
	@(posedge wb_clk_i) wb_rst_i |-> !t3_wb_cyc_o;
	endproperty
	assert property(af_p2840);

	property af_p2841;
	@(posedge wb_clk_i) $rose(t3_wb_cyc_o) |-> t3_wb_cyc_o[*1:$] ##0 !t3_wb_cyc_o;
	endproperty
	assert property(af_p2841);

	property af_p2842;
	@(posedge wb_clk_i) t3_wb_err_i |-> !t3_wb_cyc_o;
	endproperty
	assert property(af_p2842);

	property af_p2843;
	@(posedge wb_clk_i) $rose(t3_wb_cyc_o) |=> t3_wb_cyc_o;
	endproperty
	assert property(af_p2843);

	property af_p2844;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> !t3_wb_cyc_o;
	endproperty
	assert property(af_p2844);

	property af_p2845;
	@(posedge wb_clk_i) $rose(t3_wb_cyc_o) == $rose(t3_wb_stb_o) && $fell(t3_wb_cyc_o) == $fell(t3_wb_stb_o);
	endproperty
	assert property(af_p2845);

	property af_p2846;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (!t3_wb_cyc_o) ##1 (!t3_wb_cyc_o);
	endproperty
	assert property(af_p2846);

	property af_p2847;
	@(posedge wb_clk_i) t3_wb_ack_i |=> !t3_wb_cyc_o;
	endproperty
	assert property(af_p2847);

	property af_p2848;
	@(posedge wb_clk_i) t3_wb_cyc_o |-> t3_wb_cyc_o throughout (!t3_wb_ack_i[*0:$] ##1 t3_wb_ack_i);
	endproperty
	assert property(af_p2848);

	property af_p2849;
	@(posedge wb_clk_i) t3_wb_cyc_o |-> t3_wb_stb_o;
	endproperty
	assert property(af_p2849);


	property af_p2851;
	@(posedge wb_clk_i) (t3_wb_cyc_o && t3_wb_err_i) |=> !t3_wb_cyc_o;
	endproperty
	assert property(af_p2851);

	property af_p2852;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t3_wb_cyc_o ##1 !t3_wb_cyc_o;
	endproperty
	assert property(af_p2852);

	property af_p2853;
	@(posedge wb_clk_i) $rose(t3_wb_cyc_o) |-> t3_wb_cyc_o throughout (t3_wb_ack_i || t3_wb_err_i)[->1];
	endproperty
	assert property(af_p2853);

	property af_p2854;
	@(posedge wb_clk_i) ($fell(t3_wb_cyc_o) && $past(t3_wb_ack_i)) |-> !t3_wb_cyc_o throughout (!$rose(t3_wb_cyc_o))[*1:$];
	endproperty
	assert property(af_p2854);

	property af_p2855;
	@(posedge wb_clk_i) (i0_wb_cyc_i && t3_wb_cyc_o) |=> (i0_wb_cyc_i |-> t3_wb_cyc_o);
	endproperty
	assert property(af_p2855);

	property af_p2856;
	@(posedge wb_clk_i) (wb_rst_i throughout wb_rst_i[*2]) |-> (!$changed(t3_wb_cyc_o));
	endproperty
	assert property(af_p2856);

	property af_p2857;
	@(posedge wb_clk_i) ($rose(t3_wb_cyc_o)) |-> (t3_wb_cyc_o);
	endproperty
	assert property(af_p2857);

	property af_p2858;
	@(posedge wb_clk_i) (t3_wb_stb_o) |-> (t3_wb_cyc_o);
	endproperty
	assert property(af_p2858);

	property af_p2859;
	@(posedge wb_clk_i) (t3_wb_cyc_o) |-> (t3_wb_cyc_o throughout (t3_wb_ack_i[->1]));
	endproperty
	assert property(af_p2859);

	property af_p2860;
	@(posedge wb_clk_i) ($changed(t3_wb_cyc_o)) |-> (##1 $stable(t3_wb_cyc_o));
	endproperty
	assert property(af_p2860);

	property af_p2861;
	@(posedge wb_clk_i) ($changed(t3_wb_cyc_o)) |=> (!$changed(t3_wb_cyc_o));
	endproperty
	assert property(af_p2861);

	property af_p2862;
	@(posedge wb_clk_i) (t3_wb_cyc_o) |-> ($stable(t3_wb_adr_o));
	endproperty
	assert property(af_p2862);

	property af_p2863;
	@(posedge wb_clk_i) (t3_wb_err_i) |=> (!t3_wb_cyc_o);
	endproperty
	assert property(af_p2863);

	property af_p2864;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!t3_wb_cyc_o)[*3];
	endproperty
	assert property(af_p2864);

	property af_p2865;
	@(posedge wb_clk_i) (i0_wb_cyc_i) |-> (t3_wb_cyc_o);
	endproperty
	assert property(af_p2865);

	property af_p2866;
	@(posedge wb_clk_i) (t3_wb_ack_i) |-> $stable(t3_wb_dat_i);
	endproperty
	assert property(af_p2866);

	property af_p2867;
	@(posedge wb_clk_i) (!t3_wb_ack_i) |=> $stable(t3_wb_dat_i);
	endproperty
	assert property(af_p2867);

	property af_p2868;
	@(posedge wb_clk_i) ((t3_wb_dat_i >= 50) && (t3_wb_dat_i <= 75) && t3_wb_cyc_o && t3_wb_stb_o && !t3_wb_we_o) |-> ##[1:2] ((t3_wb_dat_i >= 30) && (t3_wb_dat_i <= 95));
	endproperty
	assert property(af_p2868);

	property af_p2869;
	@(posedge wb_clk_i) (t3_wb_stb_o && !t3_wb_ack_i) |=> $stable(t3_wb_dat_i);
	endproperty
	assert property(af_p2869);

	property af_p2870;
	@(posedge wb_clk_i) (!t3_wb_stb_o) |=> $stable(t3_wb_dat_i);
	endproperty
	assert property(af_p2870);


	property af_p2872;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> ##1 ((t3_wb_dat_i >= 0) && (t3_wb_dat_i <= 255));
	endproperty
	assert property(af_p2872);

	property af_p2873;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:3] ((t3_wb_dat_i >= 0) && (t3_wb_dat_i <= 255));
	endproperty
	assert property(af_p2873);

	property af_p2874;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] (t3_wb_dat_i !== 'x);
	endproperty
	assert property(af_p2874);

	property af_p2875;
	@(posedge wb_clk_i) ((t3_wb_dat_i >= 120) && (t3_wb_dat_i <= 150)) |=> (t3_wb_dat_i >= 90) && (t3_wb_dat_i <= 150);
	endproperty
	assert property(af_p2875);

	property af_p2876;
	@(posedge wb_clk_i) ((t3_wb_dat_i >= 100) && (t3_wb_dat_i <= 150)) |=> (t3_wb_dat_i >= 80) && (t3_wb_dat_i <= 150);
	endproperty
	assert property(af_p2876);

	property af_p2877;
	@(posedge wb_clk_i) ((t3_wb_dat_i >= 0) && (t3_wb_dat_i <= 127) && t3_wb_cyc_o && t3_wb_stb_o) |=> (t3_wb_dat_i >= 0) && (t3_wb_dat_i <= 255);
	endproperty
	assert property(af_p2877);

	property af_p2878;
	@(posedge wb_clk_i) (!t3_wb_we_o && t3_wb_cyc_o && t3_wb_stb_o && t3_wb_ack_i) |-> (t3_wb_dat_i == $past(t3_wb_dat_i) || t3_wb_adr_o == $past(t3_wb_adr_o));
	endproperty
	assert property(af_p2878);

	property af_p2879;
	@(posedge wb_clk_i) (t3_wb_cyc_o && t3_wb_stb_o && t3_wb_ack_i) |-> $stable(t3_wb_dat_i) throughout (t3_wb_cyc_o && t3_wb_stb_o && t3_wb_ack_i)[*1];
	endproperty
	assert property(af_p2879);

	property af_p2880;
	@(posedge wb_clk_i) (t3_wb_cyc_o && t3_wb_stb_o && t3_wb_ack_i) |-> ((t3_wb_dat_i >= 0) && (t3_wb_dat_i <= 255));
	endproperty
	assert property(af_p2880);

	property af_p2881;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ((t3_wb_dat_i >= 0) && (t3_wb_dat_i <= 255)) throughout (!t3_wb_cyc_o)[*1:$];
	endproperty
	assert property(af_p2881);

	property af_p2882;
	@(posedge wb_clk_i) (t3_wb_cyc_o && !t3_wb_we_o && (t3_wb_dat_i >= 32) && (t3_wb_dat_i <= 96)) |=> ((t3_wb_dat_i >= 16) && (t3_wb_dat_i <= 112));
	endproperty
	assert property(af_p2882);

	property af_p2883;
	@(posedge wb_clk_i) ((t3_wb_dat_i >= 200) && (t3_wb_dat_i <= 255)) |-> (t3_wb_dat_i >= 180) && (t3_wb_dat_i <= 255);
	endproperty
	assert property(af_p2883);

	property af_p2884;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t3_wb_dat_i >= 0) && (t3_wb_dat_i <= 255));
	endproperty
	assert property(af_p2884);

	property af_p2885;
	@(posedge wb_clk_i) $changed(t3_wb_dat_i) |-> $rose(wb_clk_i);
	endproperty
	assert property(af_p2885);

	property af_p2886;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t3_wb_dat_i >= 60) && (t3_wb_dat_i <= 190));
	endproperty
	assert property(af_p2886);

	property af_p2887;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(t3_wb_dat_i);
	endproperty
	assert property(af_p2887);

	property af_p2888;
	@(posedge wb_clk_i) (!t3_wb_ack_i) |-> ($stable(t3_wb_dat_i));
	endproperty
	assert property(af_p2888);

	property af_p2889;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 ((t3_wb_dat_i >= 0) && (t3_wb_dat_i <= 63));
	endproperty
	assert property(af_p2889);

	property af_p2890;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((t3_wb_dat_i >= 0) && (t3_wb_dat_i <= 255));
	endproperty
	assert property(af_p2890);

	property af_p2891;
	@(posedge wb_clk_i) (!t3_wb_we_o && t3_wb_ack_i) |-> ((t3_wb_dat_i >= 0) && (t3_wb_dat_i <= 255));
	endproperty
	assert property(af_p2891);

	property af_p2892;
	@(posedge wb_clk_i) ((t3_wb_dat_i >= 100) && (t3_wb_dat_i <= 150)) |=> (t3_wb_cyc_o -> ((t3_wb_dat_i >= 80) && (t3_wb_dat_i <= 170)));
	endproperty
	assert property(af_p2892);

	property af_p2893;
	@(posedge wb_clk_i) (t3_wb_err_i) |-> ($stable(t3_wb_dat_i));
	endproperty
	assert property(af_p2893);

	property af_p2894;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 ((t3_wb_dat_i >= 0) && (t3_wb_dat_i <= 64));
	endproperty
	assert property(af_p2894);

	property af_p2895;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((t3_wb_dat_i >= 10) && (t3_wb_dat_i <= 245));
	endproperty
	assert property(af_p2895);

	property af_p2896;
	@(posedge wb_clk_i) (t3_wb_cyc_o && t3_wb_stb_o && t3_wb_we_o && !t3_wb_ack_i) |-> ($stable(t3_wb_dat_i));
	endproperty
	assert property(af_p2896);

	property af_p2897;
	@(posedge wb_clk_i) (t3_wb_ack_i) |=> ((t3_wb_dat_i >= 0) && (t3_wb_dat_i <= 255));
	endproperty
	assert property(af_p2897);

	property af_p2898;
	@(posedge wb_clk_i) (t3_wb_ack_i) |=> ((t3_wb_dat_o >= 0) && (t3_wb_dat_o <= 255));
	endproperty
	assert property(af_p2898);

	property af_p2899;
	@(posedge wb_clk_i) (!t3_wb_we_o) |-> (t3_wb_dat_o == t3_wb_adr_o);
	endproperty
	assert property(af_p2899);

	property af_p2900;
	@(posedge wb_clk_i) (t3_wb_cyc_o && t3_wb_stb_o) |-> ((t3_wb_dat_o >= 0) && (t3_wb_dat_o <= 255));
	endproperty
	assert property(af_p2900);

	property af_p2901;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t3_wb_dat_o == 0);
	endproperty
	assert property(af_p2901);

	property af_p2902;
	@(posedge wb_clk_i) ($changed(t3_wb_dat_o)) |-> ($past(t3_wb_ack_i));
	endproperty
	assert property(af_p2902);

	property af_p2903;
	@(posedge wb_clk_i) (((t3_wb_dat_o >= 100) && (t3_wb_dat_o <= 200)) && t3_wb_cyc_o) |=> (t3_wb_cyc_o |-> ((t3_wb_dat_o >= 80) && (t3_wb_dat_o <= 220)));
	endproperty
	assert property(af_p2903);

	property af_p2904;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##3 ((t3_wb_dat_o >= 0) && (t3_wb_dat_o <= 255));
	endproperty
	assert property(af_p2904);

	property af_p2905;
	@(posedge wb_clk_i) (t3_wb_cyc_o [*5]) |-> (($stable(t3_wb_dat_o))[*5] and ((t3_wb_dat_o >= 0) && (t3_wb_dat_o <= 255)));
	endproperty
	assert property(af_p2905);

	property af_p2906;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 ((t3_wb_dat_o >= 0) && (t3_wb_dat_o <= 255));
	endproperty
	assert property(af_p2906);

	property af_p2907;
	@(posedge wb_clk_i) (t3_wb_stb_o && t3_wb_we_o) |-> (t3_wb_dat_o !== 'bx);
	endproperty
	assert property(af_p2907);

	property af_p2908;
	@(posedge wb_clk_i) (t3_wb_stb_o && t3_wb_cyc_o) |-> ((t3_wb_dat_o >= 0) && (t3_wb_dat_o <= 255));
	endproperty
	assert property(af_p2908);

	property af_p2909;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:2] !$isunknown(t3_wb_dat_o);
	endproperty
	assert property(af_p2909);

	property af_p2910;
	@(posedge wb_clk_i) ((t3_wb_dat_o >= 50) && (t3_wb_dat_o <= 75) && t3_wb_we_o) |=> (t3_wb_cyc_o -> ((t3_wb_dat_o >= 30) && (t3_wb_dat_o <= 95)));
	endproperty
	assert property(af_p2910);

	property af_p2911;
	@(posedge wb_clk_i) (t3_wb_we_o && !t3_wb_ack_i) |-> ($stable(t3_wb_dat_o) ##1 $stable(t3_wb_dat_o));
	endproperty
	assert property(af_p2911);

	property af_p2912;
	@(posedge wb_clk_i) (!t3_wb_cyc_o) |-> $stable(t3_wb_dat_o);
	endproperty
	assert property(af_p2912);

	property af_p2913;
	@(posedge wb_clk_i) (!t3_wb_cyc_o) |=> $stable(t3_wb_dat_o) until_with (t3_wb_cyc_o);
	endproperty
	assert property(af_p2913);

	property af_p2914;
	@(posedge wb_clk_i) (!t3_wb_stb_o) |-> $stable(t3_wb_dat_o);
	endproperty
	assert property(af_p2914);

	property af_p2915;
	@(posedge wb_clk_i) ((t3_wb_dat_o >= 100) && (t3_wb_dat_o <= 200)) |-> ##1 ((t3_wb_dat_o >= 80) && (t3_wb_dat_o <= 200));
	endproperty
	assert property(af_p2915);

	property af_p2916;
	@(posedge wb_clk_i) (t3_wb_stb_o && t3_wb_cyc_o) |-> $stable(t3_wb_dat_o);
	endproperty
	assert property(af_p2916);

	property af_p2917;
	@(posedge wb_clk_i) (!$stable(t3_wb_dat_o)) |-> $past(t3_wb_cyc_o && t3_wb_stb_o && t3_wb_ack_i);
	endproperty
	assert property(af_p2917);

	property af_p2918;
	@(posedge wb_clk_i) (wb_rst_i) |-> !$isunknown(t3_wb_dat_o);
	endproperty
	assert property(af_p2918);

	property af_p2919;
	@(posedge wb_clk_i) ((t3_wb_dat_o >= 50) && (t3_wb_dat_o <= 120)) |-> ##1 ((t3_wb_dat_o >= 30) && (t3_wb_dat_o <= 150));
	endproperty
	assert property(af_p2919);

	property af_p2920;
	@(posedge wb_clk_i) ($past(wb_rst_i,4) && !wb_rst_i && !t3_wb_we_o) |-> (t3_wb_dat_o >= 0) && (t3_wb_dat_o <= 255);
	endproperty
	assert property(af_p2920);

	property af_p2921;
	@(posedge wb_clk_i) ((t3_wb_dat_o >= 10) && (t3_wb_dat_o <= 90) && !t3_wb_err_i) |-> ##1 (t3_wb_dat_o >= 0) && (t3_wb_dat_o <= 100);
	endproperty
	assert property(af_p2921);

	property af_p2922;
	@(posedge wb_clk_i) $past(wb_rst_i,3) && !wb_rst_i |-> (t3_wb_dat_o >= 0) && (t3_wb_dat_o <= 255);
	endproperty
	assert property(af_p2922);

	property af_p2923;
	@(posedge wb_clk_i) (t3_wb_dat_o != $past(t3_wb_dat_o)) |-> ($past(t3_wb_stb_o) && $past(t3_wb_we_o) && (t3_wb_dat_o >= 0) && (t3_wb_dat_o <= 255));
	endproperty
	assert property(af_p2923);

	property af_p2924;
	@(posedge wb_clk_i) (!t3_wb_stb_o) |-> (t3_wb_dat_o == $past(t3_wb_dat_o));
	endproperty
	assert property(af_p2924);

	property af_p2925;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t3_wb_dat_o >= 0) && (t3_wb_dat_o <= 255);
	endproperty
	assert property(af_p2925);

	property af_p2926;
	@(posedge wb_clk_i) (t3_wb_ack_i) |-> (t3_wb_dat_o >= 0) && (t3_wb_dat_o <= 255);
	endproperty
	assert property(af_p2926);

	property af_p2927;
	@(posedge wb_clk_i) (!t3_wb_ack_i) |-> (t3_wb_dat_o == $past(t3_wb_dat_o));
	endproperty
	assert property(af_p2927);

	property af_p2928;
	@(posedge wb_clk_i) ($past(t3_wb_ack_i)) |-> (t3_wb_dat_o == $past(t3_wb_dat_i));
	endproperty
	assert property(af_p2928);

	property af_p2929;
	@(posedge wb_clk_i) (t3_wb_err_i) |=> (t3_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p2929);

	property af_p2930;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (t3_wb_err_i == 1'b0) [*3];
	endproperty
	assert property(af_p2930);

	property af_p2931;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t3_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2931);

	property af_p2932;
	@(posedge wb_clk_i) (!t3_wb_cyc_o) |-> (t3_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2932);

	property af_p2933;
	@(posedge wb_clk_i) (t3_wb_err_i) |-> $stable(t3_wb_adr_o);
	endproperty
	assert property(af_p2933);

	property af_p2934;
	@(posedge wb_clk_i) (t3_wb_err_i) |-> (t3_wb_cyc_o || $past(t3_wb_cyc_o));
	endproperty
	assert property(af_p2934);

	property af_p2935;
	@(posedge wb_clk_i) (t3_wb_we_o && !t3_wb_stb_o) |-> (t3_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2935);

	property af_p2936;
	@(posedge wb_clk_i) not (t3_wb_err_i && t3_wb_ack_i);
	endproperty
	assert property(af_p2936);

	property af_p2937;
	@(posedge wb_clk_i) ($changed(t3_wb_err_i)) |-> (t3_wb_cyc_o);
	endproperty
	assert property(af_p2937);

	property af_p2938;
	@(posedge wb_clk_i) (t3_wb_err_i && !t3_wb_cyc_o) |=> (t3_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2938);

	property af_p2939;
	@(posedge wb_clk_i) (t3_wb_we_o) |-> (t3_wb_err_i == 1'b0 || t3_wb_err_i == 1'b1);
	endproperty
	assert property(af_p2939);

	property af_p2940;
	@(posedge wb_clk_i) t3_wb_err_i |-> (t3_wb_cyc_o && t3_wb_stb_o);
	endproperty
	assert property(af_p2940);

	property af_p2941;
	@(posedge wb_clk_i) $fell(t3_wb_err_i) |-> !t3_wb_err_i[*2];
	endproperty
	assert property(af_p2941);

	property af_p2942;
	@(posedge wb_clk_i) t3_wb_err_i |-> 1'b1;
	endproperty
	assert property(af_p2942);

	property af_p2943;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t3_wb_err_i[*2];
	endproperty
	assert property(af_p2943);

	property af_p2944;
	@(posedge wb_clk_i) t3_wb_err_i |=> !t3_wb_stb_o;
	endproperty
	assert property(af_p2944);

	property af_p2945;
	@(posedge wb_clk_i) wb_rst_i |-> !t3_wb_err_i;
	endproperty
	assert property(af_p2945);

	property af_p2946;
	@(posedge wb_clk_i) disable iff (!t3_wb_cyc_o) $changed(t3_wb_err_i) |=> $stable(t3_wb_err_i) throughout t3_wb_cyc_o[*1:$];
	endproperty
	assert property(af_p2946);

	property af_p2947;
	@(posedge wb_clk_i) !t3_wb_stb_o |=> !t3_wb_err_i;
	endproperty
	assert property(af_p2947);

	property af_p2948;
	@(posedge wb_clk_i) (t3_wb_err_i && t3_wb_stb_o) |=> !t3_wb_cyc_o;
	endproperty
	assert property(af_p2948);

	property af_p2949;
	@(posedge wb_clk_i) (t3_wb_cyc_o && t3_wb_stb_o && t3_wb_err_i) |=> (!t3_wb_err_i);
	endproperty
	assert property(af_p2949);

	property af_p2950;
	@(posedge wb_clk_i) !(t3_wb_err_i && t3_wb_ack_i);
	endproperty
	assert property(af_p2950);

	property af_p2951;
	@(posedge wb_clk_i) ($rose(t3_wb_err_i)) |-> $stable(t3_wb_sel_o);
	endproperty
	assert property(af_p2951);

	property af_p2952;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (t3_wb_err_i == 1'b0)[*4];
	endproperty
	assert property(af_p2952);

	property af_p2953;
	@(posedge wb_clk_i) (t3_wb_err_i) |-> $stable(t3_wb_we_o);
	endproperty
	assert property(af_p2953);

	property af_p2954;
	@(posedge wb_clk_i) (t3_wb_err_i) |=> (!t3_wb_cyc_o);
	endproperty
	assert property(af_p2954);

	property af_p2955;
	@(posedge wb_clk_i) ($rose(t3_wb_err_i)) |-> $stable(t3_wb_adr_o);
	endproperty
	assert property(af_p2955);

	property af_p2956;
	@(posedge wb_clk_i) (!t3_wb_cyc_o) |-> (!t3_wb_err_i);
	endproperty
	assert property(af_p2956);

	property af_p2957;
	@(posedge wb_clk_i) (t3_wb_err_i) |-> (!t3_wb_ack_i);
	endproperty
	assert property(af_p2957);

	property af_p2958;
	@(posedge wb_clk_i) (t3_wb_ack_i) |-> (!t3_wb_err_i);
	endproperty
	assert property(af_p2958);

	property af_p2959;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (t3_wb_err_i == 1'b0);
	endproperty
	assert property(af_p2959);

	property af_p2960;
	@(posedge wb_clk_i) ($past(t3_wb_stb_o) && $past(t3_wb_cyc_o) && t3_wb_stb_o && t3_wb_cyc_o) |-> $stable(t3_wb_sel_o);
	endproperty
	assert property(af_p2960);

	property af_p2961;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 !$isunknown(t3_wb_sel_o);
	endproperty
	assert property(af_p2961);

	property af_p2962;
	@(posedge wb_clk_i) (t3_wb_we_o && !t3_wb_ack_i) |=> $stable(t3_wb_sel_o);
	endproperty
	assert property(af_p2962);

	property af_p2963;
	@(posedge wb_clk_i) t3_wb_ack_i |=> !$isunknown(t3_wb_sel_o);
	endproperty
	assert property(af_p2963);

	property af_p2964;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (!t3_wb_stb_o) |-> (t3_wb_sel_o == '0);
	endproperty
	assert property(af_p2964);

	property af_p2965;
	@(posedge wb_clk_i) (t3_wb_sel_o != '0) |-> t3_wb_stb_o;
	endproperty
	assert property(af_p2965);

	property af_p2966;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> !$isunknown(t3_wb_sel_o);
	endproperty
	assert property(af_p2966);

	property af_p2967;
	@(posedge wb_clk_i) ($past(t3_wb_stb_o && t3_wb_cyc_o) && (t3_wb_stb_o && t3_wb_cyc_o)) |-> $stable(t3_wb_sel_o);
	endproperty
	assert property(af_p2967);

	property af_p2968;
	@(posedge wb_clk_i) (t3_wb_stb_o && t3_wb_cyc_o) |-> (t3_wb_sel_o != '0);
	endproperty
	assert property(af_p2968);

	property af_p2969;
	@(posedge wb_clk_i) ($past(t3_wb_stb_o) && t3_wb_stb_o) |-> $stable(t3_wb_sel_o);
	endproperty
	assert property(af_p2969);

	property af_p2970;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (t3_wb_sel_o === '0);
	endproperty
	assert property(af_p2970);

	property af_p2971;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (!t3_wb_stb_o -> !$isunknown(t3_wb_sel_o));
	endproperty
	assert property(af_p2971);

	property af_p2972;
	@(posedge wb_clk_i) t3_wb_we_o |-> (t3_wb_sel_o != '0);
	endproperty
	assert property(af_p2972);

	property af_p2973;
	@(posedge wb_clk_i) (t3_wb_cyc_o && !t3_wb_ack_i) |-> $stable(t3_wb_sel_o);
	endproperty
	assert property(af_p2973);

	property af_p2974;
	@(posedge wb_clk_i) wb_rst_i |-> (t3_wb_sel_o === '0);
	endproperty
	assert property(af_p2974);

	property af_p2975;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (t3_wb_sel_o === '0);
	endproperty
	assert property(af_p2975);

	property af_p2976;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 !$isunknown(t3_wb_sel_o);
	endproperty
	assert property(af_p2976);

	property af_p2977;
	@(posedge wb_clk_i) (t3_wb_cyc_o && t3_wb_stb_o) |-> $stable(t3_wb_sel_o);
	endproperty
	assert property(af_p2977);

	property af_p2978;
	@(posedge wb_clk_i) t3_wb_ack_i |-> (t3_wb_sel_o === $past(t3_wb_sel_o));
	endproperty
	assert property(af_p2978);

	property af_p2979;
	@(posedge wb_clk_i) (i0_wb_sel_i) |-> (t3_wb_sel_o == i0_wb_sel_i);
	endproperty
	assert property(af_p2979);

	property af_p2980;
	@(posedge wb_clk_i) (t3_wb_stb_o) |=> $stable(t3_wb_sel_o);
	endproperty
	assert property(af_p2980);

	property af_p2981;
	@(posedge wb_clk_i) (!t3_wb_cyc_o) |-> (t3_wb_sel_o == '0);
	endproperty
	assert property(af_p2981);

	property af_p2982;
	@(posedge wb_clk_i) (t3_wb_we_o && t3_wb_stb_o) |=> $stable(t3_wb_sel_o) throughout (t3_wb_we_o && t3_wb_stb_o)[*1:$];
	endproperty
	assert property(af_p2982);

	property af_p2983;
	@(posedge wb_clk_i) ($fell(t3_wb_cyc_o)) |=> ($stable(t3_wb_sel_o) throughout (!t3_wb_cyc_o)[*1:$] ##0 t3_wb_cyc_o);
	endproperty
	assert property(af_p2983);

	property af_p2984;
	@(posedge wb_clk_i) (t3_wb_cyc_o) |-> $stable(t3_wb_sel_o);
	endproperty
	assert property(af_p2984);

	property af_p2985;
	@(posedge wb_clk_i) (t3_wb_ack_i) |-> $stable(t3_wb_sel_o);
	endproperty
	assert property(af_p2985);

	property af_p2986;
	@(posedge wb_clk_i) (t3_wb_stb_o) |-> $stable(t3_wb_sel_o) throughout (t3_wb_stb_o [*1:$] ##0 t3_wb_ack_i);
	endproperty
	assert property(af_p2986);

	property af_p2987;
	@(posedge wb_clk_i) (t3_wb_stb_o) |-> (!$isunknown(t3_wb_sel_o));
	endproperty
	assert property(af_p2987);

	property af_p2988;
	@(posedge wb_clk_i) (!t3_wb_cyc_o) |-> $stable(t3_wb_sel_o);
	endproperty
	assert property(af_p2988);



	property af_p2991;
	@(posedge wb_clk_i) t3_wb_stb_o |-> $stable(t3_wb_sel_o);
	endproperty
	assert property(af_p2991);

	property af_p2992;
	@(posedge wb_clk_i) $fell(t3_wb_stb_o) |-> $stable(t3_wb_sel_o) throughout (t3_wb_stb_o[->1]);
	endproperty
	assert property(af_p2992);

	property af_p2993;
	@(posedge wb_clk_i) t3_wb_stb_o |-> t3_wb_cyc_o;
	endproperty
	assert property(af_p2993);

	property af_p2994;
	@(posedge wb_clk_i) $rose(t3_wb_stb_o) |=> t3_wb_stb_o;
	endproperty
	assert property(af_p2994);

	property af_p2995;
	@(posedge wb_clk_i) (t3_wb_stb_o && t3_wb_ack_i) |=> !t3_wb_stb_o;
	endproperty
	assert property(af_p2995);

	property af_p2996;
	@(posedge wb_clk_i) t3_wb_stb_o |-> $stable(t3_wb_we_o);
	endproperty
	assert property(af_p2996);

	property af_p2997;
	@(posedge wb_clk_i) $fell(t3_wb_cyc_o) |-> ##[0:1] !t3_wb_stb_o;
	endproperty
	assert property(af_p2997);

	property af_p2998;
	@(posedge wb_clk_i) (t3_wb_stb_o && t3_wb_we_o) |-> $stable(t3_wb_adr_o);
	endproperty
	assert property(af_p2998);

	property af_p2999;
	@(posedge wb_clk_i) t3_wb_stb_o == t3_wb_cyc_o;
	endproperty
	assert property(af_p2999);

	property af_p3000;
	@(posedge wb_clk_i) wb_rst_i |-> !t3_wb_stb_o;
	endproperty
	assert property(af_p3000);

	property af_p3001;
	@(posedge wb_clk_i) t3_wb_ack_i |=> !t3_wb_stb_o;
	endproperty
	assert property(af_p3001);

	property af_p3002;
	@(posedge wb_clk_i) (t3_wb_stb_o && !t3_wb_ack_i) |=> t3_wb_stb_o;
	endproperty
	assert property(af_p3002);

	property af_p3003;
	@(posedge wb_clk_i) (t3_wb_stb_o && t3_wb_we_o) |-> $stable(t3_wb_dat_o);
	endproperty
	assert property(af_p3003);

	property af_p3004;
	@(posedge wb_clk_i) $fell(t3_wb_stb_o) |=> !t3_wb_stb_o;
	endproperty
	assert property(af_p3004);

	property af_p3005;
	@(posedge wb_clk_i) (wb_rst_i |-> !t3_wb_stb_o) and ($fell(wb_rst_i) |=> !t3_wb_stb_o[*2]);
	endproperty
	assert property(af_p3005);

	property af_p3006;
	@(posedge wb_clk_i) t3_wb_stb_o |-> (!$isunknown(t3_wb_adr_o) && $stable(t3_wb_adr_o));
	endproperty
	assert property(af_p3006);

	property af_p3007;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> !t3_wb_stb_o[*2];
	endproperty
	assert property(af_p3007);

	property af_p3008;
	@(posedge wb_clk_i) $changed(t3_wb_stb_o) |=> $stable(t3_wb_stb_o);
	endproperty
	assert property(af_p3008);

	property af_p3009;
	@(posedge wb_clk_i) (t3_wb_stb_o && t3_wb_ack_i) |=> !t3_wb_stb_o ##1 t3_wb_stb_o;
	endproperty
	assert property(af_p3009);

	property af_p3010;
	@(posedge wb_clk_i) t3_wb_err_i |=> !t3_wb_stb_o;
	endproperty
	assert property(af_p3010);

	property af_p3011;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t3_wb_stb_o;
	endproperty
	assert property(af_p3011);

	property af_p3012;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> !t3_wb_stb_o;
	endproperty
	assert property(af_p3012);

	property af_p3013;
	@(posedge wb_clk_i) t3_wb_stb_o |-> $stable(t3_wb_adr_o);
	endproperty
	assert property(af_p3013);

	property af_p3014;
	@(posedge wb_clk_i) (!t3_wb_we_o && t3_wb_ack_i) |-> (!$isunknown(t3_wb_dat_i));
	endproperty
	assert property(af_p3014);

	property af_p3015;
	@(posedge wb_clk_i) (t3_wb_we_o) |-> (t3_wb_cyc_o && t3_wb_stb_o);
	endproperty
	assert property(af_p3015);

	property af_p3016;
	@(posedge wb_clk_i) (t3_wb_we_o && t3_wb_stb_o) |-> ($stable(t3_wb_dat_o) || !$isunknown(t3_wb_dat_o));
	endproperty
	assert property(af_p3016);

	property af_p3017;
	@(posedge wb_clk_i) (t3_wb_we_o && t3_wb_ack_i) |=> (t3_wb_we_o == 1'b0);
	endproperty
	assert property(af_p3017);

	property af_p3018;
	@(posedge wb_clk_i) (!t3_wb_cyc_o) |-> (t3_wb_we_o == 1'b0);
	endproperty
	assert property(af_p3018);

	property af_p3019;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t3_wb_we_o == 1'b0);
	endproperty
	assert property(af_p3019);

	property af_p3020;
	@(posedge wb_clk_i) (t3_wb_we_o) |-> ($stable(t3_wb_dat_o) throughout (t3_wb_we_o[*1:$] ##0 t3_wb_ack_i));
	endproperty
	assert property(af_p3020);

	property af_p3021;
	@(posedge wb_clk_i) (1'b1) |-> ($stable(t3_wb_we_o) || $changed(t3_wb_we_o));
	endproperty
	assert property(af_p3021);

	property af_p3022;
	@(posedge wb_clk_i) (t3_wb_cyc_o && t3_wb_stb_o && t3_wb_we_o) |=> (t3_wb_cyc_o && t3_wb_stb_o |-> t3_wb_we_o);
	endproperty
	assert property(af_p3022);

	property af_p3023;
	@(posedge wb_clk_i) t3_wb_we_o |-> t3_wb_stb_o;
	endproperty
	assert property(af_p3023);

	property af_p3024;
	@(posedge wb_clk_i) ($past(!t3_wb_we_o) && t3_wb_we_o) |-> t3_wb_cyc_o;
	endproperty
	assert property(af_p3024);

	property af_p3025;
	@(posedge wb_clk_i) t3_wb_ack_i |-> $stable(t3_wb_we_o);
	endproperty
	assert property(af_p3025);

	property af_p3026;
	@(posedge wb_clk_i) (wb_rst_i) |-> !t3_wb_we_o;
	endproperty
	assert property(af_p3026);

	property af_p3027;
	@(posedge wb_clk_i) (t3_wb_cyc_o && !t3_wb_ack_i) |-> $stable(t3_wb_we_o);
	endproperty
	assert property(af_p3027);

	property af_p3028;
	@(posedge wb_clk_i) ($past(t3_wb_we_o) && !t3_wb_we_o && t3_wb_cyc_o) |-> $past(t3_wb_ack_i);
	endproperty
	assert property(af_p3028);

	property af_p3029;
	@(posedge wb_clk_i) (t3_wb_cyc_o && t3_wb_stb_o && !t3_wb_ack_i) |-> $stable(t3_wb_we_o);
	endproperty
	assert property(af_p3029);

	property af_p3030;
	@(posedge wb_clk_i) (t3_wb_stb_o && !t3_wb_ack_i) |-> $stable(t3_wb_we_o);
	endproperty
	assert property(af_p3030);

	property af_p3031;
	@(posedge wb_clk_i) wb_rst_i |-> !t3_wb_we_o;
	endproperty
	assert property(af_p3031);

	property af_p3032;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (!$isunknown(t3_wb_we_o));
	endproperty
	assert property(af_p3032);

	property af_p3033;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!$isunknown(t3_wb_we_o) ##1 !$isunknown(t3_wb_we_o));
	endproperty
	assert property(af_p3033);

	property af_p3034;
	@(posedge wb_clk_i) (!t3_wb_cyc_o) |-> (!t3_wb_we_o);
	endproperty
	assert property(af_p3034);

	property af_p3035;
	@(posedge wb_clk_i) ($fell(t3_wb_cyc_o)) |=> (!t3_wb_we_o);
	endproperty
	assert property(af_p3035);

	property af_p3036;
	@(posedge wb_clk_i) (t3_wb_cyc_o && t3_wb_stb_o) |-> (!$isunknown(t3_wb_we_o));
	endproperty
	assert property(af_p3036);

	property af_p3037;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!t3_wb_we_o && !t3_wb_cyc_o);
	endproperty
	assert property(af_p3037);

	property af_p3038;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!t3_wb_we_o ##1 !t3_wb_we_o);
	endproperty
	assert property(af_p3038);

	property af_p3039;
	@(posedge wb_clk_i) (t3_wb_we_o && t3_wb_stb_o) |-> (t3_wb_we_o && t3_wb_stb_o) until_with (t3_wb_ack_i || t3_wb_err_i);
	endproperty
	assert property(af_p3039);

	property af_p3040;
	@(posedge wb_clk_i) (t3_wb_we_o) |-> (!$isunknown(t3_wb_dat_o));
	endproperty
	assert property(af_p3040);

	property af_p3041;
	@(posedge wb_clk_i) (t4_wb_stb_o && t4_wb_we_o) |-> ##[1:3] (t4_wb_ack_i == 1'b1);
	endproperty
	assert property(af_p3041);

	property af_p3042;
	@(posedge wb_clk_i) (!t4_wb_cyc_o) |-> (t4_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p3042);

	property af_p3043;
	@(posedge wb_clk_i) (t4_wb_ack_i) |-> $stable(t4_wb_dat_i);
	endproperty
	assert property(af_p3043);

	property af_p3044;
	@(posedge wb_clk_i) (!t4_wb_we_o && t4_wb_ack_i) |-> $stable(t4_wb_dat_i);
	endproperty
	assert property(af_p3044);

	property af_p3045;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t4_wb_ack_i == 1'b0) ##1 (t4_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p3045);

	property af_p3046;
	@(posedge wb_clk_i) (!t4_wb_cyc_o) |=> (!t4_wb_cyc_o throughout (!t4_wb_ack_i));
	endproperty
	assert property(af_p3046);

	property af_p3047;
	@(posedge wb_clk_i) (t4_wb_ack_i) |-> ##1 (t4_wb_cyc_o || !t4_wb_cyc_o);
	endproperty
	assert property(af_p3047);

	property af_p3048;
	@(posedge wb_clk_i) (t4_wb_we_o && t4_wb_stb_o && t4_wb_cyc_o) |=> (t4_wb_ack_i == 1'b1);
	endproperty
	assert property(af_p3048);

	property af_p3049;
	@(posedge wb_clk_i) (t4_wb_ack_i) |=> (t4_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p3049);

	property af_p3050;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t4_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p3050);

	property af_p3051;
	@(posedge wb_clk_i) (t4_wb_ack_i) |-> ($past(t4_wb_stb_o));
	endproperty
	assert property(af_p3051);

	property af_p3052;
	@(posedge wb_clk_i) (t4_wb_ack_i) |-> ($past(t4_wb_cyc_o) && $past(t4_wb_stb_o));
	endproperty
	assert property(af_p3052);

	property af_p3053;
	@(posedge wb_clk_i) t4_wb_ack_i |-> t4_wb_cyc_o;
	endproperty
	assert property(af_p3053);

	property af_p3054;
	@(posedge wb_clk_i) t4_wb_ack_i |-> $past(t4_wb_cyc_o && t4_wb_stb_o);
	endproperty
	assert property(af_p3054);

	property af_p3055;
	@(posedge wb_clk_i) t4_wb_ack_i |-> $stable(t4_wb_ack_i);
	endproperty
	assert property(af_p3055);

	property af_p3056;
	@(posedge wb_clk_i) ($fell(wb_rst_i) && !t4_wb_stb_o) |=> !t4_wb_ack_i;
	endproperty
	assert property(af_p3056);

	property af_p3057;
	@(posedge wb_clk_i) t4_wb_ack_i |=> !t4_wb_ack_i;
	endproperty
	assert property(af_p3057);

	property af_p3058;
	@(posedge wb_clk_i) !(t4_wb_ack_i && t4_wb_err_i);
	endproperty
	assert property(af_p3058);

	property af_p3059;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t4_wb_ack_i ##1 !t4_wb_ack_i);
	endproperty
	assert property(af_p3059);

	property af_p3060;
	@(posedge wb_clk_i) t4_wb_ack_i |-> $stable(t4_wb_dat_i);
	endproperty
	assert property(af_p3060);

	property af_p3061;
	@(posedge wb_clk_i) (t4_wb_stb_o && t4_wb_cyc_o && t4_wb_ack_i) |=> !t4_wb_ack_i;
	endproperty
	assert property(af_p3061);

	property af_p3062;
	@(posedge wb_clk_i) disable iff (wb_rst_i) $rose(t4_wb_ack_i) |-> ($past(t4_wb_cyc_o) && $past(t4_wb_stb_o));
	endproperty
	assert property(af_p3062);

	property af_p3063;
	@(posedge wb_clk_i) (t4_wb_cyc_o && !t4_wb_stb_o) |-> !t4_wb_ack_i;
	endproperty
	assert property(af_p3063);

	property af_p3064;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t4_wb_ack_i;
	endproperty
	assert property(af_p3064);

	property af_p3065;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(t4_wb_ack_i);
	endproperty
	assert property(af_p3065);

	property af_p3066;
	@(posedge wb_clk_i) (t4_wb_ack_i) |-> (t4_wb_cyc_o && t4_wb_stb_o);
	endproperty
	assert property(af_p3066);

	property af_p3067;
	@(posedge wb_clk_i) $rose(t4_wb_adr_o) |-> ##[0:1] t4_wb_ack_i;
	endproperty
	assert property(af_p3067);

	property af_p3068;
	@(posedge wb_clk_i) ($past(t4_wb_ack_i) && !t4_wb_stb_o) |-> !t4_wb_ack_i;
	endproperty
	assert property(af_p3068);

	property af_p3069;
	@(posedge wb_clk_i) (t4_wb_we_o && t4_wb_ack_i) |-> $stable(t4_wb_dat_o);
	endproperty
	assert property(af_p3069);

	property af_p3070;
	@(posedge wb_clk_i) (t4_wb_ack_i) |-> (t4_wb_stb_o);
	endproperty
	assert property(af_p3070);

	property af_p3071;
	@(posedge wb_clk_i) $fell(t4_wb_stb_o) |=> !t4_wb_ack_i;
	endproperty
	assert property(af_p3071);

	property af_p3072;
	@(posedge wb_clk_i) wb_rst_i |-> $stable(t4_wb_adr_o);
	endproperty
	assert property(af_p3072);

	property af_p3073;
	@(posedge wb_clk_i) t4_wb_cyc_o |-> $stable(t4_wb_adr_o);
	endproperty
	assert property(af_p3073);

	property af_p3074;
	@(posedge wb_clk_i) t4_wb_stb_o |=> $stable(t4_wb_adr_o);
	endproperty
	assert property(af_p3074);


	property af_p3076;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (!$isunknown(t4_wb_adr_o) && $stable(t4_wb_adr_o));
	endproperty
	assert property(af_p3076);

	property af_p3077;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_stb_o && !t4_wb_ack_i) |=> $stable(t4_wb_adr_o);
	endproperty
	assert property(af_p3077);

	property af_p3078;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> !$isunknown(t4_wb_adr_o);
	endproperty
	assert property(af_p3078);

	property af_p3079;
	@(posedge wb_clk_i) (t4_wb_we_o && t4_wb_stb_o) |=> ($stable(t4_wb_adr_o) throughout t4_wb_ack_i[->1]);
	endproperty
	assert property(af_p3079);

	property af_p3080;
	@(posedge wb_clk_i) wb_rst_i |=> !$isunknown(t4_wb_adr_o);
	endproperty
	assert property(af_p3080);

	property af_p3081;
	@(posedge wb_clk_i) $changed(t4_wb_adr_o) |-> $past(t4_wb_ack_i);
	endproperty
	assert property(af_p3081);

	property af_p3082;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_stb_o && t4_wb_we_o) |-> (!$isunknown(t4_wb_adr_o) && !$isunknown(t4_wb_dat_o));
	endproperty
	assert property(af_p3082);

	property af_p3083;
	@(posedge wb_clk_i) t4_wb_ack_i |-> $stable(t4_wb_adr_o);
	endproperty
	assert property(af_p3083);

	property af_p3084;
	@(posedge wb_clk_i) !t4_wb_stb_o |-> !t4_wb_ack_i;
	endproperty
	assert property(af_p3084);

	property af_p3085;
	@(posedge wb_clk_i) (t4_wb_cyc_o && !t4_wb_ack_i) |=> $stable(t4_wb_adr_o);
	endproperty
	assert property(af_p3085);

	property af_p3086;
	@(posedge wb_clk_i) t4_wb_stb_o |-> !$isunknown(t4_wb_adr_o);
	endproperty
	assert property(af_p3086);

	property af_p3087;
	@(posedge wb_clk_i) t4_wb_err_i |=> $stable(t4_wb_adr_o);
	endproperty
	assert property(af_p3087);

	property af_p3088;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[0:2] !$isunknown(t4_wb_adr_o);
	endproperty
	assert property(af_p3088);

	property af_p3089;
	@(posedge wb_clk_i) t4_wb_cyc_o |-> !$isunknown(t4_wb_adr_o);
	endproperty
	assert property(af_p3089);

	property af_p3090;
	@(posedge wb_clk_i) (t4_wb_ack_i) |=> (t4_wb_adr_o != $past(t4_wb_adr_o));
	endproperty
	assert property(af_p3090);

	property af_p3091;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_stb_o) |-> ($stable(t4_wb_adr_o) until_with t4_wb_ack_i);
	endproperty
	assert property(af_p3091);

	property af_p3092;
	@(posedge wb_clk_i) (t4_wb_ack_i) |-> ($stable(t4_wb_adr_o) ##1 1);
	endproperty
	assert property(af_p3092);

	property af_p3093;
	@(posedge wb_clk_i) ($fell(t4_wb_cyc_o)) |=> ($stable(t4_wb_adr_o) || $changed(t4_wb_adr_o));
	endproperty
	assert property(af_p3093);

	property af_p3094;
	@(posedge wb_clk_i) (!t4_wb_cyc_o) |=> ($stable(t4_wb_adr_o) || $changed(t4_wb_adr_o));
	endproperty
	assert property(af_p3094);

	property af_p3095;
	@(posedge wb_clk_i) (t4_wb_we_o && t4_wb_cyc_o) |-> ($stable(t4_wb_adr_o) until_with t4_wb_ack_i);
	endproperty
	assert property(af_p3095);

	property af_p3096;
	@(posedge wb_clk_i) (t4_wb_we_o && t4_wb_cyc_o && t4_wb_stb_o) |-> ($stable(t4_wb_adr_o) until_with t4_wb_ack_i);
	endproperty
	assert property(af_p3096);

	property af_p3097;
	@(posedge wb_clk_i) (wb_rst_i) |=> $stable(t4_wb_adr_o);
	endproperty
	assert property(af_p3097);

	property af_p3098;
	@(posedge wb_clk_i) wb_rst_i |-> !t4_wb_cyc_o;
	endproperty
	assert property(af_p3098);

	property af_p3099;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_we_o) |=> t4_wb_cyc_o;
	endproperty
	assert property(af_p3099);

	property af_p3100;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_ack_i) |=> !t4_wb_cyc_o;
	endproperty
	assert property(af_p3100);

	property af_p3101;
	@(posedge wb_clk_i) $rose(t4_wb_cyc_o) |-> 1'b1;
	endproperty
	assert property(af_p3101);

	property af_p3102;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:3] !$isunknown(t4_wb_cyc_o);
	endproperty
	assert property(af_p3102);

	property af_p3103;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_we_o) |-> (t4_wb_cyc_o until t4_wb_ack_i);
	endproperty
	assert property(af_p3103);

	property af_p3104;
	@(posedge wb_clk_i) t4_wb_cyc_o |-> !wb_rst_i;
	endproperty
	assert property(af_p3104);

	property af_p3105;
	@(posedge wb_clk_i) (t4_wb_cyc_o && !t4_wb_ack_i) |=> t4_wb_cyc_o;
	endproperty
	assert property(af_p3105);

	property af_p3106;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t4_wb_cyc_o;
	endproperty
	assert property(af_p3106);

	property af_p3107;
	@(posedge wb_clk_i) $rose(t4_wb_cyc_o) |-> (t4_wb_cyc_o until (t4_wb_ack_i || t4_wb_err_i));
	endproperty
	assert property(af_p3107);

	property af_p3108;
	@(posedge wb_clk_i) (t4_wb_cyc_o == t4_wb_stb_o) |=> (t4_wb_cyc_o == t4_wb_stb_o);
	endproperty
	assert property(af_p3108);

	property af_p3109;
	@(posedge wb_clk_i) (t4_wb_stb_o) |-> (t4_wb_cyc_o);
	endproperty
	assert property(af_p3109);

	property af_p3110;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_err_i) |=> !t4_wb_cyc_o;
	endproperty
	assert property(af_p3110);

	property af_p3111;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> !t4_wb_cyc_o[*2];
	endproperty
	assert property(af_p3111);

	property af_p3112;
	@(posedge wb_clk_i) (!t4_wb_ack_i && !t4_wb_err_i) |-> $stable(t4_wb_cyc_o);
	endproperty
	assert property(af_p3112);

	property af_p3113;
	@(posedge wb_clk_i) (t4_wb_ack_i) |=> (!t4_wb_cyc_o || t4_wb_stb_o);
	endproperty
	assert property(af_p3113);

	property af_p3114;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_we_o) |-> (t4_wb_cyc_o throughout (!t4_wb_ack_i)[*0:$] ##1 (t4_wb_ack_i ##1 !t4_wb_cyc_o));
	endproperty
	assert property(af_p3114);

	property af_p3115;
	@(posedge wb_clk_i) (t4_wb_cyc_o && !t4_wb_ack_i && !t4_wb_err_i)[*3] |-> t4_wb_cyc_o;
	endproperty
	assert property(af_p3115);

	property af_p3116;
	@(posedge wb_clk_i) (wb_rst_i) |-> !t4_wb_cyc_o;
	endproperty
	assert property(af_p3116);

	property af_p3117;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(t4_wb_cyc_o);
	endproperty
	assert property(af_p3117);

	property af_p3118;
	@(posedge wb_clk_i) (t4_wb_ack_i) |=> !t4_wb_cyc_o;
	endproperty
	assert property(af_p3118);

	property af_p3119;
	@(posedge wb_clk_i) $rose(t4_wb_cyc_o) |-> ##1 (t4_wb_cyc_o);
	endproperty
	assert property(af_p3119);

	property af_p3120;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t4_wb_cyc_o) ##1 (!t4_wb_cyc_o) ##1 (!t4_wb_cyc_o);
	endproperty
	assert property(af_p3120);

	property af_p3121;
	@(posedge wb_clk_i) (t4_wb_cyc_o) |-> (t4_wb_stb_o);
	endproperty
	assert property(af_p3121);

	property af_p3122;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t4_wb_cyc_o) ##1 (!t4_wb_cyc_o);
	endproperty
	assert property(af_p3122);

	property af_p3123;
	@(posedge wb_clk_i) (t4_wb_cyc_o == t4_wb_stb_o);
	endproperty
	assert property(af_p3123);

	property af_p3124;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_stb_o) |-> (t4_wb_cyc_o && t4_wb_stb_o);
	endproperty
	assert property(af_p3124);

	property af_p3125;
	@(posedge wb_clk_i) ($rose(t4_wb_cyc_o)) |-> (t4_wb_cyc_o throughout ((t4_wb_ack_i || t4_wb_err_i)[->1])) ##1 (!t4_wb_cyc_o || !$past(t4_wb_ack_i || t4_wb_err_i));
	endproperty
	assert property(af_p3125);

	property af_p3126;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t4_wb_cyc_o);
	endproperty
	assert property(af_p3126);

	property af_p3127;
	@(posedge wb_clk_i) (t4_wb_err_i) |-> 1'b1;
	endproperty
	assert property(af_p3127);

	property af_p3128;
	@(posedge wb_clk_i) ((t4_wb_dat_i >= 100) && (t4_wb_dat_i <= 150)) |-> ##1 ((t4_wb_dat_i >= 80) && (t4_wb_dat_i <= 150));
	endproperty
	assert property(af_p3128);

	property af_p3129;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_stb_o) |-> ($stable(t4_wb_dat_i) until t4_wb_ack_i);
	endproperty
	assert property(af_p3129);

	property af_p3130;
	@(posedge wb_clk_i) (t4_wb_ack_i) |-> (t4_wb_dat_i >= 0) && (t4_wb_dat_i <= 255);
	endproperty
	assert property(af_p3130);

	property af_p3131;
	@(posedge wb_clk_i) ((t4_wb_dat_i >= 200) && (t4_wb_dat_i <= 255)) |-> ##1 ((t4_wb_dat_i >= 180) && (t4_wb_dat_i <= 255));
	endproperty
	assert property(af_p3131);

	property af_p3132;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##[1:2] ((t4_wb_dat_i >= 1) && (t4_wb_dat_i <= 254));
	endproperty
	assert property(af_p3132);

	property af_p3133;
	@(posedge wb_clk_i) (t4_wb_ack_i) |-> (!$isunknown(t4_wb_dat_i));
	endproperty
	assert property(af_p3133);

	property af_p3134;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 ((t4_wb_dat_i >= 0) && (t4_wb_dat_i <= 255));
	endproperty
	assert property(af_p3134);

	property af_p3135;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_stb_o && t4_wb_ack_i) |-> (!$isunknown(t4_wb_dat_i));
	endproperty
	assert property(af_p3135);

	property af_p3136;
	@(posedge wb_clk_i) (t4_wb_ack_i && $past(t4_wb_ack_i)) |-> $stable(t4_wb_dat_i);
	endproperty
	assert property(af_p3136);

	property af_p3137;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 ((t4_wb_dat_i >= 50) && (t4_wb_dat_i <= 200));
	endproperty
	assert property(af_p3137);

	property af_p3138;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t4_wb_dat_i == 0);
	endproperty
	assert property(af_p3138);

	property af_p3139;
	@(posedge wb_clk_i) ($rose(!wb_rst_i)) |-> ##4 ((t4_wb_dat_i >= 0) && (t4_wb_dat_i <= 255));
	endproperty
	assert property(af_p3139);

	property af_p3140;
	@(posedge wb_clk_i) (t4_wb_stb_o && t4_wb_ack_i) |-> (t4_wb_dat_i >= 0) && (t4_wb_dat_i <= 255);
	endproperty
	assert property(af_p3140);

	property af_p3141;
	@(posedge wb_clk_i) (t4_wb_ack_i) |=> ((t4_wb_dat_i >= 0) && (t4_wb_dat_i <= 255))[*2];
	endproperty
	assert property(af_p3141);

	property af_p3142;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (t4_wb_dat_i >= 0) && (t4_wb_dat_i <= 255);
	endproperty
	assert property(af_p3142);

	property af_p3143;
	@(posedge wb_clk_i) (t4_wb_ack_i) |-> ##1 ((t4_wb_dat_i >= 0) && (t4_wb_dat_i <= 255));
	endproperty
	assert property(af_p3143);

	property af_p3144;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t4_wb_dat_i >= 0) && (t4_wb_dat_i <= 255);
	endproperty
	assert property(af_p3144);

	property af_p3145;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_stb_o) |=> (t4_wb_dat_i >= 0) && (t4_wb_dat_i <= 255);
	endproperty
	assert property(af_p3145);

	property af_p3146;
	@(posedge wb_clk_i) ($rose(!wb_rst_i)) |-> ##4 ((t4_wb_dat_i >= 0) && (t4_wb_dat_i <= 63));
	endproperty
	assert property(af_p3146);

	property af_p3147;
	@(posedge wb_clk_i) (t4_wb_err_i) |-> (1'b1);
	endproperty
	assert property(af_p3147);

	property af_p3148;
	@(posedge wb_clk_i) (!t4_wb_we_o && t4_wb_ack_i) |-> (t4_wb_dat_i >= 0) && (t4_wb_dat_i <= 255);
	endproperty
	assert property(af_p3148);

	property af_p3149;
	@(posedge wb_clk_i) (!t4_wb_cyc_o) |=> (t4_wb_cyc_o && t4_wb_stb_o) |-> ((t4_wb_dat_i >= 0) && (t4_wb_dat_i <= 255));
	endproperty
	assert property(af_p3149);

	property af_p3150;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 (t4_wb_dat_i == '0);
	endproperty
	assert property(af_p3150);

	property af_p3151;
	@(posedge wb_clk_i) (t4_wb_err_i) |-> $stable(t4_wb_dat_i);
	endproperty
	assert property(af_p3151);

	property af_p3152;
	@(posedge wb_clk_i) (!t4_wb_we_o && t4_wb_stb_o) |-> ##1 ((t4_wb_dat_i >= 0) && (t4_wb_dat_i <= 255));
	endproperty
	assert property(af_p3152);

	property af_p3153;
	@(posedge wb_clk_i) (t4_wb_sel_o != '1) |-> 1'b1;
	endproperty
	assert property(af_p3153);

	property af_p3154;
	@(posedge wb_clk_i) (t4_wb_ack_i) |-> $stable(t4_wb_dat_i);
	endproperty
	assert property(af_p3154);

	property af_p3155;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((t4_wb_dat_i >= 0) && (t4_wb_dat_i <= 255));
	endproperty
	assert property(af_p3155);

	property af_p3156;
	@(posedge wb_clk_i) (!t4_wb_we_o && t4_wb_ack_i) |-> ((t4_wb_dat_i >= 0) && (t4_wb_dat_i <= 255));
	endproperty
	assert property(af_p3156);

	property af_p3157;
	@(posedge wb_clk_i) ((t4_wb_dat_i >= 100) && (t4_wb_dat_i <= 150)) |-> ##1 ((t4_wb_dat_i >= 80) && (t4_wb_dat_i <= 170));
	endproperty
	assert property(af_p3157);

	property af_p3158;
	@(posedge wb_clk_i) (t4_wb_ack_i) |-> ($sampled(t4_wb_dat_i) == t4_wb_dat_i);
	endproperty
	assert property(af_p3158);

	property af_p3159;
	@(posedge wb_clk_i) (t4_wb_stb_o && t4_wb_we_o) |-> ((t4_wb_dat_o >= 0) && (t4_wb_dat_o <= 255));
	endproperty
	assert property(af_p3159);

	property af_p3160;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##[1:2] ((t4_wb_dat_o >= 0) && (t4_wb_dat_o <= 255));
	endproperty
	assert property(af_p3160);

	property af_p3161;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_stb_o) |=> (t4_wb_dat_o == t4_wb_adr_o);
	endproperty
	assert property(af_p3161);

	property af_p3162;
	@(posedge wb_clk_i) ((t4_wb_dat_o >= 100) && (t4_wb_dat_o <= 150)) |=> ((t4_wb_dat_o >= 80) && (t4_wb_dat_o <= 170));
	endproperty
	assert property(af_p3162);

	property af_p3163;
	@(posedge wb_clk_i) (t4_wb_we_o && (t4_wb_sel_o != '0)) |=> ((t4_wb_dat_o >= 100) && (t4_wb_dat_o <= 200));
	endproperty
	assert property(af_p3163);

	property af_p3164;
	@(posedge wb_clk_i) (!t4_wb_stb_o) |=> ($stable(t4_wb_dat_o));
	endproperty
	assert property(af_p3164);

	property af_p3165;
	@(posedge wb_clk_i) (t4_wb_cyc_o) |-> (t4_wb_dat_o == t4_wb_dat_i);
	endproperty
	assert property(af_p3165);

	property af_p3166;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ((t4_wb_dat_o >= 0) && (t4_wb_dat_o <= 255))[*5];
	endproperty
	assert property(af_p3166);

	property af_p3167;
	@(posedge wb_clk_i) (t4_wb_ack_i) |=> ((t4_wb_dat_o >= 0) && (t4_wb_dat_o <= 255));
	endproperty
	assert property(af_p3167);

	property af_p3168;
	@(posedge wb_clk_i) (t4_wb_ack_i && (t4_wb_dat_o >= 100) && (t4_wb_dat_o <= 200)) |=> ((t4_wb_dat_o >= 80) && (t4_wb_dat_o <= 220));
	endproperty
	assert property(af_p3168);

	property af_p3169;
	@(posedge wb_clk_i) (t4_wb_ack_i) |-> ($stable(t4_wb_dat_o));
	endproperty
	assert property(af_p3169);

	property af_p3170;
	@(posedge wb_clk_i) ((t4_wb_dat_o >= 230) && (t4_wb_dat_o <= 255)) |=> ((t4_wb_dat_o >= 205) && (t4_wb_dat_o <= 255));
	endproperty
	assert property(af_p3170);

	property af_p3171;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((t4_wb_dat_o >= 0) && (t4_wb_dat_o <= 45));
	endproperty
	assert property(af_p3171);

	property af_p3172;
	@(posedge wb_clk_i) ($past(t4_wb_ack_i) && t4_wb_ack_i) |-> $stable(t4_wb_dat_o);
	endproperty
	assert property(af_p3172);

	property af_p3173;
	@(posedge wb_clk_i) (t4_wb_stb_o && !$isunknown(t4_wb_adr_o)) |=> ((t4_wb_dat_o >= 0) && (t4_wb_dat_o <= 255));
	endproperty
	assert property(af_p3173);

	property af_p3174;
	@(posedge wb_clk_i) (t4_wb_stb_o) |-> ##[0:3] (!$isunknown(t4_wb_dat_o));
	endproperty
	assert property(af_p3174);

	property af_p3175;
	@(posedge wb_clk_i) (t4_wb_cyc_o) |-> ($stable(t4_wb_dat_o) throughout (t4_wb_ack_i[->1]));
	endproperty
	assert property(af_p3175);

	property af_p3176;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ((t4_wb_dat_o >= 0) && (t4_wb_dat_o <= 255))[*4];
	endproperty
	assert property(af_p3176);

	property af_p3177;
	@(posedge wb_clk_i) (wb_rst_i) |-> ##1 (t4_wb_dat_o == 0);
	endproperty
	assert property(af_p3177);

	property af_p3178;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(t4_wb_dat_o);
	endproperty
	assert property(af_p3178);

	property af_p3179;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_stb_o) |-> (!$isunknown(t4_wb_dat_o));
	endproperty
	assert property(af_p3179);

	property af_p3180;
	@(posedge wb_clk_i) (!t4_wb_we_o && t4_wb_ack_i) |-> (!$isunknown(t4_wb_dat_o));
	endproperty
	assert property(af_p3180);

	property af_p3181;
	@(posedge wb_clk_i) (t4_wb_cyc_o) |-> ##[0:3] (!$isunknown(t4_wb_dat_o));
	endproperty
	assert property(af_p3181);

	property af_p3182;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:3] ((t4_wb_dat_o >= 0) && (t4_wb_dat_o <= 255));
	endproperty
	assert property(af_p3182);

	property af_p3183;
	@(posedge wb_clk_i) (t4_wb_stb_o && !t4_wb_ack_i) |=> ($stable(t4_wb_dat_o));
	endproperty
	assert property(af_p3183);

	property af_p3184;
	@(posedge wb_clk_i) (t4_wb_ack_i) |-> ((t4_wb_dat_o >= 0) && (t4_wb_dat_o <= 255));
	endproperty
	assert property(af_p3184);

	property af_p3185;
	@(posedge wb_clk_i) (!t4_wb_cyc_o) |=> ($stable(t4_wb_dat_o));
	endproperty
	assert property(af_p3185);

	property af_p3186;
	@(posedge wb_clk_i) (t4_wb_ack_i && t4_wb_stb_o) |-> (t4_wb_dat_o == t4_wb_dat_i);
	endproperty
	assert property(af_p3186);

	property af_p3187;
	@(posedge wb_clk_i) $changed(t4_wb_dat_o) |-> (t4_wb_cyc_o && t4_wb_stb_o);
	endproperty
	assert property(af_p3187);

	property af_p3188;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t4_wb_dat_o == 0);
	endproperty
	assert property(af_p3188);

	property af_p3189;
	@(posedge wb_clk_i) (t4_wb_we_o) |-> ($stable(t4_wb_dat_o));
	endproperty
	assert property(af_p3189);

	property af_p3190;
	@(posedge wb_clk_i) t4_wb_err_i |=> (t4_wb_dat_o == $past(t4_wb_dat_o));
	endproperty
	assert property(af_p3190);

	property af_p3191;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] ((t4_wb_dat_o >= 0) && (t4_wb_dat_o <= 255));
	endproperty
	assert property(af_p3191);

	property af_p3192;
	@(posedge wb_clk_i) (t4_wb_err_i) |-> (1'b1);
	endproperty
	assert property(af_p3192);

	property af_p3193;
	@(posedge wb_clk_i) ((t4_wb_dat_o >= 138) && (t4_wb_dat_o <= 153) && t4_wb_we_o) |=> ((t4_wb_dat_o >= 98) && (t4_wb_dat_o <= 153));
	endproperty
	assert property(af_p3193);

	property af_p3194;
	@(posedge wb_clk_i) t4_wb_err_i |=> (!t4_wb_cyc_o);
	endproperty
	assert property(af_p3194);

	property af_p3195;
	@(posedge wb_clk_i) wb_rst_i |-> (!t4_wb_err_i);
	endproperty
	assert property(af_p3195);

	property af_p3196;
	@(posedge wb_clk_i) t4_wb_err_i |=> ($stable(t4_wb_adr_o) until t4_wb_cyc_o);
	endproperty
	assert property(af_p3196);

	property af_p3197;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (!t4_wb_err_i);
	endproperty
	assert property(af_p3197);

	property af_p3198;
	@(posedge wb_clk_i) (t4_wb_err_i && t4_wb_stb_o && t4_wb_cyc_o) |=> (!t4_wb_cyc_o);
	endproperty
	assert property(af_p3198);

	property af_p3199;
	@(posedge wb_clk_i) t4_wb_err_i |-> (!t4_wb_ack_i);
	endproperty
	assert property(af_p3199);

	property af_p3200;
	@(posedge wb_clk_i) (t4_wb_we_o === t4_wb_we_o) |-> !(t4_wb_err_i && t4_wb_ack_i);
	endproperty
	assert property(af_p3200);

	property af_p3201;
	@(posedge wb_clk_i) (!t4_wb_cyc_o) |-> (!t4_wb_err_i);
	endproperty
	assert property(af_p3201);

	property af_p3202;
	@(posedge wb_clk_i) t4_wb_err_i |-> (t4_wb_cyc_o && t4_wb_stb_o);
	endproperty
	assert property(af_p3202);

	property af_p3203;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t4_wb_err_i[*2];
	endproperty
	assert property(af_p3203);

	property af_p3204;
	@(posedge wb_clk_i) $rose(t4_wb_err_i) |=> !t4_wb_cyc_o;
	endproperty
	assert property(af_p3204);

	property af_p3205;
	@(posedge wb_clk_i) wb_rst_i |-> !t4_wb_err_i;
	endproperty
	assert property(af_p3205);

	property af_p3206;
	@(posedge wb_clk_i) $rose(t4_wb_err_i) |=> !t4_wb_err_i[*4];
	endproperty
	assert property(af_p3206);

	property af_p3207;
	@(posedge wb_clk_i) $fell(t4_wb_cyc_o) |=> !t4_wb_err_i;
	endproperty
	assert property(af_p3207);

	property af_p3208;
	@(posedge wb_clk_i) !t4_wb_stb_o |-> !t4_wb_err_i;
	endproperty
	assert property(af_p3208);

	property af_p3209;
	@(posedge wb_clk_i) !(t4_wb_err_i && t4_wb_ack_i);
	endproperty
	assert property(af_p3209);

	property af_p3210;
	@(posedge wb_clk_i) $rose(t4_wb_err_i) |=> !t4_wb_stb_o;
	endproperty
	assert property(af_p3210);

	property af_p3211;
	@(posedge wb_clk_i) (t4_wb_we_o && t4_wb_err_i) |-> !t4_wb_ack_i;
	endproperty
	assert property(af_p3211);

	property af_p3212;
	@(posedge wb_clk_i) (!t4_wb_stb_o) |-> (!t4_wb_err_i);
	endproperty
	assert property(af_p3212);

	property af_p3213;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!t4_wb_err_i)[*2];
	endproperty
	assert property(af_p3213);

	property af_p3214;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_err_i) |-> !(t4_wb_cyc_o && $past(t4_wb_err_i) && t4_wb_err_i);
	endproperty
	assert property(af_p3214);

	property af_p3215;
	@(posedge wb_clk_i) (t4_wb_err_i) |=> !(t4_wb_err_i);
	endproperty
	assert property(af_p3215);

	property af_p3216;
	@(posedge wb_clk_i) ($changed(t4_wb_err_i)) |-> (t4_wb_stb_o);
	endproperty
	assert property(af_p3216);

	property af_p3217;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!t4_wb_err_i)[*3];
	endproperty
	assert property(af_p3217);

	property af_p3218;
	@(posedge wb_clk_i) (t4_wb_err_i) |-> !(t4_wb_ack_i);
	endproperty
	assert property(af_p3218);

	property af_p3219;
	@(posedge wb_clk_i) (t4_wb_err_i) |-> (t4_wb_cyc_o && t4_wb_stb_o);
	endproperty
	assert property(af_p3219);

	property af_p3220;
	@(posedge wb_clk_i) (t4_wb_err_i) |-> (t4_wb_dat_i === t4_wb_dat_i);
	endproperty
	assert property(af_p3220);

	property af_p3221;
	@(posedge wb_clk_i) (t4_wb_stb_o && !t4_wb_ack_i) |-> $stable(t4_wb_sel_o);
	endproperty
	assert property(af_p3221);

	property af_p3222;
	@(posedge wb_clk_i) ((t4_wb_sel_o >= 1) && (t4_wb_sel_o <= 15)) |-> ##1 ((t4_wb_sel_o >= 0) && (t4_wb_sel_o <= 15));
	endproperty
	assert property(af_p3222);

	property af_p3223;
	@(posedge wb_clk_i) (t4_wb_we_o) |-> (t4_wb_sel_o >= 1) && (t4_wb_sel_o <= 15);
	endproperty
	assert property(af_p3223);

	property af_p3224;
	@(posedge wb_clk_i) (!t4_wb_cyc_o) |-> $stable(t4_wb_sel_o);
	endproperty
	assert property(af_p3224);

	property af_p3225;
	@(posedge wb_clk_i) ((t4_wb_we_o) && (t4_wb_sel_o >= 1) && (t4_wb_sel_o <= 15)) |-> (t4_wb_sel_o === $past(t4_wb_sel_o)) until (t4_wb_ack_i);
	endproperty
	assert property(af_p3225);

	property af_p3226;
	@(posedge wb_clk_i) (t4_wb_sel_o >= 0) && (t4_wb_sel_o <= 15);
	endproperty
	assert property(af_p3226);

	property af_p3227;
	@(posedge wb_clk_i) (t4_wb_stb_o) |-> (t4_wb_sel_o != 4'b0000);
	endproperty
	assert property(af_p3227);

	property af_p3228;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t4_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p3228);

	property af_p3229;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_stb_o) |-> (t4_wb_sel_o != 4'b0000);
	endproperty
	assert property(af_p3229);

	property af_p3230;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_stb_o) |-> (t4_wb_sel_o === $past(t4_wb_sel_o)) until (t4_wb_ack_i);
	endproperty
	assert property(af_p3230);

	property af_p3231;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ((t4_wb_sel_o >= 0) && (t4_wb_sel_o <= 15))[*3];
	endproperty
	assert property(af_p3231);

	property af_p3232;
	@(posedge wb_clk_i) ((t4_wb_sel_o >= 4'h4) && (t4_wb_sel_o <= 4'hF)) |-> ($fell(t4_wb_cyc_o) |-> ((t4_wb_sel_o >= 4'h0) && (t4_wb_sel_o <= 4'hF)));
	endproperty
	assert property(af_p3232);

	property af_p3233;
	@(posedge wb_clk_i) $fell(t4_wb_cyc_o) |=> $changed(t4_wb_sel_o);
	endproperty
	assert property(af_p3233);

	property af_p3234;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(t4_wb_sel_o);
	endproperty
	assert property(af_p3234);

	property af_p3235;
	@(posedge wb_clk_i) $changed(t4_wb_sel_o) |-> !t4_wb_stb_o;
	endproperty
	assert property(af_p3235);

	property af_p3236;
	@(posedge wb_clk_i) ((t4_wb_sel_o >= 4'h0) && (t4_wb_sel_o <= 4'hF)) |=> (t4_wb_sel_o >= 4'h0) && (t4_wb_sel_o <= 4'hF);
	endproperty
	assert property(af_p3236);

	property af_p3237;
	@(posedge wb_clk_i) $rose(t4_wb_ack_i) |=> $stable(t4_wb_sel_o);
	endproperty
	assert property(af_p3237);

	property af_p3238;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((t4_wb_sel_o >= 4'h0) && (t4_wb_sel_o <= 4'hF));
	endproperty
	assert property(af_p3238);

	property af_p3239;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t4_wb_sel_o >= 4'h0) && (t4_wb_sel_o <= 4'hF));
	endproperty
	assert property(af_p3239);

	property af_p3240;
	@(posedge wb_clk_i) $stable(t4_wb_sel_o) || $changed(t4_wb_sel_o) |-> $stable(t4_wb_sel_o, @(posedge wb_clk_i));
	endproperty
	assert property(af_p3240);

	property af_p3241;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> ((t4_wb_sel_o >= 4'h0) && (t4_wb_sel_o <= 4'hF));
	endproperty
	assert property(af_p3241);

	property af_p3242;
	@(posedge wb_clk_i) (!t4_wb_cyc_o && !t4_wb_stb_o) |-> (t4_wb_sel_o == 4'h0);
	endproperty
	assert property(af_p3242);

	property af_p3243;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t4_wb_sel_o == 4'h0);
	endproperty
	assert property(af_p3243);

	property af_p3244;
	@(posedge wb_clk_i) (t4_wb_we_o) |-> (t4_wb_sel_o >= 4'h1) && (t4_wb_sel_o <= 4'hF);
	endproperty
	assert property(af_p3244);

	property af_p3245;
	@(posedge wb_clk_i) (wb_rst_i) |-> ##1 (t4_wb_sel_o == 4'h0);
	endproperty
	assert property(af_p3245);

	property af_p3246;
	@(posedge wb_clk_i) (t4_wb_err_i && t4_wb_cyc_o) |-> (t4_wb_sel_o == $past(t4_wb_sel_o));
	endproperty
	assert property(af_p3246);

	property af_p3247;
	@(posedge wb_clk_i) ($past(wb_rst_i,4) && !wb_rst_i) |-> (t4_wb_sel_o >= 4'h0) && (t4_wb_sel_o <= 4'hF);
	endproperty
	assert property(af_p3247);

	property af_p3248;
	@(posedge wb_clk_i) (t4_wb_stb_o) |-> (t4_wb_sel_o == t4_wb_adr_o[3:0]);
	endproperty
	assert property(af_p3248);

	property af_p3249;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t4_wb_sel_o >= 4'h0) && (t4_wb_sel_o <= 4'hF);
	endproperty
	assert property(af_p3249);

	property af_p3250;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_stb_o && !t4_wb_ack_i) |-> (t4_wb_sel_o == $past(t4_wb_sel_o));
	endproperty
	assert property(af_p3250);

	property af_p3251;
	@(posedge wb_clk_i) (t4_wb_cyc_o) |-> (t4_wb_sel_o == $past(t4_wb_sel_o));
	endproperty
	assert property(af_p3251);

	property af_p3252;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t4_wb_stb_o ##1 !t4_wb_stb_o;
	endproperty
	assert property(af_p3252);

	property af_p3253;
	@(posedge wb_clk_i) $rose(t4_wb_err_i) |=> !t4_wb_stb_o;
	endproperty
	assert property(af_p3253);

	property af_p3254;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> !t4_wb_stb_o;
	endproperty
	assert property(af_p3254);

	property af_p3255;
	@(posedge wb_clk_i) t4_wb_stb_o |-> $past(t4_wb_cyc_o,1);
	endproperty
	assert property(af_p3255);

	property af_p3256;
	@(posedge wb_clk_i) t4_wb_ack_i |-> (!t4_wb_stb_o && !t4_wb_cyc_o);
	endproperty
	assert property(af_p3256);

	property af_p3257;
	@(posedge wb_clk_i) wb_rst_i |-> !t4_wb_stb_o;
	endproperty
	assert property(af_p3257);

	property af_p3258;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> !t4_wb_stb_o ##1 !t4_wb_stb_o;
	endproperty
	assert property(af_p3258);

	property af_p3259;
	@(posedge wb_clk_i) (t4_wb_stb_o && !t4_wb_ack_i) |-> t4_wb_stb_o throughout (!t4_wb_ack_i)[*1:$] ##1 t4_wb_ack_i;
	endproperty
	assert property(af_p3259);

	property af_p3260;
	@(posedge wb_clk_i) t4_wb_stb_o |-> !wb_rst_i;
	endproperty
	assert property(af_p3260);

	property af_p3261;
	@(posedge wb_clk_i) wb_rst_i |-> $stable(t4_wb_stb_o);
	endproperty
	assert property(af_p3261);

	property af_p3262;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 $isunknown(t4_wb_stb_o) == 0;
	endproperty
	assert property(af_p3262);

	property af_p3263;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> !t4_wb_stb_o;
	endproperty
	assert property(af_p3263);

	property af_p3264;
	@(posedge wb_clk_i) $fell(t4_wb_stb_o) |=> !t4_wb_stb_o;
	endproperty
	assert property(af_p3264);

	property af_p3265;
	@(posedge wb_clk_i) $rose(t4_wb_ack_i) |=> !t4_wb_stb_o;
	endproperty
	assert property(af_p3265);

	property af_p3266;
	@(posedge wb_clk_i) (t4_wb_stb_o && t4_wb_ack_i) |=> !t4_wb_stb_o;
	endproperty
	assert property(af_p3266);

	property af_p3267;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t4_wb_stb_o;
	endproperty
	assert property(af_p3267);

	property af_p3268;
	@(posedge wb_clk_i) t4_wb_stb_o |-> t4_wb_we_o;
	endproperty
	assert property(af_p3268);

	property af_p3269;
	@(posedge wb_clk_i) t4_wb_err_i |=> !t4_wb_stb_o;
	endproperty
	assert property(af_p3269);

	property af_p3270;
	@(posedge wb_clk_i) t4_wb_stb_o |-> (t4_wb_sel_o !== '0);
	endproperty
	assert property(af_p3270);

	property af_p3271;
	@(posedge wb_clk_i) t4_wb_stb_o |-> (t4_wb_stb_o throughout (!(t4_wb_ack_i || t4_wb_err_i))[*0:$] ##1 (t4_wb_ack_i || t4_wb_err_i));
	endproperty
	assert property(af_p3271);

	property af_p3272;
	@(posedge wb_clk_i) t4_wb_ack_i |=> !t4_wb_stb_o;
	endproperty
	assert property(af_p3272);

	property af_p3273;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!t4_wb_stb_o ##1 !t4_wb_stb_o);
	endproperty
	assert property(af_p3273);

	property af_p3274;
	@(posedge wb_clk_i) $changed(t4_wb_adr_o) |-> (!$past(t4_wb_stb_o) || $past(t4_wb_ack_i));
	endproperty
	assert property(af_p3274);

	property af_p3275;
	@(posedge wb_clk_i) t4_wb_stb_o |-> t4_wb_cyc_o;
	endproperty
	assert property(af_p3275);

	property af_p3276;
	@(posedge wb_clk_i) $stable(t4_wb_stb_o) or ($rose(t4_wb_stb_o) || $fell(t4_wb_stb_o));
	endproperty
	assert property(af_p3276);

	property af_p3277;
	@(posedge wb_clk_i) t4_wb_stb_o |-> $stable(t4_wb_adr_o);
	endproperty
	assert property(af_p3277);

	property af_p3278;
	@(posedge wb_clk_i) (t4_wb_stb_o && t4_wb_we_o) |-> $stable(t4_wb_dat_o);
	endproperty
	assert property(af_p3278);

	property af_p3279;
	@(posedge wb_clk_i) $rose(t4_wb_cyc_o) |-> ##[0:3] t4_wb_stb_o;
	endproperty
	assert property(af_p3279);

	property af_p3280;
	@(posedge wb_clk_i) (t4_wb_stb_o && !t4_wb_ack_i) |=> t4_wb_stb_o;
	endproperty
	assert property(af_p3280);

	property af_p3281;
	@(posedge wb_clk_i) t4_wb_stb_o |-> $stable(t4_wb_we_o);
	endproperty
	assert property(af_p3281);

	property af_p3282;
	@(posedge wb_clk_i) wb_rst_i |=> !t4_wb_stb_o;
	endproperty
	assert property(af_p3282);

	property af_p3283;
	@(posedge wb_clk_i) t4_wb_stb_o |-> $stable(t4_wb_adr_o) throughout (t4_wb_ack_i || t4_wb_err_i)[->1];
	endproperty
	assert property(af_p3283);

	property af_p3284;
	@(posedge wb_clk_i) $rose(t4_wb_stb_o) |-> ##[1:16] (t4_wb_ack_i || t4_wb_err_i);
	endproperty
	assert property(af_p3284);

	property af_p3285;
	@(posedge wb_clk_i) $rose(t4_wb_cyc_o) |=> $stable(t4_wb_stb_o) throughout t4_wb_ack_i[->1];
	endproperty
	assert property(af_p3285);

	property af_p3286;
	@(posedge wb_clk_i) (wb_rst_i) |=> !$isunknown(t4_wb_we_o);
	endproperty
	assert property(af_p3286);

	property af_p3287;
	@(posedge wb_clk_i) (t4_wb_cyc_o && !t4_wb_ack_i) |-> $stable(t4_wb_we_o);
	endproperty
	assert property(af_p3287);

	property af_p3288;
	@(posedge wb_clk_i) $changed(t4_wb_we_o) |-> $rose(wb_clk_i);
	endproperty
	assert property(af_p3288);

	property af_p3289;
	@(posedge wb_clk_i) (!t4_wb_cyc_o) |-> $stable(t4_wb_we_o);
	endproperty
	assert property(af_p3289);

	property af_p3290;
	@(posedge wb_clk_i) (!t4_wb_cyc_o) |-> (t4_wb_we_o == 1'b0);
	endproperty
	assert property(af_p3290);

	property af_p3291;
	@(posedge wb_clk_i) (t4_wb_we_o) |-> !$isunknown(t4_wb_dat_o);
	endproperty
	assert property(af_p3291);

	property af_p3292;
	@(posedge wb_clk_i) (t4_wb_we_o) |-> (t4_wb_cyc_o && t4_wb_stb_o);
	endproperty
	assert property(af_p3292);

	property af_p3293;
	@(posedge wb_clk_i) (t4_wb_err_i) |-> (!t4_wb_we_o) or (##1 !t4_wb_we_o);
	endproperty
	assert property(af_p3293);

	property af_p3294;
	@(posedge wb_clk_i) t4_wb_we_o |-> (t4_wb_we_o throughout ((!t4_wb_ack_i)[*0:$] ##1 t4_wb_ack_i));
	endproperty
	assert property(af_p3294);

	property af_p3295;
	@(posedge wb_clk_i) (t4_wb_stb_o && !t4_wb_ack_i) |-> $stable(t4_wb_we_o);
	endproperty
	assert property(af_p3295);

	property af_p3296;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t4_wb_we_o;
	endproperty
	assert property(af_p3296);

	property af_p3297;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_stb_o) |-> (t4_wb_we_o === 1'b1 || t4_wb_we_o === 1'b0);
	endproperty
	assert property(af_p3297);

	property af_p3298;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!t4_wb_we_o)[*2];
	endproperty
	assert property(af_p3298);

	property af_p3299;
	@(posedge wb_clk_i) (t4_wb_cyc_o && t4_wb_stb_o) |-> ($stable(t4_wb_we_o) throughout ((!t4_wb_ack_i)[*0:$] ##1 t4_wb_ack_i));
	endproperty
	assert property(af_p3299);

	property af_p3300;
	@(posedge wb_clk_i) t4_wb_ack_i |=> !t4_wb_we_o;
	endproperty
	assert property(af_p3300);

	property af_p3301;
	@(posedge wb_clk_i) (i0_wb_cyc_i && t4_wb_cyc_o) |-> (t4_wb_we_o == i0_wb_we_i);
	endproperty
	assert property(af_p3301);

	property af_p3302;
	@(posedge wb_clk_i) !t4_wb_cyc_o |-> !t4_wb_we_o;
	endproperty
	assert property(af_p3302);

	property af_p3303;
	@(posedge wb_clk_i) wb_rst_i |-> !t4_wb_we_o;
	endproperty
	assert property(af_p3303);

	property af_p3304;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> !t4_wb_we_o[*2];
	endproperty
	assert property(af_p3304);

	property af_p3305;
	@(posedge wb_clk_i) t4_wb_we_o |-> (t4_wb_cyc_o && t4_wb_stb_o);
	endproperty
	assert property(af_p3305);

	property af_p3306;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> !t4_wb_we_o;
	endproperty
	assert property(af_p3306);

	property af_p3307;
	@(posedge wb_clk_i) (t4_wb_we_o && t4_wb_err_i) |=> !t4_wb_we_o;
	endproperty
	assert property(af_p3307);

	property af_p3308;
	@(posedge wb_clk_i) t4_wb_stb_o |=> $stable(t4_wb_we_o);
	endproperty
	assert property(af_p3308);

	property af_p3309;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t4_wb_we_o[*3];
	endproperty
	assert property(af_p3309);

	property af_p3310;
	@(posedge wb_clk_i) (t4_wb_we_o && t4_wb_stb_o) |=> ($stable(t4_wb_we_o) until t4_wb_ack_i);
	endproperty
	assert property(af_p3310);

	property af_p3311;
	@(posedge wb_clk_i) t4_wb_cyc_o |-> $stable(t4_wb_we_o);
	endproperty
	assert property(af_p3311);

	property af_p3312;
	@(posedge wb_clk_i) !(t5_wb_ack_i && t5_wb_err_i);
	endproperty
	assert property(af_p3312);

	property af_p3313;
	@(posedge wb_clk_i) (t5_wb_ack_i && !t5_wb_stb_o) |=> (!t5_wb_ack_i);
	endproperty
	assert property(af_p3313);

	property af_p3314;
	@(posedge wb_clk_i) (t5_wb_ack_i) |-> (!$isunknown(t5_wb_dat_i));
	endproperty
	assert property(af_p3314);

	property af_p3315;
	@(posedge wb_clk_i) (t5_wb_ack_i) |-> ($past(t5_wb_stb_o && t5_wb_cyc_o));
	endproperty
	assert property(af_p3315);

	property af_p3316;
	@(posedge wb_clk_i) (t5_wb_ack_i) |-> (!$isunknown(t5_wb_sel_o));
	endproperty
	assert property(af_p3316);

	property af_p3317;
	@(posedge wb_clk_i) (wb_rst_i) |-> !t5_wb_ack_i;
	endproperty
	assert property(af_p3317);

	property af_p3318;
	@(posedge wb_clk_i) (t5_wb_stb_o && t5_wb_ack_i) |=> (!t5_wb_ack_i);
	endproperty
	assert property(af_p3318);

	property af_p3319;
	@(posedge wb_clk_i) (t5_wb_we_o && t5_wb_ack_i) |-> (!$isunknown(t5_wb_dat_o));
	endproperty
	assert property(af_p3319);

	property af_p3320;
	@(posedge wb_clk_i) wb_rst_i |-> !t5_wb_ack_i;
	endproperty
	assert property(af_p3320);

	property af_p3321;
	@(posedge wb_clk_i) (!t5_wb_we_o && t5_wb_ack_i) |-> !$isunknown(t5_wb_dat_i);
	endproperty
	assert property(af_p3321);

	property af_p3322;
	@(posedge wb_clk_i) $fell(t5_wb_stb_o) |=> !t5_wb_ack_i;
	endproperty
	assert property(af_p3322);

	property af_p3323;
	@(posedge wb_clk_i) t5_wb_ack_i |-> $stable(t5_wb_adr_o);
	endproperty
	assert property(af_p3323);

	property af_p3324;
	@(posedge wb_clk_i) t5_wb_ack_i |-> !t5_wb_err_i;
	endproperty
	assert property(af_p3324);

	property af_p3325;
	@(posedge wb_clk_i) t5_wb_ack_i |-> (t5_wb_stb_o && t5_wb_cyc_o);
	endproperty
	assert property(af_p3325);

	property af_p3326;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> !t5_wb_ack_i;
	endproperty
	assert property(af_p3326);

	property af_p3327;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!t5_wb_ack_i throughout (!(t5_wb_stb_o && t5_wb_cyc_o))[*0:$]);
	endproperty
	assert property(af_p3327);

	property af_p3328;
	@(posedge wb_clk_i) (t5_wb_ack_i && t5_wb_we_o) |-> (t5_wb_we_o);
	endproperty
	assert property(af_p3328);

	property af_p3329;
	@(posedge wb_clk_i) (t5_wb_ack_i) |-> (t5_wb_cyc_o);
	endproperty
	assert property(af_p3329);

	property af_p3330;
	@(posedge wb_clk_i) (t5_wb_ack_i) |-> ##[1:3] (!t5_wb_cyc_o);
	endproperty
	assert property(af_p3330);

	property af_p3331;
	@(posedge wb_clk_i) (t5_wb_ack_i) |=> (!t5_wb_ack_i) or (t5_wb_stb_o);
	endproperty
	assert property(af_p3331);

	property af_p3332;
	@(posedge wb_clk_i) (t5_wb_ack_i && !t5_wb_cyc_o) |=> (!t5_wb_ack_i);
	endproperty
	assert property(af_p3332);

	property af_p3333;
	@(posedge wb_clk_i) (t5_wb_cyc_o && $stable(t5_wb_we_o)) |-> $stable(t5_wb_adr_o);
	endproperty
	assert property(af_p3333);

	property af_p3334;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t5_wb_adr_o == '0);
	endproperty
	assert property(af_p3334);

	property af_p3335;
	@(posedge wb_clk_i) (!t5_wb_stb_o) |-> (t5_wb_adr_o == $past(t5_wb_adr_o) || !$stable(t5_wb_stb_o));
	endproperty
	assert property(af_p3335);

	property af_p3336;
	@(posedge wb_clk_i) (t5_wb_adr_o != $past(t5_wb_adr_o)) |-> $past(t5_wb_stb_o);
	endproperty
	assert property(af_p3336);

	property af_p3337;
	@(posedge wb_clk_i) (wb_rst_i) |-> ##1 (t5_wb_adr_o == '0);
	endproperty
	assert property(af_p3337);


	property af_p3339;
	@(posedge wb_clk_i) (!t5_wb_cyc_o) |-> (t5_wb_adr_o == $past(t5_wb_adr_o));
	endproperty
	assert property(af_p3339);

	property af_p3340;
	@(posedge wb_clk_i) (t5_wb_stb_o && t5_wb_cyc_o) |-> (t5_wb_adr_o == $past(t5_wb_adr_o)) throughout (t5_wb_stb_o && t5_wb_cyc_o)[->1] ##0 !t5_wb_ack_i[*0:$] ##1 t5_wb_ack_i;
	endproperty
	assert property(af_p3340);


	property af_p3342;
	@(posedge wb_clk_i) (t5_wb_we_o) |-> (t5_wb_adr_o == t5_wb_adr_o);
	endproperty
	assert property(af_p3342);

	property af_p3343;
	@(posedge wb_clk_i) (t5_wb_cyc_o && t5_wb_stb_o && !t5_wb_ack_i) |=> (t5_wb_ack_i || $stable(t5_wb_adr_o));
	endproperty
	assert property(af_p3343);

	property af_p3344;
	@(posedge wb_clk_i) $rose(t5_wb_stb_o) |-> (t5_wb_ack_i || $stable(t5_wb_adr_o));
	endproperty
	assert property(af_p3344);

	property af_p3345;
	@(posedge wb_clk_i) (t5_wb_cyc_o && !t5_wb_ack_i) |=> (t5_wb_ack_i || $stable(t5_wb_adr_o));
	endproperty
	assert property(af_p3345);

	property af_p3346;
	@(posedge wb_clk_i) (t5_wb_stb_o) |-> $stable(t5_wb_adr_o);
	endproperty
	assert property(af_p3346);

	property af_p3347;
	@(posedge wb_clk_i) $rose(t5_wb_err_i) |-> (t5_wb_adr_o == $past(t5_wb_adr_o)) throughout (!t5_wb_cyc_o)[->1];
	endproperty
	assert property(af_p3347);

	property af_p3348;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(t5_wb_adr_o) && !$isunknown(t5_wb_adr_o);
	endproperty
	assert property(af_p3348);

	property af_p3349;
	@(posedge wb_clk_i) (t5_wb_ack_i) |=> (1'b1);
	endproperty
	assert property(af_p3349);

	property af_p3350;
	@(posedge wb_clk_i) $changed(t5_wb_adr_o) |-> $rose(wb_clk_i);
	endproperty
	assert property(af_p3350);

	property af_p3351;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> t5_wb_adr_o inside {[0:$]} [*2];
	endproperty
	assert property(af_p3351);

	property af_p3352;
	@(posedge wb_clk_i) (t5_wb_we_o && t5_wb_stb_o && !t5_wb_ack_i && !t5_wb_err_i) |=> ((t5_wb_ack_i || t5_wb_err_i) || $stable(t5_wb_adr_o));
	endproperty
	assert property(af_p3352);

	property af_p3353;
	@(posedge wb_clk_i) (!t5_wb_cyc_o) |=> (1'b1);
	endproperty
	assert property(af_p3353);

	property af_p3354;
	@(posedge wb_clk_i) ($fell(t5_wb_stb_o)) |=> ($stable(t5_wb_adr_o));
	endproperty
	assert property(af_p3354);

	property af_p3355;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (t5_wb_adr_o == '0);
	endproperty
	assert property(af_p3355);

	property af_p3356;
	@(posedge wb_clk_i) (!t5_wb_cyc_o) |-> (1'b1);
	endproperty
	assert property(af_p3356);

	property af_p3357;
	@(posedge wb_clk_i) (t5_wb_ack_i) |-> ($stable(t5_wb_adr_o));
	endproperty
	assert property(af_p3357);

	property af_p3358;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (t5_wb_adr_o == '0) ##1 (t5_wb_adr_o == '0);
	endproperty
	assert property(af_p3358);

	property af_p3359;
	@(posedge wb_clk_i) (t5_wb_err_i) |=> ($stable(t5_wb_adr_o));
	endproperty
	assert property(af_p3359);

	property af_p3360;
	@(posedge wb_clk_i) (t5_wb_cyc_o && !t5_wb_ack_i) |=> ($stable(t5_wb_adr_o));
	endproperty
	assert property(af_p3360);

	property af_p3361;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (!$isunknown(t5_wb_adr_o));
	endproperty
	assert property(af_p3361);

	property af_p3362;
	@(posedge wb_clk_i) (!t5_wb_stb_o) |=> ($stable(t5_wb_adr_o));
	endproperty
	assert property(af_p3362);

	property af_p3363;
	@(posedge wb_clk_i) $fell(t5_wb_cyc_o) |=> !t5_wb_cyc_o;
	endproperty
	assert property(af_p3363);

	property af_p3364;
	@(posedge wb_clk_i) $rose(t5_wb_cyc_o) |-> (!wb_rst_i && $past(!wb_rst_i,1));
	endproperty
	assert property(af_p3364);

	property af_p3365;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t5_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p3365);

	property af_p3366;
	@(posedge wb_clk_i) $rose(t5_wb_cyc_o) |-> (t5_wb_cyc_o until_with t5_wb_ack_i);
	endproperty
	assert property(af_p3366);

	property af_p3367;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t5_wb_cyc_o [*2];
	endproperty
	assert property(af_p3367);

	property af_p3368;
	@(posedge wb_clk_i) $rose(t5_wb_cyc_o) |-> $rose(t5_wb_stb_o);
	endproperty
	assert property(af_p3368);

	property af_p3369;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t5_wb_cyc_o)[*2];
	endproperty
	assert property(af_p3369);

	property af_p3370;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t5_wb_cyc_o);
	endproperty
	assert property(af_p3370);

	property af_p3371;
	@(posedge wb_clk_i) (t5_wb_err_i) |=> !t5_wb_cyc_o;
	endproperty
	assert property(af_p3371);

	property af_p3372;
	@(posedge wb_clk_i) (t5_wb_cyc_o) |-> (t5_wb_stb_o);
	endproperty
	assert property(af_p3372);

	property af_p3373;
	@(posedge wb_clk_i) (t5_wb_stb_o && $isunknown(t5_wb_adr_o) == 0) |-> t5_wb_cyc_o;
	endproperty
	assert property(af_p3373);

	property af_p3374;
	@(posedge wb_clk_i) $rose(t5_wb_cyc_o) |-> (t5_wb_adr_o === $past(t5_wb_adr_o)) throughout t5_wb_cyc_o[*1:$];
	endproperty
	assert property(af_p3374);

	property af_p3375;
	@(posedge wb_clk_i) ($rose(t5_wb_cyc_o) && t5_wb_we_o) |-> (t5_wb_cyc_o && t5_wb_we_o) throughout (t5_wb_cyc_o[->1] ##0 t5_wb_ack_i);
	endproperty
	assert property(af_p3375);

	property af_p3376;
	@(posedge wb_clk_i) (t5_wb_cyc_o && !t5_wb_ack_i) |=> t5_wb_cyc_o;
	endproperty
	assert property(af_p3376);

	property af_p3377;
	@(posedge wb_clk_i) (t5_wb_cyc_o && t5_wb_err_i) |=> !t5_wb_cyc_o;
	endproperty
	assert property(af_p3377);

	property af_p3378;
	@(posedge wb_clk_i) (t5_wb_cyc_o && t5_wb_ack_i) |=> !t5_wb_cyc_o;
	endproperty
	assert property(af_p3378);

	property af_p3379;
	@(posedge wb_clk_i) t5_wb_cyc_o |-> t5_wb_stb_o;
	endproperty
	assert property(af_p3379);

	property af_p3380;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t5_wb_dat_i >= 0) && (t5_wb_dat_i <= 255);
	endproperty
	assert property(af_p3380);

	property af_p3381;
	@(posedge wb_clk_i) (!t5_wb_we_o && t5_wb_stb_o) |-> ##[1:2] ((t5_wb_dat_i >= 0) && (t5_wb_dat_i <= 255));
	endproperty
	assert property(af_p3381);

	property af_p3382;
	@(posedge wb_clk_i) (t5_wb_cyc_o && t5_wb_stb_o) |-> (t5_wb_dat_i === t5_wb_dat_i);
	endproperty
	assert property(af_p3382);

	property af_p3383;
	@(posedge wb_clk_i) t5_wb_err_i |-> (1'b1);
	endproperty
	assert property(af_p3383);

	property af_p3384;
	@(posedge wb_clk_i) disable iff (!t5_wb_cyc_o || !t5_wb_stb_o) 1'b1 |-> (t5_wb_cyc_o && t5_wb_stb_o);
	endproperty
	assert property(af_p3384);

	property af_p3385;
	@(posedge wb_clk_i) ((t5_wb_dat_i >= 200) && (t5_wb_dat_i <= 255)) |=> (t5_wb_dat_i >= 180) && (t5_wb_dat_i <= 255);
	endproperty
	assert property(af_p3385);

	property af_p3386;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 ((t5_wb_dat_i >= 0) && (t5_wb_dat_i <= 63));
	endproperty
	assert property(af_p3386);

	property af_p3387;
	@(posedge wb_clk_i) (t5_wb_cyc_o && !t5_wb_ack_i) |=> $stable(t5_wb_dat_i);
	endproperty
	assert property(af_p3387);

	property af_p3388;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 ((t5_wb_dat_i >= 0) && (t5_wb_dat_i <= 255));
	endproperty
	assert property(af_p3388);

	property af_p3389;
	@(posedge wb_clk_i) t5_wb_stb_o |-> !$stable(t5_wb_dat_i) || $stable(t5_wb_dat_i);
	endproperty
	assert property(af_p3389);

	property af_p3390;
	@(posedge wb_clk_i) $fell(t5_wb_cyc_o) |=> $stable(t5_wb_dat_i);
	endproperty
	assert property(af_p3390);

	property af_p3391;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##1 (!$isunknown(t5_wb_dat_i));
	endproperty
	assert property(af_p3391);

	property af_p3392;
	@(posedge wb_clk_i) (t5_wb_stb_o && t5_wb_cyc_o && !t5_wb_ack_i) |=> ($stable(t5_wb_dat_i) || t5_wb_ack_i);
	endproperty
	assert property(af_p3392);

	property af_p3393;
	@(posedge wb_clk_i) ($rose(t5_wb_stb_o)) |-> ((t5_wb_dat_i >= 50) && (t5_wb_dat_i <= 200)) ##1 ($stable(t5_wb_dat_i) && (t5_wb_dat_i >= 50) && (t5_wb_dat_i <= 200));
	endproperty
	assert property(af_p3393);

	property af_p3394;
	@(posedge wb_clk_i) (!t5_wb_we_o && t5_wb_ack_i) |=> (!$isunknown(t5_wb_dat_i));
	endproperty
	assert property(af_p3394);

	property af_p3395;
	@(posedge wb_clk_i) ((t5_wb_dat_i >= 100) && (t5_wb_dat_i <= 150)) |=> ((t5_wb_dat_i >= 80) && (t5_wb_dat_i <= 170));
	endproperty
	assert property(af_p3395);

	property af_p3396;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ((t5_wb_dat_i >= 50) && (t5_wb_dat_i <= 200))[*6];
	endproperty
	assert property(af_p3396);

	property af_p3397;
	@(posedge wb_clk_i) (!t5_wb_we_o) |-> (t5_wb_dat_i >= 0) && (t5_wb_dat_i <= 255);
	endproperty
	assert property(af_p3397);

	property af_p3398;
	@(posedge wb_clk_i) (t5_wb_err_i) |-> 1'b1;
	endproperty
	assert property(af_p3398);

	property af_p3399;
	@(posedge wb_clk_i) ($rose(t5_wb_ack_i)) |=> ($stable(t5_wb_dat_i) && !$isunknown(t5_wb_dat_i));
	endproperty
	assert property(af_p3399);

	property af_p3400;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 (t5_wb_dat_i >= 0) && (t5_wb_dat_i <= 63);
	endproperty
	assert property(af_p3400);

	property af_p3401;
	@(posedge wb_clk_i) (t5_wb_cyc_o && t5_wb_stb_o) |=> (t5_wb_cyc_o && t5_wb_stb_o) ##0 (t5_wb_dat_i != $past(t5_wb_dat_i));
	endproperty
	assert property(af_p3401);

	property af_p3402;
	@(posedge wb_clk_i) (!t5_wb_ack_i) |-> $stable(t5_wb_dat_i);
	endproperty
	assert property(af_p3402);

	property af_p3403;
	@(posedge wb_clk_i) ((t5_wb_dat_i >= 100) && (t5_wb_dat_i <= 150)) |=> (t5_wb_dat_i >= 80) && (t5_wb_dat_i <= 170);
	endproperty
	assert property(af_p3403);

	property af_p3404;
	@(posedge wb_clk_i) ((t5_wb_dat_i >= 0) && (t5_wb_dat_i <= 15) && !t5_wb_ack_i) |-> ##[1:5] ((t5_wb_dat_i >= 16) && (t5_wb_dat_i <= 255));
	endproperty
	assert property(af_p3404);

	property af_p3405;
	@(posedge wb_clk_i) (t5_wb_ack_i) |-> (t5_wb_dat_i == t5_wb_adr_o);
	endproperty
	assert property(af_p3405);

	property af_p3406;
	@(posedge wb_clk_i) (wb_rst_i) |=> (t5_wb_dat_i == 0);
	endproperty
	assert property(af_p3406);

	property af_p3407;
	@(posedge wb_clk_i) $changed(t5_wb_adr_o) |=> (t5_wb_dat_i >= 0) && (t5_wb_dat_i <= 255);
	endproperty
	assert property(af_p3407);

	property af_p3408;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (t5_wb_dat_i >= 0) && (t5_wb_dat_i <= 255);
	endproperty
	assert property(af_p3408);

	property af_p3409;
	@(posedge wb_clk_i) (t5_wb_ack_i) |-> $stable(t5_wb_dat_i);
	endproperty
	assert property(af_p3409);

	property af_p3410;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(t5_wb_dat_i);
	endproperty
	assert property(af_p3410);

	property af_p3411;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ((t5_wb_dat_o >= 0) && (t5_wb_dat_o <= 255))[*4];
	endproperty
	assert property(af_p3411);

	property af_p3412;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t5_wb_dat_o >= 50) && (t5_wb_dat_o <= 200));
	endproperty
	assert property(af_p3412);

	property af_p3413;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (t5_wb_dat_o == 0)[*2];
	endproperty
	assert property(af_p3413);

	property af_p3414;
	@(posedge wb_clk_i) (t5_wb_stb_o && t5_wb_cyc_o) |=> $stable(t5_wb_dat_o);
	endproperty
	assert property(af_p3414);

	property af_p3415;
	@(posedge wb_clk_i) (t5_wb_ack_i && (t5_wb_dat_o >= 40) && (t5_wb_dat_o <= 90)) |=> ((t5_wb_dat_o >= 20) && (t5_wb_dat_o <= 110));
	endproperty
	assert property(af_p3415);

	property af_p3416;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((t5_wb_dat_o >= 0) && (t5_wb_dat_o <= 255));
	endproperty
	assert property(af_p3416);

	property af_p3417;
	@(posedge wb_clk_i) ((t5_wb_dat_o >= 200) && (t5_wb_dat_o <= 255)) |=> ((t5_wb_dat_o >= 180) && (t5_wb_dat_o <= 255));
	endproperty
	assert property(af_p3417);

	property af_p3418;
	@(posedge wb_clk_i) (((t5_wb_dat_o >= 0) && (t5_wb_dat_o <= 127)) ##1 ((t5_wb_dat_o >= 128) && (t5_wb_dat_o <= 255))) |-> $past(t5_wb_ack_i);
	endproperty
	assert property(af_p3418);


	property af_p3420;
	@(posedge wb_clk_i) (t5_wb_ack_i) |-> $stable(t5_wb_dat_o);
	endproperty
	assert property(af_p3420);

	property af_p3421;
	@(posedge wb_clk_i) (t5_wb_stb_o && !t5_wb_we_o) |=> ((t5_wb_dat_o >= 0) && (t5_wb_dat_o <= 255));
	endproperty
	assert property(af_p3421);

	property af_p3422;
	@(posedge wb_clk_i) (t5_wb_we_o) |=> $stable(t5_wb_dat_o);
	endproperty
	assert property(af_p3422);

	property af_p3423;
	@(posedge wb_clk_i) ($rose(!wb_rst_i)) |-> ##4 (t5_wb_dat_o >= 0) && (t5_wb_dat_o <= 60);
	endproperty
	assert property(af_p3423);

	property af_p3424;
	@(posedge wb_clk_i) ($rose(!wb_rst_i)) |-> ##3 (t5_wb_dat_o >= 0) && (t5_wb_dat_o <= 255);
	endproperty
	assert property(af_p3424);

	property af_p3425;
	@(posedge wb_clk_i) (wb_rst_i || $past(wb_rst_i,1) || $past(wb_rst_i,2)) |-> (t5_wb_dat_o == 0);
	endproperty
	assert property(af_p3425);

	property af_p3426;
	@(posedge wb_clk_i) !(t5_wb_stb_o && t5_wb_cyc_o && t5_wb_ack_i) |=> $stable(t5_wb_dat_o);
	endproperty
	assert property(af_p3426);

	property af_p3427;
	@(posedge wb_clk_i) (t5_wb_stb_o) |=> ((t5_wb_dat_o >= 20) && (t5_wb_dat_o <= 235))[*5];
	endproperty
	assert property(af_p3427);

	property af_p3428;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> (t5_wb_dat_o == 0);
	endproperty
	assert property(af_p3428);

	property af_p3429;
	@(posedge wb_clk_i) ((t5_wb_dat_o >= 100) && (t5_wb_dat_o <= 150)) |=> ((t5_wb_dat_o >= 80) && (t5_wb_dat_o <= 170));
	endproperty
	assert property(af_p3429);

	property af_p3430;
	@(posedge wb_clk_i) (!t5_wb_cyc_o) |=> $stable(t5_wb_dat_o);
	endproperty
	assert property(af_p3430);

	property af_p3431;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t5_wb_dat_o >= 0) && (t5_wb_dat_o <= 255);
	endproperty
	assert property(af_p3431);

	property af_p3432;
	@(posedge wb_clk_i) (t5_wb_stb_o && t5_wb_cyc_o && !t5_wb_we_o && t5_wb_ack_i) |-> !$isunknown(t5_wb_dat_o);
	endproperty
	assert property(af_p3432);

	property af_p3433;
	@(posedge wb_clk_i) ((t5_wb_dat_o >= 100) && (t5_wb_dat_o <= 150)) |=> (t5_wb_dat_o >= 80) && (t5_wb_dat_o <= 150);
	endproperty
	assert property(af_p3433);

	property af_p3434;
	@(posedge wb_clk_i) (t5_wb_cyc_o && t5_wb_stb_o && !t5_wb_we_o && t5_wb_ack_i) |-> $stable(t5_wb_dat_o);
	endproperty
	assert property(af_p3434);

	property af_p3435;
	@(posedge wb_clk_i) (!(t5_wb_cyc_o && t5_wb_stb_o)) |=> $stable(t5_wb_dat_o);
	endproperty
	assert property(af_p3435);

	property af_p3436;
	@(posedge wb_clk_i) (!t5_wb_ack_i) |=> ($stable(t5_wb_dat_o) || $past(t5_wb_ack_i));
	endproperty
	assert property(af_p3436);


	property af_p3438;
	@(posedge wb_clk_i) disable iff (wb_rst_i) ($past(wb_rst_i,3) && !$past(wb_rst_i,2) && !$past(wb_rst_i,1) && !wb_rst_i) |-> (t5_wb_dat_o >= 0) && (t5_wb_dat_o <= 255);
	endproperty
	assert property(af_p3438);

	property af_p3439;
	@(posedge wb_clk_i) ((t5_wb_dat_o >= 100) && (t5_wb_dat_o <= 155)) |=> (t5_wb_dat_o >= 80) && (t5_wb_dat_o <= 175);
	endproperty
	assert property(af_p3439);

	property af_p3440;
	@(posedge wb_clk_i) !t5_wb_stb_o |-> !t5_wb_err_i;
	endproperty
	assert property(af_p3440);

	property af_p3441;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t5_wb_err_i [*2];
	endproperty
	assert property(af_p3441);

	property af_p3442;
	@(posedge wb_clk_i) t5_wb_err_i |=> !t5_wb_cyc_o;
	endproperty
	assert property(af_p3442);

	property af_p3443;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> !t5_wb_err_i;
	endproperty
	assert property(af_p3443);

	property af_p3444;
	@(posedge wb_clk_i) t5_wb_err_i |=> (!t5_wb_cyc_o && !t5_wb_stb_o);
	endproperty
	assert property(af_p3444);

	property af_p3445;
	@(posedge wb_clk_i) t5_wb_err_i |=> $stable(t5_wb_adr_o);
	endproperty
	assert property(af_p3445);

	property af_p3446;
	@(posedge wb_clk_i) disable iff (wb_rst_i) $stable(t5_wb_err_i);
	endproperty
	assert property(af_p3446);

	property af_p3447;
	@(posedge wb_clk_i) (t5_wb_err_i && t5_wb_cyc_o) |-> !t5_wb_ack_i;
	endproperty
	assert property(af_p3447);

	property af_p3448;
	@(posedge wb_clk_i) wb_rst_i |-> !t5_wb_err_i;
	endproperty
	assert property(af_p3448);

	property af_p3449;
	@(posedge wb_clk_i) (t5_wb_err_i) |-> (t5_wb_cyc_o && t5_wb_stb_o);
	endproperty
	assert property(af_p3449);

	property af_p3450;
	@(posedge wb_clk_i) ($rose(t5_wb_stb_o)) |-> (!t5_wb_err_i)[*4];
	endproperty
	assert property(af_p3450);

	property af_p3451;
	@(posedge wb_clk_i) (t5_wb_err_i) |-> (!t5_wb_ack_i);
	endproperty
	assert property(af_p3451);

	property af_p3452;
	@(posedge wb_clk_i) (!t5_wb_cyc_o && !t5_wb_stb_o) |-> (!t5_wb_err_i);
	endproperty
	assert property(af_p3452);

	property af_p3453;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (!t5_wb_err_i);
	endproperty
	assert property(af_p3453);

	property af_p3454;
	@(posedge wb_clk_i) (t5_wb_err_i) |-> (t5_wb_cyc_o);
	endproperty
	assert property(af_p3454);

	property af_p3455;
	@(posedge wb_clk_i) !(t5_wb_err_i && t5_wb_ack_i);
	endproperty
	assert property(af_p3455);

	property af_p3456;
	@(posedge wb_clk_i) ($rose(t5_wb_err_i)) |=> ($stable(t5_wb_we_o));
	endproperty
	assert property(af_p3456);

	property af_p3457;
	@(posedge wb_clk_i) (t5_wb_err_i && t5_wb_we_o) |=> ($past(t5_wb_dat_o) == t5_wb_dat_o);
	endproperty
	assert property(af_p3457);

	property af_p3458;
	@(posedge wb_clk_i) (t5_wb_err_i && t5_wb_cyc_o && t5_wb_stb_o) |=> (!t5_wb_cyc_o && !t5_wb_stb_o);
	endproperty
	assert property(af_p3458);

	property af_p3459;
	@(posedge wb_clk_i) $rose(t5_wb_err_i) |-> ##[1:4] $fell(t5_wb_err_i);
	endproperty
	assert property(af_p3459);

	property af_p3460;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(t5_wb_err_i);
	endproperty
	assert property(af_p3460);

	property af_p3461;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t5_wb_err_i);
	endproperty
	assert property(af_p3461);

	property af_p3462;
	@(posedge wb_clk_i) (t5_wb_err_i && t5_wb_cyc_o && t5_wb_stb_o) |-> (!t5_wb_ack_i);
	endproperty
	assert property(af_p3462);

	property af_p3463;
	@(posedge wb_clk_i) (t5_wb_err_i) |=> (!t5_wb_stb_o);
	endproperty
	assert property(af_p3463);

	property af_p3464;
	@(posedge wb_clk_i) (t5_wb_err_i) |=> (!t5_wb_err_i);
	endproperty
	assert property(af_p3464);

	property af_p3465;
	@(posedge wb_clk_i) (t5_wb_err_i && t5_wb_stb_o) |-> ##[1:2] (!t5_wb_cyc_o);
	endproperty
	assert property(af_p3465);

	property af_p3466;
	@(posedge wb_clk_i) not (t5_wb_err_i && t5_wb_ack_i);
	endproperty
	assert property(af_p3466);




	property af_p3470;
	@(posedge wb_clk_i) (t5_wb_cyc_o && !t5_wb_ack_i) |=> $stable(t5_wb_sel_o);
	endproperty
	assert property(af_p3470);




	property af_p3474;
	@(posedge wb_clk_i) (t5_wb_cyc_o && t5_wb_stb_o && !t5_wb_ack_i && !t5_wb_err_i) |=> $stable(t5_wb_sel_o) || t5_wb_ack_i || t5_wb_err_i;
	endproperty
	assert property(af_p3474);

	property af_p3475;
	@(posedge wb_clk_i) t5_wb_cyc_o |-> $stable(t5_wb_sel_o);
	endproperty
	assert property(af_p3475);


	property af_p3477;
	@(posedge wb_clk_i) $changed(t5_wb_sel_o) |-> !t5_wb_cyc_o;
	endproperty
	assert property(af_p3477);

	property af_p3478;
	@(posedge wb_clk_i) t5_wb_ack_i |-> $stable(t5_wb_sel_o);
	endproperty
	assert property(af_p3478);

	property af_p3479;
	@(posedge wb_clk_i) (t5_wb_stb_o && $past(t5_wb_stb_o)) |-> $stable(t5_wb_sel_o);
	endproperty
	assert property(af_p3479);

	property af_p3480;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] !$isunknown(t5_wb_sel_o);
	endproperty
	assert property(af_p3480);

	property af_p3481;
	@(posedge wb_clk_i) t5_wb_stb_o |-> (t5_wb_sel_o != 4'b0000);
	endproperty
	assert property(af_p3481);

	property af_p3482;
	@(posedge wb_clk_i) (t5_wb_we_o && t5_wb_stb_o) |-> (t5_wb_sel_o != 4'b0000);
	endproperty
	assert property(af_p3482);

	property af_p3483;
	@(posedge wb_clk_i) (t5_wb_we_o && t5_wb_cyc_o && t5_wb_stb_o) |-> (t5_wb_sel_o == (4'b0001 << t5_wb_adr_o[1:0]));
	endproperty
	assert property(af_p3483);

	property af_p3484;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 (t5_wb_sel_o inside {[0:15]})[*3];
	endproperty
	assert property(af_p3484);

	property af_p3485;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 !$isunknown(t5_wb_sel_o);
	endproperty
	assert property(af_p3485);

	property af_p3486;
	@(posedge wb_clk_i) (t5_wb_cyc_o && !t5_wb_ack_i) |-> ($stable(t5_wb_sel_o));
	endproperty
	assert property(af_p3486);

	property af_p3487;
	@(posedge wb_clk_i) ((t5_wb_sel_o >= 8) && (t5_wb_sel_o <= 15)) |=> ((t5_wb_sel_o >= 0) && (t5_wb_sel_o <= 15) && t5_wb_cyc_o);
	endproperty
	assert property(af_p3487);

	property af_p3488;
	@(posedge wb_clk_i) (t5_wb_stb_o) |-> ($stable(t5_wb_sel_o));
	endproperty
	assert property(af_p3488);

	property af_p3489;
	@(posedge wb_clk_i) (wb_rst_i) |=> (t5_wb_sel_o == '0);
	endproperty
	assert property(af_p3489);

	property af_p3490;
	@(posedge wb_clk_i) (t5_wb_stb_o) |-> ((t5_wb_sel_o >= 0) && (t5_wb_sel_o <= 15));
	endproperty
	assert property(af_p3490);

	property af_p3491;
	@(posedge wb_clk_i) ($rose(t5_wb_cyc_o)) |=> ((t5_wb_sel_o >= 1) && (t5_wb_sel_o <= 15));
	endproperty
	assert property(af_p3491);

	property af_p3492;
	@(posedge wb_clk_i) (!$stable(t5_wb_sel_o)) |-> ($past(!t5_wb_cyc_o) && $past(!t5_wb_stb_o));
	endproperty
	assert property(af_p3492);

	property af_p3493;
	@(posedge wb_clk_i) (t5_wb_we_o) |-> (t5_wb_sel_o != '0);
	endproperty
	assert property(af_p3493);

	property af_p3494;
	@(posedge wb_clk_i) (!$stable(t5_wb_sel_o)) |-> ($rose(t5_wb_stb_o));
	endproperty
	assert property(af_p3494);

	property af_p3495;
	@(posedge wb_clk_i) (t5_wb_stb_o && t5_wb_ack_i) |-> ##1 (t5_wb_stb_o == 1'b0) || (t5_wb_stb_o == 1'b1 && t5_wb_cyc_o == 1'b1);
	endproperty
	assert property(af_p3495);


	property af_p3497;
	@(posedge wb_clk_i) disable iff (wb_rst_i) t5_wb_stb_o |-> t5_wb_cyc_o;
	endproperty
	assert property(af_p3497);

	property af_p3498;
	@(posedge wb_clk_i) wb_rst_i |-> (t5_wb_stb_o == 1'b0);
	endproperty
	assert property(af_p3498);

	property af_p3499;
	@(posedge wb_clk_i) t5_wb_stb_o |-> (!$isunknown(t5_wb_sel_o));
	endproperty
	assert property(af_p3499);

	property af_p3500;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (t5_wb_stb_o == 1'b0);
	endproperty
	assert property(af_p3500);

	property af_p3501;
	@(posedge wb_clk_i) t5_wb_stb_o |-> $stable(t5_wb_we_o) throughout (t5_wb_stb_o[->1]);
	endproperty
	assert property(af_p3501);

	property af_p3502;
	@(posedge wb_clk_i) t5_wb_stb_o |-> (t5_wb_we_o !== 1'bx) && (!$isunknown(t5_wb_dat_o));
	endproperty
	assert property(af_p3502);

	property af_p3503;
	@(posedge wb_clk_i) t5_wb_stb_o |-> $stable(t5_wb_adr_o) throughout (t5_wb_stb_o[->1]);
	endproperty
	assert property(af_p3503);

	property af_p3504;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 (t5_wb_stb_o == 1'b0);
	endproperty
	assert property(af_p3504);

	property af_p3505;
	@(posedge wb_clk_i) $rose(t5_wb_err_i) |-> ##1 (t5_wb_stb_o == 1'b0);
	endproperty
	assert property(af_p3505);

	property af_p3506;
	@(posedge wb_clk_i) $changed(t5_wb_stb_o) |-> $rose(wb_clk_i);
	endproperty
	assert property(af_p3506);

	property af_p3507;
	@(posedge wb_clk_i) (t5_wb_stb_o && t5_wb_cyc_o && t5_wb_ack_i) |-> ##1 !t5_wb_stb_o;
	endproperty
	assert property(af_p3507);

	property af_p3508;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t5_wb_stb_o)[*4];
	endproperty
	assert property(af_p3508);


	property af_p3510;
	@(posedge wb_clk_i) $rose(t5_wb_stb_o) |-> ##1 $stable(t5_wb_stb_o);
	endproperty
	assert property(af_p3510);


	property af_p3512;
	@(posedge wb_clk_i) (t5_wb_stb_o) |-> (t5_wb_cyc_o);
	endproperty
	assert property(af_p3512);

	property af_p3513;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t5_wb_stb_o)[*2];
	endproperty
	assert property(af_p3513);

	property af_p3514;
	@(posedge wb_clk_i) $rose(t5_wb_ack_i) |-> ##1 !t5_wb_stb_o;
	endproperty
	assert property(af_p3514);

	property af_p3515;
	@(posedge wb_clk_i) (t5_wb_cyc_o && t5_wb_stb_o) |-> $stable(t5_wb_adr_o);
	endproperty
	assert property(af_p3515);


	property af_p3517;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t5_wb_stb_o);
	endproperty
	assert property(af_p3517);

	property af_p3518;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t5_wb_stb_o)[*3];
	endproperty
	assert property(af_p3518);

	property af_p3519;
	@(posedge wb_clk_i) (t5_wb_stb_o && t5_wb_cyc_o) |=> (t5_wb_stb_o -> t5_wb_cyc_o);
	endproperty
	assert property(af_p3519);

	property af_p3520;
	@(posedge wb_clk_i) t5_wb_stb_o |-> $stable(t5_wb_adr_o) until t5_wb_ack_i;
	endproperty
	assert property(af_p3520);

	property af_p3521;
	@(posedge wb_clk_i) not ((t5_wb_stb_o && !t5_wb_ack_i && !t5_wb_err_i) [*3]);
	endproperty
	assert property(af_p3521);

	property af_p3522;
	@(posedge wb_clk_i) !t5_wb_cyc_o |-> !t5_wb_stb_o;
	endproperty
	assert property(af_p3522);

	property af_p3523;
	@(posedge wb_clk_i) t5_wb_stb_o |-> (t5_wb_stb_o until (t5_wb_ack_i || t5_wb_err_i));
	endproperty
	assert property(af_p3523);

	property af_p3524;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> !t5_wb_stb_o;
	endproperty
	assert property(af_p3524);

	property af_p3525;
	@(posedge wb_clk_i) (t5_wb_stb_o && t5_wb_err_i) |=> !t5_wb_stb_o;
	endproperty
	assert property(af_p3525);

	property af_p3526;
	@(posedge wb_clk_i) $rose(t5_wb_stb_o) |=> !t5_wb_stb_o;
	endproperty
	assert property(af_p3526);

	property af_p3527;
	@(posedge wb_clk_i) (t5_wb_stb_o && t5_wb_ack_i) |=> !t5_wb_stb_o;
	endproperty
	assert property(af_p3527);

	property af_p3528;
	@(posedge wb_clk_i) wb_rst_i |-> !t5_wb_stb_o;
	endproperty
	assert property(af_p3528);

	property af_p3529;
	@(posedge wb_clk_i) (t5_wb_stb_o && !t5_wb_ack_i) |=> t5_wb_stb_o;
	endproperty
	assert property(af_p3529);

	property af_p3530;
	@(posedge wb_clk_i) t5_wb_stb_o |-> t5_wb_cyc_o;
	endproperty
	assert property(af_p3530);

	property af_p3531;
	@(posedge wb_clk_i) (t5_wb_ack_i && !t5_wb_cyc_o) |=> (t5_wb_we_o == 1'b0);
	endproperty
	assert property(af_p3531);

	property af_p3532;
	@(posedge wb_clk_i) (!t5_wb_we_o && t5_wb_stb_o) |-> (t5_wb_ack_i |-> $isunknown(t5_wb_dat_i) == 1'b0);
	endproperty
	assert property(af_p3532);

	property af_p3533;
	@(posedge wb_clk_i) (t5_wb_we_o) |-> ($isunknown(t5_wb_sel_o) == 1'b0);
	endproperty
	assert property(af_p3533);

	property af_p3534;
	@(posedge wb_clk_i) (t5_wb_we_o) |-> (t5_wb_dat_o === $past(t5_wb_dat_o) || !$past(t5_wb_ack_i)) throughout (!t5_wb_ack_i)[*0:$] ##1 t5_wb_ack_i;
	endproperty
	assert property(af_p3534);

	property af_p3535;
	@(posedge wb_clk_i) (t5_wb_stb_o && !t5_wb_ack_i) |-> ($stable(t5_wb_we_o));
	endproperty
	assert property(af_p3535);

	property af_p3536;
	@(posedge wb_clk_i) (!t5_wb_cyc_o) |-> (t5_wb_we_o == 1'b0);
	endproperty
	assert property(af_p3536);

	property af_p3537;
	@(posedge wb_clk_i) (t5_wb_cyc_o && t5_wb_stb_o && !t5_wb_we_o) |-> (t5_wb_we_o == 1'b0);
	endproperty
	assert property(af_p3537);

	property af_p3538;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t5_wb_we_o == 1'b0);
	endproperty
	assert property(af_p3538);

	property af_p3539;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (t5_wb_we_o && t5_wb_stb_o && t5_wb_cyc_o) |-> ##[0:1] t5_wb_ack_i;
	endproperty
	assert property(af_p3539);

	property af_p3540;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (!t5_wb_cyc_o) |-> $stable(t5_wb_we_o);
	endproperty
	assert property(af_p3540);

	property af_p3541;
	@(posedge wb_clk_i) disable iff (wb_rst_i) $rose(t5_wb_stb_o && t5_wb_we_o) |-> (t5_wb_we_o throughout t5_wb_ack_i[->1]);
	endproperty
	assert property(af_p3541);

	property af_p3542;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (t5_wb_cyc_o) |-> (t5_wb_we_o == i0_wb_we_i);
	endproperty
	assert property(af_p3542);

	property af_p3543;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (t5_wb_stb_o && t5_wb_we_o) |-> ($stable(t5_wb_adr_o) throughout t5_wb_ack_i[->1]);
	endproperty
	assert property(af_p3543);

	property af_p3544;
	@(posedge wb_clk_i) disable iff (wb_rst_i) $rose(t5_wb_cyc_o) |-> ($stable(t5_wb_we_o) throughout t5_wb_ack_i[->1]);
	endproperty
	assert property(af_p3544);

	property af_p3545;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##[0:1] (t5_wb_we_o == 1'b0);
	endproperty
	assert property(af_p3545);

	property af_p3546;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##[0:2] !$isunknown(t5_wb_we_o);
	endproperty
	assert property(af_p3546);

	property af_p3547;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (t5_wb_we_o) |-> (t5_wb_stb_o && t5_wb_cyc_o);
	endproperty
	assert property(af_p3547);

	property af_p3548;
	@(posedge wb_clk_i) (t5_wb_cyc_o) |-> ($stable(t5_wb_we_o) throughout (t5_wb_cyc_o[*1:$]));
	endproperty
	assert property(af_p3548);

	property af_p3549;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (t5_wb_we_o != $past(t5_wb_we_o)) |-> $rose(wb_clk_i);
	endproperty
	assert property(af_p3549);

	property af_p3550;
	@(posedge wb_clk_i) (t5_wb_we_o) |-> (t5_wb_cyc_o);
	endproperty
	assert property(af_p3550);

	property af_p3551;
	@(posedge wb_clk_i) (t5_wb_we_o) |-> ($stable(t5_wb_adr_o) throughout (t5_wb_cyc_o[*1:$] ##0 t5_wb_ack_i));
	endproperty
	assert property(af_p3551);

	property af_p3552;
	@(posedge wb_clk_i) disable iff (wb_rst_i) ($fell(wb_rst_i) |-> !t5_wb_we_o) and (t5_wb_we_o != $past(t5_wb_we_o) |-> t5_wb_stb_o);
	endproperty
	assert property(af_p3552);

	property af_p3553;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!$isunknown(t5_wb_we_o));
	endproperty
	assert property(af_p3553);

	property af_p3554;
	@(posedge wb_clk_i) (t5_wb_we_o && t5_wb_stb_o) |-> ($stable(t5_wb_dat_o) throughout (t5_wb_stb_o[*1:$] ##0 t5_wb_ack_i));
	endproperty
	assert property(af_p3554);

	property af_p3555;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t6_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p3555);

	property af_p3556;
	@(posedge wb_clk_i) $fell(t6_wb_cyc_o) |=> !t6_wb_ack_i;
	endproperty
	assert property(af_p3556);

	property af_p3557;
	@(posedge wb_clk_i) (!t6_wb_cyc_o) |-> $stable(t6_wb_ack_i);
	endproperty
	assert property(af_p3557);


	property af_p3559;
	@(posedge wb_clk_i) (!t6_wb_cyc_o && !t6_wb_stb_o) |-> (t6_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p3559);

	property af_p3560;
	@(posedge wb_clk_i) (!t6_wb_we_o) |-> (t6_wb_ack_i |-> $stable(t6_wb_dat_i));
	endproperty
	assert property(af_p3560);

	property af_p3561;
	@(posedge wb_clk_i) $fell(t6_wb_stb_o) |-> !t6_wb_ack_i;
	endproperty
	assert property(af_p3561);

	property af_p3562;
	@(posedge wb_clk_i) $rose(t6_wb_ack_i) |-> $stable(t6_wb_adr_o);
	endproperty
	assert property(af_p3562);

	property af_p3563;
	@(posedge wb_clk_i) (t6_wb_ack_i) |-> (!t6_wb_err_i);
	endproperty
	assert property(af_p3563);

	property af_p3564;
	@(posedge wb_clk_i) $rose(t6_wb_stb_o) |-> (t6_wb_ack_i throughout t6_wb_stb_o[->1]) ##1 !t6_wb_ack_i;
	endproperty
	assert property(af_p3564);

	property af_p3565;
	@(posedge wb_clk_i) $rose(t6_wb_ack_i) |-> $past(t6_wb_ack_i) == 1'b0;
	endproperty
	assert property(af_p3565);

	property af_p3566;
	@(posedge wb_clk_i) ($rose(t6_wb_ack_i) && !t6_wb_stb_o) |=> !t6_wb_ack_i;
	endproperty
	assert property(af_p3566);

	property af_p3567;
	@(posedge wb_clk_i) (t6_wb_cyc_o && t6_wb_stb_o) |-> ##[1:16] t6_wb_ack_i;
	endproperty
	assert property(af_p3567);

	property af_p3568;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t6_wb_ack_i throughout (!t6_wb_stb_o[*1:$] ##1 t6_wb_stb_o));
	endproperty
	assert property(af_p3568);

	property af_p3569;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!t6_wb_ack_i throughout (wb_rst_i[*1:$] ##1 !wb_rst_i[*2]));
	endproperty
	assert property(af_p3569);

	property af_p3570;
	@(posedge wb_clk_i) (!t6_wb_stb_o && t6_wb_ack_i) |=> !t6_wb_ack_i;
	endproperty
	assert property(af_p3570);

	property af_p3571;
	@(posedge wb_clk_i) !(t6_wb_ack_i && t6_wb_err_i);
	endproperty
	assert property(af_p3571);

	property af_p3572;
	@(posedge wb_clk_i) wb_rst_i |-> !t6_wb_ack_i;
	endproperty
	assert property(af_p3572);

	property af_p3573;
	@(posedge wb_clk_i) t6_wb_ack_i |-> !t6_wb_err_i;
	endproperty
	assert property(af_p3573);

	property af_p3574;
	@(posedge wb_clk_i) $rose(t6_wb_stb_o) |-> ##1 (t6_wb_ack_i ##1 !t6_wb_ack_i);
	endproperty
	assert property(af_p3574);

	property af_p3575;
	@(posedge wb_clk_i) (!t6_wb_we_o) |-> (t6_wb_ack_i |-> !$isunknown(t6_wb_dat_i));
	endproperty
	assert property(af_p3575);

	property af_p3576;
	@(posedge wb_clk_i) ($past(t6_wb_ack_i) && !t6_wb_stb_o) |-> !t6_wb_ack_i;
	endproperty
	assert property(af_p3576);

	property af_p3577;
	@(posedge wb_clk_i) t6_wb_ack_i |-> (t6_wb_cyc_o && t6_wb_stb_o);
	endproperty
	assert property(af_p3577);

	property af_p3578;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (!t6_wb_cyc_o) |-> !t6_wb_ack_i;
	endproperty
	assert property(af_p3578);

	property af_p3579;
	@(posedge wb_clk_i) t6_wb_ack_i |-> t6_wb_cyc_o;
	endproperty
	assert property(af_p3579);

	property af_p3580;
	@(posedge wb_clk_i) t6_wb_ack_i |-> !$isunknown(t6_wb_dat_i);
	endproperty
	assert property(af_p3580);

	property af_p3581;
	@(posedge wb_clk_i) (!t6_wb_cyc_o && !$past(t6_wb_cyc_o)) |-> ($stable(t6_wb_ack_i));
	endproperty
	assert property(af_p3581);

	property af_p3582;
	@(posedge wb_clk_i) t6_wb_ack_i |-> ($past(t6_wb_cyc_o) && $past(t6_wb_stb_o)) || (t6_wb_cyc_o && t6_wb_stb_o);
	endproperty
	assert property(af_p3582);

	property af_p3583;
	@(posedge wb_clk_i) (t6_wb_we_o && t6_wb_cyc_o && t6_wb_stb_o) |-> t6_wb_ack_i;
	endproperty
	assert property(af_p3583);

	property af_p3584;
	@(posedge wb_clk_i) disable iff (wb_rst_i) ($past(wb_rst_i,3) && !wb_rst_i && t6_wb_cyc_o && t6_wb_stb_o) |-> t6_wb_ack_i;
	endproperty
	assert property(af_p3584);

	property af_p3585;
	@(posedge wb_clk_i) (t6_wb_stb_o && !t6_wb_ack_i) |=> ($stable(t6_wb_adr_o) || t6_wb_ack_i);
	endproperty
	assert property(af_p3585);

	property af_p3586;
	@(posedge wb_clk_i) (wb_rst_i) |-> ((t6_wb_adr_o == '0) && !$isunknown(t6_wb_adr_o));
	endproperty
	assert property(af_p3586);

	property af_p3587;
	@(posedge wb_clk_i) ($fell(t6_wb_cyc_o)) |=> 1'b1;
	endproperty
	assert property(af_p3587);

	property af_p3588;
	@(posedge wb_clk_i) (t6_wb_cyc_o && t6_wb_stb_o) |-> ($stable(t6_wb_adr_o) throughout (t6_wb_ack_i[->1]));
	endproperty
	assert property(af_p3588);

	property af_p3589;
	@(posedge wb_clk_i) (!wb_rst_i && !t6_wb_cyc_o) |-> $stable(t6_wb_adr_o);
	endproperty
	assert property(af_p3589);

	property af_p3590;
	@(posedge wb_clk_i) (!t6_wb_cyc_o) |-> $stable(t6_wb_adr_o);
	endproperty
	assert property(af_p3590);

	property af_p3591;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(t6_wb_adr_o);
	endproperty
	assert property(af_p3591);

	property af_p3592;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##[1:2] (t6_wb_adr_o == '0);
	endproperty
	assert property(af_p3592);

	property af_p3593;
	@(posedge wb_clk_i) (t6_wb_cyc_o && t6_wb_stb_o && !t6_wb_ack_i) |=> $stable(t6_wb_adr_o);
	endproperty
	assert property(af_p3593);

	property af_p3594;
	@(posedge wb_clk_i) (t6_wb_adr_o != $past(t6_wb_adr_o)) |-> ($past(!t6_wb_cyc_o) || $past(t6_wb_ack_i));
	endproperty
	assert property(af_p3594);

	property af_p3595;
	@(posedge wb_clk_i) $rose(t6_wb_cyc_o) |-> ($stable(t6_wb_adr_o) until (t6_wb_ack_i || t6_wb_err_i));
	endproperty
	assert property(af_p3595);

	property af_p3596;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (!$isunknown(t6_wb_adr_o));
	endproperty
	assert property(af_p3596);

	property af_p3597;
	@(posedge wb_clk_i) wb_rst_i |-> $stable(t6_wb_adr_o);
	endproperty
	assert property(af_p3597);

	property af_p3598;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !$isunknown(t6_wb_adr_o);
	endproperty
	assert property(af_p3598);

	property af_p3599;
	@(posedge wb_clk_i) (t6_wb_cyc_o && t6_wb_stb_o) |-> ($stable(t6_wb_adr_o) until t6_wb_ack_i);
	endproperty
	assert property(af_p3599);

	property af_p3600;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> !$isunknown(t6_wb_adr_o);
	endproperty
	assert property(af_p3600);

	property af_p3601;
	@(posedge wb_clk_i) ($fell(wb_rst_i) ##2 t6_wb_stb_o) |-> !$isunknown(t6_wb_adr_o);
	endproperty
	assert property(af_p3601);

	property af_p3602;
	@(posedge wb_clk_i) 1'b1 |-> ($stable(t6_wb_adr_o) || $changed(t6_wb_adr_o));
	endproperty
	assert property(af_p3602);

	property af_p3603;
	@(posedge wb_clk_i) $rose(t6_wb_ack_i) |=> $stable(t6_wb_adr_o);
	endproperty
	assert property(af_p3603);

	property af_p3604;
	@(posedge wb_clk_i) (t6_wb_we_o && t6_wb_cyc_o && !t6_wb_ack_i) |=> $stable(t6_wb_adr_o);
	endproperty
	assert property(af_p3604);

	property af_p3605;
	@(posedge wb_clk_i) (t6_wb_we_o && t6_wb_cyc_o && t6_wb_stb_o) |-> (t6_wb_adr_o >= 32'h0000_0000 && t6_wb_adr_o <= 32'hFFFF_FFFF);
	endproperty
	assert property(af_p3605);

	property af_p3606;
	@(posedge wb_clk_i) $past(t6_wb_ack_i) |-> 1'b1;
	endproperty
	assert property(af_p3606);

	property af_p3607;
	@(posedge wb_clk_i) (t6_wb_we_o && t6_wb_stb_o && !t6_wb_ack_i) |=> $stable(t6_wb_adr_o);
	endproperty
	assert property(af_p3607);

	property af_p3608;
	@(posedge wb_clk_i) (t6_wb_stb_o && !t6_wb_ack_i) |=> $stable(t6_wb_adr_o);
	endproperty
	assert property(af_p3608);

	property af_p3609;
	@(posedge wb_clk_i) (t6_wb_cyc_o && !t6_wb_ack_i) |=> (t6_wb_cyc_o || t6_wb_ack_i);
	endproperty
	assert property(af_p3609);

	property af_p3610;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!t6_wb_cyc_o)[*2];
	endproperty
	assert property(af_p3610);

	property af_p3611;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (t6_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p3611);

	property af_p3612;
	@(posedge wb_clk_i) (t6_wb_err_i) |=> (!t6_wb_cyc_o);
	endproperty
	assert property(af_p3612);

	property af_p3613;
	@(posedge wb_clk_i) ($fell(t6_wb_cyc_o)) |-> ($past(t6_wb_ack_i) || $past(t6_wb_err_i));
	endproperty
	assert property(af_p3613);

	property af_p3614;
	@(posedge wb_clk_i) (t6_wb_cyc_o) |-> (t6_wb_stb_o);
	endproperty
	assert property(af_p3614);

	property af_p3615;
	@(posedge wb_clk_i) ($rose(t6_wb_cyc_o)) |-> (1'b1);
	endproperty
	assert property(af_p3615);

	property af_p3616;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t6_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p3616);

	property af_p3617;
	@(posedge wb_clk_i) t6_wb_cyc_o |-> $stable(t6_wb_adr_o);
	endproperty
	assert property(af_p3617);

	property af_p3618;
	@(posedge wb_clk_i) $rose(t6_wb_cyc_o) |-> (t6_wb_cyc_o until t6_wb_ack_i);
	endproperty
	assert property(af_p3618);

	property af_p3619;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t6_wb_cyc_o)[*2];
	endproperty
	assert property(af_p3619);

	property af_p3620;
	@(posedge wb_clk_i) $rose(t6_wb_cyc_o) |=> t6_wb_cyc_o;
	endproperty
	assert property(af_p3620);

	property af_p3621;
	@(posedge wb_clk_i) t6_wb_ack_i |=> (!t6_wb_cyc_o && !t6_wb_stb_o);
	endproperty
	assert property(af_p3621);

	property af_p3622;
	@(posedge wb_clk_i) wb_rst_i |-> (!t6_wb_cyc_o);
	endproperty
	assert property(af_p3622);

	property af_p3623;
	@(posedge wb_clk_i) ($changed(t6_wb_cyc_o)) |-> (t6_wb_cyc_o === $past(t6_wb_cyc_o,2));
	endproperty
	assert property(af_p3623);

	property af_p3624;
	@(posedge wb_clk_i) ($rose(t6_wb_ack_i)) |=> (!t6_wb_cyc_o);
	endproperty
	assert property(af_p3624);

	property af_p3625;
	@(posedge wb_clk_i) ($rose(t6_wb_cyc_o)) |-> ($past(!wb_rst_i));
	endproperty
	assert property(af_p3625);

	property af_p3626;
	@(posedge wb_clk_i) (t6_wb_err_i && t6_wb_cyc_o) |=> (!t6_wb_cyc_o);
	endproperty
	assert property(af_p3626);

	property af_p3627;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |=> (!t6_wb_cyc_o);
	endproperty
	assert property(af_p3627);

	property af_p3628;
	@(posedge wb_clk_i) (t6_wb_stb_o) |-> (t6_wb_cyc_o);
	endproperty
	assert property(af_p3628);

	property af_p3629;
	@(posedge wb_clk_i) ($rose(t6_wb_we_o)) |-> (t6_wb_cyc_o);
	endproperty
	assert property(af_p3629);

	property af_p3630;
	@(posedge wb_clk_i) ((t6_wb_dat_i >= 100) && (t6_wb_dat_i <= 255)) |-> ((t6_wb_dat_i >= 80) && (t6_wb_dat_i <= 255));
	endproperty
	assert property(af_p3630);

	property af_p3631;
	@(posedge wb_clk_i) (t6_wb_err_i) |-> ((t6_wb_dat_i inside {[0:255]}) || !(t6_wb_dat_i inside {[0:255]}));
	endproperty
	assert property(af_p3631);

	property af_p3632;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((t6_wb_dat_i >= 0) && (t6_wb_dat_i <= 45));
	endproperty
	assert property(af_p3632);

	property af_p3633;
	@(posedge wb_clk_i) (t6_wb_cyc_o && !t6_wb_ack_i) |=> $stable(t6_wb_dat_i);
	endproperty
	assert property(af_p3633);

	property af_p3634;
	@(posedge wb_clk_i) ((t6_wb_dat_i >= 200) && (t6_wb_dat_i <= 255)) |-> ((t6_wb_dat_i >= 180) && (t6_wb_dat_i <= 255));
	endproperty
	assert property(af_p3634);

	property af_p3635;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t6_wb_dat_i >= 50) && (t6_wb_dat_i <= 200));
	endproperty
	assert property(af_p3635);

	property af_p3636;
	@(posedge wb_clk_i) (!t6_wb_we_o) |=> ((t6_wb_dat_i >= 0) && (t6_wb_dat_i <= 255));
	endproperty
	assert property(af_p3636);

	property af_p3637;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t6_wb_dat_i >= 0) && (t6_wb_dat_i <= 255));
	endproperty
	assert property(af_p3637);

	property af_p3638;
	@(posedge wb_clk_i) (t6_wb_err_i) |=> 1'b1;
	endproperty
	assert property(af_p3638);

	property af_p3639;
	@(posedge wb_clk_i) ((t6_wb_dat_i >= 230) && (t6_wb_dat_i <= 255)) |-> ((t6_wb_dat_i >= 205) && (t6_wb_dat_i <= 255));
	endproperty
	assert property(af_p3639);

	property af_p3640;
	@(posedge wb_clk_i) (t6_wb_cyc_o && t6_wb_stb_o) |-> ((t6_wb_dat_i >= 0) && (t6_wb_dat_i <= 255));
	endproperty
	assert property(af_p3640);

	property af_p3641;
	@(posedge wb_clk_i) $rose(t6_wb_cyc_o) |-> ##[1:2] $stable(t6_wb_dat_i) && (t6_wb_dat_i >= 0) && (t6_wb_dat_i <= 255);
	endproperty
	assert property(af_p3641);

	property af_p3642;
	@(posedge wb_clk_i) (t6_wb_ack_i) |-> $stable(t6_wb_dat_i) && (t6_wb_dat_i >= 0) && (t6_wb_dat_i <= 255);
	endproperty
	assert property(af_p3642);

	property af_p3643;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t6_wb_dat_i >= 0) && (t6_wb_dat_i <= 255);
	endproperty
	assert property(af_p3643);

	property af_p3644;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (t6_wb_dat_i >= 0) && (t6_wb_dat_i <= 15);
	endproperty
	assert property(af_p3644);

	property af_p3645;
	@(posedge wb_clk_i) ((t6_wb_dat_i >= 138) && (t6_wb_dat_i <= 153)) |=> (t6_wb_dat_i >= 98) && (t6_wb_dat_i <= 153);
	endproperty
	assert property(af_p3645);

	property af_p3646;
	@(posedge wb_clk_i) (!t6_wb_we_o) |=> (t6_wb_dat_i >= 0) && (t6_wb_dat_i <= 255);
	endproperty
	assert property(af_p3646);

	property af_p3647;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(t6_wb_dat_i) throughout (wb_rst_i)[*1:$];
	endproperty
	assert property(af_p3647);

	property af_p3648;
	@(posedge wb_clk_i) (t6_wb_ack_i) |-> $stable(t6_wb_dat_i) && (t6_wb_dat_i >= 120) && (t6_wb_dat_i <= 180);
	endproperty
	assert property(af_p3648);

	property af_p3649;
	@(posedge wb_clk_i) (t6_wb_err_i) |-> ##[1:2] (t6_wb_dat_i >= 0) && (t6_wb_dat_i <= 255);
	endproperty
	assert property(af_p3649);

	property af_p3650;
	@(posedge wb_clk_i) (##4 $fell(wb_rst_i)) |-> (t6_wb_dat_i >= 0) && (t6_wb_dat_i <= 63);
	endproperty
	assert property(af_p3650);

	property af_p3651;
	@(posedge wb_clk_i) ((t6_wb_dat_i >= 64) && (t6_wb_dat_i <= 191)) |=> ((t6_wb_dat_i >= 32) && (t6_wb_dat_i <= 223));
	endproperty
	assert property(af_p3651);

	property af_p3652;
	@(posedge wb_clk_i) (wb_rst_i) |=> (t6_wb_dat_i == 0);
	endproperty
	assert property(af_p3652);

	property af_p3653;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##3 ((t6_wb_dat_i >= 83) && (t6_wb_dat_i <= 165));
	endproperty
	assert property(af_p3653);

	property af_p3654;
	@(posedge wb_clk_i) (!t6_wb_we_o) |-> (((t6_wb_dat_i >= 30) && (t6_wb_dat_i <= 225)) ##1 ((t6_wb_dat_i >= 30) && (t6_wb_dat_i <= 225)));
	endproperty
	assert property(af_p3654);

	property af_p3655;
	@(posedge wb_clk_i) ((t6_wb_dat_i >= 100) && (t6_wb_dat_i <= 150)) |=> ((t6_wb_dat_i >= 80) && (t6_wb_dat_i <= 170));
	endproperty
	assert property(af_p3655);

	property af_p3656;
	@(posedge wb_clk_i) ((t6_wb_dat_i >= 50) && (t6_wb_dat_i <= 100) && t6_wb_ack_i) |=> ((t6_wb_dat_i >= 40) && (t6_wb_dat_i <= 110));
	endproperty
	assert property(af_p3656);

	property af_p3657;
	@(posedge wb_clk_i) (t6_wb_cyc_o && t6_wb_stb_o) |-> (!$isunknown(t6_wb_dat_i));
	endproperty
	assert property(af_p3657);

	property af_p3658;
	@(posedge wb_clk_i) (t6_wb_ack_i) |-> ($stable(t6_wb_dat_i) && (t6_wb_dat_i >= 0) && (t6_wb_dat_i <= 255));
	endproperty
	assert property(af_p3658);

	property af_p3659;
	@(posedge wb_clk_i) (t6_wb_ack_i) |=> ((t6_wb_dat_i >= 0) && (t6_wb_dat_i <= 255));
	endproperty
	assert property(af_p3659);

	property af_p3660;
	@(posedge wb_clk_i) wb_rst_i |-> (t6_wb_dat_o == '0);
	endproperty
	assert property(af_p3660);

	property af_p3661;
	@(posedge wb_clk_i) ((t6_wb_dat_o >= 200) && (t6_wb_dat_o <= 255)) |-> ##1 ((t6_wb_dat_o >= 180) && (t6_wb_dat_o <= 255));
	endproperty
	assert property(af_p3661);

	property af_p3662;
	@(posedge wb_clk_i) (!t6_wb_cyc_o) |-> $stable(t6_wb_dat_o);
	endproperty
	assert property(af_p3662);

	property af_p3663;
	@(posedge wb_clk_i) t6_wb_ack_i |-> $stable(t6_wb_dat_o);
	endproperty
	assert property(af_p3663);

	property af_p3664;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (t6_wb_dat_o >= 0 && t6_wb_dat_o <= 255);
	endproperty
	assert property(af_p3664);

	property af_p3665;
	@(posedge wb_clk_i) (!t6_wb_stb_o) |-> $stable(t6_wb_dat_o);
	endproperty
	assert property(af_p3665);

	property af_p3666;
	@(posedge wb_clk_i) wb_rst_i |-> (t6_wb_dat_o >= 0 && t6_wb_dat_o <= 0);
	endproperty
	assert property(af_p3666);

	property af_p3667;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (t6_wb_dat_o >= 0 && t6_wb_dat_o <= 128);
	endproperty
	assert property(af_p3667);

	property af_p3668;
	@(posedge wb_clk_i) t6_wb_we_o |-> (t6_wb_dat_o == '0);
	endproperty
	assert property(af_p3668);

	property af_p3669;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t6_wb_dat_o >= 0 && t6_wb_dat_o <= 255);
	endproperty
	assert property(af_p3669);

	property af_p3670;
	@(posedge wb_clk_i) (t6_wb_cyc_o && t6_wb_stb_o && !t6_wb_we_o && t6_wb_ack_i) |-> (t6_wb_dat_o >= 0 && t6_wb_dat_o <= 255);
	endproperty
	assert property(af_p3670);

	property af_p3671;
	@(posedge wb_clk_i) t6_wb_err_i |-> $stable(t6_wb_dat_o);
	endproperty
	assert property(af_p3671);

	property af_p3672;
	@(posedge wb_clk_i) (t6_wb_we_o && t6_wb_stb_o) |-> (t6_wb_dat_o == t6_wb_adr_o);
	endproperty
	assert property(af_p3672);

	property af_p3673;
	@(posedge wb_clk_i) (t6_wb_ack_i) |-> ##1 (!$isunknown(t6_wb_dat_o));
	endproperty
	assert property(af_p3673);

	property af_p3674;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 ((t6_wb_dat_o >= 0) && (t6_wb_dat_o <= 255));
	endproperty
	assert property(af_p3674);

	property af_p3675;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t6_wb_dat_o == 0);
	endproperty
	assert property(af_p3675);

	property af_p3676;
	@(posedge wb_clk_i) (t6_wb_cyc_o && t6_wb_stb_o && !t6_wb_ack_i) |-> $stable(t6_wb_dat_o);
	endproperty
	assert property(af_p3676);

	property af_p3677;
	@(posedge wb_clk_i) ($rose(t6_wb_ack_i) && t6_wb_cyc_o) |=> ($stable(t6_wb_dat_o) until_with $rose(t6_wb_ack_i));
	endproperty
	assert property(af_p3677);

	property af_p3678;
	@(posedge wb_clk_i) (!t6_wb_ack_i) |-> $stable(t6_wb_dat_o);
	endproperty
	assert property(af_p3678);

	property af_p3679;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((t6_wb_dat_o >= 0) && (t6_wb_dat_o <= 255));
	endproperty
	assert property(af_p3679);

	property af_p3680;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##[0:1] (t6_wb_dat_o == 0);
	endproperty
	assert property(af_p3680);

	property af_p3681;
	@(posedge wb_clk_i) (t6_wb_ack_i) |=> ($stable(t6_wb_dat_o) until_with t6_wb_stb_o);
	endproperty
	assert property(af_p3681);

	property af_p3682;
	@(posedge wb_clk_i) ((t6_wb_dat_o >= 50) && (t6_wb_dat_o <= 75)) |-> ##1 ((t6_wb_dat_o >= 30) && (t6_wb_dat_o <= 95));
	endproperty
	assert property(af_p3682);

	property af_p3683;
	@(posedge wb_clk_i) ((t6_wb_dat_o >= 50) && (t6_wb_dat_o <= 100)) |=> ((t6_wb_dat_o >= 30) && (t6_wb_dat_o <= 120));
	endproperty
	assert property(af_p3683);

	property af_p3684;
	@(posedge wb_clk_i) (t6_wb_stb_o) |=> (t6_wb_stb_o |-> $stable(t6_wb_dat_o));
	endproperty
	assert property(af_p3684);

	property af_p3685;
	@(posedge wb_clk_i) ((t6_wb_dat_o >= 100) && (t6_wb_dat_o <= 200)) |=> ((t6_wb_dat_o >= 80) && (t6_wb_dat_o <= 220));
	endproperty
	assert property(af_p3685);

	property af_p3686;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(t6_wb_dat_o);
	endproperty
	assert property(af_p3686);

	property af_p3687;
	@(posedge wb_clk_i) ((t6_wb_dat_o >= 100) && (t6_wb_dat_o <= 150) && t6_wb_cyc_o) |=> (t6_wb_cyc_o |-> ((t6_wb_dat_o >= 80) && (t6_wb_dat_o <= 170)));
	endproperty
	assert property(af_p3687);

	property af_p3688;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##3 ((t6_wb_dat_o >= 0) && (t6_wb_dat_o <= 255));
	endproperty
	assert property(af_p3688);

	property af_p3689;
	@(posedge wb_clk_i) (!(t6_wb_cyc_o && t6_wb_stb_o)) |-> $stable(t6_wb_dat_o);
	endproperty
	assert property(af_p3689);

	property af_p3690;
	@(posedge wb_clk_i) (!t6_wb_we_o) |-> $stable(t6_wb_dat_o);
	endproperty
	assert property(af_p3690);

	property af_p3691;
	@(posedge wb_clk_i) (t6_wb_err_i) |=> (t6_wb_adr_o != $past(t6_wb_adr_o));
	endproperty
	assert property(af_p3691);

	property af_p3692;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t6_wb_err_i == 1'b0);
	endproperty
	assert property(af_p3692);

	property af_p3693;
	@(posedge wb_clk_i) !(t6_wb_err_i && t6_wb_ack_i);
	endproperty
	assert property(af_p3693);

	property af_p3694;
	@(posedge wb_clk_i) (!t6_wb_stb_o) |-> ($stable(t6_wb_err_i));
	endproperty
	assert property(af_p3694);

	property af_p3695;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (t6_wb_err_i == 1'b0);
	endproperty
	assert property(af_p3695);

	property af_p3696;
	@(posedge wb_clk_i) (t6_wb_err_i) |-> ($past(t6_wb_cyc_o) || t6_wb_cyc_o);
	endproperty
	assert property(af_p3696);


	property af_p3698;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (t6_wb_err_i == 1'b0);
	endproperty
	assert property(af_p3698);

	property af_p3699;
	@(posedge wb_clk_i) (t6_wb_err_i) |=> (t6_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p3699);

	property af_p3700;
	@(posedge wb_clk_i) (t6_wb_err_i) |=> (t6_wb_stb_o == 1'b0);
	endproperty
	assert property(af_p3700);

	property af_p3701;
	@(posedge wb_clk_i) t6_wb_err_i |-> $stable(t6_wb_adr_o);
	endproperty
	assert property(af_p3701);

	property af_p3702;
	@(posedge wb_clk_i) ($rose(t6_wb_err_i)) |=> $stable(t6_wb_we_o);
	endproperty
	assert property(af_p3702);

	property af_p3703;
	@(posedge wb_clk_i) t6_wb_err_i |-> (t6_wb_cyc_o && t6_wb_stb_o);
	endproperty
	assert property(af_p3703);

	property af_p3704;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t6_wb_err_i)[*2];
	endproperty
	assert property(af_p3704);

	property af_p3705;
	@(posedge wb_clk_i) (t6_wb_err_i && !$past(t6_wb_err_i)) |=> (!t6_wb_err_i || $rose(t6_wb_err_i));
	endproperty
	assert property(af_p3705);

	property af_p3706;
	@(posedge wb_clk_i) t6_wb_err_i |-> (t6_wb_stb_o && t6_wb_cyc_o) || ($past(t6_wb_stb_o) && $past(t6_wb_cyc_o));
	endproperty
	assert property(af_p3706);

	property af_p3707;
	@(posedge wb_clk_i) (!t6_wb_cyc_o) |-> (!t6_wb_err_i);
	endproperty
	assert property(af_p3707);

	property af_p3708;
	@(posedge wb_clk_i) t6_wb_err_i |-> (t6_wb_we_o === 1'b0 || t6_wb_we_o === 1'b1);
	endproperty
	assert property(af_p3708);

	property af_p3709;
	@(posedge wb_clk_i) t6_wb_err_i |=> (!t6_wb_cyc_o);
	endproperty
	assert property(af_p3709);

	property af_p3710;
	@(posedge wb_clk_i) (t6_wb_cyc_o) |-> not (t6_wb_err_i && t6_wb_ack_i);
	endproperty
	assert property(af_p3710);

	property af_p3711;
	@(posedge wb_clk_i) (wb_rst_i) |-> !t6_wb_err_i;
	endproperty
	assert property(af_p3711);

	property af_p3712;
	@(posedge wb_clk_i) (t6_wb_err_i) |-> t6_wb_cyc_o;
	endproperty
	assert property(af_p3712);

	property af_p3713;
	@(posedge wb_clk_i) t6_wb_err_i |=> $stable(t6_wb_we_o);
	endproperty
	assert property(af_p3713);

	property af_p3714;
	@(posedge wb_clk_i) (t6_wb_err_i) |=> !t6_wb_stb_o;
	endproperty
	assert property(af_p3714);

	property af_p3715;
	@(posedge wb_clk_i) t6_wb_err_i |=> !t6_wb_err_i;
	endproperty
	assert property(af_p3715);

	property af_p3716;
	@(posedge wb_clk_i) not (t6_wb_err_i && t6_wb_ack_i);
	endproperty
	assert property(af_p3716);

	property af_p3717;
	@(posedge wb_clk_i) ($rose(t6_wb_err_i)) |-> t6_wb_cyc_o;
	endproperty
	assert property(af_p3717);

	property af_p3718;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t6_wb_err_i ##1 !t6_wb_err_i;
	endproperty
	assert property(af_p3718);

	property af_p3719;
	@(posedge wb_clk_i) (t6_wb_cyc_o && t6_wb_stb_o && !t6_wb_err_i) |-> !t6_wb_err_i;
	endproperty
	assert property(af_p3719);

	property af_p3720;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (t6_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p3720);

	property af_p3721;
	@(posedge wb_clk_i) (t6_wb_cyc_o && t6_wb_stb_o && !t6_wb_ack_i) |-> $stable(t6_wb_sel_o);
	endproperty
	assert property(af_p3721);

	property af_p3722;
	@(posedge wb_clk_i) $rose(t6_wb_we_o) |=> (t6_wb_sel_o != 4'b0000);
	endproperty
	assert property(af_p3722);

	property af_p3723;
	@(posedge wb_clk_i) (t6_wb_we_o) |-> (t6_wb_sel_o != 4'b0000);
	endproperty
	assert property(af_p3723);

	property af_p3724;
	@(posedge wb_clk_i) (t6_wb_sel_o != 4'b0000) |-> (t6_wb_we_o);
	endproperty
	assert property(af_p3724);

	property af_p3725;
	@(posedge wb_clk_i) $rose(t6_wb_ack_i) |=> ##1 ((t6_wb_sel_o !== $past(t6_wb_sel_o)) || (t6_wb_sel_o === $past(t6_wb_sel_o)));
	endproperty
	assert property(af_p3725);

	property af_p3726;
	@(posedge wb_clk_i) (t6_wb_ack_i && !t6_wb_stb_o) |=> (t6_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p3726);

	property af_p3727;
	@(posedge wb_clk_i) (t6_wb_sel_o != 4'b0000) |-> (t6_wb_stb_o);
	endproperty
	assert property(af_p3727);

	property af_p3728;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:3] (t6_wb_sel_o >= 4'd0 && t6_wb_sel_o <= 4'd15);
	endproperty
	assert property(af_p3728);

	property af_p3729;
	@(posedge wb_clk_i) (t6_wb_stb_o) |-> (t6_wb_sel_o >= 4'd1 && t6_wb_sel_o <= 4'd15);
	endproperty
	assert property(af_p3729);

	property af_p3730;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t6_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p3730);

	property af_p3731;
	@(posedge wb_clk_i) (t6_wb_cyc_o && !t6_wb_ack_i) |-> $stable(t6_wb_sel_o);
	endproperty
	assert property(af_p3731);


	property af_p3733;
	@(posedge wb_clk_i) (t6_wb_cyc_o) |=> $stable(t6_wb_sel_o);
	endproperty
	assert property(af_p3733);

	property af_p3734;
	@(posedge wb_clk_i) ((t6_wb_sel_o >= 4) && (t6_wb_sel_o <= 8)) |=> ((t6_wb_sel_o >= 0) && (t6_wb_sel_o <= 15));
	endproperty
	assert property(af_p3734);

	property af_p3735;
	@(posedge wb_clk_i) ((t6_wb_sel_o >= 1) && (t6_wb_sel_o <= 3)) |=> ((t6_wb_sel_o >= 0) && (t6_wb_sel_o <= 15));
	endproperty
	assert property(af_p3735);

	property af_p3736;
	@(posedge wb_clk_i) (t6_wb_stb_o) |-> (!$isunknown(t6_wb_sel_o));
	endproperty
	assert property(af_p3736);

	property af_p3737;
	@(posedge wb_clk_i) (t6_wb_cyc_o) |-> (t6_wb_sel_o == (4'b1111 << t6_wb_adr_o[1:0]));
	endproperty
	assert property(af_p3737);

	property af_p3738;
	@(posedge wb_clk_i) (t6_wb_stb_o && !t6_wb_ack_i) |=> $stable(t6_wb_sel_o);
	endproperty
	assert property(af_p3738);

	property af_p3739;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (t6_wb_sel_o == 4'b0000) until_with (t6_wb_stb_o);
	endproperty
	assert property(af_p3739);

	property af_p3740;
	@(posedge wb_clk_i) (t6_wb_cyc_o && t6_wb_stb_o) |-> ($stable(t6_wb_sel_o) && (t6_wb_sel_o >= 0 && t6_wb_sel_o <= 15));
	endproperty
	assert property(af_p3740);

	property af_p3741;
	@(posedge wb_clk_i) (wb_rst_i) |-> ##1 (t6_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p3741);

	property af_p3742;
	@(posedge wb_clk_i) (!t6_wb_ack_i && t6_wb_cyc_o) |-> $stable(t6_wb_sel_o);
	endproperty
	assert property(af_p3742);

	property af_p3743;
	@(posedge wb_clk_i) (t6_wb_err_i && t6_wb_cyc_o) |-> ##1 (t6_wb_sel_o == 4'b0000 && !t6_wb_cyc_o);
	endproperty
	assert property(af_p3743);

	property af_p3744;
	@(posedge wb_clk_i) (t6_wb_sel_o != $past(t6_wb_sel_o)) |-> $past(!t6_wb_stb_o);
	endproperty
	assert property(af_p3744);

	property af_p3745;
	@(posedge wb_clk_i) (!t6_wb_cyc_o && !t6_wb_stb_o) |-> (t6_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p3745);

	property af_p3746;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 (t6_wb_sel_o >= 0 && t6_wb_sel_o <= 15);
	endproperty
	assert property(af_p3746);

	property af_p3747;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t6_wb_sel_o >= 0 && t6_wb_sel_o <= 15);
	endproperty
	assert property(af_p3747);

	property af_p3748;
	@(posedge wb_clk_i) (t6_wb_cyc_o) |-> (($rose(t6_wb_stb_o) + $fell(t6_wb_stb_o)) <= 1);
	endproperty
	assert property(af_p3748);

	property af_p3749;
	@(posedge wb_clk_i) (t6_wb_stb_o) |-> (t6_wb_sel_o != '0);
	endproperty
	assert property(af_p3749);

	property af_p3750;
	@(posedge wb_clk_i) (t6_wb_ack_i) |=> !t6_wb_stb_o;
	endproperty
	assert property(af_p3750);

	property af_p3751;
	@(posedge wb_clk_i) (t6_wb_stb_o && t6_wb_we_o) |-> $stable(t6_wb_dat_o);
	endproperty
	assert property(af_p3751);

	property af_p3752;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t6_wb_stb_o == 1'b0);
	endproperty
	assert property(af_p3752);

	property af_p3753;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (!$isunknown(t6_wb_stb_o));
	endproperty
	assert property(af_p3753);

	property af_p3754;
	@(posedge wb_clk_i) ($rose(t6_wb_stb_o) && t6_wb_ack_i) |-> ##1 !t6_wb_stb_o;
	endproperty
	assert property(af_p3754);

	property af_p3755;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (t6_wb_stb_o == 1'b0) ##1 (t6_wb_stb_o == 1'b0);
	endproperty
	assert property(af_p3755);

	property af_p3756;
	@(posedge wb_clk_i) (t6_wb_ack_i) |=> (t6_wb_stb_o == 1'b0);
	endproperty
	assert property(af_p3756);

	property af_p3757;
	@(posedge wb_clk_i) (t6_wb_cyc_o && !t6_wb_ack_i) |-> $stable(t6_wb_stb_o);
	endproperty
	assert property(af_p3757);

	property af_p3758;
	@(posedge wb_clk_i) $rose(t6_wb_stb_o) |-> ($stable(t6_wb_adr_o) && !$isunknown(t6_wb_adr_o));
	endproperty
	assert property(af_p3758);

	property af_p3759;
	@(posedge wb_clk_i) (t6_wb_stb_o) |-> $stable(t6_wb_we_o);
	endproperty
	assert property(af_p3759);

	property af_p3760;
	@(posedge wb_clk_i) (t6_wb_stb_o && t6_wb_ack_i) |=> (!t6_wb_stb_o);
	endproperty
	assert property(af_p3760);

	property af_p3761;
	@(posedge wb_clk_i) (t6_wb_err_i) |-> (!t6_wb_stb_o);
	endproperty
	assert property(af_p3761);

	property af_p3762;
	@(posedge wb_clk_i) ($rose(t6_wb_stb_o)) |-> ##1 $stable(t6_wb_stb_o);
	endproperty
	assert property(af_p3762);

	property af_p3763;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t6_wb_stb_o) throughout (wb_rst_i);
	endproperty
	assert property(af_p3763);

	property af_p3764;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t6_wb_stb_o)[*3];
	endproperty
	assert property(af_p3764);

	property af_p3765;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t6_wb_stb_o);
	endproperty
	assert property(af_p3765);

	property af_p3766;
	@(posedge wb_clk_i) (t6_wb_cyc_o) |-> (t6_wb_stb_o);
	endproperty
	assert property(af_p3766);

	property af_p3767;
	@(posedge wb_clk_i) (t6_wb_stb_o) |-> (!$isunknown(t6_wb_adr_o));
	endproperty
	assert property(af_p3767);

	property af_p3768;
	@(posedge wb_clk_i) (!t6_wb_cyc_o) |-> (!t6_wb_stb_o);
	endproperty
	assert property(af_p3768);

	property af_p3769;
	@(posedge wb_clk_i) (t6_wb_cyc_o && t6_wb_stb_o) |-> (t6_wb_stb_o throughout (##[1:$] t6_wb_ack_i));
	endproperty
	assert property(af_p3769);

	property af_p3770;
	@(posedge wb_clk_i) (t6_wb_err_i) |=> (!t6_wb_stb_o);
	endproperty
	assert property(af_p3770);

	property af_p3771;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t6_wb_stb_o;
	endproperty
	assert property(af_p3771);

	property af_p3772;
	@(posedge wb_clk_i) t6_wb_stb_o |-> t6_wb_cyc_o;
	endproperty
	assert property(af_p3772);

	property af_p3773;
	@(posedge wb_clk_i) (t6_wb_stb_o && t6_wb_we_o) |-> ($stable(t6_wb_adr_o) until t6_wb_ack_i);
	endproperty
	assert property(af_p3773);

	property af_p3774;
	@(posedge wb_clk_i) (t6_wb_stb_o && t6_wb_ack_i) |=> !t6_wb_stb_o;
	endproperty
	assert property(af_p3774);

	property af_p3775;
	@(posedge wb_clk_i) t6_wb_stb_o |-> (i0_wb_stb_i || i1_wb_stb_i || i2_wb_stb_i || i3_wb_stb_i || i4_wb_stb_i || i5_wb_stb_i || i6_wb_stb_i || i7_wb_stb_i);
	endproperty
	assert property(af_p3775);

	property af_p3776;
	@(posedge wb_clk_i) t6_wb_stb_o |-> ($stable(t6_wb_we_o) until t6_wb_ack_i);
	endproperty
	assert property(af_p3776);

	property af_p3777;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[0:1] t6_wb_stb_o;
	endproperty
	assert property(af_p3777);

	property af_p3778;
	@(posedge wb_clk_i) t6_wb_stb_o |-> ($stable(t6_wb_dat_o) until t6_wb_ack_i);
	endproperty
	assert property(af_p3778);

	property af_p3779;
	@(posedge wb_clk_i) wb_rst_i |=> !t6_wb_stb_o;
	endproperty
	assert property(af_p3779);

	property af_p3780;
	@(posedge wb_clk_i) t6_wb_stb_o |-> (t6_wb_stb_o until t6_wb_ack_i);
	endproperty
	assert property(af_p3780);

	property af_p3781;
	@(posedge wb_clk_i) (t6_wb_we_o && t6_wb_stb_o) |-> (t6_wb_cyc_o);
	endproperty
	assert property(af_p3781);

	property af_p3782;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> !$isunknown(t6_wb_we_o);
	endproperty
	assert property(af_p3782);

	property af_p3783;
	@(posedge wb_clk_i) (t6_wb_stb_o) |-> !$isunknown(t6_wb_we_o);
	endproperty
	assert property(af_p3783);

	property af_p3784;
	@(posedge wb_clk_i) $fell(t6_wb_cyc_o) |=> (t6_wb_we_o == 1'b0);
	endproperty
	assert property(af_p3784);

	property af_p3785;
	@(posedge wb_clk_i) ($fell(wb_rst_i) ##2 t6_wb_stb_o) |-> ##[0:$] (t6_wb_we_o);
	endproperty
	assert property(af_p3785);

	property af_p3786;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t6_wb_we_o == 1'b0);
	endproperty
	assert property(af_p3786);

	property af_p3787;
	@(posedge wb_clk_i) (t6_wb_we_o) |-> (!$isunknown(t6_wb_dat_o));
	endproperty
	assert property(af_p3787);

	property af_p3788;
	@(posedge wb_clk_i) (t6_wb_we_o) |-> (!$isunknown(t6_wb_adr_o) && (t6_wb_adr_o == 6));
	endproperty
	assert property(af_p3788);

	property af_p3789;
	@(posedge wb_clk_i) (!t6_wb_cyc_o) |-> (t6_wb_we_o == 1'b0);
	endproperty
	assert property(af_p3789);

	property af_p3790;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (t6_wb_we_o == 1'b0);
	endproperty
	assert property(af_p3790);

	property af_p3791;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> !t6_wb_we_o[*2];
	endproperty
	assert property(af_p3791);

	property af_p3792;
	@(posedge wb_clk_i) (t6_wb_cyc_o && !t6_wb_ack_i) |-> $stable(t6_wb_we_o);
	endproperty
	assert property(af_p3792);

	property af_p3793;
	@(posedge wb_clk_i) t6_wb_ack_i |=> !t6_wb_we_o;
	endproperty
	assert property(af_p3793);

	property af_p3794;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> !t6_wb_we_o[*3];
	endproperty
	assert property(af_p3794);

	property af_p3795;
	@(posedge wb_clk_i) wb_rst_i |-> !t6_wb_we_o;
	endproperty
	assert property(af_p3795);

	property af_p3796;
	@(posedge wb_clk_i) !t6_wb_cyc_o |-> $stable(t6_wb_we_o);
	endproperty
	assert property(af_p3796);

	property af_p3797;
	@(posedge wb_clk_i) t6_wb_we_o |-> (t6_wb_cyc_o && t6_wb_stb_o);
	endproperty
	assert property(af_p3797);

	property af_p3798;
	@(posedge wb_clk_i) $rose(t6_wb_cyc_o) |-> (t6_wb_we_o throughout (!t6_wb_ack_i)[*1:$] ##1 t6_wb_ack_i);
	endproperty
	assert property(af_p3798);

	property af_p3799;
	@(posedge wb_clk_i) (t6_wb_we_o) |-> (t6_wb_stb_o);
	endproperty
	assert property(af_p3799);

	property af_p3800;
	@(posedge wb_clk_i) (!t6_wb_cyc_o) |=> (t6_wb_we_o == $past(t6_wb_we_o));
	endproperty
	assert property(af_p3800);

	property af_p3801;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!t6_wb_we_o) ##1 (!t6_wb_we_o);
	endproperty
	assert property(af_p3801);

	property af_p3802;
	@(posedge wb_clk_i) (t6_wb_cyc_o && !t6_wb_ack_i) |=> (t6_wb_we_o == $past(t6_wb_we_o));
	endproperty
	assert property(af_p3802);

	property af_p3803;
	@(posedge wb_clk_i) (t6_wb_we_o) |-> (t6_wb_cyc_o && t6_wb_stb_o);
	endproperty
	assert property(af_p3803);

	property af_p3804;
	@(posedge wb_clk_i) (t6_wb_ack_i) |-> (t6_wb_we_o == $past(t6_wb_we_o));
	endproperty
	assert property(af_p3804);

	property af_p3805;
	@(posedge wb_clk_i) (t6_wb_stb_o && !t6_wb_ack_i) |=> (t6_wb_we_o == $past(t6_wb_we_o));
	endproperty
	assert property(af_p3805);

	property af_p3806;
	@(posedge wb_clk_i) (t6_wb_ack_i) |=> (!t6_wb_we_o);
	endproperty
	assert property(af_p3806);

	property af_p3807;
	@(posedge wb_clk_i) !(t7_wb_err_i && t7_wb_ack_i);
	endproperty
	assert property(af_p3807);

	property af_p3808;
	@(posedge wb_clk_i) ($rose(t7_wb_ack_i)) |=> (!t7_wb_ack_i);
	endproperty
	assert property(af_p3808);

	property af_p3809;
	@(posedge wb_clk_i) (t7_wb_ack_i) |-> (t7_wb_cyc_o && t7_wb_stb_o);
	endproperty
	assert property(af_p3809);

	property af_p3810;
	@(posedge wb_clk_i) !(t7_wb_ack_i && t7_wb_err_i);
	endproperty
	assert property(af_p3810);

	property af_p3811;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t7_wb_ack_i);
	endproperty
	assert property(af_p3811);

	property af_p3812;
	@(posedge wb_clk_i) (t7_wb_sel_o != '1 && t7_wb_cyc_o && t7_wb_stb_o) |=> (t7_wb_ack_i);
	endproperty
	assert property(af_p3812);

	property af_p3813;
	@(posedge wb_clk_i) (!(t7_wb_cyc_o && t7_wb_stb_o)) |-> (!t7_wb_ack_i);
	endproperty
	assert property(af_p3813);

	property af_p3814;
	@(posedge wb_clk_i) ($rose(t7_wb_ack_i) && !t7_wb_stb_o) |=> (!t7_wb_ack_i);
	endproperty
	assert property(af_p3814);

	property af_p3815;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> (!t7_wb_ack_i);
	endproperty
	assert property(af_p3815);


	property af_p3817;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (!t7_wb_ack_i);
	endproperty
	assert property(af_p3817);

	property af_p3818;
	@(posedge wb_clk_i) ($changed(t7_wb_adr_o)) |-> (!t7_wb_ack_i);
	endproperty
	assert property(af_p3818);

	property af_p3819;
	@(posedge wb_clk_i) (t7_wb_cyc_o && t7_wb_stb_o && t7_wb_ack_i) |=> !t7_wb_ack_i;
	endproperty
	assert property(af_p3819);

	property af_p3820;
	@(posedge wb_clk_i) (!t7_wb_cyc_o) |-> (!t7_wb_ack_i);
	endproperty
	assert property(af_p3820);

	property af_p3821;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> (!t7_wb_ack_i)[*2];
	endproperty
	assert property(af_p3821);

	property af_p3822;
	@(posedge wb_clk_i) (!t7_wb_cyc_o) |=> (!t7_wb_ack_i);
	endproperty
	assert property(af_p3822);

	property af_p3823;
	@(posedge wb_clk_i) (t7_wb_ack_i) |-> (!t7_wb_err_i);
	endproperty
	assert property(af_p3823);

	property af_p3824;
	@(posedge wb_clk_i) (t7_wb_ack_i) |-> (!$isunknown(t7_wb_dat_i));
	endproperty
	assert property(af_p3824);

	property af_p3825;
	@(posedge wb_clk_i) (t7_wb_ack_i && t7_wb_we_o) |-> (t7_wb_cyc_o && t7_wb_stb_o);
	endproperty
	assert property(af_p3825);

	property af_p3826;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!t7_wb_ack_i)[*3];
	endproperty
	assert property(af_p3826);

	property af_p3827;
	@(posedge wb_clk_i) (t7_wb_ack_i) |-> (!wb_rst_i && t7_wb_cyc_o && t7_wb_stb_o);
	endproperty
	assert property(af_p3827);

	property af_p3828;
	@(posedge wb_clk_i) $rose(t7_wb_ack_i) |-> $stable(t7_wb_dat_i);
	endproperty
	assert property(af_p3828);

	property af_p3829;
	@(posedge wb_clk_i) (t7_wb_stb_o && t7_wb_cyc_o) |-> ##[1:16] t7_wb_ack_i;
	endproperty
	assert property(af_p3829);

	property af_p3830;
	@(posedge wb_clk_i) (t7_wb_we_o && t7_wb_ack_i) |-> $stable(t7_wb_dat_o);
	endproperty
	assert property(af_p3830);

	property af_p3831;
	@(posedge wb_clk_i) t7_wb_ack_i |-> ($stable(t7_wb_dat_i) && !$isunknown(t7_wb_dat_i));
	endproperty
	assert property(af_p3831);

	property af_p3832;
	@(posedge wb_clk_i) $rose(t7_wb_ack_i) |=> !t7_wb_ack_i;
	endproperty
	assert property(af_p3832);

	property af_p3833;
	@(posedge wb_clk_i) $rose(t7_wb_stb_o) |-> ##[1:4] $rose(t7_wb_ack_i);
	endproperty
	assert property(af_p3833);

	property af_p3834;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (t7_wb_ack_i == 1'b0) throughout (!(t7_wb_cyc_o && t7_wb_stb_o))[->1];
	endproperty
	assert property(af_p3834);

	property af_p3835;
	@(posedge wb_clk_i) wb_rst_i |-> !t7_wb_ack_i;
	endproperty
	assert property(af_p3835);

	property af_p3836;
	@(posedge wb_clk_i) (t7_wb_cyc_o && t7_wb_stb_o) |-> ##[1:4] t7_wb_ack_i;
	endproperty
	assert property(af_p3836);

	property af_p3837;
	@(posedge wb_clk_i) (t7_wb_we_o && t7_wb_stb_o && t7_wb_cyc_o && t7_wb_ack_i) |-> $stable(t7_wb_dat_o);
	endproperty
	assert property(af_p3837);













	property af_p3850;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (t7_wb_adr_o == '0)[*2];
	endproperty
	assert property(af_p3850);

	property af_p3851;
	@(posedge wb_clk_i) $changed(t7_wb_adr_o) |-> $past(t7_wb_ack_i);
	endproperty
	assert property(af_p3851);

	property af_p3852;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (t7_wb_adr_o !== '{default:'x});
	endproperty
	assert property(af_p3852);

	property af_p3853;
	@(posedge wb_clk_i) (!t7_wb_cyc_o) |=> $stable(t7_wb_adr_o);
	endproperty
	assert property(af_p3853);

	property af_p3854;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t7_wb_adr_o >= 0) && (t7_wb_adr_o <= 32'hFFFFFFFF));
	endproperty
	assert property(af_p3854);

	property af_p3855;
	@(posedge wb_clk_i) $changed(t7_wb_adr_o) |-> (t7_wb_stb_o || $past(t7_wb_stb_o));
	endproperty
	assert property(af_p3855);

	property af_p3856;
	@(posedge wb_clk_i) wb_rst_i |-> $stable(t7_wb_adr_o);
	endproperty
	assert property(af_p3856);

	property af_p3857;
	@(posedge wb_clk_i) (t7_wb_cyc_o && t7_wb_stb_o) |-> (t7_wb_adr_o !== '{default:'x});
	endproperty
	assert property(af_p3857);

	property af_p3858;
	@(posedge wb_clk_i) disable iff (wb_rst_i) (t7_wb_cyc_o) |-> ##[1:3] (t7_wb_adr_o !== '{default:'x});
	endproperty
	assert property(af_p3858);

	property af_p3859;
	@(posedge wb_clk_i) wb_rst_i |-> (t7_wb_adr_o == $past(t7_wb_adr_o));
	endproperty
	assert property(af_p3859);

	property af_p3860;
	@(posedge wb_clk_i) $changed(t7_wb_adr_o) |-> t7_wb_stb_o;
	endproperty
	assert property(af_p3860);

	property af_p3861;
	@(posedge wb_clk_i) (t7_wb_cyc_o && !t7_wb_ack_i) |=> $stable(t7_wb_adr_o);
	endproperty
	assert property(af_p3861);

	property af_p3862;
	@(posedge wb_clk_i) (t7_wb_we_o && !t7_wb_ack_i) |=> $stable(t7_wb_adr_o);
	endproperty
	assert property(af_p3862);

	property af_p3863;
	@(posedge wb_clk_i) t7_wb_stb_o |-> (!$isunknown(t7_wb_adr_o) && $stable(t7_wb_adr_o));
	endproperty
	assert property(af_p3863);

	property af_p3864;
	@(posedge wb_clk_i) t7_wb_cyc_o |-> !$isunknown(t7_wb_adr_o);
	endproperty
	assert property(af_p3864);

	property af_p3865;
	@(posedge wb_clk_i) wb_rst_i |-> (t7_wb_adr_o == '0);
	endproperty
	assert property(af_p3865);

	property af_p3866;
	@(posedge wb_clk_i) ((t7_wb_adr_o >= 0) && (t7_wb_adr_o <= 1023)) |=> (t7_wb_cyc_o -> ((t7_wb_adr_o >= 0) && (t7_wb_adr_o <= 2047)));
	endproperty
	assert property(af_p3866);

	property af_p3867;
	@(posedge wb_clk_i) (t7_wb_stb_o && t7_wb_cyc_o) |-> ($stable(t7_wb_adr_o) throughout (##[0:$] t7_wb_ack_i));
	endproperty
	assert property(af_p3867);

	property af_p3868;
	@(posedge wb_clk_i) t7_wb_ack_i |=> !$isunknown(t7_wb_adr_o);
	endproperty
	assert property(af_p3868);

	property af_p3869;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] !$isunknown(t7_wb_adr_o);
	endproperty
	assert property(af_p3869);

	property af_p3870;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> !t7_wb_cyc_o;
	endproperty
	assert property(af_p3870);

	property af_p3871;
	@(posedge wb_clk_i) ($rose(t7_wb_cyc_o) ##1 t7_wb_ack_i) |-> ##1 !t7_wb_cyc_o;
	endproperty
	assert property(af_p3871);

	property af_p3872;
	@(posedge wb_clk_i) $rose(t7_wb_cyc_o) |-> (t7_wb_cyc_o throughout (!(t7_wb_ack_i || t7_wb_err_i))[*0:$]) ##1 (t7_wb_ack_i || t7_wb_err_i) ##1 !t7_wb_cyc_o;
	endproperty
	assert property(af_p3872);

	property af_p3873;
	@(posedge wb_clk_i) t7_wb_cyc_o |-> $stable(t7_wb_adr_o);
	endproperty
	assert property(af_p3873);

	property af_p3874;
	@(posedge wb_clk_i) $rose(t7_wb_cyc_o) |-> (t7_wb_cyc_o throughout (!t7_wb_ack_i)[*0:$]) ##1 t7_wb_ack_i;
	endproperty
	assert property(af_p3874);

	property af_p3875;
	@(posedge wb_clk_i) $rose(t7_wb_cyc_o) |-> (t7_wb_cyc_o throughout (!t7_wb_ack_i && !t7_wb_err_i)[*0:$]) ##1 (t7_wb_ack_i || t7_wb_err_i);
	endproperty
	assert property(af_p3875);

	property af_p3876;
	@(posedge wb_clk_i) t7_wb_ack_i |-> ##1 !t7_wb_cyc_o;
	endproperty
	assert property(af_p3876);

	property af_p3877;
	@(posedge wb_clk_i) $fell(t7_wb_cyc_o) |-> !$rose(t7_wb_cyc_o);
	endproperty
	assert property(af_p3877);

	property af_p3878;
	@(posedge wb_clk_i) $changed(t7_wb_cyc_o) |-> ##1 $stable(t7_wb_cyc_o);
	endproperty
	assert property(af_p3878);

	property af_p3879;
	@(posedge wb_clk_i) t7_wb_stb_o |-> t7_wb_cyc_o;
	endproperty
	assert property(af_p3879);

	property af_p3880;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> !t7_wb_cyc_o [*2];
	endproperty
	assert property(af_p3880);

	property af_p3881;
	@(posedge wb_clk_i) (t7_wb_cyc_o && t7_wb_err_i) |=> (!t7_wb_cyc_o);
	endproperty
	assert property(af_p3881);

	property af_p3882;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!t7_wb_cyc_o)[*4];
	endproperty
	assert property(af_p3882);

	property af_p3883;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t7_wb_cyc_o);
	endproperty
	assert property(af_p3883);

	property af_p3884;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!t7_wb_cyc_o) ##1 (!t7_wb_cyc_o) ##1 (!t7_wb_cyc_o);
	endproperty
	assert property(af_p3884);

	property af_p3885;
	@(posedge wb_clk_i) (t7_wb_cyc_o && $past(t7_wb_cyc_o)) |-> ($stable(t7_wb_we_o));
	endproperty
	assert property(af_p3885);

	property af_p3886;
	@(posedge wb_clk_i) (t7_wb_cyc_o) |-> (t7_wb_stb_o);
	endproperty
	assert property(af_p3886);

	property af_p3887;
	@(posedge wb_clk_i) (t7_wb_stb_o) |-> (t7_wb_cyc_o);
	endproperty
	assert property(af_p3887);

	property af_p3888;
	@(posedge wb_clk_i) (t7_wb_err_i) |=> (!t7_wb_cyc_o);
	endproperty
	assert property(af_p3888);

	property af_p3889;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!t7_wb_cyc_o)[*3];
	endproperty
	assert property(af_p3889);

	property af_p3890;
	@(posedge wb_clk_i) ($fell(t7_wb_cyc_o)) |-> (!t7_wb_stb_o);
	endproperty
	assert property(af_p3890);

	property af_p3891;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> (!t7_wb_cyc_o) ##1 (!t7_wb_cyc_o);
	endproperty
	assert property(af_p3891);

	property af_p3892;
	@(posedge wb_clk_i) (t7_wb_cyc_o && t7_wb_err_i) |=> !t7_wb_cyc_o;
	endproperty
	assert property(af_p3892);

	property af_p3893;
	@(posedge wb_clk_i) (t7_wb_cyc_o && t7_wb_ack_i) ##1 !t7_wb_cyc_o |-> ##[1:$] t7_wb_cyc_o;
	endproperty
	assert property(af_p3893);

	property af_p3894;
	@(posedge wb_clk_i) t7_wb_ack_i |-> $past(t7_wb_cyc_o);
	endproperty
	assert property(af_p3894);

	property af_p3895;
	@(posedge wb_clk_i) $rose(t7_wb_cyc_o) |-> ($stable(t7_wb_sel_o) throughout t7_wb_cyc_o);
	endproperty
	assert property(af_p3895);

	property af_p3896;
	@(posedge wb_clk_i) $rose(t7_wb_cyc_o) |-> (t7_wb_cyc_o throughout (t7_wb_ack_i[->1])) ##1 !t7_wb_cyc_o;
	endproperty
	assert property(af_p3896);

	property af_p3897;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t7_wb_cyc_o)[*3];
	endproperty
	assert property(af_p3897);

	property af_p3898;
	@(posedge wb_clk_i) !t7_wb_cyc_o |-> !t7_wb_stb_o;
	endproperty
	assert property(af_p3898);

	property af_p3899;
	@(posedge wb_clk_i) t7_wb_cyc_o |-> (t7_wb_we_o === 1'b0 || t7_wb_we_o === 1'b1);
	endproperty
	assert property(af_p3899);

	property af_p3900;
	@(posedge wb_clk_i) $rose(t7_wb_cyc_o) |-> ($stable(t7_wb_adr_o) throughout t7_wb_cyc_o);
	endproperty
	assert property(af_p3900);

	property af_p3901;
	@(posedge wb_clk_i) disable iff (wb_rst_i) ((t7_wb_dat_i >= 0) && (t7_wb_dat_i <= 255));
	endproperty
	assert property(af_p3901);

	property af_p3902;
	@(posedge wb_clk_i) (t7_wb_stb_o && t7_wb_cyc_o && t7_wb_ack_i) |-> ##1 ((t7_wb_dat_i >= 0) && (t7_wb_dat_i <= 255));
	endproperty
	assert property(af_p3902);

	property af_p3903;
	@(posedge wb_clk_i) (t7_wb_ack_i) |-> ##1 ((t7_wb_dat_i >= 10) && (t7_wb_dat_i <= 245)) ##1 ((t7_wb_dat_i >= 10) && (t7_wb_dat_i <= 245));
	endproperty
	assert property(af_p3903);

	property af_p3904;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 ((t7_wb_dat_i >= 0) && (t7_wb_dat_i <= 127));
	endproperty
	assert property(af_p3904);

	property af_p3905;
	@(posedge wb_clk_i) (!t7_wb_we_o && t7_wb_ack_i) |-> ((t7_wb_dat_i >= 0) && (t7_wb_dat_i <= 255));
	endproperty
	assert property(af_p3905);

	property af_p3906;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 ((t7_wb_dat_i >= 0) && (t7_wb_dat_i <= 10));
	endproperty
	assert property(af_p3906);

	property af_p3907;
	@(posedge wb_clk_i) ((t7_wb_dat_i >= 200) && (t7_wb_dat_i <= 255)) |-> ##1 ((t7_wb_dat_i >= 175) && (t7_wb_dat_i <= 255));
	endproperty
	assert property(af_p3907);

	property af_p3908;
	@(posedge wb_clk_i) ((t7_wb_dat_i >= 200) && (t7_wb_dat_i <= 255)) |-> ##1 ((t7_wb_dat_i >= 180) && (t7_wb_dat_i <= 255));
	endproperty
	assert property(af_p3908);

	property af_p3909;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 ((t7_wb_dat_i >= 0) && (t7_wb_dat_i <= 60));
	endproperty
	assert property(af_p3909);

	property af_p3910;
	@(posedge wb_clk_i) (t7_wb_ack_i) |-> ((t7_wb_dat_i >= 0) && (t7_wb_dat_i <= 255));
	endproperty
	assert property(af_p3910);

	property af_p3911;
	@(posedge wb_clk_i) (t7_wb_ack_i) |-> $stable(t7_wb_dat_i);
	endproperty
	assert property(af_p3911);

	property af_p3912;
	@(posedge wb_clk_i) (!t7_wb_we_o && (t7_wb_dat_i >= 1) && (t7_wb_dat_i <= 128)) |-> ((t7_wb_dat_i >= 1 && t7_wb_dat_i <= 128) until t7_wb_ack_i);
	endproperty
	assert property(af_p3912);

	property af_p3913;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((t7_wb_dat_i >= 0) && (t7_wb_dat_i <= 63));
	endproperty
	assert property(af_p3913);

	property af_p3914;
	@(posedge wb_clk_i) (!t7_wb_we_o && (t7_wb_dat_i >= 50) && (t7_wb_dat_i <= 100)) |=> ((t7_wb_dat_i >= 30) && (t7_wb_dat_i <= 120));
	endproperty
	assert property(af_p3914);

	property af_p3915;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t7_wb_dat_i == 0);
	endproperty
	assert property(af_p3915);

	property af_p3916;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 ((t7_wb_dat_i >= 0) && (t7_wb_dat_i <= 63));
	endproperty
	assert property(af_p3916);

	property af_p3917;
	@(posedge wb_clk_i) (t7_wb_err_i) |=> 1'b1;
	endproperty
	assert property(af_p3917);

	property af_p3918;
	@(posedge wb_clk_i) ($fell(t7_wb_cyc_o)) |=> 1'b1;
	endproperty
	assert property(af_p3918);

	property af_p3919;
	@(posedge wb_clk_i) (t7_wb_ack_i) |-> (t7_wb_cyc_o && t7_wb_stb_o);
	endproperty
	assert property(af_p3919);

	property af_p3920;
	@(posedge wb_clk_i) (t7_wb_err_i) |-> 1'b1;
	endproperty
	assert property(af_p3920);

	property af_p3921;
	@(posedge wb_clk_i) ((t7_wb_dat_i >= 100) && (t7_wb_dat_i <= 150)) |=> ((t7_wb_dat_i >= 75) && (t7_wb_dat_i <= 175));
	endproperty
	assert property(af_p3921);

	property af_p3922;
	@(posedge wb_clk_i) ((t7_wb_dat_i >= 100) && (t7_wb_dat_i <= 150)) |=> ((t7_wb_dat_i >= 80) && (t7_wb_dat_i <= 150));
	endproperty
	assert property(af_p3922);

	property af_p3923;
	@(posedge wb_clk_i) (wb_rst_i) |=> ((t7_wb_dat_i >= 0) && (t7_wb_dat_i <= 255));
	endproperty
	assert property(af_p3923);

	property af_p3924;
	@(posedge wb_clk_i) (t7_wb_dat_i != $past(t7_wb_dat_i)) |-> ($past(t7_wb_cyc_o) && $past(t7_wb_stb_o));
	endproperty
	assert property(af_p3924);

	property af_p3925;
	@(posedge wb_clk_i) (t7_wb_cyc_o && t7_wb_stb_o) |-> !$isunknown(t7_wb_dat_i);
	endproperty
	assert property(af_p3925);

	property af_p3926;
	@(posedge wb_clk_i) (t7_wb_dat_i != $past(t7_wb_dat_i)) |-> $past(t7_wb_cyc_o);
	endproperty
	assert property(af_p3926);

	property af_p3927;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t7_wb_dat_i >= 50) && (t7_wb_dat_i <= 200));
	endproperty
	assert property(af_p3927);

	property af_p3928;
	@(posedge wb_clk_i) (t7_wb_ack_i) |-> (t7_wb_dat_i == t7_wb_adr_o);
	endproperty
	assert property(af_p3928);

	property af_p3929;
	@(posedge wb_clk_i) (t7_wb_cyc_o && t7_wb_stb_o && !t7_wb_ack_i) |=> $stable(t7_wb_dat_i);
	endproperty
	assert property(af_p3929);

	property af_p3930;
	@(posedge wb_clk_i) $rose(t7_wb_stb_o) |-> ##[1:2] ((t7_wb_dat_i >= 20) && (t7_wb_dat_i <= 235));
	endproperty
	assert property(af_p3930);

	property af_p3931;
	@(posedge wb_clk_i) ((t7_wb_dat_i >= 128) && (t7_wb_dat_i <= 200)) |=> ((t7_wb_dat_i >= 100) && (t7_wb_dat_i <= 220));
	endproperty
	assert property(af_p3931);

	property af_p3932;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:3] ((t7_wb_dat_i >= 0) && (t7_wb_dat_i <= 255));
	endproperty
	assert property(af_p3932);

	property af_p3933;
	@(posedge wb_clk_i) (!$stable(t7_wb_dat_o)) |-> (t7_wb_ack_i);
	endproperty
	assert property(af_p3933);

	property af_p3934;
	@(posedge wb_clk_i) (!t7_wb_cyc_o) |-> $stable(t7_wb_dat_o);
	endproperty
	assert property(af_p3934);

	property af_p3935;
	@(posedge wb_clk_i) (t7_wb_cyc_o && t7_wb_stb_o) |-> ((t7_wb_dat_o >= 0) && (t7_wb_dat_o <= 255));
	endproperty
	assert property(af_p3935);

	property af_p3936;
	@(posedge wb_clk_i) (!t7_wb_ack_i) |-> $stable(t7_wb_dat_o);
	endproperty
	assert property(af_p3936);

	property af_p3937;
	@(posedge wb_clk_i) (t7_wb_cyc_o && t7_wb_stb_o && !t7_wb_we_o) |-> ((t7_wb_dat_o >= 0) && (t7_wb_dat_o <= 255));
	endproperty
	assert property(af_p3937);

	property af_p3938;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t7_wb_dat_o >= 50) && (t7_wb_dat_o <= 200));
	endproperty
	assert property(af_p3938);

	property af_p3939;
	@(posedge wb_clk_i) (wb_rst_i) |=> (t7_wb_dat_o == 8'h00);
	endproperty
	assert property(af_p3939);

	property af_p3940;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##5 ((t7_wb_dat_o >= 0) && (t7_wb_dat_o <= 255));
	endproperty
	assert property(af_p3940);

	property af_p3941;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((t7_wb_dat_o >= 0) && (t7_wb_dat_o <= 255));
	endproperty
	assert property(af_p3941);

	property af_p3942;
	@(posedge wb_clk_i) ((t7_wb_dat_o >= 200) && (t7_wb_dat_o <= 255)) |-> ##1 ((t7_wb_dat_o >= 180) && (t7_wb_dat_o <= 255));
	endproperty
	assert property(af_p3942);

	property af_p3943;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t7_wb_dat_o >= 0) && (t7_wb_dat_o <= 255));
	endproperty
	assert property(af_p3943);

	property af_p3944;
	@(posedge wb_clk_i) ((t7_wb_dat_o >= 138) && (t7_wb_dat_o <= 153)) |=> (t7_wb_dat_o >= 98) && (t7_wb_dat_o <= 200);
	endproperty
	assert property(af_p3944);

	property af_p3945;
	@(posedge wb_clk_i) (!t7_wb_cyc_o) |-> (!$isunknown(t7_wb_dat_o));
	endproperty
	assert property(af_p3945);

	property af_p3946;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ##4 ((t7_wb_dat_o >= 0) && (t7_wb_dat_o <= 255));
	endproperty
	assert property(af_p3946);

	property af_p3947;
	@(posedge wb_clk_i) (!t7_wb_stb_o) |=> ($stable(t7_wb_dat_o));
	endproperty
	assert property(af_p3947);

	property af_p3948;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t7_wb_dat_o == 0);
	endproperty
	assert property(af_p3948);

	property af_p3949;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t7_wb_dat_o >= 0) && (t7_wb_dat_o <= 255);
	endproperty
	assert property(af_p3949);

	property af_p3950;
	@(posedge wb_clk_i) ((t7_wb_dat_o >= 100) && (t7_wb_dat_o <= 150)) |=> (t7_wb_dat_o >= 80) && (t7_wb_dat_o <= 170);
	endproperty
	assert property(af_p3950);

	property af_p3951;
	@(posedge wb_clk_i) ((t7_wb_dat_o >= 200) && (t7_wb_dat_o <= 255)) |=> (t7_wb_dat_o >= 150) && (t7_wb_dat_o <= 255);
	endproperty
	assert property(af_p3951);

	property af_p3952;
	@(posedge wb_clk_i) (t7_wb_err_i) |=> ($stable(t7_wb_dat_o));
	endproperty
	assert property(af_p3952);

	property af_p3953;
	@(posedge wb_clk_i) t7_wb_ack_i |-> ##[1:2] ((t7_wb_dat_o >= 0) && (t7_wb_dat_o <= 255));
	endproperty
	assert property(af_p3953);

	property af_p3954;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##5 ((t7_wb_dat_o >= 0) && (t7_wb_dat_o <= 255))[*1:$];
	endproperty
	assert property(af_p3954);

	property af_p3955;
	@(posedge wb_clk_i) ((t7_wb_dat_o >= 50) && (t7_wb_dat_o <= 100)) |=> (((t7_wb_dat_o >= 30) && (t7_wb_dat_o <= 120)) ##1 ((t7_wb_dat_o >= 30) && (t7_wb_dat_o <= 120)));
	endproperty
	assert property(af_p3955);

	property af_p3956;
	@(posedge wb_clk_i) (t7_wb_cyc_o && t7_wb_stb_o && !t7_wb_we_o) |=> ((t7_wb_dat_o >= 0) && (t7_wb_dat_o <= 255));
	endproperty
	assert property(af_p3956);

	property af_p3957;
	@(posedge wb_clk_i) (t7_wb_ack_i && !t7_wb_we_o) |-> $stable(t7_wb_dat_o);
	endproperty
	assert property(af_p3957);

	property af_p3958;
	@(posedge wb_clk_i) t7_wb_ack_i |-> $stable(t7_wb_dat_o);
	endproperty
	assert property(af_p3958);

	property af_p3959;
	@(posedge wb_clk_i) ((t7_wb_dat_o >= 0) && (t7_wb_dat_o <= 50) && t7_wb_stb_o) |=> ((t7_wb_dat_o >= 0) && (t7_wb_dat_o <= 100));
	endproperty
	assert property(af_p3959);

	property af_p3960;
	@(posedge wb_clk_i) $rose(t7_wb_ack_i) |=> $stable(t7_wb_dat_o);
	endproperty
	assert property(af_p3960);

	property af_p3961;
	@(posedge wb_clk_i) ((t7_wb_dat_o >= 100) && (t7_wb_dat_o <= 150)) |=> ((t7_wb_dat_o >= 80) && (t7_wb_dat_o <= 150));
	endproperty
	assert property(af_p3961);

	property af_p3962;
	@(posedge wb_clk_i) $rose(!wb_rst_i) |=> $stable(t7_wb_dat_o);
	endproperty
	assert property(af_p3962);

	property af_p3963;
	@(posedge wb_clk_i) ($rose(t7_wb_err_i)) |-> (t7_wb_cyc_o && t7_wb_stb_o);
	endproperty
	assert property(af_p3963);

	property af_p3964;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (t7_wb_err_i == 1'b0);
	endproperty
	assert property(af_p3964);

	property af_p3965;
	@(posedge wb_clk_i) (t7_wb_err_i) |-> (t7_wb_stb_o && !$isunknown(t7_wb_adr_o));
	endproperty
	assert property(af_p3965);

	property af_p3966;
	@(posedge wb_clk_i) not (t7_wb_err_i && t7_wb_ack_i);
	endproperty
	assert property(af_p3966);

	property af_p3967;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t7_wb_err_i == 1'b0);
	endproperty
	assert property(af_p3967);

	property af_p3968;
	@(posedge wb_clk_i) (t7_wb_err_i) |=> (!t7_wb_err_i);
	endproperty
	assert property(af_p3968);

	property af_p3969;
	@(posedge wb_clk_i) t7_wb_err_i |=> (t7_wb_sel_o == '0);
	endproperty
	assert property(af_p3969);

	property af_p3970;
	@(posedge wb_clk_i) t7_wb_err_i |-> t7_wb_cyc_o;
	endproperty
	assert property(af_p3970);

	property af_p3971;
	@(posedge wb_clk_i) wb_rst_i |-> !t7_wb_err_i;
	endproperty
	assert property(af_p3971);

	property af_p3972;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (!t7_wb_err_i)[*4];
	endproperty
	assert property(af_p3972);

	property af_p3973;
	@(posedge wb_clk_i) t7_wb_err_i |=> !t7_wb_cyc_o;
	endproperty
	assert property(af_p3973);

	property af_p3974;
	@(posedge wb_clk_i) t7_wb_err_i |-> ##[1:2] !t7_wb_cyc_o;
	endproperty
	assert property(af_p3974);

	property af_p3975;
	@(posedge wb_clk_i) (t7_wb_err_i && t7_wb_we_o) |=> $stable(t7_wb_dat_o);
	endproperty
	assert property(af_p3975);

	property af_p3976;
	@(posedge wb_clk_i) (t7_wb_err_i && t7_wb_we_o) |-> (!t7_wb_ack_i);
	endproperty
	assert property(af_p3976);

	property af_p3977;
	@(posedge wb_clk_i) (t7_wb_err_i) |-> (t7_wb_stb_o);
	endproperty
	assert property(af_p3977);

	property af_p3978;
	@(posedge wb_clk_i) (!t7_wb_stb_o) |-> ($stable(t7_wb_err_i));
	endproperty
	assert property(af_p3978);

	property af_p3979;
	@(posedge wb_clk_i) (!t7_wb_cyc_o && t7_wb_err_i) |=> (!t7_wb_err_i);
	endproperty
	assert property(af_p3979);

	property af_p3980;
	@(posedge wb_clk_i) (t7_wb_err_i) |-> (t7_wb_cyc_o && t7_wb_stb_o);
	endproperty
	assert property(af_p3980);

	property af_p3981;
	@(posedge wb_clk_i) (1'b1) |-> (!t7_wb_err_i);
	endproperty
	assert property(af_p3981);

	property af_p3982;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t7_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p3982);

	property af_p3983;
	@(posedge wb_clk_i) (($past(t7_wb_sel_o) == 4'b0000) && (t7_wb_sel_o != 4'b0000)) |-> ($rose(t7_wb_cyc_o));
	endproperty
	assert property(af_p3983);

	property af_p3984;
	@(posedge wb_clk_i) ($past(t7_wb_cyc_o) && t7_wb_cyc_o) |-> (t7_wb_sel_o == $past(t7_wb_sel_o));
	endproperty
	assert property(af_p3984);

	property af_p3985;
	@(posedge wb_clk_i) (t7_wb_stb_o) |-> (!$isunknown(t7_wb_sel_o) && (t7_wb_sel_o != 4'b0000));
	endproperty
	assert property(af_p3985);

	property af_p3986;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t7_wb_sel_o >= 4'd0 && t7_wb_sel_o <= 4'd15);
	endproperty
	assert property(af_p3986);

	property af_p3987;
	@(posedge wb_clk_i) (t7_wb_stb_o && !t7_wb_ack_i) |-> (t7_wb_sel_o == $past(t7_wb_sel_o));
	endproperty
	assert property(af_p3987);

	property af_p3988;
	@(posedge wb_clk_i) (t7_wb_stb_o && (t7_wb_we_o || !t7_wb_we_o)) |-> (t7_wb_sel_o != 4'b0000);
	endproperty
	assert property(af_p3988);

	property af_p3989;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (!$isunknown(t7_wb_sel_o));
	endproperty
	assert property(af_p3989);

	property af_p3990;
	@(posedge wb_clk_i) (t7_wb_stb_o && t7_wb_we_o) |-> (t7_wb_sel_o != 4'b0000);
	endproperty
	assert property(af_p3990);

	property af_p3991;
	@(posedge wb_clk_i) ($changed(t7_wb_sel_o)) |-> ($rose(wb_clk_i));
	endproperty
	assert property(af_p3991);

	property af_p3992;
	@(posedge wb_clk_i) (t7_wb_we_o) |-> (t7_wb_sel_o >= 1) && (t7_wb_sel_o <= 15);
	endproperty
	assert property(af_p3992);

	property af_p3993;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |=> (t7_wb_sel_o == '0);
	endproperty
	assert property(af_p3993);

	property af_p3994;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t7_wb_sel_o == '0);
	endproperty
	assert property(af_p3994);

	property af_p3995;
	@(posedge wb_clk_i) (t7_wb_stb_o) |=> (t7_wb_sel_o != '0);
	endproperty
	assert property(af_p3995);

	property af_p3996;
	@(posedge wb_clk_i) (t7_wb_cyc_o && $past(t7_wb_cyc_o)) |-> $stable(t7_wb_sel_o);
	endproperty
	assert property(af_p3996);

	property af_p3997;
	@(posedge wb_clk_i) ($fell(t7_wb_cyc_o)) |=> (t7_wb_sel_o == '0);
	endproperty
	assert property(af_p3997);

	property af_p3998;
	@(posedge wb_clk_i) (t7_wb_ack_i) |-> $stable(t7_wb_sel_o);
	endproperty
	assert property(af_p3998);

	property af_p3999;
	@(posedge wb_clk_i) (t7_wb_cyc_o) |-> $stable(t7_wb_sel_o);
	endproperty
	assert property(af_p3999);

	property af_p4000;
	@(posedge wb_clk_i) (t7_wb_cyc_o && t7_wb_stb_o) |-> $stable(t7_wb_sel_o);
	endproperty
	assert property(af_p4000);

	property af_p4001;
	@(posedge wb_clk_i) (t7_wb_cyc_o && t7_wb_stb_o && !t7_wb_ack_i) |-> $stable(t7_wb_sel_o);
	endproperty
	assert property(af_p4001);

	property af_p4002;
	@(posedge wb_clk_i) $fell(t7_wb_cyc_o) |-> ##1 (t7_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p4002);

	property af_p4003;
	@(posedge wb_clk_i) (!t7_wb_stb_o) |-> (t7_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p4003);

	property af_p4004;
	@(posedge wb_clk_i) (t7_wb_we_o) |-> $stable(t7_wb_sel_o);
	endproperty
	assert property(af_p4004);

	property af_p4005;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (t7_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p4005);

	property af_p4006;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (t7_wb_sel_o inside {[0:15]});
	endproperty
	assert property(af_p4006);

	property af_p4007;
	@(posedge wb_clk_i) (t7_wb_stb_o) |-> (t7_wb_sel_o inside {[0:15]});
	endproperty
	assert property(af_p4007);

	property af_p4008;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 (t7_wb_sel_o inside {[0:15]});
	endproperty
	assert property(af_p4008);

	property af_p4009;
	@(posedge wb_clk_i) (t7_wb_cyc_o) |-> (t7_wb_sel_o !== 4'bxxxx);
	endproperty
	assert property(af_p4009);

	property af_p4010;
	@(posedge wb_clk_i) (wb_rst_i) |-> !t7_wb_stb_o;
	endproperty
	assert property(af_p4010);

	property af_p4011;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t7_wb_stb_o);
	endproperty
	assert property(af_p4011);

	property af_p4012;
	@(posedge wb_clk_i) (t7_wb_stb_o) |-> ($stable(t7_wb_adr_o) && !$isunknown(t7_wb_adr_o));
	endproperty
	assert property(af_p4012);

	property af_p4013;
	@(posedge wb_clk_i) (t7_wb_stb_o) |-> (!$isunknown(t7_wb_adr_o));
	endproperty
	assert property(af_p4013);

	property af_p4014;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!t7_wb_stb_o[*3]);
	endproperty
	assert property(af_p4014);

	property af_p4015;
	@(posedge wb_clk_i) (t7_wb_ack_i) |=> (!t7_wb_stb_o);
	endproperty
	assert property(af_p4015);

	property af_p4016;
	@(posedge wb_clk_i) (t7_wb_err_i) |-> (!t7_wb_stb_o);
	endproperty
	assert property(af_p4016);

	property af_p4017;
	@(posedge wb_clk_i) (t7_wb_stb_o) |-> (t7_wb_stb_o s_until (t7_wb_ack_i || t7_wb_err_i));
	endproperty
	assert property(af_p4017);

	property af_p4018;
	@(posedge wb_clk_i) (t7_wb_stb_o && t7_wb_ack_i) |=> (!t7_wb_stb_o || (t7_wb_stb_o && t7_wb_cyc_o));
	endproperty
	assert property(af_p4018);

	property af_p4019;
	@(posedge wb_clk_i) (t7_wb_cyc_o) |-> ($stable(t7_wb_stb_o) && $stable(t7_wb_we_o));
	endproperty
	assert property(af_p4019);

	property af_p4020;
	@(posedge wb_clk_i) (t7_wb_err_i) |=> (!t7_wb_stb_o);
	endproperty
	assert property(af_p4020);

	property af_p4021;
	@(posedge wb_clk_i) (wb_rst_i) |=> (!t7_wb_stb_o);
	endproperty
	assert property(af_p4021);

	property af_p4022;
	@(posedge wb_clk_i) t7_wb_stb_o |-> ($past(!wb_rst_i) && !wb_rst_i);
	endproperty
	assert property(af_p4022);

	property af_p4023;
	@(posedge wb_clk_i) (t7_wb_stb_o && t7_wb_err_i) |-> (!t7_wb_stb_o or ##1 !t7_wb_stb_o);
	endproperty
	assert property(af_p4023);

	property af_p4024;
	@(posedge wb_clk_i) wb_rst_i |-> $stable(t7_wb_stb_o);
	endproperty
	assert property(af_p4024);

	property af_p4025;
	@(posedge wb_clk_i) wb_rst_i |-> !t7_wb_stb_o;
	endproperty
	assert property(af_p4025);

	property af_p4026;
	@(posedge wb_clk_i) (t7_wb_stb_o && !t7_wb_ack_i) |=> t7_wb_stb_o;
	endproperty
	assert property(af_p4026);

	property af_p4027;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> !t7_wb_stb_o;
	endproperty
	assert property(af_p4027);

	property af_p4028;
	@(posedge wb_clk_i) $rose(t7_wb_stb_o) |-> $past(t7_wb_cyc_o);
	endproperty
	assert property(af_p4028);

	property af_p4029;
	@(posedge wb_clk_i) $fell(t7_wb_stb_o) |=> !t7_wb_stb_o;
	endproperty
	assert property(af_p4029);

	property af_p4030;
	@(posedge wb_clk_i) $rose(t7_wb_ack_i) |=> !t7_wb_stb_o;
	endproperty
	assert property(af_p4030);

	property af_p4031;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t7_wb_stb_o ##1 !t7_wb_stb_o);
	endproperty
	assert property(af_p4031);

	property af_p4032;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:3] (!t7_wb_stb_o || t7_wb_cyc_o);
	endproperty
	assert property(af_p4032);

	property af_p4033;
	@(posedge wb_clk_i) !(t7_wb_stb_o && wb_rst_i);
	endproperty
	assert property(af_p4033);

	property af_p4034;
	@(posedge wb_clk_i) $rose(t7_wb_stb_o) |-> !$isunknown(t7_wb_adr_o);
	endproperty
	assert property(af_p4034);

	property af_p4035;
	@(posedge wb_clk_i) $rose(t7_wb_stb_o) |-> (t7_wb_stb_o throughout (t7_wb_ack_i || t7_wb_err_i)[->1]);
	endproperty
	assert property(af_p4035);

	property af_p4036;
	@(posedge wb_clk_i) t7_wb_stb_o |-> t7_wb_cyc_o;
	endproperty
	assert property(af_p4036);

	property af_p4037;
	@(posedge wb_clk_i) (!t7_wb_cyc_o) |-> $stable(t7_wb_stb_o);
	endproperty
	assert property(af_p4037);

	property af_p4038;
	@(posedge wb_clk_i) t7_wb_stb_o |-> ($stable(t7_wb_stb_o) && $stable(t7_wb_we_o));
	endproperty
	assert property(af_p4038);

	property af_p4039;
	@(posedge wb_clk_i) ($rose(t7_wb_we_o)) |-> (t7_wb_we_o throughout (!t7_wb_ack_i)[*1:$] ##1 t7_wb_ack_i);
	endproperty
	assert property(af_p4039);

	property af_p4040;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t7_wb_we_o == 1'b0);
	endproperty
	assert property(af_p4040);

	property af_p4041;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> (t7_wb_we_o == 1'b0);
	endproperty
	assert property(af_p4041);

	property af_p4042;
	@(posedge wb_clk_i) (t7_wb_stb_o && !t7_wb_ack_i) |-> ($stable(t7_wb_we_o));
	endproperty
	assert property(af_p4042);

	property af_p4043;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##2 (t7_wb_we_o == 1'b1);
	endproperty
	assert property(af_p4043);

	property af_p4044;
	@(posedge wb_clk_i) (t7_wb_we_o) |-> (t7_wb_cyc_o);
	endproperty
	assert property(af_p4044);

	property af_p4045;
	@(posedge wb_clk_i) (t7_wb_ack_i) |=> (t7_wb_we_o == 1'b0);
	endproperty
	assert property(af_p4045);

	property af_p4046;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (t7_wb_we_o == 1'b0) throughout (!t7_wb_we_o)[*1:$];
	endproperty
	assert property(af_p4046);

	property af_p4047;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (t7_wb_we_o == 1'b0)[*2];
	endproperty
	assert property(af_p4047);

	property af_p4048;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t7_wb_we_o == 1'b0) throughout (!t7_wb_stb_o)[*1:$];
	endproperty
	assert property(af_p4048);

	property af_p4049;
	@(posedge wb_clk_i) (!t7_wb_cyc_o) |-> (t7_wb_we_o == 1'b0);
	endproperty
	assert property(af_p4049);

	property af_p4050;
	@(posedge wb_clk_i) t7_wb_we_o |-> (t7_wb_cyc_o && t7_wb_stb_o);
	endproperty
	assert property(af_p4050);

	property af_p4051;
	@(posedge wb_clk_i) (t7_wb_ack_i && !t7_wb_we_o) |-> (t7_wb_we_o == 1'b0);
	endproperty
	assert property(af_p4051);

	property af_p4052;
	@(posedge wb_clk_i) 1'b1 |-> $stable(t7_wb_we_o) or $changed(t7_wb_we_o);
	endproperty
	assert property(af_p4052);

	property af_p4053;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (t7_wb_we_o == 1'b0) ##1 (t7_wb_we_o == 1'b0) ##1 (t7_wb_we_o == 1'b0);
	endproperty
	assert property(af_p4053);

	property af_p4054;
	@(posedge wb_clk_i) $changed(t7_wb_we_o) |-> (t7_wb_we_o === 1'b0 || t7_wb_we_o === 1'b1);
	endproperty
	assert property(af_p4054);

	property af_p4055;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (t7_wb_we_o == 1'b0);
	endproperty
	assert property(af_p4055);

	property af_p4056;
	@(posedge wb_clk_i) (!t7_wb_stb_o) |=> $stable(t7_wb_we_o);
	endproperty
	assert property(af_p4056);

	property af_p4057;
	@(posedge wb_clk_i) t7_wb_err_i |-> ((t7_wb_we_o == 1'b0) or ##1 (t7_wb_we_o == 1'b0));
	endproperty
	assert property(af_p4057);

	property af_p4058;
	@(posedge wb_clk_i) $rose(t7_wb_we_o) |-> (t7_wb_we_o throughout (t7_wb_we_o[->1] ##0 !t7_wb_ack_i[*0:$] ##1 t7_wb_ack_i));
	endproperty
	assert property(af_p4058);

	property af_p4059;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (t7_wb_we_o == 1'b0) ##1 (t7_wb_we_o == 1'b0);
	endproperty
	assert property(af_p4059);

	property af_p4060;
	@(posedge wb_clk_i) $rose(t7_wb_we_o) |-> t7_wb_we_o throughout (!t7_wb_ack_i)[*1:$] ##1 t7_wb_ack_i;
	endproperty
	assert property(af_p4060);

	property af_p4061;
	@(posedge wb_clk_i) (i0_wb_cyc_i && t7_wb_cyc_o) |-> (t7_wb_we_o == i0_wb_we_i);
	endproperty
	assert property(af_p4061);

	property af_p4062;
	@(posedge wb_clk_i) t7_wb_cyc_o |-> $stable(t7_wb_we_o) or $changed(t7_wb_we_o) == 1'b0;
	endproperty
	assert property(af_p4062);

	property af_p4063;
	@(posedge wb_clk_i) (t7_wb_we_o && $stable(t7_wb_adr_o)) |-> ##1 t7_wb_we_o;
	endproperty
	assert property(af_p4063);

	property af_p4064;
	@(posedge wb_clk_i) (!i0_wb_stb_i && !i7_wb_stb_i) |-> !t7_wb_we_o;
	endproperty
	assert property(af_p4064);

	property af_p4065;
	@(posedge wb_clk_i) (t7_wb_stb_o && t7_wb_ack_i) |-> (t7_wb_we_o == 1'b1) or (t7_wb_we_o == 1'b0);
	endproperty
	assert property(af_p4065);

	property af_p4066;
	@(posedge wb_clk_i) (t7_wb_cyc_o && !t7_wb_ack_i) |-> $stable(t7_wb_we_o);
	endproperty
	assert property(af_p4066);

	property af_p4067;
	@(posedge wb_clk_i) !t7_wb_cyc_o |-> !t7_wb_we_o;
	endproperty
	assert property(af_p4067);

	property af_p4068;
	@(posedge wb_clk_i) $rose(t7_wb_we_o) |-> ##1 $stable(t7_wb_we_o);
	endproperty
	assert property(af_p4068);

	property af_p4069;
	@(posedge wb_clk_i) t7_wb_we_o |-> t7_wb_stb_o;
	endproperty
	assert property(af_p4069);


	property af_p4071;
	@(posedge wb_clk_i) (t8_wb_ack_i && !t8_wb_we_o) |-> !$isunknown(t8_wb_dat_i);
	endproperty
	assert property(af_p4071);

	property af_p4072;
	@(posedge wb_clk_i) $fell(t8_wb_stb_o) |=> (t8_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p4072);

	property af_p4073;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> ##1 (t8_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p4073);

	property af_p4074;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (t8_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p4074);

	property af_p4075;
	@(posedge wb_clk_i) ($isunknown(t8_wb_adr_o) || !$stable(t8_wb_adr_o)) |-> (t8_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p4075);

	property af_p4076;
	@(posedge wb_clk_i) !(t8_wb_ack_i && t8_wb_err_i);
	endproperty
	assert property(af_p4076);

	property af_p4077;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t8_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p4077);

	property af_p4078;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (t8_wb_ack_i == 1'b0) throughout (!(t8_wb_cyc_o && t8_wb_stb_o))[*0:$];
	endproperty
	assert property(af_p4078);

	property af_p4079;
	@(posedge wb_clk_i) (t8_wb_ack_i && !t8_wb_cyc_o) |=> (t8_wb_ack_i == 1'b0);
	endproperty
	assert property(af_p4079);

	property af_p4080;
	@(posedge wb_clk_i) (t8_wb_ack_i && t8_wb_we_o) |-> t8_wb_we_o;
	endproperty
	assert property(af_p4080);

	property af_p4081;
	@(posedge wb_clk_i) (t8_wb_we_o && t8_wb_ack_i) |-> ##1 $stable(t8_wb_dat_o);
	endproperty
	assert property(af_p4081);

	property af_p4082;
	@(posedge wb_clk_i) t8_wb_stb_o |-> ##[1:16] t8_wb_ack_i;
	endproperty
	assert property(af_p4082);

	property af_p4083;
	@(posedge wb_clk_i) $fell(t8_wb_cyc_o) |=> !t8_wb_ack_i;
	endproperty
	assert property(af_p4083);

	property af_p4084;
	@(posedge wb_clk_i) t8_wb_ack_i |-> (t8_wb_cyc_o && t8_wb_stb_o);
	endproperty
	assert property(af_p4084);

	property af_p4085;
	@(posedge wb_clk_i) (|t8_wb_sel_o && t8_wb_ack_i) |-> !$isunknown(t8_wb_dat_i);
	endproperty
	assert property(af_p4085);

	property af_p4086;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_stb_o) |-> ##[1:16] t8_wb_ack_i;
	endproperty
	assert property(af_p4086);

	property af_p4087;
	@(posedge wb_clk_i) t8_wb_ack_i |-> ##1 !t8_wb_ack_i;
	endproperty
	assert property(af_p4087);

	property af_p4088;
	@(posedge wb_clk_i) (t8_wb_we_o && t8_wb_ack_i) |-> $stable(t8_wb_dat_o);
	endproperty
	assert property(af_p4088);

	property af_p4089;
	@(posedge wb_clk_i) (!t8_wb_cyc_o) |-> (!t8_wb_ack_i);
	endproperty
	assert property(af_p4089);

	property af_p4090;
	@(posedge wb_clk_i) (!t8_wb_we_o && t8_wb_ack_i) |-> ($stable(t8_wb_dat_i) && !$isunknown(t8_wb_dat_i));
	endproperty
	assert property(af_p4090);

	property af_p4091;
	@(posedge wb_clk_i) (t8_wb_stb_o) |-> ##[1:16] (t8_wb_ack_i);
	endproperty
	assert property(af_p4091);

	property af_p4092;
	@(posedge wb_clk_i) (t8_wb_stb_o) |-> ($rose(t8_wb_ack_i) ##1 $fell(t8_wb_ack_i)) or (!$past(t8_wb_ack_i) && !t8_wb_ack_i);
	endproperty
	assert property(af_p4092);

	property af_p4093;
	@(posedge wb_clk_i) (t8_wb_ack_i) |=> (!t8_wb_ack_i);
	endproperty
	assert property(af_p4093);



	property af_p4096;
	@(posedge wb_clk_i) (t8_wb_ack_i) |-> (t8_wb_cyc_o);
	endproperty
	assert property(af_p4096);

	property af_p4097;
	@(posedge wb_clk_i) (t8_wb_ack_i) |-> ($stable(t8_wb_dat_i) && !$isunknown(t8_wb_dat_i));
	endproperty
	assert property(af_p4097);

	property af_p4098;
	@(posedge wb_clk_i) (t8_wb_ack_i) |=> (!t8_wb_stb_o);
	endproperty
	assert property(af_p4098);

	property af_p4099;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_stb_o) |-> (!$isunknown(t8_wb_adr_o) && !$isunknown(t8_wb_sel_o));
	endproperty
	assert property(af_p4099);

	property af_p4100;
	@(posedge wb_clk_i) (!$stable(t8_wb_adr_o)) |-> $past(t8_wb_ack_i);
	endproperty
	assert property(af_p4100);

	property af_p4101;
	@(posedge wb_clk_i) $rose(wb_rst_i) |=> (t8_wb_adr_o == '0);
	endproperty
	assert property(af_p4101);

	property af_p4102;
	@(posedge wb_clk_i) (t8_wb_err_i) |-> $stable(t8_wb_adr_o);
	endproperty
	assert property(af_p4102);

	property af_p4103;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_stb_o && !t8_wb_ack_i) |=> $stable(t8_wb_adr_o);
	endproperty
	assert property(af_p4103);

	property af_p4104;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (!$isunknown(t8_wb_adr_o) && $stable(t8_wb_adr_o));
	endproperty
	assert property(af_p4104);

	property af_p4105;
	@(posedge wb_clk_i) (t8_wb_we_o && t8_wb_stb_o) |=> $stable(t8_wb_adr_o);
	endproperty
	assert property(af_p4105);

	property af_p4106;
	@(posedge wb_clk_i) (!t8_wb_cyc_o) |=> $stable(t8_wb_adr_o);
	endproperty
	assert property(af_p4106);

	property af_p4107;
	@(posedge wb_clk_i) (t8_wb_we_o && t8_wb_stb_o) |-> $stable(t8_wb_adr_o);
	endproperty
	assert property(af_p4107);

	property af_p4108;
	@(posedge wb_clk_i) (t8_wb_cyc_o && !t8_wb_ack_i) |=> $stable(t8_wb_adr_o);
	endproperty
	assert property(af_p4108);

	property af_p4109;
	@(posedge wb_clk_i) $changed(t8_wb_adr_o) |-> $past(t8_wb_ack_i);
	endproperty
	assert property(af_p4109);

	property af_p4110;
	@(posedge wb_clk_i) wb_rst_i |-> !$isunknown(t8_wb_adr_o);
	endproperty
	assert property(af_p4110);

	property af_p4111;
	@(posedge wb_clk_i) (t8_wb_stb_o && t8_wb_cyc_o && !t8_wb_ack_i) |-> $stable(t8_wb_adr_o);
	endproperty
	assert property(af_p4111);

	property af_p4112;
	@(posedge wb_clk_i) t8_wb_cyc_o |-> $stable(t8_wb_adr_o);
	endproperty
	assert property(af_p4112);

	property af_p4113;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 (!$isunknown(t8_wb_adr_o) && $stable(t8_wb_adr_o));
	endproperty
	assert property(af_p4113);

	property af_p4114;
	@(posedge wb_clk_i) !t8_wb_cyc_o |-> $stable(t8_wb_adr_o);
	endproperty
	assert property(af_p4114);

	property af_p4115;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 !$isunknown(t8_wb_adr_o);
	endproperty
	assert property(af_p4115);

	property af_p4116;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 !$isunknown(t8_wb_adr_o);
	endproperty
	assert property(af_p4116);

	property af_p4117;
	@(posedge wb_clk_i) t8_wb_ack_i |=> (t8_wb_cyc_o |-> $changed(t8_wb_adr_o));
	endproperty
	assert property(af_p4117);

	property af_p4118;
	@(posedge wb_clk_i) wb_rst_i |-> $stable(t8_wb_adr_o);
	endproperty
	assert property(af_p4118);

	property af_p4119;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_stb_o) |-> $stable(t8_wb_adr_o) until_with t8_wb_ack_i;
	endproperty
	assert property(af_p4119);

	property af_p4120;
	@(posedge wb_clk_i) 1'b1 |-> ($stable(t8_wb_adr_o) || $changed(t8_wb_adr_o));
	endproperty
	assert property(af_p4120);

	property af_p4121;
	@(posedge wb_clk_i) $changed(t8_wb_we_o) |-> $stable(t8_wb_adr_o);
	endproperty
	assert property(af_p4121);

	property af_p4122;
	@(posedge wb_clk_i) t8_wb_stb_o |-> $stable(t8_wb_adr_o) until_with t8_wb_ack_i;
	endproperty
	assert property(af_p4122);

	property af_p4123;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !$isunknown(t8_wb_adr_o);
	endproperty
	assert property(af_p4123);

	property af_p4124;
	@(posedge wb_clk_i) t8_wb_stb_o |-> $stable(t8_wb_adr_o) until_with (t8_wb_ack_i || t8_wb_err_i);
	endproperty
	assert property(af_p4124);

	property af_p4125;
	@(posedge wb_clk_i) !t8_wb_stb_o |-> $stable(t8_wb_adr_o);
	endproperty
	assert property(af_p4125);

	property af_p4126;
	@(posedge wb_clk_i) wb_rst_i |-> (t8_wb_adr_o == '0);
	endproperty
	assert property(af_p4126);

	property af_p4127;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (t8_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p4127);

	property af_p4128;
	@(posedge wb_clk_i) (t8_wb_cyc_o) |-> $stable(t8_wb_adr_o);
	endproperty
	assert property(af_p4128);

	property af_p4129;
	@(posedge wb_clk_i) (t8_wb_cyc_o) |-> (t8_wb_cyc_o throughout (t8_wb_ack_i[->1]));
	endproperty
	assert property(af_p4129);

	property af_p4130;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> (t8_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p4130);

	property af_p4131;
	@(posedge wb_clk_i) ($fell(t8_wb_cyc_o)) |=> (t8_wb_cyc_o || !t8_wb_cyc_o);
	endproperty
	assert property(af_p4131);

	property af_p4132;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t8_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p4132);

	property af_p4133;
	@(posedge wb_clk_i) (t8_wb_stb_o && t8_wb_cyc_o) |-> (t8_wb_cyc_o throughout (t8_wb_stb_o[->1] ##0 (t8_wb_ack_i or t8_wb_err_i)));
	endproperty
	assert property(af_p4133);

	property af_p4134;
	@(posedge wb_clk_i) (t8_wb_stb_o) |-> (t8_wb_cyc_o);
	endproperty
	assert property(af_p4134);

	property af_p4135;
	@(posedge wb_clk_i) ($rose(t8_wb_err_i)) |=> (t8_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p4135);

	property af_p4136;
	@(posedge wb_clk_i) ($rose(t8_wb_cyc_o)) |-> (t8_wb_cyc_o throughout (##1 1'b1));
	endproperty
	assert property(af_p4136);

	property af_p4137;
	@(posedge wb_clk_i) (t8_wb_cyc_o) |-> ($stable(t8_wb_adr_o) throughout t8_wb_cyc_o);
	endproperty
	assert property(af_p4137);

	property af_p4138;
	@(posedge wb_clk_i) t8_wb_ack_i |=> !t8_wb_cyc_o;
	endproperty
	assert property(af_p4138);

	property af_p4139;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_we_o && !t8_wb_ack_i) |-> $stable(t8_wb_dat_o);
	endproperty
	assert property(af_p4139);

	property af_p4140;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_ack_i) |=> !t8_wb_cyc_o;
	endproperty
	assert property(af_p4140);

	property af_p4141;
	@(posedge wb_clk_i) t8_wb_cyc_o |-> $stable(t8_wb_we_o);
	endproperty
	assert property(af_p4141);

	property af_p4142;
	@(posedge wb_clk_i) $rose(t8_wb_cyc_o) |-> (t8_wb_cyc_o until t8_wb_ack_i);
	endproperty
	assert property(af_p4142);

	property af_p4143;
	@(posedge wb_clk_i) t8_wb_err_i |-> !t8_wb_cyc_o;
	endproperty
	assert property(af_p4143);

	property af_p4144;
	@(posedge wb_clk_i) wb_rst_i |-> !t8_wb_cyc_o;
	endproperty
	assert property(af_p4144);

	property af_p4145;
	@(posedge wb_clk_i) t8_wb_cyc_o |-> ($stable(t8_wb_adr_o) until t8_wb_ack_i);
	endproperty
	assert property(af_p4145);

	property af_p4146;
	@(posedge wb_clk_i) wb_rst_i |=> !t8_wb_cyc_o;
	endproperty
	assert property(af_p4146);

	property af_p4147;
	@(posedge wb_clk_i) t8_wb_cyc_o |-> ($stable(t8_wb_we_o) until t8_wb_ack_i);
	endproperty
	assert property(af_p4147);

	property af_p4148;
	@(posedge wb_clk_i) (t8_wb_ack_i) |=> !t8_wb_cyc_o;
	endproperty
	assert property(af_p4148);


	property af_p4150;
	@(posedge wb_clk_i) (t8_wb_cyc_o && !t8_wb_ack_i && !t8_wb_err_i) |=> (t8_wb_cyc_o == $past(t8_wb_cyc_o));
	endproperty
	assert property(af_p4150);

	property af_p4151;
	@(posedge wb_clk_i) (t8_wb_cyc_o) |-> (t8_wb_stb_o);
	endproperty
	assert property(af_p4151);

	property af_p4152;
	@(posedge wb_clk_i) (t8_wb_cyc_o) |-> (t8_wb_sel_o == $past(t8_wb_sel_o));
	endproperty
	assert property(af_p4152);

	property af_p4153;
	@(posedge wb_clk_i) (t8_wb_err_i) |=> !t8_wb_cyc_o;
	endproperty
	assert property(af_p4153);

	property af_p4154;
	@(posedge wb_clk_i) (t8_wb_stb_o && !t8_wb_ack_i) |-> (t8_wb_cyc_o == $past(t8_wb_cyc_o));
	endproperty
	assert property(af_p4154);

	property af_p4155;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t8_wb_cyc_o[*2];
	endproperty
	assert property(af_p4155);

	property af_p4156;
	@(posedge wb_clk_i) (wb_rst_i && t8_wb_stb_o) |-> !t8_wb_cyc_o;
	endproperty
	assert property(af_p4156);

	property af_p4157;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_stb_o && t8_wb_ack_i) |=> (t8_wb_stb_o |-> t8_wb_cyc_o);
	endproperty
	assert property(af_p4157);

	property af_p4158;
	@(posedge wb_clk_i) (wb_rst_i) |-> !t8_wb_cyc_o;
	endproperty
	assert property(af_p4158);

	property af_p4159;
	@(posedge wb_clk_i) (t8_wb_stb_o && (t8_wb_dat_i >= 50) && (t8_wb_dat_i <= 75)) |-> ##1 (t8_wb_dat_i >= 40) && (t8_wb_dat_i <= 90);
	endproperty
	assert property(af_p4159);

	property af_p4160;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_stb_o) |-> !$isunknown(t8_wb_dat_i) && (t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255);
	endproperty
	assert property(af_p4160);

	property af_p4161;
	@(posedge wb_clk_i) (t8_wb_sel_o && (t8_wb_dat_i >= 120) && (t8_wb_dat_i <= 140)) |-> ##1 (t8_wb_dat_i >= 100) && (t8_wb_dat_i <= 160);
	endproperty
	assert property(af_p4161);

	property af_p4162;
	@(posedge wb_clk_i) (!wb_rst_i && (t8_wb_dat_i >= 200) && (t8_wb_dat_i <= 255)) |-> ##1 (!wb_rst_i) |-> (t8_wb_dat_i >= 175) && (t8_wb_dat_i <= 255);
	endproperty
	assert property(af_p4162);

	property af_p4163;
	@(posedge wb_clk_i) ((t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255)) |-> ##1 (t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255);
	endproperty
	assert property(af_p4163);

	property af_p4164;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255));
	endproperty
	assert property(af_p4164);

	property af_p4165;
	@(posedge wb_clk_i) (t8_wb_stb_o && (t8_wb_dat_i >= 100) && (t8_wb_dat_i <= 150)) |-> ##1 (t8_wb_dat_i >= 80) && (t8_wb_dat_i <= 175);
	endproperty
	assert property(af_p4165);

	property af_p4166;
	@(posedge wb_clk_i) (t8_wb_cyc_o && !t8_wb_ack_i) |-> $stable(t8_wb_dat_i);
	endproperty
	assert property(af_p4166);

	property af_p4167;
	@(posedge wb_clk_i) ((t8_wb_dat_i >= 100) && (t8_wb_dat_i <= 200)) |-> (t8_wb_dat_i >= 80) && (t8_wb_dat_i <= 220);
	endproperty
	assert property(af_p4167);

	property af_p4168;
	@(posedge wb_clk_i) (t8_wb_stb_o && !t8_wb_ack_i) |-> $stable(t8_wb_dat_i) && (t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255);
	endproperty
	assert property(af_p4168);

	property af_p4169;
	@(posedge wb_clk_i) ($fell(wb_rst_i) && !t8_wb_we_o) |-> ##3 ((t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255));
	endproperty
	assert property(af_p4169);

	property af_p4170;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_stb_o && (t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255) && t8_wb_ack_i) |=> ((t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255));
	endproperty
	assert property(af_p4170);

	property af_p4171;
	@(posedge wb_clk_i) (!t8_wb_we_o && t8_wb_ack_i) |-> ((t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255));
	endproperty
	assert property(af_p4171);

	property af_p4172;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255));
	endproperty
	assert property(af_p4172);

	property af_p4173;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_ack_i) |-> !$isunknown(t8_wb_dat_i);
	endproperty
	assert property(af_p4173);

	property af_p4174;
	@(posedge wb_clk_i) (!t8_wb_ack_i) |-> $stable(t8_wb_dat_i);
	endproperty
	assert property(af_p4174);

	property af_p4175;
	@(posedge wb_clk_i) (t8_wb_ack_i) |-> ##1 ((t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255)) ##1 ((t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255));
	endproperty
	assert property(af_p4175);

	property af_p4176;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 ((t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 127));
	endproperty
	assert property(af_p4176);

	property af_p4177;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:2] ((t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255));
	endproperty
	assert property(af_p4177);

	property af_p4178;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 45));
	endproperty
	assert property(af_p4178);

	property af_p4179;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255));
	endproperty
	assert property(af_p4179);

	property af_p4180;
	@(posedge wb_clk_i) (!t8_wb_ack_i) |=> $stable(t8_wb_dat_i);
	endproperty
	assert property(af_p4180);

	property af_p4181;
	@(posedge wb_clk_i) ((t8_wb_dat_i >= 100) && (t8_wb_dat_i <= 200)) |=> ((t8_wb_dat_i >= 50) && (t8_wb_dat_i <= 200));
	endproperty
	assert property(af_p4181);

	property af_p4182;
	@(posedge wb_clk_i) (t8_wb_cyc_o && !t8_wb_ack_i) |-> ($stable(t8_wb_dat_i) && (t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255));
	endproperty
	assert property(af_p4182);

	property af_p4183;
	@(posedge wb_clk_i) (!t8_wb_we_o) |=> ((t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255));
	endproperty
	assert property(af_p4183);

	property af_p4184;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> !$isunknown(t8_wb_dat_i);
	endproperty
	assert property(af_p4184);

	property af_p4185;
	@(posedge wb_clk_i) (!wb_rst_i && !t8_wb_we_o) |-> ((t8_wb_dat_i >= 0) && (t8_wb_dat_i <= 255));
	endproperty
	assert property(af_p4185);

	property af_p4186;
	@(posedge wb_clk_i) ((t8_wb_dat_o >= 100) && (t8_wb_dat_o <= 255)) |=> ((t8_wb_dat_o >= 80) && (t8_wb_dat_o <= 255));
	endproperty
	assert property(af_p4186);

	property af_p4187;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##3 ((t8_wb_dat_o >= 0) && (t8_wb_dat_o <= 255));
	endproperty
	assert property(af_p4187);

	property af_p4188;
	@(posedge wb_clk_i) (t8_wb_ack_i) |-> $stable(t8_wb_dat_o);
	endproperty
	assert property(af_p4188);

	property af_p4189;
	@(posedge wb_clk_i) (t8_wb_we_o) |-> ($stable(t8_wb_dat_o));
	endproperty
	assert property(af_p4189);

	property af_p4190;
	@(posedge wb_clk_i) (!t8_wb_ack_i) |=> ($stable(t8_wb_dat_o));
	endproperty
	assert property(af_p4190);

	property af_p4191;
	@(posedge wb_clk_i) ((t8_wb_dat_o >= 0) && (t8_wb_dat_o <= 127)) |=> ((t8_wb_dat_o >= 0) && (t8_wb_dat_o <= 255));
	endproperty
	assert property(af_p4191);

	property af_p4192;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 ((t8_wb_dat_o >= 0) && (t8_wb_dat_o <= 45));
	endproperty
	assert property(af_p4192);

	property af_p4193;
	@(posedge wb_clk_i) ($fell(t8_wb_cyc_o)) |=> $stable(t8_wb_dat_o);
	endproperty
	assert property(af_p4193);

	property af_p4194;
	@(posedge wb_clk_i) (!wb_rst_i) |-> ((t8_wb_dat_o >= 0) && (t8_wb_dat_o <= 255));
	endproperty
	assert property(af_p4194);

	property af_p4195;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_stb_o) |-> ((t8_wb_dat_o >= 0) && (t8_wb_dat_o <= 255));
	endproperty
	assert property(af_p4195);

	property af_p4196;
	@(posedge wb_clk_i) ($fell(wb_rst_i) && t8_wb_cyc_o) |-> ##5 ((t8_wb_dat_o >= 20) && (t8_wb_dat_o <= 235));
	endproperty
	assert property(af_p4196);


	property af_p4198;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (t8_wb_dat_o >= 0) && (t8_wb_dat_o <= 255);
	endproperty
	assert property(af_p4198);

	property af_p4199;
	@(posedge wb_clk_i) (t8_wb_ack_i) |-> (t8_wb_dat_o >= 0) && (t8_wb_dat_o <= 255);
	endproperty
	assert property(af_p4199);

	property af_p4200;
	@(posedge wb_clk_i) ((t8_wb_dat_o >= 138) && (t8_wb_dat_o <= 153)) |=> (t8_wb_dat_o >= 98) && (t8_wb_dat_o <= 153);
	endproperty
	assert property(af_p4200);

	property af_p4201;
	@(posedge wb_clk_i) ((t8_wb_dat_o >= 100) && (t8_wb_dat_o <= 150)) |-> ##1 (t8_wb_stb_o) |-> (t8_wb_dat_o >= 90) && (t8_wb_dat_o <= 160);
	endproperty
	assert property(af_p4201);

	property af_p4202;
	@(posedge wb_clk_i) ((t8_wb_dat_o >= 230) && (t8_wb_dat_o <= 255)) |=> (t8_wb_dat_o >= 205) && (t8_wb_dat_o <= 255);
	endproperty
	assert property(af_p4202);

	property af_p4203;
	@(posedge wb_clk_i) (t8_wb_err_i) |=> (t8_wb_dat_o == $past(t8_wb_dat_o));
	endproperty
	assert property(af_p4203);

	property af_p4204;
	@(posedge wb_clk_i) (!t8_wb_we_o && t8_wb_ack_i) |-> (t8_wb_dat_o >= 0) && (t8_wb_dat_o <= 255);
	endproperty
	assert property(af_p4204);

	property af_p4205;
	@(posedge wb_clk_i) disable iff (!t8_wb_sel_o) 1'b1 |-> ((t8_wb_dat_o & ~t8_wb_sel_o) == ($past(t8_wb_dat_o) & ~t8_wb_sel_o));
	endproperty
	assert property(af_p4205);

	property af_p4206;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (t8_wb_dat_o >= 0) && (t8_wb_dat_o <= 200);
	endproperty
	assert property(af_p4206);

	property af_p4207;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t8_wb_dat_o >= 0) && (t8_wb_dat_o <= 255);
	endproperty
	assert property(af_p4207);

	property af_p4208;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t8_wb_dat_o == $past(t8_wb_dat_o));
	endproperty
	assert property(af_p4208);

	property af_p4209;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_ack_i) |-> ((t8_wb_dat_o >= 0) && (t8_wb_dat_o <= 255));
	endproperty
	assert property(af_p4209);

	property af_p4210;
	@(posedge wb_clk_i) (!t8_wb_cyc_o) |-> $stable(t8_wb_dat_o);
	endproperty
	assert property(af_p4210);

	property af_p4211;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t8_wb_dat_o == 0);
	endproperty
	assert property(af_p4211);

	property af_p4212;
	@(posedge wb_clk_i) (t8_wb_cyc_o) |-> (t8_wb_dat_o == t8_wb_adr_o);
	endproperty
	assert property(af_p4212);

	property af_p4213;
	@(posedge wb_clk_i) (t8_wb_stb_o && t8_wb_ack_i) |-> ((t8_wb_dat_o >= 0) && (t8_wb_dat_o <= 255));
	endproperty
	assert property(af_p4213);

	property af_p4214;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##[1:2] (t8_wb_dat_o >= 0) && (t8_wb_dat_o <= 10);
	endproperty
	assert property(af_p4214);

	property af_p4215;
	@(posedge wb_clk_i) disable iff(!(t8_wb_stb_o && t8_wb_cyc_o)) (1) |-> ##1 (t8_wb_dat_o != $past(t8_wb_dat_o)) || (t8_wb_dat_o == $past(t8_wb_dat_o));
	endproperty
	assert property(af_p4215);

	property af_p4216;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 (t8_wb_dat_o >= 0) && (t8_wb_dat_o <= 255);
	endproperty
	assert property(af_p4216);

	property af_p4217;
	@(posedge wb_clk_i) (!t8_wb_we_o && t8_wb_ack_i) |-> (t8_wb_dat_o == t8_wb_dat_i);
	endproperty
	assert property(af_p4217);

	property af_p4218;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_stb_o) |-> $stable(t8_wb_dat_o) && (t8_wb_dat_o >= 0) && (t8_wb_dat_o <= 255);
	endproperty
	assert property(af_p4218);

	property af_p4219;
	@(posedge wb_clk_i) ((t8_wb_dat_o >= 50) && (t8_wb_dat_o <= 150)) |=> (t8_wb_dat_o >= 30) && (t8_wb_dat_o <= 150);
	endproperty
	assert property(af_p4219);

	property af_p4220;
	@(posedge wb_clk_i) (!t8_wb_stb_o) |-> $stable(t8_wb_dat_o);
	endproperty
	assert property(af_p4220);

	property af_p4221;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_stb_o) |=> (t8_wb_err_i == 1'b1);
	endproperty
	assert property(af_p4221);

	property af_p4222;
	@(posedge wb_clk_i) (!t8_wb_stb_o) |=> (t8_wb_err_i == 1'b0);
	endproperty
	assert property(af_p4222);

	property af_p4223;
	@(posedge wb_clk_i) (t8_wb_err_i && t8_wb_cyc_o) |-> (t8_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p4223);

	property af_p4224;
	@(posedge wb_clk_i) (t8_wb_err_i) |=> ($stable(t8_wb_adr_o));
	endproperty
	assert property(af_p4224);

	property af_p4225;
	@(posedge wb_clk_i) disable iff (!wb_rst_i) (t8_wb_ack_i && t8_wb_err_i) |-> ##0 (t8_wb_sel_o == t8_wb_sel_o) && (t8_wb_ack_i != t8_wb_err_i);
	endproperty
	assert property(af_p4225);

	property af_p4226;
	@(posedge wb_clk_i) ($fell(t8_wb_cyc_o)) |=> (t8_wb_err_i == 1'b0);
	endproperty
	assert property(af_p4226);

	property af_p4227;
	@(posedge wb_clk_i) (t8_wb_err_i) |=> (t8_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p4227);

	property af_p4228;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t8_wb_err_i == 1'b0);
	endproperty
	assert property(af_p4228);

	property af_p4229;
	@(posedge wb_clk_i) (t8_wb_err_i) |-> ($past(t8_wb_sel_o) == t8_wb_sel_o);
	endproperty
	assert property(af_p4229);

	property af_p4230;
	@(posedge wb_clk_i) not (t8_wb_err_i && t8_wb_ack_i);
	endproperty
	assert property(af_p4230);

	property af_p4231;
	@(posedge wb_clk_i) (!t8_wb_cyc_o) |-> (t8_wb_err_i == 1'b0);
	endproperty
	assert property(af_p4231);

	property af_p4232;
	@(posedge wb_clk_i) ($rose(!wb_rst_i)) |-> (t8_wb_err_i == 1'b0) [*2];
	endproperty
	assert property(af_p4232);

	property af_p4233;
	@(posedge wb_clk_i) (t8_wb_cyc_o) |-> ($countones({t8_wb_err_i, $past(t8_wb_err_i), $past(t8_wb_err_i,2)}) <= 1) || (t8_wb_err_i == $past(t8_wb_err_i));
	endproperty
	assert property(af_p4233);

	property af_p4234;
	@(posedge wb_clk_i) (t8_wb_err_i && t8_wb_we_o) |=> (!t8_wb_cyc_o);
	endproperty
	assert property(af_p4234);


	property af_p4236;
	@(posedge wb_clk_i) (t8_wb_stb_o && t8_wb_ack_i) |-> (t8_wb_err_i == 1'b0);
	endproperty
	assert property(af_p4236);

	property af_p4237;
	@(posedge wb_clk_i) (t8_wb_err_i) |-> (t8_wb_cyc_o && t8_wb_stb_o);
	endproperty
	assert property(af_p4237);

	property af_p4238;
	@(posedge wb_clk_i) (t8_wb_err_i) |=> (!t8_wb_stb_o);
	endproperty
	assert property(af_p4238);

	property af_p4239;
	@(posedge wb_clk_i) (t8_wb_err_i && t8_wb_we_o) |=> ($stable(t8_wb_dat_o) == 0);
	endproperty
	assert property(af_p4239);

	property af_p4240;
	@(posedge wb_clk_i) !(t8_wb_err_i && t8_wb_ack_i);
	endproperty
	assert property(af_p4240);

	property af_p4241;
	@(posedge wb_clk_i) (t8_wb_err_i && t8_wb_we_o) |=> ($stable(t8_wb_dat_o));
	endproperty
	assert property(af_p4241);

	property af_p4242;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t8_wb_err_i[*4];
	endproperty
	assert property(af_p4242);

	property af_p4243;
	@(posedge wb_clk_i) (t8_wb_err_i) |-> !t8_wb_ack_i;
	endproperty
	assert property(af_p4243);

	property af_p4244;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> !t8_wb_err_i[*5];
	endproperty
	assert property(af_p4244);

	property af_p4245;
	@(posedge wb_clk_i) $rose(t8_wb_err_i) |=> !t8_wb_stb_o;
	endproperty
	assert property(af_p4245);

	property af_p4246;
	@(posedge wb_clk_i) $rose(t8_wb_err_i) |=> ($stable(t8_wb_adr_o) throughout t8_wb_err_i[->1]);
	endproperty
	assert property(af_p4246);

	property af_p4247;
	@(posedge wb_clk_i) (!t8_wb_stb_o) |-> (!t8_wb_err_i);
	endproperty
	assert property(af_p4247);

	property af_p4248;
	@(posedge wb_clk_i) $rose(t8_wb_err_i) |=> !t8_wb_err_i;
	endproperty
	assert property(af_p4248);

	property af_p4249;
	@(posedge wb_clk_i) $fell(wb_rst_i) |=> (t8_wb_err_i === 1'b0 || t8_wb_err_i === 1'b1);
	endproperty
	assert property(af_p4249);

	property af_p4250;
	@(posedge wb_clk_i) ($past(t8_wb_cyc_o) && $past(t8_wb_stb_o) && t8_wb_cyc_o && t8_wb_stb_o) |-> $stable(t8_wb_sel_o);
	endproperty
	assert property(af_p4250);

	property af_p4251;
	@(posedge wb_clk_i) $fell(t8_wb_stb_o) |=> ($stable(t8_wb_sel_o) || t8_wb_stb_o);
	endproperty
	assert property(af_p4251);

	property af_p4252;
	@(posedge wb_clk_i) (t8_wb_stb_o) |-> (t8_wb_sel_o != 4'b0000);
	endproperty
	assert property(af_p4252);

	property af_p4253;
	@(posedge wb_clk_i) $fell(t8_wb_cyc_o) |=> (t8_wb_sel_o inside {[4'b0000:4'b1111]});
	endproperty
	assert property(af_p4253);

	property af_p4254;
	@(posedge wb_clk_i) (t8_wb_ack_i && $fell(t8_wb_cyc_o)) |=> $stable(t8_wb_sel_o);
	endproperty
	assert property(af_p4254);

	property af_p4255;
	@(posedge wb_clk_i) $rose(t8_wb_stb_o) |=> $stable(t8_wb_sel_o);
	endproperty
	assert property(af_p4255);

	property af_p4256;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t8_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p4256);

	property af_p4257;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##[1:2] (t8_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p4257);

	property af_p4258;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] (t8_wb_sel_o inside {[4'b0000:4'b1111]});
	endproperty
	assert property(af_p4258);

	property af_p4259;
	@(posedge wb_clk_i) $fell(t8_wb_cyc_o) |=> (t8_wb_sel_o == 4'b0000);
	endproperty
	assert property(af_p4259);

	property af_p4260;
	@(posedge wb_clk_i) ($past(t8_wb_ack_i) && !t8_wb_stb_o) |-> (t8_wb_sel_o == $past(t8_wb_sel_o));
	endproperty
	assert property(af_p4260);

	property af_p4261;
	@(posedge wb_clk_i) (t8_wb_cyc_o && $past(t8_wb_cyc_o)) |-> $stable(t8_wb_sel_o);
	endproperty
	assert property(af_p4261);

	property af_p4262;
	@(posedge wb_clk_i) (t8_wb_ack_i) |-> $stable(t8_wb_sel_o);
	endproperty
	assert property(af_p4262);

	property af_p4263;
	@(posedge wb_clk_i) (t8_wb_sel_o == i0_wb_sel_i);
	endproperty
	assert property(af_p4263);

	property af_p4264;
	@(posedge wb_clk_i) $changed(t8_wb_adr_o) |-> $changed(t8_wb_sel_o);
	endproperty
	assert property(af_p4264);

	property af_p4265;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_stb_o) |-> (t8_wb_sel_o inside {[4'h0:4'hF]});
	endproperty
	assert property(af_p4265);

	property af_p4266;
	@(posedge wb_clk_i) ($stable(t8_wb_adr_o)) |-> $stable(t8_wb_sel_o);
	endproperty
	assert property(af_p4266);

	property af_p4267;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (t8_wb_sel_o inside {[4'h0:4'hF]});
	endproperty
	assert property(af_p4267);

	property af_p4268;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 (t8_wb_sel_o inside {[4'h0:4'hF]});
	endproperty
	assert property(af_p4268);

	property af_p4269;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t8_wb_sel_o == 4'h0);
	endproperty
	assert property(af_p4269);

	property af_p4270;
	@(posedge wb_clk_i) (t8_wb_we_o || !t8_wb_we_o) |-> (t8_wb_sel_o >= 4'h0 && t8_wb_sel_o <= 4'hF);
	endproperty
	assert property(af_p4270);

	property af_p4271;
	@(posedge wb_clk_i) (t8_wb_cyc_o && !t8_wb_ack_i && !t8_wb_err_i) |-> (!$isunknown(t8_wb_sel_o));
	endproperty
	assert property(af_p4271);

	property af_p4272;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_stb_o && !t8_wb_ack_i) |-> ($stable(t8_wb_sel_o));
	endproperty
	assert property(af_p4272);

	property af_p4273;
	@(posedge wb_clk_i) (t8_wb_sel_o >= 4'h1 && t8_wb_sel_o <= 4'hF) |=> (t8_wb_sel_o >= 4'h0 && t8_wb_sel_o <= 4'hF);
	endproperty
	assert property(af_p4273);

	property af_p4274;
	@(posedge wb_clk_i) (!wb_rst_i) |-> (t8_wb_sel_o >= 4'h0 && t8_wb_sel_o <= 4'hF);
	endproperty
	assert property(af_p4274);

	property af_p4275;
	@(posedge wb_clk_i) (t8_wb_we_o) |-> (t8_wb_sel_o >= 4'h1 && t8_wb_sel_o <= 4'hF);
	endproperty
	assert property(af_p4275);

	property af_p4276;
	@(posedge wb_clk_i) (!t8_wb_stb_o) |-> ($stable(t8_wb_sel_o));
	endproperty
	assert property(af_p4276);

	property af_p4277;
	@(posedge wb_clk_i) (t8_wb_stb_o && !t8_wb_ack_i) |-> ($stable(t8_wb_sel_o));
	endproperty
	assert property(af_p4277);

	property af_p4278;
	@(posedge wb_clk_i) (t8_wb_stb_o && !t8_wb_ack_i) |=> t8_wb_stb_o until (t8_wb_ack_i);
	endproperty
	assert property(af_p4278);

	property af_p4279;
	@(posedge wb_clk_i) (!t8_wb_cyc_o) |-> (!t8_wb_stb_o);
	endproperty
	assert property(af_p4279);

	property af_p4280;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (t8_wb_stb_o |-> $past(t8_wb_cyc_o) && t8_wb_cyc_o);
	endproperty
	assert property(af_p4280);

	property af_p4281;
	@(posedge wb_clk_i) ($rose(t8_wb_err_i)) |=> (t8_wb_stb_o == 1'b0);
	endproperty
	assert property(af_p4281);

	property af_p4282;
	@(posedge wb_clk_i) (t8_wb_stb_o) |-> (t8_wb_cyc_o);
	endproperty
	assert property(af_p4282);

	property af_p4283;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t8_wb_stb_o == 1'b0);
	endproperty
	assert property(af_p4283);

	property af_p4284;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (t8_wb_stb_o == 1'b0) ##1 (t8_wb_stb_o == 1'b0);
	endproperty
	assert property(af_p4284);

	property af_p4285;
	@(posedge wb_clk_i) (t8_wb_stb_o && !t8_wb_ack_i && !t8_wb_err_i) |=> t8_wb_stb_o until (t8_wb_ack_i || t8_wb_err_i);
	endproperty
	assert property(af_p4285);

	property af_p4286;
	@(posedge wb_clk_i) (t8_wb_stb_o) |-> ($stable(t8_wb_adr_o) && !$isunknown(t8_wb_adr_o));
	endproperty
	assert property(af_p4286);

	property af_p4287;
	@(posedge wb_clk_i) (t8_wb_stb_o) |-> $stable(t8_wb_we_o);
	endproperty
	assert property(af_p4287);

	property af_p4288;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t8_wb_stb_o);
	endproperty
	assert property(af_p4288);

	property af_p4289;
	@(posedge wb_clk_i) $rose(t8_wb_stb_o) |-> ##[1:16] (t8_wb_ack_i || t8_wb_err_i);
	endproperty
	assert property(af_p4289);

	property af_p4290;
	@(posedge wb_clk_i) (t8_wb_stb_o && t8_wb_cyc_o) |=> (t8_wb_ack_i || t8_wb_err_i);
	endproperty
	assert property(af_p4290);

	property af_p4291;
	@(posedge wb_clk_i) (t8_wb_stb_o && t8_wb_we_o) |-> $stable(t8_wb_dat_o);
	endproperty
	assert property(af_p4291);

	property af_p4292;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!t8_wb_stb_o) ##1 (!t8_wb_stb_o);
	endproperty
	assert property(af_p4292);

	property af_p4293;
	@(posedge wb_clk_i) t8_wb_ack_i |=> !t8_wb_stb_o;
	endproperty
	assert property(af_p4293);

	property af_p4294;
	@(posedge wb_clk_i) $rose(t8_wb_stb_o) |-> i0_wb_stb_i;
	endproperty
	assert property(af_p4294);

	property af_p4295;
	@(posedge wb_clk_i) (t8_wb_stb_o && !t8_wb_ack_i) |=> t8_wb_stb_o;
	endproperty
	assert property(af_p4295);

	property af_p4296;
	@(posedge wb_clk_i) t8_wb_stb_o |-> $stable(t8_wb_sel_o);
	endproperty
	assert property(af_p4296);

	property af_p4297;
	@(posedge wb_clk_i) (t8_wb_stb_o) |-> ##[0:15] (t8_wb_ack_i || t8_wb_err_i);
	endproperty
	assert property(af_p4297);

	property af_p4298;
	@(posedge wb_clk_i) (t8_wb_stb_o) |-> ($stable(t8_wb_adr_o));
	endproperty
	assert property(af_p4298);

	property af_p4299;
	@(posedge wb_clk_i) (t8_wb_stb_o && t8_wb_we_o) |-> ((t8_wb_stb_o && t8_wb_we_o) throughout (!$isunknown(t8_wb_dat_o))[*1:$]);
	endproperty
	assert property(af_p4299);

	property af_p4300;
	@(posedge wb_clk_i) (wb_rst_i) |=> (!t8_wb_stb_o);
	endproperty
	assert property(af_p4300);

	property af_p4301;
	@(posedge wb_clk_i) (wb_rst_i) |-> ($stable(t8_wb_stb_o));
	endproperty
	assert property(af_p4301);

	property af_p4302;
	@(posedge wb_clk_i) (t8_wb_stb_o) |-> (!wb_rst_i);
	endproperty
	assert property(af_p4302);

	property af_p4303;
	@(posedge wb_clk_i) (t8_wb_we_o) |-> (t8_wb_we_o throughout (!t8_wb_ack_i)[*1:$] ##1 t8_wb_ack_i);
	endproperty
	assert property(af_p4303);

	property af_p4304;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t8_wb_we_o == 1'b0);
	endproperty
	assert property(af_p4304);

	property af_p4305;
	@(posedge wb_clk_i) (t8_wb_we_o && t8_wb_ack_i) |=> (t8_wb_we_o == 1'b0);
	endproperty
	assert property(af_p4305);

	property af_p4306;
	@(posedge wb_clk_i) (t8_wb_we_o) |-> (t8_wb_stb_o && t8_wb_cyc_o);
	endproperty
	assert property(af_p4306);

	property af_p4307;
	@(posedge wb_clk_i) (t8_wb_cyc_o && t8_wb_cyc_o[*1]) |-> $stable(t8_wb_we_o);
	endproperty
	assert property(af_p4307);

	property af_p4308;
	@(posedge wb_clk_i) ($fell(t8_wb_cyc_o)) |=> (t8_wb_we_o == 1'b0);
	endproperty
	assert property(af_p4308);

	property af_p4309;
	@(posedge wb_clk_i) (!t8_wb_cyc_o) |-> (t8_wb_we_o == 1'b0);
	endproperty
	assert property(af_p4309);

	property af_p4310;
	@(posedge wb_clk_i) (t8_wb_stb_o && $past(t8_wb_stb_o)) |-> $stable(t8_wb_we_o);
	endproperty
	assert property(af_p4310);

	property af_p4311;
	@(posedge wb_clk_i) (t8_wb_we_o) |-> (t8_wb_sel_o != 4'b0000);
	endproperty
	assert property(af_p4311);

	property af_p4312;
	@(posedge wb_clk_i) $changed(t8_wb_we_o) |-> $rose(wb_clk_i);
	endproperty
	assert property(af_p4312);

	property af_p4313;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (t8_wb_we_o == 1'b0);
	endproperty
	assert property(af_p4313);

	property af_p4314;
	@(posedge wb_clk_i) (!t8_wb_ack_i) |-> $stable(t8_wb_we_o);
	endproperty
	assert property(af_p4314);

	property af_p4315;
	@(posedge wb_clk_i) (t8_wb_cyc_o && !t8_wb_ack_i) |-> $stable(t8_wb_we_o);
	endproperty
	assert property(af_p4315);

	property af_p4316;
	@(posedge wb_clk_i) (t8_wb_stb_o && !t8_wb_ack_i && !t8_wb_we_o) |-> !t8_wb_we_o;
	endproperty
	assert property(af_p4316);

	property af_p4317;
	@(posedge wb_clk_i) (t8_wb_stb_o && !t8_wb_we_o) |-> !t8_wb_we_o;
	endproperty
	assert property(af_p4317);

	property af_p4318;
	@(posedge wb_clk_i) (wb_rst_i) |-> !t8_wb_we_o;
	endproperty
	assert property(af_p4318);

	property af_p4319;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 $stable(t8_wb_we_o);
	endproperty
	assert property(af_p4319);

	property af_p4320;
	@(posedge wb_clk_i) (t8_wb_we_o) |-> (t8_wb_cyc_o && t8_wb_stb_o);
	endproperty
	assert property(af_p4320);

	property af_p4321;
	@(posedge wb_clk_i) (t8_wb_stb_o && !t8_wb_ack_i) |-> $stable(t8_wb_we_o);
	endproperty
	assert property(af_p4321);

	property af_p4322;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 (t8_wb_we_o === 1'b0 || t8_wb_we_o === 1'b1);
	endproperty
	assert property(af_p4322);

	property af_p4323;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 (t8_wb_we_o === 1'b0 || t8_wb_we_o === 1'b1);
	endproperty
	assert property(af_p4323);

	property af_p4324;
	@(posedge wb_clk_i) (t8_wb_ack_i) |-> ##1 (!t8_wb_stb_o -> !t8_wb_we_o);
	endproperty
	assert property(af_p4324);

	property af_p4325;
	@(posedge wb_clk_i) t8_wb_we_o |-> ($stable(t8_wb_dat_o) until_with t8_wb_ack_i);
	endproperty
	assert property(af_p4325);

	property af_p4326;
	@(posedge wb_clk_i) wb_rst_i |-> (!t8_wb_we_o);
	endproperty
	assert property(af_p4326);

	property af_p4327;
	@(posedge wb_clk_i) (!t8_wb_cyc_o) |=> (!t8_wb_we_o);
	endproperty
	assert property(af_p4327);

	property af_p4328;
	@(posedge wb_clk_i) t8_wb_we_o |-> (t8_wb_stb_o && t8_wb_cyc_o);
	endproperty
	assert property(af_p4328);

	property af_p4329;
	@(posedge wb_clk_i) (t8_wb_we_o && t8_wb_ack_i) |=> (!t8_wb_we_o);
	endproperty
	assert property(af_p4329);

	property af_p4330;
	@(posedge wb_clk_i) t8_wb_we_o |-> ((t8_wb_adr_o !== 'x) && (t8_wb_sel_o != '0));
	endproperty
	assert property(af_p4330);

	property af_p4331;
	@(posedge wb_clk_i) (!$isunknown(t8_wb_dat_o)) |-> t8_wb_we_o;
	endproperty
	assert property(af_p4331);

	property af_p4332;
	@(posedge wb_clk_i) (t8_wb_we_o && t8_wb_ack_i) |=> (t8_wb_we_o === 1'b0 || t8_wb_we_o === 1'b1);
	endproperty
	assert property(af_p4332);

	property af_p4333;
	@(posedge wb_clk_i) wb_rst_i |=> (!t8_wb_we_o);
	endproperty
	assert property(af_p4333);

	property af_p4334;
	@(posedge wb_clk_i) t8_wb_we_o |-> !$isunknown(t8_wb_dat_o);
	endproperty
	assert property(af_p4334);

	property af_p4335;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t8_wb_we_o);
	endproperty
	assert property(af_p4335);

	property af_p4336;
	@(posedge wb_clk_i) (wb_rst_i) |-> ##1 $stable({i0_wb_sel_i, i4_wb_sel_i, i7_wb_sel_i}) || 1'b1;
	endproperty
	assert property(af_p4336);

	property af_p4337;
	@(posedge wb_clk_i) (wb_rst_i) |=> (!t1_wb_stb_o);
	endproperty
	assert property(af_p4337);

	property af_p4338;
	@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!i0_wb_err_o && !i3_wb_err_o && !i7_wb_err_o);
	endproperty
	assert property(af_p4338);


	property af_p4340;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!i6_wb_ack_o && !i6_wb_err_o);
	endproperty
	assert property(af_p4340);

	property af_p4341;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!i0_wb_ack_o && !i1_wb_ack_o && !i2_wb_ack_o && !i7_wb_ack_o);
	endproperty
	assert property(af_p4341);

	property af_p4342;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(t3_wb_ack_i) || 1'b1;
	endproperty
	assert property(af_p4342);

	property af_p4343;
	@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> (t5_wb_sel_o == '0);
	endproperty
	assert property(af_p4343);

	property af_p4344;
	@(posedge wb_clk_i) (wb_rst_i) |=> (!i0_wb_ack_o);
	endproperty
	assert property(af_p4344);

	property af_p4345;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (i0_wb_cyc_i && i0_wb_stb_i) || (!i0_wb_cyc_i && !i0_wb_stb_i);
	endproperty
	assert property(af_p4345);

	property af_p4346;
	@(posedge wb_clk_i) (wb_rst_i) |=> (!i1_wb_err_o);
	endproperty
	assert property(af_p4346);

	property af_p4347;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!i4_wb_err_o);
	endproperty
	assert property(af_p4347);

	property af_p4348;
	@(posedge wb_clk_i) (wb_rst_i) |-> $stable(i5_wb_dat_o);
	endproperty
	assert property(af_p4348);

	property af_p4349;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t0_wb_ack_i && !t3_wb_ack_i && !t8_wb_ack_i);
	endproperty
	assert property(af_p4349);

	property af_p4350;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t0_wb_we_o && !t2_wb_we_o && !t5_wb_we_o && !t8_wb_we_o);
	endproperty
	assert property(af_p4350);

	property af_p4351;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t0_wb_stb_o && !t1_wb_stb_o);
	endproperty
	assert property(af_p4351);

	property af_p4352;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!i2_wb_ack_o);
	endproperty
	assert property(af_p4352);


	property af_p4354;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t7_wb_cyc_o) throughout (wb_rst_i[*1:$] ##1 !wb_rst_i);
	endproperty
	assert property(af_p4354);

	property af_p4355;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t0_wb_cyc_o == 1'b0);
	endproperty
	assert property(af_p4355);

	property af_p4356;
	@(posedge wb_clk_i) $changed(i7_wb_ack_o) |-> ($past(wb_rst_i,1) == 1'b0);
	endproperty
	assert property(af_p4356);

	property af_p4357;
	@(posedge wb_clk_i) (wb_rst_i) |=> (t4_wb_adr_o == '0);
	endproperty
	assert property(af_p4357);

	property af_p4358;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (t0_wb_adr_o !== '0);
	endproperty
	assert property(af_p4358);

	property af_p4359;
	@(posedge wb_clk_i) (wb_rst_i) |-> (t2_wb_we_o == 1'b0);
	endproperty
	assert property(af_p4359);

	property af_p4360;
	@(posedge wb_clk_i) (wb_rst_i) |-> ($stable(i0_wb_dat_o) throughout (wb_rst_i[*1:$] ##1 !wb_rst_i));
	endproperty
	assert property(af_p4360);

	property af_p4361;
	@(posedge wb_clk_i) (wb_rst_i) |-> (!t0_wb_cyc_o && !t4_wb_cyc_o && !t8_wb_cyc_o);
	endproperty
	assert property(af_p4361);

	property af_p4362;
	@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 $isunknown(i0_wb_dat_o) === 1'b0;
	endproperty
	assert property(af_p4362);

	property af_p4363;
	@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!t6_wb_stb_o)[*3];
	endproperty
	assert property(af_p4363);




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
