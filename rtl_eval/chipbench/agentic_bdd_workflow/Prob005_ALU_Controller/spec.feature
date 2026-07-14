# ── module: FunctDecoder ──
Feature: ALU Control Decoder Combinational Logic
  Purely combinational decoder that generates a 4-bit ALU operation code
  based on Funct3 and Funct7 fields of R-type/I-type instructions.
  Output is independent of any clock, reset, or ALUOp signal.

  Background:
    Given the design is purely combinational with no clock or reset
    And ALUOp has no effect on the output ALU code
    And Funct3 is a 3-bit input signal
    And Funct7 is a 7-bit input signal
    And ALUCode is the 4-bit combinational output

  @combinational @add_sub
  Formal Scenario: ADD/SUB selection depends on Funct7 bit 5 when Funct3 is 000
    Given Funct3 equals 3'b000
    And Funct7 is any valid 7-bit value
    When the decoder evaluates the inputs combinationally
    Then ALUCode should be 4'b0010 if Funct7[5] equals 0
    And ALUCode should be 4'b0110 if Funct7[5] equals 1

  @combinational @sll
  Formal Scenario: SLL selection for Funct3 equal to 001
    Given Funct3 equals 3'b001
    And Funct7 is any valid 7-bit value
    When the decoder evaluates the inputs combinationally
    Then ALUCode should be 4'b0100 regardless of Funct7

  @combinational @slt
  Formal Scenario: SLT selection for Funct3 equal to 010
    Given Funct3 equals 3'b010
    And Funct7 is any valid 7-bit value
    When the decoder evaluates the inputs combinationally
    Then ALUCode should be 4'b0111 regardless of Funct7

  @combinational @sltu
  Formal Scenario: SLTU selection for Funct3 equal to 011
    Given Funct3 equals 3'b011
    And Funct7 is any valid 7-bit value
    When the decoder evaluates the inputs combinationally
    Then ALUCode should be 4'b1001 regardless of Funct7

  @combinational @xor
  Formal Scenario: XOR selection for Funct3 equal to 100
    Given Funct3 equals 3'b100
    And Funct7 is any valid 7-bit value
    When the decoder evaluates the inputs combinationally
    Then ALUCode should be 4'b0011 regardless of Funct7

  @combinational @srl_sra
  Formal Scenario: SRL/SRA selection depends on Funct7 bit 5 when Funct3 is 101
    Given Funct3 equals 3'b101
    And Funct7 is any valid 7-bit value
    When the decoder evaluates the inputs combinationally
    Then ALUCode should be 4'b0101 if Funct7[5] equals 0
    And ALUCode should be 4'b1000 if Funct7[5] equals 1

  @combinational @or
  Formal Scenario: OR selection for Funct3 equal to 110
    Given Funct3 equals 3'b110
    And Funct7 is any valid 7-bit value
    When the decoder evaluates the inputs combinationally
    Then ALUCode should be 4'b0001 regardless of Funct7

  @combinational @and
  Formal Scenario: AND selection for Funct3 equal to 111
    Given Funct3 equals 3'b111
    And Funct7 is any valid 7-bit value
    When the decoder evaluates the inputs combinationally
    Then ALUCode should be 4'b0000 regardless of Funct7

  @combinational @independence
  Formal Scenario: Output depends only on Funct3 and Funct7[5], never on ALUOp
    Given Funct3 is any valid 3-bit value
    And Funct7 is any valid 7-bit value
    And ALUOp is any valid value
    When the decoder evaluates the inputs combinationally
    Then ALUCode should remain identical for any change in ALUOp
    And ALUCode should remain identical for any change in Funct7 bits other than bit 5
    when Funct3 equals 3'b000 or Funct3 equals 3'b101

  @combinational @totality
  Formal Scenario: Decoder produces a defined output for every valid input combination
    Given Funct3 is any valid 3-bit value
    And Funct7 is any valid 7-bit value
    When the decoder evaluates the inputs combinationally
    Then ALUCode should always be one of the nine defined 4-bit codes
    And no input combination should produce an undefined or unknown output

