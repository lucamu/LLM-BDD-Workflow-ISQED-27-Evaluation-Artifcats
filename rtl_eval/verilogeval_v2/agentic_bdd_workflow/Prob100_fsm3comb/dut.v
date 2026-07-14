// Module: TopModule
// Purpose: Combinational next-state and output logic for a 4-state Moore
//          machine (states A=00, B=01, C=10, D=11). No clock/reset -
//          next_state and out are pure functions of state and in.

module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] next_state_r;
    reg       out_r;

    always @(*) begin
        // Default assignments to avoid latches
        next_state_r = A;
        out_r        = 1'b0;

        case (state)
            // @state_A @transition, @state_A @output
            A: begin
                next_state_r = (in == 1'b0) ? A : B;
                out_r        = 1'b0;
            end

            // @state_B @transition, @state_B @output
            B: begin
                next_state_r = (in == 1'b0) ? C : B;
                out_r        = 1'b0;
            end

            // @state_C @transition, @state_C @output
            C: begin
                next_state_r = (in == 1'b0) ? A : D;
                out_r        = 1'b0;
            end

            // @state_D @transition, @state_D @output
            D: begin
                next_state_r = (in == 1'b0) ? C : B;
                out_r        = 1'b1;
            end

            // Default case (unreachable for 2-bit state, but required
            // to avoid incomplete case / latch inference)
            default: begin
                next_state_r = A;
                out_r        = 1'b0;
            end
        endcase
    end

    // Continuous outputs - purely combinational, no memory
    // (@combinational_purity, @next_state_validity, @output_function)
    assign next_state = next_state_r;
    assign out        = out_r;

endmodule