Feature: I2C Master Core Formal Verification
  Formal specification for the OpenCores I2C-Master Core covering the
  WISHBONE interface, register file behavior, command/status semantics,
  and I2C protocol signal generation (START/STOP/Repeated START,
  clock stretching, arbitration).

  Background:
    Given a synchronous design clocked on the rising edge of "wb_clk_i"
    And a synchronous active-high reset signal "wb_rst_i"
    And an asynchronous reset signal "arst_i" with configurable active level "ARST_LVL"
    And the WISHBONE interface signals "wb_adr_i", "wb_dat_i", "wb_dat_o", "wb_we_i", "wb_stb_i", "wb_cyc_i", "wb_ack_o"
    And the register addresses PRERlo=0x00, PRERhi=0x01, CTR=0x02, TXR/RXR=0x03, CR/SR=0x04
    And all outputs are registered and every WISHBONE access takes exactly 2 clock cycles

  # ---------------------------------------------------------------------
  # RESET BEHAVIOR
  # ---------------------------------------------------------------------

  @reset
  Formal Scenario: Synchronous reset clears all registers
    Given "wb_rst_i" is asserted for one clock cycle
    When the clock advances by one edge
    Then the Prescale register should equal 16'hFFFF
    And the Control register should equal 8'h00
    And the Transmit register should equal 8'h00
    And the Command register should equal 8'h00
    And the Status register should equal 8'h00

  @reset
  Formal Scenario: Synchronous reset clears the Receive register
    Given "wb_rst_i" is asserted for one clock cycle
    When the clock advances by one edge
    Then the Receive register should equal 8'h00

  @reset
  Formal Scenario: Asynchronous reset clears all registers regardless of clock
    Given "arst_i" is driven to its active level "ARST_LVL"
    When any number of clock edges occur while "arst_i" remains active
    Then the Prescale register should equal 16'hFFFF
    And the Control register should equal 8'h00
    And the Command register should equal 8'h00
    And the Status register should equal 8'h00

  @reset
  Formal Scenario: Deasserting reset allows normal operation
    Given "wb_rst_i" is asserted then deasserted
    And "arst_i" is held at its inactive level
    When a valid WISHBONE write cycle to the Control register occurs with data value CTRL_VAL
    Then the Control register should equal CTRL_VAL within 2 clock cycles

  # ---------------------------------------------------------------------
  # WISHBONE INTERFACE
  # ---------------------------------------------------------------------

  @wishbone
  Formal Scenario: Write cycle acknowledges after two clock cycles
    Given "wb_cyc_i" is 1 and "wb_stb_i" is 1 and "wb_we_i" is 1
    And the address is ADDR and the write data is DATA
    When one clock edge occurs
    Then "wb_ack_o" should be 0
    When a second clock edge occurs
    Then "wb_ack_o" should be 1
    And the register selected by ADDR should equal DATA if ADDR is writable

  @wishbone
  Formal Scenario: Read cycle returns registered value after two clock cycles
    Given "wb_cyc_i" is 1 and "wb_stb_i" is 1 and "wb_we_i" is 0
    And the address is ADDR
    When two clock edges occur
    Then "wb_ack_o" should be 1
    And "wb_dat_o" should equal the value of the register selected by ADDR

  @wishbone
  Formal Scenario: No acknowledge without cycle and strobe asserted
    Given "wb_cyc_i" is 0 or "wb_stb_i" is 0
    When any number of clock edges occur
    Then "wb_ack_o" should remain 0

  @wishbone
  Formal Scenario: wb_ack_o deasserts after cycle completes
    Given a WISHBONE access completed with "wb_ack_o" equal to 1
    When "wb_cyc_i" and "wb_stb_i" are deasserted on the next clock edge
    Then "wb_ack_o" should be 0

  @wishbone
  Formal Scenario: Writing to address 0x03 updates TXR while reading returns RXR contents
    Given a WISHBONE write cycle to address 0x03 with data value TXVAL occurs
    When the write cycle completes
    Then the Transmit register should equal TXVAL
    Given a subsequent WISHBONE read cycle to address 0x03 occurs
    When the read cycle completes
    Then "wb_dat_o" should equal the Receive register value, not TXVAL

  @wishbone
  Formal Scenario: Writing to address 0x04 issues a Command while reading returns Status register contents
    Given a WISHBONE write cycle to address 0x04 with command value CMDVAL occurs
    When the write cycle completes
    Then the Command register should reflect CMDVAL as accepted on the next clock edge
    Given a subsequent WISHBONE read cycle to address 0x04 occurs
    When the read cycle completes
    Then "wb_dat_o" should equal the Status register value

  # ---------------------------------------------------------------------
  # PRESCALE REGISTER
  # ---------------------------------------------------------------------

  @prescale
  Formal Scenario: Prescale register lo-byte is writable when EN is cleared
    Given the EN bit of the Control register is 0
    And a WISHBONE write to PRERlo with data value PVAL occurs
    When the write cycle completes
    Then the Prescale register lo-byte should equal PVAL

  @prescale
  Formal Scenario: Prescale register hi-byte is writable when EN is cleared
    Given the EN bit of the Control register is 0
    And a WISHBONE write to PRERhi with data value PVAL occurs
    When the write cycle completes
    Then the Prescale register hi-byte should equal PVAL

  @prescale
  Formal Scenario: Prescale register readback matches last written value
    Given the Prescale register was previously written with value PVAL
    When a WISHBONE read of PRERlo or PRERhi occurs
    Then "wb_dat_o" should equal the corresponding byte of PVAL

  @prescale
  Formal Scenario: Prescale register write ignored while EN is set
    Given the EN bit of the Control register is 1
    And the Prescale register holds value PVAL_OLD
    And a WISHBONE write to PRERlo or PRERhi with data value PVAL_NEW occurs
    When the write cycle completes
    Then the Prescale register should remain equal to PVAL_OLD

  # ---------------------------------------------------------------------
  # CONTROL REGISTER
  # ---------------------------------------------------------------------

  @control
  Formal Scenario: Control register EN and IEN bits are directly writable
    Given a WISHBONE write to CTR with data value CVAL occurs
    When the write cycle completes
    Then bit 7 (EN) of the Control register should equal bit 7 of CVAL
    And bit 6 (IEN) of the Control register should equal bit 6 of CVAL

  @control
  Formal Scenario: Reserved Control register bits always read as zero
    Given any write to CTR with arbitrary data value CVAL occurs
    When the write cycle completes and the register is read back
    Then bits 5:0 of the Control register should equal 0

  @control
  Formal Scenario: Core ignores new commands while EN is cleared
    Given the EN bit of the Control register is 0
    And a WISHBONE write to CR with any command value CMD occurs
    When the clock advances
    Then the TIP bit of the Status register should remain 0
    And no START, STOP, or data transfer should be initiated

  # ---------------------------------------------------------------------
  # COMMAND REGISTER SEMANTICS
  # ---------------------------------------------------------------------

  @command
  Formal Scenario: STA bit triggers a START condition when EN is set
    Given the EN bit is 1
    And a WISHBONE write to CR occurs with STA bit set to 1 and WR bit set to 1
    When the command is accepted on the next clock edge
    Then the TIP bit of the Status register should become 1
    And a START condition should be generated on the I2C bus

  @command
  Formal Scenario: STO bit triggers a STOP condition when EN is set
    Given the EN bit is 1
    And a WISHBONE write to CR occurs with STO bit set to 1
    When the command completes
    Then a STOP condition should be generated on the I2C bus
    And the Busy bit of the Status register should become 0

  @command
  Formal Scenario: Command register auto-clears STA, STO, RD, WR, IACK bits
    Given a WISHBONE write to CR occurs with any combination of STA, STO, RD, WR, IACK set to 1
    When one clock cycle elapses after the command is accepted
    Then bits 7, 6, 5, 4, and 0 of the Command register should read as 0

  @command
  Formal Scenario: Reserved Command register bits always read as zero
    Given a write to CR occurs with arbitrary values in bits 2:1
    When the register is subsequently read
    Then bits 2:1 of the Command register should equal 0

  @command
  Formal Scenario: WR bit initiates transmission of TXR contents
    Given the EN bit is 1
    And the Transmit register holds value TXVAL
    And a WISHBONE write to CR occurs with WR bit set to 1
    When the byte transfer completes
    Then the transmitted byte on the I2C bus should equal TXVAL

  @command
  Formal Scenario: RD bit initiates a read and stores result in RXR
    Given the EN bit is 1
    And a WISHBONE write to CR occurs with RD bit set to 1
    When the byte transfer completes
    Then the Receive register should equal the byte received via SDA
    And the IF bit of the Status register should become 1

  @command
  Formal Scenario: ACK bit controls acknowledge polarity when receiving
    Given the EN bit is 1
    And a WISHBONE write to CR occurs with RD bit set to 1 and ACK bit set to ACKVAL
    When the 9th clock cycle of the byte transfer occurs
    Then the SDA line driven by the core should equal ACKVAL during the acknowledge slot

  @command
  Formal Scenario: IACK bit clears pending interrupt
    Given the IF bit of the Status register is 1
    And a WISHBONE write to CR occurs with IACK bit set to 1
    When the command is processed
    Then the IF bit of the Status register should become 0
    And "wb_inta_o" should become 0

  # ---------------------------------------------------------------------
  # STATUS REGISTER SEMANTICS
  # ---------------------------------------------------------------------

  @status
  Formal Scenario: RxACK reflects the acknowledge bit received from the slave
    Given a byte transfer completes with the slave driving SDA to value SLAVE_ACK during the ack slot
    When the transfer finishes
    Then the RxACK bit of the Status register should equal SLAVE_ACK

  @status
  Formal Scenario: Busy bit set after START condition
    Given a START condition is generated
    When the START completes
    Then the Busy bit of the Status register should become 1

  @status
  Formal Scenario: Busy bit cleared after STOP condition
    Given a subsequent STOP condition is generated while Busy is 1
    When the STOP completes
    Then the Busy bit of the Status register should become 0

  @status
  Formal Scenario: TIP bit is asserted during a byte transfer and deasserted after completion
    Given the EN bit is 1
    And a WISHBONE write to CR occurs with WR or RD bit set to 1
    When the byte transfer begins
    Then the TIP bit of the Status register should equal 1
    When the byte transfer completes
    Then the TIP bit of the Status register should equal 0

  @status
  Formal Scenario: IF bit is set upon byte transfer completion
    Given a byte transfer is in progress
    When the transfer completes
    Then the IF bit of the Status register should become 1
    And "wb_inta_o" should equal the IEN bit value if IF is 1

  @status
  Formal Scenario: Reserved Status register bits always read as zero
    When the Status register is read at any time
    Then bits 4:2 of the Status register should equal 0

  # ---------------------------------------------------------------------
  # ARBITRATION LOST
  # ---------------------------------------------------------------------

  @arbitration
  Formal Scenario: Arbitration lost detected when SDA driven high reads low
    Given the core drives "sda_pad_o" to 1 during a transfer
    And "sda_pad_i" is sampled as 0 on the same bit-time
    When the sampling occurs
    Then the AL bit of the Status register should become 1
    And the current transfer should be automatically cancelled
    And the IF bit of the Status register should become 1

  @arbitration
  Formal Scenario: Arbitration lost detected on unexpected STOP condition
    Given the core has not issued a STOP command
    And a STOP condition (low-to-high transition of SDA while SCL is high) is detected on the bus
    When the STOP condition is sampled
    Then the AL bit of the Status register should become 1

  @arbitration
  Formal Scenario: No arbitration lost when core-driven SDA matches sampled SDA
    Given the core drives "sda_pad_o" to value SDA_DRV during a transfer
    And "sda_pad_i" is sampled equal to SDA_DRV
    When the sampling occurs
    Then the AL bit of the Status register should remain 0

  # ---------------------------------------------------------------------
  # INTERRUPT GENERATION
  # ---------------------------------------------------------------------

  @interrupt
  Formal Scenario: Interrupt output reflects IF and IEN
    Given the IEN bit of the Control register equals IEN_VAL
    And the IF bit of the Status register equals IF_VAL
    When the clock advances
    Then "wb_inta_o" should equal (IEN_VAL AND IF_VAL)

  @interrupt
  Formal Scenario: Interrupt cleared by IACK regardless of IEN
    Given the IF bit of the Status register is 1
    And a WISHBONE write to CR occurs with IACK bit set to 1
    When the command completes
    Then the IF bit should become 0
    And "wb_inta_o" should become 0

  # ---------------------------------------------------------------------
  # SCL / SDA LINE BEHAVIOR
  # ---------------------------------------------------------------------

  @io
  Formal Scenario: SCL output enable low during clock stretching wait
    Given the master intends to drive SCL low as part of a bit operation
    And an external slave holds "scl_pad_i" low after the master releases it
    When the core samples "scl_pad_i" as still low
    Then the core should remain in a wait state and not proceed to the next bit-phase
    And "scl_pad_oe" should reflect the core releasing (not driving high) the line

  @io
  Formal Scenario: SDA line held stable during high period of SCL for data bits
    Given a data bit BIT_VAL is being transmitted
    And "scl_pad_o" is high during the sampling window
    When the bit is sampled
    Then "sda_pad_o" should remain equal to BIT_VAL throughout the high period of SCL

  @io
  Formal Scenario: START condition is a high-to-low SDA transition while SCL is high
    Given the bus is idle with both SCL and SDA high
    And the core issues a START command
    When the START sequence executes
    Then "sda_pad_o" should transition from 1 to 0 while "scl_pad_o" remains 1

  @io
  Formal Scenario: STOP condition is a low-to-high SDA transition while SCL is high
    Given the core issues a STOP command
    When the STOP sequence executes
    Then "sda_pad_o" should transition from 0 to 1 while "scl_pad_o" remains 1

  # ---------------------------------------------------------------------
  # ENABLE / DISABLE BEHAVIOR
  # ---------------------------------------------------------------------

  @enable
  Formal Scenario: Clearing EN during idle disables core command acceptance
    Given no transfer is in progress (TIP is 0)
    And the EN bit transitions from 1 to 0
    When a subsequent WISHBONE write to CR with WR or RD set occurs
    Then the TIP bit should remain 0
    And no I2C bus activity should be generated

  @enable
  Formal Scenario: Pending transfer completes even if EN is cleared mid-transfer
    Given a byte transfer is in progress (TIP is 1)
    And the EN bit is cleared to 0 during the transfer
    When the in-progress transfer completes
    Then the transfer should finish normally
    And the IF bit should be set upon completion