module TopModule #(
    parameter DATA_WIDTH    = 32,
    parameter OPCODE_LENGTH = 4
) (
    input  [DATA_WIDTH-1:0]    SrcA,
    input  [DATA_WIDTH-1:0]    SrcB,
    input  [OPCODE_LENGTH-1:0] Operation,
    output [DATA_WIDTH-1:0]    ALUResult
);

    // -------------------------------------------------------------------
    // Internal wires: results from each functional sub-unit
    // -------------------------------------------------------------------
    wire [31:0] ArithLogicResult;   // AND/OR/ADD/XOR  (Operation[3:2] = 00)
    wire [31:0] ShiftSubResult;     // SLL/SRL/SUB/SRA (Operation[3:2] = 01)
    wire [31:0] EqualityResult;     // EQ/NE/TRUE      (Operation[3:2] = 10)
    wire [31:0] CompareResult;      // SLT/SGE/SLTU/SGEU (Operation[3:2] = 11)

    // -------------------------------------------------------------------
    // Sub-unit instantiations
    // Lower 2 bits of Operation select the specific operation within
    // each unit's category.
    // -------------------------------------------------------------------

    // @and, @or, @add, @xor scenarios
    dut__ArithLogicUnit u_ArithLogicUnit (
        .SrcA   (SrcA),
        .SrcB   (SrcB),
        .sel    (Operation[1:0]),
        .Result (ArithLogicResult)
    );

    // @shift @left_shift, @shift @right_shift_logical, @sub, @shift @right_shift_arith
    dut__ShiftSubUnit u_ShiftSubUnit (
        .SrcA   (SrcA),
        .SrcB   (SrcB),
        .sel    (Operation[1:0]),
        .Result (ShiftSubResult)
    );

    // @compare @equal, @compare @not_equal, @const_true
    dut__EqualityUnit u_EqualityUnit (
        .SrcA   (SrcA),
        .SrcB   (SrcB),
        .sel    (Operation[1:0]),
        .Result (EqualityResult)
    );

    // @compare @signed_lt, @compare @signed_ge, @compare @unsigned_lt, @compare @unsigned_ge
    dut__CompareUnit u_CompareUnit (
        .SrcA   (SrcA),
        .SrcB   (SrcB),
        .sel    (Operation[1:0]),
        .Result (CompareResult)
    );

    // -------------------------------------------------------------------
    // Final result mux based on Operation[3:2]
    // Selects exactly one sub-unit result per the decoded category,
    // satisfying the @decode @exhaustive scenario (exactly one function
    // determines ALUResult) and the @combinational @no_state scenario
    // (pure combinational dependency on current SrcA, SrcB, Operation).
    // -------------------------------------------------------------------
    reg [31:0] alu_result_comb;

    always @(*) begin
        case (Operation[3:2])
            2'b00: alu_result_comb = ArithLogicResult; // AND/OR/ADD/XOR
            2'b01: alu_result_comb = ShiftSubResult;   // SLL/SRL/SUB/SRA
            2'b10: alu_result_comb = EqualityResult;   // EQ/NE/TRUE/unused
            2'b11: alu_result_comb = CompareResult;    // SLT/SGE/SLTU/SGEU
            default: alu_result_comb = 32'd0;          // unreachable, avoids latch
        endcase
    end

    assign ALUResult = alu_result_comb;

endmodule

module dut__ArithLogicUnit (
    input  [31:0] SrcA,
    input  [31:0] SrcB,
    input  [1:0]  sel,
    output [31:0] Result
);

    reg [31:0] result_comb;

    // Combinational operation selection - no internal state, no clock/reset.
    // Implements all Formal Scenarios via full case coverage of sel.
    always @(*) begin
        case (sel)
            // Scenario: Bitwise AND is selected when Operation is 00
            2'b00: result_comb = SrcA & SrcB;

            // Scenario: Bitwise OR is selected when Operation is 01
            2'b01: result_comb = SrcA | SrcB;

            // Scenario: 32-bit ADD with wraparound is selected when Operation is 10
            // Truncation to 32 bits happens naturally since result_comb is 32 bits wide;
            // no carry-out/overflow flag is generated or used.
            2'b10: result_comb = SrcA + SrcB;

            // Scenario: Bitwise XOR is selected when Operation is 11
            2'b11: result_comb = SrcA ^ SrcB;

            // Default branch (unreachable since sel covers all 2-bit values,
            // included to avoid inferred latches and satisfy full-case requirement)
            default: result_comb = 32'b0;
        endcase
    end

    // Result is a pure function of SrcA, SrcB, sel - satisfies
    // exhaustive_selector, no_other_op_dependency, and determinism scenarios.
    assign Result = result_comb;

