// =============================================================================
// Module: TopModule
// Purpose: 256-to-1 combinational multiplexer.
//          Selects one bit from the 256-bit input vector "in" using the
//          8-bit select signal "sel", such that out = in[sel].
//
// Scenarios implemented:
//   @core          : out equals in[sel] for arbitrary in/sel
//   @boundary      : sel=0   -> out = in[0]  (LSB)
//   @boundary      : sel=255 -> out = in[255] (MSB)
//   @independence  : out depends only on in[sel], not on other bits
//   @sensitivity   : out changes only if sel or the selected bit changes
//   @determinism   : same in/sel always yields same out (pure combinational)
//   @exhaustive    : every distinct sel value maps to its corresponding bit
// =============================================================================

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);

    // -------------------------------------------------------------------
    // Core combinational multiplexer logic.
    // Since this is a pure combinational function of (in, sel), the
    // continuous assignment naturally satisfies:
    //   - @core         : out = in[sel]
    //   - @boundary     : sel=0 -> in[0], sel=255 -> in[255]
    //   - @independence : only in[sel] affects out, other bits are unused
    //   - @sensitivity  : out changes only if sel or in[sel] changes
    //   - @determinism  : identical inputs always produce identical out
    //   - @exhaustive   : each sel value indexes exactly one distinct bit
    // -------------------------------------------------------------------
    assign out = in[sel];

endmodule