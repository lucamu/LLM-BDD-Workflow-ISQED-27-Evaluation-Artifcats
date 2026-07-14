Feature: mc_top Memory Controller Formal Verification

  As a formal verification engineer
  I want to verify mc_top memory controller properties
  So that WISHBONE-to-memory bridging, timing, refresh, parity, and suspend/resume behavior are correct

  Background:
    Given the design is synchronous to "clk_i" for host-side logic
    And the design is synchronous to "mc_clk_i" for memory-side logic
    And "rst_i" is an asynchronous active-high reset
    And all outputs are sampled after reset deassertion unless otherwise stated
    And "mem_space" is defined as ("wb_addr_i"[31:29] == 3'b000)
    And "reg_space" is defined as ("wb_addr_i"[31:29] == 3'b011)
    And "mem_cycle_active" is defined as ("wb_cyc_i" AND "wb_stb_i" AND "mem_space" AND NOT "wb_ack_o" AND NOT "wb_err_o")
    And "sync_access_active" is defined as ("cs_en" AND the active chip-select type configured as synchronous static memory AND NOT "mem_ack")
    And "rmw_active" is defined as the internal "mc_adr_sel" state asserted while a read beat and a subsequent write beat of one RMW host cycle target the same address
    And "addr_fetch_req" is defined as the internal "mc_adr_sel" signal that forces a new address resolve/fetch cycle
    And "col_bits" is defined as the number of column address bits derived from "page_size" ("col_bits" = log2("page_size"))
    And "byte_lsb" is a fixed constant equal to 2 (word-aligned byte offset within "wb_addr_i")
    And "org_mode" is defined as bit 16 of "tms" for the active chip-select (0 = bank-then-row ordering, 1 = row-then-bank ordering)
    And "pack_reg" is defined as the internal 32-bit byte-packing register in "mc_dp"
    And "self_refresh_active" is defined as the internal signal asserted while managed SDRAM chip-selects are held in self-refresh during suspend entry
    And "access_cycle_count" is defined as the internal counter tracking elapsed cycles of the current synchronous access
    And "T_max" is defined as the timeout value configured in "tms" for the active chip-select
    And "N_SUSP" is a fixed bound on suspend-entry latency in "clk_i" cycles
    And "N_RESUME" is a fixed bound on resume latency in "clk_i" cycles
    And "N_GRANT" is a fixed bound on bus-grant latency in "mc_clk_i" cycles

  # ---------------------------------------------------------------
  # Reset Behavior
  # ---------------------------------------------------------------

  @reset
  Formal Scenario: Reset deasserts all chip-selects
    Given "rst_i" is asserted
    When one clock edge occurs on "clk_i"
    Then "mc_cs_pad_o_" should be 8'b11111111

  @reset
  Formal Scenario: Reset is asynchronous and deasserts chip-selects independent of clock edge
    Given "rst_i" transitions from 0 to 1 between clock edges of "clk_i"
    Then "mc_cs_pad_o_" should become 8'b11111111 without waiting for a "clk_i" edge

  @reset
  Formal Scenario: Reset suppresses acknowledge and error
    Given "rst_i" is asserted
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    When one clock edge occurs on "clk_i"
    Then "wb_ack_o" should be 0
    And "wb_err_o" should be 0

  @reset
  Formal Scenario: Reset blocks normal transaction servicing
    Given "rst_i" is asserted
    And "wb_addr_i" is any value A with A[31:29] equal to 3'b000
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    When one clock edge occurs on "clk_i"
    Then "wb_ack_o" should be 0

  # ---------------------------------------------------------------
  # Address Decode Semantics
  # ---------------------------------------------------------------

  @address_decode
  Formal Scenario: Memory-space address selects memory datapath
    Given "rst_i" is deasserted
    And "wb_addr_i" is any value A with A[31:29] equal to 3'b000
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    When one clock edge occurs on "clk_i"
    Then "mem_space" should be 1
    And "wb_ack_o" should equal "mem_ack"

  @address_decode
  Formal Scenario: Register-space address selects register-file datapath
    Given "rst_i" is deasserted
    And "wb_addr_i" is any value A with A[31:29] equal to 3'b011
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    When one clock edge occurs on "clk_i"
    Then "reg_space" should be 1
    And "wb_data_o" should equal "rf_dout"

  @address_decode
  Formal Scenario: Memory-space and register-space decodes are mutually exclusive
    Given "rst_i" is deasserted
    And "wb_addr_i" is any value A
    When one clock edge occurs on "clk_i"
    Then NOT ("mem_space" AND "reg_space")

  @address_decode
  Formal Scenario: Undecoded address region produces no controller response
    Given "rst_i" is deasserted
    And "wb_addr_i" is any value A with A[31:29] not equal to 3'b000 and A[31:29] not equal to 3'b011
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    When one clock edge occurs on "clk_i"
    Then "mem_space" should be 0
    And "reg_space" should be 0
    And "wb_ack_o" should be 0
    And "wb_err_o" should be 0

  # ---------------------------------------------------------------
  # mc_wb_if: Request Qualification
  # ---------------------------------------------------------------

  @wb_if
  Formal Scenario: Read request qualification requires cyc, stb, and not we
    Given "rst_i" is deasserted
    And "wb_addr_i" is any memory-space address A
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "wb_we_i" is 0
    When one clock edge occurs on "clk_i"
    Then "wb_read_go" should be 1

  @wb_if
  Formal Scenario: Write request qualification requires cyc, stb, and we
    Given "rst_i" is deasserted
    And "wb_addr_i" is any memory-space address A
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "wb_we_i" is 1
    When one clock edge occurs on "clk_i"
    Then "wb_write_go" should be 1

  @wb_if
  Formal Scenario: No request generated when cyc is deasserted
    Given "rst_i" is deasserted
    And "wb_cyc_i" is 0
    And "wb_stb_i" is any value
    And "wb_we_i" is any value
    When one clock edge occurs on "clk_i"
    Then "wb_read_go" should be 0
    And "wb_write_go" should be 0

  @wb_if
  Formal Scenario: No request generated when stb is deasserted
    Given "rst_i" is deasserted
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 0
    When one clock edge occurs on "clk_i"
    Then "wb_read_go" should be 0
    And "wb_write_go" should be 0

  @wb_if
  Formal Scenario: First beat is asserted at start of a new cycle
    Given "rst_i" is deasserted
    And "wb_cyc_i" transitions from 0 to 1
    And "wb_stb_i" is 1
    When one clock edge occurs on "clk_i"
    Then "wb_first" should be 1

  @wb_if
  Formal Scenario: Acknowledge follows memory completion
    Given "rst_i" is deasserted
    And "mem_cycle_active" is 1
    And "mem_ack" is 1
    And "err" is 0
    When one clock edge occurs on "clk_i"
    Then "wb_ack_o" should be 1

  @wb_if
  Formal Scenario: Error suppresses acknowledge
    Given "rst_i" is deasserted
    And "mem_cycle_active" is 1
    And "err" is 1
    When one clock edge occurs on "clk_i"
    Then "wb_err_o" should be 1
    And "wb_ack_o" should be 0

  # ---------------------------------------------------------------
  # Error Signaling
  # ---------------------------------------------------------------

  @error
  Formal Scenario: Parity mismatch on read asserts error
    Given "rst_i" is deasserted
    And a read transaction completes with captured data D and captured parity P
    And parity checking is enabled for the accessed chip-select
    And computed parity of D does not equal P
    When one clock edge occurs on "clk_i"
    Then "par_err" should be 1
    And "wb_err_o" should be 1
    And "wb_ack_o" should be 0

  @error
  Formal Scenario: No parity error implies no error contribution from parity path
    Given "rst_i" is deasserted
    And a read transaction completes with captured data D and captured parity P
    And parity checking is enabled for the accessed chip-select
    And computed parity of D equals P
    When one clock edge occurs on "clk_i"
    Then "par_err" should be 0

  @error
  Formal Scenario: No parity check contribution when parity checking is disabled
    Given "rst_i" is deasserted
    And a read transaction completes with captured data D and captured parity P
    And parity checking is disabled for the accessed chip-select
    And computed parity of D does not equal P
    When one clock edge occurs on "clk_i"
    Then "par_err" should be 0

  @error
  Formal Scenario: Write to write-protected region asserts error
    Given "rst_i" is deasserted
    And "wb_we_i" is 1
    And the addressed chip-select region CS has write-protect enabled
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    When one clock edge occurs on "clk_i"
    Then "wb_err_o" should be 1
    And "wb_ack_o" should be 0

  @error
  Formal Scenario: Read from write-protected region is not an error
    Given "rst_i" is deasserted
    And "wb_we_i" is 0
    And the addressed chip-select region CS has write-protect enabled
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "mem_ack" is 1
    When one clock edge occurs on "clk_i"
    Then "wb_err_o" should be 0
    And "wb_ack_o" should be 1

  @error
  Formal Scenario: Synchronous device timeout asserts error
    Given "rst_i" is deasserted
    And "sync_access_active" is 1
    And "access_cycle_count" exceeds "T_max"
    When one clock edge occurs on "clk_i"
    Then "wb_err_o" should be 1
    And "wb_ack_o" should be 0

  # ---------------------------------------------------------------
  # mc_rf: Register File and Chip-Select Configuration
  # ---------------------------------------------------------------

  @register_file
  Formal Scenario: Register write updates register content
    Given "rst_i" is deasserted
    And "wb_addr_i" is any register-space address A
    And "wb_data_i" is any value D
    And "wb_we_i" is 1
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    When one clock edge occurs on "clk_i"
    Then the addressed register should hold value D on subsequent read

  @register_file
  Formal Scenario: Register read returns stored value
    Given "rst_i" is deasserted
    And "wb_addr_i" is any register-space address A that maps to a previously written register holding value D
    And "wb_we_i" is 0
    And "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    When one clock edge occurs on "clk_i"
    Then "rf_dout" should equal D
    And "wb_data_o" should equal D

  @register_file
  Formal Scenario: Active chip-select context reflects decoded address
    Given "rst_i" is deasserted
    And "wb_addr_i" is any memory-space address A that decodes to chip-select region CS
    When one clock edge occurs on "clk_i"
    Then "cs" should equal CS

  # ---------------------------------------------------------------
  # mc_adr_sel: Address Generation
  # ---------------------------------------------------------------

  @address_gen
  Formal Scenario: SDRAM address decomposition in bank-then-row ordering (org_mode = 0)
    Given "rst_i" is deasserted
    And the active chip-select targets an SDRAM device
    And "wb_addr_i" is any value A
    And "org_mode" is 0
    When one clock edge occurs on "clk_i"
    Then "bank_adr" should equal A[col_bits+byte_lsb+1 : col_bits+byte_lsb]
    And "row_adr" should equal A[col_bits+byte_lsb+14 : col_bits+byte_lsb+2]

  @address_gen
  Formal Scenario: SDRAM address decomposition in row-then-bank ordering (org_mode = 1)
    Given "rst_i" is deasserted
    And the active chip-select targets an SDRAM device
    And "wb_addr_i" is any value A
    And "org_mode" is 1
    When one clock edge occurs on "clk_i"
    Then "row_adr" should equal A[col_bits+byte_lsb+12 : col_bits+byte_lsb]
    And "bank_adr" should equal A[col_bits+byte_lsb+14 : col_bits+byte_lsb+13]

  @address_gen
  Formal Scenario: Burst address increments on next_adr assertion
    Given "rst_i" is deasserted
    And "mc_addr" currently holds value M
    And "next_adr" is 1
    And burst mode is enabled for the active chip-select
    When one clock edge occurs on "mc_clk_i"
    Then "mc_addr" should equal M plus the configured burst increment

  @address_gen
  Formal Scenario: Address holds constant without next_adr
    Given "rst_i" is deasserted
    And "mc_addr" currently holds value M
    And "next_adr" is 0
    When one clock edge occurs on "mc_clk_i"
    Then "mc_addr" should equal M

  @address_gen
  Formal Scenario: RMW direction change forces address re-fetch
    Given "rst_i" is deasserted
    And "rmw_active" is 1
    And "wr_cycle" transitions from 0 to 1
    When one clock edge occurs on "mc_clk_i"
    Then "addr_fetch_req" should be 1

  # ---------------------------------------------------------------
  # mc_dp: Data Path, Packing, and Parity
  # ---------------------------------------------------------------

  @datapath
  Formal Scenario: Write data forwarded to memory data output
    Given "rst_i" is deasserted
    And "wb_data_i" is any value D
    And a qualified write transaction is active
    When one clock edge occurs on "mc_clk_i"
    Then "mc_data_pad_o" should equal D

  @datapath
  Formal Scenario: Byte parity generated when parity enabled
    Given "rst_i" is deasserted
    And "wb_data_i" is any value D
    And parity generation is enabled for the target chip-select
    And a qualified write transaction is active
    When one clock edge occurs on "mc_clk_i"
    Then "mc_dp_pad_o" should equal the computed byte parity of D

  @datapath
  Formal Scenario: Read data captured and returned to host
    Given "rst_i" is deasserted
    And "mc_data_del" holds captured value D with parity P
    And "dv" is 1
    When one clock edge occurs on "clk_i"
    Then "wb_data_o" should equal D[31:0]

  @datapath
  Formal Scenario: Narrow async read data packed according to pack controls
    Given "rst_i" is deasserted
    And the active chip-select is configured for narrow asynchronous width
    And "pack_le0" is 1 causing "pack_reg"[7:0] to capture byte B0
    And "pack_le1" is 1 causing "pack_reg"[15:8] to capture byte B1
    And "pack_le2" is 1 causing "pack_reg"[23:16] to capture byte B2
    And "dv" is 1 causing "pack_reg"[31:24] to capture byte B3
    When one clock edge occurs on "clk_i" with "dv" equal to 1
    Then "wb_data_o" should equal {B3, B2, B1, B0}

  # ---------------------------------------------------------------
  # mc_refresh: Refresh Request Generation
  # ---------------------------------------------------------------

  @refresh
  Formal Scenario: Refresh request asserted when interval elapses
    Given "rst_i" is deasserted
    And "cs_need_rfr" is nonzero for at least one chip-select
    And the internal prescale/interval counter reaches the programmed threshold defined by "ref_int" and "rfr_ps_val"
    When one clock edge occurs on "clk_i"
    Then "rfr_req" should be 1

  @refresh
  Formal Scenario: Refresh request remains asserted until acknowledged
    Given "rst_i" is deasserted
    And "rfr_req" is 1
    And "rfr_ack" is 0
    When one clock edge occurs on "clk_i"
    Then "rfr_req" should remain 1

  @refresh
  Formal Scenario: Refresh request deasserts after acknowledge
    Given "rst_i" is deasserted
    And "rfr_req" is 1
    And "rfr_ack" is 1
    When one clock edge occurs on "clk_i"
    Then "rfr_req" should be 0

  @refresh
  Formal Scenario: No refresh request when no chip-select needs refresh
    Given "rst_i" is deasserted
    And "cs_need_rfr" is 8'b00000000
    When one clock edge occurs on "clk_i"
    Then "rfr_req" should be 0

  # ---------------------------------------------------------------
  # mc_obct_top: Open Bank and Row Tracking
  # ---------------------------------------------------------------

  @open_bank
  Formal Scenario: Bank marked open after bank_set
    Given "rst_i" is deasserted
    And "bank_set" is 1
    And "cs" is any value CS
    And "bank_adr" is any value B
    When one clock edge occurs on "clk_i"
    Then "bank_open" should be 1 for chip-select CS and bank B

  @open_bank
  Formal Scenario: Bank marked closed after bank_clr
    Given "rst_i" is deasserted
    And a bank was previously open for chip-select CS and bank B
    And "bank_clr" is 1 for chip-select CS and bank B
    When one clock edge occurs on "clk_i"
    Then "bank_open" should be 0 for chip-select CS and bank B

  @open_bank
  Formal Scenario: All banks closed after bank_clr_all
    Given "rst_i" is deasserted
    And "bank_clr_all" is 1
    When one clock edge occurs on "clk_i"
    Then "any_bank_open" should be 0

  @open_bank
  Formal Scenario: Row hit indicated when accessed row matches open row
    Given "rst_i" is deasserted
    And a bank is open for chip-select CS with row R
    And "row_adr" equals R for chip-select CS
    When one clock edge occurs on "clk_i"
    Then "row_same" should be 1

  @open_bank
  Formal Scenario: Row miss indicated when accessed row differs from open row
    Given "rst_i" is deasserted
    And a bank is open for chip-select CS with row R
    And "row_adr" is any value not equal to R for chip-select CS
    When one clock edge occurs on "clk_i"
    Then "row_same" should be 0

  # ---------------------------------------------------------------
  # mc_timing: Command Sequencing
  # ---------------------------------------------------------------

  @timing
  Formal Scenario: Init request selects special-request chip-select for CS drive
    Given "rst_i" is deasserted
    And "init_req" is 1
    And "spec_req_cs" equals CS
    When one clock edge occurs on "clk_i"
    Then "cs" should equal CS
    And "cs_en" should be 1

  @timing
  Formal Scenario: LMR request selects special-request chip-select for CS drive
    Given "rst_i" is deasserted
    And "lmr_req" is 1
    And "spec_req_cs" equals CS
    When one clock edge occurs on "clk_i"
    Then "cs" should equal CS
    And "cs_en" should be 1

  @timing
  Formal Scenario: Refresh service selects SDRAM-eligible chip-selects
    Given "rst_i" is deasserted
    And "rfr_req" is 1
    And "cs_need_rfr" equals mask M
    When one clock edge occurs on "clk_i"
    Then "cs" should equal M
    And "cs_en" should be 1

  @timing
  Formal Scenario: Command outputs deasserted when no request is active
    Given "rst_i" is deasserted
    And "wb_read_go" is 0
    And "wb_write_go" is 0
    And "rfr_req" is 0
    And "init_req" is 0
    And "lmr_req" is 0
    When one clock edge occurs on "clk_i"
    Then "cs_en" should be 0

  # ---------------------------------------------------------------
  # Suspend / Resume
  # ---------------------------------------------------------------

  @suspend
  Formal Scenario: Suspended asserted within bounded latency after suspend request held
    Given "rst_i" is deasserted
    And "susp_req_i" is asserted continuously for "N_SUSP" clock edges on "clk_i"
    Then "suspended_o" should become 1 within "N_SUSP" clock edges of "clk_i" (bounded by ##[1:N_SUSP])

  @suspend
  Formal Scenario: Suspended not asserted while suspend request deasserted
    Given "rst_i" is deasserted
    And "susp_req_i" is 0
    When one clock edge occurs on "clk_i"
    Then "suspended_o" should be 0

  @suspend
  Formal Scenario: SDRAM enters self-refresh before suspended indication
    Given "rst_i" is deasserted
    And "susp_req_i" is asserted continuously
    And "suspended_o" is 0
    When "suspended_o" transitions to 1 within "N_SUSP" clock edges on "clk_i"
    Then "self_refresh_active" should have been 1 for all managed SDRAM chip-selects at least one clock edge before "suspended_o" transitioned to 1

  @suspend
  Formal Scenario: Resume deasserts suspended within bounded latency after resume request
    Given "rst_i" is deasserted
    And "suspended_o" is 1
    And "resume_req_i" is asserted continuously for "N_RESUME" clock edges on "clk_i"
    Then "suspended_o" should become 0 within "N_RESUME" clock edges of "clk_i" (bounded by ##[1:N_RESUME])

  @suspend
  Formal Scenario: Resume request ignored before suspended is reached
    Given "rst_i" is deasserted
    And "suspended_o" is 0
    And "resume_req_i" is asserted
    When one clock edge occurs on "clk_i"
    Then "suspended_o" should remain 0

  @suspend
  Formal Scenario: Suspended state persists after suspend request deasserts until resume is requested
    Given "rst_i" is deasserted
    And "suspended_o" is 1
    And "susp_req_i" transitions from 1 to 0
    And "resume_req_i" is 0
    When one clock edge occurs on "clk_i"
    Then "suspended_o" should remain 1

  @suspend
  Formal Scenario: SSRAM snooze output asserted during suspend
    Given "rst_i" is deasserted
    And "suspended_o" is 1
    And a chip-select is configured as SSRAM
    When one clock edge occurs on "mc_clk_i"
    Then "mc_zz_pad_o" should be 1

  # ---------------------------------------------------------------
  # External Bus Master Interface
  # ---------------------------------------------------------------

  @ext_master
  Formal Scenario: Bus grant asserted within bounded latency after bus request
    Given "rst_i" is deasserted
    And "mc_br_pad_i" is asserted continuously for "N_GRANT" clock edges on "mc_clk_i"
    And no refresh servicing conflict is pending
    Then "mc_bg_pad_o" should become 1 within "N_GRANT" clock edges of "mc_clk_i" (bounded by ##[1:N_GRANT])

  @ext_master
  Formal Scenario: Bus grant withheld while a refresh servicing conflict is pending
    Given "rst_i" is deasserted
    And "mc_br_pad_i" is asserted
    And "rfr_req" is 1 and refresh servicing has not yet completed
    When one clock edge occurs on "mc_clk_i"
    Then "mc_bg_pad_o" should be 0

  @ext_master
  Formal Scenario: Bus grant deasserted when request deasserted
    Given "rst_i" is deasserted
    And "mc_br_pad_i" is 0
    When one clock edge occurs on "mc_clk_i"
    Then "mc_bg_pad_o" should be 0

  @ext_master
  Formal Scenario: Grant held while request held
    Given "rst_i" is deasserted
    And "mc_bg_pad_o" is 1
    And "mc_br_pad_i" remains asserted
    When one clock edge occurs on "mc_clk_i"
    Then "mc_bg_pad_o" should remain 1

  # ---------------------------------------------------------------
  # Power-On Configuration
  # ---------------------------------------------------------------

  @poc
  Formal Scenario: POC captures memory data input during reset assertion
    Given "rst_i" is asserted
    And "mc_data_pad_i" holds value V
    When one clock edge occurs on "mc_clk_i" while "rst_i" is asserted
    Then "poc_o" should equal V

  @poc
  Formal Scenario: POC value stable after reset deassertion
    Given "rst_i" transitions from 1 to 0
    And "poc_o" held value V immediately before deassertion
    When one clock edge occurs on "clk_i"
    Then "poc_o" should equal V

  # ---------------------------------------------------------------
  # Memory-Side I/O Registering
  # ---------------------------------------------------------------

  @mem_if
  Formal Scenario: Memory address registered to mc_clk_i
    Given "rst_i" is deasserted
    And the address-select block produces address A
    When one clock edge occurs on "mc_clk_i"
    Then "mc_addr_pad_o" should equal A

  @mem_if
  Formal Scenario: Data mask reflects host byte-select
    Given "rst_i" is deasserted
    And "wb_sel_i" is any value S
    And a qualified write transaction is active
    When one clock edge occurs on "mc_clk_i"
    Then "mc_dqm_pad_o" should equal ~S (bitwise complement of S)

  @mem_if
  Formal Scenario: Chip-select outputs active-low reflect decoded region
    Given "rst_i" is deasserted
    And "cs_en" is 1
    And the active chip-select index is CS
    When one clock edge occurs on "mc_clk_i"
    Then "mc_cs_pad_o_" bit CS should be 0
    And all other bits of "mc_cs_pad_o_" should be 1