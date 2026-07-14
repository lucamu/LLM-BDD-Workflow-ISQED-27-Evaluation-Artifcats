module TopModule(
    input clk,
    input areset,
    input in,
    output out
);
    parameter A = 1'b0, B = 1'b1; 
    reg state, next_state;
    always @(*) begin                    case (state)
            A: next_state = in ? A : B;
            B: next_state = in ? B : A;
        endcase
    end
    always @(posedge clk, posedge areset) begin                    if (areset) state <= B;
        else state <= next_state;
    end
        assign out = state;
endmodule
