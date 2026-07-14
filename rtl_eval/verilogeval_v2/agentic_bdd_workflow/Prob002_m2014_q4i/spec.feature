Feature: TopModule Constant Zero Output

  As a hardware design requirement
  TopModule shall always drive its output "out" to logic 0
  regardless of any internal or external conditions,
  since it has no inputs to depend on.

  Background:
    Given a combinational module TopModule
    And the module has no clock or reset signals
    And the module has no input ports
    And the module has an output "out"

  @constant @combinational @zero-output
  Formal Scenario: Output is always logic 0
    Given the module TopModule is instantiated
    When the module is evaluated in any valid state
    Then the output "out" should be 0

  @constant @combinational @invariant
  Formal Scenario: Output never asserts logic 1
    Given the module TopModule is instantiated
    When the module is evaluated in any valid state
    Then the output "out" should never equal 1

  @constant @combinational @stability
  Formal Scenario: Output remains stable across evaluations
    Given the module TopModule is instantiated
    And the output "out" is observed at an arbitrary evaluation cycle A
    And the output "out" is observed at another arbitrary evaluation cycle B
    When the module is evaluated at cycle A and cycle B
    Then the output "out" at cycle A should equal the output "out" at cycle B
    And both values should equal 0