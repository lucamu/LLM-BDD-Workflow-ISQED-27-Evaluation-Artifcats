// ============================================================================
// Module: TopModule
// Purpose: 4-state Moore FSM (A,B,C,D) with asynchronous active-high reset.
//          out = 1 only in state D, otherwise 0.
//
// State transition table:
//   A: in=0 -> A , in=1 -> B
//   B: in=0 -> C , in=1 -> B
//   C: in=0 -> A , in=1 -> D
//   D: in=0 -> C , in=1 -> B
// ============================================================================
module TopModule (
    input  clk,
    input  in,
    input  areset,
    output out
);

    // State encoding
    localparam [1:0] A = 2'b00,
                      B = 2'b01,
                      C = 2'b10,
                      D = 2'b11;

    reg [1:0] state, next_state;

    // ------------------------------------------------------------------
    // Sequential state register with asynchronous active-high reset
    // Scenario: @reset - Asynchronous reset forces state to A regardless
    //           of current state
    // ------------------------------------------------------------------
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;               // Async reset -> state A
        else
            state <= next_state;      // Normal state update on clk edge
    end

    // ------------------------------------------------------------------
    // Combinational next-state logic
    // Scenarios: @state_A, @state_B, @state_C, @state_D,
    //            @reset (post-deassertion behavior),
    //            @no_unreachable_states (default branch),
    //            @liveness_D_reachable (transition sequence)
    // ------------------------------------------------------------------
    always @(*) begin
        case (state)
            A: begin
                // Scenario: State A transition
                if (in)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // Scenario: State B transition
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            C: begin
                // Scenario: State C transition
                if (in)
                    next_state = D;
                else
                    next_state = A;
            end
            D: begin
                // Scenario: State D transition
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            default: begin
                // Safety default: force to known state A
                // Scenario: @no_unreachable_states
                next_state = A;
            end
        endcase
    end

    // ------------------------------------------------------------------
    // Moore output logic: depends only on current state
    // Scenario: @output_moore - out is 1 iff state == D
    // ------------------------------------------------------------------
    assign out = (state == D);

endmodule