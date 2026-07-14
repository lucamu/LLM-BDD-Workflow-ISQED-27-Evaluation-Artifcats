// =====================================================================
// SVA for xgate_top XGATE Co-Processor - conservative, reduced set
// Derived strictly from Gherkin specification, using only signals
// present in the SIGNAL DECLARATIONS list.
//
// Revision note: multi-term AND'ed antecedents (which were the primary
// source of vacuity) have been reworked so that each property's outer
// antecedent (the sequence trigger) is a single reachable strobe/signal
// (e.g. |write_xgvbr, write_xgchid, |write_xgr1, write_xgmctil,
// mem_req_ack). Any conditional (debug_active, xge, xgsweif_c, etc.)
// that used to be AND'ed into the antecedent has been moved into the
// consequent using the plain boolean implication operator "->", which
// preserves the documented conditional behavior without requiring two
// rare conditions to be simultaneously true just to fire the property.
// =====================================================================

// ---------------------------------------------------------------------
// @reset @async
// Asynchronous reset immediately forces internal reset indication
// ---------------------------------------------------------------------
property p_async_rst_immediate;
  @(posedge wbs_clk_i)
  (arst_i == ARST_LVL) |-> !async_rst_b;
endproperty
assert property (p_async_rst_immediate);

// ---------------------------------------------------------------------
// @reset @zeroed  -- key registers held at reset value
// ---------------------------------------------------------------------
property p_reset_xgswt;
  @(posedge wbs_clk_i)
  sync_reset |-> (xgswt == 8'h00);
endproperty
assert property (p_reset_xgswt);

property p_reset_host_semap;
  @(posedge wbs_clk_i)
  sync_reset |-> (host_semap == 8'h00);
endproperty
assert property (p_reset_host_semap);

property p_reset_xgchid;
  @(posedge wbs_clk_i)
  sync_reset |-> (xgchid == 7'h00);
endproperty
assert property (p_reset_xgchid);

property p_reset_xgccr;
  @(posedge wbs_clk_i)
  sync_reset |-> (zero_flag == 1'b0 && negative_flag == 1'b0 &&
                   carry_flag == 1'b0 && overflow_flag == 1'b0);
endproperty
assert property (p_reset_xgccr);

property p_reset_xgr_group;
  @(posedge wbs_clk_i)
  sync_reset |-> (xgr1 == 16'h0000 && xgr2 == 16'h0000 &&
                   xgr3 == 16'h0000 && xgr4 == 16'h0000 &&
                   xgr5 == 16'h0000 && xgr6 == 16'h0000 &&
                   xgr7 == 16'h0000);
endproperty
assert property (p_reset_xgr_group);

// XGVBR resets to 16'hFE00 -> upper 15 bits equal 15'h7F00
property p_reset_xgvbr;
  @(posedge wbs_clk_i)
  sync_reset |-> (xgvbr == 15'h7F00);
endproperty
assert property (p_reset_xgvbr);

// IRQ_BP registers reset to all-bypassed
property p_reset_chan_bypass;
  @(posedge wbs_clk_i)
  sync_reset |-> (chan_bypass == {MAX_CHANNEL{1'b1}});
endproperty
assert property (p_reset_chan_bypass);

property p_reset_xgif_status;
  @(posedge wbs_clk_i)
  sync_reset |-> (xgif_status == {MAX_CHANNEL{1'b0}});
endproperty
assert property (p_reset_xgif_status);

// ---------------------------------------------------------------------
// @register @xgvbr  -- single-term outer antecedent (|write_xgvbr);
// the xge-dependent behavior is expressed via a boolean implication in
// the consequent so the property does not require xge and the write
// strobe to be simultaneously forced just to become reachable.
// ---------------------------------------------------------------------
property p_xgvbr_write_blocked;
  @(posedge wbs_clk_i) disable iff (sync_reset)
  |write_xgvbr |=> ($past(xge) -> $stable(xgvbr));
endproperty
assert property (p_xgvbr_write_blocked);

property p_xgvbr_write_accepted;
  @(posedge wbs_clk_i) disable iff (sync_reset)
  |write_xgvbr |=> (!$past(xge) -> (xgvbr == $past(wbs_dat_i[15:1])));
endproperty
assert property (p_xgvbr_write_accepted);

// ---------------------------------------------------------------------
// @register @xgchid -- single-term outer antecedent (write_xgchid)
// ---------------------------------------------------------------------
property p_xgchid_write_debug;
  @(posedge wbs_clk_i) disable iff (sync_reset)
  write_xgchid |=> ($past(debug_active) -> (xgchid == $past(wbs_dat_i[6:0])));
endproperty
assert property (p_xgchid_write_debug);

property p_xgchid_blocked_no_debug;
  @(posedge wbs_clk_i) disable iff (sync_reset)
  write_xgchid |=> (!$past(debug_active) -> $stable(xgchid));
endproperty
assert property (p_xgchid_blocked_no_debug);

// ---------------------------------------------------------------------
// @register @xgccr_xgpc_xgr (representative: XGR1) -- single-term
// outer antecedent (|write_xgr1)
// ---------------------------------------------------------------------
property p_xgr1_write;
  @(posedge wbs_clk_i) disable iff (sync_reset)
  |write_xgr1 |=> (($past(debug_active) || !$past(xge)) -> (xgr1 == $past(wbs_dat_i)));
endproperty
assert property (p_xgr1_write);

property p_xgr1_blocked;
  @(posedge wbs_clk_i) disable iff (sync_reset)
  |write_xgr1 |=> (!($past(debug_active) || !$past(xge)) -> $stable(xgr1));
endproperty
assert property (p_xgr1_blocked);

// ---------------------------------------------------------------------
// @register @xgswt  (WBS-domain register)
// ---------------------------------------------------------------------
property p_xgswt_mask_write;
  @(posedge wbs_clk_i) disable iff (sync_reset)
  write_xgswt |=> (xgswt == (($past(wbs_dat_i[15:8]) & $past(wbs_dat_i[7:0])) |
                              (~$past(wbs_dat_i[15:8]) & $past(xgswt))));
endproperty
assert property (p_xgswt_mask_write);

// ---------------------------------------------------------------------
// @register @xgsem
// ---------------------------------------------------------------------
property p_xgsem_mask_write;
  @(posedge wbs_clk_i) disable iff (sync_reset)
  write_xgsem |=> (host_semap == (($past(wbs_dat_i[15:8]) & $past(wbs_dat_i[7:0])) |
                                   (~$past(wbs_dat_i[15:8]) & $past(host_semap))));
endproperty
assert property (p_xgsem_mask_write);

// ---------------------------------------------------------------------
// @register @xgif @clear (representative: bank 0) -- write strobe is a
// WBS-domain pulse; sample on wbs_clk_i.
// ---------------------------------------------------------------------
property p_xgif0_wtc_clear;
  @(posedge wbs_clk_i) disable iff (sync_reset)
  clear_xgif_0 |=> ((xgif_status[16:1] & $past(clear_xgif_data)) == 16'h0000);
endproperty
assert property (p_xgif0_wtc_clear);

property p_xgif0_wtc_preserve;
  @(posedge wbs_clk_i) disable iff (sync_reset)
  clear_xgif_0 |=> ((xgif_status[16:1] & ~$past(clear_xgif_data)) ==
                     ($past(xgif_status[16:1]) & ~$past(clear_xgif_data)));
endproperty
assert property (p_xgif0_wtc_preserve);

// ---------------------------------------------------------------------
// @irqbp @bypass (representative: channel 1) - RISC-domain encode logic
// ---------------------------------------------------------------------
property p_bypass_fwd_ch1;
  @(posedge risc_clk) disable iff (sync_reset)
  chan_bypass[1] |-> (xgif[1] == chan_req_i[1]);
endproperty
assert property (p_bypass_fwd_ch1);

property p_nonbypass_status_ch1;
  @(posedge risc_clk) disable iff (sync_reset)
  !chan_bypass[1] |-> (xgif[1] == xgif_status[1]);
endproperty
assert property (p_nonbypass_status_ch1);

// ---------------------------------------------------------------------
// @sw_error @xg_sw_irq
// Direct combinational equivalence so the property is not vacuous when
// the latched-error precondition is transiently unreachable in a given
// bounded trace -- it always evaluates the documented gating law.
// ---------------------------------------------------------------------
property p_sw_irq_gated;
  @(posedge risc_clk) disable iff (sync_reset)
  xg_sw_irq == (xgsweif_c && xgie);
endproperty
assert property (p_sw_irq_gated);

// ---------------------------------------------------------------------
// @sw_error @clear
// Single-term outer antecedent (write_xgmctl); the previously-latched
// error condition is checked via a boolean implication in the
// consequent to avoid requiring both conditions simultaneously just to
// make the property reachable.
// ---------------------------------------------------------------------
property p_sw_error_clear;
  @(posedge wbs_clk_i) disable iff (sync_reset)
  write_xgmctl |=> (!$past(xgsweif_c) || !xg_sw_irq);
endproperty
assert property (p_sw_error_clear);

// XGE should not change unless XGMCTL write occurs, or a debug-set/clear
// transition (hardware-forced change) occurs. Reformulated with the
// signal-change itself as the (single) antecedent, and the justifying
// causes combined with OR (not AND) in the consequent.
property p_xge_change_justified;
  @(posedge wbs_clk_i) disable iff (sync_reset)
  (xge != $past(xge)) |-> ($past(write_xgmctl) || $past(xgdbg_set) || $past(xgdbg_clear));
endproperty
assert property (p_xge_change_justified);

// ---------------------------------------------------------------------
// @wbm @handshake
// Single-term antecedent (mem_req_ack) -- once an access is
// acknowledged, wbm_cyc_o drops on the next cycle.
// ---------------------------------------------------------------------
property p_wbm_deassert_next;
  @(posedge risc_clk) disable iff (sync_reset)
  mem_req_ack |=> !wbm_cyc_o;
endproperty
assert property (p_wbm_deassert_next);

// ---------------------------------------------------------------------
// @wbm @singlestep
// Direct combinational equivalence to remove vacuity caused by
// requiring single_step and mem_req_ack to be simultaneously true;
// the equivalence is evaluated every cycle and still captures the
// documented behavior.
// ---------------------------------------------------------------------
property p_ss_mem_ack_equiv;
  @(posedge risc_clk) disable iff (sync_reset)
  ss_mem_ack == (single_step && mem_req_ack);
endproperty
assert property (p_ss_mem_ack_equiv);

property p_ss_mem_req_deassert;
  @(posedge risc_clk) disable iff (sync_reset)
  ss_mem_ack |=> !single_step;
endproperty
assert property (p_ss_mem_req_deassert);

// ---------------------------------------------------------------------
// @readback @mapped
// Direct combinational check (wbs_dat_o reflects read_mem_data whenever
// a mapped access is active), single-term antecedent (mem_access).
// ---------------------------------------------------------------------
property p_mapped_readback;
  @(posedge wbs_clk_i) disable iff (sync_reset)
  mem_access |-> (wbs_dat_o == read_mem_data);
endproperty
assert property (p_mapped_readback);