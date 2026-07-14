Feature: AES Cipher Top Control and Round Transformation Verification

  As a hardware verification engineer
  I want to formally verify the aes_cipher_top module
  So that encryption control flow, state matrix updates, and output generation are correct

  Background:
    Given a synchronous design with clock signal clk
    And an active-low reset signal rst_n
    And all registers update on the rising edge of clk
    And the design has state register dcnt of width 4
    And the design has state register ld_r of width 1
    And the design has state matrix register sa of width 8 times 16 elements
    And the design has buffer register text_in_r of width 128
    And the design has output register text_out of width 128
    And the design has output signal done of width 1

  @reset @formal
  Formal Scenario: Reset initializes all registers to zero
    Given rst_n is deasserted (0)
    When a rising edge of clk occurs
    Then dcnt should be 0
    And ld_r should be 0
    And all elements of sa should be 0
    And text_in_r should be 0
    And text_out should be 0
    And done should be 0

  @reset @formal
  Formal Scenario: Reset is asynchronous or synchronous but dominates ld
    Given rst_n is deasserted (0)
    And ld is any value
    And key is any value K
    And text_in is any value T
    When a rising edge of clk occurs
    Then dcnt should be 0
    And done should be 0

  @idle @formal
  Formal Scenario: IDLE state holds until load is asserted
    Given rst_n is asserted (1)
    And the design is in IDLE state with dcnt equal to 0
    And ld is 0
    When a rising edge of clk occurs
    Then dcnt should remain 0
    And done should remain 0
    And text_out should remain unchanged

  @load @formal
  Formal Scenario: Load signal captures input text and key on next cycle
    Given rst_n is asserted (1)
    And the design is in IDLE state
    And ld is 1
    And text_in is a symbolic value T
    And key is a symbolic value K
    When a rising edge of clk occurs
    Then ld_r should be 1
    And text_in_r should be T

  @init_round @formal
  Formal Scenario: INIT_ROUND performs initial AddRoundKey and sets counter
    Given rst_n is asserted (1)
    And ld_r was 1 in the previous cycle
    And text_in_r holds value T
    And the initial round key from key expansion is RK0
    When a rising edge of clk occurs
    Then sa should be equal to (T XOR RK0) mapped in column-major order
    And dcnt should be 4'hB

  @round_counter @formal
  Formal Scenario: Round counter decrements each cycle during encryption
    Given rst_n is asserted (1)
    And the design is in ROUND_OP or FINAL_ROUND state
    And dcnt is a symbolic nonzero value N
    When a rising edge of clk occurs
    Then dcnt should be N minus 1

  @round_op @formal
  Formal Scenario: ROUND_OP applies SubBytes, ShiftRows, MixColumns, AddRoundKey
    Given rst_n is asserted (1)
    And the design is in ROUND_OP state with dcnt greater than 1
    And sa holds a symbolic state matrix S
    And the current round key from key expansion is RK
    When a rising edge of clk occurs
    Then sa should be equal to MixColumns(ShiftRows(SubBytes(S))) XOR RK

  @final_round @formal
  Formal Scenario: FINAL_ROUND skips MixColumns transformation
    Given rst_n is asserted (1)
    And the design is in FINAL_ROUND state with dcnt equal to 4'h1
    And sa holds a symbolic state matrix S
    And the final round key from key expansion is RK_final
    When a rising edge of clk occurs
    Then sa should be equal to ShiftRows(SubBytes(S)) XOR RK_final
    And sa should not include a MixColumns transformation

  @done_generation @formal
  Formal Scenario: DONE signal asserted when round counter reaches zero
    Given rst_n is asserted (1)
    And the design is in FINAL_ROUND state with dcnt equal to 4'h1
    When a rising edge of clk occurs
    Then dcnt should be 4'h0
    And done should be 1

  @done_output_stability @formal
  Formal Scenario: text_out holds final ciphertext value once done
    Given rst_n is asserted (1)
    And dcnt is 4'h0
    And done is 1
    And sa holds a symbolic final state matrix S_final
    When a rising edge of clk occurs
    Then text_out should remain equal to S_final mapped in column-major order
    And done should remain 1

  @done_stability @formal
  Formal Scenario: DONE state persists without new load
    Given rst_n is asserted (1)
    And done is 1
    And ld is 0
    When a rising edge of clk occurs
    Then done should remain 1
    And text_out should remain unchanged

  @reload_after_done @formal
  Formal Scenario: New load restarts encryption after DONE
    Given rst_n is asserted (1)
    And done is 1
    And ld is 1
    And text_in is a symbolic value T2
    And key is a symbolic value K2
    When a rising edge of clk occurs
    Then ld_r should be 1
    And done should become 0 on the following cycle when INIT_ROUND begins

  @state_matrix_mapping @formal
  Formal Scenario: Input text mapped to state matrix in column-major order
    Given rst_n is asserted (1)
    And text_in_r holds a symbolic value T
    And the initial round key is RK0
    When the INIT_ROUND transformation occurs
    Then sa[0][0] should be equal to T[127:120] XOR RK0[127:120]
    And sa[1][0] should be equal to T[119:112] XOR RK0[119:112]
    And sa[2][0] should be equal to T[111:104] XOR RK0[111:104]
    And sa[3][0] should be equal to T[103:96] XOR RK0[103:96]

  @shiftrows @formal
  Formal Scenario: ShiftRows performs correct cyclic shifts per row
    Given a symbolic state matrix row values a, b, c, d for row 1
    When the ShiftRows transformation is applied
    Then the resulting row 1 should be [b, c, d, a]

  @shiftrows_row2 @formal
  Formal Scenario: ShiftRows shifts row 2 by two bytes
    Given a symbolic state matrix row values a, b, c, d for row 2
    When the ShiftRows transformation is applied
    Then the resulting row 2 should be [c, d, a, b]

  @shiftrows_row3 @formal
  Formal Scenario: ShiftRows shifts row 3 by three bytes
    Given a symbolic state matrix row values a, b, c, d for row 3
    When the ShiftRows transformation is applied
    Then the resulting row 3 should be [d, a, b, c]

  @shiftrows_row0 @formal
  Formal Scenario: ShiftRows leaves row 0 unchanged
    Given a symbolic state matrix row values a, b, c, d for row 0
    When the ShiftRows transformation is applied
    Then the resulting row 0 should be [a, b, c, d]

  @mixcolumns @formal
  Formal Scenario: MixColumns computes correct GF(2^8) matrix multiplication
    Given a symbolic column with bytes s0, s1, s2, s3
    When the MixColumns transformation is applied
    Then out0 should equal GF_MUL(s0,2) XOR GF_MUL(s1,3) XOR s2 XOR s3
    And out1 should equal s0 XOR GF_MUL(s1,2) XOR GF_MUL(s2,3) XOR s3
    And out2 should equal s0 XOR s1 XOR GF_MUL(s2,2) XOR GF_MUL(s3,3)
    And out3 should equal GF_MUL(s0,3) XOR s1 XOR s2 XOR GF_MUL(s3,2)

  @addroundkey @formal
  Formal Scenario: AddRoundKey performs byte-wise XOR with round key
    Given a symbolic state matrix S
    And a symbolic round key RK
    When the AddRoundKey transformation is applied
    Then the resulting state matrix should equal S XOR RK for every byte position

  @sbox @formal
  Formal Scenario: SubBytes applies S-box substitution independently to each byte
    Given a symbolic input byte value A at any state matrix position
    When the SubBytes transformation is applied
    Then the output byte at that position should equal SBOX(A)

  @counter_no_change_idle @formal
  Formal Scenario: Round counter does not change while in IDLE
    Given rst_n is asserted (1)
    And the design is in IDLE state with dcnt equal to 0
    And ld is 0
    When a rising edge of clk occurs
    Then dcnt should remain 0

  @output_stable_during_rounds @formal
  Formal Scenario: text_out remains unchanged during ROUND_OP and FINAL_ROUND
    Given rst_n is asserted (1)
    And dcnt is a symbolic value N greater than 0
    And text_out holds a symbolic value V
    When a rising edge of clk occurs
    Then text_out should remain equal to V until dcnt reaches 0

  @done_signal_exclusive @formal
  Formal Scenario: done is only asserted when dcnt equals zero
    Given rst_n is asserted (1)
    And dcnt is a symbolic value N
    When a rising edge of clk occurs
    Then done should be 1 if and only if N equals 4'h0

  @ld_r_delay @formal
  Formal Scenario: ld_r is a one-cycle delayed version of ld
    Given rst_n is asserted (1)
    And ld is a symbolic value L
    When a rising edge of clk occurs
    Then ld_r should be equal to L after the clock edge

  @key_expansion_interface @formal
  Formal Scenario: Round key words combine correctly to form 128-bit round key
    Given key expansion outputs wo_0, wo_1, wo_2, wo_3 each of width 32
    When the round key is formed
    Then the 128-bit round key should equal the concatenation of wo_0, wo_1, wo_2, wo_3