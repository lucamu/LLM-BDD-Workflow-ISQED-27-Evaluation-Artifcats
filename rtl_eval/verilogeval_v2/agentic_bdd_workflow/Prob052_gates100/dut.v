// ============================================================================
// Module: TopModule
// Purpose: Purely combinational 100-bit reduction gates.
//          Computes AND, OR, and XOR reduction of the 100-bit input vector.
//          No clock/reset -- outputs are pure functions of "in".
// ============================================================================
module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // -------------------------------------------------------------------
    // @and_reduction @all_ones @any_zero @functional_equivalence
    // out_and is 1 only if ALL 100 bits of "in" are 1, else 0.
    // -------------------------------------------------------------------
    assign out_and = &in;

    // -------------------------------------------------------------------
    // @or_reduction @all_zeros @any_one @functional_equivalence
    // out_or is 0 only if ALL 100 bits of "in" are 0, else 1.
    // -------------------------------------------------------------------
    assign out_or = |in;

    // -------------------------------------------------------------------
    // @xor_reduction @parity @even_ones_count @odd_ones_count
    // out_xor equals the parity (XOR reduction) of all 100 bits of "in":
    //   - 0 when the number of 1-bits is even
    //   - 1 when the number of 1-bits is odd
    // -------------------------------------------------------------------
    assign out_xor = ^in;

    // -------------------------------------------------------------------
    // @combinational_purity @independence_of_bit_order
    // All outputs above are continuous assignments driven solely by the
    // current value of "in". There is no internal state or memory, so:
    //   - Identical "in" values at different times produce identical outputs.
    //   - Any change in "in" causes outputs to be recomputed immediately,
    //     with no retention of previous values.
    // -------------------------------------------------------------------

endmodule