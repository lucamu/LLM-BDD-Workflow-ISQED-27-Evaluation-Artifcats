module TopModule (
    input [3:0] x,
    input [3:0] y, 
    output [4:0] sum);
    wire [3:0] cout;
    FA FA1(.a(x[0]), .b(y[0]), .cin(1'b0), .sum(sum[0]), .cout(cout[0]));
    FA FA2(.a(x[1]), .b(y[1]), .cin(cout[0]), .sum(sum[1]), .cout(cout[1]));
    FA FA3(.a(x[2]), .b(y[2]), .cin(cout[1]), .sum(sum[2]), .cout(cout[2]));
    FA FA4(.a(x[3]), .b(y[3]), .cin(cout[2]), .sum(sum[3]), .cout(cout[3]));
    assign sum[4] = cout[3];
endmodule
