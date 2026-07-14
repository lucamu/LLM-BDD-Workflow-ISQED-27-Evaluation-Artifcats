// ============================================================================
// Module: TopModule
// Purpose: Demonstrates combinational AND gate implemented two ways:
//          1) Continuous assignment (out_assign)
//          2) Combinational always block (out_alwaysblock)
//          Both outputs must always be logically equivalent (A & B).
// ============================================================================
module TopModule (
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

    // -------------------------------------------------------------------
    // Scenario: out_assign implements bitwise AND of a and b
    // Scenario: Both outputs are 0 when a is 0 / b is 0
    // Scenario: Both outputs follow a when b is 1 / follow b when a is 1
    // Scenario: Both outputs are 1 only when both inputs are 1
    // -------------------------------------------------------------------
    assign out_assign = a & b;

    // -------------------------------------------------------------------
    // Scenario: out_alwaysblock implements bitwise AND of a and b
    // Scenario: out_assign and out_alwaysblock are always equivalent
    // Scenario: No internal state persists between evaluations
    //   - Combinational always block with full sensitivity (a, b)
    //   - Uses blocking assignment, no latch inferred (output always driven)
    // -------------------------------------------------------------------
    reg out_alwaysblock_reg;

    always @(*) begin
        // Full combinational assignment: covers all input combinations,
        // no incomplete branches, no latch inference.
        out_alwaysblock_reg = a & b;
    end

    assign out_alwaysblock = out_alwaysblock_reg;

endmodule