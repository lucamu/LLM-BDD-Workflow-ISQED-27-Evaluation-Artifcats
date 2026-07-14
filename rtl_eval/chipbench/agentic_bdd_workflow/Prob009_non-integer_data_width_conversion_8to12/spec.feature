Feature: 8-bit to 12-bit Data Width Conversion with Valid-Only Handshake

  As a hardware design verified via formal property checking
  The TopModule shall pack two consecutive 8-bit input words
  into a single 12-bit output word, using a valid-only handshake
  on both the input and output interfaces.

  Background:
    Given the design is synchronous to the rising edge of clk
    And rst_n is an active-low reset
    And all state (pending byte, pending flag, valid_out, data_out) is updated only on the rising edge of clk

  @reset
  Formal Scenario: Reset forces outputs and internal pending state to idle
    Given rst_n is 0
    And valid_in is any value
    And data_in is any value
    When a rising edge of clk occurs
    Then valid_out should be 0
    And data_out should be 0

  @first-input-no-output
  Formal Scenario: A single accepted input produces no output on the next cycle
    Given rst_n is 1
    And the module holds no pending first byte
    And valid_in is 1
    And data_in is value A
    When a rising edge of clk occurs
    Then valid_out should be 0

  @second-input-produces-output
  Formal Scenario: Second consecutive valid input completes the pair and produces output next cycle
    Given rst_n is 1
    And the module holds no pending first byte
    And valid_in is 1
    And data_in is value A
    When a rising edge of clk occurs
    Then valid_out should be 0
    Given valid_in is 1
    And data_in is value B
    When a rising edge of clk occurs
    Then valid_out should be 1
    And data_out[11:4] should be equal to A
    And data_out[3:0] should be equal to B[3:0]

  @no-output-when-idle
  Formal Scenario: Continuous invalid input never produces a valid output
    Given rst_n is 1
    And valid_in is 0
    When a rising edge of clk occurs
    Then valid_out should be 0
    Given valid_in is 0
    When a rising edge of clk occurs
    Then valid_out should be 0

  @valid-out-single-cycle-pulse
  Formal Scenario: valid_out deasserts one cycle after a completed pair unless a new pair is immediately ready
    Given rst_n is 1
    And the module holds no pending first byte
    And valid_in is 1
    And data_in is value A
    When a rising edge of clk occurs
    Given valid_in is 1
    And data_in is value B
    When a rising edge of clk occurs
    Then valid_out should be 1
    Given valid_in is 0
    When a rising edge of clk occurs
    Then valid_out should be 0

  @back-to-back-pairs
  Formal Scenario: Continuous stream of valid inputs produces alternating valid outputs correctly paired
    Given rst_n is 1
    And the module holds no pending first byte
    And valid_in is 1
    And data_in is value A
    When a rising edge of clk occurs
    Given valid_in is 1
    And data_in is value B
    When a rising edge of clk occurs
    Then valid_out should be 1
    And data_out[11:4] should be equal to A
    And data_out[3:0] should be equal to B[3:0]
    Given valid_in is 1
    And data_in is value C
    When a rising edge of clk occurs
    Then valid_out should be 0
    Given valid_in is 1
    And data_in is value D
    When a rising edge of clk occurs
    Then valid_out should be 1
    And data_out[11:4] should be equal to C
    And data_out[3:0] should be equal to D[3:0]

  @non-contiguous-inputs
  Formal Scenario: Pending first byte persists across idle cycles until the second byte arrives
    Given rst_n is 1
    And the module holds no pending first byte
    And valid_in is 1
    And data_in is value A
    When a rising edge of clk occurs
    Then valid_out should be 0
    Given valid_in is 0
    When a rising edge of clk occurs
    Then valid_out should be 0
    Given valid_in is 1
    And data_in is value B
    When a rising edge of clk occurs
    Then valid_out should be 1
    And data_out[11:4] should be equal to A
    And data_out[3:0] should be equal to B[3:0]

  @mid-sequence-reset
  Formal Scenario: Reset during a pending pair discards the partially received byte
    Given rst_n is 1
    And the module holds no pending first byte
    And valid_in is 1
    And data_in is value A
    When a rising edge of clk occurs
    Then valid_out should be 0
    Given rst_n is 0
    When a rising edge of clk occurs
    Then valid_out should be 0
    And data_out should be 0
    Given rst_n is 1
    And valid_in is 1
    And data_in is value B
    When a rising edge of clk occurs
    Then valid_out should be 0
    Given valid_in is 1
    And data_in is value C
    When a rising edge of clk occurs
    Then valid_out should be 1
    And data_out[11:4] should be equal to B
    And data_out[3:0] should be equal to C[3:0]