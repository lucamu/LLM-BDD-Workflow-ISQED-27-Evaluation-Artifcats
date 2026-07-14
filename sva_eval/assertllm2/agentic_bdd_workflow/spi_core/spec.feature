Feature: simple_spi_top SPI Master Wishbone Slave Formal Verification

  As a formal verification engineer
  I want to verify simple_spi_top register, FIFO, bus, and SPI control behavior
  So that the core is proven correct against its specification

  Background:
    Given a synchronous design clocked on the rising edge of "clk_i"
    And "rst_n" is the asynchronous active-low reset
    And the WISHBONE access is qualified by "cyc_i" and "stb_i" both asserted
    And register address "adr_i" selects SPCR at 2'b00, SPSR at 2'b01, SPDR at 2'b10, SPER at 2'b11

  @reset
  Formal Scenario: Asynchronous reset initializes control and extension registers
    Given "rst_n" is deasserted (0)
    When one clock edge occurs
    Then SPCR should equal 8'h10
    And SPER should equal 8'h00
    And "inta_o" should equal 0
    And "sck_o" should equal 0
    And "ack_o" should equal 0

  @reset
  Formal Scenario: Reset clears write and read FIFOs
    Given "rst_n" is deasserted (0)
    When one clock edge occurs
    Then the write FIFO empty flag ("WFEMPTY") should equal 1
    And the write FIFO full flag ("WFFULL") should equal 0
    And the read FIFO empty flag ("RFEMPTY") should equal 1
    And the read FIFO full flag ("RFFULL") should equal 0

  @bus_protocol
  Formal Scenario: Acknowledge asserted only for qualified bus access
    Given "rst_n" is asserted (1)
    And "cyc_i" has symbolic value CYC
    And "stb_i" has symbolic value STB
    When one clock edge occurs
    Then "ack_o" should equal 1 if (CYC == 1 and STB == 1), else "ack_o" should equal 0

  @bus_protocol
  Formal Scenario: No register state changes when access is not qualified
    Given "rst_n" is asserted (1)
    And "cyc_i" has symbolic value CYC
    And "stb_i" has symbolic value STB
    And "we_i" has symbolic value WE
    And not (CYC == 1 and STB == 1)
    And SPCR holds value SPCR_PREV
    And SPER holds value SPER_PREV
    When one clock edge occurs
    Then SPCR should equal SPCR_PREV
    And SPER should equal SPER_PREV

  @register_write
  Formal Scenario: SPCR write updates writable bits and forces MSTR high
    Given "rst_n" is asserted (1)
    And a qualified write access with "adr_i" = 2'b00
    And "dat_i" has symbolic value D
    When one clock edge occurs
    Then bit 7 of SPCR (SPIE) should equal bit 7 of D
    And bit 6 of SPCR (SPE) should equal bit 6 of D
    And bit 4 of SPCR (MSTR) should equal 1
    And bit 3 of SPCR (CPOL) should equal bit 3 of D
    And bit 2 of SPCR (CPHA) should equal bit 2 of D
    And bits 1:0 of SPCR (SPR) should equal bits 1:0 of D

  @register_write
  Formal Scenario: SPER write updates ICNT and ESPR fields
    Given "rst_n" is asserted (1)
    And a qualified write access with "adr_i" = 2'b11
    And "dat_i" has symbolic value D
    When one clock edge occurs
    Then bits 7:6 of SPER (ICNT) should equal bits 7:6 of D
    And bits 1:0 of SPER (ESPR) should equal bits 1:0 of D

  @register_read
  Formal Scenario: SPCR read returns current control register contents
    Given "rst_n" is asserted (1)
    And a qualified read access with "adr_i" = 2'b00
    And SPCR holds value SPCR_VAL
    When one clock edge occurs
    Then "dat_o" should equal SPCR_VAL

  @register_read
  Formal Scenario: SPER read returns current extension register contents
    Given "rst_n" is asserted (1)
    And a qualified read access with "adr_i" = 2'b11
    And SPER holds value SPER_VAL
    When one clock edge occurs
    Then "dat_o" should equal SPER_VAL

  @register_read
  Formal Scenario: SPSR reserved bits always read as zero
    Given "rst_n" is asserted (1)
    And a qualified read access with "adr_i" = 2'b01
    When one clock edge occurs
    Then bits 5:4 of "dat_o" should equal 2'b00

  @spsr_status
  Formal Scenario: SPSR status bits reflect FIFO condition signals
    Given "rst_n" is asserted (1)
    And a qualified read access with "adr_i" = 2'b01
    And the write FIFO full flag equals WFULL
    And the write FIFO empty flag equals WEMPTY
    And the read FIFO full flag equals RFULL
    And the read FIFO empty flag equals REMPTY
    When one clock edge occurs
    Then bit 3 of "dat_o" (WFFULL) should equal WFULL
    And bit 2 of "dat_o" (WFEMPTY) should equal WEMPTY
    And bit 1 of "dat_o" (RFFULL) should equal RFULL
    And bit 0 of "dat_o" (RFEMPTY) should equal REMPTY

  @spsr_w1c
  Formal Scenario: SPIF cleared only by writing 1 to SPSR bit 7
    Given "rst_n" is asserted (1)
    And SPIF currently equals 1
    And a qualified write access with "adr_i" = 2'b01
    And "dat_i" has symbolic value D
    When one clock edge occurs
    Then SPIF should equal 0 if bit 7 of D equals 1, else SPIF should equal 1

  @spsr_w1c
  Formal Scenario: WCOL cleared only by writing 1 to SPSR bit 6
    Given "rst_n" is asserted (1)
    And WCOL currently equals 1
    And a qualified write access with "adr_i" = 2'b01
    And "dat_i" has symbolic value D
    When one clock edge occurs
    Then WCOL should equal 0 if bit 6 of D equals 1, else WCOL should equal 1

  @spsr_w1c
  Formal Scenario: SPIF and WCOL unaffected by non-SPSR writes
    Given "rst_n" is asserted (1)
    And SPIF currently equals SPIF_PREV
    And WCOL currently equals WCOL_PREV
    And a qualified write access with "adr_i" not equal to 2'b01
    When one clock edge occurs
    Then SPIF should equal SPIF_PREV
    And WCOL should equal WCOL_PREV

  @wcol
  Formal Scenario: Write collision flag set when SPDR written while write FIFO full
    Given "rst_n" is asserted (1)
    And the write FIFO full flag equals 1
    And a qualified write access with "adr_i" = 2'b10
    When one clock edge occurs
    Then WCOL should equal 1

  @wcol
  Formal Scenario: No write collision when SPDR written while write FIFO not full
    Given "rst_n" is asserted (1)
    And the write FIFO full flag equals 0
    And a qualified write access with "adr_i" = 2'b10
    And WCOL currently equals 0
    When one clock edge occurs
    Then WCOL should equal 0

  @fifo_write
  Formal Scenario: SPDR write enqueues byte into write FIFO when not full
    Given "rst_n" is asserted (1)
    And the write FIFO full flag equals 0
    And a qualified write access with "adr_i" = 2'b10
    And "dat_i" has symbolic value D
    When one clock edge occurs
    Then the write FIFO write-enable should equal 1
    And the write FIFO input data should equal D

  @fifo_read
  Formal Scenario: SPDR read dequeues byte from read FIFO when not empty
    Given "rst_n" is asserted (1)
    And the read FIFO empty flag equals 0
    And a qualified read access with "adr_i" = 2'b10
    And the read FIFO output data equals Q
    When one clock edge occurs
    Then "dat_o" should equal Q
    And the read FIFO read-enable should equal 1

  @fifo_read
  Formal Scenario: SPDR read does not assert read-enable when read FIFO empty
    Given "rst_n" is asserted (1)
    And the read FIFO empty flag equals 1
    And a qualified read access with "adr_i" = 2'b10
    When one clock edge occurs
    Then the read FIFO read-enable should equal 0

  @spe_control
  Formal Scenario: Clearing SPE clears both FIFOs
    Given "rst_n" is asserted (1)
    And bit 6 of SPCR (SPE) equals 0
    When one clock edge occurs
    Then the write FIFO clear control should equal 1
    And the read FIFO clear control should equal 1

  @spe_control
  Formal Scenario: Setting SPE deasserts FIFO clear controls
    Given "rst_n" is asserted (1)
    And bit 6 of SPCR (SPE) equals 1
    When one clock edge occurs
    Then the write FIFO clear control should equal 0
    And the read FIFO clear control should equal 0

  @interrupt
  Formal Scenario: Interrupt output asserted only when SPIE and SPIF both set
    Given "rst_n" is asserted (1)
    And bit 7 of SPCR (SPIE) equals SPIE_VAL
    And SPIF equals SPIF_VAL
    When one clock edge occurs
    Then "inta_o" should equal 1 if (SPIE_VAL == 1 and SPIF_VAL == 1), else "inta_o" should equal 0

  @transfer_start
  Formal Scenario: Transfer starts only when SPE is set and write FIFO is non-empty
    Given "rst_n" is asserted (1)
    And bit 6 of SPCR (SPE) equals SPE_VAL
    And the write FIFO empty flag equals WEMPTY
    And no transfer is currently in progress
    When one clock edge occurs
    Then a new SPI transfer should start if (SPE_VAL == 1 and WEMPTY == 0), else no new transfer should start

  @transfer_completion
  Formal Scenario: Byte completion pushes received data into read FIFO
    Given "rst_n" is asserted (1)
    And an SPI byte transfer completes this cycle
    And the received shift register value equals RX_BYTE
    When one clock edge occurs
    Then the read FIFO write-enable should equal 1
    And the read FIFO input data should equal RX_BYTE

  @icnt_counting
  Formal Scenario: SPIF set after configured number of completed transfers per ICNT
    Given "rst_n" is asserted (1)
    And bits 7:6 of SPER (ICNT) equal ICNT_VAL
    And the completed-transfer count since last SPIF set equals N
    And a byte transfer completes this cycle
    When one clock edge occurs
    Then SPIF should equal 1 if (N + 1) equals (ICNT_VAL + 1), else SPIF should equal 0

  @clock_divider
  Formal Scenario: SPI clock divider ratio matches ESPR/SPR encoding
    Given "rst_n" is asserted (1)
    And bits 1:0 of SPER (ESPR) equal ESPR_VAL
    And bits 1:0 of SPCR (SPR) equal SPR_VAL
    And ESPR_VAL and SPR_VAL do not both equal a reserved encoding of 2'b11 for ESPR
    When the internal clock divider counts a full period
    Then the resulting "sck_o" toggle period should correspond to the divide ratio defined by {ESPR_VAL, SPR_VAL}

  @cpol_cpha
  Formal Scenario: sck_o idle level follows CPOL when no transfer is active
    Given "rst_n" is asserted (1)
    And bit 3 of SPCR (CPOL) equals CPOL_VAL
    And no SPI transfer is in progress
    When one clock edge occurs
    Then "sck_o" should equal CPOL_VAL

  @shift_datapath
  Formal Scenario: mosi_o shifts transmit bit corresponding to current bit index
    Given "rst_n" is asserted (1)
    And an SPI transfer is in progress with transmit shift register value TX_BYTE
    And the current bit index equals IDX
    When one SPI shift clock event occurs
    Then "mosi_o" should equal bit IDX of TX_BYTE

  @fifo_full_overrun
  Formal Scenario: Write FIFO full flag asserted when four bytes are enqueued without dequeue
    Given "rst_n" is asserted (1)
    And the write FIFO currently holds 4 entries
    And no read-enable is asserted to the write FIFO
    When one clock edge occurs
    Then the write FIFO full flag should equal 1

  @fifo_empty
  Formal Scenario: Read FIFO empty flag asserted when no entries remain
    Given "rst_n" is asserted (1)
    And the read FIFO currently holds 0 entries
    When one clock edge occurs
    Then the read FIFO empty flag should equal 1