Feature: TopModule Combinational Next-State and Output Logic for One-Hot Moore FSM

  This is a purely combinational block that computes next-state indicator
  signals and Moore output signals from the current one-hot state vector
  and the primitive inputs d, done_counting, and ack. The one-hot encoding
  bit order (LSB to MSB) is:
  state[0]=S, state[1]=S1, state[2]=S11, state[3]=S110, state[4]=B0,
  state[5]=B1, state[6]=B2, state[7]=B3, state[8]=Count, state[9]=Wait

  Background:
    Given the design is fully combinational with no clock or reset
    And state is a 10-bit one-hot vector where exactly one bit is 1
    And d, done_counting, and ack are single-bit inputs

  @next_state @S_next
  Formal Scenario: S_next asserts when current state is S and d is 0
    Given state equals 10'b0000000001 representing state S
    And d equals 0
    Then S_next should be 1

  @next_state @S_next
  Formal Scenario: S_next asserts when current state is S1 and d is 0
    Given state equals 10'b0000000010 representing state S1
    And d equals 0
    Then S_next should be 1

  @next_state @S_next
  Formal Scenario: S_next asserts when current state is S110 and d is 0
    Given state equals 10'b0000001000 representing state S110
    And d equals 0
    Then S_next should be 1

  @next_state @S_next
  Formal Scenario: S_next asserts when current state is Wait and ack is 1
    Given state equals 10'b1000000000 representing state Wait
    And ack equals 1
    Then S_next should be 1

  @next_state @S_next
  Formal Scenario: S_next deasserts when no transition condition to S holds
    Given state equals value X representing any valid one-hot state
    And d equals value Dv
    And ack equals value Av
    And state, d, and ack do not match any of the four transition conditions leading to S
    Then S_next should be 0 unless (state[0]=1 and d=0) or (state[1]=1 and d=0) or (state[3]=1 and d=0) or (state[9]=1 and ack=1)

  @next_state @S1_next
  Formal Scenario: S1_next asserts when current state is S and d is 1
    Given state equals 10'b0000000001 representing state S
    And d equals 1
    Then S1_next should be 1

  @next_state @S1_next
  Formal Scenario: S1_next deasserts when current state is not S
    Given state equals value X representing any valid one-hot state
    And state[0] equals 0
    Then S1_next should be 0

  @next_state @Count_next
  Formal Scenario: Count_next asserts when current state is B3
    Given state equals 10'b0010000000 representing state B3
    Then Count_next should be 1

  @next_state @Count_next
  Formal Scenario: Count_next deasserts when current state is not B3
    Given state equals value X representing any valid one-hot state
    And state[7] equals 0
    Then Count_next should be 0

  @next_state @Wait_next
  Formal Scenario: Wait_next asserts when current state is Count and done_counting is 1
    Given state equals 10'b0100000000 representing state Count
    And done_counting equals 1
    Then Wait_next should be 1

  @next_state @Wait_next
  Formal Scenario: Wait_next deasserts when current state is Count and done_counting is 0
    Given state equals 10'b0100000000 representing state Count
    And done_counting equals 0
    Then Wait_next should be 0

  @next_state @Wait_next
  Formal Scenario: Wait_next deasserts when current state is not Count
    Given state equals value X representing any valid one-hot state
    And state[8] equals 0
    Then Wait_next should be 0

  @next_state @B3_next
  Formal Scenario: B3_next asserts when current state is B2
    Given state equals 10'b0001000000 representing state B2
    Then B3_next should be 1

  @next_state @B3_next
  Formal Scenario: B3_next deasserts when current state is not B2
    Given state equals value X representing any valid one-hot state
    And state[6] equals 0
    Then B3_next should be 0

  @output @done
  Formal Scenario: done asserts only in Wait state
    Given state equals value X representing any valid one-hot state
    Then done should equal state[9]

  @output @counting
  Formal Scenario: counting asserts only in Count state
    Given state equals value X representing any valid one-hot state
    Then counting should equal state[8]

  @output @shift_ena
  Formal Scenario: shift_ena asserts in any of the four shift states B0, B1, B2, B3
    Given state equals value X representing any valid one-hot state
    Then shift_ena should equal (state[4] or state[5] or state[6] or state[7])

  @output @shift_ena
  Formal Scenario: shift_ena deasserts outside shift states
    Given state equals value X representing any valid one-hot state
    And state[4] equals 0
    And state[5] equals 0
    And state[6] equals 0
    And state[7] equals 0
    Then shift_ena should be 0

  @output @done
  Formal Scenario: done deasserts outside Wait state
    Given state equals value X representing any valid one-hot state
    And state[9] equals 0
    Then done should be 0

  @output @counting
  Formal Scenario: counting deasserts outside Count state
    Given state equals value X representing any valid one-hot state
    And state[8] equals 0
    Then counting should be 0