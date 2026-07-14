module TopModule (
    input  [7:0] code,
    output [3:0] out,
    output       valid
);
    reg [3:0] out_reg;
    reg valid_reg;
    always @(*) begin
        case (code)
            8'h45: out_reg = 0;
            8'h16: out_reg = 1;
            8'h1e: out_reg = 2;
            8'h26: out_reg = 3;
            8'h25: out_reg = 4;
            8'h2e: out_reg = 5;
            8'h36: out_reg = 6;
            8'h3d: out_reg = 7;
            8'h3e: out_reg = 8;
            8'h46: out_reg = 9;
            default: out_reg = 0;
        endcase
        if (out_reg == 0)
            valid_reg = 0;
        else
            valid_reg = 1;
    end
    assign out = out_reg;
    assign valid = valid_reg;
endmodule
