module TopModule(
    input clk,
    input rst,
    input [5:0] stall,
    input flush,
    input [31:0] new_pc,
    input branch_flag_i,
    input [31:0] branch_target_address_i,
    output reg [31:0] pc,
    output reg ce
);
    always @(posedge clk) begin
        if (ce == 1'b0) begin
            pc <= 32'b0;
        end else if (rst == 1'b1) begin
            ce <= 1'b0;
        end else if (rst == 1'b0) begin
            ce <= 1'b1;
        end else if (stall[0] == 1'b1) begin
                    end else if (flush == 1'b1) begin
            pc <= new_pc;
        end else if (branch_flag_i == 1'b1) begin
            pc <= branch_target_address_i;
        end else begin
            pc <= new_pc;
        end
    end
endmodule
