module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);
    reg [3:0] count;
    always @(posedge clk) begin
        if (reset)
            count <= 0;
        else if (slowena) begin
            if (count == 9)
                count <= 0;
            else
                count <= count + 1;
        end
    end
    assign q = count;
endmodule
