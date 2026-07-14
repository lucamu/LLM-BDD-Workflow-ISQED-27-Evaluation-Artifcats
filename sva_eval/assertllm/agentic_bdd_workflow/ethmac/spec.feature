Feature: Ethernet IP Core Formal Verification
  Formal properties for the OpenCores Ethernet MAC IP Core covering
  WISHBONE host interface protocol, register behavior, buffer descriptor
  semantics, MAC control (flow control) logic, and MII management module.

  Background:
    Given the system clock CLK_I
    And an active-high synchronous reset RST_I
    And all registers hold their reset values while RST_I is asserted
    And all sequential state updates occur on the rising edge of CLK_I

  # ---------------------------------------------------------------------
  # Reset values of registers
  # ---------------------------------------------------------------------

  @reset
  Formal Scenario: MODER register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the MODER register should equal 32'h0000A000

  @reset
  Formal Scenario: INT_SOURCE register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the INT_SOURCE register should equal 32'h00000000

  @reset
  Formal Scenario: INT_MASK register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the INT_MASK register should equal 32'h00000000

  @reset
  Formal Scenario: IPGT register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the IPGT register should equal 32'h00000012

  @reset
  Formal Scenario: IPGR1 register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the IPGR1 register should equal 32'h0000000C

  @reset
  Formal Scenario: IPGR2 register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the IPGR2 register should equal 32'h00000012

  @reset
  Formal Scenario: PACKETLEN register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the PACKETLEN register should equal 32'h00400600

  @reset
  Formal Scenario: COLLCONF register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the COLLCONF register should equal 32'h000F003F

  @reset
  Formal Scenario: TX_BD_NUM register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the TX_BD_NUM register should equal 32'h00000040

  @reset
  Formal Scenario: CTRLMODER register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the CTRLMODER register should equal 32'h00000000

  @reset
  Formal Scenario: MIIMODER register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the MIIMODER register should equal 32'h00000064

  @reset
  Formal Scenario: MIICOMMAND register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the MIICOMMAND register should equal 32'h00000000

  @reset
  Formal Scenario: MIIADDRESS register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the MIIADDRESS register should equal 32'h00000000

  @reset
  Formal Scenario: MIITX_DATA register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the MIITX_DATA register should equal 32'h00000000

  @reset
  Formal Scenario: MIIRX_DATA register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the MIIRX_DATA register should equal 32'h00000000

  @reset
  Formal Scenario: MIISTATUS register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the MIISTATUS register should equal 32'h00000000

  @reset
  Formal Scenario: MAC_ADDR0 register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the MAC_ADDR0 register should equal 32'h00000000

  @reset
  Formal Scenario: MAC_ADDR1 register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the MAC_ADDR1 register should equal 32'h00000000

  @reset
  Formal Scenario: HASH0 register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the HASH0 register should equal 32'h00000000

  @reset
  Formal Scenario: HASH1 register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the HASH1 register should equal 32'h00000000

  @reset
  Formal Scenario: TXCTRL register reset value
    Given RST_I is asserted
    When one clock edge occurs
    Then the TXCTRL register should equal 32'h00000000

  # ---------------------------------------------------------------------
  # WISHBONE slave protocol
  # ---------------------------------------------------------------------

  @wishbone
  Formal Scenario: Valid write cycle updates addressed register
    Given RST_I is deasserted
    And CYC_I is 1
    And STB_I is 1
    And WE_I is 1
    And SEL_I is 4'b1111
    And ADDR_I is address A of a valid RW register
    And DATA_I is value D
    When one clock edge occurs
    Then the register at address A should equal D
    And ACK_O should be asserted on that clock edge

  @wishbone
  Formal Scenario: Valid read cycle returns addressed register value
    Given RST_I is deasserted
    And CYC_I is 1
    And STB_I is 1
    And WE_I is 0
    And SEL_I is 4'b1111
    And ADDR_I is address A of a valid register holding value D
    When one clock edge occurs
    Then DATA_O should equal D
    And ACK_O should be asserted on that clock edge

  @wishbone
  Formal Scenario: Incomplete byte select triggers error acknowledgment
    Given RST_I is deasserted
    And CYC_I is 1
    And STB_I is 1
    And SEL_I is not equal to 4'b1111
    When one clock edge occurs
    Then ERR_O should be asserted
    And ACK_O should not be asserted on that clock edge

  @wishbone
  Formal Scenario: No acknowledgment without an active cycle
    Given CYC_I is 0
    When one clock edge occurs
    Then ACK_O should not be asserted
    And ERR_O should not be asserted

  # ---------------------------------------------------------------------
  # WISHBONE Master interface (DMA) protocol
  # ---------------------------------------------------------------------

  @wishbone_master
  Formal Scenario: Master write cycle for TX DMA reads frame data from memory
    Given RST_I is deasserted
    And the Tx MAC requires data for buffer descriptor pointer P
    And M_CYC_O is asserted
    And M_STB_O is asserted
    And M_WE_O is 0
    And M_ADDR_O equals P
    And M_SEL_O equals 4'b1111
    When M_ACK_I is asserted on a clock edge
    Then M_DATA_I should be latched as transmit data
    And M_CYC_O and M_STB_O should be deasserted after the transfer completes

  @wishbone_master
  Formal Scenario: Master read cycle for RX DMA writes frame data to memory
    Given RST_I is deasserted
    And the Rx MAC has data D to store at buffer pointer P
    And M_CYC_O is asserted
    And M_STB_O is asserted
    And M_WE_O is 1
    And M_ADDR_O equals P
    And M_DATA_O equals D
    And M_SEL_O equals 4'b1111
    When M_ACK_I is asserted on a clock edge
    Then the memory write should be considered complete
    And M_CYC_O and M_STB_O should be deasserted after the transfer completes

  @wishbone_master
  Formal Scenario: Master cycle advances address after each acknowledged beat
    Given RST_I is deasserted
    And a DMA burst transfer is in progress at address ADDR
    And M_ACK_I is asserted on the current beat
    When the next beat of the burst begins
    Then M_ADDR_O should equal ADDR plus the transfer size of one beat

  @wishbone_master
  Formal Scenario: Master error acknowledgment aborts DMA transfer
    Given RST_I is deasserted
    And M_CYC_O is asserted
    And M_STB_O is asserted
    When M_ERR_I is asserted on a clock edge
    Then the current DMA transfer should be aborted
    And M_CYC_O should be deasserted
    And an error condition should be reported to the associated buffer descriptor

  @wishbone_master
  Formal Scenario: No master bus activity without a pending DMA request
    Given RST_I is deasserted
    And no Tx or Rx DMA request is pending
    When one clock edge occurs
    Then M_CYC_O should not be asserted
    And M_STB_O should not be asserted

  # ---------------------------------------------------------------------
  # MODER register - transmit/receive enable logic
  # ---------------------------------------------------------------------

  @moder
  Formal Scenario: Transmitter disabled when TX_BD_NUM is zero regardless of TXEN
    Given the TX_BD_NUM register equals 8'h00
    And the MODER.TXEN bit is 1
    When one clock edge occurs
    Then the transmit function should be disabled

  @moder
  Formal Scenario: Receiver disabled when TX_BD_NUM uses all descriptors
    Given the TX_BD_NUM register equals 8'h80
    And the MODER.RXEN bit is 1
    When one clock edge occurs
    Then the receive function should be disabled

  @moder
  Formal Scenario: Transmitter enabled when TXEN set and Tx BD count nonzero
    Given the TX_BD_NUM register equals value N where N is greater than 8'h00
    And the MODER.TXEN bit is 1
    When one clock edge occurs
    Then the transmit function should be enabled

  @moder
  Formal Scenario: Receiver enabled when RXEN set and Rx BD count nonzero
    Given the TX_BD_NUM register equals value N where N is less than 8'h80
    And the MODER.RXEN bit is 1
    When one clock edge occurs
    Then the receive function should be enabled

  @moder
  Formal Scenario: TX_BD_NUM values above maximum are ignored
    Given TX_BD_NUM is written with value V where V is greater than 8'h80
    When one clock edge occurs
    Then the TX_BD_NUM register should retain its previous value

  # ---------------------------------------------------------------------
  # MODER register - individual control bit semantics
  # ---------------------------------------------------------------------

  @moder
  Formal Scenario: DLYCRCEN delays CRC calculation start by 4 bytes
    Given MODER.DLYCRCEN is 1
    And a frame is transmitted
    When the transmitter computes the CRC
    Then CRC calculation should start 4 bytes after the SFD

  @moder
  Formal Scenario: CRC calculation starts immediately after SFD when DLYCRCEN is clear
    Given MODER.DLYCRCEN is 0
    And a frame is transmitted
    When the transmitter computes the CRC
    Then CRC calculation should start immediately after the SFD

  @moder
  Formal Scenario: EXDFREN allows indefinite carrier wait on excessive deferral
    Given MODER.EXDFREN is 1
    And the excessive deferral limit is reached during transmission
    When the Tx MAC evaluates the deferral condition
    Then the Tx MAC should continue waiting for the carrier indefinitely
    And the packet should not be aborted due to excessive deferral

  @moder
  Formal Scenario: Packet aborted on excessive deferral when EXDFREN is clear
    Given MODER.EXDFREN is 0
    And the excessive deferral limit is reached during transmission
    When the Tx MAC evaluates the deferral condition
    Then the current packet transmission should be aborted

  @moder
  Formal Scenario: NOBCKOF causes immediate retransmission after collision
    Given MODER.NOBCKOF is 1
    And a collision is detected during transmission
    When the Tx MAC responds to the collision
    Then retransmission should start immediately without a backoff delay

  @moder
  Formal Scenario: Binary exponential backoff used when NOBCKOF is clear
    Given MODER.NOBCKOF is 0
    And a collision is detected during transmission
    When the Tx MAC responds to the collision
    Then a binary exponential backoff delay should be applied before retransmission

  @moder
  Formal Scenario: IFG bit allows frame acceptance regardless of interframe gap
    Given MODER.IFG is 1
    And an incoming frame arrives with an interframe gap smaller than the minimum required
    When the Rx MAC evaluates frame acceptance
    Then the frame should be accepted regardless of the interframe gap

  @moder
  Formal Scenario: Minimum interframe gap enforced when IFG is clear
    Given MODER.IFG is 0
    And an incoming frame arrives with an interframe gap smaller than the minimum required
    When the Rx MAC evaluates frame acceptance
    Then the frame should not be accepted

  @moder
  Formal Scenario: IAM enables hash table check for individual addresses
    Given MODER.IAM is 1
    And a received frame has an individual destination address not equal to the station address
    When the Rx MAC performs address recognition
    Then the individual hash table should be used to determine acceptance

  @moder
  Formal Scenario: Physical address checked directly when IAM is clear
    Given MODER.IAM is 0
    And a received frame has an individual destination address
    When the Rx MAC performs address recognition
    Then the physical address should be compared directly without using the hash table

  @moder
  Formal Scenario: BRO rejects broadcast frames unless PRO is set
    Given MODER.BRO is 1
    And MODER.PRO is 0
    And a received frame contains the broadcast address
    When the Rx MAC evaluates frame acceptance
    Then the frame should be rejected

  @moder
  Formal Scenario: Broadcast frames accepted when BRO is clear
    Given MODER.BRO is 0
    And a received frame contains the broadcast address
    When the Rx MAC evaluates frame acceptance
    Then the frame should be accepted

  @moder
  Formal Scenario: NOPRE suppresses preamble transmission
    Given MODER.NOPRE is 1
    And a frame is transmitted
    When the Tx MAC begins the transmission
    Then no preamble should be sent

  @moder
  Formal Scenario: Preamble sent when NOPRE is clear
    Given MODER.NOPRE is 0
    And a frame is transmitted
    When the Tx MAC begins the transmission
    Then a 7-byte preamble should be sent

  # ---------------------------------------------------------------------
  # INT_SOURCE / INT_MASK behavior
  # ---------------------------------------------------------------------

  @interrupt
  Formal Scenario: Interrupt source bit cleared by writing 1
    Given the INT_SOURCE register bit B is set to 1
    And a write to INT_SOURCE with bit B equal to 1 and all other written bits 0 occurs
    When one clock edge occurs
    Then the INT_SOURCE register bit B should be 0

  @interrupt
  Formal Scenario: Writing 0 to an interrupt source bit does not clear it
    Given the INT_SOURCE register bit B is set to 1
    And a write to INT_SOURCE with bit B equal to 0 occurs
    When one clock edge occurs
    Then the INT_SOURCE register bit B should remain 1

  @interrupt
  Formal Scenario: INTA_O asserted only when unmasked interrupt source bit is set
    Given INT_SOURCE bit B is 1
    And INT_MASK bit B is 1
    When one clock edge occurs
    Then INTA_O should be asserted

  @interrupt
  Formal Scenario: INTA_O deasserted when interrupt source bit is masked
    Given INT_SOURCE bit B is 1
    And INT_MASK bit B is 0
    And all other INT_SOURCE bits are 0 or masked
    When one clock edge occurs
    Then INTA_O should not be asserted

  @interrupt
  Formal Scenario: RXC bit requires RXFLOW enabled to be set
    Given CTRLMODER.RXFLOW is 0
    And a valid PAUSE control frame is received
    When one clock edge occurs
    Then INT_SOURCE.RXC should not be set

  @interrupt
  Formal Scenario: TXC bit requires TXFLOW enabled to be set
    Given CTRLMODER.TXFLOW is 0
    And a control frame transmission completes
    When one clock edge occurs
    Then INT_SOURCE.TXC should not be set

  @interrupt
  Formal Scenario: RXB requires IRQ bit set in receive buffer descriptor
    Given a frame is received into a buffer descriptor with IRQ bit equal to 0
    When the reception completes
    Then INT_SOURCE.RXB should not be set

  @interrupt
  Formal Scenario: TXB requires IRQ bit set in transmit buffer descriptor
    Given a frame is transmitted from a buffer descriptor with IRQ bit equal to 0
    When the transmission completes
    Then INT_SOURCE.TXB should not be set

  @interrupt
  Formal Scenario: BUSY bit set when frame is discarded due to lack of available buffers
    Given no Rx buffer descriptor is available (all marked non-empty)
    And an incoming frame is received
    When the Rx MAC attempts to store the frame
    Then the frame should be discarded
    And INT_SOURCE.BUSY should be set to 1

  @interrupt
  Formal Scenario: BUSY bit set independent of Rx buffer descriptor IRQ bit
    Given no Rx buffer descriptor is available (all marked non-empty)
    And the last used Rx buffer descriptor has IRQ bit equal to 0
    And an incoming frame is received
    When the Rx MAC attempts to store the frame
    Then INT_SOURCE.BUSY should be set to 1

  @interrupt
  Formal Scenario: BUSY bit cleared by writing 1
    Given INT_SOURCE.BUSY is 1
    And a write to INT_SOURCE with the BUSY bit equal to 1 occurs
    When one clock edge occurs
    Then INT_SOURCE.BUSY should be cleared to 0

  # ---------------------------------------------------------------------
  # CTRLMODER / PASSALL / RXFLOW control frame table (Table 14)
  # ---------------------------------------------------------------------

  @ctrlmoder
  Formal Scenario: PASSALL 0 RXFLOW 0 drops control frame silently
    Given CTRLMODER.PASSALL is 0
    And CTRLMODER.RXFLOW is 0
    And a valid PAUSE control frame is received
    When one clock edge occurs
    Then the control frame should not be stored to memory
    And INT_SOURCE.RXC should not be set
    And INT_SOURCE.RXB should not be set

  @ctrlmoder
  Formal Scenario: PASSALL 0 RXFLOW 1 sets RXC and updates pause timer without storing
    Given CTRLMODER.PASSALL is 0
    And CTRLMODER.RXFLOW is 1
    And a valid PAUSE control frame with timer value T is received
    When one clock edge occurs
    Then INT_SOURCE.RXC should be set
    And the pause timer should be loaded with T
    And the control frame should not be stored to memory

  @ctrlmoder
  Formal Scenario: PASSALL 1 RXFLOW 0 stores frame with CF bit and sets RXB only
    Given CTRLMODER.PASSALL is 1
    And CTRLMODER.RXFLOW is 0
    And a valid PAUSE control frame is received into a buffer descriptor with IRQ equal to 1
    When one clock edge occurs
    Then the control frame should be stored to memory
    And the receive buffer descriptor CF bit should be set to 1
    And INT_SOURCE.RXB should be set
    And INT_SOURCE.RXC should not be set
    And the pause timer should not be updated

  @ctrlmoder
  Formal Scenario: PASSALL 1 RXFLOW 1 sets RXC updates timer and stores frame
    Given CTRLMODER.PASSALL is 1
    And CTRLMODER.RXFLOW is 1
    And a valid PAUSE control frame with timer value T is received
    When one clock edge occurs
    Then INT_SOURCE.RXC should be set
    And the pause timer should be loaded with T
    And the control frame should be stored to memory

  @ctrlmoder
  Formal Scenario: Valid pause frame destination address recognition
    Given the received frame destination address equals the reserved multicast address 48'h0180C2000001
    And the Length/Type field equals 16'h8808
    And the opcode field equals 16'h0001
    When the frame is fully received
    Then the frame should be classified as a control frame

  @ctrlmoder
  Formal Scenario: Valid pause frame own MAC address recognition
    Given the received frame destination address equals the value held in MAC_ADDR0 and MAC_ADDR1
    And the Length/Type field equals 16'h8808
    And the opcode field equals 16'h0001
    When the frame is fully received
    Then the frame should be classified as a control frame

  # ---------------------------------------------------------------------
  # TXCTRL / Control frame generation
  # ---------------------------------------------------------------------

  @txctrl
  Formal Scenario: TXPAUSERQ initiates pause frame transmission and self-clears
    Given CTRLMODER.TXFLOW is 1
    And TXCTRL.TXPAUSERQ is written as 1 with TXPAUSETV equal to value T
    When one clock edge occurs
    Then a PAUSE control frame transmission should be requested
    And TXCTRL.TXPAUSERQ should be cleared to 0 after the request is latched

  @txctrl
  Formal Scenario: New pause request ignored while previous request pending
    Given a PAUSE control frame transmission is currently in progress
    And TXCTRL.TXPAUSERQ is written as 1
    When one clock edge occurs
    Then the new pause request should not restart the transmission until the current one completes

  @txctrl
  Formal Scenario: Pause frame not sent when TXFLOW disabled
    Given CTRLMODER.TXFLOW is 0
    And TXCTRL.TXPAUSERQ is written as 1
    When one clock edge occurs
    Then no PAUSE control frame transmission should occur

  # ---------------------------------------------------------------------
  # Tx Buffer Descriptor semantics
  # ---------------------------------------------------------------------

  @txbd
  Formal Scenario: Tx BD Ready bit gates transmission start
    Given a Tx buffer descriptor with RD bit equal to 0
    When the transmitter examines this descriptor
    Then no transmission should start from this descriptor

  @txbd
  Formal Scenario: RD bit cleared after successful transmission
    Given a Tx buffer descriptor with RD bit equal to 1 and LEN equal to length L where L is greater than 4
    When the associated data has been transmitted successfully
    Then the RD bit of that descriptor should be cleared to 0

  @txbd
  Formal Scenario: Frames with length 4 bytes or less are not transmitted
    Given a Tx buffer descriptor with RD bit equal to 1 and LEN equal to length L where L is less than or equal to 4
    When the transmitter examines this descriptor
    Then no transmission should occur for this descriptor

  @txbd
  Formal Scenario: Wrap bit causes return to first Tx descriptor
    Given the current Tx buffer descriptor has WR bit equal to 1
    And the descriptor transmission completes
    When the next descriptor fetch occurs
    Then the Tx descriptor address should return to the base Tx BD address

  @txbd
  Formal Scenario: No wrap bit advances to next sequential Tx descriptor
    Given the current Tx buffer descriptor has WR bit equal to 0 and address ADDR
    And the descriptor transmission completes
    When the next descriptor fetch occurs
    Then the Tx descriptor address should equal ADDR plus one descriptor size

  @txbd
  Formal Scenario: IRQ bit in Tx BD gates TXB or TXE interrupt generation
    Given a Tx buffer descriptor with IRQ bit equal to 1
    When transmission of that descriptor completes successfully
    Then INT_SOURCE.TXB should be set

  @txbd
  Formal Scenario: Retransmission limit sets RL bit and aborts frame
    Given a Tx buffer descriptor transmission experiences collisions equal to COLLCONF.MAXRET plus 1
    When the retransmission limit is reached
    Then the Tx BD RL bit should be set to 1
    And the current packet transmission should be aborted

  @txbd
  Formal Scenario: Late collision sets LC bit and stops transmission
    Given a collision is detected after the time window specified by COLLCONF.COLLVALID
    When the collision occurs during transmission of a Tx descriptor
    Then the Tx BD LC bit should be set to 1
    And the transmission of that buffer should stop

  @txbd
  Formal Scenario: UR bit set on Tx FIFO underrun during transmission
    Given a Tx buffer descriptor transmission is in progress
    And the internal Tx FIFO becomes empty before the frame is fully transmitted
    When the underrun condition is detected
    Then the Tx BD UR bit should be set to 1

  @txbd
  Formal Scenario: UR bit not set when transmission completes without underrun
    Given a Tx buffer descriptor transmission completes successfully with the FIFO never empty
    When the transmission finishes
    Then the Tx BD UR bit should remain 0

  @txbd
  Formal Scenario: RTRY count reflects number of retries before successful transmission
    Given a Tx buffer descriptor transmission experiences N collisions where N is less than or equal to COLLCONF.MAXRET
    And the frame is eventually transmitted successfully
    When the transmission completes
    Then the Tx BD RTRY field should equal N

  @txbd
  Formal Scenario: RTRY count is zero when no collision occurs
    Given a Tx buffer descriptor transmission completes with no collisions detected
    When the transmission completes
    Then the Tx BD RTRY field should equal 0

  @txbd
  Formal Scenario: DF bit set when transmission is deferred due to busy medium
    Given the medium is busy (Carrier Sense asserted) when a Tx buffer descriptor becomes ready
    And the Tx MAC defers transmission until the medium is idle
    When the transmission eventually completes
    Then the Tx BD DF bit should be set to 1

  @txbd
  Formal Scenario: DF bit not set when transmission starts without deferral
    Given the medium is idle when a Tx buffer descriptor becomes ready
    When the transmission completes without waiting for Carrier Sense
    Then the Tx BD DF bit should remain 0

  @txbd
  Formal Scenario: CS bit set when Carrier Sense is lost during transmission
    Given a Tx buffer descriptor transmission is in progress in half duplex mode
    And Carrier Sense is deasserted before the transmission completes
    When the Ethernet controller finishes sending the buffer
    Then the Tx BD CS bit should be set to 1

  @txbd
  Formal Scenario: CS bit not set when Carrier Sense remains asserted throughout transmission
    Given a Tx buffer descriptor transmission is in progress in half duplex mode
    And Carrier Sense remains asserted for the duration of the transmission
    When the Ethernet controller finishes sending the buffer
    Then the Tx BD CS bit should remain 0

  # ---------------------------------------------------------------------
  # Rx Buffer Descriptor semantics
  # ---------------------------------------------------------------------

  @rxbd
  Formal Scenario: Rx BD Empty bit gates reception start
    Given an Rx buffer descriptor with E bit equal to 0
    When the receiver examines this descriptor
    Then no frame should be received into this descriptor

  @rxbd
  Formal Scenario: E bit cleared after frame stored
    Given an Rx buffer descriptor with E bit equal to 1
    When a frame is fully received and stored using this descriptor
    Then the E bit of that descriptor should be cleared to 0

  @rxbd
  Formal Scenario: Frames of 4 bytes or less produce CRC error
    Given an Rx buffer descriptor with E bit equal to 1
    And an incoming frame with length L where L is less than or equal to 4 bytes
    When the frame reception completes
    Then the Rx BD CRC bit should be set to 1

  @rxbd
  Formal Scenario: Wrap bit causes return to first Rx descriptor
    Given the current Rx buffer descriptor has WR bit equal to 1
    And a frame reception into this descriptor completes
    When the next descriptor fetch occurs
    Then the Rx descriptor address should return to the base Rx BD address

  @rxbd
  Formal Scenario: IRQ bit in Rx BD gates RXF interrupt generation
    Given an Rx buffer descriptor with IRQ bit equal to 1
    When a frame reception into that descriptor completes
    Then INT_SOURCE.RXB or INT_SOURCE.RXE should be set

  @rxbd
  Formal Scenario: Too long frame sets TL bit
    Given an incoming frame with length L where L is greater than PACKETLEN.MAXFL
    And HUGEN bit is 0
    When the frame reception completes
    Then the Rx BD TL bit should be set to 1

  @rxbd
  Formal Scenario: Short frame sets SF bit
    Given an incoming frame with length L where L is less than PACKETLEN.MINFL
    And RECSMALL bit is 0
    When the frame reception completes
    Then the Rx BD SF bit should be set to 1

  @rxbd
  Formal Scenario: Small frames accepted when RECSMALL is set
    Given MODER.RECSMALL is 1
    And an incoming frame with length L where L is less than PACKETLEN.MINFL
    When the frame reception completes
    Then the Rx BD SF bit should not be set due solely to length

  @rxbd
  Formal Scenario: Control frame bit set on received PAUSE frame
    Given CTRLMODER.PASSALL is 1
    And a valid PAUSE control frame is received into an Rx buffer descriptor
    When the frame reception completes
    Then the Rx BD CF bit should be set to 1

  @rxbd
  Formal Scenario: Miss bit set in promiscuous mode on address mismatch
    Given MODER.PRO is 1
    And the received frame destination address does not match the station address and is not a recognized multicast/broadcast
    When the frame reception completes
    Then the Rx BD M bit should be set to 1

  @rxbd
  Formal Scenario: OR bit set on receiver FIFO overrun
    Given an Rx buffer descriptor with E bit equal to 1
    And the internal Rx FIFO overflows during reception of an incoming frame
    When the overrun condition is detected
    Then the Rx BD OR bit should be set to 1

  @rxbd
  Formal Scenario: OR bit not set when no overrun occurs during reception
    Given an Rx buffer descriptor with E bit equal to 1
    And the internal Rx FIFO never overflows during reception of an incoming frame
    When the frame reception completes
    Then the Rx BD OR bit should remain 0

  @rxbd
  Formal Scenario: IS bit set when PHY signals an invalid symbol
    Given an Rx buffer descriptor with E bit equal to 1
    And the PHY asserts an invalid symbol condition (MRxErr) during reception
    When the frame reception completes
    Then the Rx BD IS bit should be set to 1

  @rxbd
  Formal Scenario: IS bit not set when no invalid symbol is detected
    Given an Rx buffer descriptor with E bit equal to 1
    And the PHY does not assert an invalid symbol condition during reception
    When the frame reception completes
    Then the Rx BD IS bit should remain 0

  @rxbd
  Formal Scenario: DN bit set when received frame is not divisible by 8 bits
    Given an Rx buffer descriptor with E bit equal to 1
    And an incoming frame is received with one extra dribble nibble beyond a full byte boundary
    When the frame reception completes
    Then the Rx BD DN bit should be set to 1

  @rxbd
  Formal Scenario: DN bit not set when received frame ends on a byte boundary
    Given an Rx buffer descriptor with E bit equal to 1
    And an incoming frame is received with no extra dribble nibble
    When the frame reception completes
    Then the Rx BD DN bit should remain 0

  # ---------------------------------------------------------------------
  # PAUSE Timer / Slot Timer
  # ---------------------------------------------------------------------

  @pausetimer
  Formal Scenario: Pause timer loaded on valid pause frame reception
    Given CTRLMODER.RXFLOW is 1
    And a valid PAUSE control frame with timer value T is received
    When one clock edge occurs
    Then the pause timer should be set to T

  @pausetimer
  Formal Scenario: Pause timer decrements once per slot time
    Given the pause timer holds value V where V is greater than 0
    When one slot time pulse occurs
    Then the pause timer should equal V minus 1

  @pausetimer
  Formal Scenario: Transmission resumes when pause timer reaches zero
    Given the pause timer equals 0
    When the transmitter checks pause status
    Then the transmit function should not be blocked by the pause timer

  @pausetimer
  Formal Scenario: Transmission blocked while pause timer nonzero
    Given the pause timer holds value V where V is greater than 0
    When the transmitter checks pause status
    Then the transmit function should be blocked from asserting TxStartFrm

  # ---------------------------------------------------------------------
  # MII Management Module - Operation Controller
  # ---------------------------------------------------------------------

  @mii
  Formal Scenario: BUSY asserted on write control data request
    Given MIISTATUS.BUSY is 0
    And MIICOMMAND.WCTRLDATA is written as 1
    When one clock edge occurs
    Then MIISTATUS.BUSY should be asserted

  @mii
  Formal Scenario: BUSY asserted on read status request
    Given MIISTATUS.BUSY is 0
    And MIICOMMAND.RSTAT is written as 1
    When one clock edge occurs
    Then MIISTATUS.BUSY should be asserted

  @mii
  Formal Scenario: New MII operation blocked while BUSY is asserted
    Given MIISTATUS.BUSY is 1
    And MIICOMMAND.WCTRLDATA is written as 1
    When one clock edge occurs
    Then no new MII operation should start until BUSY is deasserted

  @mii
  Formal Scenario: BUSY deasserted at completion of write operation
    Given a write control data operation is in progress
    And the full MII write frame has been shifted out
    When the last bit is clocked out
    Then MIISTATUS.BUSY should be deasserted

  @mii
  Formal Scenario: BUSY deasserted at completion of read operation and data valid
    Given a read status operation is in progress
    And the full MII read frame has been shifted in
    When the last status bit is clocked in
    Then MIISTATUS.BUSY should be deasserted
    And MIIRX_DATA should hold the value read from the PHY

  @mii
  Formal Scenario: Scan status keeps BUSY asserted until stopped
    Given MIICOMMAND.SCANSTAT is 1
    When continuous scanning is active
    Then MIISTATUS.BUSY should remain asserted until SCANSTAT is deasserted

  @mii
  Formal Scenario: NVALID asserted until first scan completes
    Given MIICOMMAND.SCANSTAT is written as 1 for the first time since reset
    When the first scan read has not yet completed
    Then MIISTATUS.NVALID should be asserted

  @mii
  Formal Scenario: NVALID deasserted after first scan status completes
    Given a scan status operation is active
    And the first full read cycle has completed
    When one clock edge occurs
    Then MIISTATUS.NVALID should be deasserted

  @mii
  Formal Scenario: Preamble omitted when MIINOPRE is set
    Given MIIMODER.MIINOPRE is 1
    And an MII operation is requested
    When the MII frame transmission starts
    Then no 32-bit preamble field should be shifted out

  @mii
  Formal Scenario: Preamble included when MIINOPRE is clear
    Given MIIMODER.MIINOPRE is 0
    And an MII operation is requested
    When the MII frame transmission starts
    Then a 32-bit all-ones preamble field should be shifted out first

  @mii
  Formal Scenario: MDC frequency derived from CLKDIV
    Given MIIMODER.CLKDIV equals value D where D is greater than 1
    When the clock generator operates
    Then the MDC period should equal 2 times D host clock periods

  @mii
  Formal Scenario: MDIO tri-stated when no MII operation is active
    Given MIISTATUS.BUSY is 0
    And no MII command bit is asserted
    When one clock edge occurs
    Then MDIO should be in a high-impedance state

  @mii
  Formal Scenario: MDOEN asserted during write control data output phase
    Given a write control data operation is shifting out address or data bits
    When one clock edge occurs
    Then MDOEN should be asserted

  @mii
  Formal Scenario: MDOEN deasserted during read status data input phase
    Given a read status operation has completed the turnaround field
    And the PHY is driving the status data
    When one clock edge occurs
    Then MDOEN should be deasserted

  # ---------------------------------------------------------------------
  # Loopback and Full-Duplex behavior
  # ---------------------------------------------------------------------

  @moder
  Formal Scenario: Loopback routes transmit data to receive path
    Given MODER.LOOPBCK is 1
    And the Tx MAC transmits data D
    When one clock edge occurs
    Then the Rx MAC should receive data D

  @moder
  Formal Scenario: Carrier sense and collision ignored in full duplex mode
    Given MODER.FULLD is 1
    And MCrS or MColl is asserted externally
    When the Tx MAC evaluates transmission conditions
    Then carrier sense and collision signals should not affect transmission decisions

  # ---------------------------------------------------------------------
  # CRC / PAD generation
  # ---------------------------------------------------------------------

  @txmac
  Formal Scenario: CRC appended when CRCEN is set
    Given MODER.CRCEN is 1
    And a frame without a pre-existing CRC is transmitted
    When the transmission completes
    Then a 4-byte CRC should be appended to the transmitted frame

  @txmac
  Formal Scenario: CRC not appended when CRCEN is clear
    Given MODER.CRCEN is 0
    And a frame is transmitted
    When the transmission completes
    Then no CRC should be appended by the Tx MAC

  @txmac
  Formal Scenario: Padding applied to short frames when PAD is set
    Given MODER.PAD is 1
    And a frame with length L where L is less than PACKETLEN.MINFL is transmitted
    When the transmission completes
    Then the transmitted frame length should equal PACKETLEN.MINFL

  @txmac
  Formal Scenario: Huge frames allowed when HUGEN is set
    Given MODER.HUGEN is 1
    And a frame with length L where L is greater than PACKETLEN.MAXFL is transmitted
    When the transmission completes
    Then the frame should be transmitted in full without truncation

  @txmac
  Formal Scenario: Frames truncated to MAXFL when HUGEN is clear
    Given MODER.HUGEN is 0
    And a frame with length L where L is greater than PACKETLEN.MAXFL is transmitted
    When the transmission completes
    Then bytes beyond PACKETLEN.MAXFL should be discarded