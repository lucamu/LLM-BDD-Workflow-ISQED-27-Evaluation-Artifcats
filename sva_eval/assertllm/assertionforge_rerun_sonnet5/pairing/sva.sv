// AssertionForge baseline SVA for ting_pairing
// 317 assertions captured from gen_plan.generate_svas

property af_p0;
@(posedge clk) $fell(reset) |-> ##1 (addr >= 0) && (addr <= 63);
endproperty
assert property(af_p0);

property af_p1;
@(posedge clk) (ready) |-> (addr >= 0) && (addr <= 63);
endproperty
assert property(af_p1);

property af_p2;
@(posedge clk) $rose(ready) |-> ((addr >= 0) && (addr <= 63)) ##1 ((addr >= 0) && (addr <= 63));
endproperty
assert property(af_p2);

property af_p3;
@(posedge clk) (!sel && !w) |-> (addr >= 0) && (addr <= 63);
endproperty
assert property(af_p3);

property af_p4;
@(posedge clk) $fell(reset) |-> ##3 (addr >= 0) && (addr <= 63);
endproperty
assert property(af_p4);

property af_p5;
@(posedge clk) (done) |-> (addr >= 0) && (addr <= 63);
endproperty
assert property(af_p5);

property af_p6;
@(posedge clk) (sel && !update) |-> (addr == $past(addr));
endproperty
assert property(af_p6);

property af_p7;
@(posedge clk) $fell(reset) |-> ##2 (addr >= 0) && (addr <= 63);
endproperty
assert property(af_p7);

property af_p8;
@(posedge clk) (sel && w) |-> (addr >= 0) && (addr <= 63);
endproperty
assert property(af_p8);

property af_p9;
@(posedge clk) $rose(sel) |-> (addr >= 0) && (addr <= 63);
endproperty
assert property(af_p9);

property af_p10;
@(posedge clk) (!reset) |-> (addr >= 0) && (addr <= 63);
endproperty
assert property(af_p10);

property af_p11;
@(posedge clk) (!ready) |-> $stable(addr);
endproperty
assert property(af_p11);

property af_p12;
@(posedge clk) (!reset) |-> ((addr >= 0) && (addr <= 63));
endproperty
assert property(af_p12);

property af_p13;
@(posedge clk) reset |-> ##1 (!$isunknown(addr) && (addr >= 0) && (addr <= 63));
endproperty
assert property(af_p13);

property af_p14;
@(posedge clk) (sel && $past(sel)) |-> ($stable(addr) && (addr >= 0) && (addr <= 63));
endproperty
assert property(af_p14);

property af_p15;
@(posedge clk) $rose(sel) |=> ((addr >= 0) && (addr <= 63));
endproperty
assert property(af_p15);

property af_p16;
@(posedge clk) ((addr >= 0) && (addr <= 63));
endproperty
assert property(af_p16);

property af_p17;
@(posedge clk) ((addr >= 10) && (addr <= 20)) |-> ##1 ((addr >= 0) && (addr <= 63));
endproperty
assert property(af_p17);

property af_p18;
@(posedge clk) (w) |-> ((addr >= 0) && (addr <= 63));
endproperty
assert property(af_p18);

property af_p19;
@(posedge clk) $fell(reset) |-> ##3 ((addr >= 0) && (addr <= 63));
endproperty
assert property(af_p19);

property af_p20;
@(posedge clk) reset |=> ($stable(addr) && (addr >= 0) && (addr <= 63));
endproperty
assert property(af_p20);

property af_p21;
@(posedge clk) (sel) |-> ##[1:2] ((addr >= 0) && (addr <= 63))[*2];
endproperty
assert property(af_p21);

property af_p22;
@(posedge clk) (update) |-> (addr >= 0) && (addr <= 63);
endproperty
assert property(af_p22);

property af_p23;
@(posedge clk) ((addr >= 0) && (addr <= 31)) |=> (addr >= 0) && (addr <= 63);
endproperty
assert property(af_p23);

property af_p24;
@(posedge clk) (sel) |-> ($stable(addr) && (addr >= 0) && (addr <= 63));
endproperty
assert property(af_p24);

property af_p25;
@(posedge clk) ((!w) && (addr >= 0) && (addr <= 31)) |=> (addr >= 0) && (addr <= 63);
endproperty
assert property(af_p25);

property af_p26;
@(posedge clk) (w) |-> (addr >= 0) && (addr <= 63);
endproperty
assert property(af_p26);

property af_p27;
@(posedge clk) ($fell(reset)) |-> ##4 ($stable(addr) && (addr >= 0) && (addr <= 63));
endproperty
assert property(af_p27);

property af_p28;
@(posedge clk) ((!w) && sel && (addr >= 0) && (addr <= 31)) |=> (addr >= 0) && (addr <= 63);
endproperty
assert property(af_p28);

property af_p29;
@(posedge clk) (sel) |=> ((addr >= 0) && (addr <= 63));
endproperty
assert property(af_p29);

property af_p30;
@(posedge clk) ($fell(reset)) |-> ##4 ((addr >= 0) && (addr <= 63));
endproperty
assert property(af_p30);

property af_p31;
@(posedge clk) (sel && w) |-> ##1 $stable(o);
endproperty
assert property(af_p31);

property af_p32;
@(posedge clk) reset |-> ##1 (ready == 1'b0 && done == 1'b0 && o == '0);
endproperty
assert property(af_p32);

