module TopModule (
    input  [7:0] A,
    output [15:0] B
);
    assign B = A[7:0] * 8'hFB;
endmodule
