Feature: Adder-Subtractor with Zero Flag

  Verify that TopModule correctly computes the sum or difference of two
  8-bit operands based on the do_sub control signal, and correctly
  reports whether the result is zero. The result_is_zero flag must be
  a pure combinational function of the current inputs only (no latch
  behavior, no dependence on previous output values), and must be set
  using a true equality-to-zero test rather than a bitwise inversion.

  Background:
    Given the design is purely combinational with no clock or reset
    And input do_sub
    And input a is an 8-bit value
    And input b is an 8-bit value
    And output out is an 8-bit value
    And output result_is_zero is a 1-bit value

  Formal Scenario: Addition mode computes correct sum
    @formal @addition
    Given do_sub is 0
    And a is operand A
    And b is operand B
    When the module evaluates combinationally
    Then out should equal (A + B) truncated to 8 bits

  Formal Scenario: Subtraction mode computes correct difference
    @formal @subtraction
    Given do_sub is 1
    And a is operand A
    And b is operand B
    When the module evaluates combinationally
    Then out should equal (A - B) truncated to 8 bits

  Formal Scenario: Zero flag asserted when result is zero
    @formal @zero_flag_true
    Given do_sub is a value SUB
    And a is operand A
    And b is operand B
    And the computed out equals 8'b00000000
    When the module evaluates combinationally
    Then result_is_zero should be 1

  Formal Scenario: Zero flag deasserted when result is nonzero
    @formal @zero_flag_false
    Given do_sub is a value SUB
    And a is operand A
    And b is operand B
    And the computed out does not equal 8'b00000000
    When the module evaluates combinationally
    Then result_is_zero should be 0

  Formal Scenario: Zero flag is always a deterministic function of out
    @formal @no_latch
    Given do_sub is a value SUB
    And a is operand A
    And b is operand B
    When the module evaluates combinationally
    Then result_is_zero should equal 1 if out equals 8'b00000000, else 0
    And result_is_zero should not depend on any previously latched value

  Formal Scenario: Output is independent of unrelated signal history
    @formal @combinational_purity
    Given do_sub is a value SUB
    And a is operand A
    And b is operand B
    When the same inputs are applied on any two separate evaluations
    Then out should be identical on both evaluations
    And result_is_zero should be identical on both evaluations