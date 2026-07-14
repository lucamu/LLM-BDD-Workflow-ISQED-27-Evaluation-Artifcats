Feature: UART to Bus Core Protocol and Interface Verification
  As a hardware verification engineer
  I want to formally verify the UART to Bus core behavior
  So that I can ensure correct protocol parsing, bus access timing, and interface compliance

  Background:
    Given the core is driven by a rising edge clock
    And an asynchronous active-high reset signal
    And when reset is asserted all internal state machines return to state IDLE
    And int_gnt is tied to logic 1 when the bus request/grant mechanism is disabled
    And the parser FSM defines the following named states: IDLE, BIN_CMD, BIN_ADRH, BIN_ADRL, BIN_LEN, BIN_DATA, TXT_CMD, WHITE1, DATA, WHITE2, ADDR, EOL
    And a symbolic signal cycle_count is used to index bounded repeated behavior, ranging from 0 to N-1 or 0 to LEN-1 as specified in each scenario

  # -----------------------------------------------------------------
  # Reset and Global Behavior
  # -----------------------------------------------------------------

  @reset
  Formal Scenario: Reset forces parser to IDLE state and deasserts control signals
    Given reset is asserted for at least one clock cycle
    When the clock edge occurs
    Then int_write should be 0
    And int_read should be 0
    And int_req should be 0
    And ser_out should be in idle line state

  @reset
  Formal Scenario: Reset overrides any in-progress command parsing
    Given the parser is in any state S other than IDLE
    And reset is asserted
    When the clock edge occurs
    Then the parser state should transition to IDLE
    And any partially received command should be discarded

  # -----------------------------------------------------------------
  # Bus Request / Grant Mechanism
  # -----------------------------------------------------------------

  @bus_arbitration
  Formal Scenario: Core asserts request before any internal bus access
    Given the parser has decoded a valid read or write operation with address ADDR
    And int_gnt is 0
    When the core attempts to access the internal bus
    Then int_req should be 1
    And int_write should be 0
    And int_read should be 0

  @bus_arbitration
  Formal Scenario: Core releases request and executes access upon grant
    Given int_req is 1
    And int_gnt becomes 1 on the current clock edge
    When the clock edge occurs
    Then int_req should be 0 on the following cycle
    And the internal bus access (int_read or int_write) should be executed within that cycle

  @bus_arbitration
  Formal Scenario: Bus access is held until grant is received
    Given int_req equals 1 at cycle_count = 0
    And int_gnt equals 0 for every cycle_count in the range 0 to N-1
    And N is a positive integer bound
    When cycle_count is incremented from 0 to N-1
    Then int_req should equal 1 for every cycle_count in the range 0 to N-1
    And int_write should equal 0 for every cycle_count in the range 0 to N-1
    And int_read should equal 0 for every cycle_count in the range 0 to N-1

  # -----------------------------------------------------------------
  # Internal Bus Read/Write Timing
  # -----------------------------------------------------------------

  @bus_timing
  Formal Scenario: int_write pulse is asserted for exactly one cycle per write
    Given a write operation with address ADDR and data DATA is triggered
    And int_gnt is 1
    When the clock edge occurs
    Then int_write should be 1 for exactly one clock cycle
    And int_address should equal ADDR during that cycle
    And int_wr_data should equal DATA during that cycle

  @bus_timing
  Formal Scenario: int_read pulse is asserted for exactly one cycle per read
    Given a read operation with address ADDR is triggered
    And int_gnt is 1
    When the clock edge occurs
    Then int_read should be 1 for exactly one clock cycle
    And int_address should equal ADDR during that cycle

  @bus_timing
  Formal Scenario: int_rd_data is sampled one cycle after int_read assertion
    Given int_read is asserted at cycle T with address ADDR
    And int_rd_data equals value RDATA at cycle T+1
    When the clock edge at T+1 occurs
    Then the core should capture RDATA as the value read from ADDR

  # -----------------------------------------------------------------
  # Protocol Mode Discrimination
  # -----------------------------------------------------------------

  @protocol_discrimination
  Formal Scenario: Zero byte prefix selects binary mode protocol
    Given the parser is in state IDLE
    And the received byte equals 8'h00
    When the byte is processed
    Then the parser should transition to state BIN_CMD

  @protocol_discrimination
  Formal Scenario: Non-zero R or r byte selects text mode read command
    Given the parser is in state IDLE
    And the received byte equals ASCII 'R' or ASCII 'r'
    When the byte is processed
    Then the parser should transition to state TXT_CMD with the read operation selected

  @protocol_discrimination
  Formal Scenario: Non-zero W or w byte selects text mode write command
    Given the parser is in state IDLE
    And the received byte equals ASCII 'W' or ASCII 'w'
    When the byte is processed
    Then the parser should transition to state TXT_CMD with the write operation selected

  # -----------------------------------------------------------------
  # Text Mode Protocol - Structural Coverage
  # -----------------------------------------------------------------

  @text_structure
  Formal Scenario: Text read command parses through canonical state sequence
    Given the parser is in state IDLE
    And a text read command byte sequence consisting of 'R' or 'r', one or more white space characters, four hexadecimal address digits, and an EOL character is received
    When each character is processed sequentially
    Then the parser should transition through states IDLE, TXT_CMD, WHITE1, ADDR, EOL in that order

  @text_structure
  Formal Scenario: Text write command parses through canonical state sequence
    Given the parser is in state IDLE
    And a text write command byte sequence consisting of 'W' or 'w', one or more white space characters, two hexadecimal data digits, one or more white space characters, four hexadecimal address digits, and an EOL character is received
    When each character is processed sequentially
    Then the parser should transition through states IDLE, TXT_CMD, WHITE1, DATA, WHITE2, ADDR, EOL in that order

  # -----------------------------------------------------------------
  # Text Mode Protocol - Read Command
  # -----------------------------------------------------------------

  @text_read
  Formal Scenario: Text mode read command triggers internal bus read of given address
    Given the parser transitions from IDLE to TXT_CMD upon receiving 'R' or 'r'
    And the parser transitions from TXT_CMD to WHITE1 upon receiving one or more white space characters (0x20 or 0x09)
    And the parser transitions from WHITE1 to ADDR upon receiving the first hexadecimal digit
    And the parser accumulates a 4-digit hexadecimal address ADDR while in state ADDR
    And the parser transitions from ADDR to EOL upon receiving an end-of-line character (0x0A or 0x0D)
    When the parser processes the EOL character in state EOL
    Then the core should issue int_read with int_address equal to ADDR

  @text_read
  Formal Scenario: Text mode read response transmits two hex characters followed by CRLF
    Given a text mode read command for address ADDR has completed in state EOL
    And int_rd_data equals value RDATA at the sampling cycle
    When the response is transmitted
    Then the transmitted bytes should equal the two ASCII hex characters representing RDATA
    And the transmitted bytes should be followed by CR (0x0D) then LF (0x0A)

  @text_read
  Formal Scenario: Text mode accepts both uppercase and lowercase hex digits for address
    Given the parser is in state ADDR
    And the received character C is a valid hexadecimal digit in uppercase or lowercase form
    When C is processed
    Then the parser should accept C as part of ADDR
    And the parser should not transition to state IDLE

  # -----------------------------------------------------------------
  # Text Mode Protocol - Write Command
  # -----------------------------------------------------------------

  @text_write
  Formal Scenario: Text mode write command triggers internal bus write of given data to given address
    Given the parser transitions from IDLE to TXT_CMD upon receiving 'W' or 'w'
    And the parser transitions from TXT_CMD to WHITE1 upon receiving one or more white space characters
    And the parser transitions from WHITE1 to DATA upon receiving the first hexadecimal digit of a 2-digit data value DATA
    And the parser transitions from DATA to WHITE2 upon receiving one or more white space characters
    And the parser transitions from WHITE2 to ADDR upon receiving the first hexadecimal digit of a 4-digit address ADDR
    And the parser transitions from ADDR to EOL upon receiving an end-of-line character
    When the parser processes the EOL character in state EOL
    Then the core should issue int_write with int_address equal to ADDR
    And int_wr_data equal to DATA

  @text_write
  Formal Scenario: Text mode write command produces no transmitted response
    Given a text mode write command for address ADDR and data DATA has completed in state EOL
    When the write operation completes
    Then ser_out should remain in idle line state
    And no response bytes should be transmitted

  # -----------------------------------------------------------------
  # Text Mode Protocol - Illegal Sequence Handling
  # -----------------------------------------------------------------

  @text_abort
  Formal Scenario: Illegal character in text command aborts parsing to IDLE
    Given the parser is in one of states TXT_CMD, WHITE1, DATA, WHITE2, or ADDR
    And the received character C is not a valid hexadecimal digit, white space character, or EOL character for that state
    When C is processed
    Then the parser should transition to state IDLE
    And no internal bus access should be issued

  @text_whitespace
  Formal Scenario: Both space and tab characters are recognized as white space
    Given the parser is in state WHITE1 or WHITE2
    And the received character C equals 0x20 or 0x09
    When C is processed
    Then the parser should treat C as valid white space
    And the parser should not transition to state IDLE

  @text_eol
  Formal Scenario: Both CR and LF characters are recognized as end of line
    Given the parser is in state ADDR awaiting the end-of-line character
    And the received character C equals 0x0A or 0x0D
    When C is processed
    Then the parser should transition to state EOL
    And the command execution should be triggered in the same cycle

  # -----------------------------------------------------------------
  # Binary Mode Protocol - Structural Coverage
  # -----------------------------------------------------------------

  @binary_structure
  Formal Scenario: Binary command parses through canonical state sequence
    Given the parser is in state IDLE
    And a binary command byte sequence consisting of prefix 8'h00, a command byte, an address high byte, an address low byte, and a length byte is received
    When each byte is processed sequentially
    Then the parser should transition through states IDLE, BIN_CMD, BIN_ADRH, BIN_ADRL, BIN_LEN in that order

  @binary_abort
  Formal Scenario: Reserved command selection value aborts binary command processing
    Given the parser is in state BIN_CMD
    And the command byte selection bits [5:4] equal 2'b11
    When the command byte is processed
    Then the parser should transition to state IDLE
    And no internal bus access should be issued

  # -----------------------------------------------------------------
  # Binary Mode Protocol - Command Structure
  # -----------------------------------------------------------------

  @binary_nop
  Formal Scenario: Binary NOP command with ACK flag sends ACK byte and performs no bus access
    Given the parser is in state BIN_CMD having received the binary prefix byte 8'h00
    And the command byte has command selection bits [5:4] equal to 2'b00
    And bit [0] (ACK flag) equal to 1
    When the command completes
    Then the core should transmit the ACK byte 8'h5A
    And int_write should remain 0
    And int_read should remain 0

  @binary_nop
  Formal Scenario: Binary NOP command without ACK flag produces no transmission
    Given the parser is in state BIN_CMD having received the binary prefix byte 8'h00
    And the command byte has command selection bits [5:4] equal to 2'b00
    And bit [0] (ACK flag) equal to 0
    When the command completes
    Then no bytes should be transmitted
    And int_write should remain 0
    And int_read should remain 0

  @binary_read
  Formal Scenario: Binary read command reads LEN bytes starting at ADDR
    Given the parser has received prefix byte 8'h00, a command byte with selection bits [5:4] equal to 2'b01, address high byte ADDRH, address low byte ADDRL forming ADDR, and length byte LEN
    And the parser has transitioned through states BIN_CMD, BIN_ADRH, BIN_ADRL, BIN_LEN in that order
    When the parser enters state BIN_DATA and executes bus accesses for cycle_count ranging from 0 to LEN-1
    Then the core should issue exactly LEN int_read operations, one per cycle_count value
    And the int_address used at cycle_count = 0 should equal ADDR

  @binary_read
  Formal Scenario: Binary read response transmits data followed by optional ACK
    Given a binary read command with length LEN and ACK flag ACKBIT has completed
    And the data read from the bus equals DATA at each cycle_count from 0 to LEN-1
    When the response is transmitted
    Then the transmitted byte at each cycle_count from 0 to LEN-1 should equal DATA for that cycle_count
    And if ACKBIT equals 1 then byte 8'h5A should be transmitted immediately after cycle_count = LEN-1
    And if ACKBIT equals 0 then no additional byte should be transmitted after cycle_count = LEN-1

  @binary_write
  Formal Scenario: Binary write command writes LEN bytes of DATA starting at ADDR
    Given the parser has received prefix byte 8'h00, a command byte with selection bits [5:4] equal to 2'b10, address high byte ADDRH, address low byte ADDRL forming ADDR, length byte LEN, and LEN subsequent data bytes indexed DATA at each cycle_count from 0 to LEN-1
    And the parser has transitioned through states BIN_CMD, BIN_ADRH, BIN_ADRL, BIN_LEN, BIN_DATA in that order
    When the parser executes bus accesses for cycle_count ranging from 0 to LEN-1
    Then the core should issue exactly LEN int_write operations, one per cycle_count value
    And the int_wr_data at cycle_count = 0 should equal DATA at cycle_count = 0
    And the int_address at cycle_count = 0 should equal ADDR

  @binary_write
  Formal Scenario: Binary write command sends ACK byte only when ACK flag set
    Given a binary write command with ACK flag ACKBIT has completed after cycle_count = LEN-1
    When the write operations complete
    Then if ACKBIT equals 1 then byte 8'h5A should be transmitted
    And if ACKBIT equals 0 then no byte should be transmitted

  # -----------------------------------------------------------------
  # Binary Mode Protocol - Address Auto Increment
  # -----------------------------------------------------------------

  @binary_autoincrement
  Formal Scenario: Address auto increment enabled increments address after each access
    Given a binary read or write command with bit [1] equal to 0 (auto increment enabled)
    And starting address ADDR
    And length LEN greater than 1
    When bus accesses are performed for cycle_count ranging from 0 to LEN-1
    Then the int_address used at each cycle_count should equal ADDR + cycle_count

  @binary_autoincrement
  Formal Scenario: Address auto increment disabled keeps address constant
    Given a binary read or write command with bit [1] equal to 1 (auto increment disabled)
    And starting address ADDR
    And length LEN greater than 1
    When bus accesses are performed for cycle_count ranging from 0 to LEN-1
    Then the int_address used at each cycle_count should equal ADDR

  # -----------------------------------------------------------------
  # Binary Mode Protocol - Length Field Encoding
  # -----------------------------------------------------------------

  @binary_length
  Formal Scenario: Length byte value of zero encodes 256 byte transfer
    Given a binary command with length byte LEN equal to 8'h00
    When the command is processed
    Then the number of bus accesses performed should equal 256

  @binary_length
  Formal Scenario: Length byte nonzero value encodes that many byte transfers
    Given a binary command with length byte LEN not equal to 8'h00
    When the command is processed
    Then the number of bus accesses performed should equal LEN

  # -----------------------------------------------------------------
  # Interface Port Behavior
  # -----------------------------------------------------------------

  @interface
  Formal Scenario: int_write is asserted only for a single clock cycle per write access
    Given int_write is asserted at cycle T with int_address equal to ADDR and int_wr_data equal to DATA
    When the clock edge at cycle T occurs
    Then int_write should equal 1 only at cycle T
    And int_write should equal 0 at cycle T-1 and at cycle T+1

  @interface
  Formal Scenario: int_read is asserted only for a single clock cycle per read access
    Given int_read is asserted at cycle T with int_address equal to ADDR
    When the clock edge at cycle T occurs
    Then int_read should equal 1 only at cycle T
    And int_read should equal 0 at cycle T-1 and at cycle T+1

  @interface
  Formal Scenario: int_gnt tied high disables bus request mechanism
    Given int_gnt is permanently tied to logic 1
    And int_req is asserted at cycle T
    When the clock edge at cycle T+1 occurs
    Then int_req should equal 0 at cycle T+1 regardless of int_gnt value
    And the internal bus access (int_read is asserted or int_write is asserted) should proceed at or before cycle T+1 without waiting for a grant transition on int_gnt