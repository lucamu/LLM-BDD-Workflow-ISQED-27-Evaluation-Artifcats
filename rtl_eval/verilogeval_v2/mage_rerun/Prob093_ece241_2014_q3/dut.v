module TopModule (
    input  logic c,
    input  logic d,
    output logic [3:0] mux_in
);

    // mux_in[0]: ab=00 column -> 0,1,1,1 for cd=00,01,11,10 => c | d
    assign mux_in[0] = c | d;

    // mux_in[1]: ab=01 column -> all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2]: ab=11 column -> only 1 when c=1,d=1 => c & d
    assign mux_in[2] = c & d;

    // mux_in[3]: ab=10 column -> 1,0,1,1 for cd=00,01,11,10 => c | ~d
    assign mux_in[3] = c | ~d;

endmodule