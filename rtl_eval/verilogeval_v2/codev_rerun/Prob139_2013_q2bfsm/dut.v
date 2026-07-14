module TopModule(
    input clk,
    input resetn,        input x,
    input y,
    output f,
    output g
); 
    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7;
    reg [3:0] state, next_state;
    reg f_tmp, g_tmp;
    assign f = f_tmp;
    assign g = g_tmp;
    always @(*) begin
        case (state)
            A: next_state = resetn ? B : A;
            B: next_state = C;
            C: next_state = x ? D : E;
            D: next_state = F;
            E: next_state = x ? D : H;
            F: next_state = x ? G : E;
            G: next_state = x ? D : H;
            H: next_state = x ? D : E;
        endcase
    end
    always @(posedge clk) begin
        state <= next_state;
    end
    always @(posedge clk) begin
        case (state)
            A: begin
                f_tmp <= 0;
                g_tmp <= 0;
            end
            B: begin
                f_tmp <= 1;
                g_tmp <= 0;
            end
            C: begin
                f_tmp <= 0;
                g_tmp <= 0;
            end
            D: begin
                f_tmp <= 0;
                g_tmp <= 1;
            end
            E: begin
                f_tmp <= 0;
                g_tmp <= 0;
            end
            F: begin
                f_tmp <= 0;
                g_tmp <= 1;
            end
            G: begin
                f_tmp <= 0;
                g_tmp <= 1;
            end
            H: begin
                f_tmp <= 0;
                g_tmp <= 0;
            end
        endcase
    end
endmodule
