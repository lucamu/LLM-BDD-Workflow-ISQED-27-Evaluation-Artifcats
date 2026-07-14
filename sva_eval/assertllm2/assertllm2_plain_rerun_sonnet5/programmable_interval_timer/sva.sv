// method: plain_prompt

// Global checker bound to top module: pit_top
module pit_top_sva_global (
    input logic pit_count_async_rst_b,
    input logic pit_count_bus_clk,
    input logic pit_count_cnt_flag_o,
    input logic [1:0] pit_count_cnt_n,
    input logic pit_count_counter_sync,
    input logic [1:0] pit_count_mod_value,
    input logic pit_count_pit_flg_clr,
    input logic pit_count_pit_o,
    input logic pit_count_prescale_out,
    input logic pit_count_sync_reset,
    input logic pit_prescale_async_rst_b,
    input logic pit_prescale_bus_clk,
    input logic pit_prescale_cnt_sync_o,
    input logic pit_prescale_counter_sync,
    input logic [3:0] pit_prescale_divisor,
    input logic pit_prescale_ext_sync_i,
    input logic pit_prescale_pit_slave,
    input logic pit_prescale_prescale_out,
    input logic pit_prescale_sync_reset,
    input logic pit_regs_async_rst_b,
    input logic pit_regs_bus_clk,
    input logic pit_regs_cnt_flag_o,
    input logic pit_regs_cnt_sync_o,
    input logic [1:0] pit_regs_mod_value,
    input logic pit_regs_pit_flag,
    input logic pit_regs_pit_flg_clr,
    input logic pit_regs_pit_ien,
    input logic pit_regs_pit_irq_o,
    input logic [3:0] pit_regs_pit_pre_scl,
    input logic pit_regs_pit_slave,
    input logic pit_regs_sync_reset,
    input logic [1:0] pit_regs_write_bus,
    input logic [3:0] pit_regs_write_regs,
    input logic pit_wb_bus_arst_i,
    input logic pit_wb_bus_async_rst_b,
    input logic pit_wb_bus_irq_source,
    input logic [47:0] pit_wb_bus_read_regs,
    input logic pit_wb_bus_sync_reset,
    input logic pit_wb_bus_wb_ack_o,
    input logic [2:0] pit_wb_bus_wb_adr_i,
    input logic pit_wb_bus_wb_clk_i,
    input logic pit_wb_bus_wb_cyc_i,
    input logic [1:0] pit_wb_bus_wb_dat_i,
    input logic [1:0] pit_wb_bus_wb_dat_o,
    input logic pit_wb_bus_wb_rst_i,
    input logic [1:0] pit_wb_bus_wb_sel_i,
    input logic pit_wb_bus_wb_stb_i,
    input logic pit_wb_bus_wb_we_i,
    input logic [3:0] pit_wb_bus_write_regs,
    input logic top_arst_i,
    input logic top_cnt_flag_o,
    input logic top_cnt_sync_o,
    input logic top_ext_sync_i,
    input logic top_pit_irq_o,
    input logic top_pit_o,
    input logic top_wb_ack_o,
    input logic [2:0] top_wb_adr_i,
    input logic top_wb_clk_i,
    input logic top_wb_cyc_i,
    input logic [1:0] top_wb_dat_i,
    input logic [1:0] top_wb_dat_o,
    input logic top_wb_rst_i,
    input logic [1:0] top_wb_sel_i,
    input logic top_wb_stb_i,
    input logic top_wb_we_i
);

//======================================================================
// Assertions for Signal: pit_regs_pit_irq_o
// Primary label from model: pit_regs_pit_irq_o
//======================================================================
// pit_irq_o tracks cnt_flag_o gated by interrupt enable (ENA_INT)
always_comb begin
  assert (pit_regs_pit_irq_o == (pit_regs_cnt_flag_o && pit_regs_pit_ien));
end

// Interrupt output can never be asserted without an active rollover flag
always_comb begin
  assert (!pit_regs_pit_irq_o || pit_regs_cnt_flag_o);
end

// Interrupt output can never be asserted when interrupt enable is cleared
always_comb begin
  assert (!pit_regs_pit_irq_o || pit_regs_pit_ien);
end


//======================================================================
// Assertions for Signal: pit_prescale_counter_sync
// Primary label from model: pit_prescale_counter_sync
//======================================================================
// Effective counter enable is selected between local (master) and external (slave) sync sources
always_comb begin
  assert (pit_prescale_counter_sync == (pit_prescale_pit_slave ? pit_prescale_ext_sync_i : pit_prescale_cnt_sync_o));
end


//======================================================================
// Assertions for Signal: top_cnt_sync_o
// Primary label from model: top_cnt_sync_o
//======================================================================
// Top-level master synchronization output is a direct passthrough of the control-register enable bit
always_comb begin
  assert (top_cnt_sync_o == pit_regs_cnt_sync_o);
end


//======================================================================
// Assertions for Signal: top_pit_irq_o
// Primary label from model: top_pit_irq_o
//======================================================================
// Top-level interrupt output is a direct passthrough of the qualified interrupt output from pit_regs
always_comb begin
  assert (top_pit_irq_o == pit_regs_pit_irq_o);
end


//======================================================================
// Assertions for Signal: top_cnt_flag_o
// Primary label from model: top_cnt_flag_o
//======================================================================
// Top-level sticky rollover status is a direct passthrough of the counter block's flag output
always_comb begin
  assert (top_cnt_flag_o == pit_count_cnt_flag_o);
end


//======================================================================
// Assertions for Signal: top_pit_o
// Primary label from model: top_pit_o
//======================================================================
// Top-level periodic pulse output is a direct passthrough of the counter block's pulse output
always_comb begin
  assert (top_pit_o == pit_count_pit_o);
