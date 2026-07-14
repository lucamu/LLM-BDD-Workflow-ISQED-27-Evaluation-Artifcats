Feature: Top-Level Combinational Logic Verification (A/B Submodule Composition)

  Background:
    Given the design is a purely combinational circuit with no clock or reset
    And input x is a single-bit signal
    And input y is a single-bit signal
    And output z is a single-bit signal
    And each instance of submodule A computes A_out = x & (~y)
    And each instance of submodule B computes B_out = ~(x ^ y)
    And the first A instance and the first B instance feed a two-input OR gate producing OR_out = A_out | B_out
    And the second A instance and the second B instance feed a two-input AND gate producing AND_out = A_out & B_out
    And output z is produced by a two-input XOR gate: z = OR_out ^ AND_out

  @formal @functional
  Formal Scenario: Top-level output equals XOR of the A and B functions
    Given input x holds value X
    And input y holds value Y
    When the combinational logic settles
    Then output z should equal (A_out ^ B_out)
    And A_out should equal (X & (~Y))
    And B_out should equal (~(X ^ Y))

  @formal @equivalence
  Formal Scenario: OR/AND/XOR composition is equivalent to direct XOR of A and B
    Given input x holds value X
    And input y holds value Y
    When the combinational logic settles
    Then (OR_out ^ AND_out) should equal (A_out ^ B_out)

  @formal @reduction
  Formal Scenario: Simplified closed-form relationship for output z
    Given input x holds value X
    And input y holds value Y
    When the combinational logic settles
    Then output z should equal (X | (~Y))

  @formal @corner
  Formal Scenario: Output when x is 0 and y is 0
    Given input x holds value 0
    And input y holds value 0
    When the combinational logic settles
    Then output z should equal 1

  @formal @corner
  Formal Scenario: Output when x is 0 and y is 1
    Given input x holds value 0
    And input y holds value 1
    When the combinational logic settles
    Then output z should equal 0

  @formal @corner
  Formal Scenario: Output when x is 1 and y is 0
    Given input x holds value 1
    And input y holds value 0
    When the combinational logic settles
    Then output z should equal 1

  @formal @corner
  Formal Scenario: Output when x is 1 and y is 1
    Given input x holds value 1
    And input y holds value 1
    When the combinational logic settles
    Then output z should equal 1

  @formal @stateless
  Formal Scenario: Output depends only on current inputs, not on history
    Given input x holds value X
    And input y holds value Y
    And input x previously held any different value X_prev
    And input y previously held any different value Y_prev
    When the combinational logic settles
    Then output z should equal (X | (~Y))
    And output z should not depend on X_prev or Y_prev