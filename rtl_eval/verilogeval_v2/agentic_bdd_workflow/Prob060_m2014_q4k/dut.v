// ============================================================================
// Module: TopModule
// Purpose: 4-stage shift register with synchronous active-low reset.
//          Data on 'in' propagates through F1 -> F2 -> F3 -> F4 (= out)
//          taking exactly four clock cycles to appear at 'out'.
// ============================================================================
module TopModule (
    input  clk,
    input  resetn,
    input  in,
    output out
);

    // Internal flop chain: F1, F2, F3, F4
    reg F1, F2, F3, F4;

    // Sequential logic: synchronous active-low reset, rising-edge clocked
    always @(posedge clk) begin
        if (!resetn) begin
            // @reset scenarios: force all flops to 0 synchronously,
            // overriding any previously shifted data (also covers
            // @reset_release scenario's reset edge)
            F1 <= 1'b0;
            F2 <= 1'b0;
            F3 <= 1'b0;
            F4 <= 1'b0;
        end else begin
            // @shift / @stability / @reset_release scenarios:
            // shift 'in' into F1, propagate previous values down the chain
            F1 <= in;
            F2 <= F1;
            F3 <= F2;
            F4 <= F3;
        end
    end

    // Output is the last flop in the chain (delayed by 4 cycles)
    assign out = F4;

endmodule