// =============================================================================
// Module: TopModule
// Purpose: 4-bit Johnson (twisted ring) counter.
//          Cycles through: 0000 -> 1000 -> 1100 -> 1110 -> 1111 ->
//                           0111 -> 0011 -> 0001 -> 0000 (repeat)
//          Implements right-shift with inverted feedback:
//              Q_next = { ~Q[0], Q[3:1] }
// =============================================================================
module TopModule (
    input  clk,
    input  rst_n,
    output reg [3:0] Q
);

    // -------------------------------------------------------------------
    // Sequential logic: registered output Q updated on posedge clk
    // Asynchronous active-low reset forces Q to 0000
    // -------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // @reset: Asynchronous reset forces Q to 0000 immediately
            // @reset: Q remains 0000 while reset is held low
            Q <= 4'b0000;
        end
        else begin
            // @transition: Johnson counter shift with inverted feedback
            // Covers all transitions:
            //   0000->1000, 1000->1100, 1100->1110, 1110->1111,
            //   1111->0111, 0111->0011, 0011->0001, 0001->0000
            // @invariant: Since Q_next is derived purely from shifting Q
            //   with inverted feedback, Q always stays within the
            //   8-state Johnson sequence and never enters an
            //   unreachable state.
            // @cycle: After 8 consecutive clock edges starting from 0000,
            //   the sequence returns to 0000 (full cycle).
            Q <= {~Q[0], Q[3:1]};
        end
    end

endmodule