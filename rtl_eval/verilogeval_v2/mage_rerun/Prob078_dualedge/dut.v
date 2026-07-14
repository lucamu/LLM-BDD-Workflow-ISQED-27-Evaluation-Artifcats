module TopModule (
    input  logic clk,
    input  logic d,
    output logic q
);

    logic qp; // captured on posedge clk
    logic qn; // captured on negedge clk

    initial begin
        qp = 1'b0;
        qn = 1'b0;
    end

    always @(posedge clk) begin
        qp <= d;
    end

    always @(negedge clk) begin
        qn <= d;
    end

    always @(*) begin
        if (clk)
            q = qp;
        else
            q = qn;
    end

endmodule