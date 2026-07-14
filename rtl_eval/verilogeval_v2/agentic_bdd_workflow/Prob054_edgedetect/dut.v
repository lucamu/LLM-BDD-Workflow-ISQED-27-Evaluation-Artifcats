// =============================================================================
// Module: TopModule
// Purpose: 8-bit Positive Edge Detector
//          Detects, per-bit, a 0-to-1 transition on the "in" vector between
//          consecutive clock cycles. The registered output "pedge" asserts
//          bit i one cycle after bit i of "in" transitions from 0 to 1.
// =============================================================================
module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] pedge
);

    // Register to hold the previous cycle's sample of "in"
    reg [7:0] in_prev;

    // Registered output for pedge (per-bit positive edge indicator)
    reg [7:0] pedge_reg;

    assign pedge = pedge_reg;

    // -------------------------------------------------------------------
    // Sequential logic: sample "in" each clock edge and compute pedge
    // based on the previous sample vs. the current sample.
    //
    // Scenario coverage:
    //   - edge_detection/core: bit transitions 0->1 => pedge bit = 1 next cycle
    //   - no_edge/stable_low:  bit stays 0 => pedge bit = 0
    //   - no_edge/stable_high: bit stays 1 => pedge bit = 0
    //   - no_edge/falling_edge: bit transitions 1->0 => pedge bit = 0
    //   - per_bit_independence: computed independently for all 8 bits
    //   - one_cycle_pulse: pedge is registered from in_prev/in each cycle,
    //     so a transition produces exactly one cycle of pulse.
    //   - no_combinational_leak: pedge depends on in_prev (previous cycle),
    //     not solely on current in, since in_prev is a registered copy.
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        // Compute pedge using previous cycle's sample (in_prev) and
        // current cycle's sample (in): bit asserted iff previous=0 and current=1
        pedge_reg <= (~in_prev) & in;

        // Update the previous-sample register for use in the next cycle
        in_prev <= in;
    end

endmodule