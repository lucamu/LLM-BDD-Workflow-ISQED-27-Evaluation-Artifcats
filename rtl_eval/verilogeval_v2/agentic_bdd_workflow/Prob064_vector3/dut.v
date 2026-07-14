// ============================================================================
// Module: TopModule
// Purpose: Concatenate six 5-bit vectors (a,b,c,d,e,f) with two constant '1'
//          bits to form a 32-bit value {a,b,c,d,e,f,2'b11}, then split that
//          32-bit value into four 8-bit outputs w,x,y,z (w = MSB byte,
//          z = LSB byte).
// ============================================================================
module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Conceptual 32-bit concatenation: {a, b, c, d, e, f, 2'b11}
    // Total bits: 5+5+5+5+5+5+2 = 32

    // Scenario: Output w equals the top 8 bits of the concatenation
    // w = {a[4:0], b[4:2]}
    assign w = {a, b[4:2]};

    // Scenario: Output x equals the next 8 bits of the concatenation
    // x = {b[1:0], c[4:0], d[4]}
    assign x = {b[1:0], c, d[4]};

    // Scenario: Output y equals the next 8 bits of the concatenation
    // y = {d[3:0], e[4:1]}
    assign y = {d[3:0], e[4:1]};

    // Scenario: Output z equals the bottom 8 bits of the concatenation
    // including the constant bits: z = {e[0], f[4:0], 2'b11}
    assign z = {e[0], f, 2'b11};

    // Scenario: The four outputs together reconstruct the full concatenation
    // {w, x, y, z} == {a, b, c, d, e, f, 2'b11} by construction above.

    // Scenario: The two least significant bits of z are always 1
    // Guaranteed since z[1:0] = 2'b11 in the assign statement above.

    // Scenario: All outputs remain within their declared bit widths
    // Each output is explicitly declared as [7:0], and each assign produces
    // exactly 8 bits (5+3, 2+5+1, 4+4, 1+5+2), satisfying bit-width constraints.

endmodule