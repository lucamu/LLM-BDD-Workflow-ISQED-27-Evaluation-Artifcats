# ── module: ExceptModule ──
Feature: Exception Flush and New PC Generation Unit

  Combinational logic that computes a pipeline flush signal and new program
  counter based on the exception type input, along with an except_occur flag
  for the stall controller.

  Background:
    Given this is a purely combinational module with no clock or reset signal
    And the input "excepttype_i" is a 32-bit value
    And the input "cp0_epc_i" is a 32-bit value representing the EPC register
    And the output "flush" is a 1-bit signal
    And the output "new_pc" is a 32-bit signal
    And the output "except_occur" is a 1-bit signal

  @no_exception @default
  Formal Scenario: No exception, all outputs are cleared
    Given excepttype_i is 32'h00000000
    And cp0_epc_i is any value EPC
    When the module computes its outputs
    Then flush should be 0
    And new_pc should be 32'h00000000
    And except_occur should be 0

  @exception_flag
  Formal Scenario: Except_occur reflects any non-zero exception type
    Given excepttype_i is any value E
    And E is not equal to 32'h00000000
    And cp0_epc_i is any value EPC
    When the module computes its outputs
    Then except_occur should be 1

  @exception_flag
  Formal Scenario: Except_occur is deasserted only when exception type is zero
    Given excepttype_i is any value E
    When the module computes its outputs
    Then except_occur should be 1 if E is not equal to 32'h00000000
    And except_occur should be 0 if E equals 32'h00000000

  @flush_assertion
  Formal Scenario: Flush is asserted whenever exception type is non-zero
    Given excepttype_i is any value E
    And E is not equal to 32'h00000000
    And cp0_epc_i is any value EPC
    When the module computes its outputs
    Then flush should be 1

  @vector_table @interrupt
  Formal Scenario: Interrupt exception sets new_pc to interrupt vector
    Given excepttype_i is 32'h00000001
    And cp0_epc_i is any value EPC
    When the module computes its outputs
    Then flush should be 1
    And new_pc should be 32'h00000020
    And except_occur should be 1

  @vector_table @syscall
  Formal Scenario: Syscall exception sets new_pc to syscall vector
    Given excepttype_i is 32'h00000008
    And cp0_epc_i is any value EPC
    When the module computes its outputs
    Then flush should be 1
    And new_pc should be 32'h00000040
    And except_occur should be 1

  @vector_table @invalid_instruction
  Formal Scenario: Invalid instruction exception sets new_pc to common vector
    Given excepttype_i is 32'h0000000a
    And cp0_epc_i is any value EPC
    When the module computes its outputs
    Then flush should be 1
    And new_pc should be 32'h00000040
    And except_occur should be 1

  @vector_table @trap
  Formal Scenario: Trap exception sets new_pc to common vector
    Given excepttype_i is 32'h0000000d
    And cp0_epc_i is any value EPC
    When the module computes its outputs
    Then flush should be 1
    And new_pc should be 32'h00000040
    And except_occur should be 1

  @vector_table @overflow
  Formal Scenario: Arithmetic overflow exception sets new_pc to common vector
    Given excepttype_i is 32'h0000000c
    And cp0_epc_i is any value EPC
    When the module computes its outputs
    Then flush should be 1
    And new_pc should be 32'h00000040
    And except_occur should be 1

  @vector_table @eret
  Formal Scenario: ERET exception sets new_pc to cp0_epc_i value
    Given excepttype_i is 32'h0000000e
    And cp0_epc_i is any value EPC
    When the module computes its outputs
    Then flush should be 1
    And new_pc should be EPC
    And except_occur should be 1

  @consistency
  Formal Scenario: New_pc is zero only when there is no exception
    Given excepttype_i is 32'h00000000
    And cp0_epc_i is any value EPC
    When the module computes its outputs
    Then new_pc should be 32'h00000000
    And flush should be 0

  @mutual_exclusion
  Formal Scenario: Flush and except_occur are always equal in value
    Given excepttype_i is any value E
    And cp0_epc_i is any value EPC
    When the module computes its outputs
    Then flush should equal except_occur

