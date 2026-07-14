module TopModule (
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic out,
    output logic out_n
);

    logic and_ab;
    logic and_cd;

    assign and_ab = a & b;
    assign and_cd = c & d;

    assign out = and_ab | and_cd;
    assign out_n = ~out;

endmodule