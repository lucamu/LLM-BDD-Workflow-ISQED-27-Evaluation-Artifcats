module TopModule (
    input  logic clk,
    input  logic in,
    output logic out
);

    logic d_in;

    // Combinational XOR feeding the D input of the flip-flop
    always @(*) begin
        d_in = in ^ out;
    end

    // Initialize output to a known value since there's no reset
    initial begin
        out = 1'b0;
    end

    // D flip-flop, positive edge triggered, no reset
    always @(posedge clk) begin
        out <= d_in;
    end

endmodule