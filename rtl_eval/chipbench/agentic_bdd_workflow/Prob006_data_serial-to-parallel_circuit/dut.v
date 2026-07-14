//------------------------------------------------------------------------
// Module: TopModule
// Purpose: Serial-to-Parallel Converter
//   Accepts single-bit serial data (data_a) qualified by valid_a, using a
//   simple ready/valid handshake on the input side (ready_a is always 1).
//   Accumulates 6 bits into a shift register, LSB first, and pulses
//   valid_b for exactly one cycle with the packed 6-bit word on data_b
//   once 6 valid bits have been received.
//------------------------------------------------------------------------
module TopModule (
    input  clk,
    input  rst_n,
    input  valid_a,
    input  data_a,
    output ready_a,
    output valid_b,
    output [5:0] data_b
);

    // Internal state
    reg [2:0] bit_count;      // received-bit counter (0..5)
    reg [5:0] shift_reg;      // internally stored shift register
    reg       valid_b_reg;    // registered valid_b output

    // ready_a is always asserted (Scenario @ready)
    assign ready_a = 1'b1;

    assign valid_b = valid_b_reg;
    assign data_b  = shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Scenario @reset: initialize to idle state
            bit_count   <= 3'd0;
            shift_reg   <= 6'd0;
            valid_b_reg <= 1'b0;
        end else begin
            if (valid_a) begin
                // A valid input bit arrives
                if (bit_count == 3'd5) begin
                    // Scenario @bit-placement-msb, @full-conversion,
                    // @valid-pulse, @counter-wrap:
                    // Sixth bit completes the word -> place in MSB,
                    // assert valid_b for one cycle, wrap counter to 0.
                    shift_reg[5] <= data_a;
                    valid_b_reg  <= 1'b1;
                    bit_count    <= 3'd0;
                end else begin
                    // Scenario @accumulation, @bit-placement-lsb,
                    // @back-to-back: advance counter and store bit
                    // at position [bit_count] (LSB first).
                    shift_reg[bit_count] <= data_a;
                    bit_count            <= bit_count + 3'd1;
                    valid_b_reg          <= 1'b0; // Scenario @no-premature-valid
                end
            end else begin
                // Scenario @no-advance: invalid input, hold state
                bit_count   <= bit_count;
                shift_reg   <= shift_reg;
                valid_b_reg <= 1'b0; // valid_b deasserted when no completion
            end
        end
    end

endmodule