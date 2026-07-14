// ============================================================================
// Module: TopModule
// Purpose: Population Count Circuit
//          Computes the number of '1' bits in the 3-bit input vector `in`
//          and reports the result on the 2-bit output `out`.
//          Purely combinational: out = popcount(in) = in[0] + in[1] + in[2]
// ============================================================================
module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // @core @popcount_definition
    // @boundary @all_zero / @all_one
    // @single_bit @bit0/@bit1/@bit2
    // @two_bits
    // @range @bounded_output (sum of 3 bits is always 0..3, fits in 2 bits)
    // @symmetry @bit_independence (addition is order/position independent)
    // @monotonic @single_bit_flip (adding a set bit increases sum by 1)
    // @determinism @combinational_purity (pure combinational assign, no state)
    assign out = in[0] + in[1] + in[2];

endmodule