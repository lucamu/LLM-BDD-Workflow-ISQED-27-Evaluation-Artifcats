// ============================================================================
// Module: TopModule
// Purpose: Combinational Karnaugh-map function
//
//               x[0]x[1]
//  x[2]x[3]  00  01  11  10
//    00     | 1 | 0 | 0 | 1 |
//    01     | 0 | 0 | 0 | 0 |
//    11     | 1 | 1 | 1 | 0 |
//    10     | 1 | 1 | 0 | 1 |
//
// f = (~x1 & ~x2 & ~x3)             -- row x2x3=00 depends only on x1
//   | (x2 & x3 & (~x0 | x1))        -- row x2x3=11: (~x0) OR x1
//   | (x2 & ~x3 & (~x0 | ~x1))      -- row x2x3=10: (~x0) OR (~x1)
// Row x2x3=01 contributes nothing (always 0), matching @row_x2_0_x3_1.
// ============================================================================

module TopModule (
    input  [3:0] x,
    output       f
);

    // Internal wires for clarity, matching Karnaugh-map row/column scenarios
    wire row_00; // x2x3 = 00 : depends only on x1  (@row_x2_0_x3_0)
    wire row_01; // x2x3 = 01 : always 0            (@row_x2_0_x3_1)
    wire row_11; // x2x3 = 11 : (~x0) OR x1          (@row_x2_1_x3_1)
    wire row_10; // x2x3 = 10 : (~x0) OR (~x1)       (@row_x2_1_x3_0)

    // Row x2x3 = 00: f = NOT x1, independent of x0
    assign row_00 = (~x[2] & ~x[3]) & (~x[1]);

    // Row x2x3 = 01: f = 0 always
    assign row_01 = 1'b0; // (~x[2] & x[3]) case, contributes nothing

    // Row x2x3 = 11: f = (~x0) OR x1
    assign row_11 = (x[2] & x[3]) & (~x[0] | x[1]);

    // Row x2x3 = 10: f = (~x0) OR (~x1)
    assign row_10 = (x[2] & ~x[3]) & (~x[0] | ~x[1]);

    // Combine all rows (mutually exclusive on x2,x3 combinations)
    // This directly implements the @full_function scenario and is
    // purely combinational, satisfying @no_state (no memory elements).
    assign f = row_00 | row_01 | row_11 | row_10;

endmodule