# ── module: ArithLogicUnit ──
Feature: 00xx Operation Group ALU (AND, OR, ADD, XOR)
  Purely combinational logic block that decodes a 2-bit selector
  (Operation[1:0]) to compute one of four functions on two 32-bit
  operands, SrcA and SrcB. No clock, no reset, no state.

  Background:
    Given SrcA is any valid 32-bit value
    And SrcB is any valid 32-bit value
    And Operation is any valid 2-bit selector
    And the design is purely combinational with no internal state

  @combinational @and
  Formal Scenario: Bitwise AND is selected when Operation is 00
    Given SrcA is a 32-bit value A
    And SrcB is a 32-bit value B
    And Operation equals 2'b00
    When the operation group evaluates the result
    Then the result should equal A & B
    And the result should not depend on any previous cycle values

  @combinational @or
  Formal Scenario: Bitwise OR is selected when Operation is 01
    Given SrcA is a 32-bit value A
    And SrcB is a 32-bit value B
    And Operation equals 2'b01
    When the operation group evaluates the result
    Then the result should equal A | B
    And the result should not depend on any previous cycle values

  @combinational @add @wraparound
  Formal Scenario: 32-bit ADD with wraparound is selected when Operation is 10
    Given SrcA is a 32-bit value A
    And SrcB is a 32-bit value B
    And Operation equals 2'b10
    When the operation group evaluates the result
    Then the result should equal (A + B) truncated to 32 bits
    And no carry-out or overflow flag should affect the result value
    And the result should not depend on any previous cycle values

  @combinational @xor
  Formal Scenario: Bitwise XOR is selected when Operation is 11
    Given SrcA is a 32-bit value A
    And SrcB is a 32-bit value B
    And Operation equals 2'b11
    When the operation group evaluates the result
    Then the result should equal A ^ B
    And the result should not depend on any previous cycle values

  @combinational @exhaustive_selector
  Formal Scenario: Result is uniquely determined by selector for all operand pairs
    Given SrcA is a 32-bit value A
    And SrcB is a 32-bit value B
    And Operation is a 2-bit value S
    When the operation group evaluates the result
    Then the result should equal (A & B) if S equals 2'b00
    And the result should equal (A | B) if S equals 2'b01
    And the result should equal ((A + B) truncated to 32 bits) if S equals 2'b10
    And the result should equal (A ^ B) if S equals 2'b11

  @combinational @no_other_op_dependency
  Formal Scenario: Result is independent of any other operation group's inputs or outputs
    Given SrcA is a 32-bit value A
    And SrcB is a 32-bit value B
    And Operation is a 2-bit value S
    And any signal external to this 00xx group is arbitrary
    When the operation group evaluates the result
    Then the result should depend only on A, B, and S
    And changing any external signal not part of {A, B, S} should not change the result

  @combinational @determinism
  Formal Scenario: Output is a pure combinational function with no latency
    Given SrcA is a 32-bit value A
    And SrcB is a 32-bit value B
    And Operation is a 2-bit value S
    When the inputs A, B, S are applied
    Then the result should be valid in the same evaluation cycle
    And re-evaluating with identical A, B, S should always produce the identical result

