// ============================================================================
// Module: TopModule
// Purpose: 8-bit by Constant 0xFB (251) Multiplier
//          Computes B = A * 251 using shift-and-subtract decomposition:
//          251 = 256 - 4 - 1  =>  B = (A << 8) - (A << 2) - A
//          Purely combinational, no clock/reset.
// ============================================================================
module TopModule (
    input  [7:0]  A,
    output [15:0] B
);

    // ------------------------------------------------------------------
    // @algebraic_decomposition: Shift-and-subtract decomposition of 251
    // 251 = 256 - 4 - 1
    // Extend A to 16 bits to preserve full precision during shifts/subtracts
    // ------------------------------------------------------------------
    wire [15:0] a_ext      = {8'b0, A};      // Zero-extended A (16-bit)
    wire [15:0] a_shift8   = a_ext << 8;      // A * 256
    wire [15:0] a_shift2   = a_ext << 2;      // A * 4

    // ------------------------------------------------------------------
    // @core_functionality / @no_overflow / @output_width_consistency:
    // B = (A << 8) - (A << 2) - A = A * 251, fits exactly in 16 bits
    // (max value: 255 * 251 = 64005, within 16-bit range 0..65535)
    // ------------------------------------------------------------------
    assign B = a_shift8 - a_shift2 - a_ext;

    // ------------------------------------------------------------------
    // Additional scenarios are inherently satisfied by the single
    // combinational expression above:
    //   @zero_input             : A=0x00 -> B=0x0000
    //   @maximum_input          : A=0xFF -> B=0xFF*251
    //   @single_bit_input_lsb   : A=0x01 -> B=0x00FB
    //   @power_of_two_input     : scales linearly since multiplication
    //                             by a constant is linear
    //   @monotonicity           : multiplication by positive constant 251
    //                             preserves non-decreasing order
    //   @linearity_check        : B_double = (2*A)*251 = 2*(A*251) = 2*B
    //                             when no 8-bit overflow occurs
    // ------------------------------------------------------------------

endmodule