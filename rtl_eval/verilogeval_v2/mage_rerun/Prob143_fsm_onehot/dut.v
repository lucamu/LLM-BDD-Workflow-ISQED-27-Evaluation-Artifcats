module TopModule (
    input  logic in,
    input  logic [9:0] state,
    output logic [9:0] next_state,
    output logic out1,
    output logic out2
);

    // Combinational next-state logic
    always @(*) begin
        next_state = 10'b0;

        if (state[0]) next_state[ in ? 1 : 0 ] = 1'b1;
        if (state[1]) next_state[ in ? 2 : 0 ] = 1'b1;
        if (state[2]) next_state[ in ? 3 : 0 ] = 1'b1;
        if (state[3]) next_state[ in ? 4 : 0 ] = 1'b1;
        if (state[4]) next_state[ in ? 5 : 0 ] = 1'b1;
        if (state[5]) next_state[ in ? 6 : 8 ] = 1'b1;
        if (state[6]) next_state[ in ? 7 : 9 ] = 1'b1;
        if (state[7]) next_state[ in ? 7 : 0 ] = 1'b1;
        if (state[8]) next_state[ in ? 1 : 0 ] = 1'b1;
        if (state[9]) next_state[ in ? 1 : 0 ] = 1'b1;
    end

    // Combinational output logic
    always @(*) begin
        out1 = state[8] | state[9];
        out2 = state[7] | state[9];
    end

endmodule