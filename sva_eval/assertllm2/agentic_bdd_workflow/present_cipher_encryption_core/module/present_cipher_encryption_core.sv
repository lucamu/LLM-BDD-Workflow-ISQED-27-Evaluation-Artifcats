//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//
// Design Name: Present Cipher Encryption Core                    //
// Module Name: present_encryptor_top                             //
// Language:    Verilog                                           //
// Date Created: 1/16/2011                                        //
// Author: Reza Ameli                                             //
//         Digital Systems Lab                                    //
//         Ferdowsi University of Mashhad, Iran                   //
//         http://commeng.um.ac.ir/dslab                          //
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//
//                                                                //
// This source file may be used and distributed without           //
// restriction provided that this copyright statement is not      //
// removed from the file and that any derivative work contains    //
// the original copyright notice and the associated disclaimer.   //
//                                                                //
// This source file is free software; you can redistribute it     //
// and/or modify it under the terms of the GNU Lesser General     //
// Public License as published by the Free Software Foundation;   //
// either version 2.1 of the License, or (at your option) any     //
// later version.                                                 //
//                                                                //
// This source is distributed in the hope that it will be         //
// useful, but WITHOUT ANY WARRANTY; without even the implied     //
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR        //
// PURPOSE. See the GNU Lesser General Public License for more    //
// details.                                                       //
//                                                                //
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//

// Port list style aligned with mips_16_core_top: `module name` then `(` / one port per line / `);`
// Use `input clk_i` not `input wire clk_i` for 1-bit (AgentFlow decl line parser).
module present_encryptor_top
(
    output [63:0] data_o,
    input [79:0] data_i,
    input clk_i,
    input key_load,
    input data_load
);

//- Variables, Registers and Parameters ---------------------------------------

reg  [63 : 0] state; // 64-bit state of the cipher
reg  [4  : 0] round_counter; // 5-bit round-counter (from 1 to 31)
reg  [79 : 0] key; // 80-bit register holding the key and updates of the key

wire [63 : 0] round_key; // 64-bit round-key. The round-keys are derived from the key register
wire [63 : 0] sub_per_input; // 64-bit input to the substitution-permutation network
wire [63 : 0] sub_per_output; // 64-bit output of the substitution-permutation network
wire [79 : 0] key_update_output; // 80-bit output of the keyupdate procedure. This value replaces the value of the key register

//- Instantiations ------------------------------------------------------------

sub_per present_cipher_sp(.data_o(sub_per_output),.data_i(sub_per_input)); 
    // instantion of  substitution and permutation module
    // this module is used 31 times iteratively

key_update present_cipher_key_update(.data_o(key_update_output),.data_i(key),.round_counter(round_counter)); 
    // instantiation of the key-update procedure
    // this module is used 31 times iteratively
    
//- Continuous Assigments------------------------------------------------------

assign round_key = key[79:16]; // iurrent round-key is the 64 left most bits of the key register

assign sub_per_input = state^round_key; // input to the Substitution-Permutation network is the cipher state xored by the round key

assign data_o = sub_per_input; // the output of the cipher will finally be one of the inputs to the Substitution-Permutation network.
                             // output will be valid when round-counter is 31

//- Behavioral Statements -----------------------------------------------------

always @(posedge clk_i)
begin
    if(key_load) // loading the key
    begin
        key <= data_i;
    end
    else if(!key_load) // not loading the key
    begin
        if(data_load) // loading plaintext
        begin
            state <= data_i[63:0];
            round_counter <= 5'b00001; // round_counter starts from 1 and ends at 31
        end
        else if(!data_load) // normal operation (neither loading the key nor loading the plaitext)
        begin                  
            round_counter <= round_counter + 1'b1; // round counter is increased by one
            state <= sub_per_output; // state is updated
            key <= key_update_output; // key register is updated
        end
    end
end
//-----------------------------------------------------------------------------
// --- Formal assertions ---
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


endmodule
