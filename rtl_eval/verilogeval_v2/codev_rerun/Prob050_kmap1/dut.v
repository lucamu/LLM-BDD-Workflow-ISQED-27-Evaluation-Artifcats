module TopModule(
    input a,
    input b,
    input c,
    output out  ); 
    assign out = (c & b) | (c & a) | (b & a);
endmodule
