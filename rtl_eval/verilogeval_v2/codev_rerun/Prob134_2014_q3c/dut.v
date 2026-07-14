module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);
    reg [2:0] Y;
    assign z = (y == 3'b011) | (y == 3'b100);
    assign Y0 = Y[0];
    always @(*) begin
        case(y)
            3'b000: Y = (x == 0) ? 3'b000 : 3'b001;
            3'b001: Y = (x == 0) ? 3'b001 : 3'b100;
            3'b010: Y = (x == 0) ? 3'b010 : 3'b001;
            3'b011: Y = (x == 0) ? 3'b001 : 3'b010;
            3'b100: Y = (x == 0) ? 3'b011 : 3'b100;
        endcase
    end
endmodule
