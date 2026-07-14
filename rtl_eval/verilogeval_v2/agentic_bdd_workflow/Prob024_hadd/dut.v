// ============================================================================
// Module: TopModule
// Purpose: Implements a combinational half adder.
//          Computes sum = a XOR b and cout = a AND b.
//          Pure combinational logic, no clock/reset, no internal state.
// ============================================================================
module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);

    // @sum_correctness: sum = a XOR b
    // @output_stability: purely combinational, no dependency on past state
    // @commutativity: XOR is commutative, so swapping a/b yields same sum
    assign sum = a ^ b;

    // @cout_correctness: cout = a AND b
    // @output_stability: purely combinational, no dependency on past state
    // @commutativity: AND is commutative, so swapping a/b yields same cout
    assign cout = a & b;

    // @no_overflow_beyond_range: {cout, sum} correctly represents a + b
    // since a and b are 1-bit values, a + b can be 0, 1, or 2,
    // which is exactly represented by the 2-bit {cout, sum}.

endmodule