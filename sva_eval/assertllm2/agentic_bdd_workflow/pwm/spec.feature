Feature: PWM Programmable Pulse-Width Modulation and Timer Core

  As a hardware designer
  I want to formally verify the PWM/Timer WISHBONE core
  So that register access, clock selection, PWM generation, timer behavior,
  and output gating conform to specification under all reachable states

  Background:
    Given the design is synchronous to "i_wb_clk"
    And "i_wb_rst" is the active-high synchronous reset for register/control logic and main counter path
    And the WISHBONE write enable condition is "i_wb_cyc & i_wb_stb & i_wb_we"
    And "o_wb_ack" is combinationally driven from "i_wb_stb"
    And register addresses are "Ctrl"=16'h0000, "Divisor"=16'h0002, "Period"=16'h0004, "DC"=16'h0006
    And Ctrl bit assignments are clk_sel=bit0, mode_pwm=bit1, run_en=bit2, timer_cont=bit3, out_en=bit4, timer_irq=bit5, dc_src_ext=bit6, ctr_rst=bit7

  # -----------------------------------------------------------------
  # Reset Behavior
  # -----------------------------------------------------------------

  @reset
  Formal Scenario: Global reset clears control registers
    Given "i_wb_rst" is asserted
    When one clock edge occurs
    Then the "Ctrl" register should be 8'h00
    And the "Divisor" register should be 16'h0000
    And the "Period" register should be 16'h0000
    And the "DC" register should be 16'h0000
    And "o_pwm" should be 0

  @reset
  Formal Scenario: Global reset clears main counter path regardless of Ctrl
    Given "i_wb_rst" is asserted
    And the main counter "ct" holds any value C before reset
    When one clock edge occurs
    Then the main counter "ct" should be 0
    And the timer event/irq state should be cleared

  @reset
  Formal Scenario: Ctrl[7] (ctr_rst) resets main counter path without resetting register contents
    Given "i_wb_rst" is deasserted
    And "Ctrl" bit 7 (ctr_rst) is set to 1
    And the main counter "ct" holds any value C before this cycle
    When one clock edge occurs
    Then the main counter "ct" should be 0
    And the timer event/irq state should be cleared
    And the "Divisor", "Period", "DC" registers should remain unchanged

  @reset
  Formal Scenario: Deasserting Ctrl[7] after reset allows normal counting to resume
    Given "i_wb_rst" is deasserted
    And "Ctrl" bit 7 (ctr_rst) was 1 in the previous cycle and is now driven to 0
    And "Ctrl" bit 2 (run_en) is 1
    When one clock edge occurs
    Then the main counter "ct" should increment from 0 according to the selected working clock

  # -----------------------------------------------------------------
  # WISHBONE Register Write/Read Behavior
  # -----------------------------------------------------------------

  @wishbone @write
  Formal Scenario: Write to Ctrl register updates control bits
    Given "i_wb_rst" is deasserted
    And "i_wb_cyc" is 1
    And "i_wb_stb" is 1
    And "i_wb_we" is 1
    And "i_wb_adr" is 16'h0000
    And "i_wb_data" holds symbolic value D
    When one clock edge occurs
    Then the "Ctrl" register bits [7:0] except bit 5 should equal D[7:0] except bit 5
    And "o_wb_ack" should equal "i_wb_stb" of that cycle

  @wishbone @write
  Formal Scenario: Write to Divisor register updates divisor value
    Given "i_wb_rst" is deasserted
    And "i_wb_cyc" is 1
    And "i_wb_stb" is 1
    And "i_wb_we" is 1
    And "i_wb_adr" is 16'h0002
    And "i_wb_data" holds symbolic value D
    When one clock edge occurs
    Then the "Divisor" register should equal D

  @wishbone @write
  Formal Scenario: Write to Period register updates period value
    Given "i_wb_rst" is deasserted
    And "i_wb_cyc" is 1
    And "i_wb_stb" is 1
    And "i_wb_we" is 1
    And "i_wb_adr" is 16'h0004
    And "i_wb_data" holds symbolic value D
    When one clock edge occurs
    Then the "Period" register should equal D

  @wishbone @write
  Formal Scenario: Write to DC register updates internal duty-cycle value
    Given "i_wb_rst" is deasserted
    And "i_wb_cyc" is 1
    And "i_wb_stb" is 1
    And "i_wb_we" is 1
    And "i_wb_adr" is 16'h0006
    And "i_wb_data" holds symbolic value D
    When one clock edge occurs
    Then the "DC" register should equal D

  @wishbone @write
  Formal Scenario: No write occurs when write-enable condition is false
    Given "i_wb_rst" is deasserted
    And at least one of "i_wb_cyc", "i_wb_stb", "i_wb_we" is 0
    And any register holds value R before this cycle
    And "i_wb_adr" and "i_wb_data" hold any symbolic values
    When one clock edge occurs
    Then that register should remain equal to R

  @wishbone @read
  Formal Scenario: Read from Ctrl address returns zero-extended control byte
    Given "i_wb_adr" is 16'h0000
    And the "Ctrl" register holds symbolic value C
    Then "o_wb_data" should equal {8'h00, C[7:0]}

  @wishbone @read
  Formal Scenario: Read from Divisor address returns divisor register
    Given "i_wb_adr" is 16'h0002
    And the "Divisor" register holds symbolic value V
    Then "o_wb_data" should equal V

  @wishbone @read
  Formal Scenario: Read from Period address returns period register
    Given "i_wb_adr" is 16'h0004
    And the "Period" register holds symbolic value P
    Then "o_wb_data" should equal P

  @wishbone @read
  Formal Scenario: Read from DC address returns duty-cycle register
    Given "i_wb_adr" is 16'h0006
    And the "DC" register holds symbolic value D
    Then "o_wb_data" should equal D

  @wishbone @read
  Formal Scenario: Read from undefined address returns zero
    Given "i_wb_adr" holds any value not equal to 16'h0000, 16'h0002, 16'h0004, or 16'h0006
    Then "o_wb_data" should equal 16'h0000

  @wishbone @ack
  Formal Scenario: Acknowledge mirrors strobe unconditionally
    Given "i_wb_stb" holds symbolic value S
    Then "o_wb_ack" should equal S

  # -----------------------------------------------------------------
  # Clock Selection and Down-Clocking
  # -----------------------------------------------------------------

  @clocking
  Formal Scenario: clk_sel selects WISHBONE clock as working clock source
    Given "Ctrl" bit 0 (clk_sel) is 0
    Then the working-clock source should be derived from "i_wb_clk"

  @clocking
  Formal Scenario: clk_sel selects external clock as working clock source
    Given "Ctrl" bit 0 (clk_sel) is 1
    Then the working-clock source should be derived from "i_extclk"

  @clocking
  Formal Scenario: Divisor of 0 bypasses down-clocking
    Given "Divisor" register equals 16'h0000
    Then the divider output clock should equal the selected working-clock source with no frequency reduction

  @clocking
  Formal Scenario: Divisor of 1 bypasses down-clocking
    Given "Divisor" register equals 16'h0001
    Then the divider output clock should equal the selected working-clock source with no frequency reduction

  @clocking
  Formal Scenario: Even divisor greater than one selects even-path divider
    Given "Divisor" register holds symbolic value N where N > 1 and N[0] equals 0
    Then the even-path divider module should be selected to generate the divided clock

  @clocking
  Formal Scenario: Odd divisor greater than one selects odd-path divider
    Given "Divisor" register holds symbolic value N where N > 1 and N[0] equals 1
    Then the odd-path divider module should be selected to generate the divided clock

  # -----------------------------------------------------------------
  # PWM Mode Behavior
  # -----------------------------------------------------------------

  @pwm
  Formal Scenario: PWM counter increments each working clock when running
    Given "Ctrl" bit 1 (mode_pwm) is 1
    And "Ctrl" bit 2 (run_en) is 1
    And "Ctrl" bit 7 (ctr_rst) is 0
    And the main counter "ct" holds value C before this cycle, with C less than the terminal count derived from "Period"
    When one working-clock edge occurs
    Then the main counter "ct" should equal C + 1

  @pwm
  Formal Scenario: PWM counter resets to zero at terminal count
    Given "Ctrl" bit 1 (mode_pwm) is 1
    And "Ctrl" bit 2 (run_en) is 1
    And "Ctrl" bit 7 (ctr_rst) is 0
    And the main counter "ct" equals the terminal count derived from "Period"
    When one working-clock edge occurs
    Then the main counter "ct" should equal 0

  @pwm
  Formal Scenario: PWM counter halts progression when run_en is 0
    Given "Ctrl" bit 1 (mode_pwm) is 1
    And "Ctrl" bit 2 (run_en) is 0
    And the main counter "ct" holds value C before this cycle
    When one working-clock edge occurs
    Then the main counter "ct" should remain equal to C

  @pwm
  Formal Scenario: PWM output source is high while counter is below internal duty-cycle value
    Given "Ctrl" bit 1 (mode_pwm) is 1
    And "Ctrl" bit 6 (dc_src_ext) is 0
    And the main counter "ct" holds value C
    And the "DC" register holds value D
    And C is less than D
    Then the internal output source "pts" should be 1

  @pwm
  Formal Scenario: PWM output source is low when counter is not below internal duty-cycle value
    Given "Ctrl" bit 1 (mode_pwm) is 1
    And "Ctrl" bit 6 (dc_src_ext) is 0
    And the main counter "ct" holds value C
    And the "DC" register holds value D
    And C is greater than or equal to D
    Then the internal output source "pts" should be 0

  @pwm
  Formal Scenario: PWM output source uses external duty cycle when dc_src_ext is 1
    Given "Ctrl" bit 1 (mode_pwm) is 1
    And "Ctrl" bit 6 (dc_src_ext) is 1
    And the main counter "ct" holds value C
    And the captured external duty-cycle register "extDC" holds value E
    And C is less than E
    Then the internal output source "pts" should be 1

  # -----------------------------------------------------------------
  # External Duty-Cycle Capture
  # -----------------------------------------------------------------

  @extdc
  Formal Scenario: External duty-cycle value is captured when i_valid_DC is asserted
    Given "i_valid_DC" is 1
    And "i_DC" holds symbolic value X
    When one working-clock edge occurs
    Then the captured external duty-cycle register "extDC" should equal X

  @extdc
  Formal Scenario: External duty-cycle register holds value when i_valid_DC is deasserted
    Given "i_valid_DC" is 0
    And the captured external duty-cycle register "extDC" holds value E before this cycle
    When one working-clock edge occurs
    Then the captured external duty-cycle register "extDC" should remain equal to E

  # -----------------------------------------------------------------
  # Timer Mode Behavior
  # -----------------------------------------------------------------

  @timer
  Formal Scenario: Timer counter increments each working clock when running
    Given "Ctrl" bit 1 (mode_pwm) is 0
    And "Ctrl" bit 2 (run_en) is 1
    And "Ctrl" bit 7 (ctr_rst) is 0
    And the main counter "ct" holds value C before this cycle, with C less than the terminal count derived from "Period"
    When one working-clock edge occurs
    Then the main counter "ct" should equal C + 1

  @timer
  Formal Scenario: Timer event asserted when terminal count reached
    Given "Ctrl" bit 1 (mode_pwm) is 0
    And "Ctrl" bit 2 (run_en) is 1
    And the main counter "ct" equals the terminal count derived from "Period"
    When one working-clock edge occurs
    Then the timer event/irq state should be asserted

  @timer
  Formal Scenario: One-shot timer holds event state after terminal count
    Given "Ctrl" bit 1 (mode_pwm) is 0
    And "Ctrl" bit 3 (timer_cont) is 0
    And the timer event/irq state is asserted
    And no clear request is issued
    When one working-clock edge occurs
    Then the timer event/irq state should remain asserted
    And the main counter "ct" should remain at the terminal count

  @timer
  Formal Scenario: Continuous timer restarts counting after terminal count
    Given "Ctrl" bit 1 (mode_pwm) is 0
    And "Ctrl" bit 3 (timer_cont) is 1
    And "Ctrl" bit 2 (run_en) is 1
    And the main counter "ct" equals the terminal count derived from "Period"
    When one working-clock edge occurs
    Then the main counter "ct" should equal 0
    And counting should continue on subsequent working-clock edges

  @timer
  Formal Scenario: Writing Ctrl bit 5 low requests timer interrupt clear
    Given "Ctrl" bit 1 (mode_pwm) is 0
    And the timer event/irq state is asserted
    And a WISHBONE write to "Ctrl" occurs with bit 5 driven to 0
    When the clear handshake completes
    Then the timer event/irq state should deassert

  @timer
  Formal Scenario: Timer counter halts progression when run_en is 0
    Given "Ctrl" bit 1 (mode_pwm) is 0
    And "Ctrl" bit 2 (run_en) is 0
    And the main counter "ct" holds value C before this cycle
    When one working-clock edge occurs
    Then the main counter "ct" should remain equal to C

  # -----------------------------------------------------------------
  # Output Gating
  # -----------------------------------------------------------------

  @output
  Formal Scenario: Output forced low when out_en is 0
    Given "Ctrl" bit 4 (out_en) is 0
    Then "o_pwm" should equal 0

  @output
  Formal Scenario: Output reflects internal source when out_en is 1
    Given "Ctrl" bit 4 (out_en) is 1
    And the internal output source "pts" holds symbolic value P
    Then "o_pwm" should equal P

  @output
  Formal Scenario: Timer interrupt indication visible on o_pwm only when out_en is 1
    Given "Ctrl" bit 1 (mode_pwm) is 0
    And "Ctrl" bit 4 (out_en) is 1
    And the timer event/irq state holds symbolic value T
    Then "o_pwm" should equal T

  @output
  Formal Scenario: Timer interrupt indication hidden on o_pwm when out_en is 0
    Given "Ctrl" bit 1 (mode_pwm) is 0
    And "Ctrl" bit 4 (out_en) is 0
    And the timer event/irq state holds symbolic value T
    Then "o_pwm" should equal 0

  # -----------------------------------------------------------------
  # Ctrl[5] Restricted Software Write Behavior
  # -----------------------------------------------------------------

  @ctrl5
  Formal Scenario: Ctrl bit 5 is not freely settable by software write to 1
    Given the timer event/irq state is deasserted
    And a WISHBONE write to "Ctrl" occurs with bit 5 driven to 1 and all other bits arbitrary
    When one clock edge occurs
    Then "Ctrl" bit 5 (timer_irq) should reflect only the timer-event logic state, not the written value of 1

  @ctrl5
  Formal Scenario: Ctrl bit 5 readback reflects timer event state independent of last write value
    Given the timer event/irq state holds symbolic value T
    And "i_wb_adr" is 16'h0000
    Then "o_wb_data" bit 5 should equal T