Feature: 4-Input Minimum Value Selector

  Combinational module that computes the minimum of four 8-bit unsigned
  values a, b, c, d and outputs the result on min.

  Background:
    Given the module is combinational with no clock or reset
    And input a is an 8-bit unsigned value
    And input b is an 8-bit unsigned value
    And input c is an 8-bit unsigned value
    And input d is an 8-bit unsigned value
    And output min is an 8-bit unsigned value

  @bound @correctness
  Formal Scenario: min is less than or equal to a
    Given values a, b, c, and d
    When the module computes min
    Then min should be less than or equal to a

  @bound @correctness
  Formal Scenario: min is less than or equal to b
    Given values a, b, c, and d
    When the module computes min
    Then min should be less than or equal to b

  @bound @correctness
  Formal Scenario: min is less than or equal to c
    Given values a, b, c, and d
    When the module computes min
    Then min should be less than or equal to c

  @bound @correctness
  Formal Scenario: min is less than or equal to d
    Given values a, b, c, and d
    When the module computes min
    Then min should be less than or equal to d

  @membership
  Formal Scenario: min equals one of the four inputs
    Given values a, b, c, and d
    When the module computes min
    Then min should equal a or min should equal b or min should equal c or min should equal d

  @selection @a_is_min
  Formal Scenario: min selects a when a is the smallest value
    Given values a, b, c, and d
    And a is less than or equal to b
    And a is less than or equal to c
    And a is less than or equal to d
    When the module computes min
    Then min should equal a

  @selection @b_is_min
  Formal Scenario: min selects b when b is the smallest value
    Given values a, b, c, and d
    And b is less than a
    And b is less than or equal to c
    And b is less than or equal to d
    When the module computes min
    Then min should equal b

  @selection @c_is_min
  Formal Scenario: min selects c when c is the smallest value
    Given values a, b, c, and d
    And c is less than a
    And c is less than b
    And c is less than or equal to d
    When the module computes min
    Then min should equal c

  @selection @d_is_min
  Formal Scenario: min selects d when d is the smallest value
    Given values a, b, c, and d
    And d is less than a
    And d is less than b
    And d is less than c
    When the module computes min
    Then min should equal d

  @equality
  Formal Scenario: min equals the common value when all inputs are equal
    Given values a, b, c, and d
    And a equals b
    And b equals c
    And c equals d
    When the module computes min
    Then min should equal a

  @boundary @zero
  Formal Scenario: min is zero when any input is zero
    Given values a, b, c, and d
    And at least one of a, b, c, or d equals 0
    When the module computes min
    Then min should equal 0

  @boundary @max
  Formal Scenario: min equals max value only when all inputs equal max value
    Given values a, b, c, and d
    And a equals 255
    And b equals 255
    And c equals 255
    And d equals 255
    When the module computes min
    Then min should equal 255

  @combinational @no_state
  Formal Scenario: min depends only on current inputs with no hidden state
    Given values a, b, c, and d
    When the module computes min with the same input values applied again
    Then min should produce the same result both times