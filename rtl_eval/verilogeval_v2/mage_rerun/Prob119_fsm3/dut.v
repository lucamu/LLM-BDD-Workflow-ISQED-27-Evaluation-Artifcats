module TopModule (
    input  logic clk,
    input  logic areset,
    input  logic in,
    output logic out
);

    // State encoding
    localparam STATE_A = 2'b00;
    localparam STATE_B = 2'b01;
    localparam STATE_C = 2'b10;
    localparam STATE_D = 2'b11;

    logic [1:0] state, state_next;

    // State register with asynchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= STATE_A;
        else
            state <= state_next;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            STATE_A: state_next = (in) ? STATE_B : STATE_A;
            STATE_B: state_next = (in) ? STATE_B : STATE_C;
            STATE_C: state_next = (in) ? STATE_D : STATE_A;
            STATE_D: state_next = (in) ? STATE_B : STATE_C;
            default: state_next = STATE_A;
        endcase
    end

    // Output combinational logic (Moore)
    always @(*) begin
        case (state)
            STATE_A: out = 1'b0;
            STATE_B: out = 1'b0;
            STATE_C: out = 1'b0;
            STATE_D: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule