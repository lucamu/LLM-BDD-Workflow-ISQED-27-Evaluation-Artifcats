// AssertionForge baseline SVA for amber
// 368 assertions captured from gen_plan.generate_svas

property af_p0;
@(posedge i_clk) 1'b1 |-> !$isunknown(i_wb_dat);
endproperty
assert property(af_p0);

property af_p1;
@(posedge i_clk) (i_irq || i_firq) |-> ##1 $stable(i_irq) && $stable(i_firq);
endproperty
assert property(af_p1);

property af_p2;
@(posedge i_clk) 1'b1 |=> $stable(o_wb_cyc);
endproperty
assert property(af_p2);

property af_p3;
@(posedge i_clk) 1'b1 |-> !$isunknown(i_wb_err);
endproperty
assert property(af_p3);

property af_p4;
@(posedge i_clk) 1'b1 |=> $stable(o_wb_we);
endproperty
assert property(af_p4);

property af_p5;
@(posedge i_clk) 1'b1 |-> !$isunknown(i_wb_ack);
endproperty
assert property(af_p5);

property af_p6;
@(posedge i_clk) 1'b1 |-> !$isunknown(i_clk);
endproperty
assert property(af_p6);

property af_p7;
@(posedge i_clk) 1'b1 |-> ($time - $past($time)) == ($past($time) - $past($time,2));
endproperty
assert property(af_p7);

property af_p8;
@(posedge i_clk) (i_irq) |-> $stable(o_wb_stb) && $stable(o_wb_cyc) throughout (##[1:$] (o_wb_ack || !o_wb_cyc));
endproperty
assert property(af_p8);

property af_p9;
@(posedge i_clk) 1'b1 |-> $stable(i_system_rdy) || $changed(i_system_rdy);
endproperty
assert property(af_p9);

property af_p10;
@(posedge i_clk) 1'b1 |-> !$isunknown(o_wb_cyc) && !$isunknown(o_wb_stb);
endproperty
assert property(af_p10);

property af_p11;
@(posedge i_clk) (i_wb_ack) |=> ($stable(o_wb_stb) === 0 || o_wb_stb == $past(o_wb_stb)) && ($stable(o_wb_cyc) === 0 || o_wb_cyc == $past(o_wb_cyc));
endproperty
assert property(af_p11);

property af_p12;
@(posedge i_clk) (i_firq) |-> ##0 $stable(i_firq_reg) throughout (!$rose(i_clk));
endproperty
assert property(af_p12);

property af_p13;
@(posedge i_clk) $changed(o_wb_adr) |-> $rose(i_clk);
endproperty
assert property(af_p13);

property af_p14;
@(posedge i_clk) (i_wb_ack) |-> $stable(i_wb_dat) throughout (i_wb_ack[->1]);
endproperty
assert property(af_p14);

property af_p15;
@(posedge i_clk) $changed(o_wb_we) |-> $rose(i_clk);
endproperty
assert property(af_p15);

property af_p16;
@(posedge i_clk) $changed(o_wb_dat) |-> $rose(i_clk);
endproperty
assert property(af_p16);

property af_p17;
@(posedge i_clk) (i_wb_err) |-> ##1 (1'b1);
endproperty
assert property(af_p17);

property af_p18;
@(posedge i_clk) (1'b1) |-> ##1 (i_clk == ~$past(i_clk));
endproperty
assert property(af_p18);

property af_p19;
@(posedge i_clk) $stable(o_wb_adr) or $rose(i_clk);
endproperty
assert property(af_p19);

property af_p20;
@(posedge i_clk) (1'b1) |-> (i_clk[*50]);
endproperty
assert property(af_p20);

property af_p21;
@(posedge i_clk) (1'b1) |-> ##1 (i_clk == 1'b1);
endproperty
assert property(af_p21);

property af_p22;
@(posedge i_clk) (i_irq) |-> !$changed(i_irq_state) until (posedge i_clk);
endproperty
assert property(af_p22);

property af_p23;
@(posedge i_clk) !i_system_rdy |-> ##1 $rose(i_clk);
endproperty
assert property(af_p23);

property af_p24;
@(posedge i_clk) i_firq |=> $past(i_firq);
endproperty
assert property(af_p24);

property af_p25;
@(posedge i_clk) 1'b1 |-> $stable(o_wb_stb);
endproperty
assert property(af_p25);

property af_p26;
@(posedge i_clk) $changed(i_system_rdy) |=> $stable({o_wb_stb, o_wb_cyc, o_wb_we, o_wb_sel, o_wb_adr, o_wb_dat});
endproperty
assert property(af_p26);

property af_p27;
@(posedge i_clk) i_irq |=> $stable(i_irq);
endproperty
assert property(af_p27);

property af_p28;
@(posedge i_clk) (1) |-> (i_firq === 1'b0 || i_firq === 1'b1);
endproperty
assert property(af_p28);

property af_p29;
@(posedge i_clk) (o_wb_cyc && !i_wb_ack) |-> $stable(i_firq);
endproperty
assert property(af_p29);

property af_p30;
@(posedge i_clk) (i_firq [*1:$] ##0 (o_wb_cyc && !i_wb_ack && !i_wb_err)) |-> (o_wb_adr != FIRQ_VECTOR);
endproperty
assert property(af_p30);

property af_p31;
@(posedge i_clk) (i_firq) |-> ##[1:$] (o_wb_adr == FIRQ_VECTOR);
endproperty
assert property(af_p31);

property af_p32;
@(posedge i_clk) (!i_firq) |=> (o_wb_adr != FIRQ_VECTOR);
endproperty
assert property(af_p32);

property af_p33;
@(posedge i_clk) (i_irq && i_firq) |=> (o_wb_adr == FIRQ_VECTOR);
endproperty
assert property(af_p33);

property af_p34;
@(posedge i_clk) (i_firq && !i_system_rdy) |-> (o_wb_adr != FIRQ_VECTOR);
endproperty
assert property(af_p34);

property af_p35;
@(posedge i_clk) ($rose(i_firq) ##1 $fell(i_firq) ##1 $rose(i_firq)) |-> (o_wb_adr != FIRQ_VECTOR) throughout (o_wb_cyc)[->1];
endproperty
assert property(af_p35);

property af_p36;
@(posedge i_clk) (i_firq [*2:$] ##0 !o_wb_ack) |-> (o_wb_adr != FIRQ_VECTOR);
endproperty
assert property(af_p36);

property af_p37;
@(posedge i_clk) (i_firq && !i_system_rdy) |-> !$changed(o_wb_adr) until (i_system_rdy);
endproperty
assert property(af_p37);

property af_p38;
@(posedge i_clk) ($rose(i_firq) && o_wb_cyc && o_wb_stb) |-> (o_wb_adr == $past(o_wb_adr));
endproperty
assert property(af_p38);

property af_p39;
@(posedge i_clk) (o_wb_cyc) |-> $stable(i_firq);
endproperty
assert property(af_p39);

property af_p40;
@(posedge i_clk) (!i_firq) |-> $stable(o_wb_adr);
endproperty
assert property(af_p40);

property af_p41;
@(posedge i_clk) (i_firq && i_irq) |-> (o_wb_adr !== 'x) && (o_wb_adr !== 'z);
endproperty
assert property(af_p41);

property af_p42;
@(posedge i_clk) (i_irq && i_firq) |-> (o_wb_adr == FIRQ_VECTOR);
endproperty
assert property(af_p42);

property af_p43;
@(posedge i_clk) (i_firq && i_system_rdy) |-> ##[1:$] ($rose(instr_complete) ##1 $changed(o_wb_adr) ##1 $stable(o_wb_adr) until ($fell(i_firq) || !i_firq));
endproperty
assert property(af_p43);

property af_p44;
@(posedge i_clk) ($fell(i_firq) && !instr_complete) |-> (o_wb_adr != FIRQ_VECTOR);
endproperty
assert property(af_p44);

property af_p45;
@(posedge i_clk) ($rose(i_firq)) |-> !$changed(o_wb_adr) until (instr_complete);
endproperty
assert property(af_p45);

property af_p46;
@(posedge i_clk) ($fell(i_firq) && $past(o_wb_adr == FIRQ_VECTOR_ADDR)) |-> (o_wb_adr != FIRQ_VECTOR_ADDR) until (i_firq);
endproperty
assert property(af_p46);

property af_p47;
@(posedge i_clk) (i_firq && i_system_rdy) |-> ##[1:$] (o_wb_cyc && o_wb_stb && o_wb_adr == FIRQ_VECTOR_ADDR);
endproperty
assert property(af_p47);

property af_p48;
@(posedge i_clk) (o_wb_adr == FIRQ_VECTOR_ADDR) |-> ##1 (i_firq |-> (o_wb_adr != FIRQ_VECTOR_ADDR)) until (!i_firq);
endproperty
assert property(af_p48);

property af_p49;
@(posedge i_clk) $fell(i_firq) |-> ##[1:$] (o_wb_stb && o_wb_cyc);
endproperty
assert property(af_p49);

property af_p50;
@(posedge i_clk) (i_firq && o_wb_cyc && o_wb_stb) |-> ($stable(o_wb_adr) && $stable(o_wb_dat) && $stable(o_wb_sel)) throughout (o_wb_cyc[*1:$]);
endproperty
assert property(af_p50);

property af_p51;
@(posedge i_clk) (i_firq && i_wb_err) |-> (o_wb_adr != FIRQ_VECTOR_ADDR) until (!i_wb_err);
endproperty
assert property(af_p51);

property af_p52;
@(posedge i_clk) (i_firq && !i_system_rdy) |-> (o_wb_adr != FIRQ_VECTOR_ADDR) until (i_system_rdy);
endproperty
assert property(af_p52);

property af_p53;
@(posedge i_clk) $rose(i_firq) |-> i_firq throughout (##[1:$] (o_wb_adr == FIRQ_VECTOR_ADDR))[->1];
endproperty
assert property(af_p53);

property af_p54;
@(posedge i_clk) $rose(i_irq) |-> ##0 (i_irq === $sampled(i_irq));
endproperty
assert property(af_p54);

property af_p55;
@(posedge i_clk) (i_irq && $past(i_irq)) |-> ($rose(irq_mode_entered) == 1'b0);
endproperty
assert property(af_p55);

property af_p56;
@(posedge i_clk) (i_irq && !i_firq) |-> !i_firq;
endproperty
assert property(af_p56);

property af_p57;
@(posedge i_clk) ($fell(i_irq)) |-> !($rose(irq_mode_entered));
endproperty
assert property(af_p57);

property af_p58;
@(posedge i_clk) i_irq |-> !$isunknown(i_irq);
endproperty
assert property(af_p58);

property af_p59;
@(posedge i_clk) (i_irq && !i_system_rdy) |-> (!o_wb_stb) until (i_system_rdy);
endproperty
assert property(af_p59);

property af_p60;
@(posedge i_clk) (i_irq && !i_system_rdy) |-> !irq_mode_entered;
endproperty
assert property(af_p60);

property af_p61;
@(posedge i_clk) (i_irq && !instr_complete) |-> !irq_mode_entered;
endproperty
assert property(af_p61);

property af_p62;
@(posedge i_clk) (!i_irq) |-> !irq_mode_entered;
endproperty
assert property(af_p62);

property af_p63;
@(posedge i_clk) $fell(i_irq) |-> (irq_mode_entered until instr_complete);
endproperty
assert property(af_p63);

property af_p64;
@(posedge i_clk) (i_irq && o_wb_cyc) |-> (!irq_mode_entered) until (o_wb_cyc == 1'b0);
endproperty
assert property(af_p64);

property af_p65;
@(posedge i_clk) (i_irq && o_wb_cyc) |-> o_wb_cyc throughout (##[1:$] !o_wb_cyc);
endproperty
assert property(af_p65);

property af_p66;
@(posedge i_clk) (i_irq && $past(i_irq)) |-> $stable(i_irq);
endproperty
assert property(af_p66);

property af_p67;
@(posedge i_clk) (i_irq && i_firq) |-> ##[1:5] (i_irq || i_firq);
endproperty
assert property(af_p67);

property af_p68;
@(posedge i_clk) $rose(i_irq) |-> (i_irq[*1:$] ##1 $fell(i_irq));
endproperty
assert property(af_p68);

property af_p69;
@(posedge i_clk) (i_irq && !i_wb_ack) |-> ##[1:$] i_wb_ack;
endproperty
assert property(af_p69);

property af_p70;
@(posedge i_clk) $fell(i_irq) |-> ##[1:5] !i_irq;
endproperty
assert property(af_p70);

property af_p71;
@(posedge i_clk) i_irq |-> (i_irq throughout (##[1:50] 1));
endproperty
assert property(af_p71);

property af_p72;
@(posedge i_clk) (i_irq && i_wb_err) |-> ##[1:50] (i_irq throughout (##[1:50] 1));
endproperty
assert property(af_p72);

property af_p73;
@(posedge i_clk) (i_irq && i_firq) |-> !(o_wb_cyc && $past(!o_wb_cyc) && $past(!i_irq) && $past(!i_firq));
endproperty
assert property(af_p73);

property af_p74;
@(posedge i_clk) ($rose(i_irq) ##1 $fell(i_irq) ##1 $rose(i_irq)) |-> ##[1:$] $fell(i_irq);
endproperty
assert property(af_p74);

property af_p75;
@(posedge i_clk) $rose(i_irq) |-> (o_wb_adr === $past(o_wb_adr)) throughout (i_irq[*1:$]);
endproperty
assert property(af_p75);

property af_p76;
@(posedge i_clk) $changed(i_wb_ack) |-> !$isunknown(i_irq);
endproperty
assert property(af_p76);

property af_p77;
@(posedge i_clk) i_irq |-> (!$isunknown(o_wb_stb) && !$isunknown(o_wb_we));
endproperty
assert property(af_p77);

property af_p78;
@(posedge i_clk) (1'b1) |-> !$isunknown(i_irq);
endproperty
assert property(af_p78);

property af_p79;
@(posedge i_clk) $fell(i_irq) |-> ##1 !i_irq;
endproperty
assert property(af_p79);

property af_p80;
@(posedge i_clk) !$isunknown(i_irq);
endproperty
assert property(af_p80);

property af_p81;
@(posedge i_clk) (i_irq && i_wb_err) |-> !$isunknown(o_wb_cyc);
endproperty
assert property(af_p81);

property af_p82;
@(posedge i_clk) $rose(i_irq) |-> i_irq or ##1 i_irq;
endproperty
assert property(af_p82);

property af_p83;
@(posedge i_clk) $rose(i_irq) |-> ##1 i_irq;
endproperty
assert property(af_p83);

property af_p84;
@(posedge i_clk) (i_irq && o_wb_cyc && o_wb_stb) |-> ##[1:$] (!o_wb_cyc && !o_wb_stb);
endproperty
assert property(af_p84);

property af_p85;
@(posedge i_clk) (!i_system_rdy) |-> (!$rose(i_irq) && !$rose(i_firq));
endproperty
assert property(af_p85);

property af_p86;
@(posedge i_clk) (!i_system_rdy) |-> (!o_wb_cyc && !o_wb_stb);
endproperty
assert property(af_p86);

property af_p87;
@(posedge i_clk) (i_system_rdy) |-> $stable(o_wb_we) || (o_wb_we == 1'b0) || (o_wb_we == 1'b1);
endproperty
assert property(af_p87);

property af_p88;
@(posedge i_clk) (i_system_rdy) |=> o_wb_cyc;
endproperty
assert property(af_p88);

property af_p89;
@(posedge i_clk) ($rose(i_system_rdy)) |=> ##[0:$] o_wb_stb;
endproperty
assert property(af_p89);

property af_p90;
@(posedge i_clk) (i_irq && !i_system_rdy) |-> (!o_wb_cyc throughout !i_system_rdy[*1:$]);
endproperty
assert property(af_p90);

property af_p91;
@(posedge i_clk) (!i_system_rdy) |-> ##1 $stable(i_wb_ack) || !i_wb_ack;
endproperty
assert property(af_p91);

property af_p92;
@(posedge i_clk) (i_system_rdy && i_irq) |-> !o_wb_cyc;
endproperty
assert property(af_p92);

property af_p93;
@(posedge i_clk) (!i_system_rdy) |-> $stable(o_wb_sel);
endproperty
assert property(af_p93);

property af_p94;
@(posedge i_clk) $rose(i_system_rdy) |-> ##[1:4] o_wb_stb;
endproperty
assert property(af_p94);

property af_p95;
@(posedge i_clk) (i_firq && !i_system_rdy) |-> (!o_wb_stb throughout i_system_rdy[->1]);
endproperty
assert property(af_p95);

property af_p96;
@(posedge i_clk) (!i_system_rdy) |-> $stable(o_wb_adr);
endproperty
assert property(af_p96);

property af_p97;
@(posedge i_clk) 1'b1 |-> !$isunknown(o_wb_we);
endproperty
assert property(af_p97);

property af_p98;
@(posedge i_clk) $fell(i_system_rdy) |=> (!o_wb_cyc && !o_wb_stb);
endproperty
assert property(af_p98);

property af_p99;
@(posedge i_clk) (o_wb_cyc || o_wb_stb) |-> $past(i_system_rdy);
endproperty
assert property(af_p99);

property af_p100;
@(posedge i_clk) (!i_system_rdy) |-> !o_wb_cyc;
endproperty
assert property(af_p100);

property af_p101;
@(posedge i_clk) $rose(i_system_rdy) |-> ##[1:4] (o_wb_cyc && o_wb_stb);
endproperty
assert property(af_p101);

property af_p102;
@(posedge i_clk) (!i_system_rdy) |-> (o_wb_we == $past(o_wb_we));
endproperty
assert property(af_p102);

property af_p103;
@(posedge i_clk) ($fell(i_system_rdy) && o_wb_cyc) |=> o_wb_cyc && o_wb_stb;
endproperty
assert property(af_p103);

property af_p104;
@(posedge i_clk) !(i_wb_ack && (i_irq || i_firq) && !o_wb_stb);
endproperty
assert property(af_p104);

property af_p105;
@(posedge i_clk) !(i_wb_ack && i_wb_err);
endproperty
assert property(af_p105);

property af_p106;
@(posedge i_clk) i_wb_ack |-> !i_wb_err;
endproperty
assert property(af_p106);

property af_p107;
@(posedge i_clk) i_wb_ack |-> o_wb_stb;
endproperty
assert property(af_p107);

property af_p108;
@(posedge i_clk) (i_wb_ack && o_wb_stb) |-> ##1 (!$past(o_wb_stb) || !o_wb_stb);
endproperty
assert property(af_p108);

property af_p109;
@(posedge i_clk) (i_wb_ack && o_wb_we) |-> !$isunknown(o_wb_dat);
endproperty
assert property(af_p109);

property af_p110;
@(posedge i_clk) (i_wb_ack && !o_wb_we) |-> !$isunknown(i_wb_dat);
endproperty
assert property(af_p110);

property af_p111;
@(posedge i_clk) o_wb_cyc |-> (o_wb_cyc throughout (!i_wb_ack)[*0:$] ##1 i_wb_ack) or (o_wb_cyc[*1:$] ##1 i_wb_ack ##1 (o_wb_cyc || !o_wb_cyc));
endproperty
assert property(af_p111);

property af_p112;
@(posedge i_clk) (i_wb_ack && o_wb_we) |-> ##1 !o_wb_stb;
endproperty
assert property(af_p112);

property af_p113;
@(posedge i_clk) !i_system_rdy |-> $stable(i_wb_ack);
endproperty
assert property(af_p113);

property af_p114;
@(posedge i_clk) (!i_system_rdy) |-> !i_wb_ack;
endproperty
assert property(af_p114);

property af_p115;
@(posedge i_clk) i_wb_ack |=> !i_wb_ack;
endproperty
assert property(af_p115);

property af_p116;
@(posedge i_clk) (i_wb_ack && o_wb_stb && !o_wb_we) |-> !$isunknown(i_wb_dat);
endproperty
assert property(af_p116);

property af_p117;
@(posedge i_clk) i_wb_ack ##1 $changed(o_wb_adr));
endproperty
assert property(af_p117);

property af_p118;
@(posedge i_clk) $rose(i_wb_ack) |-> (o_wb_cyc && o_wb_stb);
endproperty
assert property(af_p118);

property af_p119;
@(posedge i_clk) $rose(i_wb_ack) |-> o_wb_stb;
endproperty
assert property(af_p119);

property af_p120;
@(posedge i_clk) (!o_wb_stb) |-> !i_wb_ack;
endproperty
assert property(af_p120);

property af_p121;
@(posedge i_clk) i_wb_ack |-> o_wb_cyc;
endproperty
assert property(af_p121);

property af_p122;
@(posedge i_clk) $fell(i_system_rdy) |=> (!i_wb_ack) until_with i_system_rdy;
endproperty
assert property(af_p122);

property af_p123;
@(posedge i_clk) i_wb_ack |-> (o_wb_stb && o_wb_cyc);
endproperty
assert property(af_p123);

property af_p124;
@(posedge i_clk) o_wb_cyc |-> (o_wb_cyc s_until i_wb_ack);
endproperty
assert property(af_p124);

property af_p125;
@(posedge i_clk) i_wb_ack |=> !o_wb_stb;
endproperty
assert property(af_p125);

property af_p126;
@(posedge i_clk) (i_wb_ack && o_wb_we) |-> $stable(o_wb_sel);
endproperty
assert property(af_p126);

property af_p127;
@(posedge i_clk) i_wb_ack |-> (o_wb_we && !$isunknown(o_wb_dat));
endproperty
assert property(af_p127);

property af_p128;
@(posedge i_clk) !o_wb_cyc |-> !i_wb_ack;
endproperty
assert property(af_p128);

property af_p129;
@(posedge i_clk) (i_wb_ack && o_wb_we) |=> $stable(o_wb_dat);
endproperty
assert property(af_p129);

property af_p130;
@(posedge i_clk) (i_wb_ack && !o_wb_stb) |=> !i_wb_ack;
endproperty
assert property(af_p130);

property af_p131;
@(posedge i_clk) !i_system_rdy |=> !i_wb_ack;
endproperty
assert property(af_p131);

property af_p132;
@(posedge i_clk) i_wb_ack |-> $stable(o_wb_sel);
endproperty
assert property(af_p132);

property af_p133;
@(posedge i_clk) (!i_system_rdy) |-> (1'b1);
endproperty
assert property(af_p133);

property af_p134;
@(posedge i_clk) ($rose(i_wb_ack)) |-> ((i_wb_dat >= 0) && (i_wb_dat <= 32'hFFFFFFFF));
endproperty
assert property(af_p134);

property af_p135;
@(posedge i_clk) (i_system_rdy) |-> ##3 ((i_wb_dat >= 0) && (i_wb_dat <= 32'hFFFFFFFF));
endproperty
assert property(af_p135);

property af_p136;
@(posedge i_clk) (o_wb_cyc && i_wb_ack) |-> ((i_wb_dat >= 0) && (i_wb_dat <= 32'hFFFFFFFF));
endproperty
assert property(af_p136);

property af_p137;
@(posedge i_clk) (i_wb_ack) |-> ((i_wb_dat >= 0) && (i_wb_dat <= 32'hFFFFFFFF));
endproperty
assert property(af_p137);

property af_p138;
@(posedge i_clk) (o_wb_we) |-> (1'b1);
endproperty
assert property(af_p138);

property af_p139;
@(posedge i_clk) (!o_wb_cyc && !i_wb_ack) |-> $stable(i_wb_dat);
endproperty
assert property(af_p139);

property af_p140;
@(posedge i_clk) (o_wb_stb && !o_wb_we) |-> ##1 $stable(i_wb_dat);
endproperty
assert property(af_p140);

property af_p141;
@(posedge i_clk) (i_wb_ack) |-> $stable(i_wb_dat);
endproperty
assert property(af_p141);

property af_p142;
@(posedge i_clk) (o_wb_stb && o_wb_cyc && !o_wb_we) |-> ##[1:10] (i_wb_ack && (i_wb_dat >= 0) && (i_wb_dat <= 32'hFFFFFFFF));
endproperty
assert property(af_p142);

property af_p143;
@(posedge i_clk) (i_wb_ack) |-> (!$isunknown(i_wb_dat));
endproperty
assert property(af_p143);

property af_p144;
@(posedge i_clk) (i_wb_ack && !o_wb_we) |-> (i_wb_dat >= 0 && i_wb_dat <= 32'hFFFFFFFF);
endproperty
assert property(af_p144);

property af_p145;
@(posedge i_clk) (i_wb_err) |-> (1'b1);
endproperty
assert property(af_p145);

property af_p146;
@(posedge i_clk) ($fell(i_wb_ack)) |=> $stable(i_wb_dat);
endproperty
assert property(af_p146);

property af_p147;
@(posedge i_clk) (i_wb_ack && (i_wb_dat >= 0 && i_wb_dat <= 65535)) |=> (i_wb_ack |-> (i_wb_dat >= 0 && i_wb_dat <= 32'hFFFFFFFF));
endproperty
assert property(af_p147);

property af_p148;
@(posedge i_clk) (!i_wb_ack) |-> $stable(i_wb_dat);
endproperty
assert property(af_p148);

property af_p149;
@(posedge i_clk) (i_wb_ack) |=> $stable(i_wb_dat);
endproperty
assert property(af_p149);

property af_p150;
@(posedge i_clk) (!o_wb_cyc) |-> (1'b1);
endproperty
assert property(af_p150);

property af_p151;
@(posedge i_clk) (!i_system_rdy) |-> $stable(i_wb_dat);
endproperty
assert property(af_p151);

property af_p152;
@(posedge i_clk) ((i_irq || i_firq) && i_wb_ack) |-> (!$isunknown(i_wb_dat));
endproperty
assert property(af_p152);

property af_p153;
@(posedge i_clk) (o_wb_adr && o_wb_stb && o_wb_cyc && i_wb_ack) |-> !$isunknown(i_wb_dat);
endproperty
assert property(af_p153);

property af_p154;
@(posedge i_clk) ($past(i_system_rdy,4) && i_system_rdy) |-> (i_wb_dat >= 0 && i_wb_dat <= 32'hFFFFFFFF);
endproperty
assert property(af_p154);

property af_p155;
@(posedge i_clk) ($rose(i_wb_ack) && !o_wb_we) |-> !$isunknown(i_wb_dat);
endproperty
assert property(af_p155);

property af_p156;
@(posedge i_clk) (i_wb_err) |-> !(i_wb_ack && !$isunknown(i_wb_dat));
endproperty
assert property(af_p156);

property af_p157;
@(posedge i_clk) (i_wb_ack) |-> !$isunknown(i_wb_dat);
endproperty
assert property(af_p157);

property af_p158;
@(posedge i_clk) (i_wb_err) |-> !(i_wb_ack && !$isunknown(i_wb_dat)) ##1 1'b1;
endproperty
assert property(af_p158);

property af_p159;
@(posedge i_clk) (!o_wb_we && o_wb_stb && i_wb_ack) |-> !$isunknown(i_wb_dat);
endproperty
assert property(af_p159);

property af_p160;
@(posedge i_clk) (i_wb_ack) |-> !$isunknown(i_wb_dat) && $stable(i_wb_dat);
endproperty
assert property(af_p160);

property af_p161;
@(posedge i_clk) (i_wb_ack) |-> (!$isunknown(i_wb_dat)) ##1 (!i_wb_ack |-> $stable(i_wb_dat));
endproperty
assert property(af_p161);

property af_p162;
@(posedge i_clk) (i_system_rdy && i_wb_ack) |-> !$isunknown(i_wb_dat);
endproperty
assert property(af_p162);

property af_p163;
@(posedge i_clk) (i_wb_err inside {0,1});
endproperty
assert property(af_p163);

property af_p164;
@(posedge i_clk) (o_wb_stb == $past(o_wb_stb)) |-> ##1 (o_wb_stb == $past(o_wb_stb, 1)) || (i_wb_err || !i_wb_err);
endproperty
assert property(af_p164);

property af_p165;
@(posedge i_clk) (i_system_rdy && i_wb_err && $past(i_wb_err) && $past(i_wb_err,2)) |-> (o_wb_cyc == $past(o_wb_cyc));
endproperty
assert property(af_p165);

property af_p166;
@(posedge i_clk) (!i_system_rdy) |-> (!i_wb_err);
endproperty
assert property(af_p166);

property af_p167;
@(posedge i_clk) (i_wb_err && !i_wb_ack) |-> (o_wb_stb == 1'b1);
endproperty
assert property(af_p167);

property af_p168;
@(posedge i_clk) (i_wb_err && $past(i_wb_err) && $past(i_wb_err,2)) |-> (o_wb_sel == $past(o_wb_sel));
endproperty
assert property(af_p168);

property af_p169;
@(posedge i_clk) (i_wb_err && i_wb_ack) |=> (o_wb_stb == $past(o_wb_stb));
endproperty
assert property(af_p169);

property af_p170;
@(posedge i_clk) (i_wb_ack && $changed(i_wb_err)) |-> (o_wb_we == $past(o_wb_we));
endproperty
assert property(af_p170);

property af_p171;
@(posedge i_clk) (i_wb_ack) |-> (i_wb_dat == i_wb_dat);
endproperty
assert property(af_p171);

property af_p172;
@(posedge i_clk) ($rose(i_wb_err) && o_wb_stb) |-> (o_wb_sel == $past(o_wb_sel));
endproperty
assert property(af_p172);

property af_p173;
@(posedge i_clk) (i_wb_err && o_wb_cyc) |-> $stable(o_wb_we);
endproperty
assert property(af_p173);

property af_p174;
@(posedge i_clk) (i_wb_ack && i_wb_err) |=> $stable(i_wb_dat);
endproperty
assert property(af_p174);

property af_p175;
@(posedge i_clk) (i_wb_err && o_wb_cyc) |=> $stable(o_wb_cyc);
endproperty
assert property(af_p175);

property af_p176;
@(posedge i_clk) (o_wb_we && i_wb_err) |=> $stable(o_wb_dat);
endproperty
assert property(af_p176);

property af_p177;
@(posedge i_clk) (i_wb_err && o_wb_we) |-> $stable(o_wb_dat);
endproperty
assert property(af_p177);

property af_p178;
@(posedge i_clk) ($rose(i_wb_err) ##1 $fell(i_wb_err)) |-> ($stable(o_wb_cyc) && $stable(o_wb_stb));
endproperty
assert property(af_p178);

property af_p179;
@(posedge i_clk) i_wb_err |=> $stable(o_wb_adr);
endproperty
assert property(af_p179);

property af_p180;
@(posedge i_clk) (i_wb_ack && i_wb_err) |=> $stable(o_wb_adr);
endproperty
assert property(af_p180);

property af_p181;
@(posedge i_clk) i_wb_err |-> ($stable(i_irq) && $stable(i_firq));
endproperty
assert property(af_p181);

property af_p182;
@(posedge i_clk) $changed(i_wb_err) |-> $stable(o_wb_we);
endproperty
assert property(af_p182);

property af_p183;
@(posedge i_clk) (i_wb_err && !o_wb_we) |-> (i_wb_dat !== 32'bx);
endproperty
assert property(af_p183);

property af_p184;
@(posedge i_clk) i_wb_err |-> ($stable(o_wb_adr) || (o_wb_adr == ($past(o_wb_adr) + 4)));
endproperty
assert property(af_p184);

property af_p185;
@(posedge i_clk) i_wb_err |-> ##[1:3] $stable(o_wb_stb);
endproperty
assert property(af_p185);

property af_p186;
@(posedge i_clk) $changed(i_wb_err) |-> $stable(o_wb_dat);
endproperty
assert property(af_p186);

property af_p187;
@(posedge i_clk) $changed(i_wb_err) |-> ##1 $stable(o_wb_sel);
endproperty
assert property(af_p187);

property af_p188;
@(posedge i_clk) ($rose(i_irq) && i_wb_err) |-> ##1 $stable(o_wb_stb);
endproperty
assert property(af_p188);

property af_p189;
@(posedge i_clk) $rose(i_wb_err) |-> ##1 $stable(o_wb_cyc);
endproperty
assert property(af_p189);

property af_p190;
@(posedge i_clk) $changed(i_wb_err) |-> $stable(o_wb_cyc);
endproperty
assert property(af_p190);

property af_p191;
@(posedge i_clk) 1'b1 |-> (i_wb_err === 1'b0 || i_wb_err === 1'b1);
endproperty
assert property(af_p191);

property af_p192;
@(posedge i_clk) (i_system_rdy && i_wb_err) |-> $stable(o_wb_cyc);
endproperty
assert property(af_p192);

property af_p193;
@(posedge i_clk) (o_wb_cyc && !i_wb_ack) |-> $stable(o_wb_adr);
endproperty
assert property(af_p193);

property af_p194;
@(posedge i_clk) o_wb_cyc |-> ($stable(o_wb_adr) until i_wb_ack);
endproperty
assert property(af_p194);

property af_p195;
@(posedge i_clk) i_wb_err |=> (o_wb_adr != $past(o_wb_adr));
endproperty
assert property(af_p195);

property af_p196;
@(posedge i_clk) $changed(o_wb_adr) |-> $past(i_wb_ack);
endproperty
assert property(af_p196);

property af_p197;
@(posedge i_clk) (!i_system_rdy) |-> $stable(o_wb_adr);
endproperty
assert property(af_p197);

property af_p198;
@(posedge i_clk) (o_wb_cyc && o_wb_stb && !i_wb_ack) |-> $stable(o_wb_adr);
endproperty
assert property(af_p198);

property af_p199;
@(posedge i_clk) (o_wb_cyc && !i_wb_ack) |=> $stable(o_wb_adr);
endproperty
assert property(af_p199);

property af_p200;
@(posedge i_clk) i_wb_err |=> $stable(o_wb_adr);
endproperty
assert property(af_p200);

property af_p201;
@(posedge i_clk) (o_wb_cyc && o_wb_stb) |-> !$isunknown(o_wb_adr);
endproperty
assert property(af_p201);

property af_p202;
@(posedge i_clk) (!o_wb_stb) |=> ($stable(o_wb_adr));
endproperty
assert property(af_p202);

property af_p203;
@(posedge i_clk) (o_wb_stb && !i_wb_ack) |=> ($stable(o_wb_adr));
endproperty
assert property(af_p203);

property af_p204;
@(posedge i_clk) (i_wb_ack) |=> (o_wb_adr != $past(o_wb_adr));
endproperty
assert property(af_p204);

property af_p205;
@(posedge i_clk) (i_wb_ack) |-> (o_wb_adr == $past(o_wb_adr));
endproperty
assert property(af_p205);

property af_p206;
@(posedge i_clk) $fell(i_system_rdy) |=> (o_wb_adr == $past(o_wb_adr));
endproperty
assert property(af_p206);

property af_p207;
@(posedge i_clk) (o_wb_cyc) |-> (o_wb_adr >= 32'h00000000 && o_wb_adr <= 32'hFFFFFFFF);
endproperty
assert property(af_p207);

property af_p208;
@(posedge i_clk) $rose(o_wb_stb) |-> ($past(o_wb_adr) == $past(o_wb_adr, 2));
endproperty
assert property(af_p208);

property af_p209;
@(posedge i_clk) $rose(i_system_rdy) |=> (!$isunknown(o_wb_adr));
endproperty
assert property(af_p209);

property af_p210;
@(posedge i_clk) (!i_system_rdy) |=> ($stable(o_wb_adr));
endproperty
assert property(af_p210);

property af_p211;
@(posedge i_clk) (o_wb_stb) |-> (!$isunknown(o_wb_adr));
endproperty
assert property(af_p211);

property af_p212;
@(posedge i_clk) (o_wb_we) |-> (o_wb_adr >= 32'h00000000 && o_wb_adr <= 32'hFFFFFFFF) else (o_wb_adr[31:26] == 6'b000000);
endproperty
assert property(af_p212);

property af_p213;
@(posedge i_clk) (!o_wb_we) |-> (o_wb_adr[31:26] == 6'b000000);
endproperty
assert property(af_p213);

property af_p214;
@(posedge i_clk) i_wb_err |=> ($stable(o_wb_adr) until_with (!o_wb_cyc));
endproperty
assert property(af_p214);

property af_p215;
@(posedge i_clk) $changed(o_wb_adr) |-> o_wb_we;
endproperty
assert property(af_p215);

property af_p216;
@(posedge i_clk) (o_wb_stb && o_wb_cyc) |-> (!$isunknown(o_wb_adr));
endproperty
assert property(af_p216);

property af_p217;
@(posedge i_clk) (o_wb_we && i_wb_ack) |=> $stable(o_wb_adr);
endproperty
assert property(af_p217);

property af_p218;
@(posedge i_clk) (o_wb_stb && !i_wb_ack) |-> $stable(o_wb_adr);
endproperty
assert property(af_p218);

property af_p219;
@(posedge i_clk) $changed(o_wb_we) |-> $stable(o_wb_adr);
endproperty
assert property(af_p219);

property af_p220;
@(posedge i_clk) 1'b1 |-> $stable(o_wb_cyc) or $changed(o_wb_cyc);
endproperty
assert property(af_p220);

property af_p221;
@(posedge i_clk) $rose(i_wb_ack) |-> $past(o_wb_cyc);
endproperty
assert property(af_p221);

property af_p222;
@(posedge i_clk) $rose(i_system_rdy) |-> ($past(!o_wb_cyc,1) && $past(!o_wb_cyc,2) && $past(!o_wb_cyc,3));
endproperty
assert property(af_p222);

property af_p223;
@(posedge i_clk) ($fell(i_wb_ack) || $fell(i_wb_err)) |-> ##[0:1] !o_wb_cyc;
endproperty
assert property(af_p223);

property af_p224;
@(posedge i_clk) i_wb_err |-> ##1 !o_wb_cyc;
endproperty
assert property(af_p224);

property af_p225;
@(posedge i_clk) $rose(o_wb_cyc) |-> (o_wb_cyc throughout (##[0:$] i_wb_ack));
endproperty
assert property(af_p225);

property af_p226;
@(posedge i_clk) (!i_system_rdy) |-> (!o_wb_cyc);
endproperty
assert property(af_p226);

property af_p227;
@(posedge i_clk) (o_wb_cyc && o_wb_stb) |-> ##1 o_wb_cyc;
endproperty
assert property(af_p227);

property af_p228;
@(posedge i_clk) $rose(o_wb_cyc) |-> $past(i_system_rdy);
endproperty
assert property(af_p228);

property af_p229;
@(posedge i_clk) o_wb_cyc |-> o_wb_stb;
endproperty
assert property(af_p229);

property af_p230;
@(posedge i_clk) $rose(o_wb_stb) |-> (o_wb_cyc throughout (##[0:$] i_wb_ack));
endproperty
assert property(af_p230);

property af_p231;
@(posedge i_clk) (o_wb_cyc && !$past(o_wb_cyc)) |-> (o_wb_cyc throughout (i_wb_ack || i_wb_err)[->1]);
endproperty
assert property(af_p231);

property af_p232;
@(posedge i_clk) (o_wb_cyc && i_wb_err) |-> (!o_wb_cyc) or (!$past(o_wb_cyc) throughout ##1 (!o_wb_cyc));
endproperty
assert property(af_p232);

property af_p233;
@(posedge i_clk) (o_wb_cyc && i_wb_ack) |-> (!o_wb_cyc);
endproperty
assert property(af_p233);

property af_p234;
@(posedge i_clk) (i_wb_err) |=> (!o_wb_cyc);
endproperty
assert property(af_p234);

property af_p235;
@(posedge i_clk) (o_wb_cyc && !i_wb_ack) |-> (o_wb_cyc throughout (i_wb_ack && $stable(i_wb_dat) == 0)[->1]);
endproperty
assert property(af_p235);

property af_p236;
@(posedge i_clk) (!o_wb_cyc) |-> (!o_wb_stb);
endproperty
assert property(af_p236);

property af_p237;
@(posedge i_clk) (o_wb_stb) |-> (o_wb_cyc);
endproperty
assert property(af_p237);

property af_p238;
@(posedge i_clk) (o_wb_we) |-> (o_wb_cyc or ##1 o_wb_cyc);
endproperty
assert property(af_p238);

property af_p239;
@(posedge i_clk) (i_wb_ack) |=> (!o_wb_cyc);
endproperty
assert property(af_p239);

property af_p240;
@(posedge i_clk) (o_wb_stb) |-> (o_wb_cyc throughout i_wb_ack[->1]);
endproperty
assert property(af_p240);

property af_p241;
@(posedge i_clk) (o_wb_cyc && i_wb_ack) |-> ($sampled(i_wb_dat) === i_wb_dat) throughout (o_wb_cyc)[->1];
endproperty
assert property(af_p241);

property af_p242;
@(posedge i_clk) (o_wb_we && o_wb_stb) |-> (o_wb_cyc);
endproperty
assert property(af_p242);

property af_p243;
@(posedge i_clk) ($rose(o_wb_cyc)) |-> (o_wb_cyc until (i_wb_ack || i_wb_err));
endproperty
assert property(af_p243);

property af_p244;
@(posedge i_clk) ($fell(i_system_rdy)) |=> (!o_wb_cyc);
endproperty
assert property(af_p244);

property af_p245;
@(posedge i_clk) (o_wb_we && o_wb_stb) |-> (o_wb_cyc && !$isunknown(o_wb_dat));
endproperty
assert property(af_p245);

property af_p246;
@(posedge i_clk) (!i_irq && !i_firq) |-> (!o_wb_cyc);
endproperty
assert property(af_p246);

property af_p247;
@(posedge i_clk) ($changed(o_wb_adr)) |-> (o_wb_cyc);
endproperty
assert property(af_p247);

property af_p248;
@(posedge i_clk) !($rose(o_wb_cyc) && $fell(o_wb_cyc));
endproperty
assert property(af_p248);

property af_p249;
@(posedge i_clk) ($fell(i_system_rdy)) |=> (!o_wb_cyc[*2]);
endproperty
assert property(af_p249);

property af_p250;
@(posedge i_clk) ($rose(o_wb_stb)) |-> ($past(o_wb_cyc));
endproperty
assert property(af_p250);

property af_p251;
@(posedge i_clk) (o_wb_stb) |=> (o_wb_stb throughout ($stable(o_wb_dat)));
endproperty
assert property(af_p251);

property af_p252;
@(posedge i_clk) (i_wb_ack && o_wb_we) |=> (o_wb_stb |-> !$isunknown(o_wb_dat));
endproperty
assert property(af_p252);

property af_p253;
@(posedge i_clk) (o_wb_we && o_wb_stb) |-> (!$isunknown(o_wb_dat));
endproperty
assert property(af_p253);

property af_p254;
@(posedge i_clk) (i_wb_ack && o_wb_we) |=> ($stable(o_wb_dat));
endproperty
assert property(af_p254);

property af_p255;
@(posedge i_clk) (o_wb_stb) |-> (!$isunknown(o_wb_dat));
endproperty
assert property(af_p255);

property af_p256;
@(posedge i_clk) (i_wb_err) |=> ($stable(o_wb_dat));
endproperty
assert property(af_p256);

property af_p257;
@(posedge i_clk) (i_wb_ack) |=> ($stable(o_wb_dat));
endproperty
assert property(af_p257);

property af_p258;
@(posedge i_clk) (o_wb_we) |-> (o_wb_dat >= 0 && o_wb_dat <= 255);
endproperty
assert property(af_p258);

property af_p259;
@(posedge i_clk) (i_system_rdy) |-> ##4 (o_wb_dat >= 0 && o_wb_dat <= 45);
endproperty
assert property(af_p259);

property af_p260;
@(posedge i_clk) (!i_system_rdy) |-> ($stable(o_wb_dat));
endproperty
assert property(af_p260);

property af_p261;
@(posedge i_clk) (o_wb_stb && o_wb_we) |-> !$isunknown(o_wb_dat);
endproperty
assert property(af_p261);

property af_p262;
@(posedge i_clk) (!o_wb_we) |-> $stable(o_wb_dat);
endproperty
assert property(af_p262);

property af_p263;
@(posedge i_clk) (!o_wb_stb && !o_wb_cyc) |-> !$isunknown(o_wb_dat);
endproperty
assert property(af_p263);

property af_p264;
@(posedge i_clk) (o_wb_stb && !i_wb_ack) |=> $stable(o_wb_dat);
endproperty
assert property(af_p264);

property af_p265;
@(posedge i_clk) ((o_wb_dat >= 138) && (o_wb_dat <= 153)) |=> (o_wb_dat >= 98) && (o_wb_dat <= 153);
endproperty
assert property(af_p265);

property af_p266;
@(posedge i_clk) $fell(o_wb_stb) |=> !$stable(o_wb_dat);
endproperty
assert property(af_p266);

property af_p267;
@(posedge i_clk) (o_wb_cyc && !i_wb_ack) |=> $stable(o_wb_dat);
endproperty
assert property(af_p267);

property af_p268;
@(posedge i_clk) (o_wb_stb && o_wb_we) |-> (o_wb_cyc && o_wb_stb);
endproperty
assert property(af_p268);

property af_p269;
@(posedge i_clk) (!o_wb_stb) |-> $isunknown(o_wb_dat);
endproperty
assert property(af_p269);

property af_p270;
@(posedge i_clk) ((o_wb_dat >= 230) && (o_wb_dat <= 255)) |=> (o_wb_dat >= 205) && (o_wb_dat <= 255);
endproperty
assert property(af_p270);

property af_p271;
@(posedge i_clk) (!i_system_rdy) |=> $stable(o_wb_dat);
endproperty
assert property(af_p271);

property af_p272;
@(posedge i_clk) (o_wb_stb) |-> ##3 ((o_wb_dat >= 83) && (o_wb_dat <= 165));
endproperty
assert property(af_p272);

property af_p273;
@(posedge i_clk) (o_wb_cyc && o_wb_we) |-> $stable(o_wb_dat);
endproperty
assert property(af_p273);

property af_p274;
@(posedge i_clk) (o_wb_cyc) |-> $stable(o_wb_dat);
endproperty
assert property(af_p274);

property af_p275;
@(posedge i_clk) ($rose(o_wb_stb)) |-> ##1 $stable(o_wb_dat);
endproperty
assert property(af_p275);

property af_p276;
@(posedge i_clk) (o_wb_stb) |-> ((o_wb_sel[0] |-> !$isunknown(o_wb_dat[7:0])) && (o_wb_sel[1] |-> !$isunknown(o_wb_dat[15:8])) && (o_wb_sel[2] |-> !$isunknown(o_wb_dat[23:16])) && (o_wb_sel[3] |-> !$isunknown(o_wb_dat[31:24])));
endproperty
assert property(af_p276);

property af_p277;
@(posedge i_clk) ($rose(o_wb_stb)) |-> ($stable(o_wb_dat) until i_wb_ack);
endproperty
assert property(af_p277);

property af_p278;
@(posedge i_clk) (o_wb_stb) |-> ((o_wb_dat >= 100) && (o_wb_dat <= 150) && $stable(o_wb_dat));
endproperty
assert property(af_p278);

property af_p279;
@(posedge i_clk) (!$stable(o_wb_dat)) |-> $past(!i_wb_ack && o_wb_we);
endproperty
assert property(af_p279);

property af_p280;
@(posedge i_clk) (!i_system_rdy) |-> $stable(o_wb_dat);
endproperty
assert property(af_p280);

property af_p281;
@(posedge i_clk) (o_wb_we && !i_wb_err) |-> ((o_wb_dat >= 0) && (o_wb_dat <= 255));
endproperty
assert property(af_p281);

property af_p282;
@(posedge i_clk) (!i_system_rdy) |-> $stable(o_wb_sel);
endproperty
assert property(af_p282);

property af_p283;
@(posedge i_clk) (!o_wb_we) |-> ##1 !$stable(o_wb_sel) || $stable(o_wb_sel);
endproperty
assert property(af_p283);

property af_p284;
@(posedge i_clk) (o_wb_stb && !i_wb_ack) |=> $stable(o_wb_sel);
endproperty
assert property(af_p284);

property af_p285;
@(posedge i_clk) $rose(i_system_rdy) |-> ##[1:3] (o_wb_sel >= 4'h0 && o_wb_sel <= 4'hF);
endproperty
assert property(af_p285);

property af_p286;
@(posedge i_clk) (o_wb_stb) |-> (o_wb_sel >= 4'h0 && o_wb_sel <= 4'hF);
endproperty
assert property(af_p286);

property af_p287;
@(posedge i_clk) (o_wb_we) |-> (o_wb_sel >= 4'h1 && o_wb_sel <= 4'hF);
endproperty
assert property(af_p287);

property af_p288;
@(posedge i_clk) (o_wb_sel >= 4'h0 && o_wb_sel <= 4'hF);
endproperty
assert property(af_p288);

property af_p289;
@(posedge i_clk) (o_wb_cyc) |-> $stable(o_wb_sel);
endproperty
assert property(af_p289);

property af_p290;
@(posedge i_clk) (o_wb_cyc) |-> (o_wb_sel inside {[4'h0:4'hF]}) throughout (o_wb_cyc[*1:$]);
endproperty
assert property(af_p290);

property af_p291;
@(posedge i_clk) (1'b1) |-> (o_wb_sel inside {[4'h0:4'hF]});
endproperty
assert property(af_p291);

property af_p292;
@(posedge i_clk) (o_wb_cyc && o_wb_stb) |-> (o_wb_sel inside {[4'h1:4'hF]});
endproperty
assert property(af_p292);

property af_p293;
@(posedge i_clk) (o_wb_cyc && !i_wb_ack) |-> (o_wb_sel == $past(o_wb_sel));
endproperty
assert property(af_p293);

property af_p294;
@(posedge i_clk) (i_wb_ack) |-> (o_wb_sel == $past(o_wb_sel));
endproperty
assert property(af_p294);

property af_p295;
@(posedge i_clk) $past(i_wb_ack) |-> ((o_wb_sel == $past(o_wb_sel)) || (o_wb_sel != $past(o_wb_sel)));
endproperty
assert property(af_p295);

property af_p296;
@(posedge i_clk) (o_wb_sel != 4'b0000) |-> (o_wb_we);
endproperty
assert property(af_p296);

property af_p297;
@(posedge i_clk) (o_wb_stb && !o_wb_we) |-> (o_wb_sel inside {[4'h0:4'hF]});
endproperty
assert property(af_p297);

property af_p298;
@(posedge i_clk) $past(i_wb_ack) |-> ##0 (o_wb_sel != $past(o_wb_sel)) or (o_wb_sel == $past(o_wb_sel));
endproperty
assert property(af_p298);

property af_p299;
@(posedge i_clk) (o_wb_stb && o_wb_we) |-> (o_wb_sel != 4'b0000);
endproperty
assert property(af_p299);

property af_p300;
@(posedge i_clk) (o_wb_stb && o_wb_we) |-> ((o_wb_sel >= 4'h1) && (o_wb_sel <= 4'hF));
endproperty
assert property(af_p300);

property af_p301;
@(posedge i_clk) $fell(i_system_rdy) |-> ##[1:2] ((o_wb_sel >= 4'h0) && (o_wb_sel <= 4'hF));
endproperty
assert property(af_p301);

property af_p302;
@(posedge i_clk) $fell(i_system_rdy) |=> ((o_wb_sel >= 4'h0) && (o_wb_sel <= 4'hF));
endproperty
assert property(af_p302);

property af_p303;
@(posedge i_clk) (!i_system_rdy) |-> (o_wb_sel == 4'b0000);
endproperty
assert property(af_p303);

property af_p304;
@(posedge i_clk) (o_wb_stb && $past(o_wb_stb)) |-> $stable(o_wb_sel);
endproperty
assert property(af_p304);

property af_p305;
@(posedge i_clk) (!o_wb_we) |-> (o_wb_sel == 4'b0000);
endproperty
assert property(af_p305);

property af_p306;
@(posedge i_clk) (i_wb_ack && o_wb_stb) |=> (o_wb_stb |-> ((o_wb_sel != $past(o_wb_sel)) && (o_wb_sel >= 4'h0) && (o_wb_sel <= 4'hF)));
endproperty
assert property(af_p306);

property af_p307;
@(posedge i_clk) (o_wb_stb && o_wb_we) |-> !$isunknown(o_wb_dat);
endproperty
assert property(af_p307);

property af_p308;
@(posedge i_clk) (o_wb_stb && $past(o_wb_stb)) |-> ($stable(o_wb_adr));
endproperty
assert property(af_p308);

property af_p309;
@(posedge i_clk) (o_wb_stb && $past(o_wb_stb)) |-> ($stable(o_wb_we));
endproperty
assert property(af_p309);

property af_p310;
@(posedge i_clk) (o_wb_stb && $past(o_wb_stb)) |-> ($stable(o_wb_sel));
endproperty
assert property(af_p310);

property af_p311;
@(posedge i_clk) o_wb_stb |-> o_wb_cyc;
endproperty
assert property(af_p311);

property af_p312;
@(posedge i_clk) (i_wb_ack && o_wb_cyc) |=> !o_wb_stb;
endproperty
assert property(af_p312);

property af_p313;
@(posedge i_clk) o_wb_stb |-> !$isunknown(o_wb_sel);
endproperty
assert property(af_p313);

property af_p314;
@(posedge i_clk) $fell(i_system_rdy) |-> !o_wb_stb;
endproperty
assert property(af_p314);

property af_p315;
@(posedge i_clk) !i_system_rdy |-> !o_wb_stb;
endproperty
assert property(af_p315);

property af_p316;
@(posedge i_clk) (o_wb_stb && !i_wb_ack && !i_wb_err) |=> $stable(o_wb_stb);
endproperty
assert property(af_p316);

property af_p317;
@(posedge i_clk) i_wb_err |=> !o_wb_stb;
endproperty
assert property(af_p317);

property af_p318;
@(posedge i_clk) $fell(i_system_rdy) |=> !o_wb_stb;
endproperty
assert property(af_p318);

property af_p319;
@(posedge i_clk) ($fell(o_wb_stb)) |-> ($past(i_wb_ack) || $past(i_wb_err));
endproperty
assert property(af_p319);

property af_p320;
@(posedge i_clk) o_wb_stb |-> $stable(o_wb_sel);
endproperty
assert property(af_p320);

property af_p321;
@(posedge i_clk) (o_wb_stb && !(i_wb_ack || i_wb_err)) |=> o_wb_stb;
endproperty
assert property(af_p321);

property af_p322;
@(posedge i_clk) $rose(o_wb_cyc) |-> ##[0:1] o_wb_stb;
endproperty
assert property(af_p322);

property af_p323;
@(posedge i_clk) (o_wb_stb && i_wb_ack) |=> !o_wb_stb;
endproperty
assert property(af_p323);

property af_p324;
@(posedge i_clk) o_wb_stb |-> $stable(o_wb_we);
endproperty
assert property(af_p324);

property af_p325;
@(posedge i_clk) o_wb_stb |-> $stable(o_wb_adr);
endproperty
assert property(af_p325);

property af_p326;
@(posedge i_clk) o_wb_stb |-> ($stable(o_wb_adr) until i_wb_ack);
endproperty
assert property(af_p326);

property af_p327;
@(posedge i_clk) (o_wb_stb && o_wb_we) |-> $stable(o_wb_dat);
endproperty
assert property(af_p327);

property af_p328;
@(posedge i_clk) (i_wb_ack) |=> (!o_wb_stb);
endproperty
assert property(af_p328);

property af_p329;
@(posedge i_clk) $rose(o_wb_stb) |-> $stable(o_wb_stb);
endproperty
assert property(af_p329);

property af_p330;
@(posedge i_clk) (o_wb_stb && i_wb_err) |=> !o_wb_stb;
endproperty
assert property(af_p330);

property af_p331;
@(posedge i_clk) (o_wb_stb) |=> (i_wb_ack || i_wb_err);
endproperty
assert property(af_p331);

property af_p332;
@(posedge i_clk) o_wb_stb |-> ##[1:4] (i_wb_ack || i_wb_err);
endproperty
assert property(af_p332);

property af_p333;
@(posedge i_clk) (!i_system_rdy) |-> !o_wb_stb;
endproperty
assert property(af_p333);

property af_p334;
@(posedge i_clk) (o_wb_stb && !i_wb_ack) |=> ($stable(o_wb_adr) throughout (o_wb_stb[->1] ##0 i_wb_ack));
endproperty
assert property(af_p334);

property af_p335;
@(posedge i_clk) (!o_wb_cyc) |-> (!o_wb_stb);
endproperty
assert property(af_p335);

property af_p336;
@(posedge i_clk) $fell(o_wb_stb) |-> $past(o_wb_stb);
endproperty
assert property(af_p336);

property af_p337;
@(posedge i_clk) (i_wb_ack) |=> (!$past(o_wb_stb) || !o_wb_stb);
endproperty
assert property(af_p337);

property af_p338;
@(posedge i_clk) ((i_irq || i_firq) && !o_wb_cyc) |-> !o_wb_stb;
endproperty
assert property(af_p338);

property af_p339;
@(posedge i_clk) !i_system_rdy |-> !o_wb_we;
endproperty
assert property(af_p339);

property af_p340;
@(posedge i_clk) (o_wb_we && i_wb_err) |=> !o_wb_we;
endproperty
assert property(af_p340);

property af_p341;
@(posedge i_clk) i_wb_err |=> (!o_wb_we || !o_wb_cyc);
endproperty
assert property(af_p341);

property af_p342;
@(posedge i_clk) i_wb_ack |-> $stable(o_wb_we);
endproperty
assert property(af_p342);

property af_p343;
@(posedge i_clk) i_wb_ack |-> !o_wb_we;
endproperty
assert property(af_p343);

property af_p344;
@(posedge i_clk) i_wb_ack |=> $stable(o_wb_we);
endproperty
assert property(af_p344);

property af_p345;
@(posedge i_clk) !o_wb_cyc |-> !o_wb_we;
endproperty
assert property(af_p345);

property af_p346;
@(posedge i_clk) i_system_rdy |=> (o_wb_we === 1'b0 || o_wb_we === 1'b1);
endproperty
assert property(af_p346);

property af_p347;
@(posedge i_clk) o_wb_we |-> o_wb_cyc;
endproperty
assert property(af_p347);

property af_p348;
@(posedge i_clk) (o_wb_cyc && !i_wb_ack) |=> $stable(o_wb_we);
endproperty
assert property(af_p348);

property af_p349;
@(posedge i_clk) (o_wb_we) |-> (o_wb_cyc);
endproperty
assert property(af_p349);

property af_p350;
@(posedge i_clk) (!i_system_rdy) |-> (!o_wb_we);
endproperty
assert property(af_p350);

property af_p351;
@(posedge i_clk) (!o_wb_stb) |-> (!o_wb_we);
endproperty
assert property(af_p351);

property af_p352;
@(posedge i_clk) (o_wb_cyc && o_wb_we) |-> (o_wb_we throughout o_wb_cyc[*1:$]);
endproperty
assert property(af_p352);

property af_p353;
@(posedge i_clk) (o_wb_we && o_wb_stb) |-> (!$isunknown(o_wb_dat));
endproperty
assert property(af_p353);

property af_p354;
@(posedge i_clk) (o_wb_we) |-> (o_wb_sel != 4'b0000);
endproperty
assert property(af_p354);

property af_p355;
@(posedge i_clk) (i_wb_err) |=> (!o_wb_we);
endproperty
assert property(af_p355);

property af_p356;
@(posedge i_clk) (!o_wb_we && i_wb_ack) |-> (!$isunknown(i_wb_dat));
endproperty
assert property(af_p356);

property af_p357;
@(posedge i_clk) ($rose(o_wb_stb)) |-> (o_wb_we throughout o_wb_stb[*1:$]);
endproperty
assert property(af_p357);

property af_p358;
@(posedge i_clk) (!o_wb_stb) |=> ($stable(o_wb_we));
endproperty
assert property(af_p358);

property af_p359;
@(posedge i_clk) (i_wb_ack && o_wb_we) |=> (!o_wb_we);
endproperty
assert property(af_p359);

property af_p360;
@(posedge i_clk) (!i_system_rdy) |=> $stable(o_wb_we);
endproperty
assert property(af_p360);

property af_p361;
@(posedge i_clk) (o_wb_we) |-> (o_wb_we throughout (##[0:$] i_wb_ack));
endproperty
assert property(af_p361);

property af_p362;
@(posedge i_clk) (i_system_rdy) |=> ($changed(o_wb_we));
endproperty
assert property(af_p362);

property af_p363;
@(posedge i_clk) (o_wb_cyc && o_wb_stb && !i_wb_ack) |=> $stable(o_wb_we);
endproperty
assert property(af_p363);

property af_p364;
@(posedge i_clk) (o_wb_we && o_wb_cyc && o_wb_stb) |-> (!$isunknown(o_wb_dat));
endproperty
assert property(af_p364);

property af_p365;
@(posedge i_clk) (!i_wb_ack) |=> $stable(o_wb_we);
endproperty
assert property(af_p365);

property af_p366;
@(posedge i_clk) (!i_wb_ack) |-> ($stable(o_wb_we) until (i_wb_ack));
endproperty
assert property(af_p366);

property af_p367;
@(posedge i_clk) (o_wb_we) |-> (o_wb_stb);
endproperty
assert property(af_p367);

