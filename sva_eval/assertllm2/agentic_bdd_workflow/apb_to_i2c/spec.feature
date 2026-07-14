Feature: APB-Connected I2C Controller Wrapper

  Formal verification of the APB-to-I2C bridge, covering APB transfer
  handshaking, TX/RX FIFO datapath behavior, configuration/timeout
  register programming, status/interrupt/error propagation, RX data
  assembly, SDA/SCL drive-control enable behavior, and reset
  sequencing.

  Background:
    Given the design is synchronous to rising edges of "PCLK"
    And "PRESETn" is the active-low asynchronous/synchronous reset
    And when "PRESETn" is deasserted (0), all APB configuration and
      timeout registers, TX/RX FIFO pointers and counters, and I2C
      TX/RX control state are cleared
    And APB address "PADDR" selects one of the implemented locations
      0x0, 0x4, 0x8, 0xC for defined behavior
    And "PSELx", "PWRITE", "PENABLE" are valid APB control signals for
      the current cycle

  @reset
  Formal Scenario: Reset clears APB ready and error outputs
    Given "PRESETn" is asserted low
    When one rising edge of "PCLK" occurs
    Then "PREADY" should be 0
    And "PSLVERR" should be 0

  @reset
  Formal Scenario: Reset clears configuration and timeout registers
    Given "PRESETn" is asserted low
    When one rising edge of "PCLK" occurs
    Then "INTERNAL_I2C_REGISTER_CONFIG" should be 0
    And "INTERNAL_I2C_REGISTER_TIMEOUT" should be 0

  @reset
  Formal Scenario: Reset clears FIFO occupancy for TX and RX FIFOs
    Given "PRESETn" is asserted low
    When one rising edge of "PCLK" occurs
    Then TX FIFO "f_empty" should be 1
    And RX FIFO "f_empty" should be 1
    And TX FIFO "f_full" should be 0
    And RX FIFO "f_full" should be 0

  @apb @ready
  Formal Scenario: PREADY asserted for implemented address during active access
    Given "PRESETn" is deasserted (inactive reset, i.e. high)
    And "PADDR" is one of the implemented addresses 0x0, 0x4, 0x8, 0xC
    And "PSELx" is 1
    And "PENABLE" is 1
    When one rising edge of "PCLK" occurs with these inputs stable
    Then "PREADY" should be 1

  @apb @ready
  Formal Scenario: PREADY deasserted when peripheral not selected
    Given "PRESETn" is deasserted (inactive reset, i.e. high)
    And "PSELx" is 0
    When one rising edge of "PCLK" occurs with these inputs stable
    Then "PREADY" should be 0

  @apb @ready
  Formal Scenario: PREADY deasserted when enable phase inactive
    Given "PRESETn" is deasserted (inactive reset, i.e. high)
    And "PSELx" is 1
    And "PENABLE" is 0
    When one rising edge of "PCLK" occurs with these inputs stable
    Then "PREADY" should be 0

  @apb @tx-fifo-write
  Formal Scenario: TX FIFO write enable generated on address 0x0 write
    Given "PRESETn" is deasserted (inactive reset, i.e. high)
    And "PADDR" is 0x0
    And "PWRITE" is 1
    And "PSELx" is 1
    And "PENABLE" is 1
    And "PWDATA" holds value W
    When one rising edge of "PCLK" occurs with these inputs stable
    Then "WR_ENA" should be 1
    And "WRITE_DATA_ON_TX" should be W

  @apb @rx-fifo-read
  Formal Scenario: RX FIFO read enable generated on address 0x4 read
    Given "PRESETn" is deasserted (inactive reset, i.e. high)
    And "PADDR" is 0x4
    And "PWRITE" is 0
    And "PSELx" is 1
    And "PENABLE" is 1
    When one rising edge of "PCLK" occurs with these inputs stable
    Then "RD_ENA" should be 1
    And "PRDATA" should equal "READ_DATA_ON_RX"

  @apb @config-register
  Formal Scenario: Configuration register updated on address 0x8 write
    Given "PRESETn" is deasserted (inactive reset, i.e. high)
    And "PADDR" is 0x8
    And "PWRITE" is 1
    And "PSELx" is 1
    And "PENABLE" is 1
    And "PWDATA[13:0]" holds value C
    When one rising edge of "PCLK" occurs with these inputs stable
    Then "INTERNAL_I2C_REGISTER_CONFIG" should become C on the next clock edge

  @apb @timeout-register
  Formal Scenario: Timeout register updated on address 0xC write
    Given "PRESETn" is deasserted (inactive reset, i.e. high)
    And "PADDR" is 0xC
    And "PWRITE" is 1
    And "PSELx" is 1
    And "PENABLE" is 1
    And "PWDATA[13:0]" holds value T
    When one rising edge of "PCLK" occurs with these inputs stable
    Then "INTERNAL_I2C_REGISTER_TIMEOUT" should become T on the next clock edge

  @apb @no-write-when-unselected
  Formal Scenario: Configuration register not updated without valid select/enable
    Given "PRESETn" is deasserted (inactive reset, i.e. high)
    And "PADDR" is 0x8
    And "PWRITE" is 1
    And "PSELx" is 0
    And "INTERNAL_I2C_REGISTER_CONFIG" holds value R
    When one rising edge of "PCLK" occurs with these inputs stable
    Then "INTERNAL_I2C_REGISTER_CONFIG" should remain R

  @apb @no-write-when-unselected
  Formal Scenario: Timeout register not updated without enable phase
    Given "PRESETn" is deasserted (inactive reset, i.e. high)
    And "PADDR" is 0xC
    And "PWRITE" is 1
    And "PSELx" is 1
    And "PENABLE" is 0
    And "INTERNAL_I2C_REGISTER_TIMEOUT" holds value R
    When one rising edge of "PCLK" occurs with these inputs stable
    Then "INTERNAL_I2C_REGISTER_TIMEOUT" should remain R

  @status @error
  Formal Scenario: PSLVERR mirrors ERROR status combinationally
    Given "ERROR" holds value E
    When the combinational logic settles
    Then "PSLVERR" should be E

  @status @error @error-mode
  Formal Scenario: ERROR asserted in error configuration mode
    Given "DATA_CONFIG_REG[1:0]" is 2'b11
    When the combinational logic settles
    Then "ERROR" should be 1
    And "PSLVERR" should be 1

  @status @interrupt
  Formal Scenario: INT_TX mirrors TX_EMPTY status
    Given "TX_EMPTY" holds value X
    When the combinational logic settles
    Then "INT_TX" should be X

  @status @interrupt
  Formal Scenario: INT_RX mirrors RX_EMPTY status
    Given "RX_EMPTY" holds value X
    When the combinational logic settles
    Then "INT_RX" should be X

  @fifo @empty
  Formal Scenario: FIFO empty flag reflects zero occupancy
    Given a FIFO instance holds occupancy counter value 0
    When the combinational logic settles
    Then "f_empty" should be 1

  @fifo @full
  Formal Scenario: FIFO full flag reflects occupancy count of fifteen
    Given a FIFO instance holds occupancy counter value 15
    When the combinational logic settles
    Then "f_full" should be 1

  @fifo @counter-increment
  Formal Scenario: FIFO occupancy counter increments on write-only operation
    Given a FIFO instance holds occupancy counter value N
    And "wr_en" is 1
    And "rd_en" is 0
    And N is less than 15
    When one rising edge of "clock" occurs
    Then the FIFO occupancy counter should equal N + 1

  @fifo @counter-decrement
  Formal Scenario: FIFO occupancy counter decrements on read-only operation
    Given a FIFO instance holds occupancy counter value N
    And "wr_en" is 0
    And "rd_en" is 1
    And N is greater than 0
    When one rising edge of "clock" occurs
    Then the FIFO occupancy counter should equal N - 1

  @fifo @counter-stable
  Formal Scenario: FIFO occupancy counter unchanged on simultaneous or no operation
    Given a FIFO instance holds occupancy counter value N
    And "wr_en" equals "rd_en"
    When one rising edge of "clock" occurs
    Then the FIFO occupancy counter should equal N

  @fifo @data-out
  Formal Scenario: FIFO data_out reflects memory at current read pointer
    Given a FIFO instance holds read pointer value P
    And memory location P holds value D
    When the combinational logic settles
    Then "data_out" should equal D

  @fifo @reset
  Formal Scenario: FIFO active-high reset derived from PRESETn clears pointers
    Given "PRESETn" is deasserted low
    When the internal FIFO reset signal is evaluated
    Then the internal FIFO reset should be 1

  @i2c @mode-decode
  Formal Scenario: Transmit mode selected by configuration bits
    Given "DATA_CONFIG_REG[1:0]" is 2'b10
    When the combinational logic settles
    Then transmit operation should be enabled

  @i2c @mode-decode
  Formal Scenario: Receive mode selected by configuration bits
    Given "DATA_CONFIG_REG[1:0]" is 2'b01
    When the combinational logic settles
    Then receive operation should be enabled

  @i2c @mode-decode
  Formal Scenario: Idle mode selected by configuration bits
    Given "DATA_CONFIG_REG[1:0]" is 2'b00
    When the combinational logic settles
    Then no transfer start condition should be asserted

  @i2c @tx-guard
  Formal Scenario: TX start progression gated by timeout comparison
    Given "DATA_CONFIG_REG[1:0]" is 2'b10
    And TX FIFO "f_empty" is 0
    And internal timeout counter "count_timeout" holds value K
    And "TIMEOUT_TX" holds value M
    And K is less than M
    When one rising edge of "PCLK" occurs
    Then the TX state machine should be allowed to progress from IDLE

  @i2c @tx-guard
  Formal Scenario: TX start blocked when TX FIFO empty
    Given "DATA_CONFIG_REG[1:0]" is 2'b10
    And TX FIFO "f_empty" is 1
    When one rising edge of "PCLK" occurs
    Then the TX state machine should remain in IDLE

  @i2c @tx-fifo-advance
  Formal Scenario: TX FIFO read-enable asserted after final response phase
    Given the TX state machine is in the final response phase for the current byte group
    And acknowledge sampling has completed for that phase
    When one rising edge of "PCLK" occurs
    Then "fifo_tx_rd_en" should be 1

  @i2c @nack
  Formal Scenario: NACK sampled on SDA triggers retry path
    Given the TX state machine is in an acknowledge sampling response state
    And sampled "SDA" value is 1 representing NACK
    When one rising edge of "PCLK" occurs
    Then the TX state machine should transition to the NACK/retry phase

  @i2c @ack
  Formal Scenario: ACK sampled on SDA allows progression to next phase
    Given the TX state machine is in an acknowledge sampling response state
    And sampled "SDA" value is 0 representing ACK
    When one rising edge of "PCLK" occurs
    Then the TX state machine should progress to the next protocol phase

  @i2c @rx-assembly
  Formal Scenario: RX control byte bits assembled into fifo_rx_data_in control field
    Given "DATA_CONFIG_REG[1:0]" is 2'b01
    And the RX state machine is in a CONTROLIN_* phase
    And sampled "SDA" bit value is B
    When one rising edge of "PCLK" occurs
    Then the corresponding control field bit of "fifo_rx_data_in" should equal B

  @i2c @rx-assembly
  Formal Scenario: RX address byte bits assembled into fifo_rx_data_in address field
    Given "DATA_CONFIG_REG[1:0]" is 2'b01
    And the RX state machine is in an ADDRESS_* phase
    And sampled "SDA" bit value is B
    When one rising edge of "PCLK" occurs
    Then the corresponding address field bit of "fifo_rx_data_in" should equal B

  @i2c @rx-assembly
  Formal Scenario: RX first data byte bits assembled into fifo_rx_data_in data0 field
    Given "DATA_CONFIG_REG[1:0]" is 2'b01
    And the RX state machine is in a DATA0_* phase
    And sampled "SDA" bit value is B
    When one rising edge of "PCLK" occurs
    Then the corresponding data0 field bit of "fifo_rx_data_in" should equal B

  @i2c @rx-assembly
  Formal Scenario: RX second data byte bits assembled into fifo_rx_data_in data1 field
    Given "DATA_CONFIG_REG[1:0]" is 2'b01
    And the RX state machine is in a DATA1_* phase
    And sampled "SDA" bit value is B
    When one rising edge of "PCLK" occurs
    Then the corresponding data1 field bit of "fifo_rx_data_in" should equal B

  @i2c @rx-assembly @gating
  Formal Scenario: RX bit sampling gated by timing divisor comparison
    Given "DATA_CONFIG_REG[1:0]" is 2'b01
    And internal counter "count_receive_data" holds value K
    And "DATA_CONFIG_REG[13:2]" holds value M
    And K is less than M
    When one rising edge of "PCLK" occurs
    Then "fifo_rx_data_in" should remain unchanged for the current bit position

  @i2c @rx-assembly @gating
  Formal Scenario: RX bit sampling gated by SCL level check
    Given "DATA_CONFIG_REG[1:0]" is 2'b01
    And "SCL" is 0
    When one rising edge of "PCLK" occurs
    Then "fifo_rx_data_in" should remain unchanged for the current bit position

  @i2c @rx-fifo-write @needs-confirmation
  Formal Scenario: RX FIFO write enable not asserted during normal receive sequencing
    Given "DATA_CONFIG_REG[1:0]" is 2'b01
    And the RX state machine completes assembly of all byte-group fields into "fifo_rx_data_in"
    And no NACK or error condition is present
    When one rising edge of "PCLK" occurs
    Then "fifo_rx_wr_en" should be 0

  @i2c @enable-sda
  Formal Scenario: ENABLE_SDA asserted during SDA drive-control phase
    Given the I2C core is in a phase requiring SDA line drive control
    When the combinational logic settles
    Then "ENABLE_SDA" should be 1

  @i2c @enable-sda
  Formal Scenario: ENABLE_SDA deasserted outside SDA drive-control phase
    Given the I2C core is not in a phase requiring SDA line drive control
    When the combinational logic settles
    Then "ENABLE_SDA" should be 0

  @i2c @enable-scl
  Formal Scenario: ENABLE_SCL asserted during SCL drive-control phase
    Given the I2C core is in a phase requiring SCL line drive control
    When the combinational logic settles
    Then "ENABLE_SCL" should be 1

  @i2c @enable-scl
  Formal Scenario: ENABLE_SCL deasserted outside SCL drive-control phase
    Given the I2C core is not in a phase requiring SCL line drive control
    When the combinational logic settles
    Then "ENABLE_SCL" should be 0

  @i2c @enable-mode-select
  Formal Scenario: SDA/SCL enable outputs reflect TX mode drive path when transmit operation is active
    Given "DATA_CONFIG_REG[1:0]" is 2'b10
    And the TX state machine is in a phase requiring line drive control
    When the combinational logic settles
    Then "ENABLE_SDA" should reflect the TX drive-control path
    And "ENABLE_SCL" should reflect the TX drive-control path

  @i2c @enable-mode-select
  Formal Scenario: SDA/SCL enable outputs reflect RX mode drive path when receive operation is active
    Given "DATA_CONFIG_REG[1:0]" is 2'b01
    And the RX state machine is in a phase requiring line drive control
    When the combinational logic settles
    Then "ENABLE_SDA" should reflect the RX drive-control path
    And "ENABLE_SCL" should reflect the RX drive-control path

  @top @enable-passthrough
  Formal Scenario: Top-level SDA_ENABLE mirrors internal ENABLE_SDA
    Given "ENABLE_SDA" holds value E
    When the combinational logic settles
    Then "SDA_ENABLE" should equal E

  @top @enable-passthrough
  Formal Scenario: Top-level SCL_ENABLE mirrors internal ENABLE_SCL
    Given "ENABLE_SCL" holds value E
    When the combinational logic settles
    Then "SCL_ENABLE" should equal E

  @apb @readdata
  Formal Scenario: PRDATA sourced from RX data path independent of address when not reading
    Given "READ_DATA_ON_RX" holds value R
    When the combinational logic settles
    Then "PRDATA" should equal R

  @apb @combinational
  Formal Scenario: WR_ENA deasserted for non-write or non-selected access
    Given "PADDR" is 0x0
    And "PWRITE" is 0
    When the combinational logic settles
    Then "WR_ENA" should be 0

  @apb @combinational
  Formal Scenario: RD_ENA deasserted for non-read or wrong address access
    Given "PADDR" is 0x0
    And "PWRITE" is 0
    When the combinational logic settles
    Then "RD_ENA" should be 0