// ============================================================================
// Module:      TopModule
// Purpose:     Bit-Reversal Combinational Module
//              Reverses the bit ordering of a 100-bit input vector such that
//              out[i] == in[99-i] for all i in [0,99].
//
// Scenarios implemented:
//  - core_property/bit_reversal   : out[i] = in[99-i] for all i
//  - symmetry/involution          : reversing twice returns original value
//                                    (guaranteed structurally by the mapping)
//  - boundary/msb_lsb_swap        : out[99]=in[0], out[0]=in[99]
//  - width_preservation/interface : in and out both declared as [99:0]
//  - all_zeros_case               : all-zero input -> all-zero output
//  - all_ones_case                : all-one input  -> all-one output
//  - linearity_no_state           : purely combinational, no memory,
//                                    output depends only on current input
// ============================================================================

module TopModule (
    input  [99:0] in,   // 100-bit input vector
    output [99:0] out   // 100-bit bit-reversed output vector
);

    // Generate block to perform bit reversal: out[i] = in[99-i]
    // This single continuous assignment covers:
    //   - core_property/bit_reversal (per-bit mapping)
    //   - boundary/msb_lsb_swap (i=99 and i=0 cases fall out naturally)
    //   - all_zeros_case and all_ones_case (structural mapping preserves
    //     uniform bit values)
    //   - symmetry/involution (applying the same reversal twice returns
    //     the original vector, since reversal is its own inverse)
    //   - linearity_no_state (purely combinational assign, no registers)
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : BIT_REVERSE
            assign out[i] = in[99 - i];
        end
    endgenerate

endmodule