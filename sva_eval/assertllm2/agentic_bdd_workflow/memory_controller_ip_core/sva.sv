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