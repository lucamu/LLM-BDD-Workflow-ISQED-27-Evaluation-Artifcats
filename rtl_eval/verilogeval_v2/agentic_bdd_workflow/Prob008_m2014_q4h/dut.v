// ============================================================
// Module: TopModule
// Purpose: Combinational Passthrough Buffer
//          Continuously mirrors input 'in' onto output 'out'
//          with no clock, reset, or internal state.
// ============================================================
module TopModule (
    input  in,
    output out
);

    // @combinational @passthrough @core
    // Output equals input for any symbolic value X
    //
    // @combinational @passthrough @zero
    // When in = 1'b0, out evaluates to 1'b0
    //
    // @combinational @passthrough @one
    // When in = 1'b1, out evaluates to 1'b1
    //
    // @combinational @passthrough @stability
    // Since this is a continuous assignment with no memory elements,
    // out always reflects the current value of in (X1 or X2),
    // regardless of any previous input value.
    //
    // @combinational @passthrough @invariant
    // out depends only on the current value of in (X) and is
    // completely independent of any prior value Y that out may
    // have held, since there is no state or feedback in this design.
    assign out = in;

endmodule