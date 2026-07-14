module TopModule(
    input clk,
    input rst,
    input data,
    output reg flag
);
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;
    reg [2:0] state, next_state;
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
    always @(posedge clk) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end
    always @(*) begin
        case (state)
            S4: flag = 1'b1;
            S0, S1, S2, S3: flag = 1'b0;
            default: flag = 1'b0;
        endcase
    end
endmodule
