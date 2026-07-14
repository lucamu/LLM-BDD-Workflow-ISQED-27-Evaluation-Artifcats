module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);
    reg [3:0] q_i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_i <= 4'h0;
        end
        else begin
            if (load) begin
                q_i <= data;
            end
            else if (ena) begin
                q_i[0] <= q_i[1];
                q_i[1] <= q_i[2];
                q_i[2] <= q_i[3];
                q_i[3] <= 1'b0;
            end
        end
    end
    assign q = q_i;
endmodule
