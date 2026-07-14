//=============================================================================
// Module: TopModule
// Purpose: Decade counter (0-9) with synchronous reset and slow enable.
//          Increments on each clock edge when slowena is high, wraps from
//          9 back to 0, holds value when slowena is low, and resets
//          synchronously to 0 when reset is asserted (reset has priority).
//=============================================================================
module TopModule (
    input        clk,
    input        slowena,
    input        reset,
    output [3:0] q
);

    // Registered output holding the current decade count (0-9)
    reg [3:0] q_reg;

    always @(posedge clk) begin
        if (reset) begin
            // @reset, @reset @priority: synchronous reset forces q to 0,
            // regardless of slowena value (reset has priority)
            q_reg <= 4'b0000;
        end
        else if (slowena) begin
            // @increment, @wraparound: only update when slowena is high
            if (q_reg == 4'b1001) begin
                // @wraparound: wrap from 9 back to 0
                q_reg <= 4'b0000;
            end
            else begin
                // @increment: increment count when below 9
                q_reg <= q_reg + 4'b0001;
            end
        end
        else begin
            // @pause: hold current value when slowena is low
            q_reg <= q_reg;
        end
    end

    // @range, @range @invariant, @noxstate: q_reg is always driven to a
    // value in [0,9] by construction (reset, increment, wraparound, hold),
    // so q never takes on invalid BCD values (4'b1010 - 4'b1111).
    assign q = q_reg;

endmodule