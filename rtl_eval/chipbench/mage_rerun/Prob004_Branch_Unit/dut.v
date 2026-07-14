module TopModule(
    input  logic [8:0]  Cur_PC,
    input  logic [31:0] Imm,
    input  logic        JalrSel,
    input  logic        Branch,
    input  logic [31:0] AluResult,
    output logic [31:0] PC_Imm,
    output logic [31:0] PC_Four,
    output logic [31:0] BrPC,
    output logic        PcSel
);

    logic [31:0] Cur_PC_ext;
    logic        Branch_Sel;

    assign Cur_PC_ext = {23'b0, Cur_PC};

    assign PC_Imm  = Cur_PC_ext + Imm;
    assign PC_Four = Cur_PC_ext + 32'd4;

    assign Branch_Sel = Branch && AluResult[0];

    always @(*) begin
        if (JalrSel)
            BrPC = AluResult;
        else if (Branch_Sel)
            BrPC = PC_Imm;
        else
            BrPC = 32'd0;
    end

    assign PcSel = JalrSel || Branch_Sel;

endmodule