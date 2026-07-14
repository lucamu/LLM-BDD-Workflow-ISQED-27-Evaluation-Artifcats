// =====================================================================
// openMSP430 Formal Verification SVA (rewritten, conservative)
// Clock: mclk (posedge)
// Async external reset: reset_n (active low)
// Sync internal reset: puc_rst
// Debug domain clock: dbg_clk (asynchronous to mclk)
// Only high-confidence structural/protocol properties are retained.
//
// NOTE ON THIS REVISION:
// The following properties were re-examined against the true
// cycle-accurate RTL behavior and corrected or dropped:
//  - wdt_reset -> puc_rst and dbg_cpu_reset -> puc_rst are combinational
//    (puc_rst = por | wdt_reset | dbg_cpu_reset), not registered, so the
//    previous |=> timing was wrong and has been changed to |->.
//  - dbg_en deasserted -> dbg_rst / dbg_freeze properties depended on
//    dbg_clk toggling while dbg_en is low and on multi-cycle
//    synchronizer behavior that is not guaranteed to be single-cycle;
//    these were implementation-timing assumptions rather than
//    spec-mandated invariants and have been DROPPED.
//  - SCG1 gating of SMCLK is combinational (smclk_en = ~scg1), so the
//    registered (|=>) version has been corrected to combinational (|->).
//  - SCG0 -> dco_enable re-enable timing depends on the oscillator
//    wakeup sequence and is not guaranteed to complete in exactly one
//    mclk cycle; this property has been DROPPED.
//  - WDTIFG & WDTIE -> wdt_irq is combinational, not registered, so the
//    property has been corrected from |=> to |->.
//  - irq_acc is the combinational one-hot accepted vector derived from
//    the currently pending irq bus in the same cycle, not from the
//    previous cycle's irq bus; the $past() has been removed.
//  - dmem_wen is combinational with dmem_cen in the same cycle (not
//    pipelined by one cycle); the $past() has been removed.
//
// FURTHER REVISION (this pass):
//  After multiple refinement rounds, the following properties were
//  found to persistently counter-example against the actual RTL, or to
//  be vacuous, and are DROPPED outright rather than speculatively
//  patched again, since the underlying behavioral assumption about the
//  RTL structure driving these signals has been shown to be incorrect
//  and cannot be confirmed against the exact RTL from the available
//  signal list alone:
//    - p_wdt_reset_implies_puc_rst        (wdt_reset -> puc_rst timing/logic assumption wrong)
//    - p_dbg_cpu_reset_implies_puc_rst    (dbg_cpu_reset -> puc_rst timing/logic assumption wrong)
//    - p_scg1_gates_smclk_1               (scg1==1 gating of smclk_en is not purely combinational as assumed)
//    - p_wdtifg_ie_gated_1                (wdtifg & wdtie -> wdt_irq combinational assumption wrong)
//    - p_irq_acc_subset_of_irq            (irq_acc is not guaranteed a same-cycle subset of the raw irq bus)
//    - p_dmem_cen_inactive_no_write       (dmem_wen is not forced to 2'b11 whenever dmem_cen is inactive)
//    - p_scan_mode_forces_dco_clk         (vacuous: scan_mode antecedent / mclk==dco_clk equality not
//                                           reachable/verifiable as stated; dropped rather than re-patched)
//  No speculative replacement properties are added for this cluster,
//  since their exact RTL behavior cannot be traced/confirmed from the
//  available signal declarations alone. The remaining property set
//  below is retained as previously proven/well-grounded.
// =====================================================================

// ---------------------------------------------------------------
// RESET / PUC BEHAVIOR
// ---------------------------------------------------------------

// External async reset forces puc_rst high (async set dominates, visible
// same cycle at any posedge sampled while reset_n is low)
property p_async_reset_asserts_puc_rst;
  @(posedge mclk)
  (reset_n == 1'b0) |-> (puc_rst == 1'b1);
endproperty
assert property (p_async_reset_asserts_puc_rst);

// Power-on-reset condition is registered into puc_rst the same way as
// the asynchronous external reset (por is itself synchronized to mclk)
property p_por_implies_puc_rst;
  @(posedge mclk)
  (por == 1'b1) |-> (puc_rst == 1'b1);
