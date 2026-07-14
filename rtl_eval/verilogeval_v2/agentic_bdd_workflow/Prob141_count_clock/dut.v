// =============================================================================
// Module: TopModule
// Purpose: 12-Hour Digital Clock with BCD-encoded hours, minutes, seconds
//          outputs and an AM/PM indicator. Synchronous active-high reset
//          forces the clock to 12:00:00 AM. When enabled (ena=1), the clock
//          counts seconds, rolling over into minutes and hours as needed,
//          and toggles AM/PM when the hour rolls from 12 to 1.
// =============================================================================
module TopModule (
    input        clk,
    input        reset,
    input        ena,
    output       pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Registered state elements
    reg        pm_r;
    reg [7:0]  hh_r;
    reg [7:0]  mm_r;
    reg [7:0]  ss_r;

    assign pm = pm_r;
    assign hh = hh_r;
    assign mm = mm_r;
    assign ss = ss_r;

    // -------------------------------------------------------------------
    // Function: bcd59_inc
    // Increments a BCD value in range 00-59, wrapping 59 -> 00.
    // Sets carry_out = 1 when a rollover (59->00) occurs.
    // -------------------------------------------------------------------
    function [8:0] bcd59_inc; // {carry_out, new_val[7:0]}
        input [7:0] val;
        reg [3:0] tens, ones;
        reg carry;
        begin
            tens = val[7:4];
            ones = val[3:0];
            carry = 1'b0;
            if (ones == 4'd9) begin
                ones = 4'd0;
                if (tens == 4'd5) begin
                    tens  = 4'd0;
                    carry = 1'b1; // 59 -> 00 rollover
                end else begin
                    tens = tens + 4'd1;
                end
            end else begin
                ones = ones + 4'd1;
            end
            bcd59_inc = {carry, tens, ones};
        end
    endfunction

    // -------------------------------------------------------------------
    // Function: bcd_hour_inc
    // Increments a BCD hour value in range 01-12, wrapping 12 -> 01.
    // Sets pm_toggle = 1 when the 12 -> 01 rollover occurs.
    // -------------------------------------------------------------------
    function [8:0] bcd_hour_inc; // {pm_toggle, new_val[7:0]}
        input [7:0] val;
        reg [3:0] tens, ones;
        reg toggle;
        begin
            toggle = 1'b0;
            if (val == 8'h12) begin
                // Hour rollover: 12 -> 01, toggles AM/PM
                tens   = 4'd0;
                ones   = 4'd1;
                toggle = 1'b1;
            end else if (val[3:0] == 4'd9) begin
                // e.g., 09 -> 10
                tens = val[7:4] + 4'd1;
                ones = 4'd0;
            end else begin
                tens = val[7:4];
                ones = val[3:0] + 4'd1;
            end
            bcd_hour_inc = {toggle, tens, ones};
        end
    endfunction

    // Combinational computation of next values
    reg [8:0] ss_next_c;   // {ss_carry, new_ss}
    reg [8:0] mm_next_c;   // {mm_carry, new_mm}
    reg [8:0] hh_next_c;   // {pm_toggle, new_hh}
    reg       ss_carry;
    reg       mm_carry;
    reg       pm_toggle;
    reg [7:0] ss_next, mm_next, hh_next;

    always @(*) begin
        // Compute seconds increment and carry
        ss_next_c = bcd59_inc(ss_r);
        ss_carry  = ss_next_c[8];
        ss_next   = ss_next_c[7:0];

        // Minutes increment only if seconds rolled over
        if (ss_carry) begin
            mm_next_c = bcd59_inc(mm_r);
            mm_carry  = mm_next_c[8];
            mm_next   = mm_next_c[7:0];
        end else begin
            mm_carry = 1'b0;
            mm_next  = mm_r;
        end

        // Hours increment only if both seconds and minutes rolled over
        if (ss_carry && mm_carry) begin
            hh_next_c = bcd_hour_inc(hh_r);
            pm_toggle = hh_next_c[8];
            hh_next   = hh_next_c[7:0];
        end else begin
            pm_toggle = 1'b0;
            hh_next   = hh_r;
        end
    end

    // -------------------------------------------------------------------
    // Sequential logic: synchronous reset has top priority, then enable
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset) begin
            // @reset / @sync_priority_over_hold: force 12:00:00 AM
            pm_r <= 1'b0;
            hh_r <= 8'h12;
            mm_r <= 8'h00;
            ss_r <= 8'h00;
        end else if (ena) begin
            // @seconds/@minutes/@hours increment & rollover scenarios
            ss_r <= ss_next;
            mm_r <= mm_next;
            hh_r <= hh_next;
            pm_r <= pm_r ^ pm_toggle; // @hours_rollover_pm_toggle
        end else begin
            // @hold/@idle: no reset, no enable -> hold all state
            pm_r <= pm_r;
            hh_r <= hh_r;
            mm_r <= mm_r;
            ss_r <= ss_r;
        end
    end

endmodule