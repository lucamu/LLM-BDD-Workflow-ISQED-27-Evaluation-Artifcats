Feature: Vending Machine Currency Acceptance and Beverage Dispensing

  As a hardware designer
  I want to formally verify the TopModule vending machine
  So that currency accumulation, beverage dispensing, and change dispensing
  are correct for all valid input sequences

  Background:
    Given a clock signal "clk" that samples state on the rising edge
    And an active-low synchronous reset "rst"
    And input "d1" represents insertion of 0.5 yuan and is edge-detected to a single-cycle pulse
    And input "d2" represents insertion of 1 yuan and is edge-detected to a single-cycle pulse
    And input "sel" selects the desired beverage, 0 for beverage1 costing 1.5 yuan and 1 for beverage2 costing 2.5 yuan
    And the machine maintains an internal accumulated money total starting at 0
    And beverage1 is dispensed on "out1", beverage2 is dispensed on "out2", and 0.5 yuan change coins are dispensed on "out3"

  @reset
  Formal Scenario: Reset forces all outputs low and clears accumulated money
    Given rst is asserted low
    When any rising clock edge occurs
    Then out1 should be 0
    And out2 should be 0
    And out3 should be 0
    And the internal accumulated money should be 0

  @reset
  Formal Scenario: Reset overrides any pending currency or selection inputs
    Given rst is asserted low
    And d1 is any value
    And d2 is any value
    And sel is any value
    When a rising clock edge occurs
    Then out1 should be 0
    And out2 should be 0
    And out3 should be 0

  @edge_detection
  Formal Scenario: d1 held high for multiple cycles produces only a single pulse per edge
    Given rst is deasserted high
    And d1 transitions from 0 to 1 and remains 1 for more than one clock cycle
    When the rising clock edge that detects the transition occurs
    Then the accumulated money increases by exactly 0.5 yuan on that edge only
    And the accumulated money does not increase again while d1 remains held high without a new 0-to-1 transition

  @edge_detection
  Formal Scenario: d2 held high for multiple cycles produces only a single pulse per edge
    Given rst is deasserted high
    And d2 transitions from 0 to 1 and remains 1 for more than one clock cycle
    When the rising clock edge that detects the transition occurs
    Then the accumulated money increases by exactly 1 yuan on that edge only
    And the accumulated money does not increase again while d2 remains held high without a new 0-to-1 transition

  @accumulation
  Formal Scenario: Accumulated money equals sum of inserted currency pulses
    Given rst is deasserted high
    And a sequence of clock cycles in which d1 pulses occur count_d1 times
    And in the same sequence d2 pulses occur count_d2 times
    And no dispensing threshold for the selected beverage is reached during the sequence
    When the sequence of rising clock edges completes
    Then the internal accumulated money should equal count_d1 times 0.5 yuan plus count_d2 times 1 yuan

  @dispense_beverage1
  Formal Scenario: Beverage1 dispenses on exact payment
    Given rst is deasserted high
    And sel is 0
    And the accumulated money reaches exactly 1.5 yuan through any sequence of d1 and d2 pulses
    When the rising clock edge at which the accumulated money reaches 1.5 yuan occurs
    Then out1 should be 1 on that rising clock edge
    And out2 should be 0
    And out3 should be 0
    And the internal accumulated money should reset to 0

  @dispense_beverage2
  Formal Scenario: Beverage2 dispenses on exact payment
    Given rst is deasserted high
    And sel is 1
    And the accumulated money reaches exactly 2.5 yuan through any sequence of d1 and d2 pulses
    When the rising clock edge at which the accumulated money reaches 2.5 yuan occurs
    Then out2 should be 1 on that rising clock edge
    And out1 should be 0
    And out3 should be 0
    And the internal accumulated money should reset to 0

  @change_dispense
  Formal Scenario: Beverage1 overpayment dispenses beverage and one change coin
    Given rst is deasserted high
    And sel is 0
    And the accumulated money reaches or exceeds 1.5 yuan through any sequence of d1 and d2 pulses, overshooting the price by exactly 0.5 yuan
    When the dispensing rising clock edge occurs
    Then out1 should be 1 on the dispensing rising clock edge
    And out3 should be 1 on a rising clock edge following dispensing to return the overpaid 0.5 yuan
    And the internal accumulated money should reset to 0 after the change is returned

  @change_dispense
  Formal Scenario: Beverage2 overpayment dispenses beverage and one change coin
    Given rst is deasserted high
    And sel is 1
    And the accumulated money reaches or exceeds 2.5 yuan through any sequence of d1 and d2 pulses, overshooting the price by exactly 0.5 yuan
    When the dispensing rising clock edge occurs
    Then out2 should be 1 on the dispensing rising clock edge
    And out3 should be 1 on a rising clock edge following dispensing to return the overpaid 0.5 yuan
    And the internal accumulated money should reset to 0 after the change is returned

  @no_change
  Formal Scenario: Exact payment never triggers change dispensing
    Given rst is deasserted high
    And the accumulated money reaches exactly the price of the selected beverage with no overpayment
    When the beverage dispensing rising clock edge occurs
    Then out3 should remain 0 on that edge and on the following rising clock edge

  @insufficient_funds
  Formal Scenario: Insufficient accumulated money never dispenses beverage or change
    Given rst is deasserted high
    And the accumulated money is strictly less than the price of the selected beverage
    When any rising clock edge occurs with no further currency pulses
    Then out1 should be 0
    And out2 should be 0
    And out3 should be 0

  @mutual_exclusion
  Formal Scenario: Beverage outputs are mutually exclusive
    Given rst is deasserted high
    When any rising clock edge occurs
    Then out1 and out2 should not both be 1 simultaneously

  @sel_dependence
  Formal Scenario: Beverage selection determines which output can assert at the dispensing threshold
    Given rst is deasserted high
    And sel is held constant at a symbolic value S throughout the accumulation sequence
    And the accumulated money reaches exactly the price associated with S
    When the dispensing rising clock edge occurs
    Then out1 should be 1 if and only if S equals 0
    And out2 should be 1 if and only if S equals 1