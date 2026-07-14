Feature: TopModule combinational logic verification
  Formal verification of a 3-input combinational circuit that computes
  f = (~x3 & x2) | (x1 & x3) exactly matching the specified truth table.

  Background:
    Given the design "TopModule" is purely combinational with no clock and no reset
    And inputs "x3", "x2", "x1" are single-bit signals that may take any boolean value
    And output "f" is a single-bit signal determined only by the current values of "x3", "x2", "x1"

  @core @full-function
  Formal Scenario: Output equals the derived sum-of-products expression for all inputs
    Given x3 is an arbitrary boolean value
    And x2 is an arbitrary boolean value
    And x1 is an arbitrary boolean value
    When the combinational logic evaluates f
    Then f should equal ((not x3) and x2) or (x1 and x3)

  @boundary @x3-low
  Formal Scenario: When x3 is 0, output tracks x2 regardless of x1
    Given x3 is 0
    And x2 is an arbitrary boolean value
    And x1 is an arbitrary boolean value
    When the combinational logic evaluates f
    Then f should equal x2

  @boundary @x3-high
  Formal Scenario: When x3 is 1, output tracks x1 regardless of x2
    Given x3 is 1
    And x2 is an arbitrary boolean value
    And x1 is an arbitrary boolean value
    When the combinational logic evaluates f
    Then f should equal x1

  @boundary @x2-low
  Formal Scenario: When x2 is 0, output equals x1 AND x3
    Given x2 is 0
    And x3 is an arbitrary boolean value
    And x1 is an arbitrary boolean value
    When the combinational logic evaluates f
    Then f should equal (x1 and x3)

  @boundary @x2-high
  Formal Scenario: When x2 is 1, output equals NOT x3 OR x1
    Given x2 is 1
    And x3 is an arbitrary boolean value
    And x1 is an arbitrary boolean value
    When the combinational logic evaluates f
    Then f should equal ((not x3) or x1)

  @sanity @all-zero
  Formal Scenario: All inputs low produces low output
    Given x3 is 0
    And x2 is 0
    And x1 is 0
    When the combinational logic evaluates f
    Then f should equal 0

  @sanity @all-one
  Formal Scenario: All inputs high produces high output
    Given x3 is 1
    And x2 is 1
    And x1 is 1
    When the combinational logic evaluates f
    Then f should equal 1

  @consistency @deterministic
  Formal Scenario: Output is a pure function of current inputs (no hidden state)
    Given x3 is an arbitrary boolean value
    And x2 is an arbitrary boolean value
    And x1 is an arbitrary boolean value
    When the combinational logic evaluates f twice with the same input values
    Then both evaluations of f should be equal
    And f should equal ((not x3) and x2) or (x1 and x3)