Feature: TopModule Moore FSM with Asynchronous Reset

  As a hardware designer
  I want TopModule to implement a 2-state Moore machine (states A and B)
  So that out reflects the current state and transitions follow the defined diagram

  Background:
    Given a signal clk representing the system clock
    And a signal areset representing an asynchronous active-high reset
    And a signal in representing the single-bit input
    And a signal out representing the single-bit Moore output
    And state B is encoded by out = 1
    And state A is encoded by out = 0
    And the design asynchronously resets into state B when areset is asserted

  @reset @async
  Formal Scenario: Asynchronous reset forces state B regardless of clock
    Given the current state is any valid state
    And in is any valid value
    When areset is asserted at any time, independent of clk
    Then out should become 1 immediately
    And out should remain 1 as long as areset stays asserted

  @reset @priority
  Formal Scenario: Asynchronous reset overrides next-state logic
    Given the current state is any valid state
    And in is any valid value
    When a rising edge of clk occurs simultaneously with areset asserted
    Then out should be 1 after the edge
    And the next-state value computed from in should be ignored

  @transition @stateB
  Formal Scenario: State B transitions to state A when in is 0
    Given areset is deasserted
    And the current state is B, so out is 1
    And in is 0
    When a rising edge of clk occurs
    Then out should become 0 after the edge, representing state A

  @transition @stateB
  Formal Scenario: State B remains in state B when in is 1
    Given areset is deasserted
    And the current state is B, so out is 1
    And in is 1
    When a rising edge of clk occurs
    Then out should remain 1 after the edge, representing state B

  @transition @stateA
  Formal Scenario: State A transitions to state B when in is 0
    Given areset is deasserted
    And the current state is A, so out is 0
    And in is 0
    When a rising edge of clk occurs
    Then out should become 1 after the edge, representing state B

  @transition @stateA
  Formal Scenario: State A remains in state A when in is 1
    Given areset is deasserted
    And the current state is A, so out is 0
    And in is 1
    When a rising edge of clk occurs
    Then out should remain 0 after the edge, representing state A

  @moore @output
  Formal Scenario: Output depends only on current state, not directly on in
    Given areset is deasserted
    And the current state is any valid state, so out equals the current state encoding
    And in changes to any value between clock edges
    Then out should remain unchanged until the next rising edge of clk

  @reachability @invariant
  Formal Scenario: Output is always a valid state encoding
    Given areset is deasserted
    And the current state is any valid state
    Then out should always equal either 0 or 1, corresponding to state A or state B respectively

  @consistency @next_state
  Formal Scenario: Next-state output equals defined transition function of current state and input
    Given areset is deasserted
    And the current state is represented by out
    And in is any valid value
    When a rising edge of clk occurs
    Then the next value of out should equal ((out AND in) OR (NOT out AND NOT in))