// AssertionForge baseline SVA for sockit
// 579 assertions captured from gen_plan.generate_svas

property af_p0;
@(posedge clk) (bus_wen && (bus_adr >= 0) && (bus_adr <= 15)) |-> ##1 ((bus_adr >= 0) && (bus_adr <= 15));
endproperty
assert property(af_p0);

property af_p1;
@(posedge clk) ($changed(bus_adr) && !bus_ren && !bus_wen) |-> ##1 ((bus_adr >= 0) && (bus_adr <= 255));
endproperty
assert property(af_p1);

property af_p2;
@(posedge clk) ((bus_adr >= 0) && (bus_adr <= 7)) |-> ##1 ((bus_adr >= 0) && (bus_adr <= 7));
endproperty
assert property(af_p2);

property af_p3;
@(posedge clk) $rose(rst) |-> ($stable(bus_adr))[*1] ##1 ((bus_adr >= 0) && (bus_adr <= 7));
endproperty
assert property(af_p3);

property af_p4;
@(posedge clk) bus_wen |-> (((bus_adr >= 0) && (bus_adr <= 7)) && $stable(bus_adr));
endproperty
assert property(af_p4);

property af_p5;
@(posedge clk) $fell(rst) |-> ##3 ((bus_adr >= 0) && (bus_adr <= 31));
endproperty
assert property(af_p5);

property af_p6;
@(posedge clk) ((bus_adr >= 0) && (bus_adr <= 15)) |-> ##1 ((bus_adr >= 0) && (bus_adr <= 15));
endproperty
assert property(af_p6);

property af_p7;
@(posedge clk) $fell(rst) |-> ##3 ((bus_adr >= 0) && (bus_adr <= 15));
endproperty
assert property(af_p7);

property af_p8;
@(posedge clk) $fell(rst) |-> ##3 (((bus_adr >= 0) && (bus_adr <= 31)))[*1:$];
endproperty
assert property(af_p8);

property af_p9;
@(posedge clk) $fell(rst) |-> ##2 ((bus_adr >= 0) && (bus_adr <= 3));
endproperty
assert property(af_p9);

property af_p10;
@(posedge clk) $fell(rst) |-> ((bus_adr >= 0) && (bus_adr <= 7)) until (bus_ren || bus_wen);
endproperty
assert property(af_p10);

property af_p11;
@(posedge clk) (bus_adr >= 8 && bus_adr <= 15) |-> (bus_irq == $past(bus_irq));
endproperty
assert property(af_p11);

property af_p12;
@(posedge clk) (bus_wen && (bus_adr != $past(bus_adr))) |-> !$isunknown(bus_wdt);
endproperty
assert property(af_p12);

property af_p13;
@(posedge clk) bus_ren |-> ((bus_adr >= 0) && (bus_adr <= 15)) && $stable(bus_adr);
endproperty
assert property(af_p13);

property af_p14;
@(posedge clk) $fell(rst) |-> ##4 (bus_adr >= 0) && (bus_adr <= 31);
endproperty
assert property(af_p14);

property af_p15;
@(posedge clk) ((bus_adr >= 4 && bus_adr <= 7) && ($past(bus_adr) >= 0 && $past(bus_adr) <= 3)) |-> (!rst);
endproperty
assert property(af_p15);

property af_p16;
@(posedge clk) (!rst) |-> (bus_adr >= 0) && (bus_adr <= 63);
endproperty
assert property(af_p16);

property af_p17;
@(posedge clk) $fell(rst) |-> ##4 ((bus_adr >= 0) && (bus_adr <= 63) && $stable(bus_adr));
endproperty
assert property(af_p17);

property af_p18;
@(posedge clk) bus_wen |-> ((bus_adr >= 0) && (bus_adr <= 7)) ##1 (bus_adr == $past(bus_adr));
endproperty
assert property(af_p18);

property af_p19;
@(posedge clk) $fell(rst) |-> ##1 ((bus_adr >= 0) && (bus_adr <= 15)) ##1 (bus_adr == $past(bus_adr));
endproperty
assert property(af_p19);

property af_p20;
@(posedge clk) (!rst) |-> (bus_adr >= 0) && (bus_adr <= 31);
endproperty
assert property(af_p20);

property af_p21;
@(posedge clk) (bus_wen) |-> ((bus_adr >= 0) && (bus_adr <= 63)) && ((bus_wdt >= 0) && (bus_wdt <= 255));
endproperty
assert property(af_p21);

property af_p22;
@(posedge clk) ((bus_adr >= 0) && (bus_adr <= 63));
endproperty
assert property(af_p22);

property af_p23;
@(posedge clk) (bus_ren && $past(bus_ren)) |-> (($stable(bus_adr)) && (bus_adr >= 0) && (bus_adr <= 7));
endproperty
assert property(af_p23);

property af_p24;
@(posedge clk) $changed(bus_adr) |-> $rose(clk);
endproperty
assert property(af_p24);

property af_p25;
@(posedge clk) ((bus_adr >= 2) && (bus_adr <= 5)) |=> ((bus_adr >= 0) && (bus_adr <= 7));
endproperty
assert property(af_p25);

property af_p26;
@(posedge clk) ((bus_adr >= 4) && (bus_adr <= 7)) |=> ((bus_adr >= 0) && (bus_adr <= 7));
endproperty
assert property(af_p26);

property af_p27;
@(posedge clk) (bus_ren && (bus_adr >= 0) && (bus_adr <= 7)) |=> (bus_ren |-> ((bus_adr >= 0) && (bus_adr <= 7)));
endproperty
assert property(af_p27);

property af_p28;
@(posedge clk) (bus_wen) |-> ($stable(bus_adr) && (bus_adr >= 0) && (bus_adr <= 15));
endproperty
assert property(af_p28);



