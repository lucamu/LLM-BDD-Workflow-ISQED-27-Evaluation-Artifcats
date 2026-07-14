Feature: Programmable Interval Timer (PIT) Formal Verification

  Formal specification for `pit_top`, a WISHBONE slave programmable interval
  timer with programmable modulo counter, prescaler, and master/slave
  synchronization. All scenarios are expressed as symbolic properties over
  arbitrary valid input values, checked on each rising edge of `wb_clk_i`.

  Background:
    Given the design is clocked on the rising edge of "wb_clk_i"
    And "arst_i" is the asynchronous reset with active level "ARST_LVL"
    And "wb_rst_i" is the synchronous reset input
    And parameters "ARST_LVL", "PRE_COUNT_SIZE", "COUNT_SIZE", "DECADE_CNTR", "NO_PRESCALE", "SINGLE_CYCLE", "DWIDTH" hold arbitrary fixed valid values
    And module selection is defined as "wb_cyc_i" AND "wb_stb_i"

  # -----------------------------------------------------------------------
  # Reset behavior
  # -----------------------------------------------------------------------

  @reset @async
  Formal Scenario: Asynchronous reset clears control and status state
    Given "arst_i" is asserted to its active level "ARST_LVL"
    When one clock edge occurs
    Then "cnt_flag_o" should be 0
    And "pit_irq_o" should be 0
    And "cnt_sync_o" should be 0
    And the internal "SLAVE" bit should be 0
    And the internal "PRE_SCALR" value should be 0
    And the internal "ENA_INT" bit should be 0
    And the internal "CNT_EN" bit should be 0
    And the internal "MOD_VAL" register should be 0
    And the internal main counter "cnt_n" should be 1

  @reset @sync
  Formal Scenario: Synchronous reset clears control and status state
    Given "arst_i" is deasserted from its active level
    And "wb_rst_i" is asserted
    When one clock edge occurs
    Then "cnt_flag_o" should be 0
    And "pit_irq_o" should be 0
    And "cnt_sync_o" should be 0
    And the internal "SLAVE" bit should be 0
    And the internal "PRE_SCALR" value should be 0
    And the internal "ENA_INT" bit should be 0
    And the internal "CNT_EN" bit should be 0
    And the internal "MOD_VAL" register should be 0
    And the internal main counter "cnt_n" should be 1

  @reset @pit_o
  Formal Scenario: pit_o is deasserted during synchronous reset
    Given "wb_rst_i" is asserted
    When one clock edge occurs
    Then "pit_o" should be 0

  # -----------------------------------------------------------------------
  # WISHBONE acknowledge protocol
  # -----------------------------------------------------------------------

  @wishbone @ack @default_mode
  Formal Scenario: Acknowledge is delayed by one wait state in default mode
    Given "SINGLE_CYCLE" is 0
    And no reset is asserted
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    When one clock edge occurs
    Then "wb_ack_o" should be 0
    When a second clock edge occurs with "wb_cyc_i" 1 and "wb_stb_i" 1
    Then "wb_ack_o" should be 1

  @wishbone @ack @single_cycle
  Formal Scenario: Acknowledge follows access immediately in single-cycle mode
    Given "SINGLE_CYCLE" is 1
    And no reset is asserted
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    When one clock edge occurs
    Then "wb_ack_o" should be 1

  @wishbone @ack @deselect
  Formal Scenario: Acknowledge is deasserted when the module is not selected
    Given no reset is asserted
    And ("wb_cyc_i" is 0 OR "wb_stb_i" is 0)
    When one clock edge occurs
    Then "wb_ack_o" should be 0

  # -----------------------------------------------------------------------
  # Register write decode - DWIDTH=16
  # -----------------------------------------------------------------------

  @registers @write @dwidth16 @cntrl
  Formal Scenario: CNTRL register write updates control bits (DWIDTH=16)
    Given "DWIDTH" is 16
    And no reset is asserted
    And the module is selected with "wb_we_i" 1
    And "wb_adr_i" is address 0x0 for CNTRL
    And "wb_dat_i" holds symbolic control value CTRL
    When the write is acknowledged
    Then the internal "SLAVE" bit should equal bit 15 of CTRL
    And the internal "PRE_SCALR" value should equal bits [11:8] of CTRL
    And the internal "ENA_INT" bit should equal bit 1 of CTRL
    And the internal "CNT_EN" bit should equal bit 0 of CTRL
    And "pit_flg_clr" should equal bit 2 of CTRL

  @registers @write @dwidth16 @mod
  Formal Scenario: MOD register write updates modulo value (DWIDTH=16)
    Given "DWIDTH" is 16
    And no reset is asserted
    And the module is selected with "wb_we_i" 1
    And "wb_adr_i" is address 0x1 for MOD
    And "wb_dat_i" holds symbolic value M
    When the write is acknowledged
    Then the internal "MOD_VAL" register should equal M

  # -----------------------------------------------------------------------
  # Register write decode - DWIDTH=8
  # -----------------------------------------------------------------------

  @registers @write @dwidth8 @cntrl0
  Formal Scenario: CNTRL_0 write updates low control byte (DWIDTH=8)
    Given "DWIDTH" is 8
    And no reset is asserted
    And the module is selected with "wb_we_i" 1
    And "wb_adr_i" is address 0x0 for CNTRL_0
    And "wb_dat_i" holds symbolic byte value B
    When the write is acknowledged
    Then the internal "ENA_INT" bit should equal bit 1 of B
    And the internal "CNT_EN" bit should equal bit 0 of B
    And "pit_flg_clr" should equal bit 2 of B
    And the internal "SLAVE" bit and "PRE_SCALR" value should remain unchanged

  @registers @write @dwidth8 @cntrl1
  Formal Scenario: CNTRL_1 write updates high control byte (DWIDTH=8)
    Given "DWIDTH" is 8
    And no reset is asserted
    And the module is selected with "wb_we_i" 1
    And "wb_adr_i" is address 0x1 for CNTRL_1
    And "wb_dat_i" holds symbolic byte value B
    When the write is acknowledged
    Then the internal "SLAVE" bit should equal bit 7 of B
    And the internal "PRE_SCALR" value should equal bits [3:0] of B
    And the internal "ENA_INT" bit and "CNT_EN" bit should remain unchanged

  @registers @write @dwidth8 @mod_bytes
  Formal Scenario: MOD_0 and MOD_1 writes update respective modulo bytes (DWIDTH=8)
    Given "DWIDTH" is 8
    And no reset is asserted
    And the module is selected with "wb_we_i" 1
    And "wb_adr_i" is address 0x2 for MOD_0
    And "wb_dat_i" holds symbolic byte value LOW
    When the write is acknowledged
    Then the low byte of the internal "MOD_VAL" register should equal LOW
    And the high byte of the internal "MOD_VAL" register should remain unchanged

  # -----------------------------------------------------------------------
  # Register read behavior
  # -----------------------------------------------------------------------

  @registers @read @dwidth16 @cntrl
  Formal Scenario: CNTRL register read reflects current control/status (DWIDTH=16)
    Given "DWIDTH" is 16
    And no reset is asserted
    And the module is selected with "wb_we_i" 0
    And "wb_adr_i" is address 0x0 for CNTRL
    And the internal "SLAVE" bit holds symbolic value S
    And the internal "PRE_SCALR" value holds symbolic value P
    And "cnt_flag_o" holds symbolic value F
    And the internal "ENA_INT" bit holds symbolic value E
    And the internal "CNT_EN" bit holds symbolic value C
    When the read is acknowledged
    Then bit 15 of "wb_dat_o" should equal S
    And bits [11:8] of "wb_dat_o" should equal P
    And bit 14 of "wb_dat_o" should equal parameter "DECADE_CNTR"
    And bit 13 of "wb_dat_o" should equal parameter "NO_PRESCALE"
    And bit 2 of "wb_dat_o" should equal F
    And bit 1 of "wb_dat_o" should equal E
    And bit 0 of "wb_dat_o" should equal C

  @registers @read @dwidth16 @mod
  Formal Scenario: MOD register read reflects stored modulo value (DWIDTH=16)
    Given "DWIDTH" is 16
    And no reset is asserted
    And the module is selected with "wb_we_i" 0
    And "wb_adr_i" is address 0x1 for MOD
    And the internal "MOD_VAL" register holds symbolic value M
    When the read is acknowledged
    Then "wb_dat_o" should equal M

  @registers @read @dwidth16 @cnt
  Formal Scenario: CNT register read reflects current counter value (DWIDTH=16)
    Given "DWIDTH" is 16
    And no reset is asserted
    And the module is selected with "wb_we_i" 0
    And "wb_adr_i" is address 0x2 for CNT
    And the internal main counter "cnt_n" holds symbolic value N
    When the read is acknowledged
    Then "wb_dat_o" should equal N

  # -----------------------------------------------------------------------
  # CNTRL semantics: SLAVE/master enable source
  # -----------------------------------------------------------------------

  @cntrl @slave_mode
  Formal Scenario: Slave mode routes ext_sync_i to the counter enable
    Given no reset is asserted
    And the internal "SLAVE" bit is 1
    And "ext_sync_i" holds symbolic value X
    When one clock edge occurs
    Then "counter_sync" should equal X

  @cntrl @master_mode
  Formal Scenario: Master mode routes CNT_EN to the counter enable
    Given no reset is asserted
    And the internal "SLAVE" bit is 0
    And the internal "CNT_EN" bit holds symbolic value C
    When one clock edge occurs
    Then "counter_sync" should equal C
    And "cnt_sync_o" should equal C

  @cntrl @slave_local_writeback
  Formal Scenario: CNT_EN writes still update cnt_sync_o in slave mode
    Given no reset is asserted
    And the internal "SLAVE" bit is 1
    And a write to "CNT_EN" sets it to symbolic value C
    When one clock edge occurs
    Then "cnt_sync_o" should equal C
    And "counter_sync" should not necessarily equal C

  # -----------------------------------------------------------------------
  # Flag and interrupt behavior
  # -----------------------------------------------------------------------

  @flag @clear
  Formal Scenario: Writing FLAG=1 clears the sticky rollover flag
    Given no reset is asserted
    And "cnt_flag_o" is currently 1
    And "pit_flg_clr" is asserted via a CNTRL write with bit 2 equal to 1
    When one clock edge occurs
    Then "cnt_flag_o" should be 0

  @flag @disable_clears
  Formal Scenario: Disabling counting clears the sticky rollover flag
    Given no reset is asserted
    And "cnt_flag_o" is currently 1
    And "counter_sync" transitions from 1 to 0
    When one clock edge occurs
    Then "cnt_flag_o" should be 0

  @flag @set_on_rollover
  Formal Scenario: Rollover sets the sticky flag
    Given no reset is asserted
    And "counter_sync" is 1
    And a qualified rollover occurs on this cycle
    When one clock edge occurs
    Then "cnt_flag_o" should be 1

  @flag @sticky
  Formal Scenario: Flag remains set without a clear request or disable
    Given no reset is asserted
    And "cnt_flag_o" is currently 1
    And "pit_flg_clr" is 0
    And "counter_sync" remains 1
    When one clock edge occurs
    Then "cnt_flag_o" should be 1

  @irq
  Formal Scenario: pit_irq_o tracks flag gated by interrupt enable
    Given no reset is asserted
    And "cnt_flag_o" holds symbolic value F
    And the internal "ENA_INT" bit holds symbolic value E
    When one clock edge occurs
    Then "pit_irq_o" should equal F AND E

  # -----------------------------------------------------------------------
  # Prescaler decode behavior
  # -----------------------------------------------------------------------

  @prescaler @bypass
  Formal Scenario: NO_PRESCALE bypasses prescaler division
    Given "NO_PRESCALE" is 1
    And no reset is asserted
    And "counter_sync" is 1
    When one clock edge occurs
    Then "prescale_out" should be 1 on every enabled clock cycle

  @prescaler @binary_decode
  Formal Scenario: Binary decode divisor selects power-of-two division
    Given "NO_PRESCALE" is 0
    And "DECADE_CNTR" is 0
    And no reset is asserted
    And the internal "PRE_SCALR" value holds symbolic value D
    When "counter_sync" is 1 for the divisor-defined number of cycles equal to 2 raised to D
    Then "prescale_out" should pulse once per that number of cycles

  @prescaler @decade_decode
  Formal Scenario: Decade decode divisor selects decade-style division
    Given "NO_PRESCALE" is 0
    And "DECADE_CNTR" is 1
    And no reset is asserted
    And the internal "PRE_SCALR" value holds symbolic value D constrained to the range 0 to 3
    When "counter_sync" is 1 for the divisor-defined number of cycles equal to 2 raised to D
    Then "prescale_out" should pulse once per that number of cycles

  @prescaler @readback
  Formal Scenario: CNTRL readback bits mirror prescaler mode parameters
    Given no reset is asserted
    And the module is selected with "wb_we_i" 0
    And "wb_adr_i" is address 0x0 for CNTRL
    When the read is acknowledged
    Then bit 14 of "wb_dat_o" should equal parameter "DECADE_CNTR"
    And bit 13 of "wb_dat_o" should equal parameter "NO_PRESCALE"

  # -----------------------------------------------------------------------
  # Main counter and rollover behavior
  # -----------------------------------------------------------------------

  @counter @increment
  Formal Scenario: Main counter increments on qualified prescale event
    Given no reset is asserted
    And "counter_sync" is 1
    And "prescale_out" is 1
    And the internal main counter "cnt_n" holds symbolic value N
    And the internal "MOD_VAL" register holds symbolic value M constrained to N + 1 not equal M
    When one clock edge occurs
    Then the internal main counter "cnt_n" should equal N + 1

  @counter @hold_no_prescale_event
  Formal Scenario: Main counter holds when prescale_out is not asserted
    Given no reset is asserted
    And "counter_sync" is 1
    And "prescale_out" is 0
    And the internal main counter "cnt_n" holds symbolic value N
    When one clock edge occurs
    Then the internal main counter "cnt_n" should equal N

  @counter @hold_when_disabled
  Formal Scenario: Main counter holds when counting is disabled
    Given no reset is asserted
    And "counter_sync" is 0
    And the internal main counter "cnt_n" holds symbolic value N
    When one clock edge occurs
    Then the internal main counter "cnt_n" should equal N

  @counter @rollover
  Formal Scenario: Main counter rolls over when reaching MOD_VAL
    Given no reset is asserted
    And "counter_sync" is 1
    And "prescale_out" is 1
    And the internal main counter "cnt_n" equals the internal "MOD_VAL" register minus 1
    And the internal "MOD_VAL" register is greater than 1
    When one clock edge occurs
    Then the internal main counter "cnt_n" should reinitialize to its start value
    And "pit_o" should be 1
    And "cnt_flag_o" should be 1

  @counter @min_period
  Formal Scenario: MOD_VAL of 0 or 1 produces minimum-period rollover behavior
    Given no reset is asserted
    And "counter_sync" is 1
    And "prescale_out" is 1
    And the internal "MOD_VAL" register is 0 OR the internal "MOD_VAL" register is 1
    When one clock edge occurs
    Then "pit_o" should be 1 every qualified prescale cycle

  @counter @pulse_width
  Formal Scenario: pit_o pulse is exactly one clock cycle wide
    Given no reset is asserted
    And "pit_o" is 1 at the current cycle
    And no new rollover condition is qualified on the next cycle
    When one clock edge occurs
    Then "pit_o" should be 0

  @counter @pit_o_gated_by_enable
  Formal Scenario: pit_o cannot assert while counting is disabled
    Given no reset is asserted
    And "counter_sync" is 0
    When one clock edge occurs
    Then "pit_o" should be 0

  @counter @pit_o_gated_by_reset
  Formal Scenario: pit_o cannot assert during synchronous reset
    Given "wb_rst_i" is asserted
    When one clock edge occurs
    Then "pit_o" should be 0

  # -----------------------------------------------------------------------
  # Constraint / interface consistency checks
  # -----------------------------------------------------------------------

  @constraints @wb_sel_unused
  Formal Scenario: wb_sel_i has no effect on register access decode
    Given no reset is asserted
    And the module is selected with "wb_we_i" holding symbolic value WE
    And "wb_sel_i" holds two distinct symbolic values SEL1 and SEL2 on separate evaluations
    When the access is acknowledged under each value of "wb_sel_i"
    Then "wb_ack_o" and "wb_dat_o" should be identical regardless of "wb_sel_i"