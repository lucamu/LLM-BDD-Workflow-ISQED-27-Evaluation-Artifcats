Feature: TopModule - 2-to-1 Multiplexer

  As a hardware designer
  I want to formally verify a 1-bit 2-to-1 multiplexer
  So that the output always reflects the correct selected input under all input combinations

  Background:
    Given a combinational module TopModule
    And an input a
    And an input b
    And an input sel
    And an output out
    And no clock or reset signals are present

  @formal @core-functionality
  Formal Scenario: Output follows input a when sel is deasserted
    Given sel is 0
    And a is any value A
    And b is any value B
    When the combinational logic evaluates
    Then out should be equal to A

  @formal @core-functionality
  Formal Scenario: Output follows input b when sel is asserted
    Given sel is 1
    And a is any value A
    And b is any value B
    When the combinational logic evaluates
    Then out should be equal to B

  @formal @general-behavior
  Formal Scenario: Output is a function of a, b, and sel for all values
    Given a is any value A
    And b is any value B
    And sel is any value S
    When the combinational logic evaluates
    Then out should be equal to (S ? B : A)

  @formal @independence
  Formal Scenario: Output does not depend on b when sel selects a
    Given sel is 0
    And a is any value A
    And b is any value B1
    When the combinational logic evaluates with b equal to B1
    Then out should be equal to A
    When b changes to any different value B2
    Then out should remain equal to A

  @formal @independence
  Formal Scenario: Output does not depend on a when sel selects b
    Given sel is 1
    And a is any value A1
    And b is any value B
    When the combinational logic evaluates with a equal to A1
    Then out should be equal to B
    When a changes to any different value A2
    Then out should remain equal to B

  @formal @no-latch
  Formal Scenario: Output is fully combinational with no hidden state
    Given a is any value A
    And b is any value B
    And sel is any value S
    When the same inputs A, B, and S are applied at any later time
    Then out should be identical to the output produced the first time

  @formal @coverage
  Formal Scenario: Both selection paths are reachable
    Given a is any value A
    And b is any value B
    Then there exists an assignment of sel such that out equals A
    And there exists an assignment of sel such that out equals B