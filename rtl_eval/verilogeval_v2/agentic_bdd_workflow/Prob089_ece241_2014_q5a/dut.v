// ============================================================================
// Module: TopModule
// Purpose: Serial 2's-complement converter modeled as a Moore state machine.
//          Processes serial input x (LSB-first) and produces output z equal
//          to the corresponding 2's-complement bit. Two states:
//            FIND_ONE - initial state, passes bits through unchanged until
//                       the first 1-bit is found
//            INVERT   - after first 1-bit found, inverts all subsequent bits
//          Reset (areset) is asynchronous, active-high, forcing FIND_ONE.
// ============================================================================
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // State encoding
    localparam FIND_ONE = 1'b0;
    localparam INVERT   = 1'b1;

    reg state, next_state;

    // ------------------------------------------------------------------
    // Sequential state register with asynchronous active-high reset
    // Scenario @reset: areset immediately forces FIND_ONE, async, no
    // dependency on clk edge.
    // ------------------------------------------------------------------
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= FIND_ONE;          // Async reset -> FIND_ONE
        else
            state <= next_state;        // Normal state update on clk edge
    end

    // ------------------------------------------------------------------
    // Next-state combinational logic
    // Scenario @state_transition_function:
    //   FIND_ONE, x=0 -> FIND_ONE
    //   FIND_ONE, x=1 -> INVERT
    //   INVERT, any x -> INVERT (sticky, scenario @sticky_invert)
    // ------------------------------------------------------------------
    always @(*) begin
        case (state)
            FIND_ONE: begin
                if (x)
                    next_state = INVERT;    // @first_one: first 1 found
                else
                    next_state = FIND_ONE;  // @passthrough: still zeros
            end
            INVERT: begin
                next_state = INVERT;        // @sticky_invert: stay in INVERT
            end
            default: begin
                next_state = FIND_ONE;      // Safety default (unreachable)
            end
        endcase
    end

    // ------------------------------------------------------------------
    // Moore output logic: depends only on current state (registered),
    // not on next state, matching Moore machine semantics.
    // Scenario @moore_output_function:
    //   z = x       when state == FIND_ONE  (@passthrough, @first_one)
    //   z = ~x      when state == INVERT    (@invert, @sticky_invert)
    // ------------------------------------------------------------------
    assign z = (state == FIND_ONE) ? x : ~x;

endmodule