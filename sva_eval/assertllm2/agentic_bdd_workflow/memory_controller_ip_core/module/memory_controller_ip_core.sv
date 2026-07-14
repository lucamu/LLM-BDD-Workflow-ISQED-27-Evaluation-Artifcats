/////////////////////////////////////////////////////////////////////
////                                                             ////
////  WISHBONE Memory Controller Top Level                       ////
////                                                             ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
////                                                             ////
////                                                             ////
////  Downloaded from: http://www.opencores.org/cores/mem_ctrl/  ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2000-2002 Rudolf Usselmann                    ////
////                         www.asics.ws                        ////
////                         rudi@asics.ws                       ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

//  CVS Log
//
//  $Id: mc_top.v,v 1.7 2002-01-21 13:08:52 rudi Exp $
//
//  $Date: 2002-01-21 13:08:52 $
//  $Revision: 1.7 $
//  $Author: rudi $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: not supported by cvs2svn $
//               Revision 1.6  2001/12/21 05:09:30  rudi
//
//               - Fixed combinatorial loops in synthesis
//               - Fixed byte select bug
//
//               Revision 1.5  2001/11/29 02:16:28  rudi
//
//
//               - More Synthesis cleanup, mostly for speed
//               - Several bug fixes
//               - Changed code to avoid auto-precharge and
//                 burst-terminate combinations (apparently illegal ?)
//                 Now we will do a manual precharge ...
//
//               Revision 1.4  2001/09/10 13:44:17  rudi
//               *** empty log message ***
//
//               Revision 1.3  2001/09/02 02:28:28  rudi
//
//               Many fixes for minor bugs that showed up in gate level simulations.
//
//               Revision 1.2  2001/08/10 08:16:21  rudi
//
//               - Changed IO names to be more clear.
//               - Uniquifyed define names to be core specific.
//               - Removed "Refresh Early" configuration
//
//               Revision 1.1  2001/07/29 07:34:41  rudi
//
//
//               1) Changed Directory Structure
//               2) Fixed several minor bugs
//
//               Revision 1.3  2001/06/12 15:19:49  rudi
//
//
//               Minor changes after running lint, and a small bug fix reading csr and ba_mask registers.
//
//               Revision 1.2  2001/06/03 11:37:17  rudi
//
//
//               1) Fixed Chip Select Mask Register
//               	- Power On Value is now all ones
//               	- Comparison Logic is now correct
//
//               2) All resets are now asynchronous
//
//               3) Converted Power On Delay to an configurable item
//
//               4) Added reset to Chip Select Output Registers
//
//               5) Forcing all outputs to Hi-Z state during reset
//
//               Revision 1.1.1.1  2001/05/13 09:39:39  rudi
//               Created Directory Structure
//
//
//
//

