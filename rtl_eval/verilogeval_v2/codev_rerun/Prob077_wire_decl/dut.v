module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n   ); 
    wire and1, and2, or1;
    and (and1, a, b);
    and (and2, c, d);
    or (or1, and1, and2);
    not (out_n, or1);
    assign out = or1;
endmodule
