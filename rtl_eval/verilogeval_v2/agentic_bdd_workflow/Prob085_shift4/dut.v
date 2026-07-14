// ============================================================================
// Module: TopModule
// Purpose: 4-bit right shift register with asynchronous reset, synchronous
//          load and enable. Load has priority over enable when both are
//          asserted. Shifting is right-shift with zero-fill on MSB.
// ============================================================================
module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output [3:0] q
);

    reg [3:0] q_reg;

    assign q = q_reg;

    // Sequential logic with async reset, sync load/ena priority
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Scenario: Asynchronous reset forces output to zero immediately
            // Scenario: Asynchronous reset overrides load and enable at any time
            q_reg <= 4'b0000;
        end
        else begin
            if (load) begin
                // Scenario: Load takes priority over enable when both asserted
                // Scenario: Load overwrites register with data when ena is deasserted
                q_reg <= data;
            end
            else if (ena) begin
                // Scenario: Enable causes right shift with zero fill when load is deasserted
                // Scenario: Shifted-out bit is discarded and not observable in q
                q_reg <= {1'b0, q_reg[3:1]};
            end
            else begin
                // Scenario: Register holds its value when both load and ena are deasserted
                q_reg <= q_reg;
            end
        end
    end

endmodule