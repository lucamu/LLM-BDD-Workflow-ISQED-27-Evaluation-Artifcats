// =============================================================================
// Module: TopModule
// Purpose: 16x16 Toroidal Conway's Game of Life
//   - Synchronous load of a 256-bit grid (row r in bits [16r+15:16r])
//   - When load=0, evolves the grid one generation per clock edge using
//     Conway's rules with toroidal (wraparound) neighbor connectivity.
// =============================================================================

module TopModule (
    input               clk,
    input               load,
    input      [255:0]  data,
    output reg [255:0]  q
);

    // -------------------------------------------------------------------
    // Internal signals
    // -------------------------------------------------------------------
    reg [255:0] next_q;   // combinationally computed next state

    integer r, c;
    integer north, south, west, east_;
    integer neighbor_sum;

    // -------------------------------------------------------------------
    // Combinational: compute next generation according to Game of Life
    // rules with toroidal wraparound (Scenarios: @hold, @underpopulation,
    // @survival, @reproduction, @overpopulation, @toroid corner/edge,
    // @stability, @determinism)
    // -------------------------------------------------------------------
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                // Toroidal neighbor row/column indices
                north  = (r + 15) % 16; // (r - 1) mod 16
                south  = (r + 1)  % 16;
                west   = (c + 15) % 16; // (c - 1) mod 16
                east_  = (c + 1)  % 16;

                // Sum the 8 toroidal neighbors of cell (r, c)
                neighbor_sum = q[16*north + west]  +
                               q[16*north + c]     +
                               q[16*north + east_] +
                               q[16*r     + west]  +
                               q[16*r     + east_] +
                               q[16*south + west]  +
                               q[16*south + c]     +
                               q[16*south + east_];

                // Apply Conway's Game of Life rules
                if (neighbor_sum == 3) begin
                    // Reproduction: dead or alive cell becomes/stays alive
                    next_q[16*r + c] = 1'b1;
                end else if (neighbor_sum == 2) begin
                    // Survival: state unchanged
                    next_q[16*r + c] = q[16*r + c];
                end else begin
                    // Underpopulation (N<2) or Overpopulation (N>3): dies
                    next_q[16*r + c] = 1'b0;
                end
            end
        end
    end

    // -------------------------------------------------------------------
    // Sequential: register update on positive clock edge
    // Scenario: @load - load overrides current state, has priority over
    // game evolution and does not depend on S.
    // Scenario: @hold/@no-load - evolve per next_q when load is inactive.
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (load) begin
            // Load has top priority: q <= data regardless of current state
            q <= data;
        end else begin
            // No load: evolve grid according to computed next generation
            q <= next_q;
        end
    end

endmodule