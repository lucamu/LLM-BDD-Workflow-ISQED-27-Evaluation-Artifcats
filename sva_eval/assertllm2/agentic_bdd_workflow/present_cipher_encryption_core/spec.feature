Feature: PRESENT-80 Encryptor Top-Level Control and Datapath

  Formal verification of `present_encryptor_top`, an iterative single-round
  PRESENT-80 encryption core. Properties verify the priority-encoded load
  control logic, the combinational output path, and the per-round state,
  key, and counter update functions.

  Background:
    Given the design has no reset input
    And all state elements update only on the rising edge of clk_i
    And the state register is "state" with width 64
    And the key register is "key" with width 80
    And the round counter register is "round_counter" with width 5
    And the round key is defined as key[79:16]
    And the combinational value "sub_per_input" is defined as state XOR round_key
    And data_o is continuously driven by sub_per_input

  @key_load_priority
  Formal Scenario: key_load takes priority over data_load on the same cycle
    Given key register holds value K
    And state register holds value S
    And round_counter register holds value R
    And data_i holds value D
    And key_load is 1
    And data_load is 1
    When a rising clock edge occurs
    Then key register should become D
    And state register should remain S
    And round_counter register should remain R

  @key_load_only
  Formal Scenario: key_load asserted alone loads the key register
    Given key register holds value K
    And state register holds value S
    And round_counter register holds value R
    And data_i holds value D
    And key_load is 1
    And data_load is 0
    When a rising clock edge occurs
    Then key register should become D
    And state register should remain S
    And round_counter register should remain R

  @data_load_effect
  Formal Scenario: data_load asserted with key_load deasserted loads state and initializes round counter
    Given key register holds value K
    And state register holds value S
    And round_counter register holds value R
    And data_i holds value D
    And key_load is 0
    And data_load is 1
    When a rising clock edge occurs
    Then state register should become D[63:0]
    And round_counter register should become 5'b00001
    And key register should remain K

  @iterative_round_state_update
  Formal Scenario: iterative round step updates state via sub_per of key-added state
    Given key register holds value K
    And state register holds value S
    And round_counter register holds value R
    And key_load is 0
    And data_load is 0
    When a rising clock edge occurs
    Then state register should become sub_per(S XOR K[79:16])

  @iterative_round_key_update
  Formal Scenario: iterative round step updates key register via key_update function
    Given key register holds value K
    And state register holds value S
    And round_counter register holds value R
    And key_load is 0
    And data_load is 0
    When a rising clock edge occurs
    Then key register should become key_update(K, R)

  @iterative_round_counter_increment
  Formal Scenario: iterative round step increments the round counter by one
    Given key register holds value K
    And state register holds value S
    And round_counter register holds value R
    And key_load is 0
    And data_load is 0
    When a rising clock edge occurs
    Then round_counter register should become R + 1

  @output_combinational_path
  Formal Scenario: data_o equals state XOR round key regardless of control inputs
    Given key register holds value K
    And state register holds value S
    And key_load holds any value
    And data_load holds any value
    And data_i holds any value
    When data_o is sampled combinationally
    Then data_o should equal S XOR K[79:16]

  @round_key_extraction
  Formal Scenario: round key is always the upper 64 bits of the key register
    Given key register holds value K
    When round_key is sampled combinationally
    Then round_key should equal K[79:16]

  @state_hold_on_key_load
  Formal Scenario: state register does not change when key_load is asserted
    Given key register holds value K
    And state register holds value S
    And round_counter register holds value R
    And data_i holds any value
    And key_load is 1
    And data_load holds any value
    When a rising clock edge occurs
    Then state register should remain S

  @round_counter_hold_on_key_load
  Formal Scenario: round counter does not change when key_load is asserted
    Given key register holds value K
    And state register holds value S
    And round_counter register holds value R
    And data_i holds any value
    And key_load is 1
    And data_load holds any value
    When a rising clock edge occurs
    Then round_counter register should remain R

  @key_hold_on_data_load_only
  Formal Scenario: key register does not change when only data_load is asserted
    Given key register holds value K
    And state register holds value S
    And round_counter register holds value R
    And data_i holds value D
    And key_load is 0
    And data_load is 1
    When a rising clock edge occurs
    Then key register should remain K