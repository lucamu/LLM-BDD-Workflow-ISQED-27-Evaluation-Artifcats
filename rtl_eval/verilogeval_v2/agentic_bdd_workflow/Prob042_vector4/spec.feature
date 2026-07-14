Feature: 8-bit to 32-bit Sign Extension

  As a hardware designer
  I want to sign-extend an 8-bit input to a 32-bit output
  So that the signed numeric value is preserved when widening the bit width

  Background:
    Given a combinational module TopModule
    And an 8-bit input in
    And a 32-bit output out

  @combinational @sign-extension @lower-bits
  Formal Scenario: Lower 8 bits of output always equal the input
    Given an 8-bit value X on in
    When the module evaluates combinationally
    Then bits [7:0] of out should equal X

  @combinational @sign-extension @positive
  Formal Scenario: Sign extension replicates zero when sign bit is 0
    Given an 8-bit value X on in
    And bit [7] of X is 0
    When the module evaluates combinationally
    Then bits [31:8] of out should equal 24'b000000000000000000000000
    And bits [7:0] of out should equal X

  @combinational @sign-extension @negative
  Formal Scenario: Sign extension replicates one when sign bit is 1
    Given an 8-bit value X on in
    And bit [7] of X is 1
    When the module evaluates combinationally
    Then bits [31:8] of out should equal 24'b111111111111111111111111
    And bits [7:0] of out should equal X

  @combinational @sign-extension @general
  Formal Scenario: Upper 24 bits equal replicated sign bit for any input
    Given an 8-bit value X on in
    When the module evaluates combinationally
    Then each bit of out[31:8] should equal X[7]

  @combinational @sign-extension @signed-value-preservation
  Formal Scenario: Signed integer value is preserved after sign extension
    Given an 8-bit value X on in
    When the module evaluates combinationally
    Then the signed interpretation of out should equal the signed interpretation of X

  @combinational @sign-extension @equivalence
  Formal Scenario: Output equals concatenation of replicated sign bit and input
    Given an 8-bit value X on in
    When the module evaluates combinationally
    Then out should equal the concatenation of 24 copies of X[7] followed by X