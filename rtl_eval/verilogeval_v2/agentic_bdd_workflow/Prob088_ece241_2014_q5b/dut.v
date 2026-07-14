// =============================================================================
// Module: TopModule
// Purpose: 2's Complementer Mealy FSM (One-Hot Encoding)
//          Implements two states A (reset state) and B using one-hot encoding.
//          z = x in state A, z = ~x in state B (Mealy output).
// =============================================================================
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot state encoding
    localparam A = 2'b01;
    localparam B = 2'b10;

    reg [1:0] state, next_state;

    // ------------------------------------------------------------------------
    // Combinational next-state logic
    // Scenario: @transition @stateA - A -> A if x=0, A -> B if x=1
    // Scenario: @transition @stateB / @stability @stateB - B -> B always
    // Scenario: @noXstate @invariant - default branch avoids invalid states
    // ------------------------------------------------------------------------
    always @* begin
        case (state)
            A: next_state = (x) ? B : A; // x=1 -> B, x=0 -> A
            B: next_state = B;           // absorbing state, stays B regardless of x
            default: next_state = A;     // safety default, never reached if one-hot invariant holds
        endcase
    end

    // ------------------------------------------------------------------------
    // Sequential state register with asynchronous active-high reset
    // Scenario: @reset @async - areset forces state A immediately, async
    // Scenario: @reset @deassert - on deassertion, next rising edge moves from A
    // Scenario: @onehot @invariant - state always one-hot after reset release
    // ------------------------------------------------------------------------
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A; // Asynchronous reset forces state A immediately
        else
            state <= next_state; // Synchronous state update on rising edge
    end

    // ------------------------------------------------------------------------
    // Combinational Mealy output logic
    // Scenario: @output @mealy - z depends on current state and current x
    // Scenario: @transition @stateA - z = x in state A
    // Scenario: @transition @stateB - z = ~x in state B
    // Scenario: @reset @async - z = 0 while in state A (since z = x, but during
    //           reset assertion this is driven by current x; A yields z=x, and
    //           spec expects z=0 default in A when x=0; combinational output
    //           naturally follows z = x per Mealy definition)
    // ------------------------------------------------------------------------
    assign z = (state == A) ? x  :
               (state == B) ? ~x :
               1'b0; // default safe value, should never be reached in valid one-hot state

endmodule