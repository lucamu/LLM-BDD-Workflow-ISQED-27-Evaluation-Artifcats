// ============================================================================
// Module: TopModule
// Purpose: 100-bit 2-to-1 combinational multiplexer.
//          Selects between operand A and operand B based on select signal.
//          No clock/reset - purely combinational.
// ============================================================================
module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Combinational mux logic implementing all formal scenarios:
    // - @select-zero: sel == 0 -> out = a
    // - @select-one : sel == 1 -> out = b
    // - @general-mux-behavior: out = (sel == 0) ? a : b
    // - @no-dependency-on-unselected-input: only the selected operand
    //   drives out, the other operand has no effect (handled naturally
    //   by the ternary mux since only one branch is chosen)
    // - @equal-operands: if a == b, out equals that common value
    //   regardless of sel (automatically satisfied by mux behavior)
    // - @bit-width-integrity: output width matches input width (100 bits),
    //   no truncation/extension since assignment widths match exactly
    assign out = sel ? b : a;

endmodule