// method: plain_prompt

// Global checker bound to top module: aes_cipher_top
module aes_cipher_top_sva_global (
    input logic aes_key_expand_128_clk,
    input logic [127:0] aes_key_expand_128_key,
    input logic aes_key_expand_128_kld,
    input logic [31:0] aes_key_expand_128_subword,
    input logic [31:0] aes_key_expand_128_tmp_w,
    input logic [31:0] aes_key_expand_128_wo_0,
    input logic [31:0] aes_key_expand_128_wo_1,
    input logic [31:0] aes_key_expand_128_wo_2,
    input logic [31:0] aes_key_expand_128_wo_3,
    input logic [7:0] aes_sbox_a,
    input logic [7:0] aes_sbox_b,
    input logic top_clk,
    input logic top_done,
    input logic [127:0] top_key,
    input logic top_ld,
    input logic top_rst_n,
    input logic [7:0] top_sa00,
    input logic [7:0] top_sa00_sub,
    input logic [7:0] top_sa01,
    input logic [7:0] top_sa01_sub,
    input logic [7:0] top_sa02,
    input logic [7:0] top_sa02_sub,
    input logic [7:0] top_sa03,
    input logic [7:0] top_sa03_sub,
    input logic [7:0] top_sa10,
    input logic [7:0] top_sa10_sub,
    input logic [7:0] top_sa11,
    input logic [7:0] top_sa11_sub,
    input logic [7:0] top_sa12,
    input logic [7:0] top_sa12_sub,
    input logic [7:0] top_sa13,
    input logic [7:0] top_sa13_sub,
    input logic [7:0] top_sa20,
    input logic [7:0] top_sa20_sub,
    input logic [7:0] top_sa21,
    input logic [7:0] top_sa21_sub,
    input logic [7:0] top_sa22,
    input logic [7:0] top_sa22_sub,
    input logic [7:0] top_sa23,
    input logic [7:0] top_sa23_sub,
    input logic [7:0] top_sa30,
    input logic [7:0] top_sa30_sub,
    input logic [7:0] top_sa31,
    input logic [7:0] top_sa31_sub,
    input logic [7:0] top_sa32,
    input logic [7:0] top_sa32_sub,
    input logic [7:0] top_sa33,
    input logic [7:0] top_sa33_sub,
    input logic [127:0] top_text_in,
    input logic [127:0] top_text_out,
    input logic [31:0] top_w0,
    input logic [31:0] top_w1,
    input logic [31:0] top_w2,
    input logic [31:0] top_w3
);

//======================================================================
// Assertions for Signal: top_done
// Primary label from model: top_done
//======================================================================
// done is a control flag and must always be a legal single-bit value
always_comb begin
  assert (top_done === 1'b0 || top_done === 1'b1);
end


//======================================================================
// Assertions for Signal: top_ld
// Primary label from model: top_ld
//======================================================================
// ld is a load enable control signal and must always be a legal single-bit value
always_comb begin
  assert (top_ld === 1'b0 || top_ld === 1'b1);
end


//======================================================================
// Assertions for Signal: top_rst_n
// Primary label from model: top_rst_n
//======================================================================
// rst_n is a reset control signal and must always be a legal single-bit value
always_comb begin
  assert (top_rst_n === 1'b0 || top_rst_n === 1'b1);
end


//======================================================================
// Assertions for Signal: top_text_out
// Primary label from model: top_text_out
//======================================================================
// Ciphertext output must be fully known once encryption is indicated complete
always_comb begin
  if (top_done)
    assert (!$isunknown(top_text_out));
end


//======================================================================
// Assertions for Signal: top_w0
// Primary label from model: top_w0
//======================================================================
// Round key word 0 used by the cipher datapath must match the key expansion module output
always_comb begin
  assert (top_w0 === aes_key_expand_128_wo_0);
end


//======================================================================
// Assertions for Signal: top_w1
// Primary label from model: top_w1
//======================================================================
// Round key word 1 used by the cipher datapath must match the key expansion module output
always_comb begin
  assert (top_w1 === aes_key_expand_128_wo_1);
end


//======================================================================
// Assertions for Signal: top_w2
// Primary label from model: top_w2
//======================================================================
// Round key word 2 used by the cipher datapath must match the key expansion module output
always_comb begin
  assert (top_w2 === aes_key_expand_128_wo_2);
