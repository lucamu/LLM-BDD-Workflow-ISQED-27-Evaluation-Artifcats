//------------------------------------------------------------------------
// Module: TopModule
// Purpose: Positive-edge-triggered D flip-flop with asynchronous reset.
//          Implements all formal scenarios:
//            - Async reset forces q=0 regardless of clk (reset/async)
//            - q stays 0 while ar remains asserted across edges
//            - ar takes priority over d capture on simultaneous edge
//            - d is captured into q on rising clk edge when ar=0
//            - q holds value when no rising edge occurs
//            - q does not change on falling clk edge
//            - Normal capture resumes after ar deasserts
//            - d changes between edges do not affect q until next edge
//            - ar assertion immediately overrides q, independent of clk
//------------------------------------------------------------------------
module TopModule (
    input  wire clk,
    input  wire d,
    input  wire ar,
    output reg  q
);

    // Sequential logic: async reset has priority over clocked capture
    always @(posedge clk or posedge ar) begin
        if (ar) begin
            // Scenario: Asynchronous reset forces output low regardless of clock
            // Scenario: Output remains reset while ar stays asserted across clock edges
            // Scenario: Asynchronous reset takes priority over data capture at clock edge
            // Scenario: Reset assertion at any time immediately overrides current output
            q <= 1'b0;
        end
        else begin
            // Scenario: Data is captured on rising clock edge when reset is inactive
            // Scenario: Normal operation resumes after reset is released
            // Scenario: Output holds its value when no clock edge occurs (implicit - no other trigger)
            // Scenario: Output does not change on falling clock edge (not in sensitivity list)
            // Scenario: Changes in d between clock edges do not affect q until next edge
            q <= d;
        end
    end

endmodule