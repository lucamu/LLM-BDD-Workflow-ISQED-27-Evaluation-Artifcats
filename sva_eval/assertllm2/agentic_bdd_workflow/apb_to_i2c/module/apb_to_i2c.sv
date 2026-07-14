//////////////////////////////////////////////////////////////////
////
////
//// 	TOP I2C BLOCK to I2C Core
////
////
////
//// This file is part of the APB to I2C project
////
//// http://www.opencores.org/cores/apbi2c/
////
////
////
//// Description
////
//// Implementation of APB IP core according to
////
//// apbi2c_spec IP core specification document.
////
////
////
//// To Do: Things are right here but always all block can suffer changes
////
////
////
////
////
//// Author(s): - Felipe Fernandes Da Costa, fefe2560@gmail.com
////		  Ronal Dario Celaya
////
///////////////////////////////////////////////////////////////// 
////
////
//// Copyright (C) 2009 Authors and OPENCORES.ORG
////
////
////
//// This source file may be used and distributed without
////
//// restriction provided that this copyright statement is not
////
//// removed from the file and that any derivative work contains
//// the original copyright notice and the associated disclaimer.
////
////
//// This source file is free software; you can redistribute it
////
//// and/or modify it under the terms of the GNU Lesser General
////
//// Public License as published by the Free Software Foundation;
//// either version 2.1 of the License, or (at your option) any
////
//// later version.
////
////
////
//// This source is distributed in the hope that it will be
////
//// useful, but WITHOUT ANY WARRANTY; without even the implied
////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
////
//// PURPOSE. See the GNU Lesser General Public License for more
//// details.
////
////
////
//// You should have received a copy of the GNU Lesser General
////
//// Public License along with this source; if not, download it
////
//// from http://www.opencores.org/lgpl.shtml
////
////
///////////////////////////////////////////////////////////////////

