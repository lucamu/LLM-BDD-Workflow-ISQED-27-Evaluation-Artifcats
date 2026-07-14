module mux_4_1(input [3:0] in, input [1:0] ab, output out);
    assign out = in[ab];
endmodule
