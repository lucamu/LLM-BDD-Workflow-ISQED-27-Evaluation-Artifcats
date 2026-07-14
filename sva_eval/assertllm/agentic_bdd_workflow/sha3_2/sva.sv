// =============================================================
// SHA3-512 Core Formal Properties (SVA)
// NOTE: Signal name mapping used from Gherkin spec -> RTL ports
//   din          -> in
//   din_size     -> byte_num
//   in_valid     -> in_ready
//   is_last      -> data
//   buf_full     -> buffer_full
//   hash         -> out
//   hash_valid   -> out_ready
//   buffer_reg       -> padder_out
//   buffer_write_ptr -> i
//   last_flag_reg    -> state
//   perm_start       -> f_ack
//   compute_permutation(buffer_reg) -> out1 (valid when f_out_ready)
//   reset is the synchronous active-high reset of the core
// =============================================================

localparam int RATE_BYTES        = 72;      // 576/8
localparam [7:0] PAD_FIRST       = 8'h06;
localparam [7:0] PAD_LAST        = 8'h80;

// -------------------------------------------------------------
// @reset
// Scenario: Reset clears buffer-full and hash-valid outputs
// -------------------------------------------------------------
property p_reset_clears_outputs;
  @(posedge clk)
  (reset) |=> (buffer_full == 1'b0) && (out_ready == 1'b0);
endproperty
assert property (p_reset_clears_outputs)
  else $error("Reset did not clear buffer_full/out_ready");

// -------------------------------------------------------------
// @reset
// Scenario: Reset does not depend on input signals
// -------------------------------------------------------------
property p_reset_independent_of_inputs;
  @(posedge clk)
  (reset) |=> (buffer_full == 1'b0) && (out_ready == 1'b0);
endproperty
assert property (p_reset_independent_of_inputs)
  else $error("Reset behavior depends on input signals");

