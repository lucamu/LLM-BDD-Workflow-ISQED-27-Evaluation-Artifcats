module TopModule(
    input clk,
    input rst_n,
    output reg [3:0] gray_out
);
    wire [3:0] gray_in;
    reg [3:0] bin;
    reg [3:0] count;
    always @(posedge clk) begin
        if (~rst_n) begin
            gray_out <= 4'b0;
            count <= 4'b0;
        end
        else begin
            gray_out <= gray_in;
            count <= count + 1;
        end
    end
    assign gray_in = {bin[3], bin[3]^bin[2], bin[2]^bin[1], bin[1]^bin[0]};
    always @(posedge clk) begin
        if (~rst_n) begin
            bin <= 4'b0;
        end
        else begin
            bin <= gray_out;
        end
    end
endmodule
