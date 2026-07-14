module TopModule(
    input clk,
    input rst_n,        input a,
    output match
);
    reg [7:0] a_tem;
    reg match_tem;
    assign match = match_tem;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_tem <= 8'b0;
            match_tem <= 1'b0;
        end
        else begin
            a_tem <= {a_tem[6:0], a};
            if (a_tem == 8'b0111_0001)
                match_tem <= 1'b1;
            else
                match_tem <= 1'b0;
        end
    end
endmodule
