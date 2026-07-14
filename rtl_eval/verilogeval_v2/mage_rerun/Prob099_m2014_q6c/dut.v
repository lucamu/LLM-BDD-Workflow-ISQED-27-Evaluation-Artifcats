module TopModule (
    input  logic [6:1] y,
    input  logic       w,
    output logic       Y2,
    output logic       Y4
);

    // Y2 is the next-state signal for state B (one-hot bit y[2])
    // B is reached only from A when w=0
    assign Y2 = y[1] & ~w;

    // Y4 is the next-state signal for state D (one-hot bit y[4])
    // D is reached from B, C, E, F when w=1
    assign Y4 = w & (y[2] | y[3] | y[5] | y[6]);

endmodule