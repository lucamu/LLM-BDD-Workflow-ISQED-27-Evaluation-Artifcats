module Compare2 (
    input  logic [7:0] data_a,
    input  logic [7:0] data_b,
    output logic [7:0] data_min
);

    always @(*) begin
        if (data_a < data_b)
            data_min = data_a;
        else
            data_min = data_b;
    end

endmodule


module TopModule (
    input  logic clk,
    input  logic rst_n,
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  logic [7:0] c,
    output logic [7:0] d
);

    logic [7:0] min_ab;
    logic [7:0] min_abc;

    // First submodule instance: compare a and b
    Compare2 cmp1 (
        .data_a(a),
        .data_b(b),
        .data_min(min_ab)
    );

    // Second submodule instance: compare min(a,b) and c
    Compare2 cmp2 (
        .data_a(min_ab),
        .data_b(c),
        .data_min(min_abc)
    );

    // Sequential logic: register the minimum value output
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            d <= 8'd0;
        else
            d <= min_abc;
    end

endmodule