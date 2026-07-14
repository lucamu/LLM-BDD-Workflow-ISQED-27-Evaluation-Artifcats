module TopModule(
    input clk,
    input rst_n,
    input read_en,
    input write_en,
    input [7:0] read_addr,
    input [7:0] write_addr,
    input [3:0] write_data,
    output reg [3:0] read_data
);
    reg [3:0] ram [0:7];
    always @(posedge clk) begin
        if (!rst_n) begin
            ram[0] <= 4'b0000;
            ram[1] <= 4'b0000;
            ram[2] <= 4'b0000;
            ram[3] <= 4'b0000;
            ram[4] <= 4'b0000;
            ram[5] <= 4'b0000;
            ram[6] <= 4'b0000;
            ram[7] <= 4'b0000;
        end
        else begin
            if (read_en) begin
                read_data <= ram[read_addr];
            end
            if (write_en) begin
                ram[write_addr] <= write_data;
            end
        end
    end
endmodule
