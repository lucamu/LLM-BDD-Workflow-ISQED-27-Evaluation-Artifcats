Feature: XNOR Gate Combinational Logic Verification

  Background:
    Given the TopModule is a combinational design with no clock or reset
    And input a is a 1-bit signal
    And input b is a 1-bit signal
    And output out is a 1-bit signal
    And out is combinationally driven by a and b with no internal state

  @functional @xnor-truth-table
  Formal Scenario: XNOR output matches logical equivalence of inputs
    Given input a is any valid value
    And input b is any valid value
    When the combinational logic evaluates
    Then out should equal 1 if a equals b
    And out should equal 0 if a does not equal b

  @functional @xnor-algebraic
  Formal Scenario: XNOR output equals inverted XOR of inputs
    Given input a is any valid value
    And input b is any valid value
    When the combinational logic evaluates
    Then out should equal NOT (a XOR b)

  @functional @xnor-both-zero
  Formal Scenario: XNOR output when both inputs are logic 0
    Given input a is 1'b0
    And input b is 1'b0
    When the combinational logic evaluates
    Then out should equal 1

  @functional @xnor-both-one
  Formal Scenario: XNOR output when both inputs are logic 1
    Given input a is 1'b1
    And input b is 1'b1
    When the combinational logic evaluates
    Then out should equal 1

  @functional @xnor-differing-a0-b1
  Formal Scenario: XNOR output when inputs differ with a low and b high
    Given input a is 1'b0
    And input b is 1'b1
    When the combinational logic evaluates
    Then out should equal 0

  @functional @xnor-differing-a1-b0
  Formal Scenario: XNOR output when inputs differ with a high and b low
    Given input a is 1'b1
    And input b is 1'b0
    When the combinational logic evaluates
    Then out should equal 0

  @functional @xnor-symmetry
  Formal Scenario: XNOR output is symmetric with respect to input order
    Given input a is any valid value X
    And input b is any valid value Y
    When the combinational logic evaluates with a equal to X and b equal to Y
    And the combinational logic evaluates again with a equal to Y and b equal to X
    Then out should be identical in both evaluations

  @functional @xnor-self-complement
  Formal Scenario: XNOR output is 0 when inputs are complementary
    Given input a is any valid value X
    And input b is the logical complement of X
    When the combinational logic evaluates
    Then out should equal 0

  @functional @xnor-self-equal
  Formal Scenario: XNOR output is 1 when both inputs are the same signal
    Given input a is any valid value X
    And input b is equal to X
    When the combinational logic evaluates
    Then out should equal 1

  @functional @xnor-no-dependency-on-history
  Formal Scenario: XNOR output depends only on current input values
    Given input a is any valid value
    And input b is any valid value
    When the combinational logic evaluates at any time step
    Then out should be a pure function of the current a and b
    And out should not depend on any previous input values