# ── module: StallCtrl ──
Feature: Pipeline Stall Control Signal Generation

  This is a purely combinational module that generates a 6-bit stall
  control signal based on stall requests from four pipeline stages
  (IF, ID, EX, MEM) and an exception-occurred flag. The exception flag
  has absolute priority and forces the stall signal to zero. Otherwise,
  stall requests are prioritized MEM > EX > ID > IF.

  Background:
    Given the design is purely combinational with no clock or reset signal
    And the inputs are stallreq_from_if, stallreq_from_id, stallreq_from_ex, stallreq_from_mem, except_occur
    And the output is the 6-bit signal stall

  @exception_priority
  Formal Scenario: Exception flag forces stall to zero regardless of any stall requests
    Given stallreq_from_if is any value IF_REQ
    And stallreq_from_id is any value ID_REQ
    And stallreq_from_ex is any value EX_REQ
    And stallreq_from_mem is any value MEM_REQ
    And except_occur is asserted
    When the stall signal is computed
    Then stall should be 6'b000000

  @no_requests
  Formal Scenario: No stall requests and no exception yields zero stall
    Given stallreq_from_if is deasserted
    And stallreq_from_id is deasserted
    And stallreq_from_ex is deasserted
    And stallreq_from_mem is deasserted
    And except_occur is deasserted
    When the stall signal is computed
    Then stall should be 6'b000000

  @mem_highest_priority
  Formal Scenario: MEM stage stall request has highest priority among stall requests
    Given stallreq_from_mem is asserted
    And stallreq_from_ex is any value EX_REQ
    And stallreq_from_id is any value ID_REQ
    And stallreq_from_if is any value IF_REQ
    And except_occur is deasserted
    When the stall signal is computed
    Then stall should be 6'b011111

  @ex_priority_when_no_mem
  Formal Scenario: EX stage stall request takes priority when MEM does not request stall
    Given stallreq_from_mem is deasserted
    And stallreq_from_ex is asserted
    And stallreq_from_id is any value ID_REQ
    And stallreq_from_if is any value IF_REQ
    And except_occur is deasserted
    When the stall signal is computed
    Then stall should be 6'b001111

  @id_priority_when_no_mem_ex
  Formal Scenario: ID stage stall request takes priority when MEM and EX do not request stall
    Given stallreq_from_mem is deasserted
    And stallreq_from_ex is deasserted
    And stallreq_from_id is asserted
    And stallreq_from_if is any value IF_REQ
    And except_occur is deasserted
    When the stall signal is computed
    Then stall should be 6'b000111

  @if_lowest_priority
  Formal Scenario: IF stage stall request applies only when no other stage requests stall
    Given stallreq_from_mem is deasserted
    And stallreq_from_ex is deasserted
    And stallreq_from_id is deasserted
    And stallreq_from_if is asserted
    And except_occur is deasserted
    When the stall signal is computed
    Then stall should be 6'b000111

  @exception_overrides_mem
  Formal Scenario: Exception overrides even the highest priority MEM stall request
    Given stallreq_from_mem is asserted
    And stallreq_from_ex is any value EX_REQ
    And stallreq_from_id is any value ID_REQ
    And stallreq_from_if is any value IF_REQ
    And except_occur is asserted
    When the stall signal is computed
    Then stall should be 6'b000000

  @exhaustive_priority_encoding
  Formal Scenario: Stall output is a deterministic function of all stall requests and exception flag
    Given stallreq_from_if is any value IF_REQ
    And stallreq_from_id is any value ID_REQ
    And stallreq_from_ex is any value EX_REQ
    And stallreq_from_mem is any value MEM_REQ
    And except_occur is any value EXCEPT
    When the stall signal is computed
    Then stall should be 6'b000000 if EXCEPT is asserted
    And stall should be 6'b011111 if EXCEPT is deasserted and MEM_REQ is asserted
    And stall should be 6'b001111 if EXCEPT is deasserted and MEM_REQ is deasserted and EX_REQ is asserted
    And stall should be 6'b000111 if EXCEPT is deasserted and MEM_REQ is deasserted and EX_REQ is deasserted and ID_REQ is asserted
    And stall should be 6'b000111 if EXCEPT is deasserted and MEM_REQ is deasserted and EX_REQ is deasserted and ID_REQ is deasserted and IF_REQ is asserted
    And stall should be 6'b000000 if EXCEPT is deasserted and MEM_REQ is deasserted and EX_REQ is deasserted and ID_REQ is deasserted and IF_REQ is deasserted

