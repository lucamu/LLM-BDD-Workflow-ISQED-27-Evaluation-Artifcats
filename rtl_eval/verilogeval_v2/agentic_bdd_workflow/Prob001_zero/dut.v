// ============================================================
// Module: TopModule
// Purpose: Constant Zero Output Module
//   Implements a purely combinational circuit with no inputs
//   that always drives the output "zero" to logic LOW (0).
//
// Scenarios implemented:
//   - Output zero is always LOW under all conditions
//   - Output zero never transitions to HIGH (invariant)
//   - Output zero is stable and independent of any external condition
// ============================================================
module TopModule (
    output zero
);

    // Scenario: Output zero is always LOW under all conditions
    // Scenario: Output zero never transitions to HIGH
    // Scenario: Output zero is stable and independent of any external condition
    // Since there are no inputs, zero is tied directly to constant 0,
    // guaranteeing it never depends on any other signal and remains
    // permanently LOW in every state and at every time step.
    assign zero = 1'b0;

endmodule