end


//======================================================================
// Assertions for Signal: top_w3
// Primary label from model: top_w3
//======================================================================
// Round key word 3 used by the cipher datapath must match the key expansion module output
always_comb begin
  assert (top_w3 === aes_key_expand_128_wo_3);
end


//======================================================================
// Assertions for Signal: top_sa00_sub
// Primary label from model: top_sa00_sub
//======================================================================
// SubBytes transformation is pure combinational logic: output must be known when input byte is known
always_comb begin
  if (!$isunknown(top_sa00))
    assert (!$isunknown(top_sa00_sub));
end


//======================================================================
// Assertions for Signal: top_sa01_sub
// Primary label from model: top_sa01_sub
//======================================================================
// SubBytes transformation is pure combinational logic: output must be known when input byte is known
always_comb begin
  if (!$isunknown(top_sa01))
    assert (!$isunknown(top_sa01_sub));
end


//======================================================================
// Assertions for Signal: top_sa02_sub
// Primary label from model: top_sa02_sub
//======================================================================
// SubBytes transformation is pure combinational logic: output must be known when input byte is known
always_comb begin
  if (!$isunknown(top_sa02))
    assert (!$isunknown(top_sa02_sub));
end


//======================================================================
// Assertions for Signal: top_sa03_sub
// Primary label from model: top_sa03_sub
//======================================================================
// SubBytes transformation is pure combinational logic: output must be known when input byte is known
always_comb begin
  if (!$isunknown(top_sa03))
    assert (!$isunknown(top_sa03_sub));
end


//======================================================================
// Assertions for Signal: top_sa10_sub
// Primary label from model: top_sa10_sub
//======================================================================
// SubBytes transformation is pure combinational logic: output must be known when input byte is known
always_comb begin
  if (!$isunknown(top_sa10))
    assert (!$isunknown(top_sa10_sub));
end


//======================================================================
// Assertions for Signal: top_sa11_sub
// Primary label from model: top_sa11_sub
//======================================================================
// SubBytes transformation is pure combinational logic: output must be known when input byte is known
always_comb begin
  if (!$isunknown(top_sa11))
    assert (!$isunknown(top_sa11_sub));
end


//======================================================================
// Assertions for Signal: top_sa12_sub
// Primary label from model: top_sa12_sub
//======================================================================
// SubBytes transformation is pure combinational logic: output must be known when input byte is known
always_comb begin
  if (!$isunknown(top_sa12))
    assert (!$isunknown(top_sa12_sub));
end


//======================================================================
// Assertions for Signal: top_sa13_sub
// Primary label from model: top_sa13_sub
//======================================================================
// SubBytes transformation is pure combinational logic: output must be known when input byte is known
always_comb begin
  if (!$isunknown(top_sa13))
    assert (!$isunknown(top_sa13_sub));
end


//======================================================================
// Assertions for Signal: top_sa20_sub
// Primary label from model: top_sa20_sub
//======================================================================
// SubBytes transformation is pure combinational logic: output must be known when input byte is known
always_comb begin
  if (!$isunknown(top_sa20))
    assert (!$isunknown(top_sa20_sub));
end


//======================================================================
// Assertions for Signal: top_sa21_sub
// Primary label from model: top_sa21_sub
//======================================================================
// SubBytes transformation is pure combinational logic: output must be known when input byte is known
always_comb begin
  if (!$isunknown(top_sa21))
    assert (!$isunknown(top_sa21_sub));
end


//======================================================================
// Assertions for Signal: top_sa22_sub
// Primary label from model: top_sa22_sub
//======================================================================
// SubBytes transformation is pure combinational logic: output must be known when input byte is known
always_comb begin
  if (!$isunknown(top_sa22))
    assert (!$isunknown(top_sa22_sub));
end


//======================================================================
// Assertions for Signal: top_sa23_sub
// Primary label from model: top_sa23_sub
//======================================================================
// SubBytes transformation is pure combinational logic: output must be known when input byte is known
always_comb begin
  if (!$isunknown(top_sa23))
    assert (!$isunknown(top_sa23_sub));
end


