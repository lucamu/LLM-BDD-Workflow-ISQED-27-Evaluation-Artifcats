module TopModule (
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

    // Combinational logic: q is 1 when the number of 1's among a,b,c,d is even
    assign q = ~(a ^ b ^ c ^ d);

endmodule