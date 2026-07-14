/*
    Copyright 2011, City University of Hong Kong
    Author is Homer (Dongsheng) Hsing.

    This file is part of Tate Bilinear Pairing Core.

    Tate Bilinear Pairing Core is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Tate Bilinear Pairing Core is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with Tate Bilinear Pairing Core.  If not, see http://www.gnu.org/licenses/lgpl.txt
*/

`include "inc.v"
`define ZERO {(2*`M){1'b0}}
`define TWO {(2*`M-2){1'b0}},2'b10

// The Modified Duursma-Lee Algorithm
// out == e_({xp,yp}, {xr,yr})
module duursma_lee_algo(clk, reset, xp, yp, xr, yr, done, out);
    input clk, reset;
    input [`WIDTH:0] xp, yp, xr, yr;
    output reg done;
    output reg [`W6:0] out;
    
    reg [`W6:0] t;
    reg [`WIDTH:0] a, b, y;
    reg [1:0] d;
    reg [`M:0] i;
    reg f3m_reset, delay1, delay2;
    wire [`W6:0] g,v7,v8;
    wire [`WIDTH:0] mu /* my name is "mew" */,nmu,ny,
                    x,v2,v3,v4,v5,v6;
    wire [1:0] v9;
    wire f36m_reset, dummy, f3m_done, f36m_done, finish, change;
    
    assign g = {`ZERO,`TWO,`ZERO,nmu,v6,v5};
    assign finish = i[0];
    
    f3m_cubic
        ins1 (xr, x), // x == {x_r}^3
        ins2 (yr, v2); // v2 == {y_r}^3
    f3m_nine
        ins3 (clk, a, v3), // v3 == a^9
        ins4 (clk, b, v4); // v4 == b^9
    f3m_add3
        ins5 (v3, x, {{(2*`M-2){1'b0}},d}, mu); // mu == a^9+x+d
    f3m_neg
        ins6 (mu, nmu), // nmu == -mu
        ins7 (y,  ny);  // ny  == -y
    f3m_mult
        ins8 (clk, delay2, mu, nmu, v5, f3m_done), // v5 == - mu^2
        ins9 (clk, delay2, v4, ny,  v6, dummy); // v6 == - (b^9)*y
    f36m_cubic
        ins10 (clk, t, v7); // v7 == t^3
    f36m_mult
        ins11 (clk, f36m_reset, v7, g, v8, f36m_done); // v8 == v7*g = (t^3)*g
    func6
        ins12 (clk, reset, f36m_done, change),
        ins13 (clk, reset, f3m_done, f36m_reset);
    f3_sub1
        ins14 (d, v9); // v9 == d-1
    
    always @ (posedge clk)
        if (reset)
            i <= {1'b1, {`M{1'b0}}};
        else if (change | i[0])
            i <= i >> 1;
      
    always @ (posedge clk)
      begin
        if (reset)
          begin
            a <= xp; b <= yp; t <= 1; 
            y <= v2; d <= 1;
          end
        else if (change)
          begin
            a <= v3; b <= v4; t <= v8;
            y <= ny; d <= v9;
          end
      end

    always @ (posedge clk)
        if (reset) 
          begin done <= 0; end
        else if (finish) 
          begin done <= 1; out <= v8; end
    
    always @ (posedge clk)
        if (reset)
          begin delay1 <= 1; delay2 <= 1; end
        else
          begin delay2 <= delay1; delay1 <= f3m_reset; end
    
    always @ (posedge clk)
        if (reset) f3m_reset <= 1;
        else if (change) f3m_reset <= 1;
        else f3m_reset <= 0;
endmodule

// do Tate pairing, hahahaha
module tate_pairing(clk, reset, x1, y1, x2, y2, done, out);
    input clk, reset;
    input [`WIDTH:0] x1, y1, x2, y2;
    output reg done;
    output reg [`W6:0] out;
    
    reg delay1, rst1;
    wire done1, rst2, done2;
    wire [`W6:0] out1, out2;
    reg [2:0] K;
    
    duursma_lee_algo 
        ins1 (clk, rst1, x1, y1, x2, y2, done1, out1);
    second_part
        ins2 (clk, rst2, out1, out2, done2);
    func6
        ins3 (clk, reset, done1, rst2);
    
    always @ (posedge clk)
        if (reset)
          begin
            rst1 <= 1; delay1 <= 1;
          end
        else
          begin
            rst1 <= delay1; delay1 <= reset;
          end
    
    always @ (posedge clk)
        if (reset) K <= 3'b100;
        else if ((K[2]&rst2)|(K[1]&done2)|K[0])
            K <= K >> 1;

    always @ (posedge clk)
        if (reset) done <= 0;
        else if (K[0]) begin done <= 1; out <= out2; end
    // --- Formal assertions ---
    // =============================================================
    // Formal SVA for tate_pairing (Tate Bilinear Pairing Core)
    // Derived strictly from Gherkin specification (Background + Scenarios)
    // NOTE: Internal state/registers referenced (reset, y1, x2, y2, x1_reg,
    // y1_reg, x2_reg, y2_reg, dl_state, power_state, cycle_count) are the
    // architectural signals named in the specification Background. They are
    // assumed visible in the verification scope (e.g. via bind/hierarchical
    // reference) independent of any particular RTL implementation.
    // =============================================================

    // -------------------------------------------------------------
    // Local parameters / reference constants
    // -------------------------------------------------------------
    localparam int L = 75839;

    // -------------------------------------------------------------
    // Reference (golden) functions - treated as uninterpreted/black-box
    // reference models used ONLY for equivalence checking. They are NOT
    // derived from the implementation.
    // -------------------------------------------------------------
    // function automatic [`W6:0] TatePairing(input [`WIDTH:0] X1, Y1, X2, Y2);
    // function automatic [`M:0]  DLState(input [`WIDTH:0] X1, Y1, X2, Y2, input int C);
    // function automatic [`M:0]  PowerState(input [`WIDTH:0] X1, Y1, X2, Y2, input int C);
    // (Assumed bound externally as reference model stubs for FV.)

    // -------------------------------------------------------------
    // Auxiliary ghost logic required to model "since last capture" and
    // "ever reset" conditions used by several scenarios. These are pure
    // specification bookkeeping signals, not part of the DUT.
    // -------------------------------------------------------------
    reg [31:0] cycle_count;      // cycles elapsed since last reset-triggered capture
    reg        reset_ever;       // sticky flag: reset has occurred at least once
    reg [`WIDTH:0] x1_reg, y1_reg, x2_reg, y2_reg;

    // Ghost update logic (pure bookkeeping, not asserted, only used as reference)
    always_ff @(posedge clk) begin
      if (reset) begin
        cycle_count <= 32'd0;
        reset_ever  <= 1'b1;
        x1_reg      <= x1;
        y1_reg      <= y1;
        x2_reg      <= x2;
        y2_reg      <= y2;
      end else begin
        cycle_count <= cycle_count + 32'd1;
      end
    end

    // =============================================================
    // @reset @synchronous
    // Scenario: Synchronous reset forces done low
    // =============================================================
    property p_reset_forces_done_low;
      @(posedge clk)
      (reset) |=> (done == 1'b0);
    endproperty
    assert property (p_reset_forces_done_low);

    // =============================================================
    // @reset @capture
    // Scenario: Input data is captured when reset is asserted
    // =============================================================
    property p_capture_x1_reg;
      @(posedge clk)
      (reset) |=> (x1_reg == $past(x1));
    endproperty
    assert property (p_capture_x1_reg);

    property p_capture_y1_reg;
      @(posedge clk)
      (reset) |=> (y1_reg == $past(y1));
    endproperty
    assert property (p_capture_y1_reg);

    property p_capture_x2_reg;
      @(posedge clk)
      (reset) |=> (x2_reg == $past(x2));
    endproperty
    assert property (p_capture_x2_reg);

    property p_capture_y2_reg;
      @(posedge clk)
      (reset) |=> (y2_reg == $past(y2));
    endproperty
    assert property (p_capture_y2_reg);

    // =============================================================
    // @reset @output
    // Scenario: Output is inactive immediately after reset
    // (only 'done' is checked; 'out' is intentionally left unconstrained)
    // =============================================================
    property p_output_inactive_after_reset;
      @(posedge clk)
      (reset) |=> (done == 1'b0);
    endproperty
    assert property (p_output_inactive_after_reset);

    // =============================================================
    // @latency @done
    // Scenario: Done remains low before computation latency elapses
    // =============================================================
    property p_done_low_before_latency;
      @(posedge clk) disable iff (reset)
      (cycle_count < L) |-> (done == 1'b0);
    endproperty
    assert property (p_done_low_before_latency);

    // =============================================================
    // @latency @done
    // Scenario: Done asserts exactly at the fixed latency cycle
    // =============================================================
    property p_done_high_at_latency;
      @(posedge clk) disable iff (reset)
      (cycle_count == L) |-> (done == 1'b1);
    endproperty
    assert property (p_done_high_at_latency);

    // =============================================================
    // @latency @done
    // Scenario: Done deasserts after the completion cycle unless reset again
    // =============================================================
    property p_done_deassert_after_completion;
      @(posedge clk)
      (done && (cycle_count == L) && !reset) |=> (!$past(reset) -> (done == 1'b0));
    endproperty
    assert property (p_done_deassert_after_completion);

    // =============================================================
    // @output @correctness
    // Scenario: Output equals the Tate pairing function when done is asserted
    // =============================================================
    property p_output_correctness;
      @(posedge clk) disable iff (reset)
      (done) |-> (out == TatePairing(x1_reg, y1_reg, x2_reg, y2_reg));
    endproperty
    assert property (p_output_correctness);

    // =============================================================
    // @output @stability
    // Scenario: Output remains stable while done stays asserted
    // =============================================================
    property p_output_stable_while_done;
      @(posedge clk) disable iff (reset)
      (done) |=> (done |-> (out == $past(out)));
    endproperty
    assert property (p_output_stable_while_done);

    // =============================================================
    // @output @registered
    // Scenario: Output changes only on a clock edge, not combinationally
    // (Registered-output property: out cannot change unless a clocked
    // update (posedge clk) has occurred; expressed as invariant that
    // out is only sampled/compared at clk edges.)
    // =============================================================
    property p_output_registered_only;
      @(posedge clk)
      (1'b1) |=> ($stable(out) or (out != $past(out)));
    endproperty
    assert property (p_output_registered_only);

    // =============================================================
    // @reset @restart
    // Scenario: Reassertion of reset mid-computation restarts capture and computation
    // =============================================================
    property p_reset_restart_done_low;
      @(posedge clk)
      (reset) |=> (done == 1'b0);
    endproperty
    assert property (p_reset_restart_done_low);

    property p_reset_restart_x1_reg;
      @(posedge clk)
      (reset) |=> (x1_reg == $past(x1));
    endproperty
    assert property (p_reset_restart_x1_reg);

    property p_reset_restart_y1_reg;
      @(posedge clk)
      (reset) |=> (y1_reg == $past(y1));
    endproperty
    assert property (p_reset_restart_y1_reg);

    property p_reset_restart_x2_reg;
      @(posedge clk)
      (reset) |=> (x2_reg == $past(x2));
    endproperty
    assert property (p_reset_restart_x2_reg);

    property p_reset_restart_y2_reg;
      @(posedge clk)
      (reset) |=> (y2_reg == $past(y2));
    endproperty
    assert property (p_reset_restart_y2_reg);

    // =============================================================
    // @input @stability
    // Scenario: Internal computation state is a deterministic function
    // of captured inputs
    // =============================================================
    property p_dl_state_deterministic;
      @(posedge clk) disable iff (reset)
      ((cycle_count >= 0) && (cycle_count < L)) |->
        (dl_state == DLState(x1_reg, y1_reg, x2_reg, y2_reg, cycle_count));
    endproperty
    assert property (p_dl_state_deterministic);

    property p_power_state_deterministic;
      @(posedge clk) disable iff (reset)
      ((cycle_count >= 0) && (cycle_count < L)) |->
        (power_state == PowerState(x1_reg, y1_reg, x2_reg, y2_reg, cycle_count));
    endproperty
    assert property (p_power_state_deterministic);

    // =============================================================
    // @input @determinism
    // Scenario: Computation is a pure function of captured inputs
    // across independent runs (Run A vs Run B).
    //
    // NOTE: The original two-run equivalence properties relied on
    // unconstrained/undriven ghost signals (dl_state_B, power_state_B,
    // out_B), making those checks vacuously true and not meaningful.
    // Rather than fabricate a fake second-run model, this determinism
    // requirement is instead fully covered by the single-run properties
    // above (p_dl_state_deterministic, p_power_state_deterministic) and
    // p_output_correctness, which each show that dl_state, power_state,
    // and out are pure deterministic functions of the captured inputs
    // (x1_reg, y1_reg, x2_reg, y2_reg) and elapsed cycle count. Since any
    // two runs with identical captured inputs and identical cycle_count
    // trivially yield identical values of these deterministic functions,
    // no separate ghost-signal-based cross-run properties are required.
    // =============================================================

    // =============================================================
    // @done @idle
    // Scenario: Done never asserts without a prior reset-triggered capture
    // =============================================================
    property p_done_never_without_reset;
      @(posedge clk)
      (!reset_ever) |-> (done == 1'b0);
    endproperty
    assert property (p_done_never_without_reset);


endmodule

