// ============================================================================
// Module: TopModule
// Purpose: Combinational AND-OR-NOT circuit
//          out   = (a AND b) OR (c AND d)
//          out_n = NOT(out)
// ============================================================================
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    // Internal wires for the two AND gate outputs
    wire and1_out; // a AND b
    wire and2_out; // c AND d

    // Scenario: First AND gate computes AND of a and b
    assign and1_out = a & b;

    // Scenario: Second AND gate computes AND of c and d
    assign and2_out = c & d;

    // Scenario: out equals OR of two AND terms
    // Covers edge-cases: out=1 when either AND term asserted regardless of other,
    // out=0 when both AND terms deasserted, and sensitivity scenarios.
    assign out = and1_out | and2_out;

    // Scenario: out_n is the logical inverse of out
    // Also guarantees out XOR out_n always equals 1 (consistency scenario)
    assign out_n = ~out;

endmodule