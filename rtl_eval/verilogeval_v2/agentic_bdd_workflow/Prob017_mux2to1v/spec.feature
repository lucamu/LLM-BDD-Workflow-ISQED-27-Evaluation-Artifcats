Feature: 100-bit 2-to-1 Multiplexer (TopModule)

  Formal verification of a purely combinational 2-1 multiplexer that
  selects between two 100-bit operands based on a select signal.

  Background:
    Given a combinational module "TopModule"
    And an input "a" of width 100 bits representing any value A
    And an input "b" of width 100 bits representing any value B
    And an input "sel" of width 1 bit representing any value S
    And an output "out" of width 100 bits representing the result
    And no clock or reset signal is present in this design
    And the output "out" is a purely combinational function of "a", "b", and "sel"

  @combinational @select-zero
  Formal Scenario: Output equals A when sel is 0
    Given input "a" holds value A
    And input "b" holds value B
    And input "sel" equals 0
    When the module evaluates combinationally
    Then the output "out" should equal A

  @combinational @select-one
  Formal Scenario: Output equals B when sel is 1
    Given input "a" holds value A
    And input "b" holds value B
    And input "sel" equals 1
    When the module evaluates combinationally
    Then the output "out" should equal B

  @combinational @general-mux-behavior
  Formal Scenario: Output equals the value selected by sel for any inputs
    Given input "a" holds value A
    And input "b" holds value B
    And input "sel" holds value S
    When the module evaluates combinationally
    Then the output "out" should equal ((S == 0) ? A : B)

  @combinational @no-dependency-on-unselected-input
  Formal Scenario: Output does not depend on B when sel is 0
    Given input "a" holds value A
    And input "b" holds any value B1
    And input "sel" equals 0
    When the module evaluates combinationally
    Then the output "out" should equal A
    And the output "out" should be independent of the value of "b"

  @combinational @no-dependency-on-unselected-input
  Formal Scenario: Output does not depend on A when sel is 1
    Given input "a" holds any value A1
    And input "b" holds value B
    And input "sel" equals 1
    When the module evaluates combinationally
    Then the output "out" should equal B
    And the output "out" should be independent of the value of "a"

  @combinational @equal-operands
  Formal Scenario: Output equals common value when A and B are equal
    Given input "a" holds value A
    And input "b" holds value A
    And input "sel" holds any value S
    When the module evaluates combinationally
    Then the output "out" should equal A

  @combinational @bit-width-integrity
  Formal Scenario: Output width matches operand width with no truncation or extension
    Given input "a" holds value A
    And input "b" holds value B
    And input "sel" holds value S
    When the module evaluates combinationally
    Then the output "out" should be exactly 100 bits wide
    And no bits of "out" should be undefined or unknown for any valid A, B, S