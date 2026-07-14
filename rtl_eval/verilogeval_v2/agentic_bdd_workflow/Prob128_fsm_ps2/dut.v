// =============================================================================
// Module: TopModule
// Purpose: PS/2 Mouse Byte-Stream Message Boundary Detector
//
// Scans an incoming byte stream (in) for 3-byte PS/2 mouse messages.
// Resynchronizes by discarding bytes until one with bit[3] = 1 is found
// (byte1 of a message), then counts two more arbitrary bytes (byte2, byte3).
// Asserts `done` for exactly one clock cycle, one cycle after the third
// byte of a valid message has been received.
//
// State encoding:
//   S_SEARCH (0) : No bytes of a message accepted yet. Waiting for a byte
//                  with bit[3]=1 to serve as byte1.
//   S_BYTE1  (1) : byte1 accepted last cycle; current cycle's byte is byte2.
//   S_BYTE2  (2) : byte2 accepted last cycle; current cycle's byte is byte3.
//                  Completing this cycle triggers `done` on the NEXT cycle.
// =============================================================================
module TopModule (
    input  wire       clk,
    input  wire [7:0] in,
    input  wire       reset,
    output reg        done
);

    // State parameters
    localparam S_SEARCH = 2'd0; // Searching for byte1 (@search, @detect)
    localparam S_BYTE1  = 2'd1; // byte1 seen, waiting for byte2
    localparam S_BYTE2  = 2'd2; // byte2 seen, waiting for byte3 (last byte)

    reg [1:0] state, next_state;

    // ------------------------------------------------------------------
    // Combinational next-state logic
    // ------------------------------------------------------------------
    always @(*) begin
        case (state)
            // @search / @detect: stay searching unless in[3]=1 starts a message
            S_SEARCH: begin
                if (in[3])
                    next_state = S_BYTE1; // Byte "A" with A[3]=1 becomes byte1
                else
                    next_state = S_SEARCH; // Discard byte, keep searching
            end

            // @detect / @endtoend: current byte is byte2, move to await byte3
            S_BYTE1: begin
                next_state = S_BYTE2;
            end

            // @endtoend / @chaining / @resync: current byte is byte3,
            // message completes this cycle; next cycle starts fresh search
            // (chaining handled naturally since S_SEARCH re-evaluates in[3]
            // on the very next cycle, which corresponds to the "done" cycle)
            S_BYTE2: begin
                next_state = S_SEARCH;
            end

            default: begin
                next_state = S_SEARCH; // Safe default, avoids latch inference
            end
        endcase
    end

    // ------------------------------------------------------------------
    // Sequential state and done register update
    // ------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset) begin
            // @reset: synchronous reset restarts search and clears done
            state <= S_SEARCH;
            done  <= 1'b0;
        end else begin
            state <= next_state;

            // done asserts exactly one cycle after processing byte3
            // (i.e., when current state, before update, was S_BYTE2)
            // @endtoend, @pulsewidth, @chaining, @resync, @invariant
            if (state == S_BYTE2)
                done <= 1'b1;
            else
                done <= 1'b0;
        end
    end

endmodule