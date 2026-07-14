module TopModule(
    input  a,
    input  b,
    output out
);
    xnor g1(out, a, b);
endmodule
