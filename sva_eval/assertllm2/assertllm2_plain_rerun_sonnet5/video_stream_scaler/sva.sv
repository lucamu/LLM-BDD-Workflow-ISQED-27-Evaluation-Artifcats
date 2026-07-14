// method: plain_prompt

// Global checker bound to top module: streamScaler
module streamScaler_sva_global (
    input logic ramFifo_advanceRead1,
    input logic ramFifo_advanceRead2,
    input logic ramFifo_advanceWrite,
    input logic ramFifo_clk,
    input logic ramFifo_forceRead,
    input logic ramFifo_readAddress,
    input logic ramFifo_readData00,
    input logic ramFifo_readData01,
    input logic ramFifo_readData10,
    input logic ramFifo_readData11,
    input logic ramFifo_rst,
    input logic ramFifo_writeAddress,
    input logic ramFifo_writeData,
    input logic ramFifo_writeEnable,
    input logic top_advanceRead1,
    input logic top_advanceRead2,
    input logic top_advanceWrite,
    input logic top_clk,
    input logic top_dInValid,
    input logic top_dOutValid,
    input logic top_forceRead,
    input logic top_inputDiscardCnt,
    input logic top_inputXRes,
    input logic top_inputYRes,
    input logic top_nearestNeighbor,
    input logic top_nextDin,
    input logic top_nextDout,
    input logic top_outputXRes,
    input logic top_outputYRes,
    input logic top_readAddress,
    input logic top_readData00,
    input logic top_readData01,
    input logic top_readData10,
    input logic top_readData11,
    input logic top_rst,
    input logic top_start,
    input logic top_topFracOffset,
    input logic top_writeColCount,
    input logic top_xScale,
    input logic top_yScale
);

//======================================================================
// Assertions for Signal: top_nextDin
// Primary label from model: top_nextDin
//======================================================================
// nextDin must be a known value (no X propagation on input-ready signal)
always_comb begin
  assert (!$isunknown(top_nextDin));
end

// nextDin must be deasserted while the module is held in reset
always_comb begin
  assert (top_rst == 1'b0 || top_nextDin == 1'b0);
end


//======================================================================
// Assertions for Signal: top_dOutValid
// Primary label from model: top_dOutValid
//======================================================================
// dOutValid must be a known value at all times
always_comb begin
  assert (!$isunknown(top_dOutValid));
end

// dOutValid must be low while the module is held in reset
always_comb begin
  assert (top_rst == 1'b0 || top_dOutValid == 1'b0);
end


//======================================================================
// Assertions for Signal: top_advanceRead1
// Primary label from model: top_advanceRead1
//======================================================================
// Read control may request one-line or two-line advancement, but not both simultaneously
always_comb begin
  assert (!(top_advanceRead1 && top_advanceRead2));
end

// advanceRead1 must be a known value
always_comb begin
  assert (!$isunknown(top_advanceRead1));
end


//======================================================================
// Assertions for Signal: top_advanceRead2
// Primary label from model: top_advanceRead2
//======================================================================
// advanceRead2 must be a known value
always_comb begin
  assert (!$isunknown(top_advanceRead2));
end

// advanceRead2 must not be asserted while reset is active
always_comb begin
  assert (top_rst == 1'b0 || top_advanceRead2 == 1'b0);
end


//======================================================================
// Assertions for Signal: ramFifo_advanceRead1
// Primary label from model: ramFifo_advanceRead1
//======================================================================
// ramFifo must not receive concurrent one-line and two-line read advance requests
always_comb begin
  assert (!(ramFifo_advanceRead1 && ramFifo_advanceRead2));
end

// advanceRead1 to ramFifo must be a known value
always_comb begin
  assert (!$isunknown(ramFifo_advanceRead1));
end


//======================================================================
// Assertions for Signal: ramFifo_advanceRead2
// Primary label from model: ramFifo_advanceRead2
//======================================================================
// advanceRead2 to ramFifo must be a known value
always_comb begin
  assert (!$isunknown(ramFifo_advanceRead2));
end


//======================================================================
// Assertions for Signal: top_advanceWrite
// Primary label from model: top_advanceWrite
//======================================================================
// advanceWrite must be a known value
always_comb begin
  assert (!$isunknown(top_advanceWrite));
