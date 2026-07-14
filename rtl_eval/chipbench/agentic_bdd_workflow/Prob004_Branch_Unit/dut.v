module TopModule #(
    parameter PC_W = 9
) (
    input  [PC_W-1:0] Cur_PC,
    input  [31:0]      Imm,
    input               JalrSel,
    input               Branch,
    input  [31:0]      AluResult,
    output [31:0]      PC_Imm,
    output [31:0]      PC_Four,
    output [31:0]      BrPC,
    output              PcSel
);

    // Internal wire for Branch_Sel produced by ControlLogic
    wire Branch_Sel;

    //-------------------------------------------------------------------
    // Scenario: PC_Imm computes PC-relative target
    // PC_Imm = zero_extend(Cur_PC) + Imm
    //-------------------------------------------------------------------
    dut__PC_Adder u_PC_Imm_Adder (
        .Cur_PC  (Cur_PC),
        .Operand (Imm),
        .Sum     (PC_Imm)
    );

    //-------------------------------------------------------------------
    // Scenario: PC_Four computes sequential PC
    // PC_Four = zero_extend(Cur_PC) + 32'd4
    //-------------------------------------------------------------------
    dut__PC_Adder u_PC_Four_Adder (
        .Cur_PC  (Cur_PC),
        .Operand (32'd4),
        .Sum     (PC_Four)
    );

    //-------------------------------------------------------------------
    // Scenario: PcSel is asserted whenever JalrSel is asserted
    // Scenario: PcSel reflects branch taken condition when JalrSel is deasserted
    // Scenario: PcSel is the logical OR of JalrSel and Branch_Sel
    // ControlLogic computes Branch_Sel = Branch & AluResult[0]
    // and PcSel = JalrSel | Branch_Sel
    //-------------------------------------------------------------------
    dut__ControlLogic u_ControlLogic (
        .JalrSel    (JalrSel),
        .Branch     (Branch),
        .AluResult  (AluResult),
        .Branch_Sel (Branch_Sel),
        .PcSel      (PcSel)
    );

    //-------------------------------------------------------------------
    // Scenario: BrPC selects AluResult when JalrSel is asserted
    // Scenario: BrPC selects PC_Imm when Branch_Sel is asserted and JalrSel is deasserted
    // Scenario: BrPC is zero when neither JalrSel nor Branch_Sel is asserted
    // Scenario: BrPC follows priority mux of JalrSel then Branch_Sel then zero
    //-------------------------------------------------------------------
    dut__BrPCMux u_BrPCMux (
        .JalrSel    (JalrSel),
        .Branch_Sel (Branch_Sel),
        .AluResult  (AluResult),
        .PC_Imm     (PC_Imm),
        .BrPC       (BrPC)
    );

endmodule

module dut__PC_Adder #(
    parameter PC_W = 32   // Width of Cur_PC input (default 32 bits)
) (
    input  [PC_W-1:0] Cur_PC,   // Current program counter (PC_W bits)
    input  [31:0]     Operand,  // Operand to add (Imm or 32'd4)
    output [31:0]     Sum       // Resulting sum, 32 bits wide
);

    // Internal wire holding the zero-extended version of Cur_PC.
    // Scenario @zero_extension: upper (32-PC_W) bits are forced to 0,
    // ensuring no influence from bits outside the PC_W-bit range
    // (Scenario @unused_bits).
    wire [31:0] Cur_PC_ext;

    assign Cur_PC_ext = {{(32-PC_W){1'b0}}, Cur_PC};

    // Scenario @core: Sum = zero_extend(Cur_PC) + Operand, mod 2^32
    // Scenario @sequential_next_pc: works identically when Operand = 32'd4
    // Scenario @pc_relative_target: works identically when Operand = Imm
    // Scenario @boundary @zero_pc: if Cur_PC = 0, Sum = Operand
    // Scenario @boundary @zero_operand: if Operand = 0, Sum = zero_extend(Cur_PC)
    // Scenario @overflow: natural 32-bit addition wraps modulo 2^32
    // Scenario @combinational_purity: pure combinational assign, no state
    assign Sum = Cur_PC_ext + Operand;

endmodule

module dut__ControlLogic (
    input  wire        JalrSel,
    input  wire        Branch,
    input  wire [31:0] AluResult,
    output wire         Branch_Sel,
    output wire         PcSel
);

    // Scenario: Branch_Sel equals Branch AND AluResult bit 0
    // Also covers:
    //   - Branch_Sel deasserted when Branch is low (regardless of AluResult)
    //   - Branch_Sel deasserted when AluResult bit 0 is low (regardless of Branch)
    //   - Branch_Sel asserted when Branch=1 and AluResult[0]=1
    assign Branch_Sel = Branch & AluResult[0];

    // Scenario: PcSel equals JalrSel OR Branch_Sel
    // Also covers:
    //   - End-to-end: PcSel = JalrSel OR (Branch AND AluResult[0])
    //   - PcSel asserted when JalrSel=1 regardless of Branch_Sel
    //   - PcSel asserted when Branch_Sel=1 regardless of JalrSel
    //   - PcSel deasserted when both JalrSel and Branch_Sel are low
    //   - Consistency: Branch_Sel output equals internal value used for PcSel
    assign PcSel = JalrSel | Branch_Sel;

endmodule

module dut__BrPCMux (
    input               JalrSel,
    input               Branch_Sel,
    input      [31:0]   AluResult,
    input      [31:0]   PC_Imm,
    output reg [31:0]   BrPC
);

    // Combinational priority-encoded mux
    // Covers all Formal Scenarios:
    //  - JalrSel asserted selects AluResult regardless of Branch_Sel
    //  - Branch_Sel asserted selects PC_Imm when JalrSel deasserted
    //  - Both deasserted yields zero
    //  - JalrSel takes precedence over Branch_Sel when both asserted
    //  - Exhaustive coverage of all input combinations
    //  - No latch: all branches fully assigned, no memory across evaluations
    always @(*) begin
        if (JalrSel) begin
            // Scenario: JalrSel asserted selects AluResult regardless of Branch_Sel
            // Scenario: JalrSel takes precedence over Branch_Sel when both asserted
            BrPC = AluResult;
        end
        else if (Branch_Sel) begin
            // Scenario: Branch_Sel asserted selects PC_Imm when JalrSel is deasserted
            BrPC = PC_Imm;
        end
        else begin
            // Scenario: Both selects deasserted yields zero (default case)
            BrPC = 32'd0;
        end
    end

endmodule
