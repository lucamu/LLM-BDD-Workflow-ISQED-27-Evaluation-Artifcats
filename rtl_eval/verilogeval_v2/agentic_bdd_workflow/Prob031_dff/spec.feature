Feature: Single D Flip-Flop
  Formal verification of a single-bit D flip-flop that samples input d
  on every positive edge of clk and drives the value onto output q.

  Background:
    Given the module TopModule
    And input clk is the system clock
    And input d is a symbolic 1-bit value
    And output q is a symbolic 1-bit value
    And all sequential behavior is triggered on the positive edge of clk

  @core @basic
  Formal Scenario: Output follows input after one clock edge
    Given d holds a symbolic value D at the current cycle
    When a positive edge of clk occurs
    Then q should equal D in the next cycle

  @stability
  Formal Scenario: Output remains stable when input is unchanged
    Given d holds a symbolic value D
    And q currently equals D
    When a positive edge of clk occurs
    And d still holds the same value D
    Then q should equal D after the clock edge

  @no_combinational_path
  Formal Scenario: Output does not change between clock edges
    Given q holds a symbolic value Q at the current cycle
    When d changes to any symbolic value D
    And no positive edge of clk occurs
    Then q should remain equal to Q

  @toggle
  Formal Scenario: Output toggles correctly when input toggles
    Given d holds a symbolic value D at the current cycle
    And q equals D
    When d transitions to the logical complement of D
    And a positive edge of clk occurs
    Then q should equal the logical complement of D

  @causality
  Formal Scenario: Next-state output equals past sampled input value
    Given d holds a symbolic value D at time T
    When a positive edge of clk occurs at time T
    Then q sampled at time T+1 should equal the value of d sampled at time T using $past semantics

  @reachability
  Formal Scenario: Output q can reach symbolic value 0
    # Note: 0 represents one of the two exhaustive cover targets spanning the
    # full value domain of the 1-bit signal d, not an arbitrary test datum.
    Given d holds the symbolic value 0
    When a positive edge of clk occurs
    Then q should equal 0
    And this state should be reachable and coverable

  @reachability
  Formal Scenario: Output q can reach symbolic value 1
    # Note: 1 represents the other of the two exhaustive cover targets spanning
    # the full value domain of the 1-bit signal d, not an arbitrary test datum.
    Given d holds the symbolic value 1
    When a positive edge of clk occurs
    Then q should equal 1
    And this state should be reachable and coverable

  @no_reset_interface
  Formal Scenario: q's update is solely a function of past d via clk with no reset influence
    Given the module TopModule interface exposes only clk, d, and q
    And no reset input signal is declared in the interface
    Then it should be a formally checkable invariant that, for all times T greater than the initial cycle,
      q sampled at time T equals the value of d sampled at time T-1 using $past semantics
    And no signal other than $past(d) and clk edges should influence the value of q at any time