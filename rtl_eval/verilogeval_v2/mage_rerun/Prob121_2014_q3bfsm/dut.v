module TopModule (
    input  logic clk,
    input  logic reset,
    input  logic x,
    output logic z
);

    // State encoding
    localparam [2:0] S000 = 3'b000;
    localparam [2:0] S001 = 3'b001;
    localparam [2:0] S010 = 3'b010;
    localparam [2:0] S011 = 3'b011;
    localparam [2:0] S100 = 3'b100;

    logic [2:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S000;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            S000: next_state = (x) ? S001 : S000;
            S001: next_state = (x) ? S100 : S001;
            S010: next_state = (x) ? S001 : S010;
            S011: next_state = (x) ? S010 : S001;
            S100: next_state = (x) ? S100 : S011;
            default: next_state = S000;
        endcase
    end

    // Output combinational logic (Moore machine)
    always @(*) begin
        case (state)
            S000: z = 1'b0;
            S001: z = 1'b0;
            S010: z = 1'b0;
            S011: z = 1'b1;
            S100: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule