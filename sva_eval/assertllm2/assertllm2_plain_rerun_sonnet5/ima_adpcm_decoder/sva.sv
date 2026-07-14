// method: plain_prompt

// Global checker bound to top module: ima_adpcm_dec
module ima_adpcm_dec_sva_global (
    input logic top_clock,
    input logic [3:0] top_inPCM,
    input logic [15:0] top_inPredictSamp,
    input logic top_inReady,
    input logic top_inStateLoad,
    input logic [6:0] top_inStepIndex,
    input logic top_inValid,
    input logic [15:0] top_outSamp,
    input logic top_outValid,
    input logic top_reset
);

//======================================================================
// Assertions for Signal: top_inValid
// Primary label from model: top_inValid
//======================================================================
// inValid should only be asserted when inReady is asserted (protocol legality)
always_comb begin
  assert (!(top_inValid && !top_inReady));
end


//======================================================================
// Assertions for Signal: top_inStateLoad
// Primary label from model: top_inStateLoad
//======================================================================
// State preload (inStateLoad) should be applied only while the input interface is ready
always_comb begin
  assert (!(top_inStateLoad && !top_inReady));
end

// inStateLoad clears the pending output-valid condition, so outValid must not be
// simultaneously asserted with a state-load request
always_comb begin
  assert (!(top_inStateLoad && top_outValid));
end


//======================================================================
// Assertions for Signal: top_inStepIndex
// Primary label from model: top_inStepIndex
//======================================================================
// Step index preload value must lie within the valid table range 0..88 when loaded
always_comb begin
  if (top_inStateLoad)
    assert (top_inStepIndex <= 7'd88);
end
endmodule

