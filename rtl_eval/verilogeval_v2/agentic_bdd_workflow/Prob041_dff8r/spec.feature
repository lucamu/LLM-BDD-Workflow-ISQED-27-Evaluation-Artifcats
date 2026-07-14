Feature: 8-bit Register with Synchronous Active-High Reset

  As a hardware designer
  I want an 8-bit register built from 8 D flip-flops
  So that data is captured synchronously and can be reset to zero synchronously

  Background:
    Given a signal clk representing the system clock
    And a signal reset representing the active high synchronous reset
    And an 8-bit input signal d representing the flip-flop data input
    And an 8-bit output signal q representing the flip-flop data output
    And all 8 flip-flops are triggered on the positive edge of clk

  @reset @synchronous
  Formal Scenario: Synchronous reset forces output to zero on next clock edge
    Given reset is 1
    And d is any value X
    When a rising edge of clk occurs
    Then q should be 8'b00000000

  @data @capture
  Formal Scenario: Output captures input data when reset is not asserted
    Given reset is 0
    And d is any value X
    When a rising edge of clk occurs
    Then q should be X

  @reset @priority
  Formal Scenario: Reset takes priority over data input at the clock edge
    Given reset is 1
    And d is any value X
    When a rising edge of clk occurs
    Then q should be 8'b00000000 regardless of the value of X

  @stability @no_edge
  Formal Scenario: Output remains stable without a clock edge
    Given reset is 0
    And q holds a value Q
    And d is any value X
    When no rising edge of clk occurs
    Then q should remain Q

  @reset @stability
  Formal Scenario: Output remains zero while reset stays asserted across multiple cycles
    Given reset is 1
    And q holds value 8'b00000000
    When a rising edge of clk occurs
    And reset remains 1
    Then q should remain 8'b00000000

  @deassertion @transition
  Formal Scenario: Output transitions from reset value to input data when reset is deasserted
    Given reset is 1
    When a rising edge of clk occurs
    Then q should be 8'b00000000
    Given reset is 0
    And d is any value X
    When a rising edge of clk occurs
    Then q should be X

  @bitwise @independence
  Formal Scenario: Each output bit depends only on its corresponding input bit
    Given reset is 0
    And d is any value X
    When a rising edge of clk occurs
    Then q[0] should be X[0]
    And q[1] should be X[1]
    And q[2] should be X[2]
    And q[3] should be X[3]
    And q[4] should be X[4]
    And q[5] should be X[5]
    And q[6] should be X[6]
    And q[7] should be X[7]