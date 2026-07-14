module TopModule (
    input  logic clk,
    input  logic areset,
    input  logic bump_left,
    input  logic bump_right,
    output logic walk_left,
    output logic walk_right
);

    // State encoding
    localparam STATE_WALK_LEFT  = 1'b0;
    localparam STATE_WALK_RIGHT = 1'b1;

    logic state, state_next;

    // Sequential state register with asynchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= STATE_WALK_LEFT;
        else
            state <= state_next;
    end

    // Combinational next-state logic
    always @(*) begin
        state_next = state; // default: no bump, stay in current state
        case (state)
            STATE_WALK_LEFT: begin
                if (bump_left && bump_right)
                    state_next = STATE_WALK_RIGHT; // both bumped, switch direction
                else if (bump_left)
                    state_next = STATE_WALK_RIGHT;
                else if (bump_right)
                    state_next = STATE_WALK_LEFT;
                else
                    state_next = STATE_WALK_LEFT;
            end
            STATE_WALK_RIGHT: begin
                if (bump_left && bump_right)
                    state_next = STATE_WALK_LEFT; // both bumped, switch direction
                else if (bump_right)
                    state_next = STATE_WALK_LEFT;
                else if (bump_left)
                    state_next = STATE_WALK_RIGHT;
                else
                    state_next = STATE_WALK_RIGHT;
            end
            default: state_next = STATE_WALK_LEFT;
        endcase
    end

    // Moore output logic
    assign walk_left  = (state == STATE_WALK_LEFT);
    assign walk_right = (state == STATE_WALK_RIGHT);

endmodule