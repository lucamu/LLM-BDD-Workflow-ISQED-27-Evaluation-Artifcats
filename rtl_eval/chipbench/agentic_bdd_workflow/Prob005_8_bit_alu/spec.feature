# ── module: TopModule ──
Feature: 8-bit ALU (TopModule) Combinational Behavior
  Formal verification of a 4-function 8-bit ALU that computes bitwise AND,
  bitwise OR, addition, or subtraction of two 8-bit operands based on a
  2-bit operation selector, implemented via bit_8_AND, bit_8_OR,
  bit_8_ADDER, and mux_2X1 submodules.

  Background:
    Given the design is purely combinational with no clock or reset
    And in_A is an 8-bit value A
    And in_B is an 8-bit value B
    And in_operation is a 2-bit value OP
    And out_c is an 8-bit output

  @and_operation
  Formal Scenario: Bitwise AND selected
    Given operand A is any 8-bit value A
    And operand B is any 8-bit value B
    And in_operation equals 2'b00
    When the ALU evaluates the operation
    Then out_c should equal (A AND B)

  @or_operation
  Formal Scenario: Bitwise OR selected
    Given operand A is any 8-bit value A
    And operand B is any 8-bit value B
    And in_operation equals 2'b01
    When the ALU evaluates the operation
    Then out_c should equal (A OR B)

  @add_operation
  Formal Scenario: Addition selected
    Given operand A is any 8-bit value A
    And operand B is any 8-bit value B
    And in_operation equals 2'b10
    When the ALU evaluates the operation
    Then out_c should equal ((A + B) mod 256)

  @sub_operation
  Formal Scenario: Subtraction selected
    Given operand A is any 8-bit value A
    And operand B is any 8-bit value B
    And in_operation equals 2'b11
    When the ALU evaluates the operation
    Then out_c should equal ((A - B) mod 256)

  @opcode_high_bit_selects_domain
  Formal Scenario: High opcode bit selects logic versus arithmetic result
    Given operand A is any 8-bit value A
    And operand B is any 8-bit value B
    And in_operation is any 2-bit value OP
    When the ALU evaluates the operation
    Then out_c should equal the logic-domain result (A AND B or A OR B based on OP[0]) if OP[1] equals 0
    And out_c should equal the arithmetic-domain result (A + B or A - B based on OP[0]) if OP[1] equals 1

  @opcode_low_bit_selects_function
  Formal Scenario: Low opcode bit selects AND/OR or ADD/SUB mode
    Given operand A is any 8-bit value A
    And operand B is any 8-bit value B
    And in_operation is any 2-bit value OP
    When the ALU evaluates the operation
    Then out_c should equal (A AND B) if OP equals 2'b00
    And out_c should equal (A OR B) if OP equals 2'b01
    And out_c should equal ((A + B) mod 256) if OP equals 2'b10
    And out_c should equal ((A - B) mod 256) if OP equals 2'b11

  @output_combinational_no_state
  Formal Scenario: Output depends only on current inputs
    Given operand A is any 8-bit value A
    And operand B is any 8-bit value B
    And in_operation is any 2-bit value OP
    When the same inputs A, B, OP are applied at any two evaluation instances
    Then out_c should be identical at both instances

  @mux_selection_consistency
  Formal Scenario: Multiplexer correctly selects between logic and arithmetic sub-results
    Given operand A is any 8-bit value A
    And operand B is any 8-bit value B
    And in_operation is any 2-bit value OP
    When the ALU evaluates the operation
    Then the mux_2X1 select input should equal OP[1]
    And out_c should equal the arithmetic sub-result when OP[1] equals 1
    And out_c should equal the logic sub-result when OP[1] equals 0

  @adder_carry_in_consistency
  Formal Scenario: Adder carry-in matches subtract mode
    Given operand A is any 8-bit value A
    And operand B is any 8-bit value B
    And in_operation is any 2-bit value OP
    When the ALU evaluates the operation
    Then the bit_8_ADDER carry_in input should equal OP[0]
    And out_c should equal ((A + B) mod 256) if OP equals 2'b10
    And out_c should equal ((A - B) mod 256) if OP equals 2'b11

  @no_x_propagation
  Formal Scenario: Output is always fully defined for all input combinations
    Given operand A is any 8-bit value A
    And operand B is any 8-bit value B
    And in_operation is any 2-bit value OP
    When the ALU evaluates the operation
    Then out_c should be a defined 8-bit value with no unknown bits