`include "mc_defines.v"

module mc_top(clk_i, rst_i,

	wb_data_i, wb_data_o, wb_addr_i, wb_sel_i, wb_we_i, wb_cyc_i,
	wb_stb_i, wb_ack_o, wb_err_o, 

	susp_req_i, resume_req_i, suspended_o, poc_o,

	mc_clk_i, mc_br_pad_i, mc_bg_pad_o, mc_ack_pad_i,
	mc_addr_pad_o, mc_data_pad_i, mc_data_pad_o, mc_dp_pad_i,
	mc_dp_pad_o, mc_doe_pad_doe_o, mc_dqm_pad_o, mc_oe_pad_o_,
	mc_we_pad_o_, mc_cas_pad_o_, mc_ras_pad_o_, mc_cke_pad_o_,
	mc_cs_pad_o_, mc_sts_pad_i, mc_rp_pad_o_, mc_vpen_pad_o,
	mc_adsc_pad_o_, mc_adv_pad_o_, mc_zz_pad_o, mc_coe_pad_coe_o
	);

input		clk_i, rst_i;

// --------------------------------------
// WISHBONE SLAVE INTERFACE 
input	[31:0]	wb_data_i;
output	[31:0]	wb_data_o;
input	[31:0]	wb_addr_i;
input	[3:0]	wb_sel_i;
input		wb_we_i;
input		wb_cyc_i;
input		wb_stb_i;
output		wb_ack_o;
output		wb_err_o;

// --------------------------------------
// Suspend Resume Interface
input		susp_req_i;
input		resume_req_i;
output		suspended_o;

// POC
output	[31:0]	poc_o;

// --------------------------------------
// Memory Bus Signals
input		mc_clk_i;
input		mc_br_pad_i;
output		mc_bg_pad_o;
input		mc_ack_pad_i;
output	[23:0]	mc_addr_pad_o;
input	[31:0]	mc_data_pad_i;
output	[31:0]	mc_data_pad_o;
input	[3:0]	mc_dp_pad_i;
output	[3:0]	mc_dp_pad_o;
output		mc_doe_pad_doe_o;
output	[3:0]	mc_dqm_pad_o;
output		mc_oe_pad_o_;
output		mc_we_pad_o_;
output		mc_cas_pad_o_;
output		mc_ras_pad_o_;
output		mc_cke_pad_o_;
output	[7:0]	mc_cs_pad_o_;
input		mc_sts_pad_i;
output		mc_rp_pad_o_;
output		mc_vpen_pad_o;
output		mc_adsc_pad_o_;
output		mc_adv_pad_o_;
output		mc_zz_pad_o;
output		mc_coe_pad_coe_o;

////////////////////////////////////////////////////////////////////
//
// Local Wires
//

// WISHBONE Interface Interconnects
wire		wb_read_go;
wire		wb_write_go;
wire		wb_first;
wire		wb_wait;
wire		mem_ack;

// Suspend Resume Interface
wire		susp_sel;

// Register File Interconnects
wire	[31:0]	rf_dout;
wire	[31:0]	csc;
wire	[31:0]	tms;
wire	[31:0]	sp_csc;
wire	[31:0]	sp_tms;
wire	[7:0]	cs;
wire		fs;
wire		cs_le;
wire	[7:0]	cs_need_rfr;
wire	[2:0]	ref_int;
wire	[31:0]	mem_dout;
wire		wp_err;

// Address Select Signals
wire	[12:0]	row_adr;
wire	[1:0]	bank_adr;
wire		cmd_a10;
wire		row_sel;
wire		next_adr;
wire	[10:0]	page_size;
wire		lmr_sel;
wire		wr_hold;

// OBCT Signals
wire		bank_set;
wire		bank_clr;
wire		bank_clr_all;
wire		bank_open;
wire		row_same;
wire	[7:0]	obct_cs;
wire		any_bank_open;

// Data path Controller Signals
wire		dv;
wire		pack_le0, pack_le1, pack_le2;	// Pack Latch Enable
wire		par_err;
wire	[31:0]	mc_data_od;
wire	[3:0]	mc_dp_od;
wire	[23:0]	mc_addr_d;
wire	[35:0]	mc_data_ir;

// Refresh Counter Signals
wire		rfr_req;
wire		rfr_ack;
wire	[7:0]	rfr_ps_val;

// Memory Timing Block Signals
wire		data_oe;
wire		oe_;
wire		we_;
wire		cas_;
wire		ras_;
wire		cke_;
wire		lmr_req;
wire		lmr_ack;
wire		init_req;
wire		init_ack;
wire	[7:0]	spec_req_cs;
wire		cs_en;
wire		wb_cycle, wr_cycle;
wire	[31:0]	tms_s;
wire	[31:0]	csc_s;
wire		mc_c_oe_d;
wire		mc_br_r;
wire		mc_bg_d;
wire		mc_adsc_d;
wire		mc_adv_d;
wire		mc_ack_r;
wire		err;
wire		mc_sts_i;

////////////////////////////////////////////////////////////////////
//
// Misc Logic
//

assign obct_cs =	(rfr_ack | susp_sel) ? cs_need_rfr :
			(lmr_ack | init_ack) ? spec_req_cs : cs;

assign lmr_sel = lmr_ack | init_ack;

assign tms_s = lmr_sel ? sp_tms : tms;
assign csc_s = lmr_sel ? sp_csc : csc;


wire		not_mem_cyc;

assign	not_mem_cyc = wb_cyc_i & wb_stb_i & !( `MC_MEM_SEL );

reg		mem_ack_r;

always @(posedge clk_i)
	mem_ack_r <= #1 mem_ack;

////////////////////////////////////////////////////////////////////
//
// Modules
//

mc_rf		u0(
		.clk(		clk_i		),
		.rst(		rst_i		),
		.wb_data_i(	wb_data_i	),
		.rf_dout(	rf_dout		),
		.wb_addr_i(	wb_addr_i	),
		.wb_we_i(	wb_we_i		),
		.wb_cyc_i(	wb_cyc_i	),
		.wb_stb_i(	wb_stb_i 	),
		.wb_ack_o(			),
		.wp_err(	wp_err		),
		.csc(		csc		),
		.tms(		tms		),
		.poc(		poc_o		),
		.sp_csc(	sp_csc		),
		.sp_tms(	sp_tms		),
		.cs(		cs		),
		.mc_data_i(	mc_data_ir[31:0]),
		.mc_sts(	mc_sts_ir	),
		.mc_vpen(	mc_vpen_pad_o 	),
		.fs(		fs		),
		.cs_le(		cs_le		),
		.cs_le_d(	cs_le_d		),
		.cs_need_rfr(	cs_need_rfr	),
		.ref_int(	ref_int		),
		.rfr_ps_val(	rfr_ps_val	),
		.spec_req_cs(	spec_req_cs	),
		.init_req(	init_req	),
		.init_ack(	init_ack	),
		.lmr_req(	lmr_req		),
		.lmr_ack(	lmr_ack		)
		);

