//////////////////////////////////////////////////////////////////
//                                                              //
//  Amber 2 Core top-Level module                               //
//                                                              //
//  This file is part of the Amber project                      //
//  http://www.opencores.org/project,amber                      //
//                                                              //
//  Description                                                 //
//  Instantiates the core consisting of fetch, instruction      //
//  decode, execute, and co-processor.                          //
//                                                              //
//  Author(s):                                                  //
//      - Conor Santifort, csantifort.amber@gmail.com           //
//                                                              //
//////////////////////////////////////////////////////////////////
//                                                              //
// Copyright (C) 2010 Authors and OPENCORES.ORG                 //
//                                                              //
// This source file may be used and distributed without         //
// restriction provided that this copyright statement is not    //
// removed from the file and that any derivative work contains  //
// the original copyright notice and the associated disclaimer. //
//                                                              //
// This source file is free software; you can redistribute it   //
// and/or modify it under the terms of the GNU Lesser General   //
// Public License as published by the Free Software Foundation; //
// either version 2.1 of the License, or (at your option) any   //
// later version.                                               //
//                                                              //
// This source is distributed in the hope that it will be       //
// useful, but WITHOUT ANY WARRANTY; without even the implied   //
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      //
// PURPOSE.  See the GNU Lesser General Public License for more //
// details.                                                     //
//                                                              //
// You should have received a copy of the GNU Lesser General    //
// Public License along with this source; if not, download it   //
// from http://www.opencores.org/lgpl.shtml                     //
//                                                              //
//////////////////////////////////////////////////////////////////


module a23_core
(
input                       i_clk,

input                       i_irq,              // Interrupt request, active high
input                       i_firq,             // Fast Interrupt request, active high

input                       i_system_rdy,       // Amber is stalled when this is low

// Wishbone Master I/F
output      [31:0]          o_wb_adr,
output      [3:0]           o_wb_sel,
output                      o_wb_we,
input       [31:0]          i_wb_dat,
output      [31:0]          o_wb_dat,
output                      o_wb_cyc,
output                      o_wb_stb,
input                       i_wb_ack,
input                       i_wb_err

);

wire      [31:0]          execute_address;
wire                      execute_address_valid;
wire      [31:0]          execute_address_nxt;  // un-registered version of execute_address to the cache rams
wire      [31:0]          write_data;
wire                      write_enable;
wire      [31:0]          read_data;
wire                      priviledged;
wire                      exclusive_exec;
wire                      data_access_exec;
wire      [3:0]           byte_enable;
wire                      data_access;          // high for data petch, low for instruction fetch
wire                      exclusive;            // swap access
wire                      cache_enable;         // Enabel the cache
wire                      cache_flush;          // Flush the cache
wire      [31:0]          cacheable_area;

wire                      fetch_stall;          // when this is asserted all registers in all 3 pipeline 
                                                // stages are held
                                                // at their current values
wire     [1:0]            status_bits_mode;               
wire                      status_bits_irq_mask;           
wire                      status_bits_firq_mask;           
wire                      status_bits_flags_wen;          
wire                      status_bits_mode_wen;           
wire                      status_bits_irq_mask_wen;       
wire                      status_bits_firq_mask_wen;       
wire     [31:0]           execute_status_bits;
                 
wire     [31:0]           imm32;                   
wire     [4:0]            imm_shift_amount; 
wire                      shift_imm_zero;      
wire     [3:0]            condition;               
wire     [31:0]           read_data_s2;            
wire     [4:0]            read_data_alignment;     

