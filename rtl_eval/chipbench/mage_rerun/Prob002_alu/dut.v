module TopModule (
    input  logic [31:0] SrcA,
    input  logic [31:0] SrcB,
    input  logic [3:0]  Operation,
    output logic [31:0] ALUResult
);

    always @(*) begin
        case (Operation)
            4'b0000: ALUResult = SrcA & SrcB;                                  // AND
            4'b0001: ALUResult = SrcA | SrcB;                                  // OR
            4'b0010: ALUResult = SrcA + SrcB;                                  // ADD
            4'b0011: ALUResult = SrcA ^ SrcB;                                  // XOR
            4'b0100: ALUResult = SrcA << SrcB[4:0];                            // SLL
            4'b0101: ALUResult = SrcA >> SrcB[4:0];                            // SRL
            4'b0110: ALUResult = SrcA - SrcB;                                  // SUB
            4'b0111: ALUResult = $signed(SrcA) >>> SrcB[4:0];                  // SRA
            4'b1000: ALUResult = (SrcA == SrcB) ? 32'd1 : 32'd0;               // EQ
            4'b1001: ALUResult = (SrcA != SrcB) ? 32'd1 : 32'd0;               // NE
            4'b1010: ALUResult = 32'd1;                                        // ALWAYS TRUE
            4'b1100: ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0; // SLT
            4'b1101: ALUResult = ($signed(SrcA) >= $signed(SrcB)) ? 32'd1 : 32'd0; // SGE
            4'b1110: ALUResult = (SrcA < SrcB) ? 32'd1 : 32'd0;                // SLTU
            4'b1111: ALUResult = (SrcA >= SrcB) ? 32'd1 : 32'd0;               // SGEU
            default:  ALUResult = 32'd0;
        endcase
    end

endmodule