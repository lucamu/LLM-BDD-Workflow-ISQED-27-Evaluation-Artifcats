// ============================================================================
// Module: TopModule
// Purpose: 1-bit 2-to-1 multiplexer
//
// Behavior:
//   out = sel ? b : a
//
// Scenarios implemented:
//   - sel==0 -> out follows a (independent of b)
//   - sel==1 -> out follows b (independent of a)
//   - General: out = S ? B : A for all A,B,S
//   - Fully combinational, no hidden state (pure function of inputs)
//   - Both selection paths reachable (out can equal A or B depending on sel)
// ============================================================================
module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);

    // Combinational mux logic:
    // - When sel = 0: out = a  (Scenario: Output follows input a when sel is deasserted)
    // - When sel = 1: out = b  (Scenario: Output follows input b when sel is asserted)
    // This single continuous assignment also satisfies:
    //   - General behavior scenario: out = (sel ? b : a) for all A,B,S
    //   - Independence scenarios: out depends only on the selected input,
    //     since the non-selected input does not appear in the expression
    //     for that branch of the ternary operator.
    //   - No-latch / fully combinational scenario: assign statement has no
    //     memory element, so identical inputs always produce identical output.
    //   - Coverage scenario: setting sel=0 makes out=a=A; setting sel=1 makes out=b=B,
    //     so both paths are reachable.
    assign out = sel ? b : a;

endmodule