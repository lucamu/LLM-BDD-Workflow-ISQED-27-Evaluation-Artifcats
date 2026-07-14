Feature: Rule 90 One-Dimensional Cellular Automaton

  As a hardware designer
  I want a 512-cell Rule 90 cellular automaton register
  So that the state evolves according to the XOR-of-neighbors rule,
  or loads a new state, on each clock edge

  Background:
    Given a signal clk representing the system clock
    And a signal load representing the load control
    And a 512-bit signal data representing the value to load
    And a 512-bit signal q representing the current cellular automaton state
    And all sequential updates occur on the positive edge of clk
    And the left boundary neighbor of cell q[0] is always 0
    And the right boundary neighbor of cell q[511] is always 0

  @load @reset
  Formal Scenario: Loading the state overrides the current state
    Given load is 1
    And data holds an arbitrary 512-bit value D
    And q holds an arbitrary 512-bit value Q
    When a positive edge of clk occurs
    Then q should equal D after the clock edge

  @evolution @interior
  Formal Scenario: Interior cell evolves as XOR of its two neighbors
    Given load is 0
    And q holds an arbitrary 512-bit value Q
    And index i is an arbitrary integer such that i is greater than 0 and i is less than 511
    When a positive edge of clk occurs
    Then bit i of q after the clock edge should equal (bit (i-1) of Q) XOR (bit (i+1) of Q)

  @evolution @boundary-left
  Formal Scenario: Leftmost cell evolves using a zero left boundary
    Given load is 0
    And q holds an arbitrary 512-bit value Q
    When a positive edge of clk occurs
    Then bit 0 of q after the clock edge should equal 0 XOR (bit 1 of Q)

  @evolution @boundary-right
  Formal Scenario: Rightmost cell evolves using a zero right boundary
    Given load is 0
    And q holds an arbitrary 512-bit value Q
    When a positive edge of clk occurs
    Then bit 511 of q after the clock edge should equal (bit 510 of Q) XOR 0

  @evolution @full-vector
  Formal Scenario: Full 512-bit next state matches Rule 90 for all cells
    Given load is 0
    And q holds an arbitrary 512-bit value Q
    When a positive edge of clk occurs
    Then for every index i from 0 to 511, bit i of q after the clock edge should equal
      (i equals 0 ? 0 : bit (i-1) of Q) XOR (i equals 511 ? 0 : bit (i+1) of Q)

  @load-priority
  Formal Scenario: Load takes priority over evolution in the same cycle
    Given load is 1
    And data holds an arbitrary 512-bit value D
    And q holds an arbitrary 512-bit value Q
    When a positive edge of clk occurs
    Then q after the clock edge should equal D
    And q after the clock edge should not depend on the previous value of Q

  @sequential @two-step
  Formal Scenario: Two consecutive evolution steps compose correctly
    Given load is 0
    And q holds an arbitrary 512-bit value Q0
    When a positive edge of clk occurs
    Then q should equal an intermediate value Q1 where, for every index i from 0 to 511,
      bit i of Q1 equals (i equals 0 ? 0 : bit (i-1) of Q0) XOR (i equals 511 ? 0 : bit (i+1) of Q0)
    When a second positive edge of clk occurs with load equal to 0
    Then q should equal a value Q2 where, for every index i from 0 to 511,
      bit i of Q2 equals (i equals 0 ? 0 : bit (i-1) of Q1) XOR (i equals 511 ? 0 : bit (i+1) of Q1)

  @stability @all-zero
  Formal Scenario: All-zero state remains all zero under evolution
    Given load is 0
    And q equals 512'b0
    When a positive edge of clk occurs
    Then q after the clock edge should equal 512'b0