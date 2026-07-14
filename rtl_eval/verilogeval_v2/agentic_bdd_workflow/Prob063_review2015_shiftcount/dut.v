// =============================================================================
// Module: TopModule
// Purpose: 4-bit register that acts as a shift register (MSB-first serial-in)
//          or a down counter, depending on control signals shift_ena/count_ena.
//
//          Priority: shift_ena takes precedence over count_ena when both are
//          asserted (behavior in that case is a don't-care per spec, so any
//          consistent choice satisfies the formal scenario).
// =============================================================================
module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output [3:0] q
);

    // Internal register storage
    reg [3:0] q_reg;

    assign q = q_reg;

    always @(posedge clk) begin
        if (shift_ena) begin
            // @shift / @shift_sequence: shift-in data MSB-first
            // q <= {D, Q[3:1]}
            q_reg <= {data, q_reg[3:1]};
        end
        else if (count_ena) begin
            // @count / @count_underflow / @count_sequence: decrement, wraps naturally
            // q <= Q - 1 (4'b0000 - 1 wraps to 4'b1111 due to unsigned subtraction)
            q_reg <= q_reg - 4'b0001;
        end
        else begin
            // @hold: neither control asserted, register holds its value
            q_reg <= q_reg;
        end
        // @dont_care: when shift_ena & count_ena both asserted, shift_ena
        // branch above takes priority; formal spec imposes no constraint here.
    end

    // @stability: q_reg only updates inside the posedge clk block above,
    // so with no clock edge the value remains unchanged (implicit in synchronous design).

endmodule