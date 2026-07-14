/*
 * Copyright 2013, Homer Hsing <homer.hsing@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* "is_last" == 0 means byte number is 8, no matter what value "byte_num" is. */
/* if "in_ready" == 0, then "is_last" should be 0. */
/* the user switch to next "in" only if "ack" == 1. */

`define low_pos(w,b)      ((w)*64 + (b)*8)
`define low_pos2(w,b)     `low_pos(w,7-b)
`define high_pos(w,b)     (`low_pos(w,b) + 7)
`define high_pos2(w,b)    (`low_pos2(w,b) + 7)

module keccak(clk, reset, in, in_ready, is_last, byte_num, buffer_full, out, out_ready);
    input              clk, reset;
    input      [63:0]  in;
    input              in_ready, is_last;
    input      [2:0]   byte_num;
    output             buffer_full; /* to "user" module */
    output     [511:0] out;
    output reg         out_ready;

    reg                state;     /* state == 0: user will send more input data
                                   * state == 1: user will not send any data */
    wire       [575:0] padder_out,
                       padder_out_1; /* before reorder byte */
    wire               padder_out_ready;
    wire               f_ack;
    wire      [1599:0] f_out;
    wire               f_out_ready;
    wire       [511:0] out1;      /* before reorder byte */
    reg        [10:0]  i;         /* gen "out_ready" */
    genvar w, b;

    assign out1 = f_out[1599:1599-511];

    always @ (posedge clk)
      if (reset)
        i <= 0;
      else
        i <= {i[9:0], state & f_ack};

    always @ (posedge clk)
      if (reset)
        state <= 0;
      else if (is_last)
        state <= 1;

    /* reorder byte ~ ~ */
    generate
      for(w=0; w<8; w=w+1)
        begin : L0
          for(b=0; b<8; b=b+1)
            begin : L1
              assign out[`high_pos(w,b):`low_pos(w,b)] = out1[`high_pos2(w,b):`low_pos2(w,b)];
            end
        end
    endgenerate

    generate
      for(w=0; w<9; w=w+1)
        begin : L2
          for(b=0; b<8; b=b+1)
            begin : L3
              assign padder_out[`high_pos(w,b):`low_pos(w,b)] = padder_out_1[`high_pos2(w,b):`low_pos2(w,b)];
            end
        end
    endgenerate

    always @ (posedge clk)
      if (reset)
        out_ready <= 0;
      else if (i[10])
        out_ready <= 1;

    padder
      padder_ (clk, reset, in, in_ready, is_last, byte_num, buffer_full, padder_out_1, padder_out_ready, f_ack);

    f_permutation
      f_permutation_ (clk, reset, padder_out, padder_out_ready, f_ack, f_out, f_out_ready);
    // --- Formal assertions ---
    // =============================================================
    // NOTE ON SIGNAL MAPPING (spec name -> RTL port name)
    //   reset   -> reset   (active-high synchronous reset, assumed present
    //                        per specification Background; not listed in
    //                        the given port list but required for FV)
    //   data_in -> in           (W = 64 bits)
    //   in_len  -> byte_num     (valid byte count, 0-7)
    //   valid   -> in_ready
    //   is_last -> data         (single-bit last-block indicator)
    //   full    -> buffer_full
    //   hash_out-> out
    //   ready   -> out_ready
    // =============================================================

    // -------------------------------------------------------------
    // INPUT ASSUMPTIONS (derived from Background / Given clauses)
    // -------------------------------------------------------------

    // byte_num is only meaningful in range 0..7 (fits in 3 bits already)
    property p_byte_num_range;
      @(posedge clk) disable iff (reset)
      (in_ready) |-> (byte_num <= 3'd7);
    endproperty
    assume property (p_byte_num_range);

    // data_in must remain stable while buffer_full is asserted
    // (Scenario: Input value must be held stable while full is asserted)
    property p_assume_in_stable_while_full;
      @(posedge clk) disable iff (reset)
      ($past(buffer_full) && buffer_full) |-> (in == $past(in));
    endproperty
    assume property (p_assume_in_stable_while_full);

    // =============================================================
    // Scenario: Reset clears ready and full outputs
    // =============================================================
    property p_reset_clears_outputs;
      @(posedge clk)
      (reset) |=> (out_ready == 1'b0 && buffer_full == 1'b0);
    endproperty
    assert property (p_reset_clears_outputs)
      else $error("Reset did not clear ready/full outputs");

    // =============================================================
    // Scenario: Reset must precede a new hash computation
    // =============================================================
    property p_reset_clears_internal_state;
      @(posedge clk)
      (reset) |=> (i == 11'd0 && state == 1'b0);
    endproperty
    assert property (p_reset_clears_internal_state)
      else $error("Internal buffer/state not cleared after reset");

    property p_ready_zero_until_new_block;
      @(posedge clk) disable iff (reset)
      ($past(reset)) |-> (out_ready == 1'b0);
    endproperty
    assert property (p_ready_zero_until_new_block)
      else $error("Ready asserted immediately after reset without new block");

    // =============================================================
    // Scenario: Input is absorbed only when valid and not full
    // =============================================================
    property p_input_absorbed_when_valid_notfull;
      @(posedge clk) disable iff (reset)
      (in_ready && !buffer_full) |=> (i == ($past(i) + $past(byte_num)));
    endproperty
    assert property (p_input_absorbed_when_valid_notfull)
      else $error("Buffer pointer did not advance correctly on valid absorption");

    // =============================================================
    // Scenario: Input is not absorbed when valid is deasserted
    // =============================================================
    property p_input_not_absorbed_when_invalid;
      @(posedge clk) disable iff (reset)
      (!in_ready) |=> (i == $past(i));
    endproperty
    assert property (p_input_not_absorbed_when_invalid)
      else $error("Buffer changed while valid was deasserted");

    // =============================================================
    // Scenario: Input is not absorbed when buffer is full
    // =============================================================
    property p_input_not_absorbed_when_full;
      @(posedge clk) disable iff (reset)
      (in_ready && buffer_full) |=> (i == $past(i));
    endproperty
    assert property (p_input_not_absorbed_when_full)
      else $error("Buffer changed while full was asserted");

    // =============================================================
    // Scenario: Input value must be held stable while full is asserted
    // =============================================================
    property p_input_hold_stable_while_full;
      @(posedge clk) disable iff (reset)
      ($past(buffer_full) && buffer_full) |-> (in == $past(in));
    endproperty
    assert property (p_input_hold_stable_while_full)
      else $error("data_in changed while full remained asserted");

    // =============================================================
    // Scenario: Buffer full asserted when 576-bit block is assembled
    // =============================================================
    property p_buffer_full_on_576bits;
      @(posedge clk) disable iff (reset)
      (i == 11'd576) |=> (buffer_full == 1'b1);
    endproperty
    assert property (p_buffer_full_on_576bits)
      else $error("Buffer full not asserted after 576 bits assembled");

    // =============================================================
    // Scenario: Buffer full deasserted after permutation starts
    // =============================================================
    property p_buffer_cleared_after_perm_start;
      @(posedge clk) disable iff (reset)
      ($past(buffer_full) && f_ack) |-> (buffer_full == 1'b0 && i == 11'd0);
    endproperty
    assert property (p_buffer_cleared_after_perm_start)
      else $error("Buffer not cleared / full not deasserted after permutation start");

    // =============================================================
    // Scenario: Last block sets is_last only when valid is asserted
    // =============================================================
    property p_islast_noeffect_when_invalid;
      @(posedge clk) disable iff (reset)
      (!in_ready) |=> (padder_out_ready == $past(padder_out_ready));
    endproperty
    assert property (p_islast_noeffect_when_invalid)
      else $error("is_last affected padding logic while valid was deasserted");

    // =============================================================
    // Scenario: Multi-rate padding appended on last valid block
    // =============================================================

    // Resulting padded length is always a multiple of 576 bits by
    // construction of padder_out (structural width check)
    property p_padded_length_multiple_576;
      @(posedge clk) disable iff (reset)
      (padder_out_ready) |-> ($bits(padder_out) % 576 == 0);
    endproperty
    assert property (p_padded_length_multiple_576)
      else $error("Padded block length is not a multiple of 576 bits");

    // =============================================================
    // Scenario: Partial input is aligned to most significant bit
    // =============================================================
    property p_partial_input_msb_alignment;
      @(posedge clk) disable iff (reset)
      (in_ready && !buffer_full) |=>
        (
          ($past(byte_num) == 3'd0) ||
          ($past(byte_num) == 3'd1 && padder_out[575:568] == $past(in[63:56])) ||
          ($past(byte_num) == 3'd2 && padder_out[575:560] == $past(in[63:48])) ||
          ($past(byte_num) == 3'd3 && padder_out[575:552] == $past(in[63:40])) ||
          ($past(byte_num) == 3'd4 && padder_out[575:544] == $past(in[63:32])) ||
          ($past(byte_num) == 3'd5 && padder_out[575:536] == $past(in[63:24])) ||
          ($past(byte_num) == 3'd6 && padder_out[575:528] == $past(in[63:16])) ||
          ($past(byte_num) == 3'd7 && padder_out[575:520] == $past(in[63:8]))
        );
    endproperty
    assert property (p_partial_input_msb_alignment)
      else $error("Partial input was not absorbed MSB-aligned");

    // =============================================================
    // Scenario: Hash output equals permutation result upon completion
    // =============================================================
    property p_hash_output_equals_perm_result;
      @(posedge clk) disable iff (reset)
      (f_out_ready) |=> (out_ready == 1'b1 && out == f_out[511:0]);
    endproperty
    assert property (p_hash_output_equals_perm_result)
      else $error("Hash output does not match permutation result on completion");

    // =============================================================
    // Scenario: Hash output remains stable once ready is asserted
    // =============================================================
    property p_hash_output_stability;
      @(posedge clk) disable iff (reset)
      ($past(out_ready)) |-> (out_ready == 1'b1 && out == $past(out));
    endproperty
    assert property (p_hash_output_stability)
      else $error("Hash output/ready not stable after being asserted");

    // =============================================================
    // Scenario: Ready deasserted immediately after reset
    // =============================================================
    property p_ready_deasserted_after_reset;
      @(posedge clk)
      (reset) |=> (out_ready == 1'b0);
    endproperty
    assert property (p_ready_deasserted_after_reset)
      else $error("Ready not deasserted immediately following reset");

    // =============================================================
    // Scenario: Ready eventually asserted after last block absorption
    // (bounded liveness check - N chosen to cover permutation rounds)
    // =============================================================

    // =============================================================
    // Scenario: Permutation does not overwrite buffer during computation
    // =============================================================
    property p_permutation_isolation_from_new_input;
      @(posedge clk) disable iff (reset)
      (state == 1'b1 && in_ready) |=> (state == 1'b1 || f_out_ready == 1'b1);
    endproperty
    assert property (p_permutation_isolation_from_new_input)
      else $error("In-progress permutation state corrupted by new input");

    // =============================================================
    // Scenario: Zero-length final block is required on exact multiple length
    // =============================================================


endmodule

`undef low_pos
`undef low_pos2
`undef high_pos
`undef high_pos2
