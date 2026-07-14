module TopModule (
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    // State encoding
    localparam [2:0] S0 = 3'd0;
    localparam [2:0] S1 = 3'd1;
    localparam [2:0] S2 = 3'd2;
    localparam [2:0] S3 = 3'd3;
    localparam [2:0] S4 = 3'd4;

    logic [2:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S4;
            S4: next_state = S4;
            default: next_state = S0;
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            S0: shift_ena = 1'b1;
            S1: shift_ena = 1'b1;
            S2: shift_ena = 1'b1;
            S3: shift_ena = 1'b1;
            S4: shift_ena = 1'b0;
            default: shift_ena = 1'b0;
        endcase
    end

endmodule