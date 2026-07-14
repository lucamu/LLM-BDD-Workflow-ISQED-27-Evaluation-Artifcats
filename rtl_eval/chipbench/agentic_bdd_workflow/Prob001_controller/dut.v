module TopModule (
    input  [6:0] Opcode,
    output       ALUSrc,
    output       MemtoReg,
    output       RegWrite,
    output       MemRead,
    output       MemWrite,
    output [1:0] ALUOp,
    output       Branch,
    output       JalrSel,
    output [1:0] RWSel
);

    // Internal wires connecting OpcodeDecoder to ControlLogic
    wire isRType;
    wire isIType;
    wire isLoad;
    wire isStore;
    wire isBranch;
    wire isJal;
    wire isJalr;
    wire isLui;
    wire isAuipc;

    // ------------------------------------------------------------------
    // OpcodeDecoder: decodes the 7-bit Opcode into instruction type flags
    // Covers all @opcode_decode scenarios (R-type, I-type, Load, Store,
    // Branch, JAL, JALR, LUI, AUIPC)
    // ------------------------------------------------------------------
    dut__OpcodeDecoder u_OpcodeDecoder (
        .Opcode   (Opcode),
        .isRType  (isRType),
        .isIType  (isIType),
        .isLoad   (isLoad),
        .isStore  (isStore),
        .isBranch (isBranch),
        .isJal    (isJal),
        .isJalr   (isJalr),
        .isLui    (isLui),
        .isAuipc  (isAuipc)
    );

    // ------------------------------------------------------------------
    // ControlLogic: generates the datapath control signals from the
    // instruction type flags. Covers all invariant scenarios:
    // mutual exclusion of MemRead/MemWrite, Branch condition, JalrSel
    // condition, RegWrite condition, RWSel encoding, ALUOp encoding.
    // ------------------------------------------------------------------
    dut__ControlLogic u_ControlLogic (
        .isRType  (isRType),
        .isIType  (isIType),
        .isLoad   (isLoad),
        .isStore  (isStore),
        .isBranch (isBranch),
        .isJal    (isJal),
        .isJalr   (isJalr),
        .isLui    (isLui),
        .isAuipc  (isAuipc),
        .ALUSrc   (ALUSrc),
        .MemtoReg (MemtoReg),
        .RegWrite (RegWrite),
        .MemRead  (MemRead),
        .MemWrite (MemWrite),
        .ALUOp    (ALUOp),
        .Branch   (Branch),
        .JalrSel  (JalrSel),
        .RWSel    (RWSel)
    );

endmodule

