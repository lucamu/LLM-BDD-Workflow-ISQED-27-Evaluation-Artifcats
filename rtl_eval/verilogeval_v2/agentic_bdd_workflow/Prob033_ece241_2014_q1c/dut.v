// ============================================================================
// Module: TopModule
// Purpose: 8-bit Two's Complement Adder with Overflow Detection
//          Computes s = a + b (truncated to 8 bits) and detects signed
//          overflow using the classic "carry-in XOR carry-out of MSB" rule.
// ============================================================================
module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    // Internal 9-bit sum to capture carry-out for overflow computation
    wire [8:0] full_sum;

    // @sum_correctness: s equals (a + b) truncated to 8 bits
    assign full_sum = {1'b0, a} + {1'b0, b};
    assign s = full_sum[7:0];

    // @overflow_general_definition:
    // Overflow occurs iff sign(a) == sign(b) and sign(s) != sign(a).
    // This is equivalent to XOR of carry-in and carry-out of the sign bit.
    // Covers:
    //   @overflow_positive_plus_positive
    //   @overflow_negative_plus_negative
    //   @no_overflow_mixed_signs
    //   @no_overflow_mixed_signs_reversed
    //   @zero_addition_identity (b=0 => signs differ or b sign matches a with no overflow)
    //   @commutativity (symmetric expression in a and b)
    //   @max_positive_overflow_boundary
    //   @min_negative_overflow_boundary
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);

endmodule