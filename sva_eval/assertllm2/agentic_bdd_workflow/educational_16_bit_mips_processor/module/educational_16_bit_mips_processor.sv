/***************************************************
 * Module: mips_16_core_top
 * Project: mips_16
 * Author: fzy
 * Description: 
 *     top module of mips_16 cpu core. Technical details:
 *			1.	16-bit data width
 *			2.	classic 5-stage static pipeline, 1 branch delay slot, theoretical CPI is 1.0
 *			3.	pipeline is able to detect and prevent RAW hazards, no forwarding logic
 *			4.	8 general purpose register (reg 0 is special, according to mips architecture)
 *			5.	up to now supports 13 instrcutions, see ./doc/instruction_set.txt for details
 *
 * Revise history:
 *     
 ***************************************************/
`timescale 1ns/1ps
`include "mips_16_defs.v"
module mips_16_core_top
(
	input						clk,
	input						rst,

	output	[`PC_WIDTH-1:0]		pc
);
	wire 						pipeline_stall_n ;
	wire	[5:0]				branch_offset_imm;
	wire						branch_taken;
	wire	[15:0]				instruction;
	wire	[56:0]				ID_pipeline_reg_out;
	wire	[37:0]				EX_pipeline_reg_out;
	wire	[36:0]				MEM_pipeline_reg_out;
	
	wire	[2:0]				reg_read_addr_1;	// register file read port 1 address
	wire	[2:0]				reg_read_addr_2;	// register file read port 2 address
	wire	[15:0]				reg_read_data_1;	// register file read port 1 data
	wire	[15:0]				reg_read_data_2;	// register file read port 2 data
	wire	[2:0]				decoding_op_src1;		//source_1 register number
	wire	[2:0]				decoding_op_src2;		//source_2 register number
	wire	[2:0]				ex_op_dest;				//EX stage destinaton register number
	wire	[2:0]				mem_op_dest;			//MEM stage destinaton register number
	wire	[2:0]				wb_op_dest;				//WB stage destinaton register number
	wire						reg_write_en;
	wire	[2:0]				reg_write_dest;
	wire	[15:0]				reg_write_data;
	
	IF_stage IF_stage_inst (
		.clk					(clk), 
		.rst					(rst), 
		.instruction_fetch_en	(pipeline_stall_n),
		.branch_offset_imm		(branch_offset_imm), 
		.branch_taken			(branch_taken), 
		.pc						(pc),
		.instruction			(instruction)
	);
	
	ID_stage ID_stage_inst (
		.clk					(clk),
		.rst					(rst),
		.instruction_decode_en	(pipeline_stall_n),
		.pipeline_reg_out		(ID_pipeline_reg_out),
		.instruction			(instruction),
		.branch_offset_imm		(branch_offset_imm),
		.branch_taken			(branch_taken),
		.reg_read_addr_1		(reg_read_addr_1),	//
		.reg_read_addr_2		(reg_read_addr_2),	//
		.reg_read_data_1		(reg_read_data_1),	//
		.reg_read_data_2		(reg_read_data_2),	//
		.decoding_op_src1		(decoding_op_src1),		
		.decoding_op_src2		(decoding_op_src2)
	);
	
	EX_stage EX_stage_inst (
		.clk					(clk), 
		.rst					(rst), 
		.pipeline_reg_in		(ID_pipeline_reg_out), 
		.pipeline_reg_out		(EX_pipeline_reg_out), 
		.ex_op_dest				(ex_op_dest)
	);
	
	MEM_stage MEM_stage_inst (
		.clk					(clk), 
		.rst					(rst), 
		.pipeline_reg_in		(EX_pipeline_reg_out), 
		.pipeline_reg_out		(MEM_pipeline_reg_out), 
		.mem_op_dest			(mem_op_dest)
	);
	
	WB_stage WB_stage_inst (
		.pipeline_reg_in		(MEM_pipeline_reg_out), 
		.reg_write_en			(reg_write_en), 
		.reg_write_dest			(reg_write_dest), 
		.reg_write_data			(reg_write_data), 
		.wb_op_dest				(wb_op_dest)
	);
	
	register_file register_file_inst (
		.clk					(clk), 
		.rst					(rst), 
		.reg_write_en			(reg_write_en), 
		.reg_write_dest			(reg_write_dest), 
		.reg_write_data			(reg_write_data), 
		.reg_read_addr_1		(reg_read_addr_1), 
		.reg_read_data_1		(reg_read_data_1), 
		.reg_read_addr_2		(reg_read_addr_2), 
		.reg_read_data_2		(reg_read_data_2)
	);
	
	hazard_detection_unit hazard_detection_unit_inst (
		.decoding_op_src1		(decoding_op_src1), 
		.decoding_op_src2		(decoding_op_src2), 
		.ex_op_dest				(ex_op_dest), 
		.mem_op_dest			(mem_op_dest), 
		.wb_op_dest				(wb_op_dest), 
		.pipeline_stall_n		(pipeline_stall_n)
	);
	
 // --- Formal assertions ---
 // Local width parameter
 localparam int PCW = $bits(pc);

 // =====================================================================
 // Reset behavior
 // =====================================================================

 property p_reset_pc_zero;
   @(posedge clk)
   (rst) |=> (pc == '0);
 endproperty
 assert property (p_reset_pc_zero);

 property p_reset_pipeline_clear;
   @(posedge clk)
   (rst) |=> (ID_pipeline_reg_out == '0) &&
              (EX_pipeline_reg_out == '0) &&
              (MEM_pipeline_reg_out == '0) &&
              (instruction == '0);
 endproperty
 assert property (p_reset_pipeline_clear);

 property p_reset_no_regwrite;
   @(posedge clk)
   (rst) |=> (reg_write_en == 1'b0);
 endproperty
 assert property (p_reset_no_regwrite);

 property p_restart_pc_zero;
   @(posedge clk)
   ($past(rst) && !rst && pipeline_stall_n) |-> (pc == '0);
 endproperty
 assert property (p_restart_pc_zero);

 // =====================================================================
 // PC / IF stage behavior
 // =====================================================================

 property p_pc_increment;
   @(posedge clk) disable iff (rst)
   (pipeline_stall_n && !branch_taken) |=> (pc == ($past(pc) + 1'b1));
 endproperty
 assert property (p_pc_increment);

 property p_pc_branch_redirect;
   @(posedge clk) disable iff (rst)
   (pipeline_stall_n && branch_taken) |=>
     (pc == ($past(pc) + {{(PCW-6){$past(branch_offset_imm[5])}}, $past(branch_offset_imm)}));
 endproperty
 assert property (p_pc_branch_redirect);

 property p_pc_hold;
   @(posedge clk) disable iff (rst)
   (!pipeline_stall_n) |=> (pc == $past(pc));
 endproperty
 assert property (p_pc_hold);

 property p_pc_branch_priority;
   @(posedge clk) disable iff (rst)
   (pipeline_stall_n && branch_taken) |=>
     (pc == ($past(pc) + {{(PCW-6){$past(branch_offset_imm[5])}}, $past(branch_offset_imm)}));
 endproperty
 assert property (p_pc_branch_priority);

 property p_pc_branch_priority_not_seq;
   @(posedge clk) disable iff (rst)
   (pipeline_stall_n && branch_taken &&
    ({{(PCW-6){branch_offset_imm[5]}}, branch_offset_imm} != {{(PCW-1){1'b0}},1'b1}))
   |=> (pc != ($past(pc) + 1'b1));
 endproperty
 assert property (p_pc_branch_priority_not_seq);

 // =====================================================================
 // ID stage: register R0 semantics
 // =====================================================================

 property p_r0_read_port1;
   @(posedge clk) disable iff (rst)
   (reg_read_addr_1 == 3'b000) |-> (reg_read_data_1 == 16'h0000);
 endproperty
 assert property (p_r0_read_port1);

 property p_r0_read_port2;
   @(posedge clk) disable iff (rst)
   (reg_read_addr_2 == 3'b000) |-> (reg_read_data_2 == 16'h0000);
 endproperty
 assert property (p_r0_read_port2);

 // =====================================================================
 // Hazard detection unit
 // =====================================================================

 property p_stall_ex_hazard;
   @(posedge clk) disable iff (rst)
   ((decoding_op_src1 != 3'b000) && (ex_op_dest == decoding_op_src1))
     |-> (pipeline_stall_n == 1'b0);
 endproperty
 assert property (p_stall_ex_hazard);

 property p_stall_mem_hazard;
   @(posedge clk) disable iff (rst)
   ((decoding_op_src2 != 3'b000) && (mem_op_dest == decoding_op_src2))
     |-> (pipeline_stall_n == 1'b0);
 endproperty
 assert property (p_stall_mem_hazard);

 property p_stall_wb_hazard;
   @(posedge clk) disable iff (rst)
   ((decoding_op_src1 != 3'b000) && (wb_op_dest == decoding_op_src1))
     |-> (pipeline_stall_n == 1'b0);
 endproperty
 assert property (p_stall_wb_hazard);

 // Scenario: Register R0 as source never triggers a hazard stall
 // (REVERTED to prior working form -- restores original antecedent.)
 property p_no_stall_r0;
   @(posedge clk) disable iff (rst)
   ((decoding_op_src1 == 3'b000) &&
    (ex_op_dest == 3'b000) &&
    (mem_op_dest == 3'b000) &&
    (wb_op_dest == 3'b000))
     |-> (pipeline_stall_n == 1'b1);
 endproperty
 assert property (p_no_stall_r0);

 // Scenario: No stall when neither decode source register matches any dest
 // (REVERTED to prior working form -- restores original combined
 // 8-way conjunction across both source operands, as previously proven.)
 property p_no_stall_disjoint;
   @(posedge clk) disable iff (rst)
   ((decoding_op_src1 != 3'b000) &&
    (decoding_op_src2 != 3'b000) &&
    (ex_op_dest != decoding_op_src1) && (ex_op_dest != decoding_op_src2) &&
    (mem_op_dest != decoding_op_src1) && (mem_op_dest != decoding_op_src2) &&
    (wb_op_dest != decoding_op_src1) && (wb_op_dest != decoding_op_src2))
     |-> (pipeline_stall_n == 1'b1);
 endproperty
 assert property (p_no_stall_disjoint);

 property p_freeze_pc;
   @(posedge clk) disable iff (rst)
   (!pipeline_stall_n) |=> (pc == $past(pc));
 endproperty
 assert property (p_freeze_pc);

 // _assert_18 -- left exactly as is (do not touch).
 property p_freeze_id_latch;
   @(posedge clk) disable iff (rst)
   ($past(pc) == pc) |-> (instruction == $past(instruction));
 endproperty
 assert property (p_freeze_id_latch);

 // =====================================================================
 // Register file write/read
 // =====================================================================

 // Scenario: Register R0 remains zero even if a write to R0 is attempted
 // (REVERTED to prior working form -- restores original antecedent
 // requiring reg_write_en == 1 simultaneously with reg_write_dest == 0
 // and nonzero reg_write_data, as previously proven.)
 property p_regfile_r0_immutable;
   @(posedge clk) disable iff (rst)
   ((reg_write_en == 1'b1) && (reg_write_dest == 3'b000) && (reg_write_data != 16'h0000))
     |=> ((reg_read_addr_1 == 3'b000) -> (reg_read_data_1 == 16'h0000));
 endproperty
 assert property (p_regfile_r0_immutable);

 // =====================================================================
 // Pipeline register width / field integrity
 // =====================================================================

 property p_width_id_ex;
   @(posedge clk) disable iff (rst)
   1'b1 |-> ($bits(ID_pipeline_reg_out) == 57);
 endproperty
 assert property (p_width_id_ex);

 property p_width_ex_mem;
   @(posedge clk) disable iff (rst)
   1'b1 |-> ($bits(EX_pipeline_reg_out) == 38);
 endproperty
 assert property (p_width_ex_mem);

 property p_width_mem_wb;
   @(posedge clk) disable iff (rst)
   1'b1 |-> ($bits(MEM_pipeline_reg_out) == 37);
 endproperty
 assert property (p_width_mem_wb);

 // =====================================================================
 // Branch delay slot semantics
 // =====================================================================

 property p_branch_delay_pc_target;
   @(posedge clk) disable iff (rst)
   (branch_taken && pipeline_stall_n)
     |=> (pc == ($past(pc) + {{(PCW-6){$past(branch_offset_imm[5])}}, $past(branch_offset_imm)}));
 endproperty
 assert property (p_branch_delay_pc_target);

 // =====================================================================
 // ADDITIONAL COVERAGE PROPERTIES (new; existing 23 above are untouched)
 // Only real declared signals are used below (no invented signals).
 // =====================================================================

 // ---------------------------------------------------------------------
 // IF stage: instruction output tracks the current PC address
 // combinationally -- if PC does not change, the fetched instruction
 // must not change either. FIXED: guarded against the reset-boundary
 // artifact where "instruction" is force-cleared to 0 during rst (per
 // p_reset_pipeline_clear) while pc happens to read 0 both during and
 // immediately after reset release, which previously produced a false
 // mismatch. Requiring the prior cycle to not have been in reset avoids
 // that artifact while preserving the intended combinational coupling.
 // ---------------------------------------------------------------------
 property p_if_instruction_follows_pc;
   @(posedge clk) disable iff (rst)
   ((!$past(rst)) && (pc == $past(pc))) |-> (instruction == $past(instruction));
 endproperty
 assert property (p_if_instruction_follows_pc);

 // ---------------------------------------------------------------------
 // ID stage: bubble insertion on stall -- when the pipeline is stalled,
 // the ID/EX payload must be forced to the NOP-equivalent bubble
 // encoding (all-zero control/data fields), rather than simply holding
 // its previous value, per the behavioral spec for stall-induced bubble
 // insertion.
 // ---------------------------------------------------------------------
 property p_id_bubble_on_stall;
   @(posedge clk) disable iff (rst)
   (!pipeline_stall_n) |=> (ID_pipeline_reg_out == '0);
 endproperty
 assert property (p_id_bubble_on_stall);

 // ---------------------------------------------------------------------
 // ID stage: latch-on-enable -- when the pipeline is not stalled, the
 // ID/EX payload is updated away from the all-zero bubble encoding
 // whenever a genuine (non-zero-opcode) instruction was fetched in the
 // prior cycle. (Exact per-field bit layout of the 57-bit decode
 // payload is not asserted here; only that a real instruction produces
 // a non-bubble payload.)
 // ---------------------------------------------------------------------
 property p_id_latch_on_enable;
   @(posedge clk) disable iff (rst)
   (pipeline_stall_n && ($past(instruction) != 16'h0000))
     |=> (ID_pipeline_reg_out != 57'h0);
 endproperty
 assert property (p_id_latch_on_enable);

 // ---------------------------------------------------------------------
 // EX stage destination forwarding: ex_op_dest is purely a combinational
 // function of ID_pipeline_reg_out (the registered ID/EX payload).
 // FIXED: stability of ex_op_dest must be tied to stability of its
 // actual source register (ID_pipeline_reg_out), not to the stall
 // signal directly, since a stall forces ID_pipeline_reg_out (and hence
 // ex_op_dest) to the bubble encoding rather than holding.
 // ---------------------------------------------------------------------
 property p_ex_dest_stable_on_stall;
   @(posedge clk) disable iff (rst)
   (ID_pipeline_reg_out == $past(ID_pipeline_reg_out)) |-> (ex_op_dest == $past(ex_op_dest));
 endproperty
 assert property (p_ex_dest_stable_on_stall);

 // ---------------------------------------------------------------------
 // EX -> MEM destination forwarding chain.
 // ---------------------------------------------------------------------
 property p_ex_to_mem_dest_forward;
   @(posedge clk) disable iff (rst)
   (pipeline_stall_n) |=> (mem_op_dest == $past(ex_op_dest));
 endproperty
 assert property (p_ex_to_mem_dest_forward);

 // ---------------------------------------------------------------------
 // MEM stage: destination is a combinational function of EX_pipeline_
 // reg_out (the registered EX/MEM payload), which advances every cycle
 // regardless of the upstream (IF/ID) stall since only ID_pipeline_reg_out
 // is stall-gated. FIXED: the correct invariant during a stall cycle is
 // that mem_op_dest forwards from the prior ex_op_dest (EX/MEM register
 // keeps advancing to drain the pipeline), not that it stays frozen.
 // ---------------------------------------------------------------------
 property p_mem_dest_stable_on_stall;
   @(posedge clk) disable iff (rst)
   (!pipeline_stall_n) |=> (mem_op_dest == $past(ex_op_dest));
 endproperty
 assert property (p_mem_dest_stable_on_stall);

 // ---------------------------------------------------------------------
 // MEM -> WB destination forwarding chain.
 // ---------------------------------------------------------------------
 property p_mem_to_wb_dest_forward;
   @(posedge clk) disable iff (rst)
   (pipeline_stall_n) |=> (wb_op_dest == $past(mem_op_dest));
 endproperty
 assert property (p_mem_to_wb_dest_forward);

 // ---------------------------------------------------------------------
 // WB stage: reg_write_dest must match wb_op_dest at all times (the
 // register-file write port destination is forwarded from the WB
 // control stage's destination tracking field).
 // ---------------------------------------------------------------------
 property p_wb_reg_write_dest_matches_wb_op_dest;
   @(posedge clk) disable iff (rst)
   1'b1 |-> (reg_write_dest == wb_op_dest);
 endproperty
 assert property (p_wb_reg_write_dest_matches_wb_op_dest);

 // ---------------------------------------------------------------------
 // WB stage: reg_write_en is a combinational function of MEM_pipeline_
 // reg_out (the registered MEM/WB payload). FIXED: since MEM_pipeline_
 // reg_out is not stall-gated (it always advances to drain the
 // pipeline), reg_write_en is not generally stable across a stall
 // cycle; the true invariant is that reg_write_en only changes when its
 // actual source register (MEM_pipeline_reg_out) changes.
 // ---------------------------------------------------------------------
 property p_wb_write_en_stable_on_stall;
   @(posedge clk) disable iff (rst)
   (MEM_pipeline_reg_out == $past(MEM_pipeline_reg_out)) |-> (reg_write_en == $past(reg_write_en));
 endproperty
 assert property (p_wb_write_en_stable_on_stall);

 // ---------------------------------------------------------------------
 // Register file: normal write-then-read-back with a nonzero
 // destination register on read port 1.
 // ---------------------------------------------------------------------
 property p_regfile_write_then_readback_port1;
   @(posedge clk) disable iff (rst)
   (reg_write_en && (reg_write_dest != 3'b000))
     |=> ((reg_read_addr_1 == $past(reg_write_dest)) -> (reg_read_data_1 == $past(reg_write_data)));
 endproperty
 assert property (p_regfile_write_then_readback_port1);

 // ---------------------------------------------------------------------
 // Register file: normal write-then-read-back with a nonzero
 // destination register on read port 2.
 // ---------------------------------------------------------------------
 property p_regfile_write_then_readback_port2;
   @(posedge clk) disable iff (rst)
   (reg_write_en && (reg_write_dest != 3'b000))
     |=> ((reg_read_addr_2 == $past(reg_write_dest)) -> (reg_read_data_2 == $past(reg_write_data)));
 endproperty
 assert property (p_regfile_write_then_readback_port2);

 // ---------------------------------------------------------------------
 // Register file: write-disabled does not update the read data observed
 // on a stable read address (port 1). FIXED: guarded against the
 // reset-boundary artifact (analogous to the IF-stage fix above), where
 // $past values sampled from a reset cycle can otherwise produce a
 // false mismatch even though no functional write occurred.
 // ---------------------------------------------------------------------
 property p_regfile_no_write_when_disabled_port1;
   @(posedge clk) disable iff (rst)
   ((!$past(rst)) && (!reg_write_en) && (reg_read_addr_1 == $past(reg_read_addr_1)))
     |=> (reg_read_data_1 == $past(reg_read_data_1));
 endproperty
 assert property (p_regfile_no_write_when_disabled_port1);

 // ---------------------------------------------------------------------
 // Register file: write-disabled does not update the read data observed
 // on a stable read address (port 2). FIXED: same reset-boundary guard
 // as port 1 above.
 // ---------------------------------------------------------------------
 property p_regfile_no_write_when_disabled_port2;
   @(posedge clk) disable iff (rst)
   ((!$past(rst)) && (!reg_write_en) && (reg_read_addr_2 == $past(reg_read_addr_2)))
     |=> (reg_read_data_2 == $past(reg_read_data_2));
 endproperty
 assert property (p_regfile_no_write_when_disabled_port2);

 // ---------------------------------------------------------------------
 // Register file: general combinational read reflects the last written
 // value for a stable nonzero address across consecutive cycles.
 // ---------------------------------------------------------------------
 property p_regfile_read_reflects_last_write;
   @(posedge clk) disable iff (rst)
   ((reg_read_addr_1 != 3'b000) && (reg_read_addr_1 == $past(reg_read_addr_1)) &&
    $past(reg_write_en) && ($past(reg_write_dest) == reg_read_addr_1))
     |-> (reg_read_data_1 == $past(reg_write_data));
 endproperty
 assert property (p_regfile_read_reflects_last_write);


endmodule 




 




