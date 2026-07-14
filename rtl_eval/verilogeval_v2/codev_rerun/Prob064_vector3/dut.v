module TopModule (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z );
    wire [29:0] in;
    wire [31:0] out;
    assign in = {a, b, c, d, e, f};
    assign out = {in, 2'b11};
    assign {w, x, y, z} = out;
endmodule
