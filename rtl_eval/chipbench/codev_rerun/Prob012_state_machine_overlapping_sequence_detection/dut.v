module TopModule(
    input clk,
    input rstn,
    input data,
    output reg flag
);
    reg [1:0] state, next_state;
    reg [1:0] counter;
    always @(*) begin
        case (state)
            2'b00: next_state = data ? 2'b01 : 2'b00;
            2'b01: next_state = data ? 2'b10 : 2'b00;
            2'b10: next_state = data ? 2'b10 : 2'b11;
            2'b11: next_state = data ? 2'b01 : 2'b00;
        endcase
    end
    always @(posedge clk) begin
        if (!rstn) begin
            state <= 2'b00;
            flag <= 1'b0;
            counter <= 2'b00;
        end else begin
            state <= next_state;
            if (state == 2'b11 && next_state == 2'b00) begin
                flag <= 1'b1;
                counter <= counter + 1'b1;
            end else begin
                flag <= 1'b0;
            end
        end
    end
endmodule
