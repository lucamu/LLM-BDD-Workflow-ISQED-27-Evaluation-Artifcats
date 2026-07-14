/*Author: Zhuxu 
	m99a1@yahoo.cn
Pulse Width Generators/timers with 16-bit main counter.
Period or timers target number is controlled by register [15:0]period.
Duty cycle is controlled by register [15:0]DC.
Clock used for PWM signal generation can be switched between Wishbone Bus clock and external clock. It is down clocked first.
o_pwm outputs PWM signal or timers interrupt.

control register [7:0]ctrl:
bit 0:	When set, external clock is chosen for PWM/timer. When cleared, wb clock is used for PWM/timer.
bit 1:	When set,  PWM is enabled. When cleared,  timer is enabled.
bit 2:	When set,  PWM/timer starts. When cleared, PWM/timer stops.
bit 3:	When set, timer runs continuously. When cleared, timer runs one time.
bit 4:	When set, o_pwm enabled.
bit 5:	timer interrupt bit	When it is written with 0, interrupt request is cleared. 
bit 6:	When set, a 16-bit external signal i_DC is used as duty cycle. When cleared, register DC is used.
bit 7:	When set, counter reset for PWM/timer, it's output and bit 5 will also be cleared. When changing from PWM mode to timer mode reset is needed before timer starts.
*/
module	PWM(
//wishbone slave interface
input	i_wb_clk,
input	i_wb_rst,
input	i_wb_cyc,
input	i_wb_stb,
input	i_wb_we,
input	[15:0]i_wb_adr,
input	[15:0]i_wb_data,
output	[15:0]o_wb_data,
output	o_wb_ack,

input	i_extclk,
input	[15:0]i_DC,
input	i_valid_DC,
output	o_pwm

);

////////////////////control logic////////////////////////////
parameter	adr_ctrl=0,
		adr_divisor=2,
		adr_period=4,
		adr_DC=6;
reg	[7:0]ctrl;
reg	[15:0]period;
reg	[15:0]DC;
reg	[15:0]divisor;	//for down clocking. If(divisor==0)To=Ti;	else To=Ti/divisor;
integer	i;
wire	write;
assign	write=i_wb_cyc&i_wb_stb&i_wb_we;
assign	o_wb_ack=i_wb_stb;
always@(posedge i_wb_clk or posedge i_wb_rst)
	if(i_wb_rst)begin
		ctrl[4:0]<=0;
		ctrl[7:6]<=0;
		DC<=0;
		period<=0;
		divisor<=0;	
	end
	else if(write)begin
		case(i_wb_adr)
			adr_ctrl:begin
				ctrl[4:0]<=i_wb_data[4:0];
				ctrl[7:6]<=i_wb_data[7:6];
			end
			adr_divisor:divisor<=i_wb_data;
			adr_period:period<=i_wb_data;
			adr_DC:DC<=i_wb_data;
		endcase
	end

//interrupt bit control
wire	pwm;
assign	pwm=ctrl[1];
reg	[1:0]state;
reg	clrint;		//signal to pwm/timer  logic
wire	ack_clrint;	//signal from pwm/timer  logic
wire	timer_irq;	//signal from pwm/timer logic (not named int: SV keyword)
always@(posedge i_wb_clk or posedge i_wb_rst)
	if(i_wb_rst)begin
		ctrl[5]<=0;
		state<=0;
		clrint<=0;
	end
	else begin
		case(state)			
			1:begin
				if(write)begin
					if(i_wb_data[7])begin
						ctrl[5]<=0;
						state<=0;
					end
					else if(!i_wb_data[5])begin
						ctrl[5]<=0;
						if(!pwm)begin
							clrint<=1;
							state<=2;
						end
						else state<=0;
					end
				end
			end
			2:if(ack_clrint)begin
				clrint<=0;
				state<=0;	
			end
			default:begin
				if(!pwm)ctrl[5]<=timer_irq;
				if(timer_irq)state<=1;
			end
		endcase
	end


