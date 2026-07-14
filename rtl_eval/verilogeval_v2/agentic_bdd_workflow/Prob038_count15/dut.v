//------------------------------------------------------------------------
// Module: TopModule
// Purpose: 4-bit binary counter with synchronous active-high reset.
//          Counts 0 -> 15 and wraps back to 0. Registered output q.
//------------------------------------------------------------------------
module TopModule (
    input        clk,
    input        reset,
    output [3:0] q
);

    // Internal register holding the current count value
    reg [3:0] q_reg;

    // Sequential logic: synchronous reset and increment
    always @(posedge clk) begin
        if (reset) begin
            // Scenario: Synchronous reset forces counter to zero
            // Scenario: Reset takes priority over counting
            q_reg <= 4'b0000;
        end
        else begin
            // Scenario: Counter increments by one when not at maximum
            // Scenario: Counter wraps to zero after reaching maximum value
            // Scenario: Counter next value is current value plus one modulo sixteen
            // (natural 4-bit wraparound handles both increment and mod-16 wrap)
            q_reg <= q_reg + 4'b0001;
        end
    end

    // Scenario: Counter does not change without a clock edge
    // (register only updates on posedge clk, guaranteed by always @(posedge clk))

    // Scenario: Counter value always remains within valid 4-bit range
    // (4-bit register inherently bounded 0 to 15)

    // Scenario: Counter returns to same value after sixteen clock edges
    // (natural consequence of modulo-16 counting behavior)

    // Drive output from register
    assign q = q_reg;

endmodule