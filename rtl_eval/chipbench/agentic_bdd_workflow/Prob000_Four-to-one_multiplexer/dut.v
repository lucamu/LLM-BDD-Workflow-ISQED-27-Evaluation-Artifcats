//=============================================================================
// Module: TopModule
// Purpose: 4-to-1 Multiplexer (4:1 MUX)
//          Combinational selection of one of four 2-bit data inputs based
//          on a 2-bit select signal. Output is driven via a continuous
//          assign statement using a ternary-based selection (no latches).
//=============================================================================
module TopModule (
    input  [1:0] d0,
    input  [1:0] d1,
    input  [1:0] d2,
    input  [1:0] d3,
    input  [1:0] sel,
    output [1:0] mux_out
);

    // @combinational @select-d0, @select-d1, @select-d2, @select-d3,
    // @general-selection, @no-latch @sensitivity, @independence
    //
    // Single continuous assign implements the full mux behavior:
    //   sel == 2'b00 -> mux_out = d0  (select-d0 scenario)
    //   sel == 2'b01 -> mux_out = d1  (select-d1 scenario)
    //   sel == 2'b10 -> mux_out = d2  (select-d2 scenario)
    //   sel == 2'b11 -> mux_out = d3  (select-d3 scenario)
    //
    // Since this is a continuous assign, mux_out reacts immediately to
    // any change in d0, d1, d2, d3, or sel (no-latch / sensitivity scenario),
    // and unselected inputs never influence mux_out (independence scenario).
    assign mux_out = (sel == 2'b00) ? d0 :
                      (sel == 2'b01) ? d1 :
                      (sel == 2'b10) ? d2 :
                      d3; // sel == 2'b11 (default case, fully covers all sel values)

endmodule