module dut__OpcodeDecoder (
    input  [6:0] Opcode,
    output       isRType,
    output       isIType,
    output       isLoad,
    output       isStore,
    output       isBranch,
    output       isJal,
    output       isJalr,
    output       isLui,
    output       isAuipc
);

    // -------------------------------------------------------------------
    // Scenario: R-type opcode asserts only isRType
    // -------------------------------------------------------------------
    assign isRType  = (Opcode == 7'b0110011);

    // -------------------------------------------------------------------
    // Scenario: I-type ALU/immediate opcode asserts only isIType
    // -------------------------------------------------------------------
    assign isIType  = (Opcode == 7'b0010011);

    // -------------------------------------------------------------------
    // Scenario: Load opcode asserts only isLoad
    // -------------------------------------------------------------------
    assign isLoad   = (Opcode == 7'b0000011);

    // -------------------------------------------------------------------
    // Scenario: Store opcode asserts only isStore
    // -------------------------------------------------------------------
    assign isStore  = (Opcode == 7'b0100011);

    // -------------------------------------------------------------------
    // Scenario: Branch opcode asserts only isBranch
    // -------------------------------------------------------------------
    assign isBranch = (Opcode == 7'b1100011);

    // -------------------------------------------------------------------
    // Scenario: JAL opcode asserts only isJal
    // -------------------------------------------------------------------
    assign isJal    = (Opcode == 7'b1101111);

    // -------------------------------------------------------------------
    // Scenario: JALR opcode asserts only isJalr
    // -------------------------------------------------------------------
    assign isJalr   = (Opcode == 7'b1100111);

    // -------------------------------------------------------------------
    // Scenario: LUI opcode asserts only isLui
    // -------------------------------------------------------------------
    assign isLui    = (Opcode == 7'b0110111);

    // -------------------------------------------------------------------
    // Scenario: AUIPC opcode asserts only isAuipc
    // -------------------------------------------------------------------
    assign isAuipc  = (Opcode == 7'b0010111);

    // -------------------------------------------------------------------
    // Scenario: Exclusivity/exhaustive & Unsupported opcode default
    //   Because each output is driven by a mutually-exclusive equality
    //   comparison against a unique 7-bit constant, at most one output
    //   can ever be asserted for any given Opcode value, and any value
    //   not matching one of the nine defined encodings results in all
    //   outputs deasserted (all-zero vector).
    //
    // Scenario: Combinational/no-state & stability
    //   All outputs are continuous assignments driven solely by the
    //   current value of Opcode, with no internal state, clock, or
    //   feedback, guaranteeing a pure function of Opcode with
    //   identical results for identical inputs and distinct one-hot
    //   identities (differing by exactly one bit) for distinct
    //   supported opcodes.
    // -------------------------------------------------------------------

endmodule

module dut__ControlLogic (
    input  wire isRType,
    input  wire isIType,
    input  wire isLoad,
    input  wire isStore,
    input  wire isBranch,
    input  wire isJal,
    input  wire isJalr,
    input  wire isLui,
    input  wire isAuipc,

    output wire       ALUSrc,
    output wire       MemtoReg,
    output wire       RegWrite,
    output wire       MemRead,
    output wire       MemWrite,
    output wire [1:0] ALUOp,
    output wire       Branch,
    output wire       JalrSel,
    output wire [1:0] RWSel
);

    // -------------------------------------------------------------------
    // @alusrc: ALUSrc selects immediate operand for Load, Store, I-type,
    // AUIPC
    // -------------------------------------------------------------------
    assign ALUSrc = isLoad | isStore | isIType | isAuipc;

    // -------------------------------------------------------------------
    // @memtoreg: MemtoReg asserted only for Load
    // -------------------------------------------------------------------
    assign MemtoReg = isLoad;

    // -------------------------------------------------------------------
    // @regwrite: RegWrite asserted for all register write-back instructions
    // (R-type, I-type, Load, JAL, JALR, LUI, AUIPC). Deasserted for
    // Store/Branch. Also satisfies @cross consistency requirements:
    //   - RegWrite = 0 whenever ALUOp = 2'b01 (Branch)
    //   - MemRead implies RegWrite = 1 (Load asserts both)
    //   - MemWrite implies RegWrite = 0 (Store asserts neither)
    // -------------------------------------------------------------------
    assign RegWrite = isRType | isIType | isLoad | isJal | isJalr | isLui | isAuipc;

    // -------------------------------------------------------------------
    // @memread: MemRead asserted only for Load
    // -------------------------------------------------------------------
    assign MemRead = isLoad;

    // -------------------------------------------------------------------
    // @memwrite: MemWrite asserted only for Store
    // -------------------------------------------------------------------
    assign MemWrite = isStore;

    // -------------------------------------------------------------------
    // @aluop: ALUOp encodes ALU operation class per instruction type
    //   00 : Load / Store / AUIPC  (simple ADD for address/offset calc)
    //   01 : Branch                (subtraction/compare)
    //   10 : R-type / I-type       (full ALU op decode from funct fields)
    //   11 : JAL / LUI             (pass-through / no ALU compute needed)
    // -------------------------------------------------------------------
    assign ALUOp = (isLoad  | isStore | isAuipc) ? 2'b00 :
                   (isBranch)                    ? 2'b01 :
                   (isRType | isIType)            ? 2'b10 :
                   (isJal   | isLui)              ? 2'b11 :
                                                     2'b00; // default (unreachable if one-hot)

    // -------------------------------------------------------------------
    // @branch: Branch asserted for Branch-type instructions and JAL
    // (JAL always taken, uses same PC-target datapath as Branch)
    // -------------------------------------------------------------------
    assign Branch = isBranch | isJal;

    // -------------------------------------------------------------------
    // @jalrsel: JalrSel asserted only for JALR
    // -------------------------------------------------------------------
    assign JalrSel = isJalr;

    // -------------------------------------------------------------------
    // @rwsel: RWSel encodes write-back data source per instruction type
    //   00 : R-type / I-type / Load  (ALU result or memory data via MemtoReg)
    //   01 : JAL / JALR              (PC+4 return address)
    //   10 : LUI                     (immediate value)
    //   11 : AUIPC                   (PC + immediate)
    // Defaults to 00 for non-writing instructions (Store/Branch), per
    // @rwsel @dontcare scenario, since RegWrite = 0 makes RWSel irrelevant.
    // -------------------------------------------------------------------
    assign RWSel = (isRType | isIType | isLoad) ? 2'b00 :
                   (isJal   | isJalr)            ? 2'b01 :
                   (isLui)                       ? 2'b10 :
                   (isAuipc)                     ? 2'b11 :
                                                    2'b00; // default: Store/Branch or unreachable

endmodule
