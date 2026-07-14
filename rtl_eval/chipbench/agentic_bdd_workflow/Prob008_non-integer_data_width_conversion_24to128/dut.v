//=============================================================================
// Module: TopModule
// Purpose: 24-bit to 128-bit Data Width Converter using a bit-level
//          accumulator with valid-only handshake on input and output.
//          Implements all scenarios described in the specification:
//            - reset behavior (@reset, @reset_counter)
//            - idle hold when valid_in=0 (@idle_hold, @data_in_ignored_when_invalid)
//            - counter invariant 0 <= N < 128 (@counter_invariant)
//            - single accumulation without word completion (@single_accumulation)
//            - word completion and valid_out assertion (@word_completion)
//            - correct MSB-first bit ordering (@ordering)
//            - single-cycle valid_out pulse (@valid_out_pulse)
//            - counter wrap to leftover bits (@counter_wrap)
//            - 16-cycle / 3-word repeating pattern (@continuous_streaming)
//            - no premature valid_out assertion (@no_partial_output)
//=============================================================================

module TopModule (
    input               clk,
    input               rst_n,
    input               valid_in,
    input  [23:0]       data_in,
    output              valid_out,
    output [127:0]      data_out
);

    // -------------------------------------------------------------------
    // Internal state
    // -------------------------------------------------------------------
    // acc : 151-bit bit accumulator, always kept "left-aligned" so that the
    //       N currently-valid bits occupy the MSB side (bit 150 downward),
    //       with all bits below the valid region held at zero.
    // N   : number of valid accumulator bits held prior to this clock edge
    //       (0 <= N < 128), per @counter_invariant.
    // -------------------------------------------------------------------
    reg  [150:0] acc;
    reg  [6:0]   N;          // 7 bits -> covers 0..127

    reg          valid_out_r;
    reg  [127:0] data_out_r;

    assign valid_out = valid_out_r;
    assign data_out  = data_out_r;

    // -------------------------------------------------------------------
    // Combinational helpers: compute the next accumulator state for the
    // case that valid_in is asserted this cycle.
    // -------------------------------------------------------------------
    // Place data_in immediately after the N previously-valid bits by
    // shifting it left so it lands right below the current valid region.
    wire [150:0] data_in_ext   = {127'b0, data_in};
    wire [7:0]   shift_amount  = 8'd127 - {1'b0, N}; // 127 - N (N < 128)
    wire [150:0] shifted_in    = data_in_ext << shift_amount;

    // Merge existing accumulator with newly-placed data_in bits.
    // (Preserves reception order: earlier bits stay toward MSB - @ordering)
    wire [150:0] new_concat    = acc | shifted_in;

    // Total number of valid bits after this appended word.
    wire [7:0]   total_valid   = {1'b0, N} + 8'd24;
    wire         word_complete = (total_valid >= 8'd128);

    // -------------------------------------------------------------------
    // Sequential logic
    // -------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // @reset / @reset_counter: force known idle state on reset
            acc         <= 151'd0;
            N           <= 7'd0;
            valid_out_r <= 1'b0;
            data_out_r  <= 128'd0;
        end
        else begin
            if (valid_in) begin
                if (!word_complete) begin
                    // @single_accumulation / @no_partial_output:
                    // Not enough bits yet -- just accumulate, no output.
                    acc         <= new_concat;
                    N           <= total_valid[6:0]; // N + 24, still < 128
                    valid_out_r <= 1'b0;
                    // data_out_r intentionally unchanged
                end
                else begin
                    // @word_completion / @ordering / @counter_wrap:
                    // Enough bits accumulated -- emit top 128 bits, retain
                    // the leftover low-order bits (re-aligned to MSB side)
                    // for the next accumulation round.
                    data_out_r  <= new_concat[150:23];        // topmost 128 bits
                    acc         <= {new_concat[22:0], 128'd0}; // leftover, re-aligned
                    N           <= total_valid[7:0] - 8'd128;  // N + 24 - 128
                    valid_out_r <= 1'b1;
                end
            end
            else begin
                // @idle_hold / @data_in_ignored_when_invalid:
                // No new data -- hold accumulator, counter, and data_out;
                // valid_out deasserts (also satisfies @valid_out_pulse,
                // ensuring valid_out is only a single-cycle pulse).
                valid_out_r <= 1'b0;
                // acc, N, data_out_r remain unchanged (no assignment)
            end
        end
    end

endmodule