// ============================================================================
// Module: TopModule
// Purpose: Computes all 25 pairwise equality (XNOR) comparisons among the
//          five single-bit inputs a, b, c, d, e. The output is organized
//          as 5 rows of 5 bits each, where row i compares signal i against
//          each of the 5 inputs (a, b, c, d, e) in order.
//
//          Bit mapping (row-major, MSB-first):
//            out[24:20] = a vs {a,b,c,d,e}
//            out[19:15] = b vs {a,b,c,d,e}
//            out[14:10] = c vs {a,b,c,d,e}
//            out[9:5]   = d vs {a,b,c,d,e}
//            out[4:0]   = e vs {a,b,c,d,e}
// ============================================================================

module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Row for 'a': compares a with a, b, c, d, e
    // bit24: a vs a (self_comparison scenario)
    // bit23: a vs b
    // bit22: a vs c
    // bit21: a vs d
    // bit20: a vs e
    assign out[24] = a ~^ a; // Scenario: Bit 24 - a vs a (always 1)
    assign out[23] = a ~^ b; // Scenario: Bit 23 - a vs b
    assign out[22] = a ~^ c; // Scenario: Bit 22 - a vs c
    assign out[21] = a ~^ d; // Scenario: Bit 21 - a vs d
    assign out[20] = a ~^ e; // Scenario: Bit 20 - a vs e

    // Row for 'b': compares b with a, b, c, d, e
    // bit19: b vs a
    // bit18: b vs b (self_comparison scenario)
    // bit17: b vs c
    // bit16: b vs d
    // bit15: b vs e
    assign out[19] = b ~^ a; // Scenario: Bit 19 - b vs a
    assign out[18] = b ~^ b; // Scenario: Bit 18 - b vs b (always 1)
    assign out[17] = b ~^ c; // Scenario: Bit 17 - b vs c
    assign out[16] = b ~^ d; // Scenario: Bit 16 - b vs d
    assign out[15] = b ~^ e; // Scenario: Bit 15 - b vs e

    // Row for 'c': compares c with a, b, c, d, e
    // bit14: c vs a
    // bit13: c vs b
    // bit12: c vs c (self_comparison scenario)
    // bit11: c vs d
    // bit10: c vs e
    assign out[14] = c ~^ a; // Scenario: Bit 14 - c vs a
    assign out[13] = c ~^ b; // Scenario: Bit 13 - c vs b
    assign out[12] = c ~^ c; // Scenario: Bit 12 - c vs c (always 1)
    assign out[11] = c ~^ d; // Scenario: Bit 11 - c vs d
    assign out[10] = c ~^ e; // Scenario: Bit 10 - c vs e

    // Row for 'd': compares d with a, b, c, d, e
    // bit9: d vs a
    // bit8: d vs b
    // bit7: d vs c
    // bit6: d vs d (self_comparison scenario)
    // bit5: d vs e
    assign out[9] = d ~^ a; // Scenario: Bit 9 - d vs a
    assign out[8] = d ~^ b; // Scenario: Bit 8 - d vs b
    assign out[7] = d ~^ c; // Scenario: Bit 7 - d vs c
    assign out[6] = d ~^ d; // Scenario: Bit 6 - d vs d (always 1)
    assign out[5] = d ~^ e; // Scenario: Bit 5 - d vs e

    // Row for 'e': compares e with a, b, c, d, e
    // bit4: e vs a
    // bit3: e vs b
    // bit2: e vs c
    // bit1: e vs d
    // bit0: e vs e (self_comparison scenario)
    assign out[4] = e ~^ a; // Scenario: Bit 4 - e vs a
    assign out[3] = e ~^ b; // Scenario: Bit 3 - e vs b
    assign out[2] = e ~^ c; // Scenario: Bit 2 - e vs c
    assign out[1] = e ~^ d; // Scenario: Bit 1 - e vs d
    assign out[0] = e ~^ e; // Scenario: Bit 0 - e vs e (always 1)

    // Symmetry scenario (out[i][j] == out[j][i]) and diagonal scenario
    // (self-comparison bits always 1) are inherently satisfied by the
    // XNOR-based pairwise construction above, since XNOR is commutative
    // and a ~^ a (or b~^b, etc.) is always logic 1.

endmodule