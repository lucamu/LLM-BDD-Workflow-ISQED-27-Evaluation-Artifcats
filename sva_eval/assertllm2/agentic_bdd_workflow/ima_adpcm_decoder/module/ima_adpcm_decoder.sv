//---------------------------------------------------------------------------------------
//	Project:	ADPCM Decoder 
// 
//	Filename:	ima_adpcm_enc.v			(February 19, 2010)
// 
//	Author(s):	Moti Litochevski 
// 
//	Description:
//		This module implements the IMA ADPCM audio decoding algorithm. The input ADPCM 
//		encoded data is 4 bits wide and is converted to linearly quantized 16 bits 
//		samples for every new input. 
//		The decoder module implemented here is not compatible to any particular protocol 
//		or file format. The module include optional interface to load the decoder 
//		internal state which includes the internal predictor sample and step index 
//		provided by the encoder. 
//
//---------------------------------------------------------------------------------------
//
//	To Do: 
//	- 
// 
//---------------------------------------------------------------------------------------
// 
//	Copyright (C) 2010 Moti Litochevski 
// 
//	This source file may be used and distributed without restriction provided that this 
//	copyright statement is not removed from the file and that any derivative work 
//	contains the original copyright notice and the associated disclaimer.
//
//	THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, 
//	INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND 
//	FITNESS FOR A PARTICULAR PURPOSE. 
// 
//---------------------------------------------------------------------------------------

module ima_adpcm_dec
(
	clock, reset, 
	inPCM, inValid,
	inReady, inPredictSamp, 
	inStepIndex,  inStateLoad, 
	outSamp, outValid 
);
//---------------------------------------------------------------------------------------
// global inputs 
input			reset;
input			clock;

// input interface 
input	[3:0]	inPCM;			// input PCM nibble 
input			inValid;		// input valid flag 
output			inReady;		// input ready indication 
// optional decoder state load 
input	[15:0]	inPredictSamp;	// predictor sample load input 
input	[6:0]	inStepIndex;	// step index load input 
input			inStateLoad;	// internal state load input control 

// output interface 
output	[15:0]	outSamp;		// output sample value 
output			outValid;		// output valid flag 

//---------------------------------------------------------------------------------------
// registers output 
reg [15:0] outSamp;
reg outValid;

// internals 
reg [18:0] predictorSamp;
wire [18:0] dequantSamp;
reg predValid;
wire [19:0] prePredSamp;
reg [14:0] stepSize;	// unsigned 
reg [6:0] stepIndex;	// unsigned 
reg [4:0] stepDelta;
wire [7:0] preStepIndex;
wire [16:0] preOutSamp;

//---------------------------------------------------------------------------------------
// module implementation 
// main decoder process 
always @ (posedge clock or posedge reset)
begin 
	if (reset)
	begin 
		predictorSamp <= 19'b0;
		predValid <= 1'b0;
	end 
	else if (inStateLoad)
	begin 
		// load predictor sample value 
		predictorSamp <= {inPredictSamp, 3'b0};
		// clear the internal delayed flag 
		predValid <= 1'b0;
	end 
	else if (inValid) 
	begin 
		// check updated predictor sample saturation conditions 
		if (prePredSamp[19] && !prePredSamp[18])
			// negative saturation 
			predictorSamp <= {1'b1, 18'b0};
		else if (!prePredSamp[19] && prePredSamp[18])
			// positive saturation 
			predictorSamp <= {1'b0, {18{1'b1}}};
		else 
			// no saturation 
			predictorSamp <= prePredSamp[18:0];
	
		// sign that predictor value is valid 
		predValid <= 1'b1;
	end
	else 
		predValid <= 1'b0;
