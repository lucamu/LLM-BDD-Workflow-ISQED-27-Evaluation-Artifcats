module TopModule(
    input d,
    input done_counting,
    input ack,
    input [9:0] state,        output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);         parameter S=0, S1=1, S11=2, S110=3, B0=4, B1=5, B2=6, B3=7, Count=8, Wait=9;
    assign B3_next = state[6];
    assign S_next = (state[0] & {1'd0}) | (state[1] & {1'd0}) | (state[2] & {1'd0}) | (state[3] & {1'd0}) | (state[9] & {1'd0});
    assign S1_next = state[0] & {1'd1} | state[1] & {1'd1};
    assign Count_next = state[4] & {1'd0} | state[5] & {1'd0} | state[6] & {1'd0} | state[7] & {1'd0} | state[8] & {1'd0};
    assign Wait_next = state[7] & {1'd1} | state[8] & {1'd1} | state[9] & {1'd1};
    assign done = state[9] & {1'd1};
    assign counting = state[8] & {1'd1};
    assign shift_ena = state[4] & {1'd1} | state[5] & {1'd1} | state[6] & {1'd1} | state[7] & {1'd1};
endmodule
