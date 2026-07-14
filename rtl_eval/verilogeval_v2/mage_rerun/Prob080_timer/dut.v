module TopModule (
    input  logic clk,
    input  logic load,
    input  logic [9:0] data,
    output logic tc
);

    logic [9:0] counter;

    initial begin
        counter = 10'd0;
    end

    always @(posedge clk) begin
        if (load)
            counter <= data;
        else if (counter != 10'd0)
            counter <= counter - 10'd1;
    end

    assign tc = (counter == 10'd0);

endmodule