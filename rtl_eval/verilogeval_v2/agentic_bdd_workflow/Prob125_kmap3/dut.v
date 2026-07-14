//==============================================================================
// Module: TopModule
// Purpose: Implements a 4-input, 1-output combinational logic function
//          defined by a Karnaugh map with input d as don't-care.
//          Equation: out = a OR (NOT b AND c)
//
// Scenario coverage:
//   @core-function              -> out = a | (~b & c)
//   @a-dominant                 -> a=1 forces out=1
//   @b-forces-low               -> a=0,b=1 forces out=0
//   @c-passthrough              -> a=0,b=0 -> out=c
//   @dont-care-independence     -> d not used in equation, output unaffected
//   @full-cover-ones            -> a=1 covers all mandatory ON-set entries
//   @full-cover-zeros           -> a=0,b=1 covers all mandatory OFF-set entries
//==============================================================================
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,   // don't-care input, has no effect on out
    output out
);

    // Combinational logic: out = a OR (NOT b AND c)
    // d is intentionally excluded from the expression (don't-care)
    assign out = a | (~b & c);

endmodule