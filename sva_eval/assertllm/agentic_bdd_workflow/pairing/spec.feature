Feature: Tiny Tate Bilinear Pairing Core - Formal Verification Specification
  Formal properties for the Tiny Tate Bilinear Pairing Core covering the
  synchronous interface (clk, reset, sel, addr, w, update, ready, i, o, done),
  the internal RAM read/write protocol, the control-unit finite state machine,
  and the processing-element control word semantics.

  Background:
    Given a synchronous design clocked on the rising edge of clk
    And an active-high synchronous reset signal
    And a 64-word by 198-bit dual-port RAM
    And a 6-bit RAM address bus addr
    And a serial input signal i and a serial output signal o
    And control signals sel, w, update, ready, and done
    And the control unit exposes an internal state signal fsm_state with
      possible values START, READ_SRC1, READ_SRC2, CALC, WAIT, WRITE, DONE
    And the control unit exposes an internal signal need_src2, derived from
      the OP field of the current instruction fetched from the ROM, which is
      asserted when the current instruction requires a second operand
    And the control unit exposes an internal signal more_instr, derived from
      comparing the instruction pointer against the last valid instruction
      address in the ROM, which is asserted when there are remaining
      instructions to execute
    And the RAM exposes an internal constant output_addr identifying the
      fixed memory address whose contents are serialized onto o
    And the processing element exposes internal registers R0, R1, R2 and
      internal output signals add_sub_out, cubic_out, mult_out, and
      pe_result_valid, all sampled at the rising edge of clk
    And the control unit issues arithmetic-type selector signals
      op_add_sub, op_cubic, and op_mult that determine which of
      add_sub_out, cubic_out, mult_out is driven by the processing element
    And o is unconstrained (don't-care) whenever done is 0; no assertion is
      made about its value under this condition, and any formal environment
      assumption to that effect is documented here rather than checked

  # ---------------------------------------------------------------------
  # Reset behavior
  # ---------------------------------------------------------------------

  @reset @done
  Formal Scenario: Reset forces done inactive
    Given reset is asserted at the current clock cycle
    When the next rising clock edge occurs
    Then done should be 0

  @reset @fsm
  Formal Scenario: Reset forces control unit into START state
    Given reset is asserted at the current clock cycle
    When the next rising clock edge occurs
    Then fsm_state should be START

  @reset @done
  Formal Scenario: Done remains inactive while reset is held
    Given reset is asserted for at least one clock cycle
    When reset remains asserted at every subsequent rising clock edge
    Then done should remain 0 at every one of those cycles

  # ---------------------------------------------------------------------
  # done signal stability
  # ---------------------------------------------------------------------

  @done @stability
  Formal Scenario: Done stays asserted once the computation completes until next reset
    Given reset is deasserted
    And done becomes 1 at some clock cycle
    When reset is not asserted at any later clock cycle
    Then done should remain 1 at every later clock cycle

  # ---------------------------------------------------------------------
  # RAM write / read protocol (external interface)
  # ---------------------------------------------------------------------

  @ram @write
  Formal Scenario: A serial write to RAM address A with value V is accepted only when ready is asserted
    Given sel is 1
    And w is 1
    And addr equals address A
    And ready is 1 at the current clock cycle
    When update is asserted after the serial value V has been shifted in through i
    Then the RAM word at address A should equal V after the write completes

  @ram @write
  Formal Scenario: Writes to RAM are ignored while ready is deasserted
    Given sel is 1
    And w is 1
    And addr equals address A
    And ready is 0 at the current clock cycle
    When update is asserted at this same cycle
    Then the RAM word at address A should remain unchanged

  @ram @read
  Formal Scenario: A read from RAM address A returns the value previously written to A
    Given the RAM word at address A equals value V
    And sel is 1
    And w is 0
    And addr equals address A
    And ready is 1
    When update is asserted to trigger the serial read
    Then the serial output o should eventually produce the bits of V corresponding to address A

  @ram @read
  Formal Scenario: Reading from RAM does not modify the stored value
    Given the RAM word at address A equals value V
    And sel is 1
    And w is 0
    And addr equals address A
    And ready is 1
    When a complete read transaction of address A occurs
    Then the RAM word at address A should still equal V after the transaction

  @ram @isolation
  Formal Scenario: Writing to one RAM address does not affect a different address
    Given the RAM word at address B equals value W
    And address A is different from address B
    And sel is 1
    And w is 1
    And addr equals address A
    And ready is 1
    When a complete write transaction of value V to address A occurs
    Then the RAM word at address B should still equal W

  @ram @external_access
  Formal Scenario: External RAM access requires sel asserted
    Given sel is 0
    When update is asserted at the current clock cycle
    Then no RAM word should be written or read as a result of this cycle

  @ram @stability
  Formal Scenario: RAM address must remain stable throughout a single write transaction
    Given sel is 1
    And w is 1
    And addr equals address A at the start of a write transaction
    And ready is 1
    When addr changes to a different address before update completes the transaction
    Then the RAM word at address A should not be updated with the partially shifted value
    And the RAM word at the new address should not be corrupted by data intended for A

  @ram @stability
  Formal Scenario: RAM address must remain stable throughout a single read transaction
    Given sel is 1
    And w is 0
    And addr equals address A at the start of a read transaction
    And ready is 1
    When addr changes to a different address before the read transaction completes
    Then the serial output o should not mix bits from address A and the new address

  # ---------------------------------------------------------------------
  # Control unit FSM
  # ---------------------------------------------------------------------

  @fsm @transition
  Formal Scenario: START state always transitions to READ_SRC1
    Given fsm_state is START
    When the next rising clock edge occurs
    Then fsm_state should be READ_SRC1

  @fsm @transition
  Formal Scenario: READ_SRC1 transitions to READ_SRC2 when a second operand is required
    Given fsm_state is READ_SRC1
    And need_src2 is 1
    When the next rising clock edge occurs
    Then fsm_state should be READ_SRC2

  @fsm @transition
  Formal Scenario: READ_SRC1 transitions to CALC when no second operand is required
    Given fsm_state is READ_SRC1
    And need_src2 is 0
    And more_instr is 1
    When the next rising clock edge occurs
    Then fsm_state should be CALC

  @fsm @transition
  Formal Scenario: CALC transitions to WAIT while the arithmetic operation is in progress
    Given fsm_state is CALC
    When the next rising clock edge occurs
    Then fsm_state should be WAIT

  @fsm @transition
  Formal Scenario: WAIT transitions to WRITE once the arithmetic result is ready
    Given fsm_state is WAIT
    And pe_result_valid is 1
    When the next rising clock edge occurs
    Then fsm_state should be WRITE

  @fsm @transition
  Formal Scenario: WRITE transitions back to READ_SRC1 to process the next instruction
    Given fsm_state is WRITE
    And more_instr is 1
    When the next rising clock edge occurs
    Then fsm_state should be READ_SRC1

  @fsm @transition
  Formal Scenario: READ_SRC1 transitions to DONE when the instruction sequence is complete
    Given fsm_state is READ_SRC1
    And more_instr is 0
    When the next rising clock edge occurs
    Then fsm_state should be DONE
    And done should be 1

  # ---------------------------------------------------------------------
  # Processing element control word semantics
  # ---------------------------------------------------------------------

  @pe @control_word
  Formal Scenario: Add/subtract control word asserts exactly the add/sub function
    Given op_add_sub is 1
    And op_cubic is 0
    And op_mult is 0
    And the operands are loaded into R0 and R1
    When the processing element executes this control word at the rising clock edge
    Then add_sub_out should equal the sum or difference of R0 and R1
    And cubic_out should not be asserted
    And mult_out should not be asserted

  @pe @control_word
  Formal Scenario: Cubic control word asserts exactly the cubic function
    Given op_add_sub is 0
    And op_cubic is 1
    And op_mult is 0
    And the operand is loaded into R2
    When the processing element executes this control word at the rising clock edge
    Then cubic_out should equal R2 cubed
    And add_sub_out should not be asserted
    And mult_out should not be asserted

  @pe @control_word
  Formal Scenario: Multiply control word asserts exactly the multiply function
    Given op_add_sub is 0
    And op_cubic is 0
    And op_mult is 1
    And the operands are loaded into R1 and R2
    When the processing element executes this control word at the rising clock edge
    Then mult_out should equal the product of R1 and R2
    And add_sub_out should not be asserted
    And cubic_out should not be asserted

  @pe @control_word @mutex
  Formal Scenario: Processing element control word is mutually exclusive per operation
    Given exactly one of op_add_sub, op_cubic, op_mult is asserted by the control unit
    When the processing element latches this control word at the rising clock edge
    Then exactly one of add_sub_out, cubic_out, or mult_out should be asserted in that cycle

  # ---------------------------------------------------------------------
  # Serial output stability
  # ---------------------------------------------------------------------

  @interface @serial
  Formal Scenario: Serial output o is stable when done is not newly asserted
    Given done is 1 at the current clock cycle
    And no new write transaction to output_addr occurs
    When the next rising clock edge occurs with done still 1
    Then o should hold the same value as the previous cycle