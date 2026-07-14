// ============================================================================
// Module: TopModule
// Purpose: 16-bit register with independent byte-enable write control and
//          synchronous active-low reset.
//
// Behavior:
//   - resetn == 0        : synchronous reset, q <= 16'h0000 (highest priority)
//   - byteena == 2'b11    : both bytes updated, q <= d
//   - byteena == 2'b10    : only upper byte updated, q[15:8] <= d[15:8]
//   - byteena == 2'b01    : only lower byte updated, q[7:0]  <= d[7:0]
//   - byteena == 2'b00    : hold, q <= q (no update)
//   - No clock edge       : q retains its current value (implicit in
//                            registered/flip-flop based design)
// ============================================================================
module TopModule (
    input        clk,
    input        resetn,
    input  [1:0] byteena,
    input  [15:0] d,
    output [15:0] q
);

    // Internal register holding the current value of q
    reg [15:0] q_reg;

    // Sequential logic: triggered on rising edge of clk
    always @(posedge clk) begin
        if (!resetn) begin
            // Scenario: Synchronous reset clears all bits regardless of byteena
            // Scenario: Reset overrides data input independent of its value
            q_reg <= 16'h0000;
        end else begin
            case (byteena)
                2'b11: begin
                    // Scenario: Both bytes updated when byteena is fully asserted
                    q_reg <= d;
                end
                2'b10: begin
                    // Scenario: Only upper byte updated when byteena[1] asserted,
                    // byteena[0] deasserted. Lower byte holds previous value.
                    q_reg[15:8] <= d[15:8];
                    q_reg[7:0]  <= q_reg[7:0];
                end
                2'b01: begin
                    // Scenario: Only lower byte updated when byteena[0] asserted,
                    // byteena[1] deasserted. Upper byte holds previous value.
                    q_reg[7:0]  <= d[7:0];
                    q_reg[15:8] <= q_reg[15:8];
                end
                default: begin
                    // byteena == 2'b00
                    // Scenario: Register holds its value when no byte enable
                    // bits are asserted
                    q_reg <= q_reg;
                end
            endcase
        end
    end

    // Output assignment (registered output)
    assign q = q_reg;

    // Note: Scenario "q remains unchanged without a clock edge" is inherently
    // satisfied because q_reg is a flip-flop that only updates on posedge clk.

endmodule