module TopModule(
    input clk,
    input areset,
    input x,
    output z
); 
    parameter NONE = 0, ONE = 1;
    reg [1:0] state, next_state;
    always @(*) begin
        case (state)
            NONE: next_state = x ? ONE : NONE;
            ONE: next_state = x ? ONE : NONE;
            default: next_state = NONE;
        endcase
    end
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= NONE;
        else
            state <= next_state;
    end
    assign z = (state == ONE);
endmodule
