Feature: Cellphone Ringer and Vibration Motor Control
  Combinational circuit that controls a cellphone's ringer and vibration
  motor based on an incoming ring signal and the vibrate mode setting.
  When ringing, exactly one of ringer or motor must be asserted, chosen
  by the vibrate_mode setting.

  Background:
    Given a combinational module TopModule
    And inputs ring and vibrate_mode
    And outputs ringer and motor

  @no-ring
  Formal Scenario: No incoming ring keeps both outputs off
    Given ring is 0
    And vibrate_mode is any valid value
    When the circuit evaluates its outputs
    Then ringer should be 0
    And motor should be 0

  @ring-vibrate
  Formal Scenario: Incoming ring in vibrate mode activates only the motor
    Given ring is 1
    And vibrate_mode is 1
    When the circuit evaluates its outputs
    Then motor should be 1
    And ringer should be 0

  @ring-normal
  Formal Scenario: Incoming ring in normal mode activates only the ringer
    Given ring is 1
    And vibrate_mode is 0
    When the circuit evaluates its outputs
    Then ringer should be 1
    And motor should be 0

  @mutual-exclusion
  Formal Scenario: Ringer and motor are never both active simultaneously
    Given ring is any valid value
    And vibrate_mode is any valid value
    When the circuit evaluates its outputs
    Then the expression (ringer AND motor) should be 0

  @functional-equivalence-ringer
  Formal Scenario: Ringer output equals ring AND NOT vibrate_mode
    Given ring is any valid value
    And vibrate_mode is any valid value
    When the circuit evaluates its outputs
    Then ringer should equal (ring AND (NOT vibrate_mode))

  @functional-equivalence-motor
  Formal Scenario: Motor output equals ring AND vibrate_mode
    Given ring is any valid value
    And vibrate_mode is any valid value
    When the circuit evaluates its outputs
    Then motor should equal (ring AND vibrate_mode)

  @no-spurious-activation
  Formal Scenario: No output is active unless ring is asserted
    Given ring is 0
    And vibrate_mode is any valid value
    When the circuit evaluates its outputs
    Then the expression (ringer OR motor) should be 0

  @exactly-one-when-ringing
  Formal Scenario: Exactly one output is active whenever ringing occurs
    Given ring is 1
    And vibrate_mode is any valid value
    When the circuit evaluates its outputs
    Then the expression (ringer XOR motor) should be 1