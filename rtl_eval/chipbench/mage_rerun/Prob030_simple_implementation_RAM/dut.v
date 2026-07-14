module TopModule (
    input  logic clk,
    input  logic rst_n,
    input  logic read_en,
    input  logic write_en,
    input  logic [7:0] read_addr,
    input  logic [7:0] write_addr,
    input  logic [3:0] write_data,
    output logic [3:0] read_data
);

    // Memory array: depth 8, width 4 bits
    logic [3:0] mem [0:7];

    integer i;

    // Sequential logic: write operation and memory reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1) begin
                mem[i] <= 4'b0000;
            end
        end else begin
            if (write_en) begin
                mem[write_addr[2:0]] <= write_data;
            end
        end
    end

    // Sequential logic: read operation (registered output)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= 4'b0000;
        end else begin
            if (read_en) begin
                read_data <= mem[read_addr[2:0]];
            end
        end
    end

endmodule