module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);
    integer i;
    reg [7:0] q;
    always @(posedge clk) begin
        q <= in;
        for (i = 0; i < 8; i++) begin
            pedge[i] <= (q[i] == 0 & in[i] == 1);
        end
    end
endmodule
