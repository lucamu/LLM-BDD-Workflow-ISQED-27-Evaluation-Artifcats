// =============================================================================
// Module: TopModule
// Purpose: 64-bit register supporting synchronous load and arithmetic
//          left/right shifts by 1 or 8 bits, controlled by load/ena/amount.
//
// Priority: load (highest) > ena-controlled shift > hold (no change)
//
// amount encoding:
//   2'b00 : shift left  by 1
//   2'b01 : shift left  by 8
//   2'b10 : arithmetic shift right by 1
//   2'b11 : arithmetic shift right by 8
// =============================================================================
module TopModule (
    input        clk,
    input        load,
    input        ena,
    input  [1:0] amount,
    input  [63:0] data,
    output reg [63:0] q
);

    always @(posedge clk) begin
        if (load) begin
            // Scenario: Load takes priority over shifting
            // Scenario: Load overrides shift enable regardless of amount value
            q <= data;
        end
        else if (ena) begin
            case (amount)
                2'b00: begin
                    // Scenario: Shift left by 1 bit when not loading
                    // Scenario: Least significant bit is zero-filled during left shift by 1
                    q <= {q[62:0], 1'b0};
                end
                2'b01: begin
                    // Scenario: Shift left by 8 bits when not loading
                    // Scenario: Least significant 8 bits are zero-filled during left shift by 8
                    q <= {q[55:0], 8'b00000000};
                end
                2'b10: begin
                    // Scenario: Arithmetic shift right by 1 bit when not loading
                    // Scenario: Sign bit is preserved and replicated during arithmetic right shift by 1
                    q <= {q[63], q[63:1]};
                end
                2'b11: begin
                    // Scenario: Arithmetic shift right by 8 bits when not loading
                    // Scenario: Sign bit is preserved and replicated during arithmetic right shift by 8
                    q <= {{8{q[63]}}, q[63:8]};
                end
                default: begin
                    // Should not occur (amount is 2 bits, all cases covered),
                    // but included to avoid incomplete case / latch inference.
                    q <= q;
                end
            endcase
        end
        else begin
            // Scenario: Register holds value when not loading and not enabled
            q <= q;
        end
    end

endmodule