//======================================================================
// Assertions for Signal: top_sa30_sub
// Primary label from model: top_sa30_sub
//======================================================================
// SubBytes transformation is pure combinational logic: output must be known when input byte is known
always_comb begin
  if (!$isunknown(top_sa30))
    assert (!$isunknown(top_sa30_sub));
end


//======================================================================
// Assertions for Signal: top_sa31_sub
// Primary label from model: top_sa31_sub
//======================================================================
// SubBytes transformation is pure combinational logic: output must be known when input byte is known
always_comb begin
  if (!$isunknown(top_sa31))
    assert (!$isunknown(top_sa31_sub));
end


//======================================================================
// Assertions for Signal: top_sa32_sub
// Primary label from model: top_sa32_sub
//======================================================================
// SubBytes transformation is pure combinational logic: output must be known when input byte is known
always_comb begin
  if (!$isunknown(top_sa32))
    assert (!$isunknown(top_sa32_sub));
end


//======================================================================
// Assertions for Signal: top_sa33_sub
// Primary label from model: top_sa33_sub
//======================================================================
// SubBytes transformation is pure combinational logic: output must be known when input byte is known
always_comb begin
  if (!$isunknown(top_sa33))
    assert (!$isunknown(top_sa33_sub));
end


//======================================================================
// Assertions for Signal: aes_sbox_b
// Primary label from model: aes_sbox_b
//======================================================================
// S-box performs pure combinational non-linear byte substitution: output known whenever input byte is known
always_comb begin
  if (!$isunknown(aes_sbox_a))
    assert (!$isunknown(aes_sbox_b));
end


//======================================================================
// Assertions for Signal: aes_key_expand_128_key
// Primary label from model: aes_key_expand_128_key
//======================================================================
// Key expansion module must receive the same initial key as the top-level cipher module
always_comb begin
  assert (aes_key_expand_128_key === top_key);
end


//======================================================================
// Assertions for Signal: aes_key_expand_128_tmp_w
// Primary label from model: aes_key_expand_128_tmp_w
//======================================================================
// Internal key-expansion temporary word must be known whenever the input key is known
always_comb begin
  if (!$isunknown(aes_key_expand_128_key))
    assert (!$isunknown(aes_key_expand_128_tmp_w));
end


//======================================================================
// Assertions for Signal: aes_key_expand_128_subword
// Primary label from model: aes_key_expand_128_subword
//======================================================================
// SubWord operation in key expansion must produce a known result whenever its input word is known
always_comb begin
  if (!$isunknown(aes_key_expand_128_tmp_w))
    assert (!$isunknown(aes_key_expand_128_subword));
end


//======================================================================
// Assertions for Signal: aes_key_expand_128_wo_0
// Primary label from model: aes_key_expand_128_wo_0
//======================================================================
// Round key word 0 output must be known whenever key input and load control are known
always_comb begin
  if (!$isunknown(aes_key_expand_128_key) && !$isunknown(aes_key_expand_128_kld))
    assert (!$isunknown(aes_key_expand_128_wo_0));
end


//======================================================================
// Assertions for Signal: aes_key_expand_128_wo_1
// Primary label from model: aes_key_expand_128_wo_1
//======================================================================
// Round key word 1 output must be known whenever key input and load control are known
always_comb begin
  if (!$isunknown(aes_key_expand_128_key) && !$isunknown(aes_key_expand_128_kld))
    assert (!$isunknown(aes_key_expand_128_wo_1));
end


//======================================================================
// Assertions for Signal: aes_key_expand_128_wo_2
// Primary label from model: aes_key_expand_128_wo_2
//======================================================================
// Round key word 2 output must be known whenever key input and load control are known
always_comb begin
  if (!$isunknown(aes_key_expand_128_key) && !$isunknown(aes_key_expand_128_kld))
    assert (!$isunknown(aes_key_expand_128_wo_2));
end


//======================================================================
// Assertions for Signal: aes_key_expand_128_wo_3
// Primary label from model: aes_key_expand_128_wo_3
//======================================================================
// Round key word 3 output must be known whenever key input and load control are known
always_comb begin
  if (!$isunknown(aes_key_expand_128_key) && !$isunknown(aes_key_expand_128_kld))
    assert (!$isunknown(aes_key_expand_128_wo_3));
end
endmodule

