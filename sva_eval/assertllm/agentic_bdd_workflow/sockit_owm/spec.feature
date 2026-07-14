Feature: sockit_owm 1-Wire Master Controller

  Formal verification specification for the sockit_owm 1-wire protocol master,
  covering CPU bus interface, control/status register semantics, clock dividers,
  line multiplexing, power control, and 1-wire cycle state machine timing.

  Background:
    Given a synchronous clock "clk"
    And an active-high synchronous reset "rst"
    And the design parameter OVD_E indicates overdrive support enable
    And the design parameter CDR_E indicates clock divider register enable
    And the design parameter OWN indicates the number of 1-wire lines
    And on reset all internal registers are set to their defined reset values
    And the control/status register bit 6 "irq" resets to 0
    And the control/status register bit 3 "cyc" resets to 0
    And the control/status register bit 4 "pwr" resets to 0
    And the select register resets to 0
    And the power register resets to all zeros

  # -----------------------------------------------------------------------
  # Bus interface basic behavior
  # -----------------------------------------------------------------------

  @bus @write
  Formal Scenario: Bus write updates control/status register on same cycle
    Given bus_wen is 1
    And bus_adr selects the control/status register
    And bus_wdt is a value W
    When a clock edge occurs
    Then the control/status register should be updated to W in the next cycle

  @bus @read
  Formal Scenario: Bus read returns current control/status register value
    Given bus_ren is 1
    And bus_adr selects the control/status register
    And the control/status register currently holds value S
    When a clock edge occurs
    Then bus_rdt should equal S in the same cycle that bus_ren is asserted

  @bus @mutual_exclusion
  Formal Scenario: Bus write and read are single-cycle and non-overlapping in effect
    Given bus_wen is 1
    And bus_ren is 0
    When a clock edge occurs
    Then bus_rdt should not be driven by the write data of the same cycle
    And the write should take effect only on the next clock edge

  @bus @waitrequest
  Formal Scenario: Bus never asserts wait request
    Given any value of bus_wen or bus_ren
    Then bus_waitrequest should always equal constant 0

  # -----------------------------------------------------------------------
  # Interrupt request behavior
  # -----------------------------------------------------------------------

  @irq @set
  Formal Scenario: Interrupt request is set at end of 1-wire cycle
    Given the control/status register bit cyc is 1 indicating a cycle in progress
    And the internal cycle-done condition becomes true
    When a clock edge occurs
    Then bus_irq should be set to 1 in the next cycle
    And the control/status register bit irq should be set to 1

  @irq @clear
  Formal Scenario: Interrupt request is cleared by a status register read
    Given the control/status register bit irq is 1
    And bus_ren is 1
    And bus_adr selects the control/status register
    When a clock edge occurs
    Then the control/status register bit irq should be cleared to 0 in the next cycle

  @irq @enable
  Formal Scenario: Interrupt output reflects ien AND irq
    Given the control/status register bit ien is a value IEN
    And the control/status register bit irq is a value IRQ
    Then bus_irq should equal IEN AND IRQ

  @irq @no_spurious
  Formal Scenario: Interrupt is not asserted while a cycle is in progress
    Given the control/status register bit cyc is 1
    And the internal cycle-done condition is false
    Then bus_irq should remain 0

  # -----------------------------------------------------------------------
  # Control/status register: cycle initiation and status
  # -----------------------------------------------------------------------

  @ctrl @cyc_start
  Formal Scenario: Writing cyc=1 starts a new 1-wire cycle
    Given no 1-wire cycle is currently in progress
    And a bus write occurs with cyc bit set to 1
    And rst bit is a value RST
    And ovd bit is a value OVD
    And dat bit is a value DAT
    When a clock edge occurs
    Then the internal state machine should begin a new cycle
    And the cycle type selected should correspond to RST, OVD, DAT combination
    And the control/status register cyc bit should read 1 while the cycle is active

  @ctrl @cyc_abort
  Formal Scenario: Writing cyc=1 during an active cycle restarts the cycle
    Given the control/status register bit cyc currently is 1 indicating a cycle in progress
    And a bus write occurs with cyc bit set to 1 and new rst/ovd/dat values R2,O2,D2
    When a clock edge occurs
    Then the current cycle counter should be reloaded with the values corresponding to R2, O2, D2
    And the previous cycle should be considered aborted

  @ctrl @cyc_status
  Formal Scenario: cyc bit reads 1 exactly while a 1-wire cycle is active
    Given a 1-wire cycle has been started
    Then the control/status register cyc bit should equal 1 while the internal counter is non-zero
    And the control/status register cyc bit should equal 0 once the internal counter reaches zero

  @ctrl @dat_write_semantics
  Formal Scenario: dat bit written selects write-0 or write-1/read slot
    Given cyc is written as 1
    And rst is 0
    And dat is a value D
    When a clock edge occurs
    Then if D equals 0 the state machine should perform a write-0 timing slot
    And if D equals 1 the state machine should perform a write-1-or-read timing slot

  @ctrl @dat_read_semantics
  Formal Scenario: dat bit read reflects sampled 1-wire line or presence status
    Given a data or reset cycle has completed
    And the sampled 1-wire line value was V
    Then the control/status register dat bit should equal V after the cycle completes

  @ctrl @rst_bit
  Formal Scenario: rst bit selects reset/presence cycle type
    Given cyc is written as 1
    And rst is a value R
    Then if R equals 1 the state machine should perform a reset-and-presence-detect cycle
    And if R equals 0 the state machine should perform a data bit cycle

  @ctrl @ovd_bit
  Formal Scenario: ovd bit selects overdrive timing base
    Given cyc is written as 1
    And ovd is a value O
    Then if O equals 1 the state machine should use the overdrive base time period
    And if O equals 0 the state machine should use the normal base time period

  @ctrl @ovd_disabled
  Formal Scenario: Overdrive mode is ignored when OVD_E parameter is 0
    Given OVD_E equals 0
    And cyc is written as 1 with ovd equal to 1
    Then the state machine should use the normal mode base time period regardless of ovd

  # -----------------------------------------------------------------------
  # Cycle type timing selection (Table 12)
  # -----------------------------------------------------------------------

  @cycle @write0
  Formal Scenario: Write-0 cycle duration matches normal mode timing
    Given ovd is 0, rst is 0, dat is 0
    And cyc is written as 1
    Then the total cycle length in base periods should equal the write-0 slot duration tDATT for normal mode

  @cycle @write1read
  Formal Scenario: Write-1-or-read cycle duration matches normal mode timing
    Given ovd is 0, rst is 0, dat is 1
    And cyc is written as 1
    Then the total cycle length in base periods should equal the write-1-or-read slot duration tDATT for normal mode

  @cycle @reset
  Formal Scenario: Reset-and-presence cycle duration matches normal mode timing
    Given ovd is 0, rst is 1, dat is 0
    And cyc is written as 1
    Then the total cycle length in base periods should equal tRSTT for normal mode

  @cycle @idle_delay
  Formal Scenario: Timed idle delay cycle produces 1ms delay in normal mode
    Given ovd is 0, rst is 1, dat is 1
    And cyc is written as 1
    Then the total cycle length in base periods should equal tDLY for normal mode

  @cycle @overdrive_write0
  Formal Scenario: Overdrive write-0 cycle duration matches overdrive timing
    Given OVD_E equals 1
    And ovd is 1, rst is 0, dat is 0
    And cyc is written as 1
    Then the total cycle length in base periods should equal the write-0 slot duration for overdrive mode

  @cycle @overdrive_write1read
  Formal Scenario: Overdrive write-1-or-read cycle duration matches overdrive timing
    Given OVD_E equals 1
    And ovd is 1, rst is 0, dat is 1
    And cyc is written as 1
    Then the total cycle length in base periods should equal the write-1-or-read slot duration for overdrive mode

  @cycle @overdrive_reset
  Formal Scenario: Overdrive reset-and-presence cycle duration matches overdrive timing
    Given OVD_E equals 1
    And ovd is 1, rst is 1, dat is 0
    And cyc is written as 1
    Then the total cycle length in base periods should equal tRSTT for overdrive mode

  @cycle @overdrive_zero_delay
  Formal Scenario: Overdrive idle cycle produces zero-time delay
    Given OVD_E equals 1
    And ovd is 1, rst is 1, dat is 1
    And cyc is written as 1
    Then the total cycle length in base periods should equal 0

  # -----------------------------------------------------------------------
  # 1-wire line driver behavior during reset cycle
  # -----------------------------------------------------------------------

  @onewire @reset_low
  Formal Scenario: Reset cycle drives the line low for tRSTL then releases
    Given a reset-and-presence cycle has been started on line N
    Then owr_e[N] should be 1 for tRSTL base periods from cycle start
    And owr_e[N] should be 0 for the remaining tRSTH base periods of the cycle

  @onewire @presence_sample
  Formal Scenario: Presence status is sampled at tRSTP after the rising edge
    Given a reset-and-presence cycle is in progress on line N
    And the reset low phase has just ended
    And the sampled 1-wire input at the presence sample point is P
    Then the dat status bit at cycle completion should equal P

  # -----------------------------------------------------------------------
  # 1-wire line driver behavior during data slots
  # -----------------------------------------------------------------------

  @onewire @write0_slot
  Formal Scenario: Write-0 slot drives the line low for tDAT0 then releases for tREC
    Given a data cycle with dat equal to 0 has been started on line N
    Then owr_e[N] should be 1 for tDAT0 base periods from slot start
    And owr_e[N] should be 0 for the remaining tREC base periods of the slot

  @onewire @write1_read_slot
  Formal Scenario: Write-1-or-read slot drives the line low briefly then releases and samples
    Given a data cycle with dat equal to 1 has been started on line N
    Then owr_e[N] should be 1 for tDAT1 base periods from slot start
    And owr_e[N] should be 0 for the remainder of the slot
    And the input sample taken at tDATS after slot start should determine the resulting dat status bit

  @onewire @select_exclusivity
  Formal Scenario: Only the selected line is driven during a cycle
    Given the select register equals line index N
    And a 1-wire cycle is in progress
    Then owr_e[N] should follow the state machine drive pattern
    And owr_e for all lines other than N should remain 0

  # -----------------------------------------------------------------------
  # Power control
  # -----------------------------------------------------------------------

  @power @multi_line
  Formal Scenario: Power register directly controls owr_p when multiple lines exist
    Given OWN is greater than 1
    And the power register bit for line N equals PW
    Then owr_p[N] should equal PW

  @power @single_line
  Formal Scenario: pwr bit in control register controls owr_p when a single line exists
    Given OWN equals 1
    And the control/status register pwr bit equals PW
    Then owr_p[0] should equal PW

  @power @single_line_ignore_power_reg
  Formal Scenario: Power register writes ignored when only one line is implemented
    Given OWN equals 1
    And a bus write attempts to set the power register
    Then owr_p[0] should be controlled only by the control/status register pwr bit

  @power @multi_line_ignore_pwr_bit
  Formal Scenario: Control register pwr bit writes ignored when multiple lines exist
    Given OWN is greater than 1
    And a bus write attempts to set the control/status register pwr bit to PW
    Then owr_p should not change due to that write
    And owr_p should be determined solely by the power register

  @power @block_cycle
  Formal Scenario: A 1-wire cycle cannot be initiated on a line whose power is enabled
    Given owr_p for the selected line N is 1
    And a bus write attempts to set cyc to 1 on line N
    Then no new 1-wire cycle should start on line N while owr_p[N] is 1

  @power @read_reflects_selected_line
  Formal Scenario: Reading pwr bit reflects the power state of the currently selected line
    Given OWN is greater than 1
    And select equals N
    And power register bit N equals PW
    When the control/status register is read
    Then the pwr bit read value should equal PW

  # -----------------------------------------------------------------------
  # Line select multiplexing
  # -----------------------------------------------------------------------

  @select @basic
  Formal Scenario: Select register determines which line is active for a cycle
    Given a bus write sets select to a value SEL less than OWN
    And a subsequent bus write starts a 1-wire cycle
    Then the state machine should operate exclusively on line SEL

  @select @ignored_single_line
  Formal Scenario: Select register is ignored when only one line is implemented
    Given OWN equals 1
    And a bus write attempts to set select to any value
    Then the active line should always be line 0

  @select @reset_default
  Formal Scenario: Select defaults to line 0 after reset
    Given reset has just been asserted and deasserted
    Then the select register should equal 0

  # -----------------------------------------------------------------------
  # Clock divider registers
  # -----------------------------------------------------------------------

  @cdr @writable
  Formal Scenario: Clock divider registers are writable when CDR_E is enabled
    Given CDR_E equals 1
    And no 1-wire cycle is in progress
    And a bus write sets cdr_n to value N
    When a clock edge occurs
    Then the cdr_n register should equal N in the next cycle

  @cdr @readback
  Formal Scenario: Clock divider register read returns last written value when enabled
    Given CDR_E equals 1
    And cdr_o currently holds value O
    When cdr_o is read
    Then the read data should equal O

  @cdr @locked_during_cycle
  Formal Scenario: Clock divider registers must not change while a cycle is in progress
    Given CDR_E equals 1
    And a 1-wire cycle is currently in progress
    And a bus write attempts to modify cdr_n
    Then the cdr_n register should retain its prior value until the cycle completes

  @cdr @constant_when_disabled
  Formal Scenario: Clock divider registers are constant when CDR_E is disabled
    Given CDR_E equals 0
    And a bus write attempts to set cdr_n to any value
    Then cdr_n read value should always equal the CDR_N parameter constant
    And the write should have no effect

  @cdr @reset_value
  Formal Scenario: Clock divider registers reset to parameter defaults
    Given CDR_E equals 1
    And reset has just been asserted and deasserted
    Then cdr_n should equal the CDR_N parameter value
    And cdr_o should equal the CDR_O parameter value

  # -----------------------------------------------------------------------
  # Base time period pulse generator
  # -----------------------------------------------------------------------

  @clockgen @pulse_period
  Formal Scenario: Clock generator produces one pulse per base time period
    Given the active divider ratio register equals value CDR
    Then the pulse output should assert exactly once every CDR+1 clock cycles

  @clockgen @mode_select
  Formal Scenario: Clock generator selects normal or overdrive divider based on ovd
    Given the current cycle ovd bit equals value O
    Then if O equals 0 the clock generator should use cdr_n
    And if O equals 1 the clock generator should use cdr_o

  # -----------------------------------------------------------------------
  # State counter behavior
  # -----------------------------------------------------------------------

  @counter @decrement
  Formal Scenario: State counter decrements once per base time period pulse
    Given the state counter currently holds value C greater than 0
    And a base time period pulse occurs
    When a clock edge occurs
    Then the state counter should equal C minus 1 in the next cycle

  @counter @done
  Formal Scenario: Cycle completes when state counter reaches zero
    Given the state counter currently holds value 0
    Then the control/status register cyc bit should be 0
    And bus_irq eligibility for this cycle should be asserted per the irq scenarios

  @counter @idle_no_decrement
  Formal Scenario: State counter does not change without a base time period pulse
    Given the state counter currently holds value C
    And no base time period pulse occurs in the current cycle
    When a clock edge occurs
    Then the state counter should remain equal to C

  # -----------------------------------------------------------------------
  # Reset behavior
  # -----------------------------------------------------------------------

  @reset @registers
  Formal Scenario: Synchronous reset clears control and status register
    Given rst is asserted
    When a clock edge occurs
    Then the control/status register should equal its defined reset value 0 for all read/write bits except dat which is undefined

  @reset @no_cycle
  Formal Scenario: Synchronous reset forces no cycle in progress
    Given rst is asserted
    When a clock edge occurs
    Then the cyc bit should be 0
    And the state counter should be 0
    And bus_irq should be 0

  @reset @drivers_released
  Formal Scenario: Synchronous reset releases all 1-wire line drivers
    Given rst is asserted
    When a clock edge occurs
    Then owr_e for all lines should equal 0
    And owr_p for all lines should equal 0