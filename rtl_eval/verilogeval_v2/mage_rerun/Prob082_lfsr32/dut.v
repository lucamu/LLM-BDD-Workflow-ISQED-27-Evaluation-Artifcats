module TopModule (
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] q
);

    logic [31:0] q_next;

    // Combinational next-state logic implementing Galois LFSR taps at bit positions 32, 22, 2, 1
    // (1-indexed) which correspond to 0-indexed bits 31, 21, 1, 0.
    always @(*) begin
        q_next[31] = q[0];
        for (int i = 0; i < 31; i = i + 1) begin
            if (i == 21 || i == 1 || i == 0)
                q_next[i] = q[i+1] ^ q[0];
            else
                q_next[i] = q[i+1];
        end
    end

    // Sequential logic: synchronous active-high reset to 32'h1
    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= q_next;
    end

endmodule