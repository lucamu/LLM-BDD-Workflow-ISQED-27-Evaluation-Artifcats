// =============================================================================
// Module: TopModule
// Purpose: 2-Input NOR Gate Combinational Logic
//
// Implements: out = NOT (in1 OR in2)
//
// Scenario coverage:
//   - "Output is the logical NOR of both inputs"      -> assign below
//   - "Output is 1 only when both inputs are 0"        -> 0 NOR 0 = 1
//   - "Output is 0 when in1 is 1 regardless of in2"     -> 1 NOR B = 0
//   - "Output is 0 when in2 is 1 regardless of in1"     -> A NOR 1 = 0
//   - "Output is 0 when both inputs are 1"              -> 1 NOR 1 = 0
//   - "Output is symmetric with respect to input order" -> OR is commutative,
//                                                          so NOR(A,B) = NOR(B,A)
//   - "No registers or memory elements"                 -> single continuous
//                                                          assign, no always
//                                                          block, no clock/reset
// =============================================================================
module TopModule (
    input  in1,
    input  in2,
    output out
);

    // Pure combinational NOR logic: out = NOT (in1 OR in2)
    // Covers all truth-table scenarios and symmetry scenario since
    // (in1 | in2) is commutative in in1/in2.
    assign out = ~(in1 | in2);

endmodule