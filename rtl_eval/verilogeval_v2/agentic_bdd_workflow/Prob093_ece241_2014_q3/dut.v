// Module: TopModule
// Purpose: Generates the four data inputs (mux_in[3:0]) for an external
//          4-to-1 mux (selected by {a,b}) so that the composite circuit
//          realizes the specified Karnaugh map, using only combinational
//          logic driven by c and d.
module TopModule (
    input        c,
    input        d,
    output [3:0] mux_in
);

    // Scenario: mux_in[0] implements the ab=00 column -> (C or D)
    assign mux_in[0] = c | d;

    // Scenario: mux_in[1] implements the ab=01 column -> always 0
    assign mux_in[1] = 1'b0;

    // Scenario: mux_in[2] implements the ab=11 column -> (C and D)
    assign mux_in[2] = c & d;

    // Scenario: mux_in[3] implements the ab=10 column -> (C or (not D))
    assign mux_in[3] = c | ~d;

    // Scenario: bus_consistency - mux_in matches {(C or ~D), (C and D), 0, (C or D)}
    // This is implicitly satisfied by the four assignments above.

endmodule