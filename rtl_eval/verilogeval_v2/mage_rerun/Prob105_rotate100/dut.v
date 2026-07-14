module TopModule (
    input  logic        clk,
    input  logic        load,
    input  logic [1:0]  ena,
    input  logic [99:0] data,
    output logic [99:0] q
);

    initial begin
        q = 100'b0;
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            case (ena)
                2'b01: q <= {q[0], q[99:1]};   // rotate right by one
                2'b10: q <= {q[98:0], q[99]};  // rotate left by one
                default: q <= q;                // no rotation for 2'b00 and 2'b11
            endcase
        end
    end

endmodule