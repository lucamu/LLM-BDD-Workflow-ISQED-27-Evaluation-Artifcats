Feature: Dual-Port RAM with Independent Read and Write Ports

  As a hardware designer
  I want a dual-port RAM module with 8 locations of 4-bit width
  So that read and write operations can occur independently and simultaneously

  Background:
    Given a clock signal clk
    And an active-low asynchronous reset signal rst_n
    And a write enable signal write_en
    And an 8-bit write address write_addr
    And a 4-bit write data input write_data
    And a read enable signal read_en
    And an 8-bit read address read_addr
    And a 4-bit read data output read_data
    And the RAM contains 8 addressable locations, indexed 0 through 7, each 4 bits wide
    And although write_addr and read_addr are declared as 8-bit signals per the interface, only 8 locations exist, so any address symbol (ADDR, WADDR, RADDR, OTHER_ADDR) used in a scenario is assumed to satisfy 0 <= ADDR <= 7
    And addresses outside the range 0 to 7 are out of scope for this specification and are never asserted; the unused upper address bits are treated as don't-care with respect to addressing behavior
    And the architectural reset value for every memory location is fixed at the constant 4'b0000

  @reset @async
  Formal Scenario: Asynchronous reset clears all memory locations
    Given any address ADDR such that 0 <= ADDR <= 7
    When rst_n is deasserted low at any time regardless of clk
    Then all internal memory locations should be forced to 4'b0000
    And this reset should not depend on the clock edge

  @reset @read_after_reset
  Formal Scenario: Reading any location after reset returns zero
    Given rst_n has been asserted low and then deasserted high
    And read_en is 1
    And read_addr is any address ADDR such that 0 <= ADDR <= 7
    When one clock edge occurs after reset deassertion
    Then read_data should equal 4'b0000

  @write @basic
  Formal Scenario: Write operation updates the target memory location
    Given rst_n is high
    And write_en is 1
    And write_addr is any address ADDR such that 0 <= ADDR <= 7
    And write_data is any value DATA
    When a positive clock edge occurs
    Then the internal memory location at address ADDR should be updated to DATA

  @write @disabled
  Formal Scenario: Memory location is unchanged when write is disabled
    Given rst_n is high
    And write_en is 0
    And write_addr is any address ADDR such that 0 <= ADDR <= 7
    And the internal memory location at address ADDR currently holds value OLD_DATA
    When a positive clock edge occurs
    Then the internal memory location at address ADDR should still hold OLD_DATA

  @read @basic
  Formal Scenario: Read operation returns the stored value at the read address
    Given rst_n is high
    And read_en is 1
    And read_addr is any address ADDR such that 0 <= ADDR <= 7
    And the internal memory location at address ADDR holds value STORED_DATA
    When read_en and read_addr are sampled combinationally
    Then read_data should equal STORED_DATA

  @read @write @independent_addresses
  Formal Scenario: Simultaneous read and write to different addresses do not interfere
    Given rst_n is high
    And write_en is 1
    And write_addr is address WADDR such that 0 <= WADDR <= 7
    And write_data is value WDATA
    And read_en is 1
    And read_addr is address RADDR such that 0 <= RADDR <= 7
    And RADDR is not equal to WADDR
    And the internal memory location at address RADDR holds value RDATA_BEFORE
    When a positive clock edge occurs
    Then read_data should equal RDATA_BEFORE
    And the internal memory location at address WADDR should be updated to WDATA
    And the internal memory location at address RADDR should remain RDATA_BEFORE

  @read @write @same_address_collision
  Formal Scenario: Simultaneous read and write to the same address returns pre-write data
    Given rst_n is high
    And write_en is 1
    And write_addr is address ADDR such that 0 <= ADDR <= 7
    And write_data is value NEW_DATA
    And read_en is 1
    And read_addr is address ADDR
    And the internal memory location at address ADDR holds value OLD_DATA before the clock edge
    When read_data is sampled in the same cycle as the write
    Then read_data should equal OLD_DATA
    And after the positive clock edge the internal memory location at address ADDR should be updated to NEW_DATA

  @write @multiple_addresses @independence
  Formal Scenario: Writes to one address do not affect other addresses
    Given rst_n is high
    And write_en is 1
    And write_addr is address WADDR such that 0 <= WADDR <= 7
    And write_data is value WDATA
    And OTHER_ADDR is any address such that 0 <= OTHER_ADDR <= 7 and OTHER_ADDR is not equal to WADDR
    And the internal memory location at address OTHER_ADDR holds value OTHER_DATA
    When a positive clock edge occurs
    Then the internal memory location at address WADDR should be updated to WDATA
    And the internal memory location at address OTHER_ADDR should remain OTHER_DATA

  @read @disabled
  Formal Scenario: Memory is unmodified when only read is asserted
    Given rst_n is high
    And read_en is 1
    And write_en is 0
    And read_addr is any address ADDR such that 0 <= ADDR <= 7
    And for all addresses i such that 0 <= i <= 7, mem[i] before the clock edge equals M_i
    When a positive clock edge occurs
    Then for all addresses i such that 0 <= i <= 7, mem[i] after the clock edge equals M_i

  @write @sequential @persistence
  Formal Scenario: Written data persists across subsequent clock cycles without further writes
    Given rst_n is high
    And write_en is 1
    And write_addr is address ADDR such that 0 <= ADDR <= 7
    And write_data is value DATA
    When a positive clock edge occurs
    And on the next clock edge write_en is 0
    Then the internal memory location at address ADDR should still hold DATA

  @reset @write @priority
  Formal Scenario: Asynchronous reset overrides any pending write
    Given write_en is 1
    And write_addr is any address ADDR such that 0 <= ADDR <= 7
    And write_data is any value DATA such that DATA is not equal to 4'b0000
    When rst_n is asserted low asynchronously
    Then mem[ADDR] after reset should equal 4'b0000 rather than DATA