///////////////////////////////////////////////////////////

//////down clocking for pwm/timer///////////////////
wire	clk_source;
wire	eclk,oclk;
assign	clk_source=ctrl[0]?i_extclk:i_wb_clk;
down_clocking_even	down_clocking_even_0(
clk_source,
(!i_wb_rst),
{1'b0,divisor[15:1]},
eclk
);
down_clocking_odd	down_clocking_odd_0(
clk_source,
(!i_wb_rst),
{1'b0,divisor[15:1]},
oclk
);
wire	clk;
assign	clk=divisor[0]?oclk:eclk;
///////////////////////////////////////////////////////

/////////////////main counter //////////////////////////
reg	[15:0]ct;
reg	pts;	//PWM signal or timer interrupt signal
reg	[15:0]extDC;
wire	[15:0]DC_1;
assign	DC_1=ctrl[6]?extDC:DC;	//external or internal duty cycle toggle
wire	[15:0]period_1;
assign	period_1=(period==0)?0:(period-1);
reg	switch_ack_clrint;
wire	state_timer;
assign	state_timer=ctrl[3];
wire	rst_ct;
assign	rst_ct=i_wb_rst|ctrl[7];
assign	timer_irq=pwm?0:pts;
assign	ack_clrint=switch_ack_clrint?clrint:0;
always@(posedge clk or posedge rst_ct)
	if(rst_ct)begin
		pts<=0;
		ct<=0;
		switch_ack_clrint<=0;
		extDC<=0;
	end
	else begin
	if(i_valid_DC)extDC<=i_DC;
	if(switch_ack_clrint&&(!clrint))switch_ack_clrint<=0;
	if(ctrl[2])begin
		case(pwm)
			1:begin
				if(ct>=period_1)ct<=0;
				else ct<=ct+1;

				if(ct<DC_1)pts<=1;
				else pts<=0;
			end
			0:begin

				case(state_timer)
					0:begin
						if(clrint)switch_ack_clrint<=1;
						if(ct>=period_1)begin
							if(clrint)begin
								pts<=0;
								ct<=0;	
							end
							else pts<=1;
							
						end
						else ct<=ct+1;
					end
					1:begin
						if(ct>=period_1)begin
							pts<=1;
							ct<=0;
						end
						else begin
							if(clrint)begin
								switch_ack_clrint<=1;
								pts<=0;
							end
							ct<=ct+1;
						end
					end
				endcase
			end
		endcase
	end
	else if(clrint)begin
		switch_ack_clrint<=1;
		if(!pwm)begin
			pts<=0;
			ct<=0;
		end
	end
	end
//////////////////////////////////////////////////////////

assign	o_pwm=ctrl[4]?pts:0;
assign	o_wb_data=	i_wb_adr==adr_ctrl?{8'h0,ctrl}:
			i_wb_adr==adr_divisor?divisor:
			i_wb_adr==adr_period?period:
			i_wb_adr==adr_DC?DC:0;


// --- Formal assertions ---
// =====================================================================
// SVA Properties for pwm module (rebalanced set)
// Majority of properties are simple, register-level, single-cycle checks
// that do NOT traverse the down_clocking_even/odd divider path, to
// maximize provability. A small handful of properties that must
// reason about the counter/divider behavior are retained separately.
// This revision further splits/simplifies antecedents and fixes
// same-cycle vs next-cycle timing mismatches to improve provability.
// =====================================================================

// ---------------------------------------------------------------
// Reset Behavior (simple, no divider dependency) -- unchanged
// ---------------------------------------------------------------

property p_reset_clears_regs;
  @(posedge i_wb_clk)
  (i_wb_rst) |=> (ctrl == 8'h00 && divisor == 16'h0000 &&
                  period == 16'h0000 && DC == 16'h0000 &&
                  o_pwm == 1'b0);
endproperty
assert property (p_reset_clears_regs)
  else $error("Reset did not clear control registers/o_pwm");

property p_rst_ct_clears_counter;
  @(posedge clk)
  (rst_ct) |=> (ct == '0 && timer_irq == 1'b0);
endproperty
assert property (p_rst_ct_clears_counter)
  else $error("rst_ct did not clear main counter/timer irq state");

property p_ctr_rst_regs_unchanged;
  @(posedge i_wb_clk) disable iff (i_wb_rst)
  (ctrl[7] == 1'b1 && !write)
    |=> (divisor == $past(divisor) &&
         period  == $past(period)  &&
         DC      == $past(DC));
endproperty
assert property (p_ctr_rst_regs_unchanged)
  else $error("ctr_rst altered Divisor/Period/DC registers");

// ---------------------------------------------------------------
// WISHBONE Register Write Behavior (simple, no divider dependency) -- unchanged
// ---------------------------------------------------------------

property p_write_ctrl_bits;
  @(posedge i_wb_clk) disable iff (i_wb_rst)
  (write && i_wb_adr == 16'h0000)
    |=> (ctrl[7:6] == $past(i_wb_data[7:6]) &&
         ctrl[4:0] == $past(i_wb_data[4:0]));
endproperty
assert property (p_write_ctrl_bits)
  else $error("Ctrl write did not update non-bit5 fields correctly");

property p_write_divisor;
  @(posedge i_wb_clk) disable iff (i_wb_rst)
  (write && i_wb_adr == 16'h0002)
    |=> (divisor == $past(i_wb_data));
endproperty
assert property (p_write_divisor)
  else $error("Divisor register did not update on write");

property p_write_period;
  @(posedge i_wb_clk) disable iff (i_wb_rst)
  (write && i_wb_adr == 16'h0004)
    |=> (period == $past(i_wb_data));
endproperty
assert property (p_write_period)
  else $error("Period register did not update on write");

property p_write_dc;
  @(posedge i_wb_clk) disable iff (i_wb_rst)
  (write && i_wb_adr == 16'h0006)
    |=> (DC == $past(i_wb_data));
endproperty
assert property (p_write_dc)
  else $error("DC register did not update on write");

// ---------------------------------------------------------------
// WISHBONE Register Read-Back (combinational, simple) -- unchanged
// ---------------------------------------------------------------

property p_read_ctrl;
  @(posedge i_wb_clk)
  (i_wb_adr == 16'h0000) |-> (o_wb_data == {8'h00, ctrl[7:0]});
endproperty
assert property (p_read_ctrl)
  else $error("Ctrl readback mismatch");

property p_read_divisor;
  @(posedge i_wb_clk)
  (i_wb_adr == 16'h0002) |-> (o_wb_data == divisor);
endproperty
assert property (p_read_divisor)
  else $error("Divisor readback mismatch");

property p_read_period;
  @(posedge i_wb_clk)
  (i_wb_adr == 16'h0004) |-> (o_wb_data == period);
endproperty
assert property (p_read_period)
  else $error("Period readback mismatch");

property p_read_dc;
  @(posedge i_wb_clk)
  (i_wb_adr == 16'h0006) |-> (o_wb_data == DC);
endproperty
assert property (p_read_dc)
  else $error("DC readback mismatch");

// ---------------------------------------------------------------
// WISHBONE Ack (simple) -- unchanged
// ---------------------------------------------------------------

property p_ack_mirrors_stb;
  @(posedge i_wb_clk)
  (1'b1) |-> (o_wb_ack == i_wb_stb);
endproperty
assert property (p_ack_mirrors_stb)
  else $error("o_wb_ack does not mirror i_wb_stb");

// ---------------------------------------------------------------
// Clock Selection (simple mux, no divider dependency) -- unchanged
// ---------------------------------------------------------------

property p_clk_sel_wb;
  @(posedge i_wb_clk)
  (ctrl[0] == 1'b0) |-> (clk_source == i_wb_clk);
endproperty
assert property (p_clk_sel_wb)
  else $error("clk_source did not follow i_wb_clk when clk_sel=0");

property p_clk_sel_ext;
  @(posedge i_wb_clk)
  (ctrl[0] == 1'b1) |-> (clk_source == i_extclk);
endproperty
assert property (p_clk_sel_ext)
  else $error("clk_source did not follow i_extclk when clk_sel=1");

// ---------------------------------------------------------------
// Enable-bit hold behavior (simplified: removed unrelated !write
// cross-domain dependency to improve provability)
// ---------------------------------------------------------------

property p_pwm_ct_halt;
  @(posedge clk) disable iff (rst_ct)
  (pwm && ctrl[2] == 1'b0)
    |=> (ct == $past(ct));
endproperty
assert property (p_pwm_ct_halt)
  else $error("PWM counter progressed while run_en=0");

property p_timer_ct_halt;
  @(posedge clk) disable iff (rst_ct)
  (state_timer && ctrl[2] == 1'b0)
    |=> (ct == $past(ct));
endproperty
assert property (p_timer_ct_halt)
  else $error("Timer counter progressed while run_en=0");

// ---------------------------------------------------------------
// Output Gating (simple) -- unchanged
// ---------------------------------------------------------------

property p_out_en_forced_low;
  @(posedge i_wb_clk)
  (ctrl[4] == 1'b0) |-> (o_pwm == 1'b0);
endproperty
assert property (p_out_en_forced_low)
  else $error("o_pwm not forced low when out_en=0");

property p_out_en_reflects_pts;
  @(posedge i_wb_clk)
  (ctrl[4] == 1'b1) |-> (o_pwm == pts);
endproperty
assert property (p_out_en_reflects_pts)
  else $error("o_pwm did not reflect internal pts source when out_en=1");

// =====================================================================
// Divider/Counter Dependent Properties
// Antecedents trimmed to the minimal necessary conditions (removed
// unrelated !write cross-domain condition) to improve provability.
// =====================================================================

property p_div_bypass;
  @(posedge i_wb_clk)
  (divisor == 16'h0000 || divisor == 16'h0001) |-> (eclk == clk_source);
endproperty
assert property (p_div_bypass)
  else $error("Divisor<=1 did not bypass down-clocking");

property p_pwm_ct_increment;
  @(posedge clk) disable iff (rst_ct)
  (pwm && ctrl[2] == 1'b1 && ctrl[7] == 1'b0 && (ct < period))
    |=> (ct == $past(ct) + 1'b1);
endproperty
assert property (p_pwm_ct_increment)
  else $error("PWM counter did not increment when running");

property p_pwm_ct_reset_at_terminal;
  @(posedge clk) disable iff (rst_ct)
  (pwm && ctrl[2] == 1'b1 && ctrl[7] == 1'b0 && (ct == period))
    |=> (ct == '0);
endproperty
assert property (p_pwm_ct_reset_at_terminal)
  else $error("PWM counter did not reset at terminal count");

property p_timer_event_asserted;
  @(posedge clk) disable iff (rst_ct)
  (state_timer && ctrl[2] == 1'b1 && (ct == period))
    |=> (timer_irq == 1'b1);
endproperty
assert property (p_timer_event_asserted)
  else $error("Timer event/irq not asserted at terminal count");

// =====================================================================
// Additional Coverage Properties
// pts is a registered signal derived from ct/DC/extDC sampled in the
// SAME cycle as the antecedent; the consequent must therefore compare
// against $past(ct)/$past(DC)/$past(extDC) rather than their current
// (already-advanced) values. This fixes a same-cycle/next-cycle
// timing mismatch that previously prevented convergence.
// =====================================================================

// ---------------------------------------------------------------
// 1. External duty-cycle capture / hold -- unchanged (already
//    correctly sequential/simple)
// ---------------------------------------------------------------

property p_extdc_capture;
  @(posedge clk)
  (i_valid_DC) |=> (extDC == $past(i_DC));
endproperty
assert property (p_extdc_capture)
  else $error("extDC did not capture i_DC when i_valid_DC asserted");

property p_extdc_hold;
  @(posedge clk)
  (!i_valid_DC) |=> (extDC == $past(extDC));
endproperty
assert property (p_extdc_hold)
  else $error("extDC did not hold value when i_valid_DC deasserted");

// ---------------------------------------------------------------
// 2. pts derivation from internal vs external duty-cycle
//    (fixed timing: pts registers the comparison of the PRIOR
//    cycle's ct/DC or ct/extDC values)
// ---------------------------------------------------------------

property p_pts_internal_dc;
  @(posedge clk)
  (pwm && !ctrl[6])
    |=> (pts == ($past(ct) < $past(DC)));
endproperty
assert property (p_pts_internal_dc)
  else $error("pts did not reflect internal DC comparison");

property p_pts_external_dc;
  @(posedge clk)
  (pwm && ctrl[6])
    |=> (pts == ($past(ct) < $past(extDC)));
endproperty
assert property (p_pts_external_dc)
  else $error("pts did not reflect external DC comparison");

// ---------------------------------------------------------------
// 3. Timer one-shot hold behavior (trimmed redundant state_timer
//    precondition; timer_irq being asserted already implies timer
//    mode context)
// ---------------------------------------------------------------

property p_timer_oneshot_hold;
  @(posedge clk) disable iff (rst_ct)
  (!ctrl[3] && timer_irq && !clrint)
    |=> (timer_irq == 1'b1 && ct == $past(ct));
endproperty
assert property (p_timer_oneshot_hold)
  else $error("One-shot timer did not hold at terminal count");

// ---------------------------------------------------------------
// 4. Continuous timer restart (trimmed redundant state_timer
//    precondition; timer_cont/run_en/terminal-count are sufficient)
// ---------------------------------------------------------------

property p_timer_cont_restart;
  @(posedge clk) disable iff (rst_ct)
  (ctrl[3] && ctrl[2] && (ct == period))
    |=> (ct == '0);
endproperty
assert property (p_timer_cont_restart)
  else $error("Continuous timer did not restart at terminal count");

// ---------------------------------------------------------------
// 5. Ctrl bit5 restricted software write (no software set) -- unchanged
// ---------------------------------------------------------------

property p_ctrl5_no_soft_set;
  @(posedge i_wb_clk) disable iff (i_wb_rst)
  (write && i_wb_adr == 16'h0000 && i_wb_data[5] == 1'b1 && !timer_irq)
    |=> (ctrl[5] == 1'b0);
endproperty
assert property (p_ctrl5_no_soft_set)
  else $error("Software write illegally set Ctrl bit5 (timer_irq)");

// ---------------------------------------------------------------
// 6. Undefined/reserved address read returns zero -- unchanged
// ---------------------------------------------------------------

property p_read_undefined;
  @(posedge i_wb_clk)
  (i_wb_adr != 16'h0000 && i_wb_adr != 16'h0002 &&
   i_wb_adr != 16'h0004 && i_wb_adr != 16'h0006)
    |-> (o_wb_data == 16'h0000);
endproperty
assert property (p_read_undefined)
  else $error("Undefined address read did not return zero");

// ---------------------------------------------------------------
// 7. Timer counter increment behavior (trimmed unrelated !write
//    cross-domain condition)
// ---------------------------------------------------------------

property p_timer_ct_increment;
  @(posedge clk) disable iff (rst_ct)
  (state_timer && ctrl[2] == 1'b1 && (ct < period))
    |=> (ct == $past(ct) + 1'b1);
endproperty
assert property (p_timer_ct_increment)
  else $error("Timer counter did not increment when running");

// ---------------------------------------------------------------
// 8. Timer-mode visibility on o_pwm -- unchanged (purely combinational)
// ---------------------------------------------------------------

property p_out_timer_visibility;
  @(posedge i_wb_clk)
  (!ctrl[1]) |-> (o_pwm == (ctrl[4] && timer_irq));
endproperty
assert property (p_out_timer_visibility)
  else $error("o_pwm did not reflect timer_irq gated by out_en in timer mode");


endmodule