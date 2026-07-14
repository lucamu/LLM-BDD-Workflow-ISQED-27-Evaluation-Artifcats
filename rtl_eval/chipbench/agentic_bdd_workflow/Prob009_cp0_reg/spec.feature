# ── module: CP0_CountCompare ──
Feature: COUNT/COMPARE Timer Registers and Timer Interrupt Logic

  This feature specifies the behavior of the COP0 COUNT and COMPARE
  registers and the derived timer_int_o signal. count_o increments
  each cycle unless overwritten, compare_o holds a target value used
  to raise timer_int_o, and writes to COMPARE clear a pending interrupt.

  Background:
    Given a synchronous design with signal clk_i and active reset rst_i
    And register signals count_o and compare_o
    And input signals we_i, waddr_i, and data_i
    And output signal timer_int_o
    And constant address CP0_REG_COUNT
    And constant address CP0_REG_COMPARE
    And all signal transitions occur on the rising edge of clk_i

  @reset
  Formal Scenario: Reset initializes count, compare, and timer interrupt
    Given rst_i is asserted
    When a rising edge of clk_i occurs
    Then count_o should be 0
    And compare_o should be 0
    And timer_int_o should be deasserted

  @increment
  Formal Scenario: Count increments when no write occurs
    Given rst_i is deasserted
    And we_i is deasserted
    And count_o holds value C
    When a rising edge of clk_i occurs
    Then count_o should be C + 1

  @write_count
  Formal Scenario: Writing COUNT loads count_o and overrides increment
    Given rst_i is deasserted
    And we_i is asserted
    And waddr_i equals CP0_REG_COUNT
    And data_i holds value D
    And count_o holds value C
    When a rising edge of clk_i occurs
    Then count_o should be D

  @write_compare
  Formal Scenario: Writing COMPARE loads compare_o and clears timer interrupt
    Given rst_i is deasserted
    And we_i is asserted
    And waddr_i equals CP0_REG_COMPARE
    And data_i holds value D
    When a rising edge of clk_i occurs
    Then compare_o should be D
    And timer_int_o should be deasserted

  @no_write
  Formal Scenario: No write leaves compare_o unchanged
    Given rst_i is deasserted
    And we_i is deasserted
    And compare_o holds value M
    When a rising edge of clk_i occurs
    Then compare_o should be M

  @write_count_leaves_compare
  Formal Scenario: Writing COUNT does not affect compare_o or timer_int_o directly
    Given rst_i is deasserted
    And we_i is asserted
    And waddr_i equals CP0_REG_COUNT
    And compare_o holds value M
    And timer_int_o holds value T
    When a rising edge of clk_i occurs
    Then compare_o should be M
    And timer_int_o should be T unless count_o' equals compare_o' and compare_o' is nonzero

  @timer_int_assert
  Formal Scenario: Timer interrupt asserts when count equals nonzero compare
    Given rst_i is deasserted
    And compare_o holds value M where M is nonzero
    And count_o holds value M
    And no write to CP0_REG_COMPARE occurs this cycle
    When a rising edge of clk_i occurs
    Then timer_int_o should be asserted

  @timer_int_no_assert_zero_compare
  Formal Scenario: Timer interrupt does not assert when compare is zero
    Given rst_i is deasserted
    And compare_o holds value 0
    And count_o holds any value C
    When a rising edge of clk_i occurs
    Then timer_int_o should be deasserted

  @timer_int_no_assert_mismatch
  Formal Scenario: Timer interrupt does not assert when count differs from compare
    Given rst_i is deasserted
    And compare_o holds value M where M is nonzero
    And count_o holds value C where C is not equal to M
    And no write to CP0_REG_COMPARE occurs this cycle
    When a rising edge of clk_i occurs
    Then timer_int_o should be deasserted

  @timer_int_held
  Formal Scenario: Timer interrupt remains asserted until compare is rewritten
    Given rst_i is deasserted
    And timer_int_o is asserted
    And we_i is deasserted
    When a rising edge of clk_i occurs
    Then timer_int_o should remain asserted

  @timer_int_cleared_on_rewrite
  Formal Scenario: Timer interrupt clears exactly when compare is rewritten
    Given rst_i is deasserted
    And timer_int_o is asserted
    And we_i is asserted
    And waddr_i equals CP0_REG_COMPARE
    And data_i holds value D
    When a rising edge of clk_i occurs
    Then compare_o should be D
    And timer_int_o should be deasserted

  @priority_count_over_increment
  Formal Scenario: Write to COUNT takes priority over automatic increment
    Given rst_i is deasserted
    And we_i is asserted
    And waddr_i equals CP0_REG_COUNT
    And data_i holds value D
    And count_o holds value C where D is not equal to C + 1
    When a rising edge of clk_i occurs
    Then count_o should be D

  @independent_count_compare_update
  Formal Scenario: Count increment and compare write occur independently in the same cycle
    Given rst_i is deasserted
    And we_i is asserted
    And waddr_i equals CP0_REG_COMPARE
    And data_i holds value D
    And count_o holds value C
    When a rising edge of clk_i occurs
    Then count_o should be C + 1
    And compare_o should be D
    And timer_int_o should be deasserted

# ── module: CP0_ExceptionRegs ──
Feature: CP0 STATUS, CAUSE, and EPC Register File with Exception Handling

  As a MIPS-compatible processor core
  I want the CP0 STATUS, CAUSE, and EPC registers to update correctly
  So that exceptions, interrupts, and coprocessor writes are handled per the architecture

  Background:
    Given a synchronous design with clock clk and active-high reset rst
    And CP0_REG_STATUS, CP0_REG_CAUSE, and CP0_REG_EPC are distinct register addresses
    And the ERET exception code is a distinct fixed value among excepttype_i encodings
    And all state updates occur on the rising edge of clk when rst is not asserted

  @reset
  Formal Scenario: Reset initializes STATUS, CAUSE, and EPC registers
    Given rst is asserted
    When a clock edge occurs
    Then status_o should have CU[0] bit equal to 1 and all other bits equal to 0
    And cause_o should equal 0
    And epc_o should equal 0

  @ip_update
  Formal Scenario: Hardware interrupt pending bits are updated every cycle regardless of other inputs
    Given rst is deasserted
    And int_i is any value INT
    And we_i, excepttype_i, and waddr_i are any valid values
    When a clock edge occurs
    Then cause_o bits [15:10] should equal INT

  @write_status
  Formal Scenario: Writing to STATUS register loads status_o with data_i
    Given rst is deasserted
    And we_i is asserted
    And waddr_i equals CP0_REG_STATUS
    And data_i is any value DATA
    And excepttype_i equals 0
    When a clock edge occurs
    Then status_o should equal DATA

  @write_cause
  Formal Scenario: Writing to CAUSE register updates only the writable bits
    Given rst is deasserted
    And we_i is asserted
    And waddr_i equals CP0_REG_CAUSE
    And data_i is any value DATA
    And cause_o before the clock edge equals OLD_CAUSE
    And excepttype_i equals 0
    When a clock edge occurs
    Then cause_o bits [9:8] should equal DATA bits [9:8]
    And cause_o IV bit should equal DATA IV bit
    And all non-writable bits of cause_o, other than bits [15:10], should equal the corresponding bits of OLD_CAUSE

  @write_cause
  Formal Scenario: IP hardware bits are updated concurrently with a CAUSE register write
    Given rst is deasserted
    And we_i is asserted
    And waddr_i equals CP0_REG_CAUSE
    And data_i is any value DATA
    And int_i is any value INT
    And excepttype_i equals 0
    When a clock edge occurs
    Then cause_o bits [15:10] should equal INT
    And cause_o bits [9:8] should equal DATA bits [9:8]
    And cause_o IV bit should equal DATA IV bit

  @write_epc
  Formal Scenario: Writing to EPC register loads epc_o with data_i
    Given rst is deasserted
    And we_i is asserted
    And waddr_i equals CP0_REG_EPC
    And data_i is any value DATA
    And excepttype_i equals 0
    When a clock edge occurs
    Then epc_o should equal DATA

  @exception_entry
  Formal Scenario: Exception entry sets the EXL bit in status_o
    Given rst is deasserted
    And excepttype_i is any nonzero value not equal to the ERET code
    And status_o before the clock edge has EXL bit equal to 0
    And status_o before the clock edge equals OLD_STATUS
    When a clock edge occurs
    Then status_o EXL bit should equal 1
    And all bits of status_o other than EXL should equal the corresponding bits of OLD_STATUS

  @exception_entry
  Formal Scenario: Exception entry updates ExcCode and BD bit in cause_o
    Given rst is deasserted
    And excepttype_i is any nonzero value EXCTYPE not equal to the ERET code
    And is_in_delayslot_i is any value DS
    When a clock edge occurs
    Then cause_o ExcCode field should equal the exception code derived from EXCTYPE
    And cause_o BD bit should equal DS

  @exception_entry @epc_guard
  Formal Scenario: Exception entry loads epc_o with the current instruction address when not in a delay slot and EXL was clear
    Given rst is deasserted
    And excepttype_i is any nonzero value not equal to the ERET code
    And status_o before the clock edge has EXL bit equal to 0
    And is_in_delayslot_i equals 0
    And current_inst_addr_i is any value ADDR
    When a clock edge occurs
    Then epc_o should equal ADDR

  @exception_entry @delay_slot @epc_guard
  Formal Scenario: Exception entry loads epc_o with address minus four when in a delay slot and EXL was clear
    Given rst is deasserted
    And excepttype_i is any nonzero value not equal to the ERET code
    And status_o before the clock edge has EXL bit equal to 0
    And is_in_delayslot_i equals 1
    And current_inst_addr_i is any value ADDR
    When a clock edge occurs
    Then epc_o should equal ADDR minus 4

  @exception_entry @epc_guard
  Formal Scenario: epc_o is not updated on exception entry when EXL was already set
    Given rst is deasserted
    And excepttype_i is any nonzero value not equal to the ERET code
    And status_o before the clock edge has EXL bit equal to 1
    And epc_o before the clock edge equals OLD_EPC
    And current_inst_addr_i is any value ADDR
    And is_in_delayslot_i is any value DS
    When a clock edge occurs
    Then epc_o should equal OLD_EPC

  @eret
  Formal Scenario: ERET clears the EXL bit in status_o instead of performing exception entry
    Given rst is deasserted
    And excepttype_i equals the ERET code
    And status_o before the clock edge has EXL bit equal to 1
    And status_o before the clock edge equals OLD_STATUS
    When a clock edge occurs
    Then status_o EXL bit should equal 0
    And all bits of status_o other than EXL should equal the corresponding bits of OLD_STATUS

  @eret
  Formal Scenario: ERET does not modify epc_o
    Given rst is deasserted
    And excepttype_i equals the ERET code
    And epc_o before the clock edge equals OLD_EPC
    And current_inst_addr_i is any value ADDR
    And is_in_delayslot_i is any value DS
    When a clock edge occurs
    Then epc_o should equal OLD_EPC

  @eret
  Formal Scenario: ERET does not modify the ExcCode or BD fields of cause_o
    Given rst is deasserted
    And excepttype_i equals the ERET code
    And cause_o before the clock edge equals OLD_CAUSE
    And is_in_delayslot_i is any value DS
    When a clock edge occurs
    Then cause_o ExcCode field should equal OLD_CAUSE ExcCode field
    And cause_o BD bit should equal OLD_CAUSE BD bit

  @priority
  Formal Scenario: Exception entry takes priority over a STATUS register write in the same cycle
    Given rst is deasserted
    And we_i is asserted
    And waddr_i equals CP0_REG_STATUS
    And data_i is any value DATA
    And excepttype_i is any nonzero value not equal to the ERET code
    And status_o before the clock edge has EXL bit equal to 0
    When a clock edge occurs
    Then status_o EXL bit should equal 1
    And status_o should not equal DATA unless DATA also has EXL bit equal to 1 and matches all other exception-entry-preserved bits

  @priority
  Formal Scenario: Exception entry takes priority over an EPC register write in the same cycle
    Given rst is deasserted
    And we_i is asserted
    And waddr_i equals CP0_REG_EPC
    And data_i is any value DATA
    And excepttype_i is any nonzero value not equal to the ERET code
    And status_o before the clock edge has EXL bit equal to 0
    And is_in_delayslot_i equals 0
    And current_inst_addr_i is any value ADDR
    When a clock edge occurs
    Then epc_o should equal ADDR

  @priority
  Formal Scenario: Exception entry takes priority over a CAUSE register write in the same cycle
    Given rst is deasserted
    And we_i is asserted
    And waddr_i equals CP0_REG_CAUSE
    And data_i is any value DATA
    And excepttype_i is any nonzero value EXCTYPE not equal to the ERET code
    And is_in_delayslot_i is any value DS
    When a clock edge occurs
    Then cause_o ExcCode field should equal the exception code derived from EXCTYPE
    And cause_o BD bit should equal DS

