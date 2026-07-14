// ============================================================================
// Module: TopModule
// Purpose: 4-bit decade counter (0-9) with synchronous active-high reset.
//          Counts 0,1,2,...,9,0,1,... on each positive edge of clk.
//          Reset takes priority over counting and forces q to 0.
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
            // @reset @safety, @reset @priority:
            // Synchronous reset forces counter to zero regardless of state
            q_reg <= 4'b0000;
        end
        else begin
            // @wraparound @functional:
            // Counter wraps from nine (1001) back to zero
            if (q_reg == 4'b1001) begin
                q_reg <= 4'b0000;
            end
            // @increment @functional:
            // Counter increments by one when not at terminal count (9)
            else begin
                q_reg <= q_reg + 4'b0001;
            end
        end
    end

    // Notes on other scenarios (properties, not separate hardware logic):
    // @range @invariant, @stability @invariant, @induction @safety:
    //   Because q_reg only ever takes values 0000-1001 (0-9) via the
    //   increment/wraparound logic above, and reset always drives it to 0,
    //   the counter never produces or persists in a state greater than 9.
    // @liveness @periodicity:
    //   Starting from q=0 with reset=0 held for 10 consecutive cycles,
    //   the increment/wraparound logic guarantees q returns to 0 exactly
    //   after the 10th positive edge (0->1->2->...->9->0).

endmodule