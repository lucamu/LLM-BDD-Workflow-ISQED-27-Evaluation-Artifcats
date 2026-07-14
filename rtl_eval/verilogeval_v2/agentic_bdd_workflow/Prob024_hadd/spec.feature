Feature: Half Adder Combinational Logic Verification

  As a hardware designer
  I want to verify the TopModule implements correct half adder behavior
  So that sum and cout are always correct combinational functions of inputs a and b

  Background:
    Given the design is combinational with no clock or reset
    And input a is a 1-bit signal
    And input b is a 1-bit signal
    And output sum is a 1-bit signal
    And output cout is a 1-bit signal
    And all outputs are pure combinational functions of current inputs

  @sum_correctness
  Formal Scenario: Sum output equals XOR of inputs
    Given input a is any valid bit value
    And input b is any valid bit value
    When the combinational logic evaluates
    Then sum should be equal to (a XOR b)

  @cout_correctness
  Formal Scenario: Carry-out output equals AND of inputs
    Given input a is any valid bit value
    And input b is any valid bit value
    When the combinational logic evaluates
    Then cout should be equal to (a AND b)

  @no_overflow_beyond_range
  Formal Scenario: Result never exceeds representable range
    Given input a is any valid bit value
    And input b is any valid bit value
    When the combinational logic evaluates
    Then the concatenation of cout and sum should equal (a + b)

  @output_stability
  Formal Scenario: Outputs are pure combinational functions with no memory
    Given input a is any valid bit value
    And input b is any valid bit value
    Then sum should be equal to (a XOR b) with no dependency on past inputs or states
    And cout should be equal to (a AND b) with no dependency on past inputs or states

  @commutativity
  Formal Scenario: Half adder behavior is commutative in inputs
    Given a1 and b1 are independent symbolic inputs to a first evaluation
    And a2 is set equal to b1 and b2 is set equal to a1 as inputs to a second, independent evaluation
    When both evaluations of the combinational logic occur
    Then sum1, the sum output of the first evaluation, should be equal to sum2, the sum output of the second evaluation
    And cout1, the carry-out output of the first evaluation, should be equal to cout2, the carry-out output of the second evaluation