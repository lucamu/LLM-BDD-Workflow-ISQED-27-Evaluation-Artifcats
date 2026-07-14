# ── module: RegisterFile ──
Feature: 32x32 Register File with Synchronous Reset and Dual Read Ports

  As a hardware designer
  I want the register file to correctly implement synchronous write/reset
  and combinational dual-port reads
  So that the processor core can reliably access register operands

  Background:
    Given a clock signal clk
    And a synchronous active-high reset signal rst
    And a write enable signal rg_wrt_en
    And a 5-bit write destination address rg_wrt_dest
    And a 32-bit write data value rg_wrt_data
    And a 5-bit read address rg_rd_addr1
    And a 5-bit read address rg_rd_addr2
    And a 32-bit combinational read output rg_rd_data1
    And a 32-bit combinational read output rg_rd_data2
    And 32 internal 32-bit storage registers indexed 0 to 31

  @reset @synchronous
  Formal Scenario: Synchronous reset clears all registers
    Given rst is 1
    And rg_wrt_en is any value
    And rg_wrt_dest is any value
    And rg_wrt_data is any value
    When a rising edge of clk occurs
    Then every internal register from index 0 to 31 should become 32'd0

  @reset @priority
  Formal Scenario: Reset overrides a simultaneous write
    Given rst is 1
    And rg_wrt_en is 1
    And rg_wrt_dest is address D
    And rg_wrt_data is value X
    When a rising edge of clk occurs
    Then the internal register at index D should become 32'd0
    And no register should retain value X as a result of this edge

  @write @update
  Formal Scenario: Write updates the targeted register when enabled
    Given rst is 0
    And rg_wrt_en is 1
    And rg_wrt_dest is address D
    And rg_wrt_data is value X
    And the internal register at index D holds value Y before the edge
    When a rising edge of clk occurs
    Then the internal register at index D should become X

  @write @no_write
  Formal Scenario: Write is ignored when write enable is deasserted
    Given rst is 0
    And rg_wrt_en is 0
    And rg_wrt_dest is address D
    And rg_wrt_data is value X
    And the internal register at index D holds value Y before the edge
    When a rising edge of clk occurs
    Then the internal register at index D should remain Y

  @write @isolation
  Formal Scenario: Write does not affect registers other than the destination
    Given rst is 0
    And rg_wrt_en is 1
    And rg_wrt_dest is address D
    And rg_wrt_data is value X
    And an arbitrary register index K is not equal to D
    And the internal register at index K holds value Z before the edge
    When a rising edge of clk occurs
    Then the internal register at index K should remain Z

  @read @combinational
  Formal Scenario: Read port 1 combinationally reflects the addressed register
    Given rg_rd_addr1 is address A
    And the internal register at index A holds value V
    When no clock edge is considered
    Then rg_rd_data1 should equal V

  @read @combinational
  Formal Scenario: Read port 2 combinationally reflects the addressed register
    Given rg_rd_addr2 is address B
    And the internal register at index B holds value W
    When no clock edge is considered
    Then rg_rd_data2 should equal W

  @read @independence
  Formal Scenario: Read ports operate independently for distinct addresses
    Given rg_rd_addr1 is address A
    And rg_rd_addr2 is address B
    And address A is not equal to address B
    And the internal register at index A holds value V
    And the internal register at index B holds value W
    When no clock edge is considered
    Then rg_rd_data1 should equal V
    And rg_rd_data2 should equal W

  @read @same_address
  Formal Scenario: Both read ports return the same value for identical addresses
    Given rg_rd_addr1 is address A
    And rg_rd_addr2 is address A
    And the internal register at index A holds value V
    When no clock edge is considered
    Then rg_rd_data1 should equal V
    And rg_rd_data2 should equal V

  @read_before_write @hazard
  Formal Scenario: Reads reflect old value during a write to the same address on the same edge
    Given rst is 0
    And rg_wrt_en is 1
    And rg_wrt_dest is address D
    And rg_wrt_data is value X
    And rg_rd_addr1 is address D
    And the internal register at index D holds value Y before the edge
    When rg_rd_data1 is sampled prior to the rising edge of clk
    Then rg_rd_data1 should equal Y
    When a rising edge of clk occurs
    And rg_rd_data1 is sampled after the rising edge with rg_rd_addr1 still address D
    Then rg_rd_data1 should equal X

  @read_before_write @hazard
  Formal Scenario: Read port 2 reflects old value during a write to the same address on the same edge
    Given rst is 0
    And rg_wrt_en is 1
    And rg_wrt_dest is address D
    And rg_wrt_data is value X
    And rg_rd_addr2 is address D
    And the internal register at index D holds value Y before the edge
    When rg_rd_data2 is sampled prior to the rising edge of clk
    Then rg_rd_data2 should equal Y
    When a rising edge of clk occurs
    And rg_rd_data2 is sampled after the rising edge with rg_rd_addr2 still address D
    Then rg_rd_data2 should equal X

