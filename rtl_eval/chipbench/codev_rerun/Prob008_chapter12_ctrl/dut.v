module TopModule(
    input rst,
    input [31:0] excepttype_i,
    input [31:0] cp0_epc_i,
    input stallreq_from_if,
    input stallreq_from_id,
    input stallreq_from_ex,
    input stallreq_from_mem,
    output reg [31:0] new_pc,
    output reg flush,
    output reg [5:0] stall
    );
    always @(*) begin
        if(rst) begin
            stall <= 6'b000000;
            flush <= 0;
            new_pc <= 0;
        end
        else begin
            if(excepttype_i != 0) begin
                flush <= 1;
                stall <= 6'b000000;
                case(excepttype_i)
                    32'h00000001: new_pc <= 32'h00000020;                     32'h00000008: new_pc <= 32'h00000040;                     32'h0000000a: new_pc <= 32'h00000040;                     32'h0000000d: new_pc <= 32'h00000040;                     32'h0000000c: new_pc <= 32'h00000040;                     32'h0000000e: new_pc <= cp0_epc_i;                 endcase
            end
            else begin
                if(stallreq_from_mem) begin
                    stall <= 6'b011111;
                    flush <= 0;
                    new_pc <= 0;
                end
                else if(stallreq_from_ex) begin
                    stall <= 6'b001111;
                    flush <= 0;
                    new_pc <= 0;
                end
                else if(stallreq_from_id) begin
                    stall <= 6'b000111;
                    flush <= 0;
                    new_pc <= 0;
                end
                else if(stallreq_from_if) begin
                    stall <= 6'b000111;
                    flush <= 0;
                    new_pc <= 0;
                end
                else begin
                    stall <= 6'b000000;
                    flush <= 0;
                    new_pc <= 0;
                end
            end
        end
    end
endmodule
