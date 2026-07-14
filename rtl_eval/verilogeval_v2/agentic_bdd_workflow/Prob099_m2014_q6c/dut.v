// ============================================================================
// Module: TopModule
// Purpose: Combinational next-state logic for a one-hot encoded 6-state FSM
//          (states A-F encoded as y[0]-y[5]). Computes next-state bits
//          Y1 (state B) and Y3 (state D) based on current state y and
//          input w, per the derived state transition equations.
// ============================================================================
module TopModule (
    input  [5:0] y,   // current one-hot state vector: y[0]=A ... y[5]=F
    input        w,   // FSM control input
    output       Y1,  // next-state value for state bit y[1] (state B)
    output       Y3   // next-state value for state bit y[3] (state D)
);

    // -------------------------------------------------------------------
    // Y1_logic / transition_A_to_B / transition_A_self_loop / non_A_states
    // Y1 = y[0] & ~w
    //   - Asserted only when current state is A (y[0]=1) and w=0
    //     (A --0--> B transition)
    //   - Deasserted when in state A with w=1 (A stays in A)
    //   - Deasserted whenever y[0]=0 (not in state A), regardless of w
    // -------------------------------------------------------------------
    assign Y1 = y[0] & ~w;

    // -------------------------------------------------------------------
    // Y3_logic / transition_B_to_D / transition_C_to_D / transition_E_to_D /
    // transition_F_to_D / transition_D_to_A_not_D / w_zero_never_transitions_to_D /
    // non_contributing_states
    // Y3 = w & (y[1] | y[2] | y[4] | y[5])
    //   - Asserted when w=1 and current state is B, C, E, or F
    //     (all transition to D on w=1)
    //   - Deasserted when w=0 regardless of state (no transition to D)
    //   - Deasserted when current state is A or D with w=1 (D->A on w=1,
    //     A does not transition to D), since y[1],y[2],y[4],y[5] are all 0
    // -------------------------------------------------------------------
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

    // -------------------------------------------------------------------
    // combinational / no_state_registers
    // Both Y1 and Y3 are purely combinational functions of y and w with
    // no internal state/memory, so identical inputs always produce
    // identical outputs.
    //
    // mutual_exclusivity / one_hot_assumption
    // Under one-hot encoding, y[0]=1 implies y[1]=y[2]=y[4]=y[5]=0, so
    // Y1=1 (requires y[0]=1,w=0) and Y3=1 (requires w=1 and one of
    // y[1],y[2],y[4],y[5]=1) cannot both hold simultaneously.
    // -------------------------------------------------------------------

endmodule