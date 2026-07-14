//------------------------------------------------------------------------
// Module: TopModule
// Purpose: Moore-type Finite State Machine with two states (OFF/ON)
//          controlled by J-K style inputs j and k.
//
//          State OFF -> out = 0
//          State ON  -> out = 1
//
//          Transitions:
//            OFF, j=0 -> OFF
//            OFF, j=1 -> ON
//            ON,  k=0 -> ON
//            ON,  k=1 -> OFF
//
//          Asynchronous active-high reset (areset) forces state to OFF
//          immediately, independent of clk.
//------------------------------------------------------------------------
module TopModule (
    input  clk,
    input  j,
    input  k,
    input  areset,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;      // current state register
    reg next_state; // combinational next-state logic

    //--------------------------------------------------------------------
    // Sequential state register with asynchronous reset
    // Scenario: Asynchronous reset forces state to OFF and out to 0
    // Scenario: After reset deassertion, state remains OFF until clocked
    //--------------------------------------------------------------------
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Async reset: force state to OFF immediately
            state <= OFF;
        end else begin
            // Normal operation: move to next state on rising clk edge
            state <= next_state;
        end
    end

    //--------------------------------------------------------------------
    // Combinational next-state logic
    // Scenario: OFF state transition on j=0 stays OFF
    // Scenario: OFF state transition on j=1 moves to ON
    // Scenario: ON state transition on k=0 stays ON
    // Scenario: ON state transition on k=1 moves to OFF
    //--------------------------------------------------------------------
    always @(*) begin
        case (state)
            OFF: begin
                if (j)
                    next_state = ON;   // OFF, j=1 -> ON
                else
                    next_state = OFF;  // OFF, j=0 -> OFF
            end
            ON: begin
                if (k)
                    next_state = OFF;  // ON, k=1 -> OFF
                else
                    next_state = ON;   // ON, k=0 -> ON
            end
            default: begin
                // Safety default: avoid latches, fallback to OFF
                next_state = OFF;
            end
        endcase
    end

    //--------------------------------------------------------------------
    // Moore output logic: depends only on current state, not on j/k
    // Scenario: Output depends only on current state (Moore property)
    // Scenario: State and output consistency invariant
    //--------------------------------------------------------------------
    assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule