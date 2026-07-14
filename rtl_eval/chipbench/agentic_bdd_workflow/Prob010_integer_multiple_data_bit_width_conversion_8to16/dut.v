// ============================================================================
// Module: TopModule
// Purpose: 8-bit to 16-bit Data Width Converter with Valid-Only Handshake
//          Accumulates two consecutive valid 8-bit inputs into one 16-bit
//          output word, asserting valid_out for exactly one cycle when the
//          second byte of a pair is received.
// ============================================================================
module TopModule (
    input               clk,
    input               rst_n,
    input               valid_in,
    input       [7:0]   data_in,
    output              valid_out,
    output      [15:0]  data_out
);

    // Internal state
    reg         byte_cnt;       // 0 = waiting for first byte, 1 = first byte stored
    reg [7:0]   first_byte;     // storage for first received byte
    reg         valid_out_reg;  // registered valid_out
    reg [15:0]  data_out_reg;   // registered data_out

    assign valid_out = valid_out_reg;
    assign data_out  = data_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // @reset: Reset forces outputs and internal state to known idle values
            // @reset: Reset clears a pending first byte regardless of prior state
            byte_cnt      <= 1'b0;
            first_byte    <= 8'b0;
            valid_out_reg <= 1'b0;
            data_out_reg  <= 16'b0;
        end
        else begin
            if (valid_in) begin
                if (byte_cnt == 1'b0) begin
                    // @first_byte: Receiving the first byte stores it, no output
                    // @continuous_stream: first half of the cycle pattern
                    // @independent_bytes: store high byte (arrives first)
                    first_byte    <= data_in;
                    byte_cnt      <= 1'b1;
                    valid_out_reg <= 1'b0;
                    // data_out_reg holds previous value (data_out_stability)
                end
                else begin
                    // @second_byte: Receiving second byte produces combined output
                    // @continuous_stream: second half completes the pair
                    // @independent_bytes: high byte = first_byte, low byte = data_in
                    data_out_reg  <= {first_byte, data_in};
                    valid_out_reg <= 1'b1;
                    byte_cnt      <= 1'b0;
                end
            end
            else begin
                // @idle_no_input: no input keeps state and output unchanged
                // @first_byte_no_new_input: waiting for second byte holds partial state
                // @valid_out_pulse: valid_out deasserts one cycle after completion
                // @data_out_stability: data_out holds value when valid_out is 0
                byte_cnt      <= byte_cnt;
                first_byte    <= first_byte;
                valid_out_reg <= 1'b0;
                data_out_reg  <= data_out_reg;
            end
        end
    end

endmodule