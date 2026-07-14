module TopModule (
    input clk,
    input d,
    output q
);
    reg q_1;
    assign q = q_1;
    always @(posedge clk) begin
        q_1 <= d;
    end
endmodule
