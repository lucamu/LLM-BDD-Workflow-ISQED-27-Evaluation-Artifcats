# ── module: fifo_pointer_ctrl ──
Feature: FIFO Pointer Generation and Full/Empty Flag Logic

  As a FIFO controller designer
  I want write/read address pointers and full/empty flags generated correctly
  So that the dual-port RAM is accessed safely without overflow or underflow

  Background:
    Given a synchronous design clocked on posedge clk
    And an active-low asynchronous reset rst_n
    And a parameter DEPTH_LOG2 defining the RAM address width
    And internal write pointer wptr of width (DEPTH_LOG2+1) bits
    And internal read pointer rptr of width (DEPTH_LOG2+1) bits
    And waddr is the lower DEPTH_LOG2 bits of wptr
    And raddr is the lower DEPTH_LOG2 bits of rptr
    And wfull is asserted when wptr and rptr have equal lower DEPTH_LOG2 bits but differing MSB
    And rempty is asserted when wptr equals rptr exactly, including the MSB
    And ram_wen equals winc AND NOT wfull
    And ram_ren equals rinc AND NOT rempty

  @reset
  Formal Scenario: Synchronous reset clears both pointers to zero
    Given any current write pointer value W_CUR
    And any current read pointer value R_CUR
    When rst_n is deasserted low
    And a posedge clk occurs
    Then wptr should become 0
    And rptr should become 0
    And waddr should become 0
    And raddr should become 0
    And rempty should become 1
    And wfull should become 0

  @write_increment
  Formal Scenario: Write pointer increments on valid write request
    Given rst_n is asserted high
    And the current write pointer is WPTR_Q
    And the current read pointer is RPTR_Q
    And wfull is computed as (WPTR_Q[DEPTH_LOG2] != RPTR_Q[DEPTH_LOG2]) and (WPTR_Q[DEPTH_LOG2-1:0] == RPTR_Q[DEPTH_LOG2-1:0])
    And winc is asserted 1
    And wfull evaluates to 0
    When a posedge clk occurs
    Then wptr should become WPTR_Q + 1
    And raddr-related state (rptr) should remain RPTR_Q

  @write_hold_when_full
  Formal Scenario: Write pointer holds when FIFO is full despite write request
    Given rst_n is asserted high
    And the current write pointer is WPTR_Q
    And the current read pointer is RPTR_Q
    And wfull is computed as (WPTR_Q[DEPTH_LOG2] != RPTR_Q[DEPTH_LOG2]) and (WPTR_Q[DEPTH_LOG2-1:0] == RPTR_Q[DEPTH_LOG2-1:0])
    And winc is asserted 1
    And wfull evaluates to 1
    When a posedge clk occurs
    Then wptr should remain WPTR_Q
    And ram_wen should be 0

  @write_hold_when_no_request
  Formal Scenario: Write pointer holds when no write request is asserted
    Given rst_n is asserted high
    And the current write pointer is WPTR_Q
    And winc is deasserted 0
    When a posedge clk occurs
    Then wptr should remain WPTR_Q
    And ram_wen should be 0

  @read_increment
  Formal Scenario: Read pointer increments on valid read request
    Given rst_n is asserted high
    And the current write pointer is WPTR_Q
    And the current read pointer is RPTR_Q
    And rempty is computed as (WPTR_Q == RPTR_Q)
    And rinc is asserted 1
    And rempty evaluates to 0
    When a posedge clk occurs
    Then rptr should become RPTR_Q + 1
    And waddr-related state (wptr) should remain WPTR_Q

  @read_hold_when_empty
  Formal Scenario: Read pointer holds when FIFO is empty despite read request
    Given rst_n is asserted high
    And the current write pointer is WPTR_Q
    And the current read pointer is RPTR_Q
    And rempty is computed as (WPTR_Q == RPTR_Q)
    And rinc is asserted 1
    And rempty evaluates to 1
    When a posedge clk occurs
    Then rptr should remain RPTR_Q
    And ram_ren should be 0

  @read_hold_when_no_request
  Formal Scenario: Read pointer holds when no read request is asserted
    Given rst_n is asserted high
    And the current read pointer is RPTR_Q
    And rinc is deasserted 0
    When a posedge clk occurs
    Then rptr should remain RPTR_Q
    And ram_ren should be 0

  @simultaneous_access
  Formal Scenario: Simultaneous write and read requests both succeed when neither full nor empty
    Given rst_n is asserted high
    And the current write pointer is WPTR_Q
    And the current read pointer is RPTR_Q
    And wfull evaluates to 0
    And rempty evaluates to 0
    And winc is asserted 1
    And rinc is asserted 1
    When a posedge clk occurs
    Then wptr should become WPTR_Q + 1
    And rptr should become RPTR_Q + 1
    And ram_wen should be 1
    And ram_ren should be 1

  @wfull_definition
  Formal Scenario: wfull flag reflects pointer wrap-around comparison
    Given rst_n is asserted high
    And the current write pointer is WPTR_Q
    And the current read pointer is RPTR_Q
    When the combinational logic evaluates on the current cycle
    Then wfull should be 1 if and only if WPTR_Q[DEPTH_LOG2] differs from RPTR_Q[DEPTH_LOG2] and the lower DEPTH_LOG2 bits of WPTR_Q equal the lower DEPTH_LOG2 bits of RPTR_Q

  @rempty_definition
  Formal Scenario: rempty flag reflects exact pointer equality including MSB
    Given rst_n is asserted high
    And the current write pointer is WPTR_Q
    And the current read pointer is RPTR_Q
    When the combinational logic evaluates on the current cycle
    Then rempty should be 1 if and only if WPTR_Q equals RPTR_Q exactly, including the MSB

  @address_truncation
  Formal Scenario: Output addresses are truncated pointer values
    Given rst_n is asserted high
    And the current write pointer is WPTR_Q
    And the current read pointer is RPTR_Q
    When the combinational logic evaluates on the current cycle
    Then waddr should equal the lower DEPTH_LOG2 bits of WPTR_Q
    And raddr should equal the lower DEPTH_LOG2 bits of RPTR_Q

  @ram_wen_gating
  Formal Scenario: ram_wen is gated write enable
    Given rst_n is asserted high
    And winc has any value WINC_VAL
    And wfull has any value WFULL_VAL
    When the combinational logic evaluates on the current cycle
    Then ram_wen should equal WINC_VAL AND NOT WFULL_VAL

  @ram_ren_gating
  Formal Scenario: ram_ren is gated read enable
    Given rst_n is asserted high
    And rinc has any value RINC_VAL
    And rempty has any value REMPTY_VAL
    When the combinational logic evaluates on the current cycle
    Then ram_ren should equal RINC_VAL AND NOT REMPTY_VAL

  @no_overflow_safety
  Formal Scenario: Write pointer never advances past full condition
    Given rst_n is asserted high
    And the current write pointer is WPTR_Q
    And the current read pointer is RPTR_Q
    And wfull evaluates to 1
    And winc is asserted 1
    When a posedge clk occurs
    Then wptr should remain WPTR_Q
    And no new data should be written into the RAM

  @no_underflow_safety
  Formal Scenario: Read pointer never advances past empty condition
    Given rst_n is asserted high
    And the current write pointer is WPTR_Q
    And the current read pointer is RPTR_Q
    And rempty evaluates to 1
    And rinc is asserted 1
    When a posedge clk occurs
    Then rptr should remain RPTR_Q
    And no data should be read from the RAM

  @full_to_nonfull_transition
  Formal Scenario: wfull deasserts after a read from a full FIFO
    Given rst_n is asserted high
    And the current write pointer is WPTR_Q
    And the current read pointer is RPTR_Q
    And wfull evaluates to 1
    And rinc is asserted 1
    And winc is deasserted 0
    When a posedge clk occurs
    Then rptr should become RPTR_Q + 1
    And the next-cycle wfull should evaluate to 0

  @empty_to_nonempty_transition
  Formal Scenario: rempty deasserts after a write to an empty FIFO
    Given rst_n is asserted high
    And the current write pointer is WPTR_Q
    And the current read pointer is RPTR_Q
    And rempty evaluates to 1
    And winc is asserted 1
    And rinc is deasserted 0
    When a posedge clk occurs
    Then wptr should become WPTR_Q + 1
    And the next-cycle rempty should evaluate to 0

