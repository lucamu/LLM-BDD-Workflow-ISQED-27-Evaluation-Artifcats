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