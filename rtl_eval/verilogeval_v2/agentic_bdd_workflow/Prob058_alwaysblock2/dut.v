// =============================================================================
// Module: TopModule
// Purpose: Demonstrates three RTL constructs implementing an XOR gate:
//          1. Continuous assign statement (combinational)
//          2. Combinational always block (always @*)
//          3. Clocked always block (registered, one-cycle delayed)
// =============================================================================
module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // -------------------------------------------------------------------
    // Scenario: out_assign is the combinational XOR of a and b
    // Continuous assign statement - no dependency on clk
    // -------------------------------------------------------------------
    assign out_assign = a ^ b;

    // -------------------------------------------------------------------
    // Scenario: out_always_comb is the combinational XOR of a and b
    // Combinational always block - evaluates whenever a or b changes
    // -------------------------------------------------------------------
    reg out_always_comb_reg;

    always @* begin
        // Blocking assignment for combinational logic
        out_always_comb_reg = a ^ b;
    end

    assign out_always_comb = out_always_comb_reg;

    // -------------------------------------------------------------------
    // Scenario: out_always_ff reflects the XOR of a and b from the
    //           previous clock cycle (registered output)
    // Scenario: out_always_ff does not change combinationally with a/b
    // Scenario: out_always_ff updates only on the rising edge of clk
    // Scenario: Combinational outputs match one cycle ahead of the
    //           registered output
    // -------------------------------------------------------------------
    reg out_always_ff_reg;

    always @(posedge clk) begin
        // Non-blocking assignment for sequential logic
        // Captures XOR of a and b at the rising edge, producing a
        // one-cycle delayed version of the combinational XOR result
        out_always_ff_reg <= a ^ b;
    end

    assign out_always_ff = out_always_ff_reg;

endmodule