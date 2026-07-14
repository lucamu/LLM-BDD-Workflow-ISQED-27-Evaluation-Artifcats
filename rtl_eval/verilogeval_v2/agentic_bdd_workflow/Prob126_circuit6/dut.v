//=============================================================================
// Module: TopModule
// Purpose: Combinational lookup table mapping 3-bit input "a" to a fixed
//          16-bit output "q". Pure combinational logic, no clock/reset.
//=============================================================================
module TopModule (
    input  [2:0]  a,
    output reg [15:0] q
);

    // Combinational LUT: q depends only on current value of a
    // (Scenarios: @lut @a0..@a7, @combinational @stability, @no_memory)
    always @(*) begin
        case (a)
            3'b000: q = 16'h1232; // Scenario: Output for input value 0
            3'b001: q = 16'haee0; // Scenario: Output for input value 1
            3'b010: q = 16'h27d4; // Scenario: Output for input value 2
            3'b011: q = 16'h5a0e; // Scenario: Output for input value 3
            3'b100: q = 16'h2066; // Scenario: Output for input value 4
            3'b101: q = 16'h64ce; // Scenario: Output for input value 5
            3'b110: q = 16'hc526; // Scenario: Output for input value 6
            3'b111: q = 16'h2f19; // Scenario: Output for input value 7
            default: q = 16'h0000; // Unreachable, avoids latch inference
        endcase
    end

endmodule