Feature: 8-bit D Flip-Flop with Asynchronous Active-High Reset

  As a hardware designer
  I want an 8-bit register built from D flip-flops with asynchronous reset
  So that the output reliably tracks the input on clock edges and resets immediately when areset is asserted

  Background:
    Given a module named TopModule
    And an input clk
    And an input areset
    And an input d of width 8 bits
    And an output q of width 8 bits
    And q is driven by 8 D flip-flops with active-high asynchronous reset
    And all flip-flops are triggered on the positive edge of clk

  @reset @async
  Formal Scenario: Asynchronous reset forces output to zero regardless of clock
    Given areset is 1
    And d holds any value D
    When areset is asserted at any time, independent of clk
    Then q should immediately become 8'b00000000
    And q should remain 8'b00000000 while areset stays 1

  @reset @deassertion
  Formal Scenario: Output remains zero immediately after reset deassertion until next clock edge
    Given areset transitions from 1 to 0
    And d holds any value D
    When no positive edge of clk has occurred yet after the deassertion
    Then q should remain 8'b00000000

  @normal_operation
  Formal Scenario: Output follows input on rising clock edge when reset is inactive
    Given areset is 0
    And d holds any value D
    When a positive edge of clk occurs
    Then q should become D

  @hold
  Formal Scenario: Output holds its value when no clock edge occurs
    Given areset is 0
    And q holds any value Q
    When no positive edge of clk occurs
    Then q should remain Q

  @reset_priority
  Formal Scenario: Asynchronous reset takes priority over data input at clock edge
    Given areset is 1
    And d holds any value D
    When a positive edge of clk occurs simultaneously with areset being 1
    Then q should be 8'b00000000
    And q should not become D

  @post_reset_capture
  Formal Scenario: First clock edge after reset deassertion captures current input value
    Given areset is 1
    And then areset transitions to 0
    And d holds any value D at the time of the next positive edge of clk
    When a positive edge of clk occurs after areset is 0
    Then q should become D

  @bitwise_independence
  Formal Scenario: Each bit of q depends only on the corresponding bit of d
    Given areset is 0
    And d holds any value D
    When a positive edge of clk occurs
    Then for each bit index i from 0 to 7, q[i] should become D[i]