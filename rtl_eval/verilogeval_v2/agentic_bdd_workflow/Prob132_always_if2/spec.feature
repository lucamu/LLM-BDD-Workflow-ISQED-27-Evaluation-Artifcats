Feature: Adder-Subtractor Style Combinational Control Logic (Bug-Fixed)

  As a hardware designer
  I want to verify the corrected combinational logic for shut_off_computer and keep_driving
  So that no unintended latches are inferred and outputs are fully defined functions of inputs

  Background:
    Given the design is purely combinational with no clock or reset
    And input "cpu_overheated" is a symbolic boolean value
    And input "arrived" is a symbolic boolean value
    And input "gas_tank_empty" is a symbolic boolean value
    And output "shut_off_computer" is fully determined by "cpu_overheated"
    And output "keep_driving" is fully determined by "arrived" and "gas_tank_empty"

  @combinational @no-latch
  Formal Scenario: shut_off_computer is fully defined for all values of cpu_overheated
    Given cpu_overheated is any symbolic value C
    When the combinational logic evaluates
    Then shut_off_computer should equal C
    And shut_off_computer should never be in an undefined or latched state

  @combinational @functional
  Formal Scenario: shut_off_computer asserts when cpu is overheated
    Given cpu_overheated is 1
    When the combinational logic evaluates
    Then shut_off_computer should be 1

  @combinational @functional
  Formal Scenario: shut_off_computer deasserts when cpu is not overheated
    Given cpu_overheated is 0
    When the combinational logic evaluates
    Then shut_off_computer should be 0

  @combinational @no-latch
  Formal Scenario: keep_driving is fully defined for all values of arrived and gas_tank_empty
    Given arrived is any symbolic value A
    And gas_tank_empty is any symbolic value G
    When the combinational logic evaluates
    Then keep_driving should equal (~A & ~G)
    And keep_driving should never be in an undefined or latched state

  @combinational @functional
  Formal Scenario: keep_driving asserts only when not arrived and gas tank not empty
    Given arrived is 0
    And gas_tank_empty is 0
    When the combinational logic evaluates
    Then keep_driving should be 1

  @combinational @functional
  Formal Scenario: keep_driving deasserts when arrived regardless of gas tank state
    Given arrived is 1
    And gas_tank_empty is any symbolic value G
    When the combinational logic evaluates
    Then keep_driving should be 0

  @combinational @functional
  Formal Scenario: keep_driving deasserts when gas tank is empty and not arrived
    Given arrived is 0
    And gas_tank_empty is 1
    When the combinational logic evaluates
    Then keep_driving should be 0

  @combinational @independence
  Formal Scenario: shut_off_computer is independent of arrived and gas_tank_empty
    Given cpu_overheated is any symbolic value C
    And arrived is any symbolic value A
    And gas_tank_empty is any symbolic value G
    When the combinational logic evaluates
    Then shut_off_computer should equal C
    And changing A or G alone should not change shut_off_computer

  @combinational @independence
  Formal Scenario: keep_driving is independent of cpu_overheated
    Given cpu_overheated is any symbolic value C
    And arrived is any symbolic value A
    And gas_tank_empty is any symbolic value G
    When the combinational logic evaluates
    Then keep_driving should equal (~A & ~G)
    And changing C alone should not change keep_driving