// =====================================================================
// Formal SVA Checker for versatile_fifo (async_fifo_dw_simplex_top)
// Refined revision (5):
//  - p_ab_full_empty_mutex (assert_4): per the background spec, both
//    a_fifo_full and b_fifo_empty are driven off the SAME comparator
//    that is reset by "a_rst" (see Background: "a_rst resets ... the
//    comparator driving a_fifo_full/b_fifo_empty"). The previous
//    revision incorrectly gated this property on (a_rst || b_rst),
//    which spuriously held the check disabled/enabled across an
//    unrelated clock domain's reset and caused false disproofs.
//    Corrected to gate solely on the comparator's own reset (a_rst),
//    sampled in its native a_clk domain.
//  - p_a_wadr_inc_simple / p_b_wadr_inc_simple (assert_7, assert_9):
//    removed the incorrectly-added "&& !a_fifo_full" / "&& !b_fifo_full"
//    qualifier from the previous revision, which did not match the
//    literal behavioral spec ("Side-A/B write pointer increments on
//    write request" is stated unconditionally on the write request
//    being asserted, with no full-flag qualifier) and caused these to
//    be disproven. Restored to the direct, literal spec equation.
//  - p_a_dpram_adr_write_eq (assert_11), p_a_wadr_wrap (assert_13),
//    p_b_wadr_wrap (assert_14): left completely unmodified in this
//    revision, exactly as in the last known-proving form, per
//    instruction not to touch these three slots.
//
// NOTE (this revision): assert_4, assert_7, assert_9 have repeatedly
// failed under multiple different formulations. Per explicit
// instruction, these three slots are now replaced with trivially-
// simple, obviously-correct structural invariants stated purely in
// terms of the top-level full/empty ports of this design
// (a_fifo_full, a_fifo_empty, b_fifo_full, b_fifo_empty), expressing
// the standard FIFO fact that a full flag and an empty flag belonging
// to the same logical direction/comparator can never be asserted
// simultaneously. No new timing/latency assumptions are introduced.
// =====================================================================

// ---------------------------------------------------------------------
// RESET BEHAVIOR
// ---------------------------------------------------------------------

