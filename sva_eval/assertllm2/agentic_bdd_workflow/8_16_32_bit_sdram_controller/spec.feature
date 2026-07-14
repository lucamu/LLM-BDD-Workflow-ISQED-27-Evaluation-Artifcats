Feature: SDRAM Controller Top-Level (sdrc_top) Formal Verification

  Formal specification of the sdrc_top module, which bridges a Wishbone host
  interface to SDR SDRAM command/data signals through wb2sdrc (CDC/protocol
  bridge) and sdrc_core (SDRAM control/datapath).

  Background:
    Given the design is synchronous to "wb_clk_i" in the Wishbone domain
    And the design is synchronous to "sdram_clk" in the SDRAM domain
    And "wb_rst_i" is the active-high reset for the Wishbone domain
    And "sdram_resetn" is the active-low reset for the SDRAM domain
    And all signal values are evaluated at the active clock edge unless stated otherwise

  # -----------------------------------------------------------------
  # Reset behavior
  # -----------------------------------------------------------------

  @reset
  Formal Scenario: Wishbone domain reset forces ack low
    Given "wb_rst_i" is asserted
    When one clock edge occurs on "wb_clk_i"
    Then "wb_ack_o" should be 0

  @reset
  Formal Scenario: SDRAM domain reset forces init_done low
    Given "sdram_resetn" is deasserted (0)
    When one clock edge occurs on "sdram_clk"
    Then "sdr_init_done" should be 0

  @reset
  Formal Scenario: SDRAM domain reset forces command outputs to inactive state
    Given "sdram_resetn" is deasserted (0)
    When one clock edge occurs on "sdram_clk"
    Then "sdr_cs_n" should be 1
    And "sdr_ras_n" should be 1
    And "sdr_cas_n" should be 1
    And "sdr_we_n" should be 1

  # -----------------------------------------------------------------
  # Wishbone write/read acknowledge semantics
  # -----------------------------------------------------------------

  @wishbone @ack
  Formal Scenario: Write acknowledge requires command and write-data FIFOs not full
    Given "wb_rst_i" is deasserted
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "wb_we_i" is 1
    And the command FIFO full status is value cmd_full
    And the write-data FIFO full status is value wr_full
    When one clock edge occurs on "wb_clk_i"
    Then "wb_ack_o" should be 1 if cmd_full equals 0 and wr_full equals 0
    And "wb_ack_o" should be 0 if cmd_full equals 1 or wr_full equals 1

  @wishbone @ack
  Formal Scenario: Read acknowledge requires read-data FIFO not empty
    Given "wb_rst_i" is deasserted
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "wb_we_i" is 0
    And the read-data FIFO empty status is value rd_empty
    When one clock edge occurs on "wb_clk_i"
    Then "wb_ack_o" should be 1 if rd_empty equals 0
    And "wb_ack_o" should be 0 if rd_empty equals 1

  @wishbone @ack
  Formal Scenario: No acknowledge when cycle or strobe deasserted
    Given "wb_cyc_i" is value cyc
    And "wb_stb_i" is value stb
    And cyc equals 0 or stb equals 0
    When one clock edge occurs on "wb_clk_i"
    Then "wb_ack_o" should be 0

  @wishbone @pending_read
  Formal Scenario: Pending read blocks acceptance of a second read command
    Given "wb_rst_i" is deasserted
    And a read command has been accepted and is outstanding (pending_read is 1)
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "wb_we_i" is 0
    When one clock edge occurs on "wb_clk_i"
    Then "wb_ack_o" should be 0 while pending_read remains 1

  @wishbone @pending_read
  Formal Scenario: Pending read clears once read data returns to Wishbone
    Given "wb_rst_i" is deasserted
    And pending_read is 1
    And the read-data FIFO becomes non-empty and is consumed by wb_ack_o
    When one clock edge occurs on "wb_clk_i"
    Then pending_read should become 0 after the read response is delivered

  # -----------------------------------------------------------------
  # sdr_req assertion
  # -----------------------------------------------------------------

  @sdr_req
  Formal Scenario: sdr_req asserted whenever command FIFO is non-empty
    Given the command FIFO empty status is value cmd_empty
    When one clock edge occurs on "sdram_clk"
    Then "sdr_req" should be 1 if cmd_empty equals 0
    And "sdr_req" should be 0 if cmd_empty equals 1

  # -----------------------------------------------------------------
  # Fixed request length behavior
  # -----------------------------------------------------------------

  @request_length
  Formal Scenario: wb2sdrc always packs a fixed single-unit request length
    Given "wb_rst_i" is deasserted
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "wb_cti_i" is any value cti
    When a command is packed into the command FIFO
    Then the packed burst_length field should be 1 regardless of cti

  # -----------------------------------------------------------------
  # sdr_dq tri-state behavior
  # -----------------------------------------------------------------

  @tristate
  Formal Scenario: sdr_dq driven when any byte-lane output enable asserted
    Given the write output-enable lanes value is den_n
    And the write data value is sdr_dout
    When den_n indicates at least one lane driving (any bit of den_n equals 0)
    Then "sdr_dq" should equal sdr_dout on the driving lanes

  @tristate
  Formal Scenario: sdr_dq high impedance when no output enable asserted
    Given the write output-enable lanes value is den_n
    And all bits of den_n equal 1
    Then "sdr_dq" should be high impedance (Z)

  # -----------------------------------------------------------------
  # Address/width mode mapping (sdrc_req_gen)
  # -----------------------------------------------------------------

  @addr_mapping @width_mode
  Formal Scenario: 32-bit width mode passes address and length unmodified
    Given "cfg_sdr_width" is 2'b00
    And the application address is value app_addr
    And the application request length is value app_len
    When the request is normalized by sdrc_req_gen
    Then the internal address should equal app_addr
    And the internal length should equal app_len

  @addr_mapping @width_mode
  Formal Scenario: 16-bit width mode left-shifts address and length by one bit
    Given "cfg_sdr_width" is 2'b01
    And the application address is value app_addr
    And the application request length is value app_len
    When the request is normalized by sdrc_req_gen
    Then the internal address should equal (app_addr << 1)
    And the internal length should equal (app_len << 1)

  @addr_mapping @width_mode
  Formal Scenario: 8-bit width mode left-shifts address and length by two bits
    Given "cfg_sdr_width" is 2'b1x
    And the application address is value app_addr
    And the application request length is value app_len
    When the request is normalized by sdrc_req_gen
    Then the internal address should equal (app_addr << 2)
    And the internal length should equal (app_len << 2)

  # -----------------------------------------------------------------
  # Column/Bank/Row decoding (sdrc_req_gen)
  # -----------------------------------------------------------------

  @decode @colbits
  Formal Scenario: Column bank row decode for cfg_colbits 00
    Given "cfg_colbits" is 2'b00
    And the internal address is value addr
    When the address is decoded
    Then the column field should equal addr[7:0]
    And the bank field should equal addr[9:8]
    And the row field should equal addr[22:10]

  @decode @colbits
  Formal Scenario: Column bank row decode for cfg_colbits 01
    Given "cfg_colbits" is 2'b01
    And the internal address is value addr
    When the address is decoded
    Then the column field should equal addr[8:0]
    And the bank field should equal addr[10:9]
    And the row field should equal addr[23:11]

  @decode @colbits
  Formal Scenario: Column bank row decode for cfg_colbits 10
    Given "cfg_colbits" is 2'b10
    And the internal address is value addr
    When the address is decoded
    Then the column field should equal addr[9:0]
    And the bank field should equal addr[11:10]
    And the row field should equal addr[24:12]

  @decode @colbits
  Formal Scenario: Column bank row decode for cfg_colbits 11
    Given "cfg_colbits" is 2'b11
    And the internal address is value addr
    When the address is decoded
    Then the column field should equal addr[10:0]
    And the bank field should equal addr[12:11]
    And the row field should equal addr[25:13]

  # -----------------------------------------------------------------
  # Page boundary split (wrap disabled)
  # -----------------------------------------------------------------

  @page_split
  Formal Scenario: Non-wrap request crossing page boundary is split into sequential chunks
    Given wrap input to sdrc_req_gen is tied low
    And a request with start column value col and length value len crosses the page boundary
    When the request is processed by sdrc_req_gen
    Then the request should be split into multiple sequential chunk transfers
    And the sum of chunk lengths should equal len
    And each chunk should remain within a single page boundary

  # -----------------------------------------------------------------
  # Initialization / sdr_init_done
  # -----------------------------------------------------------------

  @init
  Formal Scenario: sdr_init_done remains 0 until initialization sequence completes
    Given "sdram_resetn" is asserted (1)
    And "cfg_sdr_en" is 1
    And the initialization state machine has not reached the active-service state
    When one clock edge occurs on "sdram_clk"
    Then "sdr_init_done" should be 0

  @init
  Formal Scenario: sdr_init_done asserts once initialization completes and controller is enabled
    Given "sdram_resetn" is asserted (1)
    And "cfg_sdr_en" is 1
    And the initialization state machine reaches the active-service state
    When one clock edge occurs on "sdram_clk"
    Then "sdr_init_done" should be 1

  @init
  Formal Scenario: sdr_init_done deasserts when controller is disabled
    Given "cfg_sdr_en" is 0
    When one clock edge occurs on "sdram_clk"
    Then "sdr_init_done" should be 0

  # -----------------------------------------------------------------
  # Refresh scheduling
  # -----------------------------------------------------------------

  @refresh
  Formal Scenario: Refresh cycle is triggered when refresh interval threshold is reached
    Given "sdr_init_done" is 1
    And the refresh interval counter reaches value cfg_sdr_rfsh
    When one clock edge occurs on "sdram_clk"
    Then a refresh command should be scheduled/issued before exceeding cfg_sdr_rfmax pending rows

  @refresh
  Formal Scenario: Refresh row count threshold bounds outstanding refresh requests
    Given the pending refresh row count is value pending_rows
    And pending_rows is less than or equal to cfg_sdr_rfmax
    Then the controller should not force an over-threshold refresh backlog beyond cfg_sdr_rfmax

  # -----------------------------------------------------------------
  # Bank request buffering / cfg_req_depth
  # -----------------------------------------------------------------

  @bank_ctl @backpressure
  Formal Scenario: Bank request queue depth limited by cfg_req_depth causes backpressure
    Given "cfg_req_depth" is value depth
    And the queued bank request count reaches value depth
    When a new request arrives for that bank
    Then the bank_ctl arbitration should apply backpressure and not accept the request until depth decreases

  # -----------------------------------------------------------------
  # Data width conversion (sdrc_bs_convert)
  # -----------------------------------------------------------------

  @data_conversion @width_mode
  Formal Scenario: 32-bit mode maps application word directly to SDRAM beat
    Given "cfg_sdr_width" is 2'b00
    And the application write data is value app_wdata
    When the data is converted by sdrc_bs_convert
    Then a single SDRAM beat should equal app_wdata

  @data_conversion @width_mode
  Formal Scenario: 16-bit mode transfers application word as two SDRAM beats
    Given "cfg_sdr_width" is 2'b01
    And the application write data is value app_wdata
    When the data is converted by sdrc_bs_convert
    Then the first SDRAM beat should equal app_wdata[15:0]
    And the second SDRAM beat should equal app_wdata[31:16]

  @data_conversion @width_mode
  Formal Scenario: 8-bit mode transfers application word as four SDRAM beats
    Given "cfg_sdr_width" is 2'b1x
    And the application write data is value app_wdata
    When the data is converted by sdrc_bs_convert
    Then the first SDRAM beat should equal app_wdata[7:0]
    And the second SDRAM beat should equal app_wdata[15:8]
    And the third SDRAM beat should equal app_wdata[23:16]
    And the fourth SDRAM beat should equal app_wdata[31:24]

  @data_conversion @read_reassembly
  Formal Scenario: Read data reassembled into 32-bit word before app_rd_valid assertion
    Given "cfg_sdr_width" is value width_mode
    And all required SDRAM read beats for one application word have been captured
    When the last beat for the word is captured
    Then "app_rd_valid" should assert
    And the reassembled 32-bit read data should equal the concatenation of the captured beats according to width_mode

  # -----------------------------------------------------------------
  # Bank FSM page hit/miss sequencing
  # -----------------------------------------------------------------

  @bank_fsm
  Formal Scenario: Page-hit request proceeds directly to read/write command
    Given the requested row equals the currently open row for the target bank (page hit)
    And timing constraints trcd are satisfied
    When the bank_fsm processes the request
    Then the bank_fsm should issue a read or write command without an intervening precharge/activate

  @bank_fsm
  Formal Scenario: Page-miss request requires precharge then activate before transfer
    Given the requested row differs from the currently open row for the target bank (page miss)
    When the bank_fsm processes the request
    Then the bank_fsm should issue a precharge command
    And after tras/trp timing constraints are satisfied, the bank_fsm should issue an activate command
    And only after trcd timing is satisfied should the bank_fsm issue the read or write command

  @bank_fsm @timing
  Formal Scenario: Activate-to-precharge respects tras timing constraint
    Given a bank is activated at time t_act
    And "cfg_sdr_tras_d" is value tras_d
    When a precharge is requested for that bank
    Then the precharge command should not be issued before t_act + tras_d SDRAM clock cycles

  @bank_fsm @timing
  Formal Scenario: Precharge-to-activate respects trp timing constraint
    Given a bank precharge completes at time t_pre
    And "cfg_sdr_trp_d" is value trp_d
    When an activate is requested for that bank
    Then the activate command should not be issued before t_pre + trp_d SDRAM clock cycles

  @bank_fsm @timing
  Formal Scenario: Activate-to-read/write respects trcd timing constraint
    Given a bank is activated at time t_act
    And "cfg_sdr_trcd_d" is value trcd_d
    When a read or write command is requested for that bank
    Then the read/write command should not be issued before t_act + trcd_d SDRAM clock cycles

  # -----------------------------------------------------------------
  # Configuration stability constraint
  # -----------------------------------------------------------------

  @config_stability
  Formal Scenario: Configuration signals remain stable during enabled normal operation
    Given "cfg_sdr_en" is 1
    And "sdr_init_done" is 1
    And cfg_sdr_width, cfg_colbits, cfg_req_depth hold values w, c, d respectively at time t
    When one clock edge occurs on "sdram_clk" during normal enabled operation
    Then cfg_sdr_width should still equal w
    And cfg_colbits should still equal c
    And cfg_req_depth should still equal d

  # -----------------------------------------------------------------
  # wb_cti_i not used for burst formation
  # -----------------------------------------------------------------

  @cti_unused
  Formal Scenario: wb_cti_i value does not alter command FIFO packing behavior
    Given "wb_cti_i" takes any value cti_a
    And an identical transaction with "wb_cti_i" taking any other value cti_b
    And all other Wishbone inputs are identical between the two transactions
    When each transaction is packed into the command FIFO
    Then the resulting packed command fields should be identical regardless of cti_a versus cti_b