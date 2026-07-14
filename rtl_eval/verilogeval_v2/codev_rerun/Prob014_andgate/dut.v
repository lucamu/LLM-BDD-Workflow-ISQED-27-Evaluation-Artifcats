module TopModule(
    input  a,
    input  b,
    output out
);
    wire [1:0] _net = {a, b};
    assign out = & _net;
endmodule
