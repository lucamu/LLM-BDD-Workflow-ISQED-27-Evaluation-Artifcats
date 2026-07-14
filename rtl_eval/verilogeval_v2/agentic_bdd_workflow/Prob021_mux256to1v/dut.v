// ============================================================================
// Module: TopModule
// Purpose: 256-to-1 4-bit wide multiplexer
//          Selects a 4-bit nibble from a 1024-bit input vector based on
//          an 8-bit select signal.
//
// Behavior:
//   out = in[(sel*4 + 3) : (sel*4)]
//
// Covers all formal scenarios:
//   - core_functionality : general SEL selects correct slice
//   - boundary_low        : sel = 0   -> in[3:0]
//   - boundary_high       : sel = 255 -> in[1023:1020]
//   - specific_index_one  : sel = 1   -> in[7:4]
//   - specific_index_two  : sel = 2   -> in[11:8]
//   - specific_midpoint   : sel = 128 -> in[515:512]
//   - invariance          : only selected bits affect out (guaranteed by
//                           indexed part-select, since only those bits are read)
//   - sensitivity         : changing selected nibble changes out accordingly
//   - determinism         : purely combinational, no state, same inputs ->
//                           same outputs always
// ============================================================================
module TopModule (
    input  [1023:0] in,
    input  [7:0]     sel,
    output [3:0]     out
);

    // Combinational indexed part-select: extracts the 4-bit slice
    // starting at bit position (sel*4), 4 bits wide.
    // This single expression satisfies all scenarios since it is a
    // pure function of 'in' and 'sel' with no internal state (determinism),
    // and only reads the 4 bits addressed by sel (invariance/sensitivity).
    assign out = in[sel*4 +: 4];

endmodule