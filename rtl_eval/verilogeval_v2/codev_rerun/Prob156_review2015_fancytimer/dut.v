module TopModule(
    input clk,
    input reset,        input data,
    output [3:0] count,
    output counting,
    output done,
    input ack );
    reg [3:0] delay;     reg [11:0] counter;     reg [3:0] state;
    reg [3:0] next_state;
    always @(*) begin
        case (state)
            0: next_state = (data == 1 && state == 0) ? 1 : 0;
            1: next_state = (data == 1 && state == 1) ? 2 : 0;
            2: next_state = (data == 0 && state == 2) ? 3 : 0;
            3: next_state = (data == 1 && state == 3) ? 4 : 0;
            4: next_state = (counter == 12'd1000) ? 5 : 4;
            5: next_state = (counter == 12'd1000) ? 6 : 5;
            6: next_state = (counter == 12'd1000) ? 7 : 6;
            7: next_state = (counter == 12'd1000) ? 8 : 7;
            8: next_state = (ack == 1) ? 0 : 8;
        endcase
    end
    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
        end
        else begin
            state <= next_state;
        end
    end
    always @(posedge clk) begin
        if (reset) begin
            delay <= 0;
        end
        else if (next_state == 4) begin
            delay <= {data, delay[3:1]};
        end
    end
    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
        end
        else if (next_state == 4) begin
            counter <= 0;
        end
        else if (next_state == 5 || next_state == 6 || next_state == 7) begin
            counter <= counter + 1;
        end
    end
    assign counting = (state == 4 || state == 5 || state == 6 || state == 7);
    assign done = (state == 8);
    assign count = (counting) ? delay - counter / 1000 : 4'bx;
endmodule