wire     [3:0]            rm_sel;                  
wire     [3:0]            rds_sel;                 
wire     [3:0]            rn_sel;                  
wire     [3:0]            rm_sel_nxt;
wire     [3:0]            rds_sel_nxt;
wire     [3:0]            rn_sel_nxt;
wire     [1:0]            barrel_shift_amount_sel; 
wire     [1:0]            barrel_shift_data_sel;   
wire     [1:0]            barrel_shift_function; 
wire                      use_carry_in;  
wire     [8:0]            alu_function;            
wire     [1:0]            multiply_function;       
wire     [2:0]            interrupt_vector_sel;    
wire     [3:0]            address_sel;             
wire     [1:0]            pc_sel;                  
wire     [1:0]            byte_enable_sel;         
wire     [2:0]            status_bits_sel;                
wire     [2:0]            reg_write_sel;           
wire                      user_mode_regs_load;     
wire                      user_mode_regs_store_nxt;    
wire                      firq_not_user_mode;

wire                      write_data_wen;          
wire                      copro_write_data_wen;          
wire                      base_address_wen;        
wire                      pc_wen;                  
wire     [14:0]           reg_bank_wen;            
wire     [3:0]            reg_bank_wsel;            

wire     [2:0]            copro_opcode1;
wire     [2:0]            copro_opcode2;
wire     [3:0]            copro_crn;    
wire     [3:0]            copro_crm;
wire     [3:0]            copro_num;
wire     [1:0]            copro_operation;
wire     [31:0]           copro_read_data;
wire     [31:0]           copro_write_data;
wire                      multiply_done;

wire                      decode_fault;
wire                      iabt_trigger;
wire                      dabt_trigger;

wire     [7:0]            decode_fault_status;
wire     [7:0]            iabt_fault_status;
wire     [7:0]            dabt_fault_status;

wire     [31:0]           decode_fault_address;
wire     [31:0]           iabt_fault_address;
wire     [31:0]           dabt_fault_address;

wire                      adex;


// data abort has priority
assign decode_fault_status  = dabt_trigger ? dabt_fault_status  : iabt_fault_status;
assign decode_fault_address = dabt_trigger ? dabt_fault_address : iabt_fault_address;
assign decode_fault         = dabt_trigger | iabt_trigger;


