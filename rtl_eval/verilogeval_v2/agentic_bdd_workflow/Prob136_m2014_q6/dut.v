//=============================================================================
// Module: TopModule
// Purpose: 6-state Moore Finite State Machine Controller (states A-F)
//          Output z is 1 in states E and F, 0 otherwise.
//          Synchronous active-high reset forces state A.
//=============================================================================
module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // Symbolic state encoding
    localparam [2:0] A = 3'd0,
                     B = 3'd1,
                     C = 3'd2,
                     D = 3'd3,
                     E = 3'd4,
                     F = 3'd5;

    reg [2:0] state, next_state;

    //-------------------------------------------------------------------
    // Sequential state register
    // Scenario: Reset forces the machine to state A
    // Scenario: Output is 0 immediately after reset (via state A -> z=0)
    //-------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset)
            state <= A;         // @reset: synchronous reset to state A
        else
            state <= next_state; // @invariant: next_state always valid A-F
    end

    //-------------------------------------------------------------------
    // Combinational next-state logic
    // Scenarios: Transition from state A, B, C, D, E, F
    //-------------------------------------------------------------------
    always @(*) begin
        case (state)
            A: begin // @transition: Transition from state A
                if (w == 1'b0)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin // @transition: Transition from state B
                if (w == 1'b0)
                    next_state = C;
                else
                    next_state = D;
            end
            C: begin // @transition: Transition from state C
                if (w == 1'b0)
                    next_state = E;
                else
                    next_state = D;
            end
            D: begin // @transition: Transition from state D
                if (w == 1'b0)
                    next_state = F;
                else
                    next_state = A;
            end
            E: begin // @transition: Transition from state E
                if (w == 1'b0)
                    next_state = E;
                else
                    next_state = D;
            end
            F: begin // @transition: Transition from state F
                if (w == 1'b0)
                    next_state = C;
                else
                    next_state = D;
            end
            default: next_state = A; // safety default, avoids latches
        endcase
    end

    //-------------------------------------------------------------------
    // Moore output logic - depends only on current state
    // Scenario: Output is 0 in states A, B, C, D
    // Scenario: Output is 1 in states E, F
    // Scenario: Output depends only on current state, not on w
    //-------------------------------------------------------------------
    assign z = (state == E) || (state == F);

endmodule