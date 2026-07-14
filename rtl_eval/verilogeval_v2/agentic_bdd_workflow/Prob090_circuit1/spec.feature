Feature: Combinational AND Gate
  Verify that TopModule implements a two-input logical AND function,
  where output q is asserted only when both inputs a and b are asserted.

  Background:
    Given a combinational module TopModule
    And inputs a and b
    And output q

  @formal @core-logic
  Formal Scenario: Output reflects logical AND of inputs
    Given input a is any valid value A
    And input b is any valid value B
    When the combinational logic evaluates
    Then the output q should be A and B

  @formal @edge-case
  Formal Scenario: Output is 0 when both inputs are 0
    Given input a is 0
    And input b is 0
    When the combinational logic evaluates
    Then the output q should be 0

  @formal @edge-case
  Formal Scenario: Output is 0 when only a is asserted
    Given input a is 1
    And input b is 0
    When the combinational logic evaluates
    Then the output q should be 0

  @formal @edge-case
  Formal Scenario: Output is 0 when only b is asserted
    Given input a is 0
    And input b is 1
    When the combinational logic evaluates
    Then the output q should be 0

  @formal @edge-case
  Formal Scenario: Output is 1 when both inputs are asserted
    Given input a is 1
    And input b is 1
    When the combinational logic evaluates
    Then the output q should be 1

  @formal @invariant
  Formal Scenario: Output never exceeds either input
    Given input a is any valid value A
    And input b is any valid value B
    When the combinational logic evaluates
    Then the output q should be less than or equal to A
    And the output q should be less than or equal to B

  @formal @invariant
  Formal Scenario: Output is stable and deterministic for identical inputs
    Given input a is any valid value A
    And input b is any valid value B
    When the combinational logic evaluates twice with the same A and B
    Then the output q should be identical on both evaluations