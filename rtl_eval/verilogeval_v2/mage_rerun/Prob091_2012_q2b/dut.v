module TopModule (
    input  logic [5:0] y,
    input  logic w,
    output logic Y1,
    output logic Y3
);

    // y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F

    // Y1 is the input to flip-flop y[1] (next state = B)
    // Only transition into B: A --1--> B
    assign Y1 = y[0] & w;

    // Y3 is the input to flip-flop y[3] (next state = D)
    // Transitions into D: B--0-->D, C--0-->D, E--0-->D, F--0-->D
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;

endmodule