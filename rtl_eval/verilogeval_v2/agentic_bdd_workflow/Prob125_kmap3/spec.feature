Feature: Combinational Logic Karnaugh Map Implementation

  This module implements a 4-input, 1-output combinational logic function
  defined by a Karnaugh map with input d treated as don't-care.
  The minimized logic equation is: out = a OR (NOT b AND c)
  Input d has no effect on the output in any legal implementation.

  Background:
    Given the design is purely combinational with no clock or reset
    And input a is any symbolic value
    And input b is any symbolic value
    And input c is any symbolic value
    And input d is any symbolic value

  @core-function
  Formal Scenario: Output matches the minimized sum-of-products equation
    Given input a is any symbolic value
    And input b is any symbolic value
    And input c is any symbolic value
    And input d is any symbolic value
    When the combinational logic evaluates
    Then out should equal a OR (NOT b AND c)

  @a-dominant
  Formal Scenario: Output is forced high whenever a is asserted
    Given input a is 1
    And input b is any symbolic value
    And input c is any symbolic value
    And input d is any symbolic value
    When the combinational logic evaluates
    Then out should be 1

  @b-forces-low
  Formal Scenario: Output is forced low when a is deasserted and b is asserted
    Given input a is 0
    And input b is 1
    And input c is any symbolic value
    And input d is any symbolic value
    When the combinational logic evaluates
    Then out should be 0

  @c-passthrough
  Formal Scenario: Output follows c when a and b are both deasserted
    Given input a is 0
    And input b is 0
    And input c is any symbolic value
    And input d is any symbolic value
    When the combinational logic evaluates
    Then out should equal c

  @dont-care-independence
  Formal Scenario: Output is independent of d for any fixed a, b, c
    Given input a is any symbolic value
    And input b is any symbolic value
    And input c is any symbolic value
    And input d is any symbolic value
    And a second evaluation uses the same a, b, c but a different value of d
    When the combinational logic evaluates in both cases
    Then out should be identical in both evaluations

  @full-cover-ones
  Formal Scenario: Output is high for all mandatory ON-set entries
    Given input a is 1
    And input b is any symbolic value
    And input c is any symbolic value
    And input d is any symbolic value
    When the combinational logic evaluates
    Then out should be 1

  @full-cover-zeros
  Formal Scenario: Output is low for all mandatory OFF-set entries
    Given input a is 0
    And input b is 1
    And input c is any symbolic value
    And input d is any symbolic value
    When the combinational logic evaluates
    Then out should be 0