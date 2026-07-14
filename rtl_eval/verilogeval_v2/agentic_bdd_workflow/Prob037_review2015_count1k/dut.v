// Module: TopModule
// Purpose: Mod-1000 counter with synchronous active-high reset.
//          Counts 0 to 999, then wraps back to 0. Registered output q.

module TopModule (
    input               clk,
    input               reset,
    output reg [9:0]    q
);

    always @(posedge clk) begin
        if (reset) begin
            // @reset, @reset_priority: synchronous reset forces q to 0
            // regardless of current count value (priority over increment)
            q <= 10'd0;
        end
        else if (q == 10'd999) begin
            // @wraparound: counter wraps to zero after reaching 999
            q <= 10'd0;
        end
        else begin
            // @increment, @stability: counter increments by one
            // (Q+1) mod 1000, since Q < 999 here, simple +1 suffices
            q <= q + 10'd1;
        end
    end

    // @range: since q only ever takes values 0..999 by construction
    // (reset -> 0, increment -> Q+1 while Q<999, wrap at 999 -> 0),
    // q is always in [0,999], and as unsigned reg it is always >= 0.
    // @periodicity: because the sequence 0,1,...,999,0,... has exactly
    // 1000 distinct states, after 1000 rising edges with reset held low,
    // q returns to its original value Q.

endmodule