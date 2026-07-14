//------------------------------------------------------------------------
// Module:      TopModule
// Purpose:     Purely combinational logic implementing q = b OR c.
//              Inputs a and d have no effect on the output (unused).
//
// Scenarios implemented:
//   - core-logic/or-function     : q = b | c
//   - independence/input-a       : a does not appear in the expression
//   - independence/input-d       : d does not appear in the expression
//   - boundary/both-zero         : b=0,c=0 -> q=0
//   - boundary/b-set             : b=1 -> q=1 regardless of c
//   - boundary/c-set             : c=1 -> q=1 regardless of b
//   - combinational/no-state     : pure combinational assign, no memory
//------------------------------------------------------------------------
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Combinational OR of b and c.
    // Inputs a and d are intentionally not used in the expression,
    // guaranteeing independence from a and d (see independence scenarios).
    assign q = b | c;

endmodule