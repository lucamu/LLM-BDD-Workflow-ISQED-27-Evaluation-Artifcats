module TopModule(
    input [7:0] in_A,
    input [7:0] in_B,
    input [1:0] in_operation,
    output [7:0] out_c
    );
    wire [7:0] out_and,out_or,out_adder,out_mux;
    bit_8_AND i1(out_and,in_A,in_B);
    bit_8_OR i2(out_or,in_A,in_B);
    bit_8_ADDER i3(out_adder,in_A,in_B,in_operation[0]);
    mux_2X1 i4(out_mux,out_and,out_or,in_operation[0]);
    assign out_c = (in_operation[1] == 0)? out_mux : out_adder;
endmodule
