Feature: TopModule Combinational Logic (XNOR Function)
  The TopModule implements a combinational circuit where the output z
  is the logical XNOR of inputs x and y. This specification captures
  the exhaustive input/output relationship for formal verification.

  Background:
    Given a combinational module TopModule
    And input x
    And input y
    And output z
    And the output z depends only on the current values of x and y

  @formal @combinational @exhaustive
  Formal Scenario: Output z is the logical XNOR of x and y
    Given input x is any valid value
    And input y is any valid value
    When the inputs are evaluated combinationally
    Then output z should be 1 if x equals y
    And output z should be 0 if x does not equal y

  @formal @combinational @case
  Formal Scenario: Both inputs low produces high output
    Given input x is 0
    And input y is 0
    When the inputs are evaluated combinationally
    Then output z should be 1

  @formal @combinational @case
  Formal Scenario: Only x high produces low output
    Given input x is 1
    And input y is 0
    When the inputs are evaluated combinationally
    Then output z should be 0

  @formal @combinational @case
  Formal Scenario: Only y high produces low output
    Given input x is 0
    And input y is 1
    When the inputs are evaluated combinationally
    Then output z should be 0

  @formal @combinational @case
  Formal Scenario: Both inputs high produces high output
    Given input x is 1
    And input y is 1
    When the inputs are evaluated combinationally
    Then output z should be 1

  @formal @combinational @equivalence
  Formal Scenario: Output equals bitwise XNOR expression
    Given input x is any valid value
    And input y is any valid value
    When the inputs are evaluated combinationally
    Then output z should equal (~(x ^ y)) & 1'b1

  @formal @combinational @symmetry
  Formal Scenario: Output is symmetric with respect to inputs
    Given input x is any valid value X
    And input y is any valid value Y
    When the inputs are evaluated combinationally with x = X and y = Y
    And the inputs are evaluated combinationally with x = Y and y = X
    Then output z in the first evaluation should equal output z in the second evaluation