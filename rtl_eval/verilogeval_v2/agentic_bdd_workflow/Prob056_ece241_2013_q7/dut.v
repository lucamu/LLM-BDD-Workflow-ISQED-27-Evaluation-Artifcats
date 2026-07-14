// =============================================================
// Module: TopModule
// Purpose: Implements a JK Flip-Flop with synchronous behavior
//          on the positive edge of clk, per the following truth
//          table:
//              J K | Q(next)
//              0 0 | Qold      (@hold_state)
//              0 1 | 0         (@reset_output)
//              1 0 | 1         (@set_output)
//              1 1 | ~Qold     (@toggle_output)
//          Q remains unchanged when no rising edge occurs
//          (@no_change_without_edge). The general behavior is
//          captured by the boolean expression:
//              Q_next = (j & ~k) | (~j & ~k & Qold) | (j & k & ~Qold)
//          (@general_truth_table)
// =============================================================
module TopModule (
    input  clk,
    input  j,
    input  k,
    output Q
);

    // Internal register to hold the flip-flop state
    reg Q_reg;

    // Assign output from internal register (registered output)
    assign Q = Q_reg;

    // Sequential logic: update Q_reg only on rising edge of clk
    // @no_change_without_edge: since this is a clocked always block,
    // Q_reg only changes at posedge clk, remaining stable otherwise.
    always @(posedge clk) begin
        case ({j, k})
            2'b00: Q_reg <= Q_reg;      // @hold_state: J=0,K=0 -> hold Qold
            2'b01: Q_reg <= 1'b0;       // @reset_output: J=0,K=1 -> reset to 0
            2'b10: Q_reg <= 1'b1;       // @set_output: J=1,K=0 -> set to 1
            2'b11: Q_reg <= ~Q_reg;     // @toggle_output: J=1,K=1 -> toggle
            default: Q_reg <= Q_reg;    // Safety default (should never occur)
        endcase
        // @general_truth_table: equivalent boolean expression
        // Q_reg <= (j & ~k) | (~j & ~k & Q_reg) | (j & k & ~Q_reg);
        // The case statement above implements this exact behavior.
    end

endmodule