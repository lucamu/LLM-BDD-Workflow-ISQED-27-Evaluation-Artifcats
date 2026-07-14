module TopModule(
    input clk,
    input rst,
    input signed_div_i,
    input [31:0] opdata1_i,
    input [31:0] opdata2_i,
    input start_i,
    input annul_i,
    output [63:0] result_o,
    output ready_o
);
endmodule
