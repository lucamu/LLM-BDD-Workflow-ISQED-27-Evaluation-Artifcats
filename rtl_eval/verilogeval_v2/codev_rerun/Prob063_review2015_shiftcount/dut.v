module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);
    reg [3:0] shift_reg;
    reg [3:0] down_count;
    always @(posedge clk) begin
                if (shift_ena == 1'b1) begin
            shift_reg <= {shift_reg[2:0], data};
        end
                if (count_ena == 1'b1) begin
            down_count <= down_count - 1'b1;
        end
    end
    assign q = shift_reg;
endmodule
