Feature: Decade Counter with Synchronous Reset and Slow Enable

  Background:
    Given a signal clk
    And a signal reset
    And a signal slowena
    And a signal q of width 4 bits
    And all sequential logic is triggered on the positive edge of clk

  @reset
  Formal Scenario: Synchronous reset forces counter to zero
    Given reset is 1
    When a rising edge of clk occurs
    Then q should become 4'b0000

  @reset @priority
  Formal Scenario: Reset takes priority over slowena
    Given reset is 1
    And slowena is 1
    When a rising edge of clk occurs
    Then q should become 4'b0000

  @increment
  Formal Scenario: Counter increments when slowena is high and not at max
    Given reset is 0
    And slowena is 1
    And q holds value Q_CURRENT
    And Q_CURRENT is less than 9
    When a rising edge of clk occurs
    Then q should become Q_CURRENT + 1

  @wraparound
  Formal Scenario: Counter wraps to zero after reaching nine
    Given reset is 0
    And slowena is 1
    And q holds value 4'b1001
    When a rising edge of clk occurs
    Then q should become 4'b0000

  @pause
  Formal Scenario: Counter holds value when slowena is low
    Given reset is 0
    And slowena is 0
    And q holds value Q_CURRENT
    When a rising edge of clk occurs
    Then q should remain Q_CURRENT

  @range
  Formal Scenario: Counter value never exceeds nine
    Given reset is 0
    And q holds value Q_CURRENT
    And Q_CURRENT is in the range 0 to 9
    When a rising edge of clk occurs
    Then q should be in the range 0 to 9

  @range @invariant
  Formal Scenario: Counter value is always a valid decade digit
    Given the design has been running for any number of cycles
    Then q should always be in the range 0 to 9

  @noxstate
  Formal Scenario: Counter never produces invalid BCD values
    Given reset is 0
    And q holds value Q_CURRENT
    And Q_CURRENT is in the range 0 to 9
    When a rising edge of clk occurs
    Then q should never equal 4'b1010
    And q should never equal 4'b1011
    And q should never equal 4'b1100
    And q should never equal 4'b1101
    And q should never equal 4'b1110
    And q should never equal 4'b1111