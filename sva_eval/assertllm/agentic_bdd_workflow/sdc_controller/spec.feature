Feature: SDC/MMC Controller Register and Protocol Behavior

  As a hardware verification engineer
  I want to formally verify the SDC/MMC Controller's register access,
  interrupt behavior, buffer descriptor handling, and Wishbone interface
  So that the controller complies with its specification

  Background:
    Given the system clock "wb_clk_i" is toggling
    And the synchronous reset "wb_rst_i" is active low
    And all registers hold their reset values while "wb_rst_i" is asserted
    And all Wishbone transactions are synchronized to the rising edge of "wb_clk_i"

  @reset @core
  Formal Scenario: Core registers return to reset values after external reset
    Given "wb_rst_i" is asserted for at least one clock cycle
    When "wb_rst_i" is deasserted
    Then the Argument register should equal 32'h0000_0000
    And the Command Setting register should equal 16'h0000
    And the Status register should equal 16'h0000
    And the Response register should equal 32'h0000_0000
    And the Timeout register should equal 16'h0000
    And the Normal Interrupt Status register should equal 16'h0000
    And the Error Interrupt Status register should equal 16'h0000
    And the Normal Interrupt Enable register should equal 16'h0000
    And the Error Interrupt Enable register should equal 16'h0000
    And the Clock Divider register should equal 8'h00
    And the BD Buffer Status register should equal 16'h0404
    And the Data Interrupt Status register should equal 16'h0000
    And the Data Interrupt Enable register should equal 16'h0000

  @reset @software
  Formal Scenario: Software reset bit produces the same effect as external reset within bounded cycles
    Given the core is out of external reset
    And any register R holds an arbitrary value V
    And N_RST is a symbolic upper bound on reset completion latency in clock cycles
    When a write of value 8'h01 is performed to the Software Reset register bit SRST
    Then within N_RST clock cycles all registers should equal their defined reset values
    And the SRST bit should remain readable as written until internal reset completes

  @command @argument
  Formal Scenario: Writing the Argument register initiates command transmission
    Given the Command Setting register holds command index CMDI
    And the Command Setting register holds response type RTS
    And the Status register bit CICMD equals 0 (Ready)
    And N_BUSY is a symbolic upper bound on the latency to assert Command Inhibit in clock cycles
    When the Argument register is written with value ARG
    Then a command transmission should be initiated using CMDI and ARG
    And within N_BUSY clock cycles the Status register bit CICMD should equal 1 (Busy)

  @command @busy
  Formal Scenario: Command Inhibit blocks new command while busy
    Given the Status register bit CICMD equals 1 (Busy)
    When the Argument register is written with any value ARG
    Then no new command transmission should be initiated
    And the Status register bit CICMD should remain 1 (Busy)

  @command @response
  Formal Scenario: Command Complete interrupt is set on valid response reception
    Given a command with response type RTS not equal to 0 (response expected) has been sent
    When a valid response terminating sequence is received on the CMD line
    Then the Response register should equal the received response value RESP
    And the Normal Interrupt Status register bit CC should be set to 1
    And the Status register bit CICMD should return to 0 (Ready)

  @command @response @multiword
  Formal Scenario: Command Word Select selects correct 32-bit segment of a 136-bit long response
    Given a command has been sent with response type RTS encoding a 136-bit long response
    And the full 136-bit response is stored internally as four 32-bit words indexed 0 through 3
    And the Command Setting register field CMDW holds symbolic word index W where W is in range [0, 3]
    When the Response register is read
    Then the Response register should equal the stored response word at index W
    And selecting a different word index W' not equal to W should yield a different stored response word whenever the corresponding word contents differ

  @command @crc_error
  Formal Scenario: Command CRC error is flagged when CRC check enabled and CRC mismatch occurs
    Given the Command Setting register bit CIRC equals 1 (perform CRC check)
    And a response is received with an incorrect CRC7 checksum
    Then the Error Interrupt Status register bit CCRC should be set to 1
    And the Normal Interrupt Status register bit EI should be set to 1

  @command @index_error
  Formal Scenario: Command index error is flagged when index check enabled and index mismatch occurs
    Given the Command Setting register bit CICE equals 1 (perform index check)
    And a response is received whose command index differs from the sent CMDI
    Then the Error Interrupt Status register bit CIE should be set to 1
    And the Normal Interrupt Status register bit EI should be set to 1

  @command @timeout
  Formal Scenario: Command timeout error is flagged when no response arrives within CTO cycles
    Given the Timeout register holds value CTO greater than 0
    And a command has been sent with response expected
    When no valid response start bit is detected within CTO system clock cycles
    Then the Error Interrupt Status register bit CTE should be set to 1
    And the Normal Interrupt Status register bit EI should be set to 1

  @interrupt @clear
  Formal Scenario: Writing any value to Normal Interrupt Status register clears it
    Given the Normal Interrupt Status register holds an arbitrary nonzero value V
    When any value W is written to the Normal Interrupt Status register
    Then the Normal Interrupt Status register should equal 16'h0000

  @interrupt @clear
  Formal Scenario: Writing any value to Error Interrupt Status register clears it
    Given the Error Interrupt Status register holds an arbitrary nonzero value V
    When any value W is written to the Error Interrupt Status register
    Then the Error Interrupt Status register should equal 16'h0000

  @interrupt @enable
  Formal Scenario: Normal interrupt enable gates the error interrupt output
    Given the Normal Interrupt Enable register bit EEI equals E
    And the Normal Interrupt Status register bit EI equals S
    Then the asserted error interrupt output should equal (E and S)

  @interrupt @enable
  Formal Scenario: Normal interrupt enable gates the command complete interrupt output
    Given the Normal Interrupt Enable register bit ECC equals E
    And the Normal Interrupt Status register bit CC equals S
    Then the asserted command complete interrupt output should equal (E and S)

  @interrupt @enable
  Formal Scenario: Error interrupt enable gates individual error interrupt bits
    Given the Error Interrupt Enable register bits ECIE, ECCRC, ECTE equal E_CIE, E_CCRC, E_CTE respectively
    And the Error Interrupt Status register bits CIE, CCRC, CTE equal S_CIE, S_CCRC, S_CTE respectively
    Then the asserted CIE interrupt should equal (E_CIE and S_CIE)
    And the asserted CCRC interrupt should equal (E_CCRC and S_CCRC)
    And the asserted CTE interrupt should equal (E_CTE and S_CTE)

  @readonly @blocksize
  Formal Scenario: Block Size register is read-only and fixed to 512
    Given the Block Size register holds value 16'h0200 after reset
    When any value V is written to the Block Size register address
    Then the Block Size register should remain equal to 16'h0200

  @readonly @powercontrol
  Formal Scenario: Power Control register is read-only
    Given the Power Control register holds its reset value 8'h07
    When any value V is written to the Power Control register address
    Then the Power Control register should remain equal to 8'h07

  @readonly @capability
  Formal Scenario: Capability register always reads as reserved zero
    When the Capability register is read
    Then the returned value should equal 16'h0000

  @clock_divider
  Formal Scenario: Clock divider register controls SD clock output frequency ratio
    Given the Clock Divider register holds value CLKD
    Then the generated SD clock period should equal the input clock period multiplied by (2 * (CLKD + 1))

  @clock_divider @encoding
  Formal Scenario: Clock divider field value maps consistently to divisor via defined formula
    Given the Clock Divider register field CLKD holds symbolic value K where K is in range [0, 255]
    Then the resulting SD clock divisor should equal 2 * (K + 1)
    And a CLKD value of 0 should yield divisor 2
    And a CLKD value of 1 should yield divisor 4
    And a CLKD value of 2 should yield divisor 6
    And for any two distinct values K1 and K2 the resulting divisors should be distinct

  @bd @status
  Formal Scenario: BD Buffer Status register free-count decreases on new TX descriptor write
    Given the BD Buffer Status register field FBTX holds value N greater than 0
    When a complete BD TX descriptor (memory address and block address) is written
    Then the BD Buffer Status register field FBTX should equal (N - 1)

  @bd @status
  Formal Scenario: BD Buffer Status register free-count increases on TX descriptor completion
    Given the BD Buffer Status register field FBTX holds value N less than its maximum
    When a queued TX descriptor completes transmission successfully
    Then the BD Buffer Status register field FBTX should equal (N + 1)

  @bd @status
  Formal Scenario: BD Buffer Status register free-count decreases on new RX descriptor write
    Given the BD Buffer Status register field FBRX holds value N greater than 0
    When a complete BD RX descriptor (memory address and block address) is written
    Then the BD Buffer Status register field FBRX should equal (N - 1)

  @bd @status
  Formal Scenario: BD Buffer Status register free-count increases on RX descriptor completion
    Given the BD Buffer Status register field FBRX holds value N less than its maximum
    When a queued RX descriptor completes reception successfully
    Then the BD Buffer Status register field FBRX should equal (N + 1)

  @bd @no_free
  Formal Scenario: No new BD descriptor is accepted when free count is zero
    Given the BD Buffer Status register field FBTX equals 0
    When a write to the BD TX register is attempted
    Then the BD Buffer Status register field FBTX should remain equal to 0
    And the write should have no effect on the descriptor queue

  @data @interrupt
  Formal Scenario: Data Interrupt Status TRS bit set on successful block transmission
    Given a data block transmission has been initiated from a queued BD
    When the block transmission completes with a correct CRC16 checksum
    Then the Data Interrupt Status register bit TRS should be set to 1

  @data @interrupt
  Formal Scenario: Data Interrupt Status TRE bit set on CRC failure during transmission
    Given a data block transmission is in progress
    When the received or computed CRC16 checksum does not match the expected value
    Then the Data Interrupt Status register bit TRE should be set to 1

  @data @interrupt
  Formal Scenario: Data Interrupt Status FIFOE bit set on FIFO underflow or overflow
    Given a data transfer is in progress with FIFO occupancy F
    When F causes a FIFO underflow or overflow condition
    Then the Data Interrupt Status register bit FIFOE should be set to 1

  @data @interrupt
  Formal Scenario: Data Interrupt Status MRC bit set after maximum resend attempts
    Given a data transmission has failed and been resent RESEND_MAX_CNT times
    When the RESEND_MAX_CNT-th resend attempt also fails
    Then the Data Interrupt Status register bit MRC should be set to 1

  @data @interrupt @clear
  Formal Scenario: Writing any value to Data Interrupt Status register clears it
    Given the Data Interrupt Status register holds an arbitrary nonzero value V
    When any value W is written to the Data Interrupt Status register
    Then the Data Interrupt Status register should equal 16'h0000

  @data @interrupt @enable
  Formal Scenario: Data interrupt enable gates the TRS interrupt output
    Given the Data Interrupt Enable register bit ETRS equals E
    And the Data Interrupt Status register bit TRS equals S
    Then the asserted TRS interrupt output should equal (E and S)

  @wishbone @slave
  Formal Scenario: Wishbone slave acknowledges a valid single-cycle access
    Given "wb_cyc_i" is asserted
    And "wb_stb_i" is asserted
    And "wb_adr_i" addresses a valid register
    Then "wb_ack_o" should be asserted within one clock cycle
    And "wb_ack_o" should be deasserted the cycle after the access completes

  @wishbone @slave @write
  Formal Scenario: Wishbone slave write updates the addressed RW register
    Given "wb_cyc_i" and "wb_stb_i" are asserted
    And "wb_we_i" is asserted
    And "wb_adr_i" addresses a writable register REG
    And "wb_dat_i" equals value D
    And "wb_sel_i" selects all valid byte lanes
    When "wb_ack_o" is asserted
    Then the register REG should equal D masked by "wb_sel_i"

  @wishbone @slave @read
  Formal Scenario: Wishbone slave read returns the addressed register value
    Given "wb_cyc_i" and "wb_stb_i" are asserted
    And "wb_we_i" is deasserted
    And "wb_adr_i" addresses register REG holding value V
    When "wb_ack_o" is asserted
    Then "wb_dat_o" should equal V

  @wishbone @master @dma
  Formal Scenario: Master Wishbone interface initiates a memory access only when a BD is active
    Given a TX or RX buffer descriptor is currently active with memory address A
    When the Data Master requests a DMA transfer
    Then "m_wb_cyc_o" should be asserted
    And "m_wb_adr_o" should equal A
    And "m_wb_we_o" should equal 1 for a read-from-memory (TX) transfer or 0 for a write-to-memory (RX) transfer

  @wishbone @master @idle
  Formal Scenario: Master Wishbone interface remains idle with no pending BD
    Given no TX or RX buffer descriptor is active
    Then "m_wb_cyc_o" should remain deasserted
    And "m_wb_we_o" and "m_wb_adr_o" should not change