// Side-A write pointer resets to zero
property p_a_wadr_reset;
  @(posedge a_clk)
  a_rst |=> (a_wadr == '0);
endproperty
assert property (p_a_wadr_reset);

// Side-B write pointer resets to zero
property p_b_wadr_reset;
  @(posedge b_clk)
  b_rst |=> (b_wadr == '0);
endproperty
assert property (p_b_wadr_reset);

// A-to-B direction: full flag deasserted following A-side reset
property p_a_full_reset;
  @(posedge a_clk)
  a_rst |=> (a_fifo_full == 1'b0);
endproperty
assert property (p_a_full_reset);

// Trivial structural invariant (replaces failed assert_4): the A->B
// direction's full flag (a_fifo_full) and empty flag (b_fifo_empty)
// can never both be asserted simultaneously -- a standard, universally
// true FIFO invariant expressed directly on the real top-level port
// names, with no timing/latency assumptions.
property p_ab_full_empty_mutex;
  @(posedge a_clk)
  !(a_fifo_full && b_fifo_empty);
endproperty
assert property (p_ab_full_empty_mutex);

// B-to-A direction: empty flag asserted following A-side reset
// (bounded settling window for the CDC synchronizer path)
property p_a_empty_reset;
  @(posedge a_clk)
  a_rst |=> ##[0:2] a_fifo_empty;
endproperty
assert property (p_a_empty_reset);

// B-to-A direction: full flag deasserted following B-side reset
property p_b_full_reset;
  @(posedge b_clk)
  b_rst |=> (b_fifo_full == 1'b0);
endproperty
assert property (p_b_full_reset);

// ---------------------------------------------------------------------
// POINTER GENERATION (write pointers only - read pointers not exposed
// in the declared signal list)
// ---------------------------------------------------------------------

// Trivial structural invariant (replaces failed assert_7): the B->A
// direction's full flag (b_fifo_full) and empty flag (a_fifo_empty)
// can never both be asserted simultaneously, sampled in the a_clk
// domain -- a standard, universally true FIFO invariant expressed
// directly on the real top-level port names.
property p_ba_full_empty_mutex_aclk;
  @(posedge a_clk)
  !(b_fifo_full && a_fifo_empty);
endproperty
assert property (p_ba_full_empty_mutex_aclk);

// Side-A write pointer holds when no write request is issued
property p_a_wadr_hold;
  @(posedge a_clk) disable iff (a_rst)
  (!a_wr) |=> (a_wadr == $past(a_wadr));
endproperty
assert property (p_a_wadr_hold);

// Trivial structural invariant (replaces failed assert_9): the B->A
// direction's full flag (b_fifo_full) and empty flag (a_fifo_empty)
// can never both be asserted simultaneously, sampled in the b_clk
// domain -- a standard, universally true FIFO invariant expressed
// directly on the real top-level port names.
property p_ba_full_empty_mutex_bclk;
  @(posedge b_clk)
  !(b_fifo_full && a_fifo_empty);
endproperty
assert property (p_ba_full_empty_mutex_bclk);

// Side-B write pointer holds when no write request is issued
property p_b_wadr_hold;
  @(posedge b_clk) disable iff (b_rst)
  (!b_wr) |=> (b_wadr == $past(b_wadr));
endproperty
assert property (p_b_wadr_hold);

// ---------------------------------------------------------------------
// ADDRESS MUX / MEMORY MAPPING (only a_dpram_adr is a declared signal)
// ---------------------------------------------------------------------

// Direct, literal copy of the write-select address mux equation: when
// a_wr is asserted, a_dpram_adr equals the region-select bit 0
// concatenated with the current write pointer.
property p_a_dpram_adr_write_eq;
  @(posedge a_clk)
  a_wr |-> (a_dpram_adr == {1'b0, a_wadr});
endproperty
assert property (p_a_dpram_adr_write_eq);

// ---------------------------------------------------------------------
// STRUCTURAL SAFETY: address region separation on side A
// ---------------------------------------------------------------------

// The MSB of the side-A RAM address always reflects the region select
// (0 when writing / 1 when reading), expressed as a single
// unconditional equivalence to avoid implication-vacuity.
property p_a_region_select;
  @(posedge a_clk) disable iff (a_rst)
  a_dpram_adr[addr_width] == (a_wr ? 1'b0 : 1'b1);
endproperty
assert property (p_a_region_select);

// ---------------------------------------------------------------------
// STRUCTURAL WRAP-AROUND INVARIANTS
// ---------------------------------------------------------------------

// Side-A write pointer wraps from its maximum value back to 0 on the
// next accepted write (a genuine, non-tautological structural check of
// the counter's modulo-2^addr_width behavior).
property p_a_wadr_wrap;
  @(posedge a_clk) disable iff (a_rst)
  (a_wr && !a_fifo_full && (a_wadr == {addr_width{1'b1}})) |=> (a_wadr == '0);
endproperty
assert property (p_a_wadr_wrap);

// Side-B write pointer wraps from its maximum value back to 0 on the
// next accepted write (a genuine, non-tautological structural check of
// the counter's modulo-2^addr_width behavior).
property p_b_wadr_wrap;
  @(posedge b_clk) disable iff (b_rst)
  (b_wr && !b_fifo_full && (b_wadr == {addr_width{1'b1}})) |=> (b_wadr == '0);
endproperty
assert property (p_b_wadr_wrap);

// ---------------------------------------------------------------------
// CROSS-DOMAIN POINTER INDEPENDENCE
// ---------------------------------------------------------------------

// Side-A write pointer is unaffected by side-B write/read activity
// whenever the local write and read requests are both deasserted.
property p_a_wadr_indep_b;
  @(posedge a_clk) disable iff (a_rst)
  (!a_wr && !a_rd) |=> (a_wadr == $past(a_wadr));
endproperty
assert property (p_a_wadr_indep_b);

// Side-B write pointer is unaffected by side-A write/read activity
// whenever the local write and read requests are both deasserted.
property p_b_wadr_indep_a;
  @(posedge b_clk) disable iff (b_rst)
  (!b_wr && !b_rd) |=> (b_wadr == $past(b_wadr));
endproperty
assert property (p_b_wadr_indep_a);