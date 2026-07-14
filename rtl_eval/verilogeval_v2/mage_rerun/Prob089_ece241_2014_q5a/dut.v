module TopModule (
    input  logic clk,
    input  logic areset,
    input  logic x,
    output logic z
);

    // State encoding
    localparam PASS   = 1'b0;
    localparam INVERT = 1'b1;

    logic state, state_next;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= PASS;
        else
            state <= state_next;
    end

    // Next state combinational logic
    always @(*) begin
        state_next = state;
        case (state)
            PASS:   state_next = (x) ? INVERT : PASS;
            INVERT: state_next = INVERT;
        endcase
    end

    // Output combinational logic (depends on state and x)
    always @(*) begin
        z = 1'b0;
        case (state)
            PASS:   z = x;
            INVERT: z = ~x;
        endcase
    end

endmodule