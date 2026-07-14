Feature: Digital PID Control Core with Wishbone B4 Slave Interface

  As a hardware verification engineer
  I want to formally verify the PID control core
  So that register access, arithmetic sequencing, overflow reporting, and output validity behave per specification

  Background:
    Given the design is in a synchronous clock domain driven by "i_clk"
    And "i_rst" is an asynchronous active-high reset
    And all formal properties are evaluated on the rising edge of "i_clk"
    And exactly one Wishbone width configuration is selected at build time

  # ---------------------------------------------------------------------
  # RESET BEHAVIOR
  # ---------------------------------------------------------------------

  @reset
  Formal Scenario: Reset clears all coefficient and data registers
    Given "i_rst" is asserted
    When one clock edge occurs
    Then register "Kp" should be 0
    And register "Ki" should be 0
    And register "Kd" should be 0
    And register "SP" should be 0
    And register "PV" should be 0
    And register "Kpd" should be 0
    And register "err[0]" should be 0
    And register "err[1]" should be 0
    And register "sigma" should be 0
    And register "un" should be 0
    And register "OF" should be 0

  @reset
  Formal Scenario: Reset is asynchronous and overrides ongoing operations
    Given the core is in an arbitrary internal state with a control-update sequence in progress
    When "i_rst" is asserted asynchronously, independent of clock edge
    Then all configuration and arithmetic state registers should transition to 0
    And "o_valid" should be asserted once reset settles

  # ---------------------------------------------------------------------
  # WISHBONE WRITE TRANSACTION SEMANTICS
  # ---------------------------------------------------------------------

  @wishbone @write
  Formal Scenario: Write request is recognized only with cyc, stb, and we asserted
    Given "i_wb_cyc" is 1
    And "i_wb_stb" is 1
    And "i_wb_we" is 1
    And "i_wb_adr" is address A
    And "i_wb_data" is value D
    When one clock edge occurs
    Then a write transaction to register at address A with data D should be accepted, subject to lock conditions

  @wishbone @write
  Formal Scenario: Write to Kp updates register and triggers Kpd update
    Given "i_wb_cyc" is 1, "i_wb_stb" is 1, "i_wb_we" is 1
    And "i_wb_adr" selects register "Kp"
    And "i_wb_data" is value D
    And register "Kp" is not locked
    When the write is acknowledged via "o_wb_ack"
    Then register "Kp" should become D
    And an internal Kpd-update sequence should be started

  @wishbone @write
  Formal Scenario: Write to Kd updates register and triggers Kpd update
    Given "i_wb_cyc" is 1, "i_wb_stb" is 1, "i_wb_we" is 1
    And "i_wb_adr" selects register "Kd"
    And "i_wb_data" is value D
    And register "Kd" is not locked
    When the write is acknowledged via "o_wb_ack"
    Then register "Kd" should become D
    And an internal Kpd-update sequence should be started

  @wishbone @write
  Formal Scenario: Write to PV updates register and triggers full control-update sequence
    Given "i_wb_cyc" is 1, "i_wb_stb" is 1, "i_wb_we" is 1
    And "i_wb_adr" selects register "PV"
    And "i_wb_data" is value D
    And register "PV" is not locked
    When the write is acknowledged via "o_wb_ack"
    Then register "PV" should become D
    And a PV-triggered control-update sequence should be started
    And "o_valid" should be deasserted while the sequence is in progress

  @wishbone @write
  Formal Scenario: Writing zero to RS clears sequence-related state
    Given "i_wb_cyc" is 1, "i_wb_stb" is 1, "i_wb_we" is 1
    And "i_wb_adr" selects register "RS"
    And "i_wb_data" is 0
    And register "RS" is not locked
    When the write is acknowledged via "o_wb_ack"
    Then register "err[0]" should become 0
    And register "un" should become 0
    And register "sigma" should become 0
    And register "OF" should become 0

  @wishbone @write
  Formal Scenario: Write acknowledge is delayed for locked registers
    Given "i_wb_cyc" is 1, "i_wb_stb" is 1, "i_wb_we" is 1
    And "i_wb_adr" selects a register R that is currently locked due to an active arithmetic-update sequence
    When the write request persists across clock edges
    Then "o_wb_ack" should remain deasserted until register R is unlocked
    And once R is unlocked, the write should complete with "o_wb_ack" asserted

  # ---------------------------------------------------------------------
  # WISHBONE READ TRANSACTION SEMANTICS
  # ---------------------------------------------------------------------

  @wishbone @read
  Formal Scenario: Read request is recognized only with cyc and stb asserted and we deasserted
    Given "i_wb_cyc" is 1
    And "i_wb_stb" is 1
    And "i_wb_we" is 0
    And "i_wb_adr" is address A
    When one clock edge occurs
    Then a read transaction from address A should return the corresponding register value on "o_wb_data", subject to lock conditions

  @wishbone @read
  Formal Scenario: Read of a valid register returns its current value with acknowledge
    Given "i_wb_cyc" is 1, "i_wb_stb" is 1, "i_wb_we" is 0
    And "i_wb_adr" selects register R holding value V
    And register R is not locked
    When the read completes
    Then "o_wb_data" should equal V, formatted per the selected bus width
    And "o_wb_ack" should be asserted

  @wishbone @read
  Formal Scenario: Out-of-range read returns zero with acknowledge
    Given "i_wb_cyc" is 1, "i_wb_stb" is 1, "i_wb_we" is 0
    And "i_wb_adr" is an address outside the implemented register map
    When one clock edge occurs
    Then "o_wb_data" should be 0
    And "o_wb_ack" should be asserted

  @wishbone @read
  Formal Scenario: Read acknowledge is delayed for locked registers
    Given "i_wb_cyc" is 1, "i_wb_stb" is 1, "i_wb_we" is 0
    And "i_wb_adr" selects a register R that is currently locked due to an active arithmetic-update sequence
    When the read request persists across clock edges
    Then "o_wb_ack" should remain deasserted until register R is unlocked
    And once R is unlocked, the read should complete with "o_wb_ack" asserted and correct data

  @wishbone @read
  Formal Scenario: RS register readback returns zero
    Given "i_wb_cyc" is 1, "i_wb_stb" is 1, "i_wb_we" is 0
    And "i_wb_adr" selects register "RS"
    When the read completes
    Then "o_wb_data" should be 0

  # ---------------------------------------------------------------------
  # BUS WIDTH FORMATTING BEHAVIOR
  # ---------------------------------------------------------------------

  @readback @width
  Formal Scenario: 16-bit mode truncates 32-bit register reads to lower 16 bits
    Given the design is configured for "wb_16bit"
    And register "un" holds a signed 32-bit value V
    And a read request targets register "un"
    When the read completes
    Then "o_wb_data" should equal the lower 16 bits of V

  @readback @width
  Formal Scenario: 32-bit mode sign-extends 16-bit signed register reads
    Given the design is configured for "wb_32bit"
    And register "Kp" holds a signed 16-bit value V
    And a read request targets register "Kp"
    When the read completes
    Then "o_wb_data" should equal V sign-extended to 32 bits

  @readback @width
  Formal Scenario: 64-bit mode sign-extends 16-bit signed register reads
    Given the design is configured for "wb_64bit"
    And register "SP" holds a signed 16-bit value V
    And a read request targets register "SP"
    When the read completes
    Then "o_wb_data" should equal V sign-extended to 64 bits

  @readback @width
  Formal Scenario: OF register is zero-extended in wider bus modes
    Given the design is configured for "wb_32bit" or "wb_64bit"
    And register "OF" holds a 5-bit value V
    And a read request targets register "OF"
    When the read completes
    Then "o_wb_data" should equal V zero-extended to the selected bus width

  # ---------------------------------------------------------------------
  # CONTROL-UPDATE SEQUENCE / ARITHMETIC BEHAVIOR
  # ---------------------------------------------------------------------

  @sequence @latency
  Formal Scenario: PV write to un update has fixed 9-cycle latency
    Given register "PV" is written with an accepted value that triggers a control-update sequence
    When 9 clock cycles have elapsed since the acceptance of the PV write
    Then register "un" should reflect the updated control output for that sequence
    And "o_valid" should be asserted at that cycle if no further update is pending

  @sequence
  Formal Scenario: Error term is derived from SP and PV
    Given register "SP" holds value S
    And register "PV" is written with value P, accepted and triggering an update
    When the control-update sequence completes error formation
    Then register "err[0]" should equal S minus P, subject to overflow behavior

  @sequence
  Formal Scenario: Previous error register captures prior error state
    Given register "err[0]" holds value E0 prior to a new PV-triggered update
    And a new PV write is accepted, triggering an update sequence
    When the sequence updates the previous error register
    Then register "err[1]" should equal E0

  @sequence
  Formal Scenario: Kpd equals sum of Kp and Kd after update
    Given register "Kp" holds value KP
    And register "Kd" holds value KD
    And a Kpd-update sequence is triggered by writing Kp or Kd
    When the Kpd-update sequence completes
    Then register "Kpd" should equal KP plus KD, subject to overflow behavior

  @sequence
  Formal Scenario: o_valid deasserted only during active PV-triggered sequence
    Given a PV write is accepted, triggering a control-update sequence
    When the sequence is in progress
    Then "o_valid" should be 0
    And when the sequence completes
    Then "o_valid" should be 1

  @sequence
  Formal Scenario: o_un continuously reflects the un register
    Given register "un" holds value U at any point in time
    When one clock edge occurs with no change to "un"
    Then "o_un" should equal U

  # ---------------------------------------------------------------------
  # OVERFLOW REPORTING
  # ---------------------------------------------------------------------

  @overflow
  Formal Scenario: OF bit 0 set on Kpd update overflow
    Given a Kpd-update sequence computes Kp plus Kd resulting in signed overflow
    When the update completes
    Then "OF[0]" should be 1

  @overflow
  Formal Scenario: OF bit 1 set on current error overflow
    Given a PV-triggered update computes err[0] as SP minus PV resulting in signed overflow
    When the update completes
    Then "OF[1]" should be 1

  @overflow
  Formal Scenario: OF bit 2 set on previous error overflow
    Given a PV-triggered update assigns err[1] from prior err[0] resulting in signed overflow
    When the update completes
    Then "OF[2]" should be 1

  @overflow
  Formal Scenario: OF bit 3 set on un path overflow
    Given a PV-triggered update assembles u(n) via the adder path resulting in signed overflow
    When the update completes
    Then "OF[3]" should be 1

  @overflow
  Formal Scenario: OF bit 4 set on sigma update overflow
    Given a PV-triggered update accumulates sigma resulting in signed overflow
    When the update completes
    Then "OF[4]" should be 1

  @overflow
  Formal Scenario: RS write clears all overflow bits
    Given register "OF" holds a nonzero value
    And register "RS" is written with data value 0 and accepted
    When the write completes
    Then register "OF" should become 0

  # ---------------------------------------------------------------------
  # LOCKING BEHAVIOR
  # ---------------------------------------------------------------------

  @locking
  Formal Scenario: Locked registers block writes until sequence completion
    Given a PV-triggered control-update sequence is active
    And register R is one of the registers locked during this sequence
    When a write request targets register R during the active sequence
    Then the write should not be acknowledged until the sequence releases the lock on R

  @locking
  Formal Scenario: Locked registers block reads until sequence completion
    Given a PV-triggered control-update sequence is active
    And register R is one of the registers locked during this sequence
    When a read request targets register R during the active sequence
    Then the read should not be acknowledged until the sequence releases the lock on R

  @locking
  Formal Scenario: Non-locked registers remain accessible during an active sequence
    Given a PV-triggered control-update sequence is active
    And register R is not part of the locked set for this sequence
    When a read or write request targets register R
    Then the transaction should be acknowledged without waiting for sequence completion

  # ---------------------------------------------------------------------
  # SUBMODULE-LEVEL PROPERTIES
  # ---------------------------------------------------------------------

  @submodule @adder
  Formal Scenario: adder_32bit computes sum with carry-in
    Given operand A is a 32-bit value
    And operand B is a 32-bit value
    And carry-in C is 0 or 1
    When the adder combinationally evaluates the inputs
    Then "o_s" should equal A plus B plus C, truncated to 32 bits
    And "o_c" should equal the carry-out of A plus B plus C

  @submodule @multiplier
  Formal Scenario: multiplier_16x16bit_pipelined produces signed product
    Given multiplicand MD is a signed 16-bit value
    And multiplier MR is a signed 16-bit value
    And "i_start" is asserted for one cycle with "i_rst" deasserted
    When the pipeline completes and asserts "o_ready"
    Then "o_product" should equal MD multiplied by MR as a signed 32-bit result

  @submodule @multiplier
  Formal Scenario: multiplier reset is driven inverted from top-level reset
    Given top-level "i_rst" is asserted
    When the top module drives the multiplier reset input
    Then the multiplier "i_rst" input should equal the logical negation of top-level "i_rst"

  # ---------------------------------------------------------------------
  # WISHBONE PROTOCOL DISCIPLINE
  # ---------------------------------------------------------------------

  @protocol
  Formal Scenario: Master holds qualifiers until acknowledge
    Given "i_wb_cyc" is 1 and "i_wb_stb" is 1 for a pending transaction
    When "o_wb_ack" has not yet been asserted
    Then "i_wb_cyc" and "i_wb_stb" should remain asserted until "o_wb_ack" is observed

  @protocol
  Formal Scenario: No acknowledge without an active request
    Given "i_wb_cyc" is 0 or "i_wb_stb" is 0
    When one clock edge occurs
    Then "o_wb_ack" should be 0