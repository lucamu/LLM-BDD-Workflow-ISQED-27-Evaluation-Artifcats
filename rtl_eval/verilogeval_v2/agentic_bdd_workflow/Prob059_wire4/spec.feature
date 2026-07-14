Feature: Combinational Wire Connections in TopModule

  This feature specifies that TopModule behaves as a set of direct
  wire connections from inputs to outputs, with no clocking or
  internal state. Each output must equal its corresponding input
  under all possible input combinations.

  Background:
    Given the module TopModule is instantiated
    And input a is a symbolic value representing any valid single-bit input
    And input b is a symbolic value representing any valid single-bit input
    And input c is a symbolic value representing any valid single-bit input
    And the design is purely combinational with no clock or reset

  @wire-connection @combinational
  Formal Scenario: Output w mirrors input a
    Given input a is any valid single-bit value
    When the combinational logic evaluates
    Then output w should equal a

  @wire-connection @combinational
  Formal Scenario: Output x mirrors input b
    Given input b is any valid single-bit value
    When the combinational logic evaluates
    Then output x should equal b

  @wire-connection @combinational
  Formal Scenario: Output y mirrors input b
    Given input b is any valid single-bit value
    When the combinational logic evaluates
    Then output y should equal b

  @wire-connection @combinational
  Formal Scenario: Output z mirrors input c
    Given input c is any valid single-bit value
    When the combinational logic evaluates
    Then output z should equal c

  @wire-connection @combinational @cross-check
  Formal Scenario: Outputs x and y are always equal since both derive from b
    Given input b is any valid single-bit value
    When the combinational logic evaluates
    Then output x should equal output y

  @wire-connection @combinational @independence
  Formal Scenario: Output w is independent of inputs b and c
    Given input a is any valid single-bit value
    And input b is any valid single-bit value
    And input c is any valid single-bit value
    When the combinational logic evaluates
    Then output w should equal a
    And output w should be unaffected by changes to b
    And output w should be unaffected by changes to c

  @wire-connection @combinational @independence
  Formal Scenario: Output z is independent of inputs a and b
    Given input a is any valid single-bit value
    And input b is any valid single-bit value
    And input c is any valid single-bit value
    When the combinational logic evaluates
    Then output z should equal c
    And output z should be unaffected by changes to a
    And output z should be unaffected by changes to b

  @wire-connection @combinational @independence
  Formal Scenario: Outputs x and y are independent of inputs a and c
    Given input a is any valid single-bit value
    And input b is any valid single-bit value
    And input c is any valid single-bit value
    When the combinational logic evaluates
    Then output x should equal b
    And output y should equal b
    And output x should be unaffected by changes to a
    And output x should be unaffected by changes to c
    And output y should be unaffected by changes to a
    And output y should be unaffected by changes to c

  @wire-connection @combinational @full-mapping
  Formal Scenario: All outputs simultaneously reflect their mapped inputs
    Given input a is any valid single-bit value
    And input b is any valid single-bit value
    And input c is any valid single-bit value
    When the combinational logic evaluates
    Then output w should equal a
    And output x should equal b
    And output y should equal b
    And output z should equal c