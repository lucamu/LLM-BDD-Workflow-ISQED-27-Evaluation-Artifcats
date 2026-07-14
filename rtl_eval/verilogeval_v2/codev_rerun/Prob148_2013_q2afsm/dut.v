module TopModule(
    input clk,
    input resetn,        input [3:1] r,       output [3:1] g   ); 
    parameter A=0, B=1, C=2, D=3;
    reg [1:0] state, next;
    always @(*) begin
        case (state)
            A: begin
                casex (r)
                    3'bxx0: next = A;
                    3'bx01: next = B;
                    3'b01x: next = C;
                    3'b111: next = D;
                endcase
            end
            B: next = r[0] ? B : A;
            C: next = r[1] ? C : A;
            D: next = r[2] ? D : A;
        endcase
    end
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next;
    end
    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = (state == D);
endmodule
