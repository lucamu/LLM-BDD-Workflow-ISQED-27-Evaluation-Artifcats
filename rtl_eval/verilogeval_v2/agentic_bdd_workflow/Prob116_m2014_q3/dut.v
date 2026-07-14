//=============================================================================
// Module: TopModule
// Purpose: Implements the combinational Karnaugh-map-derived function
//          f(x[3:0]) as specified. Don't-care cells are left
//          unconstrained; the derived minimal SOP expression naturally
//          produces consistent values for those cells without violating
//          any specified minterm.
//
// Derived minimal equation (verified against all specified minterms):
//   f = (~x[3] & x[1]) | (x[2] & x[0]);
//
// Truth table coverage (only specified cells listed):
//   x=0100 -> f=0   (Scenario: f is 0 when x equals 4'b0100)
//   x=0001 -> f=0   (Scenario: f is 0 when x equals 4'b0001)
//   x=1101 -> f=1   (Scenario: f is 1 when x equals 4'b1101)
//   x=1001 -> f=0   (Scenario: f is 0 when x equals 4'b1001)
//   x=1110 -> f=0   (Scenario: f is 0 when x equals 4'b1110)
//   x=0011 -> f=1   (Scenario: f is 1 when x equals 4'b0011)
//   x=0111 -> f=1   (Scenario: f is 1 when x equals 4'b0111)
//   x=0010 -> f=1   (Scenario: f is 1 when x equals 4'b0010)
//   x=0110 -> f=1   (Scenario: f is 1 when x equals 4'b0110)
//
// Determinism: f is a pure combinational function of x (no state,
// no clock/reset), so identical x values always produce identical f.
//=============================================================================

module TopModule (
    input  [3:0] x,
    output       f
);

    // Combinational assignment implementing the minimized SOP expression
    // derived from the specified Karnaugh map (don't-cares unconstrained).
    assign f = (~x[3] & x[1]) | (x[2] & x[0]);

endmodule