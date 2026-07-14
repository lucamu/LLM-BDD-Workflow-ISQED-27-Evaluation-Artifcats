Feature: Moore State Machine with Two States (OFF/ON) Controlled by J-K Inputs

  Background:
    Given a clock signal clk
    And an active-high asynchronous reset areset
    And an input j
    And an input k
    And an output out
    And the state register is OFF when areset is asserted, regardless of clk

  @reset @async
  Formal Scenario: Asynchronous reset forces state to OFF and out to 0
    Given the design is in any current state
    And areset is asserted to 1 asynchronously, independent of clk edge
    When the asynchronous reset takes effect
    Then out should become 0
    And the internal state should be OFF

  @reset @deassert
  Formal Scenario: After reset deassertion, state remains OFF until clocked
    Given areset is 1 and out is 0
    When areset is deasserted to 0 before any rising edge of clk
    Then out should remain 0
    And the internal state should remain OFF until the next rising edge of clk

  @transition @off_state
  Formal Scenario: OFF state transition on j=0 stays OFF
    Given areset is 0
    And the current state is OFF
    And j is 0
    When a rising edge of clk occurs
    Then the next state should be OFF
    And out should be 0

  @transition @off_state
  Formal Scenario: OFF state transition on j=1 moves to ON
    Given areset is 0
    And the current state is OFF
    And j is 1
    When a rising edge of clk occurs
    Then the next state should be ON
    And out should be 1

  @transition @on_state
  Formal Scenario: ON state transition on k=0 stays ON
    Given areset is 0
    And the current state is ON
    And k is 0
    When a rising edge of clk occurs
    Then the next state should be ON
    And out should be 1

  @transition @on_state
  Formal Scenario: ON state transition on k=1 moves to OFF
    Given areset is 0
    And the current state is ON
    And k is 1
    When a rising edge of clk occurs
    Then the next state should be OFF
    And out should be 0

  @output @moore
  Formal Scenario: Output depends only on current state (Moore property)
    Given areset is 0
    And the current state is S, where S is either OFF or ON
    When no clock edge has yet occurred after entering state S
    Then out should be 0 if S equals OFF
    And out should be 1 if S equals ON
    And out should not depend on the values of j or k in the current cycle

  @invariant @state_encoding
  Formal Scenario: State and output consistency invariant
    Given areset is 0
    And the current state is S, where S is either OFF or ON
    Then out should equal 1 if and only if S equals ON
    And out should equal 0 if and only if S equals OFF

  @coverage @reachability
  Formal Scenario: ON state is reachable from OFF state
    Given areset is 0
    And the current state is OFF
    And j is 1
    When a rising edge of clk occurs
    Then the internal state should become ON
    And this state should be reachable within one clock cycle from reset

  @coverage @reachability
  Formal Scenario: OFF state is reachable from ON state
    Given areset is 0
    And the current state is ON
    And k is 1
    When a rising edge of clk occurs
    Then the internal state should become OFF
    And this state should be reachable within one clock cycle from the ON state