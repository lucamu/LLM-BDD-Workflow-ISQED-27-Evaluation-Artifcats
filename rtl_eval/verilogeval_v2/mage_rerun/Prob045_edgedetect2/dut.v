module TopModule (
    input  logic       clk,
    input  logic [7:0] in,
    output logic [7:0] anyedge
);

    logic [7:0] prev_in;

    initial begin
        prev_in = 8'b0;
    end

    always @(posedge clk) begin
        prev_in <= in;
    end

    assign anyedge = prev_in ^ in;

endmodule