mc_adr_sel	u1(
		.clk(		clk_i		),
		.csc(		csc_s		),
		.tms(		tms_s		),
		.wb_stb_i(	wb_stb_i 	),
		//.wb_ack_o(	wb_ack_o	),
		.wb_ack_o(	mem_ack_r	),
		.wb_addr_i(	wb_addr_i	),
		.wb_we_i(	wb_we_i		),
		.wb_write_go(	wb_write_go	),
		.wr_hold(	wr_hold		),
		.cas_(		cas_		),
		.mc_addr(	mc_addr_d	),
		.row_adr(	row_adr		),
		.bank_adr(	bank_adr	),
		.rfr_ack(	rfr_ack		),
		.cs_le(		cs_le		),
		.cmd_a10(	cmd_a10		),
		.row_sel(	row_sel		),
		.lmr_sel(	lmr_sel		),
		.next_adr(	next_adr	),
		.wr_cycle(	wr_cycle	),
		.page_size(	page_size	)
		);

mc_obct_top	u2(
		.clk(		clk_i		),
		.rst(		rst_i		),
		.cs(		obct_cs		),
		.row_adr(	row_adr		),
		.bank_adr(	bank_adr	),
		.bank_set(	bank_set	),
		.bank_clr(	bank_clr	),
		.bank_clr_all(	bank_clr_all	),
		.bank_open(	bank_open	),
		.any_bank_open(	any_bank_open	),
		.row_same(	row_same	),
		.rfr_ack(	rfr_ack		)
		);

mc_dp		u3(
		.clk(		clk_i		),
		.rst(		rst_i		),
		.csc(		csc		),
		.wb_cyc_i(	wb_cyc_i	),
		.wb_stb_i(	wb_stb_i	),
		.mem_ack(	mem_ack 	),
		//.wb_ack_o(	wb_ack_o 	),
		.wb_ack_o(	mem_ack_r 	),
		.wb_we_i(	wb_we_i		),
		.wb_data_i(	wb_data_i	),
		.wb_data_o(	mem_dout	),
		.wb_read_go(	wb_read_go	),
		.mc_clk(	mc_clk_i	),
		.mc_data_del(	mc_data_ir	),
		.mc_dp_i(	mc_dp_pad_i	),
		.mc_data_o(	mc_data_od	),
		.mc_dp_o(	mc_dp_od	),
		.dv(		dv		),
		.pack_le0(	pack_le0	),
		.pack_le1(	pack_le1	),
		.pack_le2(	pack_le2	),
		.byte_en(	wb_sel_i	),
		.par_err(	par_err		)
		);

mc_refresh	u4(
		.clk(		clk_i		),
		.rst(		rst_i		),
		.cs_need_rfr(	cs_need_rfr	),
		.ref_int(	ref_int		),
		.rfr_req(	rfr_req		),
		.rfr_ack(	rfr_ack		),
		.rfr_ps_val(	rfr_ps_val	)
		);
 
mc_timing	u5(
		.clk(		clk_i		),
		.mc_clk(	mc_clk_i	),
		.rst(		rst_i		),
		.wb_cyc_i(	wb_cyc_i	),
		.wb_stb_i(	wb_stb_i 	),
		.wb_we_i(	wb_we_i		),
		.wb_read_go(	wb_read_go	),
		.wb_write_go(	wb_write_go	),
		.wb_first(	wb_first	),
		.wb_wait(	wb_wait		),
		.mem_ack(	mem_ack		),
		.err(		err		),
		.susp_req(	susp_req_i	),
		.resume_req(	resume_req_i	),
		.suspended(	suspended_o	),
		.susp_sel(	susp_sel	),
		.mc_br(		mc_br_r		),
		.mc_bg(		mc_bg_d		),
		.mc_ack(	mc_ack_r	),
		.not_mem_cyc(	not_mem_cyc	),
		.data_oe(	data_oe		),
		.oe_(		oe_		),
		.we_(		we_		),
		.cas_(		cas_		),
		.ras_(		ras_		),
		.cke_(		cke_		),
		.cs_en(		cs_en		),
		.mc_adsc(	mc_adsc_d	),
		.mc_adv(	mc_adv_d	),
		.mc_c_oe(	mc_c_oe_d	),
		.wb_cycle(	wb_cycle	),
		.wr_cycle(	wr_cycle	),
		.csc(		csc_s		),
		.tms(		tms_s		),
		.cs(		obct_cs		),
		.lmr_req(	lmr_req		),
		.lmr_ack(	lmr_ack		),
		.cs_le(		cs_le		),
		.cs_le_d(	cs_le_d		),
		.cmd_a10(	cmd_a10		),
		.row_sel(	row_sel		),
		.next_adr(	next_adr	),
		.page_size(	page_size	),
		.bank_set(	bank_set	),
		.bank_clr(	bank_clr	),
		.bank_clr_all(	bank_clr_all	),
		.bank_open(	bank_open	),
		.any_bank_open(	any_bank_open	),
		.row_same(	row_same	),
		.dv(		dv		),
		.pack_le0(	pack_le0	),
		.pack_le1(	pack_le1	),
		.pack_le2(	pack_le2	),
		.par_err(	par_err		),
		.rfr_req(	rfr_req		),
		.rfr_ack(	rfr_ack		),
		.init_req(	init_req	),
		.init_ack(	init_ack	)
		);

mc_wb_if	u6(
		.clk(		clk_i		),
		.rst(		rst_i		),
		.wb_addr_i(	wb_addr_i	),
		.wb_cyc_i(	wb_cyc_i	),
		.wb_stb_i(	wb_stb_i 	),
		.wb_we_i(	wb_we_i		),
		.wb_ack_o(	wb_ack_o	),
		.wb_err(	wb_err_o	),
		.wb_read_go(	wb_read_go	),
		.wb_write_go(	wb_write_go	),
		.wb_first(	wb_first	),
		.wb_wait(	wb_wait		),
		.mem_ack(	mem_ack		),
		.wr_hold(	wr_hold		),
		.err(		err		),
		.par_err(	par_err		),
		.wp_err(	wp_err		),
		.wb_data_o(	wb_data_o	),
		.mem_dout(	mem_dout	),
		.rf_dout(	rf_dout		)
		);

mc_mem_if	u7(
		.clk(		clk_i		),
		.rst(		rst_i		),
		.mc_rp(		mc_rp_pad_o_	),
		.mc_clk(	mc_clk_i	),
		.mc_br(		mc_br_pad_i	),
		.mc_bg(		mc_bg_pad_o	),
		.mc_addr(	mc_addr_pad_o	),
		.mc_data_o(	mc_data_pad_o	),
		.mc_dp_o(	mc_dp_pad_o	),
		.mc_data_oe(	mc_doe_pad_doe_o),
		.mc_dqm(	mc_dqm_pad_o	),
		.mc_oe_(	mc_oe_pad_o_	),
		.mc_we_(	mc_we_pad_o_	),
		.mc_cas_(	mc_cas_pad_o_	),
		.mc_ras_(	mc_ras_pad_o_	),
		.mc_cke_(	mc_cke_pad_o_	),
		.mc_cs_(	mc_cs_pad_o_	),
		.mc_adsc_(	mc_adsc_pad_o_	),
		.mc_adv_(	mc_adv_pad_o_	),
		.mc_br_r(	mc_br_r		),
		.mc_bg_d(	mc_bg_d		),
		.mc_data_od(	mc_data_od	),
		.mc_dp_od(	mc_dp_od	),
		.mc_addr_d(	mc_addr_d	),
		.mc_ack(	mc_ack_pad_i	),
		.mc_zz_o(	mc_zz_pad_o	),
		.we_(		we_		),
		.ras_(		ras_		),
		.cas_(		cas_		),
		.cke_(		cke_		),
		.mc_adsc_d(	mc_adsc_d	),
		.mc_adv_d(	mc_adv_d	),
		.cs_en(		cs_en		),
		.rfr_ack(	rfr_ack		),
		.cs_need_rfr(	cs_need_rfr	),
		.lmr_sel(	lmr_sel		),
		.spec_req_cs(	spec_req_cs	),
		.cs(		cs		),
		.fs(		fs		),
		.data_oe(	data_oe		),
		.susp_sel(	susp_sel	),
		.suspended_o(	suspended_o	),
		.mc_c_oe(	mc_coe_pad_coe_o),
		.mc_c_oe_d(	mc_c_oe_d	),
		.mc_ack_r(	mc_ack_r	),
		.oe_(		oe_		),
		.wb_cyc_i(	wb_cyc_i 	),
		.wb_stb_i(	wb_stb_i 	),
		.wb_sel_i(	wb_sel_i	),
		.wb_cycle(	wb_cycle	),
		.wr_cycle(	wr_cycle	),
		.mc_data_i(	mc_data_pad_i	),
		.mc_dp_i(	mc_dp_pad_i	),
		.mc_data_ir(	mc_data_ir	),
		.mc_sts_i(	mc_sts_pad_i	),
		.mc_sts_ir(	mc_sts_ir	)
		);

	// --- Formal assertions ---
	// ============================================================================
	// SystemVerilog Assertions for memory_controller_ip_core (mc_top)
	// Derived independently from the Gherkin Behavioral Specification.
	// Clock domains: clk_i (host/WISHBONE side), mc_clk_i (memory side)
	// Reset: rst_i - asynchronous, active-high (modeled via disable iff / posedge rst_i)
	//
	// NOTE: Only signals literally present in the mc_top port/wire list are
	// referenced below. Concepts from the Background section that have no
	// corresponding RTL signal (e.g. org_mode as a standalone signal, mc_addr,
	// rmw_active, addr_fetch_req, mc_data_del, pack_reg, self_refresh_active,
	// sync_access_active, access_cycle_count, T_max, parity_check_en,
	// burst_mode_en, ssram_cs_active) have been mapped onto their real RTL
	// counterparts where a reasonable correspondence exists (e.g. org_mode ->
	// tms[16], mc_addr -> mc_addr_d, mc_data_del -> mc_data_ir), or the
	// corresponding property has been removed where no equivalent signal
	// exists in the provided interface/wire list.
	//
	// NOTE: The col_bits helper (derived via $clog2(page_size)) and any
	// properties depending on it have been removed, since non-constant math
	// functions are not supported for synthesis. Only reduction operators
	// and plain comparisons are used throughout.
	// ============================================================================

	// ----------------------------------------------------------------------
	// Local parameters (fixed bounds per Background definitions)
	// ----------------------------------------------------------------------
	localparam int N_SUSP        = 16;
	localparam int N_RESUME      = 16;
	localparam int N_GRANT       = 8;
	localparam int N_REFRESH_MAX = 256;
	localparam int BYTE_LSB      = 2;
	localparam int BURST_INC     = 1;

	// ----------------------------------------------------------------------
	// Derived combinational helper signals (per spec Background definitions)
	// ----------------------------------------------------------------------
	wire mem_space          = (wb_addr_i[31:29] == 3'b000);
	wire reg_space          = (wb_addr_i[31:29] == 3'b011);
	wire mem_cycle_active   = wb_cyc_i && wb_stb_i && mem_space && !wb_ack_o && !wb_err_o;

	// Byte-wise parity computation helper (used for datapath & error checks)
	wire [3:0] computed_byte_parity_wb   = {^wb_data_i[31:24], ^wb_data_i[23:16],
	                                         ^wb_data_i[15:8],  ^wb_data_i[7:0]};
	wire [3:0] computed_byte_parity_ir   = {^mc_data_ir[31:24], ^mc_data_ir[23:16],
	                                         ^mc_data_ir[15:8],  ^mc_data_ir[7:0]};

	// ============================================================================
	// RESET BEHAVIOR
	// ============================================================================

	// Scenario: Reset deasserts all chip-selects
	property p_reset_deassert_cs;
	  @(posedge clk_i)
	  (rst_i) |-> (mc_cs_pad_o_ == 8'b11111111);
	endproperty
	assert property (p_reset_deassert_cs);

	// Scenario: Reset is asynchronous and deasserts chip-selects independent of clock edge
	property p_reset_async_cs;
	  @(posedge rst_i)
	  (1'b1) |-> ##0 (mc_cs_pad_o_ == 8'b11111111);
	endproperty
	assert property (p_reset_async_cs);

	// Scenario: Reset suppresses acknowledge and error
	property p_reset_suppress_ack_err;
	  @(posedge clk_i)
	  (rst_i && wb_cyc_i && wb_stb_i) |-> (!wb_ack_o && !wb_err_o);
	endproperty
	assert property (p_reset_suppress_ack_err);

	// Scenario: Reset blocks normal transaction servicing
	property p_reset_blocks_txn;
	  @(posedge clk_i)
	  (rst_i && mem_space && wb_cyc_i && wb_stb_i) |-> (!wb_ack_o);
	endproperty
	assert property (p_reset_blocks_txn);

	// ============================================================================
	// ADDRESS DECODE SEMANTICS
	// ============================================================================

	// Scenario: Memory-space address selects memory datapath
	property p_mem_space_selects_mem;
	  @(posedge clk_i) disable iff (rst_i)
	  (mem_space && wb_cyc_i && wb_stb_i) |-> (wb_ack_o == mem_ack);
	endproperty
	assert property (p_mem_space_selects_mem);

	// Scenario: Register-space address selects register-file datapath
	property p_reg_space_selects_rf;
	  @(posedge clk_i) disable iff (rst_i)
	  (reg_space && wb_cyc_i && wb_stb_i) |-> (wb_data_o == rf_dout);
	endproperty
	assert property (p_reg_space_selects_rf);

	// Scenario: Memory-space and register-space decodes are mutually exclusive
	property p_space_mutex;
	  @(posedge clk_i) disable iff (rst_i)
	  (1'b1) |-> !(mem_space && reg_space);
	endproperty
	assert property (p_space_mutex);

	// Scenario: Undecoded address region produces no controller response
	property p_undecoded_no_response;
	  @(posedge clk_i) disable iff (rst_i)
	  (!mem_space && !reg_space && wb_cyc_i && wb_stb_i) |->
	    (!mem_space && !reg_space && !wb_ack_o && !wb_err_o);
	endproperty
	assert property (p_undecoded_no_response);

	// ============================================================================
	// mc_wb_if: REQUEST QUALIFICATION
	// ============================================================================

	// Scenario: Read request qualification requires cyc, stb, and not we
	property p_read_go_qual;
	  @(posedge clk_i) disable iff (rst_i)
	  (mem_space && wb_cyc_i && wb_stb_i && !wb_we_i) |-> (wb_read_go);
	endproperty
	assert property (p_read_go_qual);

	// Scenario: Write request qualification requires cyc, stb, and we
	property p_write_go_qual;
	  @(posedge clk_i) disable iff (rst_i)
	  (mem_space && wb_cyc_i && wb_stb_i && wb_we_i) |-> (wb_write_go);
	endproperty
	assert property (p_write_go_qual);

	// Scenario: No request generated when cyc is deasserted
	property p_no_req_no_cyc;
	  @(posedge clk_i) disable iff (rst_i)
	  (!wb_cyc_i) |-> (!wb_read_go && !wb_write_go);
	endproperty
	assert property (p_no_req_no_cyc);

	// Scenario: No request generated when stb is deasserted
	property p_no_req_no_stb;
	  @(posedge clk_i) disable iff (rst_i)
	  (wb_cyc_i && !wb_stb_i) |-> (!wb_read_go && !wb_write_go);
	endproperty
	assert property (p_no_req_no_stb);

	// Scenario: First beat is asserted at start of a new cycle
	property p_wb_first_beat;
	  @(posedge clk_i) disable iff (rst_i)
	  ($rose(wb_cyc_i) && wb_stb_i) |-> (wb_first);
	endproperty
	assert property (p_wb_first_beat);

	// Scenario: Acknowledge follows memory completion
	property p_ack_follows_mem;
	  @(posedge clk_i) disable iff (rst_i)
	  (mem_cycle_active && mem_ack && !err) |-> (wb_ack_o);
	endproperty
	assert property (p_ack_follows_mem);

	// Scenario: Error suppresses acknowledge
	property p_err_suppress_ack;
	  @(posedge clk_i) disable iff (rst_i)
	  (mem_cycle_active && err) |-> (wb_err_o && !wb_ack_o);
	endproperty
	assert property (p_err_suppress_ack);

	// ============================================================================
	// ERROR SIGNALING
	// ============================================================================

	// Scenario: Parity mismatch on read asserts error
	property p_par_err_mismatch;
	  @(posedge clk_i) disable iff (rst_i)
	  (dv && (computed_byte_parity_ir != mc_data_ir[35:32])) |->
	     (par_err && wb_err_o && !wb_ack_o);
	endproperty
	assert property (p_par_err_mismatch);

	// Scenario: No parity error implies no error contribution from parity path
	property p_par_no_err_match;
	  @(posedge clk_i) disable iff (rst_i)
	  (dv && (computed_byte_parity_ir == mc_data_ir[35:32])) |-> (!par_err);
	endproperty
	assert property (p_par_no_err_match);

	// Scenario: Write to write-protected region asserts error
	property p_wp_write_err;
	  @(posedge clk_i) disable iff (rst_i)
	  (wb_we_i && wp_err && wb_cyc_i && wb_stb_i) |-> (wb_err_o && !wb_ack_o);
	endproperty
	assert property (p_wp_write_err);

	// Scenario: Read from write-protected region is not an error
	property p_wp_read_ok;
	  @(posedge clk_i) disable iff (rst_i)
	  (!wb_we_i && wb_cyc_i && wb_stb_i && mem_ack) |-> (!wb_err_o && wb_ack_o);
	endproperty
	assert property (p_wp_read_ok);

	// ============================================================================
	// mc_rf: REGISTER FILE AND CHIP-SELECT CONFIGURATION
	// ============================================================================

	// Scenario: Register write updates register content
	property p_reg_write_read;
	  logic [31:0] c_addr, c_data;
	  @(posedge clk_i) disable iff (rst_i)
	  (reg_space && wb_we_i && wb_cyc_i && wb_stb_i,
	     c_addr = wb_addr_i, c_data = wb_data_i)
	  |-> ##[1:8] (wb_addr_i == c_addr && !wb_we_i && wb_cyc_i && wb_stb_i &&
	               rf_dout == c_data);
	endproperty
	assert property (p_reg_write_read);

	// Scenario: Register read returns stored value
	property p_reg_read_returns;
	  @(posedge clk_i) disable iff (rst_i)
	  (reg_space && !wb_we_i && wb_cyc_i && wb_stb_i) |-> (wb_data_o == rf_dout);
	endproperty
	assert property (p_reg_read_returns);

	// Scenario: Active chip-select context reflects decoded address
	property p_cs_addr_decode_stable;
	  @(posedge clk_i) disable iff (rst_i)
	  (mem_space && $stable(wb_addr_i)) |-> $stable(cs);
	endproperty
	assert property (p_cs_addr_decode_stable);

	// ============================================================================
	// mc_adr_sel: ADDRESS GENERATION
	// ============================================================================
	// NOTE: SDRAM address decomposition properties (bank-then-row and
	// row-then-bank ordering) have been removed. They depended on the
	// col_bits helper, which used a non-constant system function
	// ($clog2(page_size)) and is not supported for synthesis.

	// Scenario: Burst address increments on next_adr assertion
	// mc_addr (internal address register) mapped to real internal wire mc_addr_d
	property p_burst_addr_inc;
	  @(posedge mc_clk_i) disable iff (rst_i)
	  (next_adr) |=> (mc_addr_d == $past(mc_addr_d) + BURST_INC);
	endproperty
	assert property (p_burst_addr_inc);

	// Scenario: Address holds constant without next_adr
	property p_addr_hold;
	  @(posedge mc_clk_i) disable iff (rst_i)
	  (!next_adr) |=> (mc_addr_d == $past(mc_addr_d));
	endproperty
	assert property (p_addr_hold);

	// ============================================================================
	// mc_dp: DATA PATH, PACKING, AND PARITY
	// ============================================================================

	// Scenario: Write data forwarded to memory data output
	property p_write_data_forward;
	  @(posedge mc_clk_i) disable iff (rst_i)
	  (wb_write_go) |-> (mc_data_pad_o == wb_data_i);
	endproperty
	assert property (p_write_data_forward);

	// Scenario: Byte parity generated when parity enabled
	property p_byte_parity_gen;
	  @(posedge mc_clk_i) disable iff (rst_i)
	  (wb_write_go) |-> (mc_dp_pad_o == computed_byte_parity_wb);
	endproperty
	assert property (p_byte_parity_gen);

	// Scenario: Read data captured and returned to host
	// mc_data_del (captured value with parity) mapped to real internal wire mc_data_ir
	property p_read_data_return;
	  @(posedge clk_i) disable iff (rst_i)
	  (dv) |-> (wb_data_o == mc_data_ir[31:0]);
	endproperty
	assert property (p_read_data_return);

	// ============================================================================
	// mc_refresh: REFRESH REQUEST GENERATION
	// ============================================================================

	// Scenario: Refresh request asserted when interval elapses
	property p_rfr_req_bounded;
	  @(posedge clk_i) disable iff (rst_i)
	  ($rose(|cs_need_rfr)) |-> ##[1:N_REFRESH_MAX] (rfr_req);
	endproperty
	assert property (p_rfr_req_bounded);

	// Scenario: Refresh request remains asserted until acknowledged
	property p_rfr_req_hold;
	  @(posedge clk_i) disable iff (rst_i)
	  (rfr_req && !rfr_ack) |=> (rfr_req);
	endproperty
	assert property (p_rfr_req_hold);

	// Scenario: Refresh request deasserts after acknowledge
	property p_rfr_req_deassert;
	  @(posedge clk_i) disable iff (rst_i)
	  (rfr_req && rfr_ack) |=> (!rfr_req);
	endproperty
	assert property (p_rfr_req_deassert);

	// Scenario: No refresh request when no chip-select needs refresh
	property p_no_rfr_req;
	  @(posedge clk_i) disable iff (rst_i)
	  (cs_need_rfr == 8'b00000000) |-> (!rfr_req);
	endproperty
	assert property (p_no_rfr_req);

	// ============================================================================
	// mc_obct_top: OPEN BANK AND ROW TRACKING
	// ============================================================================

	// Scenario: Bank marked open after bank_set
	property p_bank_open_after_set;
	  @(posedge clk_i) disable iff (rst_i)
	  (bank_set && $stable(cs) && $stable(bank_adr)) |=> (bank_open);
	endproperty
	assert property (p_bank_open_after_set);

	// Scenario: Bank marked closed after bank_clr
	property p_bank_closed_after_clr;
	  @(posedge clk_i) disable iff (rst_i)
	  (bank_clr && $stable(cs) && $stable(bank_adr)) |=> (!bank_open);
	endproperty
	assert property (p_bank_closed_after_clr);

	// Scenario: All banks closed after bank_clr_all
	property p_all_banks_closed;
	  @(posedge clk_i) disable iff (rst_i)
	  (bank_clr_all) |=> (!any_bank_open);
	endproperty
	assert property (p_all_banks_closed);

	// Scenario: Row hit indicated when accessed row matches open row
	property p_row_hit;
	  logic [12:0] c_row;
	  @(posedge clk_i) disable iff (rst_i)
	  (bank_set, c_row = row_adr)
	  |=> ((bank_open && row_adr == c_row) -> row_same);
	endproperty
	assert property (p_row_hit);

	// Scenario: Row miss indicated when accessed row differs from open row
	property p_row_miss;
	  logic [12:0] c_row;
	  @(posedge clk_i) disable iff (rst_i)
	  (bank_set, c_row = row_adr)
	  |=> ((bank_open && row_adr != c_row) -> !row_same);
	endproperty
	assert property (p_row_miss);

	// ============================================================================
	// mc_timing: COMMAND SEQUENCING
	// ============================================================================

	// Scenario: Init request selects special-request chip-select for CS drive
	property p_init_selects_cs;
	  @(posedge clk_i) disable iff (rst_i)
	  (init_req) |-> (cs == spec_req_cs && cs_en);
	endproperty
	assert property (p_init_selects_cs);

	// Scenario: LMR request selects special-request chip-select for CS drive
	property p_lmr_selects_cs;
	  @(posedge clk_i) disable iff (rst_i)
	  (lmr_req) |-> (cs == spec_req_cs && cs_en);
	endproperty
	assert property (p_lmr_selects_cs);

	// Scenario: Refresh service selects SDRAM-eligible chip-selects
	property p_rfr_selects_cs;
	  @(posedge clk_i) disable iff (rst_i)
	  (rfr_req) |-> (cs == cs_need_rfr && cs_en);
	endproperty
	assert property (p_rfr_selects_cs);

	// Scenario: Command outputs deasserted when no request is active
	property p_cs_en_idle;
	  @(posedge clk_i) disable iff (rst_i)
	  (!wb_read_go && !wb_write_go && !rfr_req && !init_req && !lmr_req) |->
	    (!cs_en);
	endproperty
	assert property (p_cs_en_idle);

	// ============================================================================
	// SUSPEND / RESUME
	// ============================================================================

	// Scenario: Suspended asserted within bounded latency after suspend request held
	property p_suspend_bounded;
	  @(posedge clk_i) disable iff (rst_i)
	  ($rose(susp_req_i)) |-> ##[1:N_SUSP] (suspended_o);
	endproperty
	assert property (p_suspend_bounded);

	// Scenario: Suspended not asserted while suspend request deasserted
	property p_suspend_not_when_deasserted;
	  @(posedge clk_i) disable iff (rst_i)
	  (!susp_req_i && !suspended_o) |=> (!suspended_o);
	endproperty
	assert property (p_suspend_not_when_deasserted);

	// Scenario: Resume deasserts suspended within bounded latency after resume request
	property p_resume_bounded;
	  @(posedge clk_i) disable iff (rst_i)
	  (suspended_o && $rose(resume_req_i)) |-> ##[1:N_RESUME] (!suspended_o);
	endproperty
	assert property (p_resume_bounded);

	// Scenario: Resume request ignored before suspended is reached
	property p_resume_ignored_before_suspend;
	  @(posedge clk_i) disable iff (rst_i)
	  (!suspended_o && resume_req_i) |=> (!suspended_o);
	endproperty
	assert property (p_resume_ignored_before_suspend);

	// Scenario: Suspended state persists after suspend request deasserts until resume is requested
	property p_suspend_persist;
	  @(posedge clk_i) disable iff (rst_i)
	  (suspended_o && $fell(susp_req_i) && !resume_req_i) |=> (suspended_o);
	endproperty
	assert property (p_suspend_persist);

	// Scenario: SSRAM snooze output asserted during suspend
	property p_ssram_snooze;
	  @(posedge mc_clk_i) disable iff (rst_i)
	  (suspended_o) |-> (mc_zz_pad_o);
	endproperty
	assert property (p_ssram_snooze);

	// ============================================================================
	// EXTERNAL BUS MASTER INTERFACE
	// ============================================================================

	// Scenario: Bus grant asserted within bounded latency after bus request
	property p_bus_grant_bounded;
	  @(posedge mc_clk_i) disable iff (rst_i)
	  ($rose(mc_br_pad_i) && !rfr_req) |-> ##[1:N_GRANT] (mc_bg_pad_o);
	endproperty
	assert property (p_bus_grant_bounded);

	// Scenario: Bus grant withheld while a refresh servicing conflict is pending
	property p_bus_grant_withheld_refresh;
	  @(posedge mc_clk_i) disable iff (rst_i)
	  (mc_br_pad_i && rfr_req && !rfr_ack) |-> (!mc_bg_pad_o);
	endproperty
	assert property (p_bus_grant_withheld_refresh);

	// Scenario: Bus grant deasserted when request deasserted
	property p_bus_grant_deasserted;
	  @(posedge mc_clk_i) disable iff (rst_i)
	  (!mc_br_pad_i) |-> (!mc_bg_pad_o);
	endproperty
	assert property (p_bus_grant_deasserted);

	// Scenario: Grant held while request held
	property p_bus_grant_held;
	  @(posedge mc_clk_i) disable iff (rst_i)
	  (mc_bg_pad_o && mc_br_pad_i) |=> (mc_bg_pad_o);
	endproperty
	assert property (p_bus_grant_held);

	// ============================================================================
	// POWER-ON CONFIGURATION
	// ============================================================================

	// Scenario: POC captures memory data input during reset assertion
	property p_poc_capture;
	  @(posedge mc_clk_i)
	  (rst_i) |-> (poc_o == mc_data_pad_i);
	endproperty
	assert property (p_poc_capture);

	// Scenario: POC value stable after reset deassertion
	property p_poc_stable;
	  @(posedge clk_i)
	  ($fell(rst_i)) |=> (poc_o == $past(poc_o));
	endproperty
	assert property (p_poc_stable);

	// ============================================================================
	// MEMORY-SIDE I/O REGISTERING
	// ============================================================================

	// Scenario: Memory address registered to mc_clk_i
	property p_mem_addr_registered;
	  @(posedge mc_clk_i) disable iff (rst_i)
	  (1'b1) |=> (mc_addr_pad_o == $past(mc_addr_d));
	endproperty
	assert property (p_mem_addr_registered);

	// Scenario: Data mask reflects host byte-select
	property p_dqm_mask;
	  @(posedge mc_clk_i) disable iff (rst_i)
	  (wb_write_go) |-> (mc_dqm_pad_o == ~wb_sel_i);
	endproperty
	assert property (p_dqm_mask);

	// Scenario: Chip-select outputs active-low reflect decoded region
	property p_cs_active_low;
	  @(posedge mc_clk_i) disable iff (rst_i)
	  (cs_en) |-> (mc_cs_pad_o_ == ~cs);
	endproperty
	assert property (p_cs_active_low);


endmodule