# ── module: ALUOpMux ──
Feature: ALU Control Operation Code Multiplexer

  As a hardware verification engineer
  I want to formally verify the ALU Control mux
  So that the correct 4-bit Operation code is selected based on ALUOp and RTypeOp

  Background:
    Given a combinational module with no clock and no reset
    And a 2-bit input signal ALUOp
    And a 4-bit input signal RTypeOp representing the pre-decoded R-type/I-type function code
    And a 4-bit output signal Operation
    And the output Operation is a pure combinational function of ALUOp and RTypeOp

  @combinational @mux @load_store
  Formal Scenario: ALUOp 00 selects the ADD code for load/store address calculation
    Given ALUOp is 2'b00
    And RTypeOp is any value X
    When the mux evaluates the Operation output
    Then Operation should equal 4'b0010
    And Operation should not depend on the value of X

  @combinational @mux @branch
  Formal Scenario: ALUOp 01 selects the SUB code for branch comparison
    Given ALUOp is 2'b01
    And RTypeOp is any value X
    When the mux evaluates the Operation output
    Then Operation should equal 4'b0110
    And Operation should not depend on the value of X

  @combinational @mux @rtype_passthrough
  Formal Scenario: ALUOp 10 passes through the RTypeOp value unchanged
    Given ALUOp is 2'b10
    And RTypeOp is any value X
    When the mux evaluates the Operation output
    Then Operation should equal X

  @combinational @mux @default
  Formal Scenario: ALUOp 11 selects the default ADD code
    Given ALUOp is 2'b11
    And RTypeOp is any value X
    When the mux evaluates the Operation output
    Then Operation should equal 4'b0010
    And Operation should not depend on the value of X

  @combinational @mux @no_funct_decoding
  Formal Scenario: Module performs no internal funct decoding for R-type selection
    Given ALUOp is 2'b10
    And RTypeOp is any value X
    When the mux evaluates the Operation output
    Then Operation should equal X exactly
    And the module should not modify or reinterpret X in any way

  @combinational @mux @exhaustive_coverage
  Formal Scenario: Operation output is fully determined by ALUOp and RTypeOp for all cases
    Given ALUOp is any value A
    And RTypeOp is any value X
    When the mux evaluates the Operation output
    Then Operation should equal 4'b0010 if A equals 2'b00
    And Operation should equal 4'b0110 if A equals 2'b01
    And Operation should equal X if A equals 2'b10
    And Operation should equal 4'b0010 if A equals 2'b11

  @combinational @mux @no_latch
  Formal Scenario: Output has no memory and responds only to current inputs
    Given ALUOp transitions from any value A1 to any value A2
    And RTypeOp transitions from any value X1 to any value X2
    When the mux evaluates the Operation output after the transition
    Then Operation should depend only on A2 and X2
    And Operation should not retain any influence from A1 or X1

