# ── module: OpcodeDecoder ──
Feature: RISC-V Opcode Decoder One-Hot Instruction Type Detection

  As a hardware verification engineer
  I want to formally verify the opcode decoder module
  So that each supported opcode maps to exactly one asserted instruction-type signal and unsupported opcodes assert none

  Background:
    Given the design is purely combinational with no clock or reset
    And the Opcode input is a 7-bit value
    And the outputs are is_R_type, is_I_type, is_Load, is_Store, is_Branch, is_JAL, is_JALR, is_LUI, is_AUIPC

  @onehot @r-type
  Formal Scenario: R-type opcode asserts only is_R_type
    Given Opcode equals 7'b0110011
    Then is_R_type should be 1
    And is_I_type should be 0
    And is_Load should be 0
    And is_Store should be 0
    And is_Branch should be 0
    And is_JAL should be 0
    And is_JALR should be 0
    And is_LUI should be 0
    And is_AUIPC should be 0

  @onehot @i-type
  Formal Scenario: I-type ALU/immediate opcode asserts only is_I_type
    Given Opcode equals 7'b0010011
    Then is_I_type should be 1
    And is_R_type should be 0
    And is_Load should be 0
    And is_Store should be 0
    And is_Branch should be 0
    And is_JAL should be 0
    And is_JALR should be 0
    And is_LUI should be 0
    And is_AUIPC should be 0

  @onehot @load
  Formal Scenario: Load opcode asserts only is_Load
    Given Opcode equals 7'b0000011
    Then is_Load should be 1
    And is_R_type should be 0
    And is_I_type should be 0
    And is_Store should be 0
    And is_Branch should be 0
    And is_JAL should be 0
    And is_JALR should be 0
    And is_LUI should be 0
    And is_AUIPC should be 0

  @onehot @store
  Formal Scenario: Store opcode asserts only is_Store
    Given Opcode equals 7'b0100011
    Then is_Store should be 1
    And is_R_type should be 0
    And is_I_type should be 0
    And is_Load should be 0
    And is_Branch should be 0
    And is_JAL should be 0
    And is_JALR should be 0
    And is_LUI should be 0
    And is_AUIPC should be 0

  @onehot @branch
  Formal Scenario: Branch opcode asserts only is_Branch
    Given Opcode equals 7'b1100011
    Then is_Branch should be 1
    And is_R_type should be 0
    And is_I_type should be 0
    And is_Load should be 0
    And is_Store should be 0
    And is_JAL should be 0
    And is_JALR should be 0
    And is_LUI should be 0
    And is_AUIPC should be 0

  @onehot @jal
  Formal Scenario: JAL opcode asserts only is_JAL
    Given Opcode equals 7'b1101111
    Then is_JAL should be 1
    And is_R_type should be 0
    And is_I_type should be 0
    And is_Load should be 0
    And is_Store should be 0
    And is_Branch should be 0
    And is_JALR should be 0
    And is_LUI should be 0
    And is_AUIPC should be 0

  @onehot @jalr
  Formal Scenario: JALR opcode asserts only is_JALR
    Given Opcode equals 7'b1100111
    Then is_JALR should be 1
    And is_R_type should be 0
    And is_I_type should be 0
    And is_Load should be 0
    And is_Store should be 0
    And is_Branch should be 0
    And is_JAL should be 0
    And is_LUI should be 0
    And is_AUIPC should be 0

  @onehot @lui
  Formal Scenario: LUI opcode asserts only is_LUI
    Given Opcode equals 7'b0110111
    Then is_LUI should be 1
    And is_R_type should be 0
    And is_I_type should be 0
    And is_Load should be 0
    And is_Store should be 0
    And is_Branch should be 0
    And is_JAL should be 0
    And is_JALR should be 0
    And is_AUIPC should be 0

  @onehot @auipc
  Formal Scenario: AUIPC opcode asserts only is_AUIPC
    Given Opcode equals 7'b0010111
    Then is_AUIPC should be 1
    And is_R_type should be 0
    And is_I_type should be 0
    And is_Load should be 0
    And is_Store should be 0
    And is_Branch should be 0
    And is_JAL should be 0
    And is_JALR should be 0
    And is_LUI should be 0

  @exclusivity @exhaustive
  Formal Scenario: At most one instruction-type output is asserted for any opcode value
    Given Opcode is any 7-bit value X
    Then the sum of is_R_type, is_I_type, is_Load, is_Store, is_Branch, is_JAL, is_JALR, is_LUI, and is_AUIPC should be less than or equal to 1

  @undefined @default
  Formal Scenario: Unsupported opcode asserts no instruction-type output
    Given Opcode is any 7-bit value X
    And X does not equal 7'b0110011
    And X does not equal 7'b0010011
    And X does not equal 7'b0000011
    And X does not equal 7'b0100011
    And X does not equal 7'b1100011
    And X does not equal 7'b1101111
    And X does not equal 7'b1100111
    And X does not equal 7'b0110111
    And X does not equal 7'b0010111
    Then is_R_type should be 0
    And is_I_type should be 0
    And is_Load should be 0
    And is_Store should be 0
    And is_Branch should be 0
    And is_JAL should be 0
    And is_JALR should be 0
    And is_LUI should be 0
    And is_AUIPC should be 0

  @combinational @no-state
  Formal Scenario: Outputs depend only on the current Opcode value with no memory
    Given Opcode equals value X at any evaluation instant
    Then the output vector formed by is_R_type, is_I_type, is_Load, is_Store, is_Branch, is_JAL, is_JALR, is_LUI, and is_AUIPC is a pure function of X only
    And re-evaluating the module with the same X produces the identical output vector

  @stability @glitch-free-check
  Formal Scenario: Distinct opcode encodings never produce identical asserted output identity
    Given Opcode equals 7'b0110011 producing output identity A
    And Opcode equals 7'b0010011 producing output identity B
    Then A should not equal B
    And exactly one bit differs between the corresponding one-hot output vectors of A and B

# ── module: ControlLogic ──
Feature: RISC-V Control Signal Generator

  Combinational generation of RISC-V control signals (ALUSrc, MemtoReg,
  RegWrite, MemRead, MemWrite, ALUOp, Branch, JalrSel, RWSel) from the
  one-hot instruction-type indicator signals produced by OpcodeDecoder.

  Background:
    Given a combinational control unit with no clock and no reset
    And the one-hot instruction-type signals isRType, isIType, isLoad, isStore, isBranch, isJAL, isJALR, isLUI, isAUIPC
    And exactly one of isRType, isIType, isLoad, isStore, isBranch, isJAL, isJALR, isLUI, isAUIPC is asserted at any time
    And all control outputs are generated combinationally from these signals

  @onehot @wellformed
  Formal Scenario: Instruction-type indicator signals are one-hot
    Given the instruction-type signals isRType, isIType, isLoad, isStore, isBranch, isJAL, isJALR, isLUI, isAUIPC
    When the control unit evaluates the instruction type
    Then exactly one of isRType, isIType, isLoad, isStore, isBranch, isJAL, isJALR, isLUI, isAUIPC should equal 1

  @alusrc
  Formal Scenario: ALUSrc selects immediate operand for Load, Store, I-type, AUIPC
    Given the instruction-type signals isRType, isIType, isLoad, isStore, isBranch, isJAL, isJALR, isLUI, isAUIPC
    When the control signals are generated combinationally
    Then ALUSrc should equal (isLoad OR isStore OR isIType OR isAUIPC)

  @memtoreg
  Formal Scenario: MemtoReg is asserted only for Load
    Given the instruction-type signals isRType, isIType, isLoad, isStore, isBranch, isJAL, isJALR, isLUI, isAUIPC
    When the control signals are generated combinationally
    Then MemtoReg should equal isLoad

  @regwrite
  Formal Scenario: RegWrite is asserted for all register write-back instructions
    Given the instruction-type signals isRType, isIType, isLoad, isStore, isBranch, isJAL, isJALR, isLUI, isAUIPC
    When the control signals are generated combinationally
    Then RegWrite should equal (isRType OR isIType OR isLoad OR isJAL OR isJALR OR isLUI OR isAUIPC)
    And RegWrite should equal 0 when (isStore OR isBranch) equals 1

  @memread
  Formal Scenario: MemRead is asserted only for Load
    Given the instruction-type signals isRType, isIType, isLoad, isStore, isBranch, isJAL, isJALR, isLUI, isAUIPC
    When the control signals are generated combinationally
    Then MemRead should equal isLoad

  @memwrite
  Formal Scenario: MemWrite is asserted only for Store
    Given the instruction-type signals isRType, isIType, isLoad, isStore, isBranch, isJAL, isJALR, isLUI, isAUIPC
    When the control signals are generated combinationally
    Then MemWrite should equal isStore

  @aluop
  Formal Scenario: ALUOp encodes the ALU operation class per instruction type
    Given the instruction-type signals isRType, isIType, isLoad, isStore, isBranch, isJAL, isJALR, isLUI, isAUIPC
    When the control signals are generated combinationally
    Then ALUOp should equal 2'b00 if (isLoad OR isStore OR isAUIPC) equals 1
    And ALUOp should equal 2'b01 if isBranch equals 1
    And ALUOp should equal 2'b10 if (isRType OR isIType) equals 1
    And ALUOp should equal 2'b11 if (isJAL OR isLUI) equals 1

  @branch
  Formal Scenario: Branch is asserted for Branch-type instructions and JAL
    Given the instruction-type signals isRType, isIType, isLoad, isStore, isBranch, isJAL, isJALR, isLUI, isAUIPC
    When the control signals are generated combinationally
    Then Branch should equal (isBranch OR isJAL)

  @jalrsel
  Formal Scenario: JalrSel is asserted only for JALR
    Given the instruction-type signals isRType, isIType, isLoad, isStore, isBranch, isJAL, isJALR, isLUI, isAUIPC
    When the control signals are generated combinationally
    Then JalrSel should equal isJALR

  @rwsel
  Formal Scenario: RWSel encodes the write-back data source per instruction type
    Given the instruction-type signals isRType, isIType, isLoad, isStore, isBranch, isJAL, isJALR, isLUI, isAUIPC
    When the control signals are generated combinationally
    Then RWSel should equal 2'b00 if (isRType OR isIType OR isLoad) equals 1
    And RWSel should equal 2'b01 if (isJAL OR isJALR) equals 1
    And RWSel should equal 2'b10 if isLUI equals 1
    And RWSel should equal 2'b11 if isAUIPC equals 1

  @rwsel @dontcare
  Formal Scenario: RWSel defaults to 00 for non-writing instructions
    Given the instruction-type signals isRType, isIType, isLoad, isStore, isBranch, isJAL, isJALR, isLUI, isAUIPC
    When the control signals are generated combinationally
    And (isStore OR isBranch) equals 1
    Then RegWrite should equal 0
    And RWSel should equal 2'b00

  @cross @consistency
  Formal Scenario: RegWrite is consistent with ALUOp and RWSel classification
    Given the instruction-type signals isRType, isIType, isLoad, isStore, isBranch, isJAL, isJALR, isLUI, isAUIPC
    When the control signals are generated combinationally
    Then RegWrite should equal 0 whenever ALUOp equals 2'b01
    And MemtoReg should equal 0 whenever RegWrite equals 0
    And MemRead should imply RegWrite equals 1
    And MemWrite should imply RegWrite equals 0

