Feature: 4-to-1 Multiplexer (4:1 MUX)
  Formal verification of a combinational 4-to-1 multiplexer that selects
  one of four 2-bit data inputs based on a 2-bit select signal, driving
  a wire-type output through a single continuous assign statement.

  Background:
    Given the design is a purely combinational module with no clock and no reset
    And the input "d0" is a 2-bit value
    And the input "d1" is a 2-bit value
    And the input "d2" is a 2-bit value
    And the input "d3" is a 2-bit value
    And the input "sel" is a 2-bit value
    And the output "mux_out" is a 2-bit wire driven by an assign statement

  @combinational @select-d0
  Formal Scenario: Output follows d0 when sel is 00
    Given d0 holds value A
    And d1 holds value B
    And d2 holds value C
    And d3 holds value D
    And sel equals 2'b00
    When the combinational logic evaluates
    Then mux_out should equal A

  @combinational @select-d1
  Formal Scenario: Output follows d1 when sel is 01
    Given d0 holds value A
    And d1 holds value B
    And d2 holds value C
    And d3 holds value D
    And sel equals 2'b01
    When the combinational logic evaluates
    Then mux_out should equal B

  @combinational @select-d2
  Formal Scenario: Output follows d2 when sel is 10
    Given d0 holds value A
    And d1 holds value B
    And d2 holds value C
    And d3 holds value D
    And sel equals 2'b10
    When the combinational logic evaluates
    Then mux_out should equal C

  @combinational @select-d3
  Formal Scenario: Output follows d3 when sel is 11
    Given d0 holds value A
    And d1 holds value B
    And d2 holds value C
    And d3 holds value D
    And sel equals 2'b11
    When the combinational logic evaluates
    Then mux_out should equal D

  @combinational @general-selection
  Formal Scenario: Output equals the data input indexed by sel for any selection value
    Given d0 holds value A
    And d1 holds value B
    And d2 holds value C
    And d3 holds value D
    And sel holds any valid 2-bit value S
    When the combinational logic evaluates
    Then mux_out should equal A if S equals 2'b00
    And mux_out should equal B if S equals 2'b01
    And mux_out should equal C if S equals 2'b10
    And mux_out should equal D if S equals 2'b11

  @combinational @no-latch @sensitivity
  Formal Scenario: Output is purely combinational and reacts to any input change
    Given d0 holds value A
    And d1 holds value B
    And d2 holds value C
    And d3 holds value D
    And sel holds any valid 2-bit value S
    When any of d0, d1, d2, d3, or sel changes value
    Then mux_out should update immediately without any stored state
    And mux_out should equal the data input selected by the current value of sel

  @combinational @independence
  Formal Scenario: Unselected data inputs do not affect the output
    Given d0 holds value A
    And d1 holds value B
    And d2 holds value C
    And d3 holds value D
    And sel equals 2'b00
    When any of d1, d2, or d3 changes to a different value while d0 remains A
    Then mux_out should remain equal to A