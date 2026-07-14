module TopModule(
    input clk,
    input rst_n,
    input a,
    output match
);
    reg [8:0] bits;
    always @(posedge clk) begin
        bits <= {bits[7:0], a};
    end
    assign match = bits[8:6] == 3'b011 && bits[2:0] == 3'b110 && bits[5:3] == 3'bxxx;
endmodule
