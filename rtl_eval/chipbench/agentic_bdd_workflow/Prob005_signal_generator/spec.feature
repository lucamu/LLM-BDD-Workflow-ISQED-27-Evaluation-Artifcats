Feature: Waveform Generator (TopModule)
  Verify that TopModule produces correct square, sawtooth, and triangular
  waveforms on the 5-bit `wave` output based on the 2-bit `wave_choice`
  selector, with synchronous behavior tied to `clk` and active-low `rst_n`.

  Background:
    Given the design is a synchronous module clocked on the rising edge of clk
    And rst_n is the active-low synchronous reset signal
    And wave is a 5-bit unsigned output ranging from 5'b00000 to 5'b11111
    And wave_choice is a 2-bit input selecting the waveform mode
    And there exists an internal single-bit direction state, dir, indicating
      whether the triangular wave generator is currently counting up
      (dir = up) or counting down (dir = down)
    And dir is updated deterministically each cycle so that up and down are
      always mutually exclusive, eliminating any ambiguity when wave holds
      an equal value across cycles
    And any reference to "the previous wave value", denoted W_prev,
      corresponds to $past(wave) in the SVA translation of this specification
    And the internal direction state is functionally consistent with the
      trajectory implied by comparing wave against $past(wave), but is
      represented as an explicit up/down state so that triangular wave
      transitions are always deterministic

  @reset
  Formal Scenario: Reset forces wave to its initial value
    Given rst_n is 0
    When a rising clock edge occurs
    Then wave should be 5'b00000

  @reset @direction
  Formal Scenario: Reset initializes the triangular direction state to up
    Given rst_n is 0
    When a rising clock edge occurs
    Then dir should be up

  @range @invariant
  Formal Scenario: Wave output always stays within the legal 5-bit range
    Given rst_n is 1
    And wave holds current value W
    When a rising clock edge occurs
    Then wave should be greater than or equal to 5'b00000
    And wave should be less than or equal to 5'b11111

  @square
  Formal Scenario: Square wave toggles from minimum to maximum
    Given rst_n is 1
    And wave_choice is 2'b00
    And wave holds current value W
    And W equals 5'b00000
    When a rising clock edge occurs
    Then wave should be 5'b11111

  @square
  Formal Scenario: Square wave toggles from maximum to minimum
    Given rst_n is 1
    And wave_choice is 2'b00
    And wave holds current value W
    And W equals 5'b11111
    When a rising clock edge occurs
    Then wave should be 5'b00000

  @sawtooth
  Formal Scenario: Sawtooth wave increments while below maximum
    Given rst_n is 1
    And wave_choice is 2'b01
    And wave holds current value W
    And W is less than 5'b11111
    When a rising clock edge occurs
    Then wave should be W + 1

  @sawtooth
  Formal Scenario: Sawtooth wave wraps to zero at maximum
    Given rst_n is 1
    And wave_choice is 2'b01
    And wave holds current value W
    And W equals 5'b11111
    When a rising clock edge occurs
    Then wave should be 5'b00000

  @triangular @ascending
  Formal Scenario: Triangular wave ascends while counting up and below maximum
    Given rst_n is 1
    And wave_choice is 2'b10
    And dir is up
    And wave holds current value W
    And W is less than 5'b11111
    When a rising clock edge occurs
    Then wave should be W + 1
    And dir should remain up

  @triangular @peak
  Formal Scenario: Triangular wave switches to counting down upon reaching maximum
    Given rst_n is 1
    And wave_choice is 2'b10
    And dir is up
    And wave holds current value W
    And W equals 5'b11111
    When a rising clock edge occurs
    Then wave should be W - 1
    And dir should become down

  @triangular @descending
  Formal Scenario: Triangular wave descends while counting down and above minimum
    Given rst_n is 1
    And wave_choice is 2'b10
    And dir is down
    And wave holds current value W
    And W is greater than 5'b00000
    When a rising clock edge occurs
    Then wave should be W - 1
    And dir should remain down

  @triangular @trough
  Formal Scenario: Triangular wave switches to counting up upon reaching minimum
    Given rst_n is 1
    And wave_choice is 2'b10
    And dir is down
    And wave holds current value W
    And W equals 5'b00000
    When a rising clock edge occurs
    Then wave should be W + 1
    And dir should become up

  @triangular @direction_exclusivity @invariant
  Formal Scenario: Triangular direction state is always mutually exclusive
    Given rst_n is 1
    And wave_choice is 2'b10
    When a rising clock edge occurs
    Then dir should be either up or down
    And dir should never be simultaneously up and down

  @mode_switch
  Formal Scenario: Changing wave_choice does not corrupt current output before next edge
    Given rst_n is 1
    And wave holds current value W
    And wave_choice transitions from mode M1 to mode M2
    When no rising clock edge has yet occurred
    Then wave should remain W