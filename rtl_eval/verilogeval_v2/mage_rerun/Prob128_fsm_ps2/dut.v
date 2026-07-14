module TopModule (
    input  logic clk,
    input  logic reset,
    input  logic [7:0] in,
    output logic done
);

    // State encoding
    localparam BYTE1 = 2'b00;
    localparam BYTE2 = 2'b01;
    localparam BYTE3 = 2'b10;

    logic [1:0] state, state_next;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= BYTE1;
        else
            state <= state_next;
    end

    // Next state combinational logic
    always @(*) begin
        state_next = state;
        case (state)
            BYTE1: state_next = (in[3]) ? BYTE2 : BYTE1;
            BYTE2: state_next = BYTE3;
            BYTE3: state_next = (in[3]) ? BYTE2 : BYTE1;
            default: state_next = BYTE1;
        endcase
    end

    // done output: registered, asserted one cycle after the third byte
    // (i.e., when the current state was BYTE3 during this cycle's byte reception)
    always @(posedge clk) begin
        if (reset)
            done <= 1'b0;
        else
            done <= (state == BYTE3) ? 1'b1 : 1'b0;
    end

endmodule