module TopModule (
    input  logic clk,
    input  logic rst_n,
    output logic [3:0] Q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            Q <= 4'b0000;
        else
            Q <= {~Q[0], Q[3:1]};
    end

endmodule