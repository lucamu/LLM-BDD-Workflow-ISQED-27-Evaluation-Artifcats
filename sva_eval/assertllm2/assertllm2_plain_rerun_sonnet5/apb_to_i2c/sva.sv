// method: plain_prompt

// Global checker bound to top module: i2c
module i2c_sva_global (
    input logic apb_ERROR,
    input logic [13:0] apb_INTERNAL_I2C_REGISTER_CONFIG,
    input logic [13:0] apb_INTERNAL_I2C_REGISTER_TIMEOUT,
    input logic apb_INT_RX,
    input logic apb_INT_TX,
    input logic [31:0] apb_PADDR,
    input logic apb_PCLK,
    input logic apb_PENABLE,
    input logic [31:0] apb_PRDATA,
    input logic apb_PREADY,
    input logic apb_PRESETn,
    input logic apb_PSELx,
    input logic apb_PSLVERR,
    input logic [31:0] apb_PWDATA,
    input logic apb_PWRITE,
    input logic apb_RD_ENA,
    input logic [31:0] apb_READ_DATA_ON_RX,
    input logic apb_RX_EMPTY,
    input logic apb_TX_EMPTY,
    input logic [31:0] apb_WRITE_DATA_ON_TX,
    input logic apb_WR_ENA,
    input logic fifo_clock,
    input logic [1:0] fifo_data_in,
    input logic [1:0] fifo_data_out,
    input logic fifo_f_full,
    input logic [1:0] module_i2c_DATA_CONFIG_REG,
    input logic module_i2c_ENABLE_SCL,
    input logic module_i2c_ENABLE_SDA,
    input logic module_i2c_ERROR,
    input logic module_i2c_PCLK,
    input logic module_i2c_PRESETn,
    input logic module_i2c_RX_EMPTY,
    input logic module_i2c_SCL,
    input logic module_i2c_SDA,
    input logic [1:0] module_i2c_TIMEOUT_TX,
    input logic module_i2c_TX_EMPTY,
    input logic [1:0] module_i2c_fifo_rx_data_in,
    input logic module_i2c_fifo_rx_f_empty,
    input logic module_i2c_fifo_rx_f_full,
    input logic [1:0] module_i2c_fifo_tx_data_out,
    input logic module_i2c_fifo_tx_f_empty,
    input logic module_i2c_fifo_tx_f_full,
    input logic top_INT_RX,
    input logic top_INT_TX,
    input logic [31:0] top_PADDR,
    input logic top_PCLK,
    input logic top_PENABLE,
    input logic [31:0] top_PRDATA,
    input logic top_PREADY,
    input logic top_PRESETn,
    input logic top_PSELx,
    input logic top_PSLVERR,
    input logic [31:0] top_PWDATA,
    input logic top_PWRITE,
    input logic top_SCL,
    input logic top_SCL_ENABLE,
    input logic top_SDA,
    input logic top_SDA_ENABLE,
    input logic top_TX_F_FULL,
    input logic top_w_full
);

//======================================================================
// Assertions for Signal: apb_PREADY
// Primary label from model: apb_PREADY
//======================================================================
always_comb begin
  // PREADY asserted for implemented addresses during active APB access
  assert ((apb_PSELx && apb_PENABLE && (apb_PADDR==32'h0 || apb_PADDR==32'h4 || apb_PADDR==32'h8 || apb_PADDR==32'hC)) -> apb_PREADY);
  // PREADY not asserted for unimplemented addresses even when selected/enabled
  assert ((apb_PSELx && apb_PENABLE && !(apb_PADDR==32'h0 || apb_PADDR==32'h4 || apb_PADDR==32'h8 || apb_PADDR==32'hC)) -> !apb_PREADY);
  // PREADY not asserted when select or enable is inactive
  assert ((!apb_PSELx || !apb_PENABLE) -> !apb_PREADY);
end


