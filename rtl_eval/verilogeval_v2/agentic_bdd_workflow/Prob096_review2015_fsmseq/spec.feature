Feature: Sequence Detector FSM (1101) - TopModule
  Formal verification of a synchronous Moore FSM that asserts start_shifting
  permanently once the bit sequence 1101 has been observed on the data input,
  and that resets its search state on synchronous active-high reset.

  Background:
    Given a synchronous design with input clk, input reset, input data, and output start_shifting
    And reset is active-high and synchronous
    And all state updates occur on the rising edge of clk
    And start_shifting is 0 immediately after reset is applied

  @reset
  Formal Scenario: Reset forces start_shifting low
    Given reset is asserted as 1
    When one rising edge of clk occurs
    Then start_shifting should be 0

  @reset @precedence
  Formal Scenario: Reset takes precedence over a completing match
    Given the data sequence 1, 1, 0, 1 completes the target sequence on the current cycle
    And reset is asserted as 1 on that same rising edge of clk
    When one rising edge of clk occurs
    Then start_shifting should be 0

  @reset @clear-progress
  Formal Scenario: Reset clears partial match progress
    Given reset is deasserted as 0
    And the data sequence 1, 1, 0 has been applied over three consecutive rising edges of clk
    When reset is asserted as 1 on the next rising edge of clk
    Then start_shifting should be 0
    And the data sequence 1, 1, 0, 1 applied afterward should be required again to assert start_shifting

  @detection @exact-match
  Formal Scenario: Exact sequence 1101 asserts start_shifting
    Given reset is asserted then deasserted before the sequence begins
    When data is driven with the sequence 1, 1, 0, 1 over four consecutive rising edges of clk
    Then start_shifting should be 0 after the first rising edge
    And start_shifting should be 0 after the second rising edge
    And start_shifting should be 0 after the third rising edge
    And start_shifting should be 1 after the fourth rising edge

  @detection @overlap
  Formal Scenario: Overlapping occurrence of 1101 within a longer stream
    Given reset is asserted then deasserted before the sequence begins
    When data is driven with the sequence 1, 1, 1, 0, 1 over five consecutive rising edges of clk
    Then start_shifting should be 0 after each of the first four rising edges
    And start_shifting should be 1 after the fifth rising edge

  @detection @restart-after-mismatch
  Formal Scenario: Mismatched suffix restarts the search before eventual match
    Given reset is asserted then deasserted before the sequence begins
    When data is driven with the sequence 1, 1, 0, 0, 1, 1, 0, 1 over eight consecutive rising edges of clk
    Then start_shifting should be 0 after each of the first seven rising edges
    And start_shifting should be 1 after the eighth rising edge

  @non-match @unbounded
  Formal Scenario: Constant zero stream never asserts start_shifting
    Given reset is asserted then deasserted before the sequence begins
    When data is held at 0 for an unbounded number N of consecutive rising edges of clk, verified via an unbounded/inductive formulation (e.g. k-induction or an unbounded repetition operator) over N
    Then start_shifting should remain 0 for all N rising edges

  @non-match @unbounded
  Formal Scenario: Constant one stream never asserts start_shifting
    Given reset is asserted then deasserted before the sequence begins
    When data is held at 1 for an unbounded number N of consecutive rising edges of clk, verified via an unbounded/inductive formulation (e.g. k-induction or an unbounded repetition operator) over N
    Then start_shifting should remain 0 for all N rising edges

  @sticky
  Formal Scenario: start_shifting is sticky once asserted
    Given start_shifting is 1 at some rising edge of clk
    When any value of data is applied on the next rising edge of clk with reset held at 0
    Then start_shifting should remain 1

  @sticky @invariant @unbounded
  Formal Scenario: start_shifting never deasserts without reset
    Given start_shifting is 1 at some rising edge of clk
    When reset remains 0 for an unbounded number of subsequent rising edges of clk with arbitrary values of data, verified via an unbounded/inductive formulation (e.g. k-induction or an unbounded repetition operator) over that number of edges
    Then start_shifting should remain 1 for all those subsequent rising edges