# ── module: ShiftSubUnit ──
Feature: 01xx Operation Group ALU Combinational Logic
  Verifies the shift/subtract operation group selected by Operation[1:0]
  for a purely combinational functional unit. Shift amount is always
  derived from SrcB[4:0]. No clock or reset signals are involved in the
  functional behavior; however, for formal property evaluation, all
  combinational outputs are sampled on an implicit verification sampling
  clock (sample_clk) used solely to schedule assertion checks.

  Background:
    Given SrcA is a 32-bit value
    And SrcB is a 32-bit value
    And Operation is a 2-bit selector
    And the shift amount is defined as SrcB[4:0]
    And the design is purely combinational with no internal state
    And an implicit sampling clock, sample_clk, is used only to schedule
        property evaluations and does not affect the combinational logic

  @logical_left_shift
  Formal Scenario: Logical left shift selected
    Given Operation equals 2'b00
    When the operation group evaluates its result
    Then the result should equal SrcA << SrcB[4:0]

  @logical_left_shift_zero_amount
  Formal Scenario: Logical left shift with zero shift amount
    Given Operation equals 2'b00
    And SrcB[4:0] equals 5'b00000
    When the operation group evaluates its result
    Then the result should equal SrcA

  @logical_left_shift_max_amount
  Formal Scenario: Logical left shift with maximum shift amount
    Given Operation equals 2'b00
    And SrcB[4:0] equals 5'b11111
    When the operation group evaluates its result
    Then the result should equal SrcA << 31

  @logical_right_shift
  Formal Scenario: Logical right shift selected
    Given Operation equals 2'b01
    When the operation group evaluates its result
    Then the result should equal SrcA >> SrcB[4:0]

  @logical_right_shift_zero_fill
  Formal Scenario: Logical right shift zero-fills the most significant bits
    Given Operation equals 2'b01
    And SrcA has its most significant bit set to 1
    And SrcB[4:0] is greater than 5'b00000
    When the operation group evaluates its result
    Then the result's most significant bit should equal 0

  @logical_right_shift_zero_amount
  Formal Scenario: Logical right shift with zero shift amount
    Given Operation equals 2'b01
    And SrcB[4:0] equals 5'b00000
    When the operation group evaluates its result
    Then the result should equal SrcA

  @subtraction
  Formal Scenario: 32-bit subtraction selected
    Given Operation equals 2'b10
    When the operation group evaluates its result
    Then the result should equal SrcA - SrcB

  @subtraction_equal_operands
  Formal Scenario: Subtraction of equal operands yields zero
    Given Operation equals 2'b10
    And SrcA equals SrcB
    When the operation group evaluates its result
    Then the result should equal 32'b0

  @subtraction_independent_of_shift_amount
  Formal Scenario: Subtraction result is independent of SrcB[4:0]
    Given Operation equals 2'b10
    And two evaluations share the same SrcA value
    And two evaluations share the same SrcB[31:5] value
    And the first evaluation uses SrcB[4:0] equal to a value X
    And the second evaluation uses SrcB[4:0] equal to a different value Y
    When the operation group evaluates its result in both evaluations
    Then the result of the first evaluation should equal the result of the second evaluation

  @arithmetic_right_shift
  Formal Scenario: Arithmetic right shift selected
    Given Operation equals 2'b11
    When the operation group evaluates its result
    Then the result should equal $signed(SrcA) >>> SrcB[4:0]

  @arithmetic_right_shift_negative_sign_extends
  Formal Scenario: Arithmetic right shift sign-extends negative operand
    Given Operation equals 2'b11
    And SrcA has its most significant bit set to 1
    And SrcB[4:0] is greater than 5'b00000
    When the operation group evaluates its result
    Then the result's most significant bit should equal 1

  @arithmetic_right_shift_positive_zero_fills
  Formal Scenario: Arithmetic right shift zero-extends positive operand
    Given Operation equals 2'b11
    And SrcA has its most significant bit set to 0
    And SrcB[4:0] is greater than 5'b00000
    When the operation group evaluates its result
    Then the result's most significant bit should equal 0

  @arithmetic_right_shift_zero_amount
  Formal Scenario: Arithmetic right shift with zero shift amount
    Given Operation equals 2'b11
    And SrcB[4:0] equals 5'b00000
    When the operation group evaluates its result
    Then the result should equal SrcA

  @combinational_stability
  Formal Scenario: Output depends only on current inputs across sampling cycles
    Given SrcA, SrcB, and Operation are held at fixed values across two consecutive sample_clk cycles
    When the operation group evaluates its result on the first sample_clk cycle
    And the operation group evaluates its result on the second sample_clk cycle
    Then the result on the first sample_clk cycle should equal the result on the second sample_clk cycle

  @operation_selector_exhaustive
  Formal Scenario: All four operation selections produce distinct behavior mapping
    Given Operation takes any value in the range 2'b00 to 2'b11
    When the operation group evaluates its result
    Then the result should equal SrcA << SrcB[4:0] if Operation equals 2'b00
    And the result should equal SrcA >> SrcB[4:0] if Operation equals 2'b01
    And the result should equal SrcA - SrcB if Operation equals 2'b10
    And the result should equal $signed(SrcA) >>> SrcB[4:0] if Operation equals 2'b11

