// ============================================================================
// Module: TopModule
// Purpose: Combinational XNOR-XOR circuit
//          xnor_result = XNOR(in1, in2)
//          out         = XOR(xnor_result, in3)
//
// Covers all scenarios:
//  - Core functional composition: out = (~(in1 ^ in2)) ^ in3
//  - Truth-table cases (equal/differing inputs, in3 0/1)
//  - Symmetry in in1/in2 (XNOR is symmetric)
//  - Invariant: toggling in3 inverts out
//  - Invariant: inverting both in1 and in2 leaves xnor_result unchanged
//  - Purely combinational: no clock/state dependency
// ============================================================================
module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    // Internal signal representing XNOR(in1, in2)
    wire xnor_result;

    // XNOR of in1 and in2 (symmetric in in1/in2)
    assign xnor_result = ~(in1 ^ in2);

    // Final output: XOR of xnor_result and in3
    // Toggling in3 inverts out (invariant scenario)
    assign out = xnor_result ^ in3;

endmodule