module TopModule(
    input clk,
    input rst,
    input rg_wrt_en,
    input [4:0] rg_wrt_dest,
    input [4:0] rg_rd_addr1,
    input [4:0] rg_rd_addr2,
    input [31:0] rg_wrt_data,
    output [31:0] rg_rd_data1,
    output [31:0] rg_rd_data2
);
    reg [31:0] registers [31:0];
    integer i;
    always @(posedge clk) begin
        if (rst == 1'b1) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'd0;
            end
        end else if (rg_wrt_en == 1'b1) begin
            registers[rg_wrt_dest] <= rg_wrt_data;
        end
    end
    assign rg_rd_data1 = registers[rg_rd_addr1];
    assign rg_rd_data2 = registers[rg_rd_addr2];
endmodule
