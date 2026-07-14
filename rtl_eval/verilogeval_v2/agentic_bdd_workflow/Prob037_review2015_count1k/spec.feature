Feature: Mod-1000 Counter with Synchronous Reset

  As a hardware designer
  I want a 10-bit counter that counts from 0 to 999 and wraps around
  So that it produces a repeating period of 1000 clock cycles

  Background:
    Given a signal clk representing the system clock
    And a signal reset representing the active-high synchronous reset
    And an output signal q of 10 bits representing the counter value
    And all sequential logic is triggered on the positive edge of clk

  @reset
  Formal Scenario: Synchronous reset forces counter to zero
    Given the current state of the counter is any valid value Q
    And reset is asserted to 1
    When a rising edge of clk occurs
    Then q should be 0 on the next clock cycle

  @increment
  Formal Scenario: Counter increments by one when not at maximum and not reset
    Given the current value of q is Q
    And Q is less than 999
    And reset is 0
    When a rising edge of clk occurs
    Then q should be Q + 1 on the next clock cycle

  @wraparound
  Formal Scenario: Counter wraps to zero after reaching 999
    Given the current value of q is 999
    And reset is 0
    When a rising edge of clk occurs
    Then q should be 0 on the next clock cycle

  @range
  Formal Scenario: Counter value never exceeds 999
    Given the counter has been operating for any number of cycles
    And reset has been deasserted after initialization
    Then q should always be less than or equal to 999

  @range
  Formal Scenario: Counter value is never negative
    Given q is a 10-bit unsigned value
    Then q should always be greater than or equal to 0

  @reset_priority
  Formal Scenario: Reset takes priority over increment
    Given the current value of q is Q
    And Q is less than 999
    And reset is asserted to 1
    When a rising edge of clk occurs
    Then q should be 0 on the next clock cycle
    And q should not be Q + 1 on the next clock cycle

  @periodicity
  Formal Scenario: Counter period is exactly 1000 cycles
    Given the current value of q is Q
    And reset remains 0 for 1000 consecutive clock cycles
    When 1000 rising edges of clk occur
    Then q should return to its original value Q

  @stability
  Formal Scenario: Counter holds no invalid intermediate states
    Given the current value of q is Q
    And Q is any value from 0 to 999
    And reset is 0
    When a rising edge of clk occurs
    Then the next value of q should be (Q + 1) modulo 1000