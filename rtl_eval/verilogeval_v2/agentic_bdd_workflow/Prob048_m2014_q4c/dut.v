// ============================================================================
// Module: TopModule
// Purpose: D Flip-Flop with Active-High Synchronous Reset
//
// On each rising edge of clk:
//   - If r is asserted (1), q is synchronously reset to 0 (reset priority).
//   - Otherwise, q captures the value of d.
//   - Between clock edges, q holds its last registered value (stability).
// ============================================================================
module TopModule (
    input  clk,
    input  d,
    input  r,
    output q
);

    // Registered output storage element
    reg q_reg;

    // Sequential logic: synchronous active-high reset, else capture d
    always @(posedge clk) begin
        if (r) begin
            // @reset @synchronous @priority @initial @poweron
            // Reset takes priority over data input, forces q to known 0
            q_reg <= 1'b0;
        end else begin
            // @data @capture
            // Capture d when reset is not asserted
            q_reg <= d;
        end
        // @stability: q_reg only updates on rising edge of clk,
        // remaining stable otherwise (implicit in always @(posedge clk))
    end

    // Continuous assignment of registered value to output
    assign q = q_reg;

endmodule