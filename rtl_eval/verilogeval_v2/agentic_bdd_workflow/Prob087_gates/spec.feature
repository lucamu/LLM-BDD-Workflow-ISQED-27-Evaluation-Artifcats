Feature: TopModule Combinational Logic Gates

  This feature verifies a purely combinational circuit that computes
  seven basic logic gate outputs from two single-bit inputs, a and b.
  There is no clock or reset; every output must be a pure combinational
  function of the current values of a and b.

  Background:
    Given the design is purely combinational with no clock or reset
    And input a is a value X
    And input b is a value Y

  @and_gate
  Formal Scenario: AND gate output matches logical AND of inputs
    Given input a is a value X
    And input b is a value Y
    When the combinational logic evaluates
    Then out_and should equal (X and Y)

  @or_gate
  Formal Scenario: OR gate output matches logical OR of inputs
    Given input a is a value X
    And input b is a value Y
    When the combinational logic evaluates
    Then out_or should equal (X or Y)

  @xor_gate
  Formal Scenario: XOR gate output matches logical XOR of inputs
    Given input a is a value X
    And input b is a value Y
    When the combinational logic evaluates
    Then out_xor should equal (X xor Y)

  @nand_gate
  Formal Scenario: NAND gate output matches logical NAND of inputs
    Given input a is a value X
    And input b is a value Y
    When the combinational logic evaluates
    Then out_nand should equal (not (X and Y))

  @nor_gate
  Formal Scenario: NOR gate output matches logical NOR of inputs
    Given input a is a value X
    And input b is a value Y
    When the combinational logic evaluates
    Then out_nor should equal (not (X or Y))

  @xnor_gate
  Formal Scenario: XNOR gate output matches logical XNOR of inputs
    Given input a is a value X
    And input b is a value Y
    When the combinational logic evaluates
    Then out_xnor should equal (not (X xor Y))

  @anotb_gate
  Formal Scenario: AND-NOT-B gate output matches A and (not B)
    Given input a is a value X
    And input b is a value Y
    When the combinational logic evaluates
    Then out_anotb should equal (X and (not Y))

  @consistency_and_or
  Formal Scenario: AND output is never greater than OR output
    Given input a is a value X
    And input b is a value Y
    When the combinational logic evaluates
    Then out_and should be less than or equal to out_or

  @consistency_nand_and
  Formal Scenario: NAND output is always the complement of AND output
    Given input a is a value X
    And input b is a value Y
    When the combinational logic evaluates
    Then out_nand should equal (not out_and)

  @consistency_nor_or
  Formal Scenario: NOR output is always the complement of OR output
    Given input a is a value X
    And input b is a value Y
    When the combinational logic evaluates
    Then out_nor should equal (not out_or)

  @consistency_xnor_xor
  Formal Scenario: XNOR output is always the complement of XOR output
    Given input a is a value X
    And input b is a value Y
    When the combinational logic evaluates
    Then out_xnor should equal (not out_xor)

  @consistency_anotb_and
  Formal Scenario: AND-NOT-B output matches A and (not B)
    Given input a is a value X
    And input b is a value Y
    When the combinational logic evaluates
    Then out_anotb should equal (X and (not Y))

  @no_combinational_latching
  Formal Scenario: All outputs are pure functions of current inputs with no memory
    Given input a is a value X
    And input b is a value Y
    When the combinational logic evaluates
    Then out_and should equal (X and Y)
    And out_or should equal (X or Y)
    And out_xor should equal (X xor Y)
    And out_nand should equal (not (X and Y))
    And out_nor should equal (not (X or Y))
    And out_xnor should equal (not (X xor Y))
    And out_anotb should equal (X and (not Y))