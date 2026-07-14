module TopModule (
    input  logic clk,
    input  logic rst_n,
    input  logic a,
    output logic match
);

    logic [8:0] shift_reg;

    always @(posedge clk) begin
        if (!rst_n)
            shift_reg <= 9'b0;
        else
            shift_reg <= {shift_reg[7:0], a};
    end

    assign match = (shift_reg[8:6] == 3'b011) && (shift_reg[2:0] == 3'b110);

endmodule