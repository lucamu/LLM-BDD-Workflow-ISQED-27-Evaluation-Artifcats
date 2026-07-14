// ============================================================================
// Module: TopModule
// Purpose: Gshare branch predictor with 7-bit global history register and a
//          128-entry table of 2-bit saturating counters (PHT). Supports
//          simultaneous prediction and training with correct priority and
//          read-before-write timing semantics.
// ============================================================================
module TopModule (
    input        clk,
    input        areset,
    input        predict_valid,
    input  [6:0] predict_pc,
    output       predict_taken,
    output [6:0] predict_history,

    input        train_valid,
    input        train_taken,
    input        train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

    // -------------------------------------------------------------------
    // Internal state
    // -------------------------------------------------------------------
    reg [6:0] history;          // Global history register
    reg [1:0] pht [0:127];      // 128-entry pattern history table

    integer i;

    // -------------------------------------------------------------------
    // Combinational index computation
    // -------------------------------------------------------------------
    wire [6:0] predict_index = predict_pc ^ history;      // Scenario: predict index = pc xor history
    wire [6:0] train_index   = train_pc   ^ train_history; // Scenario: train index = pc xor history

    // -------------------------------------------------------------------
    // Combinational prediction outputs
    // -------------------------------------------------------------------
    // Scenario: predict_taken = MSB of PHT entry at predict_index
    // Scenario: Same-cycle prediction reads pre-training PHT state (read-before-write)
    //           -> since pht is read combinationally from the current register
    //           contents (updated only on clk edge), this naturally reads the
    //           pre-update value even if predict_index == train_index.
    assign predict_taken    = pht[predict_index][1];

    // Scenario: predict_history equals the current history register value
    assign predict_history  = history;

    // -------------------------------------------------------------------
    // Sequential history register update
    // -------------------------------------------------------------------
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Scenario: Asynchronous reset clears the history register immediately
            history <= 7'b0;
        end else begin
            if (train_valid && train_mispredicted) begin
                // Scenario: Misprediction recovery takes precedence over a
                // concurrent prediction
                history <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                // Scenario: History register shifts in predicted outcome
                // when only predicting (also covers training w/o
                // misprediction not overriding prediction's history update)
                history <= {history[5:0], predict_taken};
            end else begin
                // Scenario: History register holds its value when neither
                // predicting nor training
                history <= history;
            end
        end
    end

    // -------------------------------------------------------------------
    // Sequential PHT update (asynchronous reset initializes all entries)
    // -------------------------------------------------------------------
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Scenario: Asynchronous reset initializes every PHT entry to
            // weakly not-taken (2'b00)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b00;
            end
        end else begin
            if (train_valid) begin
                if (train_taken) begin
                    // Scenario: Training a taken outcome increments the
                    // saturating counter unless already saturated high
                    if (pht[train_index] != 2'b11)
                        pht[train_index] <= pht[train_index] + 2'b01;
                    else
                        pht[train_index] <= 2'b11; // Saturated high, unchanged
                end else begin
                    // Scenario: Training a not-taken outcome decrements the
                    // saturating counter unless already saturated low
                    if (pht[train_index] != 2'b00)
                        pht[train_index] <= pht[train_index] - 2'b01;
                    else
                        pht[train_index] <= 2'b00; // Saturated low, unchanged
                end
                // Scenario: Training does not modify PHT entries other than
                // the trained index (implicit: only pht[train_index] is
                // assigned; all other entries retain their register value)
            end
            // If train_valid == 0, all pht entries hold their current value
            // (no explicit assignment needed since this is a register array
            // and unassigned entries retain state).
        end
    end

endmodule