//======================================================================
// Assertions for Signal: apb_WR_ENA
// Primary label from model: apb_WR_ENA
//======================================================================
always_comb begin
  // WR_ENA asserted only on accepted write to address 0x0
  assert ((apb_PSELx && apb_PENABLE && apb_PWRITE && (apb_PADDR==32'h0)) -> apb_WR_ENA);
  // WR_ENA not asserted for read transfers
  assert ((!apb_PWRITE) -> !apb_WR_ENA);
  // WR_ENA not asserted for accesses other than address 0x0
  assert ((apb_PADDR != 32'h0) -> !apb_WR_ENA);
  // WR_ENA not asserted when peripheral is not selected
  assert ((!apb_PSELx) -> !apb_WR_ENA);
  // WR_ENA and RD_ENA are mutually exclusive
  assert (!(apb_WR_ENA && apb_RD_ENA));
end


//======================================================================
// Assertions for Signal: apb_RD_ENA
// Primary label from model: apb_RD_ENA
//======================================================================
always_comb begin
  // RD_ENA asserted only on accepted read to address 0x4
  assert ((apb_PSELx && apb_PENABLE && !apb_PWRITE && (apb_PADDR==32'h4)) -> apb_RD_ENA);
  // RD_ENA not asserted for write transfers
  assert ((apb_PWRITE) -> !apb_RD_ENA);
  // RD_ENA not asserted for accesses other than address 0x4
  assert ((apb_PADDR != 32'h4) -> !apb_RD_ENA);
  // RD_ENA not asserted when peripheral is not selected
  assert ((!apb_PSELx) -> !apb_RD_ENA);
end


//======================================================================
// Assertions for Signal: apb_PSLVERR
// Primary label from model: apb_PSLVERR
//======================================================================
always_comb begin
  // PSLVERR is a direct mapping of internal ERROR status
  assert (apb_PSLVERR == apb_ERROR);
  // PSLVERR is asserted whenever the I2C core is in error mode
  assert ((module_i2c_DATA_CONFIG_REG == 2'b11) -> apb_PSLVERR);
end


//======================================================================
// Assertions for Signal: apb_INT_RX
// Primary label from model: apb_INT_RX
//======================================================================
always_comb begin
  // INT_RX mirrors RX_EMPTY status (level status, not edge-qualified)
  assert (apb_INT_RX == apb_RX_EMPTY);
end


//======================================================================
// Assertions for Signal: apb_INT_TX
// Primary label from model: apb_INT_TX
//======================================================================
always_comb begin
  // INT_TX mirrors TX_EMPTY status (level status, not edge-qualified)
  assert (apb_INT_TX == apb_TX_EMPTY);
end


//======================================================================
// Assertions for Signal: apb_PRDATA
// Primary label from model: apb_PRDATA
//======================================================================
always_comb begin
  // PRDATA is directly sourced from the RX data path
  assert (apb_PRDATA == apb_READ_DATA_ON_RX);
end


//======================================================================
// Assertions for Signal: apb_WRITE_DATA_ON_TX
// Primary label from model: apb_WRITE_DATA_ON_TX
//======================================================================
always_comb begin
  // TX FIFO write data equals PWDATA on an accepted write to address 0x0
  assert ((apb_PSELx && apb_PENABLE && apb_PWRITE && (apb_PADDR==32'h0)) -> (apb_WRITE_DATA_ON_TX == apb_PWDATA));
end


//======================================================================
// Assertions for Signal: module_i2c_ERROR
// Primary label from model: module_i2c_ERROR
//======================================================================
always_comb begin
  // ERROR asserted only in mode 2'b11
  assert ((module_i2c_DATA_CONFIG_REG == 2'b11) -> module_i2c_ERROR);
  // ERROR not asserted for any mode other than 2'b11
  assert ((module_i2c_DATA_CONFIG_REG != 2'b11) -> !module_i2c_ERROR);
end


//======================================================================
// Assertions for Signal: apb_ERROR
// Primary label from model: apb_ERROR
//======================================================================
always_comb begin
  // ERROR status is shared across the APB and I2C core boundary
  assert (apb_ERROR == module_i2c_ERROR);
end


//======================================================================
// Assertions for Signal: module_i2c_TX_EMPTY
// Primary label from model: module_i2c_TX_EMPTY
//======================================================================
always_comb begin
  // TX_EMPTY status mirrors the TX FIFO empty status
  assert (module_i2c_TX_EMPTY == module_i2c_fifo_tx_f_empty);
end


//======================================================================
// Assertions for Signal: module_i2c_RX_EMPTY
// Primary label from model: module_i2c_RX_EMPTY
//======================================================================
always_comb begin
  // RX_EMPTY status mirrors the RX FIFO empty status
  assert (module_i2c_RX_EMPTY == module_i2c_fifo_rx_f_empty);
end


//======================================================================
// Assertions for Signal: apb_TX_EMPTY
// Primary label from model: apb_TX_EMPTY
//======================================================================
always_comb begin
  // TX_EMPTY status is shared across the APB and I2C core boundary
  assert (apb_TX_EMPTY == module_i2c_TX_EMPTY);
end


//======================================================================
// Assertions for Signal: apb_RX_EMPTY
// Primary label from model: apb_RX_EMPTY
//======================================================================
always_comb begin
  // RX_EMPTY status is shared across the APB and I2C core boundary
  assert (apb_RX_EMPTY == module_i2c_RX_EMPTY);
end


//======================================================================
// Assertions for Signal: top_SDA_ENABLE
// Primary label from model: top_SDA_ENABLE
//======================================================================
always_comb begin
  // top-level SDA_ENABLE mirrors the internal core drive-control indication
  assert (top_SDA_ENABLE == module_i2c_ENABLE_SDA);
end


//======================================================================
// Assertions for Signal: top_SCL_ENABLE
// Primary label from model: top_SCL_ENABLE
//======================================================================
always_comb begin
  // top-level SCL_ENABLE mirrors the internal core drive-control indication
  assert (top_SCL_ENABLE == module_i2c_ENABLE_SCL);
end


//======================================================================
// Assertions for Signal: top_PRDATA
// Primary label from model: top_PRDATA
//======================================================================
always_comb begin
  // top-level PRDATA passes through from the APB block read data
  assert (top_PRDATA == apb_PRDATA);
end


//======================================================================
// Assertions for Signal: top_PSLVERR
// Primary label from model: top_PSLVERR
//======================================================================
always_comb begin
  // top-level PSLVERR passes through from the APB block error status
  assert (top_PSLVERR == apb_PSLVERR);
end


//======================================================================
// Assertions for Signal: top_INT_RX
// Primary label from model: top_INT_RX
//======================================================================
always_comb begin
  // top-level INT_RX passes through from the APB block
  assert (top_INT_RX == apb_INT_RX);
end


//======================================================================
// Assertions for Signal: top_INT_TX
// Primary label from model: top_INT_TX
//======================================================================
always_comb begin
  // top-level INT_TX passes through from the APB block
  assert (top_INT_TX == apb_INT_TX);
end


//======================================================================
// Assertions for Signal: top_PREADY
// Primary label from model: top_PREADY
//======================================================================
always_comb begin
  // top-level PREADY passes through from the APB block
  assert (top_PREADY == apb_PREADY);
end
endmodule

