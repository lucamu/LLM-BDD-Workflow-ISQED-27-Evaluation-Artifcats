module TopModule (
    input  logic clk,
    input  logic areset,
    input  logic j,
    input  logic k,
    output logic out
);

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    logic state, state_next;

    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= state_next;
    end

    always @(*) begin
        case (state)
            OFF: state_next = j ? ON : OFF;
            ON:  state_next = k ? OFF : ON;
            default: state_next = OFF;
        endcase
    end

    assign out = (state == ON);

endmodule