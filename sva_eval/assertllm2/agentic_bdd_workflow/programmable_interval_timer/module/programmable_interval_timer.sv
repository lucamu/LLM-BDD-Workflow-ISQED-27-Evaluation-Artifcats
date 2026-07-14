////////////////////////////////////////////////////////////////////////////////
//
//  WISHBONE revB.2 compliant Programable Interrupt Timer - Top-level
//
//  Author: Bob Hayes
//          rehayes@opencores.org
//
//  Downloaded from: http://www.opencores.org/projects/pit.....
//
////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2009, Robert Hayes
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the <organization> nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY Robert Hayes ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL Robert Hayes BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
////////////////////////////////////////////////////////////////////////////////
// 45678901234567890123456789012345678901234567890123456789012345678901234567890

module pit_top #(parameter ARST_LVL = 1'b0,      // asynchronous reset level
                 parameter PRE_COUNT_SIZE = 15,  // Prescale Counter size
                 parameter COUNT_SIZE = 16,      // Main counter size
                 parameter DECADE_CNTR = 1'b1,   // Prescale rollover decode
                 parameter NO_PRESCALE = 1'b0,   // Remove prescale function
                 parameter SINGLE_CYCLE = 1'b0,  // No bus wait state added
		 parameter DWIDTH = 16)          // Data bus width
  (
  // Wishbone Signals
  output [DWIDTH-1:0] wb_dat_o,     // databus output
  output              wb_ack_o,     // bus cycle acknowledge output
  input               wb_clk_i,     // master clock input
  input               wb_rst_i,     // synchronous active high reset
  input               arst_i,       // asynchronous reset
  input         [2:0] wb_adr_i,     // lower address bits
  input  [DWIDTH-1:0] wb_dat_i,     // databus input
  input               wb_we_i,      // write enable input
  input               wb_stb_i,     // stobe/core select signal
  input               wb_cyc_i,     // valid bus cycle input
  input         [1:0] wb_sel_i,     // Select byte in word bus transaction
  // PIT IO Signals
  output              pit_o,        // PIT output pulse
  output              pit_irq_o,    // PIT interrupt request signal output
  output              cnt_flag_o,   // PIT Flag Out
  output              cnt_sync_o,   // PIT Master Enable for Slave PIT's
  input               ext_sync_i    // Counter enable from Master PIT
  );
  
  wire [COUNT_SIZE-1:0] mod_value;     // Main Counter Modulo
  wire [COUNT_SIZE-1:0] cnt_n;         // PIT Counter Value
  wire                  async_rst_b;   // Asyncronous reset
  wire                  sync_reset;    // Syncronous reset
  wire           [ 3:0] write_regs;    // Control register write strobes
  wire                  prescale_out;  //
  wire                  pit_flg_clr;   // Clear PIT Rollover Status Bit
  wire                  pit_slave;     // PIT in Slave Mode, ext_sync_i selected
  wire           [ 3:0] pit_pre_scl;   // Prescaler modulo
  wire                  counter_sync;  // 
  
  // Wishbone Bus interface
  pit_wb_bus #(.ARST_LVL(ARST_LVL),
               .SINGLE_CYCLE(SINGLE_CYCLE),
               .DWIDTH(DWIDTH))
    wishbone(
    .wb_dat_o     ( wb_dat_o ),
    .wb_ack_o     ( wb_ack_o ),
    .wb_clk_i     ( wb_clk_i ),
    .wb_rst_i     ( wb_rst_i ),
    .arst_i       ( arst_i ),
    .wb_adr_i     ( wb_adr_i ),
    .wb_dat_i     ( wb_dat_i ),
    .wb_we_i      ( wb_we_i ),
    .wb_stb_i     ( wb_stb_i ),
    .wb_cyc_i     ( wb_cyc_i ),
    .wb_sel_i     ( wb_sel_i ),
    
    // outputs
    .write_regs   ( write_regs ),
    .sync_reset   ( sync_reset ),
    // inputs    
    .async_rst_b  ( async_rst_b ),
    .irq_source   ( cnt_flag_o ),
    .read_regs    (               // in  -- status register bits
		   { cnt_n,
		     mod_value,
		     {pit_slave, DECADE_CNTR, NO_PRESCALE, 1'b0, pit_pre_scl,
		      5'b0, cnt_flag_o, pit_ien, cnt_sync_o}
		   }
		  )
  );

// -----------------------------------------------------------------------------
  pit_regs #(.ARST_LVL(ARST_LVL),
             .COUNT_SIZE(COUNT_SIZE),
	     .NO_PRESCALE(NO_PRESCALE),
             .DWIDTH(DWIDTH))
    regs(
    // outputs
    .mod_value    ( mod_value ),
    .pit_pre_scl  ( pit_pre_scl ),
    .pit_slave    ( pit_slave ),
    .pit_flg_clr  ( pit_flg_clr ),
    .pit_ien      ( pit_ien ),
    .cnt_sync_o   ( cnt_sync_o ),
    .pit_irq_o    ( pit_irq_o ),
    // inputs
    .async_rst_b  ( async_rst_b ),
    .sync_reset   ( sync_reset ),
    .bus_clk      ( wb_clk_i ),
    .write_bus    ( wb_dat_i ),
    .write_regs   ( write_regs ),
    .cnt_flag_o   ( cnt_flag_o )
  );