end


//======================================================================
// Assertions for Signal: top_wb_dat_o
// Primary label from model: top_wb_dat_o
//======================================================================
// Top-level WISHBONE read data is a direct passthrough of the bus adapter's read data
always_comb begin
  assert (top_wb_dat_o == pit_wb_bus_wb_dat_o);
end


//======================================================================
// Assertions for Signal: top_wb_ack_o
// Primary label from model: top_wb_ack_o
//======================================================================
// Top-level WISHBONE acknowledge is a direct passthrough of the bus adapter's acknowledge
always_comb begin
  assert (top_wb_ack_o == pit_wb_bus_wb_ack_o);
end

// Acknowledge must never be produced for an access that is not module-selected
always_comb begin
  assert (!top_wb_ack_o || (top_wb_cyc_i && top_wb_stb_i));
end


//======================================================================
// Assertions for Signal: pit_wb_bus_wb_ack_o
// Primary label from model: pit_wb_bus_wb_ack_o
//======================================================================
// Acknowledge shall only be asserted when the module is selected (cyc and stb both asserted)
always_comb begin
  assert (!pit_wb_bus_wb_ack_o || (pit_wb_bus_wb_cyc_i && pit_wb_bus_wb_stb_i));
end

// Acknowledge shall be deasserted when the module is not selected
always_comb begin
  assert (!(pit_wb_bus_wb_cyc_i && pit_wb_bus_wb_stb_i) -> !pit_wb_bus_wb_ack_o);
end


//======================================================================
// Assertions for Signal: pit_wb_bus_write_regs
// Primary label from model: pit_wb_bus_write_regs
//======================================================================
// Register write strobes shall only be produced during a selected, write-qualified access
always_comb begin
  assert (!(pit_wb_bus_wb_cyc_i && pit_wb_bus_wb_stb_i && pit_wb_bus_wb_we_i) -> (pit_wb_bus_write_regs == 4'b0000));
end


//======================================================================
// Assertions for Signal: pit_regs_write_regs
// Primary label from model: pit_regs_write_regs
//======================================================================
// Register write strobes propagate unchanged from the bus adapter to the register bank
always_comb begin
  assert (pit_regs_write_regs == pit_wb_bus_write_regs);
end


//======================================================================
// Assertions for Signal: pit_count_counter_sync
// Primary label from model: pit_count_counter_sync
//======================================================================
// Main counter's effective enable input propagates unchanged from the prescaler block's selected source
always_comb begin
  assert (pit_count_counter_sync == pit_prescale_counter_sync);
end


//======================================================================
// Assertions for Signal: pit_count_prescale_out
// Primary label from model: pit_count_prescale_out
//======================================================================
// Main counter's increment qualification propagates unchanged from the prescaler rollover pulse
always_comb begin
  assert (pit_count_prescale_out == pit_prescale_prescale_out);
end


//======================================================================
// Assertions for Signal: pit_count_mod_value
// Primary label from model: pit_count_mod_value
//======================================================================
// Main counter's modulo compare value propagates unchanged from the register bank
always_comb begin
  assert (pit_count_mod_value == pit_regs_mod_value);
end


//======================================================================
// Assertions for Signal: pit_count_pit_flg_clr
// Primary label from model: pit_count_pit_flg_clr
//======================================================================
// Flag clear request propagates unchanged from the register bank to the counter block
always_comb begin
  assert (pit_count_pit_flg_clr == pit_regs_pit_flg_clr);
end


//======================================================================
// Assertions for Signal: pit_regs_cnt_flag_o
// Primary label from model: pit_regs_cnt_flag_o
//======================================================================
// Rollover flag input to the register bank matches the counter block's sticky flag output
always_comb begin
  assert (pit_regs_cnt_flag_o == pit_count_cnt_flag_o);
end


//======================================================================
// Assertions for Signal: pit_prescale_divisor
// Primary label from model: pit_prescale_divisor
//======================================================================
// Prescaler select code propagates unchanged from the register bank
always_comb begin
  assert (pit_prescale_divisor == pit_regs_pit_pre_scl);
end


//======================================================================
// Assertions for Signal: pit_prescale_pit_slave
// Primary label from model: pit_prescale_pit_slave
//======================================================================
// Master/slave mode control propagates unchanged from the register bank to the prescaler block
always_comb begin
  assert (pit_prescale_pit_slave == pit_regs_pit_slave);
end


//======================================================================
// Assertions for Signal: pit_prescale_cnt_sync_o
// Primary label from model: pit_prescale_cnt_sync_o
//======================================================================
// Local/master enable source into the prescaler matches the register bank's synchronization output
always_comb begin
  assert (pit_prescale_cnt_sync_o == pit_regs_cnt_sync_o);
end


//======================================================================
// Assertions for Signal: pit_prescale_ext_sync_i
// Primary label from model: pit_prescale_ext_sync_i
//======================================================================
// External synchronization input to the prescaler propagates unchanged from the top-level port
always_comb begin
  assert (pit_prescale_ext_sync_i == top_ext_sync_i);
end


//======================================================================
// Assertions for Signal: pit_regs_write_bus
// Primary label from model: pit_regs_write_bus
//======================================================================
// Register write payload propagates unchanged from the WISHBONE write data
always_comb begin
  assert (pit_regs_write_bus == pit_wb_bus_wb_dat_i);
end


//======================================================================
// Assertions for Signal: pit_regs_pit_flag
// Primary label from model: pit_regs_pit_flag
//======================================================================
// FLAG bit readback reflects the current rollover flag status
always_comb begin
  assert (pit_regs_pit_flag == pit_regs_cnt_flag_o);
end
endmodule

