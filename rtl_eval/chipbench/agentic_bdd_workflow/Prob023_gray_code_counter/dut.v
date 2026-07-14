// =============================================================================
// Module: TopModule
// Purpose: 4-bit Gray Code Counter with Divide-by-2 Clocking
//          Increments the Gray-coded output every two clock cycles,
//          maintains a valid Gray code sequence, and supports an
//          asynchronous active-low reset.
// =============================================================================
module TopModule (
    input  wire       clk,
    input  wire       rst_n,
    output reg  [3:0] gray_out
);

    // -------------------------------------------------------------------
    // Internal state:
    //   phase    - toggles each clk cycle to implement divide-by-2 timing
    //   bin_cnt  - internal binary count B, incremented once per two clk
    //              cycles (one full Gray "hold period")
    // -------------------------------------------------------------------
    reg       phase;
    reg [3:0] bin_cnt;

    // -------------------------------------------------------------------
    // Function: gray_encode
    // Converts a binary value X into its Gray code equivalent:
    //   gray_encode(X) = X XOR (X >> 1)
    // Used by scenario @encoding @binary-increment
    // -------------------------------------------------------------------
    function [3:0] gray_encode;
        input [3:0] x;
        begin
            gray_encode = x ^ (x >> 1);
        end
    endfunction

    // -------------------------------------------------------------------
    // Sequential logic: single always block, asynchronous active-low reset
    // -------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Scenario: Asynchronous reset forces gray_out to zero immediately
            // Scenario: Reset takes priority over normal counting behavior
            phase    <= 1'b0;
            bin_cnt  <= 4'b0000;
            gray_out <= 4'b0000;
        end else begin
            if (phase == 1'b1) begin
                // Second cycle of the current hold period:
                // this is the edge on which the Gray output is allowed
                // to change (Scenario: @stability @half-rate,
                // @gray-property @single-bit-change,
                // @encoding @binary-increment)
                bin_cnt  <= bin_cnt + 4'b0001;
                gray_out <= gray_encode(bin_cnt + 4'b0001);
                phase    <= 1'b0;
            end else begin
                // First cycle of the hold period:
                // gray_out and bin_cnt remain unchanged, only phase toggles
                // (Scenario: @stability @half-rate -- value held for
                // two consecutive clk cycles)
                phase <= 1'b1;
            end
        end
    end

    // -------------------------------------------------------------------
    // Notes on remaining scenarios (verified by construction above):
    //   @sync-release: After reset release, first posedge occurs with
    //     phase=0 -> gray_out stays 0000; only after the *second* posedge
    //     (phase=1) does bin_cnt increment to 1 and gray_out becomes 0001.
    //     Thus gray_out is 0000 or 0001 after the first post-reset edge,
    //     both valid successors of 0000 in the Gray sequence.
    //   @wraparound @full-cycle: bin_cnt cycles 0..15 then wraps to 0
    //     (4'b + 4'b0001 wraps naturally), gray_encode produces the
    //     standard reflected binary Gray code sequence, returning to
    //     4'b0000 after 16 hold periods (32 clk edges).
    //   @no-glitch @combinational-stability: since gray_out only updates
    //     via gray_encode(bin_cnt+1) which differs from gray_encode(bin_cnt)
    //     by exactly one bit (property of Gray encoding of consecutive
    //     integers), no multi-bit glitches occur.
    // -------------------------------------------------------------------

endmodule