Feature: xgate_top XGATE Co-Processor Formal Verification

  Formal specification of externally observable behavior of xgate_top,
  covering WISHBONE slave register semantics, interrupt bypass/encoding,
  software trigger, semaphore, and software-error interrupt behavior.

  Background:
    Given the design is clocked on the rising edge of "wbs_clk_i" for the slave domain
    And the design is clocked on the rising edge of "risc_clk" for the RISC domain
    And "async_rst_b" is derived as "arst_i XOR ARST_LVL"
    And when "wbs_rst_i" is asserted or "async_rst_b" is deasserted (active reset), all registers are held in reset state
    And parameter "DWIDTH" is 16
    And parameter "MAX_CHANNEL" is 127
    And parameter "SINGLE_CYCLE" is 0 unless stated otherwise
    And parameter "ARST_LVL" is 1'b0 unless stated otherwise

  @reset @xgvbr
  Formal Scenario: XGVBR resets to documented default value
    Given the design is in reset
    When reset is deasserted
    Then register "XGVBR" should equal 16'hFE00

  @reset @irqbp
  Formal Scenario: IRQ_BP registers reset to all-bypassed
    Given the design is in reset
    When reset is deasserted
    Then register "IRQ_BP0" should equal 16'hFFFF
    And register "IRQ_BP1" should equal 16'hFFFF
    And register "IRQ_BP2" should equal 16'hFFFF
    And register "IRQ_BP3" should equal 16'hFFFF
    And register "IRQ_BP4" should equal 16'hFFFF
    And register "IRQ_BP5" should equal 16'hFFFF
    And register "IRQ_BP6" should equal 16'hFFFF
    And register "IRQ_BP7" should equal 16'hFFFF

  @reset @zeroed
  Formal Scenario: Zero-reset registers hold zero after reset
    Given the design is in reset
    When reset is deasserted
    Then register "XGSWT" should equal 0
    And register "XGSEM" should equal 0
    And register "XGCHID" should equal 0
    And register "XGCCR" should equal 0
    And register "XGPC" should equal 0
    And register "XGR1" should equal 0
    And register "XGR2" should equal 0
    And register "XGR3" should equal 0
    And register "XGR4" should equal 0
    And register "XGR5" should equal 0
    And register "XGR6" should equal 0
    And register "XGR7" should equal 0
    And all bits of "XGIF_0" through "XGIF_7" should equal 0

  @wbs @protocol
  Formal Scenario: WISHBONE slave acknowledge asserted only during valid cycle
    Given "wbs_cyc_i" is asserted and "wbs_stb_i" is asserted
    When a WISHBONE slave transaction completes per SINGLE_CYCLE configuration
    Then "wbs_ack_o" should be asserted only while "wbs_cyc_i" and "wbs_stb_i" are asserted
    And "wbs_ack_o" and "wbs_err_o" should never be asserted simultaneously

  @wbs @timing
  Formal Scenario: Default WISHBONE slave timing inserts wait-state acknowledge
    Given parameter "SINGLE_CYCLE" is 0
    And "wbs_cyc_i" is asserted and "wbs_stb_i" is asserted on cycle X
    When the internal wait-state sequence completes
    Then "wbs_ack_o" should be asserted on a later cycle consistent with the documented wait-state behavior
    And "wbs_ack_o" should not be asserted in the same cycle as the initiating strobe

  @wbs @timing
  Formal Scenario: Single-cycle WISHBONE slave timing acknowledges directly
    Given parameter "SINGLE_CYCLE" is 1
    And "wbs_cyc_i" is asserted and "wbs_stb_i" is asserted and the module is selected
    When the access is evaluated
    Then "wbs_ack_o" should be asserted in the same cycle as module selection

  @wbs @error
  Formal Scenario: WISHBONE slave error indicates deselection during outstanding access
    Given a WISHBONE slave access is outstanding in the wait-state sequence
    And "wbs_stb_i" or "wbs_cyc_i" deasserts before the transaction completes
    When the internal wait-state logic detects deselection
    Then "wbs_err_o" should be asserted
    And "wbs_ack_o" should not be asserted for that access

  @register @xgmctl
  Formal Scenario: XGMCTL update uses mask-and-data write semantics
    Given register "XGMCTL" holds value M
    And a full-word write to address 16'h00 is issued with write data W
    And the upper mask bits of W select which lower control bits update
    When the write is accepted on the next clock edge
    Then the updated lower control bits of "XGMCTL" should equal "(mask(W) & data(W)) | (~mask(W) & M)"

  @register @xgvbr
  Formal Scenario: XGVBR write blocked while XGATE enabled
    Given register "XGMCTL" bit "XGE" equals 1
    And a write to address 16'h08 is issued with write data V
    When the write is evaluated on the next clock edge
    Then register "XGVBR" should remain unchanged

  @register @xgvbr
  Formal Scenario: XGVBR write accepted while XGATE disabled
    Given register "XGMCTL" bit "XGE" equals 0
    And a write to address 16'h08 is issued with write data V
    When the write is accepted on the next clock edge
    Then register "XGVBR"[15:1] should equal V[15:1]

  @register @xgchid
  Formal Scenario: XGCHID write accepted only during debug-active state
    Given debug-active internal state equals D
    And a write to address 16'h02 is issued with write data C
    When the write is evaluated on the next clock edge
    Then register "XGCHID" should equal C if D equals 1
    And register "XGCHID" should remain unchanged if D equals 0

  @register @xgccr_xgpc_xgr
  Formal Scenario: XGCCR, XGPC, XGR1-XGR7 writes constrained by debug-active or core-disabled state
    Given the combined constraint "(debug_active OR core_disabled)" equals C
    And a write to one of addresses 16'h20, 16'h22, 16'h26 through 16'h32 is issued with write data V
    When the write is evaluated on the next clock edge
    Then the targeted register should equal V if C equals 1
    And the targeted register should remain unchanged if C equals 0

  @register @xgif @clear
  Formal Scenario: XGIF bank write-one-to-clear semantics
    Given interrupt flag bank register "XGIF_n" holds value F for some n in [0:7]
    And a write to the corresponding address is issued with write data W
    When the write is accepted on the next clock edge
    Then each bit of "XGIF_n" should clear where the corresponding bit of W equals 1
    And each bit of "XGIF_n" should remain unchanged where the corresponding bit of W equals 0

  @register @xgswt
  Formal Scenario: XGSWT mask-and-data update semantics
    Given register "XGSWT" holds value S
    And a full-word write to address 16'h1A is issued with write data W where upper byte is mask M and lower byte is data D
    When the write is accepted on the next clock edge
    Then register "XGSWT" should equal "(M & D) | (~M & S[7:0])" in its lower byte
    And "xgswt" output should reflect the updated lower byte per the documented polarity convention

  @register @xgsem
  Formal Scenario: XGSEM mask-and-data update semantics
    Given register "XGSEM" holds value E
    And a full-word write to address 16'h1C is issued with write data W where upper byte is mask M and lower byte is data D
    When the write is accepted on the next clock edge
    Then register "XGSEM" lower byte should equal "(M & D) | (~M & E[7:0])"

  @semaphore @arbitration
  Formal Scenario: Host lock request resolved ahead of RISC lock request from NO_LOCK
    Given semaphore state for a given bit equals "NO_LOCK"
    And a host lock request and a RISC lock request are asserted simultaneously in the same cycle
    When the semaphore state transitions on the next clock edge
    Then the semaphore should transition to host-owned lock state
    And the RISC lock request should not be granted in that cycle

  @irqbp @bypass
  Formal Scenario: Bypassed channel forwards request directly to xgif
  For any channel n in [1:MAX_CHANNEL]
    Given "chan_bypass[n]" equals 1
    And "chan_req_i[n]" equals R
    When the interrupt encode logic evaluates outputs
    Then "xgif[n]" should equal R

  @irqbp @bypass
  Formal Scenario: Non-bypassed channel reflects RISC-generated status on xgif
  For any channel n in [1:MAX_CHANNEL]
    Given "chan_bypass[n]" equals 0
    And RISC-generated "xgif_status[n]" equals S
    When the interrupt encode logic evaluates outputs
    Then "xgif[n]" should equal S
    And "xgif[n]" should not be directly driven by "chan_req_i[n]"

  @irqbp @priority
  Formal Scenario: Lowest-index non-bypassed active channel has highest encode priority
  For any two channels i and j in [1:MAX_CHANNEL] with i less than j
    Given "chan_bypass[i]" equals 0 and "chan_req_i[i]" equals 1
    And "chan_bypass[j]" equals 0 and "chan_req_i[j]" equals 1
    When the interrupt encode logic computes "int_req"
    Then "int_req" should select channel i and not channel j

  @irqbp @encode
  Formal Scenario: No active non-bypassed channel yields idle encode result
  For all channels n in [1:MAX_CHANNEL]
    Given for every channel n, either "chan_bypass[n]" equals 1 or "chan_req_i[n]" equals 0
    When the interrupt encode logic computes "int_req"
    Then "int_req" should indicate no active channel request

  @sw_error @xg_sw_irq
  Formal Scenario: Software error interrupt gated by interrupt-enable control
    Given a latched software-error condition equals 1
    And the interrupt-output-enable control bit equals EN
    When "xg_sw_irq" is evaluated
    Then "xg_sw_irq" should equal EN
    And "xg_sw_irq" should equal 0 when EN equals 0 regardless of the latched error condition

  @sw_error @clear
  Formal Scenario: Software error clear control deasserts xg_sw_irq
    Given a latched software-error condition equals 1
    And the interrupt-output-enable control bit equals 1
    And a software-error clear write is issued via "XGMCTL"
    When the clear is accepted on the next clock edge
    Then the latched software-error condition should deassert
    And "xg_sw_irq" should deassert on the following evaluation

  @wbm @handshake
  Formal Scenario: WISHBONE master transaction requires matching acknowledge
    Given the RISC core issues a memory access request with address A and access type T
    And "wbm_cyc_o" and "wbm_stb_o" are asserted with "wbm_adr_o" equal to A
    When "wbm_ack_i" is asserted on some later cycle
    Then "mem_req_ack" should assert in that cycle
    And "wbm_cyc_o" should deassert on the cycle following acknowledge

  @wbm @singlestep
  Formal Scenario: Single-step memory request completion signaled via ss_mem_ack
    Given a single-step memory request "ss_mem_req" is asserted
    And the corresponding WISHBONE master transaction completes with "wbm_ack_i" asserted
    When the request-acknowledge handshake resolves
    Then "ss_mem_ack" should assert in the completing cycle
    And "ss_mem_req" should deassert on the following cycle

  @readback @default
  Formal Scenario: Unmapped register read returns configured default value
    Given "wbs_adr_i" selects an address with no defined register mapping
    And parameter "WB_RD_DEFAULT" equals D
    When the read access is acknowledged
    Then "wbs_dat_o" should equal D

  @readback @mapped
  Formal Scenario: Mapped register read returns stored register value
    Given "wbs_adr_i" selects a defined register address holding value V
    And "wbs_we_i" is deasserted for a read access
    When the read access is acknowledged
    Then "wbs_dat_o" should equal V

  @reset @async
  Formal Scenario: Asynchronous reset immediately forces internal reset regardless of clock edge
    Given "arst_i" transitions to the active level defined by "ARST_LVL"
    When the transition occurs independent of any clock edge
    Then "async_rst_b" should deassert immediately
    And all reset-sensitive registers should assume their reset values without waiting for a clock edge

  @reset @sync
  Formal Scenario: Synchronous reset reinitializes registers only on clock edge
    Given "wbs_rst_i" is asserted
    When the next rising edge of "wbs_clk_i" occurs
    Then all synchronously-reset registers should assume their reset values at that edge
    And no register should change value due to "wbs_rst_i" before that edge