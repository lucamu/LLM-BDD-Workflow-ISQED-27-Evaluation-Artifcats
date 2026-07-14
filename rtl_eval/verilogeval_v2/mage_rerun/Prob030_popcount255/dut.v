module TopModule (
    input  logic [254:0] in,
    output logic [7:0]   out
);

    integer i;
    integer count;

    always @(*) begin
        count = 0;
        for (i = 0; i < 255; i = i + 1) begin
            count = count + in[i];
        end
        out = count[7:0];
    end

endmodule