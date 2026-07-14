Feature: TopModule Boolean Function Verification
  Verify that TopModule correctly implements the boolean function z = (x^y) & x
  for all combinations of the single-bit inputs x and y.

  Background:
    Given the design is a purely combinational module named TopModule
    And the module has input x
    And the module has input y
    And the module has output z
    And there is no clock or reset signal in this design

  @combinational @functional @primary
  Formal Scenario: Output equals the boolean function of the inputs
    Given input x is any valid value
    And input y is any valid value
    When the combinational logic evaluates
    Then the output z should equal (x ^ y) & x

  @combinational @equivalence
  Formal Scenario: Output equals the simplified AND-NOT form
    Given input x is any valid value
    And input y is any valid value
    When the combinational logic evaluates
    Then the output z should equal x & (~y)

  @combinational @corner-case
  Formal Scenario: Output is 0 when x is 0 regardless of y
    Given input x is 1'b0
    And input y is any valid value
    When the combinational logic evaluates
    Then the output z should equal 1'b0

  @combinational @corner-case
  Formal Scenario: Output is 0 when x equals y
    Given input x is any valid value
    And input y equals x
    When the combinational logic evaluates
    Then the output z should equal 1'b0

  @combinational @corner-case
  Formal Scenario: Output is 1 only when x is 1 and y is 0
    Given input x is 1'b1
    And input y is 1'b0
    When the combinational logic evaluates
    Then the output z should equal 1'b1

  @combinational @corner-case
  Formal Scenario: Output is 0 when x is 1 and y is 1
    Given input x is 1'b1
    And input y is 1'b1
    When the combinational logic evaluates
    Then the output z should equal 1'b0

  @combinational @exhaustive
  Formal Scenario: Output never depends on any state outside x and y
    Given input x is any valid value
    And input y is any valid value
    When the combinational logic evaluates
    Then the output z should depend only on the current values of x and y
    And the output z should update immediately without sequential delay