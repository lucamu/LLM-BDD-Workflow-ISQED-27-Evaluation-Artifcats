// ============================================================================
// Module: TopModule
// Purpose: 8-bit to 12-bit data width converter with valid-only handshake.
//          Packs two consecutive valid 8-bit input words into one 12-bit
//          output word. First byte occupies data_out[11:4], second byte's
//          low nibble occupies data_out[3:0]. valid_out pulses for one
//          cycle when a pair completes.
// ============================================================================
module TopModule (
    input        clk,
    input        rst_n,
    input        valid_in,
    input  [7:0] data_in,
    output       valid_out,
    output [11:0] data_out
);

    // Internal state registers
    reg         pending_valid;   // indicates a first byte is waiting for its pair
    reg  [7:0]  pending_byte;    // stores the first byte of the pair
    reg         valid_out_reg;   // registered valid_out
    reg  [11:0] data_out_reg;    // registered data_out

    assign valid_out = valid_out_reg;
    assign data_out  = data_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // @reset: force outputs and internal pending state to idle
            pending_valid <= 1'b0;
            pending_byte  <= 8'b0;
            valid_out_reg <= 1'b0;
            data_out_reg  <= 12'b0;
        end else begin
            if (valid_in) begin
                if (pending_valid) begin
                    // @second-input-produces-output / @back-to-back-pairs /
                    // @non-contiguous-inputs / @mid-sequence-reset:
                    // second byte arrives, complete the pair
                    data_out_reg  <= {pending_byte, data_in};
                    valid_out_reg <= 1'b1;
                    pending_valid <= 1'b0;
                    pending_byte  <= 8'b0;
                end else begin
                    // @first-input-no-output: store first byte, no output yet
                    pending_byte  <= data_in;
                    pending_valid <= 1'b1;
                    valid_out_reg <= 1'b0;
                end
            end else begin
                // @no-output-when-idle / @valid-out-single-cycle-pulse /
                // @non-contiguous-inputs: no new input, valid_out deasserts,
                // pending state (if any) is preserved
                valid_out_reg <= 1'b0;
                // pending_valid and pending_byte remain unchanged
            end
        end
    end

endmodule