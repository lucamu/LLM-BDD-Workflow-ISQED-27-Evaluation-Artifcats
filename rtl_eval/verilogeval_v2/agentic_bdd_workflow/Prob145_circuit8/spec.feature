Feature: Dual-Phase Transparent Latch Pair (TopModule)

  TopModule implements two cascaded level-sensitive (transparent) latches.
  The first latch (output p) is transparent while clock is high and holds
  its value while clock is low. The second latch (output q) is transparent
  while clock is low and holds its value while clock is high. Together they
  behave like a master-slave latch pair, with q capturing the value of p
  at the falling edge of clock.

  Background:
    Given the design is TopModule
    And clock is the clock input
    And a is the data input
    And p is the first-stage latch output
    And q is the second-stage latch output

  @combinational @latch_transparent
  Formal Scenario: p is transparent and follows a while clock is high
    Given clock is 1
    And a is value A
    When one time step elapses
    Then p should equal A

  @sequential @latch_hold
  Formal Scenario: p holds its previous value while clock is low
    Given clock is 0
    And p was previously value P_prev
    And a is value A
    When one time step elapses
    Then p should equal P_prev
    And p should not equal A unless A equals P_prev

  @combinational @latch_transparent
  Formal Scenario: q is transparent and follows p while clock is low
    Given clock is 0
    And p is value P
    When one time step elapses
    Then q should equal P

  @sequential @latch_hold
  Formal Scenario: q holds its previous value while clock is high
    Given clock is 1
    And q was previously value Q_prev
    And p is value P
    When one time step elapses
    Then q should equal Q_prev
    And q should not equal P unless P equals Q_prev

  @sequential @edge_capture
  Formal Scenario: q captures the value of p at the falling edge of clock
    Given clock was previously 1
    And p was previously value P_prev
    And clock transitions to 0
    When one time step elapses
    Then q should equal P_prev

  @sequential @edge_capture
  Formal Scenario: p captures the value of a at the rising edge of clock
    Given clock was previously 0
    And a is value A
    And clock transitions to 1
    When one time step elapses
    Then p should equal A

  @sequential @stability
  Formal Scenario: q remains stable across multiple clock-high periods without a falling edge
    Given clock is 1
    And q was previously value Q_prev
    And clock remains 1 for the next time step
    When one time step elapses
    Then q should equal Q_prev

  @sequential @stability
  Formal Scenario: p remains stable across multiple clock-low periods without a rising edge
    Given clock is 0
    And p was previously value P_prev
    And clock remains 0 for the next time step
    When one time step elapses
    Then p should equal P_prev