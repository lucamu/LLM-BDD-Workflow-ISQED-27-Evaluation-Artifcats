// =============================================================
// Module: TopModule
// Purpose: 512-cell Rule 90 One-Dimensional Cellular Automaton
//          register with synchronous load capability.
//
//          On each positive clock edge:
//            - If load = 1, q <= data (load scenario, load-priority)
//            - Else, q evolves per Rule 90:
//                q[i] <= left_neighbor(i) XOR right_neighbor(i)
//              where left_neighbor(0)  = 0 (boundary-left)
//                    right_neighbor(511) = 0 (boundary-right)
//                    otherwise left_neighbor(i)  = q[i-1]
//                              right_neighbor(i) = q[i+1]
//          This satisfies interior, boundary, full-vector,
//          two-step, and all-zero stability scenarios.
// =============================================================

module TopModule (
    input               clk,
    input               load,
    input      [511:0]  data,
    output reg [511:0]  q
);

    // Combinational next-state computation for Rule 90 evolution
    wire [511:0] left_neighbor;
    wire [511:0] right_neighbor;
    wire [511:0] next_evolved;

    // Left neighbor: shift q right by 1, insert 0 at boundary (bit 0)
    // left_neighbor[i] = q[i-1] for i>0, left_neighbor[0] = 0
    assign left_neighbor  = {q[510:0], 1'b0};

    // Right neighbor: shift q left by 1, insert 0 at boundary (bit 511)
    // right_neighbor[i] = q[i+1] for i<511, right_neighbor[511] = 0
    assign right_neighbor = {1'b0, q[511:1]};

    // Rule 90: XOR of left and right neighbors
    assign next_evolved = left_neighbor ^ right_neighbor;

    // -----------------------------------------------------------
    // Sequential update block
    // -----------------------------------------------------------
    always @(posedge clk) begin
        if (load) begin
            // @load @reset / @load-priority scenarios:
            // load overrides state, no dependency on previous q
            q <= data;
        end else begin
            // @evolution scenarios (interior, boundary-left,
            // boundary-right, full-vector, two-step, all-zero)
            q <= next_evolved;
        end
    end

endmodule