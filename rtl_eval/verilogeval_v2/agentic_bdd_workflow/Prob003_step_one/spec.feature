Feature: TopModule Constant Output Driver

  As a hardware designer
  I want TopModule to always drive a constant logic high value
  So that downstream logic can rely on a fixed high signal source

  Background:
    Given a combinational module TopModule
    And the module has no clock or reset signals
    And the output signal "one"

  @formal @constant_output
  Formal Scenario: Output one is always logic high
    Given the module TopModule is instantiated
    When the module is evaluated in any state
    Then the output "one" should be 1

  @formal @constant_output @invariant
  Formal Scenario: Output one never deasserts
    Given the module TopModule is instantiated
    When the module is evaluated for any number of evaluation cycles
    Then the output "one" should remain 1 at every cycle

  @formal @constant_output @independence
  Formal Scenario: Output one is independent of any input conditions
    Given the module TopModule is instantiated
    And there are no input signals other than the fixed constant driver
    When the module is evaluated under any possible internal state
    Then the output "one" should be 1
    And the output "one" should not depend on any external stimulus