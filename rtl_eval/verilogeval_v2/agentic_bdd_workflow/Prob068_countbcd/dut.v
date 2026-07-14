// ============================================================================
// Module: TopModule
// Purpose: 4-digit BCD counter with synchronous active-high reset.
//          Each digit (ones, tens, hundreds, thousands) counts 0-9 and
//          rolls over to the next digit when it reaches 9, similar to a
//          cascaded BCD counter chain. The 'ena' outputs indicate the
//          carry/enable condition for each upper digit (combinational,
//          based on current state of lower digits).
// ============================================================================
module TopModule (
    input  wire        clk,
    input  wire         reset,
    output wire [3:1]  ena,
    output reg  [15:0] q
);

    // Internal digit aliases for readability
    wire [3:0] ones_digit     = q[3:0];
    wire [3:0] tens_digit     = q[7:4];
    wire [3:0] hundreds_digit = q[11:8];
    wire [3:0] thousands_digit = q[15:12];

    // ------------------------------------------------------------------
    // Combinational enable signals (Scenarios: ena1_combinational,
    // ena2_combinational, ena3_combinational)
    // ena[1]: ones digit is at max (9) -> tens digit should increment next
    // ena[2]: ones and tens digits are both at max -> hundreds increments
    // ena[3]: ones, tens, hundreds digits all at max -> thousands increments
    // ------------------------------------------------------------------
    assign ena[1] = (ones_digit == 4'b1001);
    assign ena[2] = (ones_digit == 4'b1001) && (tens_digit == 4'b1001);
    assign ena[3] = (ones_digit == 4'b1001) && (tens_digit == 4'b1001) &&
                     (hundreds_digit == 4'b1001);

    // ------------------------------------------------------------------
    // Sequential logic: synchronous reset and BCD counting behavior
    // ------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset) begin
            // Scenario: Synchronous reset clears the counter to zero
            q <= 16'h0000;
        end else begin
            // ------------------------------------------------------
            // Ones digit: increments every cycle, wraps at 9
            // (Scenarios: ones_digit_increment, ones_digit_wrap)
            // ------------------------------------------------------
            if (ones_digit == 4'b1001)
                q[3:0] <= 4'b0000;
            else
                q[3:0] <= ones_digit + 4'b0001;

            // ------------------------------------------------------
            // Tens digit: increments only when ones digit is 9
            // (Scenarios: tens_digit_increment, tens_digit_hold,
            //  tens_digit_wrap)
            // ------------------------------------------------------
            if (ones_digit == 4'b1001) begin
                if (tens_digit == 4'b1001)
                    q[7:4] <= 4'b0000;
                else
                    q[7:4] <= tens_digit + 4'b0001;
            end else begin
                q[7:4] <= tens_digit; // hold
            end

            // ------------------------------------------------------
            // Hundreds digit: increments only when ones & tens are 9
            // (Scenarios: hundreds_digit_increment, hundreds_digit_hold,
            //  hundreds_digit_wrap)
            // ------------------------------------------------------
            if ((ones_digit == 4'b1001) && (tens_digit == 4'b1001)) begin
                if (hundreds_digit == 4'b1001)
                    q[11:8] <= 4'b0000;
                else
                    q[11:8] <= hundreds_digit + 4'b0001;
            end else begin
                q[11:8] <= hundreds_digit; // hold
            end

            // ------------------------------------------------------
            // Thousands digit: increments only when ones, tens, and
            // hundreds are all 9
            // (Scenarios: thousands_digit_increment, thousands_digit_hold)
            // ------------------------------------------------------
            if ((ones_digit == 4'b1001) && (tens_digit == 4'b1001) &&
                (hundreds_digit == 4'b1001)) begin
                if (thousands_digit == 4'b1001)
                    q[15:12] <= 4'b0000;
                else
                    q[15:12] <= thousands_digit + 4'b0001;
            end else begin
                q[15:12] <= thousands_digit; // hold
            end
        end
    end

endmodule