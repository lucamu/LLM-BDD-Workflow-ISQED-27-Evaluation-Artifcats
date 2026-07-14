module TopModule (
    input  logic clk,
    input  logic reset,
    input  logic in,
    output logic out
);

    // State encoding
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    logic state, state_next;

    // State register with synchronous active-high reset to state B
    always @(posedge clk) begin
        if (reset)
            state <= STATE_B;
        else
            state <= state_next;
    end

    // Next-state combinational logic
    always @(*) begin
        if (in == 1'b0)
            state_next = ~state;
        else
            state_next = state;
    end

    // Output combinational logic (Moore)
    always @(*) begin
        out = state;
    end

endmodule