// ============================================================================
// Module: TopModule
// Purpose: Lemmings walking-direction FSM.
//          Moore machine with states WALK_LEFT, WALK_RIGHT, FALL_LEFT,
//          FALL_RIGHT. Outputs walk_left, walk_right, aaah are derived
//          purely from the current state (Moore outputs), and exactly one
//          of the three outputs is asserted at any time.
// ============================================================================
module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State encoding
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;

    // -------------------------------------------------------------------
    // Sequential state register with asynchronous active-high reset
    // Scenario: "Asynchronous reset forces walk_left state"
    // Scenario: "Reset holds walk_left regardless of inputs"
    // -------------------------------------------------------------------
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;        // reset forces WALK_LEFT state
        else
            state <= next_state;       // normal state transition
    end

    // -------------------------------------------------------------------
    // Combinational next-state logic
    // -------------------------------------------------------------------
    always @(*) begin
        case (state)
            // --------------------------------------------------------
            // WALK_LEFT state
            // --------------------------------------------------------
            WALK_LEFT: begin
                if (!ground)
                    // Scenario: "Losing ground while walking left
                    // transitions to falling and asserts aaah"
                    next_state = FALL_LEFT;
                else if (bump_left)
                    // Scenario: "Bump on left while walking left switches
                    // to walking right" (also covers simultaneous bump
                    // scenario, since bump_right is irrelevant here)
                    next_state = WALK_RIGHT;
                else
                    // Scenario: "Walking left continues when no bump and
                    // ground present" / "Bump on right while walking left
                    // has no effect on direction"
                    next_state = WALK_LEFT;
            end

            // --------------------------------------------------------
            // WALK_RIGHT state
            // --------------------------------------------------------
            WALK_RIGHT: begin
                if (!ground)
                    // Scenario: "Losing ground while walking right
                    // transitions to falling and asserts aaah"
                    next_state = FALL_RIGHT;
                else if (bump_right)
                    // Scenario: "Bump on right while walking right
                    // switches to walking left" (also covers simultaneous
                    // bump scenario, since bump_left is irrelevant here)
                    next_state = WALK_LEFT;
                else
                    // Scenario: "Walking right continues when no bump and
                    // ground present" / "Bump on left while walking right
                    // has no effect on direction"
                    next_state = WALK_RIGHT;
            end

            // --------------------------------------------------------
            // FALL_LEFT state
            // --------------------------------------------------------
            FALL_LEFT: begin
                if (ground)
                    // Scenario: "Ground reappears while falling left
                    // resumes walking left"
                    next_state = WALK_LEFT;
                else
                    // Scenario: "Remaining airborne while falling left
                    // continues to assert aaah" / bump inputs ignored
                    next_state = FALL_LEFT;
            end

            // --------------------------------------------------------
            // FALL_RIGHT state
            // --------------------------------------------------------
            FALL_RIGHT: begin
                if (ground)
                    // Scenario: "Ground reappears while falling right
                    // resumes walking right"
                    next_state = WALK_RIGHT;
                else
                    // Scenario: "Remaining airborne while falling right
                    // continues to assert aaah" / bump inputs ignored
                    next_state = FALL_RIGHT;
            end

            // Default case avoids latches / unreachable state recovery
            default: next_state = WALK_LEFT;
        endcase
    end

    // -------------------------------------------------------------------
    // Moore output logic - derived purely from current state
    // Ensures exactly one of walk_left, walk_right, aaah is high.
    // Scenario: "Aaah is asserted if and only if the current state is a
    // falling state"
    // Scenario: "Walk outputs are mutually exclusive with aaah"
    // -------------------------------------------------------------------
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule