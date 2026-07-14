module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // 4-input AND gate: outputs 1 only when all input bits are 1
    assign out_and = in[3] & in[2] & in[1] & in[0];

    // 4-input OR gate: outputs 0 only when all input bits are 0
    assign out_or = in[3] | in[2] | in[1] | in[0];

    // 4-input XOR gate: outputs 1 when the number of set bits is odd
    assign out_xor = in[3] ^ in[2] ^ in[1] ^ in[0];

endmodule