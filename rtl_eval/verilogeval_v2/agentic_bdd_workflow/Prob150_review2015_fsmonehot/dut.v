// ============================================================================
// Module: TopModule
// Purpose: Combinational next-state and output logic for a one-hot Moore FSM
//          used in a serial receiver design. Computes next-state indicator
//          signals (B3_next, S_next, S1_next, Count_next, Wait_next) and
//          Moore outputs (done, counting, shift_ena) from the current
//          one-hot state vector and inputs d, done_counting, ack.
//
// One-hot state bit mapping (LSB to MSB):
//   state[0]=S    state[1]=S1   state[2]=S11   state[3]=S110  state[4]=B0
//   state[5]=B1   state[6]=B2   state[7]=B3    state[8]=Count state[9]=Wait
// ============================================================================
module TopModule (
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

    // -------------------------------------------------------------------
    // S_next: asserted when transitioning back to state S
    // Scenarios:
    //  - S (state[0]) with d==0
    //  - S1 (state[1]) with d==0
    //  - S110 (state[3]) with d==0
    //  - Wait (state[9]) with ack==1
    // Deasserted otherwise.
    // -------------------------------------------------------------------
    assign S_next = (state[0] & ~d) |
                     (state[1] & ~d) |
                     (state[3] & ~d) |
                     (state[9] &  ack);

    // -------------------------------------------------------------------
    // S1_next: asserted when current state is S and d==1
    // Deasserted when state[0] == 0
    // -------------------------------------------------------------------
    assign S1_next = state[0] & d;

    // -------------------------------------------------------------------
    // Count_next: asserted when current state is B3 (state[7])
    // Deasserted when state[7] == 0
    // -------------------------------------------------------------------
    assign Count_next = state[7];

    // -------------------------------------------------------------------
    // Wait_next: asserted when current state is Count (state[8])
    //            and done_counting == 1
    // Deasserted otherwise (including when done_counting == 0 in Count,
    // or when state is not Count)
    // -------------------------------------------------------------------
    assign Wait_next = state[8] & done_counting;

    // -------------------------------------------------------------------
    // B3_next: asserted when current state is B2 (state[6])
    // Deasserted when state[6] == 0
    // -------------------------------------------------------------------
    assign B3_next = state[6];

    // -------------------------------------------------------------------
    // Moore Outputs
    // -------------------------------------------------------------------

    // done: asserted only in Wait state (state[9])
    assign done = state[9];

    // counting: asserted only in Count state (state[8])
    assign counting = state[8];

    // shift_ena: asserted in any of the shift states B0, B1, B2, B3
    // (state[4], state[5], state[6], state[7])
    assign shift_ena = state[4] | state[5] | state[6] | state[7];

endmodule