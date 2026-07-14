// =====================================================================
// SVA Properties for present_encryptor_top
// NOTE: Design has no reset input (per specification background).
// All properties restructured as single-cycle, $past-gated checks to
// avoid multi-cycle induction over unconstrained initial state.
// =====================================================================

// ---------------------------------------------------------------------
// Scenario: key_load takes priority over data_load on the same cycle
// ---------------------------------------------------------------------
property p_key_load_priority;
  @(posedge clk_i)
  $past(key_load && data_load) |->
    (key           == $past(data_i))       &&
    (state         == $past(state))        &&
    (round_counter == $past(round_counter));
endproperty
assert property (p_key_load_priority)
  else $error("key_load_priority violated");

// ---------------------------------------------------------------------
// Scenario: key_load asserted alone loads the key register
// ---------------------------------------------------------------------
property p_key_load_only;
  @(posedge clk_i)
  $past(key_load && !data_load) |->
    (key           == $past(data_i))       &&
    (state         == $past(state))        &&
    (round_counter == $past(round_counter));
endproperty
assert property (p_key_load_only)
  else $error("key_load_only violated");

// ---------------------------------------------------------------------
// Scenario: data_load asserted with key_load deasserted loads state
// and initializes round counter
// ---------------------------------------------------------------------
property p_data_load_effect;
  @(posedge clk_i)
  $past(!key_load && data_load) |->
    (state         == $past(data_i[63:0])) &&
    (round_counter == 5'b00001)            &&
    (key           == $past(key));
endproperty
assert property (p_data_load_effect)
  else $error("data_load_effect violated");

// ---------------------------------------------------------------------
// Scenario: iterative round step updates state via sub_per of
// key-added state. Uses RTL's own combinational round-function
// output wire (sub_per_output) as structural register-input equality.
// ---------------------------------------------------------------------
property p_iterative_round_state_update;
  @(posedge clk_i)
  $past(!key_load && !data_load) |->
    (state == $past(sub_per_output));
endproperty
assert property (p_iterative_round_state_update)
  else $error("iterative_round_state_update violated");

// ---------------------------------------------------------------------
// Scenario: iterative round step updates key register via
// key_update function. Uses RTL's own combinational key-schedule
// output wire (key_update_output) as structural register-input equality.
// ---------------------------------------------------------------------
property p_iterative_round_key_update;
  @(posedge clk_i)
  $past(!key_load && !data_load) |->
    (key == $past(key_update_output));
endproperty
assert property (p_iterative_round_key_update)
  else $error("iterative_round_key_update violated");

// ---------------------------------------------------------------------
// Scenario: iterative round step increments the round counter by one
// ---------------------------------------------------------------------
property p_iterative_round_counter_increment;
  @(posedge clk_i)
  $past(!key_load && !data_load) |->
    (round_counter == ($past(round_counter) + 5'b00001));
endproperty
assert property (p_iterative_round_counter_increment)
  else $error("iterative_round_counter_increment violated");

// ---------------------------------------------------------------------
// Scenario: data_o equals state XOR round key regardless of control
// inputs (purely combinational passthrough)
// ---------------------------------------------------------------------
property p_output_combinational_path;
  @(posedge clk_i)
  1'b1 |-> (data_o == (state ^ round_key));
endproperty
assert property (p_output_combinational_path)
  else $error("output_combinational_path violated");

// ---------------------------------------------------------------------
// Scenario: round key is always the upper 64 bits of the key register
// (purely combinational, direct bit-select check)
// ---------------------------------------------------------------------
property p_round_key_extraction;
  @(posedge clk_i)
  1'b1 |-> (round_key == key[79:16]);
endproperty
assert property (p_round_key_extraction)
  else $error("round_key_extraction violated");

// ---------------------------------------------------------------------
// Scenario: state register does not change when key_load is asserted
// ---------------------------------------------------------------------
property p_state_hold_on_key_load;
  @(posedge clk_i)
  $past(key_load) |-> (state == $past(state));
endproperty
assert property (p_state_hold_on_key_load)
  else $error("state_hold_on_key_load violated");

// ---------------------------------------------------------------------
// Scenario: round counter does not change when key_load is asserted
// ---------------------------------------------------------------------
property p_round_counter_hold_on_key_load;
  @(posedge clk_i)
  $past(key_load) |-> (round_counter == $past(round_counter));
endproperty
assert property (p_round_counter_hold_on_key_load)
  else $error("round_counter_hold_on_key_load violated");

// ---------------------------------------------------------------------
// Scenario: key register does not change when only data_load is
// asserted
// ---------------------------------------------------------------------
property p_key_hold_on_data_load_only;
  @(posedge clk_i)
  $past(!key_load && data_load) |-> (key == $past(key));
endproperty
assert property (p_key_hold_on_data_load_only)
  else $error("key_hold_on_data_load_only violated");