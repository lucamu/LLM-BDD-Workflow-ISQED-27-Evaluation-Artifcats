// ============================================================================
// Module: TopModule
// Purpose: Decade counter (1 to 10 inclusive) with synchronous active-high
//          reset. Counts up by 1 each clock edge, wraps from 10 back to 1.
// ============================================================================
module TopModule (
    input        clk,
    input        reset,
    output [3:0] q
);

    // Registered output storage
    reg [3:0] q_reg;

    assign q = q_reg;

    always @(posedge clk) begin
        if (reset) begin
            // @reset / @reset-priority:
            // Synchronous reset forces counter to 1, takes priority over counting
            q_reg <= 4'b0001;
        end
        else if (q_reg == 4'b1010) begin
            // @wraparound: Counter wraps from 10 back to 1
            q_reg <= 4'b0001;
        end
        else begin
            // @increment: Counter increments by one when not at maximum
            // @range-invariant / @no-invalid-state: stays within 1..10 range
            q_reg <= q_reg + 4'b0001;
        end
        // @stability-without-clock: no change occurs without a clk edge,
        // guaranteed since this block is only sensitive to posedge clk
    end

endmodule