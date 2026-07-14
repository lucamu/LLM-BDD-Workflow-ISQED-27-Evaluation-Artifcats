module TopModule(
    input clk,
    input reset,
    output [3:0] q
);
    reg [3:0] count;
    always @(posedge clk) begin
        if (reset)
            count <= 4'b0001;
        else if (count == 4'b1001)
            count <= 4'b0001;
        else
            count <= count + 1'b1;
    end
    assign q = count;
endmodule
