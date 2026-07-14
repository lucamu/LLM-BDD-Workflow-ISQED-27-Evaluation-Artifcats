module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out  ); 
    assign out = (~a&~b&c) | (a&~b&d) | (a&c&~d) | (a&b);
endmodule
