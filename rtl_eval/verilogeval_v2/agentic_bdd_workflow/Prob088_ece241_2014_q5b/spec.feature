Feature: TopModule - 2's Complementer Mealy FSM (One-Hot Encoding)

  The TopModule implements a Mealy finite-state machine with two states
  (A and B) using one-hot encoding. State A is the reset state. The
  machine computes bitwise complement logic used in 2's complement
  arithmetic. All sequential logic updates on the positive clock edge;
  areset is asynchronous and active-high.

  Background:
    Given a clock clk
    And an asynchronous active-high reset areset
    And an input x
    And an output z
    And the FSM has states A and B encoded one-hot
    And on areset assertion the state becomes A regardless of clk

  @reset @async
  Formal Scenario: Asynchronous reset forces state A at any time
    Given the design is in any reachable state
    And areset is asserted to 1 at any point in time, independent of clk edges
    When any subsequent time passes with areset held at 1
    Then the state should immediately become A without waiting for a clock edge
    And z should equal 0 while in state A regardless of x, once the state settles

  @reset @deassert
  Formal Scenario: Deasserting reset transitions to normal operation from state A
    Given areset is asserted to 1
    And then areset is deasserted to 0 synchronously with a rising clk edge
    When the next rising edge of clk occurs with areset at 0
    Then the state should be A
    And z should equal x, following the A transition function evaluated with the current x

  @onehot @invariant
  Formal Scenario: One-hot encoding invariant holds at all times
    Given the design has been released from reset
    When any number of rising clk edges occur with any sequence of x values
    Then exactly one state bit, corresponding to A or B, should be 1 at any time
    And all other state bits should be 0 at that same time

  @transition @stateA
  Formal Scenario: State A transition and output as a function of x
    Given the current state is A
    And x is a value, either 0 or 1
    When z is evaluated combinationally in state A
    Then z should equal x
    When a rising edge of clk occurs with areset at 0
    Then the next state should be A if x equals 0
    And the next state should be B if x equals 1

  @transition @stateB
  Formal Scenario: State B transition and output as a function of x
    Given the current state is B
    And x is a value, either 0 or 1
    When z is evaluated combinationally in state B
    Then z should equal the complement of x
    When a rising edge of clk occurs with areset at 0
    Then the next state should be B regardless of x

  @output @mealy
  Formal Scenario: Output z is a Mealy function of current state and current x
    Given the current state is A or B
    And x is a value, either 0 or 1
    When z is evaluated at the current clock cycle before any clk edge
    Then z should equal x if the current state is A
    And z should equal the complement of x if the current state is B

  @stability @stateB
  Formal Scenario: State B is a stable absorbing state
    Given the current state is B
    When any rising edge of clk occurs with areset at 0 and any value of x
    Then the next state should remain B

  @coverage @reachability
  Formal Scenario: Both states A and B are reachable from reset
    Given the design starts in state A immediately after reset deassertion
    When x is held at 1 for one rising clk edge
    Then the state should become B
    When x is held at 0 for one rising clk edge afterward
    Then the state should remain B

  @noXstate @invariant
  Formal Scenario: State never enters an invalid or undefined encoding
    Given the design has been released from reset
    When any number of rising clk edges occur with any sequence of x values
    Then the one-hot state vector should never equal all zeros
    And the one-hot state vector should never have more than one bit set