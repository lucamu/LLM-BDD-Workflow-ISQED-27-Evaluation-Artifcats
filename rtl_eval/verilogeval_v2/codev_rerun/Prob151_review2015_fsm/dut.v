module TopModule(
    input clk,
    input reset,          input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );
    parameter IDLE = 0, SHIFT_ENA = 1, COUNTING = 2, DONE = 3;
    reg [1:0] state, next_state;
    always @(*) begin
        case (state)
            IDLE: next_state = (data == 1 && ack == 0) ? SHIFT_ENA : IDLE;
            SHIFT_ENA: next_state = (done_counting == 1) ? COUNTING : SHIFT_ENA;
            COUNTING: next_state = (done_counting == 1) ? DONE : COUNTING;
            DONE: next_state = (ack == 1) ? IDLE : DONE;
        endcase
    end
    always @(posedge clk) begin
        if (reset) state <= IDLE;
        else state <= next_state;
    end
    assign shift_ena = (state == SHIFT_ENA) ? 1 : 0;
    assign counting = (state == COUNTING) ? 1 : 0;
    assign done = (state == DONE) ? 1 : 0;
endmodule
