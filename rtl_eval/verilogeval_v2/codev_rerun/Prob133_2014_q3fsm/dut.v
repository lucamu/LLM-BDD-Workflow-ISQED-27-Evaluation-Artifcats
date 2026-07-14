module fsm_q4 (
    input clk,
    input reset,
    input s,
    input w,
    output z
);
    parameter A = 0, B = 1;
    reg [1 : 0] state, next_state;
    reg [2 : 0] w_count;
    reg z_temp;
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end
        else begin
            state <= next_state;
        end
    end
    always @(*) begin
        case (state)
            A : next_state = s ? B : A;
            B : next_state = B;
            default : next_state = A;
        endcase
    end
    always @(posedge clk) begin
        if (reset) begin
            w_count <= 3'b000;
        end
        else if (next_state == B) begin
            w_count <= {w_count[1 : 0], w};
        end
    end
    always @(*) begin
        if (w_count == 3'b111 || w_count == 3'b000) begin
            z_temp = 1'b0;
        end
        else begin
            z_temp = 1'b1;
        end
    end
    assign z = (state == B) ? z_temp : 1'b0;
endmodule
