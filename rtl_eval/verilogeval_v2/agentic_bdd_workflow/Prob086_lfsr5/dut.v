// ============================================================================
// Module: TopModule
// Purpose: 5-bit Maximal-Length Galois LFSR with taps at bit positions 5 and 3
//
// Behavior:
//   - Synchronous, active-high reset forces q to 5'b00001 (Scenarios:
//     "Synchronous reset forces output to 1", "Reset takes priority over
//     LFSR shifting")
//   - On each posedge clk with reset=0, the LFSR shifts as follows:
//       q[0] <= Q[1]           (Scenario: bit0 - no tap)
//       q[1] <= Q[2]           (Scenario: bit1 - no tap)
//       q[2] <= Q[3] ^ Q[0]    (Scenario: bit2/tap - tap at position 3)
//       q[3] <= Q[4]           (Scenario: bit3 - no tap)
//       q[4] <= Q[0]           (Scenario: bit4/tap - wraparound feedback,
//                                tap at position 5)
//   - This Galois LFSR configuration guarantees a maximal-length cycle of
//     31 nonzero states (never entering 5'b00000), satisfying the
//     invariant and reachability scenarios.
//   - Next-state is a pure function of current state Q and reset R, as
//     described in the "next_state_function" scenario.
// ============================================================================

module TopModule (
    input        clk,
    input        reset,
    output [4:0] q
);

    // Internal register holding the current LFSR state
    reg [4:0] q_reg;

    // Sequential logic: synchronous reset and LFSR shift
    always @(posedge clk) begin
        if (reset) begin
            // Scenario: Synchronous reset forces output to 1
            // Scenario: Reset takes priority over LFSR shifting
            q_reg <= 5'b00001;
        end else begin
            // Scenario: next_state_function (R=0 case)
            // Bit-by-bit shift with taps at positions 5 and 3
            q_reg[0] <= q_reg[1];             // Scenario: bit0 - no tap
            q_reg[1] <= q_reg[2];             // Scenario: bit1 - no tap
            q_reg[2] <= q_reg[3] ^ q_reg[0];  // Scenario: bit2/tap - tap at position 3
            q_reg[3] <= q_reg[4];             // Scenario: bit3 - no tap
            q_reg[4] <= q_reg[0];             // Scenario: bit4/tap - wraparound feedback tap
        end
    end

    // Registered output assignment
    assign q = q_reg;

endmodule