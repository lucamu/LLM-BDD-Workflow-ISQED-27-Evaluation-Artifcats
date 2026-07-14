module TopModule(
    input clk,
    input reset,        input in,
    output out);    parameter A=0, B=1; 
    reg state, next_state;
    always @(*) begin                    case(state)
            B: begin
                if(in) next_state = B;
                else next_state = A;
            end
            A: begin
                if(in) next_state = A;
                else next_state = B;
            end
        endcase
    end
    always @(posedge clk) begin                    if(reset) state <= B;
        else state <= next_state;
    end
        assign out = (state == B);
endmodule
