// Module: TopModule
// Purpose: 2-bit Equality Comparator
// Output z is asserted (1) if and only if A equals B, purely combinational.
// Covers all formal scenarios: core, equal_case, unequal_case,
// bitwise_definition, symmetry, reflexivity, single_bit_difference,
// combinational_no_state.

module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

    // @core, @bitwise_definition:
    // z is 1 iff bit0 of A equals bit0 of B AND bit1 of A equals bit1 of B
    // This is equivalent to a full bitwise equality check (A == B).
    // @equal_case: when A == B, z = 1
    // @unequal_case: when A != B, z = 0
    // @symmetry: (A==B) is inherently symmetric, so swapping A and B
    //            produces the same result
    // @reflexivity: if B is set equal to A, A==B is trivially true, z=1
    // @single_bit_difference: any single-bit difference makes A!=B, z=0
    // @combinational_no_state: no registers/latches used, z depends only
    //            on current A and B values (assign statement, no clock)
    assign z = (A[0] == B[0]) && (A[1] == B[1]);

endmodule