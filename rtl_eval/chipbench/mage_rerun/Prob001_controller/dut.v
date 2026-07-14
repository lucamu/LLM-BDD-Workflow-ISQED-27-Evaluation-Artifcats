module TopModule (
    input  logic [6:0] Opcode,
    output logic ALUSrc,
    output logic MemtoReg,
    output logic RegWrite,
    output logic MemRead,
    output logic MemWrite,
    output logic [1:0] ALUOp,
    output logic Branch,
    output logic JalrSel,
    output logic [1:0] RWSel
);

    // Opcode definitions
    localparam OP_RTYPE  = 7'b0110011;
    localparam OP_LOAD   = 7'b0000011;
    localparam OP_STORE  = 7'b0100011;
    localparam OP_ITYPE  = 7'b0010011;
    localparam OP_BRANCH = 7'b1100011;
    localparam OP_JAL    = 7'b1101111;
    localparam OP_JALR   = 7'b1100111;
    localparam OP_LUI    = 7'b0110111;
    localparam OP_AUIPC  = 7'b0010111;

    always @(*) begin
        // Default values to avoid latches and undefined outputs
        ALUSrc   = 1'b0;
        MemtoReg = 1'b0;
        RegWrite = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        ALUOp    = 2'b00;
        Branch   = 1'b0;
        JalrSel  = 1'b0;
        RWSel    = 2'b00;

        case (Opcode)
            OP_RTYPE: begin
                ALUSrc   = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                ALUOp    = 2'b10;
                Branch   = 1'b0;
                JalrSel  = 1'b0;
                RWSel    = 2'b00;
            end

            OP_LOAD: begin
                ALUSrc   = 1'b1;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                MemRead  = 1'b1;
                MemWrite = 1'b0;
                ALUOp    = 2'b00;
                Branch   = 1'b0;
                JalrSel  = 1'b0;
                RWSel    = 2'b00;
            end

            OP_STORE: begin
                ALUSrc   = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b1;
                ALUOp    = 2'b00;
                Branch   = 1'b0;
                JalrSel  = 1'b0;
                RWSel    = 2'b00;
            end

            OP_ITYPE: begin
                ALUSrc   = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                ALUOp    = 2'b10;
                Branch   = 1'b0;
                JalrSel  = 1'b0;
                RWSel    = 2'b00;
            end

            OP_BRANCH: begin
                ALUSrc   = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                ALUOp    = 2'b01;
                Branch   = 1'b1;
                JalrSel  = 1'b0;
                RWSel    = 2'b00;
            end

            OP_JAL: begin
                ALUSrc   = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                ALUOp    = 2'b11;
                Branch   = 1'b1;
                JalrSel  = 1'b0;
                RWSel    = 2'b01;
            end

            OP_JALR: begin
                ALUSrc   = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                ALUOp    = 2'b00;
                Branch   = 1'b0;
                JalrSel  = 1'b1;
                RWSel    = 2'b01;
            end

            OP_LUI: begin
                ALUSrc   = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                ALUOp    = 2'b11;
                Branch   = 1'b0;
                JalrSel  = 1'b0;
                RWSel    = 2'b10;
            end

            OP_AUIPC: begin
                ALUSrc   = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                ALUOp    = 2'b00;
                Branch   = 1'b0;
                JalrSel  = 1'b0;
                RWSel    = 2'b11;
            end

            default: begin
                ALUSrc   = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                ALUOp    = 2'b00;
                Branch   = 1'b0;
                JalrSel  = 1'b0;
                RWSel    = 2'b00;
            end
        endcase
    end

endmodule