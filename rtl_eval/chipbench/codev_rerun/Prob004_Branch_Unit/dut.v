module TopModule(
    input [9:0] Cur_PC,
    input [31:0] Imm,
    input JalrSel,
    input Branch,
    input [31:0] AluResult,
    output [31:0] PC_Imm,
    output [31:0] PC_Four,
    output [31:0] BrPC,
    output PcSel
);
    wire [31:0] PC;
    assign PC = {22'b0, Cur_PC};
    assign PC_Imm = PC + Imm;
    assign PC_Four = PC + 32'd4;
    wire Branch_Sel;
    assign Branch_Sel = Branch && AluResult[0];
    assign BrPC = JalrSel ? AluResult : (Branch_Sel ? PC_Imm : 32'd0);
    assign PcSel = JalrSel || (Branch && AluResult[0]);
endmodule