# ── module: CP0_ConfigPrid ──
Feature: Static CONFIG and PRID Registers

  Formal verification of the non-writable CONFIG and PRID coprocessor registers.
  These registers are hardwired: CONFIG holds a fixed reset value with the
  Big-Endian (BE) bit set, and PRID holds a fixed processor identification
  constant. No write path exists, so both outputs must remain constant
  regardless of any input stimulus, cycle after cycle.

  Background:
    Given a synchronous clock "clk"
    And an active-low or active-high reset signal "rst"
    And the CONFIG register output "config_o"
    And the PRID register output "prid_o"
    And the CONFIG register width is 32 bits
    And the PRID register width is 32 bits
    And the BE (Big-Endian) bit is located at bit position 15 of config_o
    And the fixed PRID constant value is 32'h00480002

  @reset @config
  Formal Scenario: CONFIG register resets to zero with BE bit set
    Given the design is in the reset state
    When a rising clock edge occurs
    Then config_o should equal 32'h00008000 (all bits zero except BE bit 15 set to 1)

  @reset @prid
  Formal Scenario: PRID register resets to fixed processor identification value
    Given the design is in the reset state
    When a rising clock edge occurs
    Then prid_o should equal 32'h00480002

  @stability @config
  Formal Scenario: CONFIG register value is stable across clock cycles after reset
    Given the design is out of reset
    And config_o currently holds value C
    When a rising clock edge occurs
    And no reset is asserted
    Then config_o should equal C
    And bit 15 of config_o should remain 1

  @stability @prid
  Formal Scenario: PRID register value is stable across clock cycles after reset
    Given the design is out of reset
    And prid_o currently holds value P
    When a rising clock edge occurs
    And no reset is asserted
    Then prid_o should equal P
    And prid_o should equal 32'h00480002

  @no_write @config
  Formal Scenario: CONFIG register ignores any attempted write
    Given the design is out of reset
    And an arbitrary write data value W is presented on any write interface
    And an arbitrary write enable value E is presented
    When a rising clock edge occurs
    Then config_o should equal 32'h00008000
    And config_o should not equal W regardless of E

  @no_write @prid
  Formal Scenario: PRID register ignores any attempted write
    Given the design is out of reset
    And an arbitrary write data value W is presented on any write interface
    And an arbitrary write enable value E is presented
    When a rising clock edge occurs
    Then prid_o should equal 32'h00480002
    And prid_o should not equal W regardless of E

  @invariant @config
  Formal Scenario: CONFIG register BE bit is always asserted
    Given the design is in any reachable state
    When a rising clock edge occurs
    Then bit 15 of config_o should equal 1

  @invariant @combined
  Formal Scenario: CONFIG and PRID outputs are independent of all data inputs
    Given arbitrary input values are applied to every data input port of the module
    When a rising clock edge occurs
    Then config_o should equal 32'h00008000
    And prid_o should equal 32'h00480002

  @reset_recovery
  Formal Scenario: Registers return to fixed values immediately after reset deassertion
    Given the design was previously in an arbitrary state
    And reset is asserted for at least one clock cycle
    When reset is deasserted
    And a rising clock edge occurs
    Then config_o should equal 32'h00008000
    And prid_o should equal 32'h00480002

