Feature: 7:1 Clock Divider with 50% Duty Cycle

  As a hardware designer
  I want clk_out7 to be a divided version of clk_in with a 7:1 ratio and 50% duty cycle
  So that I can generate a slower, symmetric clock from a faster reference clock

  Background:
    Given a synchronous design clocked by clk_in
    And rst is an active-low reset signal
    And clk_out7 is derived internally from clk_in edge counting logic that wraps every 7 clk_in cycles
    And let N represent the number of clk_in rising edges that have elapsed since rst was last deasserted

  @reset @initialization
  Formal Scenario: Reset forces clk_out7 to its defined initial state
    Given rst is asserted low
    Then clk_out7 should equal the fixed reset value produced when all internal divider counters are held at zero

  @reset @stability
  Formal Scenario: clk_out7 holds its reset value while reset remains asserted
    Given rst is held low for an arbitrary number of consecutive clk_in cycles
    When no rising or falling edge of clk_in changes the reset condition
    Then clk_out7 should remain equal to its reset value for every one of those cycles

  @reset @recovery
  Formal Scenario: clk_out7 resumes correct periodic division after reset release
    Given rst transitions from low to high (deasserted) at some clk_in cycle
    And clk_in continues to toggle afterward
    Then clk_out7 should resume the 7-cycle division pattern starting from the internal counters' initialized state
    And the resumed pattern should be identical to the pattern produced by any other reset release event

  @period
  Formal Scenario: clk_out7 period equals seven clk_in cycles
    Given rst is deasserted and clk_in is free-running
    And clk_out7 exhibits a rising transition at cycle N
    Then clk_out7 should exhibit its next rising transition at cycle N + 7
    And clk_out7 should exhibit a falling transition exactly once between cycle N and cycle N + 7

  @frequency
  Formal Scenario: clk_out7 frequency is one seventh of clk_in frequency
    Given rst is deasserted and clk_in completes 14 consecutive rising edges
    Then clk_out7 should exhibit exactly 2 rising transitions within those 14 clk_in cycles
    And clk_out7 should exhibit exactly 2 falling transitions within those 14 clk_in cycles

  @duty_cycle
  Formal Scenario: clk_out7 maintains a 50% duty cycle over one period
    Given rst is deasserted and clk_in is free-running
    And one full period of clk_out7 spans 7 consecutive clk_in cycles measured in clk_in half-cycles
    Then the total duration clk_out7 is high during that period should equal the total duration clk_out7 is low during that period
    And this equality should hold using both rising-edge and falling-edge aligned half-cycle counts of clk_in

  @synchronization
  Formal Scenario: clk_out7 transitions occur only at clk_in edges
    Given rst is deasserted
    Then every transition of clk_out7 should coincide with either a rising edge or a falling edge of clk_in
    And clk_out7 should not change value at any point strictly between two consecutive clk_in edges

  @stability @continuity
  Formal Scenario: The 7:1 division pattern repeats indefinitely without drift
    Given rst is deasserted and clk_in continues indefinitely without further reset assertions
    Then the sequence of clk_out7 values observed during cycles N through N + 6 should equal the sequence observed during cycles N + 7 through N + 13
    And this equality should hold for any arbitrary choice of N after reset release

  @consistency
  Formal Scenario: clk_out7 value depends only on clk_in history since last reset
    Given two identical sequences of clk_in edges applied after two separate reset release events
    Then the resulting sequences of clk_out7 values should be identical for corresponding cycle indices N