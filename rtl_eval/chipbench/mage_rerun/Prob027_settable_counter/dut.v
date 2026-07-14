module TopModule (
    input  logic clk,
    input  logic rst_n,
    input  logic set,
    input  logic [3:0] set_num,
    output logic zero,
    output logic [3:0] number
);

    // Sequential logic: counter with async active-low reset
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            number <= 4'h0;
        else if (set)
            number <= set_num;
        else
            number <= number + 4'h1;
    end

    // Combinational logic: zero flag
    always @(*) begin
        zero = (number == 4'h0);
    end

endmodule