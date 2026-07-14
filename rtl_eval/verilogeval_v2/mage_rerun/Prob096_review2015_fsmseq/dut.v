module TopModule (
    input  logic clk,
    input  logic reset,
    input  logic data,
    output logic start_shifting
);

    // State encoding
    localparam S0 = 3'd0; // no match
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '11'
    localparam S3 = 3'd3; // matched '110'
    localparam S4 = 3'd4; // matched '1101' - sticky done state

    logic [2:0] state, state_next;

    // Sequential state register
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= state_next;
    end

    // Combinational next-state logic
    always @(*) begin
        state_next = state;
        case (state)
            S0: state_next = (data) ? S1 : S0;
            S1: state_next = (data) ? S2 : S0;
            S2: state_next = (data) ? S2 : S3;
            S3: state_next = (data) ? S4 : S0;
            S4: state_next = S4; // sticky, stays forever until reset
            default: state_next = S0;
        endcase
    end

    // Combinational output logic
    always @(*) begin
        start_shifting = (state == S4);
    end

endmodule