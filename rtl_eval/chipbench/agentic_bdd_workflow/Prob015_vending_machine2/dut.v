// =============================================================================
// Module: TopModule
// Purpose: Vending Machine Currency Acceptance and Beverage Dispensing
//
// Behavior Summary:
//   - d1 pulse (edge-detected) adds 0.5 yuan (1 unit) to accumulated money
//   - d2 pulse (edge-detected) adds 1.0 yuan (2 units) to accumulated money
//   - sel=0 selects beverage1 (price 1.5 yuan = 3 units) -> out1
//   - sel=1 selects beverage2 (price 2.5 yuan = 5 units) -> out2
//   - When accumulated money reaches or exceeds the selected price, the
//     beverage is dispensed on the same clock edge that the threshold is
//     reached, and any overpaid amount is returned as 0.5 yuan coins
//     (out3) on subsequent clock edge(s).
//   - rst is active-low synchronous reset that clears all state/outputs.
//
// Internal money/price/change values are tracked in units of 0.5 yuan to
// keep arithmetic integer-only:
//   d1  -> 1 unit
//   d2  -> 2 units
//   beverage1 price -> 3 units (1.5 yuan)
//   beverage2 price -> 5 units (2.5 yuan)
//   change coin      -> 1 unit (0.5 yuan)
// =============================================================================

module TopModule (
    input  wire clk,
    input  wire rst,   // active-low synchronous reset
    input  wire d1,
    input  wire d2,
    input  wire sel,
    output reg  out1,
    output reg  out2,
    output reg  out3
);

    // -------------------------------------------------------------------
    // Internal state
    // -------------------------------------------------------------------
    reg [3:0] money;           // accumulated money, in 0.5-yuan units
    reg [3:0] pending_change;  // remaining 0.5-yuan coins owed as change

    reg d1_prev, d2_prev;      // previous-cycle values for edge detection

    // FSM states
    localparam S_IDLE   = 2'b00; // accumulating money, waiting for threshold
    localparam S_CHANGE = 2'b01; // returning overpaid change coins

    reg [1:0] state;

    // Combinational helpers (computed each cycle, used for same-edge decisions)
    reg        pulse1, pulse2;
    reg [3:0]  new_money;
    reg [3:0]  price;

    // -------------------------------------------------------------------
    // Combinational computation of edge pulses, new money total, and price
    // -------------------------------------------------------------------
    always @(*) begin
        // Edge detection: single-cycle pulse on 0->1 transition
        // (Scenario: d1/d2 held high produces only a single pulse per edge)
        pulse1 = d1 & ~d1_prev;
        pulse2 = d2 & ~d2_prev;

        // Selected beverage price (Scenario: sel_dependence)
        price = sel ? 4'd5 : 4'd3;

        // Money after applying this cycle's currency pulses
        new_money = money + pulse1 + (pulse2 << 1);
    end

    // -------------------------------------------------------------------
    // Sequential logic: main FSM, money accumulation, dispensing, change
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (!rst) begin
            // Scenario: Reset forces all outputs low and clears money
            // Scenario: Reset overrides any pending currency or selection inputs
            out1           <= 1'b0;
            out2           <= 1'b0;
            out3           <= 1'b0;
            money          <= 4'd0;
            pending_change <= 4'd0;
            state          <= S_IDLE;
            d1_prev        <= 1'b0;
            d2_prev        <= 1'b0;
        end else begin
            // Update edge-detection registers every cycle
            d1_prev <= d1;
            d2_prev <= d2;

            case (state)
                // -------------------------------------------------------
                // S_IDLE: accumulate money; dispense beverage when the
                // selected price is reached or exceeded (same edge).
                // -------------------------------------------------------
                S_IDLE: begin
                    if (new_money >= price) begin
                        // Scenario: dispense_beverage1 / dispense_beverage2
                        // Scenario: mutual_exclusion (only one of out1/out2 asserted)
                        out1 <= (sel == 1'b0);
                        out2 <= (sel == 1'b1);
                        out3 <= 1'b0; // Scenario: no_change (no change on dispense edge)

                        money          <= 4'd0;
                        pending_change <= new_money - price;

                        // Scenario: change_dispense - overpayment returns
                        // change on a following clock edge, not this one.
                        if (new_money > price)
                            state <= S_CHANGE;
                        else
                            state <= S_IDLE;
                    end else begin
                        // Scenario: accumulation - money equals sum of pulses
                        // Scenario: insufficient_funds - no dispensing yet
                        money <= new_money;
                        out1  <= 1'b0;
                        out2  <= 1'b0;
                        out3  <= 1'b0;
                        state <= S_IDLE;
                    end
                end

                // -------------------------------------------------------
                // S_CHANGE: return one 0.5-yuan coin per cycle until the
                // overpaid amount has been fully refunded.
                // -------------------------------------------------------
                S_CHANGE: begin
                    out1 <= 1'b0;
                    out2 <= 1'b0;

                    if (pending_change > 4'd0) begin
                        // Scenario: change_dispense - out3 asserted on
                        // the edge following dispensing
                        out3           <= 1'b1;
                        pending_change <= pending_change - 4'd1;
                        if (pending_change == 4'd1)
                            state <= S_IDLE;
                        else
                            state <= S_CHANGE;
                    end else begin
                        out3  <= 1'b0;
                        state <= S_IDLE;
                    end
                end

                // -------------------------------------------------------
                // Default: safe fallback, avoids inferred latches
                // -------------------------------------------------------
                default: begin
                    out1           <= 1'b0;
                    out2           <= 1'b0;
                    out3           <= 1'b0;
                    money          <= 4'd0;
                    pending_change <= 4'd0;
                    state          <= S_IDLE;
                end
            endcase
        end
    end

endmodule