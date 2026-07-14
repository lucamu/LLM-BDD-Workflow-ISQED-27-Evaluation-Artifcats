// Module: TopModule
// Purpose: Combinationally reverse the byte order of a 32-bit input.
//          Byte 0 <-> Byte 3, Byte 1 <-> Byte 2.
module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    // Full byte order reversal (Scenario: Full byte order reversal)
    // out[31:24] = in[7:0]   (Scenario: byte0 - LSB maps to MSB)
    // out[23:16] = in[15:8]  (Scenario: byte1 - second byte maps to third byte)
    // out[15:8]  = in[23:16] (Scenario: byte2 - third byte maps to second byte)
    // out[7:0]   = in[31:24] (Scenario: byte3 - MSB maps to LSB)
    //
    // This is a pure wire assignment: purely combinational, no internal
    // state (Scenario: determinism), and applying it twice restores the
    // original value (Scenario: involution) since it is its own inverse.
    // Population count is preserved (Scenario: bit-preservation) because
    // this is simply a bit permutation - no bits are added, dropped, or
    // duplicated. Distinct inputs always yield distinct outputs
    // (Scenario: no-aliasing) since the mapping is a bijection.
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule