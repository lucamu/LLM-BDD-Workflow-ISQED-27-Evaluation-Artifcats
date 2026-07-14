module TopModule (
    input  clk,
    input  ar,
    input  d,
    output q
);
    reg q_r;
    always @(posedge clk or posedge ar) begin
        if (ar) begin
            q_r <= 1'b0;
        end
        else begin
            q_r <= d;
        end
    end
    assign q = q_r;
endmodule
