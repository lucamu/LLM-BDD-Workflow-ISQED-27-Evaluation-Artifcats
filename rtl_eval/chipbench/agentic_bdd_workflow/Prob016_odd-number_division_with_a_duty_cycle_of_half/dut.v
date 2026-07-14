// =============================================================================
// Module: TopModule
// Purpose: 7:1 clock divider producing clk_out7 from clk_in with an exact
//          50% duty cycle, using dual-edge counting so that a 50% duty cycle
//          is achievable even though the divide ratio (7) is odd.
//
// Design approach:
//   - pos_cnt increments on every rising edge of clk_in (mod 7)
//   - neg_cnt increments on every falling edge of clk_in (mod 7)
//   - clk_out7 is high whenever either counter is in its "low half" range,
//     which yields exactly 7 high half-cycles and 7 low half-cycles per
//     14 half-cycles (7 full clk_in cycles) -> 50% duty cycle.
//   - rst is active-low and synchronously clears both counters to zero,
//     forcing clk_out7 to its defined reset value (both counters == 0).
// =============================================================================

module TopModule (
    input  wire rst,       // active-low synchronous reset
    input  wire clk_in,    // reference input clock
    output wire clk_out7   // divided output clock, 7:1 ratio, 50% duty cycle
);

    // Internal counters: 3 bits enough to count 0..6
    reg [2:0] pos_cnt; // increments on rising edges of clk_in
    reg [2:0] neg_cnt; // increments on falling edges of clk_in

    // -------------------------------------------------------------------
    // Scenario: Reset forces clk_out7 to its defined initial state
    // Scenario: clk_out7 holds its reset value while reset remains asserted
    // Scenario: clk_out7 resumes correct periodic division after reset release
    // -------------------------------------------------------------------
    always @(posedge clk_in) begin
        if (!rst) begin
            // Reset condition: hold counter at zero
            pos_cnt <= 3'd0;
        end else begin
            // Wrap every 7 rising edges (0..6)
            if (pos_cnt == 3'd6)
                pos_cnt <= 3'd0;
            else
                pos_cnt <= pos_cnt + 3'd1;
        end
    end

    always @(negedge clk_in) begin
        if (!rst) begin
            // Reset condition: hold counter at zero
            neg_cnt <= 3'd0;
        end else begin
            // Wrap every 7 falling edges (0..6)
            if (neg_cnt == 3'd6)
                neg_cnt <= 3'd0;
            else
                neg_cnt <= neg_cnt + 3'd1;
        end
    end

    // -------------------------------------------------------------------
    // Scenario: clk_out7 period equals seven clk_in cycles
    // Scenario: clk_out7 frequency is one seventh of clk_in frequency
    // Scenario: clk_out7 maintains a 50% duty cycle over one period
    // Scenario: clk_out7 transitions occur only at clk_in edges
    //           (clk_out7 is purely a function of the registered counters,
    //            so it can only change value when a counter updates, i.e.
    //            exactly at a clk_in rising or falling edge)
    // Scenario: The 7:1 division pattern repeats indefinitely without drift
    // Scenario: clk_out7 value depends only on clk_in history since last reset
    // -------------------------------------------------------------------
    // High for the "low half" of each mod-7 counter (values 0,1,2),
    // combined via OR from both edge-aligned counters to produce an
    // exact 50% duty cycle over the full 7-cycle (14 half-cycle) period.
    assign clk_out7 = (pos_cnt < 3'd3) | (neg_cnt < 3'd3);

endmodule