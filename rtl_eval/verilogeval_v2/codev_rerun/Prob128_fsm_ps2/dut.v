module TopModule(
    input clk,
    input reset,        input [7:0] in,
    output done);     parameter IDLE=0, BYTE1=1, BYTE2=2, BYTE3=3, DONE=4;
    reg [2:0] state, next_state;
    reg [2:0] count;
        always @(*) begin
        case (state)
            IDLE: next_state = (in[3]) ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = DONE;
            DONE: next_state = (in[3]) ? BYTE1 : IDLE;
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
            if (next_state == BYTE1) count <= 1;
            else if (next_state == BYTE2) count <= 2;
            else if (next_state == BYTE3) count <= 3;
            else if (next_state == DONE) count <= 0;
        end
    end
        assign done = (state == DONE);
endmodule