# ── module: CP0_ReadMux ──
Feature: CP0 Register Read Data Multiplexer

  Combinationally selects data_o based on raddr_i, choosing among the
  current values of count_o, compare_o, status_o, cause_o, epc_o,
  config_o, and prid_o. When raddr_i does not match any known CP0
  register address, data_o outputs 0. This logic is purely
  combinational and has no dependency on the clock edge, though the
  surrounding design is synchronous.

  Background:
    Given the design is synchronous with clock clk and active reset rst
    And CP0_REG_COUNT is address 5'd9
    And CP0_REG_COMPARE is address 5'd11
    And CP0_REG_STATUS is address 5'd12
    And CP0_REG_CAUSE is address 5'd13
    And CP0_REG_EPC is address 5'd14
    And CP0_REG_PRID is address 5'd15
    And CP0_REG_CONFIG is address 5'd16
    And count_o holds value COUNT_VAL
    And compare_o holds value COMPARE_VAL
    And status_o holds value STATUS_VAL
    And cause_o holds value CAUSE_VAL
    And epc_o holds value EPC_VAL
    And config_o holds value CONFIG_VAL
    And prid_o holds value PRID_VAL

  @combinational @count
  Formal Scenario: Select count_o when raddr_i matches CP0_REG_COUNT
    Given raddr_i is set to CP0_REG_COUNT
    When the combinational logic evaluates data_o
    Then data_o should equal COUNT_VAL

  @combinational @compare
  Formal Scenario: Select compare_o when raddr_i matches CP0_REG_COMPARE
    Given raddr_i is set to CP0_REG_COMPARE
    When the combinational logic evaluates data_o
    Then data_o should equal COMPARE_VAL

  @combinational @status
  Formal Scenario: Select status_o when raddr_i matches CP0_REG_STATUS
    Given raddr_i is set to CP0_REG_STATUS
    When the combinational logic evaluates data_o
    Then data_o should equal STATUS_VAL

  @combinational @cause
  Formal Scenario: Select cause_o when raddr_i matches CP0_REG_CAUSE
    Given raddr_i is set to CP0_REG_CAUSE
    When the combinational logic evaluates data_o
    Then data_o should equal CAUSE_VAL

  @combinational @epc
  Formal Scenario: Select epc_o when raddr_i matches CP0_REG_EPC
    Given raddr_i is set to CP0_REG_EPC
    When the combinational logic evaluates data_o
    Then data_o should equal EPC_VAL

  @combinational @config
  Formal Scenario: Select config_o when raddr_i matches CP0_REG_CONFIG
    Given raddr_i is set to CP0_REG_CONFIG
    When the combinational logic evaluates data_o
    Then data_o should equal CONFIG_VAL

  @combinational @prid
  Formal Scenario: Select prid_o when raddr_i matches CP0_REG_PRID
    Given raddr_i is set to CP0_REG_PRID
    When the combinational logic evaluates data_o
    Then data_o should equal PRID_VAL

  @combinational @default
  Formal Scenario: Output zero when raddr_i matches no known register
    Given raddr_i is set to any value ADDR_X
    And ADDR_X is not equal to CP0_REG_COUNT
    And ADDR_X is not equal to CP0_REG_COMPARE
    And ADDR_X is not equal to CP0_REG_STATUS
    And ADDR_X is not equal to CP0_REG_CAUSE
    And ADDR_X is not equal to CP0_REG_EPC
    And ADDR_X is not equal to CP0_REG_PRID
    And ADDR_X is not equal to CP0_REG_CONFIG
    When the combinational logic evaluates data_o
    Then data_o should equal 0

  @combinational @exclusivity
  Formal Scenario: Exactly one source drives data_o for any matching address
    Given raddr_i is set to any value ADDR_X
    When the combinational logic evaluates data_o
    Then data_o should equal COUNT_VAL if ADDR_X equals CP0_REG_COUNT
    And data_o should equal COMPARE_VAL if ADDR_X equals CP0_REG_COMPARE
    And data_o should equal STATUS_VAL if ADDR_X equals CP0_REG_STATUS
    And data_o should equal CAUSE_VAL if ADDR_X equals CP0_REG_CAUSE
    And data_o should equal EPC_VAL if ADDR_X equals CP0_REG_EPC
    And data_o should equal PRID_VAL if ADDR_X equals CP0_REG_PRID
    And data_o should equal CONFIG_VAL if ADDR_X equals CP0_REG_CONFIG

  @combinational @no_clock_dependency
  Formal Scenario: data_o updates immediately without waiting for clock edge
    Given raddr_i is set to CP0_REG_STATUS
    And status_o holds value STATUS_VAL
    When raddr_i changes to CP0_REG_CAUSE within the same clock period
    And cause_o holds value CAUSE_VAL
    Then data_o should equal CAUSE_VAL before any subsequent clock edge occurs

  @combinational @reset_independence
  Formal Scenario: data_o mux behavior is independent of reset state
    Given rst is asserted
    And raddr_i is set to CP0_REG_EPC
    And epc_o holds value EPC_VAL
    When the combinational logic evaluates data_o
    Then data_o should equal EPC_VAL

