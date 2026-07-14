// ============================================================
// Module: TopModule
// Purpose: Combinationally reverse the bit ordering of an 8-bit
//          input "in" onto the 8-bit output "out".
//          out[i] = in[7-i] for i = 0..7
// ============================================================
module TopModule (
    input  [7:0] in,
    output [7:0] out
);

    // Scenario: Output bit 0 equals input bit 7
    assign out[0] = in[7];

    // Scenario: Output bit 1 equals input bit 6
    assign out[1] = in[6];

    // Scenario: Output bit 2 equals input bit 5
    assign out[2] = in[5];

    // Scenario: Output bit 3 equals input bit 4
    assign out[3] = in[4];

    // Scenario: Output bit 4 equals input bit 3
    assign out[4] = in[3];

    // Scenario: Output bit 5 equals input bit 2
    assign out[5] = in[2];

    // Scenario: Output bit 6 equals input bit 1
    assign out[6] = in[1];

    // Scenario: Output bit 7 equals input bit 0
    assign out[7] = in[0];

    // Scenario: Full output is bit-reversed input
    // out[7:0] == {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]}
    // (implied by the eight single-bit assignments above)

    // Scenario: Reversing twice returns original value
    // Since this module is a pure involution (reverse(reverse(x)) == x),
    // chaining two instances of TopModule naturally satisfies this
    // scenario without additional logic.

    // Scenario: Palindromic input produces identical output
    // If in[0]==in[7], in[1]==in[6], in[2]==in[5], in[3]==in[4],
    // then out == in automatically due to the bit-reversal mapping above.

    // Scenario: Output depends only on current input with no memory
    // The module contains only continuous (combinational) assignments,
    // no registers or state, so out is purely a function of in.

endmodule