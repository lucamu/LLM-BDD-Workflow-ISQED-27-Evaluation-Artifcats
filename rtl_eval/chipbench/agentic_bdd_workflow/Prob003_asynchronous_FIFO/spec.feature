# ── module: write_pointer_handler ──
Feature: Asynchronous FIFO Write-Side Pointer Management (Binary and Gray Coded)

  As a hardware designer
  I want the write-side pointer logic to correctly maintain binary and Gray-coded
  write pointers, generate the RAM write address, and compute the full flag
  I need these properties formally verified for all reachable states

  Background:
    Given a synchronous design clocked on the rising edge of wclk
    And an active-low asynchronous reset wrstn
    And a parameter ADDRWIDTH defining the FIFO address width
    And a current binary write pointer wbin of width ADDRWIDTH+1
    And a current Gray write pointer wptr_gray of width ADDRWIDTH+1
    And a write increment request winc
    And a current full flag wfull
    And a synchronized Gray read pointer rptr_sync of width ADDRWIDTH+1
    And the next binary pointer value wbin_next defined as wbin + (winc AND NOT wfull)
    And the next Gray pointer value wgray_next defined as (wbin_next >> 1) XOR wbin_next

  @reset
  Formal Scenario: Synchronous reset clears binary and Gray write pointers
    Given wrstn is 0
    And wbin holds any value B
    And wptr_gray holds any value G
    When a rising edge occurs on wclk
    Then wbin should be 0
    And wptr_gray should be 0

  @reset
  Formal Scenario: Reset forces waddr to zero
    Given wrstn is 0
    And wbin holds any value B
    When a rising edge occurs on wclk
    Then waddr should equal the lower ADDRWIDTH bits of 0

  @increment
  Formal Scenario: Binary pointer increments when write enabled and FIFO not full
    Given wrstn is 1
    And wbin holds value B
    And winc is 1
    And wfull is 0
    When a rising edge occurs on wclk
    Then wbin should be B + 1

  @hold
  Formal Scenario: Binary pointer holds when write disabled
    Given wrstn is 1
    And wbin holds value B
    And winc is 0
    When a rising edge occurs on wclk
    Then wbin should be B

  @hold
  Formal Scenario: Binary pointer holds when FIFO is full regardless of winc
    Given wrstn is 1
    And wbin holds value B
    And winc is 1
    And wfull is 1
    When a rising edge occurs on wclk
    Then wbin should be B

  @gray_conversion
  Formal Scenario: Gray pointer is updated as binary-to-Gray conversion of next binary value
    Given wrstn is 1
    And wbin holds value B
    And winc is any value I
    And wfull is any value F
    When a rising edge occurs on wclk
    Then wptr_gray should equal (wbin_next >> 1) XOR wbin_next

  @gray_conversion
  Formal Scenario: Gray pointer update is independent of prior Gray pointer value
    Given two identical instances of the write-pointer logic, Instance1 and Instance2
    And wrstn is 1 for both instances
    And wbin holds the same value B in both instances
    And winc holds the same value I in both instances
    And wfull holds the same value F in both instances
    And Instance1's wptr_gray holds value G1
    And Instance2's wptr_gray holds a different value G2
    When a rising edge occurs on wclk for both instances
    Then Instance1's wptr_gray should equal Instance2's wptr_gray
    And both should equal wgray_next

  @address
  Formal Scenario: waddr is the lower ADDRWIDTH bits of the current binary pointer
    Given wrstn is 1
    And wbin holds value B
    Then waddr should equal the lower ADDRWIDTH bits of B

  @address
  Formal Scenario: waddr updates consistently with binary pointer after increment
    Given wrstn is 1
    And wbin holds value B
    And winc is 1
    And wfull is 0
    When a rising edge occurs on wclk
    Then waddr should equal the lower ADDRWIDTH bits of (B + 1)

  @full_detection
  Formal Scenario: Full flag asserts when next Gray pointer matches inverted-MSB comparison to rptr_sync
    Given wrstn is 1
    And wbin holds value B
    And rptr_sync holds value R
    And winc is 1
    And wfull is 0
    When a rising edge occurs on wclk
    Then wfull should be 1 if wgray_next equals the concatenation of the inverted two MSBs of R with the remaining lower bits of R
    And wfull should be 0 otherwise

  @full_detection
  Formal Scenario: Full flag deasserts when next Gray pointer does not match the full-detection pattern
    Given wrstn is 1
    And wbin holds value B
    And rptr_sync holds value R
    And wgray_next does not equal the concatenation of the inverted two MSBs of R with the remaining lower bits of R
    When a rising edge occurs on wclk
    Then wfull should be 0

  @full_detection
  Formal Scenario: Full flag remains stable when no write occurs and pointers are unchanged
    Given wrstn is 1
    And wbin holds value B
    And rptr_sync holds value R
    And winc is 0
    And wfull is any value F
    When a rising edge occurs on wclk
    Then wfull should be 1 if wgray_next equals the concatenation of the inverted two MSBs of R with the remaining lower bits of R
    And wfull should be 0 otherwise

  @gray_property
  Formal Scenario: Gray-coded pointer never has more than a single bit difference between consecutive updates
    Given wrstn is 1
    And wbin holds value B
    And winc is 1
    And wfull is 0
    When a rising edge occurs on wclk
    Then the Hamming distance between wptr_gray before and after the clock edge should be exactly 1

  @synchronization_output
  Formal Scenario: wptr_gray output reflects the registered Gray pointer for cross-domain synchronization
    Given wrstn is 1
    And wbin holds value B
    And winc is any value I
    And wfull is any value F
    When a rising edge occurs on wclk
    Then the output wptr_gray should equal the internally registered Gray pointer value wgray_next

  @no_overflow_when_full
  Formal Scenario: Binary pointer never increments past current value when wfull is asserted
    Given wrstn is 1
    And wbin holds value B
    And wfull is 1
    And winc is any value I
    When a rising edge occurs on wclk
    Then wbin should remain equal to B

# ── module: read_pointer_handler ──
Feature: Read-Side Binary and Gray-Coded Pointer Management (rclk domain)

  Background:
    Given a synchronous design clocked by rclk
    And an active-low asynchronous reset rrstn
    And ADDRWIDTH is the width of the RAM address
    And PTRWIDTH is ADDRWIDTH + 1
    And rptr_bin is the binary read pointer register of width PTRWIDTH
    And rptr_gray is the Gray-coded read pointer register of width PTRWIDTH
    And raddr is the lower ADDRWIDTH bits of rptr_bin
    And rinc is the read increment request input
    And wptr_sync is the synchronized write Gray pointer input
    And rempty is the empty flag output
    And the binary-to-Gray function gray(x) is defined as x XOR (x right-shifted by 1)
    And all registers update on the rising edge of rclk

  @reset
  Formal Scenario: Synchronous reset clears binary and Gray read pointers
    Given rrstn is 0
    And rptr_bin holds any value P
    And rptr_gray holds any value G
    When a rising edge of rclk occurs
    Then rptr_bin should become 0
    And rptr_gray should become 0
    And raddr should become 0

  @increment
  Formal Scenario: Pointer increments when read requested and FIFO not empty
    Given rrstn is 1
    And rptr_bin holds value P
    And rinc is 1
    And rempty is 0
    When a rising edge of rclk occurs
    Then rptr_bin should become P + 1
    And rptr_gray should become gray(P + 1)

  @no_increment_rinc_low
  Formal Scenario: Pointer holds when read is not requested
    Given rrstn is 1
    And rptr_bin holds value P
    And rptr_gray holds value gray(P)
    And rinc is 0
    When a rising edge of rclk occurs
    Then rptr_bin should remain P
    And rptr_gray should remain gray(P)

  @no_increment_when_empty
  Formal Scenario: Pointer holds when FIFO is empty despite read request
    Given rrstn is 1
    And rptr_bin holds value P
    And rptr_gray holds value gray(P)
    And rinc is 1
    And rempty is 1
    When a rising edge of rclk occurs
    Then rptr_bin should remain P
    And rptr_gray should remain gray(P)

  @address_output
  Formal Scenario: RAM address reflects lower bits of binary pointer
    Given rrstn is 1
    And rptr_bin holds value P
    When a rising edge of rclk occurs with no reset asserted
    Then raddr should equal the lower ADDRWIDTH bits of rptr_bin

  @gray_conversion
  Formal Scenario: Gray pointer always matches Gray encoding of binary pointer
    Given rrstn is 1
    And rptr_bin holds any value P at any time step
    Then rptr_gray should equal gray(rptr_bin)

  @empty_detection
  Formal Scenario: Empty flag asserted when Gray pointers match
    Given rrstn is 1
    And rptr_gray holds value G
    And wptr_sync holds value W
    Then rempty should be 1 if and only if G equals W

  @empty_detection_negative
  Formal Scenario: Empty flag deasserted when Gray pointers differ
    Given rrstn is 1
    And rptr_gray holds value G
    And wptr_sync holds value W
    And G is not equal to W
    Then rempty should be 0

  @synchronization_output
  Formal Scenario: Gray pointer output remains stable for cross-domain synchronization
    Given rrstn is 1
    And rptr_gray holds value G at cycle T
    And no increment condition occurs at cycle T (rinc is 0 or rempty is 1)
    When a rising edge of rclk occurs
    Then rptr_gray at cycle T+1 should equal G

# ── module: sync_r2w ──
Feature: Two-Stage Gray Pointer Synchronizer (rptr_gray -> wclk domain)

  Background:
    Given a synchronous design clocked on the rising edge of wclk
    And an active-low asynchronous or synchronous reset signal wrstn
    And an internal register stage1_q that samples rptr_gray on each wclk rising edge
    And an internal register stage2_q that samples stage1_q on each wclk rising edge
    And the output rptr_sync equals the value of stage2_q
    And rptr_gray is an arbitrary Gray-coded pointer value from the rclk domain

  @reset @formal
  Formal Scenario: Both synchronizer stages clear on reset assertion
    Given wrstn is 0
    And stage1_q holds any value A
    And stage2_q holds any value B
    When a rising edge of wclk occurs
    Then stage1_q should become 0
    And stage2_q should become 0
    And rptr_sync should become 0

  @capture @formal
  Formal Scenario: First stage captures rptr_gray when not in reset
    Given wrstn is 1
    And rptr_gray has value G
    And stage1_q holds any value A
    When a rising edge of wclk occurs
    Then stage1_q should become G

  @capture @formal
  Formal Scenario: Second stage captures previous first-stage value when not in reset
    Given wrstn is 1
    And stage1_q holds value A before the clock edge
    And stage2_q holds any value B
    When a rising edge of wclk occurs
    Then stage2_q should become A
    And rptr_sync should become A

  @propagation @formal
  Formal Scenario: Two-cycle latency of rptr_gray to rptr_sync
    Given wrstn is 1 for at least two consecutive wclk rising edges
    And rptr_gray holds a stable value G for those two clock edges
    And stage1_q and stage2_q hold arbitrary values before the first edge
    When two consecutive rising edges of wclk occur with wrstn held at 1
    Then rptr_sync should equal G after the second edge

  @hold @formal
  Formal Scenario: Synchronizer registers remain unaffected by rclk domain changes between wclk edges
    Given wrstn is 1
    And stage1_q holds value A and stage2_q holds value B immediately after a wclk rising edge
    And rptr_gray changes to a new value G_new before the next wclk rising edge
    When no wclk rising edge has yet occurred
    Then stage1_q should remain A
    And stage2_q should remain B
    And rptr_sync should remain B

  @no_reset @formal
  Formal Scenario: Reset deasserted allows normal shift operation to resume
    Given wrstn transitions from 0 to 1
    And rptr_gray holds value G at the rising edge following deassertion
    And stage1_q and stage2_q are 0 immediately after reset
    When a rising edge of wclk occurs with wrstn equal to 1
    Then stage1_q should become G
    And stage2_q should become 0
    And rptr_sync should become 0

  @stability @formal
  Formal Scenario: rptr_sync only changes on wclk rising edges
    Given wrstn is 1
    And rptr_sync holds value V after a wclk rising edge
    When time advances without a new wclk rising edge
    Then rptr_sync should remain V

  @determinism @formal
  Formal Scenario: Output is a pure function of the two-cycle-delayed input and reset history
    Given wrstn is 1 throughout the observed cycles
    And rptr_gray takes value G exactly two wclk rising edges before the current cycle
    And no reset has occurred within those two cycles
    When the current wclk rising edge occurs
    Then rptr_sync should equal G

