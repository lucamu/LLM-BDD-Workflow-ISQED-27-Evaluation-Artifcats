// ============================================================
// Module: TopModule
// Purpose: 8-bit register built from 8 D flip-flops with
//          synchronous active-high reset. On each rising edge
//          of clk, if reset is asserted, q is cleared to zero;
//          otherwise q captures the value of d.
// ============================================================
module TopModule (
    input        clk,
    input  [7:0] d,
    input        reset,
    output [7:0] q
);

    // Internal register holding the flip-flop state
    reg [7:0] q_reg;

    // Sequential logic: synchronous reset with priority over data capture
    always @(posedge clk) begin
        if (reset) begin
            // @reset @synchronous, @reset @priority, @reset @stability
            // Reset forces q to zero on the clock edge, regardless of d,
            // and remains zero as long as reset stays asserted.
            q_reg <= 8'b00000000;
        end else begin
            // @data @capture, @bitwise @independence
            // When reset is not asserted, q captures d bit-for-bit.
            q_reg <= d;
        end
        // @stability @no_edge : q_reg only updates on posedge clk,
        // so without a clock edge it naturally remains stable.
        // @deassertion @transition : handled automatically since
        // the same always block re-evaluates reset each cycle,
        // allowing transition from reset value to captured data.
    end

    // Continuous assignment of registered output
    assign q = q_reg;

endmodule