Feature: 8-bit D Flip-Flop Register (TopModule)

  As a hardware designer
  I want an 8-bit register built from 8 D flip-flops
  So that the 8-bit output q reflects the 8-bit input d delayed by one clock cycle

  Background:
    Given the module TopModule
    And input clk
    And input [7:0] d
    And output [7:0] q
    And all 8 D flip-flops are triggered on the positive edge of clk

  @basic @formal
  Formal Scenario: Output follows input after one clock edge
    Given the input d holds value D
    When a positive edge occurs on clk
    Then the output q should equal D

  @stability @formal
  Formal Scenario: Output remains stable when input does not change
    Given the output q holds value Q
    And the input d holds value Q
    When a positive edge occurs on clk
    Then the output q should remain equal to Q

  @bitwise_independence @formal
  Formal Scenario: Each output bit depends only on the corresponding input bit
    Given the input d holds value D
    When a positive edge occurs on clk
    Then bit i of output q should equal bit i of D for all i in range 0 to 7

  @no_combinational_passthrough @formal
  Formal Scenario: Output does not change combinationally with input
    Given the output q holds value Q
    And the input d changes to a new value D_NEW
    And no clock edge occurs
    Then the output q should remain equal to Q

  @sequential_update @formal
  Formal Scenario: Output updates correctly across two consecutive clock cycles
    Given the input d holds value D1
    When a positive edge occurs on clk
    Then the output q should equal D1
    Given the input d holds value D2
    When a positive edge occurs on clk
    Then the output q should equal D2

  @negedge_no_update @formal
  Formal Scenario: Output does not update on negative clock edge
    Given the output q holds value Q
    And the input d holds value D_NEW
    When a negative edge occurs on clk
    Then the output q should remain equal to Q

  @width_consistency @formal
  Formal Scenario: Output width matches input width
    Given the input d is an 8-bit value D
    When a positive edge occurs on clk
    Then the output q should be an 8-bit value equal to D