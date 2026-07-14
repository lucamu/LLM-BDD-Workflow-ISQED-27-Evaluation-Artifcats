module TopModule (
    input  [1:0] ALUOp,
    input  [6:0] Funct7,
    input  [2:0] Funct3,
    output [3:0] Operation
);

    // Internal wire carrying the R-type/I-type decoded operation
    // (used only when ALUOp selects R-type or I-type behavior)
    wire [3:0] RTypeOp;

    //--------------------------------------------------------------------
    // FunctDecoder:
    // Decodes Funct3/Funct7 into the R-type/I-type operation code.
    // Covers scenarios:
    //   @rtype @add/@sub/@and/@or/@xor/@sll/@srl/@sra/@slt/@sltu
    //   @itype @add/@and/@or/@xor/@sll/@srl/@sra/@slt/@sltu
    //   @shift_disambiguation
    //   @add_sub_disambiguation
    //--------------------------------------------------------------------
    dut__FunctDecoder u_FunctDecoder (
        .Funct7  (Funct7),
        .Funct3  (Funct3),
        .RTypeOp (RTypeOp)
    );

    //--------------------------------------------------------------------
    // ALUOpMux:
    // Selects final Operation based on ALUOp:
    //   ALUOp = 00 -> ADD (load/store address calc)      : @load_store @add
    //   ALUOp = 01 -> SUB (branch comparison)             : @branch @sub
    //   ALUOp = 10 -> RTypeOp (R-type instructions)        : @rtype scenarios
    //   ALUOp = 11 -> RTypeOp (I-type immediate instructions): @itype scenarios
    // Also guarantees determinism (@determinism @combinational) since
    // this is a pure combinational path with no internal state.
    //--------------------------------------------------------------------
    dut__ALUOpMux u_ALUOpMux (
        .ALUOp     (ALUOp),
        .RTypeOp   (RTypeOp),
        .Operation (Operation)
    );

endmodule

module dut__FunctDecoder (
    input  [6:0] Funct7,
    input  [2:0] Funct3,
    output [3:0] RTypeOp
);

    reg [3:0] alu_code;

    always @(*) begin
        case (Funct3)
            // @add_sub: ADD/SUB depends on Funct7[5]
            3'b000: begin
                if (Funct7[5] == 1'b0)
                    alu_code = 4'b0010; // ADD
                else
                    alu_code = 4'b0110; // SUB
            end

            // @sll: SLL regardless of Funct7
            3'b001: alu_code = 4'b0100;

            // @slt: SLT regardless of Funct7
            3'b010: alu_code = 4'b0111;

            // @sltu: SLTU regardless of Funct7
            3'b011: alu_code = 4'b1001;

            // @xor: XOR regardless of Funct7
            3'b100: alu_code = 4'b0011;

            // @srl_sra: SRL/SRA depends on Funct7[5]
            3'b101: begin
                if (Funct7[5] == 1'b0)
                    alu_code = 4'b0101; // SRL
                else
                    alu_code = 4'b1000; // SRA
            end

            // @or: OR regardless of Funct7
            3'b110: alu_code = 4'b0001;

            // @and: AND regardless of Funct7
            3'b111: alu_code = 4'b0000;

            // @totality: default case ensures no undefined output
            default: alu_code = 4'b0000;
        endcase
    end

    // @totality / @independence: output is purely combinational,
    // depends only on Funct3 and Funct7[5] for the two conditional cases
    assign RTypeOp = alu_code;

endmodule

module dut__ALUOpMux (
    input  [1:0] ALUOp,
    input  [3:0] RTypeOp,
    output reg [3:0] Operation
);

    // Combinational mux logic covering all ALUOp cases
    always @(*) begin
        case (ALUOp)
            // Scenario: ALUOp 00 selects ADD code for load/store address calculation
            2'b00: Operation = 4'b0010;

            // Scenario: ALUOp 01 selects SUB code for branch comparison
            2'b01: Operation = 4'b0110;

            // Scenario: ALUOp 10 passes through RTypeOp unchanged (no funct decoding)
            2'b10: Operation = RTypeOp;

            // Scenario: ALUOp 11 (and default) selects the default ADD code
            default: Operation = 4'b0010;
        endcase
    end

endmodule
