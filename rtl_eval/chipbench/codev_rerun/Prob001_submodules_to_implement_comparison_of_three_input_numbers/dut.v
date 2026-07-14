module TopModule(
    input clk,
    input rst_n,
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    output [7:0] d
);
    wire [7:0] min_a_b;
    wire [7:0] min_a_b_c;
    MinModule u1(
        .data_a(a),
        .data_b(b),
        .min_data(min_a_b)
    );
    MinModule u2(
        .data_a(min_a_b),
        .data_b(c),
        .min_data(min_a_b_c)
    );
    assign d = min_a_b_c;
endmodule
