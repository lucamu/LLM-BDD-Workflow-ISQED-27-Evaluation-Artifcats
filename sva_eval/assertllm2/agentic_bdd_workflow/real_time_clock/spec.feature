Feature: rtcclock - Wishbone Real-Time Clock Peripheral

  This feature specifies the formally verifiable behavior of the rtcclock
  design: wall-clock timekeeping, countdown timer, stopwatch, alarm,
  clock-speed calibration, time-hack capture, display/LED outputs, and
  interrupt generation, all accessed via a Wishbone register interface.

  Background:
    Given the design is synchronous to the positive edge of "i_clk"
    And there is no dedicated reset input
    And register state is defined by RTL initial values at power-up
    And a write is accepted only when "i_wb_cyc" is 1 and "i_wb_stb" is 1 and "i_wb_we" is 1
    And "i_wb_addr" selects the target register for the current bus cycle

  # ---------------------------------------------------------------------
  # Bus access semantics
  # ---------------------------------------------------------------------

  @bus @readmux
  Formal Scenario: Read data reflects the addressed register on the next clock edge
    Given a register address A on "i_wb_addr"
    And "i_wb_cyc" is 1 and "i_wb_stb" is 1 and "i_wb_we" is 0
    When one clock edge occurs
    Then "o_data" should equal the value of the register selected by address A, registered from that cycle

  @bus @write-gating
  Formal Scenario: Write is ignored unless cyc, stb, and we are all asserted
    Given a register address A on "i_wb_addr"
    And a write data value D on "i_wb_data"
    And at least one of "i_wb_cyc", "i_wb_stb", "i_wb_we" is 0
    And the current value of the register selected by address A is V
    When one clock edge occurs
    Then the register selected by address A should remain equal to V

  @bus @write-gating
  Formal Scenario: Write is accepted when cyc, stb, and we are all asserted
    Given a register address A on "i_wb_addr"
    And a write data value D on "i_wb_data"
    And "i_wb_cyc" is 1 and "i_wb_stb" is 1 and "i_wb_we" is 1
    When one clock edge occurs
    Then the register selected by address A should be updated according to the write semantics of that register with data D

  # ---------------------------------------------------------------------
  # Time base / accumulator
  # ---------------------------------------------------------------------

  @timebase @accumulator
  Formal Scenario: Fractional accumulator increments by ckspeed each cycle
    Given "ckspeed" holds value K
    And "ck_counter" holds value C
    When one clock edge occurs with no hack event
    Then "ck_counter" should equal (C + K) modulo 2^40

  @timebase @carry
  Formal Scenario: Subsecond step advances on accumulator carry
    Given "ckspeed" holds value K
    And "ck_counter" holds value C
    And "ck_sub" holds value S
    When one clock edge occurs
    Then "ck_sub" should equal (S + 1) modulo 256 if the addition of C and K produces a carry out of bit 39
    And "ck_sub" should equal S if the addition of C and K produces no carry out of bit 39

  @timebase @pps
  Formal Scenario: Second pulse advances wall clock after 256 subsecond steps
    Given "ck_sub" holds value 255
    And a subsecond-step event occurs on this cycle
    When one clock edge occurs
    Then "ck_pps" should be asserted on this cycle
    And the wall clock seconds field should advance by one BCD second

  # ---------------------------------------------------------------------
  # Wall clock register behavior
  # ---------------------------------------------------------------------

  @clock @masked-write @seconds
  Formal Scenario: Writing seconds field 8'hFF leaves seconds unchanged
    Given the clock register seconds field holds BCD value SS
    And a write to the Clock/Display register (address 3'b000) with seconds field 8'hFF
    When one clock edge occurs
    Then the clock register seconds field should remain equal to SS

  @clock @masked-write @minutes
  Formal Scenario: Writing minutes field 8'hFF leaves minutes unchanged
    Given the clock register minutes field holds BCD value MM
    And a write to the Clock/Display register (address 3'b000) with minutes field 8'hFF
    When one clock edge occurs
    Then the clock register minutes field should remain equal to MM

  @clock @masked-write @hours
  Formal Scenario: Writing hours field 6'h3F leaves hours unchanged
    Given the clock register hours field holds BCD value HH
    And a write to the Clock/Display register (address 3'b000) with hours field 6'h3F
    When one clock edge occurs
    Then the clock register hours field should remain equal to HH

  @clock @subsecond-clear
  Formal Scenario: Writing seconds field 8'h00 clears ck_sub
    Given "ck_sub" holds a value S
    And a write to the Clock/Display register (address 3'b000) with seconds field 8'h00
    When one clock edge occurs
    Then "ck_sub" should equal 0

  @clock @write-update
  Formal Scenario: Writing a defined BCD seconds value updates the seconds field
    Given a write to the Clock/Display register (address 3'b000) with seconds field value SS, where SS is not 8'hFF
    When one clock edge occurs
    Then the clock register seconds field should equal SS

  @clock @readback
  Formal Scenario: Clock register read returns status and stable clock copy
    Given the clock register control/status upper field holds value U
    And "ck_last_clock" holds value L
    And a read of the Clock/Display register (address 3'b000)
    When one clock edge occurs
    Then "o_data" should equal the concatenation of U and L

  # ---------------------------------------------------------------------
  # Countdown timer
  # ---------------------------------------------------------------------

  @timer @decrement
  Formal Scenario: Running timer decrements once per second
    Given "timer" bit 24 (running) is 1
    And the timer BCD countdown value holds T, where T is not zero
    And a one-second event occurs on this cycle
    When one clock edge occurs
    Then the timer BCD countdown value should equal T decremented by one BCD second

  @timer @expiration
  Formal Scenario: Countdown reaching zero trips alarm, stops running, and pulses interrupt
    Given "timer" bit 24 (running) is 1
    And the timer BCD countdown value holds BCD zero
    And a one-second event occurs on this cycle
    When one clock edge occurs
    Then "timer" bit 25 (tripped) should be set to 1
    And "timer" bit 24 (running) should be cleared to 0
    And "tm_int" should be asserted for exactly this cycle

  @timer @write-while-running
  Formal Scenario: Write while running only affects run/stop control
    Given "timer" bit 24 (running) is 1
    And the timer BCD countdown value holds T
    And a write to the Timer register (address 3'b001) with countdown value data D and run bit R
    When one clock edge occurs
    Then "timer" bit 24 should equal R
    And the timer BCD countdown value should remain equal to T

  @timer @write-while-stopped
  Formal Scenario: Write while stopped loads new value and clears alarm status
    Given "timer" bit 24 (running) is 0
    And a write to the Timer register (address 3'b001) with countdown value data D, where D is nonzero, and run bit R
    When one clock edge occurs
    Then the timer BCD countdown value should equal D
    And "timer" bit 25 (tripped) should equal 0
    And "timer" bit 24 (running) should equal R

  @timer @reload
  Formal Scenario: Writing zero while stopped and timer already zero reloads from tm_start
    Given "timer" bit 24 (running) is 0
    And the timer BCD countdown value holds BCD zero
    And "tm_start" holds value ST
    And a write to the Timer register (address 3'b001) with countdown value data BCD zero
    When one clock edge occurs
    Then the timer BCD countdown value should equal ST

  # ---------------------------------------------------------------------
  # Stopwatch
  # ---------------------------------------------------------------------

  @stopwatch @run-control
  Formal Scenario: Writing bit0 controls stopwatch run/stop state
    Given a write to the Stopwatch register (address 3'b010) with bit0 value R
    When one clock edge occurs
    Then "stopwatch" bit 0 (running) should equal R

  @stopwatch @advance
  Formal Scenario: Running stopwatch advances elapsed time on a one-second event
    Given "stopwatch" bit 0 (running) is 1
    And the stopwatch BCD elapsed time holds value E
    And a one-second event occurs on this cycle
    When one clock edge occurs
    Then the stopwatch BCD elapsed time should equal E advanced by one BCD second

  @stopwatch @clear-while-stopped
  Formal Scenario: Clear request while stopped clears the stopwatch
    Given "stopwatch" bit 0 (running) is 0
    And a write to the Stopwatch register (address 3'b010) with clear bit 1 and run bit 0
    When one clock edge occurs
    Then the stopwatch BCD elapsed time should equal 0
    And "stopwatch" bit 0 (running) should equal 0

  @stopwatch @clear-on-stop-transition
  Formal Scenario: Clear request that also stops the stopwatch in the same write is honored
    Given "stopwatch" bit 0 (running) is 1
    And a write to the Stopwatch register (address 3'b010) with clear bit 1 and run bit 0
    When one clock edge occurs
    Then the stopwatch BCD elapsed time should equal 0
    And "stopwatch" bit 0 (running) should equal 0

  @stopwatch @clear-ignored-while-running
  Formal Scenario: Clear request is ignored if stopwatch remains running after the write
    Given "stopwatch" bit 0 (running) is 1
    And the stopwatch BCD elapsed time holds value E
    And a write to the Stopwatch register (address 3'b010) with clear bit 1 and run bit 1
    When one clock edge occurs
    Then the stopwatch BCD elapsed time should not be forced to zero by this write

  # ---------------------------------------------------------------------
  # Alarm
  # ---------------------------------------------------------------------

  @alarm @masked-write @seconds
  Formal Scenario: Writing alarm seconds field 8'hFF leaves alarm seconds unchanged
    Given the alarm seconds field holds BCD value SS
    And a write to the Alarm register (address 3'b011) with seconds field 8'hFF
    When one clock edge occurs
    Then the alarm seconds field should remain equal to SS

  @alarm @masked-write @minutes
  Formal Scenario: Writing alarm minutes field 8'hFF leaves alarm minutes unchanged
    Given the alarm minutes field holds BCD value MM
    And a write to the Alarm register (address 3'b011) with minutes field 8'hFF
    When one clock edge occurs
    Then the alarm minutes field should remain equal to MM

  @alarm @masked-write @hours
  Formal Scenario: Writing alarm hours field 6'h3F leaves alarm hours unchanged
    Given the alarm hours field holds BCD value HH
    And a write to the Alarm register (address 3'b011) with hours field 6'h3F
    When one clock edge occurs
    Then the alarm hours field should remain equal to HH

  @alarm @trip
  Formal Scenario: Alarm trips on time match transition when enabled
    Given "al_enabled" is 1
    And "alarm_time" holds value AT
    And "ck_last_clock" equals AT on this cycle
    And "ck_last_clock" did not equal AT on the previous cycle
    When one clock edge occurs
    Then "al_tripped" should be set to 1
    And "al_int" should be asserted for exactly this cycle

  @alarm @no-repeat-trip
  Formal Scenario: Alarm does not re-trip while clock remains matched at the same level
    Given "al_enabled" is 1
    And "alarm_time" holds value AT
    And "ck_last_clock" equals AT on this cycle
    And "ck_last_clock" equaled AT on the previous cycle
    When one clock edge occurs
    Then "al_int" should not be asserted on this cycle

  @alarm @clear-by-write
  Formal Scenario: Software write clears al_tripped
    Given "al_tripped" is 1
    And a write to the Alarm register (address 3'b011) with tripped-clear bit 1
    When one clock edge occurs
    Then "al_tripped" should equal 0

  @alarm @clear-by-disable
  Formal Scenario: Disabling alarm clears al_tripped
    Given "al_tripped" is 1
    And a write to the Alarm register (address 3'b011) with enable bit 0
    When one clock edge occurs
    Then "al_enabled" should equal 0
    And "al_tripped" should equal 0

  # ---------------------------------------------------------------------
  # Time hack capture
  # ---------------------------------------------------------------------

  @hack @capture
  Formal Scenario: Hack strobe captures wall clock time and fractional accumulator
    Given "i_hack" is 1
    And "clock" upper 22 bits hold value CV
    And "ck_sub" holds value S
    And "ck_counter" holds value C
    And no carry is active on this cycle
    When one clock edge occurs
    Then "hack_time" should equal the concatenation of CV and S
    And "hack_counter" should equal C

  @hack @carry-alignment
  Formal Scenario: Hack capture with active carry aligns on the next cycle
    Given "i_hack" is 1
    And a carry is active at hack capture time
    When one clock edge occurs
    Then a follow-up update should align "hack_time" and "hack_counter" on the next cycle

  @hack @register-read
  Formal Scenario: Hack time register read returns padded capture value
    Given "hack_time" holds value HT
    And a read of the Hack Time register (address 3'b101)
    When one clock edge occurs
    Then "o_data" should equal the concatenation of 2'b00 and HT

  @hack @counter-high-read
  Formal Scenario: Hack counter high register read returns upper bits
    Given "hack_counter" holds value HC
    And a read of the Hack Counter High register (address 3'b110)
    When one clock edge occurs
    Then "o_data" should equal bits [39:8] of HC

  @hack @counter-low-read
  Formal Scenario: Hack counter low register read returns lower bits padded with zeros
    Given "hack_counter" holds value HC
    And a read of the Hack Counter Low register (address 3'b111)
    When one clock edge occurs
    Then "o_data" should equal the concatenation of bits [7:0] of HC and 24'h000000

  # ---------------------------------------------------------------------
  # Interrupt behavior
  # ---------------------------------------------------------------------

  @interrupt @or-logic
  Formal Scenario: Interrupt output is the logical OR of timer and alarm pulses
    Given "tm_int" holds value TI
    And "al_int" holds value AI
    Then "o_interrupt" should equal (TI or AI)

  @interrupt @pulse-only
  Formal Scenario: Interrupt is a single-cycle pulse for countdown expiration
    Given "tm_int" is asserted for exactly one cycle due to countdown expiration
    And "al_int" is 0
    When one clock edge occurs
    Then "o_interrupt" should be asserted for exactly that one cycle and deasserted on the following cycle

  @interrupt @pulse-only
  Formal Scenario: Interrupt is a single-cycle pulse for alarm trip
    Given "al_int" is asserted for exactly one cycle due to alarm match transition
    And "tm_int" is 0
    When one clock edge occurs
    Then "o_interrupt" should be asserted for exactly that one cycle and deasserted on the following cycle

  # ---------------------------------------------------------------------
  # Display and LED outputs
  # ---------------------------------------------------------------------

  @display @mode-select
  Formal Scenario: Seven-segment output reflects wall-clock hours/minutes in mode 0
    Given the clock register display-mode field equals 0
    And "timer" bit 25 (tripped) is 0
    And "al_tripped" is 0
    And the wall clock hours field holds HH and minutes field holds MM
    When one clock edge occurs
    Then "o_sseg" should encode HH and MM according to the wall-clock hours/minutes view

  @display @mode-select
  Formal Scenario: Seven-segment output reflects timer view in mode 1
    Given the clock register display-mode field equals 1
    And "timer" bit 25 (tripped) is 0
    And "al_tripped" is 0
    And the timer BCD countdown value holds T
    When one clock edge occurs
    Then "o_sseg" should encode T according to the timer-centric view

  @display @mode-select
  Formal Scenario: Seven-segment output reflects stopwatch view in mode 2
    Given the clock register display-mode field equals 2
    And "timer" bit 25 (tripped) is 0
    And "al_tripped" is 0
    And the stopwatch BCD elapsed time holds E
    When one clock edge occurs
    Then "o_sseg" should encode E according to the stopwatch-centric view

  @display @mode-select
  Formal Scenario: Seven-segment output reflects wall-clock minutes/seconds in mode 3
    Given the clock register display-mode field equals 3
    And "timer" bit 25 (tripped) is 0
    And "al_tripped" is 0
    And the wall clock minutes field holds MM and seconds field holds SS
    When one clock edge occurs
    Then "o_sseg" should encode MM and SS according to the wall-clock minutes/seconds view

  @display @blink
  Formal Scenario: Seven-segment output blanks in blink pattern when timer alarm is active
    Given "timer" bit 25 (tripped) is 1
    When one clock edge occurs
    Then "o_sseg" should follow the blink-blank pattern instead of the normal digit encoding

  @display @blink
  Formal Scenario: Seven-segment output blanks in blink pattern when alarm trip is active
    Given "al_tripped" is 1
    When one clock edge occurs
    Then "o_sseg" should follow the blink-blank pattern instead of the normal digit encoding

  @led @normal-mode
  Formal Scenario: LED pattern derives from running progression in normal mode
    Given "timer" bit 25 (tripped) is 0
    And "al_tripped" is 0
    And the internal running pattern holds value P synchronized to clock progression
    When one clock edge occurs
    Then "o_led" should equal P

  @led @alarm-mode
  Formal Scenario: All LEDs flash together when timer or alarm is tripped
    Given "timer" bit 25 (tripped) is 1 or "al_tripped" is 1
    When one clock edge occurs
    Then "o_led" should follow the all-flash pattern

  # ---------------------------------------------------------------------
  # Clock speed calibration register
  # ---------------------------------------------------------------------

  @ckspeed @readwrite
  Formal Scenario: Clock speed register write updates ckspeed and read returns it
    Given a write to the Clock Speed register (address 3'b100) with data value K
    When one clock edge occurs
    And a subsequent read of the Clock Speed register (address 3'b100) occurs
    Then "o_data" should equal K