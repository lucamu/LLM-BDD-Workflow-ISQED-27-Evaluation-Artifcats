module TopModule (
    input  logic clk,
    input  logic reset,
    input  logic j,
    input  logic k,
    output logic out
);

    localparam STATE_OFF = 1'b0;
    localparam STATE_ON  = 1'b1;

    logic state, state_next;

    always @(posedge clk) begin
        if (reset)
            state <= STATE_OFF;
        else
            state <= state_next;
    end

    always @(*) begin
        state_next = state;
        case (state)
            STATE_OFF: state_next = j ? STATE_ON : STATE_OFF;
            STATE_ON:  state_next = k ? STATE_OFF : STATE_ON;
        endcase
    end

    always @(*) begin
        out = 1'b0;
        case (state)
            STATE_OFF: out = 1'b0;
            STATE_ON:  out = 1'b1;
        endcase
    end

endmodule