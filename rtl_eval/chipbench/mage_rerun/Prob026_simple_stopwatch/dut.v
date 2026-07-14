module TopModule (
    input  logic clk,
    input  logic rst_n,
    output logic [5:0] second,
    output logic [5:0] minute
);

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            second <= 6'd0;
            minute <= 6'd0;
        end else begin
            if (minute == 6'd60) begin
                // Stopwatch paused, hold current values
                second <= second;
                minute <= minute;
            end else if (second == 6'd60) begin
                second <= 6'd1;
                minute <= minute + 6'd1;
            end else begin
                second <= second + 6'd1;
            end
        end
    end

endmodule