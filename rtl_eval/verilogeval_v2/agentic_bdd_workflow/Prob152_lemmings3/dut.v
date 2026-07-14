// ============================================================================
// Module: TopModule
// Purpose: Lemmings walking/falling/digging finite state machine.
//          Implements direction-switch on bump, falling when ground is lost,
//          digging on request (only while grounded and walking), and resuming
//          the stored walking direction after falling or after falling out
//          of a dig. Reset (async, active high) forces walk_left state.
// ============================================================================
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    input  wire dig,
    output wire walk_left,
    output wire walk_right,
    output wire aaah,
    output wire digging
);

    // ------------------------------------------------------------------
    // State encoding: remembers walking direction even while falling/digging
    // so that the Lemming resumes the correct direction afterward.
    // ------------------------------------------------------------------
    localparam [2:0] WALK_LEFT  = 3'd0;
    localparam [2:0] WALK_RIGHT = 3'd1;
    localparam [2:0] FALL_LEFT  = 3'd2;
    localparam [2:0] FALL_RIGHT = 3'd3;
    localparam [2:0] DIG_LEFT   = 3'd4;
    localparam [2:0] DIG_RIGHT  = 3'd5;

    reg [2:0] state, next_state;

    // ------------------------------------------------------------------
    // Combinational next-state logic
    // ------------------------------------------------------------------
    always @(*) begin
        next_state = state; // default: hold state (no latch, full coverage below)
        case (state)

            // @walk scenarios, @fall @ground_loss, @dig @start,
            // @priority @fall_over_dig, @priority @dig_over_bump
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALL_LEFT;        // fall takes priority over dig
                else if (dig)
                    next_state = DIG_LEFT;         // dig takes priority over bump
                else if (bump_left)
                    next_state = WALK_RIGHT;       // switch direction on left bump
                else
                    next_state = WALK_LEFT;        // stay walking left (right bump ignored)
            end

            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALL_RIGHT;       // fall takes priority over dig
                else if (dig)
                    next_state = DIG_RIGHT;        // dig takes priority over bump
                else if (bump_right)
                    next_state = WALK_LEFT;        // switch direction on right bump
                else
                    next_state = WALK_RIGHT;       // stay walking right (left bump ignored)
            end

            // @fall @bump_ignored, @fall @resume_left, @fall @same_cycle_bump
            FALL_LEFT: begin
                if (ground)
                    next_state = WALK_LEFT;        // resume walking left when ground returns
                else
                    next_state = FALL_LEFT;        // keep falling, bumps/dig ignored
            end

            // @fall @bump_ignored, @fall @resume_right
            FALL_RIGHT: begin
                if (ground)
                    next_state = WALK_RIGHT;       // resume walking right when ground returns
                else
                    next_state = FALL_RIGHT;       // keep falling, bumps/dig ignored
            end

            // @dig @continue, @dig @fall_transition, @dig @bump_ignored,
            // @dig @resume_left (transition into FALL_LEFT here)
            DIG_LEFT: begin
                if (!ground)
                    next_state = FALL_LEFT;        // ground disappears while digging -> fall
                else
                    next_state = DIG_LEFT;         // keep digging, bumps/dig req ignored
            end

            // @dig @continue, @dig @fall_transition, @dig @bump_ignored,
            // @dig @resume_right (transition into FALL_RIGHT here)
            DIG_RIGHT: begin
                if (!ground)
                    next_state = FALL_RIGHT;       // ground disappears while digging -> fall
                else
                    next_state = DIG_RIGHT;        // keep digging, bumps/dig req ignored
            end

            default: next_state = WALK_LEFT;       // safe default, unreachable in practice

        endcase
    end

    // ------------------------------------------------------------------
    // Sequential state register with asynchronous active-high reset
    // @reset @async, @reset @sync
    // ------------------------------------------------------------------
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;    // async reset forces walk-left state
        else
            state <= next_state;   // synchronous state update
    end

    // ------------------------------------------------------------------
    // Moore outputs derived directly from state
    // @invariant @mutual_exclusion, @invariant @no_dig_without_ground
    // ------------------------------------------------------------------
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT)  || (state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT)   || (state == DIG_RIGHT);

endmodule