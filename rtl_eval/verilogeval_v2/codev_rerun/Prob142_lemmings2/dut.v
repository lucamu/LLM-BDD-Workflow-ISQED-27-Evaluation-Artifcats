module TopModule(
    input clk,
    input areset,        input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 
    parameter LEFT=0, RIGHT=1, FALLING=2;
    reg [1:0] state, next_state;
    always @(*) begin
        case (state)
            LEFT: next_state = ground==0 ? FALLING : bump_left ? RIGHT : LEFT;
            RIGHT: next_state = ground==0 ? FALLING : bump_right ? LEFT : RIGHT;
            FALLING: next_state = ground==0 ? FALLING : LEFT;
            default: next_state = LEFT;
        endcase
    end
    always @(posedge clk, posedge areset) begin
        state <= areset ? LEFT : next_state;
    end
    assign walk_left = state==LEFT;
    assign walk_right = state==RIGHT;
    assign aaah = state==FALLING;
endmodule
