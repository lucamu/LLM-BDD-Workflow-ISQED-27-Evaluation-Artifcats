//=============================================================================
// Module: TopModule
// Purpose: Purely combinational wire-connection module.
//          Directly mirrors each input to its corresponding output(s)
//          with no internal state, clocking, or reset logic.
//
// Mapping:
//   w = a   (Scenario: Output w mirrors input a)
//   x = b   (Scenario: Output x mirrors input b)
//   y = b   (Scenario: Output y mirrors input b)
//   z = c   (Scenario: Output z mirrors input c)
//
// Since x and y both derive from b, they are always equal
// (Scenario: Outputs x and y are always equal since both derive from b).
//
// Each output depends on exactly one input, ensuring independence
// from the other two inputs (Scenarios: independence checks).
//=============================================================================
module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

    // Scenario: Output w mirrors input a
    // Scenario: Output w is independent of inputs b and c
    assign w = a;

    // Scenario: Output x mirrors input b
    // Scenario: Outputs x and y are independent of inputs a and c
    assign x = b;

    // Scenario: Output y mirrors input b
    // Scenario: Outputs x and y are always equal since both derive from b
    // Scenario: Outputs x and y are independent of inputs a and c
    assign y = b;

    // Scenario: Output z mirrors input c
    // Scenario: Output z is independent of inputs a and b
    assign z = c;

    // Scenario: All outputs simultaneously reflect their mapped inputs
    // (Satisfied automatically by the four continuous assignments above,
    //  since they are combinational and always active concurrently.)

endmodule