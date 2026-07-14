// =============================================================================
// Module: TopModule
// Purpose: 100-bit rotator register with synchronous load and bidirectional
//          rotate enable.
//
//   - load=1        : q <= data (synchronous load, overrides rotation)
//   - load=0,ena=01  : q <= rotate_right(q)  (bit0 -> bit99, others shift down)
//   - load=0,ena=10  : q <= rotate_left(q)   (bit99 -> bit0, others shift up)
//   - load=0,ena=00  : q <= q (hold, no rotation)
//   - load=0,ena=11  : q <= q (hold, no rotation)
//
// No asynchronous/synchronous reset port exists in the required interface,
// so only clk-driven sequential logic is implemented as specified.
// =============================================================================
module TopModule (
    input               clk,
    input               load,
    input        [1:0]  ena,
    input        [99:0] data,
    output       [99:0] q
);

    // Internal register holding current state
    reg [99:0] q_reg;

    // Combinational next-state computations for rotation
    wire [99:0] rot_right = {q_reg[0], q_reg[99:1]};   // Scenario: @rotate-right
    wire [99:0] rot_left  = {q_reg[98:0], q_reg[99]};  // Scenario: @rotate-left

    // Sequential update: load has top priority, then rotate right/left, else hold
    always @(posedge clk) begin
        if (load) begin
            // Scenario: @load @priority, @load-and-rotate-right, @load-and-rotate-left
            // Load overrides rotation regardless of ena value
            q_reg <= data;
        end
        else begin
            case (ena)
                2'b01: begin
                    // Scenario: @rotate-right - rotate right by one bit
                    q_reg <= rot_right;
                end
                2'b10: begin
                    // Scenario: @rotate-left - rotate left by one bit
                    q_reg <= rot_left;
                end
                default: begin
                    // Scenario: @no-rotate - ena = 2'b00 or 2'b11, hold value
                    q_reg <= q_reg;
                end
            endcase
        end
    end

    // Output assignment
    assign q = q_reg;

endmodule