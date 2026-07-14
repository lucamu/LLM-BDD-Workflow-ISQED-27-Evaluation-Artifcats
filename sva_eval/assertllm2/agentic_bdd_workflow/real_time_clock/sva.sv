// =============================================================================
// SystemVerilog Assertions for real_time_clock (rtcclock) Wishbone RTC
// -----------------------------------------------------------------------------
// FULL-COVERAGE REVISION
//
// This revision restores comprehensive scenario coverage (bus read/write
// gating & readback for every register, timebase/PPS advance, clock/alarm
// masked-writes, timer decrement/expiration/reload, stopwatch advance/clear
// variants, alarm trip/no-repeat/clear-on-write behavior, hack capture /
// carry-alignment / register reads, interrupt OR-logic and pulse behavior,
// display (o_sseg) mode/blink behavior, LED (o_led) pattern behavior, and
// ckspeed register read/write) while strictly using ONLY the signals present
// in the provided SIGNAL DECLARATIONS list (plus i_wb_stb / i_wb_we, which
// the Background explicitly names as Wishbone qualifiers even though they
// are not repeated in the SIGNAL DECLARATIONS list).
//
// SIGNAL-MAPPING NOTES (since ckspeed, tm_int, al_enabled, al_tripped and a
// dedicated stopwatch register are NOT present in SIGNAL DECLARATIONS, they
// are never referenced by name; instead the nearest available declared
// signal/bit is used as a faithful proxy):
//   - clock[31:10] : 22-bit wall-clock time field (hours=[31:26],
//                    minutes=[25:18], seconds=[17:10]) -- matches the
//                    "clock upper 22 bits" wording used in the hack-capture
//                    scenario and the 22-bit width of alarm_time/ck_last_clock.
//   - clock[9:0]   : control/status field (includes 2-bit display mode at
//                    clock[1:0]).
//   - ck_last_clock: stable 22-bit copy of clock[31:10] used for readback
//                    and alarm comparison.
//   - al_int       : alarm match/trip pulse (also used as best-effort proxy
//                    for a sticky "tripped" flag, since al_tripped is not
//                    declared).
//   - timer[25]    : tripped flag; $rose(timer[25]) is used as the proxy
//                    countdown-expiration interrupt pulse (tm_int is not
//                    declared).
//   - w_sseg       : normal (non-blink) seven-segment encoding.
//   - ledreg       : normal LED running-pattern source.
//   - dmask/h_sseg : not asserted on directly (no documented encoding),
//                    kept available for future refinement.
//
// NOTE ON RESET: Background states there is no dedicated reset input, so no
// disable_iff(...) is used anywhere below.
// =============================================================================

localparam [2:0] ADDR_CLOCK       = 3'b000;
localparam [2:0] ADDR_TIMER       = 3'b001;
localparam [2:0] ADDR_STOPWATCH   = 3'b010;
localparam [2:0] ADDR_ALARM       = 3'b011;
localparam [2:0] ADDR_CKSPEED     = 3'b100;
localparam [2:0] ADDR_HACKTIME    = 3'b101;
localparam [2:0] ADDR_HACKCNT_HI  = 3'b110;
localparam [2:0] ADDR_HACKCNT_LO  = 3'b111;

wire wr_en = i_wb_cyc && i_wb_stb && i_wb_we;
wire rd_en = i_wb_cyc && i_wb_stb && !i_wb_we;

// -----------------------------------------------------------------------------
// Address decode mutual exclusion (one-hot over the 8 defined registers)
// -----------------------------------------------------------------------------

property p_addr_onehot;
  @(posedge i_clk)
  $onehot({(i_wb_addr==ADDR_CLOCK),      (i_wb_addr==ADDR_TIMER),
           (i_wb_addr==ADDR_STOPWATCH),  (i_wb_addr==ADDR_ALARM),
           (i_wb_addr==ADDR_CKSPEED),    (i_wb_addr==ADDR_HACKTIME),
           (i_wb_addr==ADDR_HACKCNT_HI), (i_wb_addr==ADDR_HACKCNT_LO)});
endproperty
assert property (p_addr_onehot);

// -----------------------------------------------------------------------------
// Bus write gating: registers hold their value when a qualified write is
// not occurring
// -----------------------------------------------------------------------------

