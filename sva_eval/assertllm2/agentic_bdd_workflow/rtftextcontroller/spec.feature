Feature: rtfTextController Text-Mode Video Overlay Controller

  Formal verification specification for the rtfTextController module, covering
  bus interface handshaking, register programming, dual-port memory access,
  cursor generation, transparency-based pixel composition, and light-pen
  capture across the clk_i and vclk clock domains.

  Background:
    Given the design is at time T with clk_i and vclk as independent clocks
    And rst_i is the active-high synchronous/asynchronous reset for clk_i domain state
    And all vclk-domain sequential state is reset when rst_i is asserted
    And cs_text, cs_color, cs_rom, cs_reg are derived from decode of adr_i high-order bits qualified by cyc_i and stb_i

  # ---------------------------------------------------------------------
  # Reset behavior
  # ---------------------------------------------------------------------

  @reset
  Formal Scenario: Reset forces ack_o inactive
    Given rst_i is asserted
    When a clk_i rising edge occurs
    Then ack_o should be 0

  @reset
  Formal Scenario: Reset forces rgbOut to a defined black/blank state on vclk domain
    Given rst_i is asserted
    When a vclk rising edge occurs
    Then rgbOut should reflect the reset-defined blanked output value

  @reset
  Formal Scenario: Reset clears the light-pen address register
    Given rst_i is asserted
    When a clk_i rising edge occurs
    Then the value read from register index 12 (penAddr) should be 0

  # ---------------------------------------------------------------------
  # Bus handshake: write acknowledgment
  # ---------------------------------------------------------------------

  @bus_write
  Formal Scenario: Write transfer acknowledges combinationally when selected
    Given rst_i is deasserted
    And cyc_i is 1 and stb_i is 1
    And we_i is 1
    And adr_i selects a valid mapped region (text, attribute, register)
    And sel_i indicates a byte-lane selection value SEL
    And dat_i carries write data value D
    When a clk_i rising edge occurs
    Then ack_o should be 1 in the same selected cycle

  @bus_write
  Formal Scenario: Unselected access produces no acknowledge
    Given rst_i is deasserted
    And cyc_i is 0 or stb_i is 0
    When a clk_i rising edge occurs
    Then ack_o should be 0

  @bus_write
  Formal Scenario: Text RAM write updates memory content at addressed location
    Given rst_i is deasserted
    And cyc_i is 1 and stb_i is 1 and we_i is 1
    And adr_i selects the text screen memory window with column address ADDR = adr_i[13:1]
    And dat_i carries character code value CODE
    When a clk_i rising edge occurs with the write qualified
    Then the text RAM entry at address ADDR should hold value CODE truncated to 9 bits

  @bus_write
  Formal Scenario: Attribute RAM write updates memory content at addressed location
    Given rst_i is deasserted
    And cyc_i is 1 and stb_i is 1 and we_i is 1
    And adr_i selects the attribute memory window with column address ADDR = adr_i[13:1]
    And dat_i carries attribute value ATTR
    When a clk_i rising edge occurs with the write qualified
    Then the attribute RAM entry at address ADDR should hold value ATTR truncated to 9 bits

  @bus_write
  Formal Scenario: Character bitmap write is inactive regardless of bus write attempt
    Given rst_i is deasserted
    And cyc_i is 1 and stb_i is 1 and we_i is 1
    And adr_i selects the character bitmap memory window
    And dat_i carries any value DATA
    When a clk_i rising edge occurs
    Then the character bitmap RAM content should remain unchanged
    And ack_o may still assert per bus-select behavior without altering glyph storage

  # ---------------------------------------------------------------------
  # Bus handshake: read acknowledgment and read-ready staging
  # ---------------------------------------------------------------------

  @bus_read
  Formal Scenario: Read transfer acknowledges after internal ready staging
    Given rst_i is deasserted
    And cyc_i is 1 and stb_i is 1 and we_i is 0
    And adr_i selects a valid mapped memory region
    When a clk_i rising edge occurs
    Then ack_o should be 0 in the same cycle the read request is issued
    And ack_o should become 1 on the subsequent clk_i rising edge reflecting ramRdy staging

  @bus_read
  Formal Scenario: Text RAM read returns previously written value
    Given rst_i is deasserted
    And a prior write stored value CODE at text RAM address ADDR
    And cyc_i is 1 and stb_i is 1 and we_i is 0
    And adr_i selects the text screen memory window with column address ADDR
    When two clk_i rising edges occur to satisfy read latency
    Then dat_o should equal CODE zero-extended to 16 bits

  @bus_read
  Formal Scenario: Attribute RAM read returns previously written value
    Given rst_i is deasserted
    And a prior write stored value ATTR at attribute RAM address ADDR
    And cyc_i is 1 and stb_i is 1 and we_i is 0
    And adr_i selects the attribute memory window with column address ADDR
    When two clk_i rising edges occur to satisfy read latency
    Then dat_o should equal ATTR zero-extended to 16 bits

  # ---------------------------------------------------------------------
  # Register write / readback behavior
  # ---------------------------------------------------------------------

  @registers
  Formal Scenario: numCols register write and readback
    Given rst_i is deasserted
    And cyc_i is 1 and stb_i is 1 and we_i is 1
    And adr_i selects register index 0 (numCols)
    And dat_i carries value VAL with VAL[11:0] representing the column count
    When a clk_i rising edge occurs to perform the write
    And a subsequent read transfer selects register index 0
    Then dat_o should equal VAL[11:0] zero-extended to 16 bits

  @registers
  Formal Scenario: numRows register write and readback
    Given rst_i is deasserted
    And cyc_i is 1 and stb_i is 1 and we_i is 1
    And adr_i selects register index 1 (numRows)
    And dat_i carries value VAL with VAL[11:0] representing the row count
    When a clk_i rising edge occurs to perform the write
    And a subsequent read transfer selects register index 1
    Then dat_o should equal VAL[11:0] zero-extended to 16 bits

  @registers
  Formal Scenario: cursorPos register write and readback
    Given rst_i is deasserted
    And cyc_i is 1 and stb_i is 1 and we_i is 1
    And adr_i selects register index 11 (cursorPos)
    And dat_i carries value VAL representing the cursor position address
    When a clk_i rising edge occurs to perform the write
    And a subsequent read transfer selects register index 11
    Then dat_o should equal VAL zero-extended to 16 bits

  @registers
  Formal Scenario: penAddr register readback reflects latched light-pen address
    Given rst_i is deasserted
    And the light-pen capture logic has latched value PENVAL into penAddr
    And a read transfer selects register index 12
    When the read completes
    Then dat_o should equal PENVAL zero-extended to 16 bits

  @registers
  Formal Scenario: Unimplemented register index reads as zero
    Given rst_i is deasserted
    And a read transfer selects a register index IDX where IDX is not in the set {0, 1, 11, 12}
    When the read completes
    Then dat_o should equal 0

  @registers
  Formal Scenario: windowLeft register write and readback consistency
    Given rst_i is deasserted
    And cyc_i is 1 and stb_i is 1 and we_i is 1
    And adr_i selects register index 2 (windowLeft)
    And dat_i carries value VAL with VAL[11:0] representing the window offset
    When a clk_i rising edge occurs to perform the write
    Then the internal windowLeft register should hold VAL[11:0]

  @registers
  Formal Scenario: txtTcCode register write updates transparent code value
    Given rst_i is deasserted
    And cyc_i is 1 and stb_i is 1 and we_i is 1
    And adr_i selects register index 7 (txtTcCode)
    And dat_i carries value VAL with VAL[4:0] representing the transparent color code
    When a clk_i rising edge occurs to perform the write
    Then the internal txtTcCode register should hold VAL[4:0]

  # ---------------------------------------------------------------------
  # Light-pen capture
  # ---------------------------------------------------------------------

  @lightpen
  Formal Scenario: Rising edge on lp latches current text address into penAddr
    Given rst_i is deasserted
    And lp is stable at 0 for at least one clk_i cycle
    And the current text address value is TXTADDR
    When lp transitions from 0 to 1 on a clk_i rising edge
    Then penAddr should be updated to TXTADDR on the following clk_i cycle

  @lightpen
  Formal Scenario: No light-pen capture without rising edge
    Given rst_i is deasserted
    And lp remains constant at a fixed level (0 or 1) across consecutive clk_i cycles
    And penAddr currently holds value PREV
    When a clk_i rising edge occurs with no edge on lp
    Then penAddr should remain equal to PREV

  @lightpen
  Formal Scenario: Falling edge on lp does not affect penAddr
    Given rst_i is deasserted
    And lp transitions from 1 to 0 on a clk_i rising edge
    And penAddr currently holds value PREV
    When the clk_i rising edge with the falling transition occurs
    Then penAddr should remain equal to PREV

  # ---------------------------------------------------------------------
  # Text address generation
  # ---------------------------------------------------------------------

  @addressing
  Formal Scenario: Text address computed from start address, row, column, and numCols
    Given rst_i is deasserted
    And startAddress register holds value START
    And numCols register holds value NCOLS
    And the current derived row is ROW and the current derived column is COL
    When the vclk-domain address generator evaluates txtAddr
    Then txtAddr should equal START + (ROW * NCOLS) + COL

  @addressing
  Formal Scenario: Glyph fetch address formed from character code and rowscan
    Given rst_i is deasserted
    And the text RAM fetch returned character code CODE
    And the current intra-character scanline index is ROWSCAN with ROWSCAN[2:0] valid
    When the glyph bitmap fetch address is formed
    Then the glyph fetch address should equal the concatenation of CODE and ROWSCAN[2:0]

  # ---------------------------------------------------------------------
  # Character pixel generation / serializer
  # ---------------------------------------------------------------------

  @serializer
  Formal Scenario: Parallel load transfers bit-reversed glyph row into shifter
    Given rst_i is deasserted
    And the fetched glyph row byte is ROWBYTE
    And ld_shft is asserted at a vclk rising edge
    When the parallel-to-serial shifter loads on that edge
    Then the shifter contents should equal the bit-reversal of ROWBYTE

  @serializer
  Formal Scenario: Serial shift advances pix output on each pixel step
    Given rst_i is deasserted
    And the shifter currently holds value SHIFTVAL
    And nhp (shift enable) is asserted with ld_shft deasserted at a vclk rising edge
    When the shift occurs
    Then pix should equal the MSB of SHIFTVAL prior to the shift
    And the shifter should shift left by one bit filling with qin

  @serializer
  Formal Scenario: Pixel replication holds pix stable across replicated video clocks
    Given rst_i is deasserted
    And pixelWidth register field specifies replication factor REPW greater than 1
    And a text pixel value PIXVAL has just been serialized
    When REPW consecutive vclk cycles elapse without a new pixel-step strobe
    Then the composed output pixel value should remain derived from PIXVAL for each of those cycles

  # ---------------------------------------------------------------------
  # Cursor behavior
  # ---------------------------------------------------------------------

  @cursor
  Formal Scenario: Cursor active when text address matches cursorPos within scanline range
    Given rst_i is deasserted
    And cursorPos register holds value CURSORPOS
    And cursorStart and cursorEnd registers define scanline range [CSTART, CEND]
    And the current text address (with pipeline offset compensation) equals CURSORPOS
    And the current scanline index SCAN satisfies CSTART <= SCAN <= CEND
    When the vclk-domain cursor logic evaluates cursor-active condition
    Then cursor_active should be 1

  @cursor
  Formal Scenario: Cursor inactive when text address does not match cursorPos
    Given rst_i is deasserted
    And cursorPos register holds value CURSORPOS
    And the current text address (with pipeline offset compensation) equals ADDR where ADDR != CURSORPOS
    When the vclk-domain cursor logic evaluates cursor-active condition
    Then cursor_active should be 0

  @cursor
  Formal Scenario: Cursor inactive when scanline outside programmed start/end range
    Given rst_i is deasserted
    And the current text address matches cursorPos
    And cursorStart and cursorEnd registers define scanline range [CSTART, CEND]
    And the current scanline index SCAN is outside [CSTART, CEND]
    When the vclk-domain cursor logic evaluates cursor-active condition
    Then cursor_active should be 0

  @cursor
  Formal Scenario: Cursor pattern XORs glyph bit when active and blink phase enables display
    Given rst_i is deasserted
    And cursor_active is 1
    And the blink control selects cursor-visible phase
    And the current glyph pixel bit is PIX
    When the cursor composition logic evaluates the rendered pixel
    Then the rendered pixel bit should equal PIX XOR 1

  @cursor
  Formal Scenario: Cursor pattern does not alter glyph bit during blink-off phase
    Given rst_i is deasserted
    And cursor_active is 1
    And the blink control selects cursor-hidden (blink-off) phase
    And the current glyph pixel bit is PIX
    When the cursor composition logic evaluates the rendered pixel
    Then the rendered pixel bit should equal PIX

  # ---------------------------------------------------------------------
  # Output composition priority: blank, iblank, border, text
  # ---------------------------------------------------------------------

  @composition
  Formal Scenario: Global blanking forces black output regardless of other conditions
    Given rst_i is deasserted
    And blank is asserted at a vclk rising edge
    And border, iblank, and text-pixel state may take any value
    And rgbIn carries an arbitrary value RGBIN
    When the output pixel mux evaluates rgbOut
    Then rgbOut[23:0] should equal RGB black (24'h000000)

  @composition
  Formal Scenario: Window-outside pass-through forwards rgbIn when not blanked
    Given rst_i is deasserted
    And blank is deasserted
    And iblank (outside active window) is asserted
    And rgbIn carries value RGBIN with bit 24 equal to BIT24
    When the output pixel mux evaluates rgbOut
    Then rgbOut[23:0] should equal RGBIN[23:0]
    And rgbOut[24] should equal BIT24

  @composition
  Formal Scenario: Border pattern color selected when border asserted and not blanked or outside window
    Given rst_i is deasserted
    And blank is deasserted
    And iblank is deasserted
    And border is asserted
    When the output pixel mux evaluates rgbOut
    Then rgbOut[23:0] should equal the border pattern RGB color
    And rgbOut[24] should equal 0

  @composition
  Formal Scenario: Foreground color selected when text pixel is set and no override conditions apply
    Given rst_i is deasserted
    And blank is deasserted
    And iblank is deasserted
    And border is deasserted
    And the rendered text pixel bit (post cursor composition) equals 1
    And the foreground color ROM output for the current foreground code is FGRGB
    When the output pixel mux evaluates rgbOut
    Then rgbOut[23:0] should equal FGRGB
    And rgbOut[24] should equal 0

  @composition
  Formal Scenario: Background color selected when text pixel is clear and background is not transparent
    Given rst_i is deasserted
    And blank is deasserted
    And iblank is deasserted
    And border is deasserted
    And the rendered text pixel bit (post cursor composition) equals 0
    And the current attribute background code BGCODE does not equal txtTcCode
    And the background color ROM output for BGCODE is BGRGB
    When the output pixel mux evaluates rgbOut
    Then rgbOut[23:0] should equal BGRGB
    And rgbOut[24] should equal 0

  @composition
  Formal Scenario: Transparent background passes rgbIn when background code matches txtTcCode
    Given rst_i is deasserted
    And blank is deasserted
    And iblank is deasserted
    And border is deasserted
    And the rendered text pixel bit (post cursor composition) equals 0
    And the current attribute background code BGCODE equals txtTcCode register value
    And rgbIn carries value RGBIN with bit 24 equal to BIT24
    When the output pixel mux evaluates rgbOut
    Then rgbOut[23:0] should equal RGBIN[23:0]
    And rgbOut[24] should equal BIT24

  # ---------------------------------------------------------------------
  # Color ROM decode
  # ---------------------------------------------------------------------

  @colorrom
  Formal Scenario: Foreground code decode produces deterministic RGB value
    Given rst_i is deasserted
    And the rtfColorROM foreground input code is FGCODE
    And ce (update enable) is asserted at a vclk rising edge
    When the color ROM registers the decoded value
    Then the decoded foreground color output should equal the fixed ROM mapping of FGCODE

  @colorrom
  Formal Scenario: Background code decode produces deterministic RGB value
    Given rst_i is deasserted
    And the rtfColorROM background input code is BGCODE
    And ce (update enable) is asserted at a vclk rising edge
    When the color ROM registers the decoded value
    Then the decoded background color output should equal the fixed ROM mapping of BGCODE

  # ---------------------------------------------------------------------
  # HVCounter behavior
  # ---------------------------------------------------------------------

  @timing
  Formal Scenario: HVCounter resets its raw counter on sync pulse
    Given rst_i is deasserted
    And sync (eol or eof) is asserted at a vclk rising edge
    And cnt_offs holds preload value OFFS
    When the counter updates on this edge
    Then ctr should be set to OFFS

  @timing
  Formal Scenario: HVCounter increments raw counter when pixcce enabled and no sync
    Given rst_i is deasserted
    And sync is deasserted
    And pixcce is asserted
    And ctr currently holds value CTRVAL
    When a vclk rising edge occurs
    Then ctr should equal CTRVAL + 1

  @timing
  Formal Scenario: HVCounter holds raw counter when pixcce is deasserted
    Given rst_i is deasserted
    And sync is deasserted
    And pixcce is deasserted
    And ctr currently holds value CTRVAL
    When a vclk rising edge occurs
    Then ctr should remain equal to CTRVAL

  @timing
  Formal Scenario: HVCounter asserts nxt_pos strobe when position increments due to pixel replication boundary
    Given rst_i is deasserted
    And maxpix defines the maximum sub-pixel index MAXP
    And the internal sub-pixel counter reaches MAXP on this vclk cycle
    When the counter evaluates position advancement
    Then nxt_pos should be 1
    And pos should increment by 1 relative to its prior value

  @timing
  Formal Scenario: HVCounter deasserts nxt_pos strobe when sub-pixel counter has not reached maximum
    Given rst_i is deasserted
    And maxpix defines the maximum sub-pixel index MAXP
    And the internal sub-pixel counter value is below MAXP on this vclk cycle
    When the counter evaluates position advancement
    Then nxt_pos should be 0
    And pos should remain equal to its prior value

  # ---------------------------------------------------------------------
  # Region decode exclusivity
  # ---------------------------------------------------------------------

  @decode
  Formal Scenario: Only one region select is active for a given address decode
    Given rst_i is deasserted
    And cyc_i is 1 and stb_i is 1
    And adr_i carries a value that decodes to exactly one of {text, attribute, bitmap, register} windows
    When the address decode logic evaluates region selects
    Then exactly one of cs_text, cs_color, cs_rom, cs_reg should be 1
    And the remaining selects should be 0

  @decode
  Formal Scenario: Address outside all mapped windows asserts no region select
    Given rst_i is deasserted
    And cyc_i is 1 and stb_i is 1
    And adr_i carries a value outside all defined mapped windows
    When the address decode logic evaluates region selects
    Then cs_text, cs_color, cs_rom, and cs_reg should all be 0