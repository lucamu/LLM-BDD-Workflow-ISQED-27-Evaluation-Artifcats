// =============================================================================
// Module: TopModule
// Purpose: Overlapping "1011" sequence detector (Moore machine)
//          Detects the pattern "1011" in a serial input stream, including
//          overlapping occurrences, using KMP-style state transitions.
//
// States:
//   S0 - no partial match
//   S1 - matched prefix "1"
//   S2 - matched prefix "10"
//   S3 - matched prefix "101"
//   S4 - matched full pattern "1011" (detection state)
// =============================================================================

module TopModule (
    input  wire clk,
    input  wire rst,   // active-low reset
    input  wire data,
    output reg  flag
);

    // ---------------------------------------------------------------------
    // State encoding
    // ---------------------------------------------------------------------
    localparam [2:0] S0 = 3'd0,
                      S1 = 3'd1,
                      S2 = 3'd2,
                      S3 = 3'd3,
                      S4 = 3'd4;

    reg [2:0] seq_state;      // current state register
    reg [2:0] next_state;     // combinational next-state logic

    // ---------------------------------------------------------------------
    // Combinational next-state logic
    // Implements KMP-style overlap transitions for pattern "1011"
    // Scenarios: @transition (S0..S4 transitions), @overlap
    // ---------------------------------------------------------------------
    always @(*) begin
        case (seq_state)
            // Scenario: State S0 transitions correctly on any data value
            S0: next_state = data ? S1 : S0;

            // Scenario: State S1 transitions correctly on any data value
            S1: next_state = data ? S1 : S2;

            // Scenario: State S2 transitions correctly on any data value
            S2: next_state = data ? S3 : S0;

            // Scenario: State S3 detects pattern when data completes "1011"
            S3: next_state = data ? S4 : S2;

            // Scenario: State S4 continues detection with overlap logic
            S4: next_state = data ? S1 : S2;

            // Default: unreachable states fall back to S0 (no latches)
            default: next_state = S0;
        endcase
    end

    // ---------------------------------------------------------------------
    // Sequential state register with active-low synchronous reset
    // Scenario: Reset forces state to S0
    // Scenario: State register always holds one of the five valid states
    // ---------------------------------------------------------------------
    always @(posedge clk) begin
        if (!rst) begin
            seq_state <= S0;               // Reset scenario
        end else begin
            seq_state <= next_state;       // Normal operation
        end
    end

    // ---------------------------------------------------------------------
    // Registered Moore output "flag"
    // flag asserts for exactly one cycle when S3 + data=1 (pattern complete)
    // Scenario: Flag pulse only from S3 with D=1
    // Scenario: Flag is a pure function of previous state and data
    // Scenario: Flag remains 0 after reset deassertion with no valid history
    // ---------------------------------------------------------------------
    always @(posedge clk) begin
        if (!rst) begin
            flag <= 1'b0;                                   // Reset scenario
        end else begin
            flag <= (seq_state == S3) && (data == 1'b1);    // Pure function of prev state & data
        end
    end

endmodule