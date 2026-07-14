module TopModule (
    input  logic [99:0] in,
    output logic [99:0] out
);

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : REVERSE_BITS
            assign out[i] = in[99-i];
        end
    endgenerate

endmodule