module handshake_data_width(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);
        reg [1:0] count;
        reg [7:0] data_lock;
        always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
                        valid_out <= 1'b0;
            data_out <= 16'b0;
            count <= 2'b0;
            data_lock <= 8'b0;
        end else begin
            if (valid_in) begin
                                if (count == 2'b0) begin
                                        data_lock <= data_in;
                    count <= count + 1'b1;
                end else if (count == 2'b1) begin
                                        data_out <= {data_lock, data_in};
                    valid_out <= 1'b1;                     count <= 2'b0;                 end
            end else if (valid_out) begin
                                valid_out <= 1'b0;
            end
        end
    end
endmodule
