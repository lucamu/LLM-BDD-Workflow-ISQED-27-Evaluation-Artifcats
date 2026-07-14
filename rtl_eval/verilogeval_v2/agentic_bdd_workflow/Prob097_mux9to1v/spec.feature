Feature: 16-bit 9-to-1 Multiplexer

  The TopModule is a purely combinational 16-bit wide, 9-to-1 multiplexer
  with a 4-bit select signal. Inputs a through i are each routed to the
  output based on the value of sel. Select values 9 through 15 are unused
  and must force the output to all ones.

  Background:
    Given the design under test is "TopModule"
    And input "a" is a 16-bit value
    And input "b" is a 16-bit value
    And input "c" is a 16-bit value
    And input "d" is a 16-bit value
    And input "e" is a 16-bit value
    And input "f" is a 16-bit value
    And input "g" is a 16-bit value
    And input "h" is a 16-bit value
    And input "i" is a 16-bit value
    And input "sel" is a 4-bit value
    And output "out" is a 16-bit value
    And this is a combinational design with no clock or reset

  @mux @select0
  Formal Scenario: Select input a when sel is 0
    Given sel equals 4'b0000
    And a is any 16-bit value A
    When the output is evaluated
    Then out should equal A

  @mux @select1
  Formal Scenario: Select input b when sel is 1
    Given sel equals 4'b0001
    And b is any 16-bit value B
    When the output is evaluated
    Then out should equal B

  @mux @select2
  Formal Scenario: Select input c when sel is 2
    Given sel equals 4'b0010
    And c is any 16-bit value C
    When the output is evaluated
    Then out should equal C

  @mux @select3
  Formal Scenario: Select input d when sel is 3
    Given sel equals 4'b0011
    And d is any 16-bit value D
    When the output is evaluated
    Then out should equal D

  @mux @select4
  Formal Scenario: Select input e when sel is 4
    Given sel equals 4'b0100
    And e is any 16-bit value E
    When the output is evaluated
    Then out should equal E

  @mux @select5
  Formal Scenario: Select input f when sel is 5
    Given sel equals 4'b0101
    And f is any 16-bit value F
    When the output is evaluated
    Then out should equal F

  @mux @select6
  Formal Scenario: Select input g when sel is 6
    Given sel equals 4'b0110
    And g is any 16-bit value G
    When the output is evaluated
    Then out should equal G

  @mux @select7
  Formal Scenario: Select input h when sel is 7
    Given sel equals 4'b0111
    And h is any 16-bit value H
    When the output is evaluated
    Then out should equal H

  @mux @select8
  Formal Scenario: Select input i when sel is 8
    Given sel equals 4'b1000
    And i is any 16-bit value I
    When the output is evaluated
    Then out should equal I

  @mux @unused @default
  Formal Scenario: Output all ones for unused select value 9
    Given sel equals 4'b1001
    When the output is evaluated
    Then out should equal 16'hFFFF

  @mux @unused @default
  Formal Scenario: Output all ones for unused select value 10
    Given sel equals 4'b1010
    When the output is evaluated
    Then out should equal 16'hFFFF

  @mux @unused @default
  Formal Scenario: Output all ones for unused select value 11
    Given sel equals 4'b1011
    When the output is evaluated
    Then out should equal 16'hFFFF

  @mux @unused @default
  Formal Scenario: Output all ones for unused select value 12
    Given sel equals 4'b1100
    When the output is evaluated
    Then out should equal 16'hFFFF

  @mux @unused @default
  Formal Scenario: Output all ones for unused select value 13
    Given sel equals 4'b1101
    When the output is evaluated
    Then out should equal 16'hFFFF

  @mux @unused @default
  Formal Scenario: Output all ones for unused select value 14
    Given sel equals 4'b1110
    When the output is evaluated
    Then out should equal 16'hFFFF

  @mux @unused @default
  Formal Scenario: Output all ones for unused select value 15
    Given sel equals 4'b1111
    When the output is evaluated
    Then out should equal 16'hFFFF

  @mux @combinational @no_state
  Formal Scenario: Output depends only on current inputs with no internal state
    Given sel is any 4-bit value SEL
    And a, b, c, d, e, f, g, h, i are any 16-bit values
    When the same inputs are applied on any two evaluation cycles
    Then out should produce the same result on both cycles for identical SEL and identical selected input

  @mux @exhaustive
  Formal Scenario: Output equals exactly one of the nine inputs or all ones for every possible sel
    Given sel is any 4-bit value SEL
    And a, b, c, d, e, f, g, h, i are any 16-bit values
    When the output is evaluated
    Then out should equal a if SEL equals 4'b0000
    And out should equal b if SEL equals 4'b0001
    And out should equal c if SEL equals 4'b0010
    And out should equal d if SEL equals 4'b0011
    And out should equal e if SEL equals 4'b0100
    And out should equal f if SEL equals 4'b0101
    And out should equal g if SEL equals 4'b0110
    And out should equal h if SEL equals 4'b0111
    And out should equal i if SEL equals 4'b1000
    And out should equal 16'hFFFF if SEL is greater than 4'b1000