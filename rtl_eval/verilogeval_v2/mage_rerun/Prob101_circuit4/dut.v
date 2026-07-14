module TopModule (
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

    // Combinational logic: q = b OR c (independent of a and d)
    always @(*) begin
        q = b | c;
    end

endmodule