property af_p33;
@(posedge clk) 1'b1 |-> ##1 $stable(ready);
endproperty
assert property(af_p33);

property af_p34;
@(posedge clk) update |-> ##1 $changed(o);
endproperty
assert property(af_p34);

property af_p35;
@(posedge clk) $changed({sel, addr, w, update}) |-> ##1 $stable({sel, addr, w, update});
endproperty
assert property(af_p35);

property af_p36;
@(posedge clk) reset |-> ##1 ($stable(ready) && $stable(done));
endproperty
assert property(af_p36);

property af_p37;
@(posedge clk) update |-> ##1 $changed(ready);
endproperty
assert property(af_p37);

property af_p38;
@(posedge clk) 1'b1 |-> ##1 $stable({reset, sel, addr, w, update, i});
endproperty
assert property(af_p38);

property af_p39;
@(posedge clk) 1'b1 |-> $stable({o, ready, done});
endproperty
assert property(af_p39);

property af_p40;
@(posedge clk) $changed({sel, addr}) |-> ##1 (sel == $past(sel)) && (addr == $past(addr));
endproperty
assert property(af_p40);

property af_p41;
@(posedge clk) (sel && w) |-> ##[1:$] done;
endproperty
assert property(af_p41);

property af_p42;
@(posedge clk) 1'b1 |-> $stable({sel, addr, w, update});
endproperty
assert property(af_p42);

property af_p43;
@(posedge clk) (sel && w) |-> ##0 (sel && w);
endproperty
assert property(af_p43);

property af_p44;
@(posedge clk) 1'b1 |-> $stable({addr, i});
endproperty
assert property(af_p44);

property af_p45;
@(posedge clk) (!reset) |-> ($changed(done) || $changed(ready)) -> ($changed(sel) || $changed(w) || $changed(update));
endproperty
assert property(af_p45);

property af_p46;
@(posedge clk) 1'b1 |-> ##1 $stable(o);
endproperty
assert property(af_p46);

property af_p47;
@(posedge clk) $fell(reset) |-> ##1 $stable({sel, addr, w});
endproperty
assert property(af_p47);

