module TopModule (
    input  logic clk,
    input  logic reset,
    input  logic w,
    output logic z
);

    // State encoding
    localparam STATE_A = 3'd0;
    localparam STATE_B = 3'd1;
    localparam STATE_C = 3'd2;
    localparam STATE_D = 3'd3;
    localparam STATE_E = 3'd4;
    localparam STATE_F = 3'd5;

    logic [2:0] state, state_next;

    // Initialize state to avoid X before reset takes effect
    initial begin
        state = STATE_A;
    end

    // State flip-flop (sequential logic)
    always @(posedge clk) begin
        if (reset)
            state <= STATE_A;
        else
            state <= state_next;
    end

    // Next-state combinational logic
    always @(*) begin
        state_next = state;
        case (state)
            STATE_A: state_next = (w) ? STATE_B : STATE_A;
            STATE_B: state_next = (w) ? STATE_C : STATE_D;
            STATE_C: state_next = (w) ? STATE_E : STATE_D;
            STATE_D: state_next = (w) ? STATE_F : STATE_A;
            STATE_E: state_next = (w) ? STATE_E : STATE_D;
            STATE_F: state_next = (w) ? STATE_C : STATE_D;
            default: state_next = STATE_A;
        endcase
    end

    // Output logic (Moore output)
    assign z = (state == STATE_E) || (state == STATE_F);

endmodule