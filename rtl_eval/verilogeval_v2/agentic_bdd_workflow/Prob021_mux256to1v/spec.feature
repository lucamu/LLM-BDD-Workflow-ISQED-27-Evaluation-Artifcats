Feature: 256-to-1 4-bit Wide Multiplexer

  As a hardware designer
  I want TopModule to select the correct 4-bit slice from a 1024-bit input
  So that out always equals the 4-bit field addressed by sel

  Background:
    Given the design is combinational with no clock or reset
    And the input vector "in" is 1024 bits wide
    And the select signal "sel" is 8 bits wide
    And the output "out" is 4 bits wide

  @core_functionality
  Formal Scenario: Output selects the correct 4-bit slice for any select value
    Given an arbitrary input vector value IN
    And an arbitrary select value SEL
    When the select value is SEL
    Then the output out should equal bits IN[(SEL*4+3):(SEL*4)]

  @boundary_low
  Formal Scenario: Selecting index 0 returns the least significant nibble
    Given an arbitrary input vector value IN
    And the select value sel is 8'd0
    When the module evaluates the output
    Then the output out should equal bits IN[3:0]

  @boundary_high
  Formal Scenario: Selecting index 255 returns the most significant nibble
    Given an arbitrary input vector value IN
    And the select value sel is 8'd255
    When the module evaluates the output
    Then the output out should equal bits IN[1023:1020]

  @specific_index_one
  Formal Scenario: Selecting index 1 returns the second nibble
    Given an arbitrary input vector value IN
    And the select value sel is 8'd1
    When the module evaluates the output
    Then the output out should equal bits IN[7:4]

  @specific_index_two
  Formal Scenario: Selecting index 2 returns the third nibble
    Given an arbitrary input vector value IN
    And the select value sel is 8'd2
    When the module evaluates the output
    Then the output out should equal bits IN[11:8]

  @specific_midpoint
  Formal Scenario: Selecting index 128 returns the middle nibble
    Given an arbitrary input vector value IN
    And the select value sel is 8'd128
    When the module evaluates the output
    Then the output out should equal bits IN[515:512]

  @invariance
  Formal Scenario: Output is independent of bits outside the selected nibble
    Given an arbitrary select value SEL
    And two input vectors IN1 and IN2 that are identical in bits [(SEL*4+3):(SEL*4)]
    When the select value is SEL for both IN1 and IN2
    Then the resulting out for IN1 should equal the resulting out for IN2

  @sensitivity
  Formal Scenario: Changing only the selected nibble changes the output accordingly
    Given an arbitrary input vector value IN
    And an arbitrary select value SEL
    And a modified input vector IN_MOD that differs from IN only in bits [(SEL*4+3):(SEL*4)]
    When the select value is SEL for both IN and IN_MOD
    Then the output out for IN should equal bits IN[(SEL*4+3):(SEL*4)]
    And the output out for IN_MOD should equal bits IN_MOD[(SEL*4+3):(SEL*4)]
    And the output out for IN should not equal the output out for IN_MOD when the selected bits differ

  @determinism
  Formal Scenario: Output is a pure function of in and sel with no hidden state
    Given two identical evaluations with the same input vector IN and same select value SEL
    When the module is evaluated twice under identical conditions
    Then the output out should be identical in both evaluations