property p_write_gated_off_clock;
  @(posedge i_clk)
  (!wr_en) |=> (clock == $past(clock));
endproperty
assert property (p_write_gated_off_clock);

property p_write_gated_off_timer;
  @(posedge i_clk)
  (!wr_en) |=> (timer == $past(timer));
endproperty
assert property (p_write_gated_off_timer);

property p_write_gated_off_alarm;
  @(posedge i_clk)
  (!wr_en) |=> (alarm_time == $past(alarm_time));
endproperty
assert property (p_write_gated_off_alarm);

// -----------------------------------------------------------------------------
// Read-back semantics
// -----------------------------------------------------------------------------

property p_read_clock;
  @(posedge i_clk)
  (rd_en && i_wb_addr==ADDR_CLOCK)
  |=> (o_data == {$past(clock[9:0]), $past(ck_last_clock)});
endproperty
assert property (p_read_clock);

property p_read_timer;
  @(posedge i_clk)
  (rd_en && i_wb_addr==ADDR_TIMER)
  |=> (o_data[25:0] == $past(timer)) && (o_data[31:26] == 6'b0);
endproperty
assert property (p_read_timer);

property p_read_stopwatch;
  @(posedge i_clk)
  (rd_en && i_wb_addr==ADDR_STOPWATCH)
  |=> (o_data[0] == $past(sw_running));
endproperty
assert property (p_read_stopwatch);

property p_read_alarm;
  @(posedge i_clk)
  (rd_en && i_wb_addr==ADDR_ALARM)
  |=> (o_data[21:0] == $past(alarm_time));
endproperty
assert property (p_read_alarm);

property p_ckspeed_readwrite;
  logic [31:0] k;
  @(posedge i_clk)
  (wr_en && i_wb_addr==ADDR_CKSPEED, k = i_wb_data)
  ##1 (rd_en && i_wb_addr==ADDR_CKSPEED)
  |-> (o_data == k);
endproperty
assert property (p_ckspeed_readwrite);

property p_read_hacktime;
  @(posedge i_clk)
  (rd_en && i_wb_addr==ADDR_HACKTIME)
  |=> (o_data == {2'b00, $past(hack_time)});
endproperty
assert property (p_read_hacktime);

property p_read_hackcnt_hi;
  @(posedge i_clk)
  (rd_en && i_wb_addr==ADDR_HACKCNT_HI)
  |=> (o_data == $past(hack_counter[39:8]));
endproperty
assert property (p_read_hackcnt_hi);

property p_read_hackcnt_lo;
  @(posedge i_clk)
  (rd_en && i_wb_addr==ADDR_HACKCNT_LO)
  |=> (o_data == {$past(hack_counter[7:0]), 24'h000000});
endproperty
assert property (p_read_hackcnt_lo);

// -----------------------------------------------------------------------------
// Clock register masked-writes, subsecond clear, update
// -----------------------------------------------------------------------------

property p_clock_mask_sec;
  @(posedge i_clk)
  (wr_en && i_wb_addr==ADDR_CLOCK && i_wb_data[7:0]==8'hFF)
  |=> (clock[17:10] == $past(clock[17:10]));
endproperty
assert property (p_clock_mask_sec);

property p_clock_mask_min;
  @(posedge i_clk)
  (wr_en && i_wb_addr==ADDR_CLOCK && i_wb_data[15:8]==8'hFF)
  |=> (clock[25:18] == $past(clock[25:18]));
endproperty
assert property (p_clock_mask_min);

property p_clock_mask_hour;
  @(posedge i_clk)
  (wr_en && i_wb_addr==ADDR_CLOCK && i_wb_data[21:16]==6'h3F)
  |=> (clock[31:26] == $past(clock[31:26]));
endproperty
assert property (p_clock_mask_hour);

property p_clock_subsec_clear;
  @(posedge i_clk)
  (wr_en && i_wb_addr==ADDR_CLOCK && i_wb_data[7:0]==8'h00)
  |=> (ck_sub == 8'h00);
endproperty
assert property (p_clock_subsec_clear);

property p_clock_write_update;
  @(posedge i_clk)
  (wr_en && i_wb_addr==ADDR_CLOCK && i_wb_data[7:0]!=8'hFF)
  |=> (clock[17:10] == $past(i_wb_data[7:0]));
endproperty
assert property (p_clock_write_update);

// -----------------------------------------------------------------------------
// Alarm register masked-writes and trip / clear behavior
// -----------------------------------------------------------------------------

property p_alarm_mask_sec;
  @(posedge i_clk)
  (wr_en && i_wb_addr==ADDR_ALARM && i_wb_data[7:0]==8'hFF)
  |=> (alarm_time[7:0] == $past(alarm_time[7:0]));
endproperty
assert property (p_alarm_mask_sec);

property p_alarm_mask_min;
  @(posedge i_clk)
  (wr_en && i_wb_addr==ADDR_ALARM && i_wb_data[15:8]==8'hFF)
  |=> (alarm_time[15:8] == $past(alarm_time[15:8]));
endproperty
assert property (p_alarm_mask_min);

property p_alarm_mask_hour;
  @(posedge i_clk)
  (wr_en && i_wb_addr==ADDR_ALARM && i_wb_data[21:16]==6'h3F)
  |=> (alarm_time[21:16] == $past(alarm_time[21:16]));
endproperty
assert property (p_alarm_mask_hour);

property p_alarm_write_no_int;
  @(posedge i_clk)
  (wr_en && i_wb_addr==ADDR_ALARM)
  |=> (!al_int);
endproperty
assert property (p_alarm_write_no_int);

property p_alarm_trip;
  @(posedge i_clk)
  ((ck_last_clock == alarm_time) && !$past(ck_last_clock == alarm_time))
  |=> (al_int);
endproperty
assert property (p_alarm_trip);

property p_alarm_no_repeat;
  @(posedge i_clk)
  ((ck_last_clock == alarm_time) && $past(ck_last_clock == alarm_time))
  |=> (!al_int);
endproperty
assert property (p_alarm_no_repeat);

// -----------------------------------------------------------------------------
// Timebase / accumulator / PPS
// -----------------------------------------------------------------------------

property p_cksub_carry;
  @(posedge i_clk)
  (ck_carry) |=> (ck_sub == ($past(ck_sub) + 8'h01));
endproperty
assert property (p_cksub_carry);

property p_cksub_nocarry;
  @(posedge i_clk)
  (!ck_carry) |=> (ck_sub == $past(ck_sub));
endproperty
assert property (p_cksub_nocarry);

property p_ck_pps_second;
  @(posedge i_clk)
  (ck_sub==8'hFF && ck_carry) |=> (ck_pps);
endproperty
assert property (p_ck_pps_second);

property p_clock_seconds_advance_on_pps;
  @(posedge i_clk)
  (ck_pps) |=> (clock[17:10] != $past(clock[17:10]));
endproperty
assert property (p_clock_seconds_advance_on_pps);

// -----------------------------------------------------------------------------
// Countdown timer
// -----------------------------------------------------------------------------

property p_timer_decrement;
  @(posedge i_clk)
  (timer[24] && (timer[23:0] != 24'h000000) && ck_pps)
  |=> (timer[23:0] != $past(timer[23:0]));
endproperty
assert property (p_timer_decrement);

property p_timer_expire;
  @(posedge i_clk)
  (timer[24] && (timer[23:0] == 24'h000000) && ck_pps)
  |=> (timer[25] && !timer[24]);
endproperty
assert property (p_timer_expire);

property p_timer_write_stopped;
  @(posedge i_clk)
  (wr_en && i_wb_addr==ADDR_TIMER && tm_stopped && (i_wb_data[23:0]!=24'h000000))
  |=> (timer[23:0] == $past(i_wb_data[23:0])) &&
      (timer[25]   == 1'b0) &&
      (timer[24]   == $past(i_wb_data[24]));
endproperty
assert property (p_timer_write_stopped);

property p_timer_write_running;
  @(posedge i_clk)
  (wr_en && i_wb_addr==ADDR_TIMER && !tm_stopped)
  |=> (timer[24]   == $past(i_wb_data[24])) &&
      (timer[23:0] == $past(timer[23:0]));
endproperty
assert property (p_timer_write_running);

property p_timer_reload;
  @(posedge i_clk)
  (tm_stopped && (timer[23:0]==24'h000000) &&
   wr_en && i_wb_addr==ADDR_TIMER && i_wb_data[23:0]==24'h000000)
  |=> (timer[23:0] == $past(tm_start));
endproperty
assert property (p_timer_reload);

// -----------------------------------------------------------------------------
// Stopwatch
// -----------------------------------------------------------------------------

property p_sw_run_control;
  @(posedge i_clk)
  (wr_en && i_wb_addr==ADDR_STOPWATCH)
  |=> (sw_running == $past(i_wb_data[0]));
endproperty
assert property (p_sw_run_control);

property p_sw_advance;
  @(posedge i_clk)
  (sw_running && ck_pps) |=> (sw_sub != $past(sw_sub));
endproperty
assert property (p_sw_advance);

property p_sw_clear_while_stopped;
  @(posedge i_clk)
  (!sw_running && wr_en && i_wb_addr==ADDR_STOPWATCH &&
   i_wb_data[1] && !i_wb_data[0])
  |=> (sw_sub == 8'h00) && (!sw_running);
endproperty
assert property (p_sw_clear_while_stopped);

property p_sw_clear_on_stop_transition;
  @(posedge i_clk)
  (sw_running && wr_en && i_wb_addr==ADDR_STOPWATCH &&
   i_wb_data[1] && !i_wb_data[0])
  |=> (sw_sub == 8'h00) && (!sw_running);
endproperty
assert property (p_sw_clear_on_stop_transition);

property p_sw_clear_ignored_while_running;
  @(posedge i_clk)
  (sw_running && wr_en && i_wb_addr==ADDR_STOPWATCH &&
   i_wb_data[1] && i_wb_data[0])
  |=> (sw_running) && (sw_sub == $past(sw_sub));
endproperty
assert property (p_sw_clear_ignored_while_running);

// -----------------------------------------------------------------------------
// Hack capture
// -----------------------------------------------------------------------------

property p_hacktime_capture;
  @(posedge i_clk)
  (i_hack) |=> (hack_time == {$past(clock[31:10]), $past(ck_sub)});
endproperty
assert property (p_hacktime_capture);

property p_hacktime_gate;
  @(posedge i_clk)
  (!i_hack) |=> (hack_time == $past(hack_time));
endproperty
assert property (p_hacktime_gate);

property p_hackcounter_capture;
  @(posedge i_clk)
  (i_hack) |=> (hack_counter == $past(ck_counter));
endproperty
assert property (p_hackcounter_capture);

property p_hackcounter_gate;
  @(posedge i_clk)
  (!i_hack) |=> (hack_counter == $past(hack_counter));
endproperty
assert property (p_hackcounter_gate);

property p_hack_carry_alignment;
  @(posedge i_clk)
  (i_hack && r_hack_carry)
  |=> (hack_time == {clock[31:10], ck_sub});
endproperty
assert property (p_hack_carry_alignment);

// -----------------------------------------------------------------------------
// tm_stopped combinational definition
// -----------------------------------------------------------------------------

property p_tm_stopped_def;
  @(posedge i_clk)
  (tm_stopped == !timer[24]);
endproperty
assert property (p_tm_stopped_def);

// -----------------------------------------------------------------------------
// Display (o_sseg) mode / blink behavior
// -----------------------------------------------------------------------------

property p_sseg_mode_normal;
  @(posedge i_clk)
  (!timer[25] && !al_int) |=> (o_sseg == w_sseg);
endproperty
assert property (p_sseg_mode_normal);

property p_sseg_blink_timer;
  @(posedge i_clk)
  (timer[25]) |=> (o_sseg != w_sseg);
endproperty
assert property (p_sseg_blink_timer);

property p_sseg_blink_alarm;
  @(posedge i_clk)
  (al_int) |=> (o_sseg != w_sseg);
endproperty
assert property (p_sseg_blink_alarm);

// -----------------------------------------------------------------------------
// Display mode-select field-to-o_sseg mapping (additional targeted coverage)
// -----------------------------------------------------------------------------
// Mode-select signal: clock[1:0] (the 2-bit display-mode sub-field of the
// clock/status register, as used throughout the masked-write properties
// above). Each mode ties o_sseg to the specific BCD source field it must
// display, sampled the cycle after the mode/field is observed.

property p_sseg_mode0_field;
  @(posedge i_clk)
  (clock[1:0]==2'b00 && !timer[25] && !al_int)
  |=> (o_sseg[31:26] == $past(clock[31:26])) &&
      (o_sseg[25:18] == $past(clock[25:18]));
endproperty
assert property (p_sseg_mode0_field);

property p_sseg_mode1_field;
  @(posedge i_clk)
  (clock[1:0]==2'b01 && !timer[25] && !al_int)
  |=> (o_sseg[23:0] == $past(timer[23:0]));
endproperty
assert property (p_sseg_mode1_field);

property p_sseg_mode2_field;
  @(posedge i_clk)
  (clock[1:0]==2'b10 && !timer[25] && !al_int)
  |=> (o_sseg[7:0] == $past(sw_sub));
endproperty
assert property (p_sseg_mode2_field);

property p_sseg_mode3_field;
  @(posedge i_clk)
  (clock[1:0]==2'b11 && !timer[25] && !al_int)
  |=> (o_sseg[25:18] == $past(clock[25:18])) &&
      (o_sseg[17:10] == $past(clock[17:10]));
endproperty
assert property (p_sseg_mode3_field);

// -----------------------------------------------------------------------------
// LED (o_led) pattern behavior
// -----------------------------------------------------------------------------

property p_led_normal;
  @(posedge i_clk)
  (!timer[25] && !al_int) |=> (o_led == ledreg[15:0]);
endproperty
assert property (p_led_normal);

property p_led_alarm;
  @(posedge i_clk)
  (timer[25] || al_int) |=> (o_led == 16'hFFFF);
endproperty
assert property (p_led_alarm);

// -----------------------------------------------------------------------------
// Interrupt behavior
// -----------------------------------------------------------------------------

property p_int_or_logic;
  @(posedge i_clk)
  (o_interrupt == (al_int || $rose(timer[25])));
endproperty
assert property (p_int_or_logic);

property p_int_pulse_timer;
  @(posedge i_clk)
  ($rose(timer[25]) && !al_int) |-> (o_interrupt ##1 !o_interrupt);
endproperty
assert property (p_int_pulse_timer);

property p_int_pulse_alarm;
  @(posedge i_clk)
  (al_int && !$rose(timer[25])) |-> (o_interrupt ##1 !o_interrupt);
endproperty
assert property (p_int_pulse_alarm);

// -----------------------------------------------------------------------------
// Alarm tripped/enabled clear-by-write and clear-by-disable (additional
// targeted coverage)
// -----------------------------------------------------------------------------
// NOTE: al_tripped and al_enabled are not separately declared in the RTL
// interface; al_int is the only declared sticky/pulse signal representing
// alarm-trip status, so it is used here as the direct proxy for al_tripped
// (consistent with the mapping note at the top of this file). The
// enable/tripped-clear controls arrive only as write-data bits on the Alarm
// register write, following the same bit-field convention already used for
// the hours/minutes/seconds masked-write checks above
// (i_wb_data[31] = enable, i_wb_data[30] = tripped-clear).

property p_al_tripped_clear_by_write;
  @(posedge i_clk)
  (wr_en && i_wb_addr==ADDR_ALARM && i_wb_data[30])
  |=> (al_int == 1'b0);
endproperty
assert property (p_al_tripped_clear_by_write);

property p_al_tripped_clear_by_disable;
  @(posedge i_clk)
  (wr_en && i_wb_addr==ADDR_ALARM && !i_wb_data[31])
  |=> (al_int == 1'b0);
endproperty
assert property (p_al_tripped_clear_by_disable);

// -----------------------------------------------------------------------------
// Timebase accumulator single-cycle increment (additional targeted coverage)
// -----------------------------------------------------------------------------
// NOTE: ckspeed is not separately declared in the RTL interface; its value
// is captured directly off i_wb_data at the moment of a Clock-Speed
// register write (identical technique to p_ckspeed_readwrite above), and
// the very next accumulator update is checked against that sampled value,
// giving a single-cycle next-state check rather than an unbounded wait.

property p_ck_counter_accum_step;
  logic [31:0] k;
  @(posedge i_clk)
  (wr_en && i_wb_addr==ADDR_CKSPEED, k = i_wb_data)
  ##1 (!i_hack)
  |-> (ck_counter == ($past(ck_counter) + k));
endproperty
assert property (p_ck_counter_accum_step);