# ── module: TopModule ──
Feature: 32-Register File with Dual Read Ports and Single Write Port

  Formal verification of a register file containing 32 registers, each 32
  bits wide, with two combinational read ports and one clocked write port.
  Reset is synchronous and active-high.

  Background:
    Given the design is TopModule
    And clk is the clock signal
    And rst is the synchronous active-high reset
    And all signals are sampled with respect to the rising edge of clk

  @reset
  Formal Scenario: Synchronous reset clears all registers
    Given rst is 1
    When a rising clock edge occurs
    Then every register in the register file should equal 32'd0

  @reset
  Formal Scenario: Reset takes priority over a simultaneous write
    Given rst is 1
    And rg_wrt_en is 1
    And rg_wrt_dest is address D
    And rg_wrt_data is value W
    When a rising clock edge occurs
    Then the register at address D should equal 32'd0
    And every other register in the register file should equal 32'd0

  @write
  Formal Scenario: Write updates the targeted register
    Given rst is 0
    And rg_wrt_en is 1
    And rg_wrt_dest is address D
    And rg_wrt_data is value W
    When a rising clock edge occurs
    Then the register at address D should equal W

  @write
  Formal Scenario: Write does not affect other registers
    Given rst is 0
    And rg_wrt_en is 1
    And rg_wrt_dest is address D
    And rg_wrt_data is value W
    And address E is any register address different from D
    And the register at address E holds value V before the clock edge
    When a rising clock edge occurs
    Then the register at address E should still equal V

  @write
  Formal Scenario: No write occurs when write enable is deasserted
    Given rst is 0
    And rg_wrt_en is 0
    And rg_wrt_dest is address D
    And the register at address D holds value V before the clock edge
    When a rising clock edge occurs
    Then the register at address D should still equal V

  @read
  Formal Scenario: Read port 1 combinationally reflects addressed register
    Given rg_rd_addr1 is address A
    And the register at address A currently holds value V
    Then rg_rd_data1 should equal V

  @read
  Formal Scenario: Read port 2 combinationally reflects addressed register
    Given rg_rd_addr2 is address B
    And the register at address B currently holds value V
    Then rg_rd_data2 should equal V

  @read
  Formal Scenario: Both read ports can independently address different registers
    Given rg_rd_addr1 is address A
    And rg_rd_addr2 is address B
    And address A is different from address B
    And the register at address A currently holds value V1
    And the register at address B currently holds value V2
    Then rg_rd_data1 should equal V1
    And rg_rd_data2 should equal V2

  @read
  Formal Scenario: Both read ports can address the same register
    Given rg_rd_addr1 is address A
    And rg_rd_addr2 is address A
    And the register at address A currently holds value V
    Then rg_rd_data1 should equal V
    And rg_rd_data2 should equal V

  @write-read-hazard
  Formal Scenario: Read port 1 shows pre-write value during a same-cycle write to the same address
    Given rst is 0
    And rg_wrt_en is 1
    And rg_wrt_dest is address D
    And rg_wrt_data is value W
    And rg_rd_addr1 is address D
    And the register at address D holds value V before the clock edge
    Then rg_rd_data1 should equal V
    When a rising clock edge occurs
    Then the register at address D should equal W

  @write-read-hazard
  Formal Scenario: Read port 2 shows pre-write value during a same-cycle write to the same address
    Given rst is 0
    And rg_wrt_en is 1
    And rg_wrt_dest is address D
    And rg_wrt_data is value W
    And rg_rd_addr2 is address D
    And the register at address D holds value V before the clock edge
    Then rg_rd_data2 should equal V
    When a rising clock edge occurs
    Then the register at address D should equal W

  @write-read-hazard
  Formal Scenario: Written value becomes visible on read ports only after the write edge
    Given rst is 0
    And rg_wrt_en is 1
    And rg_wrt_dest is address D
    And rg_wrt_data is value W
    When a rising clock edge occurs
    And rg_rd_addr1 is address D
    And rg_rd_addr2 is address D
    Then rg_rd_data1 should equal W
    And rg_rd_data2 should equal W

  @stability
  Formal Scenario: Register retains value across cycles with no write and no reset
    Given rst is 0
    And rg_wrt_en is 0
    And an arbitrary address D holds value V before the clock edge
    When a rising clock edge occurs
    Then the register at address D should still equal V