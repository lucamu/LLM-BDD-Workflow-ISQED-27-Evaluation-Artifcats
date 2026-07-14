module TopModule (
    input  logic clk,
    input  logic areset,
    input  logic in,
    output logic out
);

    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    logic state, state_next;

    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= STATE_B;
        else
            state <= state_next;
    end

    always @(*) begin
        case (state)
            STATE_A: state_next = (in) ? STATE_A : STATE_B;
            STATE_B: state_next = (in) ? STATE_B : STATE_A;
            default: state_next = STATE_B;
        endcase
    end

    assign out = (state == STATE_B) ? 1'b1 : 1'b0;

endmodule