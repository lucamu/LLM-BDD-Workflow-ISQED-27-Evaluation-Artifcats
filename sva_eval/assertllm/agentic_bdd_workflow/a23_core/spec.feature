Feature: Amber 2 Core Formal Specification
  Formal verification properties for the Amber 2 ARM v2a-compatible core,
  covering the ALU, barrel shifter, condition code evaluation, immediate
  decoding, multiplier (Booth's algorithm), register banking, pipeline
  stall behavior, and interrupt vector selection.

  Background:
    Given the design is synchronous to the rising edge of "i_clk"
    And all registers are initialized by FPGA configuration with no explicit reset logic
    And "i_system_rdy" is high unless otherwise specified
    And the core implements the ARM v2a instruction set architecture

  # ---------------------------------------------------------------------
  # ALU Functional Properties
  # ---------------------------------------------------------------------

  @alu @combinational
  Formal Scenario: ALU addition produces correct sum and carry out
    Given ALU input "a_in" holds value A
    And ALU input "b_in" holds value B
    And "cin_sel" selects a carry-in value CIN
    And "alu_function" out_sel selects the full adder output
    When the ALU evaluates its output combinationally
    Then "alu_out" should equal (A + B + CIN) truncated to 32 bits
    And the carry flag "cout" should equal the carry out of the 33-bit addition (A + B + CIN)

  @alu @combinational
  Formal Scenario: ALU subtraction implemented as addition with inverted operand
    Given ALU input "a_in" holds value A
    And ALU input "b_in" holds value B
    And "not_sel" is set to invert the B input
    And "cin_sel" selects carry-in value 1
    And "alu_function" out_sel selects the full adder output
    When the ALU evaluates its output combinationally
    Then "alu_out" should equal (A - B) truncated to 32 bits
    And the carry flag "cout" should equal 1 if A >= B else 0

  @alu @combinational
  Formal Scenario: ALU logical AND operation
    Given ALU input "a_in" holds value A
    And ALU input "b_in" holds value B
    And "alu_function" out_sel selects the AND output
    When the ALU evaluates its output combinationally
    Then "alu_out" should equal (A bitwise-AND B)

  @alu @combinational
  Formal Scenario: ALU logical OR operation
    Given ALU input "a_in" holds value A
    And ALU input "b_in" holds value B
    And "alu_function" out_sel selects the OR output
    When the ALU evaluates its output combinationally
    Then "alu_out" should equal (A bitwise-OR B)

  @alu @combinational
  Formal Scenario: ALU logical XOR operation
    Given ALU input "a_in" holds value A
    And ALU input "b_in" holds value B
    And "alu_function" out_sel selects the XOR output
    When the ALU evaluates its output combinationally
    Then "alu_out" should equal (A bitwise-XOR B)

  @alu @combinational
  Formal Scenario: ALU swap_sel exchanges operand order
    Given ALU input "a_in" holds value A
    And ALU input "b_in" holds value B
    And "swap_sel" is asserted
    And "alu_function" out_sel selects the full adder output
    And "cin_sel" selects carry-in value 0
    When the ALU evaluates its output combinationally
    Then "alu_out" should equal (B + A) truncated to 32 bits

  @alu @flags
  Formal Scenario: ALU zero flag reflects zero result
    Given ALU input "a_in" holds value A
    And ALU input "b_in" holds value B
    And the ALU produces output result R
    When the ALU evaluates its flags combinationally
    Then the zero flag "z" should equal 1 if R equals 0 else 0

  @alu @flags
  Formal Scenario: ALU negative flag reflects sign bit of result
    Given the ALU produces output result R
    When the ALU evaluates its flags combinationally
    Then the negative flag "n" should equal bit 31 of R

  @alu @flags
  Formal Scenario: ALU overflow flag for addition
    Given ALU input "a_in" holds value A
    And ALU input "b_in" holds value B
    And "alu_function" selects an addition operation with cin_sel value CIN
    And the ALU produces output result R equal to (A + B + CIN) truncated to 32 bits
    When the ALU evaluates its overflow flag combinationally
    Then the overflow flag "v" should equal 1 if the sign of A equals the sign of B and the sign of R differs from the sign of A else 0

  @alu @not_sel
  Formal Scenario: ALU not_sel inverts the B operand before use
    Given ALU input "b_in" holds value B
    And "not_sel" is asserted
    And "alu_function" out_sel selects the b output
    When the ALU evaluates its output combinationally
    Then "alu_out" should equal bitwise-NOT of B

  # ---------------------------------------------------------------------
  # Barrel Shifter Properties
  # ---------------------------------------------------------------------

  @barrel_shifter @lsl
  Formal Scenario: Barrel shifter logical shift left
    Given barrel shifter input "in" holds value X
    And "shift_amount" holds value S in range 0 to 31
    And "barrel_shift_function" selects logical shift left
    When the barrel shifter evaluates its output combinationally
    Then "barrel_shift_out" should equal (X shifted left by S) truncated to 32 bits
    And "barrel_shift_carry" should equal bit (32 - S) of X when S is greater than 0

  @barrel_shifter @lsr
  Formal Scenario: Barrel shifter logical shift right
    Given barrel shifter input "in" holds value X
    And "shift_amount" holds value S in range 0 to 31
    And "barrel_shift_function" selects logical shift right
    When the barrel shifter evaluates its output combinationally
    Then "barrel_shift_out" should equal (X shifted right by S, zero filled)
    And "barrel_shift_carry" should equal bit (S - 1) of X when S is greater than 0

  @barrel_shifter @asr
  Formal Scenario: Barrel shifter arithmetic shift right sign-extends
    Given barrel shifter input "in" holds value X
    And "shift_amount" holds value S in range 0 to 31
    And "barrel_shift_function" selects arithmetic shift right
    When the barrel shifter evaluates its output combinationally
    Then "barrel_shift_out" should equal (X arithmetically shifted right by S, sign-extended from bit 31 of X)

  @barrel_shifter @ror
  Formal Scenario: Barrel shifter rotate right with nonzero amount
    Given barrel shifter input "in" holds value X
    And "shift_amount" holds value S greater than 0 and less than 32
    And "barrel_shift_function" selects rotate right
    When the barrel shifter evaluates its output combinationally
    Then "barrel_shift_out" should equal ((X rotated right by S bits))
    And "barrel_shift_carry" should equal bit (S - 1) of X

  @barrel_shifter @rrx
  Formal Scenario: Barrel shifter rotate right extended when shift amount is zero
    Given barrel shifter input "in" holds value X
    And "shift_amount" equals 0
    And "barrel_shift_function" selects rotate right
    And the incoming carry flag "cpsr_carry" holds value C
    When the barrel shifter evaluates its output combinationally
    Then "barrel_shift_out" should equal { C, X[31:1] }
    And "barrel_shift_carry" should equal bit 0 of X

  # ---------------------------------------------------------------------
  # Shifter Operand: Register-Specified Shift Amount
  # ---------------------------------------------------------------------

  @shifter_operand @register_shift
  Formal Scenario: Shifter operand takes shift amount from register Rs
    Given the instruction encodes a register shift with shift register Rs holding value S
    And field "Rm" holds value X
    And the immediate bit "I" is 0 and the register-shift bit is 1
    When the shifter_operand is decoded
    Then the shift amount applied should equal the least significant 8 bits of S
    And the shifted result should equal X shifted according to the selected shift type by that amount

  @shifter_operand @register_shift_large
  Formal Scenario: Register-specified shift amount of 32 or more produces defined result for logical shifts
    Given the instruction encodes a logical shift left or logical shift right with shift register Rs holding value S greater than or equal to 32
    And field "Rm" holds value X
    When the shifter_operand is decoded
    Then the shifted result should equal zero
    And "barrel_shift_carry" should equal 0 when S is greater than 32
    And "barrel_shift_carry" should equal bit 0 of X for logical shift right, or bit 31 of X for logical shift left, when S equals exactly 32

  @shifter_operand @register_shift_zero
  Formal Scenario: Register-specified shift amount of zero passes operand unchanged
    Given the instruction encodes a register shift with shift register Rs holding value 0
    And field "Rm" holds value X
    When the shifter_operand is decoded
    Then the shifted result should equal X unchanged
    And "barrel_shift_carry" should equal the current carry flag "cpsr_carry"

  # ---------------------------------------------------------------------
  # Condition Code Evaluation
  # ---------------------------------------------------------------------

  @condition_codes
  Formal Scenario: EQ condition passes only when zero flag is set
    Given the instruction condition field holds value 4'b0000
    And status flag "z" holds value Z
    When the core evaluates the condition for execution
    Then the instruction should execute if and only if Z equals 1

  @condition_codes
  Formal Scenario: NE condition passes only when zero flag is clear
    Given the instruction condition field holds value 4'b0001
    And status flag "z" holds value Z
    When the core evaluates the condition for execution
    Then the instruction should execute if and only if Z equals 0

  @condition_codes
  Formal Scenario: CS condition passes only when carry flag is set
    Given the instruction condition field holds value 4'b0010
    And status flag "c" holds value C
    When the core evaluates the condition for execution
    Then the instruction should execute if and only if C equals 1

  @condition_codes
  Formal Scenario: CC condition passes only when carry flag is clear
    Given the instruction condition field holds value 4'b0011
    And status flag "c" holds value C
    When the core evaluates the condition for execution
    Then the instruction should execute if and only if C equals 0

  @condition_codes
  Formal Scenario: MI condition passes only when negative flag is set
    Given the instruction condition field holds value 4'b0100
    And status flag "n" holds value N
    When the core evaluates the condition for execution
    Then the instruction should execute if and only if N equals 1

  @condition_codes
  Formal Scenario: PL condition passes only when negative flag is clear
    Given the instruction condition field holds value 4'b0101
    And status flag "n" holds value N
    When the core evaluates the condition for execution
    Then the instruction should execute if and only if N equals 0

  @condition_codes
  Formal Scenario: VS condition passes only when overflow flag is set
    Given the instruction condition field holds value 4'b0110
    And status flag "v" holds value V
    When the core evaluates the condition for execution
    Then the instruction should execute if and only if V equals 1

  @condition_codes
  Formal Scenario: VC condition passes only when overflow flag is clear
    Given the instruction condition field holds value 4'b0111
    And status flag "v" holds value V
    When the core evaluates the condition for execution
    Then the instruction should execute if and only if V equals 0

  @condition_codes
  Formal Scenario: HI condition passes only when carry set and zero clear
    Given the instruction condition field holds value 4'b1000
    And status flag "c" holds value C
    And status flag "z" holds value Z
    When the core evaluates the condition for execution
    Then the instruction should execute if and only if (C equals 1 and Z equals 0)

  @condition_codes
  Formal Scenario: LS condition passes only when carry clear or zero set
    Given the instruction condition field holds value 4'b1001
    And status flag "c" holds value C
    And status flag "z" holds value Z
    When the core evaluates the condition for execution
    Then the instruction should execute if and only if (C equals 0 or Z equals 1)

  @condition_codes
  Formal Scenario: GE condition passes only when N equals V
    Given the instruction condition field holds value 4'b1010
    And status flag "n" holds value N
    And status flag "v" holds value V
    When the core evaluates the condition for execution
    Then the instruction should execute if and only if N equals V

  @condition_codes
  Formal Scenario: LT condition passes only when N differs from V
    Given the instruction condition field holds value 4'b1011
    And status flag "n" holds value N
    And status flag "v" holds value V
    When the core evaluates the condition for execution
    Then the instruction should execute if and only if N does not equal V

  @condition_codes
  Formal Scenario: GT condition passes only when Z clear and N equals V
    Given the instruction condition field holds value 4'b1100
    And status flag "z" holds value Z
    And status flag "n" holds value N
    And status flag "v" holds value V
    When the core evaluates the condition for execution
    Then the instruction should execute if and only if (Z equals 0 and N equals V)

  @condition_codes
  Formal Scenario: LE condition passes only when Z set or N differs from V
    Given the instruction condition field holds value 4'b1101
    And status flag "z" holds value Z
    And status flag "n" holds value N
    And status flag "v" holds value V
    When the core evaluates the condition for execution
    Then the instruction should execute if and only if (Z equals 1 or N does not equal V)

  @condition_codes
  Formal Scenario: AL condition always executes unconditionally
    Given the instruction condition field holds value 4'b1110
    When the core evaluates the condition for execution
    Then the instruction should always execute regardless of status flags

  @condition_codes
  Formal Scenario: NV condition code never executes the instruction
    Given the instruction condition field holds value 4'b1111
    When the core evaluates the condition for execution
    Then the instruction should never execute regardless of status flags

  # ---------------------------------------------------------------------
  # Immediate Operand Decoding
  # ---------------------------------------------------------------------

  @immediate_decode
  Formal Scenario: Immediate value with zero rotate is zero-extended
    Given the instruction has the immediate bit "I" set to 1
    And field "rotate" holds value 4'h0
    And field "imm_8" holds value IMM8
    When the shifter_operand is decoded
    Then the resulting imm32 should equal { 24'h0, IMM8 }

  @immediate_decode
  Formal Scenario: Immediate value is rotated right by twice the rotate field
    Given the instruction has the immediate bit "I" set to 1
    And field "rotate" holds value ROT in range 0 to 15
    And field "imm_8" holds value IMM8
    When the shifter_operand is decoded
    Then the resulting imm32 should equal (IMM8 zero-extended to 32 bits, rotated right by (2 * ROT) bits)

  # ---------------------------------------------------------------------
  # Multiply (Booth's Algorithm) Properties
  # ---------------------------------------------------------------------

  @multiply @booth
  Formal Scenario: Multiply produces correct 32-bit low result after 34 cycles
    Given multiplicand register "Rm" holds value M
    And multiplier register "Rs" holds value S
    And a multiply instruction begins execution at cycle 0
    When 34 clock cycles have elapsed with no interrupting stall
    Then the multiply result low word should equal (M * S) truncated to 32 bits
    And the multiply unit should assert its completion signal on the 34th cycle

  @multiply @mla
  Formal Scenario: Multiply-accumulate adds the accumulate register
    Given multiplicand register "Rm" holds value M
    And multiplier register "Rs" holds value S
    And accumulate register "Rn" holds value ACC
    And the instruction is a multiply-accumulate (A bit set)
    When the multiply-accumulate operation completes
    Then the result should equal ((M * S) + ACC) truncated to 32 bits

  @multiply @booth_step
  Formal Scenario: Booth encoding selects add of multiplicand on booth bits 01
    Given the current product register "P" holds value PVAL
    And the two least significant bits of P equal 2'b01
    And value A represents the multiplicand shifted into position
    When one Booth iteration is performed
    Then the new product before shifting should equal (PVAL + A) ignoring overflow
    And the product should then be arithmetically shifted right by one bit

  @multiply @booth_step
  Formal Scenario: Booth encoding selects subtract of multiplicand on booth bits 10
    Given the current product register "P" holds value PVAL
    And the two least significant bits of P equal 2'b10
    And value S represents the two's complement negated multiplicand shifted into position
    When one Booth iteration is performed
    Then the new product before shifting should equal (PVAL + S) ignoring overflow
    And the product should then be arithmetically shifted right by one bit

  @multiply @booth_step
  Formal Scenario: Booth encoding performs no addition on repeated bit pairs
    Given the current product register "P" holds value PVAL
    And the two least significant bits of P equal either 2'b00 or 2'b11
    When one Booth iteration is performed
    Then the product used for the shift should equal PVAL unchanged
    And the product should then be arithmetically shifted right by one bit

  # ---------------------------------------------------------------------
  # Pipeline Stall / Load-Store Behavior
  # ---------------------------------------------------------------------

  @pipeline @load_stall
  Formal Scenario: Load instruction stalls decode stage for two cycles
    Given a load instruction is present in the execute stage at cycle T
    And the target memory access is a cache hit
    When the load instruction executes
    Then the decode stage should be stalled for exactly 2 clock cycles following cycle T
    And the fetched data should be written to the destination register 2 cycles after the load address is issued

  @pipeline @store_stall
  Formal Scenario: Store instruction stalls decode stage for two cycles
    Given a store instruction is present in the execute stage at cycle T
    And the target memory access is a cache hit
    When the store instruction executes
    Then the decode stage should be stalled for exactly 2 clock cycles following cycle T
    And the write data should be presented on the store address 1 cycle after cycle T

  @pipeline @prefetch_reuse
  Formal Scenario: Instruction following load/store is preserved without re-fetch
    Given a load or store instruction occupies the execute stage
    And the following instruction has already been fetched into "pre_fetch_instruction"
    When the load or store instruction completes its stall cycles
    Then the decode stage should use the saved "pre_fetch_instruction" value
    And no additional fetch cycle should be issued for that instruction

  @pipeline @cache_miss_stall
  Formal Scenario: Cache miss stalls the pipeline until wishbone read completes
    Given the fetch stage issues an address that misses in the cache
    When a cache miss is detected
    Then the pipeline should stall
    And the pipeline should remain stalled until "i_wb_ack" is asserted for the corresponding wishbone read
    And a 4-word cache line fill should be initiated on the wishbone bus

  @pipeline @system_rdy_stall
  Formal Scenario: System not ready freezes decode and execute stages
    Given "i_system_rdy" is deasserted
    When a clock edge occurs
    Then the decode stage registers should not update
    And the execute stage registers should not update

  # ---------------------------------------------------------------------
  # Interrupt / Exception Vector Selection
  # ---------------------------------------------------------------------

  @interrupts @vector_select
  Formal Scenario: Reset selects the reset vector address and Supervisor mode
    Given a reset condition occurs
    When the core services the reset
    Then the next fetch address should equal 32'h00000000
    And the processor mode should switch to Supervisor mode

  @interrupts @vector_select
  Formal Scenario: Undefined instruction exception selects the undefined instruction vector address
    Given an undefined instruction reaches the execute stage
    When the core detects the undefined instruction
    Then the next fetch address should equal 32'h00000004
    And the processor mode should switch to Supervisor mode

  @interrupts @swi_vector
  Formal Scenario: Software interrupt selects the SWI vector address
    Given a software interrupt (swi) instruction reaches the execute stage
    And the instruction's condition passes
    When the swi instruction executes
    Then the next fetch address should equal 32'h00000008
    And the processor mode should switch to Supervisor mode

  @interrupts @vector_select
  Formal Scenario: Prefetch abort selects the prefetch abort vector address
    Given a prefetch abort is signaled for an instruction fetch
    When the core services the prefetch abort exception
    Then the next fetch address should equal 32'h0000000C
    And the processor mode should switch to Supervisor mode

  @interrupts @vector_select
  Formal Scenario: Data abort selects the data abort vector address
    Given a data abort is signaled for a data access
    When the core services the data abort exception
    Then the next fetch address should equal 32'h00000010
    And the processor mode should switch to Supervisor mode

  @interrupts @vector_select
  Formal Scenario: Address exception selects the address exception vector address
    Given an address exception condition is detected
    When the core services the address exception
    Then the next fetch address should equal 32'h00000014
    And the processor mode should switch to Supervisor mode

  @interrupts @vector_select
  Formal Scenario: IRQ input selects the IRQ vector address
    Given "i_irq" is asserted
    And "i_firq" is deasserted
    And the current instruction has completed execution
    And the IRQ mask bit "I" in the status register is clear
    When the core services the pending interrupt
    Then the next fetch address should equal 32'h00000018
    And the processor mode should switch to IRQ mode

  @interrupts @vector_select
  Formal Scenario: FIRQ input selects the FIRQ vector address
    Given "i_firq" is asserted
    And the current instruction has completed execution
    And the FIRQ mask bit "F" in the status register is clear
    When the core services the pending interrupt
    Then the next fetch address should equal 32'h0000001C
    And the processor mode should switch to FIRQ mode

  @interrupts @masking
  Formal Scenario: IRQ is ignored while the IRQ mask bit is set
    Given "i_irq" is asserted
    And the IRQ mask bit "I" in the status register is set
    When a clock edge occurs
    Then the core should not switch to IRQ mode
    And the fetch address should continue in normal sequence

  @interrupts @completion_before_switch
  Formal Scenario: Interrupt mode switch is deferred until multi-cycle instruction completes
    Given a multi-cycle instruction (such as stm) is executing across N cycles
    And "i_irq" is asserted during cycle K where K is less than N
    When the multi-cycle instruction completes at cycle N
    Then the interrupt mode switch should occur only after cycle N
    And no mode switch should occur during cycles K through N-1

  # ---------------------------------------------------------------------
  # Register Bank / Banking Properties
  # ---------------------------------------------------------------------

  @registers @banking
  Formal Scenario: FIRQ mode uses banked registers r8-r14
    Given the processor mode equals FIRQ
    And register write targets r8 through r14
    When a register write occurs
    Then the write should update the FIRQ-banked copy of that register
    And the User mode copy of that register should remain unchanged

  @registers @banking
  Formal Scenario: Supervisor mode banks only r13 and r14
    Given the processor mode equals Supervisor
    And register write targets r13 or r14
    When a register write occurs
    Then the write should update the Supervisor-banked copy of that register
    And registers r0 through r12 should be shared with User mode

  @registers @pc_offset
  Formal Scenario: Register read of PC returns address plus 8 during execute
    Given the program counter holds address ADDR at the execute stage
    And a register read of r15 occurs during instruction execution
    When the read value is produced
    Then the returned value should equal (ADDR + 8)

  # ---------------------------------------------------------------------
  # Status Register Field Properties
  # ---------------------------------------------------------------------

  @status_bits
  Formal Scenario: Privileged mode field is not writable from User mode
    Given the processor mode equals User
    And an instruction attempts to write the mode field bits [1:0]
    When the write is attempted
    Then the mode field should remain unchanged

  @status_bits
  Formal Scenario: S-bit update writes flags only when S is set
    Given a REGOP instruction has the S bit set to value S_BIT
    And the ALU produces flags N, Z, C, V
    When the instruction completes execution
    Then the status flags register should be updated with N, Z, C, V if S_BIT equals 1
    And the status flags register should remain unchanged if S_BIT equals 0

  # ---------------------------------------------------------------------
  # REGOP Opcode-Specific Semantics (Table 7)
  # ---------------------------------------------------------------------

  @regop_opcode @mov
  Formal Scenario: MOV opcode writes shifter_operand directly to destination register
    Given the REGOP opcode field holds value 4'hd
    And the decoded shifter_operand equals value OP2
    When the mov instruction executes
    Then register Rd should be written with OP2
    And the flags N and Z should be updated based on OP2 when the S bit is set

  @regop_opcode @mvn
  Formal Scenario: MVN opcode writes the bitwise complement of shifter_operand to destination register
    Given the REGOP opcode field holds value 4'hf
    And the decoded shifter_operand equals value OP2
    When the mvn instruction executes
    Then register Rd should be written with bitwise-NOT of OP2
    And the flags N and Z should be updated based on the result when the S bit is set

  @regop_opcode @orr
  Formal Scenario: ORR opcode computes bitwise OR of Rn and shifter_operand
    Given the REGOP opcode field holds value 4'hc
    And register Rn holds value A
    And the decoded shifter_operand equals value B
    When the orr instruction executes
    Then register Rd should be written with (A bitwise-OR B)
    And the flags N and Z should be updated based on the result when the S bit is set

  @regop_opcode @rsb
  Formal Scenario: RSB opcode computes reverse subtraction of Rn from shifter_operand
    Given the REGOP opcode field holds value 4'h3
    And register Rn holds value A
    And the decoded shifter_operand equals value B
    When the rsb instruction executes
    Then register Rd should be written with (B - A) truncated to 32 bits
    And the flags N, Z, C, V should be updated according to the subtraction when the S bit is set

  @regop_opcode @rsc
  Formal Scenario: RSC opcode computes reverse subtraction with carry
    Given the REGOP opcode field holds value 4'h7
    And register Rn holds value A
    And the decoded shifter_operand equals value B
    And the carry flag holds value CARRY
    When the rsc instruction executes
    Then register Rd should be written with (B - A - NOT(CARRY)) truncated to 32 bits
    And the flags N, Z, C, V should be updated according to the subtraction when the S bit is set

  @regop_opcode @sbc
  Formal Scenario: SBC opcode computes subtraction with carry
    Given the REGOP opcode field holds value 4'h6
    And register Rn holds value A
    And the decoded shifter_operand equals value B
    And the carry flag holds value CARRY
    When the sbc instruction executes
    Then register Rd should be written with (A - B - NOT(CARRY)) truncated to 32 bits
    And the flags N, Z, C, V should be updated according to the subtraction when the S bit is set

  @regop_opcode @tst
  Formal Scenario: TST opcode updates flags from AND result without writing destination register
    Given the REGOP opcode field holds value 4'h8
    And register Rn holds value A
    And the decoded shifter_operand equals value B
    When the tst instruction executes
    Then the flags N and Z should be updated based on (A bitwise-AND B)
    And no destination register should be written

  @regop_opcode @teq
  Formal Scenario: TEQ opcode updates flags from XOR result without writing destination register
    Given the REGOP opcode field holds value 4'h9
    And register Rn holds value A
    And the decoded shifter_operand equals value B
    When the teq instruction executes
    Then the flags N and Z should be updated based on (A bitwise-XOR B)
    And no destination register should be written

  @regop_opcode @cmn
  Formal Scenario: CMN opcode updates flags from addition result without writing destination register
    Given the REGOP opcode field holds value 4'hb
    And register Rn holds value A
    And the decoded shifter_operand equals value B
    When the cmn instruction executes
    Then the flags N, Z, C, V should be updated based on (A + B) truncated to 32 bits
    And no destination register should be written

  # ---------------------------------------------------------------------
  # Instruction Set Semantics: Branch, Block Transfer, Swap, Single Transfer
  # ---------------------------------------------------------------------

  @instruction_set @branch
  Formal Scenario: Branch instruction computes target from sign-extended offset
    Given a branch instruction with 24-bit signed offset field OFFSET24
    And the program counter holds address PC at the execute stage
    When the branch target address is computed
    Then the target address should equal (PC + 8 + (sign-extend(OFFSET24) shifted left by 2 bits))

  @instruction_set @branch_link
  Formal Scenario: Branch and link stores return address in link register
    Given a branch-and-link (bl) instruction with 24-bit offset field OFFSET24
    And the program counter holds address PC at the execute stage
    When the bl instruction executes
    Then register r14 should be written with the value (PC + 4)
    And the target address should equal (PC + 8 + (sign-extend(OFFSET24) shifted left by 2 bits))

  @instruction_set @ldm
  Formal Scenario: LDM without PC in register list transfers User-mode registers when S bit is set
    Given an ldm instruction with register list REGLIST not including r15
    And the S bit is set
    And the processor is in a privileged mode
    When the ldm instruction executes
    Then the User mode banked registers in REGLIST should be loaded
    And the status flags should remain unchanged

  @instruction_set @ldm_pc
  Formal Scenario: LDM including PC with S bit loads status bits alongside the PC
    Given an ldm instruction with register list REGLIST including r15
    And the S bit is set
    When the ldm instruction executes
    Then the PC should be loaded from memory
    And the status bits should be loaded from the same memory word as the PC

  @instruction_set @stm
  Formal Scenario: STM writeback updates base register when W bit is set
    Given an stm instruction with base register Rn holding value BASE
    And the W bit is set
    And the register list REGLIST contains N registers
    When the stm instruction executes
    Then the registers in REGLIST should be stored to sequential memory locations starting at an address derived from BASE
    And register Rn should be updated according to the addressing mode after the transfer

  @instruction_set @stm_order
  Formal Scenario: STM stores registers in ascending order to ascending addresses
    Given an stm instruction with register list REGLIST containing at least two registers
    When the stm instruction executes
    Then the lowest-numbered register in REGLIST should be stored to the lowest memory address
    And the highest-numbered register in REGLIST should be stored to the highest memory address

  @instruction_set @mtrans_modes
  Formal Scenario: Increment-after addressing mode transfers starting at base register value
    Given an ldm or stm instruction uses increment-after addressing mode with base register Rn holding value BASE
    When the transfer executes
    Then the first register transferred should use address BASE
    And each subsequent register should use an address incremented by 4 from the previous

  @instruction_set @mtrans_modes
  Formal Scenario: Increment-before addressing mode starts transfer at base plus 4
    Given an ldm or stm instruction uses increment-before addressing mode with base register Rn holding value BASE
    When the transfer executes
    Then the first register transferred should use address (BASE + 4)
    And each subsequent register should use an address incremented by 4 from the previous

  @instruction_set @mtrans_modes
  Formal Scenario: Decrement-after addressing mode starts transfer at base and decrements
    Given an ldm or stm instruction uses decrement-after addressing mode with base register Rn holding value BASE and register list of N registers
    When the transfer executes
    Then the first register transferred should use the lowest address equal to (BASE - 4*(N-1))
    And the final register transferred should use address BASE

  @instruction_set @mtrans_modes
  Formal Scenario: Decrement-before addressing mode starts transfer below base
    Given an ldm or stm instruction uses decrement-before addressing mode with base register Rn holding value BASE and register list of N registers
    When the transfer executes
    Then the first register transferred should use the lowest address equal to (BASE - 4*N)
    And the final register transferred should use address (BASE - 4)

  @instruction_set @swp
  Formal Scenario: SWP exchanges a word between register and memory
    Given register Rm holds value M
    And register Rn holds address ADDR
    And the memory at address ADDR holds value MEM
    When the swp instruction executes
    Then register Rd should be written with value MEM
    And the memory at address ADDR should be written with value M

  @instruction_set @swpb
  Formal Scenario: SWPB exchanges a zero-extended byte between register and memory
    Given register Rm holds a value whose least significant byte is B
    And register Rn holds address ADDR
    And the memory byte at address ADDR holds value MEMB
    When the swpb instruction executes
    Then register Rd should be written with MEMB zero-extended to 32 bits
    And the memory byte at address ADDR should be written with B

  @instruction_set @ldr
  Formal Scenario: LDR rotates unaligned word data into destination register
    Given the computed load address ADDR has a non-zero 2-bit byte offset within a word
    And the memory word at the aligned address holds value WORD
    When the ldr instruction executes
    Then the destination register Rd should be written with WORD rotated right by (8 * (ADDR modulo 4)) bits

  @instruction_set @ldrb
  Formal Scenario: LDRB zero-extends a loaded byte
    Given the computed load address ADDR selects a byte value BYTE from memory
    When the ldrb instruction executes
    Then the destination register Rd should be written with BYTE zero-extended to 32 bits

  @instruction_set @str
  Formal Scenario: STR stores a full register word to memory
    Given register Rd holds value VAL
    And the computed store address ADDR is word-aligned
    When the str instruction executes
    Then the memory word at address ADDR should be written with VAL

  @instruction_set @strb
  Formal Scenario: STRB stores only the least significant byte of a register
    Given register Rd holds a value whose least significant byte is B
    And the computed store address is ADDR
    When the strb instruction executes
    Then the memory byte at address ADDR should be written with B
    And bytes outside address ADDR should remain unchanged

  # ---------------------------------------------------------------------
  # Coprocessor Register Transfer Instructions (mcr / mrc)
  # ---------------------------------------------------------------------

  @coprocessor @mcr
  Formal Scenario: MCR transfers a register value to a coprocessor register
    Given register Rd holds value VAL
    And an mcr instruction specifies coprocessor number CP, opcode1 OPC1, destination coprocessor registers CRn and CRm, and opcode2 OPC2
    When the mcr instruction executes
    Then the coprocessor write data should equal VAL
    And the coprocessor register transfer should be signaled with the specified CRn, CRm, opcode1, and opcode2 fields

  @coprocessor @mrc
  Formal Scenario: MRC transfers a coprocessor register value to a general-purpose register
    Given a coprocessor register holds value CPVAL for coprocessor number CP, source coprocessor registers CRn and CRm, and opcode fields OPC1 and OPC2
    And an mrc instruction specifies destination register Rd
    When the mrc instruction executes
    Then register Rd should be written with CPVAL

  @coprocessor @mrc_flags
  Formal Scenario: MRC to R15 transfers coprocessor result into condition flags
    Given a coprocessor register holds value CPVAL
    And an mrc instruction specifies destination register r15
    When the mrc instruction executes
    Then the condition flag bits should be updated from bits [31:28] of CPVAL

  # ---------------------------------------------------------------------
  # Branch Offset Encoding (Section 4.7)
  # ---------------------------------------------------------------------

  @branch @offset_encoding
  Formal Scenario: Branch offset is sign-extended from 24 to 32 bits before shifting
    Given the branch instruction offset field holds a 24-bit value OFFSET24
    When the branch offset is decoded
    Then the sign-extended 32-bit value should replicate bit 23 of OFFSET24 into bits [31:24]

  @branch @offset_alignment
  Formal Scenario: Branch target address is always word-aligned
    Given the branch instruction offset field holds a 24-bit value OFFSET24
    And the program counter holds address PC
    When the branch target address is computed
    Then the two least significant bits of the target address should equal 0
    And the target address should equal (PC + 8 + (sign-extend(OFFSET24) shifted left by 2 bits))

  # ---------------------------------------------------------------------
  # Little-Endian Byte Ordering (Section 1.1 / 1.2)
  # ---------------------------------------------------------------------

  @endianness @byte_order
  Formal Scenario: Word store places byte 0 in the least significant bits
    Given register Rd holds a 32-bit value VAL
    And a str instruction stores VAL to address ADDR
    When the store completes
    Then memory byte at address ADDR should equal bits [7:0] of VAL
    And memory byte at address (ADDR + 3) should equal bits [31:24] of VAL

  @endianness @byte_order_load
  Formal Scenario: Word load reconstructs value with byte 0 as least significant byte
    Given memory byte at address ADDR holds value B0
    And memory byte at address (ADDR + 1) holds value B1
    And memory byte at address (ADDR + 2) holds value B2
    And memory byte at address (ADDR + 3) holds value B3
    And a ldr instruction loads a word from address ADDR
    When the load completes
    Then the destination register should equal { B3, B2, B1, B0 }

  @endianness @byte_lane_select
  Formal Scenario: Byte store selects the correct byte lane based on address bits
    Given a strb instruction stores byte value B to address ADDR
    When the store completes
    Then the byte lane corresponding to (ADDR modulo 4) should be written with B
    And the other three byte lanes at the containing word should remain unchanged

  # ---------------------------------------------------------------------
  # Wishbone Interface Signal Properties (Table 17)
  # ---------------------------------------------------------------------

  @wishbone @address
  Formal Scenario: Wishbone address output reflects the byte address for a bus access
    Given the core initiates a wishbone access to byte address ADDR
    When the access is issued on the wishbone bus
    Then "o_wb_adr" should equal ADDR

  @wishbone @byte_select
  Formal Scenario: Wishbone byte select reflects the active byte lanes for a write
    Given the core initiates a write with byte-enable value BE
    When the access is issued on the wishbone bus
    Then "o_wb_sel" should equal BE
    And bit 0 of "o_wb_sel" should correspond to bits [7:0] of the data bus

  @wishbone @write_enable
  Formal Scenario: Wishbone write enable is asserted only for store accesses
    Given the core initiates a memory access of type ACCESS_TYPE
    When the access is issued on the wishbone bus
    Then "o_wb_we" should equal 1 if ACCESS_TYPE is a write else 0

  @wishbone @read_data
  Formal Scenario: Wishbone read data is sampled only when acknowledged
    Given the core initiates a read access on the wishbone bus
    And "i_wb_dat" holds value RDATA when "i_wb_ack" is asserted
    When "i_wb_ack" is asserted during the read cycle
    Then the core should capture RDATA as the read result
    And the core should not capture data on cycles where "i_wb_ack" is deasserted

  @wishbone @write_data
  Formal Scenario: Wishbone write data is driven while strobe is active
    Given the core initiates a write access with data WDATA
    When "o_wb_stb" is asserted during the write cycle
    Then "o_wb_dat" should equal WDATA

  @wishbone @cycle
  Formal Scenario: Wishbone cycle signal holds bus ownership for multi-cycle accesses
    Given the core initiates a multi-cycle wishbone access spanning N beats
    When the access is in progress
    Then "o_wb_cyc" should remain asserted for the entire duration of the N beats
    And "o_wb_cyc" should deassert only after the final beat is acknowledged

  @wishbone @strobe
  Formal Scenario: Wishbone strobe is asserted once per transferred beat
    Given the core initiates a wishbone access with N beats
    When each beat is transferred
    Then "o_wb_stb" should be asserted exactly once per beat awaiting acknowledgment

  @wishbone @error
  Formal Scenario: Wishbone error response is signaled without corrupting core state
    Given the core initiates a wishbone access
    And "i_wb_err" is asserted instead of "i_wb_ack" for that access
    When the error response is received
    Then the core should terminate the access
    And no register or memory write should be committed for that access

  # ---------------------------------------------------------------------
  # Cache Configuration and Behavior (Section 7)
  # ---------------------------------------------------------------------

  @cache @config_ways
  Formal Scenario: Cache way count is configurable to 2, 3, 4, or 8 ways
    Given the cache is configured with WAYS ways where WAYS is one of 2, 3, 4, or 8
    When the cache is synthesized with this configuration
    Then each way should provide 256 lines of 16 bytes
    And the total cache capacity should equal (WAYS * 4096) bytes

  @cache @write_through
  Formal Scenario: Cache write policy is write-through for all configurations
    Given a store instruction writes value VAL to address ADDR that hits in the cache
    When the store completes
    Then the cache line at ADDR should be updated with VAL
    And the write should also be forwarded to the wishbone bus

  @cache @read_miss_replacement
  Formal Scenario: Cache read-miss replacement policy fills a line only on read miss
    Given the fetch stage issues a read to address ADDR that misses in the cache
    When the miss is serviced
    Then a cache line containing ADDR should be allocated and filled from memory
    And a write access that misses in the cache should not allocate a new cache line

  @cache @instruction_cache_read_only
  Formal Scenario: Instruction cache in Amber 25 configuration is read only
    Given the core is configured as Amber 25 with separate instruction and data caches
    And a write access targets an address mapped into the instruction cache
    When the write is attempted
    Then the instruction cache contents should remain unchanged
    And the write should be directed only to the data cache, not the instruction cache