Feature: Keyboard Scancode Decoder for Keys 0-9

  This module decodes 8-bit keyboard scancodes into 4-bit key values (0-9)
  and asserts valid when a recognized scancode is detected. Unrecognized
  scancodes produce out=0 and valid=0. This is a purely combinational
  design with no clock or reset.

  Background:
    Given a combinational module TopModule
    And an 8-bit input code
    And a 4-bit output out
    And a 1-bit output valid

  @scancode_decode @key0
  Formal Scenario: Scancode 8'h45 decodes to key 0
    Given code equals 8'h45
    When the combinational logic evaluates
    Then out should be 4'd0
    And valid should be 1

  @scancode_decode @key1
  Formal Scenario: Scancode 8'h16 decodes to key 1
    Given code equals 8'h16
    When the combinational logic evaluates
    Then out should be 4'd1
    And valid should be 1

  @scancode_decode @key2
  Formal Scenario: Scancode 8'h1e decodes to key 2
    Given code equals 8'h1e
    When the combinational logic evaluates
    Then out should be 4'd2
    And valid should be 1

  @scancode_decode @key3
  Formal Scenario: Scancode 8'h26 decodes to key 3
    Given code equals 8'h26
    When the combinational logic evaluates
    Then out should be 4'd3
    And valid should be 1

  @scancode_decode @key4
  Formal Scenario: Scancode 8'h25 decodes to key 4
    Given code equals 8'h25
    When the combinational logic evaluates
    Then out should be 4'd4
    And valid should be 1

  @scancode_decode @key5
  Formal Scenario: Scancode 8'h2e decodes to key 5
    Given code equals 8'h2e
    When the combinational logic evaluates
    Then out should be 4'd5
    And valid should be 1

  @scancode_decode @key6
  Formal Scenario: Scancode 8'h36 decodes to key 6
    Given code equals 8'h36
    When the combinational logic evaluates
    Then out should be 4'd6
    And valid should be 1

  @scancode_decode @key7
  Formal Scenario: Scancode 8'h3d decodes to key 7
    Given code equals 8'h3d
    When the combinational logic evaluates
    Then out should be 4'd7
    And valid should be 1

  @scancode_decode @key8
  Formal Scenario: Scancode 8'h3e decodes to key 8
    Given code equals 8'h3e
    When the combinational logic evaluates
    Then out should be 4'd8
    And valid should be 1

  @scancode_decode @key9
  Formal Scenario: Scancode 8'h46 decodes to key 9
    Given code equals 8'h46
    When the combinational logic evaluates
    Then out should be 4'd9
    And valid should be 1

  @invalid_scancode
  Formal Scenario: Unrecognized scancode produces zero output and invalid flag
    Given code is any value X
    And X does not equal 8'h45
    And X does not equal 8'h16
    And X does not equal 8'h1e
    And X does not equal 8'h26
    And X does not equal 8'h25
    And X does not equal 8'h2e
    And X does not equal 8'h36
    And X does not equal 8'h3d
    And X does not equal 8'h3e
    And X does not equal 8'h46
    When the combinational logic evaluates
    Then out should be 4'd0
    And valid should be 0

  @mutual_exclusivity
  Formal Scenario: Valid is asserted if and only if code matches exactly one recognized scancode
    Given code is any value X
    When the combinational logic evaluates
    Then valid should be 1 if X equals 8'h45 or X equals 8'h16 or X equals 8'h1e or X equals 8'h26 or X equals 8'h25 or X equals 8'h2e or X equals 8'h36 or X equals 8'h3d or X equals 8'h3e or X equals 8'h46
    And valid should be 0 otherwise

  @output_range
  Formal Scenario: Output out is always within valid key range when valid is asserted
    Given code is any value X
    When the combinational logic evaluates
    Then out should be less than or equal to 4'd9 if valid equals 1

  @deterministic_mapping
  Formal Scenario: Distinct recognized scancodes map to distinct output values via bounded enumeration
    Given the finite set of recognized scancodes is exactly {8'h45, 8'h16, 8'h1e, 8'h26, 8'h25, 8'h2e, 8'h36, 8'h3d, 8'h3e, 8'h46}
    And CodeA is any value drawn from the finite set of recognized scancodes
    And CodeB is any value drawn from the finite set of recognized scancodes
    And CodeA does not equal CodeB
    When the combinational logic evaluates for code equal to CodeA
    And the combinational logic evaluates for code equal to CodeB
    Then out(CodeA) should not equal out(CodeB)
    And this property is verified via bounded enumeration over all pairwise combinations of the 10 recognized scancodes