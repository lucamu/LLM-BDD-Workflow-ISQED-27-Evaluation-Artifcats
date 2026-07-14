Feature: TopModule - Dual 4-Input NAND Gate (7420 Equivalent)

  As a hardware designer
  I want TopModule to replicate the 7400-series 7420 chip
  So that it provides two independent 4-input NAND gates

  Background:
    Given a combinational module named "TopModule"
    And inputs p1a, p1b, p1c, p1d for the first NAND gate
    And inputs p2a, p2b, p2c, p2d for the second NAND gate
    And output p1y representing the result of the first NAND gate
    And output p2y representing the result of the second NAND gate
    And no clock or reset signal exists in this design

  @combinational @nand_gate1 @core_functionality
  Formal Scenario: First NAND gate output is the NAND of its four inputs
    Given p1a is value A1
    And p1b is value B1
    And p1c is value C1
    And p1d is value D1
    When the combinational logic is evaluated
    Then p1y should be equal to NOT (A1 AND B1 AND C1 AND D1)

  @combinational @nand_gate2 @core_functionality
  Formal Scenario: Second NAND gate output is the NAND of its four inputs
    Given p2a is value A2
    And p2b is value B2
    And p2c is value C2
    And p2d is value D2
    When the combinational logic is evaluated
    Then p2y should be equal to NOT (A2 AND B2 AND C2 AND D2)

  @combinational @all_ones @gate1
  Formal Scenario: First NAND gate outputs 0 only when all inputs are 1
    Given p1a is 1
    And p1b is 1
    And p1c is 1
    And p1d is 1
    When the combinational logic is evaluated
    Then p1y should be 0

  @combinational @all_ones @gate2
  Formal Scenario: Second NAND gate outputs 0 only when all inputs are 1
    Given p2a is 1
    And p2b is 1
    And p2c is 1
    And p2d is 1
    When the combinational logic is evaluated
    Then p2y should be 0

  @combinational @any_zero @gate1
  Formal Scenario: First NAND gate outputs 1 when any input is 0
    Given p1a is value A1
    And p1b is value B1
    And p1c is value C1
    And p1d is value D1
    And at least one of A1, B1, C1, D1 is 0
    When the combinational logic is evaluated
    Then p1y should be 1

  @combinational @any_zero @gate2
  Formal Scenario: Second NAND gate outputs 1 when any input is 0
    Given p2a is value A2
    And p2b is value B2
    And p2c is value C2
    And p2d is value D2
    And at least one of A2, B2, C2, D2 is 0
    When the combinational logic is evaluated
    Then p2y should be 1

  @combinational @independence
  Formal Scenario: The two NAND gates operate independently
    Given p1a is value A1
    And p1b is value B1
    And p1c is value C1
    And p1d is value D1
    And p2a is value A2
    And p2b is value B2
    And p2c is value C2
    And p2d is value D2
    When the combinational logic is evaluated
    Then p1y should be equal to NOT (A1 AND B1 AND C1 AND D1)
    And p2y should be equal to NOT (A2 AND B2 AND C2 AND D2)
    And p1y should not depend on A2, B2, C2, or D2
    And p2y should not depend on A1, B1, C1, or D1

  @combinational @commutativity @gate1
  Formal Scenario: First NAND gate output is invariant to input order
    Given p1a is value A1
    And p1b is value B1
    And p1c is value C1
    And p1d is value D1
    When the combinational logic is evaluated with p1a and p1b swapped
    Then p1y should remain equal to NOT (A1 AND B1 AND C1 AND D1)

  @combinational @commutativity @gate2
  Formal Scenario: Second NAND gate output is invariant to input order
    Given p2a is value A2
    And p2b is value B2
    And p2c is value C2
    And p2d is value D2
    When the combinational logic is evaluated with p2c and p2d swapped
    Then p2y should remain equal to NOT (A2 AND B2 AND C2 AND D2)

  @combinational @no_state @gate1
  Formal Scenario: First NAND gate has no hidden state across evaluations
    Given p1a is value A1
    And p1b is value B1
    And p1c is value C1
    And p1d is value D1
    When the combinational logic is evaluated twice with identical inputs
    Then p1y should produce the same result both times

  @combinational @no_state @gate2
  Formal Scenario: Second NAND gate has no hidden state across evaluations
    Given p2a is value A2
    And p2b is value B2
    And p2c is value C2
    And p2d is value D2
    When the combinational logic is evaluated twice with identical inputs
    Then p2y should produce the same result both times