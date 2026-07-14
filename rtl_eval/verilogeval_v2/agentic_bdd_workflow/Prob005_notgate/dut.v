// ============================================================================
// Module: TopModule
// Purpose: Implements a pure combinational NOT gate.
//          The output 'out' is always the logical inverse of input 'in'.
//          No clock, no reset, no internal state (no-latch, memoryless).
// ============================================================================
module TopModule (
    input  in,
    output out
);

    // @core @inversion, @boundary @low, @boundary @high,
    // @invariant @no-latch, @totality @single-bit
    //
    // Continuous assignment guarantees:
    //  - out is always NOT(in)      -> satisfies core inversion scenario
    //  - in=0 -> out=1              -> satisfies boundary/low scenario
    //  - in=1 -> out=0              -> satisfies boundary/high scenario
    //  - out depends only on current in, no stored state -> no-latch scenario
    //  - out is always a valid single bit (0 or 1) when in is 0/1 -> totality scenario
    //
    // @consistency @double-negation is satisfied structurally: feeding 'out'
    // through an identical NOT operation externally (out2 = ~out = ~(~in) = in)
    // reproduces the original input, since this module's logic is a pure
    // bitwise inversion with no hidden state.
    assign out = ~in;

endmodule