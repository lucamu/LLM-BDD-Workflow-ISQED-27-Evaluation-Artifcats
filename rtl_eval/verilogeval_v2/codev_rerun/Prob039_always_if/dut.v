module TopModule(
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always   ); 
    wire w1,w2,w3,w4;
    assign w1 = sel_b1 & sel_b2;
    assign w2 = ~w1;
    assign w3 = w2 & a;
    assign w4 = w1 & b;
    assign out_assign = w3 | w4;
    reg out_always_r;
    always @(*) begin
        if (w1) begin
            out_always_r = b;
        end
        else begin
            out_always_r = a;
        end
    end
    assign out_always = out_always_r;
endmodule
