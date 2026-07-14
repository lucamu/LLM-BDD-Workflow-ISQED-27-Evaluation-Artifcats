// =============================================================================
// Module      : TopModule
// Purpose     : Fractional Frequency Divider (8.7x)
//
// Produces clk_out from clk_in with an average division ratio of 8.7 by
// alternating between two period lengths:
//      div_e = 8  clk_in cycles ("even"/short period)
//      div_o = 9  clk_in cycles ("odd"/long period)
// Over every WINDOW = 10 consecutive clk_out periods, the total number of
// clk_in cycles consumed sums exactly to M_N = 87 (countE*8 + countO*9 = 87,
// with countE = 3, countO = 7). The selection between div_e/div_o each
// period is made by a fractional phase accumulator (acc) whose scaled value
// is compared against the switching-point threshold c89 = 24 (@switching_threshold).
// =============================================================================
module TopModule (
    input  clk_in,
    input  rst,        // active-low synchronous reset
    output clk_out
);

    // -------------------------------------------------------------------
    // Parameters (per specification, exact widths as required)
    // -------------------------------------------------------------------
    parameter [7:0] M_N   = 8'd87; // clk_in cycles summed over 10 clk_out periods
    parameter [7:0] c89   = 8'd24; // switching-point threshold (scaled: 3*div_e)
    parameter [4:0] div_e = 5'd8;  // short period length (clk_in cycles)
    parameter [4:0] div_o = 5'd9;  // long period length (clk_in cycles)

    // Fixed pattern window (10 clk_out periods per repeating pattern)
    localparam [7:0] WINDOW    = 8'd10;
    // Fractional excess consumed by the accumulator each period:
    // M_N - WINDOW*div_e = 87 - 80 = 7
    localparam [7:0] FRAC_STEP = 8'd7;

    // -------------------------------------------------------------------
    // Internal state registers
    // -------------------------------------------------------------------
    reg       clk_out_reg;  // registered clk_out value
    reg [4:0] period_cnt;   // internal period counter: counts clk_in cycles
                            // within the current clk_out period
    reg [4:0] acc;          // fractional phase accumulator /
                            // "even/odd phase selector" (reset state = 0)
    reg [4:0] cur_len;      // currently selected period length (div_e or div_o)

    // -------------------------------------------------------------------
    // Combinational: compute next accumulator value and next period length
    // (@switching_threshold, @pattern_composition, @average_ratio)
    // -------------------------------------------------------------------
    reg [7:0] acc_sum;
    reg [4:0] acc_next;
    reg [7:0] acc_scaled;
    reg       cross_thresh;
    reg [4:0] cur_len_next;

    always @(*) begin
        // advance the phase accumulator by the fractional excess step
        acc_sum = acc + FRAC_STEP;

        // wrap within the 10-period window
        if (acc_sum >= WINDOW)
            acc_next = acc_sum[4:0] - WINDOW[4:0];
        else
            acc_next = acc_sum[4:0];

        // scale the accumulator and compare against the c89 threshold:
        // acc_next * div_e >= c89  <=>  acc_next >= 3 (since c89 = 3*div_e)
        acc_scaled   = acc_next * div_e;
        cross_thresh = (acc_scaled >= c89);

        // crossing the threshold selects the longer (div_o) period,
        // otherwise the shorter (div_e) period is selected
        cur_len_next = cross_thresh ? div_o : div_e;
    end

    // -------------------------------------------------------------------
    // Sequential logic: synchronous, active-low reset, single clock domain
    // -------------------------------------------------------------------
    always @(posedge clk_in) begin
        if (!rst) begin
            // @reset : force all state to known reset values
            period_cnt  <= 5'd0;
            acc         <= 5'd0;      // phase selector reset state
            cur_len     <= div_e;     // reset-defined initial phase
            clk_out_reg <= 1'b0;
        end
        else begin
            // @reset_release : counting resumes from 0 once rst deasserts
            if (period_cnt == (cur_len - 5'd1)) begin
                // @counter_wrap / @period_bound : end of current period
                period_cnt  <= 5'd0;
                clk_out_reg <= ~clk_out_reg;   // toggle clk_out at boundary
                acc         <= acc_next;       // update fractional accumulator
                cur_len     <= cur_len_next;   // select next period's length
            end
            else begin
                // @monotonic_counter : keep counting, clk_out does not toggle
                period_cnt <= period_cnt + 5'd1;
            end
        end
    end

    // -------------------------------------------------------------------
    // Output assignment (registered clock, changes only on clk_in edges)
    // Satisfies @no_glitch and @output_dependency by construction.
    // -------------------------------------------------------------------
    assign clk_out = clk_out_reg;

endmodule