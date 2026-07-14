// ============================================================================
// Module: TopModule
// Purpose: Single-stage shift register with synchronous load and shift-enable
//          Intended to be chained into an n-bit shift register circuit.
//
// Behavior (on each positive edge of clk):
//   - If L is asserted: Q <= R   (load, highest priority)  @load @priority
//   - Else if E is asserted: Q <= w  (shift in)            @shift
//   - Else: Q holds its previous value                     @hold
//
// Q only changes on positive clk edges (no combinational dependency on
// L, E, R, w between edges).                                @stability @combinational
// ============================================================================
module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output Q
);

    // Registered output storing current stage value
    reg Q_reg;

    // Sequential logic: synchronous load/shift/hold on positive clock edge
    always @(posedge clk) begin
        if (L) begin
            // @load @priority: load takes priority over shift
            // @load @independence: loaded value does not depend on w
            Q_reg <= R;
        end else if (E) begin
            // @shift: shift in w when E asserted and L deasserted
            // @shift @independence: shifted value does not depend on R
            Q_reg <= w;
        end else begin
            // @hold: neither L nor E asserted -> hold previous value
            Q_reg <= Q_reg;
        end
    end

    // Continuous assignment of registered value to output
    // @stability / @combinational: Q only updates on posedge clk
    assign Q = Q_reg;

endmodule