property af_p48;
@(posedge clk) reset |=> (done == 1'b0) && (ready == 1'b0) && (o == '0);
endproperty
assert property(af_p48);

property af_p49;
@(posedge clk) 1'b1 |-> (w === $sampled(w));
endproperty
assert property(af_p49);

property af_p50;
@(posedge clk) ($stable(reset) && $stable(sel) && $stable(addr) && $stable(w) && $stable(update) && $stable(i)) |-> $stable(done);
endproperty
assert property(af_p50);

property af_p51;
@(posedge clk) (sel && w) |=> (o == $past(i));
endproperty
assert property(af_p51);

property af_p52;
@(posedge clk) update |=> $changed(o);
endproperty
assert property(af_p52);

property af_p53;
@(posedge clk) reset |-> (ready == 1'b0) && (done == 1'b0) && (o == '0);
endproperty
assert property(af_p53);

property af_p54;
@(posedge clk) $fell(reset) |=> (!$isunknown(ready) && !$isunknown(done));
endproperty
assert property(af_p54);

property af_p55;
@(posedge clk) 1'b1 |-> ##0 ((sel === $sampled(sel)) && (addr === $sampled(addr)) && (w === $sampled(w)) && (update === $sampled(update)));
endproperty
assert property(af_p55);

property af_p56;
@(posedge clk) update |=> (ready == 1'b1);
endproperty
assert property(af_p56);

property af_p57;
@(posedge clk) $rose(reset) |=> !done;
endproperty
assert property(af_p57);

property af_p58;
@(posedge clk) (!done) |-> (!ready);
endproperty
assert property(af_p58);

property af_p59;
@(posedge clk) $rose(done) |-> ($isunknown(o)===0) && $stable(o);
endproperty
assert property(af_p59);

property af_p60;
@(posedge clk) $fell(reset) |-> !done ##1 !done ##1 !done;
endproperty
assert property(af_p60);

property af_p61;
@(posedge clk) ($isunknown(o)===0) |-> done;
endproperty
assert property(af_p61);

property af_p62;
@(posedge clk) reset |=> !done ##1 !done;
endproperty
assert property(af_p62);

property af_p63;
@(posedge clk) reset |=> !done;
endproperty
assert property(af_p63);

property af_p64;
@(posedge clk) $fell(reset) |-> !done ##1 !done ##1 !done ##1 !done;
endproperty
assert property(af_p64);

property af_p65;
@(posedge clk) reset |-> !done;
endproperty
assert property(af_p65);

property af_p66;
@(posedge clk) $stable(o) && $isunknown(o)===0 |-> done;
endproperty
assert property(af_p66);

property af_p67;
@(posedge clk) ((!w) && ($isunknown(addr)===0)) |-> $past(done, 1) || done;
endproperty
assert property(af_p67);

property af_p68;
@(posedge clk) (reset) |-> !done;
endproperty
assert property(af_p68);

property af_p69;
@(posedge clk) ($fell(reset)) |-> !done ##1 !done;
endproperty
assert property(af_p69);

property af_p70;
@(posedge clk) (update && !done) |-> !done;
endproperty
assert property(af_p70);

property af_p71;
@(posedge clk) (!reset && !done) |-> !done;
endproperty
assert property(af_p71);

property af_p72;
@(posedge clk) (done && !reset) |=> done;
endproperty
assert property(af_p72);

property af_p73;
@(posedge clk) (done) |-> (ready or ##1 ready);
endproperty
assert property(af_p73);

property af_p74;
@(posedge clk) (!ready) |-> !done;
endproperty
assert property(af_p74);

property af_p75;
@(posedge clk) (done) |-> ##1 done;
endproperty
assert property(af_p75);

property af_p76;
@(posedge clk) ($fell(reset)) |-> !done;
endproperty
assert property(af_p76);

property af_p77;
@(posedge clk) !(ready && done);
endproperty
assert property(af_p77);

property af_p78;
@(posedge clk) (update && done) |=> $stable(o);
endproperty
assert property(af_p78);

property af_p79;
@(posedge clk) $rose(done) |=> (done until reset);
endproperty
assert property(af_p79);

property af_p80;
@(posedge clk) $fell(reset) |-> ((!done) until done);
endproperty
assert property(af_p80);

property af_p81;
@(posedge clk) done |-> ##1 (done || reset);
endproperty
assert property(af_p81);

property af_p82;
@(posedge clk) (w) |-> !done;
endproperty
assert property(af_p82);

property af_p83;
@(posedge clk) (ready && done) |-> !(addr == sel);
endproperty
assert property(af_p83);

property af_p84;
@(posedge clk) $fell(reset) |-> (!done)[*3];
endproperty
assert property(af_p84);

property af_p85;
@(posedge clk) $rose(done) |=> done;
endproperty
assert property(af_p85);

property af_p86;
@(posedge clk) $rose(done) |-> $stable(o) ##1 $stable(o);
endproperty
assert property(af_p86);

property af_p87;
@(posedge clk) $rose(done) |-> (done until reset);
endproperty
assert property(af_p87);

property af_p88;
@(posedge clk) $fell(reset) |-> !done;
endproperty
assert property(af_p88);

property af_p89;
@(posedge clk) (update) |-> ((i >= 10) && (i <= 245));
endproperty
assert property(af_p89);

property af_p90;
@(posedge clk) ((i >= 50) && (i <= 75)) |-> ((i >= 30) && (i <= 95));
endproperty
assert property(af_p90);

property af_p91;
@(posedge clk) ((!$isunknown(addr)) && (!w)) |=> ((i >= 0) && (i <= 255));
endproperty
assert property(af_p91);

property af_p92;
@(posedge clk) $fell(reset) |-> ##2 ((i >= 0) && (i <= 255));
endproperty
assert property(af_p92);

property af_p93;
@(posedge clk) $fell(reset) |-> ##3 ((i >= 0) && (i <= 255));
endproperty
assert property(af_p93);

property af_p94;
@(posedge clk) (sel) |-> ((o == i) || ##1 (o == i));
endproperty
assert property(af_p94);

property af_p95;
@(posedge clk) disable iff (w) (($past(i) == i) && ($past(addr) == addr)) |-> (o == $past(o));
endproperty
assert property(af_p95);

property af_p96;
@(posedge clk) (!ready) |=> (i == $past(i));
endproperty
assert property(af_p96);

property af_p97;
@(posedge clk) ((i >= 0) && (i <= 127)) |=> ((i >= 0) && (i <= 127));
endproperty
assert property(af_p97);

property af_p98;
@(posedge clk) ((i >= 50) && (i <= 75)) |-> ((i >= 40) && (i <= 90));
endproperty
assert property(af_p98);

property af_p99;
@(posedge clk) (!$isunknown(addr)) |-> ($stable(i));
endproperty
assert property(af_p99);

property af_p100;
@(posedge clk) reset |-> (i == 0) until_with (!reset);
endproperty
assert property(af_p100);

property af_p101;
@(posedge clk) ((o >= 0) && (o <= 100)) |-> ##1 ((i >= 0) && (i <= 150));
endproperty
assert property(af_p101);

property af_p102;
@(posedge clk) (w && (i >= 200) && (i <= 255)) |-> ##[1:2] done;
endproperty
assert property(af_p102);

property af_p103;
@(posedge clk) $fell(reset) |-> ##4 ((i >= 0) && (i <= 63));
endproperty
assert property(af_p103);

property af_p104;
@(posedge clk) $rose(done) |-> ##1 $stable(i) && (i >= 0) && (i <= 255);
endproperty
assert property(af_p104);

property af_p105;
@(posedge clk) (!reset) |-> ((i >= 0) && (i <= 255));
endproperty
assert property(af_p105);

property af_p106;
@(posedge clk) (!update) |-> $stable(i);
endproperty
assert property(af_p106);

property af_p107;
@(posedge clk) $fell(reset) |-> ##4 ((i >= 0) && (i <= 127));
endproperty
assert property(af_p107);

property af_p108;
@(posedge clk) ((i >= 100) && (i <= 150)) |-> ##1 (i >= 90) && (i <= 160);
endproperty
assert property(af_p108);

property af_p109;
@(posedge clk) ((i >= 100) && (i <= 200)) |-> ##1 (i >= 80) && (i <= 220);
endproperty
assert property(af_p109);

property af_p110;
@(posedge clk) $fell(reset) |-> ##4 ((i >= 10) && (i <= 60));
endproperty
assert property(af_p110);

property af_p111;
@(posedge clk) (!reset && ready) |-> (i >= 0) && (i <= 255);
endproperty
assert property(af_p111);

property af_p112;
@(posedge clk) (update) |=> (o == $past(i));
endproperty
assert property(af_p112);

property af_p113;
@(posedge clk) (reset) |=> (i == 0);
endproperty
assert property(af_p113);

property af_p114;
@(posedge clk) (!ready) |-> (i >= 20) && (i <= 235);
endproperty
assert property(af_p114);

property af_p115;
@(posedge clk) (!sel && !update) |=> ($stable(i));
endproperty
assert property(af_p115);

property af_p116;
@(posedge clk) (!reset) |-> ##3 ((i >= 0) && (i <= 31));
endproperty
assert property(af_p116);

property af_p117;
@(posedge clk) ((i >= 16) && (i <= 32)) |=> ((i >= 8) && (i <= 40));
endproperty
assert property(af_p117);

property af_p118;
@(posedge clk) (sel && w) |=> ($stable(i) throughout (!done)[*0:$] ##1 done);
endproperty
assert property(af_p118);

property af_p119;
@(posedge clk) (sel) |=> (i >= 0) && (i <= 63);
endproperty
assert property(af_p119);

property af_p120;
@(posedge clk) (ready) |-> ((i >= 0) && (i <= 255)) throughout (!done)[*0:$] ##1 done;
endproperty
assert property(af_p120);

property af_p121;
@(posedge clk) (!reset) |-> (i >= 0) && (i <= 255);
endproperty
assert property(af_p121);

property af_p122;
@(posedge clk) $changed(sel) |-> ##1 (o == sel);
endproperty
assert property(af_p122);

property af_p123;
@(posedge clk) (!ready) |-> $stable(o);
endproperty
assert property(af_p123);

property af_p124;
@(posedge clk) $rose(done) |-> (o == $past(o)) until_with (reset);
endproperty
assert property(af_p124);

property af_p125;
@(posedge clk) $fell(reset) |-> ##[1:2] !$isunknown(o);
endproperty
assert property(af_p125);

property af_p126;
@(posedge clk) $fell(reset) |-> ##1 !$isunknown(o) throughout (##[0:1] !$isunknown(o));
endproperty
assert property(af_p126);

property af_p127;
@(posedge clk) reset |-> (o == '0);
endproperty
assert property(af_p127);

property af_p128;
@(posedge clk) (update && !reset) |-> ##1 (o == i);
endproperty
assert property(af_p128);

property af_p129;
@(posedge clk) ($fell(reset) && ready) |-> ##[1:3] (!$isunknown(o) && o != '0);
endproperty
assert property(af_p129);

property af_p130;
@(posedge clk) $rose(reset) |-> ##1 (o == '0);
endproperty
assert property(af_p130);

property af_p131;
@(posedge clk) $changed(sel) |-> ##1 $changed(o);
endproperty
assert property(af_p131);

property af_p132;
@(posedge clk) (!update && !w) |-> (o == $past(o));
endproperty
assert property(af_p132);

property af_p133;
@(posedge clk) $fell(reset) |-> ##4 $stable(o) [*2];
endproperty
assert property(af_p133);

property af_p134;
@(posedge clk) (reset) |-> (o == '0);
endproperty
assert property(af_p134);

property af_p135;
@(posedge clk) (ready) |-> ($stable(o) throughout (!update)[*0:$] ##0 1);
endproperty
assert property(af_p135);

property af_p136;
@(posedge clk) (!done) |-> !($past(done) && $stable(o));
endproperty
assert property(af_p136);

property af_p137;
@(posedge clk) $fell(reset) |-> ##[1:3] !$isunknown(o);
endproperty
assert property(af_p137);

property af_p138;
@(posedge clk) (update) |=> (o == $past(i));
endproperty
assert property(af_p138);

property af_p139;
@(posedge clk) (w) |-> $stable(o);
endproperty
assert property(af_p139);

property af_p140;
@(posedge clk) (done) |-> !$isunknown(o);
endproperty
assert property(af_p140);

property af_p141;
@(posedge clk) (!update) |-> $stable(o);
endproperty
assert property(af_p141);

property af_p142;
@(posedge clk) ($stable(o) throughout (!(addr inside {[0:$]}) or !ready)[*1:$]) or ((addr inside {[0:$]}) && ready) |=> 1'b1;
endproperty
assert property(af_p142);

property af_p143;
@(posedge clk) (sel == 1'b1) |-> ##[0:1] (o == i);
endproperty
assert property(af_p143);

property af_p144;
@(posedge clk) (done) |-> ($stable(o) throughout (!update)[*0:$] ##0 1);
endproperty
assert property(af_p144);

property af_p145;
@(posedge clk) (done) |-> ($stable(o) until (reset));
endproperty
assert property(af_p145);

property af_p146;
@(posedge clk) (done && ready) |-> ##1 ($stable(o));
endproperty
assert property(af_p146);

property af_p147;
@(posedge clk) (!w) |-> $stable(o);
endproperty
assert property(af_p147);

property af_p148;
@(posedge clk) (sel) |-> (o == addr);
endproperty
assert property(af_p148);

property af_p149;
@(posedge clk) ($stable(sel)) |=> (o == i);
endproperty
assert property(af_p149);

property af_p150;
@(posedge clk) $fell(reset) |-> ##[1:2] (!$isunknown(o));
endproperty
assert property(af_p150);

property af_p151;
@(posedge clk) ($changed(addr) && sel) |-> ##1 (o == addr);
endproperty
assert property(af_p151);

property af_p152;
@(posedge clk) $fell(reset) |-> ##[1:3] (!$isunknown(o));
endproperty
assert property(af_p152);

property af_p153;
@(posedge clk) (w) |-> ##1 (o == $past(i));
endproperty
assert property(af_p153);

property af_p154;
@(posedge clk) (reset) |-> (ready == $past(ready)) ##1 (ready == $past(ready,2));
endproperty
assert property(af_p154);

property af_p155;
@(posedge clk) (!done) |-> (ready == 0);
endproperty
assert property(af_p155);

property af_p156;
@(posedge clk) (w) |-> ##1 (ready != $past(ready));
endproperty
assert property(af_p156);

property af_p157;
@(posedge clk) (ready ##1 i) |-> ($past(ready) == 1);
endproperty
assert property(af_p157);

property af_p158;
@(posedge clk) (ready) |-> (o !== 'bx);
endproperty
assert property(af_p158);

property af_p159;
@(posedge clk) (update) |-> (ready != 1);
endproperty
assert property(af_p159);

property af_p160;
@(posedge clk) ($fell(reset)) |-> ##[1:4] (ready == 1);
endproperty
assert property(af_p160);

property af_p161;
@(posedge clk) (done) |=> (ready == 0 || ready == 1);
endproperty
assert property(af_p161);

property af_p162;
@(posedge clk) ($rose(ready) && $past(w)) |-> ($past(i) !== 'bx && $fell(w));
endproperty
assert property(af_p162);

property af_p163;
@(posedge clk) (ready && w && (addr inside {[0:63]})) |=> ($past(i) == i);
endproperty
assert property(af_p163);

property af_p164;
@(posedge clk) (!reset && w) |-> (ready == 0) until_with (!w);
endproperty
assert property(af_p164);

property af_p165;
@(posedge clk) (!update) |-> (ready == $past(ready));
endproperty
assert property(af_p165);

property af_p166;
@(posedge clk) (reset) |-> (ready == 0);
endproperty
assert property(af_p166);

property af_p167;
@(posedge clk) $rose(update) |-> ##1 (ready == 0);
endproperty
assert property(af_p167);

property af_p168;
@(posedge clk) $rose(o) |-> $past(ready);
endproperty
assert property(af_p168);

property af_p169;
@(posedge clk) (w) |-> (!ready ##1 ready);
endproperty
assert property(af_p169);

property af_p170;
@(posedge clk) $fell(ready && !update) |-> ready [*1:$] until (update);
endproperty
assert property(af_p170);

property af_p171;
@(posedge clk) (w && ready) |-> ##1 (i == $past(i));
endproperty
assert property(af_p171);

property af_p172;
@(posedge clk) $rose(reset) |-> (ready == 0) throughout (!reset)[->1];
endproperty
assert property(af_p172);

property af_p173;
@(posedge clk) $rose(done) |-> ##[1:4] (ready == 1);
endproperty
assert property(af_p173);

property af_p174;
@(posedge clk) (sel) |-> (ready == 1);
endproperty
assert property(af_p174);

property af_p175;
@(posedge clk) $fell(reset) |-> ##[1:4] (ready == 1);
endproperty
assert property(af_p175);

property af_p176;
@(posedge clk) $stable(ready);
endproperty
assert property(af_p176);

property af_p177;
@(posedge clk) (!w) |-> $stable(ready);
endproperty
assert property(af_p177);

property af_p178;
@(posedge clk) (ready && w) |-> ##1 (!ready) ##[1:$] (ready);
endproperty
assert property(af_p178);

property af_p179;
@(posedge clk) $rose(update) |-> ##1 (!ready) ##[1:$] (ready);
endproperty
assert property(af_p179);

property af_p180;
@(posedge clk) $fell(reset) |-> (ready == 0) ##1 (ready == 1);
endproperty
assert property(af_p180);

property af_p181;
@(posedge clk) ($stable(update) && $stable(w)) |-> $stable(ready);
endproperty
assert property(af_p181);

property af_p182;
@(posedge clk) ((ready == 1) && (w == 0)) |=> (ready == 0);
endproperty
assert property(af_p182);

property af_p183;
@(posedge clk) $changed(addr) |-> $past(ready, 1) == 1;
endproperty
assert property(af_p183);

property af_p184;
@(posedge clk) (ready == 1) |-> $isunknown(addr) == 0;
endproperty
assert property(af_p184);

property af_p185;
@(posedge clk) $rose(update) |-> (ready == 0) ##1 (ready == 1);
endproperty
assert property(af_p185);

property af_p186;
@(posedge clk) $changed(sel) |=> (ready == 1);
endproperty
assert property(af_p186);

property af_p187;
@(posedge clk) ((w == 0) && (ready == 1)) |-> (ready == 1) throughout (update == 1);
endproperty
assert property(af_p187);

property af_p188;
@(posedge clk) (done == 0) |-> (ready == 0);
endproperty
assert property(af_p188);

property af_p189;
@(posedge clk) (w == 0) |-> ##[1:$] (ready == 1);
endproperty
assert property(af_p189);

property af_p190;
@(posedge clk) !reset |-> !$isunknown({sel, addr, w});
endproperty
assert property(af_p190);

property af_p191;
@(posedge clk) reset |-> ##1 $stable(o);
endproperty
assert property(af_p191);

property af_p192;
@(posedge clk) reset |-> ##1 !ready;
endproperty
assert property(af_p192);

property af_p193;
@(posedge clk) $fell(reset) |-> !ready;
endproperty
assert property(af_p193);

property af_p194;
@(posedge clk) reset |=> (done == 1'b0 && ready == 1'b0);
endproperty
assert property(af_p194);

property af_p195;
@(posedge clk) $fell(reset) |=> (!$isunknown(sel) && !$isunknown(addr) && !$isunknown(w));
endproperty
assert property(af_p195);

property af_p196;
@(posedge clk) reset |=> (o == '0);
endproperty
assert property(af_p196);

property af_p197;
@(posedge clk) reset |-> !ready;
endproperty
assert property(af_p197);

property af_p198;
@(posedge clk) reset |=> !ready;
endproperty
assert property(af_p198);

property af_p199;
@(posedge clk) reset |=> !done;
endproperty
assert property(af_p199);

property af_p200;
@(posedge clk) 1 |-> ##1 ((done == (reset ? 1'b0 : $past(done))) && (ready == (reset ? 1'b0 : $past(ready))));
endproperty
assert property(af_p200);

property af_p201;
@(posedge clk) (reset && sel && w) |=> !done;
endproperty
assert property(af_p201);

property af_p202;
@(posedge clk) (reset && update) |=> (!ready);
endproperty
assert property(af_p202);

property af_p203;
@(posedge clk) (reset) |-> (!done && !ready);
endproperty
assert property(af_p203);

property af_p204;
@(posedge clk) (1'b1) |-> ##1 ($stable(done) && $stable(ready) && $stable(o));
endproperty
assert property(af_p204);

property af_p205;
@(posedge clk) ($past(reset) && !reset) |-> (o == '0);
endproperty
assert property(af_p205);

property af_p206;
@(posedge clk) $fell(reset) |-> ##2 ready;
endproperty
assert property(af_p206);

property af_p207;
@(posedge clk) $fell(reset) |-> ##2 $stable(ready);
endproperty
assert property(af_p207);

property af_p208;
@(posedge clk) $fell(reset) |=> (!reset);
endproperty
assert property(af_p208);

property af_p209;
@(posedge clk) (reset) |=> (!ready);
endproperty
assert property(af_p209);

property af_p210;
@(posedge clk) (reset) |-> (o == $past(o));
endproperty
assert property(af_p210);

property af_p211;
@(posedge clk) (reset && $changed(i)) |-> ((o == $past(o)) throughout (reset[*1:$] ##1 !reset ##1 1));
endproperty
assert property(af_p211);

property af_p212;
@(posedge clk) $fell(reset) |=> (!sel)[*1:$] ##1 sel;
endproperty
assert property(af_p212);

property af_p213;
@(posedge clk) $fell(reset) |=> (done == $past(done));
endproperty
assert property(af_p213);

property af_p214;
@(posedge clk) (reset ##1 !reset) |=> !done;
endproperty
assert property(af_p214);

property af_p215;
@(posedge clk) reset |=> (!done && !ready && $stable(o));
endproperty
assert property(af_p215);

property af_p216;
@(posedge clk) (reset && update) |=> $stable(o);
endproperty
assert property(af_p216);

property af_p217;
@(posedge clk) (reset ##1 !reset) |=> !done[*1:$];
endproperty
assert property(af_p217);

property af_p218;
@(posedge clk) (reset && sel && w) |=> !ready;
endproperty
assert property(af_p218);

property af_p219;
@(posedge clk) $fell(reset) |-> !done throughout (##[0:$] done)[->1];
endproperty
assert property(af_p219);

property af_p220;
@(posedge clk) $fell(reset) |=> !done;
endproperty
assert property(af_p220);

property af_p221;
@(posedge clk) (reset && sel && w) |=> $stable(ram_data);
endproperty
assert property(af_p221);

property af_p222;
@(posedge clk) reset throughout (!done && !ready)[*1:$];
endproperty
assert property(af_p222);

property af_p223;
@(posedge clk) (reset) |=> (ready == $past(ready));
endproperty
assert property(af_p223);

property af_p224;
@(posedge clk) (sel && w) |=> (addr == $past(addr));
endproperty
assert property(af_p224);

property af_p225;
@(posedge clk) disable iff (reset) (sel && $past(sel)) |-> ($stable(sel));
endproperty
assert property(af_p225);

property af_p226;
@(posedge clk) disable iff (reset) ($past(sel) && !sel) |-> ($stable(addr) && $stable(w));
endproperty
assert property(af_p226);

property af_p227;
@(posedge clk) disable iff (reset) (sel && !w) |-> ($stable(addr));
endproperty
assert property(af_p227);

property af_p228;
@(posedge clk) disable iff (reset) (sel === 1'b0 || sel === 1'b1);
endproperty
assert property(af_p228);

property af_p229;
@(posedge clk) disable iff (reset) (!sel) |-> ($stable(addr) && $stable(w));
endproperty
assert property(af_p229);

property af_p230;
@(posedge clk) disable iff (reset) (!sel && !$past(sel)) |-> ($stable(addr));
endproperty
assert property(af_p230);

property af_p231;
@(posedge clk) disable iff (reset) (sel) |-> ($stable(addr) && $stable(w));
endproperty
assert property(af_p231);

property af_p232;
@(posedge clk) disable iff (reset) (sel) |=> (addr == $past(addr)) && (w == $past(w));
endproperty
assert property(af_p232);

property af_p233;
@(posedge clk) 1'b1 |-> (sel === $past(sel)) || (sel !== $past(sel));
endproperty
assert property(af_p233);

property af_p234;
@(posedge clk) ($past(reset) && !reset) |-> (sel === $past(sel) || sel !== $past(sel));
endproperty
assert property(af_p234);

property af_p235;
@(posedge clk) ($past(reset)) |-> (sel == 1'b0);
endproperty
assert property(af_p235);

property af_p236;
@(posedge clk) (!sel) |-> !(sel && w);
endproperty
assert property(af_p236);

property af_p237;
@(posedge clk) (sel && !w) |=> (o == $past(addr));
endproperty
assert property(af_p237);

property af_p238;
@(posedge clk) (!sel) |=> (!update);
endproperty
assert property(af_p238);

property af_p239;
@(posedge clk) (!reset) |-> ((sel === 1'b0) || (sel === 1'b1));
endproperty
assert property(af_p239);

property af_p240;
@(posedge clk) 1'b1 |-> (sel === $sampled(sel));
endproperty
assert property(af_p240);

property af_p241;
@(posedge clk) ($changed(sel) && !w) |-> ##1 $stable(o);
endproperty
assert property(af_p241);

property af_p242;
@(posedge clk) (!reset) |-> (sel inside {1'b0, 1'b1});
endproperty
assert property(af_p242);

property af_p243;
@(posedge clk) (reset) |-> (sel == 1'b0);
endproperty
assert property(af_p243);

property af_p244;
@(posedge clk) (sel && w) |-> ##0 (addr == addr);
endproperty
assert property(af_p244);

property af_p245;
@(posedge clk) $changed(sel) |-> ($stable(addr) && $stable(w));
endproperty
assert property(af_p245);

property af_p246;
@(posedge clk) reset |-> ##1 (sel == 1'b0);
endproperty
assert property(af_p246);

property af_p247;
@(posedge clk) $fell(reset) |-> ##3 (sel == sel_ext);
endproperty
assert property(af_p247);

property af_p248;
@(posedge clk) (reset && sel) |-> !(w || $changed(addr));
endproperty
assert property(af_p248);

property af_p249;
@(posedge clk) (sel && !w) |-> (o == ram[addr]);
endproperty
assert property(af_p249);

property af_p250;
@(posedge clk) (sel) |-> ($stable(addr) && $stable(w));
endproperty
assert property(af_p250);

property af_p251;
@(posedge clk) (sel !== $past(sel)) |-> ##0 $stable(o);
endproperty
assert property(af_p251);

property af_p252;
@(posedge clk) (sel && w) |-> ##1 (ram[addr] == $past(i));
endproperty
assert property(af_p252);

property af_p253;
@(posedge clk) (sel && (w || !w)) |-> $stable(sel);
endproperty
assert property(af_p253);

property af_p254;
@(posedge clk) (sel && !w && $isunknown(addr)==0) |-> ##1 (ready == 1'b1);
endproperty
assert property(af_p254);

property af_p255;
@(posedge clk) (sel && w) |-> (ram[addr] == i);
endproperty
assert property(af_p255);

property af_p256;
@(posedge clk) $fell(reset) |-> ##1 (sel == 1'b0);
endproperty
assert property(af_p256);

property af_p257;
@(posedge clk) (!$isunknown(addr)) |-> (update == 1);
endproperty
assert property(af_p257);

property af_p258;
@(posedge clk) (update == 1) |=> (update == 0);
endproperty
assert property(af_p258);

property af_p259;
@(posedge clk) (update != ready);
endproperty
assert property(af_p259);

property af_p260;
@(posedge clk) (reset) |-> (update == 0);
endproperty
assert property(af_p260);

property af_p261;
@(posedge clk) ((update == 0) || (update == 1));
endproperty
assert property(af_p261);

property af_p262;
@(posedge clk) ($rose(update)) |-> $stable(addr);
endproperty
assert property(af_p262);

property af_p263;
@(posedge clk) (!reset) |-> (update != $past(update));
endproperty
assert property(af_p263);

property af_p264;
@(posedge clk) ($changed(i)) |-> (update != $past(update));
endproperty
assert property(af_p264);

property af_p265;
@(posedge clk) (ready) |-> (update != $past(update));
endproperty
assert property(af_p265);

property af_p266;
@(posedge clk) ($fell(update)) |=> (!$isunknown(o));
endproperty
assert property(af_p266);

property af_p267;
@(posedge clk) (update == 1) |-> (w == 1);
endproperty
assert property(af_p267);

property af_p268;
@(posedge clk) ($rose(w)) |=> ($rose(update) ##1 (update == 0));
endproperty
assert property(af_p268);

property af_p269;
@(posedge clk) (w) |-> (update !== 1'bx);
endproperty
assert property(af_p269);

property af_p270;
@(posedge clk) ($rose(done)) |-> ##1 (update == 0);
endproperty
assert property(af_p270);

property af_p271;
@(posedge clk) ($rose(update)) |-> ##1 (ready == 1);
endproperty
assert property(af_p271);

property af_p272;
@(posedge clk) (reset) |-> (!update);
endproperty
assert property(af_p272);

property af_p273;
@(posedge clk) ($fell(update)) |-> (!done);
endproperty
assert property(af_p273);

property af_p274;
@(posedge clk) ($rose(done)) |-> ##1 (update == 0)[*1:$];
endproperty
assert property(af_p274);

property af_p275;
@(posedge clk) (sel) |-> (update != $past(update));
endproperty
assert property(af_p275);

property af_p276;
@(posedge clk) (reset) |-> (update == 0) ##1 (update == 1);
endproperty
assert property(af_p276);

property af_p277;
@(posedge clk) (update) |-> (reset throughout (update)[*1:$]);
endproperty
assert property(af_p277);

property af_p278;
@(posedge clk) (reset) |-> (update == 0) ##1 (!reset |-> update);
endproperty
assert property(af_p278);

property af_p279;
@(posedge clk) (i) |-> (update != $past(update));
endproperty
assert property(af_p279);

property af_p280;
@(posedge clk) (!ready) |-> (!update) ##1 (ready |-> update);
endproperty
assert property(af_p280);

property af_p281;
@(posedge clk) (update) |-> (!ready && w);
endproperty
assert property(af_p281);

property af_p282;
@(posedge clk) (update) |-> ($stable(addr));
endproperty
assert property(af_p282);

property af_p283;
@(posedge clk) (!ready) |-> (update != $past(update)) throughout (!$isunknown(o) == 0);
endproperty
assert property(af_p283);

property af_p284;
@(posedge clk) (w && !ready) |-> (update == 1) ##1 (update == 0) ##1 (update == 1) ##1 (update == 0) ##1 (ready == 1);
endproperty
assert property(af_p284);

property af_p285;
@(posedge clk) ($past(reset) && !reset) |-> (update == 1) ##1 (update == 0) ##1 (update == 1);
endproperty
assert property(af_p285);

property af_p286;
@(posedge clk) (sel && !done) |-> (update != $past(update)) ##[1:$] (done |-> update == 0);
endproperty
assert property(af_p286);

property af_p287;
@(posedge clk) ($rose(update)) |-> (update ##1 !update) ##0 (!$isunknown(o));
endproperty
assert property(af_p287);

property af_p288;
@(posedge clk) (ready && update) |-> (0);
endproperty
assert property(af_p288);

property af_p289;
@(posedge clk) (update) |-> ($stable(i) == 0 || i == $past(i));
endproperty
assert property(af_p289);

property af_p290;
@(posedge clk) (update) |-> (ready);
endproperty
assert property(af_p290);

property af_p291;
@(posedge clk) (sel) |-> (update == 1) ##1 (update == 0);
endproperty
assert property(af_p291);

property af_p292;
@(posedge clk) (sel) |=> (w == i);
endproperty
assert property(af_p292);

property af_p293;
@(posedge clk) (!update) |=> (w == $past(w));
endproperty
assert property(af_p293);

property af_p294;
@(posedge clk) (addr == $past(addr)) |-> ((w == $past(w)) && (w >= 0) && (w <= 255));
endproperty
assert property(af_p294);

property af_p295;
@(posedge clk) $fell(reset) |-> ##3 ((w >= 0) && (w <= 255));
endproperty
assert property(af_p295);

property af_p296;
@(posedge clk) ((w >= 100) && (w <= 150)) |-> ##1 ((w >= 80) && (w <= 150));
endproperty
assert property(af_p296);

property af_p297;
@(posedge clk) (reset) |-> (w == $past(w));
endproperty
assert property(af_p297);

property af_p298;
@(posedge clk) (ready) |-> ((w >= 0) && (w <= 255));
endproperty
assert property(af_p298);

property af_p299;
@(posedge clk) (reset) |-> (w == 0);
endproperty
assert property(af_p299);

property af_p300;
@(posedge clk) ((w >= 0) && (w <= 127)) |-> ##1 ((w >= 0) && (w <= 127));
endproperty
assert property(af_p300);

property af_p301;
@(posedge clk) $past(!reset,3) |-> ((w >= 0) && (w <= 63));
endproperty
assert property(af_p301);

property af_p302;
@(posedge clk) (!reset) |-> ((w >= 0) && (w <= 255));
endproperty
assert property(af_p302);

property af_p303;
@(posedge clk) $past(!reset,4) |-> ((w >= 0) && (w <= 63));
endproperty
assert property(af_p303);

property af_p304;
@(posedge clk) (done) |-> $stable(w);
endproperty
assert property(af_p304);

property af_p305;
@(posedge clk) $changed(update) |-> ((w >= 60) && (w <= 120)) ##1 ((w >= 60) && (w <= 120));
endproperty
assert property(af_p305);

property af_p306;
@(posedge clk) ((i >= 0) && (i <= 127)) |=> ((w >= 0) && (w <= 255));
endproperty
assert property(af_p306);

property af_p307;
@(posedge clk) $past(!reset,4) |-> ((w >= 0) && (w <= 45));
endproperty
assert property(af_p307);

property af_p308;
@(posedge clk) (ready) |=> ((w >= 0) && (w <= 255));
endproperty
assert property(af_p308);

property af_p309;
@(posedge clk) ((w >= 32) && (w <= 96)) |=> ((w >= 16) && (w <= 96));
endproperty
assert property(af_p309);

property af_p310;
@(posedge clk) (sel) |-> ($stable(w) && (w >= 0) && (w <= 127));
endproperty
assert property(af_p310);

property af_p311;
@(posedge clk) (done) |=> $stable(w);
endproperty
assert property(af_p311);

property af_p312;
@(posedge clk) ((w >= 32) && (w <= 95)) |=> ((w >= 16) && (w <= 111));
endproperty
assert property(af_p312);

property af_p313;
@(posedge clk) (done) |-> (o == w);
endproperty
assert property(af_p313);

property af_p314;
@(posedge clk) (update) |=> ((w >= 0) && (w <= 255));
endproperty
assert property(af_p314);

property af_p315;
@(posedge clk) (ready) |-> (o == w);
endproperty
assert property(af_p315);

property af_p316;
@(posedge clk) (ready) |-> (w == addr);
endproperty
assert property(af_p316);

