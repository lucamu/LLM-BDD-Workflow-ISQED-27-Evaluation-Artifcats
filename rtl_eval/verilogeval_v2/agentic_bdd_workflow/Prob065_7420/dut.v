// ============================================================================
// Module: TopModule
// Purpose: Dual 4-Input NAND Gate (7420 Equivalent)
//          Implements two independent, combinational 4-input NAND gates.
//          No clock or reset - purely combinational logic.
// ============================================================================
module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    output p1y,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p2y
);

    // -------------------------------------------------------------------
    // First NAND gate: p1y = NOT (p1a AND p1b AND p1c AND p1d)
    // Covers scenarios: nand_gate1, all_ones/gate1, any_zero/gate1,
    // independence (p1y depends only on p1a-p1d), commutativity/gate1,
    // no_state/gate1 (pure combinational assign has no memory).
    // -------------------------------------------------------------------
    assign p1y = ~(p1a & p1b & p1c & p1d);

    // -------------------------------------------------------------------
    // Second NAND gate: p2y = NOT (p2a AND p2b AND p2c AND p2d)
    // Covers scenarios: nand_gate2, all_ones/gate2, any_zero/gate2,
    // independence (p2y depends only on p2a-p2d), commutativity/gate2,
    // no_state/gate2 (pure combinational assign has no memory).
    // -------------------------------------------------------------------
    assign p2y = ~(p2a & p2b & p2c & p2d);

endmodule