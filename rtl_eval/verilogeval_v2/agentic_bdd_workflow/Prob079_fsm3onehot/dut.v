// =============================================================================
// Module: TopModule
// Purpose: Combinational Moore state machine (one-hot encoded, 4 states)
//          States: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
//          Pure combinational logic - no clock/reset.
// =============================================================================
module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // Local one-hot state encodings
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] next_state_r;
    reg       out_r;

    // -------------------------------------------------------------------
    // Next-state and output combinational logic
    // Implements all @transition scenarios for states A, B, C, D
    // -------------------------------------------------------------------
    always @(*) begin
        // Default assignment to avoid latches (fallback: stay in A)
        next_state_r = A;

        case (state)
            // State A scenarios: @state_A @transition
            A: begin
                if (in == 1'b0)
                    next_state_r = A; // Scenario: A stays in A on in=0
                else
                    next_state_r = B; // Scenario: A transitions to B on in=1
            end

            // State B scenarios: @state_B @transition
            B: begin
                if (in == 1'b0)
                    next_state_r = C; // Scenario: B transitions to C on in=0
                else
                    next_state_r = B; // Scenario: B remains in B on in=1
            end

            // State C scenarios: @state_C @transition
            C: begin
                if (in == 1'b0)
                    next_state_r = A; // Scenario: C transitions to A on in=0
                else
                    next_state_r = D; // Scenario: C transitions to D on in=1
            end

            // State D scenarios: @state_D @transition
            D: begin
                if (in == 1'b0)
                    next_state_r = C; // Scenario: D transitions to C on in=0
                else
                    next_state_r = B; // Scenario: D transitions to B on in=1
            end

            // Default: invalid/undefined one-hot state -> safe fallback to A
            default: next_state_r = A;
        endcase
    end

    // -------------------------------------------------------------------
    // Output logic (Moore - depends only on current state)
    // Implements @output_logic scenario: out = 1 only in state D
    // -------------------------------------------------------------------
    always @(*) begin
        if (state == D)
            out_r = 1'b1; // Scenario: out asserted in state D (both in=0 and in=1)
        else
            out_r = 1'b0; // Scenario: out deasserted for all other states
    end

    // -------------------------------------------------------------------
    // Output assignments
    // Satisfies @next_state_onehot: next_state_r always one of A,B,C,D
    // Satisfies @next_state_no_selfloop_undefined: deterministic combinational function
    // -------------------------------------------------------------------
    assign next_state = next_state_r;
    assign out         = out_r;

endmodule