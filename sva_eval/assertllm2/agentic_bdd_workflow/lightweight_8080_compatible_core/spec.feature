Feature: light8080 CPU Core Formal Verification

  As a hardware verification engineer
  I want to formally verify the light8080 CPU core
  So that its synchronous bus protocol, interrupt handling, halt behavior,
  and microcode-controlled execution semantics are correct

  Background:
    Given a synchronous design clocked by "clk"
    And an active-high synchronous reset signal "reset"
    And all outputs "addr_out", "vma", "io", "rd", "wr", "fetch", "data_out", "inta", "inte", "halt" are registered and update only on the rising edge of "clk"
    And the input "data_in" is an 8-bit value
    And the input "intr" is a 1-bit interrupt request
    And reset is sampled synchronously on the rising edge of "clk"
    And the internal microcode state signal "mc_state" encodes the current control-path stage using the concrete values "RESET_SEQ", "FETCH_ENTRY", "OPERAND_STAGE", "ALU_STAGE", "DECODE", "INTA_SEQ", and "HALT_LOOP"
    And the internal 9-bit microcode address register "mc_addr" drives the "uc_addr" input of the "micro_rom" submodule
    And the internal operand registers "T1" and "T2" hold ALU operand values loaded during "mc_state == OPERAND_STAGE"

  # -----------------------------------------------------------------
  # RESET BEHAVIOR
  # -----------------------------------------------------------------

  @reset
  Formal Scenario: Reset forces halt output low
    Given "reset" is asserted at the current clock edge
    When the clock advances one rising edge
    Then "halt" should be 0

  @reset
  Formal Scenario: Reset forces interrupt-acknowledge output low
    Given "reset" is asserted at the current clock edge
    When the clock advances one rising edge
    Then "inta" should be 0

  @reset
  Formal Scenario: Reset forces interrupt-enable output low
    Given "reset" is asserted at the current clock edge
    When the clock advances one rising edge
    Then "inte" should be 0

  @reset
  Formal Scenario: Reset initializes the microcode state to the reset sequence entry point
    Given "reset" is asserted at the current clock edge
    When the clock advances one rising edge
    Then "mc_state" should equal "RESET_SEQ"

  @reset
  Formal Scenario: First fetch after reset targets address zero
    Given "reset" is asserted at the current clock edge
    And "reset" is deasserted on all subsequent clock edges until the first fetch cycle
    When "mc_state" transitions from "RESET_SEQ" to "FETCH_ENTRY" and the core performs its first opcode fetch
    Then "addr_out" during that fetch cycle should equal 16'h0000
    And "fetch" should be 1 during that cycle
    And "vma" should be 1 during that cycle
    And "rd" should be 1 during that cycle
    And "wr" should be 0 during that cycle
    And "io" should be 0 during that cycle

  # -----------------------------------------------------------------
  # BUS PROTOCOL SEMANTICS
  # -----------------------------------------------------------------

  @bus
  Formal Scenario: Read and write are mutually exclusive when vma is active
    Given "vma" is 1 at the current clock edge
    Then "rd" and "wr" should not both be 1 at the same cycle

  @bus
  Formal Scenario: Address bus high byte is driven from register bank during any active access
    Given "vma" is 1 at the current clock edge
    And the register bank high-byte source value is register value H
    Then the upper 8 bits of "addr_out" should equal H

  @bus
  Formal Scenario: Address bus low byte is driven from the internal low-address latch during any active access
    Given "vma" is 1 at the current clock edge
    And the internal low-address latch value is L
    Then the lower 8 bits of "addr_out" should equal L

  @bus
  Formal Scenario: data_out is only meaningful during a write cycle
    Given "vma" is 1 at the current clock edge
    And "wr" is 1 at the current clock edge
    And the output data register value is value D
    Then "data_out" should equal D

  @bus
  Formal Scenario: data_in is sampled only during a qualified read cycle
    Given "vma" is 1 at the current clock edge
    And "rd" is 1 at the current clock edge
    And "data_in" presents value V during the read completion phase
    Then the value latched by the core for that transfer should equal V

  # -----------------------------------------------------------------
  # FETCH AND PC UPDATE BEHAVIOR
  # -----------------------------------------------------------------

  @fetch
  Formal Scenario: Fetch cycle always issues a memory read
    Given "fetch" is 1 at the current clock edge
    Then "vma" should be 1 during that cycle
    And "io" should be 0 during that cycle
    And "rd" should be 1 during that cycle
    And "wr" should be 0 during that cycle

  @fetch
  Formal Scenario: Normal fetch places current PC value on the address bus
    Given "mc_state" is not equal to "INTA_SEQ"
    And "fetch" is 1 at the current clock edge
    And the program counter register value is PC
    Then "addr_out" during that fetch cycle should equal PC

  @fetch
  Formal Scenario: PC advances after a normal opcode fetch completes
    Given "mc_state" is not equal to "INTA_SEQ"
    And "fetch" is 1 at the current clock edge
    And the program counter register value before the fetch is PC
    When "mc_state" advances from "FETCH_ENTRY" through "OPERAND_STAGE" to "ALU_STAGE" and the fetch microinstruction completes normally
    Then the program counter register value after completion should equal PC + 1

  # -----------------------------------------------------------------
  # INTERRUPT ACKNOWLEDGE (INTA) BEHAVIOR
  # -----------------------------------------------------------------

  @interrupt
  Formal Scenario: Interrupt acknowledge asserts inta throughout the acknowledged instruction flow
    Given "inte" is 1 at the current clock edge
    And "intr" is asserted at an instruction boundary
    When "mc_state" transitions to "INTA_SEQ"
    Then "inta" should be 1 for every cycle while "mc_state == INTA_SEQ"
    And "inta" should return to 0 only after "mc_state" leaves "INTA_SEQ"

  @interrupt
  Formal Scenario: PC auto-increment is inhibited during interrupt-acknowledge fetch
    Given "mc_state" equals "INTA_SEQ"
    And "inta" is 1 at the current clock edge
    And "fetch" is 1 at the current clock edge
    And the program counter register value before the cycle is PC
    When the "INTA_SEQ" fetch microinstruction completes
    Then the program counter register value after completion should equal PC

  @interrupt
  Formal Scenario: Explicit control-flow instructions determine PC update during INTA-driven execution
    Given "mc_state" equals "INTA_SEQ"
    And "inta" is 1 at the current clock edge
    And the fetched interrupt-vector opcode is OPC
    And the program counter register value before execution is PC
    When that opcode's microinstruction routine executes through "OPERAND_STAGE" and "ALU_STAGE" to completion
    Then if OPC is a jump-class, call-class, or return-class opcode, the program counter register value after completion should equal the decoded target address of OPC
    And if OPC is not a jump-class, call-class, or return-class opcode, the program counter register value after completion should equal PC
    And this conditional equality is independent of the PC auto-increment inhibition rule applied to the interrupt-acknowledge fetch itself

  @interrupt
  Formal Scenario: Interrupts are disabled upon interrupt service entry
    Given "inte" is 1 at the current clock edge
    And "intr" is asserted at an instruction boundary
    When "mc_state" transitions to "INTA_SEQ"
    Then "inte" should become 0 at the cycle "mc_state" first equals "INTA_SEQ"
    And "inte" should remain 0 until explicitly re-enabled by subsequent instruction flow

  @interrupt
  Formal Scenario: Interrupt is not serviced when interrupts are disabled
    Given "inte" is 0 at the current clock edge
    And "intr" is asserted at an instruction boundary
    Then "mc_state" should not transition to "INTA_SEQ"
    And "inta" should remain 0

  @interrupt
  Formal Scenario: Interrupt servicing occurs only at instruction boundaries
    Given "intr" is asserted while "mc_state" is within "OPERAND_STAGE" or "ALU_STAGE" of a multicycle instruction, not at an instruction boundary
    And "inte" is 1
    Then "mc_state" should not transition to "INTA_SEQ" before the current instruction's final "ALU_STAGE" cycle
    And "inta" should remain 0 until the instruction boundary is reached

  # -----------------------------------------------------------------
  # HALT BEHAVIOR
  # -----------------------------------------------------------------

  @halt
  Formal Scenario: Halt output asserted upon entering halt microcode loop
    Given the core executes a HALT-class opcode to completion
    When "mc_state" transitions to "HALT_LOOP"
    Then "halt" should be 1 for every subsequent cycle while "mc_state == HALT_LOOP"

  @halt
  Formal Scenario: Halt exits on reset
    Given "mc_state" equals "HALT_LOOP"
    And "halt" is 1 at the current clock edge
    And "reset" is asserted at the current clock edge
    When the clock advances one rising edge
    Then "halt" should be 0
    And "mc_state" should equal "RESET_SEQ"

  @halt
  Formal Scenario: Halt exits on qualifying interrupt service condition
    Given "mc_state" equals "HALT_LOOP"
    And "halt" is 1 at the current clock edge
    And "inte" is 1 at the current clock edge
    And "intr" is asserted at the current clock edge
    When the core samples the interrupt request while "mc_state == HALT_LOOP"
    Then "mc_state" should transition away from "HALT_LOOP" to "INTA_SEQ"
    And "halt" should become 0 as "mc_state" enters "INTA_SEQ"

  @halt
  Formal Scenario: Halt persists while no exit condition is present
    Given "mc_state" equals "HALT_LOOP"
    And "halt" is 1 at the current clock edge
    And "reset" is 0 at the current clock edge
    And not ("inte" is 1 and "intr" is asserted)
    When the clock advances one rising edge
    Then "halt" should remain 1
    And "mc_state" should remain equal to "HALT_LOOP"

  # -----------------------------------------------------------------
  # ALU AND FLAG SEMANTICS
  # -----------------------------------------------------------------

  @flags
  Formal Scenario: Zero flag reflects ALU result value
    Given "mc_state" equals "ALU_STAGE" and the ALU computes a result value R for the current microinstruction
    And the microinstruction flag-pattern field enables non-carry flag update
    When "mc_state == ALU_STAGE" completes
    Then the zero flag should be 1 if R equals 0
    And the zero flag should be 0 if R does not equal 0

  @flags
  Formal Scenario: Carry flag update is gated by the microinstruction flag-pattern field
    Given "mc_state" equals "ALU_STAGE" and an arithmetic ALU operation produces a carry-out value C
    And the microinstruction flag-pattern field enables carry-group flag update
    When "mc_state == ALU_STAGE" completes
    Then the carry flag should equal C

  @flags
  Formal Scenario: Carry flag is not modified when carry-group update is not enabled
    Given "mc_state" equals "ALU_STAGE" and an arithmetic ALU operation produces a carry-out value C
    And the microinstruction flag-pattern field does not enable carry-group flag update
    And the carry flag value before the operation is F
    When "mc_state == ALU_STAGE" completes
    Then the carry flag should remain equal to F

  @flags
  Formal Scenario: ALU operand registers are loaded before ALU stage computation
    Given "mc_state" equals "OPERAND_STAGE" and operand value A is loaded into register "T1"
    And "mc_state" equals "OPERAND_STAGE" and operand value B is loaded into register "T2"
    When "mc_state" advances to "ALU_STAGE" for the following cycle
    Then the ALU computation for that microinstruction should use "T1 == A" and "T2 == B"

  # Note: the AC generation rule below (AC' = T1[3] | T2[3]) is the implemented
  # 8085-style AND-class auxiliary-carry behavior and is a documented, known
  # deviation from strict original 8080 AC semantics. This explanatory context
  # is informational only and is not part of the checkable formal property.
  @flags
  Formal Scenario: Auxiliary-carry update for logical AND-class operations follows explicit bit-level rule
    Given "mc_state" equals "ALU_STAGE" and a logical AND-class operation (ANI/ANA-class) executes with operand registers "T1" and "T2"
    And the microinstruction flag-pattern field enables carry-group flag update including auxiliary carry
    When "mc_state == ALU_STAGE" completes
    Then the auxiliary-carry flag should equal ("T1"[3] OR "T2"[3])

  # -----------------------------------------------------------------
  # MICROCODE SEQUENCER / PIPELINE OVERLAP
  # -----------------------------------------------------------------

  @microcode
  Formal Scenario: Second stage of a started microinstruction completes unless reset intervenes
    Given "mc_state" equals "OPERAND_STAGE" at cycle N for a given microinstruction
    And "reset" is 0 at cycle N and at cycle N+1
    When cycle N+1 occurs
    Then "mc_state" should equal "ALU_STAGE" at cycle N+1 and the write-back for that microinstruction should occur

  @microcode
  Formal Scenario: Reset aborts a pipelined microinstruction write-back
    Given "mc_state" equals "OPERAND_STAGE" at cycle N for a given microinstruction
    And "reset" is asserted at cycle N+1
    When cycle N+1 occurs
    Then "mc_state" should equal "RESET_SEQ" at cycle N+1
    And the "ALU_STAGE" write-back for that microinstruction should not be committed to architectural state

  @microcode
  Formal Scenario: Opcode decode dispatches to the corresponding micro-routine entry point
    Given "mc_state" equals "DECODE" and a fetched opcode value OPC is presented to the decode jump table
    When "mc_state == DECODE" resolves the next value of "mc_addr"
    Then "mc_addr" should equal the fixed entry point associated with opcode OPC

  @microcode
  Formal Scenario: Sequential microcode address increments when no branch condition is asserted
    Given "mc_addr" equals MADDR at the current cycle
    And no micro-subroutine call, conditional branch, or return condition is asserted for the current microinstruction
    When the clock advances one rising edge
    Then "mc_addr" should equal MADDR + 1

  @microcode
  Formal Scenario: Micro-subroutine call preserves a single-level return address
    Given the sequencer executes a JSR-class micro-branch at "mc_addr == MADDR" with return address RET
    When the corresponding return micro-instruction executes
    Then "mc_addr" should equal RET