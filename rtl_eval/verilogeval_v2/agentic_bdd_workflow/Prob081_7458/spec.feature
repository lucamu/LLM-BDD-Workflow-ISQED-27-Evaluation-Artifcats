Feature: TopModule - 7458 Quad AND / Dual OR Gate Chip Emulation

  This module implements the logic of the 7458 chip: two independent
  logic cones. p1y is the OR of two 3-input AND gates. p2y is the OR
  of two 2-input AND gates. The design is purely combinational.

  Background:
    Given TopModule is a combinational module with no clock and no reset
    And p1a is an arbitrary 1-bit value
    And p1b is an arbitrary 1-bit value
    And p1c is an arbitrary 1-bit value
    And p1d is an arbitrary 1-bit value
    And p1e is an arbitrary 1-bit value
    And p1f is an arbitrary 1-bit value
    And p2a is an arbitrary 1-bit value
    And p2b is an arbitrary 1-bit value
    And p2c is an arbitrary 1-bit value
    And p2d is an arbitrary 1-bit value

  @combinational @p1y @core
  Formal Scenario: p1y equals OR of two 3-input AND terms
    Given p1a, p1b, p1c, p1d, p1e, p1f hold arbitrary values
    When the combinational logic evaluates
    Then p1y should equal ((p1a AND p1b AND p1c) OR (p1d AND p1e AND p1f))

  @combinational @p2y @core
  Formal Scenario: p2y equals OR of two 2-input AND terms
    Given p2a, p2b, p2c, p2d hold arbitrary values
    When the combinational logic evaluates
    Then p2y should equal ((p2a AND p2b) OR (p2c AND p2d))

  @combinational @p1y @independence
  Formal Scenario: p1y is independent of p2 inputs
    Given p1a, p1b, p1c, p1d, p1e, p1f hold arbitrary values
    And p2a, p2b, p2c, p2d hold arbitrary values
    When the combinational logic evaluates
    Then p1y should equal ((p1a AND p1b AND p1c) OR (p1d AND p1e AND p1f))
    And p1y should not depend on p2a, p2b, p2c, or p2d

  @combinational @p2y @independence
  Formal Scenario: p2y is independent of p1 inputs
    Given p2a, p2b, p2c, p2d hold arbitrary values
    And p1a, p1b, p1c, p1d, p1e, p1f hold arbitrary values
    When the combinational logic evaluates
    Then p2y should equal ((p2a AND p2b) OR (p2c AND p2d))
    And p2y should not depend on p1a, p1b, p1c, p1d, p1e, or p1f

  @combinational @p1y @allzero
  Formal Scenario: p1y is 0 when all p1 inputs are 0
    Given p1a is 0
    And p1b is 0
    And p1c is 0
    And p1d is 0
    And p1e is 0
    And p1f is 0
    When the combinational logic evaluates
    Then p1y should equal 0

  @combinational @p1y @allone
  Formal Scenario: p1y is 1 when all p1 inputs are 1
    Given p1a is 1
    And p1b is 1
    And p1c is 1
    And p1d is 1
    And p1e is 1
    And p1f is 1
    When the combinational logic evaluates
    Then p1y should equal 1

  @combinational @p2y @allzero
  Formal Scenario: p2y is 0 when all p2 inputs are 0
    Given p2a is 0
    And p2b is 0
    And p2c is 0
    And p2d is 0
    When the combinational logic evaluates
    Then p2y should equal 0

  @combinational @p2y @allone
  Formal Scenario: p2y is 1 when all p2 inputs are 1
    Given p2a is 1
    And p2b is 1
    And p2c is 1
    And p2d is 1
    When the combinational logic evaluates
    Then p2y should equal 1

  @combinational @p1y @firstterm
  Formal Scenario: p1y is 1 when first AND term is satisfied regardless of second term
    Given p1a is 1
    And p1b is 1
    And p1c is 1
    And p1d, p1e, p1f hold arbitrary values
    When the combinational logic evaluates
    Then p1y should equal 1

  @combinational @p1y @secondterm
  Formal Scenario: p1y is 1 when second AND term is satisfied regardless of first term
    Given p1d is 1
    And p1e is 1
    And p1f is 1
    And p1a, p1b, p1c hold arbitrary values
    When the combinational logic evaluates
    Then p1y should equal 1

  @combinational @p1y @noterm
  Formal Scenario: p1y is 0 when neither 3-input AND term is fully satisfied
    Given p1a, p1b, p1c, p1d, p1e, p1f hold arbitrary values
    And NOT (p1a AND p1b AND p1c)
    And NOT (p1d AND p1e AND p1f)
    When the combinational logic evaluates
    Then p1y should equal 0

  @combinational @p2y @firstterm
  Formal Scenario: p2y is 1 when first AND term is satisfied regardless of second term
    Given p2a is 1
    And p2b is 1
    And p2c, p2d hold arbitrary values
    When the combinational logic evaluates
    Then p2y should equal 1

  @combinational @p2y @secondterm
  Formal Scenario: p2y is 1 when second AND term is satisfied regardless of first term
    Given p2c is 1
    And p2d is 1
    And p2a, p2b hold arbitrary values
    When the combinational logic evaluates
    Then p2y should equal 1

  @combinational @p2y @noterm
  Formal Scenario: p2y is 0 when neither 2-input AND term is fully satisfied
    Given p2a, p2b, p2c, p2d hold arbitrary values
    And NOT (p2a AND p2b)
    And NOT (p2c AND p2d)
    When the combinational logic evaluates
    Then p2y should equal 0