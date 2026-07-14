Feature: TopModule Karnaugh Map Combinational Logic

  The design implements a purely combinational function f(x[3:0])
  defined by the given Karnaugh map. Cells marked "d" are don't-care
  and are intentionally left unconstrained by this specification.
  Only the explicitly specified (non-don't-care) cells are verified.

  # Don't-care cells (unconstrained, no assertion made for these inputs):
  #   x = 4'b0000
  #   x = 4'b1100
  #   x = 4'b1000
  #   x = 4'b0101
  #   x = 4'b1111
  #   x = 4'b1011
  #   x = 4'b1010

  Background:
    Given a combinational module TopModule with input x[3:0] and output f
    And f depends only on the current value of x with no internal state
    And there is no clock or reset signal

  @minterm
  Formal Scenario: f is 0 when x equals 4'b0100
    Given x is 4'b0100
    When f is evaluated for this x
    Then f should be 0

  @minterm
  Formal Scenario: f is 0 when x equals 4'b0001
    Given x is 4'b0001
    When f is evaluated for this x
    Then f should be 0

  @minterm
  Formal Scenario: f is 1 when x equals 4'b1101
    Given x is 4'b1101
    When f is evaluated for this x
    Then f should be 1

  @minterm
  Formal Scenario: f is 0 when x equals 4'b1001
    Given x is 4'b1001
    When f is evaluated for this x
    Then f should be 0

  @minterm
  Formal Scenario: f is 0 when x equals 4'b1110
    Given x is 4'b1110
    When f is evaluated for this x
    Then f should be 0

  @minterm
  Formal Scenario: f is 1 when x equals 4'b0011
    Given x is 4'b0011
    When f is evaluated for this x
    Then f should be 1

  @minterm
  Formal Scenario: f is 1 when x equals 4'b0111
    Given x is 4'b0111
    When f is evaluated for this x
    Then f should be 1

  @minterm
  Formal Scenario: f is 1 when x equals 4'b0010
    Given x is 4'b0010
    When f is evaluated for this x
    Then f should be 1

  @minterm
  Formal Scenario: f is 1 when x equals 4'b0110
    Given x is 4'b0110
    When f is evaluated for this x
    Then f should be 1

  @determinism
  Formal Scenario: f is a pure function of x
    Given two evaluation instances with identical values of x
    When f is evaluated for both instances
    Then f should be equal in both instances