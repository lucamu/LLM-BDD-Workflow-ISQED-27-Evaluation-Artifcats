// ============================================================================
// Module: TopModule
// Purpose: Two-State Moore Machine (OFF/ON) controlled by J and K inputs.
//          - Synchronous, active-high reset forces state to OFF.
//          - OFF -> ON when j=1
//          - ON  -> OFF when k=1
//          - out reflects current state combinationally (Moore output)
// ============================================================================
module TopModule (
    input  wire clk,
    input  wire j,
    input  wire k,
    input  wire reset,
    output wire out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg current_state;
    reg next_state;

    // --------------------------------------------------------------------
    // Combinational next-state logic
    // Scenario: OFF state holds when j is 0
    // Scenario: OFF state transitions to ON when j is 1
    // Scenario: ON state holds when k is 0
    // Scenario: ON state transitions to OFF when k is 1
    // Scenario: State remains within valid state encoding (OFF/ON only)
    // --------------------------------------------------------------------
    always @(*) begin
        case (current_state)
            OFF: begin
                if (j)
                    next_state = ON;   // OFF -> ON when j=1
                else
                    next_state = OFF;  // OFF holds when j=0
            end
            ON: begin
                if (k)
                    next_state = OFF;  // ON -> OFF when k=1
                else
                    next_state = ON;   // ON holds when k=0
            end
            default: next_state = OFF; // safety default, avoids latch
        endcase
    end

    // --------------------------------------------------------------------
    // Sequential state register with synchronous reset
    // Scenario: Synchronous reset forces state to OFF
    // Scenario: Reset output is immediately consistent with OFF state
    // --------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset)
            current_state <= OFF;      // synchronous reset to OFF
        else
            current_state <= next_state;
    end

    // --------------------------------------------------------------------
    // Moore output logic: combinational function of current state only
    // Scenario: Output reflects OFF state combinationally
    // Scenario: Output reflects ON state combinationally
    // Scenario: Output is always a function of current state only
    // --------------------------------------------------------------------
    assign out = (current_state == ON) ? 1'b1 : 1'b0;

endmodule