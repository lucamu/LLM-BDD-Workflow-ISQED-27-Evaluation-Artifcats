module TopModule (
    input  logic clk,
    input  logic areset,
    input  logic load,
    input  logic ena,
    input  logic [3:0] data,
    output logic [3:0] q
);

    always @(posedge clk, posedge areset) begin
        if (areset)
            q <= 4'b0000;
        else if (load)
            q <= data;
        else if (ena)
            q <= {1'b0, q[3:1]};
        else
            q <= q;
    end

endmodule