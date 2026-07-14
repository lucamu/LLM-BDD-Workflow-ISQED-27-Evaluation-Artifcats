// =============================================================================
// Module: TopModule
// Purpose: Serial Receiver FSM
//   Detects a start bit (logic 0 on an idle line), shifts in 8 data bits
//   LSB-first, checks for a valid stop bit (logic 1), and asserts 'done'
//   for exactly one clock cycle when a valid frame is received.
//   If the stop bit is missing (line is 0 instead of 1), the FSM enters
//   an error/recovery state and waits until the line returns to 1 before
//   resuming start-bit detection.
// =============================================================================
module TopModule (
    input        clk,
    input        in,
    input        reset,
    output [7:0] out_byte,
    output       done
);

    // -------------------------------------------------------------------
    // State encoding
    // -------------------------------------------------------------------
    localparam IDLE  = 2'd0; // Waiting for start bit          (@idle, @start)
    localparam DATA  = 2'd1; // Shifting in 8 data bits         (@data, @frame)
    localparam STOP  = 2'd2; // Checking stop bit               (@stop, @pulse)
    localparam ERROR = 2'd3; // Waiting for line to return to 1 (@stop @error, @recovery)

    reg [1:0] state;
    reg [2:0] bit_cnt;      // counts which data bit is being received (0..7)
    reg [7:0] shift_reg;    // holds bits as they are shifted in
    reg [7:0] out_byte_reg; // registered output byte
    reg       done_reg;     // registered done pulse

    assign out_byte = out_byte_reg;
    assign done     = done_reg;

    // -------------------------------------------------------------------
    // Sequential FSM logic
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset) begin
            // @reset: Reset forces FSM to idle state with done deasserted
            state        <= IDLE;
            bit_cnt      <= 3'd0;
            shift_reg    <= 8'd0;
            out_byte_reg <= 8'd0;
            done_reg     <= 1'b0;
        end else begin
            case (state)

                // -----------------------------------------------------------
                // IDLE: Line idle level is logic 1. Never asserts done here.
                // @idle, @start
                // -----------------------------------------------------------
                IDLE: begin
                    done_reg <= 1'b0;
                    if (in == 1'b0) begin
                        // Start bit detected: begin sampling data bits next cycle
                        state   <= DATA;
                        bit_cnt <= 3'd0;
                    end else begin
                        // Line still idle (1), remain in IDLE
                        state <= IDLE;
                    end
                end

                // -----------------------------------------------------------
                // DATA: Shift in 8 data bits, LSB first.
                // @data @frame @correct
                // -----------------------------------------------------------
                DATA: begin
                    done_reg          <= 1'b0;
                    shift_reg[bit_cnt] <= in; // b0 goes to bit0 (LSB), etc.
                    if (bit_cnt == 3'd7) begin
                        // All 8 bits received, move to stop bit check
                        state <= STOP;
                    end else begin
                        bit_cnt <= bit_cnt + 3'd1;
                        state   <= DATA;
                    end
                end

                // -----------------------------------------------------------
                // STOP: Validate the stop bit.
                // @data @frame @correct, @stop @error, @pulse, @backtoback
                // -----------------------------------------------------------
                STOP: begin
                    if (in == 1'b1) begin
                        // Correct stop bit: pulse done for exactly this cycle
                        done_reg     <= 1'b1;
                        out_byte_reg <= shift_reg;
                        state        <= IDLE; // ready to detect next start bit
                    end else begin
                        // Missing stop bit: suppress done, enter error recovery
                        done_reg <= 1'b0;
                        state    <= ERROR;
                    end
                end

                // -----------------------------------------------------------
                // ERROR: Wait here until line returns to idle (1) before
                // resuming start-bit detection.
                // @stop @error, @recovery
                // -----------------------------------------------------------
                ERROR: begin
                    done_reg <= 1'b0;
                    if (in == 1'b1) begin
                        // Delayed stop bit found; return to idle next edge
                        state <= IDLE;
                    end else begin
                        // Still waiting; do not attempt new start bit detection
                        state <= ERROR;
                    end
                end

                default: begin
                    // Safety net: should never occur, but avoid latches
                    state    <= IDLE;
                    done_reg <= 1'b0;
                end

            endcase
        end
    end

endmodule