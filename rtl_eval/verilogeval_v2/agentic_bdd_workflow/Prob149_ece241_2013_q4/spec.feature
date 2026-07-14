Feature: Reservoir Water Level Flow Controller

  As a formal verification engineer
  I want to verify TopModule correctly controls Nominal (fr0, fr1, fr2)
  and Supplemental (dfr) flow valves based on thermometer-coded water
  level sensors and the direction of the last level change
  So that the reservoir maintains a safe, non-oscillating water level

  Background:
    Given a clock clk
    And a synchronous active-high reset reset
    And a 3-bit thermometer-coded sensor input s, where s[0] is the lowest sensor and s[2] is the highest sensor
    And valid sensor codes are limited to 3'b000, 3'b001, 3'b011, and 3'b111
    And outputs fr2, fr1, fr0, and dfr update only on the rising edge of clk

  @reset
  Formal Scenario: Synchronous reset forces the low-water state
    Given reset is asserted
    When a rising edge of clk occurs
    Then fr2 should be 1
    And fr1 should be 1
    And fr0 should be 1
    And dfr should be 1

  @reset_priority
  Formal Scenario: Reset overrides any sensor input on the same edge
    Given reset is asserted
    And s is any valid sensor code
    When a rising edge of clk occurs
    Then fr2 should be 1
    And fr1 should be 1
    And fr0 should be 1
    And dfr should be 1

  @sensor_above_top
  Formal Scenario: Water above the top sensor requires no flow
    Given reset is deasserted
    And s has been held at 3'b111 for at least one prior rising edge of clk
    When a rising edge of clk occurs with s equal to 3'b111
    Then fr2 should be 0
    And fr1 should be 0
    And fr0 should be 0
    And dfr should be 0

  @sensor_below_bottom
  Formal Scenario: Water below the lowest sensor requires maximum flow
    Given reset is deasserted
    And s has been held at 3'b000 for at least one prior rising edge of clk
    When a rising edge of clk occurs with s equal to 3'b000
    Then fr2 should be 1
    And fr1 should be 1
    And fr0 should be 1
    And dfr should be 1

  @sensor_mid_high_nominal
  Formal Scenario: Nominal flow between s2 and s1 asserts only fr0
    Given reset is deasserted
    And s has been held at 3'b011 for at least one prior rising edge of clk
    When a rising edge of clk occurs with s equal to 3'b011
    Then fr0 should be 1
    And fr1 should be 0
    And fr2 should be 0

  @sensor_mid_low_nominal
  Formal Scenario: Nominal flow between s1 and s0 asserts fr0 and fr1
    Given reset is deasserted
    And s has been held at 3'b001 for at least one prior rising edge of clk
    When a rising edge of clk occurs with s equal to 3'b001
    Then fr0 should be 1
    And fr1 should be 1
    And fr2 should be 0

  @rising_transition_supplemental_open
  Formal Scenario: Rising water from the bottom opens the supplemental valve at s0-s1
    Given reset is deasserted
    And s equals 3'b000 at the current rising edge of clk
    When s transitions to 3'b001 on the next rising edge of clk
    Then fr0 should be 1
    And fr1 should be 1
    And fr2 should be 0
    And dfr should be 1

  @rising_continue_supplemental_hold
  Formal Scenario: Continued rise into s1-s2 keeps the supplemental valve open
    Given reset is deasserted
    And s equals 3'b001 at the current rising edge of clk as a result of a prior rising transition from 3'b000
    When s transitions to 3'b011 on the next rising edge of clk
    Then fr0 should be 1
    And fr1 should be 0
    And fr2 should be 0
    And dfr should be 1

  @rising_reaches_top_closes_supplemental
  Formal Scenario: Reaching the top sensor while rising closes all flow
    Given reset is deasserted
    And s equals 3'b011 at the current rising edge of clk as a result of a prior rising transition
    When s transitions to 3'b111 on the next rising edge of clk
    Then fr2 should be 0
    And fr1 should be 0
    And fr0 should be 0
    And dfr should be 0

  @falling_from_top_no_supplemental
  Formal Scenario: Falling from above the top sensor does not open the supplemental valve
    Given reset is deasserted
    And s equals 3'b111 at the current rising edge of clk
    When s transitions to 3'b011 on the next rising edge of clk
    Then fr0 should be 1
    And fr1 should be 0
    And fr2 should be 0
    And dfr should be 0

  @falling_continue_no_supplemental
  Formal Scenario: Continued fall keeps the supplemental valve closed
    Given reset is deasserted
    And s equals 3'b011 at the current rising edge of clk as a result of a prior falling transition from 3'b111
    When s transitions to 3'b001 on the next rising edge of clk
    Then fr0 should be 1
    And fr1 should be 1
    And fr2 should be 0
    And dfr should be 0

  @falling_reaches_bottom_forces_supplemental
  Formal Scenario: Reaching the bottom sensor always forces maximum flow
    Given reset is deasserted
    And s equals 3'b001 at the current rising edge of clk
    When s transitions to 3'b000 on the next rising edge of clk
    Then fr2 should be 1
    And fr1 should be 1
    And fr0 should be 1
    And dfr should be 1

  @direction_reversal_reopens_supplemental
  Formal Scenario: A new rise from the bottom reopens the supplemental valve even after a prior fall
    Given reset is deasserted
    And s equals 3'b001 at the current rising edge of clk as a result of a prior falling transition from 3'b011
    And s transitions to 3'b000 on the next rising edge of clk
    When s transitions again to 3'b001 on the following rising edge of clk
    Then fr0 should be 1
    And fr1 should be 1
    And fr2 should be 0
    And dfr should be 1

  @stable_input_holds_output
  Formal Scenario: A steady sensor reading preserves the current flow outputs
    Given reset is deasserted
    And s equals a fixed valid sensor code X at the current rising edge of clk
    And fr2, fr1, fr0, and dfr have settled to their steady values for code X
    When s remains equal to X on the next rising edge of clk
    Then fr2 should remain unchanged
    And fr1 should remain unchanged
    And fr0 should remain unchanged
    And dfr should remain unchanged

  @fr_bits_depend_only_on_current_level
  Formal Scenario: Nominal flow bits depend only on the current sensor code, not on direction
    Given reset is deasserted
    And s equals a fixed valid sensor code X for at least one prior rising edge of clk
    When a rising edge of clk occurs with s equal to X
    Then fr2 should equal 1 only if X equals 3'b000
    And fr1 should equal 1 only if X equals 3'b000 or X equals 3'b001
    And fr0 should equal 1 only if X does not equal 3'b111