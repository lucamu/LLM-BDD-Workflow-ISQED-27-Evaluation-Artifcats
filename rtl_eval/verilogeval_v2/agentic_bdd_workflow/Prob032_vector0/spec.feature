Feature: Vector Passthrough and Bit Splitting
  Combinational module that outputs a 3-bit input vector unchanged
  and also exposes each individual bit as a separate 1-bit output.

  Background:
    Given a combinational module TopModule
    And an input vec of width 3 bits
    And an output outv of width 3 bits
    And an output o2
    And an output o1
    And an output o0
    And no clock or reset signals are present

  @combinational @passthrough
  Formal Scenario: Output vector equals input vector
    Given vec is any 3-bit value V
    When the module evaluates its outputs
    Then outv should equal V

  @combinational @bitsplit
  Formal Scenario: Bit o0 reflects bit 0 of input vector
    Given vec is any 3-bit value V
    When the module evaluates its outputs
    Then o0 should equal V bit 0

  @combinational @bitsplit
  Formal Scenario: Bit o1 reflects bit 1 of input vector
    Given vec is any 3-bit value V
    When the module evaluates its outputs
    Then o1 should equal V bit 1

  @combinational @bitsplit
  Formal Scenario: Bit o2 reflects bit 2 of input vector
    Given vec is any 3-bit value V
    When the module evaluates its outputs
    Then o2 should equal V bit 2

  @combinational @consistency
  Formal Scenario: Concatenation of split bits equals output vector
    Given vec is any 3-bit value V
    When the module evaluates its outputs
    Then outv should equal the concatenation of o2, o1, and o0

  @combinational @consistency
  Formal Scenario: Concatenation of split bits equals input vector
    Given vec is any 3-bit value V
    When the module evaluates its outputs
    Then the concatenation of o2, o1, and o0 should equal V