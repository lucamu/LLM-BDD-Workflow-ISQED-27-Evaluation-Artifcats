// Module: TopModule
// Purpose: 2-input NOR gate combinational logic
// Implements out = ~(a | b) = (~a) & (~b) (De Morgan's law)
// Pure combinational design - no clock or reset signals

module TopModule (
    input  a,
    input  b,
    output out
);

    // @core_functionality @nor_truth_table
    // @equivalence @nor_as_not_or
    // @equivalence @demorgan
    // @combinational_purity @no_state
    // @symmetry @commutative
    // @width_check @single_bit_output
    //
    // out = NOT(a OR b), equivalently (NOT a) AND (NOT b).
    // This single continuous assignment covers all truth table cases:
    //   a=0,b=0 -> out=1  (@both_zero)
    //   a=1,b=B -> out=0  (@a_high)
    //   a=A,b=1 -> out=0  (@b_high)
    //   a=1,b=1 -> out=0  (@both_high)
    // The expression is purely combinational (no memory elements),
    // symmetric in a and b, and always yields a valid single-bit result.
    assign out = ~(a | b);

endmodule