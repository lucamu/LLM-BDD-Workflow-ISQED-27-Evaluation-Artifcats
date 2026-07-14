//------------------------------------------------------------------------
// Module: TopModule
// Purpose: Combinational AND gate with inverted in2 input.
//          Implements: out = in1 AND (NOT in2)
//
// Covers all specified scenarios:
//   - in1=1, in2=0 -> out=1        (@in1_high @in2_low)
//   - in1=1, in2=1 -> out=0        (@in1_high @in2_high)
//   - in1=0, any in2 -> out=0      (@in1_low)
//   - in1=1, out = NOT in2         (@in2_dependency)
//   - General truth table: out = A AND (NOT B)  (@truth_table, @no_state)
//------------------------------------------------------------------------
module TopModule (
    input  in1,
    input  in2,
    output out
);

    // Pure combinational logic: no clock, no reset, no internal state.
    // out = in1 AND (NOT in2)
    assign out = in1 & (~in2);

endmodule