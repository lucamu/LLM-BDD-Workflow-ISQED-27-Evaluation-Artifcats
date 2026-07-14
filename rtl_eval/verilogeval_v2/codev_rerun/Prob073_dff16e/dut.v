module DFF (q, d, clk, resetn);
    output reg q;
    input d, clk, resetn;
    always @(posedge clk) begin
        if (~resetn)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule
