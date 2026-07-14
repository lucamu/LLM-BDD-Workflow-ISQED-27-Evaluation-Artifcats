# ── module: PC_Adder ──
Feature: Combinational PC-Relative Adder
  Zero-extends a PC_W-bit Cur_PC input to 32 bits and adds it to a
  32-bit Operand to produce a 32-bit Sum. This adder is reused both
  to compute a PC-relative branch/jump target (Operand = Imm) and to
  compute the sequential next PC (Operand = 32'd4).

  Background:
    Given a combinational adder with inputs Cur_PC (PC_W bits) and Operand (32 bits)
    And the output Sum is 32 bits wide
    And Cur_PC is zero-extended to 32 bits before addition
    And Sum is purely combinational with no internal state

  @core @addition
  Formal Scenario: Sum equals zero-extended Cur_PC plus Operand
    Given Cur_PC has value X
    And Operand has value Y
    When the adder computes its output
    Then Sum should equal (zero_extend(X, 32) + Y) mod 2^32

  @zero_extension
  Formal Scenario: Zero extension pads upper bits with zero before addition
    Given Cur_PC has value X
    And Operand has value 32'd0
    When the adder computes its output
    Then Sum should equal zero_extend(X, 32)
    And the upper (32 - PC_W) bits of the zero-extended Cur_PC should be 0

  @sequential_next_pc
  Formal Scenario: Sequential next PC computation with Operand equal to 4
    Given Cur_PC has value X
    And Operand has value 32'd4
    When the adder computes its output
    Then Sum should equal (zero_extend(X, 32) + 32'd4) mod 2^32

  @pc_relative_target
  Formal Scenario: PC-relative target computation with arbitrary immediate
    Given Cur_PC has value X
    And Operand has value Imm
    When the adder computes its output
    Then Sum should equal (zero_extend(X, 32) + Imm) mod 2^32

  @boundary @zero_pc
  Formal Scenario: Zero Cur_PC yields Sum equal to Operand
    Given Cur_PC has value PC_W'd0
    And Operand has value Y
    When the adder computes its output
    Then Sum should equal Y

  @boundary @zero_operand
  Formal Scenario: Zero Operand yields Sum equal to zero-extended Cur_PC
    Given Cur_PC has value X
    And Operand has value 32'd0
    When the adder computes its output
    Then Sum should equal zero_extend(X, 32)

  @overflow
  Formal Scenario: Sum wraps modulo 2^32 on overflow
    Given Cur_PC has value X
    And Operand has value Y
    And the true sum zero_extend(X, 32) + Y exceeds 32 bits
    When the adder computes its output
    Then Sum should equal (zero_extend(X, 32) + Y) mod 2^32

  @combinational_purity
  Formal Scenario: Output depends only on current inputs
    Given Cur_PC has value X
    And Operand has value Y
    When the adder computes its output with the same input values X and Y at any evaluation instant
    Then Sum should always equal (zero_extend(X, 32) + Y) mod 2^32
    And Sum should not depend on any prior input values or internal history

  @unused_bits
  Formal Scenario: Cur_PC bits beyond PC_W do not affect Sum
    Given Cur_PC has value X constrained to PC_W bits
    And Operand has value Y
    When the adder computes its output
    Then Sum should equal (zero_extend(X, 32) + Y) mod 2^32
    And Sum should not be influenced by any bits outside the PC_W-bit range of Cur_PC

# ── module: ControlLogic ──
Feature: Branch and PC Select Combinational Logic

  This feature verifies the combinational computation of the internal
  Branch_Sel signal and the top-level PcSel output.
  Branch_Sel is defined as (Branch AND AluResult[0]).
  PcSel is defined as (JalrSel OR Branch_Sel).
  This is purely combinational logic with no clock or reset.

  Background:
    Given the design is combinational with no clock or reset dependency
    And Branch is a 1-bit input signal
    And JalrSel is a 1-bit input signal
    And AluResult is a multi-bit input bus
    And Branch_Sel is a 1-bit internal signal exposed as output
    And PcSel is a 1-bit output signal

  @combinational @core
  Formal Scenario: Branch_Sel equals Branch AND AluResult bit 0
    Given Branch is any valid value B
    And AluResult bit 0 is any valid value R0
    When the combinational logic evaluates
    Then Branch_Sel should equal (B AND R0)

  @combinational @core
  Formal Scenario: PcSel equals JalrSel OR Branch_Sel
    Given JalrSel is any valid value J
    And Branch_Sel is any valid value S
    When the combinational logic evaluates
    Then PcSel should equal (J OR S)

  @combinational @endtoend
  Formal Scenario: PcSel equals JalrSel OR (Branch AND AluResult bit 0)
    Given Branch is any valid value B
    And JalrSel is any valid value J
    And AluResult bit 0 is any valid value R0
    When the combinational logic evaluates
    Then Branch_Sel should equal (B AND R0)
    And PcSel should equal (J OR (B AND R0))

  @combinational @edge
  Formal Scenario: PcSel is asserted when JalrSel is high regardless of Branch_Sel
    Given JalrSel is 1
    And Branch_Sel is any valid value S
    When the combinational logic evaluates
    Then PcSel should equal 1

  @combinational @edge
  Formal Scenario: PcSel is asserted when Branch_Sel is high regardless of JalrSel
    Given Branch is 1
    And AluResult bit 0 is 1
    And JalrSel is any valid value J
    When the combinational logic evaluates
    Then Branch_Sel should equal 1
    And PcSel should equal 1

  @combinational @edge
  Formal Scenario: PcSel is deasserted when both JalrSel and Branch_Sel are low
    Given JalrSel is 0
    And Branch is any valid value B
    And AluResult bit 0 is any valid value R0
    When the combinational logic evaluates
    Then Branch_Sel should equal (B AND R0)
    And PcSel should equal Branch_Sel

  @combinational @edge
  Formal Scenario: Branch_Sel is deasserted when Branch is low regardless of AluResult
    Given Branch is 0
    And AluResult bit 0 is any valid value R0
    When the combinational logic evaluates
    Then Branch_Sel should equal 0

  @combinational @edge
  Formal Scenario: Branch_Sel is deasserted when AluResult bit 0 is low regardless of Branch
    Given AluResult bit 0 is 0
    And Branch is any valid value B
    When the combinational logic evaluates
    Then Branch_Sel should equal 0

  @combinational @consistency
  Formal Scenario: Branch_Sel output matches internal computation used for PcSel
    Given Branch is any valid value B
    And AluResult bit 0 is any valid value R0
    And JalrSel is any valid value J
    When the combinational logic evaluates
    Then the Branch_Sel output should equal the internal Branch_Sel value used to compute PcSel
    And PcSel should equal (J OR (B AND R0))

# ── module: BrPCMux ──
Feature: Branch/Jump Target Address Selector (BrPC)

  Combinational logic that selects the branch/jump target address based on
  priority-encoded select signals. JalrSel has highest priority, followed
  by Branch_Sel, with a default of zero when neither is asserted.

  Background:
    Given this is a purely combinational design with no clock or reset
    And JalrSel is a 1-bit control signal
    And Branch_Sel is a 1-bit control signal
    And AluResult is a 32-bit value
    And PC_Imm is a 32-bit value
    And BrPC is a 32-bit output that responds immediately to input changes

  @combinational @priority-select
  Formal Scenario: JalrSel asserted selects AluResult regardless of Branch_Sel
    Given JalrSel is 1
    And Branch_Sel is any valid value
    And AluResult is value X
    And PC_Imm is any valid value
    When the combinational logic evaluates
    Then BrPC should equal X

  @combinational @priority-select
  Formal Scenario: Branch_Sel asserted selects PC_Imm when JalrSel is deasserted
    Given JalrSel is 0
    And Branch_Sel is 1
    And AluResult is any valid value
    And PC_Imm is value Y
    When the combinational logic evaluates
    Then BrPC should equal Y

  @combinational @default-case
  Formal Scenario: Both selects deasserted yields zero
    Given JalrSel is 0
    And Branch_Sel is 0
    And AluResult is any valid value
    And PC_Imm is any valid value
    When the combinational logic evaluates
    Then BrPC should equal 32'd0

  @combinational @mutual-exclusion
  Formal Scenario: JalrSel takes precedence over Branch_Sel when both asserted
    Given JalrSel is 1
    And Branch_Sel is 1
    And AluResult is value X
    And PC_Imm is value Y
    When the combinational logic evaluates
    Then BrPC should equal X
    And BrPC should not equal Y unless X equals Y

  @combinational @exhaustive-coverage
  Formal Scenario: BrPC is fully determined by select priority for all input combinations
    Given JalrSel is any valid 1-bit value
    And Branch_Sel is any valid 1-bit value
    And AluResult is value X
    And PC_Imm is value Y
    When the combinational logic evaluates
    Then BrPC should equal X if JalrSel equals 1
    And BrPC should equal Y if JalrSel equals 0 and Branch_Sel equals 1
    And BrPC should equal 32'd0 if JalrSel equals 0 and Branch_Sel equals 0

  @combinational @no-latch
  Formal Scenario: BrPC has no memory and depends only on current inputs
    Given JalrSel is any valid value
    And Branch_Sel is any valid value
    And AluResult is value X
    And PC_Imm is value Y
    When the combinational logic evaluates with these inputs at time T
    And the same inputs are reapplied at time T plus one
    Then BrPC at time T should equal BrPC at time T plus one

# ── module: TopModule ──
Feature: TopModule Branch Unit Combinational Logic
  Formal verification of a purely combinational branch unit that computes
  PC-relative targets, sequential PC, selected branch/jump target, and
  the PC-select control signal.

  Background:
    Given the design is purely combinational with no clock or reset
    And Cur_PC is a 9-bit unsigned value zero-extended to 32 bits
    And Imm is a 32-bit signed immediate value
    And JalrSel is a 1-bit control signal
    And Branch is a 1-bit control signal
    And AluResult is a 32-bit value

  @combinational @pc_imm
  Formal Scenario: PC_Imm computes PC-relative target
    Given Cur_PC is any valid 9-bit value X
    And Imm is any valid 32-bit value Y
    When the outputs are computed
    Then PC_Imm should equal the 32-bit sum of the zero-extended X and Y

  @combinational @pc_four
  Formal Scenario: PC_Four computes sequential PC
    Given Cur_PC is any valid 9-bit value X
    When the outputs are computed
    Then PC_Four should equal the 32-bit sum of the zero-extended X and 32'd4

  @combinational @brpc @jalr_priority
  Formal Scenario: BrPC selects AluResult when JalrSel is asserted
    Given JalrSel is 1
    And Branch is any valid value B
    And AluResult is any valid 32-bit value R
    And Cur_PC is any valid 9-bit value X
    And Imm is any valid 32-bit value Y
    When the outputs are computed
    Then BrPC should equal AluResult

  @combinational @brpc @branch_taken
  Formal Scenario: BrPC selects PC_Imm when Branch_Sel is asserted and JalrSel is deasserted
    Given JalrSel is 0
    And Branch is 1
    And AluResult has bit 0 equal to 1
    And Cur_PC is any valid 9-bit value X
    And Imm is any valid 32-bit value Y
    When the outputs are computed
    Then BrPC should equal PC_Imm

  @combinational @brpc @no_change
  Formal Scenario: BrPC is zero when neither JalrSel nor Branch_Sel is asserted
    Given JalrSel is 0
    And Branch is any valid value B
    And AluResult is any valid 32-bit value R
    And the condition (Branch and AluResult bit 0) is false
    And Cur_PC is any valid 9-bit value X
    And Imm is any valid 32-bit value Y
    When the outputs are computed
    Then BrPC should equal 32'd0

  @combinational @pcsel @jalr
  Formal Scenario: PcSel is asserted whenever JalrSel is asserted
    Given JalrSel is 1
    And Branch is any valid value B
    And AluResult is any valid 32-bit value R
    When the outputs are computed
    Then PcSel should equal 1

  @combinational @pcsel @branch
  Formal Scenario: PcSel reflects branch taken condition when JalrSel is deasserted
    Given JalrSel is 0
    And Branch is any valid value B
    And AluResult is any valid 32-bit value R
    When the outputs are computed
    Then PcSel should equal the logical AND of Branch and AluResult bit 0

  @combinational @pcsel @general
  Formal Scenario: PcSel is the logical OR of JalrSel and Branch_Sel
    Given JalrSel is any valid value J
    And Branch is any valid value B
    And AluResult is any valid 32-bit value R
    When the outputs are computed
    Then PcSel should equal J or (B and AluResult bit 0)

  @combinational @brpc @general
  Formal Scenario: BrPC follows priority mux of JalrSel then Branch_Sel then zero
    Given JalrSel is any valid value J
    And Branch is any valid value B
    And AluResult is any valid 32-bit value R
    And Cur_PC is any valid 9-bit value X
    And Imm is any valid 32-bit value Y
    When the outputs are computed
    Then BrPC should equal AluResult if J is 1
    And BrPC should equal PC_Imm if J is 0 and B and AluResult bit 0 are both 1
    And BrPC should equal 32'd0 if J is 0 and the condition (B and AluResult bit 0) is false

  @combinational @independence
  Formal Scenario: PC_Imm and PC_Four do not depend on control signals
    Given Cur_PC is any valid 9-bit value X
    And Imm is any valid 32-bit value Y
    And JalrSel is any valid value J
    And Branch is any valid value B
    And AluResult is any valid 32-bit value R
    When the outputs are computed
    Then PC_Imm should equal the 32-bit sum of the zero-extended X and Y
    And PC_Four should equal the 32-bit sum of the zero-extended X and 32'd4