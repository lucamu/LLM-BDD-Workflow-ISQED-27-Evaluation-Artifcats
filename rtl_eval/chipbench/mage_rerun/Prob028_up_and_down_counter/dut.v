module TopModule (
    input  logic clk,
    input  logic rst_n,
    input  logic mode,
    output logic [3:0] number,
    output logic zero
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            number <= 4'd0;
            zero   <= 1'b0;
        end else begin
            // zero reflects whether the number BEFORE this update was 0
            zero <= (number == 4'd0);

            if (mode) begin
                // count up
                if (number == 4'd9)
                    number <= 4'd0;
                else
                    number <= number + 4'd1;
            end else begin
                // count down
                if (number == 4'd0)
                    number <= 4'd9;
                else
                    number <= number - 4'd1;
            end
        end
    end

endmodule