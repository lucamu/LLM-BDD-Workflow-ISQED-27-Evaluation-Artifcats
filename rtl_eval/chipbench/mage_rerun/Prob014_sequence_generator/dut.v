module TopModule (
    input  logic clk,
    input  logic rst_n,
    output logic data
);

    logic [2:0] counter;

    always @(posedge clk) begin
        if (!rst_n)
            counter <= 3'd0;
        else begin
            if (counter == 3'd5)
                counter <= 3'd0;
            else
                counter <= counter + 3'd1;
        end
    end

    always @(*) begin
        case (counter)
            3'd0: data = 1'b0;
            3'd1: data = 1'b0;
            3'd2: data = 1'b1;
            3'd3: data = 1'b0;
            3'd4: data = 1'b1;
            3'd5: data = 1'b1;
            default: data = 1'b0;
        endcase
    end

endmodule