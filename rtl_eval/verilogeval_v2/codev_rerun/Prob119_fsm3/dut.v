module TopModule(
    input clk,
    input areset,
    input in,
    output out);     parameter A=0, B=1, C=2, D=3;
    reg [1:0] state, next_state;
        always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? C : B;
            C: next_state = in ? A : D;
            D: next_state = in ? C : B;
        endcase
    end
        always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= A;
        end
        else begin
            state <= next_state;
        end
    end
        assign out = (state == D);
endmodule
