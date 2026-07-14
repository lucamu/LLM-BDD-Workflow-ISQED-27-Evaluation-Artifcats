module TopModule(
    input clk,
    input rst_n,
    output data
);
    reg[5:0] d;
    reg[2:0] cnt;
    always @(posedge clk) begin
        if(!rst_n) begin
            d <= 6'b001011;
            cnt <= 3'd0;
        end
        else begin
            cnt <= (cnt == 3'd5) ? 3'd0 : cnt + 3'd1;
        end
    end
    assign data = d[cnt];
endmodule
