// ============================================================================
// Module: TopModule
// Purpose: Dual-Phase Transparent Latch Pair
//          - First latch (p): transparent when clock=1, holds when clock=0
//          - Second latch (q): transparent when clock=0, holds when clock=1
//          Together they form a master-slave latch pair where q captures
//          the value of p at the falling edge of clock.
// ============================================================================
module TopModule (
    input  clock,
    input  a,
    output p,
    output q
);

    // Internal registers to hold latch state
    reg p_reg;
    reg q_reg;

    // -------------------------------------------------------------------
    // First-stage latch (p): transparent while clock is high
    // Scenarios covered:
    //   - "p is transparent and follows a while clock is high"
    //   - "p holds its previous value while clock is low"
    //   - "p captures the value of a at the rising edge of clock"
    //   - "p remains stable across multiple clock-low periods without a rising edge"
    // -------------------------------------------------------------------
    always @(*) begin
        if (clock)
            p_reg = a;      // transparent: follow input a while clock high
        else
            p_reg = p_reg;  // hold: retain previous value while clock low
    end

    // -------------------------------------------------------------------
    // Second-stage latch (q): transparent while clock is low
    // Scenarios covered:
    //   - "q is transparent and follows p while clock is low"
    //   - "q holds its previous value while clock is high"
    //   - "q captures the value of p at the falling edge of clock"
    //   - "q remains stable across multiple clock-high periods without a falling edge"
    // -------------------------------------------------------------------
    always @(*) begin
        if (!clock)
            q_reg = p_reg;  // transparent: follow p while clock low
        else
            q_reg = q_reg;  // hold: retain previous value while clock high
    end

    // Continuous assignment of outputs from internal latch registers
    assign p = p_reg;
    assign q = q_reg;

endmodule