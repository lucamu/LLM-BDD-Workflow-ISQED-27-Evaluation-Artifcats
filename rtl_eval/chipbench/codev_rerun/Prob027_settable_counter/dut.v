module TopModule(
    input clk,
    input rst_n,
    input set,
    input [3:0] set_num,
    output reg zero,
    output reg [3:0] number
);
    reg [3:0] number_next;
    always @(*) begin
        if (set)
            number_next = set_num;
        else
            number_next = number + 1;
    end
    always @(posedge clk) begin
        if (!rst_n) begin
            number <= 0;
            zero <= 0;
        end
        else begin
            number <= number_next;
            zero <= (number_next == 0);
        end
    end
endmodule
