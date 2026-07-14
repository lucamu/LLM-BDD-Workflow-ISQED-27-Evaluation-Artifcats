// Module: TopModule
// Purpose: Combinational next-state flip-flop input logic (Y1, Y3)
//          for a one-hot encoded Moore FSM with states A..F (y[0]..y[5]).
//          Y1 feeds flip-flop y[1] (state B), Y3 feeds flip-flop y[3] (state D).
module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Scenario: Y1 asserted only when in state A (y[0]=1) with w high
    // Scenario: Y1 deasserted when not in state A regardless of w
    // Scenario: Y1 general symbolic equation -> Y1 = y[0] AND W
    assign Y1 = y[0] & w;

    // Scenario: Y3 asserted when in state B, C, E, or F with w low
    // Scenario: Y3 deasserted when in state A or D regardless of w
    // Scenario: Y3 general symbolic equation -> Y3 = (y[1]|y[2]|y[4]|y[5]) AND (NOT W)
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;

    // Note: For valid one-hot y, Y1 and Y3 are mutually exclusive since
    // y[0] and (y[1]|y[2]|y[4]|y[5]) cannot both be 1 simultaneously.
    // The same equations govern behavior even for non-one-hot y values.

endmodule