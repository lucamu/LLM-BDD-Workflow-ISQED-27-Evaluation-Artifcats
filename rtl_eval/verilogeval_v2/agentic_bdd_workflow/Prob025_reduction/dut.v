// ============================================================================
// Module: TopModule
// Purpose: 8-bit Even Parity Generator
//          Computes the XOR-reduction of all 8 input bits to produce a
//          single even-parity check bit. Purely combinational logic.
// ============================================================================
module TopModule (
    input  [7:0] in,
    output       parity
);

    // -------------------------------------------------------------------
    // @core @xor-definition
    // parity = in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7]
    // This single continuous assignment also satisfies:
    //   @edge-case @all-zeros           -> XOR of all 0s = 0
    //   @edge-case @all-ones            -> XOR of eight 1s = 0
    //   @edge-case @single-bit-set      -> XOR with exactly one 1 = 1
    //   @property @bit-flip-invariance  -> flipping one bit toggles XOR result
    //   @property @flipping-two-bits-preserves-parity
    //                                    -> flipping two bits toggles twice,
    //                                       net effect: parity unchanged
    //   @property @combinational-purity -> no state, same input always
    //                                       gives same output
    //   @property @weight-parity-equivalence
    //                                    -> XOR-reduction equals popcount mod 2
    // -------------------------------------------------------------------
    assign parity = ^in;  // reduction XOR across all 8 bits of "in"

endmodule