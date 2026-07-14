// ============================================================================
// Module: TopModule
// Purpose: 3-bit synchronous counter with load control.
//          On each rising edge of clk:
//            - if a==1, load q with fixed value 3'b100 (load priority)
//            - else if q < 3'b110, increment q by 1
//            - else (q == 3'b110), wrap q around to 3'b000
//          No reset input; initial value of q is don't-care.
// ============================================================================
module TopModule (
    input        clk,
    input        a,
    output [2:0] q
);

    // Internal register holding the counter state
    reg [2:0] q_reg;

    // Sequential logic: updates only on rising edge of clk
    always @(posedge clk) begin
        if (a) begin
            // Scenario: Loading fixed value 4 when a is asserted
            // Scenario: Load takes priority over increment or wraparound
            q_reg <= 3'b100;
        end
        else if (q_reg < 3'b110) begin
            // Scenario: Incrementing q when a is deasserted and q_prev < 6
            q_reg <= q_reg + 3'b001;
        end
        else begin
            // Scenario: Wrapping to zero when a is deasserted and q_prev == 6
            q_reg <= 3'b000;
        end
        // Scenario: Holding value when no rising edge occurs is implicit,
        // since this block only executes on posedge clk; between edges
        // q_reg retains its value automatically.
    end

    // Registered output assignment
    assign q = q_reg;

endmodule