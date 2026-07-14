Feature: Sticky Falling-Edge Detector for 32-bit Input Vector

  As a hardware designer
  I want each bit of the 32-bit output to capture a 1-to-0 transition
  on the corresponding input bit and hold that captured value until
  a synchronous reset occurs
  So that transient falling edges on any bit of "in" are latched in "out"

  Background:
    Given a signal clk that toggles every cycle
    And a synchronous active-high reset signal reset
    And a 32-bit input vector in
    And a 32-bit output vector out
    And all state updates occur on the positive edge of clk

  @reset
  Formal Scenario: Synchronous reset clears all captured bits
    Given reset is 1
    And in is any 32-bit value IN_VAL
    And out was any 32-bit value PREV_OUT on the previous clock edge
    When a clock edge occurs
    Then out should be 32'h00000000

  @capture @falling_edge
  Formal Scenario: A 1-to-0 transition on any bit sets that output bit
    Given reset is 0
    And in was value PREV_IN on the previous clock edge
    And in is value CURR_IN on this clock edge
    And out was value PREV_OUT on the previous clock edge
    When a clock edge occurs
    Then out should be (PREV_IN & ~CURR_IN) | PREV_OUT

  @no_capture @stable_high
  Formal Scenario: A bit held at 1 does not newly set its output bit
    Given reset is 0
    And bit index N is any value such that 0 <= N <= 31
    And in bit N was 1 on the previous clock edge
    And in bit N is 1 on this clock edge
    And out bit N was 0 on the previous clock edge
    When a clock edge occurs
    Then out bit N should be 0

  @no_capture @stable_low
  Formal Scenario: A bit held at 0 does not newly set its output bit
    Given reset is 0
    And bit index N is any value such that 0 <= N <= 31
    And in bit N was 0 on the previous clock edge
    And in bit N is 0 on this clock edge
    And out bit N was 0 on the previous clock edge
    When a clock edge occurs
    Then out bit N should be 0

  @no_capture @rising_edge
  Formal Scenario: A 0-to-1 transition does not set the output bit
    Given reset is 0
    And bit index N is any value such that 0 <= N <= 31
    And in bit N was 0 on the previous clock edge
    And in bit N is 1 on this clock edge
    And out bit N was 0 on the previous clock edge
    When a clock edge occurs
    Then out bit N should be 0

  @sticky
  Formal Scenario: A previously captured bit remains set regardless of subsequent input activity
    Given reset is 0
    And bit index N is any value such that 0 <= N <= 31
    And out bit N was 1 on the previous clock edge
    And in bit N was any value PREV_BIT on the previous clock edge
    And in bit N is any value CURR_BIT on this clock edge
    When a clock edge occurs
    Then out bit N should be 1

  @independence
  Formal Scenario: Each output bit depends only on the corresponding input bit history
    Given reset is 0
    And bit index N is any value such that 0 <= N <= 31
    And in bit N was value PREV_BIT on the previous clock edge
    And in bit N is value CURR_BIT on this clock edge
    And out bit N was value PREV_OUT_BIT on the previous clock edge
    And all other bits of in and out hold arbitrary values
    When a clock edge occurs
    Then out bit N should be (PREV_BIT & ~CURR_BIT) | PREV_OUT_BIT

  @vector_update
  Formal Scenario: Full 32-bit next-state relation for out
    Given reset is 0
    And in was value PREV_IN on the previous clock edge
    And in is value CURR_IN on this clock edge
    And out was value PREV_OUT on the previous clock edge
    When a clock edge occurs
    Then out should equal (PREV_IN & ~CURR_IN) | PREV_OUT

  @reset_priority
  Formal Scenario: Reset overrides any pending capture in the same cycle
    Given reset is 1
    And in was value PREV_IN on the previous clock edge
    And in is value CURR_IN on this clock edge such that PREV_IN & ~CURR_IN is nonzero
    And out was value PREV_OUT on the previous clock edge
    When a clock edge occurs
    Then out should be 32'h00000000