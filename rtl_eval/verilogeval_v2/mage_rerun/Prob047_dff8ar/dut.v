module TopModule (
    input  logic       clk,
    input  logic       areset,
    input  logic [7:0] d,
    output logic [7:0] q
);

    always @(posedge clk, posedge areset) begin
        if (areset)
            q <= 8'b0;
        else
            q <= d;
    end

endmodule