module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);
    wire w;
    xnor XNOR1 (w, in1, in2);
    xor XOR1 (out, w, in3);
endmodule
