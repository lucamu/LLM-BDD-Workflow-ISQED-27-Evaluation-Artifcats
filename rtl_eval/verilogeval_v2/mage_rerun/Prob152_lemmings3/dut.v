module TopModule (
    input  logic clk,
    input  logic areset,
    input  logic bump_left,
    input  logic bump_right,
    input  logic ground,
    input  logic dig,
    output logic walk_left,
    output logic walk_right,
    output logic aaah,
    output logic digging
);

    // State encoding
    localparam [2:0] WALK_LEFT  = 3'b000;
    localparam [2:0] WALK_RIGHT = 3'b001;
    localparam [2:0] FALL_LEFT  = 3'b010;
    localparam [2:0] FALL_RIGHT = 3'b011;
    localparam [2:0] DIG_LEFT   = 3'b100;
    localparam [2:0] DIG_RIGHT  = 3'b101;

    logic [2:0] state, state_next;

    // Sequential state register with asynchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= state_next;
    end

    // Combinational next-state logic
    always @(*) begin
        state_next = state; // default: stay in current state
        case (state)
            WALK_LEFT: begin
                if (!ground)
                    state_next = FALL_LEFT;
                else if (dig)
                    state_next = DIG_LEFT;
                else if (bump_left)
                    state_next = WALK_RIGHT;
                else
                    state_next = WALK_LEFT;
            end

            WALK_RIGHT: begin
                if (!ground)
                    state_next = FALL_RIGHT;
                else if (dig)
                    state_next = DIG_RIGHT;
                else if (bump_right)
                    state_next = WALK_LEFT;
                else
                    state_next = WALK_RIGHT;
            end

            FALL_LEFT: begin
                if (ground)
                    state_next = WALK_LEFT;
                else
                    state_next = FALL_LEFT;
            end

            FALL_RIGHT: begin
                if (ground)
                    state_next = WALK_RIGHT;
                else
                    state_next = FALL_RIGHT;
            end

            DIG_LEFT: begin
                if (!ground)
                    state_next = FALL_LEFT;
                else
                    state_next = DIG_LEFT;
            end

            DIG_RIGHT: begin
                if (!ground)
                    state_next = FALL_RIGHT;
                else
                    state_next = DIG_RIGHT;
            end

            default: state_next = WALK_LEFT;
        endcase
    end

    // Combinational output logic (Moore machine)
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        digging    = 1'b0;

        case (state)
            WALK_LEFT:  walk_left  = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALL_LEFT:  aaah       = 1'b1;
            FALL_RIGHT: aaah       = 1'b1;
            DIG_LEFT:   digging    = 1'b1;
            DIG_RIGHT:  digging    = 1'b1;
            default: begin
                walk_left  = 1'b0;
                walk_right = 1'b0;
                aaah       = 1'b0;
                digging    = 1'b0;
            end
        endcase
    end

endmodule