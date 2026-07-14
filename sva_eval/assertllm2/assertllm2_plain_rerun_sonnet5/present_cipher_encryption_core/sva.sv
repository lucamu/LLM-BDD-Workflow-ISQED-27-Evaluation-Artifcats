// method: plain_prompt

// Global checker bound to top module: present_encryptor_top
module present_encryptor_top_sva_global (
    input logic [79:0] key_update_data_i,
    input logic [79:0] key_update_data_o,
    input logic [4:0] key_update_round_counter,
    input logic [63:0] sub_per_data_i,
    input logic [63:0] sub_per_data_o,
    input logic top_clk_i,
    input logic [79:0] top_data_i,
    input logic top_data_load,
    input logic [63:0] top_data_o,
    input logic [79:0] top_key,
    input logic top_key_load,
    input logic [79:0] top_key_update_output,
    input logic [4:0] top_round_counter,
    input logic [63:0] top_sub_per_input,
    input logic [63:0] top_sub_per_output
);

//======================================================================
// Assertions for Signal: top_data_o
// Primary label from model: top_data_o
//======================================================================
always_comb begin
  // data_o is continuously driven by the post-XOR round-key-addition value (sub_per_input), per spec 4.2/5.3
  assert (top_data_o == top_sub_per_input);
  // Combinational output must always be a known, driven value
  assert (!$isunknown(top_data_o));
end


//======================================================================
// Assertions for Signal: top_sub_per_input
// Primary label from model: top_sub_per_input
//======================================================================
always_comb begin
  // sub_per_input is the combinational value fed into the sub_per submodule's data_i port
  assert (top_sub_per_input == sub_per_data_i);
  // sub_per_input must be a known, driven 64-bit value
  assert (!$isunknown(top_sub_per_input));
end


//======================================================================
// Assertions for Signal: top_sub_per_output
// Primary label from model: top_sub_per_output
//======================================================================
always_comb begin
  // sub_per_output must equal the value produced by the sub_per submodule's data_o port
  assert (top_sub_per_output == sub_per_data_o);
end


//======================================================================
// Assertions for Signal: top_key_update_output
// Primary label from model: top_key_update_output
//======================================================================
always_comb begin
  // key_update_output must equal the value produced by the key_update submodule's data_o port
  assert (top_key_update_output == key_update_data_o);
end


//======================================================================
// Assertions for Signal: key_update_data_i
// Primary label from model: key_update_data_i
//======================================================================
always_comb begin
  // key_update submodule's data_i input must reflect the current key register value
  assert (key_update_data_i == top_key);
end


//======================================================================
// Assertions for Signal: key_update_round_counter
// Primary label from model: key_update_round_counter
//======================================================================
always_comb begin
  // key_update submodule's round_counter input must match the current round counter value
  assert (key_update_round_counter == top_round_counter);
end
endmodule

