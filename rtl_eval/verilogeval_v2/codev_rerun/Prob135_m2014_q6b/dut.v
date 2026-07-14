module TopModule (
    input [3:1] y,
    input w,
    output Y1);
    parameter A=3'd0, B=3'd1, C=3'd2, D=3'd3, E=3'd4, F=3'd5;
    reg [3:1] Y;
    always @(*) begin
        case(y)
            A: Y = w? A : B;
            B: Y = w? C : D;
            C: Y = w? E : D;
            D: Y = w? F : A;
            E: Y = w? E : D;
            F: Y = w? C : D;
            default: Y = y;
        endcase
    end
    assign Y1 = Y[1];
endmodule
