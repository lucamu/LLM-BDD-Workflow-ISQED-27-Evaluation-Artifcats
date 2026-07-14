module TopModule(
    input clk,
    input in,
    output out
);
    wire q, qbar, d;
    assign d = in ^ q;
    DFF dff1(clk, d, q, qbar);
    assign out = q ^ qbar;
endmodule
