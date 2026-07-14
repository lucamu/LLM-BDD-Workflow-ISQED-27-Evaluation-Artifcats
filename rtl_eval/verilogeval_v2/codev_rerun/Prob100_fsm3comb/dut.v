module TopModule(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out);     parameter A=0, B=1, C=2, D=3;
        assign next_state = (state == A)? (in?B:A) :
        (state == B)? (in?B:C) :
        (state == C)? (in?D:A) :
        in?B:C;
        assign out = (state == D)? 1:0;
endmodule
