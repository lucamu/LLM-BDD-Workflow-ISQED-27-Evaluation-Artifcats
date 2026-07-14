// method: plain_prompt

// Global checker bound to top module: RS_dec
module RS_dec_sva_global (
    input logic [7:0] BM_lamda_L1,
    input logic [7:0] BM_lamda_Sm1,
    input logic [7:0] BM_lamda_Sm9,
    input logic BM_lamda_Sm_ready,
    input logic [7:0] BM_lamda_add_dec1,
    input logic [7:0] BM_lamda_add_pow1,
    input logic BM_lamda_clk,
    input logic [7:0] BM_lamda_dec1,
    input logic [3:0] BM_lamda_erasure_cnt,
    input logic BM_lamda_erasure_ready,
    input logic [7:0] BM_lamda_pow1,
    input logic BM_lamda_reset,
    input logic [7:0] DP_RAM_address_read,
    input logic [7:0] DP_RAM_address_write,
    input logic DP_RAM_clk,
    input logic [7:0] DP_RAM_data_in,
    input logic [7:0] DP_RAM_data_out,
    input logic DP_RAM_re,
    input logic DP_RAM_we,
    input logic [7:0] GF_matrix_ascending_binary_address_read,
    input logic GF_matrix_ascending_binary_clk,
    input logic [7:0] GF_matrix_ascending_binary_data_out,
    input logic GF_matrix_ascending_binary_re,
    input logic [7:0] GF_matrix_dec_address_read,
    input logic GF_matrix_dec_clk,
    input logic [7:0] GF_matrix_dec_data_out,
    input logic GF_matrix_dec_re,
    input logic [7:0] GF_mult_add_syndromes_address_GF_dec,
    input logic GF_mult_add_syndromes_clk,
    input logic [7:0] GF_mult_add_syndromes_out_GF_dec,
    input logic [7:0] Omega_Phy_L1,
    input logic Omega_Phy_L_ready,
    input logic [7:0] Omega_Phy_O1,
    input logic [7:0] Omega_Phy_O2,
    input logic [7:0] Omega_Phy_P1,
    input logic [7:0] Omega_Phy_P3,
    input logic [7:0] Omega_Phy_Sm1,
    input logic [7:0] Omega_Phy_Sm9,
    input logic Omega_Phy_Sm_ready,
    input logic [7:0] Omega_Phy_add_dec1,
    input logic [7:0] Omega_Phy_add_pow1,
    input logic Omega_Phy_clk,
    input logic [7:0] Omega_Phy_dec1,
    input logic [7:0] Omega_Phy_pow1,
    input logic Omega_Phy_reset,
    input logic [7:0] error_correction_Address,
    input logic [7:0] error_correction_O1,
    input logic [7:0] error_correction_O2,
    input logic [7:0] error_correction_P1,
    input logic [7:0] error_correction_P3,
    input logic error_correction_RE,
    input logic [7:0] error_correction_add_dec1,
    input logic [7:0] error_correction_add_pow1,
    input logic error_correction_clk,
    input logic [7:0] error_correction_correction_value,
    input logic [7:0] error_correction_dec1,
    input logic [7:0] error_correction_initial_value,
    input logic error_correction_poly_ready,
    input logic [7:0] error_correction_pow1,
    input logic [7:0] error_correction_r1,
    input logic error_correction_reset,
    input logic [3:0] error_correction_root_count,
    input logic error_correction_roots_ready,
    input logic [7:0] input_syndromes_Address_GF_ascending,
    input logic input_syndromes_CE,
    input logic input_syndromes_RE,
    input logic [7:0] input_syndromes_R_Add,
    input logic [7:0] input_syndromes_Read_byte,
    input logic input_syndromes_WE,
    input logic [7:0] input_syndromes_W_Add,
    input logic input_syndromes_clk,
    input logic [7:0] input_syndromes_input_byte,
    input logic [7:0] input_syndromes_input_byte0,
    input logic [7:0] input_syndromes_out_GF_ascending,
    input logic [7:0] input_syndromes_out_byte_0,
    input logic [7:0] input_syndromes_out_byte_1,
    input logic input_syndromes_reset,
    input logic [7:0] input_syndromes_s0,
    input logic lamda_roots_CE,
    input logic [7:0] lamda_roots_Lc0,
    input logic [7:0] lamda_roots_add_GF_ascending,
    input logic lamda_roots_clk,
    input logic [7:0] lamda_roots_decimal0,
    input logic [7:0] lamda_roots_power,
    input logic [7:0] lamda_roots_r1,
    input logic lamda_roots_reset,
    input logic [3:0] lamda_roots_root_cnt,
    input logic out_stage_DONE,
    input logic [7:0] out_stage_In_byte,
    input logic [7:0] out_stage_Out_byte,
    input logic [7:0] out_stage_RdAdd,
    input logic out_stage_clk,
    input logic out_stage_reset,
    input logic [7:0] top_Address_error_correction,
    input logic top_CE,
    input logic top_CEO,
    input logic [7:0] top_In_byte_out_stage,
    input logic [7:0] top_In_mem_Read_byte,
    input logic [7:0] top_Out_byte,
    input logic top_RE1,
    input logic top_RE2,
    input logic top_RE_error_correction,
    input logic [7:0] top_R_Add1,
    input logic [7:0] top_R_Add2,
    input logic [7:0] top_RdAdd_out_stage,
    input logic top_Valid_out,
    input logic top_WE1,
    input logic top_WE2,
    input logic [7:0] top_W_Add1,
    input logic [7:0] top_W_Add2,
    input logic [7:0] top_add_dec1,
    input logic [7:0] top_add_dec1_BM_lamda,
    input logic [7:0] top_add_dec1_Omega_Phy,
    input logic [7:0] top_add_dec1_error_correction,
    input logic [7:0] top_add_dec2,
    input logic [7:0] top_add_dec3,
    input logic [7:0] top_add_dec4,
    input logic [7:0] top_add_pow1,
    input logic [7:0] top_add_pow1_BM_lamda,
    input logic [7:0] top_add_pow1_Omega_Phy,
    input logic [7:0] top_add_pow1_error_correction,
    input logic [7:0] top_add_pow1_lamda_roots,
    input logic [7:0] top_add_pow2,
    input logic [7:0] top_add_pow3,
    input logic [7:0] top_add_pow4,
    input logic top_clk,
    input logic [7:0] top_correction_value,
    input logic [7:0] top_dec1,
    input logic [7:0] top_dec1_BM_lamda,
    input logic [7:0] top_dec1_Omega_Phy,
    input logic [7:0] top_dec1_error_correction,
    input logic [7:0] top_dec1_lamda_roots,
    input logic [7:0] top_dec2,
    input logic [7:0] top_dec3,
    input logic [7:0] top_dec4,
    input logic [7:0] top_initial_value,
    input logic [7:0] top_input_byte,
    input logic [7:0] top_input_byte1,
    input logic [7:0] top_input_byte2,
    input logic [7:0] top_out_byte1,
    input logic [7:0] top_out_byte2,
    input logic [7:0] top_pow1,
    input logic [7:0] top_pow1_BM_lamda,
    input logic [7:0] top_pow1_Omega_Phy,
    input logic [7:0] top_pow1_error_correction,
    input logic [7:0] top_pow1_lamda_roots,
    input logic [7:0] top_pow2,
    input logic [7:0] top_pow3,
    input logic [7:0] top_pow4,
    input logic top_reset,
    input logic [7:0] transport_in2out_RdAdd,
    input logic transport_in2out_S_Ready,
    input logic transport_in2out_clk,
    input logic transport_in2out_reset
);

