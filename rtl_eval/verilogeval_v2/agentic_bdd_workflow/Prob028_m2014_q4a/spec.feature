Feature: D Latch Combinational Behavior
  Verify that TopModule implements a level-sensitive D latch, where q
  becomes transparent to d when ena is asserted, and retains its
  previously latched value when ena is deasserted. The design has no
  explicit clock or reset; state retention and transitions are defined
  relative to an implicit evaluation event triggered by any change to
  d or ena.

  Background:
    Given the module TopModule has input d
    And the module TopModule has input ena
    And the module TopModule has output q
    And the design has no explicit clock or reset signal
    And the design is evaluated on any change to d or ena (an implicit
      sensitivity event @(d or ena)), and this event serves as the
      reference point for state retention and transition checks

  @transparent_mode @core
  Formal Scenario: Latch is transparent when enable is high
    Given ena is 1
    And d is any valid value D
    When the always block evaluates
    Then q should equal D

  @hold_mode @core
  Formal Scenario: Latch holds previous value when enable is low
    Given ena is 0
    And q currently holds value Q_PREV
    And d is any valid value D
    When the always block evaluates
    Then q should equal Q_PREV
    And q should be independent of D

  @enable_transition_high_to_low
  Formal Scenario: Value is captured at the moment enable falls
    Given ena is 1
    And d is value D
    And q equals D as a result of the current evaluation event
    When ena changes to 0
    And this change triggers the implicit evaluation event
    Then q should equal D
    And q should remain equal to D when d subsequently changes to any
      value D1, as long as ena remains 0

  @enable_transition_low_to_high
  Formal Scenario: Latch becomes transparent immediately when enable rises
    Given ena is 0
    And q currently holds value Q_HELD
    And d is value D
    When ena changes to 1
    And this change triggers the implicit evaluation event
    Then q should equal D

  @no_glitch_while_disabled
  Formal Scenario: Output remains stable across multiple d changes while disabled
    Given ena is 0
    And q currently holds value Q_HELD
    When d changes to any value D1
    And this change triggers the implicit evaluation event
    Then q should equal Q_HELD
    When d changes again to any value D2
    And this change triggers the implicit evaluation event
    Then q should equal Q_HELD

  @combinational_equivalence
  Formal Scenario: Q tracks d combinationally whenever enable is asserted
    Given ena is 1
    And d is any valid value D
    When the always block evaluates
    Then q should equal d at every evaluation, for all values of d

  @combinational_hold_equivalence
  Formal Scenario: Q equals its previously held value whenever enable is deasserted
    Given ena is 0
    And q holds value Q_HELD prior to any change in d
    When d changes to any value D
    And this change triggers the implicit evaluation event
    Then q should equal Q_HELD
    And this equality should hold regardless of the value of D

  @simultaneous_change
  Formal Scenario: Simultaneous change of d and ena at the same evaluation event
    Given ena transitions from 0 to 1
    And d transitions to value D at the same implicit evaluation event
    When the implicit evaluation event occurs
    Then q should equal D

  @idle_stability
  Formal Scenario: Output remains unchanged when neither d nor ena changes
    Given ena is 0
    And q currently holds value Q_HELD
    And neither d nor ena changes
    Then no implicit evaluation event occurs
    And q should remain equal to Q_HELD