# ── module: EqualityUnit ──
Feature: 10xx Operation Group Combinational Logic
  Formal verification of the 10xx opcode group, which computes
  equality, inequality, and constant-true operations on two
  32-bit operands based on a 2-bit operation selector.
  This is a purely combinational block with no clock or reset.

  Background:
    Given SrcA is any valid 32-bit value
    And SrcB is any valid 32-bit value
    And Operation[1:0] is any valid 2-bit selector
    And the design belongs to the 10xx operation group
    And the output Result is a 32-bit combinational function of SrcA, SrcB and Operation[1:0]

  @equal @combinational
  Formal Scenario: EQUAL operation selects sel=00
    Given Operation[1:0] equals 2'b00
    When the operation is evaluated
    Then Result should equal 32'd1 if SrcA equals SrcB
    And Result should equal 32'd0 if SrcA does not equal SrcB

  @not_equal @combinational
  Formal Scenario: NOT EQUAL operation selects sel=01
    Given Operation[1:0] equals 2'b01
    When the operation is evaluated
    Then Result should equal 32'd1 if SrcA does not equal SrcB
    And Result should equal 32'd0 if SrcA equals SrcB

  @always_true @combinational
  Formal Scenario: ALWAYS TRUE operation selects sel=10
    Given Operation[1:0] equals 2'b10
    When the operation is evaluated
    Then Result should equal 32'd1 regardless of the values of SrcA and SrcB

  @unused @combinational
  Formal Scenario: Unused operation selects sel=11
    Given Operation[1:0] equals 2'b11
    When the operation is evaluated
    Then Result should equal 32'd0 regardless of the values of SrcA and SrcB

  @mutual_exclusion @combinational
  Formal Scenario: EQUAL and NOT EQUAL results are mutually exclusive and complementary
    Given Operation[1:0] equals 2'b00 for computing ResultEQ
    And Operation[1:0] equals 2'b01 for computing ResultNEQ
    When both operations are evaluated on the same SrcA and SrcB
    Then ResultEQ should equal 32'd1 if and only if ResultNEQ equals 32'd0
    And ResultEQ plus ResultNEQ should equal 32'd1

  @output_domain @combinational
  Formal Scenario: Result is always a boolean-valued output
    Given Operation[1:0] is any valid 2-bit selector
    When the operation is evaluated for any SrcA and SrcB
    Then Result should equal either 32'd0 or 32'd1

  @no_state @combinational
  Formal Scenario: Output has no dependency on history or clock
    Given SrcA, SrcB and Operation[1:0] hold any fixed values
    When the operation is evaluated at any two distinct time steps with identical inputs
    Then Result at the first time step should equal Result at the second time step

# ── module: CompareUnit ──
Feature: 11xx Group Comparison Operations Unit

  Purely combinational unit that compares SrcA and SrcB according to a
  2-bit Operation selector and produces a 32-bit boolean result
  (32'd1 for true, 32'd0 for false). The upper opcode bits are fixed
  to 11xx; only the lower 2 bits (Operation[1:0]) select the function.

  Background:
    Given SrcA is any valid 32-bit value
    And SrcB is any valid 32-bit value
    And the design is purely combinational with no clock or reset

  @signed_less_than @formal
  Formal Scenario: Signed less-than comparison when selector is 00
    Given Operation[1:0] is 2'b00
    When the operation is evaluated
    Then the result should be 32'd1 if signed(SrcA) < signed(SrcB) else 32'd0

  @signed_greater_equal @formal
  Formal Scenario: Signed greater-or-equal comparison when selector is 01
    Given Operation[1:0] is 2'b01
    When the operation is evaluated
    Then the result should be 32'd1 if signed(SrcA) >= signed(SrcB) else 32'd0

  @unsigned_less_than @formal
  Formal Scenario: Unsigned less-than comparison when selector is 10
    Given Operation[1:0] is 2'b10
    When the operation is evaluated
    Then the result should be 32'd1 if SrcA < SrcB else 32'd0

  @unsigned_greater_equal @formal
  Formal Scenario: Unsigned greater-or-equal comparison when selector is 11
    Given Operation[1:0] is 2'b11
    When the operation is evaluated
    Then the result should be 32'd1 if SrcA >= SrcB else 32'd0

  @output_range @formal
  Formal Scenario: Result is always boolean-encoded regardless of selector
    Given Operation[1:0] is any valid 2-bit value
    When the operation is evaluated
    Then the result should equal 32'd0 or 32'd1

  @mutual_exclusion_signed @formal
  Formal Scenario: Signed less-than and greater-or-equal are complementary
    Given Operation[1:0] is 2'b00 producing result_lt
    And Operation[1:0] is 2'b01 producing result_ge for the same SrcA and SrcB
    When the operation is evaluated for both selectors
    Then result_lt should equal 32'd1 if and only if result_ge equals 32'd0

  @mutual_exclusion_unsigned @formal
  Formal Scenario: Unsigned less-than and greater-or-equal are complementary
    Given Operation[1:0] is 2'b10 producing result_ltu
    And Operation[1:0] is 2'b11 producing result_geu for the same SrcA and SrcB
    When the operation is evaluated for both selectors
    Then result_ltu should equal 32'd1 if and only if result_geu equals 32'd0

  @equal_operands_signed @formal
  Formal Scenario: Equal operands yield false for signed less-than and true for signed greater-or-equal
    Given SrcA equals SrcB
    And Operation[1:0] is 2'b00
    When the operation is evaluated
    Then the result should be 32'd0
    Given Operation[1:0] is 2'b01
    When the operation is evaluated
    Then the result should be 32'd1

  @equal_operands_unsigned @formal
  Formal Scenario: Equal operands yield false for unsigned less-than and true for unsigned greater-or-equal
    Given SrcA equals SrcB
    And Operation[1:0] is 2'b10
    When the operation is evaluated
    Then the result should be 32'd0
    Given Operation[1:0] is 2'b11
    When the operation is evaluated
    Then the result should be 32'd1

  @combinational_no_state @formal
  Formal Scenario: Output depends only on current SrcA, SrcB, and selector
    Given SrcA, SrcB, and Operation[1:0] hold any fixed values over two consecutive evaluations
    When the operation is evaluated at each instance
    Then the result should be identical for both evaluations

# ── module: ALUCore ──
Feature: ALU Core Top-Level Combinational Multiplexing Logic

  As a hardware verification engineer
  I want to verify the ALUCore correctly distributes operands to all four
  functional units and forwards the correct unit's Result to ALUResult
  So that the ALU behaves exactly as specified for every operation encoding

  Background:
    Given the design is purely combinational with no clock or reset
    And SrcA is a symbolic operand value
    And SrcB is a symbolic operand value
    And Operation is a symbolic 4-bit value composed of Operation[3:2] as the group selector and Operation[1:0] as the local selector
    And the ArithLogicUnit receives SrcA, SrcB, and Operation[1:0] as its inputs
    And the ShiftSubUnit receives SrcA, SrcB, and Operation[1:0] as its inputs
    And the EqualityUnit receives SrcA, SrcB, and Operation[1:0] as its inputs
    And the CompareUnit receives SrcA, SrcB, and Operation[1:0] as its inputs
    And ArithLogicResult is the Result output of ArithLogicUnit
    And ShiftSubResult is the Result output of ShiftSubUnit
    And EqualityResult is the Result output of EqualityUnit
    And CompareResult is the Result output of CompareUnit

  @formal @input_distribution
  Formal Scenario: All four functional units receive identical operands regardless of group selector
    Given SrcA is operand A
    And SrcB is operand B
    And Operation[1:0] is local selector L
    And Operation[3:2] is any group selector value
    When the ALUCore evaluates its combinational logic
    Then the ArithLogicUnit input SrcA should equal operand A
    And the ArithLogicUnit input SrcB should equal operand B
    And the ArithLogicUnit input Operation[1:0] should equal local selector L
    And the ShiftSubUnit input SrcA should equal operand A
    And the ShiftSubUnit input SrcB should equal operand B
    And the ShiftSubUnit input Operation[1:0] should equal local selector L
    And the EqualityUnit input SrcA should equal operand A
    And the EqualityUnit input SrcB should equal operand B
    And the EqualityUnit input Operation[1:0] should equal local selector L
    And the CompareUnit input SrcA should equal operand A
    And the CompareUnit input SrcB should equal operand B
    And the CompareUnit input Operation[1:0] should equal local selector L

  @formal @mux_select @arith_logic
  Formal Scenario: ALUResult forwards ArithLogicUnit Result when group selector selects arithmetic-logic group
    Given SrcA is operand A
    And SrcB is operand B
    And Operation[1:0] is local selector L
    And Operation[3:2] equals 2'b00
    When the ALUCore evaluates its combinational logic
    Then ALUResult should equal ArithLogicResult

  @formal @mux_select @shift_sub
  Formal Scenario: ALUResult forwards ShiftSubUnit Result when group selector selects shift-subtract group
    Given SrcA is operand A
    And SrcB is operand B
    And Operation[1:0] is local selector L
    And Operation[3:2] equals 2'b01
    When the ALUCore evaluates its combinational logic
    Then ALUResult should equal ShiftSubResult

  @formal @mux_select @equality
  Formal Scenario: ALUResult forwards EqualityUnit Result when group selector selects equality group
    Given SrcA is operand A
    And SrcB is operand B
    And Operation[1:0] is local selector L
    And Operation[3:2] equals 2'b10
    When the ALUCore evaluates its combinational logic
    Then ALUResult should equal EqualityResult

  @formal @mux_select @compare
  Formal Scenario: ALUResult forwards CompareUnit Result when group selector selects compare group
    Given SrcA is operand A
    And SrcB is operand B
    And Operation[1:0] is local selector L
    And Operation[3:2] equals 2'b11
    When the ALUCore evaluates its combinational logic
    Then ALUResult should equal CompareResult

  @formal @exclusivity
  Formal Scenario: Exactly one functional unit's Result drives ALUResult for any operation encoding
    Given SrcA is operand A
    And SrcB is operand B
    And Operation is any valid 4-bit operation encoding
    When the ALUCore evaluates its combinational logic
    Then ALUResult should equal ArithLogicResult if and only if Operation[3:2] equals 2'b00
    And ALUResult should equal ShiftSubResult if and only if Operation[3:2] equals 2'b01
    And ALUResult should equal EqualityResult if and only if Operation[3:2] equals 2'b10
    And ALUResult should equal CompareResult if and only if Operation[3:2] equals 2'b11

  @formal @combinational_immediacy
  Formal Scenario: ALUResult updates immediately and purely combinationally with input changes
    Given SrcA is operand A
    And SrcB is operand B
    And Operation is any valid 4-bit operation encoding
    When any input among SrcA, SrcB, or Operation changes to a new symbolic value
    Then ALUResult should update in the same evaluation cycle with no dependency on any clock edge
    And ALUResult should be a pure function of the current values of SrcA, SrcB, and Operation only

  @formal @no_hidden_state
  Formal Scenario: ALUCore contains no internal state and no memory of past inputs
    Given SrcA is operand A
    And SrcB is operand B
    And Operation is any valid 4-bit operation encoding
    When the same input combination is applied at two different evaluation instances
    Then ALUResult should be identical at both evaluation instances

  @formal @full_operation_coverage
  Formal Scenario: Every possible value of Operation[3:2] maps to exactly one defined functional unit
    Given Operation[3:2] is any 2-bit value
    When the ALUCore evaluates its combinational logic
    Then Operation[3:2] equal to 2'b00 should select ArithLogicUnit
    And Operation[3:2] equal to 2'b01 should select ShiftSubUnit
    And Operation[3:2] equal to 2'b10 should select EqualityUnit
    And Operation[3:2] equal to 2'b11 should select CompareUnit

# ── module: TopModule ──
Feature: Combinational ALU (TopModule)
  The module computes ALUResult combinationally from SrcA, SrcB, and
  Operation according to the 4-bit opcode encoding. Every operation is
  independent of any prior state and must hold for all legal input
  combinations.

  Background:
    Given the design is purely combinational with no clock or reset
    And SrcA is a 32-bit symbolic value
    And SrcB is a 32-bit symbolic value
    And Operation is a 4-bit symbolic value
    And ALUResult is the 32-bit combinational output

  @and
  Formal Scenario: Bitwise AND operation
    Given SrcA is operand A
    And SrcB is operand B
    And Operation is 4'b0000
    When the ALU evaluates the operation
    Then ALUResult should equal (A & B)

  @or
  Formal Scenario: Bitwise OR operation
    Given SrcA is operand A
    And SrcB is operand B
    And Operation is 4'b0001
    When the ALU evaluates the operation
    Then ALUResult should equal (A | B)

  @add
  Formal Scenario: Addition operation
    Given SrcA is operand A
    And SrcB is operand B
    And Operation is 4'b0010
    When the ALU evaluates the operation
    Then ALUResult should equal the 32-bit truncated sum of (A + B)

  @xor
  Formal Scenario: Bitwise XOR operation
    Given SrcA is operand A
    And SrcB is operand B
    And Operation is 4'b0011
    When the ALU evaluates the operation
    Then ALUResult should equal (A ^ B)

  @shift @left_shift
  Formal Scenario: Logical left shift operation
    Given SrcA is operand A
    And SrcB is operand B
    And Operation is 4'b0100
    When the ALU evaluates the operation
    Then ALUResult should equal (A << B[4:0]) truncated to 32 bits
    And the shift amount used should be B[4:0] only

  @shift @right_shift_logical
  Formal Scenario: Logical right shift operation
    Given SrcA is operand A
    And SrcB is operand B
    And Operation is 4'b0101
    When the ALU evaluates the operation
    Then ALUResult should equal (A >> B[4:0]) with zero fill
    And the shift amount used should be B[4:0] only

  @sub
  Formal Scenario: Subtraction operation
    Given SrcA is operand A
    And SrcB is operand B
    And Operation is 4'b0110
    When the ALU evaluates the operation
    Then ALUResult should equal the 32-bit truncated difference of (A - B)

  @shift @right_shift_arith
  Formal Scenario: Arithmetic right shift operation
    Given SrcA is operand A
    And SrcB is operand B
    And Operation is 4'b0111
    When the ALU evaluates the operation
    Then ALUResult should equal ($signed(A) >>> B[4:0]) sign-extended to 32 bits
    And the shift amount used should be B[4:0] only

  @compare @equal
  Formal Scenario: Equality comparison true
    Given SrcA is operand A
    And SrcB is operand B
    And A equals B
    And Operation is 4'b1000
    When the ALU evaluates the operation
    Then ALUResult should equal 32'd1

  @compare @equal
  Formal Scenario: Equality comparison false
    Given SrcA is operand A
    And SrcB is operand B
    And A does not equal B
    And Operation is 4'b1000
    When the ALU evaluates the operation
    Then ALUResult should equal 32'd0

  @compare @not_equal
  Formal Scenario: Inequality comparison true
    Given SrcA is operand A
    And SrcB is operand B
    And A does not equal B
    And Operation is 4'b1001
    When the ALU evaluates the operation
    Then ALUResult should equal 32'd1

  @compare @not_equal
  Formal Scenario: Inequality comparison false
    Given SrcA is operand A
    And SrcB is operand B
    And A equals B
    And Operation is 4'b1001
    When the ALU evaluates the operation
    Then ALUResult should equal 32'd0

  @const_true
  Formal Scenario: Always true operation
    Given SrcA is operand A
    And SrcB is operand B
    And Operation is 4'b1010
    When the ALU evaluates the operation
    Then ALUResult should equal 32'd1 regardless of A and B

  @compare @signed_lt
  Formal Scenario: Signed less-than comparison true
    Given SrcA is operand A
    And SrcB is operand B
    And $signed(A) is less than $signed(B)
    And Operation is 4'b1100
    When the ALU evaluates the operation
    Then ALUResult should equal 32'd1

  @compare @signed_lt
  Formal Scenario: Signed less-than comparison false
    Given SrcA is operand A
    And SrcB is operand B
    And $signed(A) is greater than or equal to $signed(B)
    And Operation is 4'b1100
    When the ALU evaluates the operation
    Then ALUResult should equal 32'd0

  @compare @signed_ge
  Formal Scenario: Signed greater-or-equal comparison true
    Given SrcA is operand A
    And SrcB is operand B
    And $signed(A) is greater than or equal to $signed(B)
    And Operation is 4'b1101
    When the ALU evaluates the operation
    Then ALUResult should equal 32'd1

  @compare @signed_ge
  Formal Scenario: Signed greater-or-equal comparison false
    Given SrcA is operand A
    And SrcB is operand B
    And $signed(A) is less than $signed(B)
    And Operation is 4'b1101
    When the ALU evaluates the operation
    Then ALUResult should equal 32'd0

  @compare @unsigned_lt
  Formal Scenario: Unsigned less-than comparison true
    Given SrcA is operand A
    And SrcB is operand B
    And A is less than B when both are interpreted as unsigned
    And Operation is 4'b1110
    When the ALU evaluates the operation
    Then ALUResult should equal 32'd1

  @compare @unsigned_lt
  Formal Scenario: Unsigned less-than comparison false
    Given SrcA is operand A
    And SrcB is operand B
    And A is greater than or equal to B when both are interpreted as unsigned
    And Operation is 4'b1110
    When the ALU evaluates the operation
    Then ALUResult should equal 32'd0

  @compare @unsigned_ge
  Formal Scenario: Unsigned greater-or-equal comparison true
    Given SrcA is operand A
    And SrcB is operand B
    And A is greater than or equal to B when both are interpreted as unsigned
    And Operation is 4'b1111
    When the ALU evaluates the operation
    Then ALUResult should equal 32'd1

  @compare @unsigned_ge
  Formal Scenario: Unsigned greater-or-equal comparison false
    Given SrcA is operand A
    And SrcB is operand B
    And A is less than B when both are interpreted as unsigned
    And Operation is 4'b1111
    When the ALU evaluates the operation
    Then ALUResult should equal 32'd0

  @combinational @no_state
  Formal Scenario: Output has no memory across evaluations
    Given SrcA is operand A
    And SrcB is operand B
    And Operation is opcode Op
    When the same inputs A, B, Op are applied at any two distinct times
    Then ALUResult should be identical at both times

  @decode @exhaustive
  Formal Scenario: Result depends only on current inputs and valid opcode selects exactly one function
    Given SrcA is operand A
    And SrcB is operand B
    And Operation is opcode Op
    When the ALU evaluates the operation
    Then ALUResult should be fully determined by A, B, and Op with no other dependency
    And exactly one of the defined operation behaviors for Op should determine ALUResult