property af_p31;
@(posedge clk) ($changed(owr_i) && !owr_e) |-> (bus_irq == 1'b0);
endproperty
assert property(af_p31);

property af_p32;
@(posedge clk) (rst) |-> (bus_irq == 1'b0);
endproperty
assert property(af_p32);


property af_p34;
@(posedge clk) (!owr_e) |-> (bus_irq == 1'b0);
endproperty
assert property(af_p34);



property af_p37;
@(posedge clk) ($changed(bus_adr) && !bus_ren && !bus_wen) |-> ($stable(bus_irq));
endproperty
assert property(af_p37);

property af_p38;
@(posedge clk) ($rose(bus_irq)) |-> ($past(bus_wen) || bus_wen);
endproperty
assert property(af_p38);

property af_p39;
@(posedge clk) ($rose(bus_irq)) |=> (bus_irq == 1'b1);
endproperty
assert property(af_p39);

property af_p40;
@(posedge clk) ($rose(bus_irq)) |-> (bus_irq == 1'b1) [*2] or (bus_ren throughout (bus_irq == 1'b1) [*1]);
endproperty
assert property(af_p40);

property af_p41;
@(posedge clk) ($rose(bus_irq)) |-> (bus_irq == 1'b1) throughout (bus_wen && (bus_wdt == '0))[->1];
endproperty
assert property(af_p41);

property af_p42;
@(posedge clk) ($rose(rst)) |=> (bus_irq == 1'b0);
endproperty
assert property(af_p42);

property af_p43;
@(posedge clk) (bus_ren && bus_irq) |=> (bus_irq == 1'b0);
endproperty
assert property(af_p43);

property af_p44;
@(posedge clk) ($fell(rst)) |=> (bus_irq == 1'b0);
endproperty
assert property(af_p44);

property af_p45;
@(posedge clk) ($fell(rst)) |-> (bus_irq == 1'b0) [*3];
endproperty
assert property(af_p45);

property af_p46;
@(posedge clk) $rose(rst) |-> (bus_irq == 0)[*2];
endproperty
assert property(af_p46);

property af_p47;
@(posedge clk) ($changed(owr_i) || $changed(owr_p)) |-> ##[1:3] (bus_irq == (owr_i || owr_p));
endproperty
assert property(af_p47);


property af_p49;
@(posedge clk) $changed(owr_i) |-> ##[1:3] (bus_irq == 1);
endproperty
assert property(af_p49);

property af_p50;
@(posedge clk) bus_wen |=> (bus_irq == $past(bus_wdt[0]));
endproperty
assert property(af_p50);


property af_p52;
@(posedge clk) (bus_ren && bus_irq) |=> !bus_irq;
endproperty
assert property(af_p52);




property af_p56;
@(posedge clk) $fell(rst) |-> (bus_irq == 0)[*3];
endproperty
assert property(af_p56);



property af_p59;
@(posedge clk) $fell(rst) |-> (bus_irq == 0)[*4];
endproperty
assert property(af_p59);


property af_p61;
@(posedge clk) (bus_irq !== $past(bus_irq)) |-> ##1 (bus_irq === $past(bus_irq));
endproperty
assert property(af_p61);

property af_p62;
@(posedge clk) (bus_irq && !bus_ren) |=> bus_irq;
endproperty
assert property(af_p62);

property af_p63;
@(posedge clk) (bus_irq && bus_ren) |-> (bus_rdt == bus_irq);
endproperty
assert property(af_p63);

property af_p64;
@(posedge clk) bus_irq |-> (bus_adr == 8'h04);
endproperty
assert property(af_p64);

property af_p65;
@(posedge clk) bus_wen |=> !bus_irq;
endproperty
assert property(af_p65);

property af_p66;
@(posedge clk) rst |-> !bus_irq;
endproperty
assert property(af_p66);

property af_p67;
@(posedge clk) $fell(owr_p) |-> ##[1:2] bus_irq;
endproperty
assert property(af_p67);


property af_p69;
@(posedge clk) !rst |-> (bus_irq === 1'b0 || bus_irq === 1'b1);
endproperty
assert property(af_p69);

property af_p70;
@(posedge clk) 1'b1 |=> $stable(bus_irq);
endproperty
assert property(af_p70);

property af_p71;
@(posedge clk) bus_irq |-> (bus_irq until bus_ren);
endproperty
assert property(af_p71);

property af_p72;
@(posedge clk) bus_ren |=> !bus_irq;
endproperty
assert property(af_p72);


property af_p74;
@(posedge clk) (bus_ren) |-> (!$isunknown(bus_rdt)) or (bus_ren |=> !$isunknown(bus_rdt));
endproperty
assert property(af_p74);

property af_p75;
@(posedge clk) (!bus_ren && !bus_wen) |=> $stable(bus_rdt)[*1:$];
endproperty
assert property(af_p75);

property af_p76;
@(posedge clk) (!bus_wen && !bus_ren) |=> $stable(bus_rdt);
endproperty
assert property(af_p76);

property af_p77;
@(posedge clk) (bus_wen && !$past(bus_ren)) ##1 (bus_ren && (bus_adr == $past(bus_adr))) |-> (bus_rdt == $past(bus_wdt,1));
endproperty
assert property(af_p77);

property af_p78;
@(posedge clk) (bus_ren && bus_irq) |-> !$isunknown(bus_rdt);
endproperty
assert property(af_p78);

property af_p79;
@(posedge clk) (bus_ren) |=> (bus_rdt !== $past(bus_rdt)) || (bus_rdt === $past(bus_rdt));
endproperty
assert property(af_p79);

property af_p80;
@(posedge clk) (bus_ren && !bus_wen) |-> !$isunknown(bus_rdt) && (bus_rdt !== bus_wdt || bus_wdt === bus_wdt);
endproperty
assert property(af_p80);

property af_p81;
@(posedge clk) (bus_ren && $changed(bus_adr)) |=> (bus_rdt !== $past(bus_rdt));
endproperty
assert property(af_p81);

property af_p82;
@(posedge clk) (bus_ren && $changed(bus_adr)) |=> !$isunknown(bus_rdt);
endproperty
assert property(af_p82);

property af_p83;
@(posedge clk) (bus_ren) |-> $stable(bus_rdt);
endproperty
assert property(af_p83);

property af_p84;
@(posedge clk) (bus_ren && $stable(bus_adr)) |=> (bus_ren && $stable(bus_adr)) |-> $stable(bus_rdt);
endproperty
assert property(af_p84);

property af_p85;
@(posedge clk) (bus_ren) ##1 (bus_ren) |-> (bus_rdt == $past(bus_rdt, 1));
endproperty
assert property(af_p85);

property af_p86;
@(posedge clk) (bus_ren && bus_irq) |-> (bus_rdt !== 'x) && (bus_rdt != '0);
endproperty
assert property(af_p86);

property af_p87;
@(posedge clk) (bus_ren throughout (bus_ren[*2])) |-> $rose(bus_rdt) ##0 1'b1 |-> $stable(bus_rdt);
endproperty
assert property(af_p87);

property af_p88;
@(posedge clk) (bus_ren) |-> !$isunknown(bus_rdt);
endproperty
assert property(af_p88);

property af_p89;
@(posedge clk) (!bus_ren) |-> $stable(bus_rdt);
endproperty
assert property(af_p89);

property af_p90;
@(posedge clk) (!bus_ren && !bus_wen) |-> $stable(bus_rdt);
endproperty
assert property(af_p90);

property af_p91;
@(posedge clk) (bus_ren) |-> !$isunknown(bus_rdt) ##0 $stable(bus_rdt);
endproperty
assert property(af_p91);

property af_p92;
@(posedge clk) (bus_wen && !bus_ren) ##1 (bus_ren && !bus_wen) |-> !$isunknown(bus_rdt);
endproperty
assert property(af_p92);

property af_p93;
@(posedge clk) (!bus_ren) |-> (bus_rdt == '0);
endproperty
assert property(af_p93);

property af_p94;
@(posedge clk) (!bus_ren) |=> $stable(bus_rdt);
endproperty
assert property(af_p94);

property af_p95;
@(posedge clk) (bus_ren) |-> ##1 $stable(bus_rdt) throughout (bus_ren[*1]);
endproperty
assert property(af_p95);


property af_p97;
@(posedge clk) (rst) |-> (bus_rdt == '0);
endproperty
assert property(af_p97);

property af_p98;
@(posedge clk) (!bus_ren) |-> (bus_rdt == $past(bus_rdt));
endproperty
assert property(af_p98);

property af_p99;
@(posedge clk) (bus_ren) |=> (bus_rdt !== 'x);
endproperty
assert property(af_p99);

property af_p100;
@(posedge clk) (bus_ren) |-> (bus_rdt !== $past(bus_rdt)) || ($past(bus_ren) == 0);
endproperty
assert property(af_p100);

property af_p101;
@(posedge clk) (bus_wen && !bus_ren) |-> (bus_rdt == $past(bus_rdt));
endproperty
assert property(af_p101);

property af_p102;
@(posedge clk) ($past(rst) && !rst && bus_ren) |-> (bus_rdt >= 0 && bus_rdt <= 255);
endproperty
assert property(af_p102);

property af_p103;
@(posedge clk) (bus_ren && (bus_adr == $past(bus_adr)) && $past(bus_ren)) |-> (bus_rdt == $past(bus_rdt));
endproperty
assert property(af_p103);

property af_p104;
@(posedge clk) !$isunknown(bus_ren);
endproperty
assert property(af_p104);

property af_p105;
@(posedge clk) $fell(rst) |=> !bus_ren;
endproperty
assert property(af_p105);

property af_p106;
@(posedge clk) $rose(bus_ren) |-> !$isunknown(bus_rdt);
endproperty
assert property(af_p106);

property af_p107;
@(posedge clk) $rose(bus_ren) |-> ##1 $stable(bus_rdt) == 0 || bus_rdt == $past(bus_rdt);
endproperty
assert property(af_p107);

property af_p108;
@(posedge clk) rst |-> !bus_ren;
endproperty
assert property(af_p108);

property af_p109;
@(posedge clk) !(bus_ren && rst);
endproperty
assert property(af_p109);

property af_p110;
@(posedge clk) !(bus_ren && bus_wen);
endproperty
assert property(af_p110);

property af_p111;
@(posedge clk) bus_ren |=> (bus_rdt != $past(bus_rdt));
endproperty
assert property(af_p111);

property af_p112;
@(posedge clk) bus_ren |-> $stable(bus_adr);
endproperty
assert property(af_p112);

property af_p113;
@(posedge clk) (bus_ren && bus_irq) |=> !bus_irq;
endproperty
assert property(af_p113);

property af_p114;
@(posedge clk) bus_ren |-> ($stable(owr_e) && $stable(owr_p));
endproperty
assert property(af_p114);

property af_p115;
@(posedge clk) bus_ren |=> !bus_ren;
endproperty
assert property(af_p115);

property af_p116;
@(posedge clk) $fell(rst) |=> !$isunknown(bus_ren);
endproperty
assert property(af_p116);

property af_p117;
@(posedge clk) ($fell(rst)) |-> (bus_ren == 1'b0);
endproperty
assert property(af_p117);

property af_p118;
@(posedge clk) ($rose(bus_ren)) |-> (1'b1);
endproperty
assert property(af_p118);

property af_p119;
@(posedge clk) (bus_ren) |-> ($stable(bus_adr));
endproperty
assert property(af_p119);

property af_p120;
@(posedge clk) (bus_ren) |=> (!bus_ren);
endproperty
assert property(af_p120);

property af_p121;
@(posedge clk) (!bus_ren) |-> (1'b1);
endproperty
assert property(af_p121);

property af_p122;
@(posedge clk) (bus_ren) |-> ##1 ((bus_irq == 1'b0) || ($stable(bus_irq)));
endproperty
assert property(af_p122);

property af_p123;
@(posedge clk) ($rose(bus_ren)) |=> (bus_rdt !== 'x);
endproperty
assert property(af_p123);

property af_p124;
@(posedge clk) (bus_wen) |-> ##1 ((bus_wdt >= 0) && (bus_wdt <= 255));
endproperty
assert property(af_p124);

property af_p125;
@(posedge clk) (bus_wen) |-> $stable(bus_wdt);
endproperty
assert property(af_p125);

property af_p126;
@(posedge clk) (!bus_wen && !bus_ren) |-> $stable(bus_rdt);
endproperty
assert property(af_p126);

property af_p127;
@(posedge clk) (bus_wen && !$isunknown(bus_adr)) |-> !$isunknown(bus_wdt);
endproperty
assert property(af_p127);

property af_p128;
@(posedge clk) ($rose(!rst)) |-> ##3 (bus_wen && (bus_wdt >= 0) && (bus_wdt <= 255));
endproperty
assert property(af_p128);

property af_p129;
@(posedge clk) (bus_wen && !rst) |-> (bus_wdt >= 0) && (bus_wdt <= 255);
endproperty
assert property(af_p129);

property af_p130;
@(posedge clk) $changed(bus_wdt) |-> $stable(bus_rdt);
endproperty
assert property(af_p130);

property af_p131;
@(posedge clk) (!bus_wen) |-> ##1 $stable(bus_rdt);
endproperty
assert property(af_p131);

property af_p132;
@(posedge clk) (bus_wen) |-> ($stable(bus_wdt) && (bus_wdt >= 0) && (bus_wdt <= 255));
endproperty
assert property(af_p132);

property af_p133;
@(posedge clk) (bus_wen) |-> $stable(bus_irq);
endproperty
assert property(af_p133);

property af_p134;
@(posedge clk) (bus_wen && (bus_wdt >= 0) && (bus_wdt <= 127)) |-> ##1 ((bus_wdt >= 0) && (bus_wdt <= 127));
endproperty
assert property(af_p134);

property af_p135;
@(posedge clk) (bus_wen) |-> ((bus_wdt >= 0) && (bus_wdt <= 255));
endproperty
assert property(af_p135);

property af_p136;
@(posedge clk) (!bus_wen) |-> $stable(bus_wdt);
endproperty
assert property(af_p136);

property af_p137;
@(posedge clk) (bus_wen ##1 bus_wen) |-> $stable(bus_wdt);
endproperty
assert property(af_p137);

property af_p138;
@(posedge clk) (rst throughout ##1 !rst) |-> !$isunknown(bus_wdt);
endproperty
assert property(af_p138);

property af_p139;
@(posedge clk) ((bus_wdt >= 100) && (bus_wdt <= 150)) |-> ##1 (bus_wdt >= 80) && (bus_wdt <= 170);
endproperty
assert property(af_p139);

property af_p140;
@(posedge clk) (bus_wen && bus_wen[->1]) |-> ($stable(bus_adr) == $stable(bus_wdt));
endproperty
assert property(af_p140);


property af_p142;
@(posedge clk) (!bus_wen && $changed(bus_ren)) |-> $stable(bus_wdt);
endproperty
assert property(af_p142);

property af_p143;
@(posedge clk) bus_wen throughout (bus_ren ##1 !bus_ren) |-> $stable(bus_wdt);
endproperty
assert property(af_p143);

property af_p144;
@(posedge clk) bus_wen |-> $stable(bus_wdt);
endproperty
assert property(af_p144);

property af_p145;
@(posedge clk) disable iff (!bus_wen) (1) |-> !$isunknown(bus_wdt);
endproperty
assert property(af_p145);

property af_p146;
@(posedge clk) (bus_wen && (bus_wdt >= 50) && (bus_wdt <= 200)) |-> ##1 (bus_wdt >= 30) && (bus_wdt <= 220);
endproperty
assert property(af_p146);

property af_p147;
@(posedge clk) $changed(bus_ren) |-> $stable(bus_wdt);
endproperty
assert property(af_p147);

property af_p148;
@(posedge clk) (!rst) |-> (!bus_wen |=> $stable(bus_wdt));
endproperty
assert property(af_p148);

property af_p149;
@(posedge clk) (bus_ren) |-> $stable(bus_wdt);
endproperty
assert property(af_p149);

property af_p150;
@(posedge clk) ($changed(bus_adr) && bus_wen) |=> $changed(bus_wdt);
endproperty
assert property(af_p150);

property af_p151;
@(posedge clk) ($changed(bus_adr) && bus_wen) |-> (bus_wdt >= 0 && bus_wdt <= 255);
endproperty
assert property(af_p151);

property af_p152;
@(posedge clk) (rst) |=> (bus_wdt == 0);
endproperty
assert property(af_p152);

property af_p153;
@(posedge clk) $fell(rst) |=> ##1 (bus_wdt >= 0 && bus_wdt <= 255);
endproperty
assert property(af_p153);

property af_p154;
@(posedge clk) (bus_wen) |-> ((bus_wdt >= 0 && bus_wdt <= 255) ##1 $stable(bus_wdt));
endproperty
assert property(af_p154);

property af_p155;
@(posedge clk) ($fell(rst) && bus_wen) |=> (bus_wdt >= 0 && bus_wdt <= 255);
endproperty
assert property(af_p155);

property af_p156;
@(posedge clk) (bus_wen) |-> (bus_wdt >= 0 && bus_wdt <= 255);
endproperty
assert property(af_p156);

property af_p157;
@(posedge clk) $stable(bus_wen) or (!$isunknown(bus_wen));
endproperty
assert property(af_p157);

property af_p158;
@(posedge clk) ($fell(bus_ren)) |-> (!bus_wen throughout (##0 1));
endproperty
assert property(af_p158);

property af_p159;
@(posedge clk) ($fell(rst)) |-> (!bus_wen throughout (##0 1));
endproperty
assert property(af_p159);

property af_p160;
@(posedge clk) ($fell(rst)) |-> (##2 !$isunknown(bus_wen));
endproperty
assert property(af_p160);

property af_p161;
@(posedge clk) (bus_wen) |-> ($stable(bus_rdt) until_with (bus_ren));
endproperty
assert property(af_p161);

property af_p162;
@(posedge clk) (bus_wen) |-> !$isunknown(bus_wdt);
endproperty
assert property(af_p162);

property af_p163;
@(posedge clk) ($rose(bus_wen) || $fell(bus_wen)) |-> (owr_e || !$rose(bus_irq));
endproperty
assert property(af_p163);

property af_p164;
@(posedge clk) (bus_wen) |-> (!bus_irq);
endproperty
assert property(af_p164);

property af_p165;
@(posedge clk) (rst && !bus_wen) |-> !$isunknown(bus_wdt);
endproperty
assert property(af_p165);

property af_p166;
@(posedge clk) ($rose(bus_wen)) |-> (!$rose(bus_irq));
endproperty
assert property(af_p166);

property af_p167;
@(posedge clk) (bus_wen) |-> $stable(bus_adr);
endproperty
assert property(af_p167);

property af_p168;
@(posedge clk) (bus_wen) |-> ((bus_wdt >= 0) && (bus_wdt <= 255));
endproperty
assert property(af_p168);

property af_p169;
@(posedge clk) (bus_wen) |-> ($stable(bus_adr) && !$isunknown(bus_adr));
endproperty
assert property(af_p169);

property af_p170;
@(posedge clk) !(bus_wen && bus_ren);
endproperty
assert property(af_p170);

property af_p171;
@(posedge clk) (bus_wen) |-> $stable(bus_rdt);
endproperty
assert property(af_p171);

property af_p172;
@(posedge clk) (bus_wen) |-> !bus_ren;
endproperty
assert property(af_p172);

property af_p173;
@(posedge clk) (bus_wen) |-> !rst;
endproperty
assert property(af_p173);


property af_p175;
@(posedge clk) $rose(rst) |-> !bus_wen;
endproperty
assert property(af_p175);

property af_p176;
@(posedge clk) $rose(rst) |-> (!bus_wen ##1 !bus_wen);
endproperty
assert property(af_p176);

property af_p177;
@(posedge clk) (bus_wen && $past(bus_wen)) |-> (!$isunknown(bus_wdt));
endproperty
assert property(af_p177);

property af_p178;
@(posedge clk) (bus_wen) |-> (!$isunknown(bus_wdt));
endproperty
assert property(af_p178);

property af_p179;
@(posedge clk) ($rose(bus_wen)) |=> (!bus_wen);
endproperty
assert property(af_p179);

property af_p180;
@(posedge clk) (!(bus_wen && owr_e));
endproperty
assert property(af_p180);

property af_p181;
@(posedge clk) (!(bus_wen && bus_ren));
endproperty
assert property(af_p181);

property af_p182;
@(posedge clk) (bus_wen) |-> ($stable(bus_adr));
endproperty
assert property(af_p182);

property af_p183;
@(posedge clk) (bus_wen && !$isunknown(bus_adr)) |=> ($past(bus_wdt) == bus_wdt);
endproperty
assert property(af_p183);



property af_p186;
@(posedge clk) (bus_wen) |-> ##1 $stable(bus_adr);
endproperty
assert property(af_p186);

property af_p187;
@(posedge clk) (bus_ren) |-> ##1 (bus_rdt !== 'x);
endproperty
assert property(af_p187);

property af_p188;
@(posedge clk) $past(!rst) |-> ##1 $stable(bus_adr) || 1'b1;
endproperty
assert property(af_p188);

property af_p189;
@(posedge clk) !(bus_wen && bus_ren);
endproperty
assert property(af_p189);


property af_p191;
@(posedge clk) (bus_wen) |-> ##1 $stable(bus_wdt);
endproperty
assert property(af_p191);

property af_p192;
@(posedge clk) (bus_wen) |-> ($stable(bus_wdt) || 1'b1);
endproperty
assert property(af_p192);

property af_p193;
@(posedge clk) (!bus_ren) |-> ##1 $stable(bus_rdt);
endproperty
assert property(af_p193);

property af_p194;
@(posedge clk) disable iff (!rst) (!bus_irq) |-> ##1 (bus_irq === $past(bus_irq));
endproperty
assert property(af_p194);

property af_p195;
@(posedge clk) 1'b1 |=> (owr_i == $past(owr_p));
endproperty
assert property(af_p195);

property af_p196;
@(posedge clk) (!owr_e) |-> (owr_i == owr_p);
endproperty
assert property(af_p196);

property af_p197;
@(posedge clk) ($isunknown(owr_i) == 0 && owr_i !== '0) |=> (bus_irq == 1'b1);
endproperty
assert property(af_p197);

property af_p198;
@(posedge clk) ($isunknown(bus_adr) == 0) |=> (bus_irq == 1'b1);
endproperty
assert property(af_p198);


property af_p200;
@(posedge clk) (!bus_wen && !bus_ren) |-> ($stable(owr_e) && $stable(owr_p));
endproperty
assert property(af_p200);

property af_p201;
@(posedge clk) (bus_ren) |=> ($isunknown(bus_rdt) == 0);
endproperty
assert property(af_p201);

property af_p202;
@(posedge clk) ($rose(rst)) |=> (bus_wen == 1'b0);
endproperty
assert property(af_p202);

property af_p203;
@(posedge clk) (bus_wen || bus_ren) |-> ##1 $stable(bus_adr);
endproperty
assert property(af_p203);

property af_p204;
@(posedge clk) (bus_wen) |=> (bus_wdt == $past(bus_wdt));
endproperty
assert property(af_p204);

property af_p205;
@(posedge clk) ($changed(owr_e)) |-> ##[1:2] ($changed(owr_i) || $stable(owr_i));
endproperty
assert property(af_p205);


property af_p207;
@(posedge clk) disable iff (!rst) $stable(owr_e) or $changed(owr_e);
endproperty
assert property(af_p207);

property af_p208;
@(posedge clk) ($fell(rst)) |-> ##1 (bus_irq === 1'b0);
endproperty
assert property(af_p208);

property af_p209;
@(posedge clk) (rst) |=> (!bus_wen && !bus_ren);
endproperty
assert property(af_p209);

property af_p210;
@(posedge clk) (!owr_e) |-> $stable(owr_p);
endproperty
assert property(af_p210);

property af_p211;
@(posedge clk) ($fell(rst)) |-> (1'b1);
endproperty
assert property(af_p211);


property af_p213;
@(posedge clk) (1'b1) |-> $stable(owr_e) || $changed(owr_e);
endproperty
assert property(af_p213);


property af_p215;
@(posedge clk) (bus_wen) |-> (bus_wdt === bus_wdt);
endproperty
assert property(af_p215);

property af_p216;
@(posedge clk) (rst) |-> (bus_irq === 1'b0);
endproperty
assert property(af_p216);

property af_p217;
@(posedge clk) !(bus_ren && bus_wen);
endproperty
assert property(af_p217);

property af_p218;
@(posedge clk) (1'b1) |-> ($stable(owr_i) || !$stable(owr_i));
endproperty
assert property(af_p218);





property af_p223;
@(posedge clk) (bus_ren) |-> (bus_rdt == $past(owr_i));
endproperty
assert property(af_p223);























































































































property af_p342;
@(posedge clk) (bus_wen) |=> (bus_rdt == $past(bus_wdt));
endproperty
assert property(af_p342);









































property af_p383;
@(posedge clk) rst |-> (owr_e == 1'b0);
endproperty
assert property(af_p383);

property af_p384;
@(posedge clk) bus_ren |-> (bus_rdt[0] == owr_e);
endproperty
assert property(af_p384);

property af_p385;
@(posedge clk) ($fell(owr_e) && !owr_p) |-> ##1 (owr_i === 1'bz);
endproperty
assert property(af_p385);

property af_p386;
@(posedge clk) $fell(rst) |-> (owr_e == 1'b0)[*4];
endproperty
assert property(af_p386);


property af_p388;
@(posedge clk) (!owr_e && !owr_p) |-> ##1 (owr_i === 1'bz);
endproperty
assert property(af_p388);


property af_p390;
@(posedge clk) (!bus_wen && !bus_ren) |-> $stable(owr_e);
endproperty
assert property(af_p390);

property af_p391;
@(posedge clk) bus_wen |-> ##1 (owr_e == bus_wdt[0]);
endproperty
assert property(af_p391);

property af_p392;
@(posedge clk) owr_e |-> ##1 (owr_i === 1'b0);
endproperty
assert property(af_p392);

property af_p393;
@(posedge clk) (!rst) |-> (owr_e === 1'b0 || owr_e === 1'b1);
endproperty
assert property(af_p393);

property af_p394;
@(posedge clk) owr_e |-> bus_wen;
endproperty
assert property(af_p394);

property af_p395;
@(posedge clk) 1'b1 |-> (owr_e inside {1'b0, 1'b1});
endproperty
assert property(af_p395);

property af_p396;
@(posedge clk) $fell(rst) |-> ##1 (owr_e == 1'b0);
endproperty
assert property(af_p396);

property af_p397;
@(posedge clk) (!owr_p && !owr_e) |-> ##1 (owr_i === 1'bz);
endproperty
assert property(af_p397);

property af_p398;
@(posedge clk) rst |-> (owr_e == 1'b0) && (owr_e == $past(owr_e));
endproperty
assert property(af_p398);


property af_p400;
@(posedge clk) $fell(rst) |-> (owr_e == 1'b0) until (bus_wen);
endproperty
assert property(af_p400);

property af_p401;
@(posedge clk) (!bus_wen) |-> (owr_e == $past(owr_e));
endproperty
assert property(af_p401);

property af_p402;
@(posedge clk) $rose(rst) |-> (owr_e == 1'b0);
endproperty
assert property(af_p402);

property af_p403;
@(posedge clk) (owr_e && !owr_p) |-> (owr_i == 1'b0);
endproperty
assert property(af_p403);

property af_p404;
@(posedge clk) $fell(rst) |-> (owr_e == 1'b0 && owr_p == 1'b0);
endproperty
assert property(af_p404);

property af_p405;
@(posedge clk) $fell(rst) |-> ##4 (owr_e === 1'b0 || owr_e === 1'b1);
endproperty
assert property(af_p405);

property af_p406;
@(posedge clk) (bus_wen && bus_wdt[0]) |-> ##[1:2] (owr_e !== 1'bx);
endproperty
assert property(af_p406);

property af_p407;
@(posedge clk) (owr_e !== 1'bx && owr_e !== 1'bz) |-> ($stable(owr_e) || $changed(owr_e));
endproperty
assert property(af_p407);

property af_p408;
@(posedge clk) owr_p |-> (owr_i == owr_p);
endproperty
assert property(af_p408);



property af_p411;
@(posedge clk) owr_e |-> (owr_i !== 1'bz);
endproperty
assert property(af_p411);

property af_p412;
@(posedge clk) (owr_e || owr_p) |-> (owr_i !== 1'bz);
endproperty
assert property(af_p412);

property af_p413;
@(posedge clk) (owr_e && !owr_p) |=> (owr_i == 1'b0);
endproperty
assert property(af_p413);


property af_p415;
@(posedge clk) $rose(owr_e) |-> owr_e throughout (##1 1);
endproperty
assert property(af_p415);

property af_p416;
@(posedge clk) disable iff (rst) $rose(owr_e) |-> owr_e[->1];
endproperty
assert property(af_p416);

property af_p417;
@(posedge clk) (rst) |-> $stable(owr_i);
endproperty
assert property(af_p417);

property af_p418;
@(posedge clk) (bus_ren) |-> (bus_rdt === owr_i);
endproperty
assert property(af_p418);

property af_p419;
@(posedge clk) (owr_p && owr_e) |-> (owr_i === owr_p);
endproperty
assert property(af_p419);

property af_p420;
@(posedge clk) ($fell(owr_e)) |-> ##1 (owr_i !== $past(owr_i,1)) or (owr_i === owr_p);
endproperty
assert property(af_p420);


property af_p422;
@(posedge clk) disable iff (rst) ($fell(rst)) |-> (owr_i === $past(owr_i)) [*4];
endproperty
assert property(af_p422);

property af_p423;
@(posedge clk) (!owr_e) |-> (owr_p ? (owr_i === owr_p) : (owr_i === 1'bz));
endproperty
assert property(af_p423);

property af_p424;
@(posedge clk) (owr_p) |-> (owr_i === 1'b1);
endproperty
assert property(af_p424);

property af_p425;
@(posedge clk) ($changed(owr_p) || $changed(owr_e)) |-> ##1 (owr_i === ((owr_p || owr_e) ? owr_p : 1'bz));
endproperty
assert property(af_p425);

property af_p426;
@(posedge clk) (owr_e) |-> (owr_i === $past(owr_p));
endproperty
assert property(af_p426);

property af_p427;
@(posedge clk) ((!owr_p) && (!owr_e)) |-> (owr_i !== 1'b0);
endproperty
assert property(af_p427);


property af_p429;
@(posedge clk) disable iff (rst) (owr_i === 1'b0 || owr_i === 1'b1);
endproperty
assert property(af_p429);

property af_p430;
@(posedge clk) (owr_e && !owr_p) |=> (owr_i == 1'b1);
endproperty
assert property(af_p430);



property af_p433;
@(posedge clk) (owr_e) |-> (owr_i == owr_p);
endproperty
assert property(af_p433);

property af_p434;
@(posedge clk) (!owr_e && !owr_p) |-> (owr_i == 1'b1) [*2];
endproperty
assert property(af_p434);

property af_p435;
@(posedge clk) (owr_e && !owr_p) |=> (owr_i == 1'b0);
endproperty
assert property(af_p435);

property af_p436;
@(posedge clk) (rst) |-> ##[1:3] (owr_i === 1'b0 || owr_i === 1'b1);
endproperty
assert property(af_p436);

property af_p437;
@(posedge clk) $stable(owr_i) throughout (1'b1 ##1 1'b1);
endproperty
assert property(af_p437);

property af_p438;
@(posedge clk) (owr_p | owr_e) |=> (owr_i == owr_p);
endproperty
assert property(af_p438);

property af_p439;
@(posedge clk) (owr_p && !owr_e) |=> (owr_i == owr_p);
endproperty
assert property(af_p439);

property af_p440;
@(posedge clk) (1'b1) |-> ##1 (owr_i == ((owr_p || owr_e) ? owr_p : owr_i));
endproperty
assert property(af_p440);

property af_p441;
@(posedge clk) (bus_wdt) |-> ##1 (owr_i == $past(owr_i));
endproperty
assert property(af_p441);

property af_p442;
@(posedge clk) ($rose(owr_e)) |-> ##1 (owr_i == owr_p);
endproperty
assert property(af_p442);

property af_p443;
@(posedge clk) ($fell(owr_e) && owr_p) |-> ##1 (owr_i == owr_p);
endproperty
assert property(af_p443);

property af_p444;
@(posedge clk) ($fell(owr_p) && !owr_e) |-> ##1 (owr_i == 1'b1);
endproperty
assert property(af_p444);

property af_p445;
@(posedge clk) ($stable(owr_p) && $stable(owr_e)) |-> $stable(owr_i);
endproperty
assert property(af_p445);

property af_p446;
@(posedge clk) ($fell(owr_e) && (owr_p == 1'b0)) |-> ##1 $stable(owr_i);
endproperty
assert property(af_p446);

property af_p447;
@(posedge clk) (owr_i) |-> ##[1:2] (bus_rdt == owr_i);
endproperty
assert property(af_p447);

property af_p448;
@(posedge clk) (owr_e && (owr_p == 1'b0)) |-> ##1 (owr_i == 1'b0);
endproperty
assert property(af_p448);

property af_p449;
@(posedge clk) (rst) |-> (owr_i == 1'b0);
endproperty
assert property(af_p449);

property af_p450;
@(posedge clk) (bus_wen) |-> ##1 (owr_p == bus_wdt);
endproperty
assert property(af_p450);

property af_p451;
@(posedge clk) (owr_p && owr_e) |=> (owr_i == owr_p);
endproperty
assert property(af_p451);

property af_p452;
@(posedge clk) ($changed(bus_adr)) |-> $stable(owr_p);
endproperty
assert property(af_p452);

property af_p453;
@(posedge clk) (owr_p == 1) |=> (owr_i == 1);
endproperty
assert property(af_p453);

property af_p454;
@(posedge clk) ($fell(rst)) |-> ##4 $stable(owr_p);
endproperty
assert property(af_p454);

property af_p455;
@(posedge clk) (!owr_e) |-> ((owr_p == 0) || (owr_p == 1)) ##1 $stable(owr_p);
endproperty
assert property(af_p455);

property af_p456;
@(posedge clk) (bus_wen || bus_ren) |-> $stable(owr_p);
endproperty
assert property(af_p456);

property af_p457;
@(posedge clk) ($fell(rst)) |-> ##[1:3] (owr_p == 0);
endproperty
assert property(af_p457);

property af_p458;
@(posedge clk) ($stable(owr_e)) |-> $stable(owr_p);
endproperty
assert property(af_p458);

property af_p459;
@(posedge clk) ($fell(rst)) |-> ##4 ((owr_p >= 0) && (owr_p <= 1));
endproperty
assert property(af_p459);

property af_p460;
@(posedge clk) (rst) |-> (owr_p == 0);
endproperty
assert property(af_p460);

property af_p461;
@(posedge clk) disable iff (!rst) ($fell(rst)) |-> ##1 $stable(owr_p)[*4];
endproperty
assert property(af_p461);

property af_p462;
@(posedge clk) $changed(owr_p) |-> ##1 $stable(owr_p)[*2];
endproperty
assert property(af_p462);

property af_p463;
@(posedge clk) $changed(owr_p) |-> $stable(bus_irq);
endproperty
assert property(af_p463);

property af_p464;
@(posedge clk) (owr_p == 1'b1) |=> (owr_i !== 1'bz);
endproperty
assert property(af_p464);

property af_p465;
@(posedge clk) (owr_p == 1'b0) || (owr_p == 1'b1);
endproperty
assert property(af_p465);

property af_p466;
@(posedge clk) (owr_p == 1'b0) |=> (owr_p == 1'b0);
endproperty
assert property(af_p466);

property af_p467;
@(posedge clk) $rose(rst) |-> (owr_p == 1'b0);
endproperty
assert property(af_p467);

property af_p468;
@(posedge clk) disable iff (!rst) (rst) |-> $stable(owr_p);
endproperty
assert property(af_p468);

property af_p469;
@(posedge clk) (owr_p) |=> (owr_i == $past(owr_p));
endproperty
assert property(af_p469);

property af_p470;
@(posedge clk) (owr_p == 1'b0) |-> ##[1:$] $stable(owr_p);
endproperty
assert property(af_p470);

property af_p471;
@(posedge clk) (owr_p && owr_e) |=> (owr_i == $past(owr_p));
endproperty
assert property(af_p471);

property af_p472;
@(posedge clk) (rst) |=> (owr_p == 1'b0);
endproperty
assert property(af_p472);

property af_p473;
@(posedge clk) (!bus_wen) |=> ($stable(owr_p));
endproperty
assert property(af_p473);


property af_p475;
@(posedge clk) (owr_p == 1'b1) |=> (owr_i == owr_p);
endproperty
assert property(af_p475);

property af_p476;
@(posedge clk) ($rose(owr_p)) |-> ##1 (owr_i == owr_p);
endproperty
assert property(af_p476);

property af_p477;
@(posedge clk) (owr_p && owr_e) |-> ##1 (owr_i == (owr_p | owr_e));
endproperty
assert property(af_p477);

property af_p478;
@(posedge clk) ($stable(owr_e)) |-> ($stable(owr_p));
endproperty
assert property(af_p478);

property af_p479;
@(posedge clk) ($fell(rst)) |-> (owr_p == 1'b0) ##1 (owr_p == 1'b0) ##1 (owr_p == 1'b0);
endproperty
assert property(af_p479);

property af_p480;
@(posedge clk) (owr_p >= 1'b0) && (owr_p <= 1'b1);
endproperty
assert property(af_p480);

property af_p481;
@(posedge clk) (bus_wen || bus_ren) |-> ((owr_p == 1'b0) || (owr_p == 1'b1));
endproperty
assert property(af_p481);


property af_p483;
@(posedge clk) (owr_e == 8'h00) |-> $stable(owr_p);
endproperty
assert property(af_p483);


































































property af_p549;
@(posedge clk) (!rst) |-> (bus_wdt[0] == 1'b0 || rst == 1'b0);
endproperty
assert property(af_p549);

property af_p550;
@(posedge clk) (rst !== $past(rst)) |-> ($past(bus_wen) == 1'b1);
endproperty
assert property(af_p550);


property af_p552;
@(posedge clk) (rst) |-> (rst == $past(rst)) throughout (##[1:$] $fell(clk));
endproperty
assert property(af_p552);


property af_p554;
@(posedge clk) (bus_wen) |=> (rst == $past(rst));
endproperty
assert property(af_p554);

property af_p555;
@(posedge clk) (rst && (bus_wdt[0] == 1'b0)) |-> (rst == 1'b1);
endproperty
assert property(af_p555);


property af_p557;
@(posedge clk) (rst) |-> (owr_e throughout (##[1:$] !owr_e));
endproperty
assert property(af_p557);

property af_p558;
@(posedge clk) (bus_ren) |-> (bus_rdt[0] == rst);
endproperty
assert property(af_p558);

property af_p559;
@(posedge clk) (!bus_wen) |-> (rst == $past(rst));
endproperty
assert property(af_p559);




property af_p563;
@(posedge clk) (bus_wen) |=> (bus_rdt == $past(bus_wdt));
endproperty
assert property(af_p563);











property af_p574;
@(posedge clk) (rst) |=> owr_p;
endproperty
assert property(af_p574);

property af_p575;
@(posedge clk) (rst) |-> owr_e;
endproperty
assert property(af_p575);




