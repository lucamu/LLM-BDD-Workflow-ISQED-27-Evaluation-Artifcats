// Module: TopModule
// Purpose: Two-state Moore FSM controlling Lemming walking direction.
//          Switches direction whenever bumped on the current walking wall.
module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // ---------------------------------------------------------------
    // Sequential state register with asynchronous active-high reset
    // Scenarios: @reset @async, @reset @hold, @reset @initial
    // ---------------------------------------------------------------
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;      // Async reset forces walk_left immediately
        else
            state <= next_state;     // Normal state update on clk edge
    end

    // ---------------------------------------------------------------
    // Combinational next-state logic
    // Scenarios: @transition @bump_left, @transition @bump_right,
    //            @transition @bump_both, @stability @no_bump,
    //            @stability @bump_right_while_left_ignored,
    //            @stability @bump_left_while_right_ignored
    // ---------------------------------------------------------------
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (bump_left)
                    next_state = WALK_RIGHT; // bumped on left -> switch to right
                else
                    next_state = WALK_LEFT;  // no left bump -> keep walking left
            end
            WALK_RIGHT: begin
                if (bump_right)
                    next_state = WALK_LEFT;  // bumped on right -> switch to left
                else
                    next_state = WALK_RIGHT; // no right bump -> keep walking right
            end
            default: begin
                next_state = WALK_LEFT;      // safe default, avoids latches
            end
        endcase
    end

    // ---------------------------------------------------------------
    // Moore outputs - mutually exclusive and one-hot at all times
    // Scenario: @invariant @mutual_exclusion
    // ---------------------------------------------------------------
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule