//=============================================================================
// Module: TopModule
// Purpose: Reservoir Water Level Flow Controller
//
// Controls three "Nominal" flow valves (fr0, fr1, fr2) based purely on the
// thermometer-coded water-level sensor s, and one "Supplemental" flow valve
// (dfr) based on both the current sensor reading and the direction (rising
// or falling) of the most recent level change.
//
// Sensor codes (thermometer coded, monotonic in binary value):
//   3'b000 -> water below lowest sensor
//   3'b001 -> water between s0 and s1
//   3'b011 -> water between s1 and s2
//   3'b111 -> water above top sensor
//=============================================================================
module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    //-------------------------------------------------------------------
    // Registered outputs
    //-------------------------------------------------------------------
    reg fr2_r, fr1_r, fr0_r, dfr_r;

    assign fr2 = fr2_r;
    assign fr1 = fr1_r;
    assign fr0 = fr0_r;
    assign dfr = dfr_r;

    //-------------------------------------------------------------------
    // Internal state:
    //   prev_s   - sensor value sampled on the previous rising edge
    //   dir_reg  - direction of last observed level change
    //              (1 = rising, 0 = falling)
    //-------------------------------------------------------------------
    reg [2:0] prev_s;
    reg       dir_reg;

    // Combinational next-direction computation.
    // Sensor codes 000,001,011,111 map to increasing binary values,
    // so a simple magnitude comparison correctly captures the
    // "rising"/"falling" relationship between consecutive samples.
    reg dir_next;
    always @(*) begin
        if (s > prev_s)
            dir_next = 1'b1;   // level increased -> rising
        else if (s < prev_s)
            dir_next = 1'b0;   // level decreased -> falling
        else
            dir_next = dir_reg; // no change -> keep previous direction
    end

    //-------------------------------------------------------------------
    // Sequential logic: synchronous reset, registered outputs
    //-------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset) begin
            // @reset / @reset_priority: force low-water (max flow) state
            fr2_r   <= 1'b1;
            fr1_r   <= 1'b1;
            fr0_r   <= 1'b1;
            dfr_r   <= 1'b1;
            prev_s  <= 3'b000;
            dir_reg <= 1'b1; // arbitrary; forced conditions dominate at s=000/111
        end else begin
            //-----------------------------------------------------------
            // Nominal flow bits (fr2, fr1, fr0):
            // depend only on the current sensor code, not on direction.
            // @fr_bits_depend_only_on_current_level
            // @sensor_above_top, @sensor_below_bottom,
            // @sensor_mid_high_nominal, @sensor_mid_low_nominal
            //-----------------------------------------------------------
            fr2_r <= (s == 3'b000);
            fr1_r <= (s == 3'b000) || (s == 3'b001);
            fr0_r <= (s != 3'b111);

            //-----------------------------------------------------------
            // Supplemental flow bit (dfr):
            //   - forced to 1 at the bottom sensor (max flow)
            //     @sensor_below_bottom, @falling_reaches_bottom_forces_supplemental
            //   - forced to 0 at the top sensor (no flow)
            //     @sensor_above_top, @rising_reaches_top_closes_supplemental
            //   - otherwise follows the direction of the last level change
            //     @rising_transition_supplemental_open
            //     @rising_continue_supplemental_hold
            //     @falling_from_top_no_supplemental
            //     @falling_continue_no_supplemental
            //     @direction_reversal_reopens_supplemental
            //-----------------------------------------------------------
            if (s == 3'b000)
                dfr_r <= 1'b1;
            else if (s == 3'b111)
                dfr_r <= 1'b0;
            else
                dfr_r <= dir_next;

            //-----------------------------------------------------------
            // Update direction history and previous sensor sample
            // @stable_input_holds_output relies on dir_reg/prev_s holding
            //-----------------------------------------------------------
            dir_reg <= dir_next;
            prev_s  <= s;
        end
    end

endmodule