// -----------------------------------------------------------------------------
  pit_prescale #(.COUNT_SIZE(PRE_COUNT_SIZE),
                 .DECADE_CNTR(DECADE_CNTR),
		 .NO_PRESCALE(NO_PRESCALE))
    prescale(
    // outputs
    .prescale_out      ( prescale_out ),
    .counter_sync      ( counter_sync ),
    // inputs
    .async_rst_b       ( async_rst_b ),
    .sync_reset        ( sync_reset ),
    .bus_clk           ( wb_clk_i ),
    .cnt_sync_o        ( cnt_sync_o ),
    .ext_sync_i        ( ext_sync_i ),
    .pit_slave         ( pit_slave ),
    .divisor           ( pit_pre_scl )
  );

// -----------------------------------------------------------------------------
  pit_count #(.COUNT_SIZE(COUNT_SIZE))
    counter(
    // outputs
    .cnt_n             ( cnt_n ),
    .cnt_flag_o        ( cnt_flag_o ),
    .pit_o             ( pit_o ),
    // inputs
    .async_rst_b       ( async_rst_b ),
    .sync_reset        ( sync_reset ),
    .bus_clk           ( wb_clk_i ),
    .counter_sync      ( counter_sync ),
    .prescale_out      ( prescale_out ),
    .pit_flg_clr       ( pit_flg_clr ),
    .mod_value         ( mod_value )
  );

                 // --- Formal assertions ---
                 // =============================================================================
                 // SVA Formal Properties for programmable_interval_timer (pit_top)
                 // Derived strictly from the Gherkin behavioral specification.
                 // -----------------------------------------------------------------------------
                 // NOTE ON SIGNAL MAPPING:
                 // The following internal/interface signals are required by the specification
                 // but were not explicitly enumerated as top-level pit_top wires (they are
                 // internal registers inside the pit_regs submodule instance, named "regs" in
                 // pit_top). They are referenced hierarchically as regs.ena_int and
                 // regs.cnt_en, consistent with the declared wires (mod_value, cnt_n,
                 // pit_slave, pit_pre_scl, write_regs, prescale_out, pit_flg_clr,
                 // counter_sync):
                 //   wb_we_i, wb_stb_i, wb_rst_i, wb_sel_i, wb_ack_o, cnt_flag_o : WB interface
                 //   regs.ena_int, regs.cnt_en                                   : CNTRL bits
                 // =============================================================================

                 // Helper combinational selection signal per spec: "module selection is defined
                 // as wb_cyc_i AND wb_stb_i"
                 wire sel = wb_cyc_i && wb_stb_i;

                 // Reset condition helpers
                 wire arst_active = (arst_i == ARST_LVL);

                 // Reset value of main counter per spec ("cnt_n should be 1")
                 wire [COUNT_SIZE-1:0] CNT_RESET_VAL = {{(COUNT_SIZE-1){1'b0}}, 1'b1};

                 // =============================================================================
                 // Reset behavior
                 // =============================================================================

                 // Scenario: Asynchronous reset clears control and status state
                 property p_async_reset_clears_state;
                   @(posedge wb_clk_i)
                   (arst_active) |->
                     (cnt_flag_o   == 1'b0 &&
                      pit_irq_o    == 1'b0 &&
                      cnt_sync_o   == 1'b0 &&
                      pit_slave    == 1'b0 &&
                      pit_pre_scl  == 4'b0000 &&
                      regs.ena_int == 1'b0 &&
                      regs.cnt_en  == 1'b0 &&
                      mod_value    == '0 &&
                      cnt_n        == CNT_RESET_VAL);
                 endproperty
                 assert property (p_async_reset_clears_state)
                   else $error("Async reset failed to clear control/status state");

                 // Scenario: Synchronous reset clears control and status state
                 property p_sync_reset_clears_state;
                   @(posedge wb_clk_i) disable iff (arst_active)
                   (wb_rst_i) |->
                     (cnt_flag_o   == 1'b0 &&
                      pit_irq_o    == 1'b0 &&
                      cnt_sync_o   == 1'b0 &&
                      pit_slave    == 1'b0 &&
                      pit_pre_scl  == 4'b0000 &&
                      regs.ena_int == 1'b0 &&
                      regs.cnt_en  == 1'b0 &&
                      mod_value    == '0 &&
                      cnt_n        == CNT_RESET_VAL);
                 endproperty
                 assert property (p_sync_reset_clears_state)
                   else $error("Sync reset failed to clear control/status state");

                 // Scenario: pit_o is deasserted during synchronous reset
                 property p_pit_o_deasserted_sync_reset;
                   @(posedge wb_clk_i) disable iff (arst_active)
                   (wb_rst_i) |-> (pit_o == 1'b0);
                 endproperty
                 assert property (p_pit_o_deasserted_sync_reset)
                   else $error("pit_o asserted during synchronous reset");

                 // =============================================================================
                 // WISHBONE acknowledge protocol
                 // =============================================================================

                 generate
                 if (SINGLE_CYCLE == 0) begin : g_ack_default_mode
                   // Scenario: Acknowledge is delayed by one wait state in default mode
                   property p_ack_default_first_cycle_low;
                     @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                     (sel && !$past(sel)) |-> (!wb_ack_o);
                   endproperty
                   assert property (p_ack_default_first_cycle_low)
                     else $error("wb_ack_o asserted on first selected cycle in default mode");

                   property p_ack_default_second_cycle_high;
                     @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                     (sel && $past(sel) && !$past(wb_ack_o)) |-> (wb_ack_o);
                   endproperty
                   assert property (p_ack_default_second_cycle_high)
                     else $error("wb_ack_o not asserted on second consecutive selected cycle");
                 end
                 endgenerate

                 generate
                 if (SINGLE_CYCLE == 1) begin : g_ack_single_cycle
                   // Scenario: Acknowledge follows access immediately in single-cycle mode
                   property p_ack_single_cycle;
                     @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                     (sel) |-> (wb_ack_o);
                   endproperty
                   assert property (p_ack_single_cycle)
                     else $error("wb_ack_o not immediate in single-cycle mode");
                 end
                 endgenerate

                 // Scenario: Acknowledge is deasserted when the module is not selected
                 property p_ack_deselect;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (!sel) |-> (!wb_ack_o);
                 endproperty
                 assert property (p_ack_deselect)
                   else $error("wb_ack_o asserted while module not selected");

                 // =============================================================================
                 // Register write decode - DWIDTH = 16
                 // =============================================================================

                 generate
                 if (DWIDTH == 16) begin : g_dwidth16_writes

                   // Scenario: CNTRL register write updates control bits (combinational flg_clr)
                   property p_cntrl16_flgclr;
                     @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                     (sel && wb_we_i && (wb_adr_i == 3'h0) && wb_ack_o) |->
                       (pit_flg_clr == wb_dat_i[2]);
                   endproperty
                   assert property (p_cntrl16_flgclr)
                     else $error("pit_flg_clr mismatch on CNTRL write (DWIDTH16)");

                   // Registered fields updated on the cycle following the acknowledged write
                   property p_cntrl16_regs;
                     @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                     (sel && wb_we_i && (wb_adr_i == 3'h0) && wb_ack_o) |=>
                       (pit_slave   == $past(wb_dat_i[15]) &&
                        pit_pre_scl == $past(wb_dat_i[11:8]) &&
                        regs.ena_int == $past(wb_dat_i[1]) &&
                        regs.cnt_en  == $past(wb_dat_i[0]));
                   endproperty
                   assert property (p_cntrl16_regs)
                     else $error("CNTRL register fields not updated correctly (DWIDTH16)");

                   // Scenario: MOD register write updates modulo value (DWIDTH=16)
                   property p_mod16_write;
                     @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                     (sel && wb_we_i && (wb_adr_i == 3'h1) && wb_ack_o) |=>
                       (mod_value == $past(wb_dat_i));
                   endproperty
                   assert property (p_mod16_write)
                     else $error("MOD_VAL not updated correctly (DWIDTH16)");

                 end
                 endgenerate

                 // =============================================================================
                 // Register write decode - DWIDTH = 8
                 // =============================================================================

                 generate
                 if (DWIDTH == 8) begin : g_dwidth8_writes

                   // Scenario: CNTRL_0 write updates low control byte
                   property p_cntrl0_flgclr;
                     @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                     (sel && wb_we_i && (wb_adr_i == 3'h0) && wb_ack_o) |->
                       (pit_flg_clr == wb_dat_i[2]);
                   endproperty
                   assert property (p_cntrl0_flgclr)
                     else $error("pit_flg_clr mismatch on CNTRL_0 write");

                   property p_cntrl0_regs;
                     @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                     (sel && wb_we_i && (wb_adr_i == 3'h0) && wb_ack_o) |=>
                       (regs.ena_int == $past(wb_dat_i[1]) &&
                        regs.cnt_en  == $past(wb_dat_i[0]) &&
                        pit_slave    == $past(pit_slave) &&
                        pit_pre_scl  == $past(pit_pre_scl));
                   endproperty
                   assert property (p_cntrl0_regs)
                     else $error("CNTRL_0 write side-effects incorrect");

                   // Scenario: CNTRL_1 write updates high control byte
                   property p_cntrl1_regs;
                     @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                     (sel && wb_we_i && (wb_adr_i == 3'h1) && wb_ack_o) |=>
                       (pit_slave    == $past(wb_dat_i[7]) &&
                        pit_pre_scl  == $past(wb_dat_i[3:0]) &&
                        regs.ena_int == $past(regs.ena_int) &&
                        regs.cnt_en  == $past(regs.cnt_en));
                   endproperty
                   assert property (p_cntrl1_regs)
                     else $error("CNTRL_1 write side-effects incorrect");

                   // Scenario: MOD_0 write updates low modulo byte, preserves high byte
                   property p_mod0_write;
                     @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                     (sel && wb_we_i && (wb_adr_i == 3'h2) && wb_ack_o) |=>
                       (mod_value[7:0]  == $past(wb_dat_i) &&
                        mod_value[COUNT_SIZE-1:8] == $past(mod_value[COUNT_SIZE-1:8]));
                   endproperty
                   assert property (p_mod0_write)
                     else $error("MOD_0 write did not update low byte / preserve high byte");

                 end
                 endgenerate

                 // =============================================================================
                 // Register read behavior
                 // =============================================================================

                 generate
                 if (DWIDTH == 16) begin : g_dwidth16_reads

                   // Scenario: CNTRL register read reflects current control/status
                   property p_cntrl16_read;
                     @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                     (sel && !wb_we_i && (wb_adr_i == 3'h0) && wb_ack_o) |->
                       (wb_dat_o[15]    == pit_slave &&
                        wb_dat_o[11:8]  == pit_pre_scl &&
                        wb_dat_o[14]    == DECADE_CNTR &&
                        wb_dat_o[13]    == NO_PRESCALE &&
                        wb_dat_o[2]     == cnt_flag_o &&
                        wb_dat_o[1]     == regs.ena_int &&
                        wb_dat_o[0]     == regs.cnt_en);
                   endproperty
                   assert property (p_cntrl16_read)
                     else $error("CNTRL read data mismatch (DWIDTH16)");

                   // Scenario: MOD register read reflects stored modulo value
                   property p_mod16_read;
                     @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                     (sel && !wb_we_i && (wb_adr_i == 3'h1) && wb_ack_o) |->
                       (wb_dat_o == mod_value);
                   endproperty
                   assert property (p_mod16_read)
                     else $error("MOD read data mismatch (DWIDTH16)");

                   // Scenario: CNT register read reflects current counter value
                   property p_cnt16_read;
                     @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                     (sel && !wb_we_i && (wb_adr_i == 3'h2) && wb_ack_o) |->
                       (wb_dat_o == cnt_n);
                   endproperty
                   assert property (p_cnt16_read)
                     else $error("CNT read data mismatch (DWIDTH16)");

                 end
                 endgenerate

                 // =============================================================================
                 // CNTRL semantics: SLAVE / master enable source
                 // =============================================================================

                 // Scenario: Slave mode routes ext_sync_i to the counter enable
                 property p_slave_mode_routing;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (pit_slave == 1'b1) |-> (counter_sync == ext_sync_i);
                 endproperty
                 assert property (p_slave_mode_routing)
                   else $error("Slave mode did not route ext_sync_i to counter_sync");

                 // Scenario: Master mode routes CNT_EN to the counter enable
                 property p_master_mode_routing;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (pit_slave == 1'b0) |-> (counter_sync == regs.cnt_en && cnt_sync_o == regs.cnt_en);
                 endproperty
                 assert property (p_master_mode_routing)
                   else $error("Master mode did not route CNT_EN correctly");

                 // Scenario: CNT_EN writes still update cnt_sync_o in slave mode
                 property p_slave_local_writeback;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (pit_slave == 1'b1 && sel && wb_we_i && wb_ack_o) |=>
                     (cnt_sync_o == regs.cnt_en);
                 endproperty
                 assert property (p_slave_local_writeback)
                   else $error("cnt_sync_o did not follow CNT_EN write in slave mode");
                 // NOTE: "counter_sync should not necessarily equal C" is a non-constraint
                 // (no assertion required) - covered by p_slave_mode_routing already ensuring
                 // counter_sync tracks ext_sync_i instead.

                 // =============================================================================
                 // Flag and interrupt behavior
                 // =============================================================================

                 // Scenario: Writing FLAG=1 clears the sticky rollover flag
                 property p_flag_clear_on_write;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (cnt_flag_o == 1'b1 && pit_flg_clr == 1'b1) |=> (cnt_flag_o == 1'b0);
                 endproperty
                 assert property (p_flag_clear_on_write)
                   else $error("Flag not cleared after FLAG=1 write");

                 // Scenario: Disabling counting clears the sticky rollover flag
                 property p_flag_clear_on_disable;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (cnt_flag_o == 1'b1 && $past(counter_sync) == 1'b1 && counter_sync == 1'b0) |->
                     (cnt_flag_o == 1'b0);
                 endproperty
                 assert property (p_flag_clear_on_disable)
                   else $error("Flag not cleared when counting disabled");

                 // Scenario: Rollover sets the sticky flag
                 property p_flag_set_on_rollover;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (counter_sync && prescale_out && (cnt_n == mod_value - 1'b1) && (mod_value > 1)) |=>
                     (cnt_flag_o == 1'b1);
                 endproperty
                 assert property (p_flag_set_on_rollover)
                   else $error("cnt_flag_o not set on qualified rollover");

                 // Scenario: Flag remains set without a clear request or disable
                 property p_flag_sticky;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (cnt_flag_o == 1'b1 && pit_flg_clr == 1'b0 &&
                    counter_sync == 1'b1 && $past(counter_sync) == 1'b1) |-> (cnt_flag_o == 1'b1);
                 endproperty
                 assert property (p_flag_sticky)
                   else $error("Flag unexpectedly cleared without clear/disable");

                 // Scenario: pit_irq_o tracks flag gated by interrupt enable
                 property p_irq_gating;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (1'b1) |-> (pit_irq_o == (cnt_flag_o && regs.ena_int));
                 endproperty
                 assert property (p_irq_gating)
                   else $error("pit_irq_o does not match cnt_flag_o AND ena_int");

                 // =============================================================================
                 // Prescaler decode behavior
                 // =============================================================================

                 generate
                 if (NO_PRESCALE == 1) begin : g_prescale_bypass
                   // Scenario: NO_PRESCALE bypasses prescaler division
                   property p_prescale_bypass;
                     @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                     (counter_sync == 1'b1) |-> (prescale_out == 1'b1);
                   endproperty
                   assert property (p_prescale_bypass)
                     else $error("prescale_out not asserted every cycle under NO_PRESCALE");
                 end
                 endgenerate

                 // Auxiliary cycle counter for prescaler period-checking (verification aid only)
                 logic [31:0] presc_cyc_cnt;
                 always_ff @(posedge wb_clk_i or posedge arst_i) begin
                   if (arst_active) begin
                     presc_cyc_cnt <= 32'd0;
                   end else if (wb_rst_i) begin
                     presc_cyc_cnt <= 32'd0;
                   end else if (counter_sync) begin
                     if (prescale_out)
                       presc_cyc_cnt <= 32'd1;
                     else
                       presc_cyc_cnt <= presc_cyc_cnt + 32'd1;
                   end
                 end

                 generate
                 if (NO_PRESCALE == 0 && DECADE_CNTR == 0) begin : g_prescale_binary
                   // Scenario: Binary decode divisor selects power-of-two division
                   property p_prescale_binary_period;
                     @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                     (prescale_out && counter_sync) |->
                       (presc_cyc_cnt == (32'd1 << pit_pre_scl));
                   endproperty
                   assert property (p_prescale_binary_period)
                     else $error("prescale_out period mismatch for binary decode");
                 end
                 endgenerate

                 generate
                 if (NO_PRESCALE == 0 && DECADE_CNTR == 1) begin : g_prescale_decade
                   // Scenario: Decade decode divisor selects decade-style division
                   property p_prescale_decade_period;
                     @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                     (prescale_out && counter_sync && (pit_pre_scl <= 4'd3)) |->
                       (presc_cyc_cnt == (32'd1 << pit_pre_scl));
                   endproperty
                   assert property (p_prescale_decade_period)
                     else $error("prescale_out period mismatch for decade decode");
                 end
                 endgenerate

                 // Scenario: CNTRL readback bits mirror prescaler mode parameters
                 property p_prescale_readback;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (sel && !wb_we_i && (wb_adr_i == 3'h0) && wb_ack_o) |->
                     (wb_dat_o[14] == DECADE_CNTR && wb_dat_o[13] == NO_PRESCALE);
                 endproperty
                 assert property (p_prescale_readback)
                   else $error("CNTRL readback prescaler mode bits mismatch");

                 // =============================================================================
                 // Main counter and rollover behavior
                 // =============================================================================

                 // Scenario: Main counter increments on qualified prescale event
                 property p_counter_increment;
                   logic [COUNT_SIZE-1:0] n_cap;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (counter_sync && prescale_out && ((cnt_n + 1'b1) != mod_value),
                      n_cap = cnt_n) |=> (cnt_n == n_cap + 1'b1);
                 endproperty
                 assert property (p_counter_increment)
                   else $error("Main counter did not increment on qualified prescale event");

                 // Scenario: Main counter holds when prescale_out is not asserted
                 property p_counter_hold_no_prescale;
                   logic [COUNT_SIZE-1:0] n_cap;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (counter_sync && !prescale_out, n_cap = cnt_n) |=> (cnt_n == n_cap);
                 endproperty
                 assert property (p_counter_hold_no_prescale)
                   else $error("Main counter changed without qualified prescale event");

                 // Scenario: Main counter holds when counting is disabled
                 property p_counter_hold_disabled;
                   logic [COUNT_SIZE-1:0] n_cap;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (!counter_sync, n_cap = cnt_n) |=> (cnt_n == n_cap);
                 endproperty
                 assert property (p_counter_hold_disabled)
                   else $error("Main counter changed while counting disabled");

                 // Scenario: Main counter rolls over when reaching MOD_VAL
                 property p_counter_rollover;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (counter_sync && prescale_out && (cnt_n == (mod_value - 1'b1)) && (mod_value > 1)) |=>
                     (cnt_n == CNT_RESET_VAL && pit_o == 1'b1 && cnt_flag_o == 1'b1);
                 endproperty
                 assert property (p_counter_rollover)
                   else $error("Main counter rollover behavior incorrect");

                 // Scenario: MOD_VAL of 0 or 1 produces minimum-period rollover behavior
                 property p_counter_min_period;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (counter_sync && prescale_out && (mod_value == 0 || mod_value == 1)) |=>
                     (pit_o == 1'b1);
                 endproperty
                 assert property (p_counter_min_period)
                   else $error("pit_o not asserted every qualified cycle for MOD_VAL 0/1");

                 // Scenario: pit_o pulse is exactly one clock cycle wide
                 property p_pit_o_pulse_width;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (pit_o && !(counter_sync && prescale_out &&
                               (cnt_n == (mod_value - 1'b1)) && (mod_value > 1))) |=> (!pit_o);
                 endproperty
                 assert property (p_pit_o_pulse_width)
                   else $error("pit_o pulse width exceeded one clock cycle");

                 // Scenario: pit_o cannot assert while counting is disabled
                 property p_pit_o_gated_by_enable;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   (!counter_sync) |-> (!pit_o);
                 endproperty
                 assert property (p_pit_o_gated_by_enable)
                   else $error("pit_o asserted while counting disabled");

                 // Scenario: pit_o cannot assert during synchronous reset
                 property p_pit_o_gated_by_reset;
                   @(posedge wb_clk_i) disable iff (arst_active)
                   (wb_rst_i) |-> (!pit_o);
                 endproperty
                 assert property (p_pit_o_gated_by_reset)
                   else $error("pit_o asserted during synchronous reset");

                 // =============================================================================
                 // Constraint / interface consistency checks
                 // =============================================================================

                 // Scenario: wb_sel_i has no effect on register access decode
                 property p_sel_irrelevant;
                   @(posedge wb_clk_i) disable iff (arst_active || wb_rst_i)
                   ($stable(wb_cyc_i) && $stable(wb_stb_i) && $stable(wb_we_i) &&
                    $stable(wb_adr_i) && $stable(wb_dat_i) && !$stable(wb_sel_i)) |->
                     ($stable(wb_ack_o) && $stable(wb_dat_o));
                 endproperty
                 assert property (p_sel_irrelevant)
                   else $error("wb_sel_i incorrectly affects wb_ack_o/wb_dat_o");

                 // =============================================================================
                 // Input assumptions (Given / Background constraints)
                 // =============================================================================

                 // Module selection is combinationally defined; no free assumption needed
                 // beyond wb_cyc_i/wb_stb_i themselves being free inputs.

                 // ARST_LVL, DWIDTH, SINGLE_CYCLE, NO_PRESCALE, DECADE_CNTR, COUNT_SIZE,
                 // PRE_COUNT_SIZE are elaboration-time parameters; no runtime assumption
                 // is required since their values are fixed per elaboration (guarded above
                 // via generate blocks).

                 // Assumption: wb_we_i, wb_stb_i, wb_cyc_i, wb_sel_i, ext_sync_i, wb_dat_i,
                 // wb_adr_i are free-running primary inputs (no additional assumptions
                 // required beyond scenario-specific antecedents already encoded above).


endmodule // pit_top
