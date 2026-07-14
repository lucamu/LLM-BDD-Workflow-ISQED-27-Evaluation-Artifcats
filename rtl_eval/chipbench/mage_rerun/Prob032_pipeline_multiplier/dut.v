module TopModule (
    input  logic clk,
    input  logic rst_n,
    input  logic [3:0] mul_a,
    input  logic [3:0] mul_b,
    output logic [7:0] mul_out
);

    // Pipeline stage 1: register the inputs
    logic [3:0] stage1_a;
    logic [3:0] stage1_b;

    // Pipeline stage 2: register the multiplication result (this is the output)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_a <= 4'b0;
            stage1_b <= 4'b0;
            mul_out  <= 8'b0;
        end else begin
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            mul_out  <= stage1_a * stage1_b;
        end
    end

endmodule