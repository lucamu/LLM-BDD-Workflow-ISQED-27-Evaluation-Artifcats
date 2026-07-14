// =============================================================================
// Module: TopModule
// Purpose: Motor Control FSM with synchronous active-low reset.
//          - Emits a single-cycle pulse on f after reset de-assertion.
//          - Detects the x sequence 1,0,1 (with overlap-aware restart on break).
//          - Upon detection, asserts g and monitors y for up to two cycles
//            to decide whether g becomes permanently 1 (confirmed) or
//            permanently 0 (not confirmed).
//          - f and g are mutually exclusive at all times.
// =============================================================================
module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // -------------------------------------------------------------------
    // State encoding
    //   A        : reset / idle state (Scenario: reset holds FSM in A)
    //   F_PULSE  : single-cycle f pulse after reset de-assertion
    //   S0       : searching for start of pattern 1,0,1 (no progress)
    //   S1       : matched leading '1'
    //   S2       : matched '1','0' -- one more '1' completes the pattern
    //   G_WAIT1  : g asserted, cycle M -- sample y first time
    //   G_WAIT2  : g asserted, cycle M+1 -- sample y second time
    //   G_PERM1  : g permanently 1 (y confirmed within window)
    //   G_PERM0  : g permanently 0 (y never confirmed within window)
    // -------------------------------------------------------------------
    localparam [3:0] A       = 4'd0,
                      F_PULSE = 4'd1,
                      S0      = 4'd2,
                      S1      = 4'd3,
                      S2      = 4'd4,
                      G_WAIT1 = 4'd5,
                      G_WAIT2 = 4'd6,
                      G_PERM1 = 4'd7,
                      G_PERM0 = 4'd8;

    reg [3:0] state, next_state;

    // -------------------------------------------------------------------
    // Sequential state register: synchronous active-low reset
    // Scenario: Reset holds FSM in initial state with outputs deasserted
    // Scenario: Reset asserted at any time overrides all FSM behavior
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (!resetn)
            state <= A;                 // synchronous reset to state A
        else
            state <= next_state;        // normal state update
    end

    // -------------------------------------------------------------------
    // Combinational next-state logic
    // -------------------------------------------------------------------
    always @(*) begin
        case (state)
            // Scenario: f asserts for exactly one cycle after reset de-assertion
            A: next_state = F_PULSE;

            // Scenario: f de-asserts one cycle after its single-cycle pulse
            F_PULSE: next_state = S0;

            // Scenario: x pattern search (1,0,1) with overlap-aware restart
            S0: next_state = x ? S1 : S0;          // look for first '1'
            S1: next_state = x ? S1 : S2;          // stay on repeated '1', else saw '1,0'
            S2: next_state = x ? G_WAIT1           // '1,0,1' completed -> g asserts
                                : S0;               // broken pattern -> resume search from S0

            // Scenario: y confirmation window (two cycles max)
            G_WAIT1: next_state = y ? G_PERM1 : G_WAIT2; // sample y at cycle M
            G_WAIT2: next_state = y ? G_PERM1 : G_PERM0; // sample y at cycle M+1

            // Scenario: Once g is set permanently, it does not change
            G_PERM1: next_state = G_PERM1;
            G_PERM0: next_state = G_PERM0;

            default: next_state = A;   // safe default, avoids latches
        endcase
    end

    // -------------------------------------------------------------------
    // Output logic (Moore-style, derived from registered state)
    // Scenario: f and g are never asserted simultaneously
    // -------------------------------------------------------------------
    assign f = (state == F_PULSE);

    assign g = (state == G_WAIT1) ||
               (state == G_WAIT2) ||
               (state == G_PERM1);

endmodule