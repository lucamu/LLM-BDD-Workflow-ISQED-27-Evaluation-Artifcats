// ============================================================================
// Module: TopModule
// Purpose: Combinational Moore FSM controller using one-hot state encoding.
//          Computes next_state[9:0] and Moore outputs out1/out2 purely
//          combinationally from the current state vector and input "in".
//          No clock or reset - pure combinational logic.
// ============================================================================
module TopModule (
    input               in,
    input  [9:0]        state,
    output [9:0]         next_state,
    output               out1,
    output               out2
);

    // Individual state bit aliases for clarity (matches spec naming)
    wire state0 = state[0];
    wire state1 = state[1];
    wire state2 = state[2];
    wire state3 = state[3];
    wire state4 = state[4];
    wire state5 = state[5];
    wire state6 = state[6];
    wire state7 = state[7];
    wire state8 = state[8];
    wire state9 = state[9];

    // ------------------------------------------------------------------
    // Scenario: Next state bit 0 logic (transition to S0)
    // next_state[0] = (s0|s1|s2|s3|s4|s7|s8|s9) & ~in
    // ------------------------------------------------------------------
    assign next_state[0] = (state0 | state1 | state2 | state3 |
                             state4 | state7 | state8 | state9) & ~in;

    // ------------------------------------------------------------------
    // Scenario: Next state bit 1 logic (transition to S1)
    // next_state[1] = (s0|s8|s9) & in
    // ------------------------------------------------------------------
    assign next_state[1] = (state0 | state8 | state9) & in;

    // ------------------------------------------------------------------
    // Scenario: Next state bit 2 logic (transition to S2)
    // next_state[2] = s1 & in
    // ------------------------------------------------------------------
    assign next_state[2] = state1 & in;

    // ------------------------------------------------------------------
    // Scenario: Next state bit 3 logic (transition to S3)
    // next_state[3] = s2 & in
    // ------------------------------------------------------------------
    assign next_state[3] = state2 & in;

    // ------------------------------------------------------------------
    // Scenario: Next state bit 4 logic (transition to S4)
    // next_state[4] = s3 & in
    // ------------------------------------------------------------------
    assign next_state[4] = state3 & in;

    // ------------------------------------------------------------------
    // Scenario: Next state bit 5 logic (transition to S5)
    // next_state[5] = s4 & in
    // ------------------------------------------------------------------
    assign next_state[5] = state4 & in;

    // ------------------------------------------------------------------
    // Scenario: Next state bit 6 logic (transition to S6)
    // next_state[6] = s5 & in
    // ------------------------------------------------------------------
    assign next_state[6] = state5 & in;

    // ------------------------------------------------------------------
    // Scenario: Next state bit 7 logic (transition to S7)
    // next_state[7] = (s6|s7) & in
    // ------------------------------------------------------------------
    assign next_state[7] = (state6 | state7) & in;

    // ------------------------------------------------------------------
    // Scenario: Next state bit 8 logic (transition to S8)
    // next_state[8] = s5 & ~in
    // ------------------------------------------------------------------
    assign next_state[8] = state5 & ~in;

    // ------------------------------------------------------------------
    // Scenario: Next state bit 9 logic (transition to S9)
    // next_state[9] = s6 & ~in
    // ------------------------------------------------------------------
    assign next_state[9] = state6 & ~in;

    // ------------------------------------------------------------------
    // Scenario: Output out1 combinational logic (independent of "in")
    // out1 = s8 | s9
    // ------------------------------------------------------------------
    assign out1 = state8 | state9;

    // ------------------------------------------------------------------
    // Scenario: Output out2 combinational logic (independent of "in")
    // out2 = s7 | s9
    // ------------------------------------------------------------------
    assign out2 = state7 | state9;

    // ------------------------------------------------------------------
    // Scenario: Outputs are independent of input "in"
    // out1/out2 depend only on state bits, not on "in" -- satisfied by
    // the assigns above since "in" does not appear in their expressions.
    // ------------------------------------------------------------------

    // ------------------------------------------------------------------
    // Scenario: Next state logic holds under multi-hot state combinations
    // No mutual-exclusion assumptions are made; each next_state[i] is
    // computed independently from OR/AND combinations of state bits,
    // so multi-hot inputs are handled correctly by construction.
    // ------------------------------------------------------------------

    // ------------------------------------------------------------------
    // Scenario: Next state vector has no undefined bits
    // All next_state bits are driven by continuous assigns covering
    // every bit [9:0]; no latches or undefined conditions exist.
    // ------------------------------------------------------------------

endmodule