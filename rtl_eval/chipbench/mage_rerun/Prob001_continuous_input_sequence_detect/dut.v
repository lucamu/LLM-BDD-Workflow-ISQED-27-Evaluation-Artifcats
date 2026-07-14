module TopModule (
    input  logic clk,
    input  logic rst_n,
    input  logic a,
    output logic match
);

    // 8-bit shift register
    logic [7:0] a_tem;

    // Sequential logic: shift register with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n)
            a_tem <= 8'b0;
        else
            a_tem <= {a_tem[6:0], a};
    end

    // Combinational logic: pattern matching
    assign match = (a_tem == 8'b0111_0001);

endmodule