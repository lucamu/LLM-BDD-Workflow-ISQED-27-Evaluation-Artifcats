Feature: wb_dma_top Dual-Interface WISHBONE DMA and Bridge Core

  Formal verification of wb_dma_top: register-file/pass-through address
  decode, WISHBONE protocol compliance on both interfaces, channel
  arbitration, DMA transfer execution, hardware-handshake behavior,
  linked-list descriptor handling, circular buffer/software pointer
  behavior, forced descriptor advance/restart, and interrupt generation.

  Background:
    Given the design is synchronous to "clk_i"
    And "rst_i" is the active-high synchronous reset
    And parameter "rf_addr" holds a fixed nibble value RFADDR
    And parameter "pri_sel" holds a fixed value PRISEL in {0,1,2}
    And parameter "ch_count" holds a fixed value CHCOUNT in range 1 to 31
    And channel 0 capability bit EN is fixed to 1
    And all registers are initialized by "rst_i" before any scenario begins

  # ---------------------------------------------------------------
  # Reset behavior
  # ---------------------------------------------------------------

  @reset
  Formal Scenario: Reset clears interrupt outputs and channel enables
    Given "rst_i" is asserted for at least one clock edge
    When one clock edge passes
    Then "inta_o" should be 0
    And "intb_o" should be 0
    And all channel enable status bits should be 0
    And all channel busy status bits should be 0

  @reset
  Formal Scenario: Reset forces WISHBONE outputs to idle
    Given "rst_i" is asserted for at least one clock edge
    When one clock edge passes
    Then "wb0_cyc_o" should be 0
    And "wb0_stb_o" should be 0
    And "wb1_cyc_o" should be 0
    And "wb1_stb_o" should be 0
    And "wb0_ack_o" should be 0
    And "wb1_ack_o" should be 0

  @reset
  Formal Scenario: Reset clears interrupt mask registers
    Given "rst_i" is asserted for at least one clock edge
    When one clock edge passes
    Then every interrupt mask register bit routing a channel event to "inta_o" should be 0
    And every interrupt mask register bit routing a channel event to "intb_o" should be 0

  # ---------------------------------------------------------------
  # Register-file selection vs pass-through selection
  # ---------------------------------------------------------------

  @address_decode
  Formal Scenario: Interface 0 address nibble match selects register file
    Given "rst_i" is deasserted
    And "wb0_addr_i" upper nibble [31:28] equals RFADDR
    And "wb0_cyc_i" is 1
    And "wb0_stb_i" is 1
    When one clock edge passes
    Then internal signal "rf_sel_o" for interface 0 should be 1
    And internal signal "pt_active" for interface 0 should be 0

  @address_decode
  Formal Scenario: Interface 0 address nibble mismatch selects pass-through
    Given "rst_i" is deasserted
    And "wb0_addr_i" upper nibble [31:28] differs from RFADDR
    And "wb0_cyc_i" is 1
    And "wb0_stb_i" is 1
    When one clock edge passes
    Then internal signal "pt_active" for interface 0 should be 1
    And internal signal "rf_sel_o" for interface 0 should be 0
    And "wb1_addr_o" should equal "wb0_addr_i"
    And "wb1_we_o" should equal "wb0_we_i"
    And "wb1_sel_o" should equal "wb0_sel_i"

  @address_decode
  Formal Scenario: Interface 1 address nibble match selects register file
    Given "rst_i" is deasserted
    And "wb1_addr_i" upper nibble [31:28] equals RFADDR
    And "wb1_cyc_i" is 1
    And "wb1_stb_i" is 1
    When one clock edge passes
    Then internal signal "rf_sel_o" for interface 1 should be 1
    And internal signal "pt_active" for interface 1 should be 0

  @address_decode
  Formal Scenario: Interface 1 address nibble mismatch selects pass-through to interface 0
    Given "rst_i" is deasserted
    And "wb1_addr_i" upper nibble [31:28] differs from RFADDR
    And "wb1_cyc_i" is 1
    And "wb1_stb_i" is 1
    When one clock edge passes
    Then internal signal "pt_active" for interface 1 should be 1
    And internal signal "rf_sel_o" for interface 1 should be 0
    And "wb0_addr_o" should equal "wb1_addr_i"
    And "wb0_we_o" should equal "wb1_we_i"

  @address_decode
  Formal Scenario: Pass-through selection is combinational and requires valid cycle
    Given "rst_i" is deasserted
    And "wb0_addr_i" upper nibble [31:28] differs from RFADDR
    And "wb0_cyc_i" is 0
    When one clock edge passes
    Then internal signal "pt_active" for interface 0 should be 0
    And "wb1_cyc_o" should be 0

  # ---------------------------------------------------------------
  # WISHBONE protocol compliance (slave side, register-file path)
  # Interface 0
  # ---------------------------------------------------------------

  @wb_protocol
  Formal Scenario: Register-file read returns ack with data and deasserts err/rty on interface 0
    Given "rst_i" is deasserted
    And "wb0_addr_i" upper nibble [31:28] equals RFADDR
    And "wb0_we_i" is 0
    And "wb0_cyc_i" is 1
    And "wb0_stb_i" is 1
    When one clock edge passes
    Then "wb0_ack_o" should be 1
    And "wb0_err_o" should be 0
    And "wb0_rty_o" should be 0
    And "wb0s_data_o" should equal the addressed register-file value

  @wb_protocol
  Formal Scenario: Register-file write updates register content on interface 0
    Given "rst_i" is deasserted
    And "wb0_addr_i" upper nibble [31:28] equals RFADDR
    And "wb0_we_i" is 1
    And "wb0_cyc_i" is 1
    And "wb0_stb_i" is 1
    And "wb0s_data_i" holds value DATAIN
    When one clock edge passes
    Then "wb0_ack_o" should be 1
    And the addressed register-file location should hold value DATAIN after acknowledgment

  @wb_protocol
  Formal Scenario: No ack without an active cycle and strobe on interface 0
    Given "rst_i" is deasserted
    And "wb0_cyc_i" is 0
    When one clock edge passes
    Then "wb0_ack_o" should be 0

  @wb_protocol
  Formal Scenario: Internal DMA master transfers use full word byte enable on interface 0
    Given "rst_i" is deasserted
    And the DMA engine is generating a master transaction on interface 0
    When one clock edge passes
    Then "wb0_sel_o" should equal 4'hf

  # ---------------------------------------------------------------
  # WISHBONE protocol compliance (slave side, register-file path)
  # Interface 1 (symmetric coverage)
  # ---------------------------------------------------------------

  @wb_protocol
  Formal Scenario: Register-file read returns ack with data and deasserts err/rty on interface 1
    Given "rst_i" is deasserted
    And "wb1_addr_i" upper nibble [31:28] equals RFADDR
    And "wb1_we_i" is 0
    And "wb1_cyc_i" is 1
    And "wb1_stb_i" is 1
    When one clock edge passes
    Then "wb1_ack_o" should be 1
    And "wb1_err_o" should be 0
    And "wb1_rty_o" should be 0
    And "wb1s_data_o" should equal the addressed register-file value

  @wb_protocol
  Formal Scenario: Register-file write updates register content on interface 1
    Given "rst_i" is deasserted
    And "wb1_addr_i" upper nibble [31:28] equals RFADDR
    And "wb1_we_i" is 1
    And "wb1_cyc_i" is 1
    And "wb1_stb_i" is 1
    And "wb1s_data_i" holds value DATAIN
    When one clock edge passes
    Then "wb1_ack_o" should be 1
    And the addressed register-file location should hold value DATAIN after acknowledgment

  @wb_protocol
  Formal Scenario: No ack without an active cycle and strobe on interface 1
    Given "rst_i" is deasserted
    And "wb1_cyc_i" is 0
    When one clock edge passes
    Then "wb1_ack_o" should be 0

  @wb_protocol
  Formal Scenario: Internal DMA master transfers use full word byte enable on interface 1
    Given "rst_i" is deasserted
    And the DMA engine is generating a master transaction on interface 1
    When one clock edge passes
    Then "wb1_sel_o" should equal 4'hf

  # ---------------------------------------------------------------
  # Channel arbitration and scheduling
  # ---------------------------------------------------------------

  @arbitration
  Formal Scenario: Higher priority eligible channel is selected over lower priority channel
    Given "rst_i" is deasserted
    And channel A has priority field PRIO_A
    And channel B has priority field PRIO_B
    And PRIO_A is strictly higher priority than PRIO_B
    And both channel A and channel B are enabled and eligible for arbitration
    When one clock edge passes
    Then "ch_sel" should equal channel A's index and not channel B's index

  @arbitration
  Formal Scenario: Equal priority channels are serviced round-robin
    Given "rst_i" is deasserted
    And channel A and channel B share equal priority field PRIO
    And both channel A and channel B are enabled and eligible for arbitration
    And channel A was the most recently selected channel
    When one clock edge passes and both channels remain eligible
    Then "ch_sel" should equal channel B's index

  @arbitration
  Formal Scenario: Disabled channel is never selected
    Given "rst_i" is deasserted
    And channel N has its enable status bit set to 0
    When one clock edge passes
    Then "ch_sel" should never equal channel N's index

  @arbitration
  Formal Scenario: Non-existent channel is never selected
    Given "rst_i" is deasserted
    And channel N has capability bit EN equal to 0 in "chN_conf"
    When one clock edge passes
    Then "ch_sel" should never equal channel N's index

  @arbitration
  Formal Scenario: Hardware-handshake channel requires dma_req_i to be eligible
    Given "rst_i" is deasserted
    And channel N is configured for hardware-handshake mode
    And channel N is enabled
    And "dma_req_i"[N] is 0
    When one clock edge passes
    Then "ch_sel" should not equal channel N's index

  # ---------------------------------------------------------------
  # Normal DMA mode transfer execution
  # ---------------------------------------------------------------

  @dma_normal
  Formal Scenario: Normal mode transfer completes when total size reaches zero
    Given "rst_i" is deasserted
    And channel N is enabled in normal mode with total size TOTSZ
    And channel N is selected and executing
    When the DMA engine has transferred TOTSZ words for channel N
    Then channel N done status should be 1
    And channel N busy status should be 0

  @dma_normal
  Formal Scenario: Address increment follows INC_SRC and INC_DST configuration
    Given "rst_i" is deasserted
    And channel N has "INC_SRC" set to 1 and "INC_DST" set to 1
    And channel N source address is SRC0 and destination address is DST0
    When one word transfer completes for channel N
    Then the source address should become SRC0 + 4
    And the destination address should become DST0 + 4

  @dma_normal
  Formal Scenario: Address does not increment when INC bit is cleared
    Given "rst_i" is deasserted
    And channel N has "INC_SRC" set to 0
    And channel N source address is SRC0
    When one word transfer completes for channel N
    Then the source address should remain SRC0

  @dma_normal
  Formal Scenario: Chunked transfer re-arbitrates between chunks
    Given "rst_i" is deasserted
    And channel N has non-zero "CHK_SZ" equal to CHUNKSZ
    And channel N total size TOTSZ is greater than CHUNKSZ
    When channel N completes one chunk of CHUNKSZ words
    Then channel N should return to the arbitration pool
    And channel N busy status should remain 1 until total size TOTSZ is reached

  @dma_normal
  Formal Scenario: Source and destination interface selection follows SRC_SEL/DST_SEL
    Given "rst_i" is deasserted
    And channel N has "SRC_SEL" selecting interface 0
    And channel N has "DST_SEL" selecting interface 1
    When channel N executes a transfer
    Then the DMA read master activity should occur on interface 0
    And the DMA write master activity should occur on interface 1

  # ---------------------------------------------------------------
  # Hardware-handshake mode
  # ---------------------------------------------------------------

  @handshake
  Formal Scenario: dma_req_i trigger starts one chunk transfer
    Given "rst_i" is deasserted
    And channel N is configured for hardware-handshake mode with "CHK_SZ" equal to CHUNKSZ
    And channel N is enabled and idle
    And "dma_req_i"[N] transitions to 1
    When channel N is selected and completes CHUNKSZ words
    Then "dma_ack_o"[N] should pulse to 1
    And channel N should return to idle awaiting the next request

  @handshake
  Formal Scenario: Zero chunk size uses total size semantics in handshake mode
    Given "rst_i" is deasserted
    And channel N is configured for hardware-handshake mode with "CHK_SZ" equal to 0
    And channel N total size is TOTSZ
    And "dma_req_i"[N] transitions to 1
    When channel N is selected and completes the transfer
    Then the number of words transferred should equal TOTSZ
    And "dma_ack_o"[N] should pulse to 1

  @handshake
  Formal Scenario: dma_ack_o remains deasserted while chunk transfer is in progress
    Given "rst_i" is deasserted
    And channel N is configured for hardware-handshake mode
    And channel N chunk transfer is in progress and not yet complete
    When one clock edge passes
    Then "dma_ack_o"[N] should be 0

  # ---------------------------------------------------------------
  # Linked-list descriptor mode
  # ---------------------------------------------------------------

  @descriptor
  Formal Scenario: Descriptor fetch updates channel working state
    Given "rst_i" is deasserted
    And channel N has "USE_ED" set to 1
    And channel N descriptor pointer "CHn_DESC" points to descriptor value DESCVAL
    When the DMA engine fetches the descriptor for channel N
    Then "de_csr_we" should assert
    And "de_txsz_we" should assert
    And "de_adr0_we" and "de_adr1_we" should assert
    And "de_csr" should equal the CSR field of DESCVAL
    And "de_txsz" should equal the size field of DESCVAL
    And "de_adr0" should equal the source-address field of DESCVAL
    And "de_adr1" should equal the destination-address field of DESCVAL

  @descriptor
  Formal Scenario: End-of-list descriptor completes the channel
    Given "rst_i" is deasserted
    And channel N has "USE_ED" set to 1
    And the fetched descriptor for channel N indicates end-of-list
    When the descriptor is processed
    Then channel N done status should be 1
    And channel N busy status should be 0

  @descriptor
  Formal Scenario: Non-end descriptor continues channel transfer flow
    Given "rst_i" is deasserted
    And channel N has "USE_ED" set to 1
    And the fetched descriptor for channel N does not indicate end-of-list
    When the descriptor is processed
    Then channel N busy status should remain 1
    And "de_adr0" should equal the updated source-address field from the descriptor
    And "de_adr1" should equal the updated destination-address field from the descriptor
    And "de_txsz" should equal the updated size field from the descriptor
    And the DMA engine should initiate the next transfer segment using "de_adr0", "de_adr1", and "de_txsz"

  # ---------------------------------------------------------------
  # Circular buffer / software pointer behavior
  # ---------------------------------------------------------------

  @circular_buffer
  Formal Scenario: Address mask restricts increment to unmasked bits
    Given "rst_i" is deasserted
    And channel N has capability bit CBUF set to 1
    And channel N address mask "CHn_AM0" equals MASK
    And channel N source address equals ADDR0
    When one word transfer increments the source address
    Then only bits of the address selected by MASK should change
    And bits outside MASK should remain equal to ADDR0's corresponding bits

  @circular_buffer
  Formal Scenario: Software pointer stalls channel at boundary
    Given "rst_i" is deasserted
    And channel N is configured for software-pointer FIFO mode
    And the DMA address for channel N equals the software pointer boundary SWPTR
    When one clock edge passes
    Then channel N transfer progress should stall
    And channel N busy status should remain 1 without further address advance

  # ---------------------------------------------------------------
  # Forced descriptor advance and restart
  # ---------------------------------------------------------------

  @restart
  Formal Scenario: dma_nd_i forces descriptor advance in linked-list handshake mode
    Given "rst_i" is deasserted
    And channel N has "USE_ED" set to 1 and is in hardware-handshake mode
    And "dma_nd_i"[N] transitions to 1
    When one clock edge passes
    Then the descriptor-advance qualifier "ndr" for channel N should assert
    And the DMA engine should fetch the next descriptor for channel N

  @restart
  Formal Scenario: dma_rest_i reloads channel working state when channel is idle
    Given "rst_i" is deasserted
    And channel N busy status is 0
    And "dma_rest_i"[N] transitions to 1
    When one clock edge passes
    Then channel N working state should be reloaded from its configured base registers
    And channel N busy status should reflect the reloaded configuration

  @restart
  Formal Scenario: dma_rest_i has no defined effect during active transfer
    Given "rst_i" is deasserted
    And channel N busy status is 1
    And "dma_rest_i"[N] transitions to 1
    When one clock edge passes
    Then "adr0" for channel N should remain unchanged by the restart request
    And "adr1" for channel N should remain unchanged by the restart request
    And "txsz" for channel N should continue its normal transfer-progress decrement unaffected by the restart request
    And channel N busy status should remain 1

  # ---------------------------------------------------------------
  # Interrupt and status behavior
  # ---------------------------------------------------------------

  @interrupt
  Formal Scenario: Channel done event sets interrupt source and masked output asserts
    Given "rst_i" is deasserted
    And channel N completes its transfer producing a done event
    And the interrupt mask register enables channel N done event routed to "inta_o"
    When one clock edge passes
    Then the interrupt source bit for channel N done should be set
    And "inta_o" should be 1

  @interrupt
  Formal Scenario: Masked-off event does not assert interrupt output
    Given "rst_i" is deasserted
    And channel N completes its transfer producing a done event
    And the interrupt mask register disables channel N done event for "inta_o" and "intb_o"
    When one clock edge passes
    Then the interrupt source bit for channel N done should be set
    And "inta_o" should be 0
    And "intb_o" should be 0

  @interrupt
  Formal Scenario: Channel error event sets error status and interrupt source
    Given "rst_i" is deasserted
    And channel N encounters a transfer error condition
    When one clock edge passes
    Then channel N error status bit should be 1
    And the interrupt source bit for channel N error should be set

  @interrupt
  Formal Scenario: Chunk done event routed to intb_o when configured
    Given "rst_i" is deasserted
    And channel N completes one chunk producing a chunk-done event
    And the interrupt mask register enables channel N chunk-done event routed to "intb_o"
    When one clock edge passes
    Then "intb_o" should be 1

  # ---------------------------------------------------------------
  # Pause and abort control
  # ---------------------------------------------------------------

  @control
  Formal Scenario: pause_req halts new channel dispatch
    Given "rst_i" is deasserted
    And "pause_req" is asserted by a register write
    When one clock edge passes
    Then no new channel transfer should be dispatched by the DMA engine while "pause_req" remains asserted

  @control
  Formal Scenario: dma_abort terminates active engine execution
    Given "rst_i" is deasserted
    And the DMA engine is executing a transfer for channel N
    And "dma_abort" is asserted by a register write
    When one clock edge passes
    Then the DMA engine should terminate the current transfer
    And channel N busy status should be cleared