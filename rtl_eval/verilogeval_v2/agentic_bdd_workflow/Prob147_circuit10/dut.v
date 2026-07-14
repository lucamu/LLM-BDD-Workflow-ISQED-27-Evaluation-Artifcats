// ============================================================================
// Module: TopModule
// Purpose: Full Adder Sequential Circuit with Carry Register
//          - state acts as the carry-bit flip-flop
//          - q acts as the combinational sum-bit output
//          No reset port is defined per specification; state is governed
//          solely by the clock-edge-driven update rule.
// ============================================================================
module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

    // Internal register representing the carry bit (state)
    reg state_reg;

    // ------------------------------------------------------------------
    // @combinational @sum
    // Scenario: Output q is the XOR of a, b and the current state
    // q is purely combinational, always reflecting same-cycle state (S)
    // ------------------------------------------------------------------
    assign q = a ^ b ^ state_reg;

    // Expose internal state register on the state output
    assign state = state_reg;

    // ------------------------------------------------------------------
    // @sequential @carry
    // Scenario: Next state is the majority function of a, b, and state
    //
    // @sequential @stability
    // Scenario: State does not change without a rising clock edge
    // (implicit: only updates inside the clk posedge block)
    //
    // @sequential @full_adder_equivalence
    // Scenario: Sequential behavior matches chained full-adder carry
    // propagation -- next state = majority(a, b, state)
    // ------------------------------------------------------------------
    always @(posedge clk) begin
        state_reg <= (a & b) | (a & state_reg) | (b & state_reg);
    end

endmodule