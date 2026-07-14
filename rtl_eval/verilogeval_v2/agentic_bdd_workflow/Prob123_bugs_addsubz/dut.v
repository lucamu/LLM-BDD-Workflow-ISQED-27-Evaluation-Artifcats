// ============================================================================
// Module: TopModule
// Purpose: Adder-Subtractor with Zero Flag
//   - Computes out = a + b when do_sub = 0 (addition mode)
//   - Computes out = a - b when do_sub = 1 (subtraction mode)
//   - result_is_zero is a pure combinational equality-to-zero test on out
//   - No clock/reset; purely combinational, no latches
// ============================================================================
module TopModule (
    input        do_sub,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out,
    output       result_is_zero
);

    reg [7:0] out_r;

    // Scenario: Addition mode computes correct sum
    // Scenario: Subtraction mode computes correct difference
    // Combinational logic, all branches covered -> no latch
    always @(*) begin
        if (do_sub)
            out_r = a - b;   // Subtraction mode
        else
            out_r = a + b;   // Addition mode
    end

    assign out = out_r;

    // Scenario: Zero flag asserted / deasserted
    // Scenario: Zero flag is always a deterministic function of out (no latch)
    // Scenario: Output is independent of unrelated signal history
    //   (combinational assign guarantees purity - no stored state)
    // Use true equality-to-zero test, not bitwise inversion
    assign result_is_zero = (out_r == 8'b00000000) ? 1'b1 : 1'b0;

endmodule