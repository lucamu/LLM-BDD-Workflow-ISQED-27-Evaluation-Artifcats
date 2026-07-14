// =============================================================================
// Module: TopModule
// Purpose: 8x1 Shift-Register Memory with Random-Access Read Multiplexer
//   - 8-bit shift register (Q[0]..Q[7]), serial input S, shifts on posedge
//     clk when enable is asserted (Q[0] gets S, Q[1..7] shift from Q[0..6]).
//   - Combinational read mux: Z = Q[{A,B,C}], address MSB=A, LSB=C.
//   - No reset input is defined in this specification (interface has no rst).
// =============================================================================
module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    // Internal shift register bits Q[0]..Q[7]
    reg [7:0] Q;

    // -------------------------------------------------------------------
    // Sequential logic: shift register behavior
    // @shift @enable: when enable=1, shift S into Q[0], propagate down
    // @hold @disable: when enable=0, hold all Q values unchanged
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (enable) begin
            // Scenario: Shift register shifts in S when enable is asserted
            Q[0] <= S;         // Q[0] receives new serial input S_in
            Q[1] <= Q[0];      // Q[1] <= previous Q[0]
            Q[2] <= Q[1];      // Q[2] <= previous Q[1]
            Q[3] <= Q[2];      // Q[3] <= previous Q[2]
            Q[4] <= Q[3];      // Q[4] <= previous Q[3]
            Q[5] <= Q[4];      // Q[5] <= previous Q[4]
            Q[6] <= Q[5];      // Q[6] <= previous Q[5]
            Q[7] <= Q[6];      // Q[7] <= previous Q[6]
        end
        else begin
            // Scenario: Shift register holds its state when enable is deasserted
            Q[0] <= Q[0];
            Q[1] <= Q[1];
            Q[2] <= Q[2];
            Q[3] <= Q[3];
            Q[4] <= Q[4];
            Q[5] <= Q[5];
            Q[6] <= Q[6];
            Q[7] <= Q[7];
        end
    end

    // -------------------------------------------------------------------
    // Combinational logic: address-based read multiplexer
    // @mux @boundary, @mux @address_mapping, @combinational,
    // @independence @enable, @combined @shift_then_read
    // Z is purely combinational function of Q[0..7], A, B, C
    // Address = {A,B,C}, A = MSB, C = LSB
    // -------------------------------------------------------------------
    reg z_comb;

    always @(*) begin
        case ({A, B, C})
            3'b000: z_comb = Q[0]; // Address 000 -> Q[0]
            3'b001: z_comb = Q[1]; // Address 001 -> Q[1]
            3'b010: z_comb = Q[2]; // Address 010 -> Q[2]
            3'b011: z_comb = Q[3]; // Address 011 -> Q[3]
            3'b100: z_comb = Q[4]; // Address 100 -> Q[4]
            3'b101: z_comb = Q[5]; // Address 101 -> Q[5]
            3'b110: z_comb = Q[6]; // Address 110 -> Q[6]
            3'b111: z_comb = Q[7]; // Address 111 -> Q[7]
            default: z_comb = 1'b0; // Default case, should be unreachable
        endcase
    end

    assign Z = z_comb;

endmodule