Feature: Shift Enable FSM Controller

  This FSM controls a shift register by asserting shift_ena for exactly
  4 clock cycles immediately after synchronous reset, then holding
  shift_ena at 0 until the next reset event.

  Background:
    Given a clock "clk" with rising edge triggered sequential logic
    And a synchronous active-high reset "reset"
    And an output "shift_ena"

  @reset @synchronous
  Formal Scenario: Reset synchronously initializes the shift enable sequence
    Given reset is asserted at the current clock edge
    When the clock transitions on the positive edge
    Then shift_ena should be 1 on the next clock cycle

  @sequence @cycle1
  Formal Scenario: shift_ena is asserted on the first cycle after reset deassertion
    Given reset was asserted on cycle 0 and deasserted on cycle 1
    And reset remains 0 for cycles 1 through 4
    When cycle 1 occurs
    Then shift_ena should be 1

  @sequence @cycle2
  Formal Scenario: shift_ena remains asserted on the second cycle after reset
    Given reset was asserted on cycle 0 and deasserted thereafter
    And reset remains 0 for cycles 1 through 4
    When cycle 2 occurs
    Then shift_ena should be 1

  @sequence @cycle3
  Formal Scenario: shift_ena remains asserted on the third cycle after reset
    Given reset was asserted on cycle 0 and deasserted thereafter
    And reset remains 0 for cycles 1 through 4
    When cycle 3 occurs
    Then shift_ena should be 1

  @sequence @cycle4
  Formal Scenario: shift_ena remains asserted on the fourth cycle after reset
    Given reset was asserted on cycle 0 and deasserted thereafter
    And reset remains 0 for cycles 1 through 4
    When cycle 4 occurs
    Then shift_ena should be 1

  @sequence @deassert
  Formal Scenario: shift_ena deasserts on the fifth cycle after reset
    Given reset was asserted on cycle 0 and deasserted thereafter
    And reset remains 0 for cycles 1 through 5
    When cycle 5 occurs
    Then shift_ena should be 0

  @persistence
  Formal Scenario: shift_ena stays 0 indefinitely after the four-cycle window until next reset
    Given reset was asserted at some past cycle and deasserted thereafter
    And at least 4 clock cycles have elapsed since that reset with reset held at 0 throughout
    And no reset has occurred since
    When an arbitrary number of additional cycles N elapse with reset held at 0
    Then shift_ena should be 0 for all of those N cycles

  @reset @reinitialization
  Formal Scenario: A new reset restarts the 4-cycle shift_ena sequence regardless of prior state
    Given shift_ena is in an arbitrary state, either 0 or 1
    And reset is asserted at the current clock edge
    When the clock transitions on the positive edge
    Then shift_ena should be 1 on the next clock cycle
    And the shift_ena sequence should restart counting from that cycle

  @coverage @exactly_four
  Formal Scenario: shift_ena is asserted for exactly 4 cycles between resets
    Given reset was asserted on cycle 0 and deasserted thereafter
    And reset remains 0 for cycles 1 through 5
    When the value of shift_ena is observed for cycles 1 through 5
    Then shift_ena should equal 1 for cycles 1, 2, 3 and 4
    And shift_ena should equal 0 for cycle 5