# ── module: TopModule ──
Feature: Pipeline Control Unit (TopModule) - Stall and Exception Handling

  This module generates pipeline control signals (new_pc, flush, stall) based on
  reset state, exception type, and stall requests from four pipeline stages.
  Exception handling has priority over stall requests. Reset has priority over both.

  Background:
    Given the design is purely combinational
    And "excepttype_i" is a 32-bit input
    And "cp0_epc_i" is a 32-bit input
    And "new_pc" is a 32-bit output
    And "stall" is a 6-bit output
    And "flush" is a 1-bit output

  @reset @priority
  Formal Scenario: Reset forces all outputs to their default values
    Given "rst" is 1
    And "excepttype_i" is any value X
    And "cp0_epc_i" is any value Y
    And "stallreq_from_if" is any value
    And "stallreq_from_id" is any value
    And "stallreq_from_ex" is any value
    And "stallreq_from_mem" is any value
    When the outputs are computed
    Then "stall" should be 6'b000000
    And "flush" should be 0
    And "new_pc" should be 32'h00000000

  @exception @interrupt
  Formal Scenario: Interrupt exception sets new_pc to interrupt vector
    Given "rst" is 0
    And "excepttype_i" is 32'h00000001
    And "cp0_epc_i" is any value Y
    When the outputs are computed
    Then "flush" should be 1
    And "stall" should be 6'b000000
    And "new_pc" should be 32'h00000020

  @exception @syscall
  Formal Scenario: Syscall exception sets new_pc to syscall vector
    Given "rst" is 0
    And "excepttype_i" is 32'h00000008
    And "cp0_epc_i" is any value Y
    When the outputs are computed
    Then "flush" should be 1
    And "stall" should be 6'b000000
    And "new_pc" should be 32'h00000040

  @exception @invalid_instruction
  Formal Scenario: Invalid instruction exception sets new_pc to exception vector
    Given "rst" is 0
    And "excepttype_i" is 32'h0000000a
    And "cp0_epc_i" is any value Y
    When the outputs are computed
    Then "flush" should be 1
    And "stall" should be 6'b000000
    And "new_pc" should be 32'h00000040

  @exception @trap
  Formal Scenario: Trap exception sets new_pc to exception vector
    Given "rst" is 0
    And "excepttype_i" is 32'h0000000d
    And "cp0_epc_i" is any value Y
    When the outputs are computed
    Then "flush" should be 1
    And "stall" should be 6'b000000
    And "new_pc" should be 32'h00000040

  @exception @overflow
  Formal Scenario: Arithmetic overflow exception sets new_pc to exception vector
    Given "rst" is 0
    And "excepttype_i" is 32'h0000000c
    And "cp0_epc_i" is any value Y
    When the outputs are computed
    Then "flush" should be 1
    And "stall" should be 6'b000000
    And "new_pc" should be 32'h00000040

  @exception @eret
  Formal Scenario: ERET exception sets new_pc to cp0_epc_i value
    Given "rst" is 0
    And "excepttype_i" is 32'h0000000e
    And "cp0_epc_i" is any value Y
    When the outputs are computed
    Then "flush" should be 1
    And "stall" should be 6'b000000
    And "new_pc" should be Y

  @exception @priority_over_stall
  Formal Scenario: Exception takes priority over all stall requests
    Given "rst" is 0
    And "excepttype_i" is 32'h00000001
    And "cp0_epc_i" is any value Y
    And "stallreq_from_if" is 1
    And "stallreq_from_id" is 1
    And "stallreq_from_ex" is 1
    And "stallreq_from_mem" is 1
    When the outputs are computed
    Then "flush" should be 1
    And "stall" should be 6'b000000
    And "new_pc" should be 32'h00000020

  @stall @mem_priority
  Formal Scenario: Stall request from mem stage has highest stall priority
    Given "rst" is 0
    And "excepttype_i" is 32'h00000000
    And "stallreq_from_mem" is 1
    And "stallreq_from_ex" is any value
    And "stallreq_from_id" is any value
    And "stallreq_from_if" is any value
    When the outputs are computed
    Then "stall" should be 6'b011111
    And "flush" should be 0
    And "new_pc" should be 32'h00000000

  @stall @ex_priority
  Formal Scenario: Stall request from ex stage takes priority over id and if
    Given "rst" is 0
    And "excepttype_i" is 32'h00000000
    And "stallreq_from_mem" is 0
    And "stallreq_from_ex" is 1
    And "stallreq_from_id" is any value
    And "stallreq_from_if" is any value
    When the outputs are computed
    Then "stall" should be 6'b001111
    And "flush" should be 0
    And "new_pc" should be 32'h00000000

  @stall @id_priority
  Formal Scenario: Stall request from id stage takes priority over if
    Given "rst" is 0
    And "excepttype_i" is 32'h00000000
    And "stallreq_from_mem" is 0
    And "stallreq_from_ex" is 0
    And "stallreq_from_id" is 1
    And "stallreq_from_if" is any value
    When the outputs are computed
    Then "stall" should be 6'b000111
    And "flush" should be 0
    And "new_pc" should be 32'h00000000

  @stall @if_only
  Formal Scenario: Stall request from if stage alone triggers stall
    Given "rst" is 0
    And "excepttype_i" is 32'h00000000
    And "stallreq_from_mem" is 0
    And "stallreq_from_ex" is 0
    And "stallreq_from_id" is 0
    And "stallreq_from_if" is 1
    When the outputs are computed
    Then "stall" should be 6'b000111
    And "flush" should be 0
    And "new_pc" should be 32'h00000000

  @default @no_stall_no_exception
  Formal Scenario: No exception and no stall requests results in default outputs
    Given "rst" is 0
    And "excepttype_i" is 32'h00000000
    And "stallreq_from_mem" is 0
    And "stallreq_from_ex" is 0
    And "stallreq_from_id" is 0
    And "stallreq_from_if" is 0
    When the outputs are computed
    Then "stall" should be 6'b000000
    And "flush" should be 0
    And "new_pc" should be 32'h00000000

  @exception @unrecognized_type
  Formal Scenario: Non-zero unrecognized exception type still flushes with undefined vector selection but stall cleared
    Given "rst" is 0
    And "excepttype_i" is any nonzero value X not equal to 32'h00000001, 32'h00000008, 32'h0000000a, 32'h0000000c, 32'h0000000d, and 32'h0000000e
    And "cp0_epc_i" is any value Y
    When the outputs are computed
    Then "flush" should be 1
    And "stall" should be 6'b000000