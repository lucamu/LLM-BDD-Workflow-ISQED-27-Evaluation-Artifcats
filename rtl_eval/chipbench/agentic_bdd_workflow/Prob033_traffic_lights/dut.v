// ============================================================================
// Module: TopModule
// Purpose: Traffic Light Controller with Pedestrian Request
//
// Implements a red -> green -> yellow -> red cycle:
//   RED    : 10 cycles
//   GREEN  : 60 cycles nominally, shortened to 10 cycles remaining if
//            pass_request is asserted while remaining time > 10
//   YELLOW : 5 cycles
//
// rst_n is active-low asynchronous reset that forces the RED state with
// clock = 10.
// ============================================================================
module TopModule (
    input        rst_n,
    input        clk,
    input        pass_request,
    output [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // -------------------------------------------------------------------
    // State encoding for the three mutually exclusive light states
    // -------------------------------------------------------------------
    localparam [1:0] S_RED    = 2'b00;
    localparam [1:0] S_GREEN  = 2'b01;
    localparam [1:0] S_YELLOW = 2'b10;

    reg [1:0] state, next_state;
    reg [7:0] clock_reg, next_clock;

    // -------------------------------------------------------------------
    // Sequential state/counter update
    // Scenario: reset  -- async reset forces red state, clock = 10
    // Scenario: reset_async -- reset overrides regardless of prior state
    // -------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= S_RED;
            clock_reg <= 8'd10;
        end else begin
            state     <= next_state;
            clock_reg <= next_clock;
        end
    end

    // -------------------------------------------------------------------
    // Combinational next-state / next-clock logic
    // -------------------------------------------------------------------
    always @(*) begin
        // Default: hold current state, decrement clock
        next_state = state;
        next_clock = clock_reg - 8'd1;

        case (state)
            // ----------------------------------------------------------
            // RED state: counts down from 10 to 1, ignores pass_request
            // Scenario: red_countdown, red_to_green, pedestrian_no_effect_red
            // ----------------------------------------------------------
            S_RED: begin
                if (clock_reg == 8'd1) begin
                    // Countdown expired -> transition to green
                    next_state = S_GREEN;
                    next_clock = 8'd60;
                end else begin
                    // Continue counting down, pass_request has no effect
                    next_state = S_RED;
                    next_clock = clock_reg - 8'd1;
                end
            end

            // ----------------------------------------------------------
            // GREEN state: counts down from 60 to 1
            // Scenario: green_countdown, green_to_yellow,
            //           pedestrian_shorten, pedestrian_no_effect_green
            // ----------------------------------------------------------
            S_GREEN: begin
                if (clock_reg == 8'd1) begin
                    // Countdown expired -> transition to yellow
                    next_state = S_YELLOW;
                    next_clock = 8'd5;
                end else if (pass_request && (clock_reg > 8'd10)) begin
                    // Pedestrian request shortens remaining green time to 10
                    next_state = S_GREEN;
                    next_clock = 8'd10;
                end else begin
                    // Continue counting down normally
                    next_state = S_GREEN;
                    next_clock = clock_reg - 8'd1;
                end
            end

            // ----------------------------------------------------------
            // YELLOW state: counts down from 5 to 1, ignores pass_request
            // Scenario: yellow_countdown, yellow_to_red,
            //           pedestrian_no_effect_yellow
            // ----------------------------------------------------------
            S_YELLOW: begin
                if (clock_reg == 8'd1) begin
                    // Countdown expired -> transition to red
                    next_state = S_RED;
                    next_clock = 8'd10;
                end else begin
                    // Continue counting down, pass_request has no effect
                    next_state = S_YELLOW;
                    next_clock = clock_reg - 8'd1;
                end
            end

            // ----------------------------------------------------------
            // Default case to avoid incomplete case / latch inference
            // ----------------------------------------------------------
            default: begin
                next_state = S_RED;
                next_clock = 8'd10;
            end
        endcase
    end

    // -------------------------------------------------------------------
    // Output assignments (registered state drives combinational decode)
    // Scenario: one_hot -- exactly one light active at a time
    // Scenario: clock_bounds / clock_bound_red / clock_bound_green /
    //           clock_bound_yellow -- clock always within valid range
    // -------------------------------------------------------------------
    assign red    = (state == S_RED);
    assign green  = (state == S_GREEN);
    assign yellow = (state == S_YELLOW);
    assign clock  = clock_reg;

endmodule