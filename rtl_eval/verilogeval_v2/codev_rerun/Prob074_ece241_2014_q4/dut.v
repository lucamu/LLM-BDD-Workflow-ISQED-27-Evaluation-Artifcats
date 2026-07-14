module TopModule(
    input clk,
    input x,
    output z
); 
    wire[1:0] w;
    wire[1:0] w2;
    wire[1:0] w3;
    wire[1:0] w4;
    DFF dff0(.clk(clk), .d(w[0]), .q(w2[0]));
    DFF dff1(.clk(clk), .d(w[1]), .q(w2[1]));
    DFF dff2(.clk(clk), .d(w3[0]), .q(w4[0]));
    DFF dff3(.clk(clk), .d(w3[1]), .q(w4[1]));
    XOR2 xor2(.a(x), .b(w2[0]), .q(w[0]));
    AND2 and2(.a(x), .b(w2[1]), .q(w[1]));
    OR2 or2(.a(x), .b(w2[1]), .q(w3[0]));
    NOR3 nor3(.a(w4[0]), .b(w4[1]), .c(w[0]), .q(w3[1]));
    assign z = w3[1];
endmodule
