Feature: Cyclic Sequence Generator (001011)

  As a hardware designer
  I want to verify that TopModule outputs the repeating sequence 001011
  So that the pattern restarts correctly on reset and cycles indefinitely

  Background:
    Given a signal clk representing the system clock
    And a signal rst_n representing the active-low synchronous reset
    And a signal data representing the sequential output
    And all sequential logic is triggered on the positive edge of clk
    And the sequence pattern is defined as bit 0 = 0, bit 1 = 0, bit 2 = 1, bit 3 = 0, bit 4 = 1, bit 5 = 1

  @reset
  Formal Scenario: Reset forces the sequence to restart at the first bit
    Given rst_n is deasserted (rst_n = 0)
    When a positive clock edge occurs
    Then data should equal 0
    And the internal sequence position should equal 0 immediately after reset deassertion

  @reset
  Formal Scenario: Reset asserted at any arbitrary cycle restarts the sequence
    Given the design has been running for a symbolic number of cycles N since the last reset
    And rst_n is deasserted (rst_n = 0) at this cycle
    When a positive clock edge occurs
    Then the internal sequence position should equal 0
    And data should equal 0

  @sequence
  Formal Scenario: Output at sequence position 0 is 0
    Given rst_n has been asserted (rst_n = 1) continuously
    And a symbolic number of cycles N have elapsed since reset deassertion
    And the internal sequence position equals N modulo 6
    And the sequence position equals 0
    Then data should equal 0

  @sequence
  Formal Scenario: Output at sequence position 1 is 0
    Given rst_n has been asserted (rst_n = 1) continuously
    And a symbolic number of cycles N have elapsed since reset deassertion
    And the internal sequence position equals N modulo 6
    And the sequence position equals 1
    Then data should equal 0

  @sequence
  Formal Scenario: Output at sequence position 2 is 1
    Given rst_n has been asserted (rst_n = 1) continuously
    And a symbolic number of cycles N have elapsed since reset deassertion
    And the internal sequence position equals N modulo 6
    And the sequence position equals 2
    Then data should equal 1

  @sequence
  Formal Scenario: Output at sequence position 3 is 0
    Given rst_n has been asserted (rst_n = 1) continuously
    And a symbolic number of cycles N have elapsed since reset deassertion
    And the internal sequence position equals N modulo 6
    And the sequence position equals 3
    Then data should equal 0

  @sequence
  Formal Scenario: Output at sequence position 4 is 1
    Given rst_n has been asserted (rst_n = 1) continuously
    And a symbolic number of cycles N have elapsed since reset deassertion
    And the internal sequence position equals N modulo 6
    And the sequence position equals 4
    Then data should equal 1

  @sequence
  Formal Scenario: Output at sequence position 5 is 1
    Given rst_n has been asserted (rst_n = 1) continuously
    And a symbolic number of cycles N have elapsed since reset deassertion
    And the internal sequence position equals N modulo 6
    And the sequence position equals 5
    Then data should equal 1

  @cyclic
  Formal Scenario: Sequence position advances by one each cycle modulo 6
    Given rst_n has been asserted (rst_n = 1) continuously
    And the internal sequence position at cycle N equals P
    When a positive clock edge occurs
    Then the internal sequence position at cycle N+1 should equal (P + 1) modulo 6

  @cyclic
  Formal Scenario: The output pattern repeats identically every 6 cycles
    Given rst_n has been asserted (rst_n = 1) continuously
    And a symbolic number of cycles N have elapsed since reset deassertion
    And data at cycle N equals value D
    Then data at cycle N+6 should equal D