//------------------------------------------------------------------------
// Module: TopModule
// Purpose: Implements a 4-input combinational function of a, b, c, d
//          defined by the given Karnaugh map. Purely combinational,
//          no clock or reset.
//
// Minimized SOP form:
//   out = (~b & ~c) | (~a & ~d) | (a & ~b & d) | (b & c & d)
//------------------------------------------------------------------------
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // @main @full_equation
    // Combinational assignment implementing the full minimized equation.
    // This single expression also satisfies all row/column scenarios
    // (@row_cd_00, @row_cd_01, @row_cd_11, @row_cd_10,
    //  @column_ab_00, @column_ab_01, @column_ab_11, @column_ab_10)
    // since it is a pure function of a, b, c, d evaluated for all
    // possible input combinations.
    //
    // @combinational_purity: Because this is a continuous assignment
    // with no memory elements (no clock/reset), out always reflects
    // the current values of a, b, c, d with no dependency on time/history.
    assign out = (~b & ~c) | (~a & ~d) | (a & ~b & d) | (b & c & d);

endmodule