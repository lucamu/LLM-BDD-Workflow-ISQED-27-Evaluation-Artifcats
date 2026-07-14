// ============================================================================
// Module: TopModule
// Purpose: 2-state Moore FSM (states A, B) with asynchronous active-high
//          reset. State B is encoded by out = 1, State A by out = 0.
//          Next state = (out AND in) OR (NOT out AND NOT in)  [XNOR relation]
// ============================================================================
module TopModule (
    input  clk,
    input  in,
    input  areset,
    output out
);

    // Registered state variable: state_out directly represents the Moore
    // output since output == state encoding (state B = 1, state A = 0)
    reg state_out;

    // Sequential state register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Scenario: Asynchronous reset forces state B regardless of clock
            // Scenario: Asynchronous reset overrides next-state logic
            state_out <= 1'b1;
        end else begin
            // Scenario: Consistency - next-state equals defined transition function
            // Scenario: State B -> A when in=0
            // Scenario: State B remains B when in=1
            // Scenario: State A -> B when in=0
            // Scenario: State A remains A when in=1
            state_out <= (state_out & in) | (~state_out & ~in);
        end
    end

    // Moore output: depends only on current state, not directly on 'in'
    // Scenario: Moore output depends only on current state
    // Scenario: Output is always a valid state encoding (0 or 1)
    assign out = state_out;

endmodule