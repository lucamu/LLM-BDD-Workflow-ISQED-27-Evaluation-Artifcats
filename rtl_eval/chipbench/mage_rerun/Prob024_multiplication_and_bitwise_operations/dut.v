module TopModule (
    input  logic [7:0] A,
    output logic [15:0] B
);

    // A * 251 = A * (256 - 5) = (A << 8) - (A << 2 + A)
    logic [15:0] A_shifted8;
    logic [15:0] A_times5;

    assign A_shifted8 = {A, 8'b0};         // A << 8
    assign A_times5   = (A << 2) + A;       // 5*A

    assign B = A_shifted8 - A_times5;       // A*251

endmodule