# ── module: TopModule ──
Feature: MIPS-style CP0 Coprocessor Register Module

  As a hardware designer
  I want to verify the TopModule CP0 register file
  So that reset values, counter/timer behavior, register writes/reads,
  exception handling, and interrupt propagation are formally correct

  Background:
    Given the clock signal "clk" toggles every cycle
    And CP0 register address "CP0_REG_COUNT" equals 5'd9
    And CP0 register address "CP0_REG_COMPARE" equals 5'd11
    And CP0 register address "CP0_REG_STATUS" equals 5'd12
    And CP0 register address "CP0_REG_CAUSE" equals 5'd13
    And CP0 register address "CP0_REG_EPC" equals 5'd14
    And CP0 register address "CP0_REG_CONFIG" equals 5'd16
    And CP0 register address "CP0_REG_PRID" equals 5'd15

  @reset
  Formal Scenario: Reset initializes all output registers to defined defaults
    Given rst is asserted
    When a rising clock edge occurs
    Then count_o should be 0
    And compare_o should be 0
    And status_o bit 0 (CU0-related init bit) should be 1
    And cause_o should be 0
    And epc_o should be 0
    And config_o BE bit should be 1
    And prid_o should equal 32'h00480002
    And timer_int_o should be 0

  @reset
  Formal Scenario: Reset holds regardless of other inputs
    Given rst is asserted
    And we_i, waddr_i, data_i, excepttype_i, int_i, current_inst_addr_i, is_in_delayslot_i have any symbolic values
    When a rising clock edge occurs
    Then count_o should be 0
    And compare_o should be 0
    And cause_o should be 0
    And epc_o should be 0
    And timer_int_o should be 0

  @counter
  Formal Scenario: Counter increments every clock cycle when not reset
    Given rst is deasserted
    And count_o currently holds value C
    And we_i is 0
    When a rising clock edge occurs
    Then count_o should equal C + 1

  @counter
  Formal Scenario: Counter write overrides increment behavior
    Given rst is deasserted
    And we_i is 1
    And waddr_i equals CP0_REG_COUNT
    And data_i holds value D
    When a rising clock edge occurs
    Then count_o should equal D

  @timer_interrupt
  Formal Scenario: Timer interrupt asserts when count matches nonzero compare
    Given rst is deasserted
    And compare_o holds value K where K is not 0
    And count_o holds value K minus 1
    And we_i is 0
    When a rising clock edge occurs
    Then count_o should equal K
    And timer_int_o should be 1

  @timer_interrupt
  Formal Scenario: Timer interrupt stays deasserted when compare is zero
    Given rst is deasserted
    And compare_o holds value 0
    And count_o holds any value C
    And we_i is 0
    When a rising clock edge occurs
    Then timer_int_o should be 0

  @timer_interrupt
  Formal Scenario: Writing compare register deasserts timer interrupt
    Given rst is deasserted
    And timer_int_o currently holds value 1
    And we_i is 1
    And waddr_i equals CP0_REG_COMPARE
    And data_i holds value D
    When a rising clock edge occurs
    Then compare_o should equal D
    And timer_int_o should be 0

  @register_write
  Formal Scenario: Writing status register updates status_o directly
    Given rst is deasserted
    And we_i is 1
    And waddr_i equals CP0_REG_STATUS
    And data_i holds value S
    When a rising clock edge occurs
    Then status_o should equal S

  @register_write
  Formal Scenario: Writing epc register updates epc_o directly
    Given rst is deasserted
    And we_i is 1
    And waddr_i equals CP0_REG_EPC
    And data_i holds value E
    When a rising clock edge occurs
    Then epc_o should equal E

  @register_write
  Formal Scenario: Writing cause register only modifies writable bits
    Given rst is deasserted
    And cause_o currently holds value CAUSE_PREV
    And we_i is 1
    And waddr_i equals CP0_REG_CAUSE
    And data_i holds value W
    When a rising clock edge occurs
    Then cause_o writable bit field should equal W writable bit field
    And cause_o non-writable bit field should equal CAUSE_PREV non-writable bit field

  @register_write
  Formal Scenario: Write to non-matching address does not affect unrelated registers
    Given rst is deasserted
    And we_i is 1
    And waddr_i equals CP0_REG_STATUS
    And data_i holds value S
    And epc_o currently holds value EPC_PREV
    When a rising clock edge occurs
    Then epc_o should equal EPC_PREV

  @register_read
  Formal Scenario: Reading count register returns current count value
    Given raddr_i equals CP0_REG_COUNT
    And count_o holds value C
    Then data_o should equal C

  @register_read
  Formal Scenario: Reading compare register returns current compare value
    Given raddr_i equals CP0_REG_COMPARE
    And compare_o holds value K
    Then data_o should equal K

  @register_read
  Formal Scenario: Reading status register returns current status value
    Given raddr_i equals CP0_REG_STATUS
    And status_o holds value S
    Then data_o should equal S

  @register_read
  Formal Scenario: Reading cause register returns current cause value
    Given raddr_i equals CP0_REG_CAUSE
    And cause_o holds value CS
    Then data_o should equal CS

  @register_read
  Formal Scenario: Reading epc register returns current epc value
    Given raddr_i equals CP0_REG_EPC
    And epc_o holds value E
    Then data_o should equal E

  @register_read
  Formal Scenario: Reading config register returns current config value
    Given raddr_i equals CP0_REG_CONFIG
    And config_o holds value CFG
    Then data_o should equal CFG

  @register_read
  Formal Scenario: Reading prid register returns fixed processor ID
    Given raddr_i equals CP0_REG_PRID
    Then data_o should equal 32'h00480002

  @exception
  Formal Scenario: Exception not in delay slot updates epc with current instruction address
    Given rst is deasserted
    And excepttype_i indicates an exception (non-zero, non-ERET)
    And is_in_delayslot_i is 0
    And current_inst_addr_i holds value ADDR
    When a rising clock edge occurs
    Then epc_o should equal ADDR
    And cause_o BD bit should be 0

  @exception
  Formal Scenario: Exception in delay slot sets BD bit and adjusts epc
    Given rst is deasserted
    And excepttype_i indicates an exception (non-zero, non-ERET)
    And is_in_delayslot_i is 1
    And current_inst_addr_i holds value ADDR
    When a rising clock edge occurs
    Then epc_o should equal ADDR minus 4
    And cause_o BD bit should be 1

  @exception
  Formal Scenario: Exception sets EXL bit in status register
    Given rst is deasserted
    And excepttype_i indicates an exception (non-zero, non-ERET)
    And status_o EXL bit currently holds value 0
    When a rising clock edge occurs
    Then status_o EXL bit should be 1

  @exception
  Formal Scenario: Exception updates cause ExcCode field based on excepttype_i
    Given rst is deasserted
    And excepttype_i holds a specific known exception type T
    When a rising clock edge occurs
    Then cause_o ExcCode field should equal the exception code corresponding to T

  @interrupt
  Formal Scenario: Interrupt input propagates to cause IP field
    Given rst is deasserted
    And int_i holds value I
    When a rising clock edge occurs
    Then cause_o IP field should equal I

  @eret
  Formal Scenario: ERET clears EXL bit in status register
    Given rst is deasserted
    And excepttype_i indicates an ERET instruction
    And status_o EXL bit currently holds value 1
    When a rising clock edge occurs
    Then status_o EXL bit should be 0

  @eret
  Formal Scenario: ERET does not modify epc_o
    Given rst is deasserted
    And excepttype_i indicates an ERET instruction
    And epc_o currently holds value EPC_PREV
    When a rising clock edge occurs
    Then epc_o should equal EPC_PREV

  @priority
  Formal Scenario: Exception handling takes priority over concurrent register write to same field
    Given rst is deasserted
    And excepttype_i indicates an exception (non-zero, non-ERET)
    And we_i is 1
    And waddr_i equals CP0_REG_EPC
    And data_i holds value D
    And current_inst_addr_i holds value ADDR
    And is_in_delayslot_i is 0
    When a rising clock edge occurs
    Then epc_o should equal ADDR

  @priority
  Formal Scenario: No exception and no write leaves epc_o unchanged
    Given rst is deasserted
    And excepttype_i indicates no exception and not ERET
    And we_i is 0
    And epc_o currently holds value EPC_PREV
    When a rising clock edge occurs
    Then epc_o should equal EPC_PREV