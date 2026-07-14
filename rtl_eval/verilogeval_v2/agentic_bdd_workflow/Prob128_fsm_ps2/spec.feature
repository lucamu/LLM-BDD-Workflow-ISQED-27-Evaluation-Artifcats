Feature: PS/2 Mouse Byte-Stream Message Boundary Detector (TopModule)
  The TopModule scans a continuous byte stream for 3-byte PS/2 mouse
  messages. It resynchronizes by discarding bytes until it finds one
  whose bit 3 is 1 (the first byte of a message), then counts two more
  bytes of any value, asserting done exactly one cycle after the third
  byte of each message is received.

  Background:
    Given a synchronous design with input clk, input reset, input [7:0] in, output done
    And all sequential logic is triggered on the rising edge of clk
    And reset is active-high and synchronous
    And reset is asserted for at least one clock edge before any scenario begins

  Formal Scenario: @reset Reset deasserts done and restarts the search
    Given reset is asserted (reset = 1)
    When a rising clock edge occurs
    Then done should be 0 in the cycle following the reset edge
    And done should remain 0 as long as reset stays asserted

  Formal Scenario: @search Bytes with in[3]=0 are discarded indefinitely while searching
    Given reset has been deasserted for at least one cycle
    And no byte with in[3] = 1 has been seen since reset
    And an arbitrary sequence of bytes is presented, each with in[3] = 0
    When any number of rising clock edges occur
    Then done should be 0 on every one of those cycles

  Formal Scenario: @detect A byte with in[3]=1 starts a new message count
    Given reset has been deasserted and no message is currently in progress
    And a byte "A" is presented with A[3] = 1
    When a rising clock edge occurs
    Then done should be 0 in that same cycle
    And exactly two further bytes of arbitrary value must be received before done can assert

  Formal Scenario: @endtoend Done asserts exactly one cycle after the third byte of a message
    Given reset has been deasserted and no message is currently in progress
    And byte "A" is presented at cycle T with A[3] = 1
    And byte "B" is presented at cycle T+1 with any value of B
    And byte "C" is presented at cycle T+2 with any value of C
    When three consecutive rising clock edges occur at cycles T, T+1, and T+2
    Then done should be 0 at cycles T, T+1, and T+2
    And done should be 1 at cycle T+3, regardless of the values of B and C

  Formal Scenario: @pulsewidth Done is asserted for exactly one clock cycle
    Given a message completed such that done = 1 at cycle T+3
    And byte "D" is presented at cycle T+3 with any value of D
    When a rising clock edge occurs at cycle T+3
    Then done should be 0 at cycle T+4, regardless of the value of D and of D[3]

  Formal Scenario: @chaining Back-to-back messages start immediately if in[3]=1 on the done cycle
    Given a message completed such that done = 1 at cycle T+3
    And byte "D" is presented at cycle T+3 with D[3] = 1
    When three further consecutive rising clock edges occur at cycles T+3, T+4, and T+5
    And bytes "E" and "F" are presented at cycles T+4 and T+5 with any values of E and F
    Then done should be 0 at cycles T+3, T+4, and T+5
    And done should be 1 at cycle T+6, regardless of the values of E and F

  Formal Scenario: @resync Search resumes if the byte on the done cycle is not a valid byte1
    Given a message completed such that done = 1 at cycle T+3
    And byte "D" is presented at cycle T+3 with D[3] = 0
    When a rising clock edge occurs at cycle T+3
    Then done should be 0 at cycle T+4
    And no further done assertion should occur until a subsequent byte with in[3] = 1 is received and two more bytes follow it

  Formal Scenario: @invariant Done can only be 1 in the cycle immediately following a completed third byte
    Given reset has been deasserted at least three cycles ago
    Then done should be 1 at any cycle T only if a byte with in[3] = 1 was accepted as byte one at cycle T-3
    And exactly two bytes of arbitrary value were received at cycles T-2 and T-1 as byte two and byte three of that same message