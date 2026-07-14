// =====================================================================
// Module: TopModule
// Purpose: Emulates a dual-edge triggered flip-flop using only
//          single-edge triggered flip-flops (as required for FPGAs
//          lacking native dual-edge FF support).
//
// Technique:
//   - A "high-phase" register (qh) captures d on the rising edge.
//   - A "low-phase" register (ql) captures d on the falling edge.
//   - A combinational mux selects between qh and ql based on the
//     current level of clk, producing an output that updates on
//     both edges, exactly emulating a true dual-edge flip-flop.
//
// Note: Per specification, no explicit reset signal is used/required
//       for this circuit (Background: "the circuit contains no
//       explicit reset signal").
// =====================================================================

module TopModule (
    input  clk,
    input  d,
    output q
);

    // ------------------------------------------------------------------
    // Register capturing d on the RISING edge of clk
    // Implements: @rising_edge @capture
    //   "Output captures input on rising clock edge"
    // ------------------------------------------------------------------
    reg qh;
    always @(posedge clk) begin
        qh <= d;  // capture D immediately before rising edge -> q after edge
    end

    // ------------------------------------------------------------------
    // Register capturing d on the FALLING edge of clk
    // Implements: @falling_edge @capture
    //   "Output captures input on falling clock edge"
    // ------------------------------------------------------------------
    reg ql;
    always @(negedge clk) begin
        ql <= d;  // capture D immediately before falling edge -> q after edge
    end

    // ------------------------------------------------------------------
    // Combinational mux selecting the appropriate captured value.
    //
    // When clk is high: the most recent update happened on the rising
    // edge, so q reflects qh.
    // When clk is low: the most recent update happened on the falling
    // edge, so q reflects ql.
    //
    // This mux does NOT introduce new capture behavior; it merely
    // selects the already-registered value based on clk level, so:
    //
    // Implements: @stability @no_glitch
    //   "Output remains stable between clock edges" -- because qh/ql
    //   only change on their respective edges, and the mux selection
    //   (clk level) is stable between edges, q cannot glitch.
    //
    // Implements: @dual_edge @full_period
    //   "Output updates exactly twice per clock period" -- once via
    //   qh update (rising edge) reflected while clk=1, and once via
    //   ql update (falling edge) reflected while clk=0.
    //
    // Implements: @no_combinational_leak
    //   "Output does not change without a clock edge" -- since qh, ql,
    //   and clk are all unchanged between edges, q (a pure function of
    //   these) cannot change either, regardless of d changing.
    //
    // Implements: @equivalence @behavioral
    //   "Equivalence to ideal dual-edge flip-flop" -- at each edge,
    //   the corresponding register captures D, and the mux immediately
    //   (combinationally) reflects that captured value as q, matching
    //   ideal dual-edge FF behavior for both edge types.
    // ------------------------------------------------------------------
    assign q = clk ? qh : ql;

endmodule