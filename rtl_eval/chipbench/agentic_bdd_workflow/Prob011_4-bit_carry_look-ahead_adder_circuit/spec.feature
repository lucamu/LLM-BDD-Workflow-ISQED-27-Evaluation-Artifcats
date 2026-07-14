Feature: 4-bit Carry Look-Ahead Adder (Gate-Level)

  As a hardware designer
  I want to verify a 4-bit carry look-ahead adder built from gate-level primitives
  So that the sum and carry-out outputs correctly implement binary addition using
  generate (G_i = A_i AND B_i), propagate (P_i = A_i XOR B_i), and carry-chain logic

  Background:
    Given a combinational module "TopModule" with inputs "A_in" (4 bits), "B_in" (4 bits), and "C_1" (1 bit)
    And outputs "S" (4 bits) and "CO" (1 bit)
    And the module has no clock or reset signal
    And outputs update immediately and combinationally with any change of "A_in", "B_in", or "C_1"

  @combinational @sum_correctness
  Formal Scenario: Sum output equals full 4-bit addition modulo 16
    Given an arbitrary value "A_in"
    And an arbitrary value "B_in"
    And an arbitrary value "C_1"
    When the combinational logic evaluates
    Then S should equal (A_in + B_in + C_1) modulo 16

  @combinational @carry_correctness
  Formal Scenario: Carry-out equals the overflow bit of the 5-bit sum
    Given an arbitrary value "A_in"
    And an arbitrary value "B_in"
    And an arbitrary value "C_1"
    When the combinational logic evaluates
    Then CO should equal bit 4 of (A_in + B_in + C_1)

  @combinational @full_result_equivalence
  Formal Scenario: Concatenated carry-out and sum equal the full 5-bit addition result
    Given an arbitrary value "A_in"
    And an arbitrary value "B_in"
    And an arbitrary value "C_1"
    When the combinational logic evaluates
    Then the concatenation of CO and S should equal (A_in + B_in + C_1)

  @gate_level @generate_propagate
  Formal Scenario: Per-bit generate and propagate signals match gate definitions
    Given an arbitrary value "A_in"
    And an arbitrary value "B_in"
    When the combinational logic evaluates
    Then for each bit index i from 0 to 3, the generate signal G_i should equal A_in[i] AND B_in[i]
    And for each bit index i from 0 to 3, the propagate signal P_i should equal A_in[i] XOR B_in[i]

  @gate_level @carry_chain
  Formal Scenario: Internal carry chain follows look-ahead recurrence
    Given an arbitrary value "A_in"
    And an arbitrary value "B_in"
    And an arbitrary value "C_1"
    When the combinational logic evaluates
    Then the internal carry C_0 should equal G_0 OR (P_0 AND C_1)
    And the internal carry C_1_next should equal G_1 OR (P_1 AND C_0)
    And the internal carry C_2 should equal G_2 OR (P_2 AND C_1_next)
    And CO should equal G_3 OR (P_3 AND C_2)

  @gate_level @sum_bit_definition
  Formal Scenario: Each sum bit equals propagate XOR incoming carry
    Given an arbitrary value "A_in"
    And an arbitrary value "B_in"
    And an arbitrary value "C_1"
    When the combinational logic evaluates
    Then S[0] should equal P_0 XOR C_1
    And S[1] should equal P_1 XOR C_0
    And S[2] should equal P_2 XOR C_1_next
    And S[3] should equal P_3 XOR C_2

  @edge_case @zero_operands
  Formal Scenario: Zero operands with zero carry-in produce zero sum and no carry-out
    Given A_in equals 4'b0000
    And B_in equals 4'b0000
    And C_1 equals 1'b0
    When the combinational logic evaluates
    Then S should equal 4'b0000
    And CO should equal 1'b0

  @edge_case @all_ones_with_carry
  Formal Scenario: Maximum operands with carry-in produce maximum sum and carry-out
    Given A_in equals 4'b1111
    And B_in equals 4'b1111
    And C_1 equals 1'b1
    When the combinational logic evaluates
    Then S should equal 4'b1111
    And CO should equal 1'b1

  @edge_case @carry_in_increment
  Formal Scenario: Incrementing carry-in by one increases the addition result by one
    Given an arbitrary value "A_in"
    And an arbitrary value "B_in"
    And C_1 equals 1'b0
    When the combinational logic evaluates with C_1 equal to 1'b0
    And the combinational logic evaluates with C_1 equal to 1'b1
    Then the concatenation of CO and S with C_1 equal to 1'b1 should equal the concatenation of CO and S with C_1 equal to 1'b0 plus 1

  @commutativity
  Formal Scenario: Addition is commutative in A_in and B_in
    Given an arbitrary value "A_in"
    And an arbitrary value "B_in"
    And an arbitrary value "C_1"
    When the combinational logic evaluates with A_in and B_in
    And the combinational logic evaluates with B_in and A_in swapped
    Then S should be identical in both evaluations
    And CO should be identical in both evaluations

  @combinational @no_state
  Formal Scenario: Outputs depend only on current inputs with no memory
    Given an arbitrary value "A_in"
    And an arbitrary value "B_in"
    And an arbitrary value "C_1"
    When the same input combination is applied at any two distinct evaluation instants
    Then S should be identical at both instants
    And CO should be identical at both instants