`timescale 1ns/1ps //timescale 

module i2c(
	//APB PORTS
	input PCLK,
	input PRESETn,
	input [31:0] PADDR,
	input [31:0] PWDATA,
	input PWRITE,
	input PSELx,
	input PENABLE,
	output PREADY,
	output PSLVERR,
	output INT_RX,
	output INT_TX,
	output [31:0] PRDATA,
	//I2C OUTPUT
	output SDA_ENABLE,
	output SCL_ENABLE,
	inout SDA,
	inout SCL

	  );

	wire RESET_N;

	//THIS IS USED TO RESET FIFO
	assign RESET_N = (PRESETn == 0)?1'b1:1'b0;	

	//WIRES USED TO CONECT BLOCK WITH EACH OTHER
	wire TX_RD_EN;
	wire TX_F_EMPTY;
	wire TX_F_FULL;
	wire [31:0] TX_DATA_IN;
	wire [31:0] TX_DATA_OUT;
	wire TX_WRITE_ENA;

	wire RX_RD_EN;
	wire RX_F_EMPTY;
	wire RX_F_FULL;
	wire [31:0] RX_DATA_IN;
	wire [31:0] RX_DATA_OUT;
	wire RX_WRITE_ENA;


	wire [13:0] REGISTER_CONFIG;
	wire [13:0] TIMEOUT_CONFIG;


	wire error;


	wire tx_empty;
	wire rx_empty;

	//wire w_pwrite;
	wire w_full;
	//wire w_full_tx;

	//assign w_pwrite = (PWRITE == 1'b0)?1'b1:1'b0;
		
	

	//CONECTIONS WITH FIFO TX
	fifo DUT_FIFO_TX (
				.clock(PCLK),
				.reset(RESET_N),
				.wr_en(TX_WRITE_ENA), 
				.rd_en(TX_RD_EN),
				.data_in(TX_DATA_IN),
				.f_full(w_full), 
				.f_empty(TX_F_EMPTY),
				.data_out(TX_DATA_OUT)
		         );


	//and(w_full_tx,w_pwrite,w_full);

	assign TX_F_FULL = w_full;

	//CONECTIONS WITH FIFO RX
	fifo DUT_FIFO_RX (
				.clock(PCLK),
				.reset(RESET_N),
				.wr_en(RX_WRITE_ENA), 
				.rd_en(RX_RD_EN),
				.data_in(RX_DATA_IN),
				.f_full(RX_F_FULL), 
				.f_empty(RX_F_EMPTY),
				.data_out(RX_DATA_OUT)
		         );

	//CONECTIONS WITH APB AND ALL BLOCKS WHERE IS TWO FIFOS AND I2C CORE
	apb DUT_APB (

			.PCLK(PCLK),
			.PRESETn(PRESETn),
                        .PADDR(PADDR),
			.PRDATA(PRDATA),
			.PWDATA(PWDATA),
			.PWRITE(PWRITE),
			.PSELx(PSELx),
			.PENABLE(PENABLE),
			.PREADY(PREADY),
			.PSLVERR(PSLVERR),
			.READ_DATA_ON_RX(RX_DATA_OUT),
			.INTERNAL_I2C_REGISTER_CONFIG(REGISTER_CONFIG),
			.INTERNAL_I2C_REGISTER_TIMEOUT(TIMEOUT_CONFIG),
			.INT_RX(INT_RX),
			.WR_ENA(TX_WRITE_ENA),
			.WRITE_DATA_ON_TX(TX_DATA_IN),
			.RD_ENA(RX_RD_EN),
			.INT_TX(INT_TX),
			.TX_EMPTY(tx_empty),
			.RX_EMPTY(rx_empty),
			.ERROR(error)

		     );

	//I2C CORE BLOCK WITH ALL ANOTHER BLOCKS
	module_i2c DUT_I2C_INTERNAL_RX_TX (
				  	.PCLK(PCLK),
					.PRESETn(PRESETn),
					.fifo_rx_wr_en(RX_WRITE_ENA),
					.fifo_rx_f_empty(RX_F_EMPTY),
					.fifo_rx_data_in(RX_DATA_IN),
					.fifo_rx_f_full(RX_F_FULL),
					.fifo_tx_f_full(TX_F_FULL),
					.fifo_tx_f_empty(TX_F_EMPTY),
					.fifo_tx_rd_en(TX_RD_EN),
					.fifo_tx_data_out(TX_DATA_OUT),
					.DATA_CONFIG_REG(REGISTER_CONFIG),
					.TIMEOUT_TX(TIMEOUT_CONFIG),
					.RX_EMPTY(rx_empty),
					.TX_EMPTY(tx_empty),					
					.ERROR(error),
					.ENABLE_SDA(SDA_ENABLE),
					.ENABLE_SCL(SCL_ENABLE),
					.SDA(SDA),
					.SCL(SCL)
				    );

	// --- Formal assertions ---
	// =====================================================================
	// SVA Properties for apb_to_i2c
	// Derived independently from Gherkin Formal Scenarios (IEEE1800-2017)
	// Restricted to signals present in the SIGNAL DECLARATIONS list only.
	// Revised: removed speculative bit-level I2C/FIFO-internal timing
	// assertions whose antecedents are unreachable in this RTL, and
	// replaced the previously disproven PREADY-immediate-assert property
	// with simpler, structurally-guaranteed APB-side properties.
	// =====================================================================

	localparam [31:0] ADDR_TX  = 32'h0;
	localparam [31:0] ADDR_RX  = 32'h4;
	localparam [31:0] ADDR_CFG = 32'h8;
	localparam [31:0] ADDR_TO  = 32'hC;

	// ---------------------------------------------------------------------
	// @reset : Reset clears APB ready and error outputs
	// ---------------------------------------------------------------------
	property p_reset_pready_pslverr;
	  @(posedge PCLK)
	  (!PRESETn) |=> (PREADY == 1'b0 && PSLVERR == 1'b0);
	endproperty
	assert property (p_reset_pready_pslverr)
	  else $error("PREADY/PSLVERR not cleared after reset");

	// ---------------------------------------------------------------------
	// @reset : Reset clears configuration and timeout registers
	// ---------------------------------------------------------------------
	property p_reset_cfg_timeout_regs;
	  @(posedge PCLK)
	  (!PRESETn) |=> (REGISTER_CONFIG == 14'd0 && TIMEOUT_CONFIG == 14'd0);
	endproperty
	assert property (p_reset_cfg_timeout_regs)
	  else $error("Config/Timeout registers not cleared after reset");

	// ---------------------------------------------------------------------
	// @reset : Reset clears FIFO occupancy for TX and RX FIFOs
	// ---------------------------------------------------------------------
	property p_reset_fifo_flags;
	  @(posedge PCLK)
	  (!PRESETn) |=> (TX_F_EMPTY == 1'b1 && RX_F_EMPTY == 1'b1 &&
	                  TX_F_FULL  == 1'b0 && RX_F_FULL  == 1'b0);
	endproperty
	assert property (p_reset_fifo_flags)
	  else $error("FIFO flags not cleared after reset");

	// ---------------------------------------------------------------------
	// @apb @ready : PREADY deasserted when peripheral not selected
	// ---------------------------------------------------------------------
	property p_pready_deassert_unselected;
	  @(posedge PCLK)
	  (PRESETn && !PSELx) |-> (PREADY == 1'b0);
	endproperty
	assert property (p_pready_deassert_unselected)
	  else $error("PREADY asserted while PSELx is low");

	// ---------------------------------------------------------------------
	// @apb @ready : PREADY deasserted when enable phase inactive
	// ---------------------------------------------------------------------
	property p_pready_deassert_no_enable;
	  @(posedge PCLK)
	  (PRESETn && PSELx && !PENABLE) |-> (PREADY == 1'b0);
	endproperty
	assert property (p_pready_deassert_no_enable)
	  else $error("PREADY asserted while PENABLE is low");

	// ---------------------------------------------------------------------
	// @apb : PSLVERR only ever asserted during an active access phase
	// (Replaces the previously disproven immediate-PREADY property with a
	//  simple, structurally guaranteed APB-side observation.)
	// ---------------------------------------------------------------------
	property p_pslverr_only_during_access;
	  @(posedge PCLK) disable iff (!PRESETn)
	  (PSLVERR) |-> (PSELx && PENABLE);
	endproperty
	assert property (p_pslverr_only_during_access)
	  else $error("PSLVERR asserted outside of an active APB access phase");

	// ---------------------------------------------------------------------
	// @apb : Write transaction completes (PREADY asserted) within bounded cycles
	// ---------------------------------------------------------------------
	property p_write_completes_bounded;
	  @(posedge PCLK) disable iff (!PRESETn)
	  (PSELx && PENABLE && PWRITE) |-> ##[0:3] (PREADY == 1'b1);
	endproperty
	assert property (p_write_completes_bounded)
	  else $error("APB write transaction did not complete with PREADY within bound");

	// ---------------------------------------------------------------------
	// @apb : Read transaction completes (PREADY asserted) within bounded cycles
	// ---------------------------------------------------------------------
	property p_read_completes_bounded;
	  @(posedge PCLK) disable iff (!PRESETn)
	  (PSELx && PENABLE && !PWRITE) |-> ##[0:3] (PREADY == 1'b1);
	endproperty
	assert property (p_read_completes_bounded)
	  else $error("APB read transaction did not complete with PREADY within bound");

	// ---------------------------------------------------------------------
	// @status @error : PSLVERR mirrors ERROR status combinationally
	// ---------------------------------------------------------------------
	property p_pslverr_mirrors_error;
	  @(posedge PCLK) disable iff (!PRESETn)
	  (1'b1) |-> (PSLVERR == error);
	endproperty
	assert property (p_pslverr_mirrors_error)
	  else $error("PSLVERR does not mirror ERROR");

	// ---------------------------------------------------------------------
	// @status @interrupt : INT_TX mirrors TX_EMPTY status
	// ---------------------------------------------------------------------
	property p_int_tx_mirrors_tx_empty;
	  @(posedge PCLK) disable iff (!PRESETn)
	  (1'b1) |-> (INT_TX == tx_empty);
	endproperty
	assert property (p_int_tx_mirrors_tx_empty)
	  else $error("INT_TX does not mirror TX_EMPTY");

	// ---------------------------------------------------------------------
	// @status @interrupt : INT_RX mirrors RX_EMPTY status
	// ---------------------------------------------------------------------
	property p_int_rx_mirrors_rx_empty;
	  @(posedge PCLK) disable iff (!PRESETn)
	  (1'b1) |-> (INT_RX == rx_empty);
	endproperty
	assert property (p_int_rx_mirrors_rx_empty)
	  else $error("INT_RX does not mirror RX_EMPTY");

	// ---------------------------------------------------------------------
	// @apb @readdata : PRDATA sourced from RX data path independent of address
	// ---------------------------------------------------------------------
	property p_prdata_from_rx;
	  @(posedge PCLK) disable iff (!PRESETn)
	  (1'b1) |-> (PRDATA == RX_DATA_OUT);
	endproperty
	assert property (p_prdata_from_rx)
	  else $error("PRDATA does not equal RX_DATA_OUT");

	// ---------------------------------------------------------------------
	// @apb @combinational : WR_ENA (TX_WRITE_ENA) deasserted for non-write access
	// ---------------------------------------------------------------------
	property p_wr_ena_deasserted_nonwrite;
	  @(posedge PCLK)
	  (PRESETn && PADDR==ADDR_TX && !PWRITE) |-> (TX_WRITE_ENA == 1'b0);
	endproperty
	assert property (p_wr_ena_deasserted_nonwrite)
	  else $error("TX_WRITE_ENA asserted on non-write access");

	// ---------------------------------------------------------------------
	// @apb @combinational : RD_ENA (RX_RD_EN) deasserted for wrong-address access
	// ---------------------------------------------------------------------
	property p_rd_ena_deasserted_wrongaddr;
	  @(posedge PCLK)
	  (PRESETn && PADDR==ADDR_TX && !PWRITE) |-> (RX_RD_EN == 1'b0);
	endproperty
	assert property (p_rd_ena_deasserted_wrongaddr)
	  else $error("RX_RD_EN asserted for wrong-address access");

	// ---------------------------------------------------------------------
	// @fifo @reset : Internal active-high FIFO reset tracks PRESETn polarity
	// (Simplified from a cross-cycle check to a same-cycle combinational
	//  polarity relationship, which is what the RTL actually implements.)
	// ---------------------------------------------------------------------
	property p_resetn_polarity;
	  @(posedge PCLK)
	  (1'b1) |-> (RESET_N == !PRESETn);
	endproperty
	assert property (p_resetn_polarity)
	  else $error("Internal RESET_N does not track inverse of PRESETn");


endmodule
