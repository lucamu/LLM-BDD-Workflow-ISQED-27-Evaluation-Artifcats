module TopModule (
    input  logic clk,
    input  logic aresetn,
    input  logic x,
    output logic z
);

    // State encoding
    localparam S0 = 2'b00; // no match yet
    localparam S1 = 2'b01; // seen '1'
    localparam S2 = 2'b10; // seen '10'

    logic [1:0] state, next_state;

    // Sequential logic: state register with async active-low reset
    always @(posedge clk, negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = (x) ? S1 : S2;
            S2: next_state = (x) ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Mealy output combinational logic
    always @(*) begin
        z = 1'b0;
        case (state)
            S0: z = 1'b0;
            S1: z = 1'b0;
            S2: z = (x) ? 1'b1 : 1'b0;
            default: z = 1'b0;
        endcase
    end

endmodule