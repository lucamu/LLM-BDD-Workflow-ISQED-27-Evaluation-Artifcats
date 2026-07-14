// ============================================================================
// Module: TopModule
// Purpose: Shift Enable FSM Controller
//          Asserts shift_ena for exactly 4 clock cycles immediately after
//          synchronous reset, then holds shift_ena at 0 until next reset.
// ============================================================================
module TopModule (
    input  wire clk,
    input  wire reset,
    output wire shift_ena
);

    // 3-bit counter: counts cycles since reset deassertion (0..4, saturates at 4)
    // count == 0,1,2,3 -> shift_ena asserted (covers cycle1-cycle4 scenarios)
    // count == 4       -> shift_ena deasserted (covers deassert & persistence scenarios)
    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            // @reset @synchronous, @reinitialization: restart sequence on reset
            count <= 3'd0;
        end else begin
            // Increment until saturating at 4 (persistence scenario keeps it at 4)
            if (count < 3'd4)
                count <= count + 3'd1;
            else
                count <= 3'd4;
        end
    end

    // shift_ena is high while count is 0,1,2,3 (4 cycles: @cycle1-@cycle4, @exactly_four)
    // shift_ena goes low once count reaches 4 (@deassert, @persistence)
    assign shift_ena = (count < 3'd4);

endmodule