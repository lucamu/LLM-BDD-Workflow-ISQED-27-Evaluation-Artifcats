Feature: mips_16_core_top Formal Verification Specification
  Formal property specification for the mips_16_core_top five-stage pipeline
  MIPS-like processor core, covering PC/fetch behavior, decode/hazard/stall
  behavior, ALU execution, memory access, writeback selection, and reset.

  Background:
    Given the design is clocked by "clk"
    And "rst" is the active-high synchronous reset
    And all state transitions are evaluated on the rising edge of "clk"

  # ---------------------------------------------------------------------
  # Reset behavior
  # ---------------------------------------------------------------------

  @reset @pc
  Formal Scenario: PC clears to zero on reset assertion
    Given "rst" is asserted at the current rising edge of "clk"
    When the rising edge of "clk" occurs
    Then "pc" should be 0

  @reset @pipeline
  Formal Scenario: Pipeline stall gate is not asserted during reset
    Given "rst" is asserted at the current rising edge of "clk"
    When the rising edge of "clk" occurs
    Then the instruction register and pipeline registers should be cleared
    And no register write should occur as a result of stale pipeline content

  @reset @restart
  Formal Scenario: Execution restarts from address zero after reset release
    Given "rst" is asserted for one or more cycles then deasserted
    And "pipeline_stall_n" is 1 after reset release
    When the first rising edge of "clk" occurs after "rst" deasserts
    Then "pc" should be 0
    And the instruction fetched should be the instruction stored at instruction memory address 0

  # ---------------------------------------------------------------------
  # PC / IF stage behavior
  # ---------------------------------------------------------------------

  @if_stage @pc @increment
  Formal Scenario: PC increments sequentially when fetch enabled and no branch taken
    Given "rst" is deasserted
    And "pipeline_stall_n" equals 1
    And "branch_taken" equals 0
    And the current program counter value is PC_CUR
    When the rising edge of "clk" occurs
    Then "pc" should equal PC_CUR + 1

  @if_stage @pc @branch
  Formal Scenario: PC redirects to branch target when branch is taken and fetch enabled
    Given "rst" is deasserted
    And "pipeline_stall_n" equals 1
    And "branch_taken" equals 1
    And the current program counter value is PC_CUR
    And "branch_offset_imm" equals OFFSET, a signed 6-bit value sign-extended to 16 bits
    When the rising edge of "clk" occurs
    Then "pc" should equal PC_CUR + SIGN_EXTEND(OFFSET)

  @if_stage @pc @hold
  Formal Scenario: PC holds its value when fetch is disabled by stall
    Given "rst" is deasserted
    And "pipeline_stall_n" equals 0
    And the current program counter value is PC_CUR
    When the rising edge of "clk" occurs
    Then "pc" should equal PC_CUR

  @if_stage @pc @priority
  Formal Scenario: Branch redirect takes priority over sequential increment when both fetch-enabled conditions could apply
    Given "rst" is deasserted
    And "pipeline_stall_n" equals 1
    And "branch_taken" equals 1
    And the current program counter value is PC_CUR
    And "branch_offset_imm" equals OFFSET
    When the rising edge of "clk" occurs
    Then "pc" should equal PC_CUR + SIGN_EXTEND(OFFSET)
    And "pc" should not equal PC_CUR + 1 unless SIGN_EXTEND(OFFSET) equals 1

  @if_stage @instruction_fetch
  Formal Scenario: Instruction memory read reflects current PC address
    Given "rst" is deasserted
    And the current program counter value is PC_CUR
    And instruction memory location PC_CUR (masked to INSTR_MEM_ADDR_WIDTH low bits) holds value INSTR_VAL
    When the IF stage combinationally reads instruction memory
    Then "instruction" should equal INSTR_VAL

  # ---------------------------------------------------------------------
  # ID stage: decode enable / bubble insertion
  # ---------------------------------------------------------------------

  @id_stage @bubble
  Formal Scenario: ID stage inserts a NOP-equivalent bubble when decode is disabled by stall
    Given "rst" is deasserted
    And "pipeline_stall_n" equals 0
    And "instruction_decode_en" equals 0
    When the rising edge of "clk" occurs
    Then the ID/EX pipeline register control fields should equal the NOP-equivalent bubble encoding
    And no register write enable should be asserted downstream as a direct result of this cycle's decode

  @id_stage @latch
  Formal Scenario: ID stage latches fetched instruction when decode is enabled
    Given "rst" is deasserted
    And "instruction_decode_en" equals 1
    And "instruction" equals INSTR
    When the rising edge of "clk" occurs
    Then the decoded control/data fields in "pipeline_reg_out" should correspond to decoding INSTR

  @id_stage @reg_zero
  Formal Scenario: Register R0 always reads as architectural zero regardless of stored contents
    Given "reg_read_addr_1" equals 3'b000
    When the register file combinationally produces read data
    Then "reg_read_data_1" should equal 0

  @id_stage @reg_zero_port2
  Formal Scenario: Register R0 always reads as architectural zero on the second read port
    Given "reg_read_addr_2" equals 3'b000
    When the register file combinationally produces read data
    Then "reg_read_data_2" should equal 0

  @id_stage @branch_condition
  Formal Scenario: BZ branch is taken when selected operand equals zero
    Given the decoded instruction is BZ with condition selector BRANCH_Z
    And the selected source operand value is OPVAL
    When the ID stage evaluates the branch condition
    Then "branch_taken" should equal 1 if OPVAL equals 0, else "branch_taken" should equal 0

  @id_stage @store_source
  Formal Scenario: Store operation uses rd field as store data source register
    Given the decoded instruction is ST with destination/condition field RD_FIELD
    When the ID stage selects the store data source register
    Then the store data source register identifier should equal RD_FIELD

  @id_stage @immediate_sign_extend
  Formal Scenario: 6-bit immediate is sign-extended to 16 bits for immediate operations
    Given the decoded instruction is ADDI with 6-bit immediate field IMM6
    When the ID stage produces the ALU operand from the immediate field
    Then the resulting 16-bit operand should equal SIGN_EXTEND(IMM6)
    And bits [15:6] of the resulting operand should equal replication of bit IMM6[5]

  # ---------------------------------------------------------------------
  # Hazard detection unit
  # ---------------------------------------------------------------------

  @hazard @stall_ex
  Formal Scenario: Stall asserted when decode source register matches EX-stage destination
    Given "decoding_op_src1" equals SRC1, a nonzero register index
    And "ex_op_dest" equals SRC1
    When the hazard detection unit evaluates in the current cycle
    Then "pipeline_stall_n" should equal 0

  @hazard @stall_mem
  Formal Scenario: Stall asserted when decode source register matches MEM-stage destination
    Given "decoding_op_src2" equals SRC2, a nonzero register index
    And "mem_op_dest" equals SRC2
    When the hazard detection unit evaluates in the current cycle
    Then "pipeline_stall_n" should equal 0

  @hazard @stall_wb
  Formal Scenario: Stall asserted when decode source register matches WB-stage destination
    Given "decoding_op_src1" equals SRC1, a nonzero register index
    And "wb_op_dest" equals SRC1
    When the hazard detection unit evaluates in the current cycle
    Then "pipeline_stall_n" should equal 0

  @hazard @no_stall_zero_reg
  Formal Scenario: Register R0 as source never triggers a hazard stall
    Given "decoding_op_src1" equals 3'b000
    And "ex_op_dest" equals 3'b000
    And "mem_op_dest" equals 3'b000
    And "wb_op_dest" equals 3'b000
    When the hazard detection unit evaluates in the current cycle
    Then "pipeline_stall_n" should equal 1

  @hazard @no_stall_disjoint
  Formal Scenario: No stall asserted when neither decode source register matches any tracked destination
    Given "decoding_op_src1" equals SRC1, a nonzero register index
    And "decoding_op_src2" equals SRC2, a nonzero register index
    And "ex_op_dest" does not equal SRC1 and does not equal SRC2
    And "mem_op_dest" does not equal SRC1 and does not equal SRC2
    And "wb_op_dest" does not equal SRC1 and does not equal SRC2
    When the hazard detection unit evaluates in the current cycle
    Then "pipeline_stall_n" should equal 1

  @hazard @freeze_effect
  Formal Scenario: Stall condition freezes IF and ID stage advancement
    Given "pipeline_stall_n" equals 0
    And the current program counter value is PC_CUR
    And the current fetched instruction latch value is INSTR_LATCHED
    When the rising edge of "clk" occurs
    Then "pc" should equal PC_CUR
    And the ID stage instruction latch should remain INSTR_LATCHED unchanged

  # ---------------------------------------------------------------------
  # EX stage: ALU operations
  # ---------------------------------------------------------------------

  @ex_stage @alu_add
  Formal Scenario: ALU computes ADD as sum of two operands
    Given the ALU command is ADD
    And ALU operand A equals VAL_A
    And ALU operand B equals VAL_B
    When the EX stage computes the ALU result
    Then the ALU result should equal VAL_A + VAL_B

  @ex_stage @alu_sub
  Formal Scenario: ALU computes SUB as difference of two operands
    Given the ALU command is SUB
    And ALU operand A equals VAL_A
    And ALU operand B equals VAL_B
    When the EX stage computes the ALU result
    Then the ALU result should equal VAL_A - VAL_B

  @ex_stage @alu_and
  Formal Scenario: ALU computes bitwise AND of two operands
    Given the ALU command is AND
    And ALU operand A equals VAL_A
    And ALU operand B equals VAL_B
    When the EX stage computes the ALU result
    Then the ALU result should equal VAL_A AND VAL_B (bitwise)

  @ex_stage @alu_or
  Formal Scenario: ALU computes bitwise OR of two operands
    Given the ALU command is OR
    And ALU operand A equals VAL_A
    And ALU operand B equals VAL_B
    When the EX stage computes the ALU result
    Then the ALU result should equal VAL_A OR VAL_B (bitwise)

  @ex_stage @alu_xor
  Formal Scenario: ALU computes bitwise XOR of two operands
    Given the ALU command is XOR
    And ALU operand A equals VAL_A
    And ALU operand B equals VAL_B
    When the EX stage computes the ALU result
    Then the ALU result should equal VAL_A XOR VAL_B (bitwise)

  @ex_stage @alu_sl
  Formal Scenario: ALU computes logical left shift
    Given the ALU command is SL
    And ALU operand A equals VAL_A
    And the shift amount operand equals SHAMT
    When the EX stage computes the ALU result
    Then the ALU result should equal (VAL_A << SHAMT)

  @ex_stage @alu_sr
  Formal Scenario: ALU computes arithmetic right shift
    Given the ALU command is SR
    And ALU operand A equals VAL_A, a signed 16-bit value
    And the shift amount operand equals SHAMT
    When the EX stage computes the ALU result
    Then the ALU result should equal ARITHMETIC_SHIFT_RIGHT(VAL_A, SHAMT)

  @ex_stage @alu_sru
  Formal Scenario: ALU computes logical (unsigned) right shift
    Given the ALU command is SRU
    And ALU operand A equals VAL_A, treated as unsigned 16-bit value
    And the shift amount operand equals SHAMT
    When the EX stage computes the ALU result
    Then the ALU result should equal LOGICAL_SHIFT_RIGHT(VAL_A, SHAMT)

  @ex_stage @alu_addi
  Formal Scenario: ALU computes ADDI using sign-extended immediate
    Given the ALU command is ADD (from ADDI decode)
    And ALU operand A equals VAL_A
    And ALU operand B equals SIGN_EXTEND(IMM6)
    When the EX stage computes the ALU result
    Then the ALU result should equal VAL_A + SIGN_EXTEND(IMM6)

  @ex_stage @effective_address
  Formal Scenario: EX stage computes effective address for LD/ST as base plus sign-extended offset
    Given the ALU command corresponds to LD or ST
    And the base register operand equals BASE
    And the offset field equals OFFSET6
    When the EX stage computes the ALU result
    Then the ALU result should equal BASE + SIGN_EXTEND(OFFSET6)

  @ex_stage @dest_forward
  Formal Scenario: EX stage forwards destination register identifier for hazard tracking
    Given the decoded destination register in ID/EX payload equals DEST
    When the EX stage produces its outputs
    Then "ex_op_dest" should equal DEST

  # ---------------------------------------------------------------------
  # MEM stage
  # ---------------------------------------------------------------------

  @mem_stage @store
  Formal Scenario: MEM stage writes store data to data memory at ALU-computed address when store enabled
    Given the ALU result (address) equals ADDR
    And the store data value equals SDATA
    And the memory write enable control is 1
    When the rising edge of "clk" occurs
    Then data memory location ADDR (masked to DATA_MEM_ADDR_WIDTH low bits) should equal SDATA

  @mem_stage @no_store
  Formal Scenario: MEM stage does not modify data memory when store is not enabled
    Given the ALU result (address) equals ADDR
    And the memory write enable control is 0
    And data memory location ADDR currently holds MVAL
    When the rising edge of "clk" occurs
    Then data memory location ADDR should still equal MVAL

  @mem_stage @load_passthrough
  Formal Scenario: MEM stage forwards memory read data for LD instructions
    Given the ALU result (address) equals ADDR
    And data memory location ADDR holds value MVAL
    When the MEM stage reads data memory
    Then the memory read data forwarded in "pipeline_reg_out" should equal MVAL

  @mem_stage @alu_passthrough
  Formal Scenario: MEM stage passes through ALU result unmodified toward WB
    Given the ALU result equals ALU_VAL
    When the MEM stage produces its outputs
    Then the ALU result field in "pipeline_reg_out" should equal ALU_VAL

  @mem_stage @dest_forward
  Formal Scenario: MEM stage forwards destination register identifier for hazard tracking
    Given the destination register in the EX/MEM payload equals DEST
    When the MEM stage produces its outputs
    Then "mem_op_dest" should equal DEST

  # ---------------------------------------------------------------------
  # WB stage
  # ---------------------------------------------------------------------

  @wb_stage @select_alu
  Formal Scenario: WB stage selects ALU result for arithmetic/logic/immediate operations
    Given the writeback source select indicates ALU result
    And the ALU result in the MEM/WB payload equals ALU_VAL
    When the WB stage produces its outputs
    Then "reg_write_data" should equal ALU_VAL

  @wb_stage @select_load
  Formal Scenario: WB stage selects memory read data for LD instructions
    Given the writeback source select indicates memory data
    And the memory read data in the MEM/WB payload equals MEM_VAL
    When the WB stage produces its outputs
    Then "reg_write_data" should equal MEM_VAL

  @wb_stage @write_enable
  Formal Scenario: WB stage asserts register write enable per decoded control
    Given the writeback control write-enable field equals WEN
    When the WB stage produces its outputs
    Then "reg_write_en" should equal WEN

  @wb_stage @write_dest
  Formal Scenario: WB stage forwards destination register for the register file write port
    Given the writeback control destination field equals DEST
    When the WB stage produces its outputs
    Then "reg_write_dest" should equal DEST
    And "wb_op_dest" should equal DEST

  # ---------------------------------------------------------------------
  # Register file write/read
  # ---------------------------------------------------------------------

  @regfile @write
  Formal Scenario: Register file writes data to destination register when write enabled and nonzero
    Given "reg_write_en" equals 1
    And "reg_write_dest" equals DEST, a nonzero register index
    And "reg_write_data" equals WDATA
    When the rising edge of "clk" occurs
    Then register DEST should hold value WDATA on the following read

  @regfile @no_write_disabled
  Formal Scenario: Register file does not update any register when write is disabled
    Given "reg_write_en" equals 0
    And register DEST currently holds value OLD_VAL
    When the rising edge of "clk" occurs
    Then register DEST should still hold value OLD_VAL

  @regfile @r0_immutable
  Formal Scenario: Register R0 remains zero even if a write to R0 is attempted
    Given "reg_write_en" equals 1
    And "reg_write_dest" equals 3'b000
    And "reg_write_data" equals WDATA, a nonzero value
    When the rising edge of "clk" occurs
    And "reg_read_addr_1" equals 3'b000
    Then "reg_read_data_1" should equal 0

  @regfile @read_combinational
  Formal Scenario: Register file read ports reflect currently stored values combinationally
    Given register SRC currently holds value RVAL, where SRC is a nonzero register index
    And "reg_read_addr_1" equals SRC
    When the register file combinationally produces read data
    Then "reg_read_data_1" should equal RVAL

  # ---------------------------------------------------------------------
  # Pipeline register width / field integrity
  # ---------------------------------------------------------------------

  @pipeline_width @id_ex
  Formal Scenario: ID/EX pipeline payload preserves 57-bit field width
    Given the ID stage produces a payload on "pipeline_reg_out"
    When the payload is registered at the rising edge of "clk"
    Then the "pipeline_reg_out" width should equal 57 bits

  @pipeline_width @ex_mem
  Formal Scenario: EX/MEM pipeline payload preserves 38-bit field width
    Given the EX stage produces a payload on "pipeline_reg_out"
    When the payload is registered at the rising edge of "clk"
    Then the "pipeline_reg_out" width should equal 38 bits

  @pipeline_width @mem_wb
  Formal Scenario: MEM/WB pipeline payload preserves 37-bit field width
    Given the MEM stage produces a payload on "pipeline_reg_out"
    When the payload is registered at the rising edge of "clk"
    Then the "pipeline_reg_out" width should equal 37 bits

  # ---------------------------------------------------------------------
  # Branch delay slot semantics
  # ---------------------------------------------------------------------

  @branch_delay
  Formal Scenario: One instruction following a taken branch executes before redirect takes effect
    Given "branch_taken" equals 1 in the current cycle at PC value PC_CUR
    And the instruction at PC_CUR + 1 (the delay slot) has already been fetched
    When the rising edge of "clk" occurs
    Then the delay-slot instruction fetched at PC_CUR + 1 should proceed into the pipeline
    And "pc" on the following cycle should equal PC_CUR + SIGN_EXTEND(OFFSET)