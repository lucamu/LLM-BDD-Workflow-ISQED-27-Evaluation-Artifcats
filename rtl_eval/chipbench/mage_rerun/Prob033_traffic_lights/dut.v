module TopModule (
    input  logic clk,
    input  logic rst_n,
    input  logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

    // State encoding
    localparam [1:0] RED    = 2'b00;
    localparam [1:0] GREEN  = 2'b01;
    localparam [1:0] YELLOW = 2'b10;

    logic [1:0] state, state_next;

    // Sequential logic: state and clock counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
            clock <= 8'd10;
        end else begin
            case (state)
                RED: begin
                    if (clock == 8'd1) begin
                        state <= GREEN;
                        clock <= 8'd60;
                    end else begin
                        state <= RED;
                        clock <= clock - 8'd1;
                    end
                end

                GREEN: begin
                    if (pass_request && (clock > 8'd10)) begin
                        state <= GREEN;
                        clock <= 8'd10;
                    end else if (clock == 8'd1) begin
                        state <= YELLOW;
                        clock <= 8'd5;
                    end else begin
                        state <= GREEN;
                        clock <= clock - 8'd1;
                    end
                end

                YELLOW: begin
                    if (clock == 8'd1) begin
                        state <= RED;
                        clock <= 8'd10;
                    end else begin
                        state <= YELLOW;
                        clock <= clock - 8'd1;
                    end
                end

                default: begin
                    state <= RED;
                    clock <= 8'd10;
                end
            endcase
        end
    end

    // Combinational output decode
    always @(*) begin
        red    = 1'b0;
        yellow = 1'b0;
        green  = 1'b0;
        case (state)
            RED:    red    = 1'b1;
            GREEN:  green  = 1'b1;
            YELLOW: yellow = 1'b1;
            default: red   = 1'b1;
        endcase
    end

endmodule