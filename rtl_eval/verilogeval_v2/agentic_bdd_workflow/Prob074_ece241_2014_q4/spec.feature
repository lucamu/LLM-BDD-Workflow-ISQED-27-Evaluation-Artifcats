Feature: Three-Flip-Flop FSM with XOR/AND/OR Feedback Gates and NOR Output

  As a hardware designer
  I want to formally verify TopModule's finite state machine behavior
  So that the flip-flop next-state logic and NOR output are provably correct

  Background:
    Given input clk
    And input x
    And output z
    And the design contains three internal D flip-flops: the XOR flip-flop with output Q_xor, the AND flip-flop with output Q_and, and the OR flip-flop with output Q_or
    And the XOR flip-flop's D input is x XOR Q_xor
    And the AND flip-flop's D input is x AND (NOT Q_and)
    And the OR flip-flop's D input is x OR (NOT Q_or)
    And z is the NOR of Q_xor, Q_and, and Q_or
    And all flip-flops are triggered on the positive edge of clk
    And all flip-flops are reset to 0 before the machine begins

  @reset @initial_state
  Formal Scenario: All flip-flops initialize to zero after reset
    Given the design is in its initial reset state
    Then Q_xor should be 0
    And Q_and should be 0
    And Q_or should be 0
    And z should be 1

  @next_state @xor_gate
  Formal Scenario: XOR flip-flop next state is a function of x and its own output
    Given the current XOR flip-flop output is Q_xor
    And input x holds value x
    When a rising edge of clk occurs
    Then the next value of Q_xor should equal x XOR Q_xor

  @next_state @and_gate
  Formal Scenario: AND flip-flop next state is a function of x and its complemented output
    Given the current AND flip-flop output is Q_and
    And input x holds value x
    When a rising edge of clk occurs
    Then the next value of Q_and should equal x AND (NOT Q_and)

  @next_state @or_gate
  Formal Scenario: OR flip-flop next state is a function of x and its complemented output
    Given the current OR flip-flop output is Q_or
    And input x holds value x
    When a rising edge of clk occurs
    Then the next value of Q_or should equal x OR (NOT Q_or)

  @output_logic @nor_gate
  Formal Scenario: Output z is the NOR of all three flip-flop outputs
    Given the current flip-flop outputs are Q_xor, Q_and, and Q_or
    Then z should equal NOT (Q_xor OR Q_and OR Q_or)

  @combined_transition
  Formal Scenario: Full state transition and output computation for one clock cycle
    Given the current flip-flop outputs are Q_xor, Q_and, and Q_or
    And input x holds value x
    When a rising edge of clk occurs
    Then the next XOR flip-flop output should equal x XOR Q_xor
    And the next AND flip-flop output should equal x AND (NOT Q_and)
    And the next OR flip-flop output should equal x OR (NOT Q_or)
    And the new z should equal NOT ((x XOR Q_xor) OR (x AND (NOT Q_and)) OR (x OR (NOT Q_or)))

  @stability @no_uninitialized_transitions
  Formal Scenario: z is always the complement of the disjunction of flip-flop states
    Given the current flip-flop outputs are Q_xor, Q_and, and Q_or
    Then z should be 1 if and only if Q_xor equals 0 and Q_and equals 0 and Q_or equals 0
    And z should be 0 if Q_xor equals 1 or Q_and equals 1 or Q_or equals 1