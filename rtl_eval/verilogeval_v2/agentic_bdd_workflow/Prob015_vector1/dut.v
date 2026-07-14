// ============================================================================
// Module: TopModule
// Purpose: Combinational Byte Splitter
//          Splits a 16-bit input 'in' into upper byte 'out_hi' (bits [15:8])
//          and lower byte 'out_lo' (bits [7:0]).
//
// Scenarios implemented:
//   - Lower byte equals bits [7:0] of input
//   - Upper byte equals bits [15:8] of input
//   - Concatenation of outputs reconstructs the input
//   - Output byte independence (naturally satisfied by direct bit-slicing)
//   - Purely combinational stability (no clocked storage, always reflects
//     current input)
//   - Boundary cases (all-zero / all-one) follow directly from slicing
// ============================================================================

module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Scenario: Upper byte equals bits [15:8] of input
    // Also ensures independence from low byte (out_hi depends only on in[15:8])
    assign out_hi = in[15:8];

    // Scenario: Lower byte equals bits [7:0] of input
    // Also ensures independence from high byte (out_lo depends only on in[7:0])
    assign out_lo = in[7:0];

    // Scenario: Concatenation of outputs reconstructs the input
    // {out_hi, out_lo} == {in[15:8], in[7:0]} == in  (holds by construction)

    // Scenario: Outputs are purely combinational functions of current input
    // No clock/reset/state used; outputs update immediately with 'in'.

    // Scenario: All-zero input -> out_hi = 8'h00, out_lo = 8'h00 (by slicing)
    // Scenario: All-one input  -> out_hi = 8'hFF, out_lo = 8'hFF (by slicing)

endmodule