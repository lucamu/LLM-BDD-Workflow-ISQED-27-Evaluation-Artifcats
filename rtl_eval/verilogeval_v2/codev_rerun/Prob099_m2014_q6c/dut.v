module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
        assign Y2 = (y[0] & ~w) | (y[2] & ~w) | (y[4] & ~w);
    assign Y4 = (y[1] & w) | (y[3] & w) | (y[5] & w);
endmodule