endmodule

module dut__ShiftSubUnit (
    input  [31:0] SrcA,
    input  [31:0] SrcB,
    input  [1:0]  sel,
    output [31:0] Result
);

    // Shift amount is always derived from SrcB[4:0]
    wire [4:0] shift_amt = SrcB[4:0];

    reg [31:0] result_reg;

    always @(*) begin
        case (sel)
            // @logical_left_shift, @logical_left_shift_zero_amount,
            // @logical_left_shift_max_amount
            2'b00: result_reg = SrcA << shift_amt;

            // @logical_right_shift, @logical_right_shift_zero_fill,
            // @logical_right_shift_zero_amount
            2'b01: result_reg = SrcA >> shift_amt;

            // @subtraction, @subtraction_equal_operands,
            // @subtraction_independent_of_shift_amount
            2'b10: result_reg = SrcA - SrcB;

            // @arithmetic_right_shift, @arithmetic_right_shift_negative_sign_extends,
            // @arithmetic_right_shift_positive_zero_fills,
            // @arithmetic_right_shift_zero_amount
            2'b11: result_reg = $signed(SrcA) >>> shift_amt;

            // Default case to avoid latches (unreachable since sel is 2 bits
            // and all 4 combinations are covered above, but required for
            // completeness per synthesis guidelines)
            default: result_reg = 32'b0;
        endcase
    end

    // @combinational_stability, @operation_selector_exhaustive
    // Result is a pure function of current inputs, no internal state.
    assign Result = result_reg;

endmodule

module dut__EqualityUnit (
    input  [31:0] SrcA,
    input  [31:0] SrcB,
    input  [1:0]  sel,
    output [31:0] Result
);

    reg [31:0] Result_r;

    always @(*) begin
        case (sel)
            // Scenario: EQUAL operation selects sel=00
            2'b00: Result_r = (SrcA == SrcB) ? 32'd1 : 32'd0;

            // Scenario: NOT EQUAL operation selects sel=01
            2'b01: Result_r = (SrcA != SrcB) ? 32'd1 : 32'd0;

            // Scenario: ALWAYS TRUE operation selects sel=10
            2'b10: Result_r = 32'd1;

            // Scenario: Unused operation selects sel=11
            2'b11: Result_r = 32'd0;

            // Default branch to avoid latches (unreachable since sel covers all cases)
            default: Result_r = 32'd0;
        endcase
    end

    // Result is a purely combinational function of SrcA, SrcB, sel
    // (Scenarios: output_domain, mutual_exclusion, no_state are satisfied
    // by construction since this block has no memory elements.)
    assign Result = Result_r;

endmodule

module dut__CompareUnit (
    input  [31:0] SrcA,
    input  [31:0] SrcB,
    input  [1:0]  sel,
    output [31:0] Result
);

    reg [31:0] result_reg;

    always @(*) begin
        case (sel)
            // @signed_less_than: result = 1 if signed(SrcA) < signed(SrcB)
            2'b00: result_reg = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0;

            // @signed_greater_equal: result = 1 if signed(SrcA) >= signed(SrcB)
            2'b01: result_reg = ($signed(SrcA) >= $signed(SrcB)) ? 32'd1 : 32'd0;

            // @unsigned_less_than: result = 1 if SrcA < SrcB (unsigned)
            2'b10: result_reg = (SrcA < SrcB) ? 32'd1 : 32'd0;

            // @unsigned_greater_equal: result = 1 if SrcA >= SrcB (unsigned)
            2'b11: result_reg = (SrcA >= SrcB) ? 32'd1 : 32'd0;

            // Default case to avoid latches; should be unreachable since
            // sel is a full 2-bit value covering all cases above.
            default: result_reg = 32'd0;
        endcase
    end

    // @combinational_no_state: output depends only on current inputs
    // @output_range: result_reg is always 32'd0 or 32'd1 by construction
    assign Result = result_reg;

endmodule

module dut__ALUCore (
    input  [31:0] SrcA,
    input  [31:0] SrcB,
    input  [1:0]  OpSel,
    output reg [31:0] Result
);
    always @(*) begin
        case (OpSel)
            2'b00: Result = SrcA + SrcB;   // ADD
            2'b01: Result = SrcA - SrcB;   // SUB
            2'b10: Result = SrcA & SrcB;   // AND
            2'b11: Result = SrcA | SrcB;   // OR
            default: Result = 32'b0;
        endcase
    end
endmodule
