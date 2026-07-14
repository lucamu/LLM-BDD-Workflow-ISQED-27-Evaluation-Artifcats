Feature: MinSoC Wishbone Interconnect, Address Decoding, Arbitration and Start-Up Control

  Formal verification of the MinSoC double shared-bus Wishbone interconnect,
  its target address decoding rules, bus arbitration mutual exclusion,
  start-up boot mux behavior, reset vector selection, and PIC interrupt
  status reflection, as specified in the MinSoC architecture documentation.

  Background:
    Given a synchronous system clock "wb_clk"
    And an active-high synchronous reset "wb_rst"
    And the interconnect target address width parameter "t0_addr_w" equals 8
    And the interconnect target address width parameter "t28c_addr_w" equals 4
    And the interconnect full address width parameter "t28i_addr_w" equals 8
    And target 0 base address parameter "t0_addr" equals 8'h00
    And target 1 base address parameter "t1_addr" equals 8'h04
    And targets 2 to 8 shared MSB address parameter "t28_addr" equals 4'h9
    And all Wishbone transactions follow the standard CYC/STB/ACK handshake

  @reset @address_decode
  Formal Scenario: CPU fetches from hardwired software reset vector after reset deassertion when start-up is disabled
    Given the start-up module is disabled
    And the reset signal "wb_rst" is asserted for at least one clock cycle
    When "wb_rst" is deasserted on a rising clock edge
    Then the OR1200 instruction fetch address "pc" should equal 32'h00000100

  @reset @startup
  Formal Scenario: Start-up Starter mux selects internal tiny program data on reset
    Given the start-up module is enabled
    And the reset signal "wb_rst" is asserted
    When "wb_rst" is deasserted on a rising clock edge
    Then the instruction data input mux select signal "startup_active" should be 1
    And the OR1200 instruction data input "wb_dat_i" should be driven by the start-up Starter internal program, not by the interconnect

  @startup
  Formal Scenario: Start-up Starter releases instruction mux back to interconnect once or1k_startup is fetched
    Given the start-up module is enabled
    And "startup_active" is 1
    And the CPU instruction fetch address "iaddr" equals the or1k_startup module base address "startup_addr"
    When a rising clock edge occurs
    Then the instruction data input mux select signal "startup_active" should transition to 0
    And subsequent OR1200 instruction data input "wb_dat_i" should be driven by the interconnect

  @startup @reset
  Formal Scenario: or1k_startup completion sets CPU program counter to software reset address
    Given the start-up module is enabled
    And the or1k_startup module asserts its completion signal "startup_done"
    When a rising clock edge occurs with "startup_done" equal to 1
    Then the OR1200 instruction fetch address "pc" should equal 32'h00000100

  @address_decode
  Formal Scenario: Target 0 (RAM) is selected only when the top t0_addr_w bits of the master address match t0_addr
    Given a master asserts a Wishbone address "wb_adr_i" with valid cycle "wb_cyc_i" equal to 1 and strobe "wb_stb_i" equal to 1
    When the top 8 bits of "wb_adr_i" equal "t0_addr"
    Then the target select signal "target0_sel" should be 1
    And the target select signals for all other targets should be 0

  @address_decode
  Formal Scenario: Target 0 is not selected when top address bits differ from t0_addr
    Given a master asserts a Wishbone address "wb_adr_i" with valid cycle "wb_cyc_i" equal to 1 and strobe "wb_stb_i" equal to 1
    When the top 8 bits of "wb_adr_i" do not equal "t0_addr"
    Then the target select signal "target0_sel" should be 0

  @address_decode
  Formal Scenario: Targets 2 to 8 are considered valid only when the top t28c_addr_w bits of the address equal t28_addr
    Given a master asserts a Wishbone address "wb_adr_i" with valid cycle "wb_cyc_i" equal to 1 and strobe "wb_stb_i" equal to 1
    When the top 4 bits of "wb_adr_i" equal "t28_addr"
    Then the shared-bus target-valid signal "target28_valid" should be 1

  @address_decode
  Formal Scenario: Targets 2 to 8 are rejected when the address MSB does not match t28_addr
    Given a master asserts a Wishbone address "wb_adr_i" with valid cycle "wb_cyc_i" equal to 1 and strobe "wb_stb_i" equal to 1
    When the top 4 bits of "wb_adr_i" do not equal "t28_addr"
    Then the shared-bus target-valid signal "target28_valid" should be 0
    And no target grant among targets 2 to 8 should be asserted

  @arbitration
  Formal Scenario: Only one master may be granted the shared bus at any given clock cycle
    Given master A and master B both simultaneously request the shared bus with valid cycle and strobe signals asserted
    And both requests target a valid address among targets 2 to 8
    When a rising clock edge occurs
    Then at most one of "gnt_master_A" and "gnt_master_B" should be 1
    And the grant signals "gnt_master_A" and "gnt_master_B" should never both equal 1 in the same cycle

  @arbitration
  Formal Scenario: Target 0 access is granted independently of shared bus occupancy
    Given the shared bus is currently granted to some master accessing targets 1 to 8
    And a different master requests access to target 0 with valid cycle and strobe signals asserted
    When a rising clock edge occurs
    Then the target 0 grant signal "gnt_target0" should be 1
    And this grant should not depend on the busy state of the shared bus grant signal "gnt_shared_bus"

  @arbitration
  Formal Scenario: Bus grant is withheld until the target slave interface is idle
    Given a master requests access to a target whose slave interface busy signal "target_busy" is 1
    When a rising clock edge occurs
    Then the corresponding grant signal for that master should be 0
    And the grant signal should only become 1 in a later cycle when "target_busy" equals 0

  @wishbone_protocol
  Formal Scenario: UART target error signal is always tied to zero
    Given the UART module is connected to a target slot of the interconnect
    When any Wishbone transaction is directed to the UART target address
    Then the Wishbone error output "wb_err_o" for the UART target slot should be 0

  @wishbone_protocol
  Formal Scenario: Acknowledge is asserted only for an active, correctly addressed and enabled transaction
    Given a master asserts "wb_cyc_i" equal to X and "wb_stb_i" equal to Y for some target T
    When a rising clock edge occurs
    Then the target's Wishbone acknowledge "wb_ack_o" should be 1 only if X equals 1 and Y equals 1 and the target's address decode matches
    And "wb_ack_o" should be 0 whenever "wb_cyc_i" equals 0

  @interrupt
  Formal Scenario: PIC status register bit reflects the corresponding external interrupt line
    Given the UART interrupt output "uart_irq" is connected to bit 2 of "pic_ints_i"
    When "uart_irq" equals I on a rising clock edge
    Then bit 2 of the PIC status register "pic_status" should equal I

  @interrupt
  Formal Scenario: Aggregate PIC interrupt to OR1200 asserts only when at least one enabled interrupt line is active
    Given the PIC interrupt mask register "pic_mask" and status inputs "pic_ints_i" have some values
    When a rising clock edge occurs
    Then the aggregate OR1200 interrupt signal "pic_interrupt" should equal the logical OR of all bits of ("pic_ints_i" AND "pic_mask")

  @interrupt
  Formal Scenario: Interrupt exception vector is fixed regardless of interrupt source
    Given the aggregate PIC interrupt signal "pic_interrupt" equals 1
    And the OR1200 exception handling is enabled
    When a rising clock edge occurs while "pic_interrupt" is 1
    Then the OR1200 program counter "pc" should equal 32'h00000800

  @address_decode
  Formal Scenario: Lower-order address bits do not affect target selection decision
    Given two Wishbone addresses "addr_1" and "addr_2" that share identical top t0_addr_w bits but differ in lower-order bits
    When either "addr_1" or "addr_2" is presented with valid cycle and strobe asserted
    Then the resulting target select signal for target 0 should be identical for both "addr_1" and "addr_2"