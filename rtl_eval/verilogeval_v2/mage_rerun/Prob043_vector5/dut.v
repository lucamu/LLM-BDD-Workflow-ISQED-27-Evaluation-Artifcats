module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    input  logic e,
    output logic [24:0] out
);

    logic [4:0] sig;
    assign sig = {a, b, c, d, e};

    integer i, j;
    always @(*) begin
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                out[24 - (5*i + j)] = ~sig[i] ^ sig[j];
            end
        end
    end

endmodule