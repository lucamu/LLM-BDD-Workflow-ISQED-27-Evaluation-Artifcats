module TopModule (
    input clk,
    input reset,       input w,
    output z
);
    parameter A=0, B=1, C=2, D=3, E=4, F=5;
    reg [2:0] state, next_state;
    always @(*) begin
        case ({state, w})
            {A, 1'b0}: next_state = A;
            {A, 1'b1}: next_state = B;
            {B, 1'b0}: next_state = C;
            {B, 1'b1}: next_state = D;
            {C, 1'b0}: next_state = D;
            {C, 1'b1}: next_state = E;
            {D, 1'b0}: next_state = A;
            {D, 1'b1}: next_state = F;
            {E, 1'b0}: next_state = D;
            {E, 1'b1}: next_state = E;
            {F, 1'b0}: next_state = C;
            {F, 1'b1}: next_state = D;
        endcase
    end
    always @(posedge clk) begin
        if (reset) state <= A;
        else state <= next_state;
    end
        assign z = (state == E) | (state == F);
endmodule
