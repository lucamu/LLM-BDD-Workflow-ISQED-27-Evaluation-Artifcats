// =============================================================
// Module      : TopModule
// Purpose     : Detects the 6-bit sequence 011100 on serial input
//               `data`, processing non-overlapping groups of six
//               clock cycles. At the end of each group (6th cycle)
//               either `match` or `not_match` pulses for one cycle.
// =============================================================
module TopModule (
    input  wire clk,
    input  wire rst_n,
    input  wire data,
    output reg  match,
    output reg  not_match
);

    // ---------------------------------------------------------
    // Internal state
    // ---------------------------------------------------------
    // bit_cnt: position within the current 6-cycle group (0..5)
    reg [2:0] bit_cnt;

    // shift_reg: holds the bits collected so far in this group
    // (bits [4:0] are the previous 5 samples; new data is shifted in)
    reg [4:0] shift_reg;

    // Target sequence to match: 0,1,1,1,0,0
    localparam [5:0] TARGET = 6'b011100;

    // ---------------------------------------------------------
    // Sequential logic
    // ---------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // -----------------------------------------------------------
            // Scenario: Asynchronous reset forces both outputs low
            // Scenario: Reset causes a fresh group to begin on next edge
            // -----------------------------------------------------------
            bit_cnt   <= 3'd0;
            shift_reg <= 5'b00000;
            match     <= 1'b0;
            not_match <= 1'b0;
        end else begin
            // -----------------------------------------------------------
            // Scenario: A new group begins immediately after every
            // completed group, regardless of the result. The current
            // data bit is treated as the first bit of the next group's
            // comparison when bit_cnt wraps back to 0.
            // -----------------------------------------------------------
            if (bit_cnt == 3'd5) begin
                // -------------------------------------------------------
                // Scenario: Match asserts on the sixth cycle when the
                // group equals the target sequence
                // Scenario: Not_match asserts on the sixth cycle when the
                // group differs from the target sequence
                // Scenario: Group still requires exactly six cycles even
                // if the first bit already mismatches
                // -------------------------------------------------------
                if ({shift_reg, data} == TARGET) begin
                    match     <= 1'b1;
                    not_match <= 1'b0;
                end else begin
                    match     <= 1'b0;
                    not_match <= 1'b1;
                end

                // Group complete -> restart counting at position zero
                bit_cnt   <= 3'd0;
                shift_reg <= 5'b00000; // fresh group, first bit not yet stored
            end else begin
                // -------------------------------------------------------
                // Scenario: No output asserts before a group of six
                // cycles completes
                // Scenario: Match or not_match pulses for exactly one
                // clock cycle (cleared here for all non-terminal cycles)
                // -------------------------------------------------------
                match     <= 1'b0;
                not_match <= 1'b0;

                // Shift in the new data bit and advance position counter
                shift_reg <= {shift_reg[3:0], data};
                bit_cnt   <= bit_cnt + 3'd1;
            end
        end
    end

    // -----------------------------------------------------------------
    // Scenario: Match and not_match are mutually exclusive at every
    // clock cycle -- guaranteed by construction above, since only one
    // branch ever sets a 1 into either register per cycle.
    // -----------------------------------------------------------------

endmodule