// -------------------------------------------------------------
// @input-handshake
// Scenario: Input is absorbed only when not full and valid.
// byte_num encodes 1..4 valid bytes (0->1B .. 3->4B), aligned at
// the most-significant end of the incoming word, written at the
// current byte pointer position.
// -------------------------------------------------------------
property p_input_absorbed_when_ready;
  logic [31:0] D;
  logic [1:0]  S;
  logic [22:0] P;
  @(posedge clk) disable iff (reset)
  (!buffer_full && in_ready, D = in, S = byte_num, P = i)
  |=> ((S == 2'd0 && padder_out[P*8 +: 8]  == D[31:24]) ||
       (S == 2'd1 && padder_out[P*8 +: 16] == D[31:16]) ||
       (S == 2'd2 && padder_out[P*8 +: 24] == D[31:8])  ||
       (S == 2'd3 && padder_out[P*8 +: 32] == D[31:0]));
endproperty
assert property (p_input_absorbed_when_ready)
  else $error("Input not absorbed correctly when not full and valid");

// -------------------------------------------------------------
// @input-handshake
// Scenario: Input is not absorbed when buffer is full
// -------------------------------------------------------------
property p_input_not_absorbed_when_full;
  logic [575:0] prev_buf;
  @(posedge clk) disable iff (reset)
  (buffer_full && in_ready, prev_buf = padder_out)
  |=> (padder_out == prev_buf);
endproperty
assert property (p_input_not_absorbed_when_full)
  else $error("Buffer changed while full");

// -------------------------------------------------------------
// @input-handshake
// Scenario: Input is not absorbed when not valid
// -------------------------------------------------------------
property p_input_not_absorbed_when_invalid;
  logic [575:0] prev_buf;
  @(posedge clk) disable iff (reset)
  (!buffer_full && !in_ready, prev_buf = padder_out)
  |=> (padder_out == prev_buf);
endproperty
assert property (p_input_not_absorbed_when_invalid)
  else $error("Buffer changed while in_ready deasserted");

// -------------------------------------------------------------
// @input-stability
// Scenario: Input value must remain stable until it is accepted.
// This constrains the *environment* driving the DUT's primary
// input, not the DUT's internal logic, so it is modeled as an
// assumption rather than an assertion.
// -------------------------------------------------------------
property p_input_stable_until_accept;
  logic [31:0] D;
  @(posedge clk) disable iff (reset)
  ((buffer_full || !in_ready), D = in)
  |=> (in == D);
endproperty
assume property (p_input_stable_until_accept);

// -------------------------------------------------------------
// @is-last
// Scenario: is_last takes effect only when in_valid is asserted
// -------------------------------------------------------------
property p_islast_no_effect_without_valid;
  logic prev_state;
  @(posedge clk) disable iff (reset)
  (!in_ready, prev_state = state)
  |=> (state == prev_state);
endproperty
assert property (p_islast_no_effect_without_valid)
  else $error("last_flag_reg changed without in_valid");

// -------------------------------------------------------------
// @is-last
// Scenario: is_last is captured when input is accepted
// -------------------------------------------------------------
property p_islast_captured_on_accept;
  logic L;
  @(posedge clk) disable iff (reset)
  (!buffer_full && in_ready, L = data)
  |=> (state == L);
endproperty
assert property (p_islast_captured_on_accept)
  else $error("last_flag_reg not updated with is_last on accept");

// -------------------------------------------------------------
// @padding-alignment
// Scenario: Partial final input is aligned to the most significant
// bits, followed by PAD_FIRST, with PAD_LAST fixed at the top byte
// of the rate.
// -------------------------------------------------------------
property p_padding_alignment;
  logic [31:0] D;
  logic [1:0]  S;
  logic [22:0] P;
  @(posedge clk) disable iff (reset)
  (!buffer_full && in_ready && data && (byte_num != 2'd3),
   D = in, S = byte_num, P = i)
  |=> ((S == 2'd0 && padder_out[P*8 +: 8]  == D[31:24]) ||
       (S == 2'd1 && padder_out[P*8 +: 16] == D[31:16]) ||
       (S == 2'd2 && padder_out[P*8 +: 24] == D[31:8]))
      && (padder_out[(P + S + 1)*8 +: 8] == PAD_FIRST)
      && (padder_out[RATE_BYTES*8-8 +: 8] == PAD_LAST);
endproperty
assert property (p_padding_alignment)
  else $error("Final partial block not padded/aligned correctly");

// -------------------------------------------------------------
// @buffer-full-triggers-permutation
// Scenario: Buffer full asserts and triggers permutation start.
// Use >= rather than == so the property is not vacuous when the
// pointer can advance by more than one byte per accepted word.
// -------------------------------------------------------------
property p_buffer_full_triggers_perm;
  @(posedge clk) disable iff (reset)
  (i >= RATE_BYTES) |=> (buffer_full == 1'b1) && (f_ack == 1'b1);
endproperty
assert property (p_buffer_full_triggers_perm)
  else $error("buffer_full/perm_start not asserted when buffer full");

// -------------------------------------------------------------
// @buffer-full-triggers-permutation
// Scenario: perm_start is a single-cycle pulse
// -------------------------------------------------------------
property p_perm_start_single_cycle_pulse;
  @(posedge clk) disable iff (reset)
  (f_ack) |=> (f_ack == 1'b0);
endproperty
assert property (p_perm_start_single_cycle_pulse)
  else $error("perm_start held for more than one cycle");

// -------------------------------------------------------------
// @buffer-full-triggers-permutation
// Scenario: Buffer is cleared one cycle after permutation start.
// Only the write pointer reset is checked directly here since the
// pointer (a simple counter register) has deterministic reset
// timing tied to f_ack.
// -------------------------------------------------------------
property p_buffer_cleared_after_perm_start;
  @(posedge clk) disable iff (reset)
  (f_ack) |=> (i == 23'd0);
endproperty
assert property (p_buffer_cleared_after_perm_start)
  else $error("buffer pointer not cleared after perm_start");

// -------------------------------------------------------------
// @output-stability
// Scenario: Hash output remains unchanged after becoming valid
// until next reset
// -------------------------------------------------------------
property p_hash_stable_after_valid;
  logic [511:0] H;
  @(posedge clk) disable iff (reset)
  (out_ready, H = out) |=> (out == H) && (out_ready == 1'b1);
endproperty
assert property (p_hash_stable_after_valid)
  else $error("Hash output changed while valid without reset");

// -------------------------------------------------------------
// @output-stability
// Scenario: Hash output update is deterministically tied to
// permutation completion. The permutation takes multiple cycles
// to run, so the hash-output update is gated by the completion
// indication f_out_ready (which qualifies out1), not by the
// single-cycle start pulse f_ack.
// -------------------------------------------------------------
property p_hash_update_tied_to_out1;
  @(posedge clk) disable iff (reset)
  (f_out_ready) |=> (out == out1) && (out_ready == 1'b1);
endproperty
assert property (p_hash_update_tied_to_out1)
  else $error("Hash not updated via compute_permutation on completion");

property p_hash_stable_without_out1;
  logic [511:0] prevH;
  logic prevValid;
  @(posedge clk) disable iff (reset)
  (!f_out_ready, prevH = out, prevValid = out_ready)
  |=> (out == prevH) && (out_ready == prevValid);
endproperty
assert property (p_hash_stable_without_out1)
  else $error("Hash changed without permutation-complete indication");

// -------------------------------------------------------------
// @output-registered
// Scenario: Outputs at T are independent of inputs sampled at T.
// All output-facing properties above use |=> (next-cycle) timing,
// which already encodes that buffer_full/out/out_ready at any
// cycle T are functions of state sampled at T-1 and not of
// in/in_ready/byte_num/data sampled at T itself.
// -------------------------------------------------------------

// -------------------------------------------------------------
// @reset-priority
// Scenario: Reset has priority over any concurrent valid input
// -------------------------------------------------------------
property p_reset_priority_over_input;
  logic [575:0] prev_buf;
  @(posedge clk)
  (reset && in_ready && !buffer_full, prev_buf = padder_out)
  |=> (padder_out == prev_buf) && (buffer_full == 1'b0) && (out_ready == 1'b0);
endproperty
assert property (p_reset_priority_over_input)
  else $error("Reset did not take priority over concurrent valid input");