//======================================================================
// Assertions for Signal: top_CEO
// Primary label from model: top_CEO
//======================================================================
// Top-level CEO must be gated by Valid_out (CEO = CEO_0 && Valid_out)
always_comb begin
  assert (!top_CEO || top_Valid_out);
end


//======================================================================
// Assertions for Signal: BM_lamda_erasure_cnt
// Primary label from model: BM_lamda_erasure_cnt
//======================================================================
// erasure_cnt and erasure_ready are tied to zero for errors-only decoding
always_comb begin
  assert (BM_lamda_erasure_cnt == 4'b0000);
  assert (BM_lamda_erasure_ready == 1'b0);
end


//======================================================================
// Assertions for Signal: error_correction_root_count
// Primary label from model: error_correction_root_count
//======================================================================
// Root count cannot exceed decoder capability (t=8)
always_comb begin
  assert (error_correction_root_count <= 4'd8);
  // root_count passed to error_correction must match root search output
  assert (error_correction_root_count == lamda_roots_root_cnt);
end


//======================================================================
// Assertions for Signal: lamda_roots_root_cnt
// Primary label from model: lamda_roots_root_cnt
//======================================================================
// Root search reports at most 8 roots per codeword (t=8)
always_comb begin
  assert (lamda_roots_root_cnt <= 4'd8);
end


//======================================================================
// Assertions for Signal: top_Address_error_correction
// Primary label from model: top_Address_error_correction
//======================================================================
// Correction writes restricted to payload address range (Address < 188)
always_comb begin
  assert (top_Address_error_correction < 8'd188);
  // Address must match the error_correction submodule address output
  assert (top_Address_error_correction == error_correction_Address);
end


//======================================================================
// Assertions for Signal: top_RE_error_correction
// Primary label from model: top_RE_error_correction
//======================================================================
// Top-level read enable for correction path must match submodule output
always_comb begin
  assert (top_RE_error_correction == error_correction_RE);
end


//======================================================================
// Assertions for Signal: top_correction_value
// Primary label from model: top_correction_value
//======================================================================
// Correction value written back must match error_correction computed value
always_comb begin
  assert (top_correction_value == error_correction_correction_value);
end


//======================================================================
// Assertions for Signal: top_initial_value
// Primary label from model: top_initial_value
//======================================================================
// Initial value read from output memory must match error_correction input
always_comb begin
  assert (top_initial_value == error_correction_initial_value);
end


//======================================================================
// Assertions for Signal: top_Out_byte
// Primary label from model: top_Out_byte
//======================================================================
// Top-level output byte must match out_stage generated output byte
always_comb begin
  assert (top_Out_byte == out_stage_Out_byte);
end


//======================================================================
// Assertions for Signal: top_add_pow1_BM_lamda
// Primary label from model: top_add_pow1_BM_lamda
//======================================================================
// GF power lookup address for BM_lamda must match submodule output
always_comb begin
  assert (top_add_pow1_BM_lamda == BM_lamda_add_pow1);
end


//======================================================================
// Assertions for Signal: top_pow1_BM_lamda
// Primary label from model: top_pow1_BM_lamda
//======================================================================
// GF power lookup return value fed to BM_lamda must match submodule input
always_comb begin
  assert (top_pow1_BM_lamda == BM_lamda_pow1);
end


//======================================================================
// Assertions for Signal: top_dec1_BM_lamda
// Primary label from model: top_dec1_BM_lamda
//======================================================================
// GF decimal lookup return value fed to BM_lamda must match submodule input
always_comb begin
  assert (top_dec1_BM_lamda == BM_lamda_dec1);
end


//======================================================================
// Assertions for Signal: top_add_dec1_BM_lamda
// Primary label from model: top_add_dec1_BM_lamda
//======================================================================
// GF decimal lookup address for BM_lamda must match submodule output
always_comb begin
  assert (top_add_dec1_BM_lamda == BM_lamda_add_dec1);
end


//======================================================================
// Assertions for Signal: top_add_pow1_Omega_Phy
// Primary label from model: top_add_pow1_Omega_Phy
//======================================================================
// GF power lookup address for Omega_Phy must match submodule output
always_comb begin
  assert (top_add_pow1_Omega_Phy == Omega_Phy_add_pow1);
end


//======================================================================
// Assertions for Signal: top_pow1_Omega_Phy
// Primary label from model: top_pow1_Omega_Phy
//======================================================================
// GF power lookup return value fed to Omega_Phy must match submodule input
always_comb begin
  assert (top_pow1_Omega_Phy == Omega_Phy_pow1);
end


//======================================================================
// Assertions for Signal: top_dec1_Omega_Phy
// Primary label from model: top_dec1_Omega_Phy
//======================================================================
// GF decimal lookup return value fed to Omega_Phy must match submodule input
always_comb begin
  assert (top_dec1_Omega_Phy == Omega_Phy_dec1);
end


//======================================================================
// Assertions for Signal: top_add_dec1_Omega_Phy
// Primary label from model: top_add_dec1_Omega_Phy
//======================================================================
// GF decimal lookup address for Omega_Phy must match submodule output
always_comb begin
  assert (top_add_dec1_Omega_Phy == Omega_Phy_add_dec1);
end


//======================================================================
// Assertions for Signal: top_add_pow1_error_correction
// Primary label from model: top_add_pow1_error_correction
//======================================================================
// GF power lookup address for error_correction must match submodule output
always_comb begin
  assert (top_add_pow1_error_correction == error_correction_add_pow1);
end


//======================================================================
// Assertions for Signal: top_pow1_error_correction
// Primary label from model: top_pow1_error_correction
//======================================================================
// GF power lookup return value fed to error_correction must match submodule input
always_comb begin
  assert (top_pow1_error_correction == error_correction_pow1);
end


//======================================================================
// Assertions for Signal: top_dec1_error_correction
// Primary label from model: top_dec1_error_correction
//======================================================================
// GF decimal lookup return value fed to error_correction must match submodule input
always_comb begin
  assert (top_dec1_error_correction == error_correction_dec1);
end


//======================================================================
// Assertions for Signal: top_add_dec1_error_correction
// Primary label from model: top_add_dec1_error_correction
//======================================================================
// GF decimal lookup address for error_correction must match submodule output
always_comb begin
  assert (top_add_dec1_error_correction == error_correction_add_dec1);
end


//======================================================================
// Assertions for Signal: top_pow1_lamda_roots
// Primary label from model: top_pow1_lamda_roots
//======================================================================
// GF power lookup return value fed to lamda_roots must match submodule input
always_comb begin
  assert (top_pow1_lamda_roots == lamda_roots_power);
end


//======================================================================
// Assertions for Signal: top_dec1_lamda_roots
// Primary label from model: top_dec1_lamda_roots
//======================================================================
// GF decimal lookup return value fed to lamda_roots must match submodule input
always_comb begin
  assert (top_dec1_lamda_roots == lamda_roots_decimal0);
end


//======================================================================
// Assertions for Signal: top_add_pow1_lamda_roots
// Primary label from model: top_add_pow1_lamda_roots
//======================================================================
// GF power lookup address for lamda_roots must match submodule output
always_comb begin
  assert (top_add_pow1_lamda_roots == lamda_roots_add_GF_ascending);
end


//======================================================================
// Assertions for Signal: error_correction_r1
// Primary label from model: error_correction_r1
//======================================================================
// Root value used by error_correction must match root-search output
always_comb begin
  assert (error_correction_r1 == lamda_roots_r1);
end


//======================================================================
// Assertions for Signal: error_correction_O1
// Primary label from model: error_correction_O1
//======================================================================
// Omega/Phy terms used by error_correction must match Omega_Phy outputs
always_comb begin
  assert (error_correction_O1 == Omega_Phy_O1);
  assert (error_correction_O2 == Omega_Phy_O2);
  assert (error_correction_P1 == Omega_Phy_P1);
  assert (error_correction_P3 == Omega_Phy_P3);
end


//======================================================================
// Assertions for Signal: Omega_Phy_L1
// Primary label from model: Omega_Phy_L1
//======================================================================
// Lambda coefficients used by Omega_Phy must match BM_lamda output
always_comb begin
  assert (Omega_Phy_L1 == BM_lamda_L1);
end


//======================================================================
// Assertions for Signal: BM_lamda_Sm1
// Primary label from model: BM_lamda_Sm1
//======================================================================
// Syndromes consumed by BM_lamda and Omega_Phy must be identical (same syndrome set)
always_comb begin
  assert (BM_lamda_Sm1 == Omega_Phy_Sm1);
  assert (BM_lamda_Sm9 == Omega_Phy_Sm9);
  assert (BM_lamda_Sm_ready == Omega_Phy_Sm_ready);
end


//======================================================================
// Assertions for Signal: input_syndromes_CE
// Primary label from model: input_syndromes_CE
//======================================================================
// CE strobe forwarded from top level to input_syndromes must match
always_comb begin
  assert (input_syndromes_CE == top_CE);
end


//======================================================================
// Assertions for Signal: input_syndromes_input_byte
// Primary label from model: input_syndromes_input_byte
//======================================================================
// input_byte forwarded from top level to input_syndromes must match
always_comb begin
  assert (input_syndromes_input_byte == top_input_byte);
end


//======================================================================
// Assertions for Signal: out_stage_In_byte
// Primary label from model: out_stage_In_byte
//======================================================================
// Input byte to out_stage must match top-level staged byte
always_comb begin
  assert (out_stage_In_byte == top_In_byte_out_stage);
end


//======================================================================
// Assertions for Signal: out_stage_RdAdd
// Primary label from model: out_stage_RdAdd
//======================================================================
// Output stage read address must stay within payload range (0..187)
always_comb begin
  assert (out_stage_RdAdd < 8'd188);
  // Top-level read address for out_stage must match submodule output
  assert (out_stage_RdAdd == top_RdAdd_out_stage);
end


//======================================================================
// Assertions for Signal: top_W_Add1
// Primary label from model: top_W_Add1
//======================================================================
// Output memory write address (bank1) must stay within payload range (0..187)
always_comb begin
  assert (top_W_Add1 < 8'd188);
end


//======================================================================
// Assertions for Signal: top_W_Add2
// Primary label from model: top_W_Add2
//======================================================================
// Output memory write address (bank2) must stay within payload range (0..187)
always_comb begin
  assert (top_W_Add2 < 8'd188);
end


//======================================================================
// Assertions for Signal: top_R_Add1
// Primary label from model: top_R_Add1
//======================================================================
// Output memory read address (bank1) must stay within payload range (0..187)
always_comb begin
  assert (top_R_Add1 < 8'd188);
end


//======================================================================
// Assertions for Signal: top_R_Add2
// Primary label from model: top_R_Add2
//======================================================================
// Output memory read address (bank2) must stay within payload range (0..187)
always_comb begin
  assert (top_R_Add2 < 8'd188);
end


//======================================================================
// Assertions for Signal: input_syndromes_R_Add
// Primary label from model: input_syndromes_R_Add
//======================================================================
// Input memory read address must stay within codeword buffer depth (0..204)
always_comb begin
  assert (input_syndromes_R_Add < 8'd205);
end


//======================================================================
// Assertions for Signal: DP_RAM_address_read
// Primary label from model: DP_RAM_address_read
//======================================================================
// Input DP_RAM addresses must stay within codeword buffer depth (0..204)
always_comb begin
  assert (DP_RAM_address_read < 8'd205);
  assert (DP_RAM_address_write < 8'd205);
end
endmodule

