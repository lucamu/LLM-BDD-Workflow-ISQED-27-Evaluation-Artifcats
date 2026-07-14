// =============================================================================
// Module:      TopModule
// Purpose:     Sequence Detector FSM that detects the bit pattern "1101"
//              on the serial input `data` and asserts `start_shifting`
//              permanently (sticky) once the pattern has been observed.
//              Synchronous active-high reset clears all progress and the
//              sticky output.
// =============================================================================
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output wire start_shifting
);

    // -------------------------------------------------------------------
    // State encoding
    //   S0 - no progress / mismatch restart point
    //   S1 - matched "1"
    //   S2 - matched "11"
    //   S3 - matched "110"
    //   S4 - matched "1101" -> sticky terminal state
    // -------------------------------------------------------------------
    localparam [2:0] S0 = 3'd0,
                      S1 = 3'd1,
                      S2 = 3'd2,
                      S3 = 3'd3,
                      S4 = 3'd4;

    reg [2:0] state, next_state;

    // -------------------------------------------------------------------
    // Sequential state register
    // Scenario @reset: Reset forces start_shifting low
    // Scenario @reset @precedence: Reset takes precedence over a completing match
    // Scenario @reset @clear-progress: Reset clears partial match progress
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset)
            state <= S0;            // synchronous active-high reset clears progress
        else
            state <= next_state;    // normal FSM progression
    end

    // -------------------------------------------------------------------
    // Combinational next-state logic
    // Implements the 1101 pattern search with overlap handling and
    // mismatch restart (Scenarios: exact-match, overlap, restart-after-mismatch,
    // unbounded constant-0 / constant-1 streams)
    // -------------------------------------------------------------------
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0; // waiting for first '1'
            S1: next_state = data ? S2 : S0; // saw "1"
            S2: next_state = data ? S2 : S3; // saw "11" (stay on repeated 1s)
            S3: next_state = data ? S4 : S0; // saw "110"
            S4: next_state = S4;             // sticky: once matched, stay matched
                                              // (Scenario @sticky, @sticky @invariant)
            default: next_state = S0;        // safety default, avoids latches
        endcase
    end

    // -------------------------------------------------------------------
    // Moore output: asserted only in the terminal sticky state S4
    // Scenario @detection @exact-match / @overlap / @restart-after-mismatch
    // -------------------------------------------------------------------
    assign start_shifting = (state == S4);

endmodule