Feature: 4-to-1 Multiplexer with Default Constant Output

  This module implements a combinational multiplexer that selects
  among inputs a, b, d, e based on the value of selector c, with
  a fixed constant output of 4'hF for all unmapped selector values.

  Background:
    Given the design is combinational with no clock or reset
    And input a is a 4-bit value
    And input b is a 4-bit value
    And input c is a 4-bit value
    And input d is a 4-bit value
    And input e is a 4-bit value
    And output q is a 4-bit value

  @formal @mux-select-0
  Formal Scenario: Selector value 0 routes input b to output
    Given a is any 4-bit value A
    And b is any 4-bit value B
    And c is 4'b0000
    And d is any 4-bit value D
    And e is any 4-bit value E
    When the combinational logic evaluates
    Then q should equal B

  @formal @mux-select-1
  Formal Scenario: Selector value 1 routes input e to output
    Given a is any 4-bit value A
    And b is any 4-bit value B
    And c is 4'b0001
    And d is any 4-bit value D
    And e is any 4-bit value E
    When the combinational logic evaluates
    Then q should equal E

  @formal @mux-select-2
  Formal Scenario: Selector value 2 routes input a to output
    Given a is any 4-bit value A
    And b is any 4-bit value B
    And c is 4'b0010
    And d is any 4-bit value D
    And e is any 4-bit value E
    When the combinational logic evaluates
    Then q should equal A

  @formal @mux-select-3
  Formal Scenario: Selector value 3 routes input d to output
    Given a is any 4-bit value A
    And b is any 4-bit value B
    And c is 4'b0011
    And d is any 4-bit value D
    And e is any 4-bit value E
    When the combinational logic evaluates
    Then q should equal D

  @formal @mux-default-low
  Formal Scenario: Selector values 4 through 9 produce constant output
    Given a is any 4-bit value A
    And b is any 4-bit value B
    And c is any 4-bit value in range 4'h4 to 4'h9
    And d is any 4-bit value D
    And e is any 4-bit value E
    When the combinational logic evaluates
    Then q should equal 4'hF

  @formal @mux-default-high
  Formal Scenario: Selector values A through F produce constant output
    Given a is any 4-bit value A
    And b is any 4-bit value B
    And c is any 4-bit value in range 4'hA to 4'hF
    And d is any 4-bit value D
    And e is any 4-bit value E
    When the combinational logic evaluates
    Then q should equal 4'hF

  @formal @mux-exhaustive
  Formal Scenario: Output is fully determined by selector for all cases
    Given a is any 4-bit value A
    And b is any 4-bit value B
    And c is any 4-bit value C
    And d is any 4-bit value D
    And e is any 4-bit value E
    When the combinational logic evaluates
    Then q should equal B if C equals 4'h0
    And q should equal E if C equals 4'h1
    And q should equal A if C equals 4'h2
    And q should equal D if C equals 4'h3
    And q should equal 4'hF if C is greater than or equal to 4'h4

  @formal @no-x-propagation
  Formal Scenario: Output is always fully defined for valid inputs
    Given a is any 4-bit value A
    And b is any 4-bit value B
    And c is any 4-bit value C
    And d is any 4-bit value D
    And e is any 4-bit value E
    When the combinational logic evaluates
    Then q should never be unknown or undefined