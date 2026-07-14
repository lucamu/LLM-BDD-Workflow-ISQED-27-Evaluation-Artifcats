// ============================================================================
// Module: TopModule
// Purpose: Any-Edge Detector for 8-bit Input Vector
//
// For each bit i of "in", the corresponding bit of "anyedge" is asserted
// exactly one clock cycle after a 0->1 or 1->0 transition occurs on that
// bit. This is implemented by registering the previous sample of "in" and
// XOR-ing it with the current sample, then registering that XOR result so
// it appears one cycle after the transition (per spec: "in the following
// cycle").
// ============================================================================
module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] anyedge
);

    // Registered copy of "in" from the previous clock cycle
    reg [7:0] in_prev;

    // Registered output vector (anyedge)
    reg [7:0] anyedge_reg;

    // Sequential logic: sample "in" and compute edge detection
    always @(posedge clk) begin
        // @xor_relation / @full_vector / @multi_bit_toggle / @no_false_positive:
        // anyedge is the bitwise XOR of the previous and current samples of "in",
        // registered so the result appears one cycle after the transition.
        anyedge_reg <= in_prev ^ in;

        // Update the previous-sample register for the next comparison
        // (@rising, @falling, @stable, @per_bit_independence rely on this
        // holding the prior value of each bit of "in")
        in_prev <= in;
    end

    // Drive the output port from the registered value
    assign anyedge = anyedge_reg;

endmodule