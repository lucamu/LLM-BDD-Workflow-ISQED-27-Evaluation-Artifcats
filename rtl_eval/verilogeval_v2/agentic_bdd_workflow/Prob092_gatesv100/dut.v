// =============================================================================
// Module: TopModule
// Purpose: Bitwise Neighbour Logic Module
//          Computes three 100-bit combinational outputs from a 100-bit input
//          vector by comparing each bit to its left or right neighbour.
//          - out_both:      AND with left neighbour (in[i] & in[i+1])
//          - out_any:       OR with right neighbour (in[i] | in[i-1])
//          - out_different: XOR with left neighbour, with wraparound at MSB
// =============================================================================
module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // -------------------------------------------------------------------
    // out_both: AND with left neighbour
    // Scenario: MSB (bit 99) has no left neighbour -> forced to 0
    // Scenario: bits 0..98 equal in[i] AND in[i+1]
    // -------------------------------------------------------------------
    assign out_both[99]   = 1'b0;                       // no left neighbour
    assign out_both[98:0] = in[98:0] & in[99:1];         // AND with left neighbour

    // -------------------------------------------------------------------
    // out_any: OR with right neighbour
    // Scenario: LSB (bit 0) has no right neighbour -> forced to 0
    // Scenario: bits 1..99 equal in[i] OR in[i-1]
    // -------------------------------------------------------------------
    assign out_any[0]     = 1'b0;                        // no right neighbour
    assign out_any[99:1]  = in[99:1] | in[98:0];         // OR with right neighbour

    // -------------------------------------------------------------------
    // out_different: XOR with left neighbour, wraparound for MSB
    // Scenario: bits 0..98 equal in[i] XOR in[i+1]
    // Scenario: bit 99 wraps around and equals in[99] XOR in[0]
    // -------------------------------------------------------------------
    assign out_different[98:0] = in[98:0] ^ in[99:1];    // XOR with left neighbour
    assign out_different[99]   = in[99] ^ in[0];         // wraparound case

endmodule