// ============================================================================
// Module: TopModule
// Purpose: Four-Input XNOR (Even Parity Detector)
//          Computes q = ~(a ^ b ^ c ^ d)
//          q = 1 when the number of asserted inputs (a,b,c,d) is even
//          q = 0 when the number of asserted inputs is odd
// ============================================================================
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Combinational logic implementing the four-input XNOR.
    //
    // Scenario "Output is the XNOR of all four inputs":
    //   q = NOT(a XOR b XOR c XOR d)
    //
    // Scenario "Output is 1 when the number of asserted inputs is even":
    //   XOR of bits gives parity (1 = odd count of ones, 0 = even count).
    //   Inverting the XOR result yields 1 for even count, 0 for odd count.
    //
    // Scenario "All inputs zero produces output 1":
    //   a=b=c=d=0 -> a^b^c^d = 0 -> q = ~0 = 1
    //
    // Scenario "All inputs one produces output 1":
    //   a=b=c=d=1 -> a^b^c^d = 0 (even number of ones) -> q = ~0 = 1
    //
    // Scenario "Flipping exactly one input inverts the output":
    //   Inverting exactly one operand of an XOR chain flips the XOR result,
    //   hence flips q as well (since q is the complement of the XOR chain).
    //
    // Scenario "Output is invariant under permutation of inputs":
    //   XOR and its complement (XNOR) are commutative and associative,
    //   so any reordering of a, b, c, d yields the same result.
    assign q = ~(a ^ b ^ c ^ d);

endmodule