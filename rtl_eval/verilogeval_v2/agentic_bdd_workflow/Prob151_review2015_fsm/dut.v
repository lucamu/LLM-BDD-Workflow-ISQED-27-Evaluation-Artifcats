// =============================================================================
// Module      : TopModule
// Description : Timer Control FSM
//                - Detects serial pattern "1101" on 'data'
//                - Asserts shift_ena for 4 cycles after pattern detection
//                - Asserts counting until done_counting is observed high
//                - Asserts done until ack is observed high, then returns to
//                  the initial pattern-search state
// =============================================================================
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output wire shift_ena,
    output wire counting,
    input  wire done_counting,
    output wire done,
    input  wire ack
);

    // -------------------------------------------------------------------
    // State encoding
    // -------------------------------------------------------------------
    localparam [3:0]
        IDLE0 = 4'd0,  // no bits of pattern matched yet
        S1    = 4'd1,  // matched "1"
        S11   = 4'd2,  // matched "11"
        S110  = 4'd3,  // matched "110"
        SH0   = 4'd4,  // shift cycle 1 (shift_ena=1)
        SH1   = 4'd5,  // shift cycle 2 (shift_ena=1)
        SH2   = 4'd6,  // shift cycle 3 (shift_ena=1)
        SH3   = 4'd7,  // shift cycle 4 (shift_ena=1)
        COUNT = 4'd8,  // counting state
        DONE  = 4'd9;  // done / waiting for ack

    reg [3:0] state, next_state;

    // -------------------------------------------------------------------
    // Sequential state register with synchronous reset
    // Scenario: @reset / @reset @override -> forces FSM to IDLE0
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset)
            state <= IDLE0;                 // synchronous reset to search state
        else
            state <= next_state;
    end

    // -------------------------------------------------------------------
    // Next-state combinational logic
    // -------------------------------------------------------------------
    always @(*) begin
        next_state = state; // default: hold state (avoid latch by covering all cases below)
        case (state)
            // ---------------- Pattern detection: search for "1101" ----------------
            IDLE0: begin
                // @pattern_detection : building the "1101" sequence
                if (data)
                    next_state = S1;
                else
                    next_state = IDLE0;
            end

            S1: begin
                if (data)
                    next_state = S11;
                else
                    next_state = IDLE0; // @pattern_detection @mismatch
            end

            S11: begin
                // @pattern_detection @overlap : extra '1' keeps us in S11 (overlap tracking)
                if (data)
                    next_state = S11;
                else
                    next_state = S110;
            end

            S110: begin
                if (data)
                    next_state = SH0; // pattern "1101" complete -> start shifting
                else
                    next_state = IDLE0; // @pattern_detection @mismatch
            end

            // ---------------- Shift phase: 4 cycles of shift_ena ----------------
            SH0: next_state = SH1; // @shift_duration
            SH1: next_state = SH2;
            SH2: next_state = SH3;
            SH3: next_state = COUNT; // after 4th shift cycle, move to counting

            // ---------------- Counting phase ----------------
            COUNT: begin
                // @counting_wait / @counting_to_done / @stability
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end

            // ---------------- Done / ack handshake ----------------
            DONE: begin
                // @done_wait / @ack_return / @ack_return @resume_search / @stability
                if (ack)
                    next_state = IDLE0;
                else
                    next_state = DONE;
            end

            default: next_state = IDLE0; // safety default, avoids incomplete case
        endcase
    end

    // -------------------------------------------------------------------
    // Output logic (registered via state, Moore-style outputs)
    // Ensures @mutual_exclusion : shift_ena, counting, done never overlap
    // -------------------------------------------------------------------
    assign shift_ena = (state == SH0) || (state == SH1) ||
                        (state == SH2) || (state == SH3);

    assign counting  = (state == COUNT);

    assign done      = (state == DONE);

endmodule