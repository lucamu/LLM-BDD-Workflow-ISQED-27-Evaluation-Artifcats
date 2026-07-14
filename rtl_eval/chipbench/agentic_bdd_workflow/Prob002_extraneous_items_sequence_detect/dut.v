// ============================================================================
// Module: TopModule
// Purpose: Sequence Detector for pattern "011XXX110" over a 9-bit serial
//          shift register. Bit position 0 is the newest sampled bit, bit
//          position 8 is the oldest of the last nine sampled bits.
//          match = (shiftreg[8:6] == 3'b011) && (shiftreg[2:0] == 3'b110)
//          shiftreg[5:3] are don't-care middle bits.
// ============================================================================
module TopModule (
    input  clk,
    input  rst_n,
    input  a,
    output match
);

    // 9-bit shift register holding the last nine sampled values of 'a'.
    // Newest bit enters position 0, oldest resides at position 8.
    reg [8:0] shiftreg;

    // Registered match output, recomputed every cycle from shiftreg.
    reg match_reg;

    // ------------------------------------------------------------------
    // Sequential shift register with synchronous active-low reset.
    // @reset, @reset_release: rst_n low forces shiftreg to all zeros,
    // which (since 000XXX000 != 011XXX110) also forces match to 0.
    // ------------------------------------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            // Scenario @reset: synchronous reset clears shift register
            shiftreg <= 9'b0;
        end else begin
            // Shift in new bit 'a' at position 0; old bits move up.
            // Scenarios @pattern_match_full, @no_match_prefix,
            // @no_match_suffix, @no_match_both_wrong, @overlap_detection
            // all rely on this shifting behavior across successive cycles.
            shiftreg <= {shiftreg[7:0], a};
        end
    end

    // ------------------------------------------------------------------
    // Registered match computation based on current shiftreg value.
    // Scenario @general_combinational_property: match is a pure function
    // of bits 8:6 and 2:0, with bits 5:3 unconstrained (don't care).
    // Scenario @continuous_no_latching: match is recomputed every cycle,
    // deasserting once the matching window shifts out.
    // ------------------------------------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            // Scenario @reset: match forced low on reset
            match_reg <= 1'b0;
        end else begin
            // Compute match from the updated shift register value
            // (post-shift value on this same edge captured via shiftreg
            // combinational read of next state is avoided; instead we
            // compute from the shift register value that will be formed
            // this cycle by evaluating the same shift expression).
            if ( ({shiftreg[7:0], a}[8:6] == 3'b011) &&
                 ({shiftreg[7:0], a}[2:0] == 3'b110) ) begin
                match_reg <= 1'b1; // Prefix 011 and suffix 110 matched
            end else begin
                match_reg <= 1'b0; // No match: prefix and/or suffix wrong
            end
        end
    end

    assign match = match_reg;

endmodule