// ============================================================================
// Module: TopModule
// Purpose: Cyclic Sequence Generator producing the repeating 6-bit pattern
//          "001011" (bit0=0, bit1=0, bit2=1, bit3=0, bit4=1, bit5=1) on the
//          registered output 'data'. The sequence position is tracked
//          internally and increments modulo 6 each clock cycle. A synchronous
//          active-low reset restarts the sequence at position 0.
// ============================================================================
module TopModule (
    input  clk,
    input  rst_n,
    output data
);

    // Internal sequence position counter (0 to 5), tracks N modulo 6
    reg [2:0] seq_pos;

    // Registered output
    reg data_reg;

    // -------------------------------------------------------------------
    // Sequential logic: sequence position update
    // Scenario: Reset forces sequence to restart at position 0
    // Scenario: Reset asserted at any arbitrary cycle restarts the sequence
    // Scenario: Sequence position advances by one each cycle modulo 6
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            // Reset scenarios: position immediately goes to 0
            seq_pos <= 3'd0;
        end else begin
            // Cyclic scenario: advance position modulo 6
            if (seq_pos == 3'd5)
                seq_pos <= 3'd0;
            else
                seq_pos <= seq_pos + 3'd1;
        end
    end

    // -------------------------------------------------------------------
    // Sequential logic: output data based on sequence position
    // Scenario: Output at each sequence position (0..5) matches pattern
    // Scenario: Reset forces data to 0
    // Scenario: Output pattern repeats identically every 6 cycles (implied
    //           by the cyclic position update above combined with this
    //           fixed mapping table)
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            // Reset scenario: data must equal 0 upon reset deassertion
            data_reg <= 1'b0;
        end else begin
            case (seq_pos)
                3'd0: data_reg <= 1'b0; // position 0 -> 0
                3'd1: data_reg <= 1'b0; // position 1 -> 0
                3'd2: data_reg <= 1'b1; // position 2 -> 1
                3'd3: data_reg <= 1'b0; // position 3 -> 0
                3'd4: data_reg <= 1'b1; // position 4 -> 1
                3'd5: data_reg <= 1'b1; // position 5 -> 1
                default: data_reg <= 1'b0; // safe default, avoids latch
            endcase
        end
    end

    // Output assignment
    assign data = data_reg;

endmodule