a23_fetch u_fetch (
    .i_clk                              ( i_clk                             ),

    .i_address                          ( {execute_address[31:2], 2'd0}     ),
    .i_address_valid                    ( execute_address_valid             ), 
    .i_address_nxt                      ( execute_address_nxt               ),
    .i_write_data                       ( write_data                        ),
    .i_write_enable                     ( write_enable                      ),
    .o_read_data                        ( read_data                         ),
    .i_priviledged                      ( priviledged                       ),
    .i_byte_enable                      ( byte_enable                       ),
    .i_data_access                      ( data_access                       ),      
    .i_exclusive                        ( exclusive                         ),
    .i_cache_enable                     ( cache_enable                      ),     
    .i_cache_flush                      ( cache_flush                       ), 
    .i_cacheable_area                   ( cacheable_area                    ),

    .i_system_rdy                       ( i_system_rdy                      ),
    .o_fetch_stall                      ( fetch_stall                       ),
    
    .o_wb_adr                           ( o_wb_adr                          ),
    .o_wb_sel                           ( o_wb_sel                          ),
    .o_wb_we                            ( o_wb_we                           ),
    .i_wb_dat                           ( i_wb_dat                          ),
    .o_wb_dat                           ( o_wb_dat                          ),
    .o_wb_cyc                           ( o_wb_cyc                          ),
    .o_wb_stb                           ( o_wb_stb                          ),
    .i_wb_ack                           ( i_wb_ack                          ),
    .i_wb_err                           ( i_wb_err                          )
);


a23_decode u_decode (
    .i_clk                              ( i_clk                             ),
    
    // Instruction fetch or data read signals
    .i_read_data                        ( read_data                         ),                                          
    .i_execute_address                  ( execute_address                   ),
    .i_adex                             ( adex                              ),
    .i_iabt                             ( 1'd0                              ),
    .i_dabt                             ( 1'd0                              ),
    .i_abt_status                       ( 8'd0                              ),                                          
    
    .o_read_data                        ( read_data_s2                      ),                                          
    .o_read_data_alignment              ( read_data_alignment               ),                                          
    
    .i_irq                              ( i_irq                             ),                                          
    .i_firq                             ( i_firq                            ),                                          
    .i_fetch_stall                      ( fetch_stall                       ),                                          
    .i_execute_status_bits              ( execute_status_bits               ),                                          
    .i_multiply_done                    ( multiply_done                     ),                                          
    
    .o_status_bits_mode                 ( status_bits_mode                  ),
    .o_status_bits_irq_mask             ( status_bits_irq_mask              ),  
    .o_status_bits_firq_mask            ( status_bits_firq_mask             ),  
    .o_imm32                            ( imm32                             ),
    .o_imm_shift_amount                 ( imm_shift_amount                  ),
    .o_shift_imm_zero                   ( shift_imm_zero                    ),
    .o_condition                        ( condition                         ),
    .o_exclusive_exec                   ( exclusive_exec                    ), 
    .o_data_access_exec                 ( data_access_exec                  ),
    .o_rm_sel                           ( rm_sel                            ),
    .o_rds_sel                          ( rds_sel                           ),
    .o_rn_sel                           ( rn_sel                            ),
    .o_rm_sel_nxt                       ( rm_sel_nxt                        ),
    .o_rds_sel_nxt                      ( rds_sel_nxt                       ),
    .o_rn_sel_nxt                       ( rn_sel_nxt                        ),
    .o_barrel_shift_amount_sel          ( barrel_shift_amount_sel           ),
    .o_barrel_shift_data_sel            ( barrel_shift_data_sel             ),
    .o_barrel_shift_function            ( barrel_shift_function             ),
    .o_use_carry_in                     ( use_carry_in                      ),
    .o_alu_function                     ( alu_function                      ),
    .o_multiply_function                ( multiply_function                 ),
    .o_interrupt_vector_sel             ( interrupt_vector_sel              ),
    .o_address_sel                      ( address_sel                       ),
    .o_pc_sel                           ( pc_sel                            ),
    .o_byte_enable_sel                  ( byte_enable_sel                   ),
    .o_status_bits_sel                  ( status_bits_sel                   ),
    .o_reg_write_sel                    ( reg_write_sel                     ),
    .o_user_mode_regs_load              ( user_mode_regs_load               ),
    .o_user_mode_regs_store_nxt         ( user_mode_regs_store_nxt          ),
    .o_firq_not_user_mode               ( firq_not_user_mode                ),
    .o_write_data_wen                   ( write_data_wen                    ),
    .o_base_address_wen                 ( base_address_wen                  ),
    .o_pc_wen                           ( pc_wen                            ),
    .o_reg_bank_wen                     ( reg_bank_wen                      ),
    .o_reg_bank_wsel                    ( reg_bank_wsel                     ),
    .o_status_bits_flags_wen            ( status_bits_flags_wen             ),
    .o_status_bits_mode_wen             ( status_bits_mode_wen              ),
    .o_status_bits_irq_mask_wen         ( status_bits_irq_mask_wen          ),
    .o_status_bits_firq_mask_wen        ( status_bits_firq_mask_wen         ),
    
    .o_copro_opcode1                    ( copro_opcode1                     ),                                        
    .o_copro_opcode2                    ( copro_opcode2                     ),                                        
    .o_copro_crn                        ( copro_crn                         ),                                        
    .o_copro_crm                        ( copro_crm                         ),                                        
    .o_copro_num                        ( copro_num                         ),                                        
    .o_copro_operation                  ( copro_operation                   ), 
    .o_copro_write_data_wen             ( copro_write_data_wen              ),                                        
    
    .o_iabt_trigger                     ( iabt_trigger                      ),
    .o_iabt_address                     ( iabt_fault_address                ),
    .o_iabt_status                      ( iabt_fault_status                 ),
    .o_dabt_trigger                     ( dabt_trigger                      ),
    .o_dabt_address                     ( dabt_fault_address                ),
    .o_dabt_status                      ( dabt_fault_status                 ) 
);


a23_execute u_execute (
    .i_clk                              ( i_clk                             ),
    
    .i_read_data                        ( read_data_s2                      ),
    .i_read_data_alignment              ( read_data_alignment               ), 
    .i_copro_read_data                  ( copro_read_data                   ),
    
    .o_write_data                       ( write_data                        ),
    .o_copro_write_data                 ( copro_write_data                  ),
    .o_address                          ( execute_address                   ),
    .o_address_valid                    ( execute_address_valid             ),
    .o_address_nxt                      ( execute_address_nxt               ),
    .o_adex                             ( adex                              ),

    .o_byte_enable                      ( byte_enable                       ),
    .o_data_access                      ( data_access                       ),
    .o_write_enable                     ( write_enable                      ),
    .o_exclusive                        ( exclusive                         ),
    .o_priviledged                      ( priviledged                       ),
    .o_status_bits                      ( execute_status_bits               ),
    .o_multiply_done                    ( multiply_done                     ),

    .i_fetch_stall                      ( fetch_stall                       ),   
    .i_status_bits_mode                 ( status_bits_mode                  ),   
    .i_status_bits_irq_mask             ( status_bits_irq_mask              ),   
    .i_status_bits_firq_mask            ( status_bits_firq_mask             ),   
    .i_imm32                            ( imm32                             ),   
    .i_imm_shift_amount                 ( imm_shift_amount                  ),   
    .i_shift_imm_zero                   ( shift_imm_zero                    ),   
    .i_condition                        ( condition                         ),   
    .i_exclusive_exec                   ( exclusive_exec                    ),   
    .i_data_access_exec                 ( data_access_exec                  ),   
    .i_rm_sel                           ( rm_sel                            ),   
    .i_rds_sel                          ( rds_sel                           ),   
    .i_rn_sel                           ( rn_sel                            ),   
    .i_rm_sel_nxt                       ( rm_sel_nxt                        ),
    .i_rds_sel_nxt                      ( rds_sel_nxt                       ),
    .i_rn_sel_nxt                       ( rn_sel_nxt                        ),
    .i_barrel_shift_amount_sel          ( barrel_shift_amount_sel           ),   
    .i_barrel_shift_data_sel            ( barrel_shift_data_sel             ),   
    .i_barrel_shift_function            ( barrel_shift_function             ),   
    .i_use_carry_in                     ( use_carry_in                      ),
    .i_alu_function                     ( alu_function                      ),   
    .i_multiply_function                ( multiply_function                 ),   
    .i_interrupt_vector_sel             ( interrupt_vector_sel              ),   
    .i_address_sel                      ( address_sel                       ),   
    .i_pc_sel                           ( pc_sel                            ),   
    .i_byte_enable_sel                  ( byte_enable_sel                   ),   
    .i_status_bits_sel                  ( status_bits_sel                   ),   
    .i_reg_write_sel                    ( reg_write_sel                     ),   
    .i_user_mode_regs_load              ( user_mode_regs_load               ),   
    .i_user_mode_regs_store_nxt         ( user_mode_regs_store_nxt          ),   
    .i_firq_not_user_mode               ( firq_not_user_mode                ),   
    .i_write_data_wen                   ( write_data_wen                    ),   
    .i_base_address_wen                 ( base_address_wen                  ),   
    .i_pc_wen                           ( pc_wen                            ),   
    .i_reg_bank_wen                     ( reg_bank_wen                      ),   
    .i_reg_bank_wsel                    ( reg_bank_wsel                     ),
    .i_status_bits_flags_wen            ( status_bits_flags_wen             ),   
    .i_status_bits_mode_wen             ( status_bits_mode_wen              ),   
    .i_status_bits_irq_mask_wen         ( status_bits_irq_mask_wen          ),   
    .i_status_bits_firq_mask_wen        ( status_bits_firq_mask_wen         ),   
    .i_copro_write_data_wen             ( copro_write_data_wen              )
);


a23_coprocessor u_coprocessor (
    .i_clk                              ( i_clk                             ),
    
    .i_fetch_stall                      ( fetch_stall                       ),
    .i_copro_opcode1                    ( copro_opcode1                     ),
    .i_copro_opcode2                    ( copro_opcode2                     ),
    .i_copro_crn                        ( copro_crn                         ),    
    .i_copro_crm                        ( copro_crm                         ),
    .i_copro_num                        ( copro_num                         ),
    .i_copro_operation                  ( copro_operation                   ),
    .i_copro_write_data                 ( copro_write_data                  ),
    
    .i_fault                            ( decode_fault                      ),
    .i_fault_status                     ( decode_fault_status               ),
    .i_fault_address                    ( decode_fault_address              ), 
    
    .o_copro_read_data                  ( copro_read_data                   ),
    .o_cache_enable                     ( cache_enable                      ),
    .o_cache_flush                      ( cache_flush                       ),
    .o_cacheable_area                   ( cacheable_area                    )
);


// --- Formal assertions ---
// =========================================================================
// SVA for a23_core - derived independently from the Gherkin specification
// No explicit reset exists in this design (Background: FPGA config init),
// so no disable iff(reset) is used. i_system_rdy gates register updates.
//
// Only signals present in the SIGNAL DECLARATIONS list (top-level a23_core
// ports and internal control/status nets) are referenced. Properties whose
// specification concept required a signal that has no real counterpart in
// the declared signal set (raw ALU operands/output, raw barrel-shifter
// data path, per-field instruction decode bits, source register read
// values, condition-pass/decode-stall/pre-fetch internal probes, Booth
// product register, etc.) have been removed rather than invented.
// =========================================================================

// CPSR flag extraction from execute_status_bits (ARM CPSR bit layout)
wire n_flag = execute_status_bits[31];
wire z_flag = execute_status_bits[30];
wire c_flag = execute_status_bits[29];
wire v_flag = execute_status_bits[28];

localparam [1:0] MODE_USR = 2'b00, MODE_FIRQ = 2'b01,
                 MODE_IRQ = 2'b10, MODE_SVC = 2'b11;

// =========================================================================
// Condition Code Evaluation
// (cond_pass has no real signal; execute_address_valid is used as the
//  observable proxy for "instruction executes")
// =========================================================================

property p_cc_eq;
  @(posedge i_clk) (condition == 4'b0000) |-> (execute_address_valid == z_flag);
endproperty
assert property (p_cc_eq);

property p_cc_ne;
  @(posedge i_clk) (condition == 4'b0001) |-> (execute_address_valid == !z_flag);
endproperty
assert property (p_cc_ne);

property p_cc_cs;
  @(posedge i_clk) (condition == 4'b0010) |-> (execute_address_valid == c_flag);
endproperty
assert property (p_cc_cs);

property p_cc_cc;
  @(posedge i_clk) (condition == 4'b0011) |-> (execute_address_valid == !c_flag);
endproperty
assert property (p_cc_cc);

property p_cc_mi;
  @(posedge i_clk) (condition == 4'b0100) |-> (execute_address_valid == n_flag);
endproperty
assert property (p_cc_mi);

property p_cc_pl;
  @(posedge i_clk) (condition == 4'b0101) |-> (execute_address_valid == !n_flag);
endproperty
assert property (p_cc_pl);

property p_cc_vs;
  @(posedge i_clk) (condition == 4'b0110) |-> (execute_address_valid == v_flag);
endproperty
assert property (p_cc_vs);

property p_cc_vc;
  @(posedge i_clk) (condition == 4'b0111) |-> (execute_address_valid == !v_flag);
endproperty
assert property (p_cc_vc);

property p_cc_hi;
  @(posedge i_clk) (condition == 4'b1000) |-> (execute_address_valid == (c_flag && !z_flag));
endproperty
assert property (p_cc_hi);

property p_cc_ls;
  @(posedge i_clk) (condition == 4'b1001) |-> (execute_address_valid == (!c_flag || z_flag));
endproperty
assert property (p_cc_ls);

property p_cc_ge;
  @(posedge i_clk) (condition == 4'b1010) |-> (execute_address_valid == (n_flag == v_flag));
endproperty
assert property (p_cc_ge);

property p_cc_lt;
  @(posedge i_clk) (condition == 4'b1011) |-> (execute_address_valid == (n_flag != v_flag));
endproperty
assert property (p_cc_lt);

property p_cc_gt;
  @(posedge i_clk) (condition == 4'b1100) |-> (execute_address_valid == (!z_flag && (n_flag == v_flag)));
endproperty
assert property (p_cc_gt);

property p_cc_le;
  @(posedge i_clk) (condition == 4'b1101) |-> (execute_address_valid == (z_flag || (n_flag != v_flag)));
endproperty
assert property (p_cc_le);

property p_cc_al;
  @(posedge i_clk) (condition == 4'b1110) |-> (execute_address_valid == 1'b1);
endproperty
assert property (p_cc_al);

property p_cc_nv;
  @(posedge i_clk) (condition == 4'b1111) |-> (execute_address_valid == 1'b0);
endproperty
assert property (p_cc_nv);

// =========================================================================
// Multiply (Booth's Algorithm) Properties
// (Only completion timing is observable; operand/product internals are
//  not exposed as real signals.)
// =========================================================================

property p_multiply_completes;
  @(posedge i_clk)
  $rose(multiply_function != 2'b00) |-> ##[1:34] multiply_done;
endproperty
assert property (p_multiply_completes);

// =========================================================================
// Pipeline Stall / Load-Store Behavior
// =========================================================================

property p_load_stall_2cyc;
  @(posedge i_clk)
  (data_access_exec && !write_enable) |-> ##1 fetch_stall ##1 fetch_stall ##1 !fetch_stall;
endproperty
assert property (p_load_stall_2cyc);

property p_store_stall_2cyc;
  @(posedge i_clk)
  (data_access_exec && write_enable) |-> ##1 fetch_stall ##1 fetch_stall ##1 !fetch_stall;
endproperty
assert property (p_store_stall_2cyc);

property p_cache_miss_stall;
  @(posedge i_clk)
  (fetch_stall && o_wb_cyc) |-> (fetch_stall throughout (!i_wb_ack)[->1]);
endproperty
assert property (p_cache_miss_stall);

property p_sysrdy_freeze;
  @(posedge i_clk)
  (!i_system_rdy) |=> ($stable(execute_address) && $stable(execute_status_bits));
endproperty
assert property (p_sysrdy_freeze);

// =========================================================================
// Interrupt / Exception Vector Selection
// =========================================================================

property p_reset_vector;
  @(posedge i_clk)
  (interrupt_vector_sel == 3'd0) |-> (execute_address_nxt == 32'h00000000 &&
                                       status_bits_mode == MODE_SVC);
endproperty
assert property (p_reset_vector);

property p_undef_vector;
  @(posedge i_clk)
  (decode_fault) |-> (execute_address_nxt == 32'h00000004 && status_bits_mode == MODE_SVC);
endproperty
assert property (p_undef_vector);

property p_swi_vector;
  @(posedge i_clk)
  (interrupt_vector_sel == 3'd2 && execute_address_valid) |-> (execute_address_nxt == 32'h00000008 &&
                                                                 status_bits_mode == MODE_SVC);
endproperty
assert property (p_swi_vector);

property p_pabt_vector;
  @(posedge i_clk)
  (iabt_trigger) |-> (execute_address_nxt == 32'h0000000C && status_bits_mode == MODE_SVC);
endproperty
assert property (p_pabt_vector);

property p_dabt_vector;
  @(posedge i_clk)
  (dabt_trigger) |-> (execute_address_nxt == 32'h00000010 && status_bits_mode == MODE_SVC);
endproperty
assert property (p_dabt_vector);

property p_adex_vector;
  @(posedge i_clk)
  (adex) |-> (execute_address_nxt == 32'h00000014 && status_bits_mode == MODE_SVC);
endproperty
assert property (p_adex_vector);

property p_irq_vector;
  @(posedge i_clk)
  (i_irq && !i_firq && !status_bits_irq_mask) |=> (execute_address == 32'h00000018 &&
                                                     status_bits_mode == MODE_IRQ);
endproperty
assert property (p_irq_vector);

property p_firq_vector;
  @(posedge i_clk)
  (i_firq && !status_bits_firq_mask) |=> (execute_address == 32'h0000001C &&
                                            status_bits_mode == MODE_FIRQ);
endproperty
assert property (p_firq_vector);

property p_irq_masked;
  @(posedge i_clk)
  (i_irq && status_bits_irq_mask) |=> (status_bits_mode != MODE_IRQ);
endproperty
assert property (p_irq_masked);

property p_irq_defer_simple;
  @(posedge i_clk)
  (i_irq && fetch_stall) |-> (status_bits_mode != MODE_IRQ);
endproperty
assert property (p_irq_defer_simple);

// =========================================================================
// Register Bank / Banking Properties
// =========================================================================

property p_firq_bank_wsel;
  @(posedge i_clk)
  (status_bits_mode == MODE_FIRQ && reg_bank_wsel >= 4'd8 && reg_bank_wsel <= 4'd14)
    |-> (reg_bank_wen != 15'd0);
endproperty
assert property (p_firq_bank_wsel);

property p_svc_bank_wsel;
  @(posedge i_clk)
  (status_bits_mode == MODE_SVC && (reg_bank_wsel == 4'd13 || reg_bank_wsel == 4'd14))
    |-> (reg_bank_wen != 15'd0);
endproperty
assert property (p_svc_bank_wsel);

// =========================================================================
// Status Register Field Properties
// =========================================================================

property p_mode_not_writable_user;
  @(posedge i_clk)
  (status_bits_mode == MODE_USR && status_bits_mode_wen)
    |=> (status_bits_mode == MODE_USR);
endproperty
assert property (p_mode_not_writable_user);

// =========================================================================
// Instruction Set Semantics: Swap, Single Transfer
// =========================================================================

property p_swp_exchange;
  @(posedge i_clk)
  (exclusive_exec && byte_enable == 4'b1111 && !write_enable)
    |-> ##[1:2] (exclusive_exec && write_enable && byte_enable == 4'b1111);
endproperty
assert property (p_swp_exchange);

property p_swpb_exchange;
  @(posedge i_clk)
  (exclusive_exec && byte_enable_sel == 2'd1 && !write_enable)
    |-> (read_data[31:8] == 24'h0);
endproperty
assert property (p_swpb_exchange);

property p_ldr_rotate;
  @(posedge i_clk)
  (read_data_alignment != 5'd0)
    |-> (read_data == ((read_data_s2 >> {read_data_alignment[1:0], 3'b0}) |
                        (read_data_s2 << (32 - {read_data_alignment[1:0], 3'b0}))));
endproperty
assert property (p_ldr_rotate);

property p_ldrb_zeroext;
  @(posedge i_clk)
  (byte_enable_sel == 2'd1 && !write_enable) |-> (read_data[31:8] == 24'h0);
endproperty
assert property (p_ldrb_zeroext);

property p_str_word;
  @(posedge i_clk)
  (write_enable && byte_enable == 4'b1111) |-> (o_wb_dat == write_data);
endproperty
assert property (p_str_word);

property p_strb_byte;
  @(posedge i_clk)
  (write_enable && byte_enable_sel == 2'd1) |-> (o_wb_dat[7:0] == write_data[7:0]);
endproperty
assert property (p_strb_byte);

// =========================================================================
// Coprocessor Register Transfer Instructions
// =========================================================================

property p_mcr_transfer;
  @(posedge i_clk)
  (copro_operation == 2'd1) |-> (copro_write_data_wen);
endproperty
assert property (p_mcr_transfer);

property p_mrc_transfer;
  @(posedge i_clk)
  (copro_operation == 2'd2 && rds_sel != 4'd15) |-> (write_data == copro_read_data);
endproperty
assert property (p_mrc_transfer);

property p_mrc_r15_flags;
  @(posedge i_clk)
  (copro_operation == 2'd2 && rds_sel == 4'd15)
    |-> (execute_status_bits[31:28] == copro_read_data[31:28]);
endproperty
assert property (p_mrc_r15_flags);

// =========================================================================
// Little-Endian Byte Ordering
// =========================================================================

property p_endian_store_lsb;
  @(posedge i_clk)
  (write_enable && byte_enable == 4'b1111) |-> (o_wb_dat[7:0] == write_data[7:0] &&
                                                  o_wb_dat[31:24] == write_data[31:24]);
endproperty
assert property (p_endian_store_lsb);

property p_endian_load_lsb;
  @(posedge i_clk)
  (i_wb_ack && !write_enable) |-> (read_data == i_wb_dat);
endproperty
assert property (p_endian_load_lsb);

property p_byte_lane_select;
  @(posedge i_clk)
  (write_enable && byte_enable_sel == 2'd1) |-> ($countones(o_wb_sel) == 1);
endproperty
assert property (p_byte_lane_select);

// =========================================================================
// Wishbone Interface Signal Properties
// =========================================================================

property p_wb_address;
  @(posedge i_clk)
  (o_wb_stb) |-> (o_wb_adr == execute_address);
endproperty
assert property (p_wb_address);

property p_wb_byte_select;
  @(posedge i_clk)
  (o_wb_we) |-> (o_wb_sel == byte_enable);
endproperty
assert property (p_wb_byte_select);

property p_wb_we;
  @(posedge i_clk)
  (o_wb_stb) |-> (o_wb_we == write_enable);
endproperty
assert property (p_wb_we);

property p_wb_read_sample;
  @(posedge i_clk)
  (o_wb_stb && !o_wb_we && i_wb_ack) |=> ($past(i_wb_dat) == read_data);
endproperty
assert property (p_wb_read_sample);

property p_wb_write_data;
  @(posedge i_clk)
  (o_wb_stb && o_wb_we) |-> (o_wb_dat == write_data);
endproperty
assert property (p_wb_write_data);

property p_wb_cyc_hold;
  @(posedge i_clk)
  (o_wb_cyc && !i_wb_ack) |=> (o_wb_cyc);
endproperty
assert property (p_wb_cyc_hold);

property p_wb_stb_once;
  @(posedge i_clk)
  (o_wb_stb && i_wb_ack) |=> (!o_wb_stb || o_wb_cyc);
endproperty
assert property (p_wb_stb_once);

property p_wb_err_terminate;
  @(posedge i_clk)
  (i_wb_err) |=> (!o_wb_cyc || !o_wb_stb);
endproperty
assert property (p_wb_err_terminate);

property p_wb_err_no_write;
  @(posedge i_clk)
  (i_wb_err) |-> (write_enable == 1'b0 || o_wb_we == 1'b0);
endproperty
assert property (p_wb_err_no_write);

// =========================================================================
// Cache Configuration and Behavior
// =========================================================================

property p_cache_write_through;
  @(posedge i_clk)
  (write_enable && cache_enable) |-> (o_wb_stb && o_wb_we);
endproperty
assert property (p_cache_write_through);

property p_cache_read_miss_fill;
  @(posedge i_clk)
  (fetch_stall && !write_enable) |-> (o_wb_cyc && !o_wb_we);
endproperty
assert property (p_cache_read_miss_fill);

property p_cache_write_miss_no_alloc;
  @(posedge i_clk)
  (write_enable && fetch_stall) |-> (!o_wb_cyc || o_wb_we);
endproperty
assert property (p_cache_write_miss_no_alloc);

// =========================================================================
// Input Assumptions
// =========================================================================

property a_condition_valid;
  @(posedge i_clk) (condition inside {[4'b0000:4'b1111]});
endproperty
assume property (a_condition_valid);


endmodule

