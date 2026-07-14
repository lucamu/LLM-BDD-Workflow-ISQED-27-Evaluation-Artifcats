// ============================================================================
// Module: TopModule
// Purpose: Mealy FSM sequence detector for overlapping "101" pattern on x.
//          Implements 3 states (STATE_IDLE, STATE_S1, STATE_S10) with
//          asynchronous active-low reset. Output z is combinational
//          (Mealy) function of current state and x, so a match asserts
//          z in the same cycle the "101" pattern completes.
// ============================================================================
module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    // Symbolic state encoding - exactly three defined states
    // (Formal Scenario: state_space/safety)
    localparam STATE_IDLE = 2'b00;
    localparam STATE_S1   = 2'b01;
    localparam STATE_S10  = 2'b10;
    // Note: 2'b11 is an unreachable/undefined encoding by design.

    reg [1:0] state, next_state;

    // ------------------------------------------------------------------
    // Sequential state register with asynchronous active-low reset
    // (Formal Scenario: reset/async, reset/deassert)
    // ------------------------------------------------------------------
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            // Async reset forces state to STATE_IDLE immediately
            state <= STATE_IDLE;
        end else begin
            state <= next_state;
        end
    end

    // ------------------------------------------------------------------
    // Combinational next-state logic
    // (Formal Scenarios: sequence_detection/*, overlapping/*)
    // ------------------------------------------------------------------
    always @(*) begin
        case (state)
            STATE_IDLE: begin
                if (x == 1'b1)
                    // First "1" from idle begins pattern tracking
                    next_state = STATE_S1;
                else
                    // Zero input while idle keeps FSM idle
                    next_state = STATE_IDLE;
            end

            STATE_S1: begin
                if (x == 1'b1)
                    // Repeated "1" keeps tracking a single "1"
                    next_state = STATE_S1;
                else
                    // A "0" following a tracked "1" advances FSM
                    next_state = STATE_S10;
            end

            STATE_S10: begin
                if (x == 1'b1)
                    // "1" after "10" completes match; overlap reuse
                    // of this "1" as start of new potential match
                    next_state = STATE_S1;
                else
                    // "0" after "10" breaks the pattern
                    next_state = STATE_IDLE;
            end

            default: begin
                // Unreachable state safety net; defaults to idle
                next_state = STATE_IDLE;
            end
        endcase
    end

    // ------------------------------------------------------------------
    // Combinational Mealy output logic
    // z asserts iff current state is STATE_S10 and x is 1
    // (Formal Scenarios: mealy_match, overlapping/non_match,
    //  overlapping/functional, overlapping/repeated_ones)
    // ------------------------------------------------------------------
    reg z_comb;

    always @(*) begin
        if (!aresetn) begin
            // Async reset drives z to 0 immediately, independent of clk
            z_comb = 1'b0;
        end else if ((state == STATE_S10) && (x == 1'b1)) begin
            // Pattern "101" completed combinationally
            z_comb = 1'b1;
        end else begin
            // No match on this cycle
            z_comb = 1'b0;
        end
    end

    assign z = z_comb;

endmodule