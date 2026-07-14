// ============================================================================
// Module: TopModule
// Purpose: 8-bit register implemented with D flip-flops having an
//          asynchronous, active-high reset. On assertion of areset, the
//          output q is immediately forced to 0 regardless of clk. When
//          areset is low, q captures d on every rising edge of clk and
//          holds its value otherwise.
// ============================================================================
module TopModule (
    input        clk,
    input  [7:0] d,
    input        areset,
    output [7:0] q
);

    // Registered output driven by 8 D flip-flops
    reg [7:0] q_reg;

    // Sequential logic: async active-high reset, else capture d on posedge clk
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // @reset / @reset_priority: async reset forces q to 0 immediately,
            // takes priority over d even on a simultaneous clock edge, and
            // (@reset_deassertion) q stays 0 until the next rising clk edge
            // after areset is deasserted.
            q_reg <= 8'b00000000;
        end else begin
            // @normal_operation / @post_reset_capture / @bitwise_independence:
            // On rising clk edge with areset low, q captures d bit-for-bit.
            // @hold: without a clk edge, this block does not execute, so
            // q_reg retains its previous value.
            q_reg <= d;
        end
    end

    // Continuous assignment of registered value to output port
    assign q = q_reg;

endmodule