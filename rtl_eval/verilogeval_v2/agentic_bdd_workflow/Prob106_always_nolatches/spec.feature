Feature: PS/2 Keyboard Scancode Arrow Key Decoder

  As a hardware designer
  I want to decode PS/2 scancodes into arrow key signals
  So that the game can detect directional key presses

  Background:
    Given a combinational module "TopModule"
    And an input "scancode" of width 16 bits
    And an output "left"
    And an output "down"
    And an output "right"
    And an output "up"

  @formal @exact-match
  Formal Scenario: Left arrow key scancode is recognized
    Given scancode equals 16'he06b
    Then left should be 1
    And down should be 0
    And right should be 0
    And up should be 0

  @formal @exact-match
  Formal Scenario: Down arrow key scancode is recognized
    Given scancode equals 16'he072
    Then down should be 1
    And left should be 0
    And right should be 0
    And up should be 0

  @formal @exact-match
  Formal Scenario: Right arrow key scancode is recognized
    Given scancode equals 16'he074
    Then right should be 1
    And left should be 0
    And down should be 0
    And up should be 0

  @formal @exact-match
  Formal Scenario: Up arrow key scancode is recognized
    Given scancode equals 16'he075
    Then up should be 1
    And left should be 0
    And down should be 0
    And right should be 0

  @formal @default-case
  Formal Scenario: Unrecognized scancode asserts no arrow key outputs
    Given scancode is value X
    And value X is not equal to 16'he06b
    And value X is not equal to 16'he072
    And value X is not equal to 16'he074
    And value X is not equal to 16'he075
    Then left should be 0
    And down should be 0
    And right should be 0
    And up should be 0

  @formal @mutual-exclusion
  Formal Scenario: At most one arrow key output is asserted at a time
    Given scancode is value X
    Then left + down + right + up should be less than or equal to 1

  @formal @output-consistency
  Formal Scenario: Left output is asserted if and only if scancode matches left arrow code
    Given scancode is value X
    Then left should be 1 if value X equals 16'he06b
    And left should be 0 if value X does not equal 16'he06b

  @formal @output-consistency
  Formal Scenario: Down output is asserted if and only if scancode matches down arrow code
    Given scancode is value X
    Then down should be 1 if value X equals 16'he072
    And down should be 0 if value X does not equal 16'he072

  @formal @output-consistency
  Formal Scenario: Right output is asserted if and only if scancode matches right arrow code
    Given scancode is value X
    Then right should be 1 if value X equals 16'he074
    And right should be 0 if value X does not equal 16'he074

  @formal @output-consistency
  Formal Scenario: Up output is asserted if and only if scancode matches up arrow code
    Given scancode is value X
    Then up should be 1 if value X equals 16'he075
    And up should be 0 if value X does not equal 16'he075

  @formal @combinational-purity
  Formal Scenario: Outputs depend only on current scancode value
    Given scancode is value X
    And scancode later changes to value Y
    Then left should update to reflect value Y equals 16'he06b
    And down should update to reflect value Y equals 16'he072
    And right should update to reflect value Y equals 16'he074
    And up should update to reflect value Y equals 16'he075