// ============================================================================
// Module: TopModule
// Purpose: Combinational two-input AND gate.
//          Implements q = a AND b, satisfying all specified scenarios:
//            - Output reflects logical AND of inputs (core-logic)
//            - Output is 0 when both inputs are 0 (edge-case)
//            - Output is 0 when only a is asserted (edge-case)
//            - Output is 0 when only b is asserted (edge-case)
//            - Output is 1 when both inputs are asserted (edge-case)
//            - Output never exceeds either input (invariant)
//            - Output is stable/deterministic for identical inputs (invariant)
// ============================================================================
module TopModule (
    input  a,
    input  b,
    output q
);

    // Combinational AND logic: q = a & b
    // Covers all scenarios since AND truth table satisfies:
    //   a=0,b=0 -> q=0
    //   a=1,b=0 -> q=0
    //   a=0,b=1 -> q=0
    //   a=1,b=1 -> q=1
    // and q <= a, q <= b always holds for AND.
    // Purely combinational assignment guarantees determinism/stability
    // for identical inputs (no internal state).
    assign q = a & b;

endmodule