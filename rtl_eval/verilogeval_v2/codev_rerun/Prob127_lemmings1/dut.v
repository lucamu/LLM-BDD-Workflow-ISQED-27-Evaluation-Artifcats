module TopModule(
    input clk,
    input areset,        input bump_left,
    input bump_right,
    output walk_left,
    output walk_right);     parameter LEFT=0, RIGHT=1;
    reg state, next_state;
    reg [1:0] inputs;
    always @(*) begin
                inputs = {bump_left, bump_right};
        case (state)
            LEFT: next_state = (inputs == 2'b10 || inputs == 2'b11) ? RIGHT : LEFT;
            RIGHT: next_state = (inputs == 2'b01 || inputs == 2'b11) ? LEFT : RIGHT;
            default: next_state = LEFT;
        endcase
    end
    always @(posedge clk, posedge areset) begin
                if (areset) state <= LEFT;
        else state <= next_state;
    end
        assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
endmodule
