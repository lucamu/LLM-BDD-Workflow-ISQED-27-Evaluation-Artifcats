module TopModule (
    input  logic clk,
    input  logic rst,
    input  logic data,
    output logic flag
);

    // State encoding
    localparam [2:0] S0 = 3'b000;
    localparam [2:0] S1 = 3'b001;
    localparam [2:0] S2 = 3'b010;
    localparam [2:0] S3 = 3'b011;
    localparam [2:0] S4 = 3'b100;

    logic [2:0] state, next_state;

    // State register (sequential logic), rst is active low, synchronous
    always @(posedge clk) begin
        if (!rst)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S1;
            S2: next_state = data ? S3 : S2;
            S3: next_state = data ? S4 : S3;
            S4: next_state = data ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Output combinational logic (Moore)
    always @(*) begin
        case (state)
            S4: flag = 1'b1;
            default: flag = 1'b0;
        endcase
    end

endmodule