# ── module: TopModule ──
Feature: Synchronous FIFO with Dual-Port RAM Backing Store

  As a hardware designer
  I want to verify a parameterizable synchronous FIFO
  So that write/read pointers, full/empty flags, and data integrity are formally correct

  Background:
    Given the design is a synchronous module with clock "clk" and active-low reset "rst_n"
    And the FIFO has parameters WIDTH and DEPTH
    And all state transitions occur on the positive edge of clk
    And the dual-port RAM stores written data indexed by the write pointer address
    And the read data output reflects the RAM content addressed by the read pointer

  @reset
  Formal Scenario: Reset initializes FIFO to empty and not full
    Given rst_n is deasserted (0)
    When a positive clock edge occurs
    Then rempty should be 1
    And wfull should be 0
    And the internal write pointer should be 0
    And the internal read pointer should be 0

  @reset
  Formal Scenario: Reset overrides winc and rinc
    Given rst_n is deasserted (0)
    And winc is any value W
    And rinc is any value R
    And wdata is any value D
    When a positive clock edge occurs
    Then rempty should be 1
    And wfull should be 0

  @write
  Formal Scenario: Write operation increments write pointer when not full
    Given rst_n is asserted (1)
    And wfull is 0
    And winc is 1
    And wdata is value D
    And the current write pointer is P_w
    When a positive clock edge occurs
    Then the write pointer should become P_w + 1
    And the RAM location addressed by P_w should hold D on the next read of that address

  @write
  Formal Scenario: Write is inhibited when FIFO is full
    Given rst_n is asserted (1)
    And wfull is 1
    And winc is 1
    And wdata is value D
    And the current write pointer is P_w
    When a positive clock edge occurs
    Then the write pointer should remain P_w
    And no new data should be committed to the RAM

  @read
  Formal Scenario: Read operation increments read pointer when not empty
    Given rst_n is asserted (1)
    And rempty is 0
    And rinc is 1
    And the current read pointer is P_r
    When a positive clock edge occurs
    Then the read pointer should become P_r + 1
    And rdata should equal the RAM content addressed by P_r

  @read
  Formal Scenario: Read is inhibited when FIFO is empty
    Given rst_n is asserted (1)
    And rempty is 1
    And rinc is 1
    And the current read pointer is P_r
    When a positive clock edge occurs
    Then the read pointer should remain P_r
    And rdata should remain unchanged

  @flags
  Formal Scenario: wfull asserts when write pointer leads read pointer by DEPTH
    Given rst_n is asserted (1)
    And the current write pointer is P_w
    And the current read pointer is P_r
    And P_w - P_r equals DEPTH (modulo pointer wraparound)
    When a positive clock edge occurs with no further winc or rinc
    Then wfull should be 1

  @flags
  Formal Scenario: wfull deasserts when a read occurs from a full FIFO
    Given rst_n is asserted (1)
    And wfull is 1
    And rinc is 1
    And winc is 0
    When a positive clock edge occurs
    Then wfull should be 0

  @flags
  Formal Scenario: rempty asserts when write pointer equals read pointer
    Given rst_n is asserted (1)
    And the current write pointer is P
    And the current read pointer is P
    When a positive clock edge occurs with no further winc or rinc
    Then rempty should be 1

  @flags
  Formal Scenario: rempty deasserts when a write occurs into an empty FIFO
    Given rst_n is asserted (1)
    And rempty is 1
    And winc is 1
    And rinc is 0
    When a positive clock edge occurs
    Then rempty should be 0

  @simultaneous
  Formal Scenario: Simultaneous read and write when neither full nor empty
    Given rst_n is asserted (1)
    And wfull is 0
    And rempty is 0
    And winc is 1
    And rinc is 1
    And wdata is value D
    And the current write pointer is P_w
    And the current read pointer is P_r
    When a positive clock edge occurs
    Then the write pointer should become P_w + 1
    And the read pointer should become P_r + 1
    And wfull should be 0 if (P_w + 1) - (P_r + 1) is less than DEPTH
    And rempty should be 0 if (P_w + 1) is not equal to (P_r + 1)

  @simultaneous
  Formal Scenario: Simultaneous write and read when FIFO is full keeps it full
    Given rst_n is asserted (1)
    And wfull is 1
    And winc is 1
    And rinc is 1
    And the current write pointer is P_w
    And the current read pointer is P_r
    When a positive clock edge occurs
    Then the write pointer should become P_w + 1
    And the read pointer should become P_r + 1
    And wfull should remain 1

  @simultaneous
  Formal Scenario: Simultaneous write and read when FIFO is empty keeps it empty
    Given rst_n is asserted (1)
    And rempty is 1
    And winc is 1
    And rinc is 1
    And the current write pointer is P_w
    And the current read pointer is P_r
    When a positive clock edge occurs
    Then the write pointer should become P_w + 1
    And the read pointer should become P_r + 1
    And rempty should remain 1

  @data_integrity
  Formal Scenario: Data written is correctly retrieved in FIFO order
    Given rst_n is asserted (1)
    And the FIFO is not full
    And winc is 1
    And wdata is value D
    And the current write pointer is P_w
    When a positive clock edge occurs
    And rinc remains 0 until the read pointer equals P_w
    And then rinc is asserted once with the read pointer equal to P_w
    Then rdata should equal D

  @pointer_wraparound
  Formal Scenario: Write pointer wraps around correctly at DEPTH boundary
    Given rst_n is asserted (1)
    And the current write pointer is DEPTH - 1
    And winc is 1
    And wfull is 0
    When a positive clock edge occurs
    Then the write pointer should become 0 (modulo DEPTH address wraparound with pointer MSB toggling)

  @pointer_wraparound
  Formal Scenario: Read pointer wraps around correctly at DEPTH boundary
    Given rst_n is asserted (1)
    And the current read pointer is DEPTH - 1
    And rinc is 1
    And rempty is 0
    When a positive clock edge occurs
    Then the read pointer should become 0 (modulo DEPTH address wraparound with pointer MSB toggling)

  @mutual_exclusion
  Formal Scenario: FIFO cannot be both full and empty simultaneously
    Given rst_n is asserted (1)
    When any positive clock edge occurs
    Then wfull and rempty should not both equal 1