// ============================================================
// Module: TopModule
// Purpose: Combinational passthrough of a 3-bit input vector,
//          also exposing each individual bit as a separate output.
// ============================================================
module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Scenario: Output vector equals input vector (passthrough)
    assign outv = vec;

    // Scenario: Bit o0 reflects bit 0 of input vector
    assign o0 = vec[0];

    // Scenario: Bit o1 reflects bit 1 of input vector
    assign o1 = vec[1];

    // Scenario: Bit o2 reflects bit 2 of input vector
    assign o2 = vec[2];

    // Note: Since outv = vec and {o2,o1,o0} = vec, the consistency
    // scenarios (outv == {o2,o1,o0} and {o2,o1,o0} == V) hold
    // automatically by construction.

endmodule