//=============================================================================
// Module: TopModule
// Purpose: Combinational logic circuit implementing q = (a OR b) AND (c OR d)
//
// Implements all specified formal scenarios:
//   - core-function : q = (a|b) & (c|d)
//   - edge-case      : a=b=0 -> q=0 ; c=d=0 -> q=0
//   - edge-case      : (a|b)=1 and (c|d)=1 -> q=1
//   - symmetry       : swapping a,b or c,d does not change q
//   - monotonicity   : q is non-decreasing in each input
//=============================================================================
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Intermediate OR terms
    wire ab_or; // (a OR b)
    wire cd_or; // (c OR d)

    assign ab_or = a | b;   // covers edge-case: a=0,b=0 -> ab_or=0
    assign cd_or = c | d;   // covers edge-case: c=0,d=0 -> cd_or=0

    // Core function: AND of the two OR terms
    // Satisfies core-function, symmetry (a<->b, c<->d), and monotonicity scenarios
    assign q = ab_or & cd_or;

endmodule