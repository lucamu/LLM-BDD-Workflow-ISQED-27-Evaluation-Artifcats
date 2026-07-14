// ============================================================================
// Module: TopModule
// Purpose: 2-Input AND Gate (purely combinational)
//          Implements out = a AND b with no clock/reset/state dependency.
// ============================================================================
module TopModule (
    input  a,
    input  b,
    output out
);

    // ------------------------------------------------------------------
    // Scenario: Output equals logical AND of inputs for any values
    // Scenario: Output is 0 when a is 0 regardless of b
    // Scenario: Output is 0 when b is 0 regardless of a
    // Scenario: Output is 1 only when both inputs are 1
    // Scenario: Output has no memory of previous input values
    //           (continuous assignment recomputes out purely from a,b)
    // Scenario: AND operation is commutative
    //           (the '&' operator is inherently commutative)
    // ------------------------------------------------------------------
    assign out = a & b;

endmodule