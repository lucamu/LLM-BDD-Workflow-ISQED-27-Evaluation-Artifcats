// =============================================================================
// Purpose: Fast-to-Slow Clock Domain Pulse Synchronizer
//
// A single-cycle pulse on data_in (sampled in the clk_fast domain) is
// converted into a toggle signal, safely synchronized into the clk_slow
// domain using a multi-stage synchronizer, and then re-converted into a
// single-cycle pulse on clk_slow (data_out).
//
// This toggle-based CDC scheme guarantees:
//   - No pulse loss (toggle persists until sampled)
//   - No pulse duplication (edge detection produces exactly one pulse)
//   - Bounded latency (fixed synchronizer depth)
// =============================================================================
module TopModule (
    input  clk_fast,
    input  clk_slow,
    input  rst_n,
    input  data_in,
    output data_out
);

    // -------------------------------------------------------------------
    // Fast domain: toggle flip-flop
    // Scenario: @pulse_detect, @no_glitch, @multiple_pulses, @no_double_pulse
    // Every single-cycle pulse on data_in toggles the state, so each
    // pulse produces a distinct, well-defined edge on toggle_ff.
    // -------------------------------------------------------------------
    reg toggle_ff;

    always @(posedge clk_fast or negedge rst_n) begin
        if (!rst_n) begin
            // Scenario: reset forces known state, clears pending activity
            toggle_ff <= 1'b0;
        end else begin
            if (data_in) begin
                // Single-cycle pulse detected -> toggle the flag
                toggle_ff <= ~toggle_ff;
            end else begin
                toggle_ff <= toggle_ff;
            end
        end
    end

    // -------------------------------------------------------------------
    // Slow domain: 2-stage synchronizer for metastability protection
    // Scenario: @cdc_latency - bounded latency via fixed pipeline depth
    // -------------------------------------------------------------------
    reg sync_stage1;
    reg sync_stage2;
    reg sync_stage3; // extra stage used for edge detection

    always @(posedge clk_slow or negedge rst_n) begin
        if (!rst_n) begin
            // Scenario: reset clears synchronizer pipeline immediately
            sync_stage1 <= 1'b0;
            sync_stage2 <= 1'b0;
            sync_stage3 <= 1'b0;
        end else begin
            sync_stage1 <= toggle_ff;    // 1st synchronizer stage
            sync_stage2 <= sync_stage1;  // 2nd synchronizer stage
            sync_stage3 <= sync_stage2;  // delayed copy for edge detect
        end
    end

    // -------------------------------------------------------------------
    // Edge detection: produces a single-cycle pulse on clk_slow whenever
    // the synchronized toggle value changes.
    // Scenario: @pulse_width - pulse lasts exactly one clk_slow cycle
    // Scenario: @multiple_pulses - sequential toggles produce sequential
    //           single-cycle pulses in order
    // -------------------------------------------------------------------
    reg data_out_reg;

    always @(posedge clk_slow or negedge rst_n) begin
        if (!rst_n) begin
            // Scenario: reset forces data_out low regardless of edges
            data_out_reg <= 1'b0;
        end else begin
            data_out_reg <= sync_stage2 ^ sync_stage3;
        end
    end

    assign data_out = data_out_reg;

endmodule