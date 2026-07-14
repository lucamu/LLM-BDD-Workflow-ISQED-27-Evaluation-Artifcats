Feature: Serial 2's Complement Moore State Machine

  As a hardware designer
  I want a serial 2's-complement converter modeled as a Moore machine
  So that each output bit z is the correct 2's-complement bit of the serial input x,
  LSB-first, with asynchronous reset control

  Background:
    Given clk is a free-running clock and all sequential logic is triggered on its positive edge
    And areset is an asynchronous, active-high reset input
    And x is a serial input bit sampled on every positive edge of clk, representing a number starting from its least-significant bit
    And z is a Moore-type output bit representing the corresponding bit of the 2's-complement result
    And conversion begins as soon as areset is deasserted and stops (restarts) whenever areset is asserted
    And the internal machine has exactly two reachable states: FIND_ONE (initial/pass-through) and INVERT (invert mode)

  @reset
  Formal Scenario: Asynchronous reset forces the machine into the initial pass-through state
    Given areset is asserted, independent of the value of clk or x
    When areset is asserted
    Then the internal state should immediately become FIND_ONE regardless of any clk edge
    And this reset takes effect asynchronously, not waiting for a positive clk edge

  @passthrough
  Formal Scenario: Leading zero bits are passed through unchanged
    Given areset has been deasserted for at least one full clock cycle
    And every value of x sampled since the last reset, up to and including the current cycle, has been 0
    When a positive edge of clk samples the current value of x, denoted X
    Then z should equal X in that same cycle

  @first_one
  Formal Scenario: The first 1 bit encountered is passed through unchanged
    Given areset has been deasserted for at least one full clock cycle
    And every value of x sampled since the last reset, strictly before the current cycle, has been 0
    And the current sampled value of x, denoted X, equals 1
    When a positive edge of clk samples X
    Then z should equal 1 in that same cycle
    And the internal state after this edge should become INVERT

  @invert
  Formal Scenario: All bits following the first 1 are inverted
    Given areset has been deasserted for at least one full clock cycle
    And at least one value of x sampled since the last reset, strictly before the current cycle, has equaled 1
    When a positive edge of clk samples the current value of x, denoted X
    Then z should equal the logical complement of X, that is NOT X, in that same cycle

  @sticky_invert
  Formal Scenario: Invert mode persists until the next reset
    Given areset has been deasserted for at least one full clock cycle
    And at least one value of x sampled since the last reset has equaled 1
    When any number of subsequent positive clk edges occur without areset being asserted, sampling arbitrary values of x
    Then z should equal NOT x on every one of those subsequent cycles
    And the internal state should remain INVERT on every one of those subsequent cycles

  @moore_output_function
  Formal Scenario: Output is a pure function of current state and current input
    Given the internal state, denoted S, is either FIND_ONE or INVERT
    And x is sampled as symbolic value X
    When a positive edge of clk occurs
    Then z should equal X whenever S equals FIND_ONE
    And z should equal NOT X whenever S equals INVERT

  @state_transition_function
  Formal Scenario: Next-state behavior depends only on current state and current input
    Given the internal state, denoted S, is either FIND_ONE or INVERT
    And x is sampled as symbolic value X
    When a positive edge of clk occurs and areset is not asserted
    Then the next state should remain FIND_ONE if S equals FIND_ONE and X equals 0
    And the next state should become INVERT if S equals FIND_ONE and X equals 1
    And the next state should remain INVERT if S equals INVERT, regardless of X