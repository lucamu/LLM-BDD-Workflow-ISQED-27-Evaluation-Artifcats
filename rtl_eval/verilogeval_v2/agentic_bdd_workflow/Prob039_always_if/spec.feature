Feature: 2-to-1 Multiplexer with Dual Implementation
  Verify that TopModule correctly implements a 2-to-1 mux selecting between
  inputs a and b based on the AND condition of sel_b1 and sel_b2, using both
  continuous assignment and procedural if statement implementations.

  Background:
    Given a combinational design with inputs a, b, sel_b1, sel_b2
    And outputs out_assign and out_always

  @assign @select_b
  Formal Scenario: Continuous assignment selects b when both select lines are true
    Given a is value A
    And b is value B
    And sel_b1 is 1
    And sel_b2 is 1
    When the combinational logic evaluates
    Then out_assign should be B

  @assign @select_a_sel_b1_low
  Formal Scenario: Continuous assignment selects a when sel_b1 is false
    Given a is value A
    And b is value B
    And sel_b1 is 0
    And sel_b2 is any value S2
    When the combinational logic evaluates
    Then out_assign should be A

  @assign @select_a_sel_b2_low
  Formal Scenario: Continuous assignment selects a when sel_b2 is false
    Given a is value A
    And b is value B
    And sel_b1 is any value S1
    And sel_b2 is 0
    When the combinational logic evaluates
    Then out_assign should be A

  @assign @general_equivalence
  Formal Scenario: Continuous assignment output equals conditional expression for all inputs
    Given a is value A
    And b is value B
    And sel_b1 is value S1
    And sel_b2 is value S2
    When the combinational logic evaluates
    Then out_assign should be B if S1 equals 1 and S2 equals 1
    And out_assign should be A if S1 equals 0 or S2 equals 0

  @always @select_b
  Formal Scenario: Procedural if selects b when both select lines are true
    Given a is value A
    And b is value B
    And sel_b1 is 1
    And sel_b2 is 1
    When the combinational logic evaluates
    Then out_always should be B

  @always @select_a_sel_b1_low
  Formal Scenario: Procedural if selects a when sel_b1 is false
    Given a is value A
    And b is value B
    And sel_b1 is 0
    And sel_b2 is any value S2
    When the combinational logic evaluates
    Then out_always should be A

  @always @select_a_sel_b2_low
  Formal Scenario: Procedural if selects a when sel_b2 is false
    Given a is value A
    And b is value B
    And sel_b1 is any value S1
    And sel_b2 is 0
    When the combinational logic evaluates
    Then out_always should be A

  @always @general_equivalence
  Formal Scenario: Procedural if output equals conditional expression for all inputs
    Given a is value A
    And b is value B
    And sel_b1 is value S1
    And sel_b2 is value S2
    When the combinational logic evaluates
    Then out_always should be B if S1 equals 1 and S2 equals 1
    And out_always should be A if S1 equals 0 or S2 equals 0

  @equivalence
  Formal Scenario: Both implementations produce identical results for all input combinations
    Given a is value A
    And b is value B
    And sel_b1 is value S1
    And sel_b2 is value S2
    When the combinational logic evaluates
    Then out_assign should equal out_always

  @no_dependency @sel_b1_low
  Formal Scenario: Output is independent of b when sel_b1 is false
    Given a is value A
    And b is any value B
    And sel_b1 is 0
    And sel_b2 is any value S2
    When the combinational logic evaluates
    Then out_assign should be A
    And out_always should be A

  @no_dependency @sel_b2_low
  Formal Scenario: Output is independent of b when sel_b2 is false
    Given a is value A
    And b is any value B
    And sel_b1 is any value S1
    And sel_b2 is 0
    When the combinational logic evaluates
    Then out_assign should be A
    And out_always should be A

  @no_dependency @both_select_high
  Formal Scenario: Output is independent of a when both select lines are true
    Given a is any value A
    And b is value B
    And sel_b1 is 1
    And sel_b2 is 1
    When the combinational logic evaluates
    Then out_assign should be B
    And out_always should be B