# ── module: TopModule ──
Feature: RISC-V Single-Cycle Controller (TopModule) Control Signal Generation

  This feature formally specifies the combinational control logic that decodes
  the 7-bit RISC-V Opcode field into the datapath control signals: ALUSrc,
  MemtoReg, RegWrite, MemRead, MemWrite, ALUOp, Branch, JalrSel, and RWSel.

  Background:
    Given the design TopModule is combinational with no clock or reset
    And the input Opcode is a 7-bit value
    And the outputs ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, JalrSel are 1-bit values
    And the outputs ALUOp and RWSel are 2-bit values

  @rtype @opcode_decode
  Formal Scenario: R-type instruction control signals (opcode 0110011)
    Given Opcode equals 7'b0110011
    Then ALUSrc should be 0
    And MemtoReg should be 0
    And RegWrite should be 1
    And MemRead should be 0
    And MemWrite should be 0
    And ALUOp should be 2'b10
    And Branch should be 0
    And JalrSel should be 0
    And RWSel should be 2'b00

  @itype_arith @opcode_decode
  Formal Scenario: I-type arithmetic instruction control signals (opcode 0010011)
    Given Opcode equals 7'b0010011
    Then ALUSrc should be 1
    And MemtoReg should be 0
    And RegWrite should be 1
    And MemRead should be 0
    And MemWrite should be 0
    And ALUOp should be 2'b10
    And Branch should be 0
    And JalrSel should be 0
    And RWSel should be 2'b00

  @load @opcode_decode
  Formal Scenario: Load word instruction control signals (opcode 0000011)
    Given Opcode equals 7'b0000011
    Then ALUSrc should be 1
    And MemtoReg should be 1
    And RegWrite should be 1
    And MemRead should be 1
    And MemWrite should be 0
    And ALUOp should be 2'b00
    And Branch should be 0
    And JalrSel should be 0
    And RWSel should be 2'b00

  @store @opcode_decode
  Formal Scenario: Store word instruction control signals (opcode 0100011)
    Given Opcode equals 7'b0100011
    Then ALUSrc should be 1
    And RegWrite should be 0
    And MemRead should be 0
    And MemWrite should be 1
    And ALUOp should be 2'b00
    And Branch should be 0
    And JalrSel should be 0

  @branch @opcode_decode
  Formal Scenario: Conditional branch instruction control signals (opcode 1100011)
    Given Opcode equals 7'b1100011
    Then ALUSrc should be 0
    And RegWrite should be 0
    And MemRead should be 0
    And MemWrite should be 0
    And ALUOp should be 2'b01
    And Branch should be 1
    And JalrSel should be 0

  @jal @opcode_decode
  Formal Scenario: JAL instruction control signals (opcode 1101111)
    Given Opcode equals 7'b1101111
    Then RegWrite should be 1
    And MemRead should be 0
    And MemWrite should be 0
    And ALUOp should be 2'b11
    And Branch should be 1
    And JalrSel should be 0
    And RWSel should be 2'b01

  @jalr @opcode_decode
  Formal Scenario: JALR instruction control signals (opcode 1100111)
    Given Opcode equals 7'b1100111
    Then ALUSrc should be 1
    And RegWrite should be 1
    And MemRead should be 0
    And MemWrite should be 0
    And Branch should be 0
    And JalrSel should be 1
    And RWSel should be 2'b01

  @lui @opcode_decode
  Formal Scenario: LUI instruction control signals (opcode 0110111)
    Given Opcode equals 7'b0110111
    Then RegWrite should be 1
    And MemRead should be 0
    And MemWrite should be 0
    And ALUOp should be 2'b11
    And Branch should be 0
    And JalrSel should be 0
    And RWSel should be 2'b10

  @auipc @opcode_decode
  Formal Scenario: AUIPC instruction control signals (opcode 0010111)
    Given Opcode equals 7'b0010111
    Then ALUSrc should be 1
    And RegWrite should be 1
    And MemRead should be 0
    And MemWrite should be 0
    And ALUOp should be 2'b00
    And Branch should be 0
    And JalrSel should be 0
    And RWSel should be 2'b11

  @invariant @mutual_exclusion
  Formal Scenario: MemRead and MemWrite are never asserted simultaneously
    Given Opcode is any valid 7-bit value
    Then it should not be the case that MemRead equals 1 and MemWrite equals 1

  @invariant @branch_condition
  Formal Scenario: Branch is asserted only for branch and JAL opcodes
    Given Opcode is any valid 7-bit value
    Then Branch should be 1 if Opcode equals 7'b1100011 or Opcode equals 7'b1101111
    And Branch should be 0 if Opcode is not equal to 7'b1100011 and Opcode is not equal to 7'b1101111

  @invariant @jalrsel_condition
  Formal Scenario: JalrSel is asserted only for the JALR opcode
    Given Opcode is any valid 7-bit value
    Then JalrSel should be 1 if Opcode equals 7'b1100111
    And JalrSel should be 0 if Opcode is not equal to 7'b1100111

  @invariant @regwrite_condition
  Formal Scenario: RegWrite is deasserted for store and branch instructions
    Given Opcode is any valid 7-bit value
    Then RegWrite should be 0 if Opcode equals 7'b0100011 or Opcode equals 7'b1100011

  @invariant @rwsel_encoding
  Formal Scenario: RWSel encodes writeback source consistently with opcode
    Given Opcode is any valid 7-bit value
    Then RWSel should be 2'b01 if Opcode equals 7'b1101111 or Opcode equals 7'b1100111
    And RWSel should be 2'b10 if Opcode equals 7'b0110111
    And RWSel should be 2'b11 if Opcode equals 7'b0010111
    And RWSel should be 2'b00 if Opcode equals 7'b0110011 or Opcode equals 7'b0010011 or Opcode equals 7'b0000011

  @invariant @aluop_encoding
  Formal Scenario: ALUOp encodes instruction class consistently with opcode
    Given Opcode is any valid 7-bit value
    Then ALUOp should be 2'b00 if Opcode equals 7'b0000011 or Opcode equals 7'b0100011 or Opcode equals 7'b0010111
    And ALUOp should be 2'b01 if Opcode equals 7'b1100011
    And ALUOp should be 2'b10 if Opcode equals 7'b0110011 or Opcode equals 7'b0010011
    And ALUOp should be 2'b11 if Opcode equals 7'b1101111 or Opcode equals 7'b0110111