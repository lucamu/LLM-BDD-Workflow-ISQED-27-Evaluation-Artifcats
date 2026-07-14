module Lemmings1(
    input       clk,
    input       areset,        input       bump_left,
    input       bump_right,
    input       ground,
    input       dig,
    output      walk_left,
    output      walk_right,
    output      aaah,
    output      digging ); 
    parameter   [2:0]     LEFT  = 3'b000,
                          RIGHT = 3'b001,
                          AH_L  = 3'b010,
                          AH_R  = 3'b011,
                          DIG_L = 3'b100,
                          DIG_R = 3'b101;
    reg         [2:0]     state, next_state;
    reg         [4:0]     count;
    always @ (posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            count <= 5'b0;
        end
        else begin
            state <= next_state;
            if (state == AH_L || state == AH_R) begin
                count <= count + 1;
            end
            else begin
                count <= 5'b0;
            end
        end
    end
    always @ (*) begin
        case (state)
            LEFT: begin
                if (ground) begin
                    if (dig) begin
                        next_state = DIG_L;
                    end
                    else begin
                        if (bump_left) begin
                            next_state = RIGHT;
                        end
                        else begin
                            next_state = LEFT;
                        end
                    end
                end
                else begin
                    next_state = AH_L;
                end
            end
            RIGHT: begin
                if (ground) begin
                    if (dig) begin
                        next_state = DIG_R;
                    end
                    else begin
                        if (bump_right) begin
                            next_state = LEFT;
                        end
                        else begin
                            next_state = RIGHT;
                        end
                    end
                end
                else begin
                    next_state = AH_R;
                end
            end
            AH_L: begin
                if (ground) begin
                    next_state = LEFT;
                end
                else begin
                    next_state = AH_L;
                end
            end
            AH_R: begin
                if (ground) begin
                    next_state = RIGHT;
                end
                else begin
                    next_state = AH_R;
                end
            end
            DIG_L: begin
                if (ground) begin
                    next_state = DIG_L;
                end
                else begin
                    next_state = AH_L;
                end
            end
            DIG_R: begin
                if (ground) begin
                    next_state = DIG_R;
                end
                else begin
                    next_state = AH_R;
                end
            end
            default: next_state = LEFT;
        endcase
    end
    assign walk_left  = (state == LEFT)  ? 1'b1 : 1'b0;
    assign walk_right = (state == RIGHT) ? 1'b1 : 1'b0;
    assign aaah       = (state == AH_L)  ? 1'b1 : 1'b0;
    assign digging    = (state == DIG_L) ? 1'b1 : 1'b0;
endmodule
