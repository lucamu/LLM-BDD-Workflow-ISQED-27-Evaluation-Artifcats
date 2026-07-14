module TopModule(
  input  logic       clk,
  input  logic       rst_n,
  input  logic       valid_in,
  input  logic [7:0] data_in,
  output logic       valid_out,
  output logic [11:0] data_out
);

  // toggle: 0 means waiting for first byte, 1 means waiting for second byte
  logic       toggle;
  logic [7:0] high_byte;

  initial begin
    high_byte = 8'h00;
  end

  always @(posedge clk) begin
    if (!rst_n) begin
      toggle    <= 1'b0;
      valid_out <= 1'b0;
      data_out  <= 12'h000;
    end else begin
      // Default: no new valid output unless second byte arrives this cycle
      valid_out <= 1'b0;

      if (valid_in) begin
        if (toggle == 1'b0) begin
          // First byte of the pair
          high_byte <= data_in;
          toggle    <= 1'b1;
        end else begin
          // Second byte of the pair - form 12-bit output
          data_out  <= {high_byte, data_in};
          valid_out <= 1'b1;
          toggle    <= 1'b0;
        end
      end
    end
  end

endmodule