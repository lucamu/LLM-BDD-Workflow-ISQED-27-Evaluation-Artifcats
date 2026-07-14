Feature: 10GE MAC Core Formal Verification

  As a hardware verification engineer
  I want to formally verify the 10GE MAC Core
  So that register access, interrupt logic, packet interfaces, and fault handling are guaranteed correct

  Background:
    Given the system clock "wb_clk_i" is toggling
    And the system clock "clk_156m25" is toggling
    And the system clock "clk_xgmii_rx" is toggling
    And the system clock "clk_xgmii_tx" is toggling
    And "wb_rst_i" is active high and synchronous to "wb_clk_i"
    And "reset_156m25_n" is active low and synchronous to "clk_156m25"
    And "reset_xgmii_rx_n" is active low and synchronous to "clk_xgmii_rx"
    And "reset_xgmii_tx_n" is active low and synchronous to "clk_xgmii_tx"
    And all resets are de-asserted within 2 cycles of each other

  # -------------------------------------------------------------------
  # RESET BEHAVIOR
  # -------------------------------------------------------------------

  @reset
  Formal Scenario: Configuration Register 0 resets to default value
    Given "wb_rst_i" is asserted
    When one clock edge of "wb_clk_i" occurs
    Then Configuration Register 0 should equal 32'h00000001

  @reset
  Formal Scenario: TX Enable bit is set by default after reset
    Given "wb_rst_i" is asserted
    When one clock edge of "wb_clk_i" occurs
    Then bit 0 "TX Enable" of Configuration Register 0 should equal 1

  @reset
  Formal Scenario: Interrupt Pending Register resets to zero
    Given "wb_rst_i" is asserted
    When one clock edge of "wb_clk_i" occurs
    Then Interrupt Pending Register should equal 32'h00000000

  @reset
  Formal Scenario: Interrupt Status Register resets to zero
    Given "wb_rst_i" is asserted
    When one clock edge of "wb_clk_i" occurs
    Then Interrupt Status Register should equal 32'h00000000

  @reset
  Formal Scenario: Interrupt Mask Register resets to all interrupts disabled
    Given "wb_rst_i" is asserted
    When one clock edge of "wb_clk_i" occurs
    Then Interrupt Mask Register should equal 32'h00000000

  @reset
  Formal Scenario: Transmit Octets Count Register resets to zero
    Given "wb_rst_i" is asserted
    When one clock edge of "wb_clk_i" occurs
    Then Transmit Octets Count Register should equal 32'h00000000

  @reset
  Formal Scenario: Transmit Packet Count Register resets to zero
    Given "wb_rst_i" is asserted
    When one clock edge of "wb_clk_i" occurs
    Then Transmit Packet Count Register should equal 32'h00000000

  @reset
  Formal Scenario: Receive Octets Count Register resets to zero
    Given "wb_rst_i" is asserted
    When one clock edge of "wb_clk_i" occurs
    Then Receive Octets Count Register should equal 32'h00000000

  @reset
  Formal Scenario: Receive Packet Count Register resets to zero
    Given "wb_rst_i" is asserted
    When one clock edge of "wb_clk_i" occurs
    Then Receive Packet Count Register should equal 32'h00000000

  # -------------------------------------------------------------------
  # WISHBONE REGISTER ACCESS
  # -------------------------------------------------------------------

  @wishbone @register
  Formal Scenario: Configuration Register 0 write updates TX Enable bit
    Given "wb_rst_i" is de-asserted
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "wb_we_i" is 1
    And "wb_adr_i" is address 8'h00
    And "wb_dat_i" is value D
    When one clock edge of "wb_clk_i" occurs
    Then bit 0 of Configuration Register 0 should equal bit 0 of D
    And "wb_ack_o" should equal 1

  @wishbone @register
  Formal Scenario: Configuration Register 0 reserved bits always read zero
    Given "wb_rst_i" is de-asserted
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "wb_we_i" is 0
    And "wb_adr_i" is address 8'h00
    When one clock edge of "wb_clk_i" occurs
    Then bits 31 to 1 of "wb_dat_o" should equal 0

  @wishbone @register
  Formal Scenario: Interrupt Pending Register is cleared on read
    Given "wb_rst_i" is de-asserted
    And Interrupt Pending Register equals value P where P is nonzero
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "wb_we_i" is 0
    And "wb_adr_i" is address 8'h08
    When one clock edge of "wb_clk_i" occurs
    Then "wb_dat_o" should equal P
    And on the following clock edge Interrupt Pending Register should equal 0

  @wishbone @register
  Formal Scenario: Interrupt Status Register is read-only and reflects live status
    Given "wb_rst_i" is de-asserted
    And the internal interrupt status lines equal value S
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "wb_we_i" is 0
    And "wb_adr_i" is address 8'h0c
    When one clock edge of "wb_clk_i" occurs
    Then "wb_dat_o" should equal S

  @wishbone @register
  Formal Scenario: Interrupt Mask Register write is read back correctly
    Given "wb_rst_i" is de-asserted
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "wb_we_i" is 1
    And "wb_adr_i" is address 8'h10
    And "wb_dat_i" is value M
    When one clock edge of "wb_clk_i" occurs
    Then Interrupt Mask Register should equal M

  @wishbone @register
  Formal Scenario: Transmit Octets Count Register is read-only
    Given "wb_rst_i" is de-asserted
    And Transmit Octets Count Register equals value C
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "wb_we_i" is 1
    And "wb_adr_i" is address 8'h80
    And "wb_dat_i" is value D
    When one clock edge of "wb_clk_i" occurs
    Then Transmit Octets Count Register should equal C

  @wishbone @register
  Formal Scenario: Wishbone acknowledge asserted only during valid cycle
    Given "wb_rst_i" is de-asserted
    And "wb_cyc_i" is C
    And "wb_stb_i" is S
    When one clock edge of "wb_clk_i" occurs
    Then "wb_ack_o" should equal 1 if C equals 1 and S equals 1
    And "wb_ack_o" should equal 0 if C equals 0 or S equals 0

  # -------------------------------------------------------------------
  # INTERRUPT LOGIC
  # -------------------------------------------------------------------

  @interrupt
  Formal Scenario: Interrupt output asserted when any masked interrupt is pending
    Given "wb_rst_i" is de-asserted
    And Interrupt Pending Register equals value P
    And Interrupt Mask Register equals value M
    When one clock edge of "wb_clk_i" occurs
    Then "wb_int_o" should equal 1 if (P and M) is nonzero
    And "wb_int_o" should equal 0 if (P and M) equals 0

  @interrupt
  Formal Scenario: TX Data FIFO Overflow sets bit 0 of Interrupt Pending Register
    Given "wb_rst_i" is de-asserted
    And a TX data FIFO overflow condition occurs
    When one clock edge of "clk_156m25" occurs
    Then bit 0 of Interrupt Pending Register should equal 1

  @interrupt
  Formal Scenario: TX Data FIFO Underflow sets bit 1 of Interrupt Pending Register
    Given "wb_rst_i" is de-asserted
    And a TX data FIFO underflow condition occurs
    When one clock edge of "clk_156m25" occurs
    Then bit 1 of Interrupt Pending Register should equal 1

  @interrupt
  Formal Scenario: RX Data FIFO Overflow sets bit 2 of Interrupt Pending Register
    Given "wb_rst_i" is de-asserted
    And a RX data FIFO overflow condition occurs
    When one clock edge of "clk_156m25" occurs
    Then bit 2 of Interrupt Pending Register should equal 1

  @interrupt
  Formal Scenario: RX Data FIFO Underflow sets bit 3 of Interrupt Pending Register
    Given "wb_rst_i" is de-asserted
    And a RX data FIFO underflow condition occurs
    When one clock edge of "clk_156m25" occurs
    Then bit 3 of Interrupt Pending Register should equal 1

  @interrupt
  Formal Scenario: Local Fault transition sets bit 4 of Interrupt Pending Register
    Given "wb_rst_i" is de-asserted
    And the fault state-machine transitions in or out of local fault
    When one clock edge of "clk_xgmii_rx" occurs
    Then bit 4 of Interrupt Pending Register should equal 1

  @interrupt
  Formal Scenario: Remote Fault transition sets bit 5 of Interrupt Pending Register
    Given "wb_rst_i" is de-asserted
    And the fault state-machine transitions in or out of remote fault
    When one clock edge of "clk_xgmii_rx" occurs
    Then bit 5 of Interrupt Pending Register should equal 1

  @interrupt
  Formal Scenario: RX Pause Frame received sets bit 6 of Interrupt Pending Register
    Given "wb_rst_i" is de-asserted
    And a pause frame is received
    When one clock edge of "clk_xgmii_rx" occurs
    Then bit 6 of Interrupt Pending Register should equal 1

  @interrupt
  Formal Scenario: RX CRC Error sets bit 7 of Interrupt Pending Register
    Given "wb_rst_i" is de-asserted
    And a frame is received with invalid CRC
    When one clock edge of "clk_xgmii_rx" occurs
    Then bit 7 of Interrupt Pending Register should equal 1

  @interrupt
  Formal Scenario: RX Fragment Error sets bit 8 of Interrupt Pending Register
    Given "wb_rst_i" is de-asserted
    And a fragment is received without a matching end of frame
    When one clock edge of "clk_xgmii_rx" occurs
    Then bit 8 of Interrupt Pending Register should equal 1

  # -------------------------------------------------------------------
  # STATISTICS COUNTERS
  # -------------------------------------------------------------------

  @stats
  Formal Scenario: Transmit Octets Count increments by transferred byte count
    Given "wb_rst_i" is de-asserted
    And Transmit Octets Count Register equals value N
    And a valid transmit word transfer occurs with byte count B
    When one clock edge of "clk_156m25" occurs
    Then Transmit Octets Count Register should equal N + B

  @stats
  Formal Scenario: Transmit Packet Count increments on end of packet
    Given "wb_rst_i" is de-asserted
    And Transmit Packet Count Register equals value N
    And "pkt_tx_val" is 1
    And "pkt_tx_eop" is 1
    When one clock edge of "clk_156m25" occurs
    Then Transmit Packet Count Register should equal N + 1

  @stats
  Formal Scenario: Transmit Packet Count does not increment without EOP
    Given "wb_rst_i" is de-asserted
    And Transmit Packet Count Register equals value N
    And "pkt_tx_val" is 1
    And "pkt_tx_eop" is 0
    When one clock edge of "clk_156m25" occurs
    Then Transmit Packet Count Register should equal N

  @stats
  Formal Scenario: Receive Octets Count increments by valid received byte count
    Given "wb_rst_i" is de-asserted
    And Receive Octets Count Register equals value N
    And a valid receive word transfer occurs with byte count B
    When one clock edge of "clk_156m25" occurs
    Then Receive Octets Count Register should equal N + B

  @stats
  Formal Scenario: Receive Packet Count increments on valid end of packet
    Given "wb_rst_i" is de-asserted
    And Receive Packet Count Register equals value N
    And "pkt_rx_val" is 1
    And "pkt_rx_eop" is 1
    And "pkt_rx_err" is 0
    When one clock edge of "clk_156m25" occurs
    Then Receive Packet Count Register should equal N + 1

  @stats
  Formal Scenario: Receive Packet Count does not increment on errored end of packet
    Given "wb_rst_i" is de-asserted
    And Receive Packet Count Register equals value N
    And "pkt_rx_val" is 1
    And "pkt_rx_eop" is 1
    And "pkt_rx_err" is 1
    When one clock edge of "clk_156m25" occurs
    Then Receive Packet Count Register should equal N

  @stats
  Formal Scenario: Statistics counters wrap on overflow
    Given "wb_rst_i" is de-asserted
    And Transmit Octets Count Register equals 32'hFFFFFFFF
    And a valid transmit word transfer occurs with byte count B where B is greater than 0
    When one clock edge of "clk_156m25" occurs
    Then Transmit Octets Count Register should equal (32'hFFFFFFFF + B) mod 2^32

  # -------------------------------------------------------------------
  # PACKET RECEIVE INTERFACE
  # -------------------------------------------------------------------

  @pkt_rx
  Formal Scenario: Receive data valid asserted one cycle after read enable
    Given "reset_156m25_n" is de-asserted high
    And "pkt_rx_avail" is 1
    And "pkt_rx_ren" is 1
    And no FIFO underflow occurs
    When one clock edge of "clk_156m25" occurs
    Then "pkt_rx_val" should equal 1 on the next cycle

  @pkt_rx
  Formal Scenario: Receive Start of Packet asserted on first word of frame
    Given "reset_156m25_n" is de-asserted high
    And the current word is the first word of a received frame
    When one clock edge of "clk_156m25" occurs
    Then "pkt_rx_sop" should equal 1

  @pkt_rx
  Formal Scenario: Receive End of Packet asserted on last word of frame
    Given "reset_156m25_n" is de-asserted high
    And the current word is the last word of a received frame
    When one clock edge of "clk_156m25" occurs
    Then "pkt_rx_eop" should equal 1

  @pkt_rx
  Formal Scenario: Receive modulus indicates valid bytes in little endian mode
    Given "reset_156m25_n" is de-asserted high
    And big endian mode is disabled
    And "pkt_rx_eop" is 1
    And the last word contains valid byte count V where V is between 1 and 8
    When one clock edge of "clk_156m25" occurs
    Then "pkt_rx_mod" should equal V mod 8

  @pkt_rx
  Formal Scenario: Receive error asserted on CRC failure
    Given "reset_156m25_n" is de-asserted high
    And a CRC error was detected for the current frame
    And "pkt_rx_val" is 1
    When one clock edge of "clk_156m25" occurs
    Then "pkt_rx_err" should equal 1

  @pkt_rx
  Formal Scenario: Receive available reflects FIFO occupancy
    Given "reset_156m25_n" is de-asserted high
    And the RX FIFO contains at least one complete frame
    When one clock edge of "clk_156m25" occurs
    Then "pkt_rx_avail" should equal 1

  @pkt_rx
  Formal Scenario: Receive data is not valid without read enable
    Given "reset_156m25_n" is de-asserted high
    And "pkt_rx_ren" is 0
    When one clock edge of "clk_156m25" occurs
    Then "pkt_rx_val" should equal 0

  # -------------------------------------------------------------------
  # PACKET TRANSMIT INTERFACE
  # -------------------------------------------------------------------

  @pkt_tx
  Formal Scenario: Transmit full asserted when FIFO nears capacity
    Given "reset_156m25_n" is de-asserted high
    And the TX FIFO occupancy equals value O where O is greater than or equal to the near-full threshold
    When one clock edge of "clk_156m25" occurs
    Then "pkt_tx_full" should equal 1

  @pkt_tx
  Formal Scenario: Transmit full de-asserted when FIFO has room
    Given "reset_156m25_n" is de-asserted high
    And the TX FIFO occupancy equals value O where O is less than the near-full threshold
    When one clock edge of "clk_156m25" occurs
    Then "pkt_tx_full" should equal 0

  @pkt_tx
  Formal Scenario: Transmit data accepted into FIFO when valid and not full
    Given "reset_156m25_n" is de-asserted high
    And "pkt_tx_val" is 1
    And "pkt_tx_full" is 0
    And "pkt_tx_data" is value D
    When one clock edge of "clk_156m25" occurs
    Then the TX FIFO should contain an entry equal to D

  @pkt_tx
  Formal Scenario: Transmit modulus indicates valid bytes in little endian mode
    Given "reset_156m25_n" is de-asserted high
    And big endian mode is disabled
    And "pkt_tx_eop" is 1
    And "pkt_tx_mod" is value M where M is between 0 and 7
    When one clock edge of "clk_156m25" occurs
    Then valid bytes of "pkt_tx_data" should equal M mod 8 or 8 if M equals 0

  @pkt_tx
  Formal Scenario: TX Enable disabled prevents transmission
    Given "reset_156m25_n" is de-asserted high
    And bit 0 "TX Enable" of Configuration Register 0 equals 0
    And "pkt_tx_val" is 1
    When one clock edge of "clk_156m25" occurs
    Then no data should be transmitted on "xgmii_txd"

  # -------------------------------------------------------------------
  # XGMII TRANSMIT / RECEIVE INTERFACES
  # -------------------------------------------------------------------

  @xgmii
  Formal Scenario: XGMII transmit control marks non-data bytes
    Given "reset_xgmii_tx_n" is de-asserted high
    And byte position I of "xgmii_txd" carries a control character
    When one clock edge of "clk_xgmii_tx" occurs
    Then bit I of "xgmii_txc" should equal 1

  @xgmii
  Formal Scenario: XGMII transmit control clear for data bytes
    Given "reset_xgmii_tx_n" is de-asserted high
    And byte position I of "xgmii_txd" carries valid data
    When one clock edge of "clk_xgmii_tx" occurs
    Then bit I of "xgmii_txc" should equal 0

  @xgmii
  Formal Scenario: XGMII receive control marks non-data bytes as detected
    Given "reset_xgmii_rx_n" is de-asserted high
    And byte position I of "xgmii_rxd" carries a control character
    And bit I of "xgmii_rxc" is 1
    When one clock edge of "clk_xgmii_rx" occurs
    Then the Decoding State-Machine should classify byte I as control

  # -------------------------------------------------------------------
  # FAULT STATE-MACHINE
  # -------------------------------------------------------------------

  @fault
  Formal Scenario: Local fault detected when XGMII local fault sequences persist
    Given "reset_xgmii_rx_n" is de-asserted high
    And the XGMII receive interface indicates a local fault condition for the debounce duration
    When one clock edge of "clk_xgmii_rx" occurs
    Then the fault state-machine should assert local fault status

  @fault
  Formal Scenario: Remote fault detected when far-end fault messages persist
    Given "reset_xgmii_rx_n" is de-asserted high
    And the XGMII receive interface indicates a remote fault condition for the debounce duration
    When one clock edge of "clk_xgmii_rx" occurs
    Then the fault state-machine should assert remote fault status

  @fault
  Formal Scenario: Encoding State-Machine stops transmitting during local fault
    Given "reset_xgmii_tx_n" is de-asserted high
    And the fault state-machine indicates local fault is active
    When one clock edge of "clk_xgmii_tx" occurs
    Then the Encoding State-Machine should not emit frame data on "xgmii_txd"

  @fault
  Formal Scenario: Remote fault message inserted on transmit during local fault
    Given "reset_xgmii_tx_n" is de-asserted high
    And the fault state-machine indicates local fault is active
    When one clock edge of "clk_xgmii_tx" occurs
    Then the RC Layer should insert a remote fault ordered set on "xgmii_txd"

  # -------------------------------------------------------------------
  # FIFO INTEGRITY
  # -------------------------------------------------------------------

  @fifo
  Formal Scenario: TX FIFO never exceeds configured depth
    Given "reset_156m25_n" is de-asserted high
    And the TX FIFO write pointer and read pointer are tracked
    When one clock edge of "clk_156m25" occurs
    Then the TX FIFO occupancy should never exceed 128 entries

  @fifo
  Formal Scenario: RX FIFO never exceeds configured depth
    Given "reset_156m25_n" is de-asserted high
    And the RX FIFO write pointer and read pointer are tracked
    When one clock edge of "clk_156m25" occurs
    Then the RX FIFO occupancy should never exceed 128 entries

  @fifo
  Formal Scenario: TX FIFO status bits preserve SOP and EOP alignment
    Given "reset_156m25_n" is de-asserted high
    And an entry is written to the TX FIFO with SOP flag S and EOP flag E
    When one clock edge of "clk_156m25" occurs
    Then bits 71:64 of that TX FIFO entry should encode S and E correctly

  @fifo
  Formal Scenario: RX FIFO error flag propagates CRC errors to next entry
    Given "reset_156m25_n" is de-asserted high
    And the CRC logic reports an error for the current frame
    When one clock edge of "clk_156m25" occurs
    Then the error flag bit of the next RX FIFO entry should equal 1

  # -------------------------------------------------------------------
  # MAX FRAME SIZE
  # -------------------------------------------------------------------

  @maxframe
  Formal Scenario: Oversized frame flagged as errored
    Given "reset_xgmii_rx_n" is de-asserted high
    And a received frame length L exceeds MAX_FRAME_SIZE
    When one clock edge of "clk_xgmii_rx" occurs
    Then "pkt_rx_err" should equal 1 during transfer of that frame

  @maxframe
  Formal Scenario: Frame within MAX_FRAME_SIZE not flagged as oversized error
    Given "reset_xgmii_rx_n" is de-asserted high
    And a received frame length L is less than or equal to MAX_FRAME_SIZE
    And no CRC error occurred
    When one clock edge of "clk_xgmii_rx" occurs
    Then "pkt_rx_err" should equal 0 during transfer of that frame