# ── module: TopModule ──
Feature: RISC-V ALU Control Decoder (TopModule)

  As a hardware designer
  I want the ALU control decoder to translate ALUOp, Funct3, and Funct7
  into a correct 4-bit Operation code
  So that the downstream ALU performs the correct arithmetic/logic/shift/compare operation

  Background:
    Given TopModule is a purely combinational circuit with no clock and no reset
    And ALUOp is a 2-bit input
    And Funct3 is a 3-bit input
    And Funct7 is a 7-bit input
    And Operation is a 4-bit output
    And Operation depends only on the current values of ALUOp, Funct3, and Funct7

  @determinism @combinational
  Formal Scenario: Output is a pure function of the current inputs
    Given ALUOp holds value A
    And Funct3 holds value F3
    And Funct7 holds value F7
    When the same values A, F3, F7 are applied again in any later cycle
    Then Operation should be identical to the Operation produced the first time A, F3, F7 were applied

  @load_store @add
  Formal Scenario: Memory address calculation always selects ADD
    Given ALUOp is 2'b00
    And Funct3 holds any value F3
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b0000
    And Operation should not depend on the value of F3
    And Operation should not depend on the value of F7

  @branch @sub
  Formal Scenario: Branch comparison always selects SUB
    Given ALUOp is 2'b01
    And Funct3 holds any value F3
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b0001
    And Operation should not depend on the value of F3
    And Operation should not depend on the value of F7

  @rtype @add
  Formal Scenario: R-type ADD selection
    Given ALUOp is 2'b10
    And Funct3 is 3'b000
    And Funct7 is 7'b0000000
    When Operation is computed
    Then Operation should be 4'b0000

  @rtype @sub
  Formal Scenario: R-type SUB selection
    Given ALUOp is 2'b10
    And Funct3 is 3'b000
    And Funct7 is 7'b0100000
    When Operation is computed
    Then Operation should be 4'b0001

  @rtype @and
  Formal Scenario: R-type AND selection is independent of Funct7
    Given ALUOp is 2'b10
    And Funct3 is 3'b111
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b0010
    And Operation should not depend on the value of F7

  @rtype @or
  Formal Scenario: R-type OR selection is independent of Funct7
    Given ALUOp is 2'b10
    And Funct3 is 3'b110
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b0011
    And Operation should not depend on the value of F7

  @rtype @xor
  Formal Scenario: R-type XOR selection is independent of Funct7
    Given ALUOp is 2'b10
    And Funct3 is 3'b100
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b0100
    And Operation should not depend on the value of F7

  @rtype @sll
  Formal Scenario: R-type SLL selection is independent of Funct7
    Given ALUOp is 2'b10
    And Funct3 is 3'b001
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b0101
    And Operation should not depend on the value of F7

  @rtype @srl
  Formal Scenario: R-type SRL selection
    Given ALUOp is 2'b10
    And Funct3 is 3'b101
    And Funct7 is 7'b0000000
    When Operation is computed
    Then Operation should be 4'b0110

  @rtype @sra
  Formal Scenario: R-type SRA selection
    Given ALUOp is 2'b10
    And Funct3 is 3'b101
    And Funct7 is 7'b0100000
    When Operation is computed
    Then Operation should be 4'b0111

  @rtype @slt
  Formal Scenario: R-type SLT selection is independent of Funct7
    Given ALUOp is 2'b10
    And Funct3 is 3'b010
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b1000
    And Operation should not depend on the value of F7

  @rtype @sltu
  Formal Scenario: R-type SLTU selection is independent of Funct7
    Given ALUOp is 2'b10
    And Funct3 is 3'b011
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b1001
    And Operation should not depend on the value of F7

  @itype @add
  Formal Scenario: I-type immediate ADD always selects ADD regardless of Funct7
    Given ALUOp is 2'b11
    And Funct3 is 3'b000
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b0000
    And Operation should not depend on the value of F7

  @itype @and
  Formal Scenario: I-type immediate AND selection is independent of Funct7
    Given ALUOp is 2'b11
    And Funct3 is 3'b111
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b0010
    And Operation should not depend on the value of F7

  @itype @or
  Formal Scenario: I-type immediate OR selection is independent of Funct7
    Given ALUOp is 2'b11
    And Funct3 is 3'b110
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b0011
    And Operation should not depend on the value of F7

  @itype @xor
  Formal Scenario: I-type immediate XOR selection is independent of Funct7
    Given ALUOp is 2'b11
    And Funct3 is 3'b100
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b0100
    And Operation should not depend on the value of F7

  @itype @sll
  Formal Scenario: I-type immediate SLL selection is independent of Funct7
    Given ALUOp is 2'b11
    And Funct3 is 3'b001
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b0101
    And Operation should not depend on the value of F7

  @itype @srl
  Formal Scenario: I-type immediate SRLI selection
    Given ALUOp is 2'b11
    And Funct3 is 3'b101
    And Funct7 is 7'b0000000
    When Operation is computed
    Then Operation should be 4'b0110

  @itype @sra
  Formal Scenario: I-type immediate SRAI selection
    Given ALUOp is 2'b11
    And Funct3 is 3'b101
    And Funct7 is 7'b0100000
    When Operation is computed
    Then Operation should be 4'b0111

  @itype @slt
  Formal Scenario: I-type immediate SLTI selection is independent of Funct7
    Given ALUOp is 2'b11
    And Funct3 is 3'b010
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b1000
    And Operation should not depend on the value of F7

  @itype @sltu
  Formal Scenario: I-type immediate SLTIU selection is independent of Funct7
    Given ALUOp is 2'b11
    And Funct3 is 3'b011
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b1001
    And Operation should not depend on the value of F7

  @shift_disambiguation
  Formal Scenario: Only bit 5 of Funct7 distinguishes SRL/SRLI from SRA/SRAI
    Given ALUOp is either 2'b10 or 2'b11
    And Funct3 is 3'b101
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b0111 if bit 5 of F7 equals 1
    And Operation should be 4'b0110 if bit 5 of F7 equals 0

  @add_sub_disambiguation
  Formal Scenario: Only bit 5 of Funct7 distinguishes ADD from SUB for R-type Funct3 000
    Given ALUOp is 2'b10
    And Funct3 is 3'b000
    And Funct7 holds any value F7
    When Operation is computed
    Then Operation should be 4'b0001 if bit 5 of F7 equals 1
    And Operation should be 4'b0000 if bit 5 of F7 equals 0