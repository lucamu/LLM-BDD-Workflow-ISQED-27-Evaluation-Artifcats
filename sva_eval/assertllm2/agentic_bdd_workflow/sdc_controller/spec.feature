Feature: SDC Controller Wishbone Interface and Register Control Logic

  As a hardware verification engineer
  I want to formally verify the sdc_controller module
  So that reset behavior, Wishbone protocol, master mux control,
  register updates, and interrupt generation are provably correct

  Background:
    Given the design is synchronous to "wb_clk_i"
    And the asynchronous reset signal is "wb_rst_i"
    And the software reset bit is "software_reset_reg[0]"
    And all state is initialized only via reset or software reset

  # ---------------------------------------------------------------
  # RESET BEHAVIOR
  # ---------------------------------------------------------------

  @reset @formal
  Formal Scenario: Wishbone reset forces all outputs to idle state
    Given "wb_rst_i" is asserted
    When one clock edge occurs on "wb_clk_i"
    Then "wb_ack_o" should be 0
    And "m_wb_cyc_o" should be 0
    And "m_wb_stb_o" should be 0
    And "m_wb_we_o" should be 0
    And "m_wb_adr_o" should be 0
    And "int_a" should be 0
    And "int_b" should be 0
    And "int_c" should be 0

  @reset @formal
  Formal Scenario: Software reset bit produces same sub-module reset assertions as wb_rst_i
    Given "wb_rst_i" is deasserted
    And "software_reset_reg[0]" is set to 1
    When one clock edge occurs on "wb_clk_i"
    Then the "rst" input driven to "sd_data_master" should equal the value it would hold when "wb_rst_i" is asserted
    And the "RST_PAD_I" input driven to "sd_cmd_master" should equal the value it would hold when "wb_rst_i" is asserted
    And the "rst" input driven to "tx_bd" should equal the value it would hold when "wb_rst_i" is asserted
    And the "rst" input driven to "rx_bd" should equal the value it would hold when "wb_rst_i" is asserted
    And the "RST_IN" input driven to "sd_cmd_serial_host" should equal the value it would hold when "wb_rst_i" is asserted
    And the "rst" input driven to "sd_data_serial_host" should equal the value it would hold when "wb_rst_i" is asserted

  @reset @formal
  Formal Scenario: go_idle_o from sd_cmd_master forces reset input of sd_cmd_serial_host
    Given "go_idle_o" is asserted by "sd_cmd_master"
    And "wb_rst_i" is deasserted
    And "software_reset_reg[0]" is 0
    When one clock edge occurs on "wb_clk_i"
    Then the "RST_IN" input of "sd_cmd_serial_host" should equal "go_idle_o"

  # ---------------------------------------------------------------
  # CORE SETUP SEQUENCE
  # ---------------------------------------------------------------

  @setup_sequence @formal
  Formal Scenario: Core setup sequence completes in required order before normal operation
    Given "wb_rst_i" is asserted and then deasserted
    And "time_out_reg" is written with symbolic value T after reset deassertion
    And "software_reset_reg[0]" is subsequently written with value 1
    When one clock edge occurs on "wb_clk_i" after each step
    Then the core should accept the timeout write only after reset deassertion
    And "time_out_reg" should equal T after the software reset assertion completes
    And "new_cmd" should remain 0 until "software_reset_reg[0]" returns to 0 after this sequence

  @setup_sequence @formal
  Formal Scenario: Software reset issued before timeout register is set does not preserve an undefined timeout value
    Given "wb_rst_i" is deasserted
    And "software_reset_reg[0]" is asserted before "time_out_reg" is ever written
    When one clock edge occurs on "wb_clk_i"
    Then "time_out_reg" should hold its reset default value
    And no command transmission should be initiated until "time_out_reg" is explicitly written

  # ---------------------------------------------------------------
  # WISHBONE SLAVE PROTOCOL
  # ---------------------------------------------------------------

  @wishbone_slave @formal
  Formal Scenario: Slave acknowledge only asserted during valid cycle and strobe
    Given "wb_cyc_i" holds value C
    And "wb_stb_i" holds value S
    When one clock edge occurs on "wb_clk_i"
    Then "wb_ack_o" should be 1 only if C is 1 and S is 1

  @wishbone_slave @formal
  Formal Scenario: Slave write data path forwards data to correct register on write
    Given "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "wb_we_i" is 1
    And "wb_adr_i" holds address A
    And "wb_dat_i" holds data D
    And "wb_sel_i" holds byte select value SEL
    When one clock edge occurs on "wb_clk_i"
    Then the register selected by address A should be updated using data D masked by SEL

  @wishbone_slave @formal
  Formal Scenario: Slave read data path returns register value without side effects on read
    Given "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "wb_we_i" is 0
    And "wb_adr_i" holds address A
    When one clock edge occurs on "wb_clk_i"
    Then "wb_dat_o" should equal the current value of the register selected by address A
    And no register written through the slave interface should change value

  # ---------------------------------------------------------------
  # TIMEOUT REGISTER
  # ---------------------------------------------------------------

  @timeout_register @formal
  Formal Scenario: time_out_reg is writable through the slave interface and readable back unchanged
    Given "wb_cyc_i" is 1
    And "wb_stb_i" is 1
    And "wb_we_i" is 1
    And "wb_adr_i" targets the timeout register
    And "wb_dat_i" holds value T
    When one clock edge occurs on "wb_clk_i"
    And a subsequent read cycle targets the timeout register with "wb_we_i" 0
    Then "wb_dat_o" should equal T

  @timeout_register @formal
  Formal Scenario: time_out_reg value is forwarded to sd_cmd_master as TIMEOUT_REG
    Given "time_out_reg" holds value T
    When one clock edge occurs on "wb_clk_i"
    Then "TIMEOUT_REG" input of "sd_cmd_master" should equal T

  @timeout_register @formal
  Formal Scenario: sd_cmd_master signals a timeout error when response exceeds time_out_reg duration
    Given "time_out_reg" holds value T
    And a command is issued and no response is received within T clock cycles measured against "TIMEOUT_REG"
    When the timeout duration T elapses without a valid response
    Then "ERR_INT_REG" should indicate a timeout error condition
    And "error_int_status_reg" should reflect this timeout error on the next update

  # ---------------------------------------------------------------
  # CARD DETECT
  # ---------------------------------------------------------------

  @card_detect @formal
  Formal Scenario: card_detect deasserted prevents sd_cmd_master from issuing new commands
    Given "card_detect" is 0
    And "new_cmd" is requested by the host via slave write
    When one clock edge occurs on "wb_clk_i"
    Then "sd_cmd_master" should not transition out of idle state
    And "cmd_out" should not be driven with a new command

  @card_detect @formal
  Formal Scenario: card_detect asserted allows sd_cmd_master to process a pending command
    Given "card_detect" is 1
    And "new_cmd" is asserted with valid "cmd_setting_reg" and "argument_reg"
    When one clock edge occurs on "wb_clk_i"
    Then "sd_cmd_master" should transition out of idle state
    And "cmd_out" should be driven with the composed 40 bit command message

  @card_detect @formal
  Formal Scenario: card_detect transition to deasserted while a command is in progress forces command abort
    Given "sd_cmd_master" is in an active, non-idle command state
    And "card_detect" transitions from 1 to 0
    When one clock edge occurs on "wb_clk_i"
    Then "sd_cmd_master" should return to idle state
    And "go_idle_o" should be asserted

  # ---------------------------------------------------------------
  # MASTER WISHBONE MUX CONTROL (Tx/Rx arbitration)
  # ---------------------------------------------------------------

  @master_mux @formal
  Formal Scenario: Master interface connects to Tx FIFO filler when start_tx_fifo is asserted
    Given "start_tx_fifo" is 1
    And "start_rx_fifo" is 0
    And the "sd_fifo_tx_filler" sub-module drives address TX_ADR, write enable TX_WE, cycle TX_CYC, strobe TX_STB, cti TX_CTI, bte TX_BTE
    When one clock edge occurs on "wb_clk_i"
    Then "m_wb_adr_o" should equal TX_ADR
    And "m_wb_we_o" should equal TX_WE
    And "m_wb_cyc_o" should equal TX_CYC
    And "m_wb_stb_o" should equal TX_STB
    And "m_wb_cti_o" should equal TX_CTI
    And "m_wb_bte_o" should equal TX_BTE

  @master_mux @formal
  Formal Scenario: Master interface connects to Rx FIFO filler when start_rx_fifo is asserted and start_tx_fifo is not
    Given "start_tx_fifo" is 0
    And "start_rx_fifo" is 1
    And the "sd_fifo_rx_filler" sub-module drives address RX_ADR, write enable RX_WE, cycle RX_CYC, strobe RX_STB, cti RX_CTI, bte RX_BTE
    When one clock edge occurs on "wb_clk_i"
    Then "m_wb_adr_o" should equal RX_ADR
    And "m_wb_we_o" should equal RX_WE
    And "m_wb_cyc_o" should equal RX_CYC
    And "m_wb_stb_o" should equal RX_STB
    And "m_wb_cti_o" should equal RX_CTI
    And "m_wb_bte_o" should equal RX_BTE

  @master_mux @formal
  Formal Scenario: Master interface defaults to zero when neither Tx nor Rx transfer is active
    Given "start_tx_fifo" is 0
    And "start_rx_fifo" is 0
    When one clock edge occurs on "wb_clk_i"
    Then "m_wb_adr_o" should be 0
    And "m_wb_we_o" should be 0
    And "m_wb_cyc_o" should be 0
    And "m_wb_stb_o" should be 0
    And "m_wb_cti_o" should be 0
    And "m_wb_bte_o" should be 0

  @master_mux @formal
  Formal Scenario: start_tx_fifo takes priority over start_rx_fifo when both asserted
    Given "start_tx_fifo" is 1
    And "start_rx_fifo" is 1
    And the "sd_fifo_tx_filler" sub-module drives address TX_ADR, write enable TX_WE, cycle TX_CYC, strobe TX_STB, cti TX_CTI, bte TX_BTE
    When one clock edge occurs on "wb_clk_i"
    Then "m_wb_adr_o" should equal TX_ADR
    And "m_wb_cyc_o" should equal TX_CYC

  @master_mux @formal
  Formal Scenario: Master byte select is always all bytes valid
    Given any valid state of the design
    When one clock edge occurs on "wb_clk_i"
    Then "m_wb_sel_o" should be 4'b1111

  # ---------------------------------------------------------------
  # STATUS / BD STATUS REGISTER COMPOSITION
  # ---------------------------------------------------------------

  @register_update @formal
  Formal Scenario: Bd_status_reg composition from free_rx_bd and free_tx_bd
    Given "free_rx_bd" holds value RX_FREE
    And "free_tx_bd" holds value TX_FREE
    When one clock edge occurs on "wb_clk_i"
    Then "Bd_status_reg[15:8]" should equal RX_FREE
    And "Bd_status_reg[7:0]" should equal TX_FREE

  @register_update @formal
  Formal Scenario: status_reg bit 0 reflects cmd_int_busy or retains previous value
    Given "cmd_int_busy" holds value BUSY
    And "status_reg[0]" currently holds value PREV0
    When one clock edge occurs on "wb_clk_i"
    Then "status_reg[0]" should be 1 if BUSY is 1
    And "status_reg[0]" should equal PREV0 if BUSY is 0

  @register_update @formal
  Formal Scenario: status_reg bit 1 reflects cidat_w
    Given "cidat_w" holds value CIDAT
    When one clock edge occurs on "wb_clk_i"
    Then "status_reg[1]" should equal CIDAT

  @register_update @formal
  Formal Scenario: status_reg upper bits [15:1] hold previous value except bit 1
    Given "status_reg[15:1]" currently holds value PREVU
    And "cidat_w" holds value CIDAT
    When one clock edge occurs on "wb_clk_i"
    Then "status_reg[15:2]" should equal PREVU[14:1]

  @register_update @formal
  Formal Scenario: normal_int_status_reg mirrors NORMAL_INT_REG from sd_cmd_master
    Given "sd_cmd_master" drives "NORMAL_INT_REG" with value N
    When one clock edge occurs on "wb_clk_i"
    Then "normal_int_status_reg" should equal N

  @register_update @formal
  Formal Scenario: error_int_status_reg mirrors ERR_INT_REG from sd_cmd_master
    Given "sd_cmd_master" drives "ERR_INT_REG" with value E
    When one clock edge occurs on "wb_clk_i"
    Then "error_int_status_reg" should equal E

  @register_update @formal
  Formal Scenario: Bd_isr_reg mirrors Dat_Int_Status from sd_data_master
    Given "sd_data_master" drives "Dat_Int_Status" with value D
    When one clock edge occurs on "wb_clk_i"
    Then "Bd_isr_reg" should equal D

  @register_update @formal
  Formal Scenario: cmd_int_busy asserted immediately blocks further CMD bus grants
    Given "cmd_int_busy" transitions from 0 to 1 on this clock edge
    When one clock edge occurs on "wb_clk_i"
    Then "status_reg[0]" should be 1 on the same clock edge that "cmd_int_busy" becomes 1

  # ---------------------------------------------------------------
  # INTERRUPT GENERATION
  # ---------------------------------------------------------------

  @interrupts @formal
  Formal Scenario: int_a asserted when normal status and enable overlap
    Given "normal_int_status_reg" holds value STAT
    And "normal_int_signal_enable_reg" holds value EN
    When one clock edge occurs on "wb_clk_i"
    Then "int_a" should be 1 if the bitwise AND of STAT and EN is nonzero
    And "int_a" should be 0 if the bitwise AND of STAT and EN is zero

  @interrupts @formal
  Formal Scenario: int_b asserted when error status and enable overlap
    Given "error_int_status_reg" holds value STAT
    And "error_int_signal_enable_reg" holds value EN
    When one clock edge occurs on "wb_clk_i"
    Then "int_b" should be 1 if the bitwise AND of STAT and EN is nonzero
    And "int_b" should be 0 if the bitwise AND of STAT and EN is zero

  @interrupts @formal
  Formal Scenario: int_c asserted when Bd_isr status and enable overlap
    Given "Bd_isr_reg" holds value STAT
    And "Bd_isr_enable_reg" holds value EN
    When one clock edge occurs on "wb_clk_i"
    Then "int_c" should be 1 if the bitwise AND of STAT and EN is nonzero
    And "int_c" should be 0 if the bitwise AND of STAT and EN is zero

  @interrupts @formal
  Formal Scenario: normal_isr_reset clears normal_int_status_reg
    Given "normal_isr_reset" is 1
    When one clock edge occurs on "wb_clk_i"
    Then "normal_int_status_reg" should be 0 on the next clock edge

  @interrupts @formal
  Formal Scenario: error_isr_reset clears error_int_status_reg
    Given "error_isr_reset" is 1
    When one clock edge occurs on "wb_clk_i"
    Then "error_int_status_reg" should be 0 on the next clock edge

  @interrupts @formal
  Formal Scenario: bd_isr_reset clears Bd_isr_reg
    Given "bd_isr_reset" is 1
    When one clock edge occurs on "wb_clk_i"
    Then "Bd_isr_reg" should be 0 on the next clock edge

  # ---------------------------------------------------------------
  # CONDITIONAL INTERRUPT PORTS (SDC_IRQ_ENABLE)
  # ---------------------------------------------------------------

  @conditional_ports @formal
  Formal Scenario: Interrupt outputs equal their overlap logic when SDC_IRQ_ENABLE is defined
    Given the parameter "SDC_IRQ_ENABLE" is defined
    And "normal_int_status_reg" holds value NSTAT
    And "normal_int_signal_enable_reg" holds value NEN
    And "error_int_status_reg" holds value ESTAT
    And "error_int_signal_enable_reg" holds value EEN
    And "Bd_isr_reg" holds value BSTAT
    And "Bd_isr_enable_reg" holds value BEN
    When one clock edge occurs on "wb_clk_i"
    Then "int_a" should equal the bitwise AND-reduction of NSTAT and NEN being nonzero
    And "int_b" should equal the bitwise AND-reduction of ESTAT and EEN being nonzero
    And "int_c" should equal the bitwise AND-reduction of BSTAT and BEN being nonzero

  # ---------------------------------------------------------------
  # COMMAND SEQUENCE / SUB-MODULE HANDSHAKE
  # ---------------------------------------------------------------

  @command_path @formal
  Formal Scenario: Writing argument_reg with pending cmd_setting_reg triggers new_cmd
    Given "cmd_setting_reg" has been written with value CMDSET
    And "wb_adr_i" now targets the argument register with data ARG
    And "wb_we_i" is 1
    And "wb_cyc_i" is 1 and "wb_stb_i" is 1
    When one clock edge occurs on "wb_clk_i"
    Then "argument_reg" should equal ARG
    And "new_cmd" should be asserted on this transaction

  @command_path @formal
  Formal Scenario: write_req_s from data master is granted and reflected as cmd_int_busy
    Given "write_req_s" is 1
    And "cmd_busy" from CMD path is 0
    When one clock edge occurs on "wb_clk_i"
    Then "we_ack" should be asserted
    And "cmd_int_busy" should be 1 on the same edge that grant occurs

  @command_path @formal
  Formal Scenario: cmd_set_s and cmd_arg_s are forwarded to cmd_setting_reg and argument_reg on grant
    Given "write_req_s" is 1
    And "cmd_set_s" holds value SETV
    And "cmd_arg_s" holds value ARGV
    And access is granted this cycle
    When one clock edge occurs on "wb_clk_i"
    Then "cmd_setting_reg" should equal SETV
    And "argument_reg" should equal ARGV

  # ---------------------------------------------------------------
  # BUFFER DESCRIPTOR RAM
  # ---------------------------------------------------------------

  @buffer_descriptor @formal
  Formal Scenario: Free BD count decreases only on successful write and consumption
    Given "we_m_tx_bd" is 1
    And "free_tx_bd" currently holds value F
    And the Tx BD RAM is not full
    When one clock edge occurs on "wb_clk_i"
    Then "free_tx_bd" should equal F - 1 if a new descriptor is completed
    And "free_tx_bd" should equal F if only a partial (first-word) write occurred

  @buffer_descriptor @formal
  Formal Scenario: Free RX BD count decreases only on successful write and consumption
    Given "we_m_rx_bd" is 1
    And "free_rx_bd" currently holds value F
    And the Rx BD RAM is not full
    When one clock edge occurs on "wb_clk_i"
    Then "free_rx_bd" should equal F - 1 if a new descriptor is completed
    And "free_rx_bd" should equal F if only a partial (first-word) write occurred

  @buffer_descriptor @formal
  Formal Scenario: a_cmp acknowledgment increments free BD count after transfer completion
    Given "a_cmp" is asserted to "tx_bd"
    And "free_tx_bd" currently holds value F
    And F is less than the maximum BD count MAX
    When one clock edge occurs on "wb_clk_i"
    Then "free_tx_bd" should equal F + 1

  # ---------------------------------------------------------------
  # CLOCKING
  # ---------------------------------------------------------------

  @clocking @formal
  Formal Scenario: sd_clk_o equals wb_clk_i when SDC_CLK_BUS_CLK is defined
    Given the parameter "SDC_CLK_BUS_CLK" is defined
    When one clock edge occurs on "wb_clk_i"
    Then "sd_clk_o" should equal "wb_clk_i"

  @clocking @formal
  Formal Scenario: sd_clk_o_pad is an alias of sd_clk_o
    Given any valid state of the design
    When one clock edge occurs on "wb_clk_i"
    Then "sd_clk_o_pad" should equal "sd_clk_o"

  @clocking @formal
  Formal Scenario: sd_clock_divider toggles SD_CLK once every DIVIDER rising edges of CLK
    Given the parameter "SDC_CLK_DYNAMIC" is defined
    And "DIVIDER" holds a symbolic value DIV greater than 0
    And an internal counter COUNT increments by 1 on each rising edge of "CLK" and wraps to 0 upon reaching DIV
    When one clock edge occurs on "CLK"
    Then "SD_CLK" should toggle if and only if COUNT equals DIV minus 1 before wrap
    And the number of "CLK" rising edges between two consecutive toggles of "SD_CLK" should equal DIV

  @clocking @formal
  Formal Scenario: sd_clk_i equals sd_clk_i_pad when SDC_CLK_SEP is defined
    Given the parameter "SDC_CLK_SEP" is defined
    And "sd_clk_i_pad" carries a clock signal independent of "wb_clk_i"
    When one clock edge occurs on "sd_clk_i_pad"
    Then "sd_clk_i" should equal "sd_clk_i_pad"

  @clocking @formal
  Formal Scenario: sd_clk_i equals wb_clk_i when SDC_CLK_SEP is not defined
    Given the parameter "SDC_CLK_SEP" is not defined
    When one clock edge occurs on "wb_clk_i"
    Then "sd_clk_i" should equal "wb_clk_i"

  # ---------------------------------------------------------------
  # OUTPUT ENABLE / TRI-STATE CONTROL
  # ---------------------------------------------------------------

  @io_control @formal
  Formal Scenario: sd_cmd_oe_o reflects command host drive intent
    Given "sd_cmd_serial_host" internal state indicates the module is transmitting, denoted TX
    When one clock edge occurs on "wb_clk_i"
    Then "sd_cmd_oe_o" should equal TX

  @io_control @formal
  Formal Scenario: sd_dat_oe_o reflects data host drive intent
    Given "sd_data_serial_host" internal state indicates the module is transmitting, denoted DTX
    When one clock edge occurs on "wb_clk_i"
    Then "sd_dat_oe_o" should equal DTX