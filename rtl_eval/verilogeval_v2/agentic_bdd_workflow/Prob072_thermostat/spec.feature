Feature: Heating/Cooling Thermostat Controller

  Formal verification specification for a combinational thermostat controller
  that manages a heater, air conditioner, and fan based on mode and
  temperature sensor inputs.

  Background:
    Given the design is purely combinational with no clock or reset
    And mode is a symbolic 1-bit value representing heating (1) or cooling (0) mode
    And too_cold is a symbolic 1-bit value indicating if it is too cold
    And too_hot is a symbolic 1-bit value indicating if it is too hot
    And fan_on is a symbolic 1-bit value representing a manual fan request
    And heater, aircon, and fan are combinational outputs of mode, too_cold, too_hot, and fan_on

  @heater-logic
  Formal Scenario: Heater turns on only in heating mode when too cold
    Given mode is set to value M
    And too_cold is set to value C
    And too_hot is set to value H
    And fan_on is set to value F
    When the outputs are computed
    Then heater should equal M AND C

  @aircon-logic
  Formal Scenario: Air conditioner turns on only in cooling mode when too hot
    Given mode is set to value M
    And too_cold is set to value C
    And too_hot is set to value H
    And fan_on is set to value F
    When the outputs are computed
    Then aircon should equal (NOT M) AND H

  @fan-logic
  Formal Scenario: Fan turns on when heater, air conditioner, or manual request is active
    Given mode is set to value M
    And too_cold is set to value C
    And too_hot is set to value H
    And fan_on is set to value F
    When the outputs are computed
    Then fan should equal (M AND C) OR ((NOT M) AND H) OR F

  @mutual-exclusion
  Formal Scenario: Heater and air conditioner are never on simultaneously
    Given mode is set to value M
    And too_cold is set to value C
    And too_hot is set to value H
    And fan_on is set to value F
    When the outputs are computed
    Then heater AND aircon should equal 0

  @heating-mode-no-aircon
  Formal Scenario: Air conditioner never activates in heating mode
    Given mode is set to 1
    And too_cold is set to value C
    And too_hot is set to value H
    And fan_on is set to value F
    When the outputs are computed
    Then aircon should equal 0

  @cooling-mode-no-heater
  Formal Scenario: Heater never activates in cooling mode
    Given mode is set to 0
    And too_cold is set to value C
    And too_hot is set to value H
    And fan_on is set to value F
    When the outputs are computed
    Then heater should equal 0

  @heating-mode-too-cold
  Formal Scenario: Heater activates in heating mode when too cold
    Given mode is set to 1
    And too_cold is set to 1
    And too_hot is set to value H
    And fan_on is set to value F
    When the outputs are computed
    Then heater should equal 1
    And aircon should equal 0
    And fan should equal 1

  @cooling-mode-too-hot
  Formal Scenario: Air conditioner activates in cooling mode when too hot
    Given mode is set to 0
    And too_cold is set to value C
    And too_hot is set to 1
    And fan_on is set to value F
    When the outputs are computed
    Then aircon should equal 1
    And heater should equal 0
    And fan should equal 1

  @manual-fan-request
  Formal Scenario: Fan turns on from manual request even when heater and air conditioner are off
    Given mode is set to 1
    And too_cold is set to 0
    And too_hot is set to value H
    And fan_on is set to 1
    When the outputs are computed
    Then heater should equal 0
    And aircon should equal 0
    And fan should equal 1

  @all-off
  Formal Scenario: All outputs off when no conditions are triggered in heating mode
    Given mode is set to 1
    And too_cold is set to 0
    And too_hot is set to value H
    And fan_on is set to 0
    When the outputs are computed
    Then heater should equal 0
    And aircon should equal 0
    And fan should equal 0

  @all-off-cooling
  Formal Scenario: All outputs off when no conditions are triggered in cooling mode
    Given mode is set to 0
    And too_cold is set to value C
    And too_hot is set to 0
    And fan_on is set to 0
    When the outputs are computed
    Then heater should equal 0
    And aircon should equal 0
    And fan should equal 0

  @fan-implied-by-heater
  Formal Scenario: Fan is always on whenever the heater is on
    Given mode is set to value M
    And too_cold is set to value C
    And too_hot is set to value H
    And fan_on is set to value F
    When the outputs are computed
    Then (heater implies fan) should equal 1

  @fan-implied-by-aircon
  Formal Scenario: Fan is always on whenever the air conditioner is on
    Given mode is set to value M
    And too_cold is set to value C
    And too_hot is set to value H
    And fan_on is set to value F
    When the outputs are computed
    Then (aircon implies fan) should equal 1