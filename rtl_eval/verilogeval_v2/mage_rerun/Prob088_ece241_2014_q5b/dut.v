module TopModule (
    input  logic clk,
    input  logic areset,
    input  logic x,
    output logic z
);

    // One-hot state encoding
    localparam A = 2'b01;
    localparam B = 2'b10;

    logic [1:0] state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            A: next_state = x ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

    // Mealy output combinational logic (depends on current state and input)
    always @(*) begin
        case (state)
            A: z = x ? 1'b1 : 1'b0;
            B: z = x ? 1'b0 : 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule