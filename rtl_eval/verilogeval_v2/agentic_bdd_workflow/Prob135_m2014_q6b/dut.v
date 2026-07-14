// Module: TopModule
// Purpose: Combinational next-state logic for bit y[1] of a 6-state Moore FSM
//          (states A..F encoded in 3-bit vector y). Y1 = next-state y[1]
//          as a function of current state y and input w.
//
// State encoding:
//   A = 3'b000, B = 3'b001, C = 3'b010,
//   D = 3'b011, E = 3'b100, F = 3'b101
module TopModule (
    input  [2:0] y,
    input        w,
    output       Y1
);

    reg Y1_r;

    always @(*) begin
        case (y)
            // @state_A: Next-state y[1] from state A is always 0
            3'b000: Y1_r = 1'b0;

            // @state_B: Next-state y[1] from state B is always 1
            3'b001: Y1_r = 1'b1;

            // @state_C: Next-state y[1] from state C depends on w
            3'b010: Y1_r = w;

            // @state_D: Next-state y[1] from state D is always 0
            3'b011: Y1_r = 1'b0;

            // @state_E: Next-state y[1] from state E depends on w
            3'b100: Y1_r = w;

            // @state_F: Next-state y[1] from state F is always 1
            3'b101: Y1_r = 1'b1;

            // @unused_states: 3'b110 and 3'b111 are unreachable/unconstrained,
            // assign a don't-care default value (0) to avoid latches.
            default: Y1_r = 1'b0;
        endcase
    end

    assign Y1 = Y1_r;

endmodule