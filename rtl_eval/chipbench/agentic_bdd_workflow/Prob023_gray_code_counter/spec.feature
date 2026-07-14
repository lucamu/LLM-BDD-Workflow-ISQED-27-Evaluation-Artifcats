Feature: 4-bit Gray Code Counter with Divide-by-2 Clocking

  As a hardware designer
  I want a 4-bit Gray code counter that increments every two clock cycles
  So that the output always follows a valid Gray code sequence with asynchronous active-low reset

  Background:
    Given the design has input clk
    And the design has input rst_n
    And the design has output gray_out with width 4
    And all sequential logic is triggered on the rising edge of clk
    And rst_n is an asynchronous active-low reset

  @reset @async
  Formal Scenario: Asynchronous reset forces gray_out to zero immediately
    Given rst_n is deasserted to 0 at an arbitrary time, independent of clk
    Then gray_out should immediately become 4'b0000
    And gray_out should remain 4'b0000 for as long as rst_n stays 0
    And this behavior is independent of the value of gray_out prior to reset

  @reset @sync-release
  Formal Scenario: Counter resumes from zero after reset release
    Given rst_n is deasserted to 0 and gray_out equals 4'b0000
    When rst_n is asserted to 1
    And a rising edge of clk occurs
    Then gray_out should equal 4'b0000 or 4'b0001
    And the resulting value should be a valid successor of 4'b0000 in the Gray code sequence

  @stability @half-rate
  Formal Scenario: Gray output holds its value for two consecutive clock cycles
    Given rst_n is asserted to 1
    And gray_out equals value G at clock cycle N
    And clock cycle N marks the start of a new Gray code hold period
    When one rising edge of clk occurs, advancing to cycle N+1
    Then gray_out should still equal G at cycle N+1
    And gray_out should only be permitted to change on the rising edge that advances from cycle N+1 to cycle N+2

  @gray-property @single-bit-change
  Formal Scenario: Consecutive distinct Gray code outputs differ by exactly one bit
    Given rst_n is asserted to 1
    And gray_out equals value G_prev immediately before a value-changing rising edge of clk
    When the rising edge of clk occurs and gray_out changes to G_next
    Then G_next should differ from G_prev in exactly one bit position
    And G_next XOR G_prev should have a Hamming weight of exactly 1

  @encoding @binary-increment
  Formal Scenario: Gray output equals Gray encoding of an incrementing binary count
    Given rst_n is asserted to 1
    And an internal binary count B represents the number of completed two-cycle Gray periods since reset
    And gray_out equals gray_encode(B) at the current hold period
    When two rising edges of clk occur, completing the current hold period
    Then the internal binary count should update to (B + 1) mod 16
    And gray_out should equal gray_encode((B + 1) mod 16)
    Where gray_encode(X) is defined as X XOR (X >> 1)

  @wraparound @full-cycle
  Formal Scenario: Counter cycles through all 16 Gray code values and wraps to zero
    Given rst_n is asserted to 1
    And gray_out equals 4'b0000 at the start of a hold period
    When 32 rising edges of clk occur, corresponding to 16 complete two-cycle hold periods
    Then gray_out should return to 4'b0000
    And every value produced during these 16 hold periods should be a unique 4-bit Gray code
    And the sequence of values should match the standard reflected binary Gray code ordering

  @no-glitch @combinational-stability
  Formal Scenario: Gray output never contains an undefined or multi-bit-change glitch
    Given rst_n is asserted to 1
    And gray_out equals value G at any clock cycle after reset deassertion
    Then G should always be a member of the valid 4-bit Gray code set of 16 values
    And no rising edge of clk should ever produce a G_next that differs from G_prev by more than one bit

  @reset-priority
  Formal Scenario: Reset takes priority over normal counting behavior
    Given rst_n is asserted to 1
    And gray_out equals some non-zero value G at the current cycle
    When rst_n is deasserted to 0 at the same time as a rising edge of clk that would otherwise update gray_out
    Then gray_out should become 4'b0000
    And the normal Gray code increment should not take effect on that edge