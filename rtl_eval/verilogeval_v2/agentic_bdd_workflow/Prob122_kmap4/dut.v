// ============================================================================
// Module: TopModule
// Purpose: 4-input XOR (odd parity) combinational logic.
//          out = a ^ b ^ c ^ d
//
// This single equation satisfies all specified scenarios:
//  - @core-function: out = A^B^C^D directly.
//  - @kmap-row-cd00: c=0,d=0 -> out = a^b^0^0 = A^B.
//  - @kmap-row-cd01: c=0,d=1 -> out = a^b^0^1 = (A^B)^1.
//  - @kmap-row-cd11: c=1,d=1 -> out = a^b^1^1 = A^B.
//  - @kmap-row-cd10: c=1,d=0 -> out = a^b^1^0 = (A^B)^1.
//  - @symmetry-ab: complementing both a and b flips out twice -> unchanged.
//  - @symmetry-cd: complementing both c and d flips out twice -> unchanged.
//  - @toggle-single-bit: complementing exactly one input flips out once.
//  - @no-combinational-loop: pure combinational assign, no state, so
//    identical inputs always yield identical output on repeated evaluation.
// ============================================================================
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Core combinational logic: odd parity function of all four inputs.
    // Covers @core-function, @kmap-row-cd00/01/11/10, @symmetry-ab,
    // @symmetry-cd, @toggle-single-bit, and @no-combinational-loop
    // (no clock/reset, no internal state -> deterministic, repeatable).
    assign out = a ^ b ^ c ^ d;

endmodule