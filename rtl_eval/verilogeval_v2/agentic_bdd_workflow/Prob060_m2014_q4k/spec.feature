Feature: 4-Stage Shift Register with Synchronous Active-Low Reset

  As a hardware designer
  I want a 4-flop shift register with synchronous active-low reset
  So that data on 'in' propagates to 'out' after exactly four clock cycles

  Background:
    Given a design "TopModule" with input clk, input resetn, input in, output out
    And all sequential logic updates on the rising edge of clk
    And resetn is an active-low synchronous reset

  @reset
  Formal Scenario: Synchronous reset forces output to zero
    Given resetn is 0
    And in is any symbolic value X
    When a rising edge of clk occurs
    Then out should be 0

  @reset
  Formal Scenario: Reset held for multiple cycles keeps output at zero
    Given resetn is 0 for two consecutive rising edges of clk
    And in is any symbolic value X on each cycle
    When each rising edge of clk occurs
    Then out should be 0 after each rising edge

  @reset
  Formal Scenario: Reset overrides any previously shifted data
    Given resetn is 1 for some number of prior cycles
    And in holds arbitrary symbolic values during those cycles
    And resetn transitions to 0
    When a rising edge of clk occurs with resetn equal to 0
    Then out should be 0 regardless of the previously shifted values

  @shift
  Formal Scenario: A single symbolic value propagates through four flops
    Given resetn is 1 for four consecutive rising edges of clk
    And in holds a constant symbolic value D during those four cycles
    When four rising edges of clk occur
    Then out should equal D after the fourth rising edge

  @shift
  Formal Scenario: Output reflects the input value from four cycles earlier
    Given resetn is 1 throughout four consecutive rising edges of clk
    And in is assigned symbolic values D0 on cycle 1, D1 on cycle 2, D2 on cycle 3, and D3 on cycle 4
    When four rising edges of clk occur applying D0, D1, D2, D3 respectively
    Then out should equal D0 after the fourth rising edge

  @shift
  Formal Scenario: Intermediate values do not appear early at the output
    Given resetn is 0 immediately before the first rising edge, so internal flops F1, F2, F3, and F4 all equal 0
    And resetn is 1 for four consecutive rising edges of clk
    And in is assigned symbolic values D0, D1, D2, and D3 on cycles 1 through 4 respectively
    When 1 rising edge of clk has occurred
    Then out should equal 0
    When 2 rising edges of clk have occurred
    Then out should equal 0
    When 3 rising edges of clk have occurred
    Then out should equal 0
    When 4 rising edges of clk have occurred
    Then out should equal D0

  @stability
  Formal Scenario: Holding a constant input keeps output stable after propagation
    Given resetn is 1 throughout
    And in holds a constant symbolic value D for four or more consecutive cycles
    When a rising edge of clk occurs on or after the fourth cycle
    Then out should equal D
    And out should remain equal to D on every subsequent rising edge while in stays D

  @reset_release
  Formal Scenario: Deasserting reset allows shifting to resume correctly
    Given resetn is 0 for one rising edge of clk
    And in is any symbolic value X during reset
    And resetn becomes 1 for the next four consecutive rising edges of clk
    And in holds a constant symbolic value D during those four cycles
    When the reset-then-four-shift sequence completes
    Then out should equal 0 immediately after the reset edge
    And out should equal D after four subsequent rising edges with resetn equal to 1