// ============================================================================
// Module:     TopModule
// Purpose:    8-bit 2-to-1 Multiplexer (Bug-Fixed)
//             Correctly outputs full 8-bit width when selecting between
//             operand A and operand B based on sel, avoiding the previous
//             truncation bug caused by a 1-bit output declaration.
// ============================================================================
module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Combinational mux logic, full 8-bit width (no truncation)
    // Scenario @core @select-a: sel == 0 -> out = a
    // Scenario @core @select-b: sel == 1 -> out = b
    // Scenario @width @no-truncation: all 8 bits of a/b preserved
    // Scenario @bitwise @per-bit: equivalent to ((~sel_rep & a) | (sel_rep & b))
    // Scenario @equivalence @exhaustive: equivalent to ternary (sel==0)?a:b
    // Scenario @stability @no-x-no-z: fully defined for all valid sel/a/b
    // Scenario @symmetry @a-equals-b: if a==b, out==a regardless of sel
    assign out = sel ? b : a;

endmodule