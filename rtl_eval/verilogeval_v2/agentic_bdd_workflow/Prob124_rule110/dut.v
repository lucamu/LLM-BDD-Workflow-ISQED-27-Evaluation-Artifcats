// =============================================================================
// Module: TopModule
// Purpose: Implements a 512-cell Rule 110 Cellular Automaton register.
//          On each rising clk edge:
//            - if load is asserted, q is synchronously loaded with data
//            - otherwise, q evolves one step according to Rule 110,
//              with virtual left neighbor of cell 511 and virtual right
//              neighbor of cell 0 treated as constant zero.
// =============================================================================
module TopModule (
    input         clk,
    input         load,
    input  [511:0] data,
    output [511:0] q
);

    // Registered state
    reg [511:0] q_reg;
    assign q = q_reg;

    // Combinational next-state (Rule 110) computation
    // Extend q_reg with virtual zero neighbors on both sides:
    //   left_ext[511] (virtual left of cell 511)  = 0
    //   right_ext[-1] (virtual right of cell 0)   = 0
    wire [513:0] q_ext;
    assign q_ext = {1'b0, q_reg, 1'b0}; // bit513=virtual left(0), bits[512:1]=q_reg, bit0=virtual right(0)

    reg [511:0] next_state;
    integer i;

    always @* begin
        // Default assignment to avoid latches
        next_state = 512'b0;
        for (i = 0; i < 512; i = i + 1) begin
            // Map cell index i to extended vector position (i+1)
            // LEFT  = neighbor at i+1 (higher index), RIGHT = neighbor at i-1 (lower index)
            // For i=511 (leftmost cell), LEFT is virtual 0 (q_ext[513])
            // For i=0   (rightmost cell), RIGHT is virtual 0 (q_ext[0])
            next_state[i] = (q_ext[i+1] || q_ext[i]) && !(q_ext[i+2] && q_ext[i+1] && q_ext[i]);
        end
    end

    // Sequential update: load has priority over Rule 110 evolution
    always @(posedge clk) begin
        if (load) begin
            // Scenario: Synchronous load overrides current state with data
            // Scenario: Load has priority over Rule 110 update
            q_reg <= data;
        end else begin
            // Scenario: Rule 110 update for interior cells, boundaries,
            // truth table cases, fixed-point, and locality (neighborhood-only dependence)
            q_reg <= next_state;
        end
    end

endmodule