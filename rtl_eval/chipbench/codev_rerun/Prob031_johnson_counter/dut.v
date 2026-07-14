module TopModule(
    input clk,
    input rst_n,
    output reg [3:0] Q
);
    always @(posedge clk) begin
        if (~rst_n) begin
            Q <= 4'b0000;
        end
        else begin
            Q[3] <= ~Q[0];
            Q[2] <= Q[3];
            Q[1] <= Q[2];
            Q[0] <= Q[1];
        end
    end
endmodule
