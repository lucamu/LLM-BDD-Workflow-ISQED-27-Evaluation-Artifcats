Feature: Rule 110 Cellular Automaton (TopModule)

  As a hardware designer
  I want the TopModule to implement Rule 110 cellular automaton semantics
  So that q[511:0] evolves correctly each clock cycle, with data loaded synchronously and virtual boundary cells treated as zero

  Background:
    Given a signal clk
    And a signal load
    And a signal data representing 512 bits
    And a signal q representing 512 bits
    And all sequential updates occur on the rising edge of clk
    And the virtual left neighbor of cell index 511 (q[512]) is always 0
    And the virtual right neighbor of cell index 0 (q[-1]) is always 0

  @load @synchronous
  Formal Scenario: Synchronous load overrides current state with data
    Given load is 1
    And data holds an arbitrary 512-bit value D
    And q holds an arbitrary 512-bit value Q_CURRENT
    When a rising edge of clk occurs
    Then q should equal D after the clock edge

  @load @priority
  Formal Scenario: Load has priority over Rule 110 update
    Given load is 1
    And data holds an arbitrary 512-bit value D
    And q holds an arbitrary 512-bit value Q_CURRENT that differs from D
    When a rising edge of clk occurs
    Then q should equal D after the clock edge
    And q should not equal the Rule 110 next-state computed from Q_CURRENT

  @rule110 @interior
  Formal Scenario: Rule 110 update for an interior cell
    Given load is 0
    And q holds an arbitrary 512-bit value Q_CURRENT
    And an interior cell index I such that I is greater than 0 and I is less than 511
    And LEFT is Q_CURRENT[I+1]
    And CENTER is Q_CURRENT[I]
    And RIGHT is Q_CURRENT[I-1]
    When a rising edge of clk occurs
    Then q[I] after the clock edge should equal (CENTER OR RIGHT) AND NOT (LEFT AND CENTER AND RIGHT)

  @rule110 @boundary @left
  Formal Scenario: Rule 110 update for the leftmost cell (index 511) with virtual left neighbor zero
    Given load is 0
    And q holds an arbitrary 512-bit value Q_CURRENT
    And CENTER is Q_CURRENT[511]
    And RIGHT is Q_CURRENT[510]
    And the virtual left neighbor for cell 511 is 0
    When a rising edge of clk occurs
    Then q[511] after the clock edge should equal (CENTER OR RIGHT)

  @rule110 @boundary @right
  Formal Scenario: Rule 110 update for the rightmost cell (index 0) with virtual right neighbor zero
    Given load is 0
    And q holds an arbitrary 512-bit value Q_CURRENT
    And LEFT is Q_CURRENT[1]
    And CENTER is Q_CURRENT[0]
    And the virtual right neighbor for cell 0 is 0
    When a rising edge of clk occurs
    Then q[0] after the clock edge should equal CENTER

  @rule110 @table @all_off
  Formal Scenario: Rule 110 truth table case Left=0 Center=0 Right=0 yields 0
    Given load is 0
    And an interior cell index I such that I is greater than 0 and I is less than 511
    And q[I+1] is 0
    And q[I] is 0
    And q[I-1] is 0
    When a rising edge of clk occurs
    Then q[I] after the clock edge should equal 0

  @rule110 @table @all_on
  Formal Scenario: Rule 110 truth table case Left=1 Center=1 Right=1 yields 0
    Given load is 0
    And an interior cell index I such that I is greater than 0 and I is less than 511
    And q[I+1] is 1
    And q[I] is 1
    And q[I-1] is 1
    When a rising edge of clk occurs
    Then q[I] after the clock edge should equal 0

  @rule110 @table @mixed_case
  Formal Scenario: Rule 110 truth table case Left=1 Center=0 Right=1 yields 1
    Given load is 0
    And an interior cell index I such that I is greater than 0 and I is less than 511
    And q[I+1] is 1
    And q[I] is 0
    And q[I-1] is 1
    When a rising edge of clk occurs
    Then q[I] after the clock edge should equal 1

  @invariant @fixed_point
  Formal Scenario: All-zero state is a fixed point under Rule 110 evolution
    Given load is 0
    And every bit of q is 0
    When a rising edge of clk occurs
    Then every bit of q after the clock edge should equal 0

  @invariant @stability_check
  Formal Scenario: Rule 110 next state depends only on the three-cell neighborhood
    Given load is 0
    And q holds an arbitrary 512-bit value Q_CURRENT
    And q' holds an arbitrary 512-bit value Q_ALT
    And an interior cell index I such that I is greater than 0 and I is less than 511
    And Q_CURRENT[I+1] equals Q_ALT[I+1]
    And Q_CURRENT[I] equals Q_ALT[I]
    And Q_CURRENT[I-1] equals Q_ALT[I-1]
    When a rising edge of clk occurs starting from Q_CURRENT to produce NEXT_A
    And a rising edge of clk occurs starting from Q_ALT to produce NEXT_B
    Then NEXT_A[I] should equal NEXT_B[I]