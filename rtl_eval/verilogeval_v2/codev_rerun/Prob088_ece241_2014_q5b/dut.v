module TopModule(
    input clk,
    input areset,
    input x,
    output z
); 
    parameter A=0, B=1;
    reg [1:0] state, next;
    always @(*) begin
        case (state)
            A: next = x?B:A;
            B: next = x?B:B;
        endcase
    end
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next;
    end
    assign z = (state==A);
endmodule
