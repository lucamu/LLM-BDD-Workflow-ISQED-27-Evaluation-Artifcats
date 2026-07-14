// ============================================================================
// Module:      TopModule
// Purpose:     Implements a level-sensitive D latch. When ena is asserted,
//              q is transparent and follows d combinationally. When ena is
//              deasserted, q retains its previously latched value. No clock
//              or reset exists; behavior is defined relative to the implicit
//              sensitivity event @(d or ena).
// ============================================================================
module TopModule (
    input  d,
    input  ena,
    output q
);

    // Internal register to hold latched state (models the latch storage element)
    reg q_reg;

    // ------------------------------------------------------------------------
    // Implicit evaluation event: triggered on any change to d or ena
    // ------------------------------------------------------------------------
    always @(d or ena) begin
        // @transparent_mode / @combinational_equivalence:
        // When ena is high, q becomes transparent to d immediately.
        if (ena)
            q_reg = d;
        // @hold_mode / @combinational_hold_equivalence / @no_glitch_while_disabled
        // / @idle_stability:
        // When ena is low, no assignment occurs here -- q_reg intentionally
        // retains its previous value (latch behavior), independent of d.
        // (No else branch: this is the deliberate latch inference.)

        // @enable_transition_high_to_low: at the moment ena falls, this event
        // fires with ena==0, so the branch above is skipped and q_reg keeps
        // the value it had (equal to D from when ena was last high).

        // @enable_transition_low_to_high: at the moment ena rises, this event
        // fires with ena==1, so q_reg = d executes immediately, making q
        // transparent to the new d value.

        // @simultaneous_change: if d and ena change together and ena resolves
        // to 1 at this event, q_reg = d captures the new D value directly.
    end

    // Combinational output assignment
    assign q = q_reg;

endmodule