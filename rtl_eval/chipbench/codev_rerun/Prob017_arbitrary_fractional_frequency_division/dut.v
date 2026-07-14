module TopModule(
    input clk_in,
    input rst,
    output clk_out
);
    reg [7:0] cnt;
    reg clk_p;
    reg clk_n;
    always @(posedge clk_in or negedge rst) begin
        if(!rst) begin
            cnt <= 8'd0;
            clk_p <= 1'b0;
        end
        else begin
            if(cnt == M_N - 1'b1) begin
                cnt <= 8'd0;
                clk_p <= ~clk_p;
            end
            else begin
                cnt <= cnt + 8'd1;
                clk_p <= clk_p;
            end
        end
    end
    always @(negedge clk_in or negedge rst) begin
        if(!rst) begin
            cnt <= 8'd0;
            clk_n <= 1'b0;
        end
        else begin
            if(cnt == M_N - 1'b1) begin
                cnt <= 8'd0;
                clk_n <= ~clk_n;
            end
            else begin
                cnt <= cnt + 8'd1;
                clk_n <= clk_n;
            end
        end
    end
    assign clk_out = clk_in ? clk_p : clk_n;
endmodule
