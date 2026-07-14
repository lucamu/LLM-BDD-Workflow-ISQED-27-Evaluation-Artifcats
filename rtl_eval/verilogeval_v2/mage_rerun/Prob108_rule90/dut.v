module TopModule(
    input  logic         clk,
    input  logic         load,
    input  logic [511:0] data,
    output logic [511:0] q
);

    logic [511:0] left_neighbor;
    logic [511:0] right_neighbor;
    logic [511:0] next_q;

    always @(*) begin
        // left_neighbor[i] = q[i-1], with q[-1] = 0
        left_neighbor = {q[510:0], 1'b0};
        // right_neighbor[i] = q[i+1], with q[512] = 0
        right_neighbor = {1'b0, q[511:1]};
        next_q = left_neighbor ^ right_neighbor;
    end

    initial begin
        q = 512'b0;
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule