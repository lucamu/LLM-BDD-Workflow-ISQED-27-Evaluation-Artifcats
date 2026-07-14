Feature: async_fifo_dw_simplex_top - Dual-Clock Dual-Direction Asynchronous FIFO

  As a hardware verification engineer
  I want to formally verify the async_fifo_dw_simplex_top module
  So that pointer generation, address mux, and full/empty flag logic are proven correct

  Background:
    Given the design is a synchronous module with two independent clock domains "a_clk" and "b_clk"
    And "a_rst" is a synchronous reset for side-A logic, evaluated on the rising edge of "a_clk"
    And "b_rst" is a synchronous reset for side-B logic, evaluated on the rising edge of "b_clk"
    And "a_rst" resets all side-A pointer generators and the comparator driving "a_fifo_full"/"b_fifo_empty"
    And "b_rst" resets all side-B pointer generators and the comparator driving "b_fifo_full"/"a_fifo_empty"
    And all registers update on the rising edge of their respective local clock
    And the parameter "addr_width" defines a per-direction depth of 2^addr_width entries
    And the parameter "data_width" defines the width of "a_d", "b_d", "a_q", "b_q"
    And "WCOUNT" and "RCOUNT" denote formal-only auxiliary (ghost) counters and are not RTL signals of the design
    And each ghost write counter increments by exactly 1 on a rising edge of its associated clock domain when the corresponding write request is accepted (e.g. "a_wr" or "b_wr")
    And each ghost read counter increments by exactly 1 on a rising edge of its associated clock domain when the corresponding read request is accepted (e.g. "a_rd" or "b_rd")
    And ghost counters are used exclusively for specification/verification purposes and do not correspond to any physical counter in the RTL

  # ---------------------------------------------------------------------
  # Reset Behavior
  # ---------------------------------------------------------------------

  @reset @pointer
  Formal Scenario: Side-A pointers reset to zero
    Given "a_rst" is asserted
    When a rising edge of "a_clk" occurs
    Then the side-A write binary pointer should equal 0
    And the side-A write Gray pointer should equal 0
    And the side-A read binary pointer should equal 0
    And the side-A read Gray pointer should equal 0

  @reset @pointer
  Formal Scenario: Side-B pointers reset to zero
    Given "b_rst" is asserted
    When a rising edge of "b_clk" occurs
    Then the side-B write binary pointer should equal 0
    And the side-B write Gray pointer should equal 0
    And the side-B read binary pointer should equal 0
    And the side-B read Gray pointer should equal 0

  @reset @flags
  Formal Scenario: A-to-B direction flags reflect empty state after reset
    Given "a_rst" is asserted
    And "b_rst" is asserted
    When a rising edge of "a_clk" occurs
    And a rising edge of "b_clk" occurs
    Then "b_fifo_empty" should equal 1
    And "a_fifo_full" should equal 0

  @reset @flags
  Formal Scenario: B-to-A direction flags reflect empty state after reset
    Given "a_rst" is asserted
    And "b_rst" is asserted
    When a rising edge of "a_clk" occurs
    And a rising edge of "b_clk" occurs
    Then "a_fifo_empty" should equal 1
    And "b_fifo_full" should equal 0

  # ---------------------------------------------------------------------
  # Pointer Generation
  # ---------------------------------------------------------------------

  @pointer
  Formal Scenario: Side-A write pointer increments on write request
    Given "a_rst" is deasserted
    And the side-A write binary pointer holds value P_w
    And "a_wr" is asserted
    When a rising edge of "a_clk" occurs
    Then the side-A write binary pointer should equal P_w + 1
    And the side-A write Gray pointer should equal the Gray encoding of P_w + 1

  @pointer
  Formal Scenario: Side-A write pointer holds when no write request
    Given "a_rst" is deasserted
    And the side-A write binary pointer holds value P_w
    And "a_wr" is deasserted
    When a rising edge of "a_clk" occurs
    Then the side-A write binary pointer should equal P_w

  @pointer
  Formal Scenario: Side-A read pointer increments on read request
    Given "a_rst" is deasserted
    And the side-A read binary pointer holds value P_r
    And "a_rd" is asserted
    When a rising edge of "a_clk" occurs
    Then the side-A read binary pointer should equal P_r + 1
    And the side-A read Gray pointer should equal the Gray encoding of P_r + 1

  @pointer
  Formal Scenario: Side-A read pointer holds when no read request
    Given "a_rst" is deasserted
    And the side-A read binary pointer holds value P_r
    And "a_rd" is deasserted
    When a rising edge of "a_clk" occurs
    Then the side-A read binary pointer should equal P_r

  @pointer
  Formal Scenario: Side-B write pointer increments on write request
    Given "b_rst" is deasserted
    And the side-B write binary pointer holds value Q_w
    And "b_wr" is asserted
    When a rising edge of "b_clk" occurs
    Then the side-B write binary pointer should equal Q_w + 1
    And the side-B write Gray pointer should equal the Gray encoding of Q_w + 1

  @pointer
  Formal Scenario: Side-B read pointer increments on read request
    Given "b_rst" is deasserted
    And the side-B read binary pointer holds value Q_r
    And "b_rd" is asserted
    When a rising edge of "b_clk" occurs
    Then the side-B read binary pointer should equal Q_r + 1
    And the side-B read Gray pointer should equal the Gray encoding of Q_r + 1

  @pointer @independence
  Formal Scenario: Side-A pointers are unaffected by side-B write/read requests
    Given "a_rst" is deasserted
    And the side-A write binary pointer holds value P_w
    And the side-A read binary pointer holds value P_r
    And "b_wr" and "b_rd" take any values
    When a rising edge of "a_clk" occurs with "a_wr" and "a_rd" deasserted
    Then the side-A write binary pointer should equal P_w
    And the side-A read binary pointer should equal P_r

  # ---------------------------------------------------------------------
  # Address Mux / Memory Mapping
  # ---------------------------------------------------------------------

  @addressing
  Formal Scenario: Side-A RAM address selects write pointer when writing
    Given "a_wr" is asserted
    And the side-A write binary pointer equals value P_w
    And the side-A read binary pointer equals value P_r
    Then "a_dpram_adr" should equal the concatenation of bit 0 and P_w

  @addressing
  Formal Scenario: Side-A RAM address selects read pointer when not writing
    Given "a_wr" is deasserted
    And the side-A write binary pointer equals value P_w
    And the side-A read binary pointer equals value P_r
    Then "a_dpram_adr" should equal the concatenation of bit 1 and P_r

  @addressing
  Formal Scenario: Side-B RAM address selects write pointer when writing
    Given "b_wr" is asserted
    And the side-B write binary pointer equals value Q_w
    And the side-B read binary pointer equals value Q_r
    Then "b_dpram_adr" should equal the concatenation of bit 1 and Q_w

  @addressing
  Formal Scenario: Side-B RAM address selects read pointer when not writing
    Given "b_wr" is deasserted
    And the side-B write binary pointer equals value Q_w
    And the side-B read binary pointer equals value Q_r
    Then "b_dpram_adr" should equal the concatenation of bit 0 and Q_r

  @addressing @priority
  Formal Scenario: Write address has priority over read address on the same side when both requests occur
    Given "a_wr" is asserted
    And "a_rd" is asserted
    And the side-A write binary pointer equals value P_w
    Then "a_dpram_adr" should equal the concatenation of bit 0 and P_w

  # ---------------------------------------------------------------------
  # RAM Write Enable Coupling
  # ---------------------------------------------------------------------

  @datapath
  Formal Scenario: Port-A RAM write enable follows a_wr directly
    Given "a_wr" holds value W
    Then "we_a" should equal W

  @datapath
  Formal Scenario: Port-B RAM write enable follows b_wr directly
    Given "b_wr" holds value W
    Then "we_b" should equal W

  # ---------------------------------------------------------------------
  # Data Path: Synchronous RAM Output
  # ---------------------------------------------------------------------

  @datapath
  Formal Scenario: Side-A RAM output reflects addressed memory contents one cycle later
    Given the side-A RAM address in the previous cycle equaled address X
    And RAM location X held value M
    When a rising edge of "a_clk" occurs
    Then "a_q" should equal M

  @datapath
  Formal Scenario: Side-B RAM output reflects addressed memory contents one cycle later
    Given the side-B RAM address in the previous cycle equaled address Y
    And RAM location Y held value M
    When a rising edge of "b_clk" occurs
    Then "b_q" should equal M

  @datapath
  Formal Scenario: Write data is stored at the write-selected RAM address
    Given "a_wr" is asserted
    And "a_d" holds value D
    And "a_dpram_adr" equals address X
    When a rising edge of "a_clk" occurs
    Then RAM location X should hold value D

  # ---------------------------------------------------------------------
  # Full / Empty Flag Correctness (Functional Definition)
  # ---------------------------------------------------------------------

  @flags @crossdomain
  Formal Scenario: b_fifo_empty asserted when A-to-B write and read counts are equal
    Given the ghost counter "WCOUNT" tracks the cumulative count of accepted "a_wr" pulses
    And the ghost counter "RCOUNT" tracks the cumulative count of accepted "b_rd" pulses
    And WCOUNT equals RCOUNT
    Then "b_fifo_empty" should equal 1

  @flags @crossdomain
  Formal Scenario: b_fifo_empty deasserted when A-to-B write count exceeds read count
    Given the ghost counter "WCOUNT" tracks the cumulative count of accepted "a_wr" pulses
    And the ghost counter "RCOUNT" tracks the cumulative count of accepted "b_rd" pulses
    And WCOUNT is greater than RCOUNT
    Then "b_fifo_empty" should equal 0

  @flags @crossdomain
  Formal Scenario: a_fifo_full asserted when A-to-B direction reaches full depth
    Given the ghost counter "WCOUNT" tracks the cumulative count of accepted "a_wr" pulses
    And the ghost counter "RCOUNT" tracks the cumulative count of accepted "b_rd" pulses
    And WCOUNT minus RCOUNT equals 2^addr_width
    Then "a_fifo_full" should equal 1

  @flags @crossdomain
  Formal Scenario: a_fifo_full deasserted when A-to-B occupancy is below full depth
    Given the ghost counter "WCOUNT" tracks the cumulative count of accepted "a_wr" pulses
    And the ghost counter "RCOUNT" tracks the cumulative count of accepted "b_rd" pulses
    And WCOUNT minus RCOUNT is less than 2^addr_width
    Then "a_fifo_full" should equal 0

  @flags @crossdomain
  Formal Scenario: a_fifo_empty asserted when B-to-A write and read counts are equal
    Given the ghost counter "WCOUNT" tracks the cumulative count of accepted "b_wr" pulses
    And the ghost counter "RCOUNT" tracks the cumulative count of accepted "a_rd" pulses
    And WCOUNT equals RCOUNT
    Then "a_fifo_empty" should equal 1

  @flags @crossdomain
  Formal Scenario: b_fifo_full asserted when B-to-A direction reaches full depth
    Given the ghost counter "WCOUNT" tracks the cumulative count of accepted "b_wr" pulses
    And the ghost counter "RCOUNT" tracks the cumulative count of accepted "a_rd" pulses
    And WCOUNT minus RCOUNT equals 2^addr_width
    Then "b_fifo_full" should equal 1

  @flags @crossdomain
  Formal Scenario: b_fifo_full deasserted when B-to-A occupancy is below full depth
    Given the ghost counter "WCOUNT" tracks the cumulative count of accepted "b_wr" pulses
    And the ghost counter "RCOUNT" tracks the cumulative count of accepted "a_rd" pulses
    And WCOUNT minus RCOUNT is less than 2^addr_width
    Then "b_fifo_full" should equal 0

  # ---------------------------------------------------------------------
  # Structural / Non-Overflow Safety
  # ---------------------------------------------------------------------

  @safety
  Formal Scenario: A-to-B occupancy never exceeds direction depth
    Given the ghost counter "WCOUNT" tracks the cumulative count of accepted "a_wr" pulses
    And the ghost counter "RCOUNT" tracks the cumulative count of accepted "b_rd" pulses
    Then WCOUNT minus RCOUNT should never exceed 2^addr_width

  @safety
  Formal Scenario: B-to-A occupancy never exceeds direction depth
    Given the ghost counter "WCOUNT" tracks the cumulative count of accepted "b_wr" pulses
    And the ghost counter "RCOUNT" tracks the cumulative count of accepted "a_rd" pulses
    Then WCOUNT minus RCOUNT should never exceed 2^addr_width

  @safety
  Formal Scenario: Address regions never overlap between directions
    Given "a_dpram_adr" equals address X
    And "b_dpram_adr" equals address Y
    Then the most significant bit of X should equal 0 when "a_wr" is asserted
    And the most significant bit of X should equal 1 when "a_wr" is deasserted
    And the most significant bit of Y should equal 1 when "b_wr" is asserted
    And the most significant bit of Y should equal 0 when "b_wr" is deasserted