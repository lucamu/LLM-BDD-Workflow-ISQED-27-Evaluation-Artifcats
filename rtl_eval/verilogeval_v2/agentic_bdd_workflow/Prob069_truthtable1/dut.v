// ============================================================================
// Module: TopModule
// Purpose: Combinational logic computing f = (~x3 & x2) | (x1 & x3)
//
// Covers all specified scenarios:
//   - core/full-function: f = (~x3 & x2) | (x1 & x3) for all inputs
//   - boundary/x3-low   : x3=0 => f = x2
//   - boundary/x3-high  : x3=1 => f = x1
//   - boundary/x2-low   : x2=0 => f = x1 & x3
//   - boundary/x2-high  : x2=1 => f = ~x3 | x1
//   - sanity/all-zero   : x3=x2=x1=0 => f=0
//   - sanity/all-one    : x3=x2=x1=1 => f=1
//   - consistency       : purely combinational, deterministic function
// ============================================================================

module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);

    // Combinational sum-of-products implementation
    // f = (~x3 & x2) | (x1 & x3)
    assign f = (~x3 & x2) | (x1 & x3);

endmodule