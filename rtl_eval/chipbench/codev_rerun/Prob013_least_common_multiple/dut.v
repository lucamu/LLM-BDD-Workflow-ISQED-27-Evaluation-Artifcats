module TopModule #(
    parameter DATA_W = 8
)(
    input                   clk,
    input                   rst_n,
    input  [DATA_W - 1 : 0] A,
    input  [DATA_W - 1 : 0] B,
    input                   vld_in,
    output [DATA_W*2 - 1 : 0] lcm_out,
    output [DATA_W   : 0] mcd_out,
    output                  vld_out
);
endmodule
