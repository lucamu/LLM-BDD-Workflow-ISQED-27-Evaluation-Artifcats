module TopModule (
    input  logic clk,
    input  logic ar,
    input  logic d,
    output logic q
);

    always @(posedge clk, posedge ar) begin
        if (ar)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule