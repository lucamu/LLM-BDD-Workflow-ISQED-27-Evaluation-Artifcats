// =============================================================================
// Module: TopModule
// Purpose: Serial Data Accumulation Circuit with Valid-Ready Handshake
//
// Accepts four consecutive 8-bit values via a valid/ready handshake on the
// input side (data_in/valid_a/ready_a) and produces their 10-bit sum via a
// valid/ready handshake on the output side (data_out/valid_b/ready_b).
// Supports back-pressure on both sides and sustains full throughput when
// both sides are always ready.
// =============================================================================
module TopModule (
    input        clk,
    input        rst_n,
    input  [7:0] data_in,
    input        valid_a,
    input        ready_b,
    output       ready_a,
    output       valid_b,
    output [9:0] data_out
);

    // -------------------------------------------------------------------
    // Internal state
    //   accumulated_sum : running sum of accepted inputs since last output
    //                     handshake (or reset)
    //   input_count     : number of input handshakes completed since last
    //                     output handshake (or reset), range 0..3
    //   valid_b_reg     : registered pending-output flag
    //   data_out_reg    : registered pending-output data
    // -------------------------------------------------------------------
    reg [9:0] accumulated_sum;
    reg [1:0] input_count;
    reg       valid_b_reg;
    reg [9:0] data_out_reg;

    // -------------------------------------------------------------------
    // Combinational handshake helper wires
    // -------------------------------------------------------------------
    wire input_accept  = valid_a & ready_a;   // input handshake completes
    wire output_accept = valid_b & ready_b;   // output handshake completes

    // -------------------------------------------------------------------
    // ready_a-formula / ready_a-formula-release / ready_a-formula-release2:
    // ready_a is the negation of (valid_b AND NOT ready_b).
    // ready_a = 0 only when a pending output (valid_b=1) is being stalled
    // (ready_b=0). Otherwise ready_a = 1.
    // -------------------------------------------------------------------
    assign ready_a  = ~(valid_b_reg & ~ready_b);
    assign valid_b  = valid_b_reg;
    assign data_out = data_out_reg;

    // -------------------------------------------------------------------
    // Sequential state update
    // -------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // @reset : known idle state
            accumulated_sum <= 10'd0;
            input_count     <= 2'd0;
            valid_b_reg     <= 1'b0;
            data_out_reg    <= 10'd0;
        end else begin
            // @accumulation-correctness / @independent-batches /
            // @no-overflow / @full-throughput:
            // When the 4th input of a batch is accepted, complete the sum
            // and present it on the output. This has priority over any
            // simultaneous output-side clearing so a new output can be
            // produced on the same cycle the previous one is consumed
            // (back-to-back throughput, no bubbles).
            if (input_accept && (input_count == 2'd3)) begin
                data_out_reg    <= accumulated_sum + data_in;
                valid_b_reg     <= 1'b1;
                accumulated_sum <= 10'd0;
                input_count     <= 2'd0;
            end else begin
                // @no-spurious-valid : valid_b stays low until 4th input
                // No new output produced this cycle.

                // @input-ignored-when-invalid /
                // @backpressure-holds-partial-state:
                // Only update partial accumulation/count when an input
                // handshake actually completes; otherwise hold state.
                if (input_accept) begin
                    accumulated_sum <= accumulated_sum + data_in;
                    input_count     <= input_count + 2'd1;
                end

                // @output-stability : data_out/valid_b hold until acked.
                // Clear the pending-output flag only when it is actually
                // acknowledged (valid_b & ready_b).
                if (output_accept) begin
                    valid_b_reg <= 1'b0;
                end
                // If neither input_accept nor output_accept occurs,
                // all registers implicitly hold their previous values
                // (no assignment -> retained), avoiding latches since
                // this is a clocked always block with full reset coverage.
            end
        end
    end

endmodule