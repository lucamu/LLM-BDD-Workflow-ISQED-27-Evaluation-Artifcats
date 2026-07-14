// ============================================================================
// Module: TopModule
// Purpose: Implements the boolean function z = (x ^ y) & x
//          which simplifies to z = x & (~y).
//          Purely combinational, no clock/reset.
// ============================================================================
module TopModule (
    input  x,
    input  y,
    output z
);

    // -------------------------------------------------------------------
    // Scenario: Output equals the boolean function of the inputs
    // Scenario: Output equals the simplified AND-NOT form
    //   z = (x ^ y) & x  ==  x & (~y)
    // -------------------------------------------------------------------
    assign z = (x ^ y) & x;

    // -------------------------------------------------------------------
    // Implicit coverage of remaining scenarios via the single expression above:
    //
    // Scenario: Output is 0 when x is 0 regardless of y
    //   x=0 -> (0^y)&0 = 0, for any y  => z = 0
    //
    // Scenario: Output is 0 when x equals y
    //   x=y -> (x^y)=0 -> z = 0 & x = 0
    //
    // Scenario: Output is 1 only when x is 1 and y is 0
    //   x=1, y=0 -> (1^0)&1 = 1&1 = 1
    //
    // Scenario: Output is 0 when x is 1 and y is 1
    //   x=1, y=1 -> (1^1)&1 = 0&1 = 0
    //
    // Scenario: Output never depends on any state outside x and y
    //   The continuous assignment guarantees z updates immediately
    //   and depends only on current x, y values (pure combinational).
    // -------------------------------------------------------------------

endmodule