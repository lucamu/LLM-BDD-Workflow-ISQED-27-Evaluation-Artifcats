// ============================================================================
// Module: TopModule
// Purpose: Emulates the 7458 Quad AND / Dual OR Gate chip.
//          - p1y = (p1a & p1b & p1c) | (p1d & p1e & p1f)   [two 3-input AND gates ORed]
//          - p2y = (p2a & p2b) | (p2c & p2d)                [two 2-input AND gates ORed]
//          Purely combinational, no clock/reset.
// ============================================================================
module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    output p1y,

    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p2y
);

    // ------------------------------------------------------------------
    // Scenario: p1y equals OR of two 3-input AND terms
    // Also covers: independence from p2 inputs, allzero, allone,
    // firstterm, secondterm, noterm scenarios (all follow from this
    // combinational equation).
    // ------------------------------------------------------------------
    assign p1y = (p1a & p1b & p1c) | (p1d & p1e & p1f);

    // ------------------------------------------------------------------
    // Scenario: p2y equals OR of two 2-input AND terms
    // Also covers: independence from p1 inputs, allzero, allone,
    // firstterm, secondterm, noterm scenarios (all follow from this
    // combinational equation).
    // ------------------------------------------------------------------
    assign p2y = (p2a & p2b) | (p2c & p2d);

endmodule