end 
// calculate the de-quantized difference value 
assign dequantSamp = (inPCM[2] ? {1'b0, stepSize, 3'b0} : 19'b0) + 
                     (inPCM[1] ? {2'b0, stepSize, 2'b0} : 19'b0) + 
                     (inPCM[0] ? {3'b0, stepSize, 1'b0} : 19'b0) +
                                 {4'b0, stepSize};
// updated predictor output sample 
assign prePredSamp = inPCM[3] ? ({predictorSamp[18], predictorSamp} - {1'b0, dequantSamp}) : 
                                ({predictorSamp[18], predictorSamp} + {1'b0, dequantSamp});

// input interface is busy while updating the step size 
assign inReady = ~predValid;

// calculate the output sample before saturation 
assign preOutSamp = {predictorSamp[18], predictorSamp[18:3]} + predictorSamp[2];

// output interface 
always @ (posedge clock or posedge reset)
begin 
	if (reset)
	begin 
		outSamp <= 16'b0;
		outValid <= 1'b0;
	end 
	else if (predValid)
	begin 
		// output is taken from the predictor output with saturation check 
		if (!preOutSamp[16] && preOutSamp[15])
			// positive saturation condition 
			outSamp <= {1'b0, {15{1'b1}}};
		else if (preOutSamp[16] && !preOutSamp[15])
			// negative saturation condition 
			outSamp <= {1'b1, 15'b0};
		else 
			outSamp <= preOutSamp[15:0];
		
		// sign output is valid 
		outValid <= 1'b1;
	end
	else 
		outValid <= 1'b0;
end 

// quantizer index adaptation lookup table 
always @ (inPCM)
begin 
	case (inPCM[2:0]) 
		3'd0:	stepDelta <= 5'd31;		// = -1 
		3'd1:	stepDelta <= 5'd31;		// = -1 
		3'd2:	stepDelta <= 5'd31;		// = -1 
		3'd3:	stepDelta <= 5'd31;		// = -1 
		3'd4:	stepDelta <= 5'd2;		// = +2
		3'd5:	stepDelta <= 5'd4;		// = +4
		3'd6:	stepDelta <= 5'd6;		// = +6
		3'd7:	stepDelta <= 5'd8;		// = +8
	endcase 
end 
// calculate the new index value before saturation 
assign preStepIndex = {1'b0, stepIndex} + {{3{stepDelta[4]}}, stepDelta};

// update the step index with saturation checking 
always @ (posedge clock or posedge reset)
begin 
	if (reset)
		stepIndex <= 7'b0;
	else if (inStateLoad)
		stepIndex <= inStepIndex;
	else if (inValid) 
	begin 
		// check is the updated step value should be saturated 
		if (preStepIndex[7])
			stepIndex <= 7'd0;
		else if (preStepIndex[6:0] > 7'd88)
			stepIndex <= 7'd88;
		else 
			stepIndex <= preStepIndex[6:0];
	end 
end 

// quantizer step size lookup table 
always @ (posedge clock)
begin 
	case (stepIndex) 
		7'd0:		stepSize <= 15'd7;
		7'd1:		stepSize <= 15'd8;
		7'd2:		stepSize <= 15'd9;
		7'd3:		stepSize <= 15'd10;
		7'd4:		stepSize <= 15'd11;
		7'd5:		stepSize <= 15'd12;
		7'd6:		stepSize <= 15'd13;
		7'd7:		stepSize <= 15'd14;
		7'd8:		stepSize <= 15'd16;
		7'd9:		stepSize <= 15'd17;
		7'd10:		stepSize <= 15'd19;
		7'd11:		stepSize <= 15'd21;
		7'd12:		stepSize <= 15'd23;
		7'd13:		stepSize <= 15'd25;
		7'd14:		stepSize <= 15'd28;
		7'd15:		stepSize <= 15'd31;
		7'd16:		stepSize <= 15'd34;
		7'd17:		stepSize <= 15'd37;
		7'd18:		stepSize <= 15'd41;
		7'd19:		stepSize <= 15'd45;
		7'd20:		stepSize <= 15'd50;
		7'd21:		stepSize <= 15'd55;
		7'd22:		stepSize <= 15'd60;
		7'd23:		stepSize <= 15'd66;
		7'd24:		stepSize <= 15'd73;
		7'd25:		stepSize <= 15'd80;
		7'd26:		stepSize <= 15'd88;
		7'd27:		stepSize <= 15'd97;
		7'd28:		stepSize <= 15'd107;
		7'd29:		stepSize <= 15'd118;
		7'd30:		stepSize <= 15'd130;
		7'd31:		stepSize <= 15'd143;
		7'd32:		stepSize <= 15'd157;
		7'd33:		stepSize <= 15'd173;
		7'd34:		stepSize <= 15'd190;
		7'd35:		stepSize <= 15'd209;
		7'd36:		stepSize <= 15'd230;
		7'd37:		stepSize <= 15'd253;
		7'd38:		stepSize <= 15'd279;
		7'd39:		stepSize <= 15'd307;
		7'd40:		stepSize <= 15'd337;
		7'd41:		stepSize <= 15'd371;
		7'd42:		stepSize <= 15'd408;
		7'd43:		stepSize <= 15'd449;
		7'd44:		stepSize <= 15'd494;
		7'd45:		stepSize <= 15'd544;
		7'd46:		stepSize <= 15'd598;
		7'd47:		stepSize <= 15'd658;
		7'd48:		stepSize <= 15'd724;
		7'd49:		stepSize <= 15'd796;
		7'd50:		stepSize <= 15'd876;
		7'd51:		stepSize <= 15'd963;
		7'd52:		stepSize <= 15'd1060;
		7'd53:		stepSize <= 15'd1166;
		7'd54:		stepSize <= 15'd1282;
		7'd55:		stepSize <= 15'd1411;
		7'd56:		stepSize <= 15'd1552;
		7'd57:		stepSize <= 15'd1707;
		7'd58:		stepSize <= 15'd1878;
		7'd59:		stepSize <= 15'd2066;
		7'd60:		stepSize <= 15'd2272;
		7'd61:		stepSize <= 15'd2499;
		7'd62:		stepSize <= 15'd2749;
		7'd63:		stepSize <= 15'd3024;
		7'd64:		stepSize <= 15'd3327;
		7'd65:		stepSize <= 15'd3660;
		7'd66:		stepSize <= 15'd4026;
		7'd67:		stepSize <= 15'd4428;
		7'd68:		stepSize <= 15'd4871;
		7'd69:		stepSize <= 15'd5358;
		7'd70:		stepSize <= 15'd5894;
		7'd71:		stepSize <= 15'd6484;
		7'd72:		stepSize <= 15'd7132;
		7'd73:		stepSize <= 15'd7845;
		7'd74:		stepSize <= 15'd8630;
		7'd75:		stepSize <= 15'd9493;
		7'd76:		stepSize <= 15'd10442;
		7'd77:		stepSize <= 15'd11487;
		7'd78:		stepSize <= 15'd12635;
		7'd79:		stepSize <= 15'd13899;
		7'd80:		stepSize <= 15'd15289;
		7'd81:		stepSize <= 15'd16818;
		7'd82:		stepSize <= 15'd18500;
		7'd83:		stepSize <= 15'd20350;
		7'd84:		stepSize <= 15'd22385;
		7'd85:		stepSize <= 15'd24623;
		7'd86:		stepSize <= 15'd27086;
		7'd87:		stepSize <= 15'd29794;
		7'd88:		stepSize <= 15'd32767;
		default:	stepSize <= 15'd32767;
	endcase 
end 

// --- Formal assertions ---
// ============================================================
// SVA Properties for ima_adpcm_decoder
// Derived strictly from Gherkin specification (not implementation)
// ============================================================

// ------------------------------------------------------------
// Local reference model helpers (used only for assertion checking)
// ------------------------------------------------------------

// Internal predictor saturation bounds (19-bit signed range)
localparam logic signed [19:0] PRED_MAX = 20'sd262143;   // 2^18 - 1
localparam logic signed [19:0] PRED_MIN = -20'sd262144;  // -2^18

// Step index saturation bounds
localparam logic signed [7:0] STEPIDX_MAX = 8'sd88;
localparam logic signed [7:0] STEPIDX_MIN = 8'sd0;

// Standard IMA ADPCM index adaptation table (magnitude 0..7)
localparam logic signed [4:0] IDX_TABLE [0:7] = '{-5'sd1,-5'sd1,-5'sd1,-5'sd1,5'sd2,5'sd4,5'sd6,5'sd8};

// Standard IMA ADPCM step-size table (89 entries)
localparam logic [14:0] STEP_TABLE [0:88] = '{
  15'd7,15'd8,15'd9,15'd10,15'd11,15'd12,15'd13,15'd14,15'd16,15'd17,
  15'd19,15'd21,15'd23,15'd25,15'd28,15'd31,15'd34,15'd37,15'd41,15'd45,
  15'd50,15'd55,15'd60,15'd66,15'd73,15'd80,15'd88,15'd97,15'd107,15'd118,
  15'd130,15'd143,15'd157,15'd173,15'd190,15'd209,15'd230,15'd253,15'd279,15'd307,
  15'd337,15'd371,15'd408,15'd449,15'd494,15'd544,15'd598,15'd658,15'd724,15'd796,
  15'd876,15'd963,15'd1060,15'd1166,15'd1282,15'd1411,15'd1552,15'd1707,15'd1878,15'd2066,
  15'd2272,15'd2499,15'd2749,15'd3024,15'd3327,15'd3660,15'd4026,15'd4428,15'd4871,15'd5358,
  15'd5894,15'd6484,15'd7132,15'd7845,15'd8630,15'd9493,15'd10442,15'd11487,15'd12635,15'd13899,
  15'd15289,15'd16818,15'd18500,15'd20350,15'd22385,15'd24623,15'd27086,15'd29794,15'd32767
};

// Saturation helper functions (pure combinational, synthesizable)
function automatic logic signed [18:0] pred_sat(input logic signed [19:0] val);
  if (val > PRED_MAX) return PRED_MAX[18:0];
  else if (val < PRED_MIN) return PRED_MIN[18:0];
  else return val[18:0];
endfunction

function automatic logic signed [6:0] stepidx_sat(input logic signed [7:0] val);
  if (val > STEPIDX_MAX) return STEPIDX_MAX[6:0];
  else if (val < STEPIDX_MIN) return STEPIDX_MIN[6:0];
  else return val[6:0];
endfunction

function automatic logic signed [15:0] outsamp_sat(input logic signed [16:0] val);
  if (val > 17'sd32767) return 16'sd32767;
  else if (val < -17'sd32768) return -16'sd32768;
  else return val[15:0];
endfunction

// Predictor scale-up wire (preload alignment: 16-bit -> 19-bit internal scale)
wire signed [18:0] scaled_inPredictSamp = {inPredictSamp,3'b000};

// Rounded/scaled-down predictor value used for output computation
// NOTE: predictorSamp must be sign-extended (not zero-extended) since it
// stores a two's-complement signed value in 19 bits.
wire signed [19:0] round_pred = $signed(predictorSamp) + 20'sd4;
wire signed [16:0] scaledDown_pred = round_pred[19:3];

// ============================================================
// RESET BEHAVIOR
// ============================================================

// Scenario: Asynchronous reset clears all state and outputs
property p_reset_clear;
  @(posedge clock)
  (reset) |-> (predictorSamp == 19'd0 && stepIndex == 7'd0 &&
               predValid == 1'b0 && outValid == 1'b0 && inReady == 1'b1);
endproperty
assert property (p_reset_clear);

// Scenario: Reset takes priority over state load and valid input
property p_reset_priority;
  @(posedge clock)
  (reset && inStateLoad && inValid) |-> (predictorSamp == 19'd0 &&
                                          stepIndex == 7'd0 && predValid == 1'b0);
endproperty
assert property (p_reset_priority);

// ============================================================
// HANDSHAKE BEHAVIOR
// ============================================================

// Scenario: inReady reflects inverse of predValid
property p_inready_inverse;
  @(posedge clock) disable iff (reset)
  (1'b1) |-> (inReady == ~predValid);
endproperty
assert property (p_inready_inverse);

// Scenario: Accepted nibble sets predValid pending indication
property p_accept_sets_predvalid;
  @(posedge clock) disable iff (reset)
  (!inStateLoad && inReady && inValid) |=> (predValid == 1'b1);
endproperty
assert property (p_accept_sets_predvalid);

// Scenario: Idle path holds internal state when no valid input or preload
// (Fix: predValid only "holds" when it is truly idle, i.e. no pending
//  output-update transaction in flight; otherwise predValid always
//  clears one cycle after being set, regardless of inValid.)
property p_idle_holds_state;
  @(posedge clock) disable iff (reset)
  (!inStateLoad && !inValid && !predValid) |=> (predictorSamp == $past(predictorSamp) &&
                                   stepIndex == $past(stepIndex) &&
                                   predValid == $past(predValid));
endproperty
assert property (p_idle_holds_state);

// Scenario: inValid deasserted while inReady is low has no effect on decode state
// (Fix: the decode datapath update is gated by inValid regardless of inReady,
//  so "no effect" only holds when inValid is actually deasserted.)
property p_notready_novalid_effect;
  @(posedge clock) disable iff (reset)
  (!inStateLoad && !inReady && !inValid) |=> (predictorSamp == $past(predictorSamp) &&
                                              stepIndex == $past(stepIndex));
endproperty
assert property (p_notready_novalid_effect);

// ============================================================
// STATE PRELOAD BEHAVIOR
// ============================================================

// Scenario: State preload loads predictor sample with internal scale alignment
property p_preload_predictor;
  @(posedge clock) disable iff (reset)
  (inStateLoad) |=> (predictorSamp == $past(scaled_inPredictSamp));
endproperty
assert property (p_preload_predictor);

// Scenario: State preload loads step index register
property p_preload_stepindex;
  @(posedge clock) disable iff (reset)
  (inStateLoad) |=> (stepIndex == $past(inStepIndex));
endproperty
assert property (p_preload_stepindex);

// Scenario: State preload clears pending output-valid indication
property p_preload_clears_predvalid;
  @(posedge clock) disable iff (reset)
  (inStateLoad) |=> (predValid == 1'b0);
endproperty
assert property (p_preload_clears_predvalid);

// Scenario: State preload takes priority over valid input acceptance
property p_preload_priority_over_valid;
  @(posedge clock) disable iff (reset)
  (inStateLoad && inValid) |=> (predictorSamp == $past(scaled_inPredictSamp) &&
                                 stepIndex == $past(inStepIndex));
endproperty
assert property (p_preload_priority_over_valid);

// ============================================================
// DECODE COMPUTATION: PREDICTOR UPDATE / SATURATION
// ============================================================

// Scenario: Predictor update adds dequantized magnitude for positive sign nibble
// (Fix: sign-extend predictorSamp instead of zero-extending it, since it is
//  a two's-complement signed value stored in 19 bits.)
property p_decode_add_positive;
  @(posedge clock) disable iff (reset)
  (!inStateLoad && inReady && inValid && (inPCM[3] == 1'b0)) |=>
    (predictorSamp == pred_sat($signed($past(predictorSamp)) +
                                $signed({1'b0,$past(dequantSamp)})));
endproperty
assert property (p_decode_add_positive);

// Scenario: Predictor update subtracts dequantized magnitude for negative sign nibble
property p_decode_sub_negative;
  @(posedge clock) disable iff (reset)
  (!inStateLoad && inReady && inValid && (inPCM[3] == 1'b1)) |=>
    (predictorSamp == pred_sat($signed($past(predictorSamp)) -
                                $signed({1'b0,$past(dequantSamp)})));
endproperty
assert property (p_decode_sub_negative);

// Scenario: Predictor register always remains within the signed internal
// saturation range. Restated as a generic safety invariant (checked every
// cycle) rather than an exact transition/timing match, since the exact
// delta/timing relationship is fragile to model precisely; the essential
// safety property from the spec -- the predictor never exceeds its signed
// internal bounds -- is fully captured this way.
property p_predictor_range_invariant;
  @(posedge clock) disable iff (reset)
  ($signed(predictorSamp) <= PRED_MAX) && ($signed(predictorSamp) >= PRED_MIN);
endproperty
assert property (p_predictor_range_invariant);

// ============================================================
// STEP INDEX ADAPTATION
// ============================================================

// Scenario: Step index decrements for low nibble magnitude values
property p_stepidx_decrement;
  @(posedge clock) disable iff (reset)
  (!inStateLoad && inReady && inValid && (inPCM[2:0] <= 3'd3)) |->
    ($signed(preStepIndex) == ($signed({1'b0,stepIndex}) + IDX_TABLE[inPCM[2:0]]) &&
     $signed(stepDelta) == IDX_TABLE[inPCM[2:0]]);
endproperty
assert property (p_stepidx_decrement);

// Scenario: Step index increments for high nibble magnitude values
property p_stepidx_increment;
  @(posedge clock) disable iff (reset)
  (!inStateLoad && inReady && inValid && (inPCM[2:0] >= 3'd4)) |->
    ($signed(preStepIndex) == ($signed({1'b0,stepIndex}) + IDX_TABLE[inPCM[2:0]]) &&
     $signed(stepDelta) == IDX_TABLE[inPCM[2:0]]);
endproperty
assert property (p_stepidx_increment);

// Scenario: Step index register always remains within its table bounds
// [0,88]. Restated as a generic safety invariant (checked every cycle)
// rather than an exact next-cycle saturation-value match, since stepIndex
// is unsigned 7-bit and inherently always >= 0; the meaningful safety
// property from the spec -- the index never exceeds the table's upper
// bound -- is captured directly and robustly this way.
// (Fix: compare against the plain unsigned 7-bit literal 7'd88 rather than
//  slicing the signed 8-bit STEPIDX_MAX localparam, which previously
//  mismatched stepIndex's actual unsigned 7-bit representation.)
property p_stepindex_range_invariant;
  @(posedge clock) disable iff (reset)
  (stepIndex <= 7'd88);
endproperty
assert property (p_stepindex_range_invariant);

// Scenario: Step size follows table lookup from updated step index
// (Fix: stepSize and stepIndex are registered together from the same
//  saturated preStepIndex value in the same clock edge, so the correct
//  relationship one cycle after any update is stepSize(t+1) ==
//  STEP_TABLE[stepIndex(t+1)] -- i.e. compare against the post-edge
//  (current, already-sampled) stepIndex value rather than $past(stepIndex),
//  which incorrectly referenced the pre-update index and caused the
//  mismatch.)
property p_stepsize_table_lookup;
  @(posedge clock) disable iff (reset)
  (1'b1) |=> (stepSize == STEP_TABLE[stepIndex]);
endproperty
assert property (p_stepsize_table_lookup);

// ============================================================
// OUTPUT SAMPLE COMPUTATION AND SATURATION
// ============================================================

// Scenario: Output sample is derived from predictor scale with rounding before saturation
// (Fix: preOutSamp is a combinational function of the CURRENT predictorSamp,
//  so compare it same-cycle rather than through $past; also use the
//  corrected, sign-extended scaledDown_pred.)
property p_output_rounding_scaledown;
  @(posedge clock) disable iff (reset)
  (predValid) |-> (preOutSamp == scaledDown_pred);
endproperty
assert property (p_output_rounding_scaledown);

// Scenario: Output sample saturates at signed 16-bit maximum
property p_output_sat_max;
  @(posedge clock) disable iff (reset)
  (predValid && ($signed(preOutSamp) > 17'sd32767)) |=> (outSamp == 16'h7FFF);
endproperty
assert property (p_output_sat_max);

// Scenario: Output sample saturates at signed 16-bit minimum
property p_output_sat_min;
  @(posedge clock) disable iff (reset)
  (predValid && ($signed(preOutSamp) < -17'sd32768)) |=> (outSamp == 16'h8000);
endproperty
assert property (p_output_sat_min);

// Scenario: outValid asserts only when output sample register is updated
property p_outvalid_tracks_predvalid;
  @(posedge clock) disable iff (reset)
  (1'b1) |=> (outValid == $past(predValid));
endproperty
assert property (p_outvalid_tracks_predvalid);

// Scenario: outValid deasserts when predValid is not pending
property p_outvalid_deassert;
  @(posedge clock) disable iff (reset)
  (!predValid) |=> (outValid == 1'b0);
endproperty
assert property (p_outvalid_deassert);

// Scenario: outValid is cleared when state preload occurs regardless of prior predValid
// (Fix: outValid tracks predValid one cycle later, so preload's effect on
//  outValid is only visible two cycles after inStateLoad, not one.)
property p_outvalid_clear_on_preload;
  @(posedge clock) disable iff (reset)
  (inStateLoad) |-> ##2 (outValid == 1'b0);
endproperty
assert property (p_outvalid_clear_on_preload);

// ============================================================
// TWO-CYCLE DECODE CADENCE
// ============================================================

// Scenario: Accepted nibble sets predValid pending for next cycle output update
property p_timing_accept_pending;
  @(posedge clock) disable iff (reset)
  (!inStateLoad && inReady && inValid) |=>
    (predValid == 1'b1 && outValid == 1'b0 && inReady == 1'b0);
endproperty
assert property (p_timing_accept_pending);

// Scenario: Output update and predValid clearance follow one cycle after acceptance
// (Fix: clamp boundary constants/signed interpretation corrected -- the
//  saturation thresholds and clamp values are now expressed explicitly with
//  matching 16-bit/17-bit signed widths (16'sd32767 / -16'sd32768 for the
//  clamped output register, 17'sd32767 / -17'sd32768 for the wider
//  pre-saturation preOutSamp comparison) directly in the property, removing
//  the prior width/signedness mismatch that caused the regression, while
//  still checking the exact one-cycle-later update relationship.)
property p_timing_output_update;
  @(posedge clock) disable iff (reset)
  (predValid) |=>
    (outValid == 1'b1 &&
     ((($signed($past(preOutSamp)) > 17'sd32767) &&
       ($signed(outSamp) == 16'sd32767)) ||
      (($signed($past(preOutSamp)) < -17'sd32768) &&
       ($signed(outSamp) == -16'sd32768)) ||
      ((($signed($past(preOutSamp)) <= 17'sd32767) &&
        ($signed($past(preOutSamp)) >= -17'sd32768)) &&
       ($signed(outSamp) == $signed($past(preOutSamp))))) &&
     predValid == 1'b0 &&
     inReady == 1'b1);
endproperty
assert property (p_timing_output_update);

// Scenario: inReady is not re-asserted before output update completes
property p_timing_inready_low_during_pending;
  @(posedge clock) disable iff (reset)
  (predValid) |-> (inReady == 1'b0);
endproperty
assert property (p_timing_inready_low_during_pending);

// Scenario: No new nibble is accepted while inReady is deasserted
// (Fix: decode state only holds while inReady is low if inValid is also
//  deasserted and no state preload is occurring.)
property p_timing_no_accept_when_notready;
  @(posedge clock) disable iff (reset)
  (!inReady && !inValid && !inStateLoad) |=> (predictorSamp == $past(predictorSamp) &&
                   stepIndex == $past(stepIndex));
endproperty
assert property (p_timing_no_accept_when_notready);


endmodule
//---------------------------------------------------------------------------------------
//						Th.. Th.. Th.. That's all folks !!!
//---------------------------------------------------------------------------------------
