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
    // AssertionForge baseline SVA for pairing
    // 130 assertions captured from gen_plan.generate_svas

    property af_p0;
    @(posedge clk) (!done) |-> ($stable(xp));
    endproperty
    assert property(af_p0);

    property af_p1;
    @(posedge clk) (!done) |-> ($stable(xp) && !$isunknown(xp));
    endproperty
    assert property(af_p1);

    property af_p2;
    @(posedge clk) ($past(done)) |-> (!$isunknown(out)) else (!done |-> $isunknown(out));
    endproperty
    assert property(af_p2);

    property af_p3;
    @(posedge clk) (done) |=> ($stable(out) && !$isunknown(out));
    endproperty
    assert property(af_p3);

    property af_p4;
    @(posedge clk) (done) |=> (!$isunknown(out));
    endproperty
    assert property(af_p4);

    property af_p5;
    @(posedge clk) (!done) |=> (!$isunknown(x1) && !$isunknown(xp) && $stable(x1) && $stable(xp));
    endproperty
    assert property(af_p5);

    property af_p6;
    @(posedge clk) (!done) |-> ($stable(x1) && $stable(xp));
    endproperty
    assert property(af_p6);

    property af_p7;
    @(posedge clk) (done) |=> (out == expected_out);
    endproperty
    assert property(af_p7);

    property af_p8;
    @(posedge clk) (!done) |-> ($stable(x1));
    endproperty
    assert property(af_p8);

    property af_p9;
    @(posedge clk) (done) |-> (!$isunknown(out));
    endproperty
    assert property(af_p9);

    property af_p10;
    @(posedge clk) ((x1 >= 0) && (x1 <= MAX_VALID_X1)) |-> ##1 ((x1 >= 0) && (x1 <= MAX_VALID_X1));
    endproperty
    assert property(af_p10);

    property af_p11;
    @(posedge clk) (!done) |-> (out == $past(out));
    endproperty
    assert property(af_p11);

    property af_p12;
    @(posedge clk) (!done) |-> $stable(x1);
    endproperty
    assert property(af_p12);

    property af_p13;
    @(posedge clk) (!done) |-> $stable(xp);
    endproperty
    assert property(af_p13);

    property af_p14;
    @(posedge clk) (done) |-> ($past(clk) === 1'b0 && clk === 1'b1);
    endproperty
    assert property(af_p14);

    property af_p15;
    @(posedge clk) ($rose(done)) |-> (!$isunknown(out));
    endproperty
    assert property(af_p15);

    property af_p16;
    @(posedge clk) $changed(x1) |=> $stable(x1);
    endproperty
    assert property(af_p16);

    property af_p17;
    @(posedge clk) done |=> (1'b1);
    endproperty
    assert property(af_p17);

    property af_p18;
    @(posedge clk) done |-> ##1 $stable(out);
    endproperty
    assert property(af_p18);

    property af_p19;
    @(posedge clk) (!done) |=> $stable(x1);
    endproperty
    assert property(af_p19);

    property af_p20;
    @(posedge clk) (!done) |=> ($stable(x1) && $stable(xp));
    endproperty
    assert property(af_p20);

    property af_p21;
    @(posedge clk) (!done) |-> (out == '0);
    endproperty
    assert property(af_p21);

    property af_p22;
    @(posedge clk) done |-> ($stable(x1) && $stable(xp));
    endproperty
    assert property(af_p22);

    property af_p23;
    @(posedge clk) $changed(out) |-> done;
    endproperty
    assert property(af_p23);

    property af_p24;
    @(posedge clk) ($rose(x1)) |-> (!done)[*4];
    endproperty
    assert property(af_p24);

    property af_p25;
    @(posedge clk) (done) |=> $stable(out);
    endproperty
    assert property(af_p25);

    property af_p26;
    @(posedge clk) (!done) |-> (out === 'x || $stable(out) == 0 || 1'b1);
    endproperty
    assert property(af_p26);

    property af_p27;
    @(posedge clk) (done && !$past(done)) |-> ##1 (!done) until_with (reset);
    endproperty
    assert property(af_p27);

    property af_p28;
    @(posedge clk) (done) |-> $rose(done);
    endproperty
    assert property(af_p28);

    property af_p29;
    @(posedge clk) (!done) |=> ($stable(out) throughout (!done)[*1:$]);
    endproperty
    assert property(af_p29);

    property af_p30;
    @(posedge clk) ($stable(x1) && $stable(xp))[*3] |-> ##[1:$] (done);
    endproperty
    assert property(af_p30);

    property af_p31;
    @(posedge clk) (done) |=> (!$stable(out));
    endproperty
    assert property(af_p31);

    property af_p32;
    @(posedge clk) (!done) |=> (!done)[*3];
    endproperty
    assert property(af_p32);

    property af_p33;
    @(posedge clk) ($rose(done)) |-> (done)[*1];
    endproperty
    assert property(af_p33);

    property af_p34;
    @(posedge clk) !done |-> ($stable(x1) && $stable(xp));
    endproperty
    assert property(af_p34);

    property af_p35;
    @(posedge clk) done |-> (!$isunknown(out)) ##1 $stable(out);
    endproperty
    assert property(af_p35);

    property af_p36;
    @(posedge clk) ($stable(x1) && $stable(xp)) |-> $stable(done);
    endproperty
    assert property(af_p36);

    property af_p37;
    @(posedge clk) $rose(done) |=> $stable(out);
    endproperty
    assert property(af_p37);

    property af_p38;
    @(posedge clk) $rose(reset) |-> (!done)[*1:$] ##1 done;
    endproperty
    assert property(af_p38);

    property af_p39;
    @(posedge clk) done |-> $stable(out);
    endproperty
    assert property(af_p39);

    property af_p40;
    @(posedge clk) $fell(done) |=> $stable(out);
    endproperty
    assert property(af_p40);

    property af_p41;
    @(posedge clk) $rose(done) |-> !$isunknown(out);
    endproperty
    assert property(af_p41);

    property af_p42;
    @(posedge clk) $rose(reset) |-> (!done)[*3:$] ##1 1'b1;
    endproperty
    assert property(af_p42);

    property af_p43;
    @(posedge clk) done |-> ($stable(x1) && $stable(xp))[*10];
    endproperty
    assert property(af_p43);

    property af_p44;
    @(posedge clk) (!done) |-> (out === 'x) && ($rose(done) |-> (out !== 'x));
    endproperty
    assert property(af_p44);

    property af_p45;
    @(posedge clk) $rose(done) |-> (out !== 'x) && $stable(out);
    endproperty
    assert property(af_p45);

    property af_p46;
    @(posedge clk) (!done) |-> (out === $past(out));
    endproperty
    assert property(af_p46);

    property af_p47;
    @(posedge clk) $rose(done) |-> (done ##1 !done);
    endproperty
    assert property(af_p47);

    property af_p48;
    @(posedge clk) (done && $stable(x1) && $stable(xp)) |-> ##0 (x1 === $past(x1,10)) && (xp === $past(xp,10));
    endproperty
    assert property(af_p48);

    property af_p49;
    @(posedge clk) $rose(done) |-> ##1 $stable(done) throughout (##[1:1] 1);
    endproperty
    assert property(af_p49);

    property af_p50;
    @(posedge clk) (!done) |-> !done[*2];
    endproperty
    assert property(af_p50);

    property af_p51;
    @(posedge clk) ($changed(x1) || $changed(xp)) |-> (!done)[*10];
    endproperty
    assert property(af_p51);

    property af_p52;
    @(posedge clk) ($changed(x1) || $changed(xp)) |-> ##1 (out == $past(out));
    endproperty
    assert property(af_p52);

    property af_p53;
    @(posedge clk) $rose(done) |=> $stable(out);
    endproperty
    assert property(af_p53);

    property af_p54;
    @(posedge clk) !done |-> $stable(out);
    endproperty
    assert property(af_p54);

    property af_p55;
    @(posedge clk) done |=> $stable(out);
    endproperty
    assert property(af_p55);

    property af_p56;
    @(posedge clk) !done |=> $stable(out);
    endproperty
    assert property(af_p56);

    property af_p57;
    @(posedge clk) done |-> !$isunknown(out);
    endproperty
    assert property(af_p57);

    property af_p58;
    @(posedge clk) !done |-> ($isunknown(out) || $stable(out));
    endproperty
    assert property(af_p58);

    property af_p59;
    @(posedge clk) $rose(done) |-> ##1 $stable(out);
    endproperty
    assert property(af_p59);

    property af_p60;
    @(posedge clk) $rose(done) |-> $stable(out);
    endproperty
    assert property(af_p60);

    property af_p61;
    @(posedge clk) ($changed(x1) || $changed(xp)) |-> $stable(out);
    endproperty
    assert property(af_p61);

    property af_p62;
    @(posedge clk) (!done) |-> $stable(out);
    endproperty
    assert property(af_p62);

    property af_p63;
    @(posedge clk) ($changed(x1) || $changed(xp)) |-> ##1 !done;
    endproperty
    assert property(af_p63);

    property af_p64;
    @(posedge clk) ($fell(done)) |-> (out == $past(out)) until ($rose(done));
    endproperty
    assert property(af_p64);

    property af_p65;
    @(posedge clk) (($changed(x1) || $changed(xp)) && !done) |-> $stable(out);
    endproperty
    assert property(af_p65);

    property af_p66;
    @(posedge clk) ($fell(done)) |-> (out == $past(out)) until (done);
    endproperty
    assert property(af_p66);

    property af_p67;
    @(posedge clk) (done && $past(done)) |-> $stable(out);
    endproperty
    assert property(af_p67);

    property af_p68;
    @(posedge clk) disable iff (!done) (!$isunknown(out));
    endproperty
    assert property(af_p68);

    property af_p69;
    @(posedge clk) ($rose(done)) |-> (!$isunknown(out));
    endproperty
    assert property(af_p69);

    property af_p70;
    @(posedge clk) ($rose(done)) |=> ($stable(out) throughout (!$rose(done)[->1]));
    endproperty
    assert property(af_p70);

    property af_p71;
    @(posedge clk) (done throughout (##[1:$] done)) |-> ($stable(out));
    endproperty
    assert property(af_p71);

    property af_p72;
    @(posedge clk) (done && $past(done) [*2]) |-> ($stable(out));
    endproperty
    assert property(af_p72);

    property af_p73;
    @(posedge clk) (1'b1) |-> ($stable(out) || $changed(out));
    endproperty
    assert property(af_p73);

    property af_p74;
    @(posedge clk) ($rose(done)) |-> (out == $past(out)) throughout (done[->1]);
    endproperty
    assert property(af_p74);

    property af_p75;
    @(posedge clk) (1'b1) |-> (out == $past(out)) || ($changed(out) ##0 $past(done) != done);
    endproperty
    assert property(af_p75);

    property af_p76;
    @(posedge clk) ($fell(done)) |-> (out == $past(out));
    endproperty
    assert property(af_p76);

    property af_p77;
    @(posedge clk) ($rose(done)) |-> ($stable(out) throughout (done[->1]));
    endproperty
    assert property(af_p77);

    property af_p78;
    @(posedge clk) (!done) |-> ($stable(out));
    endproperty
    assert property(af_p78);

    property af_p79;
    @(posedge clk) (done && $past(done)) |-> ($stable(out));
    endproperty
    assert property(af_p79);

    property af_p80;
    @(posedge clk) (!done) |-> $stable(x1);
    endproperty
    assert property(af_p80);

    property af_p81;
    @(posedge clk) (x1 inside {[0:(2**194)-1]}) |-> ((done inside {1'b0,1'b1}) && (out inside {[0:(2**194)-1]}));
    endproperty
    assert property(af_p81);

    property af_p82;
    @(posedge clk) (x1 inside {[0:(2**194)-1]}) |-> (done throughout (##[1:$] !done));
    endproperty
    assert property(af_p82);

    property af_p83;
    @(posedge clk) ($stable(x1) && $stable(xp)) |-> ##1 (1);
    endproperty
    assert property(af_p83);

    property af_p84;
    @(posedge clk) (x1 >= 0 && x1 <= (2**193)-1) |=> (x1 >= 0 && x1 <= (2**194)-1);
    endproperty
    assert property(af_p84);

    property af_p85;
    @(posedge clk) $changed(x1) |-> $stable(out);
    endproperty
    assert property(af_p85);

    property af_p86;
    @(posedge clk) (!reset) |-> (x1 inside {[0:(2**194)-1]}) until (done);
    endproperty
    assert property(af_p86);

    property af_p87;
    @(posedge clk) $rose(done) |-> $stable(x1);
    endproperty
    assert property(af_p87);

    property af_p88;
    @(posedge clk) ($stable(x1) && !done) |-> $stable(out);
    endproperty
    assert property(af_p88);

    property af_p89;
    @(posedge clk) ($changed(x1) && !done) |-> ##1 $stable(out);
    endproperty
    assert property(af_p89);

    property af_p90;
    @(posedge clk) ($stable(x1) throughout (!done)[*1:$]) |-> (done |-> (xp == x1));
    endproperty
    assert property(af_p90);

    property af_p91;
    @(posedge clk) ($changed(x1) && !done) |-> ($stable(out));
    endproperty
    assert property(af_p91);

    property af_p92;
    @(posedge clk) ($rose(done)) |-> (xp == $past(x1));
    endproperty
    assert property(af_p92);

    property af_p93;
    @(posedge clk) $rose(done) |-> ##[1:5] (xp == x1);
    endproperty
    assert property(af_p93);

    property af_p94;
    @(posedge clk) ((x1 >= (194'd1 << 190)) && (x1 <= (194'd1 << 194) - 1)) |=> ((x1 >= (194'd1 << 189)) && (x1 <= (194'd1 << 194) - 1));
    endproperty
    assert property(af_p94);

    property af_p95;
    @(posedge clk) $stable(x1);
    endproperty
    assert property(af_p95);

    property af_p96;
    @(posedge clk) ((x1 >= 194'd0) && (x1 <= (194'd1 << 194) - 1) && done) |-> ((xp >= 194'd0) && (xp <= (194'd1 << 194) - 1));
    endproperty
    assert property(af_p96);

    property af_p97;
    @(posedge clk) $rose(done) |-> ##3 ((x1 >= 194'd0) && (x1 <= (194'd1 << 194) - 1));
    endproperty
    assert property(af_p97);

    property af_p98;
    @(posedge clk) (out != $past(out)) |-> ($past(x1) != x1);
    endproperty
    assert property(af_p98);

    property af_p99;
    @(posedge clk) ($past(!done,4)) |-> ((x1 >= 0) && (x1 <= (2**194 - 1)));
    endproperty
    assert property(af_p99);

    property af_p100;
    @(posedge clk) ($rose(done)) |-> ($past(x1,1) == $past(x1,2));
    endproperty
    assert property(af_p100);

    property af_p101;
    @(posedge clk) (!done && $stable(x1)) |-> (!done throughout ($stable(x1) until_with done));
    endproperty
    assert property(af_p101);

    property af_p102;
    @(posedge clk) disable iff (done) $stable(x1);
    endproperty
    assert property(af_p102);

    property af_p103;
    @(posedge clk) (done) |-> (out == $past(x1, 1));
    endproperty
    assert property(af_p103);

    property af_p104;
    @(posedge clk) (done) |-> ($past(x1) == x1);
    endproperty
    assert property(af_p104);

    property af_p105;
    @(posedge clk) (!done) |-> ($stable(x1) && (x1 >= 0) && (x1 <= (2**194 - 1)));
    endproperty
    assert property(af_p105);

    property af_p106;
    @(posedge clk) ($changed(x1)) |-> ##1 $changed(xp);
    endproperty
    assert property(af_p106);

    property af_p107;
    @(posedge clk) (done) |-> $stable(xp);
    endproperty
    assert property(af_p107);

    property af_p108;
    @(posedge clk) (done) |-> (out == xp);
    endproperty
    assert property(af_p108);

    property af_p109;
    @(posedge clk) ($rose(done)) |-> $stable(xp);
    endproperty
    assert property(af_p109);

    property af_p110;
    @(posedge clk) (!done) |-> $stable(xp);
    endproperty
    assert property(af_p110);

    property af_p111;
    @(posedge clk) (xp == x1) |-> ($stable(xp) && $stable(x1));
    endproperty
    assert property(af_p111);

    property af_p112;
    @(posedge clk) ($changed(x1)) |-> ##[1:20] (done && $stable(xp));
    endproperty
    assert property(af_p112);

    property af_p113;
    @(posedge clk) ($rose(done) && $changed(xp)) |-> ##1 !done;
    endproperty
    assert property(af_p113);

    property af_p114;
    @(posedge clk) ($changed(xp)) |=> $stable(xp) throughout (!done)[*1:$];
    endproperty
    assert property(af_p114);

    property af_p115;
    @(posedge clk) ($changed(xp)) |=> !done throughout (xp == $past(xp))[*1:$];
    endproperty
    assert property(af_p115);

    property af_p116;
    @(posedge clk) ($stable(xp) && $changed(x1)) |-> (!done |-> $stable(out)) and (done |-> (out == xp));
    endproperty
    assert property(af_p116);

    property af_p117;
    @(posedge clk) ($rose(done)) |-> (out == $past(xp));
    endproperty
    assert property(af_p117);

    property af_p118;
    @(posedge clk) ($stable(xp)[*5]) |-> ##[1:$] (done && (out == xp));
    endproperty
    assert property(af_p118);

    property af_p119;
    @(posedge clk) ($rose(done) && $past(x1) != x1) |=> ($past(xp,1) != xp);
    endproperty
    assert property(af_p119);

    property af_p120;
    @(posedge clk) ($rose(xp) && xp != 'bx) |-> (xp throughout (!done)[*1:$] );
    endproperty
    assert property(af_p120);

    property af_p121;
    @(posedge clk) (!done) |-> ($stable(xp) && $stable(x1)) throughout (!done)[*1:$];
    endproperty
    assert property(af_p121);

    property af_p122;
    @(posedge clk) ($rose(done)) |-> ($stable(xp) throughout ##[1:$] $changed(x1));
    endproperty
    assert property(af_p122);

    property af_p123;
    @(posedge clk) ($rose(done)) |-> (out == xp);
    endproperty
    assert property(af_p123);

    property af_p124;
    @(posedge clk) (done) |-> (out == (xp ^ x1));
    endproperty
    assert property(af_p124);

    property af_p125;
    @(posedge clk) (!done) |-> ##1 $stable(xp);
    endproperty
    assert property(af_p125);

    property af_p126;
    @(posedge clk) (!done) |-> (xp == '0);
    endproperty
    assert property(af_p126);

    property af_p127;
    @(posedge clk) ((!done) && !$isunknown(xp) && !$isunknown(x1)) |-> (done throughout (!done)[*0:$]) ##1 $rose(done) |-> !$isunknown(out);
    endproperty
    assert property(af_p127);

    property af_p128;
    @(posedge clk) ($initstate && !done) |-> !$isunknown(xp);
    endproperty
    assert property(af_p128);

    property af_p129;
    @(posedge clk) ($stable(x1) && !done) |-> ##3 (xp == expected_result(x1));
    endproperty
    assert property(af_p129);




endmodule

