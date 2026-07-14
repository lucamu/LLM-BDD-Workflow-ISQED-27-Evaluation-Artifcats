Feature: 256-to-1 Multiplexer (TopModule)
  Formal verification of a purely combinational 1-bit wide, 256-to-1
  multiplexer. The 256-bit input vector "in" is indexed by "sel" such
  that out always equals the bit of "in" at index "sel".

  Background:
    Given the design "TopModule" is a purely combinational module
    And an input vector "in" of 256 bits
    And a select signal "sel" of 8 bits
    And an output "out" of 1 bit
    And no clock or reset signals exist in this design
    And the output is a pure function of the current inputs "in" and "sel"

  @core @functional
  Formal Scenario: Output selects the bit of in indexed by sel
    Given an arbitrary input vector "in"
    And an arbitrary select value "sel"
    When the module evaluates combinationally
    Then out should equal bit sel of in
    And out should equal in[sel]

  @boundary
  Formal Scenario: Selecting index zero selects the least significant bit
    Given an arbitrary input vector "in"
    And sel equals 8'd0
    When the module evaluates combinationally
    Then out should equal in[0]

  @boundary
  Formal Scenario: Selecting index 255 selects the most significant bit
    Given an arbitrary input vector "in"
    And sel equals 8'd255
    When the module evaluates combinationally
    Then out should equal in[255]

  @independence
  Formal Scenario: Output is independent of non-selected bits
    Given an arbitrary input vector "in"
    And an arbitrary select value "sel"
    And a second input vector "in2" that agrees with "in" at index sel
    When the module evaluates combinationally with input "in"
    And the module evaluates combinationally with input "in2"
    Then both evaluations should produce the same value of out

  @sensitivity
  Formal Scenario: Output changes only if selected bit or select value changes
    Given an arbitrary input vector "in"
    And an arbitrary select value "sel"
    And a second input vector "in2" and a second select value "sel2"
    When the module evaluates combinationally with input "in" and select "sel"
    And the module evaluates combinationally with input "in2" and select "sel2"
    Then if sel equals sel2 and in[sel] equals in2[sel2] then out should be equal in both evaluations

  @determinism
  Formal Scenario: Output is a deterministic function of inputs
    Given an arbitrary input vector "in"
    And an arbitrary select value "sel"
    When the module evaluates combinationally twice with identical "in" and "sel"
    Then out should be identical in both evaluations

  @exhaustive
  Formal Scenario: Every select value maps to exactly one distinct input bit
    Given an arbitrary select value "sel1" and an arbitrary select value "sel2"
    And an arbitrary input vector "in"
    When the module evaluates combinationally with sel1
    And the module evaluates combinationally with sel2
    Then if sel1 does not equal sel2 then out for sel1 should equal in[sel1]
    And out for sel2 should equal in[sel2]