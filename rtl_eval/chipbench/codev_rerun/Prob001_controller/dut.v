module TopModule(Opcode, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, ALUOp, Branch, JalrSel, RWSel);
    input [6:0] Opcode;
    output ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, JalrSel;
    output [1:0] ALUOp, RWSel;
endmodule
