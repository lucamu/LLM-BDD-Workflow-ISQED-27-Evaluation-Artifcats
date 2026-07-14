Feature: FSM Output and Next State Logic for TopModule

  This feature formally specifies the combinational next-state and output
  logic of a Moore/Mealy-style FSM whose present state is presented on the
  primary input y[2:0] and whose next state is computed combinationally
  based on y and x. Y0 is defined as bit 0 of the next-state vector, and z
  is the combinational output defined by the present state. The module
  interface includes a clk signal; however, Y0 and z are purely
  combinational functions of x and y and are not sensitive to clk edges
  or clk levels.

  Background:
    Given the module TopModule
    And the module has an input clk that exists on the interface
    And clk is not used in the computation of Y0 or z, since both are purely combinational functions of x and y
    And input x is a symbolic 1-bit value
    And input y is a symbolic 3-bit value representing the present state
    And output Y0 is defined as bit 0 of the next state vector
    And output z is a combinational function of the present state y

  @clk_irrelevance
  Formal Scenario: clk has no effect on combinational outputs Y0 and z
    Given the present state y is symbolic
    And the input x is symbolic
    And clk toggles arbitrarily between 0 and 1
    Then Y0 should remain equal to bit 0 of the next state regardless of clk
    And z should remain equal to the combinational function of y regardless of clk

  @state_000
  Formal Scenario: Next state and output for present state 000
    Given the present state y is 3'b000
    And the input x is symbolic
    Then the next state should be 3'b000 if x equals 0
    And the next state should be 3'b001 if x equals 1
    And Y0 should equal bit 0 of the next state
    And z should equal 0

  @state_001
  Formal Scenario: Next state and output for present state 001
    Given the present state y is 3'b001
    And the input x is symbolic
    Then the next state should be 3'b001 if x equals 0
    And the next state should be 3'b100 if x equals 1
    And Y0 should equal bit 0 of the next state
    And z should equal 0

  @state_010
  Formal Scenario: Next state and output for present state 010
    Given the present state y is 3'b010
    And the input x is symbolic
    Then the next state should be 3'b010 if x equals 0
    And the next state should be 3'b001 if x equals 1
    And Y0 should equal bit 0 of the next state
    And z should equal 0

  @state_011
  Formal Scenario: Next state and output for present state 011
    Given the present state y is 3'b011
    And the input x is symbolic
    Then the next state should be 3'b001 if x equals 0
    And the next state should be 3'b010 if x equals 1
    And Y0 should equal bit 0 of the next state
    And z should equal 1

  @state_100
  Formal Scenario: Next state and output for present state 100
    Given the present state y is 3'b100
    And the input x is symbolic
    Then the next state should be 3'b011 if x equals 0
    And the next state should be 3'b100 if x equals 1
    And Y0 should equal bit 0 of the next state
    And z should equal 1

  @Y0_consistency
  Formal Scenario: Y0 always reflects bit 0 of the computed next state
    Given the present state y is symbolic
    And the input x is symbolic
    Then Y0 should equal bit 0 of the next state for every valid combination of y and x

  @z_only_depends_on_present_state
  Formal Scenario: z depends only on present state, not on x
    Given the present state y is symbolic
    And the input x is symbolic
    Then z should equal 0 if y equals 3'b000
    And z should equal 0 if y equals 3'b001
    And z should equal 0 if y equals 3'b010
    And z should equal 1 if y equals 3'b011
    And z should equal 1 if y equals 3'b100
    And z should be unaffected by the value of x for any fixed y