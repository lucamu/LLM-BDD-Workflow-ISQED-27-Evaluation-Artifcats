// ============================================================
// Module: TopModule
// Purpose: Combinational 3-input OR function.
//          Implements out = a | b | c
//
// Scenarios covered:
//   - Output equals logical OR of all three inputs
//   - Output is zero only when all inputs are zero
//   - Output is one when a is asserted regardless of b,c
//   - Output is one when b is asserted regardless of a,c
//   - Output is one when c is asserted regardless of a,b
//   - Output never depends on hidden state (pure combinational,
//     no registers, no clock/reset -> always consistent)
// ============================================================
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Combinational logic: out is 0 only when a=0,b=0,c=0,
    // otherwise out is 1 (covers all edge-case scenarios above)
    assign out = a | b | c;

endmodule