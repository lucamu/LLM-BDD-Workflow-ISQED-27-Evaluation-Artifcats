// ============================================================================
// Module: TopModule
// Purpose: Bitwise Neighbour Relationship Detector
//          Computes AND, OR, and XOR relationships between each bit of a
//          4-bit input vector and its neighbouring bit(s). Purely
//          combinational, no clock/reset.
// ============================================================================
module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // -----------------------------------------------------------------
    // out_both: logical AND with the left (higher-index) neighbour
    // -----------------------------------------------------------------
    // Scenario: out_both bit 0 reflects AND of in[0] and in[1]
    assign out_both[0] = in[0] & in[1];
    // Scenario: out_both bit 1 reflects AND of in[1] and in[2]
    assign out_both[1] = in[1] & in[2];
    // Scenario: out_both bit 2 reflects AND of in[2] and in[3]
    assign out_both[2] = in[2] & in[3];
    // Scenario: out_both bit 3 is unspecified and unconstrained
    // No neighbour exists above bit 3 in this relationship; tie to 0.
    assign out_both[3] = 1'b0;

    // -----------------------------------------------------------------
    // out_any: logical OR with the right (lower-index) neighbour
    // -----------------------------------------------------------------
    // Scenario: out_any bit 0 is unspecified and unconstrained
    // No neighbour exists below bit 0 in this relationship; tie to 0.
    assign out_any[0] = 1'b0;
    // Scenario: out_any bit 1 reflects OR of in[1] and in[0]
    assign out_any[1] = in[1] | in[0];
    // Scenario: out_any bit 2 reflects OR of in[2] and in[1]
    assign out_any[2] = in[2] | in[1];
    // Scenario: out_any bit 3 reflects OR of in[3] and in[2]
    assign out_any[3] = in[3] | in[2];

    // -----------------------------------------------------------------
    // out_different: XOR with the left (higher-index) neighbour,
    // wrapping around for the top bit
    // -----------------------------------------------------------------
    // Scenario: out_different bit 0 reflects XOR of in[0] and in[1]
    assign out_different[0] = in[0] ^ in[1];
    // Scenario: out_different bit 1 reflects XOR of in[1] and in[2]
    assign out_different[1] = in[1] ^ in[2];
    // Scenario: out_different bit 2 reflects XOR of in[2] and in[3]
    assign out_different[2] = in[2] ^ in[3];
    // Scenario: out_different bit 3 reflects XOR of in[3] and wrapped in[0]
    assign out_different[3] = in[3] ^ in[0];

    // -----------------------------------------------------------------
    // Scenario: Outputs depend only on the current input with no memory
    // All outputs above are driven purely by continuous assignments
    // combinationally from "in", with no registers or feedback,
    // ensuring no dependency on previously applied input values.
    // -----------------------------------------------------------------

endmodule