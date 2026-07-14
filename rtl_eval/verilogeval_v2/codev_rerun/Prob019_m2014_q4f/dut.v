module TopModule(
    input  in1,
    input  in2,
    output out
);
    wire w;
    and a(w, in1, in2);
    buf b(out, w);
endmodule
