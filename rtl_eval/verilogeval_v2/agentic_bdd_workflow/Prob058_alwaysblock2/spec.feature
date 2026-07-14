Feature: Three-Way XOR Gate Implementation

  Formal verification of a module that implements an XOR gate using three
  different RTL constructs: a continuous assign statement, a combinational
  always block, and a clocked always block. The clocked version introduces
  a one-cycle delay due to the flip-flop.

  Background:
    Given a signal clk that toggles as the system clock
    And an input a representing the first XOR operand
    And an input b representing the second XOR operand
    And an output out_assign driven by a continuous assign statement
    And an output out_always_comb driven by a combinational always block
    And an output out_always_ff driven by a clocked always block

  @combinational @assign
  Formal Scenario: out_assign is the combinational XOR of a and b
    Given input a is value A
    And input b is value B
    When the design evaluates continuously with no dependency on clk
    Then out_assign should be A ^ B

  @combinational @always_comb
  Formal Scenario: out_always_comb is the combinational XOR of a and b
    Given input a is value A
    And input b is value B
    When the design evaluates continuously with no dependency on clk
    Then out_always_comb should be A ^ B

  @combinational @equivalence
  Formal Scenario: out_assign and out_always_comb are always equal
    Given input a is value A
    And input b is value B
    When the design evaluates continuously
    Then out_assign should equal out_always_comb
    And out_assign should be A ^ B
    And out_always_comb should be A ^ B

  @sequential @always_ff
  Formal Scenario: out_always_ff reflects the XOR of a and b from the previous clock cycle
    Given input a is value A_prev at the current clock cycle
    And input b is value B_prev at the current clock cycle
    When a positive edge of clk occurs
    Then out_always_ff should be A_prev ^ B_prev in the next clock cycle

  @sequential @delay_behavior
  Formal Scenario: out_always_ff does not change combinationally with a and b
    Given input a is value A
    And input b is value B
    And out_always_ff currently holds value Q_prev
    When input a or input b changes value without a positive edge of clk occurring
    Then out_always_ff should remain equal to Q_prev

  @sequential @reset_free_operation
  Formal Scenario: out_always_ff updates only on the rising edge of clk
    Given input a is value A
    And input b is value B
    And out_always_ff currently holds value Q_prev
    When no positive edge of clk occurs
    Then out_always_ff should remain equal to Q_prev
    When a positive edge of clk occurs
    Then out_always_ff should be A ^ B

  @cross_check @functional_equivalence
  Formal Scenario: Combinational outputs match one cycle ahead of the registered output
    Given input a is value A_k at clock cycle k
    And input b is value B_k at clock cycle k
    When a positive edge of clk occurs transitioning from cycle k to cycle k+1
    Then out_always_ff at cycle k+1 should equal the value of out_assign at cycle k
    And out_always_ff at cycle k+1 should equal the value of out_always_comb at cycle k