# ── module: sync_w2r ──
Feature: Two-Stage Gray Code Synchronizer for Asynchronous FIFO Pointer Crossing

  As a hardware designer
  I want a two-flip-flop synchronizer that safely transfers wptr_gray into the rclk domain
  So that read_pointer_handler receives a metastability-hardened wptr_sync for empty detection

  Background:
    Given a synchronous design clocked by rclk
    And an active-low asynchronous-style reset signal rrstn sampled at rclk
    And an internal register stage1_reg that captures wptr_gray
    And an output register wptr_sync_reg that captures the previous value of stage1_reg
    And wptr_sync equals wptr_sync_reg

  @reset @synchronous-clear
  Formal Scenario: Reset clears both synchronizer stages
    Given rrstn is 0
    And stage1_reg holds any value S1
    And wptr_sync_reg holds any value S2
    When a rising edge of rclk occurs
    Then the next value of stage1_reg should be 0
    And the next value of wptr_sync_reg should be 0
    And the next value of wptr_sync should be 0

  @capture-stage1 @normal-operation
  Formal Scenario: First stage captures write pointer gray value when not in reset
    Given rrstn is 1
    And wptr_gray equals value G
    And stage1_reg holds any value S1
    And wptr_sync_reg holds any value S2
    When a rising edge of rclk occurs
    Then the next value of stage1_reg should be G

  @capture-stage2 @pipeline-behavior
  Formal Scenario: Second stage captures the previous value of the first stage
    Given rrstn is 1
    And wptr_gray equals any value G
    And stage1_reg holds value S1
    And wptr_sync_reg holds any value S2
    When a rising edge of rclk occurs
    Then the next value of wptr_sync_reg should be S1
    And the next value of wptr_sync should be S1

  @no-combinational-bypass @metastability-isolation
  Formal Scenario: Output does not combinationally depend on the current write pointer value
    Given rrstn is 1
    And wptr_gray equals value G1
    And stage1_reg holds value S1
    And wptr_sync_reg holds any value S2
    When a rising edge of rclk occurs
    Then the next value of wptr_sync should be S1
    And the next value of wptr_sync should not depend on G1

  @two-cycle-latency @propagation
  Formal Scenario: Write pointer value propagates to wptr_sync after exactly two clock edges
    Given rrstn is 1 during both clock edges
    And wptr_gray equals a constant value G for two consecutive clock cycles
    And stage1_reg holds any value S1 before the first edge
    And wptr_sync_reg holds any value S2 before the first edge
    When a first rising edge of rclk occurs
    And a second rising edge of rclk occurs
    Then the value of wptr_sync after the second edge should be G

  @reset-priority @override
  Formal Scenario: Reset overrides capture regardless of write pointer value
    Given rrstn is 0
    And wptr_gray equals any value G
    And stage1_reg holds any value S1
    And wptr_sync_reg holds any value S2
    When a rising edge of rclk occurs
    Then the next value of stage1_reg should be 0
    And the next value of wptr_sync_reg should be 0
    And the next value of stage1_reg should not depend on G

  @stability @hold-value
  Formal Scenario: Synchronizer output remains stable when write pointer value is unchanging
    Given rrstn is 1
    And wptr_gray remains constant at value G for three consecutive clock cycles
    And stage1_reg equals G before the first of these edges
    And wptr_sync_reg equals G before the first of these edges
    When a rising edge of rclk occurs
    Then the next value of stage1_reg should be G
    And the next value of wptr_sync_reg should be G
    And the next value of wptr_sync should be G

