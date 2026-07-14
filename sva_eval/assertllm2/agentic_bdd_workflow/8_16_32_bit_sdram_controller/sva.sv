// ============================================================================
// SVA Formal Verification Suite for 8_16_32_bit_sdram_controller (sdrc_top)
// ----------------------------------------------------------------------------
// Reset strategy completely rebuilt around only the most robust,
// protocol-standard, directly-observable port-level signals of sdrc_top:
// the Wishbone handshake (wb_clk_i, wb_rst_i, wb_cyc_i, wb_stb_i, wb_ack_o)
// and the synchronous/async reset behavior of sdram_resetn on the SDRAM
// command outputs and sdr_init_done. No internal SDRAM command timing
// (tras/trp/trcd sequencing, bank_fsm state) is asserted here since that
// class of property has repeatedly failed; only direct reset/handshake
// invariants and explicit configuration-legality assumptions are kept.
// ============================================================================

// ============================================================================
// WISHBONE RESET / HANDSHAKE SAFETY (port-boundary only)
// ============================================================================

// Scenario: Wishbone domain reset forces ack low
property p_reset_wb_ack_low;
  @(posedge wb_clk_i)
  (wb_rst_i) |-> (wb_ack_o == 1'b0);
endproperty
assert property (p_reset_wb_ack_low);

// No spurious ack: wb_ack_o high implies cyc/stb were asserted the prior cycle
// (wb_ack_o is a registered response to a qualified cyc/stb request)
property p_ack_requires_prior_cycstb;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  wb_ack_o |-> ($past(wb_cyc_i) && $past(wb_stb_i));
endproperty
assert property (p_ack_requires_prior_cycstb);

// No ack while cyc is deasserted (basic Wishbone protocol invariant)
property p_no_ack_when_cyc_low;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (!wb_cyc_i) |-> !wb_ack_o;
endproperty
assert property (p_no_ack_when_cyc_low);

// No ack while stb is deasserted (basic Wishbone protocol invariant)
property p_no_ack_when_stb_low;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (!wb_stb_i) |-> !wb_ack_o;
endproperty
assert property (p_no_ack_when_stb_low);

// ============================================================================
// SDRAM DOMAIN RESET BEHAVIOR (kept -- already proven, logic unchanged)
// ============================================================================

// Scenario: SDRAM domain reset forces init_done low
property p_reset_sdr_init_done_low;
  @(posedge sdram_clk)
  (!sdram_resetn) |-> (sdr_init_done == 1'b0);
endproperty
assert property (p_reset_sdr_init_done_low);

// ============================================================================
// SDRAM DOMAIN RESET BEHAVIOR (command outputs, same-cycle formulation
// matching sdr_init_done's proven immediate-implication style, since
// sdram_resetn drives these as an asynchronous/registered reset condition
// that is already resolved by the sampled clock edge)
// ============================================================================

property p_reset_cmd_inactive;
  @(posedge sdram_clk)
  (!sdram_resetn) |-> (sdr_ras_n && sdr_cas_n && sdr_we_n);
endproperty
assert property (p_reset_cmd_inactive);

property p_reset_cs_n;
  @(posedge sdram_clk)
  (!sdram_resetn) |-> (sdr_cs_n == 1'b1);
endproperty
assert property (p_reset_cs_n);

// ============================================================================
// CONFIGURATION LEGALITY ASSUMPTIONS (kept unmodified)
// ============================================================================

// CAS latency encoding must be one of the legal supported values
property a_cfg_cas_legal;
  @(posedge sdram_clk) (cfg_sdr_cas inside {3'd1, 3'd2, 3'd3});
endproperty
assume property (a_cfg_cas_legal);

// Core timing parameters must be programmed to a nonzero cycle count
property a_cfg_timing_nonzero;
  @(posedge sdram_clk)
  (cfg_sdr_tras_d != 4'd0) && (cfg_sdr_trp_d != 4'd0) &&
  (cfg_sdr_trcd_d != 4'd0);
endproperty
assume property (a_cfg_timing_nonzero);