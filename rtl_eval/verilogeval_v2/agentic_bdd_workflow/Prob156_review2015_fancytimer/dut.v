// =============================================================================
// Module: TopModule
// Purpose: Serial Timer with Pattern Detection, Programmable Delay, and
//          Acknowledge Handshake.
//
//   - Searches serial input `data` for the pattern 1101 (MSB-first, most
//     recently received bits compared against the pattern).
//   - Once found, captures the next 4 bits of `data` (MSB first) as a
//     programmable delay value.
//   - Counts down for (delay+1)*1000 clock cycles while `counting` is
//     asserted and `count` shows the current remaining delay value
//     (decrementing once every 1000 cycles).
//   - When the countdown completes, asserts `done` and waits for `ack`
//     before returning to the searching state.
// =============================================================================
module TopModule (
    input        clk,
    input        reset,
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // ----------------------------------------------------------------------
    // Internal state encoding
    // ----------------------------------------------------------------------
    localparam SEARCH   = 2'd0;  // Searching for pattern 1101
    localparam CAPTURE  = 2'd1;  // Shifting in 4-bit delay value
    localparam COUNTING = 2'd2;  // Counting down (delay+1)*1000 cycles
    localparam DONE_ST  = 2'd3;  // Waiting for ack

    reg [1:0] state;

    // Shift register used while searching for the 1101 pattern
    reg [3:0] shift_reg;

    // Shift register used while capturing the delay value
    reg [3:0] delay_reg;

    // Counts how many delay bits have been captured (0..3)
    reg [1:0] capture_count;

    // Counts cycles within a single 1000-cycle block (0..999)
    reg [9:0] cycle_counter;

    // ----------------------------------------------------------------------
    // Main synchronous state machine
    // ----------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset) begin
            // @reset: Synchronous reset forces searching state, clears outputs
            state         <= SEARCH;
            shift_reg     <= 4'b0000;
            delay_reg     <= 4'b0000;
            capture_count <= 2'd0;
            cycle_counter <= 10'd0;
            count         <= 4'd0;
            counting      <= 1'b0;
            done          <= 1'b0;
        end
        else begin
            case (state)

                // ------------------------------------------------------
                // SEARCH: look for pattern 1101 on the serial data line
                // ------------------------------------------------------
                SEARCH: begin
                    counting <= 1'b0;
                    done     <= 1'b0;

                    // Shift new bit into the pattern-detect shift register
                    shift_reg <= {shift_reg[2:0], data};

                    // @pattern-detect: exact/overlapping match detection
                    if ({shift_reg[2:0], data} == 4'b1101) begin
                        state         <= CAPTURE;
                        capture_count <= 2'd0;
                    end
                    else begin
                        state <= SEARCH;
                    end
                end

                // ------------------------------------------------------
                // CAPTURE: shift in 4 delay bits, MSB first
                // ------------------------------------------------------
                CAPTURE: begin
                    counting <= 1'b0;
                    done     <= 1'b0;

                    // Shift new bit into delay register
                    delay_reg <= {delay_reg[2:0], data};

                    if (capture_count == 2'd3) begin
                        // @delay-capture: 4th bit just shifted in -> load count
                        state    <= COUNTING;
                        count    <= {delay_reg[2:0], data};
                        cycle_counter <= 10'd0;
                        counting <= 1'b1;
                    end
                    else begin
                        capture_count <= capture_count + 1'b1;
                        state         <= CAPTURE;
                    end
                end

                // ------------------------------------------------------
                // COUNTING: hold count for 1000 cycles, then decrement;
                // total duration = (delay+1)*1000 cycles
                // ------------------------------------------------------
                COUNTING: begin
                    counting <= 1'b1;
                    done     <= 1'b0;

                    // @data-ignored-while-counting: data input not sampled here

                    if (cycle_counter == 10'd999) begin
                        if (count == 4'd0) begin
                            // @counting: total duration elapsed -> done
                            state    <= DONE_ST;
                            counting <= 1'b0;
                            done     <= 1'b1;
                        end
                        else begin
                            // @counting: decrement every 1000 cycles
                            count         <= count - 1'b1;
                            cycle_counter <= 10'd0;
                            state         <= COUNTING;
                        end
                    end
                    else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end
                end

                // ------------------------------------------------------
                // DONE_ST: wait here until ack is received
                // ------------------------------------------------------
                DONE_ST: begin
                    counting <= 1'b0;
                    done     <= 1'b1;

                    if (ack) begin
                        // @done-ack: ack received -> return to searching
                        state     <= SEARCH;
                        done      <= 1'b0;
                        shift_reg <= 4'b0000;
                    end
                    else begin
                        // @done-ack: done remains asserted until ack
                        state <= DONE_ST;
                    end
                end

                default: begin
                    state <= SEARCH;
                end
            endcase
        end
    end

endmodule