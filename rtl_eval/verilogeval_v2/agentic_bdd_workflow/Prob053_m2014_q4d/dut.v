// ============================================================================
// Module: TopModule
// Purpose: XOR Feedback D Flip-Flop
//          Implements a single positive-edge-triggered D flip-flop whose
//          data input D is the combinational XOR of the external signal
//          'in' and the flip-flop's own registered output 'out'.
//          No reset is present, so the initial value of 'out' is
//          unconstrained (as required by @no_reset scenario).
// ============================================================================
module TopModule (
    input  wire clk,
    input  wire in,
    output wire out
);

    // ------------------------------------------------------------------
    // Registered output storage element.
    // No reset signal exists in this design (per @no_reset scenario),
    // so 'out_reg' initial value is unconstrained/arbitrary.
    // ------------------------------------------------------------------
    reg out_reg;

    // ------------------------------------------------------------------
    // @combinational @feedback
    // Combinational XOR gate: computes the D input of the flip-flop
    // from the current 'in' and the current registered 'out' value.
    // D = in_curr XOR out_curr
    // ------------------------------------------------------------------
    wire d_next;
    assign d_next = in ^ out_reg;

    // ------------------------------------------------------------------
    // Sequential logic: positive-edge-triggered flip-flop, no reset.
    //
    // @sequential @toggle    : when in=1, out_reg <= NOT out_curr
    // @sequential @hold      : when in=0, out_reg <= out_curr
    // @sequential @general   : out_reg <= in_curr XOR out_curr (covers all cases)
    // @sequential @stability : out_reg only updates on posedge clk;
    //                          between edges it remains unchanged since
    //                          this is the only assignment to out_reg.
    // @sequential @multi_cycle : two successive posedges apply the XOR
    //                            update twice, yielding
    //                            out_after_2 = in_second XOR (in_first XOR out_curr)
    // ------------------------------------------------------------------
    always @(posedge clk) begin
        out_reg <= d_next; // Non-blocking assignment for sequential update
    end

    // ------------------------------------------------------------------
    // Output assignment: 'out' reflects the current registered state.
    // ------------------------------------------------------------------
    assign out = out_reg;

endmodule