module TopModule (
    input  logic clk,
    input  logic reset,
    output logic [3:1] ena,
    output logic [15:0] q
);

    logic [3:0] d0, d1, d2, d3;

    // Enable signals: each higher digit increments when all lower digits are 9
    assign ena[1] = (d0 == 4'd9);
    assign ena[2] = ena[1] && (d1 == 4'd9);
    assign ena[3] = ena[2] && (d2 == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            d0 <= 4'd0;
            d1 <= 4'd0;
            d2 <= 4'd0;
            d3 <= 4'd0;
        end else begin
            // Ones digit always increments (wraps at 9)
            if (d0 == 4'd9)
                d0 <= 4'd0;
            else
                d0 <= d0 + 4'd1;

            // Tens digit increments when ena[1] is asserted
            if (ena[1]) begin
                if (d1 == 4'd9)
                    d1 <= 4'd0;
                else
                    d1 <= d1 + 4'd1;
            end

            // Hundreds digit increments when ena[2] is asserted
            if (ena[2]) begin
                if (d2 == 4'd9)
                    d2 <= 4'd0;
                else
                    d2 <= d2 + 4'd1;
            end

            // Thousands digit increments when ena[3] is asserted
            if (ena[3]) begin
                if (d3 == 4'd9)
                    d3 <= 4'd0;
                else
                    d3 <= d3 + 4'd1;
            end
        end
    end

    assign q = {d3, d2, d1, d0};

endmodule