module full_module (
    input [2:0] r,
    input L,
    input clk,
    output reg [2:0] q);
    wire q_in, r_in;
    TopModule top0 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .Q(q[2])
    );
    TopModule top1 (
        .clk(clk),
        .L(L),
        .q_in(q[2]),
        .r_in(r[2]),
        .Q(q[1])
    );
    TopModule top2 (
        .clk(clk),
        .L(L),
        .q_in(q[1]),
        .r_in(r[1]),
        .Q(q[0])
    );
endmodule