# ── module: TopModule ──
Feature: Asynchronous FIFO with Dual-Port RAM and Clock Domain Crossing

  Background:
    Given a parameter WIDTH representing the data width in bits
    Given a parameter DEPTH representing the FIFO depth (power of two)
    Given wclk is the write domain clock
    Given rclk is the read domain clock
    Given wrstn is the active-low write domain reset, asynchronous to wclk
    Given rrstn is the active-low read domain reset, asynchronous to rclk
    Given all internal write pointers are synchronized into the read domain via 2-flop synchronizers
    Given all internal read pointers are synchronized into the write domain via 2-flop synchronizers
    Given pointers are maintained in Gray code to ensure safe clock domain crossing

  @reset @write_domain
  Formal Scenario: Write domain reset clears write pointer and forces not-full to full-safe state
    Given wrstn is deasserted (0)
    When a rising edge occurs on wclk
    Then the internal write pointer should be 0
    And wfull should be 0

  @reset @read_domain
  Formal Scenario: Read domain reset clears read pointer and forces empty state
    Given rrstn is deasserted (0)
    When a rising edge occurs on rclk
    Then the internal read pointer should be 0
    And rempty should be 1

  @write @pointer_increment
  Formal Scenario: Write pointer increments on successful write
    Given wrstn is asserted (1)
    Given wfull is 0
    Given winc is 1
    Given wdata is value D
    And the current write pointer is P_w
    When a rising edge occurs on wclk
    Then the internal write pointer should be P_w + 1
    And the RAM location addressed by P_w should be written with D

  @write @no_write_when_full
  Formal Scenario: Write pointer does not change when FIFO is full
    Given wrstn is asserted (1)
    Given wfull is 1
    Given winc is 1
    And the current write pointer is P_w
    When a rising edge occurs on wclk
    Then the internal write pointer should remain P_w

  @write @no_write_when_disabled
  Formal Scenario: Write pointer does not change when winc is deasserted
    Given wrstn is asserted (1)
    Given winc is 0
    And the current write pointer is P_w
    When a rising edge occurs on wclk
    Then the internal write pointer should remain P_w

  @read @pointer_increment
  Formal Scenario: Read pointer increments on successful read
    Given rrstn is asserted (1)
    Given rempty is 0
    Given rinc is 1
    And the current read pointer is P_r
    When a rising edge occurs on rclk
    Then the internal read pointer should be P_r + 1

  @read @no_read_when_empty
  Formal Scenario: Read pointer does not change when FIFO is empty
    Given rrstn is asserted (1)
    Given rempty is 1
    Given rinc is 1
    And the current read pointer is P_r
    When a rising edge occurs on rclk
    Then the internal read pointer should remain P_r

  @read @no_read_when_disabled
  Formal Scenario: Read pointer does not change when rinc is deasserted
    Given rrstn is asserted (1)
    Given rinc is 0
    And the current read pointer is P_r
    When a rising edge occurs on rclk
    Then the internal read pointer should remain P_r

  @full_flag @correctness
  Formal Scenario: wfull asserted when write pointer wraps to match synchronized read pointer
    Given wrstn is asserted (1)
    Given the write pointer Gray code equals the synchronized read pointer Gray code with inverted MSBs and matching lower bits (full condition)
    When a rising edge occurs on wclk
    Then wfull should be 1

  @full_flag @correctness
  Formal Scenario: wfull deasserted when FIFO is not full
    Given wrstn is asserted (1)
    Given the write pointer Gray code does not satisfy the full condition relative to the synchronized read pointer
    When a rising edge occurs on wclk
    Then wfull should be 0

  @empty_flag @correctness
  Formal Scenario: rempty asserted when read pointer equals synchronized write pointer
    Given rrstn is asserted (1)
    Given the read pointer Gray code equals the synchronized write pointer Gray code (empty condition)
    When a rising edge occurs on rclk
    Then rempty should be 1

  @empty_flag @correctness
  Formal Scenario: rempty deasserted when FIFO is not empty
    Given rrstn is asserted (1)
    Given the read pointer Gray code does not equal the synchronized write pointer Gray code
    When a rising edge occurs on rclk
    Then rempty should be 0

  @data_integrity @fifo_order
  Formal Scenario: Data written is correctly read out in FIFO order
    Given wrstn is asserted (1)
    Given rrstn is asserted (1)
    Given wfull is 0
    Given winc is 1
    Given wdata is value D
    And the current write pointer is P_w
    When a rising edge occurs on wclk
    And enough rclk cycles occur for the write pointer to propagate through synchronizers
    And rinc is 1 when the read pointer equals P_w
    And a rising edge occurs on rclk
    Then rdata should equal D

  @gray_code @synchronizer
  Formal Scenario: Write pointer Gray code synchronization into read domain is stable and glitch-free
    Given wrstn is asserted (1)
    Given rrstn is asserted (1)
    And the write pointer Gray code value is G_w
    When two consecutive rising edges occur on rclk with no change to G_w
    Then the synchronized write pointer in the read domain should equal G_w

  @gray_code @synchronizer
  Formal Scenario: Read pointer Gray code synchronization into write domain is stable and glitch-free
    Given wrstn is asserted (1)
    Given rrstn is asserted (1)
    And the read pointer Gray code value is G_r
    When two consecutive rising edges occur on wclk with no change to G_r
    Then the synchronized read pointer in the write domain should equal G_r

  @pointer_encoding @gray_code
  Formal Scenario: Write pointer Gray code transitions differ by exactly one bit
    Given wrstn is asserted (1)
    Given winc is 1
    Given wfull is 0
    And the current write pointer Gray code is G_w
    When a rising edge occurs on wclk
    Then the new write pointer Gray code should differ from G_w in exactly one bit

  @pointer_encoding @gray_code
  Formal Scenario: Read pointer Gray code transitions differ by exactly one bit
    Given rrstn is asserted (1)
    Given rinc is 1
    Given rempty is 0
    And the current read pointer Gray code is G_r
    When a rising edge occurs on rclk
    Then the new read pointer Gray code should differ from G_r in exactly one bit

  @mutual_exclusion @flags
  Formal Scenario: wfull and rempty cannot both indicate an invalid overlapping state
    Given wrstn is asserted (1)
    Given rrstn is asserted (1)
    When a rising edge occurs on wclk
    And a rising edge occurs on rclk
    Then wfull and rempty should not both be 1 unless the FIFO has just been reset

  @capacity @no_overflow
  Formal Scenario: Number of unread entries never exceeds DEPTH
    Given wrstn is asserted (1)
    Given rrstn is asserted (1)
    And the difference between write pointer and read pointer (mod 2*DEPTH) is N
    When a rising edge occurs on wclk
    Then N should be less than or equal to DEPTH

  @capacity @no_underflow
  Formal Scenario: Read pointer never advances beyond write pointer
    Given rrstn is asserted (1)
    Given wrstn is asserted (1)
    And the current write pointer is P_w
    And the current read pointer is P_r
    When a rising edge occurs on rclk
    Then P_r should never exceed P_w in FIFO order (mod 2*DEPTH)