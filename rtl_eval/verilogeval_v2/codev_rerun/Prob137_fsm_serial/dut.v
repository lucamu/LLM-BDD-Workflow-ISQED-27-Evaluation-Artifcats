module TopModule(
    input clk,
    input reset,        input in,
    output done
); 
    parameter IDLE = 0, START_BIT = 1, DATA_BITS = 2, STOP_BIT = 3, STOP_BIT_1 = 4;
    reg [2:0] state, next_state;
    reg [3:0] count;
    always @(*) begin
        case (state)
            IDLE: next_state = in ? IDLE : START_BIT;
            START_BIT: next_state = DATA_BITS;
            DATA_BITS: next_state = count < 8 ? DATA_BITS : (in ? STOP_BIT : STOP_BIT_1);
            STOP_BIT: next_state = in ? IDLE : START_BIT;
            STOP_BIT_1: next_state = in ? IDLE : START_BIT;
            default: next_state = IDLE;
        endcase
    end
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
        end
        else begin
            state <= next_state;
            if (state == DATA_BITS)
                count <= count + 1;
            else if (state == IDLE || state == STOP_BIT || state == STOP_BIT_1)
                count <= 0;
        end
    end
    assign done = state == STOP_BIT;
endmodule
