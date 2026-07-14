`include "mips_16_defs.v"

// method: plain_prompt

// Global checker bound to top module: mips_16_core_top
module mips_16_core_top_sva_global (
    input logic EX_stage_clk,
    input logic [2:0] EX_stage_ex_op_dest,
    input logic [56:0] EX_stage_pipeline_reg_in,
    input logic [37:0] EX_stage_pipeline_reg_out,
    input logic EX_stage_rst,
    input logic [5:0] ID_stage_branch_offset_imm,
    input logic ID_stage_branch_taken,
    input logic ID_stage_clk,
    input logic [2:0] ID_stage_decoding_op_src1,
    input logic [2:0] ID_stage_decoding_op_src2,
    input logic [15:0] ID_stage_instruction,
    input logic ID_stage_instruction_decode_en,
    input logic [56:0] ID_stage_pipeline_reg_out,
    input logic [2:0] ID_stage_reg_read_addr_1,
    input logic [2:0] ID_stage_reg_read_addr_2,
    input logic [15:0] ID_stage_reg_read_data_1,
    input logic [15:0] ID_stage_reg_read_data_2,
    input logic ID_stage_rst,
    input logic [5:0] IF_stage_branch_offset_imm,
    input logic IF_stage_branch_taken,
    input logic IF_stage_clk,
    input logic [15:0] IF_stage_instruction,
    input logic IF_stage_instruction_fetch_en,
    input logic [`PC_WIDTH-1:0] IF_stage_pc,
    input logic IF_stage_rst,
    input logic MEM_stage_clk,
    input logic [2:0] MEM_stage_mem_op_dest,
    input logic [37:0] MEM_stage_pipeline_reg_in,
    input logic [36:0] MEM_stage_pipeline_reg_out,
    input logic MEM_stage_rst,
    input logic [36:0] WB_stage_pipeline_reg_in,
    input logic [15:0] WB_stage_reg_write_data,
    input logic [2:0] WB_stage_reg_write_dest,
    input logic WB_stage_reg_write_en,
    input logic [2:0] WB_stage_wb_op_dest,
    input logic [2:0] hazard_detection_unit_decoding_op_src1,
    input logic [2:0] hazard_detection_unit_decoding_op_src2,
    input logic [2:0] hazard_detection_unit_ex_op_dest,
    input logic [2:0] hazard_detection_unit_mem_op_dest,
    input logic hazard_detection_unit_pipeline_stall_n,
    input logic [2:0] hazard_detection_unit_wb_op_dest,
    input logic register_file_clk,
    input logic [2:0] register_file_reg_read_addr_1,
    input logic [2:0] register_file_reg_read_addr_2,
    input logic [15:0] register_file_reg_read_data_1,
    input logic [15:0] register_file_reg_read_data_2,
    input logic [15:0] register_file_reg_write_data,
    input logic [2:0] register_file_reg_write_dest,
    input logic register_file_reg_write_en,
    input logic register_file_rst,
    input logic top_clk,
    input logic [`PC_WIDTH-1:0] top_pc,
    input logic top_rst
);

//======================================================================
// Assertions for Signal: top_pc
// Primary label from model: top_pc
//======================================================================
// top_pc must reflect the fetch-stage program counter value
always_comb begin
  assert (top_pc == IF_stage_pc);
end


//======================================================================
// Assertions for Signal: top_clk
// Primary label from model: top_clk
//======================================================================
// Single clock domain: all pipeline stage clocks must match the top-level clock
always_comb begin
  assert (top_clk == IF_stage_clk);
  assert (top_clk == ID_stage_clk);
  assert (top_clk == EX_stage_clk);
  assert (top_clk == MEM_stage_clk);
  assert (top_clk == register_file_clk);
end


//======================================================================
// Assertions for Signal: top_rst
// Primary label from model: top_rst
//======================================================================
// Single reset domain: all pipeline stage resets must match the top-level reset
always_comb begin
  assert (top_rst == IF_stage_rst);
  assert (top_rst == ID_stage_rst);
  assert (top_rst == EX_stage_rst);
  assert (top_rst == MEM_stage_rst);
  assert (top_rst == register_file_rst);
end


//======================================================================
// Assertions for Signal: IF_stage_instruction_fetch_en
// Primary label from model: IF_stage_instruction_fetch_en
//======================================================================
// Fetch advance is gated directly by hazard-unit stall control (active-low stall)
always_comb begin
  assert (IF_stage_instruction_fetch_en == hazard_detection_unit_pipeline_stall_n);
end


//======================================================================
// Assertions for Signal: ID_stage_instruction_decode_en
// Primary label from model: ID_stage_instruction_decode_en
//======================================================================
// Decode advance is gated directly by hazard-unit stall control (active-low stall)
always_comb begin
  assert (ID_stage_instruction_decode_en == hazard_detection_unit_pipeline_stall_n);
end


//======================================================================
// Assertions for Signal: ID_stage_instruction
// Primary label from model: ID_stage_instruction
//======================================================================
// ID stage latches the instruction fetched by IF stage
always_comb begin
  assert (ID_stage_instruction == IF_stage_instruction);
end


//======================================================================
// Assertions for Signal: IF_stage_branch_offset_imm
// Primary label from model: IF_stage_branch_offset_imm
//======================================================================
// Branch offset feedback path from ID stage into IF stage must be consistent
always_comb begin
  assert (IF_stage_branch_offset_imm == ID_stage_branch_offset_imm);
end


//======================================================================
// Assertions for Signal: IF_stage_branch_taken
// Primary label from model: IF_stage_branch_taken
//======================================================================
// Branch-taken feedback path from ID stage into IF stage must be consistent
always_comb begin
  assert (IF_stage_branch_taken == ID_stage_branch_taken);
end


//======================================================================
// Assertions for Signal: EX_stage_pipeline_reg_in
// Primary label from model: EX_stage_pipeline_reg_in
//======================================================================
// ID/EX pipeline payload must be forwarded intact from ID stage output to EX stage input
always_comb begin
  assert (EX_stage_pipeline_reg_in == ID_stage_pipeline_reg_out);
end


//======================================================================
// Assertions for Signal: MEM_stage_pipeline_reg_in
// Primary label from model: MEM_stage_pipeline_reg_in
//======================================================================
// EX/MEM pipeline payload must be forwarded intact from EX stage output to MEM stage input
always_comb begin
  assert (MEM_stage_pipeline_reg_in == EX_stage_pipeline_reg_out);
end


//======================================================================
// Assertions for Signal: WB_stage_pipeline_reg_in
// Primary label from model: WB_stage_pipeline_reg_in
//======================================================================
// MEM/WB pipeline payload must be forwarded intact from MEM stage output to WB stage input
always_comb begin
  assert (WB_stage_pipeline_reg_in == MEM_stage_pipeline_reg_out);
end


//======================================================================
// Assertions for Signal: register_file_reg_write_en
// Primary label from model: register_file_reg_write_en
//======================================================================
// Register file write interface must be driven consistently by WB stage outputs
always_comb begin
  assert (register_file_reg_write_en == WB_stage_reg_write_en);
  assert (register_file_reg_write_dest == WB_stage_reg_write_dest);
  assert (register_file_reg_write_data == WB_stage_reg_write_data);
end


//======================================================================
// Assertions for Signal: ID_stage_reg_read_data_1
// Primary label from model: ID_stage_reg_read_data_1
//======================================================================
// ID stage read data must equal the register file read outputs
always_comb begin
  assert (ID_stage_reg_read_data_1 == register_file_reg_read_data_1);
  assert (ID_stage_reg_read_data_2 == register_file_reg_read_data_2);
end


//======================================================================
// Assertions for Signal: ID_stage_reg_read_addr_1
// Primary label from model: ID_stage_reg_read_addr_1
//======================================================================
// ID stage read addresses must drive the register file read address ports
always_comb begin
  assert (ID_stage_reg_read_addr_1 == register_file_reg_read_addr_1);
  assert (ID_stage_reg_read_addr_2 == register_file_reg_read_addr_2);
end


//======================================================================
// Assertions for Signal: hazard_detection_unit_decoding_op_src1
// Primary label from model: hazard_detection_unit_decoding_op_src1
//======================================================================
// Hazard unit source-register inputs must match ID stage decoded source identifiers,
// which are also the register-file read addresses used for hazard checking
always_comb begin
  assert (hazard_detection_unit_decoding_op_src1 == ID_stage_decoding_op_src1);
  assert (hazard_detection_unit_decoding_op_src2 == ID_stage_decoding_op_src2);
  assert (ID_stage_decoding_op_src1 == ID_stage_reg_read_addr_1);
  assert (ID_stage_decoding_op_src2 == ID_stage_reg_read_addr_2);
end


//======================================================================
// Assertions for Signal: hazard_detection_unit_ex_op_dest
// Primary label from model: hazard_detection_unit_ex_op_dest
//======================================================================
// Hazard unit EX-stage destination tracking input must match EX stage destination output
always_comb begin
  assert (hazard_detection_unit_ex_op_dest == EX_stage_ex_op_dest);
end


//======================================================================
// Assertions for Signal: hazard_detection_unit_mem_op_dest
// Primary label from model: hazard_detection_unit_mem_op_dest
//======================================================================
// Hazard unit MEM-stage destination tracking input must match MEM stage destination output
always_comb begin
  assert (hazard_detection_unit_mem_op_dest == MEM_stage_mem_op_dest);
end


//======================================================================
// Assertions for Signal: hazard_detection_unit_wb_op_dest
// Primary label from model: hazard_detection_unit_wb_op_dest
//======================================================================
// Hazard unit WB-stage destination tracking input must match WB stage destination output
always_comb begin
  assert (hazard_detection_unit_wb_op_dest == WB_stage_wb_op_dest);
end


//======================================================================
// Assertions for Signal: hazard_detection_unit_pipeline_stall_n
// Primary label from model: hazard_detection_unit_pipeline_stall_n
//======================================================================
// A nonzero source register matching any tracked in-flight destination must deassert
// pipeline_stall_n (active-low stall) to freeze IF/ID advancement, for either source operand
always_comb begin
  assert ( ((hazard_detection_unit_decoding_op_src1 != 3'd0) &&
            ((hazard_detection_unit_decoding_op_src1 == hazard_detection_unit_ex_op_dest) ||
             (hazard_detection_unit_decoding_op_src1 == hazard_detection_unit_mem_op_dest) ||
             (hazard_detection_unit_decoding_op_src1 == hazard_detection_unit_wb_op_dest)))
           -> (hazard_detection_unit_pipeline_stall_n == 1'b0) );

  assert ( ((hazard_detection_unit_decoding_op_src2 != 3'd0) &&
            ((hazard_detection_unit_decoding_op_src2 == hazard_detection_unit_ex_op_dest) ||
             (hazard_detection_unit_decoding_op_src2 == hazard_detection_unit_mem_op_dest) ||
             (hazard_detection_unit_decoding_op_src2 == hazard_detection_unit_wb_op_dest)))
           -> (hazard_detection_unit_pipeline_stall_n == 1'b0) );

  // No RAW hazard on either source implies stall is not asserted (no other stall source is defined)
  assert ( (!((hazard_detection_unit_decoding_op_src1 != 3'd0) &&
              ((hazard_detection_unit_decoding_op_src1 == hazard_detection_unit_ex_op_dest) ||
               (hazard_detection_unit_decoding_op_src1 == hazard_detection_unit_mem_op_dest) ||
               (hazard_detection_unit_decoding_op_src1 == hazard_detection_unit_wb_op_dest))) &&
            !((hazard_detection_unit_decoding_op_src2 != 3'd0) &&
              ((hazard_detection_unit_decoding_op_src2 == hazard_detection_unit_ex_op_dest) ||
               (hazard_detection_unit_decoding_op_src2 == hazard_detection_unit_mem_op_dest) ||
               (hazard_detection_unit_decoding_op_src2 == hazard_detection_unit_wb_op_dest))) )
           -> (hazard_detection_unit_pipeline_stall_n == 1'b1) );
end


//======================================================================
// Assertions for Signal: register_file_reg_read_data_1
// Primary label from model: register_file_reg_read_data_1
//======================================================================
// Register R0 is architecturally constant zero on reads
always_comb begin
  assert ( (register_file_reg_read_addr_1 == 3'd0) -> (register_file_reg_read_data_1 == 16'd0) );
end


//======================================================================
// Assertions for Signal: register_file_reg_read_data_2
// Primary label from model: register_file_reg_read_data_2
//======================================================================
// Register R0 is architecturally constant zero on reads
always_comb begin
  assert ( (register_file_reg_read_addr_2 == 3'd0) -> (register_file_reg_read_data_2 == 16'd0) );
end
endmodule

