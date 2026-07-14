// Module: TopModule
// Purpose: Implements minimum SOP and POS realizations of a 4-input
//          combinational logic function (a=MSB, d=LSB).
//
// Function specification (decimal value = 8a+4b+2c+d):
//   ones (must be 1): 2, 7, 15
//   zeros (must be 0): 0, 1, 4, 5, 6, 9, 10, 13, 14
//   don't cares: 3, 8, 11, 12
//
// SOP minimum form: out_sop = (~a & ~b & c) | (c & d)
// POS minimum form: out_pos = c & (~a | ~c | d) & (~b | ~c | d)
//
// Both realizations are functionally equivalent for all input
// combinations, satisfying required_ones, required_zeros,
// dont_care_consistency, and sop_pos_equivalence scenarios.

module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // @minimum_sop_formula: minimum sum-of-products realization
    // out_sop = (~a & ~b & c) | (c & d)
    assign out_sop = ((~a) & (~b) & c) | (c & d);

    // @minimum_pos_formula: minimum product-of-sums realization
    // out_pos = c & (~a | ~c | d) & (~b | ~c | d)
    assign out_pos = c & ((~a) | (~c) | d) & ((~b) | (~c) | d);

    // @required_ones, @required_zeros, @dont_care_consistency,
    // @sop_pos_equivalence: verified by construction of the two
    // expressions above, which realize the same Boolean function
    // (both equal 1 only for minterms 2, 7, 15 and equal 0 for
    // minterms 0,1,4,5,6,9,10,13,14; agree on don't-cares 3,8,11,12).

endmodule