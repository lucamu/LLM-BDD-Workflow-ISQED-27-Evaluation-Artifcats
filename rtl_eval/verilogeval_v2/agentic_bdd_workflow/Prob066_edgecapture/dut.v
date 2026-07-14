// Module: TopModule
// Purpose: Sticky falling-edge detector for a 32-bit input vector.
// Each output bit latches a 1-to-0 transition on the corresponding
// input bit and holds it (sticky) until synchronous reset clears it.

module TopModule (
    input         clk,
    input         reset,
    input  [31:0] in,
    output [31:0] out
);

    // Registered output (sticky captured bits)
    reg [31:0] out_reg;

    // Register to remember previous value of "in" for edge detection
    reg [31:0] prev_in;

    assign out = out_reg;

    always @(posedge clk) begin
        if (reset) begin
            // @reset / @reset_priority : synchronous reset clears everything
            out_reg <= 32'h00000000;
            prev_in <= 32'h00000000; // clear history so no false capture after reset
        end else begin
            // @capture / @falling_edge / @vector_update / @independence:
            // Set bit if previous bit was 1 and current bit is 0 (falling edge),
            // OR keep bit set if it was already 1 (sticky behavior - @sticky).
            // @no_capture scenarios (stable_high, stable_low, rising_edge) are
            // naturally handled since (prev_in & ~in) is 0 in those cases.
            out_reg <= (prev_in & ~in) | out_reg;

            // Update history of "in" for next cycle's edge detection
            prev_in <= in;
        end
    end

endmodule