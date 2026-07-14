module TopModule(
    input clk,
    input reset,       input x,
    output z
);
    reg [2:0] y;
    wire [2:0] Y;
    always @(posedge clk) begin
        if (reset) y <= 3'b000;
        else y <= Y;
    end
    assign Y[2] = (y[2] & ~y[1] & y[0]) | (~y[2] & ~y[1] & ~x) | (~y[2] & y[1] & x);
    assign Y[1] = (~y[2] & ~y[1] & x) | (~y[2] & y[1] & ~x);
    assign Y[0] = ~y[0];
    assign z = y[0];
endmodule
