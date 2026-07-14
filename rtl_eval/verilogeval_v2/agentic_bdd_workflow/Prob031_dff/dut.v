// =============================================================================
// Module: TopModule
// Purpose: Single D Flip-Flop
//          Samples input d on every positive edge of clk and drives the
//          sampled value onto output q. No reset input is declared, per
//          the @no_reset_interface scenario -- q's next value is solely a
//          function of the past value of d, sampled via clk edges.
// =============================================================================
module TopModule (
    input  clk,
    input  d,
    output q
);

    // Internal register holding the flip-flop state
    reg q_reg;

    // ------------------------------------------------------------------
    // @core / @basic: Output follows input after one clock edge
    // @stability: Output remains stable when input is unchanged
    // @no_combinational_path: q only updates on clk posedge, not
    //   combinationally when d changes between edges
    // @toggle: q reflects the complement of d after a posedge if d toggled
    // @causality: q sampled at T+1 equals d sampled at T ($past semantics)
    // @reachability (0 and 1): both values of d propagate to q, covering
    //   the full value domain of the 1-bit signal
    // @no_reset_interface: no reset logic present -- q depends only on
    //   the previously sampled value of d via clk edges
    // ------------------------------------------------------------------
    always @(posedge clk) begin
        q_reg <= d;  // Non-blocking assignment for sequential sampling
    end

    // Drive registered output
    assign q = q_reg;

endmodule