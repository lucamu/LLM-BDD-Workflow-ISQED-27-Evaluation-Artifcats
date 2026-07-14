// ============================================================================
// Module: TopModule
// Purpose: 32-bit Galois LFSR with taps at positions 32, 22, 2, 1
//          Synchronous active-high reset forces q to 32'h1.
//          On each clock edge (when not in reset), the register shifts
//          right with feedback XORed in at tap bit positions.
// ============================================================================
module TopModule (
    input  wire        clk,
    input  wire        reset,
    output reg  [31:0] q
);

    // Next-state combinational logic for the Galois LFSR
    reg [31:0] q_next;

    always @(*) begin
        // Default: shift right, feedback bit (Q[0]) enters at bit 31
        // Scenario: feedback_bit31 - q[31] = Q[0]
        q_next[31] = q[0];

        // Scenario: shift_non_tap_high - bits 22..30 shift unchanged
        q_next[30:22] = q[31:23];

        // Scenario: feedback_bit21 - tap at position 22, q[21] = Q[22] ^ Q[0]
        q_next[21] = q[22] ^ q[0];

        // Scenario: shift_non_tap_low - bits 2..20 shift unchanged
        q_next[20:2] = q[21:3];

        // Scenario: feedback_bit1 - tap at position 2, q[1] = Q[2] ^ Q[0]
        q_next[1] = q[2] ^ q[0];

        // Scenario: feedback_bit0 - tap at position 1, q[0] = Q[1] ^ Q[0]
        q_next[0] = q[1] ^ q[0];
    end

    // Sequential update: synchronous reset takes priority (reset_priority,
    // deterministic_reset_value scenarios), otherwise apply full next-state
    // function (no_reset_full_update scenario)
    always @(posedge clk) begin
        if (reset) begin
            // Scenario: Synchronous reset forces q to 32'h1
            q <= 32'h00000001;
        end else begin
            // Scenario: Full next-state function when reset is deasserted
            q <= q_next;
        end
    end

endmodule