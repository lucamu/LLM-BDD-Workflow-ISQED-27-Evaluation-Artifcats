Feature: Full Adder Combinational Logic Verification

  As a hardware designer
  I want the TopModule to correctly compute sum and carry-out
  So that it behaves as a formally verified full adder for all input combinations

  Background:
    Given the TopModule is a combinational circuit with no clock or reset
    And input a is a single bit
    And input b is a single bit
    And input cin is a single bit
    And output cout is a single bit
    And output sum is a single bit
    And all outputs are purely combinational functions of a, b, and cin

  @core @sum
  Formal Scenario: Sum output equals XOR of all three inputs
    Given a is any valid bit value A
    And b is any valid bit value B
    And cin is any valid bit value CIN
    When the combinational logic evaluates
    Then sum should equal A ^ B ^ CIN

  @core @carry
  Formal Scenario: Carry-out output equals majority function of all three inputs
    Given a is any valid bit value A
    And b is any valid bit value B
    And cin is any valid bit value CIN
    When the combinational logic evaluates
    Then cout should equal (A & B) | (A & CIN) | (B & CIN)

  @arithmetic @consistency
  Formal Scenario: Sum and carry together represent correct 2-bit arithmetic sum
    Given a is any valid bit value A
    And b is any valid bit value B
    And cin is any valid bit value CIN
    When the combinational logic evaluates
    Then the concatenation of cout and sum should equal A + B + CIN

  @edge @all_zeros
  Formal Scenario: All zero inputs produce zero sum and zero carry
    Given a is 1'b0
    And b is 1'b0
    And cin is 1'b0
    When the combinational logic evaluates
    Then sum should be 1'b0
    And cout should be 1'b0

  @edge @all_ones
  Formal Scenario: All one inputs produce sum one and carry one
    Given a is 1'b1
    And b is 1'b1
    And cin is 1'b1
    When the combinational logic evaluates
    Then sum should be 1'b1
    And cout should be 1'b1

  @symmetry @commutative_ab
  Formal Scenario: Swapping a and b produces identical sum and cout
    Given a is any valid bit value A
    And b is any valid bit value B
    And cin is any valid bit value CIN
    When the combinational logic evaluates with a=A, b=B, cin=CIN producing sum1 and cout1
    And the combinational logic evaluates with a=B, b=A, cin=CIN producing sum2 and cout2
    Then sum1 should equal sum2
    And cout1 should equal cout2

  @symmetry @commutative_cin
  Formal Scenario: Swapping cin with a produces identical sum and cout
    Given a is any valid bit value A
    And b is any valid bit value B
    And cin is any valid bit value CIN
    When the combinational logic evaluates with a=A, b=B, cin=CIN producing sum1 and cout1
    And the combinational logic evaluates with a=CIN, b=B, cin=A producing sum2 and cout2
    Then sum1 should equal sum2
    And cout1 should equal cout2

  @no_x_propagation
  Formal Scenario: Outputs are always deterministic and defined for valid inputs
    Given a is any valid bit value A
    And b is any valid bit value B
    And cin is any valid bit value CIN
    When the combinational logic evaluates
    Then sum should not be unknown or high-impedance
    And cout should not be unknown or high-impedance

  @combinational_purity
  Formal Scenario: Outputs depend only on current inputs with no internal state
    Given a is any valid bit value A
    And b is any valid bit value B
    And cin is any valid bit value CIN
    When the combinational logic evaluates twice with identical inputs a=A, b=B, cin=CIN
    Then sum should be identical on both evaluations
    And cout should be identical on both evaluations