module TopModule (
    input  logic clk,
    input  logic shift_ena,
    input  logic count_ena,
    input  logic data,
    output logic [3:0] q
);

    initial q = 4'b0000;

    always @(posedge clk) begin
        if (shift_ena)
            q <= {q[2:0], data};
        else if (count_ena)
            q <= q - 1'b1;
        else
            q <= q;
    end

endmodule