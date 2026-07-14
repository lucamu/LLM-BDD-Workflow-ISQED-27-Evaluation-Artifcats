Feature: Decade Counter (1 to 10) with Synchronous Reset

  As a hardware designer
  I want a decade counter that counts from 1 through 10 inclusive
  So that I can verify correct reset, increment, and wraparound behavior formally

  Background:
    Given a signal clk
    And a signal reset
    And an output q of 4 bits
    And all sequential logic is triggered on the positive edge of clk
    And reset is active high and synchronous

  @reset
  Formal Scenario: Synchronous reset forces counter to 1
    Given the current state is any value
    When reset is 1
    And a rising edge of clk occurs
    Then q should be 4'b0001

  @reset-priority
  Formal Scenario: Reset takes priority over counting
    Given q holds value Q, where Q is any value in the range 1 to 10 inclusive
    And reset is 1
    When a rising edge of clk occurs
    Then q should be 4'b0001 regardless of Q

  @increment
  Formal Scenario: Counter increments by one when not at maximum
    Given reset is 0
    And q holds value Q, where Q is any value in the range 1 to 9 inclusive
    When a rising edge of clk occurs
    Then q should be Q + 1

  @wraparound
  Formal Scenario: Counter wraps from 10 back to 1
    Given reset is 0
    And q holds value 4'b1010
    When a rising edge of clk occurs
    Then q should be 4'b0001

  @range-invariant
  Formal Scenario: Counter value always stays within valid decade range
    Given q holds value Q, where Q is any value in the range 1 to 10 inclusive
    When a rising edge of clk occurs
    Then q should be in the range 1 to 10 inclusive

  @no-invalid-state
  Formal Scenario: Counter never produces value 0 or above 10
    Given the design has been reset at least once
    Then q should never equal 4'b0000
    And q should never be greater than 4'b1010

  @stability-without-clock
  Formal Scenario: Counter output does not change without a clock edge
    Given q holds value Q, where Q is any value in the range 1 to 10 inclusive
    And no rising edge of clk occurs
    Then q should remain equal to Q