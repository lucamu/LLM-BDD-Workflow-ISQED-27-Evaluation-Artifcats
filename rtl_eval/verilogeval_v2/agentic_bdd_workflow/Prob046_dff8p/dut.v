// =============================================================================
// Module: TopModule
// Purpose: 8-bit DFF bank, negative-edge triggered, synchronous active-high
//          reset to 0x34. When reset is deasserted, q samples d on negedge.
//          q is stable (unchanged) on posedge of clk.
// =============================================================================
module TopModule (
    input        clk,
    input  [7:0] d,
    input        reset,
    output [7:0] q
);

    reg [7:0] q_reg;

    // All flip-flops triggered on negedge of clk.
    // @reset/@priority: reset (active-high) forces q to 8'h34, takes priority over d
    // @data_capture: when reset=0, q <= d on negedge
    // @reset_sequence/@reset_release: reset value persists while asserted,
    //   and q follows d again once reset is deasserted on the next negedge
    // @no_change/@posedge: since always block is sensitive only to negedge clk,
    //   q_reg (and thus q) does not change on the positive edge of clk
    always @(negedge clk) begin
        if (reset)
            q_reg <= 8'h34;   // Synchronous reset to 0x34, priority over d
        else
            q_reg <= d;       // Normal operation: load d into q
    end

    // @width: q is always exactly 8 bits, bounded within 0 to 255
    assign q = q_reg;

endmodule