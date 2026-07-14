// ============================================================================
// Module:      TopModule
// Purpose:     8-bit D Flip-Flop Register
//              Implements 8 positive-edge-triggered D flip-flops so that
//              output q reflects input d delayed by one clock cycle.
//
// Scenarios implemented:
//  - Output follows input after one clock edge
//  - Output remains stable when input does not change
//  - Each output bit depends only on the corresponding input bit
//  - Output does not change combinationally with input (no passthrough)
//  - Output updates correctly across two consecutive clock cycles
//  - Output does not update on negative clock edge
//  - Output width matches input width (8 bits)
// ============================================================================

module TopModule (
    input        clk,
    input  [7:0] d,
    output [7:0] q
);

    // Registered output storage element (8 D flip-flops, one per bit)
    reg [7:0] q_reg;

    // Sequential logic: only updates on positive edge of clk
    // (@negedge_no_update, @no_combinational_passthrough satisfied since
    //  q_reg only changes inside this posedge-triggered block)
    always @(posedge clk) begin
        // @basic: output follows input after one clock edge
        // @stability: if d == current q, q remains same value
        // @bitwise_independence: each bit of q_reg follows corresponding bit of d
        // @sequential_update: successive clock edges capture successive d values
        q_reg <= d;
    end

    // Continuous assignment of registered value to output port
    // @width_consistency: q is 8 bits wide, matching d
    assign q = q_reg;

endmodule