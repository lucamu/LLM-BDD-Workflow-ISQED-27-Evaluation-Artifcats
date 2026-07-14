Feature: t6507lp CPU Core Formal Verification
  Formal specification of the t6507lp 6507-compatible CPU core, covering
  the t6507lp_fsm control sequencer, the t6507lp_alu datapath, and their
  composition through the top-level memory interface (rw_mem, data_out,
  address, data_in).

  Background:
    Given the design is clocked on the rising edge of "clk"
    And "reset_n" is an active-low asynchronous reset
    And DATA_SIZE is 8
    And ADDR_SIZE is 13
    And RESET_SEQUENCE_LENGTH is a fixed parameter equal to 7, representing
        the exact number of cycles the FSM holds in initialization sequencing
        after release of "reset_n" before entering opcode-fetch sequencing
    And "binary_result" is an auxiliary reference signal, defined in the
        verification environment, equal to the plain binary (non-BCD-adjusted)
        8-bit result of the currently selected ADC/SBC operation applied to
        accumulator value ACC and operand A with prior carry, independent of
        the state of the D flag

  # -----------------------------------------------------------------
  # Reset behavior
  # -----------------------------------------------------------------

  @reset @fsm
  Formal Scenario: Asynchronous reset forces FSM control outputs to a known state
    Given "reset_n" is deasserted (logic 0) at any time relative to "clk"
    When the next evaluation occurs
    Then "rw_mem" should be driven to its defined reset value regardless of "clk" edge
    And "address" should be driven to its defined reset value regardless of "clk" edge
    And "alu_enable" should be deasserted regardless of "clk" edge

  @reset @alu
  Formal Scenario: Asynchronous reset forces ALU architectural state to a known state
    Given "reset_n" is deasserted (logic 0) at any time relative to "clk"
    When the next evaluation occurs
    Then "alu_result" should be driven to its defined reset value regardless of "clk" edge
    And "alu_status" should be driven to its defined reset value regardless of "clk" edge
    And "alu_x" should be driven to its defined reset value regardless of "clk" edge
    And "alu_y" should be driven to its defined reset value regardless of "clk" edge

  @reset @startup
  Formal Scenario: Startup sequencing holds core before normal fetch flow for a fixed bound of cycles
    Given "reset_n" is asserted (logic 1) after being deasserted
    And RESET_SEQUENCE_LENGTH is the fixed bound on initialization-hold cycles
    When cycle count K elapses after release of "reset_n", for all K such that 0 <= K < RESET_SEQUENCE_LENGTH
    Then the FSM should remain in an initialization sequence at every cycle K in that range
    And the FSM should enter opcode-fetch sequencing for the first time exactly at cycle K equal to RESET_SEQUENCE_LENGTH

  # -----------------------------------------------------------------
  # Top-level memory interface semantics
  # -----------------------------------------------------------------

  @interface @read
  Formal Scenario: Read phase drives rw_mem low and consumes data_in
    Given "reset_n" is asserted (logic 1)
    And the FSM is in any read-type micro-sequence stage
    When a rising edge of "clk" occurs
    Then "rw_mem" should equal 0
    And "data_in" value present at that cycle should be consumed by the current micro-sequence stage

  @interface @write
  Formal Scenario: Write phase drives rw_mem high and drives data_out from internal state
    Given "reset_n" is asserted (logic 1)
    And the FSM is in any write-type micro-sequence stage with internal write value W
    When a rising edge of "clk" occurs
    Then "rw_mem" should equal 1
    And "data_out" should equal W

  @interface @address
  Formal Scenario: Address output is a function of the current FSM sequencing stage
    Given "reset_n" is asserted (logic 1)
    And the FSM computed target address value ADDR for the current micro-sequence stage
    When a rising edge of "clk" occurs
    Then "address" should equal ADDR

  # -----------------------------------------------------------------
  # FSM to ALU control coupling
  # -----------------------------------------------------------------

  @coupling @alu_control
  Formal Scenario: FSM drives ALU control signals consistent with decoded operation
    Given "reset_n" is asserted (logic 1)
    And the FSM has decoded an operation class with opcode value OPC and operand value OPA
    When a rising edge of "clk" occurs
    Then "alu_opcode" should equal OPC
    And "alu_a" should equal OPA

  @coupling @alu_enable
  Formal Scenario: ALU enable asserted only during execute stage of an operation
    Given "reset_n" is asserted (logic 1)
    And the FSM is in an ALU-execute micro-sequence stage
    When a rising edge of "clk" occurs
    Then "alu_enable" should equal 1

  @coupling @alu_enable_gate
  Formal Scenario: ALU enable deasserted outside execute stage
    Given "reset_n" is asserted (logic 1)
    And the FSM is not in an ALU-execute micro-sequence stage
    When a rising edge of "clk" occurs
    Then "alu_enable" should equal 0

  @coupling @feedback_data
  Formal Scenario: FSM data-out and address computation at the next cycle equal the prior ALU result for a store/write-back stage
    Given "reset_n" is asserted (logic 1)
    And the ALU produced result value R at cycle T with "alu_enable" equal to 1
    And the FSM's micro-sequence stage at cycle T+1 is a store-class or write-back stage targeting address ADDR
    When a rising edge of "clk" occurs at cycle T+1
    Then "data_out" at cycle T+1 should equal R
    And "address" at cycle T+1 should equal ADDR
    And "rw_mem" at cycle T+1 should equal 1

  @coupling @feedback_status
  Formal Scenario: FSM branch/flag-dependent decision at the next cycle equals an explicit function of prior ALU status
    Given "reset_n" is asserted (logic 1)
    And the ALU produced status value S at cycle T with "alu_enable" equal to 1
    And the FSM's decoded instruction at cycle T+1 is a relative-branch opcode with condition function COND evaluated over S
    When a rising edge of "clk" occurs at cycle T+1
    Then the branch-taken decision signal computed by the FSM at cycle T+1 should equal COND(S)

  # -----------------------------------------------------------------
  # ALU arithmetic / logic / status-flag semantics
  # -----------------------------------------------------------------

  @alu @commit
  Formal Scenario: ALU commits result and flags only when alu_enable is asserted
    Given "reset_n" is asserted (logic 1)
    And "alu_enable" equals 0 for operand A and opcode OPC
    When a rising edge of "clk" occurs
    Then "alu_result" should retain its previous value
    And "alu_status" should retain its previous value

  @alu @zero_flag
  Formal Scenario: Zero flag reflects a zero-valued ALU result
    Given "reset_n" is asserted (logic 1)
    And "alu_enable" equals 1
    And the ALU computes result value RES from operand A and opcode OPC
    When a rising edge of "clk" occurs
    Then the Z bit of "alu_status" should equal 1 if RES equals 0
    And the Z bit of "alu_status" should equal 0 if RES does not equal 0

  @alu @negative_flag
  Formal Scenario: Negative flag reflects bit 7 of the ALU result
    Given "reset_n" is asserted (logic 1)
    And "alu_enable" equals 1
    And the ALU computes result value RES from operand A and opcode OPC
    When a rising edge of "clk" occurs
    Then the N bit of "alu_status" should equal bit 7 of RES

  @alu @carry_flag
  Formal Scenario: Carry flag reflects arithmetic carry-out for add-class operations
    Given "reset_n" is asserted (logic 1)
    And "alu_enable" equals 1
    And opcode OPC selects an add-class (ADC) operation with operand A and accumulator value ACC
    When a rising edge of "clk" occurs
    Then the C bit of "alu_status" should equal 1 if the unsigned sum of ACC, A, and prior carry exceeds 8'hFF
    And "alu_result" should equal the truncated 8-bit sum of ACC, A, and prior carry

  @alu @overflow_flag
  Formal Scenario: Overflow flag reflects signed overflow for ADC/SBC operations
    Given "reset_n" is asserted (logic 1)
    And "alu_enable" equals 1
    And opcode OPC selects an ADC or SBC operation with operand A and accumulator value ACC
    When a rising edge of "clk" occurs
    Then the V bit of "alu_status" should equal 1 if the signed result of the operation on ACC and A exceeds the signed 8-bit range
    And the V bit of "alu_status" should equal 0 otherwise

  @alu @status_bit5
  Formal Scenario: Status register bit 5 is always held high
    Given "reset_n" is asserted (logic 1)
    And "alu_enable" equals 1
    And any opcode OPC and operand A are applied
    When a rising edge of "clk" occurs
    Then bit 5 of "alu_status" should equal 1

  @alu @compare
  Formal Scenario: Compare operation sets flags without altering register value
    Given "reset_n" is asserted (logic 1)
    And "alu_enable" equals 1
    And opcode OPC selects a compare-class operation between register value REG and operand A
    When a rising edge of "clk" occurs
    Then the C bit of "alu_status" should equal 1 if REG is greater than or equal to A
    And the Z bit of "alu_status" should equal 1 if REG equals A
    And the N bit of "alu_status" should equal bit 7 of the subtraction result of REG minus A
    And the architectural register REG should retain its previous value

  @alu @shift_rotate
  Formal Scenario: Shift/rotate operation updates carry from the shifted-out bit
    Given "reset_n" is asserted (logic 1)
    And "alu_enable" equals 1
    And opcode OPC selects a shift-class or rotate-class operation on operand A with prior carry C_IN
    When a rising edge of "clk" occurs
    Then the C bit of "alu_status" should equal the bit shifted out of A
    And "alu_result" should equal the shifted or rotated value of A combined with C_IN where applicable

  @alu @load_store
  Formal Scenario: Load-class operation transfers operand into architectural register without flag side effects beyond Z and N
    Given "reset_n" is asserted (logic 1)
    And "alu_enable" equals 1
    And opcode OPC selects a load-class transfer of operand value A into a target register
    When a rising edge of "clk" occurs
    Then the target architectural register should equal A
    And the Z bit of "alu_status" should equal 1 if A equals 0
    And the N bit of "alu_status" should equal bit 7 of A
    And the C bit and V bit of "alu_status" should retain their previous values

  @alu @flag_set_clear
  Formal Scenario: Flag-set and flag-clear class operations affect only the targeted status bit
    Given "reset_n" is asserted (logic 1)
    And "alu_enable" equals 1
    And opcode OPC selects a flag-set or flag-clear class operation targeting status bit F
    When a rising edge of "clk" occurs
    Then the targeted status bit F of "alu_status" should equal the operation's defined set/clear value
    And all other bits of "alu_status" except bit F should retain their previous values

  @alu @decimal_mode
  Formal Scenario: Decimal-mode adjustment applies to ADC/SBC when D flag is set
    Given "reset_n" is asserted (logic 1)
    And "alu_enable" equals 1
    And the D bit of the prior "alu_status" equals 1
    And opcode OPC selects an ADC or SBC operation with operand A and accumulator value ACC
    And "binary_result" equals the plain binary (non-BCD-adjusted) result of the operation on ACC and A
    When a rising edge of "clk" occurs
    Then "alu_result" should equal the BCD-adjusted result of the operation on ACC and A
    And "alu_result" should differ from "binary_result" whenever a nibble correction is required
    And "alu_result" should equal "binary_result" whenever no nibble correction is required

  @alu @decimal_mode_disabled
  Formal Scenario: Binary arithmetic applies to ADC/SBC when D flag is clear
    Given "reset_n" is asserted (logic 1)
    And "alu_enable" equals 1
    And the D bit of the prior "alu_status" equals 0
    And opcode OPC selects an ADC or SBC operation with operand A and accumulator value ACC
    And "binary_result" equals the plain binary (non-BCD-adjusted) result of the operation on ACC and A
    When a rising edge of "clk" occurs
    Then "alu_result" should equal "binary_result"

  # -----------------------------------------------------------------
  # Addressing-mode and instruction-class sequencing
  # -----------------------------------------------------------------

  @addressing @immediate
  Formal Scenario: Immediate addressing supplies the fetched operand directly as ALU operand
    Given "reset_n" is asserted (logic 1)
    And the decoded instruction uses immediate addressing with fetched operand value OPRND
    When the FSM reaches the execute micro-sequence stage
    Then "alu_a" should equal OPRND

  @addressing @zero_page
  Formal Scenario: Zero-page addressing forms an 8-bit address with zero-extended upper bits
    Given "reset_n" is asserted (logic 1)
    And the decoded instruction uses zero-page addressing with fetched low-byte value ZP
    When the FSM reaches the operand-fetch micro-sequence stage
    Then "address" should equal the zero-extended value of ZP

  @addressing @zero_page_indexed
  Formal Scenario: Zero-page indexed addressing wraps within the zero page
    Given "reset_n" is asserted (logic 1)
    And the decoded instruction uses zero-page indexed addressing with base ZP and index value IDX
    When the FSM reaches the operand-fetch micro-sequence stage
    Then "address" should equal the zero-extended value of the 8-bit truncated sum of ZP and IDX

  @addressing @absolute
  Formal Scenario: Absolute addressing forms a 16-bit address from two fetched bytes
    Given "reset_n" is asserted (logic 1)
    And the decoded instruction uses absolute addressing with fetched low byte LO and high byte HI
    When the FSM reaches the operand-fetch micro-sequence stage
    Then "address" should equal the concatenation of HI and LO truncated to ADDR_SIZE bits

  @addressing @absolute_indexed
  Formal Scenario: Absolute indexed addressing adds an index register to the base address
    Given "reset_n" is asserted (logic 1)
    And the decoded instruction uses absolute indexed addressing with base address BASE and index value IDX
    When the FSM reaches the operand-fetch micro-sequence stage
    Then "address" should equal BASE plus IDX truncated to ADDR_SIZE bits

  @addressing @indexed_indirect
  Formal Scenario: Indexed-indirect addressing resolves a pointer from zero page before final address use
    Given "reset_n" is asserted (logic 1)
    And the decoded instruction uses indexed-indirect addressing with zero-page base ZP, index value IDX, and pointer bytes PTR_LO and PTR_HI fetched from that computed zero-page location
    When the FSM reaches the final operand-address micro-sequence stage
    Then "address" should equal the concatenation of PTR_HI and PTR_LO truncated to ADDR_SIZE bits

  @addressing @indirect_indexed
  Formal Scenario: Indirect-indexed addressing adds Y register after pointer resolution
    Given "reset_n" is asserted (logic 1)
    And the decoded instruction uses indirect-indexed addressing with zero-page pointer ZP producing base address PTR and Y register value Y
    When the FSM reaches the final operand-address micro-sequence stage
    Then "address" should equal PTR plus Y truncated to ADDR_SIZE bits

  @instruction_class @rmw
  Formal Scenario: Read-modify-write sequence executes read then ALU transform then write-back
    Given "reset_n" is asserted (logic 1)
    And the decoded instruction is a read-modify-write class operation targeting address ADDR with memory value VAL
    When the FSM completes its read stage at ADDR
    Then the FSM should transition to an ALU-transform stage using VAL as "alu_a"
    And after the ALU-transform stage completes, the FSM should transition to a write-back stage
    And during the write-back stage "rw_mem" should equal 1 and "address" should equal ADDR and "data_out" should equal "alu_result"

  # -----------------------------------------------------------------
  # Branch, jump, and stack sequencing
  # -----------------------------------------------------------------

  @branch @taken
  Formal Scenario: Relative branch is taken when the decoded condition on status flags holds
    Given "reset_n" is asserted (logic 1)
    And the decoded instruction is a relative-branch opcode with condition function COND over prior "alu_status"
    And the fetched relative offset value OFFSET and current program-counter value PC
    When COND evaluated on prior "alu_status" equals 1
    Then the FSM should compute the next program-counter target as PC plus the sign-extended OFFSET

  @branch @not_taken
  Formal Scenario: Relative branch is not taken when the decoded condition on status flags fails
    Given "reset_n" is asserted (logic 1)
    And the decoded instruction is a relative-branch opcode with condition function COND over prior "alu_status"
    And current program-counter value PC
    When COND evaluated on prior "alu_status" equals 0
    Then the FSM should proceed to fetch the instruction at PC without adding the offset

  @branch @page_crossing
  Formal Scenario: Branch page-crossing invokes an additional address-fix cycle
    Given "reset_n" is asserted (logic 1)
    And a taken relative branch produces an intermediate address INTERM whose high byte differs from the high byte of the base program counter PC
    When the FSM detects this page-crossing condition
    Then the FSM should insert an extra address-fix micro-sequence stage before resuming fetch
    And the final "address" after the fix stage should equal PC plus the sign-extended offset

  @jump @absolute
  Formal Scenario: Absolute jump loads the program counter with the fetched target address
    Given "reset_n" is asserted (logic 1)
    And the decoded instruction is an absolute JMP with fetched low byte LO and high byte HI
    When the FSM completes the jump target-fetch micro-sequence stage
    Then the next instruction fetch "address" should equal the concatenation of HI and LO truncated to ADDR_SIZE bits

  @jump @indirect
  Formal Scenario: Indirect jump loads the program counter from the pointer-resolved address
    Given "reset_n" is asserted (logic 1)
    And the decoded instruction is an indirect JMP with pointer address PTR and target bytes TARGET_LO and TARGET_HI read from PTR and PTR+1
    When the FSM completes the indirect-resolution micro-sequence stage
    Then the next instruction fetch "address" should equal the concatenation of TARGET_HI and TARGET_LO truncated to ADDR_SIZE bits

  @stack @push
  Formal Scenario: Push sequence writes to the stack-pointer address and decrements it
    Given "reset_n" is asserted (logic 1)
    And the current stack pointer value SP and value V to be pushed
    When the FSM executes a push micro-sequence stage
    Then "address" should equal the stack-page-offset concatenation with SP
    And "rw_mem" should equal 1
    And "data_out" should equal V
    And the internal stack pointer should update to SP minus 1 after the stage completes

  @stack @pull
  Formal Scenario: Pull sequence reads from the incremented stack-pointer address
    Given "reset_n" is asserted (logic 1)
    And the current stack pointer value SP
    When the FSM executes a pull micro-sequence stage
    Then the internal stack pointer should first update to SP plus 1
    And "address" should equal the stack-page-offset concatenation with the updated stack pointer
    And "rw_mem" should equal 0

  @stack @subroutine
  Formal Scenario: Subroutine call pushes return address before jumping to target
    Given "reset_n" is asserted (logic 1)
    And the decoded instruction is JSR with target address TARGET and current program-counter value PC
    When the FSM executes the JSR micro-sequence
    Then the return address derived from PC should be pushed onto the stack across two push stages
    And the next instruction fetch "address" should equal TARGET after the JSR sequence completes

  @stack @return
  Formal Scenario: Return-from-subroutine sequence pulls the return address and resumes fetch there
    Given "reset_n" is asserted (logic 1)
    And the decoded instruction is RTS with stacked return-address bytes RET_LO and RET_HI
    When the FSM completes the RTS pull micro-sequence
    Then the next instruction fetch "address" should equal the concatenation of RET_HI and RET_LO truncated to ADDR_SIZE bits

  @stack @break_return
  Formal Scenario: Break/return sequence performs vector-read style sequencing and status restoration
    Given "reset_n" is asserted (logic 1)
    And the decoded instruction is a BRK/RTI-class instruction with stacked status value STAT and stacked return-address bytes RET_LO and RET_HI
    When the FSM completes the corresponding pull or vector-read micro-sequence
    Then "alu_status" should be updated to reflect STAT for an RTI-class sequence
    And the next instruction fetch "address" should be derived from the vector-read or RET_HI/RET_LO bytes as applicable

  # -----------------------------------------------------------------
  # Invalid opcode handling
  # -----------------------------------------------------------------

  @invalid_opcode
  Formal Scenario: Undecoded opcode redirects control back to fetch sequencing
    Given "reset_n" is asserted (logic 1)
    And the fetched instruction register value OPC does not match any opcode entry in the implemented decode set
    When the FSM evaluates decode for OPC
    Then the FSM should transition to the opcode-fetch micro-sequence stage
    And "alu_enable" should equal 0 for that transition
    And no write-type "rw_mem" assertion should occur as a result of decoding OPC