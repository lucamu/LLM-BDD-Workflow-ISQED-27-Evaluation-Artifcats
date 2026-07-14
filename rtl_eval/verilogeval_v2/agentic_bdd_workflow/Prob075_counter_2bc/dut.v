// ============================================================================
// Module: TopModule
// Purpose: Two-bit saturating counter for branch prediction.
//          Saturates at 2'b11 (strongly taken) and 2'b00 (strongly not-taken).
//          Asynchronously resets to 2'b01 (weakly not-taken).
// ============================================================================
module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output wire [1:0] state
);

    // Internal registered state
    reg [1:0] state_reg;

    assign state = state_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Scenario: Asynchronous reset forces state to weakly not-taken
            // Scenario: Reset takes priority over training inputs
            // Scenario: State remains at reset value while areset stays asserted
            state_reg <= 2'b01;
        end else begin
            if (!train_valid) begin
                // Scenario: State holds its value when not training
                state_reg <= state_reg;
            end else if (train_taken) begin
                // Scenario: Counter increments toward maximum but saturates at 3
                // Scenario: Incrementing at maximum value does not wrap around
                if (state_reg == 2'b11)
                    state_reg <= 2'b11;
                else
                    state_reg <= state_reg + 2'b01;
            end else begin
                // Scenario: Counter decrements toward minimum but saturates at 0
                // Scenario: Decrementing at minimum value does not wrap around
                if (state_reg == 2'b00)
                    state_reg <= 2'b00;
                else
                    state_reg <= state_reg - 2'b01;
            end
        end
    end

    // Scenario: State value is always within valid two-bit range
    // Guaranteed by construction since state_reg is a 2-bit register
    // and all transitions saturate at 2'b00 and 2'b11.

endmodule