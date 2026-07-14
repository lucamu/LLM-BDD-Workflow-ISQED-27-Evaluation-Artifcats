Feature: SDRAM Controller Formal Verification

  This feature specifies formally verifiable properties of the SDRAM
  Controller Core, covering the WISHBONE interface protocol, application
  interface handshaking, SDRAM command encoding, address mapping,
  bank management, refresh generation, and CAS latency behavior.

  Scenarios tagged "@parameterized" describe property families that hold
  for all valid values of the referenced configuration parameter(s),
  as opposed to example-driven test cases with fixed constants.

  Background:
    Given the system clock "wb_clk_i" is toggling every cycle
    And the synchronous active-high reset "wb_rst_i" is used
    And all outputs are registered on the positive edge of "wb_clk_i"
    And the SDRAM controller is enabled via "cfg_sdr_en"

  # ---------------------------------------------------------------
  # RESET BEHAVIOR
  # ---------------------------------------------------------------

  @reset @safety
  Formal Scenario: Reset forces SDRAM command outputs to NOP/inhibit state
    Given "wb_rst_i" is asserted
    When one clock edge occurs
    Then "sdr_cs_n" should be 1
    And "sdr_cke" should be 0
    And "sdr_ras_n" should be 1
    And "sdr_cas_n" should be 1
    And "sdr_we_n" should be 1
    And "wb_ack_o" should be 0
    And "app_req_ack" should be 0
    And "app_rd_valid" should be 0

  @reset @safety
  Formal Scenario: Reset clears busy indication to a known safe state
    Given "wb_rst_i" is asserted
    When one clock edge occurs
    Then "sdr_core_busy_n" should be 0

  # ---------------------------------------------------------------
  # SDRAM COMMAND ENCODING (Table: Command truth table)
  # ---------------------------------------------------------------

  @command_encoding @combinational
  Formal Scenario: No Operation command encoding
    Given "wb_rst_i" is deasserted
    And the controller issues command type "NOP"
    When one clock edge occurs
    Then "sdr_ras_n" should be 1
    And "sdr_cas_n" should be 1
    And "sdr_we_n" should be 1

  @command_encoding @combinational
  Formal Scenario: Active command encoding
    Given "wb_rst_i" is deasserted
    And the controller issues command type "ACTIVE"
    When one clock edge occurs
    Then "sdr_ras_n" should be 0
    And "sdr_cas_n" should be 1
    And "sdr_we_n" should be 1

  @command_encoding @combinational
  Formal Scenario: Read command encoding
    Given "wb_rst_i" is deasserted
    And the controller issues command type "READ"
    When one clock edge occurs
    Then "sdr_ras_n" should be 1
    And "sdr_cas_n" should be 0
    And "sdr_we_n" should be 1

  @command_encoding @combinational
  Formal Scenario: Write command encoding
    Given "wb_rst_i" is deasserted
    And the controller issues command type "WRITE"
    When one clock edge occurs
    Then "sdr_ras_n" should be 1
    And "sdr_cas_n" should be 0
    And "sdr_we_n" should be 0

  @command_encoding @combinational
  Formal Scenario: Burst terminate command encoding
    Given "wb_rst_i" is deasserted
    And the controller issues command type "BURST_TERMINATE"
    When one clock edge occurs
    Then "sdr_ras_n" should be 1
    And "sdr_cas_n" should be 1
    And "sdr_we_n" should be 0

  @command_encoding @combinational
  Formal Scenario: Precharge command encoding
    Given "wb_rst_i" is deasserted
    And the controller issues command type "PRECHARGE"
    When one clock edge occurs
    Then "sdr_ras_n" should be 0
    And "sdr_cas_n" should be 1
    And "sdr_we_n" should be 0

  @command_encoding @combinational
  Formal Scenario: Auto refresh command encoding
    Given "wb_rst_i" is deasserted
    And the controller issues command type "AUTO_REFRESH"
    When one clock edge occurs
    Then "sdr_ras_n" should be 0
    And "sdr_cas_n" should be 0
    And "sdr_we_n" should be 1

  @command_encoding @combinational
  Formal Scenario: Load mode register command encoding
    Given "wb_rst_i" is deasserted
    And the controller issues command type "LOAD_MODE_REGISTER"
    When one clock edge occurs
    Then "sdr_ras_n" should be 0
    And "sdr_cas_n" should be 0
    And "sdr_we_n" should be 0

  # ---------------------------------------------------------------
  # WISHBONE PROTOCOL PROPERTIES
  # ---------------------------------------------------------------

  @wishbone @protocol
  Formal Scenario: Acknowledge only asserted during valid cycle and strobe
    Given "wb_rst_i" is deasserted
    And "wb_ack_o" is asserted
    Then "wb_cyc_i" should have been 1
    And "wb_stb_i" should have been 1

  @wishbone @protocol
  Formal Scenario: No acknowledge without an active bus cycle
    Given "wb_rst_i" is deasserted
    And "wb_cyc_i" is 0
    When one clock edge occurs
    Then "wb_ack_o" should be 0

  @wishbone @protocol
  Formal Scenario: Write data captured only when write enable and strobe are asserted
    Given "wb_rst_i" is deasserted
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "wb_we_i" is 1
    And "wb_dat_i" holds value D
    And "wb_sel_i" holds value SEL
    When "wb_ack_o" is asserted on this transaction
    Then the byte lanes selected by SEL of the internal write data register should equal the corresponding byte lanes of D

  @wishbone @protocol
  Formal Scenario: Read data output stable when not acknowledged
    Given "wb_rst_i" is deasserted
    And "wb_ack_o" is 0
    When one clock edge occurs
    Then "wb_dat_o" should remain unchanged from the previous cycle

  # ---------------------------------------------------------------
  # APPLICATION INTERFACE HANDSHAKE
  # ---------------------------------------------------------------

  @app_interface @protocol
  Formal Scenario: Application request acknowledgment implies request and non-busy condition
    Given "wb_rst_i" is deasserted
    And "app_req_ack" is 1
    Then "app_req" should have been 1 on the acknowledging cycle
    And "sdr_core_busy_n" should have been 1 on the acknowledging cycle

  @app_interface @protocol
  Formal Scenario: Application request never acknowledged while controller busy
    Given "wb_rst_i" is deasserted
    And "sdr_core_busy_n" is 0
    When one clock edge occurs
    Then "app_req_ack" should be 0

  @app_interface @protocol
  Formal Scenario: Read valid only follows a prior read request
    Given "wb_rst_i" is deasserted
    And "app_rd_valid" is 1
    Then there exists a prior cycle where "app_req" was 1 and "app_req_wr_n" was 1 and "app_req_ack" was 1

  @app_interface @protocol
  Formal Scenario: Write enable byte lanes reflect requested byte mask on write
    Given "wb_rst_i" is deasserted
    And an application write request is accepted with byte mask M
    When the corresponding SDRAM write cycle occurs
    Then "app_wr_en_n" should equal the bitwise complement of M

  @app_interface @protocol
  Formal Scenario: Next write data requested only during active write burst
    Given "wb_rst_i" is deasserted
    And "app_wr_next" is 1
    Then a write transaction should be in progress

  # ---------------------------------------------------------------
  # ADDRESS MAPPING (Section 4, Column/Bank/Row decoding)
  # ---------------------------------------------------------------

  @address_mapping @combinational @parameterized
  Formal Scenario: Column bank row decode for cfg_colbits 00 (8-bit column) (parameterized property family)
    Given "wb_rst_i" is deasserted
    And "cfg_colbits" is 2'b00
    And the internal SDRAM mapping address holds value A
    When the address decoder computes column, bank, and row
    Then the column address should equal {4'h0, A[7:0]}
    And the bank address should equal A[9:8]
    And the row address should equal A[21:10]

  @address_mapping @combinational @parameterized
  Formal Scenario: Column bank row decode for cfg_colbits 01 (9-bit column) (parameterized property family)
    Given "wb_rst_i" is deasserted
    And "cfg_colbits" is 2'b01
    And the internal SDRAM mapping address holds value A
    When the address decoder computes column, bank, and row
    Then the column address should equal {3'h0, A[8:0]}
    And the bank address should equal A[10:9]
    And the row address should equal A[22:11]

  @address_mapping @combinational @parameterized
  Formal Scenario: Column bank row decode for cfg_colbits 10 (10-bit column) (parameterized property family)
    Given "wb_rst_i" is deasserted
    And "cfg_colbits" is 2'b10
    And the internal SDRAM mapping address holds value A
    When the address decoder computes column, bank, and row
    Then the column address should equal {2'h0, A[9:0]}
    And the bank address should equal A[11:10]
    And the row address should equal A[23:12]

  @address_mapping @combinational @parameterized
  Formal Scenario: Column bank row decode for cfg_colbits 11 (11-bit column) (parameterized property family)
    Given "wb_rst_i" is deasserted
    And "cfg_colbits" is 2'b11
    And the internal SDRAM mapping address holds value A
    When the address decoder computes column, bank, and row
    Then the column address should equal {1'h0, A[10:0]}
    And the bank address should equal A[12:11]
    And the row address should equal A[24:13]

  @address_mapping @combinational @parameterized
  Formal Scenario: Application to SDRAM address mapping for 8-bit mode (parameterized property family)
    Given "wb_rst_i" is deasserted
    And "SDR_DW" is 8
    And "app_req_addr" holds value ADDR
    When the SDRAM mapping address is computed
    Then the SDRAM mapping address should equal ADDR[25:0]

  @address_mapping @combinational @parameterized
  Formal Scenario: Application to SDRAM address mapping for 16-bit mode (parameterized property family)
    Given "wb_rst_i" is deasserted
    And "SDR_DW" is 16
    And "app_req_addr" holds value ADDR
    When the SDRAM mapping address is computed
    Then the SDRAM mapping address should equal ADDR[26:1]

  @address_mapping @combinational @parameterized
  Formal Scenario: Application to SDRAM address mapping for 32-bit mode (parameterized property family)
    Given "wb_rst_i" is deasserted
    And "SDR_DW" is 32
    And "app_req_addr" holds value ADDR
    When the SDRAM mapping address is computed
    Then the SDRAM mapping address should equal ADDR[26:2]

  # ---------------------------------------------------------------
  # REQUEST GENERATOR: BURST LENGTH / ADDRESS SCALING
  # ---------------------------------------------------------------

  @request_generator @combinational @parameterized
  Formal Scenario: Internal request address scaling for 32-bit SDRAM width (parameterized property family)
    Given "wb_rst_i" is deasserted
    And SDRAM width configuration is 2'b00
    And "app_req_addr" holds value ADDR
    And "app_req_len" holds value LEN
    When the request generator computes internal request parameters
    Then the internal request address should equal ADDR
    And the internal request length should equal LEN

  @request_generator @combinational @parameterized
  Formal Scenario: Internal request address scaling for 16-bit SDRAM width (parameterized property family)
    Given "wb_rst_i" is deasserted
    And SDRAM width configuration is 2'b01
    And "app_req_addr" holds value ADDR
    And "app_req_len" holds value LEN
    When the request generator computes internal request parameters
    Then the internal request address should equal {ADDR, 1'b0}
    And the internal request length should equal {LEN, 1'b0}

  @request_generator @combinational @parameterized
  Formal Scenario: Internal request address scaling for 8-bit SDRAM width (parameterized property family)
    Given "wb_rst_i" is deasserted
    And SDRAM width configuration is 2'b10
    And "app_req_addr" holds value ADDR
    And "app_req_len" holds value LEN
    When the request generator computes internal request parameters
    Then the internal request address should equal {ADDR, 2'b00}
    And the internal request length should equal {LEN, 2'b00}

  @request_generator @safety
  Formal Scenario: Page boundary crossing splits request when wrap is disabled
    Given "wb_rst_i" is deasserted
    And "app_req_wrap" is 0
    And a request with address ADDR and length LEN crosses a page boundary
    When the request generator processes the request
    Then two sub-requests should be issued
    And the sum of the two sub-request lengths should equal LEN
    And the first sub-request address should equal ADDR

  @request_generator @safety
  Formal Scenario: Non-crossing request is passed through unmodified when wrap is disabled
    Given "wb_rst_i" is deasserted
    And "app_req_wrap" is 0
    And a request with address ADDR and length LEN does not cross a page boundary
    When the request generator processes the request
    Then exactly one sub-request should be issued
    And the sub-request address should equal ADDR
    And the sub-request length should equal LEN

  @request_generator @safety
  Formal Scenario: Wrapped request preserves address and length
    Given "wb_rst_i" is deasserted
    And "app_req_wrap" is 1
    And a request with address ADDR and length LEN is issued
    When the request generator processes the request
    Then the sub-request address should equal ADDR
    And the sub-request length should equal LEN

  # ---------------------------------------------------------------
  # BANK CONTROLLER: PAGE HIT/MISS AND PRECHARGE/ACTIVATE
  # ---------------------------------------------------------------

  @bank_controller @safety
  Formal Scenario: Activate command issued only for a closed bank with bounded read/write delay
    Given "wb_rst_i" is deasserted
    And "cfg_sdr_trcd_d" holds value TRCD
    And bank B is currently closed
    And a request targets bank B with row R
    When the bank controller processes the request
    Then an "ACTIVE" command should be issued for bank B with row address R at cycle Ta
    And no "READ" or "WRITE" command should be issued to bank B before cycle Ta + TRCD

  @bank_controller @safety
  Formal Scenario: Precharge issued on row change within an open bank with bounded reactivation delay
    Given "wb_rst_i" is deasserted
    And "cfg_sdr_trp_d" holds value TRP
    And bank B is currently open with row R1
    And a new request targets bank B with a different row R2
    When the bank controller processes the request
    Then a "PRECHARGE" command should be issued for bank B at cycle Tp
    And the "ACTIVE" command with row address R2 should be issued no earlier than cycle Tp + TRP
    And no "ACTIVE" command with row address R2 should be issued for bank B before cycle Tp + TRP

  @bank_controller @safety
  Formal Scenario: Page hit avoids redundant activate command
    Given "wb_rst_i" is deasserted
    And bank B is currently open with row R
    And a new request targets bank B with the same row R
    When the bank controller processes the request
    Then no additional "ACTIVE" command should be issued for bank B
    And the request should proceed directly to the transfer controller

  # ---------------------------------------------------------------
  # TIMING PARAMETER COMPLIANCE
  # ---------------------------------------------------------------

  @timing @safety
  Formal Scenario: Minimum RAS-to-CAS delay honored within TRCD cycles
    Given "wb_rst_i" is deasserted
    And "cfg_sdr_trcd_d" holds value TRCD
    And an "ACTIVE" command is issued to bank B at cycle T
    Then no "READ" or "WRITE" command should be issued to bank B within the window [T, T + TRCD)
    And "READ" or "WRITE" commands to bank B are permitted starting at cycle T + TRCD

  @timing @safety
  Formal Scenario: Minimum precharge period honored within TRP cycles
    Given "wb_rst_i" is deasserted
    And "cfg_sdr_trp_d" holds value TRP
    And a "PRECHARGE" command is issued to bank B at cycle T
    Then no "ACTIVE" command should be issued to bank B within the window [T, T + TRP)
    And "ACTIVE" commands to bank B are permitted starting at cycle T + TRP

  @timing @safety
  Formal Scenario: Minimum active-to-precharge period honored within TRAS cycles
    Given "wb_rst_i" is deasserted
    And "cfg_sdr_tras_d" holds value TRAS
    And an "ACTIVE" command is issued to bank B at cycle T
    Then no "PRECHARGE" command should be issued to bank B within the window [T, T + TRAS)
    And "PRECHARGE" commands to bank B are permitted starting at cycle T + TRAS

  @timing @safety
  Formal Scenario: Minimum active-to-active period honored within TRC cycles
    Given "wb_rst_i" is deasserted
    And "cfg_sdr_trcar_d" holds value TRC
    And an "ACTIVE" or "AUTO_REFRESH" command is issued to bank B at cycle T
    Then no subsequent "ACTIVE" or "AUTO_REFRESH" command should be issued to bank B within the window [T, T + TRC)

  @timing @safety
  Formal Scenario: Write recovery time honored within TWR cycles before precharge
    Given "wb_rst_i" is deasserted
    And "cfg_sdr_twr_d" holds value TWR
    And a "WRITE" command completes at cycle T
    Then no "PRECHARGE" command should be issued to the corresponding bank within the window [T, T + TWR)
    And "PRECHARGE" commands to that bank are permitted starting at cycle T + TWR

  # ---------------------------------------------------------------
  # CAS LATENCY
  # ---------------------------------------------------------------

  @cas_latency @safety @parameterized
  Formal Scenario: Read data appears exactly CAS latency cycles after read command (parameterized property family)
    Given "wb_rst_i" is deasserted
    And "cfg_sdr_cas" holds value CL
    And a "READ" command is issued at cycle T
    Then valid read data should appear on the SDRAM data path at cycle T + CL
    And "app_rd_valid" should not be asserted for that data within the window [T, T + CL)

  # ---------------------------------------------------------------
  # AUTOMATIC REFRESH
  # ---------------------------------------------------------------

  @refresh @liveness
  Formal Scenario: Auto-refresh command issued periodically within bounded RFSH_PERIOD window
    Given "wb_rst_i" is deasserted
    And "cfg_sdr_rfsh" holds value RFSH_PERIOD
    And an "AUTO_REFRESH" command was issued at cycle T
    Then another "AUTO_REFRESH" command should be issued within the bounded window [T + 1, T + RFSH_PERIOD]

  @refresh @safety
  Formal Scenario: Refresh command only issued when all banks are precharged
    Given "wb_rst_i" is deasserted
    And an "AUTO_REFRESH" command is issued at cycle T
    Then all banks should be in the precharged (closed) state at cycle T

  @refresh @safety @parameterized
  Formal Scenario: cfg_sdr_rfmax bounds the number of rows refreshed at a time (parameterized property family)
    Given "wb_rst_i" is deasserted
    And "cfg_sdr_rfmax" holds value RFMAX
    And a burst of pending auto-refresh requests has accumulated due to deferred refresh
    Then the number of consecutive "AUTO_REFRESH" commands issued back-to-back without an intervening normal access should not exceed RFMAX
    And the count of outstanding (pending, not-yet-serviced) refresh requests should never exceed RFMAX

  # ---------------------------------------------------------------
  # INITIALIZATION SEQUENCE
  # ---------------------------------------------------------------

  @initialization @safety
  Formal Scenario: Mode register load occurs only after precharge and two refresh cycles within bounded windows
    Given "wb_rst_i" is deasserted
    And "cfg_sdr_trp_d" holds value TRP
    And "cfg_sdr_trcar_d" holds value TRC
    And the controller is in the power-up initialization sequence
    When a "LOAD_MODE_REGISTER" command is issued at cycle Tm
    Then a "PRECHARGE" command for all banks should have occurred at some cycle Tp with Tp < Tm
    And a first "AUTO_REFRESH" command should have occurred at cycle Tr1 with Tr1 >= Tp + TRP and Tr1 < Tm
    And a second "AUTO_REFRESH" command should have occurred at cycle Tr2 with Tr2 >= Tr1 + TRC and Tr2 < Tm
    And Tm should satisfy Tm >= Tr2 + TRC

  @initialization @safety
  Formal Scenario: No command other than NOP or inhibit issued during bounded power-up delay window
    Given "wb_rst_i" is deasserted
    And "INIT_DELAY_CYCLES" holds the value corresponding to the required 100us power-up delay
    And the controller is within the initial power-up delay window starting at reset deassertion cycle T0
    Then only "NOP" or command-inhibit states should be issued on the SDRAM command bus within the window [T0, T0 + INIT_DELAY_CYCLES)

  # ---------------------------------------------------------------
  # DATA MASK (BYTE-WISE WRITE)
  # ---------------------------------------------------------------

  @data_mask @combinational
  Formal Scenario: DQM reflects inactive byte lanes during partial write
    Given "wb_rst_i" is deasserted
    And a "WRITE" command is issued with byte enable mask M
    When one clock edge occurs
    Then "sdr_dqm" should equal the bitwise complement of M

  # ---------------------------------------------------------------
  # CLOCK ENABLE
  # ---------------------------------------------------------------

  @clock_enable @safety
  Formal Scenario: Clock enable asserted only after initialization completes
    Given "wb_rst_i" is deasserted
    And "sdr_cke" is 1
    Then the power-up initialization sequence should have completed at some prior cycle Ti
    And Ti should be less than the current cycle