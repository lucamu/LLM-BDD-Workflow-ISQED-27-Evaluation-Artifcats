// ============================================================================
// Module: TopModule
// Purpose: 4-bit Carry Look-Ahead Adder (Gate-Level)
//          Implements generate/propagate logic and carry-chain recurrence
//          to compute S = A_in + B_in + C_1 and CO = carry-out.
// ============================================================================
module TopModule (
    input  [3:0] A_in,
    input  [3:0] B_in,
    input        C_1,
    output       CO,
    output [3:0] S
);

    // ------------------------------------------------------------------
    // Scenario: gate_level @generate_propagate
    // Generate signals: G_i = A_i AND B_i
    // Propagate signals: P_i = A_i XOR B_i
    // ------------------------------------------------------------------
    wire G_0, G_1, G_2, G_3;
    wire P_0, P_1, P_2, P_3;

    and (G_0, A_in[0], B_in[0]);
    and (G_1, A_in[1], B_in[1]);
    and (G_2, A_in[2], B_in[2]);
    and (G_3, A_in[3], B_in[3]);

    xor (P_0, A_in[0], B_in[0]);
    xor (P_1, A_in[1], B_in[1]);
    xor (P_2, A_in[2], B_in[2]);
    xor (P_3, A_in[3], B_in[3]);

    // ------------------------------------------------------------------
    // Scenario: gate_level @carry_chain
    // Internal carry chain follows look-ahead recurrence:
    //   C_0      = G_0 OR (P_0 AND C_1)
    //   C_1_next = G_1 OR (P_1 AND C_0)
    //   C_2      = G_2 OR (P_2 AND C_1_next)
    //   CO       = G_3 OR (P_3 AND C_2)
    // ------------------------------------------------------------------
    wire C_0, C_1_next, C_2;

    wire p0c1, p1c0, p2c1n, p3c2;

    and (p0c1, P_0, C_1);
    or  (C_0, G_0, p0c1);

    and (p1c0, P_1, C_0);
    or  (C_1_next, G_1, p1c0);

    and (p2c1n, P_2, C_1_next);
    or  (C_2, G_2, p2c1n);

    and (p3c2, P_3, C_2);
    or  (CO, G_3, p3c2);

    // ------------------------------------------------------------------
    // Scenario: gate_level @sum_bit_definition
    // Each sum bit equals propagate XOR incoming carry:
    //   S[0] = P_0 XOR C_1
    //   S[1] = P_1 XOR C_0
    //   S[2] = P_2 XOR C_1_next
    //   S[3] = P_3 XOR C_2
    // ------------------------------------------------------------------
    xor (S[0], P_0, C_1);
    xor (S[1], P_1, C_0);
    xor (S[2], P_2, C_1_next);
    xor (S[3], P_3, C_2);

    // ------------------------------------------------------------------
    // Scenarios covered by construction (no additional logic needed):
    //   @sum_correctness       - S = (A_in + B_in + C_1) mod 16 via CLA logic above
    //   @carry_correctness     - CO = bit 4 of (A_in + B_in + C_1)
    //   @full_result_equivalence - {CO,S} = A_in + B_in + C_1
    //   @zero_operands         - all-zero inputs yield S=0, CO=0
    //   @all_ones_with_carry   - all-ones inputs with carry yield S=1111, CO=1
    //   @carry_in_increment    - toggling C_1 increments {CO,S} by 1
    //   @commutativity         - G_i/P_i symmetric in A_in/B_in => S,CO symmetric
    //   @no_state              - purely combinational, no memory elements
    // ------------------------------------------------------------------

endmodule