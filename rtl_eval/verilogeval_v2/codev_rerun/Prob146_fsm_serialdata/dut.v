module fsm_serial_top(
    input           clk,
    input           in,
    input           reset,
    output  [7 : 0] out_byte,
    output          done
);
    parameter   IDLE    = 0,
                START   = 1,
                DATA    = 2,
                STOP_OK = 3,
                STOP_ERR= 4,
                STOP_ERR2OK = 5;
    reg [2 : 0]   state, next_state;
    reg [3 : 0]   data_count;
    reg [7 : 0]   data;
    always @(posedge clk) begin
        if (reset)  state <= IDLE;
        else        state <= next_state;
    end
    always @(*) begin
        case (state)
            IDLE:     next_state = in ? IDLE : START;
            START:    next_state = DATA;
            DATA:     next_state = data_count == 8 ? (in ? STOP_OK : STOP_ERR) : DATA;
            STOP_OK:  next_state = in ? IDLE : START;
            STOP_ERR: next_state = in ? STOP_ERR2OK : STOP_ERR;
            STOP_ERR2OK: next_state = in ? IDLE : START;
            default:  next_state = IDLE;
        endcase
    end
    always @(posedge clk) begin
        if (reset) begin
            data_count <= 0;
            data       <= 0;
        end
        else if (state == DATA) begin
            data       <= {in, data[7 : 1]};
            data_count <= data_count + 1;
        end
        else begin
            data       <= 0;
            data_count <= 0;
        end
    end
    assign done = state == STOP_OK;
    assign out_byte = done ? data : 8'bx;
endmodule
