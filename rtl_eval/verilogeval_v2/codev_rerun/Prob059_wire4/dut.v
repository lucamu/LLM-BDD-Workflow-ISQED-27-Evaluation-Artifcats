module TopModule(
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    wire w1 = a;
    wire w2 = b;
    wire w3 = c;
    assign w = w1;
    assign x = w2;
    assign y = w2;
    assign z = w3;
endmodule
