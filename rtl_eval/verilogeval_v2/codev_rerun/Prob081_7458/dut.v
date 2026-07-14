module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    output p1y,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p2y
);
    wire w_and3_1;
    wire w_and3_2;
    wire w_and2_1;
    wire w_and2_2;
    assign w_and3_1 = p1a & p1b & p1c;
    assign w_and3_2 = p1d & p1e & p1f;
    assign w_and2_1 = p2a & p2b;
    assign w_and2_2 = p2c & p2d;
    assign p1y = w_and3_1 | w_and3_2;
    assign p2y = w_and2_1 | w_and2_2;
endmodule