end

// Write-line advancement must not occur while the module is held in reset
always_comb begin
  assert (top_rst == 1'b0 || top_advanceWrite == 1'b0);
end


//======================================================================
// Assertions for Signal: top_forceRead
// Primary label from model: top_forceRead
//======================================================================
// forceRead must be a known value (enables readout-completion behavior)
always_comb begin
  assert (!$isunknown(top_forceRead));
end


//======================================================================
// Assertions for Signal: top_writeColCount
// Primary label from model: top_writeColCount
//======================================================================
// Write-side pixel column tracking must remain within the configured input active width
always_comb begin
  assert (top_writeColCount <= top_inputXRes);
end

// writeColCount must be a known value
always_comb begin
  assert (!$isunknown(top_writeColCount));
end


//======================================================================
// Assertions for Signal: top_readAddress
// Primary label from model: top_readAddress
//======================================================================
// Base read address for the interpolation neighborhood must be within the configured input width
always_comb begin
  assert (top_readAddress <= top_inputXRes);
end

// readAddress must be a known value
always_comb begin
  assert (!$isunknown(top_readAddress));
end


//======================================================================
// Assertions for Signal: ramFifo_readAddress
// Primary label from model: ramFifo_readAddress
//======================================================================
// ramFifo read address must correspond to a valid input-width X coordinate
always_comb begin
  assert (ramFifo_readAddress <= top_inputXRes);
end

// ramFifo read address must be a known value
always_comb begin
  assert (!$isunknown(ramFifo_readAddress));
end


//======================================================================
// Assertions for Signal: ramFifo_writeEnable
// Primary label from model: ramFifo_writeEnable
//======================================================================
// Write strobe to ramFifo must be a known value
always_comb begin
  assert (!$isunknown(ramFifo_writeEnable));
end

// Writes into ramFifo must not occur while the module is held in reset
always_comb begin
  assert (top_rst == 1'b0 || ramFifo_writeEnable == 1'b0);
end


//======================================================================
// Assertions for Signal: ramFifo_writeAddress
// Primary label from model: ramFifo_writeAddress
//======================================================================
// Write address within the selected line must stay within the configured input width
always_comb begin
  assert (ramFifo_writeAddress <= top_inputXRes);
end

// writeAddress must be a known value
always_comb begin
  assert (!$isunknown(ramFifo_writeAddress));
end


//======================================================================
// Assertions for Signal: ramFifo_writeData
// Primary label from model: ramFifo_writeData
//======================================================================
// Data written into ramFifo must be a known value whenever the write strobe is asserted
always_comb begin
  assert (!ramFifo_writeEnable || !$isunknown(ramFifo_writeData));
end


//======================================================================
// Assertions for Signal: top_nearestNeighbor
// Primary label from model: top_nearestNeighbor
//======================================================================
// Resize-mode select must resolve to one of the two legal, well-defined modes
always_comb begin
  assert (top_nearestNeighbor === 1'b0 || top_nearestNeighbor === 1'b1);
end


//======================================================================
// Assertions for Signal: top_start
// Primary label from model: top_start
//======================================================================
// Frame-start pulse must be a known value
always_comb begin
  assert (!$isunknown(top_start));
end


//======================================================================
// Assertions for Signal: top_dInValid
// Primary label from model: top_dInValid
//======================================================================
// Input data-valid qualifier must be a known value
always_comb begin
  assert (!$isunknown(top_dInValid));
end


//======================================================================
// Assertions for Signal: top_nextDout
// Primary label from model: top_nextDout
//======================================================================
// Downstream consume-request signal must be a known value
always_comb begin
  assert (!$isunknown(top_nextDout));
end


//======================================================================
// Assertions for Signal: ramFifo_forceRead
// Primary label from model: ramFifo_forceRead
//======================================================================
// forceRead into ramFifo must be a known value
always_comb begin
  assert (!$isunknown(ramFifo_forceRead));
end


//======================================================================
// Assertions for Signal: top_readData00
// Primary label from model: top_readData00
//======================================================================
// Interpolation neighborhood sample outputs must be known values (no X propagation on datapath output)
always_comb begin
  assert (!$isunknown(top_readData00));
end
endmodule

