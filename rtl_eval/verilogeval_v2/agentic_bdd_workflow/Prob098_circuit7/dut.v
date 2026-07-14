// ============================================================================
// Module: TopModule
// Purpose: Single-Stage Inverting Flip-Flop
//
// On every rising edge of clk, the output q is updated to the logical NOT
// of the value of "a" that was sampled at the immediately preceding rising
// edge. This creates a fixed one-cycle inverting latency between "a" and
// "q". There is no reset signal for this design, so q is unconstrained
// until the first rising clock edge occurs (per @undefined_initial_state).
// ============================================================================

module TopModule (
    input  clk,
    input  a,
    output q
);

    // Registered output implementing the one-cycle inverting latency.
    // Covers scenarios:
    //   @core_behavior        - q = NOT(a) sampled one edge earlier
    //   @stable_input         - q stays at NOT(A) while a remains A
    //   @input_transition     - q reflects NOT of old value, then updates
    //   @toggling_input       - q tracks alternating input with fixed delay
    //   @undefined_initial_state - no reset, so q is 'x' until first edge
    reg q_reg;

    always @(posedge clk) begin
        // Capture inverted value of "a" as sampled at this rising edge;
        // this becomes the output value held until the next edge.
        q_reg <= ~a;
    end

    // Continuous assignment of registered value to output port
    assign q = q_reg;

endmodule