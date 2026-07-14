// ============================================================================
// Module: TopModule
// Purpose: Combinational constant output driver.
//          Always drives output "one" to logic high (1'b1), regardless of
//          any internal state or external stimulus (there are none).
//
// Scenarios implemented:
//   - Output one is always logic high
//   - Output one never deasserts (invariant across all cycles)
//   - Output one is independent of any input conditions
// ============================================================================
module TopModule (
    output one
);

    // Scenario: Output one is always logic high
    // Scenario: Output one never deasserts (holds true every cycle since
    //           this is a pure combinational constant driver with no state)
    // Scenario: Output one is independent of any input conditions
    //           (no inputs exist, so the value cannot depend on stimulus)
    assign one = 1'b1;

endmodule