// =============================================================
// Description: Stopwatch with second counter (1-60) and minute
//              counter (0-60). Second wraps 60->1 incrementing
//              minute. When minute reaches 60, both counters pause
//              (hold their values) until reset.
// =============================================================
module TopModule (
    input        clk,
    input        rst_n,
    output reg [5:0] second,
    output reg [5:0] minute
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // @reset @async, @reset @deassert, @reset @priority,
            // @reset @priority-during-count
            second <= 6'd0;
            minute <= 6'd0;
        end
        else if (minute == 6'd60) begin
            // @pause @hold, @pause @multi-cycle-hold
            // Minute saturated: stopwatch pauses, hold both values
            second <= second;
            minute <= minute;
        end
        else if (second == 6'd60) begin
            // @wrap @minute-increment, @saturate @pause-trigger
            // Second wraps from 60 to 1, minute increments
            second <= 6'd1;
            minute <= minute + 6'd1;
        end
        else begin
            // @init @from-reset, @normal @increment,
            // @boundary @minute-not-yet-max
            // Normal increment of second, minute unchanged
            second <= second + 6'd1;
            minute <= minute;
        end
    end

endmodule