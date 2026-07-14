Feature: JK Flip-Flop Synchronous Behavior

  As a hardware designer
  I want to verify that TopModule implements a JK flip-flop
  So that the output Q updates correctly on every positive clock edge according to J and K inputs

  Background:
    Given the design is TopModule with inputs clk, j, k and output Q
    And Qold represents the value of Q immediately before the positive clock edge
    And all signal transitions are evaluated with respect to the rising edge of clk

  @hold_state
  Formal Scenario: Hold state when J=0 and K=0
    Given j is 0
    And k is 0
    And Q is Qold before the positive clock edge
    When a positive edge occurs on clk
    Then Q should equal Qold

  @reset_output
  Formal Scenario: Reset output to 0 when J=0 and K=1
    Given j is 0
    And k is 1
    And Q is Qold before the positive clock edge
    When a positive edge occurs on clk
    Then Q should equal 0

  @set_output
  Formal Scenario: Set output to 1 when J=1 and K=0
    Given j is 1
    And k is 0
    And Q is Qold before the positive clock edge
    When a positive edge occurs on clk
    Then Q should equal 1

  @toggle_output
  Formal Scenario: Toggle output when J=1 and K=1
    Given j is 1
    And k is 1
    And Q is Qold before the positive clock edge
    When a positive edge occurs on clk
    Then Q should equal ~Qold

  @no_change_without_edge
  Formal Scenario: No change to Q without a clock edge
    Given j is any value
    And k is any value
    And Q is Qold before evaluation
    When clk does not transition from 0 to 1
    Then Q should remain equal to Qold

  @general_truth_table
  Formal Scenario: General JK flip-flop behavior for all input combinations
    Given j is any value
    And k is any value
    And Q is Qold before the positive clock edge
    When a positive edge occurs on clk
    Then Q should equal (j & ~k) | (~j & ~k & Qold) | (j & k & ~Qold)