module TopModule (
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output [3:0] out
);
    reg [3:0] out1;
    always @(*) begin
        case (sel)
            0: out1 = data0;
            1: out1 = data1;
            2: out1 = data2;
            3: out1 = data3;
            4: out1 = data4;
            5: out1 = data5;
            default: out1 = 0;
        endcase
    end
    assign out = out1;
endmodule
