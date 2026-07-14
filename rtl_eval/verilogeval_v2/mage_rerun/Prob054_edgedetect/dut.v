module TopModule (
    input  logic       clk,
    input  logic [7:0] in,
    output logic [7:0] pedge
);

    logic [7:0] prev;
    logic [7:0] pedge_reg;

    initial begin
        prev = 8'b0;
        pedge_reg = 8'b0;
    end

    always @(posedge clk) begin
        prev <= in;
    end

    always @(posedge clk) begin
        pedge_reg <= (~prev) & in;
    end

    assign pedge = pedge_reg;

endmodule