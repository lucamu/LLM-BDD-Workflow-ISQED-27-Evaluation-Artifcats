module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
); 
    reg [2:0] state, next_state;
    parameter [3:0] A=0, B=1, C=2, D=3, E=4, F=5, G=6, H=7, I=8, J=9, K=10, L=11;
    always @(*) begin
        case (state)
            A: next_state = (s[2]) ? B : A;
            B: next_state = (s[2]) ? B : C;
            C: next_state = (s[2]) ? D : A;
            D: next_state = (s[2]) ? E : C;
            E: next_state = (s[2]) ? B : F;
            F: next_state = (s[2]) ? G : A;
            G: next_state = (s[2]) ? E : H;
            H: next_state = (s[2]) ? I : C;
            I: next_state = (s[2]) ? B : J;
            J: next_state = (s[2]) ? K : A;
            K: next_state = (s[2]) ? L : H;
            L: next_state = (s[2]) ? I : A;
        endcase
    end
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end
        else begin
            state <= next_state;
        end
    end
    assign fr0 = ((state == C) | (state == D) | (state == E) | (state == F) | (state == G) | (state == H)) ? 1'b1 : 1'b0;
    assign fr1 = ((state == D) | (state == E) | (state == F) | (state == G) | (state == H) | (state == I) | (state == J)) ? 1'b1 : 1'b0;
    assign fr2 = ((state == E) | (state == F) | (state == G) | (state == H) | (state == I) | (state == J) | (state == K)) ? 1'b1 : 1'b0;
    assign dfr = ((state == F) | (state == G) | (state == H) | (state == I) | (state == J) | (state == K) | (state == L)) ? 1'b1 : 1'b0;
endmodule
