Feature: FSM TopModule - Moore State Machine with 4 States

  As a hardware designer
  I want to formally verify the TopModule FSM
  So that state transitions and outputs match the specification for all reachable states and inputs

  Background:
    Given the module TopModule has input clk
    And the module TopModule has input in
    And the module TopModule has input areset
    And the module TopModule has output out
    And the FSM has four states: A, B, C, D
    And the state register updates only on the positive edge of clk
    And areset is asynchronous and active high

  @reset
  Formal Scenario: Asynchronous reset forces state to A regardless of current state
    Given the FSM is in any current state S
    And in is any value
    When areset is asserted to 1 asynchronously
    Then the next state should immediately become A
    And out should be 0 while in state A

  @reset
  Formal Scenario: After reset deassertion, FSM remains in state A until clock edge with input
    Given areset was asserted and then deasserted to 0
    And the state is A
    And in is any value
    When a positive edge of clk occurs
    Then the next state should be A if in is 0
    And the next state should be B if in is 1

  @state_A
  Formal Scenario: State A transition and output behavior
    Given areset is 0
    And the current state is A
    And in is any value X
    When a positive edge of clk occurs
    Then the next state should be A if X equals 0
    And the next state should be B if X equals 1
    And out should be 0 in state A

  @state_B
  Formal Scenario: State B transition and output behavior
    Given areset is 0
    And the current state is B
    And in is any value X
    When a positive edge of clk occurs
    Then the next state should be C if X equals 0
    And the next state should be B if X equals 1
    And out should be 0 in state B

  @state_C
  Formal Scenario: State C transition and output behavior
    Given areset is 0
    And the current state is C
    And in is any value X
    When a positive edge of clk occurs
    Then the next state should be A if X equals 0
    And the next state should be D if X equals 1
    And out should be 0 in state C

  @state_D
  Formal Scenario: State D transition and output behavior
    Given areset is 0
    And the current state is D
    And in is any value X
    When a positive edge of clk occurs
    Then the next state should be C if X equals 0
    And the next state should be B if X equals 1
    And out should be 1 in state D

  @output_moore
  Formal Scenario: Output depends only on current state, not on input
    Given areset is 0
    And the current state is S
    And in is any value X0
    And in is any different value X1
    When out is sampled for both values of in in the same state S
    Then out should be identical for X0 and X1
    And out should be 1 if and only if S equals D

  @no_unreachable_states
  Formal Scenario: State register only holds one of the four valid encoded states
    Given areset is 0
    And the FSM has been clocked for any number of cycles
    Then the current state should always be one of A, B, C, D

  @liveness_D_reachable
  Formal Scenario: State D is reachable from A via B and C with in=1 sequence
    Given areset is asserted then deasserted
    And the state is A
    When in is 1 on the first clk edge
    Then the next state should be B
    When in is 0 on the second clk edge
    Then the next state should be C
    When in is 1 on the third clk edge
    Then the next state should be D
    And out should be 1 in this resulting state