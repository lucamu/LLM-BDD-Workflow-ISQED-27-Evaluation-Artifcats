// =============================================================================
// Module: TopModule
// Purpose: Synchronous down-counter timer with terminal count (tc) output.
//          Loads a 10-bit duration on 'load', then counts down to zero on
//          each clock edge when not loading. Holds at zero once reached.
//          tc is combinationally derived from the counter register.
// Note: No explicit reset signal exists per specification.
// =============================================================================
module TopModule (
    input             clk,
    input             load,
    input      [9:0]  data,
    output            tc
);

    // Internal 10-bit counter register holding current countdown value
    reg [9:0] counter;

    // -------------------------------------------------------------------
    // Sequential logic: counter update
    // Scenarios covered:
    //   - Loading the counter captures the input data value (@load @basic)
    //   - Counter decrements by one when not loading and not at zero
    //     (@decrement @basic)
    //   - Counter holds at zero once terminal count is reached
    //     (@terminal_count @hold)
    //   - Loading overrides counting even while counter has not reached
    //     zero (@load @priority)
    //   - Loading a zero duration asserts terminal count immediately on
    //     next cycle (@load @edge_case)
    //   - Counter never decrements below zero when not reloaded
    //     (@load @no_underflow)
    //   - Multi-cycle inductive invariant scenarios
    //     (@sequence @multi_cycle @invariant, @load @zero_data @multi_cycle)
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (load) begin
            // Loading overrides counting regardless of current counter value
            counter <= data;
        end else if (counter != 10'd0) begin
            // Decrement by one when not loading and counter is not zero
            counter <= counter - 10'd1;
        end else begin
            // Hold at zero once terminal count is reached (no underflow)
            counter <= 10'd0;
        end
    end

    // -------------------------------------------------------------------
    // Combinational logic: terminal count output
    // Scenario covered:
    //   - Terminal count output is a direct function of the counter state
    //     (@combinational @tc)
    // tc is asserted whenever the counter register equals 0
    // -------------------------------------------------------------------
    assign tc = (counter == 10'd0);

endmodule