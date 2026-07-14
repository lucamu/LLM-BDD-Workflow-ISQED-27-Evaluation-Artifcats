// =============================================================================
// Module: TopModule
// Purpose: Two-state Moore machine (states A and B)
//          - Reset state is B (synchronous, active-high)
//          - out = 1 in state B, out = 0 in state A
//          - Transition: stay in current state if in=1, else toggle state
// =============================================================================
module TopModule (
    input  clk,
    input  in,
    input  reset,
    output out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state; // current state register

    // Sequential state update logic
    always @(posedge clk) begin
        if (reset) begin
            // @reset: Synchronous reset forces state B
            // @reset: Reset takes priority over input value
            state <= B;
        end
        else begin
            case (state)
                // @transition: State B -> A when in=0, B remains B when in=1
                B: state <= (in) ? B : A;
                // @transition: State A -> B when in=0, A remains A when in=1
                A: state <= (in) ? A : B;
                default: state <= B; // safety default, avoids latch/unknown state
            endcase
        end
    end

    // @output: Moore output depends only on current state
    // out = 1 when state == B, out = 0 when state == A
    assign out = (state == B) ? 1'b1 : 1'b0;

    // @invariant: 
    //   - When in=0: next state toggles, so next out = ~out (complement)
    //   - When in=1: next state = current state, so next out = out
    // @coverage: Only states A and B are reachable, guaranteed by the
    //            complete case statement and default fallback to B.

endmodule