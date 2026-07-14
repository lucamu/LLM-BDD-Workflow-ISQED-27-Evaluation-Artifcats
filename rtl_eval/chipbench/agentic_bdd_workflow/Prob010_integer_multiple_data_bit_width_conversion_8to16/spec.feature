Feature: 8-bit to 16-bit Data Width Converter with Valid-Only Handshake

  As a hardware designer
  I want a width conversion module that accumulates two 8-bit inputs into one 16-bit output
  So that downstream logic can consume 16-bit data using a valid-only handshake

  Background:
    Given the design is synchronous to the rising edge of clk
    And all internal state updates occur only on the rising edge of clk
    And rst_n is an active-low reset
    And the module maintains an internal byte counter representing the number of pending bytes received (0 or 1)
    And the module maintains an internal register holding the first received byte when the byte counter is 1
    And data_in is an 8-bit value
    And data_out is a 16-bit value

  @reset
  Formal Scenario: Reset forces outputs and internal state to known idle values
    Given rst_n is deasserted (0)
    When a rising edge of clk occurs
    Then valid_out should be 0
    And data_out should be 16'b0
    And the internal byte counter should be 0

  @reset
  Formal Scenario: Reset clears a pending first byte regardless of prior state
    Given rst_n is asserted (1) prior to this cycle
    And the internal byte counter is 1
    And the stored first byte equals value A
    And rst_n becomes deasserted (0) in this cycle
    When a rising edge of clk occurs
    Then valid_out should be 0
    And data_out should be 16'b0
    And the internal byte counter should become 0

  @first_byte
  Formal Scenario: Receiving the first byte stores it without producing output
    Given rst_n is asserted (1)
    And the internal byte counter is 0
    And valid_in is 1
    And data_in is value A
    When a rising edge of clk occurs
    Then valid_out should be 0
    And the internal byte counter should become 1
    And the stored first byte should become A

  @second_byte
  Formal Scenario: Receiving the second byte produces the combined 16-bit output
    Given rst_n is asserted (1)
    And the internal byte counter is 1
    And the stored first byte equals value A
    And valid_in is 1
    And data_in is value B
    When a rising edge of clk occurs
    Then valid_out should be 1
    And data_out should be {A, B}
    And the internal byte counter should become 0

  @idle_no_input
  Formal Scenario: No input keeps internal state and output unchanged
    Given rst_n is asserted (1)
    And the internal byte counter is value N
    And the stored first byte equals value A
    And valid_in is 0
    When a rising edge of clk occurs
    Then valid_out should be 0
    And the internal byte counter should remain N
    And the stored first byte should remain A

  @first_byte_no_new_input
  Formal Scenario: Waiting for second byte with no new input holds partial state
    Given rst_n is asserted (1)
    And the internal byte counter is 1
    And the stored first byte equals value A
    And valid_in is 0
    When a rising edge of clk occurs
    Then valid_out should be 0
    And the internal byte counter should remain 1
    And the stored first byte should remain A

  @valid_out_pulse
  Formal Scenario: valid_out deasserts one cycle after a completed conversion
    Given rst_n is asserted (1)
    And valid_out was asserted (1) due to a completed byte pair in the previous cycle
    And valid_in is 0 in the current cycle
    When a rising edge of clk occurs
    Then valid_out should be 0

  @continuous_stream
  Formal Scenario: Continuous valid input produces output every second cycle
    Given rst_n is asserted (1)
    And the internal byte counter is 0
    And valid_in is 1 on this cycle with data_in equal to value A
    When a rising edge of clk occurs
    Then valid_out should be 0
    And the internal byte counter should become 1
    And the stored first byte should become A
    Given valid_in is 1 on the following cycle with data_in equal to value B
    When a rising edge of clk occurs
    Then valid_out should be 1
    And data_out should be {A, B}
    And the internal byte counter should become 0

  @data_out_stability
  Formal Scenario: data_out holds its value when valid_out is deasserted
    Given rst_n is asserted (1)
    And valid_out is 0 in the current cycle
    And data_out equals value D prior to this cycle
    And valid_in is 0
    When a rising edge of clk occurs
    Then data_out should remain D

  @independent_bytes
  Formal Scenario: High and low bytes of data_out correspond to order of arrival
    Given rst_n is asserted (1)
    And the internal byte counter is 0
    And valid_in is 1 with data_in equal to value A
    When a rising edge of clk occurs
    Then the internal byte counter should become 1
    And the stored first byte should become A
    Given valid_in is 1 with data_in equal to value B
    When a rising edge of clk occurs
    Then data_out[15:8] should equal A
    And data_out[7:0] should equal B