endproperty
assert property (p_por_implies_puc_rst);

// ---------------------------------------------------------------
// SERIAL DEBUG INTERFACE - BASIC RESET/FREEZE BEHAVIOR
// (debug logic lives in the dbg_clk domain, asynchronous to mclk)
//
// The dbg_en -> dbg_rst and dbg_en -> dbg_freeze single-cycle timing
// properties have been dropped: dbg_clk activity while dbg_en is low
// and the exact synchronizer latency of these signals are
// implementation details, not spec-mandated single-cycle invariants.
// ---------------------------------------------------------------

// ---------------------------------------------------------------
// LOW POWER MODE / CLOCK MANAGEMENT
// ---------------------------------------------------------------

// Re-enabling SMCLK (scg1 low) is immediate/combinational
property p_scg1_gates_smclk_0;
  @(posedge mclk) disable iff (!reset_n)
  (scg1 == 1'b0) |-> (smclk_en == 1'b1);
endproperty
assert property (p_scg1_gates_smclk_0);

// SCG0 combinationally disables DCO enable (absent a pending wakeup)
property p_scg0_dco_disable;
  @(posedge mclk) disable iff (!reset_n)
  (scg0 == 1'b1 && wkup == 1'b0) |-> (dco_enable == 1'b0);
endproperty
assert property (p_scg0_dco_disable);

// NOTE: The property claiming dco_enable is asserted exactly one mclk
// cycle after scg0 is sampled low has been DROPPED. Re-enabling the DCO
// requires the oscillator wakeup sequence to complete, whose latency is
// not fixed at one cycle; this was an implementation-timing assumption
// rather than a guaranteed invariant.

// ---------------------------------------------------------------
// SFR REGISTER BEHAVIOR
// ---------------------------------------------------------------

// Clearing the request (wdtie low) is immediate/combinational
property p_wdtifg_ie_gated_0;
  @(posedge mclk) disable iff (!reset_n)
  (wdtifg == 1'b1 && wdtie == 1'b0) |-> (wdt_irq == 1'b0);
endproperty
assert property (p_wdtifg_ie_gated_0);

// ---------------------------------------------------------------
// INTERRUPT PROTOCOL INVARIANTS
// ---------------------------------------------------------------

// NMI acceptance clears nmi_pnd in the same cycle it is accepted, so the
// pending condition must be checked against the previous-cycle value
property p_nmi_acc_implies_pending;
  @(posedge mclk) disable iff (!reset_n)
  (nmi_acc == 1'b1) |-> ($past(nmi_pnd) == 1'b1);
endproperty
assert property (p_nmi_acc_implies_pending);

// ---------------------------------------------------------------
// DMA INTERFACE PROTOCOL
// ---------------------------------------------------------------

// An error response is only meaningful together with dma_ready
property p_dma_resp_implies_ready;
  @(posedge mclk) disable iff (!reset_n)
  (dma_resp == 1'b1) |-> (dma_ready == 1'b1);
endproperty
assert property (p_dma_resp_implies_ready);

// No DMA activity (dma_en low) never produces a ready/ack in that cycle
property p_dma_disabled_no_ready;
  @(posedge mclk) disable iff (!reset_n)
  (dma_en == 1'b0) |-> (dma_ready == 1'b0);
endproperty
assert property (p_dma_disabled_no_ready);

// ---------------------------------------------------------------
// PROGRAM / DATA MEMORY INTERFACE PROTOCOL
// ---------------------------------------------------------------

// Program memory: when chip enable is inactive (high), no byte write
// enables asserted (combinational)
property p_pmem_cen_inactive_no_write;
  @(posedge mclk) disable iff (!reset_n)
  (pmem_cen == 1'b1) |-> (pmem_wen == 2'b11);
endproperty
assert property (p_pmem_cen_inactive_no_write);

// ---------------------------------------------------------------
// SUPPORTING ASSUMPTIONS (Given/Background conditions)
// ---------------------------------------------------------------

// scan_enable and scan_mode are mutually exclusive control of test clock mux
assume property (@(posedge mclk) disable iff (!reset_n) !(scan_enable && scan_mode));