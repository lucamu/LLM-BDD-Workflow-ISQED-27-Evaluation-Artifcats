module TopModule(
    input clk,
    input rst_n,
    input data,
    input data_valid,
    output match
);
    reg [1:0] state, next_state;
    reg [3:0] seq;
    always @(*) begin
        case ({state, data_valid, data})
            4'b0001: next_state = 2'b01;
            4'b0011: next_state = 2'b10;
            4'b0101: next_state = 2'b10;
            4'b0111: next_state = 2'b11;
            4'b1001: next_state = 2'b01;
            4'b1011: next_state = 2'b11;
            4'b1101: next_state = 2'b10;
            4'b1111: next_state = 2'b11;
            default: next_state = state;
        endcase
    end
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 2'b00;
        end
        else begin
            state <= next_state;
        end
    end
    always @(posedge clk) begin
        if (!rst_n) begin
            seq <= 4'b0000;
        end
        else begin
            if (data_valid) begin
                seq <= {seq[2:0], data};
            end
            else begin
                seq <= seq;
            end
        end
    end
    assign match = (rst_n == 1'b1) && (seq == 4'b0110);
endmodule
