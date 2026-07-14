module TopModule (
    input clk,
    input reset,
    output shift_ena
);
    reg [2:0] cnt;
    reg ena_reg;
    always @(posedge clk) begin
        if (reset) begin
            ena_reg <= 1'b0;
        end
        else begin
            if (cnt == 3'd4)
                ena_reg <= 1'b0;
            else
                ena_reg <= 1'b1;
        end
    end
    always @(posedge clk) begin
        if (reset)
            cnt <= 3'd0;
        else if (cnt < 3'd4)
            cnt <= cnt + 3'd1;
    end
    assign shift_ena = ena_reg;
endmodule
