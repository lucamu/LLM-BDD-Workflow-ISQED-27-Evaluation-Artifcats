// =============================================================================
// Module: TopModule
// Purpose: Sequence detector for the pattern "0110" (with overlap support)
//          operating on a data stream that is gated by a data_valid signal.
//          Only samples where data_valid=1 are considered part of the stream;
//          samples where data_valid=0 are ignored (state holds, match forced 0).
//
// State encoding (Mealy-style transition table implemented as Moore FSM with
// registered "match" pulse that is high exactly one cycle after the 4th
// matching valid sample is processed):
//
//   S_IDLE : no relevant prefix matched yet
//   S_0    : last relevant bit sequence ends in "0"
//   S_01   : last relevant bit sequence ends in "01"
//   S_011  : last relevant bit sequence ends in "011"
//   S_0110 : full pattern "0110" just completed (match cycle)
// =============================================================================

module TopModule (
    input  wire clk,
    input  wire rst_n,
    input  wire data,
    input  wire data_valid,
    output reg  match
);

    // -------------------------------------------------------------------
    // State encoding
    // -------------------------------------------------------------------
    localparam [2:0] S_IDLE = 3'd0, // no progress
                      S_0    = 3'd1, // seen "0"
                      S_01   = 3'd2, // seen "01"
                      S_011  = 3'd3, // seen "011"
                      S_0110 = 3'd4; // seen "0110" (match state)

    reg [2:0] state, next_state;

    // -------------------------------------------------------------------
    // Combinational next-state logic (based on overlapping-pattern FSM)
    // This logic is evaluated regardless of data_valid; it is only
    // committed to the state register when data_valid=1 (see sequential
    // block below), implementing the "ignore invalid samples" behavior.
    // -------------------------------------------------------------------
    always @(*) begin
        case (state)
            // Scenario: sequence_detection - building toward "0110"
            S_IDLE: begin
                if (data == 1'b0)
                    next_state = S_0;    // saw first '0'
                else
                    next_state = S_IDLE; // stay, no progress on '1'
            end

            S_0: begin
                if (data == 1'b0)
                    next_state = S_0;    // stay on repeated '0'
                else
                    next_state = S_01;   // saw "01"
            end

            S_01: begin
                if (data == 1'b0)
                    next_state = S_0;    // "010" -> longest useful suffix is "0"
                else
                    next_state = S_011;  // saw "011"
            end

            S_011: begin
                if (data == 1'b0)
                    next_state = S_0110; // completes "0110" -> match cycle
                else
                    next_state = S_IDLE; // "0111" -> no useful suffix
            end

            // Scenario: overlap - after a match, allow overlapping detection
            S_0110: begin
                if (data == 1'b0)
                    next_state = S_0;    // "01100" -> longest suffix "0"
                else
                    next_state = S_01;   // "01101" -> longest suffix "01"
            end

            default: next_state = S_IDLE; // safety default, avoids latches
        endcase
    end

    // -------------------------------------------------------------------
    // Sequential logic: state register and registered "match" output.
    //   - Reset scenario: rst_n=0 forces state to S_IDLE and match to 0.
    //   - data_valid scenario: when data_valid=0, state holds its value
    //     and match is forced to 0 (invalid samples ignored / no match
    //     asserted on invalid cycles).
    //   - When data_valid=1, state advances per next_state, and match
    //     is asserted exactly when the new state is S_0110 (i.e., the
    //     4th matching sample of "0110" was just processed).
    // -------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // @reset: Reset forces match to zero
            state <= S_IDLE;
            match <= 1'b0;
        end
        else if (data_valid) begin
            // Valid sample: advance FSM and compute match for this cycle
            state <= next_state;
            // match asserted only if transition completes "0110"
            match <= (next_state == S_0110);
        end
        else begin
            // @data_valid: invalid sample -> hold state, force match low
            state <= state;
            match <= 1'b0;
        end
    end

endmodule