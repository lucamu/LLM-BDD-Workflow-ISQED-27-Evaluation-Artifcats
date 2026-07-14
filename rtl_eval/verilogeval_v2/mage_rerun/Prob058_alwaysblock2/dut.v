module TopModule (
    input  logic clk,
    input  logic a,
    input  logic b,
    output logic out_assign,
    output logic out_always_comb,
    output logic out_always_ff
);

    // Method 1: assign statement
    assign out_assign = a ^ b;

    // Method 2: combinational always block
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Method 3: clocked always block (flip-flop, delayed output)
    initial begin
        out_always_ff = 1'b0;
    end

    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule