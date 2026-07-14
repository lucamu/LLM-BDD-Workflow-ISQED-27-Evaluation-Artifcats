// ============================================================================
// Module: TopModule
// Purpose: Combinational logic implementing:
//   1. Bitwise OR of a and b (out_or_bitwise)
//   2. Logical OR of a and b (out_or_logical)
//   3. Bitwise NOT concatenation of b and a (out_not)
// This is a pure combinational design with no clock or reset.
// ============================================================================
module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // @bitwise_or: per-bit OR of a and b
    assign out_or_bitwise = a | b;

    // @logical_or_both_zero, @logical_or_general:
    // out_or_logical is 1 if either a or b is nonzero, 0 only if both are zero
    assign out_or_logical = a || b;

    // @not_lower_half, @not_upper_half, @not_full_concatenation:
    // out_not = {NOT(b), NOT(a)} - upper half is ~b, lower half is ~a
    assign out_not = {~b, ~a};

    // @combinational_no_state:
    // All outputs are continuous assignments driven directly by current
    // values of a and b with no internal state elements (no registers,
    // no latches), so outputs always reflect only the present inputs.

endmodule