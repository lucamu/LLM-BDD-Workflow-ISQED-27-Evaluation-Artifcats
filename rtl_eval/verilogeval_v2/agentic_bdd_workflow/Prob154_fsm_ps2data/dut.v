// ============================================================================
// Module: TopModule
// Purpose: Message Boundary Detection FSM
//          Detects 3-byte messages in a byte stream where the first byte
//          of the message has bit[3] set. Captures byte1, byte2, byte3 and
//          asserts 'done' for exactly one cycle when a full message has been
//          received, presenting the captured bytes on out_bytes.
//
// States:
//   S_SEARCH (byte-1-searching) : byte1_captured=0, byte2_captured=0
//   S_WAIT2  (byte-2-waiting)   : byte1_captured=1, byte2_captured=0
//   S_WAIT3  (byte-3-waiting)   : byte1_captured=1, byte2_captured=1
// ============================================================================
module TopModule (
    input        clk,
    input  [7:0] in,
    input        reset,
    output [23:0] out_bytes,
    output        done
);

    // State encoding
    localparam S_SEARCH = 2'b00; // byte-1-searching
    localparam S_WAIT2  = 2'b01; // byte-2-waiting
    localparam S_WAIT3  = 2'b10; // byte-3-waiting

    reg [1:0]  state;
    reg [7:0]  byte1_reg;
    reg [7:0]  byte2_reg;
    reg [23:0] out_bytes_reg;
    reg        done_reg;

    // Internal flags precisely reflecting current state
    // (@state_flags_invariant scenario)
    wire byte1_captured = (state == S_WAIT2) || (state == S_WAIT3);
    wire byte2_captured = (state == S_WAIT3);

    assign out_bytes = out_bytes_reg;
    assign done       = done_reg;

    always @(posedge clk) begin
        if (reset) begin
            // @reset : force done low and FSM into searching state
            state         <= S_SEARCH;
            done_reg      <= 1'b0;
            // out_bytes and internal captured bytes are don't-care after reset
            // (only done and state are required to be defined per spec)
            byte1_reg     <= 8'h00;
            byte2_reg     <= 8'h00;
            out_bytes_reg <= 24'h000000;
        end else begin
            case (state)

                // ------------------------------------------------------
                // S_SEARCH: waiting for a byte with in[3]=1 to start
                // a new message (@discard, @capture_byte1, @no_spurious_done)
                // ------------------------------------------------------
                S_SEARCH: begin
                    done_reg <= 1'b0; // never done while searching
                    if (in[3]) begin
                        // @capture_byte1 : qualifying byte captured as byte1
                        byte1_reg <= in;
                        state     <= S_WAIT2;
                    end else begin
                        // @discard : non-qualifying byte, stay searching
                        state <= S_SEARCH;
                    end
                end

                // ------------------------------------------------------
                // S_WAIT2: byte1 already captured, capture byte2 next
                // (@full_message)
                // ------------------------------------------------------
                S_WAIT2: begin
                    done_reg  <= 1'b0; // not done yet
                    byte2_reg <= in;   // capture byte2 (any value)
                    state     <= S_WAIT3;
                end

                // ------------------------------------------------------
                // S_WAIT3: byte1 & byte2 captured, this cycle's 'in' is
                // byte3 -- complete the message (@full_message,
                // @done_pulse_width, @back_to_back_start,
                // @done_cycle_discard)
                // ------------------------------------------------------
                S_WAIT3: begin
                    done_reg      <= 1'b1; // message complete this cycle
                    out_bytes_reg <= {byte1_reg, byte2_reg, in};
                    if (in[3]) begin
                        // @back_to_back_start : this same byte also
                        // qualifies as the start of the next message
                        byte1_reg <= in;
                        state     <= S_WAIT2;
                    end else begin
                        // @done_cycle_discard : does not start new message
                        state <= S_SEARCH;
                    end
                end

                // ------------------------------------------------------
                // Default: should not occur, but guard against
                // unreachable/undefined states
                // ------------------------------------------------------
                default: begin
                    state    <= S_SEARCH;
                    done_reg <= 1'b0;
                end

            endcase
        end
    end

endmodule