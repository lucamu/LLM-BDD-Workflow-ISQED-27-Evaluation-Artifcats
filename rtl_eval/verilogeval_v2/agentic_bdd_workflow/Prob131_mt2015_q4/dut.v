// ============================================================================
// Module: SubmoduleA
// Purpose: Computes A_out = x & (~y)
// ============================================================================
module TopModule (
    input  wire A_x,
    input  wire A_y,
    output wire A_out
);
    assign A_out = A_x & (~A_y);
endmodule

// ============================================================================
// Module: SubmoduleB
// Purpose: Computes B_out = ~(x ^ y)
// ============================================================================
module SubmoduleB (
    input  wire B_x,
    input  wire B_y,
    output wire B_out
);
    assign B_out = ~(B_x ^ B_y);
endmodule

// ============================================================================
// Module: TopModule
// Purpose: Top-level combinational logic composed of two A instances and
//          two B instances feeding OR/AND gates, combined via XOR to
//          produce output z. Implements all specified formal scenarios.
// ============================================================================
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

    // Internal wires for the two A instances and two B instances
    wire A_out_1, A_out_2;
    wire B_out_1, B_out_2;

    // Internal wires for OR/AND/XOR composition
    wire OR_out;
    wire AND_out;

    // ------------------------------------------------------------------
    // First A instance and first B instance -> OR gate
    // Scenario: Top-level output equals XOR of the A and B functions
    // ------------------------------------------------------------------
    SubmoduleA A_inst1 (
        .A_x   (x),
        .A_y   (y),
        .A_out (A_out_1)
    );

    SubmoduleB B_inst1 (
        .B_x   (x),
        .B_y   (y),
        .B_out (B_out_1)
    );

    // OR_out = A_out | B_out (using first A/B instance pair)
    assign OR_out = A_out_1 | B_out_1;

    // ------------------------------------------------------------------
    // Second A instance and second B instance -> AND gate
    // ------------------------------------------------------------------
    SubmoduleA A_inst2 (
        .A_x   (x),
        .A_y   (y),
        .A_out (A_out_2)
    );

    SubmoduleB B_inst2 (
        .B_x   (x),
        .B_y   (y),
        .B_out (B_out_2)
    );

    // AND_out = A_out & B_out (using second A/B instance pair)
    assign AND_out = A_out_2 & B_out_2;

    // ------------------------------------------------------------------
    // Scenario: OR/AND/XOR composition is equivalent to direct XOR of A and B
    // Scenario: Simplified closed-form relationship for output z
    //           z = OR_out ^ AND_out = A_out ^ B_out = x | (~y)
    // Scenario: Corner cases (x=0,y=0)->1, (x=0,y=1)->0, (x=1,y=0)->1, (x=1,y=1)->1
    // Scenario: Stateless - output depends only on current x,y (pure combinational,
    //           no registers/memory, so no dependency on previous values)
    // ------------------------------------------------------------------
    assign z = OR_out ^ AND_out;

endmodule