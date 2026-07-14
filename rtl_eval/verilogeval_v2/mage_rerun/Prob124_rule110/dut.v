module TopModule (
    input  logic clk,
    input  logic load,
    input  logic [511:0] data,
    output logic [511:0] q
);

    logic [511:0] next_q;
    integer i;

    initial begin
        q = 512'b0;
    end

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            logic L, C, R;
            L = (i == 511) ? 1'b0 : q[i+1];
            C = q[i];
            R = (i == 0) ? 1'b0 : q[i-1];
            next_q[i] = (~L & C) | (~C & R) | (L & C & ~R);
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule