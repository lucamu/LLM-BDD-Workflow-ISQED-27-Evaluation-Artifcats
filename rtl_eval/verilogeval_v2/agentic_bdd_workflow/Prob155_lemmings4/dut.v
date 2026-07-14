// ============================================================================
// Module: TopModule
// Purpose: Lemmings Finite State Machine Controller
//          Models walking (left/right), falling, digging, direction switching
//          on bumps, and splattering after falling too long, with asynchronous
//          active-high reset that always returns to walk_left.
// ============================================================================
module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding: separate LEFT/RIGHT variants for FALL and DIG so the
    // original walking direction is remembered for resumption after falling
    // or after digging-then-falling (see @falling @direction, @digging @direction).
    localparam WALK_LEFT  = 3'd0;
    localparam WALK_RIGHT = 3'd1;
    localparam FALL_LEFT  = 3'd2;
    localparam FALL_RIGHT = 3'd3;
    localparam DIG_LEFT   = 3'd4;
    localparam DIG_RIGHT  = 3'd5;
    localparam SPLAT      = 3'd6;

    reg [2:0] state, next_state;
    reg [4:0] fall_count, next_fall_count; // counts consecutive cycles spent falling

    // ------------------------------------------------------------------
    // Combinational next-state logic
    // ------------------------------------------------------------------
    always @(*) begin
        case (state)
            // @walking @direction, @falling, @digging, @precedence scenarios
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALL_LEFT;        // Ground disappears -> falling (@falling, @precedence fall>dig)
                else if (dig)
                    next_state = DIG_LEFT;         // Dig takes precedence over bump (@digging @precedence, @precedence dig>bump)
                else if (bump_left)
                    next_state = WALK_RIGHT;       // Bumped left -> switch direction (@walking @direction)
                else
                    next_state = WALK_LEFT;        // Keep walking left
            end

            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALL_RIGHT;       // Ground disappears -> falling (@falling)
                else if (dig)
                    next_state = DIG_RIGHT;        // Dig takes precedence (@digging @precedence)
                else if (bump_right)
                    next_state = WALK_LEFT;        // Bumped right -> switch direction (@walking @direction)
                else
                    next_state = WALK_RIGHT;       // Keep walking right
            end

            DIG_LEFT: begin
                // @digging: continues while ground present; @digging @falling: falls if ground gone
                if (!ground)
                    next_state = FALL_LEFT;        // Dug through ground -> falling, remember LEFT (@digging @direction)
                else
                    next_state = DIG_LEFT;         // Continue digging (@digging)
            end

            DIG_RIGHT: begin
                if (!ground)
                    next_state = FALL_RIGHT;       // Falling, remember RIGHT (@digging @direction)
                else
                    next_state = DIG_RIGHT;        // Continue digging
            end

            FALL_LEFT: begin
                // @falling: bumps have no effect while falling (not referenced here)
                if (ground) begin
                    // @splatter: check fall duration threshold
                    if (fall_count > 20)
                        next_state = SPLAT;        // Fell too long -> splatter
                    else
                        next_state = WALK_LEFT;    // Resume walking left (@falling resumption)
                end else
                    next_state = FALL_LEFT;        // Still falling (@splatter mid-air scenario)
            end

            FALL_RIGHT: begin
                if (ground) begin
                    if (fall_count > 20)
                        next_state = SPLAT;
                    else
                        next_state = WALK_RIGHT;   // Resume walking right (@falling resumption)
                end else
                    next_state = FALL_RIGHT;
            end

            SPLAT: begin
                // @splatter @persistence: stays splattered until reset
                next_state = SPLAT;
            end

            default: next_state = WALK_LEFT;       // Safe default (unreachable)
        endcase
    end

    // ------------------------------------------------------------------
    // Combinational fall counter update
    // Counts consecutive cycles spent in a falling state, used for the
    // splatter threshold check (@splatter scenarios).
    // ------------------------------------------------------------------
    always @(*) begin
        if (state == FALL_LEFT || state == FALL_RIGHT)
            next_fall_count = fall_count + 1'b1;   // Increment while falling
        else
            next_fall_count = 5'd0;                // Reset counter otherwise
    end

    // ------------------------------------------------------------------
    // Sequential state register with asynchronous active-high reset
    // @reset: areset forces walk_left immediately on next clock edge,
    //         regardless of current state or inputs.
    // @splatter @reset: recovers from splattered state via reset as well.
    // ------------------------------------------------------------------
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK_LEFT;   // @reset scenarios
            fall_count <= 5'd0;
        end else begin
            state      <= next_state;
            fall_count <= next_fall_count;
        end
    end

    // ------------------------------------------------------------------
    // Output decoding - mutually exclusive except SPLAT where all are 0
    // (@output_consistency)
    // ------------------------------------------------------------------
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT)  || (state == DIG_RIGHT);

endmodule