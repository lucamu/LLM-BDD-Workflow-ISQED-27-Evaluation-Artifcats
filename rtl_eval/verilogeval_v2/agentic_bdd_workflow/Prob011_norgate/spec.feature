Feature: TopModule NOR Gate Combinational Logic Verification
  Formal verification of a 2-input NOR gate combinational module.
  The module has no clock or reset signals; all outputs are pure
  combinational functions of the current inputs.

  Background:
    Given the module TopModule is instantiated
    And input a is a symbolic 1-bit value
    And input b is a symbolic 1-bit value
    And the design is purely combinational with no clock or reset

  @core_functionality @nor_truth_table
  Formal Scenario: Output equals logical NOR of inputs for all input combinations
    Given input a is A
    And input b is B
    When the combinational logic evaluates
    Then out should equal NOT (A OR B)

  @core_functionality @both_zero
  Formal Scenario: Output is 1 when both inputs are 0
    Given input a is 0
    And input b is 0
    When the combinational logic evaluates
    Then out should be 1

  @core_functionality @a_high
  Formal Scenario: Output is 0 when input a is 1 regardless of b
    Given input a is 1
    And input b is B
    When the combinational logic evaluates
    Then out should be 0

  @core_functionality @b_high
  Formal Scenario: Output is 0 when input b is 1 regardless of a
    Given input a is A
    And input b is 1
    When the combinational logic evaluates
    Then out should be 0

  @core_functionality @both_high
  Formal Scenario: Output is 0 when both inputs are 1
    Given input a is 1
    And input b is 1
    When the combinational logic evaluates
    Then out should be 0

  @equivalence @nor_as_not_or
  Formal Scenario: Output equals negation of logical OR
    Given input a is A
    And input b is B
    When the combinational logic evaluates
    Then out should equal ~(A | B)

  @equivalence @demorgan
  Formal Scenario: Output equals AND of negated inputs (De Morgan's law)
    Given input a is A
    And input b is B
    When the combinational logic evaluates
    Then out should equal (NOT A) AND (NOT B)

  @combinational_purity @no_state
  Formal Scenario: Output depends only on current inputs with no memory
    Given input a is A
    And input b is B
    When the combinational logic evaluates
    Then out should be uniquely determined by A and B alone
    And out should not depend on any previous input values

  @symmetry @commutative
  Formal Scenario: Output is symmetric under swapping inputs a and b
    Given input a is A
    And input b is B
    When the combinational logic evaluates with a as A and b as B
    And the combinational logic evaluates with a as B and b as A
    Then both evaluations should produce the same out value

  @width_check @single_bit_output
  Formal Scenario: Output remains a valid single bit for all input combinations
    Given input a is A
    And input b is B
    When the combinational logic evaluates
    Then out should be either 0 or 1
    And out should never take any value outside the 1-bit range