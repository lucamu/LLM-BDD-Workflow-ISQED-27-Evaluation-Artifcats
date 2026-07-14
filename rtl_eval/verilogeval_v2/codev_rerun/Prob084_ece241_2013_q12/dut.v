module dff (input clk, d, reset, output reg q);
    always @(posedge clk) begin
        if (reset)
            q <= 0;
        else
            q <= d;
    end
endmodule
