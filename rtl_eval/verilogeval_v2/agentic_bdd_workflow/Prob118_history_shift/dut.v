// ============================================================================
// Module: TopModule
// Purpose: 32-bit Global Branch History Register with Misprediction Rollback
//
// Priority order each clock edge:
//   1. areset (async)        -> clear register to 0
//   2. train_mispredicted    -> load {train_history[30:0], train_taken}
//   3. predict_valid         -> shift {predict_history[30:0], predict_taken}
//   4. otherwise             -> hold current value
// ============================================================================
module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    output [31:0] predict_history,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history
);

    // Internal register holding the global branch history
    reg [31:0] history_reg;

    assign predict_history = history_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Scenario: Asynchronous reset clears history to zero
            // Scenario: Async reset takes effect regardless of clock edge
            history_reg <= 32'h00000000;
        end
        else if (train_mispredicted) begin
            // Scenario: Misprediction loads rollback history with actual outcome
            // Scenario: Misprediction takes precedence over simultaneous prediction
            // Scenario: Misprediction result does not depend on prior predict_history value
            // Scenario: LSB reflects actual outcome after misprediction rollback
            history_reg <= {train_history[30:0], train_taken};
        end
        else if (predict_valid) begin
            // Scenario: Valid prediction shifts predict_taken into LSB
            // Scenario: LSB of predict_history reflects the youngest branch outcome
            history_reg <= {history_reg[30:0], predict_taken};
        end
        else begin
            // Scenario: No prediction and no misprediction holds history constant
            // Scenario: Deasserting reset allows normal operation (hold when idle)
            // Scenario: History remains stable across multiple idle cycles
            history_reg <= history_reg;
        end
    end

endmodule