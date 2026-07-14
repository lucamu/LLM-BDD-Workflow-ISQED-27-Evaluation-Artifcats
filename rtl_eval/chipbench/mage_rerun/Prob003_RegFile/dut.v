module TopModule (
    input  logic        clk,
    input  logic        rst,
    input  logic        rg_wrt_en,
    input  logic [4:0]  rg_wrt_dest,
    input  logic [4:0]  rg_rd_addr1,
    input  logic [4:0]  rg_rd_addr2,
    input  logic [31:0] rg_wrt_data,
    output logic [31:0] rg_rd_data1,
    output logic [31:0] rg_rd_data2
);

    // Register file: 32 registers, each 32 bits wide
    logic [31:0] regfile [31:0];

    integer i;

    // Initialize registers to known values (0) to avoid X propagation
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            regfile[i] = 32'd0;
        end
    end

    // Sequential write logic with synchronous active-high reset
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                regfile[i] <= 32'd0;
            end
        end else if (rg_wrt_en) begin
            regfile[rg_wrt_dest] <= rg_wrt_data;
        end
    end

    // Combinational read logic
    assign rg_rd_data1 = regfile[rg_rd_addr1];
    assign rg_rd_data2 = regfile[rg_rd_addr2];

endmodule