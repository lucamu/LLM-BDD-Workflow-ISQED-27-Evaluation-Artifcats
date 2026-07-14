Feature: 8-bit DFF Bank with Synchronous Active-High Reset to 0x34, Triggered on Negative Clock Edge

  As a hardware designer
  I want 8 D flip-flops with synchronous reset to a non-zero value (0x34)
  So that the register initializes to a known state on reset and otherwise samples d

  Background:
    Given a module named TopModule
    And an input clk
    And an input reset
    And an input [7:0] d
    And an output [7:0] q
    And all flip-flops are triggered on the negative edge of clk
    And the synchronous reset is active-high

  @reset @negedge
  Formal Scenario: Synchronous reset forces q to 0x34
    Given reset is 1
    And d is any value X
    When the negative edge of clk occurs
    Then q should be 8'h34

  @reset @negedge @priority
  Formal Scenario: Reset takes priority over data input
    Given reset is 1
    And d is any value X
    When the negative edge of clk occurs
    Then q should be 8'h34
    And q should not equal X unless X equals 8'h34

  @data_capture @negedge
  Formal Scenario: Normal operation loads d into q when reset is deasserted
    Given reset is 0
    And d is any value X
    When the negative edge of clk occurs
    Then q should be X

  @no_change @posedge
  Formal Scenario: q does not change on positive clock edge
    Given q holds value Q_PREV
    And reset is any value
    And d is any value
    When the positive edge of clk occurs
    Then q should remain Q_PREV

  @reset_sequence @negedge
  Formal Scenario: Reset value persists across multiple negative edges while reset stays asserted
    Given reset is 1
    And d is any value X1
    When the negative edge of clk occurs
    Then q should be 8'h34
    Given reset is 1
    And d is any value X2
    When the negative edge of clk occurs
    Then q should be 8'h34

  @reset_release @negedge
  Formal Scenario: Deasserting reset allows q to follow d on the next negative edge
    Given reset is 1
    And d is any value X1
    When the negative edge of clk occurs
    Then q should be 8'h34
    Given reset is 0
    And d is any value X2
    When the negative edge of clk occurs
    Then q should be X2

  @width @static
  Formal Scenario: q is always an 8-bit value bounded within valid range
    Given d is any value X
    And reset is any value
    When the negative edge of clk occurs
    Then q should be in the range 0 to 255