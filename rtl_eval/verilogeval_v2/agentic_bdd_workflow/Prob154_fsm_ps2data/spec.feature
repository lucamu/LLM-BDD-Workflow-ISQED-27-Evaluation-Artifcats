Feature: Message Boundary Detection FSM (TopModule)
  As a hardware designer
  I want the TopModule FSM to detect message boundaries in a byte stream
  So that every 3-byte message beginning with a byte where in[3]=1 is correctly
  captured and signaled via done/out_bytes

  Background:
    Given a synchronous design with input clk
    And an active-high synchronous reset input reset
    And an 8-bit input in
    And a 24-bit output out_bytes
    And a 1-bit output done
    And all state updates occur on the rising edge of clk
    And the reset signal, when asserted, forces done to 0 on the next clock edge
    And the reset signal, when asserted, forces the FSM into the byte-searching state on the next clock edge
    And the FSM states are exactly: byte-1-searching, byte-2-waiting, byte-3-waiting
    And the internal signal byte1_captured is 1 if and only if the FSM currently holds a validly captured byte 1 (i.e., the FSM is in the byte-2-waiting or byte-3-waiting state)
    And the internal signal byte2_captured is 1 if and only if the FSM currently holds a validly captured byte 2 (i.e., the FSM is in the byte-3-waiting state)

  @reset
  Formal Scenario: Reset forces done low and FSM into searching state
    Given the design is in an arbitrary state
    And reset is asserted
    When one clock edge occurs
    Then done should be 0
    And the FSM should be in the byte-1-searching state

  @discard
  Formal Scenario: Bytes without the start marker are discarded while searching
    Given reset is deasserted
    And the FSM is in the byte-1-searching state
    And in is garbage_byte with garbage_byte[3] equal to 0
    When one clock edge occurs
    Then done should be 0
    And the FSM should remain in the byte-1-searching state

  @capture_byte1
  Formal Scenario: A byte with in[3]=1 while searching is captured as byte 1
    Given reset is deasserted
    And the FSM is in the byte-1-searching state
    And in is byte_1 with byte_1[3] equal to 1
    When one clock edge occurs
    Then done should be 0
    And the FSM should be in the byte-2-waiting state
    And the internal byte-1 storage should equal byte_1

  @full_message
  Formal Scenario: A full 3-byte message produces done and correct out_bytes
    Given reset is deasserted
    And the FSM is in the byte-1-searching state
    And in is byte_1 with byte_1[3] equal to 1
    When one clock edge occurs
    Then done should be 0
    Given in is byte_2 with any 8-bit value
    When one clock edge occurs
    Then done should be 0
    Given in is byte_3 with any 8-bit value
    When one clock edge occurs
    Then done should be 1
    And out_bytes[23:16] should equal byte_1
    And out_bytes[15:8] should equal byte_2
    And out_bytes[7:0] should equal byte_3

  @done_pulse_width
  Formal Scenario: done is asserted for exactly one cycle after message reception
    Given reset is deasserted
    And the FSM has just completed receiving byte_3 of a message
    When one clock edge occurs
    Then done should be 1
    Given in is any_byte with any 8-bit value
    When one clock edge occurs
    Then done should be 0 unless byte1_captured and byte2_captured were both 1 immediately prior to this clock edge

  @back_to_back_start
  Formal Scenario: A qualifying byte presented on the done cycle immediately starts a new message
    Given reset is deasserted
    And the FSM has just completed receiving byte_3 of a message
    And in is byte_1 with byte_1[3] equal to 1
    When one clock edge occurs
    Then done should be 1
    And the FSM should be in the byte-2-waiting state
    And the internal byte-1 storage should equal byte_1

  @done_cycle_discard
  Formal Scenario: A non-qualifying byte presented on the done cycle is discarded
    Given reset is deasserted
    And the FSM has just completed receiving byte_3 of a message
    And in is garbage_byte with garbage_byte[3] equal to 0
    When one clock edge occurs
    Then done should be 1
    And the FSM should be in the byte-1-searching state

  @no_spurious_done
  Formal Scenario: done is never asserted without three valid captured bytes
    Given reset is deasserted
    And the FSM is in the byte-1-searching state
    And in is garbage_byte with garbage_byte[3] equal to 0
    When one clock edge occurs
    Then done should be 0
    Given in is another_garbage_byte with any 8-bit value
    When one clock edge occurs
    Then done should be 0 unless byte1_captured and byte2_captured were both 1 immediately prior to this clock edge

  @out_bytes_dontcare
  Formal Scenario: out_bytes need only be valid when done is asserted
    Given reset is deasserted
    And done is 0
    Then out_bytes is a documented don't-care in this cycle and no assertion is required on its value

  @reset_midmessage
  Formal Scenario: Reset during message reception aborts the in-progress message
    Given reset is deasserted
    And the FSM is in the byte-2-waiting state or byte-3-waiting state
    And reset is asserted
    When one clock edge occurs
    Then done should be 0
    And the FSM should be in the byte-1-searching state

  @state_flags_invariant
  Formal Scenario: Captured-byte flags precisely reflect the current FSM state
    Given reset is deasserted
    And the FSM is in the byte-1-searching state
    Then byte1_captured should be 0
    And byte2_captured should be 0

    Given reset is deasserted
    And the FSM is in the byte-2-waiting state
    Then byte1_captured should be 1
    And byte2_captured should be 0

    Given reset is deasserted
    And the FSM is in the byte-3-waiting state
    Then byte1_captured should be 1
    And byte2_captured should be 1