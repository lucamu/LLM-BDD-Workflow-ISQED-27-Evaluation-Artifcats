// AssertionForge baseline SVA for sdc
// 703 assertions captured from gen_plan.generate_svas






























property af_p29;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o && m_wb_ack_i) |-> !int_a;
endproperty
assert property(af_p29);

property af_p30;
@(posedge wb_clk_i) wb_rst_i |-> !int_a;
endproperty
assert property(af_p30);

property af_p31;
@(posedge wb_clk_i) 1'b1 |-> ($stable(int_a) || ($past(int_a) !== int_a));
endproperty
assert property(af_p31);

property af_p32;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (int_a == 0) ##1 (int_a == 0);
endproperty
assert property(af_p32);

property af_p33;
@(posedge wb_clk_i) $rose(int_a) |-> $past(m_wb_ack_i);
endproperty
assert property(af_p33);

property af_p34;
@(posedge wb_clk_i) (int_a && m_wb_ack_i) |-> ##[1:5] !int_a;
endproperty
assert property(af_p34);

property af_p35;
@(posedge wb_clk_i) m_wb_ack_i |-> ##[1:4] int_a;
endproperty
assert property(af_p35);

property af_p36;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (!$isunknown(int_a));
endproperty
assert property(af_p36);

property af_p37;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> (int_a == 0) ##1 (int_a == 0);
endproperty
assert property(af_p37);

property af_p38;
@(posedge wb_clk_i) ($changed(wb_adr_i) && !m_wb_ack_i) |-> $stable(int_a);
endproperty
assert property(af_p38);

property af_p39;
@(posedge wb_clk_i) (int_a && $stable(m_wb_dat_o)) |=> int_a;
endproperty
assert property(af_p39);


property af_p41;
@(posedge wb_clk_i) $rose(int_a) |-> (int_a throughout ($stable(wb_dat_i))[->1]);
endproperty
assert property(af_p41);

property af_p42;
@(posedge wb_clk_i) $changed(int_a) |-> m_wb_ack_i;
endproperty
assert property(af_p42);

property af_p43;
@(posedge wb_clk_i) !(m_wb_cyc_o && m_wb_stb_o) |-> $stable(int_a);
endproperty
assert property(af_p43);

property af_p44;
@(posedge wb_clk_i) disable iff (wb_rst_i) $stable(int_a);
endproperty
assert property(af_p44);

property af_p45;
@(posedge wb_clk_i) $rose(int_a) |-> int_a;
endproperty
assert property(af_p45);


property af_p47;
@(posedge wb_clk_i) $rose(int_a) |=> int_a;
endproperty
assert property(af_p47);

property af_p48;
@(posedge wb_clk_i) (!$rose(m_wb_ack_i)) |-> ($stable(int_a));
endproperty
assert property(af_p48);

property af_p49;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> (int_a == 1'b0);
endproperty
assert property(af_p49);

property af_p50;
@(posedge wb_clk_i) (wb_rst_i) |-> (int_a == 1'b0);
endproperty
assert property(af_p50);

property af_p51;
@(posedge wb_clk_i) (wb_rst_i) |-> !int_a;
endproperty
assert property(af_p51);

property af_p52;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (int_a == 1'b0);
endproperty
assert property(af_p52);

property af_p53;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> (int_a == 1'b0)[*3];
endproperty
assert property(af_p53);

property af_p54;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> (int_a == 1'b0);
endproperty
assert property(af_p54);

property af_p55;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (int_a == 1'b0)[*3];
endproperty
assert property(af_p55);

property af_p56;
@(posedge wb_clk_i) $rose(m_wb_ack_i) |-> ##[1:4] (int_a == 1'b1);
endproperty
assert property(af_p56);

property af_p57;
@(posedge wb_clk_i) $rose(m_wb_stb_o) |-> (m_wb_ack_i ##1 !m_wb_ack_i);
endproperty
assert property(af_p57);

property af_p58;
@(posedge wb_clk_i) m_wb_ack_i |-> $past(m_wb_cyc_o && m_wb_stb_o);
endproperty
assert property(af_p58);

property af_p59;
@(posedge wb_clk_i) not (m_wb_ack_i[*2]);
endproperty
assert property(af_p59);

property af_p60;
@(posedge wb_clk_i) $rose(m_wb_ack_i) |-> !$isunknown(m_wb_dat_i);
endproperty
assert property(af_p60);

property af_p61;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o) |=> (m_wb_ack_i ##1 !m_wb_ack_i);
endproperty
assert property(af_p61);

property af_p62;
@(posedge wb_clk_i) $rose(m_wb_stb_o) |-> ##[1:4] m_wb_ack_i;
endproperty
assert property(af_p62);

property af_p63;
@(posedge wb_clk_i) m_wb_cyc_o |-> not (m_wb_ack_i[*2]);
endproperty
assert property(af_p63);

property af_p64;
@(posedge wb_clk_i) m_wb_ack_i |-> ((m_wb_cyc_o && m_wb_stb_o) || $past(m_wb_cyc_o && m_wb_stb_o));
endproperty
assert property(af_p64);

property af_p65;
@(posedge wb_clk_i) m_wb_ack_i |-> !$isunknown(m_wb_dat_i);
endproperty
assert property(af_p65);

property af_p66;
@(posedge wb_clk_i) m_wb_ack_i |-> m_wb_stb_o;
endproperty
assert property(af_p66);

property af_p67;
@(posedge wb_clk_i) (m_wb_ack_i) |-> ($isunknown(m_wb_dat_i) == 0);
endproperty
assert property(af_p67);

property af_p68;
@(posedge wb_clk_i) (m_wb_ack_i) |-> (m_wb_cyc_o == 1'b1);
endproperty
assert property(af_p68);

property af_p69;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_ack_i == 1'b0);
endproperty
assert property(af_p69);

property af_p70;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 (m_wb_ack_i == 1'b0);
endproperty
assert property(af_p70);

property af_p71;
@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> ##3 (m_wb_ack_i == 1'b0);
endproperty
assert property(af_p71);

property af_p72;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> (m_wb_ack_i == 1'b0);
endproperty
assert property(af_p72);

property af_p73;
@(posedge wb_clk_i) (m_wb_ack_i) |-> (m_wb_stb_o && m_wb_cyc_o);
endproperty
assert property(af_p73);

property af_p74;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (m_wb_ack_i == 1'b0);
endproperty
assert property(af_p74);

property af_p75;
@(posedge wb_clk_i) (m_wb_ack_i) |-> (m_wb_cyc_o && (m_wb_we_o === 1'b0 || m_wb_we_o === 1'b1));
endproperty
assert property(af_p75);

property af_p76;
@(posedge wb_clk_i) (!wb_rst_i) |-> (m_wb_ack_i inside {1'b0, 1'b1});
endproperty
assert property(af_p76);

property af_p77;
@(posedge wb_clk_i) (m_wb_ack_i) |-> (m_wb_cyc_o);
endproperty
assert property(af_p77);

property af_p78;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!m_wb_ack_i)[*2];
endproperty
assert property(af_p78);

property af_p79;
@(posedge wb_clk_i) ($fell(m_wb_cyc_o)) |=> (!m_wb_ack_i);
endproperty
assert property(af_p79);

property af_p80;
@(posedge wb_clk_i) (m_wb_ack_i && !m_wb_we_o) |-> (!$isunknown(m_wb_dat_i));
endproperty
assert property(af_p80);

property af_p81;
@(posedge wb_clk_i) ($rose(m_wb_cyc_o) && !$isunknown(m_wb_adr_o)) |-> ##[1:4] (m_wb_ack_i);
endproperty
assert property(af_p81);

property af_p82;
@(posedge wb_clk_i) (m_wb_we_o && m_wb_stb_o && m_wb_cyc_o) |-> ##[1:8] (m_wb_ack_i);
endproperty
assert property(af_p82);

property af_p83;
@(posedge wb_clk_i) (wb_rst_i) |-> (!m_wb_ack_i);
endproperty
assert property(af_p83);

property af_p84;
@(posedge wb_clk_i) ($past(m_wb_ack_i) && m_wb_stb_o) |-> $changed(m_wb_adr_o);
endproperty
assert property(af_p84);

property af_p85;
@(posedge wb_clk_i) $changed(wb_adr_i) |=> !$isunknown(m_wb_adr_o);
endproperty
assert property(af_p85);

property af_p86;
@(posedge wb_clk_i) $changed(wb_adr_i) |=> (m_wb_adr_o >= 0) && (m_wb_adr_o <= 255);
endproperty
assert property(af_p86);

property af_p87;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p87);

property af_p88;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> (m_wb_adr_o >= 0) && (m_wb_adr_o <= 255);
endproperty
assert property(af_p88);

property af_p89;
@(posedge wb_clk_i) $changed(m_wb_adr_o) |=> $stable(m_wb_adr_o);
endproperty
assert property(af_p89);

property af_p90;
@(posedge wb_clk_i) (m_wb_cti_o == 1'b1) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p90);

property af_p91;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_ack_i) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p91);

property af_p92;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o && !m_wb_ack_i) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p92);

property af_p93;
@(posedge wb_clk_i) ((m_wb_adr_o >= 0) && (m_wb_adr_o <= 1023)) |=> (m_wb_adr_o >= 0) && (m_wb_adr_o <= 2047);
endproperty
assert property(af_p93);

property af_p94;
@(posedge wb_clk_i) $changed(m_wb_adr_o) |-> $past(m_wb_ack_i);
endproperty
assert property(af_p94);

property af_p95;
@(posedge wb_clk_i) (m_wb_cti_o == m_wb_cti_o) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p95);

property af_p96;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_adr_o == 32'h0);
endproperty
assert property(af_p96);

property af_p97;
@(posedge wb_clk_i) (wb_rst_i) |=> (m_wb_adr_o == 32'h0);
endproperty
assert property(af_p97);

property af_p98;
@(posedge wb_clk_i) (wb_rst_i) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p98);

property af_p99;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> 1'b1;
endproperty
assert property(af_p99);

property af_p100;
@(posedge wb_clk_i) (m_wb_ack_i) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p100);

property af_p101;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##1 (m_wb_adr_o >= 32'h0 && m_wb_adr_o <= 32'hFF);
endproperty
assert property(af_p101);

property af_p102;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##3 (m_wb_adr_o == m_wb_adr_o);
endproperty
assert property(af_p102);

property af_p103;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:2] (m_wb_adr_o >= 32'h0 && m_wb_adr_o <= 32'hFFFFFFFF);
endproperty
assert property(af_p103);

property af_p104;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (m_wb_adr_o >= 32'h00000000 && m_wb_adr_o <= 32'hFFFFFFFF);
endproperty
assert property(af_p104);

property af_p105;
@(posedge wb_clk_i) ($stable(m_wb_we_o) && $stable(m_wb_cyc_o)) |=> $stable(m_wb_adr_o);
endproperty
assert property(af_p105);

property af_p106;
@(posedge wb_clk_i) (m_wb_stb_o) |-> (m_wb_adr_o >= 32'h00000000 && m_wb_adr_o <= 32'hFFFFFFFF);
endproperty
assert property(af_p106);

property af_p107;
@(posedge wb_clk_i) (m_wb_ack_i) |=> (m_wb_adr_o == ($past(m_wb_adr_o) + (m_wb_bte_o ? 32'd4 : 32'd1)));
endproperty
assert property(af_p107);

property af_p108;
@(posedge wb_clk_i) (m_wb_cti_o) |=> $stable(m_wb_adr_o);
endproperty
assert property(af_p108);

property af_p109;
@(posedge wb_clk_i) !(m_wb_cyc_o && m_wb_stb_o) |=> $stable(m_wb_adr_o);
endproperty
assert property(af_p109);

property af_p110;
@(posedge wb_clk_i) (m_wb_we_o) |=> $stable(m_wb_adr_o);
endproperty
assert property(af_p110);

property af_p111;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_ack_i) |=> $stable(m_wb_adr_o);
endproperty
assert property(af_p111);

property af_p112;
@(posedge wb_clk_i) $changed(wb_adr_i) |-> ##3 (m_wb_adr_o == {24'b0, wb_adr_i});
endproperty
assert property(af_p112);

property af_p113;
@(posedge wb_clk_i) (m_wb_stb_o && !m_wb_ack_i) |=> $stable(m_wb_adr_o);
endproperty
assert property(af_p113);

property af_p114;
@(posedge wb_clk_i) (!wb_rst_i) |-> ##2 (m_wb_bte_o >= 0 && m_wb_bte_o <= 1);
endproperty
assert property(af_p114);

property af_p115;
@(posedge wb_clk_i) (m_wb_bte_o >= 0 && m_wb_bte_o <= 1);
endproperty
assert property(af_p115);

property af_p116;
@(posedge wb_clk_i) ($fell(m_wb_cyc_o)) |-> ##1 $stable(m_wb_bte_o);
endproperty
assert property(af_p116);

property af_p117;
@(posedge wb_clk_i) (m_wb_ack_i) |-> ##1 (m_wb_bte_o >= 0 && m_wb_bte_o <= 1);
endproperty
assert property(af_p117);

property af_p118;
@(posedge wb_clk_i) (m_wb_cti_o) |-> (m_wb_bte_o >= 0 && m_wb_bte_o <= 1);
endproperty
assert property(af_p118);

property af_p119;
@(posedge wb_clk_i) (!wb_rst_i) |-> ##3 (m_wb_bte_o >= 0 && m_wb_bte_o <= 1);
endproperty
assert property(af_p119);

property af_p120;
@(posedge wb_clk_i) (!wb_rst_i) |-> ##4 (m_wb_bte_o >= 0 && m_wb_bte_o <= 1);
endproperty
assert property(af_p120);


property af_p122;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o) |-> $stable(m_wb_bte_o);
endproperty
assert property(af_p122);

property af_p123;
@(posedge wb_clk_i) disable iff (wb_rst_i) (m_wb_bte_o >= 0 && m_wb_bte_o <= 1);
endproperty
assert property(af_p123);

property af_p124;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 (m_wb_bte_o >= 0 && m_wb_bte_o <= 1);
endproperty
assert property(af_p124);

property af_p125;
@(posedge wb_clk_i) (!wb_rst_i) |-> (m_wb_bte_o >= 0 && m_wb_bte_o <= 1);
endproperty
assert property(af_p125);

property af_p126;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (m_wb_bte_o >= 0 && m_wb_bte_o <= 1);
endproperty
assert property(af_p126);

property af_p127;
@(posedge wb_clk_i) wb_rst_i |-> (m_wb_bte_o == 0) ##1 (m_wb_bte_o == 0);
endproperty
assert property(af_p127);

property af_p128;
@(posedge wb_clk_i) (m_wb_bte_o == 1'b1) |-> ##1 (m_wb_bte_o >= 0 && m_wb_bte_o <= 1);
endproperty
assert property(af_p128);

property af_p129;
@(posedge wb_clk_i) (m_wb_cti_o == 1'b1) |-> ##1 (m_wb_bte_o >= 0 && m_wb_bte_o <= 1);
endproperty
assert property(af_p129);

property af_p130;
@(posedge wb_clk_i) (!m_wb_stb_o) |-> ($stable(m_wb_bte_o) && (m_wb_bte_o >= 0 && m_wb_bte_o <= 1));
endproperty
assert property(af_p130);

property af_p131;
@(posedge wb_clk_i) ($fell(wb_rst_i) && !m_wb_stb_o) |-> (m_wb_bte_o == 1'b0);
endproperty
assert property(af_p131);

property af_p132;
@(posedge wb_clk_i) m_wb_cyc_o |-> $stable(m_wb_bte_o);
endproperty
assert property(af_p132);

property af_p133;
@(posedge wb_clk_i) (!m_wb_stb_o) |-> $stable(m_wb_bte_o);
endproperty
assert property(af_p133);

property af_p134;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> $stable(m_wb_bte_o);
endproperty
assert property(af_p134);

property af_p135;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_bte_o == 1'b0);
endproperty
assert property(af_p135);

property af_p136;
@(posedge wb_clk_i) ((m_wb_bte_o >= 0) && (m_wb_bte_o <= 1) && m_wb_ack_i) |-> ##1 ((m_wb_bte_o >= 0) && (m_wb_bte_o <= 1));
endproperty
assert property(af_p136);

property af_p137;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 ((m_wb_bte_o >= 0) && (m_wb_bte_o <= 1))[*1:$];
endproperty
assert property(af_p137);

property af_p138;
@(posedge wb_clk_i) (m_wb_cti_o == 1'b1) |-> $stable(m_wb_bte_o);
endproperty
assert property(af_p138);

property af_p139;
@(posedge wb_clk_i) (m_wb_ack_i && $past(m_wb_ack_i)) |-> ((m_wb_bte_o >= 0) && (m_wb_bte_o <= 1));
endproperty
assert property(af_p139);

property af_p140;
@(posedge wb_clk_i) 1'b1 |-> $stable(m_wb_bte_o);
endproperty
assert property(af_p140);

property af_p141;
@(posedge wb_clk_i) (!wb_rst_i) |-> (m_wb_bte_o >= 0) && (m_wb_bte_o <= 1);
endproperty
assert property(af_p141);

property af_p142;
@(posedge wb_clk_i) (!m_wb_ack_i) |=> $stable(m_wb_cti_o);
endproperty
assert property(af_p142);

property af_p143;
@(posedge wb_clk_i) (m_wb_ack_i && m_wb_cyc_o) |=> (m_wb_cyc_o |-> $stable(m_wb_cti_o));
endproperty
assert property(af_p143);

property af_p144;
@(posedge wb_clk_i) (m_wb_cti_o && m_wb_cyc_o) |=> (m_wb_cyc_o |-> (m_wb_cti_o inside {[0:1]}));
endproperty
assert property(af_p144);

property af_p145;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> (m_wb_cti_o inside {[0:1]})[*5];
endproperty
assert property(af_p145);

property af_p146;
@(posedge wb_clk_i) (!wb_rst_i) |-> (m_wb_cti_o >= 0 && m_wb_cti_o <= 1);
endproperty
assert property(af_p146);

property af_p147;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> (m_wb_cti_o == 0);
endproperty
assert property(af_p147);

property af_p148;
@(posedge wb_clk_i) (!$past(m_wb_ack_i)) |-> ($stable(m_wb_cti_o));
endproperty
assert property(af_p148);

property af_p149;
@(posedge wb_clk_i) (m_wb_ack_i) |-> (m_wb_cti_o >= 0 && m_wb_cti_o <= 1);
endproperty
assert property(af_p149);

property af_p150;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_cyc_o) |-> ($stable(m_wb_cti_o) until m_wb_ack_i);
endproperty
assert property(af_p150);

property af_p151;
@(posedge wb_clk_i) (m_wb_stb_o && !$past(m_wb_stb_o)) |-> (m_wb_cti_o == 0);
endproperty
assert property(af_p151);

property af_p152;
@(posedge wb_clk_i) ((m_wb_cti_o >= 0) && (m_wb_cti_o <= 1)) |-> ##1 ((m_wb_cti_o >= 0) && (m_wb_cti_o <= 1));
endproperty
assert property(af_p152);

property af_p153;
@(posedge wb_clk_i) (m_wb_cyc_o && $stable(m_wb_adr_o)) |-> $stable(m_wb_cti_o);
endproperty
assert property(af_p153);

property af_p154;
@(posedge wb_clk_i) (!$past(m_wb_ack_i)) |-> $stable(m_wb_cti_o);
endproperty
assert property(af_p154);

property af_p155;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] (m_wb_cti_o == 1'b0);
endproperty
assert property(af_p155);

property af_p156;
@(posedge wb_clk_i) (!wb_rst_i) |-> ((m_wb_cti_o === 1'b0) || (m_wb_cti_o === 1'b1));
endproperty
assert property(af_p156);

property af_p157;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> ((m_wb_cti_o >= 0) && (m_wb_cti_o <= 1) && (m_wb_bte_o >= 0) && (m_wb_bte_o <= 1));
endproperty
assert property(af_p157);

property af_p158;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_cti_o == 1'b0);
endproperty
assert property(af_p158);

property af_p159;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((m_wb_cti_o >= 0) && (m_wb_cti_o <= 1));
endproperty
assert property(af_p159);

property af_p160;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> (m_wb_cti_o == 1'b0);
endproperty
assert property(af_p160);

property af_p161;
@(posedge wb_clk_i) (!m_wb_stb_o) |-> $stable(m_wb_cti_o);
endproperty
assert property(af_p161);

property af_p162;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (m_wb_cti_o == 0)[*2];
endproperty
assert property(af_p162);

property af_p163;
@(posedge wb_clk_i) m_wb_cyc_o |-> (m_wb_cti_o == 0);
endproperty
assert property(af_p163);

property af_p164;
@(posedge wb_clk_i) ($past(wb_rst_i,3) && !wb_rst_i) |-> (m_wb_cti_o >= 0) && (m_wb_cti_o <= 1);
endproperty
assert property(af_p164);

property af_p165;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_cyc_o) |-> ##1 $stable(m_wb_cti_o)[*3];
endproperty
assert property(af_p165);

property af_p166;
@(posedge wb_clk_i) ($past(wb_rst_i,4) && !wb_rst_i) |-> ((m_wb_cti_o == 0) || (m_wb_cyc_o && m_wb_stb_o));
endproperty
assert property(af_p166);

property af_p167;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 !$isunknown(m_wb_cti_o);
endproperty
assert property(af_p167);

property af_p168;
@(posedge wb_clk_i) $fell(m_wb_cyc_o) |-> ##1 (m_wb_cti_o == 0);
endproperty
assert property(af_p168);

property af_p169;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> !$isunknown(m_wb_cti_o);
endproperty
assert property(af_p169);

property af_p170;
@(posedge wb_clk_i) disable iff (!wb_rst_i) 1'b1 |-> !m_wb_cyc_o;
endproperty
assert property(af_p170);

property af_p171;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_cyc_o == 1'b0);
endproperty
assert property(af_p171);

property af_p172;
@(posedge wb_clk_i) $rose(m_wb_cyc_o) |-> ##1 m_wb_cyc_o;
endproperty
assert property(af_p172);


property af_p174;
@(posedge wb_clk_i) $rose(m_wb_cyc_o) |-> ($stable(m_wb_cyc_o) && $stable(m_wb_we_o)) throughout (m_wb_ack_i[->1]);
endproperty
assert property(af_p174);

property af_p175;
@(posedge wb_clk_i) (!$isunknown(m_wb_adr_o) && !$isunknown(m_wb_dat_o)) |-> $stable(m_wb_cyc_o);
endproperty
assert property(af_p175);

property af_p176;
@(posedge wb_clk_i) (wb_rst_i) |-> !m_wb_cyc_o;
endproperty
assert property(af_p176);

property af_p177;
@(posedge wb_clk_i) (!$isunknown(m_wb_adr_o)) |-> m_wb_cyc_o ##1 m_wb_cyc_o;
endproperty
assert property(af_p177);

property af_p178;
@(posedge wb_clk_i) $rose(m_wb_cyc_o) |-> m_wb_cyc_o throughout (m_wb_ack_i[->1]);
endproperty
assert property(af_p178);

property af_p179;
@(posedge wb_clk_i) $rose(m_wb_ack_i) |-> $past(m_wb_cyc_o);
endproperty
assert property(af_p179);

property af_p180;
@(posedge wb_clk_i) $rose(m_wb_we_o) |-> m_wb_cyc_o;
endproperty
assert property(af_p180);

property af_p181;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[0:2] !$isunknown(m_wb_cyc_o);
endproperty
assert property(af_p181);

property af_p182;
@(posedge wb_clk_i) m_wb_cyc_o |-> !$isunknown(m_wb_adr_o);
endproperty
assert property(af_p182);

property af_p183;
@(posedge wb_clk_i) (m_wb_we_o && !$isunknown(m_wb_dat_o)) |-> m_wb_cyc_o;
endproperty
assert property(af_p183);

property af_p184;
@(posedge wb_clk_i) m_wb_ack_i |=> !m_wb_cyc_o;
endproperty
assert property(af_p184);

property af_p185;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_ack_i) |=> m_wb_cyc_o;
endproperty
assert property(af_p185);

property af_p186;
@(posedge wb_clk_i) m_wb_cyc_o == m_wb_stb_o;
endproperty
assert property(af_p186);

property af_p187;
@(posedge wb_clk_i) wb_rst_i |-> !m_wb_cyc_o;
endproperty
assert property(af_p187);

property af_p188;
@(posedge wb_clk_i) $onehot0({$rose(m_wb_cyc_o), $fell(m_wb_cyc_o)});
endproperty
assert property(af_p188);

property af_p189;
@(posedge wb_clk_i) $fell(m_wb_cyc_o) |-> $past(m_wb_ack_i);
endproperty
assert property(af_p189);

property af_p190;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> !m_wb_cyc_o;
endproperty
assert property(af_p190);

property af_p191;
@(posedge wb_clk_i) (m_wb_stb_o) |-> (m_wb_cyc_o);
endproperty
assert property(af_p191);

property af_p192;
@(posedge wb_clk_i) (wb_rst_i) |=> (!m_wb_cyc_o)[*2];
endproperty
assert property(af_p192);

property af_p193;
@(posedge wb_clk_i) ($fell(wb_rst_i) && m_wb_stb_o) |-> (m_wb_cyc_o);
endproperty
assert property(af_p193);

property af_p194;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (!m_wb_cyc_o);
endproperty
assert property(af_p194);

property af_p195;
@(posedge wb_clk_i) ($past(m_wb_ack_i) && $fell(m_wb_cyc_o)) |-> ##[1:2] $rose(m_wb_cyc_o);
endproperty
assert property(af_p195);

property af_p196;
@(posedge wb_clk_i) (m_wb_ack_i) |=> (!m_wb_cyc_o);
endproperty
assert property(af_p196);

property af_p197;
@(posedge wb_clk_i) ($fell(m_wb_cyc_o)) |=> (!m_wb_cyc_o);
endproperty
assert property(af_p197);

property af_p198;
@(posedge wb_clk_i) ($past(m_wb_stb_o) && m_wb_stb_o) |-> $stable(m_wb_cyc_o);
endproperty
assert property(af_p198);

property af_p199;
@(posedge wb_clk_i) (1) |-> ($stable(m_wb_cyc_o) || $changed(m_wb_cyc_o));
endproperty
assert property(af_p199);

property af_p200;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> (m_wb_stb_o);
endproperty
assert property(af_p200);

property af_p201;
@(posedge wb_clk_i) ($changed(m_wb_we_o)) |-> (m_wb_cyc_o);
endproperty
assert property(af_p201);

property af_p202;
@(posedge wb_clk_i) (!m_wb_ack_i) |-> 1'b1;
endproperty
assert property(af_p202);

property af_p203;
@(posedge wb_clk_i) $rose(wb_rst_i == 0) |-> (m_wb_cyc_o && m_wb_ack_i)[->1];
endproperty
assert property(af_p203);

property af_p204;
@(posedge wb_clk_i) $rose(wb_rst_i == 0) |-> ##3 ((m_wb_dat_i >= 50) && (m_wb_dat_i <= 200));
endproperty
assert property(af_p204);

property af_p205;
@(posedge wb_clk_i) (m_wb_ack_i) |=> (m_wb_ack_i) |-> (m_wb_dat_i != $past(m_wb_dat_i)) or (m_wb_dat_i == $past(m_wb_dat_i));
endproperty
assert property(af_p205);

property af_p206;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o) |-> ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 255)) throughout (!m_wb_ack_i)[*0:$] ##0 m_wb_ack_i;
endproperty
assert property(af_p206);

property af_p207;
@(posedge wb_clk_i) $rose(m_wb_ack_i) |-> $stable(m_wb_dat_i);
endproperty
assert property(af_p207);

property af_p208;
@(posedge wb_clk_i) $rose(wb_rst_i == 0) |-> ##2 (!$isunknown(m_wb_dat_i) && (m_wb_dat_i >= 0) && (m_wb_dat_i <= 255));
endproperty
assert property(af_p208);

property af_p209;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_ack_i) |-> $stable(m_wb_dat_i);
endproperty
assert property(af_p209);

property af_p210;
@(posedge wb_clk_i) $rose(wb_rst_i == 0) |-> ##3 ((m_wb_dat_i >= 83) && (m_wb_dat_i <= 165));
endproperty
assert property(af_p210);

property af_p211;
@(posedge wb_clk_i) 1'b1 |-> $stable(m_wb_dat_i) or !$stable(m_wb_dat_i);
endproperty
assert property(af_p211);

property af_p212;
@(posedge wb_clk_i) ((m_wb_dat_i >= 230) && (m_wb_dat_i <= 255)) |-> ##1 (m_wb_dat_i >= 205) && (m_wb_dat_i <= 255);
endproperty
assert property(af_p212);

property af_p213;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 45));
endproperty
assert property(af_p213);

property af_p214;
@(posedge wb_clk_i) (m_wb_ack_i) |-> !$isunknown(m_wb_dat_i);
endproperty
assert property(af_p214);

property af_p215;
@(posedge wb_clk_i) (m_wb_we_o) |-> !$isunknown(m_wb_dat_o);
endproperty
assert property(af_p215);

property af_p216;
@(posedge wb_clk_i) (!wb_rst_i) |-> !$isunknown(m_wb_dat_i);
endproperty
assert property(af_p216);

property af_p217;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> (((m_wb_dat_i >= 0) && (m_wb_dat_i <= 10)) ##1 ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 10)));
endproperty
assert property(af_p217);

property af_p218;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 63));
endproperty
assert property(af_p218);

property af_p219;
@(posedge wb_clk_i) (!$isunknown(m_wb_dat_i)) |-> (m_wb_cyc_o && m_wb_ack_i);
endproperty
assert property(af_p219);

property af_p220;
@(posedge wb_clk_i) ((m_wb_dat_i >= 200) && (m_wb_dat_i <= 255)) |=> ((m_wb_dat_i >= 180) && (m_wb_dat_i <= 255));
endproperty
assert property(af_p220);

property af_p221;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 255));
endproperty
assert property(af_p221);

property af_p222;
@(posedge wb_clk_i) ((!m_wb_we_o) && (m_wb_dat_i >= 50) && (m_wb_dat_i <= 75)) |=> ((m_wb_dat_i >= 40) && (m_wb_dat_i <= 85));
endproperty
assert property(af_p222);

property af_p223;
@(posedge wb_clk_i) ((m_wb_dat_i >= 100) && (m_wb_dat_i <= 150)) |=> ((m_wb_dat_i >= 80) && (m_wb_dat_i <= 150));
endproperty
assert property(af_p223);

property af_p224;
@(posedge wb_clk_i) (wb_rst_i) |-> !$changed(m_wb_dat_i);
endproperty
assert property(af_p224);

property af_p225;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_we_o) |-> ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 4294967295));
endproperty
assert property(af_p225);

property af_p226;
@(posedge wb_clk_i) (!m_wb_we_o && (m_wb_dat_i >= 60) && (m_wb_dat_i <= 90)) |=> ((m_wb_dat_i >= 40) && (m_wb_dat_i <= 100));
endproperty
assert property(af_p226);

property af_p227;
@(posedge wb_clk_i) (m_wb_ack_i) |=> $stable(m_wb_dat_i);
endproperty
assert property(af_p227);

property af_p228;
@(posedge wb_clk_i) (!m_wb_ack_i) |-> $stable(m_wb_dat_i) until_with (m_wb_ack_i);
endproperty
assert property(af_p228);

property af_p229;
@(posedge wb_clk_i) $rose(m_wb_stb_o && m_wb_cyc_o) |=> $changed(m_wb_dat_i);
endproperty
assert property(af_p229);

property af_p230;
@(posedge wb_clk_i) ((m_wb_dat_i >= 138) && (m_wb_dat_i <= 153)) |=> ((m_wb_dat_i >= 98) && (m_wb_dat_i <= 153));
endproperty
assert property(af_p230);

property af_p231;
@(posedge wb_clk_i) (m_wb_ack_i) |-> ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 255));
endproperty
assert property(af_p231);

property af_p232;
@(posedge wb_clk_i) (!m_wb_ack_i) |-> $stable(m_wb_dat_i);
endproperty
assert property(af_p232);

property af_p233;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_cyc_o && !m_wb_ack_i) |=> $stable(m_wb_dat_o);
endproperty
assert property(af_p233);

property af_p234;
@(posedge wb_clk_i) (1'b1) |-> (m_wb_dat_o == wb_dat_i);
endproperty
assert property(af_p234);

property af_p235;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_dat_o == 32'h0);
endproperty
assert property(af_p235);

property af_p236;
@(posedge wb_clk_i) ((m_wb_dat_o >= 0) && (m_wb_dat_o <= 65535) && m_wb_stb_o) |-> ((m_wb_dat_o >= 0) && (m_wb_dat_o <= 65535));
endproperty
assert property(af_p236);

property af_p237;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_we_o && !m_wb_ack_i) |=> $stable(m_wb_dat_o);
endproperty
assert property(af_p237);

property af_p238;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o && !m_wb_ack_i) |=> $stable(m_wb_dat_o);
endproperty
assert property(af_p238);

property af_p239;
@(posedge wb_clk_i) (m_wb_ack_i) |-> (m_wb_dat_o !== $past(m_wb_dat_o));
endproperty
assert property(af_p239);

property af_p240;
@(posedge wb_clk_i) ($past(wb_rst_i,3) && !wb_rst_i) |-> ((m_wb_dat_o >= 0) && (m_wb_dat_o <= 32'hFFFFFFFF));
endproperty
assert property(af_p240);

property af_p241;
@(posedge wb_clk_i) m_wb_ack_i |=> $stable(m_wb_dat_o) throughout (!(m_wb_cyc_o && m_wb_we_o))[*1:$];
endproperty
assert property(af_p241);

property af_p242;
@(posedge wb_clk_i) (m_wb_ack_i && m_wb_cyc_o) |=> (m_wb_dat_o !== $past(m_wb_dat_o));
endproperty
assert property(af_p242);

property af_p243;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> $stable(m_wb_dat_o);
endproperty
assert property(af_p243);

property af_p244;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (m_wb_dat_o >= 0 && m_wb_dat_o <= 4294967295) ##1 (m_wb_dat_o >= 0 && m_wb_dat_o <= 4294967295);
endproperty
assert property(af_p244);

property af_p245;
@(posedge wb_clk_i) $changed(wb_dat_i) |-> ##1 (m_wb_dat_o == $past(wb_dat_i));
endproperty
assert property(af_p245);

property af_p246;
@(posedge wb_clk_i) (m_wb_we_o) |-> (m_wb_dat_o >= 0 && m_wb_dat_o <= 4294967295);
endproperty
assert property(af_p246);


property af_p248;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (m_wb_dat_o >= 0 && m_wb_dat_o <= 255);
endproperty
assert property(af_p248);

property af_p249;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> $stable(m_wb_dat_o);
endproperty
assert property(af_p249);

property af_p250;
@(posedge wb_clk_i) !(m_wb_cyc_o && m_wb_we_o) |-> $stable(m_wb_dat_o);
endproperty
assert property(af_p250);

property af_p251;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_dat_o == 0) ##1 (m_wb_dat_o == 0);
endproperty
assert property(af_p251);

property af_p252;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_we_o) |-> (!$isunknown(m_wb_dat_o) && $stable(m_wb_dat_o));
endproperty
assert property(af_p252);

property af_p253;
@(posedge wb_clk_i) (m_wb_we_o) |-> ((m_wb_dat_o >= 0) && (m_wb_dat_o <= 4294967295));
endproperty
assert property(af_p253);

property af_p254;
@(posedge wb_clk_i) ($fell(m_wb_cyc_o)) |=> ($stable(m_wb_dat_o));
endproperty
assert property(af_p254);

property af_p255;
@(posedge wb_clk_i) (!m_wb_we_o) |=> ($stable(m_wb_dat_o));
endproperty
assert property(af_p255);


property af_p257;
@(posedge wb_clk_i) (!m_wb_ack_i) |=> ($stable(m_wb_dat_o));
endproperty
assert property(af_p257);

property af_p258;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((m_wb_dat_o >= 0) && (m_wb_dat_o <= 4294967295));
endproperty
assert property(af_p258);

property af_p259;
@(posedge wb_clk_i) (m_wb_we_o && m_wb_cyc_o) |-> (m_wb_dat_o == wb_dat_i);
endproperty
assert property(af_p259);

property af_p260;
@(posedge wb_clk_i) ((m_wb_dat_o >= 100) && (m_wb_dat_o <= 150) && m_wb_we_o) |=> (m_wb_we_o) |-> (m_wb_dat_o >= 90) && (m_wb_dat_o <= 160);
endproperty
assert property(af_p260);


property af_p262;
@(posedge wb_clk_i) (m_wb_sel_o && m_wb_cyc_o) |-> ##1 (m_wb_sel_o inside {1'b0, 1'b1});
endproperty
assert property(af_p262);

property af_p263;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o) |-> $stable(m_wb_sel_o);
endproperty
assert property(af_p263);

property af_p264;
@(posedge wb_clk_i) (m_wb_stb_o) |-> ##1 $stable(m_wb_sel_o);
endproperty
assert property(af_p264);

property af_p265;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_ack_i) |-> $stable(m_wb_sel_o);
endproperty
assert property(af_p265);

property af_p266;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> (m_wb_sel_o == 1'b0);
endproperty
assert property(af_p266);

property af_p267;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> (m_wb_sel_o inside {1'b0, 1'b1});
endproperty
assert property(af_p267);

property af_p268;
@(posedge wb_clk_i) ($past(m_wb_ack_i) && !m_wb_cyc_o) |-> (m_wb_sel_o == 1'b0);
endproperty
assert property(af_p268);

property af_p269;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o) |-> ($stable(m_wb_sel_o) && (m_wb_sel_o inside {1'b0, 1'b1}));
endproperty
assert property(af_p269);

property af_p270;
@(posedge wb_clk_i) (!m_wb_ack_i) |-> $stable(m_wb_sel_o);
endproperty
assert property(af_p270);

property af_p271;
@(posedge wb_clk_i) ($changed(m_wb_adr_o)) |-> (m_wb_sel_o == 1'b1);
endproperty
assert property(af_p271);

property af_p272;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> (m_wb_sel_o == 1'b1);
endproperty
assert property(af_p272);

property af_p273;
@(posedge wb_clk_i) (m_wb_stb_o) |-> $stable(m_wb_sel_o);
endproperty
assert property(af_p273);

property af_p274;
@(posedge wb_clk_i) (m_wb_we_o) |-> (m_wb_sel_o == 1'b1);
endproperty
assert property(af_p274);

property af_p275;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_sel_o == 1'b0);
endproperty
assert property(af_p275);

property af_p276;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o) |-> (m_wb_sel_o == 1'b1);
endproperty
assert property(af_p276);

property af_p277;
@(posedge wb_clk_i) ($changed(m_wb_we_o)) |-> $stable(m_wb_sel_o);
endproperty
assert property(af_p277);

property af_p278;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##2 (m_wb_sel_o == 1'b0);
endproperty
assert property(af_p278);

property af_p279;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> ($stable(m_wb_sel_o));
endproperty
assert property(af_p279);

property af_p280;
@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> (m_wb_sel_o == 1'b0);
endproperty
assert property(af_p280);

property af_p281;
@(posedge wb_clk_i) ((!m_wb_ack_i) && (!$past(m_wb_ack_i))) |-> ($stable(m_wb_sel_o));
endproperty
assert property(af_p281);

property af_p282;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ((m_wb_sel_o == 1'b0 || m_wb_sel_o == 1'b1) [*3]);
endproperty
assert property(af_p282);

property af_p283;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 (m_wb_sel_o == 1'b0 || m_wb_sel_o == 1'b1);
endproperty
assert property(af_p283);

property af_p284;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (m_wb_sel_o === 1'b0 || m_wb_sel_o === 1'b1);
endproperty
assert property(af_p284);

property af_p285;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (m_wb_sel_o inside {1'b0, 1'b1});
endproperty
assert property(af_p285);

property af_p286;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 (m_wb_sel_o inside {1'b0, 1'b1});
endproperty
assert property(af_p286);

property af_p287;
@(posedge wb_clk_i) (m_wb_stb_o) |-> (!$isunknown(m_wb_we_o));
endproperty
assert property(af_p287);

property af_p288;
@(posedge wb_clk_i) ($fell(m_wb_stb_o)) |-> (!m_wb_stb_o throughout (!m_wb_cyc_o)[*1:$] ##0 (m_wb_stb_o) |-> $past(m_wb_cyc_o));
endproperty
assert property(af_p288);

property af_p289;
@(posedge wb_clk_i) (m_wb_ack_i) |=> (!m_wb_stb_o);
endproperty
assert property(af_p289);

property af_p290;
@(posedge wb_clk_i) (wb_rst_i) |-> (!m_wb_stb_o);
endproperty
assert property(af_p290);

property af_p291;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!m_wb_stb_o [*3]);
endproperty
assert property(af_p291);

property af_p292;
@(posedge wb_clk_i) (m_wb_stb_o) |-> (!$isunknown(m_wb_sel_o) && (m_wb_sel_o !== '0));
endproperty
assert property(af_p292);

property af_p293;
@(posedge wb_clk_i) (m_wb_stb_o) |-> (m_wb_stb_o throughout (!m_wb_ack_i)[*0:$] ##1 (m_wb_ack_i) ##1 (!m_wb_stb_o));
endproperty
assert property(af_p293);

property af_p294;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_cyc_o) |-> (!$isunknown(m_wb_cti_o) && !$isunknown(m_wb_bte_o));
endproperty
assert property(af_p294);

property af_p295;
@(posedge wb_clk_i) (!m_wb_ack_i) |-> ($stable(m_wb_stb_o));
endproperty
assert property(af_p295);

property af_p296;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> (m_wb_stb_o);
endproperty
assert property(af_p296);

property af_p297;
@(posedge wb_clk_i) (m_wb_stb_o) |-> (m_wb_sel_o !== '0);
endproperty
assert property(af_p297);

property af_p298;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> (!m_wb_stb_o ##1 !m_wb_stb_o);
endproperty
assert property(af_p298);

property af_p299;
@(posedge wb_clk_i) m_wb_stb_o |-> m_wb_cyc_o;
endproperty
assert property(af_p299);

property af_p300;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> !m_wb_stb_o;
endproperty
assert property(af_p300);

property af_p301;
@(posedge wb_clk_i) m_wb_ack_i |=> (!m_wb_stb_o || (m_wb_stb_o && m_wb_cyc_o));
endproperty
assert property(af_p301);

property af_p302;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_ack_i) |=> !m_wb_stb_o;
endproperty
assert property(af_p302);

property af_p303;
@(posedge wb_clk_i) (m_wb_stb_o && (m_wb_cti_o == 3'b000)) |=> !m_wb_stb_o;
endproperty
assert property(af_p303);

property af_p304;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> !m_wb_stb_o;
endproperty
assert property(af_p304);

property af_p305;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> !m_wb_stb_o;
endproperty
assert property(af_p305);

property af_p306;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_we_o) |-> !$isunknown(m_wb_dat_o);
endproperty
assert property(af_p306);

property af_p307;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!m_wb_stb_o)[*2];
endproperty
assert property(af_p307);

property af_p308;
@(posedge wb_clk_i) ($fell(m_wb_cyc_o)) |=> (!m_wb_stb_o);
endproperty
assert property(af_p308);

property af_p309;
@(posedge wb_clk_i) ($fell(m_wb_stb_o)) |-> ($past(m_wb_ack_i));
endproperty
assert property(af_p309);

property af_p310;
@(posedge wb_clk_i) (m_wb_stb_o) |-> (!$isunknown(m_wb_adr_o) && $stable(m_wb_adr_o));
endproperty
assert property(af_p310);

property af_p311;
@(posedge wb_clk_i) (m_wb_stb_o) |-> ($stable(m_wb_adr_o) && !$isunknown(m_wb_adr_o));
endproperty
assert property(af_p311);

property af_p312;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_we_o) |-> (!$isunknown(m_wb_dat_o));
endproperty
assert property(af_p312);

property af_p313;
@(posedge wb_clk_i) (m_wb_stb_o && (m_wb_cti_o != 3'b111)) |=> (m_wb_stb_o);
endproperty
assert property(af_p313);

property af_p314;
@(posedge wb_clk_i) (m_wb_stb_o && !m_wb_ack_i) |=> (m_wb_stb_o);
endproperty
assert property(af_p314);

property af_p315;
@(posedge wb_clk_i) ($rose(m_wb_cyc_o)) |-> (m_wb_stb_o);
endproperty
assert property(af_p315);

property af_p316;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (m_wb_we_o == 1'b0) ##1 (m_wb_we_o == 1'b0);
endproperty
assert property(af_p316);

property af_p317;
@(posedge wb_clk_i) 1 |-> $stable(m_wb_we_o) or $changed(m_wb_we_o);
endproperty
assert property(af_p317);

property af_p318;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o) |-> (m_wb_we_o === 1'b0 || m_wb_we_o === 1'b1);
endproperty
assert property(af_p318);

property af_p319;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:2] (m_wb_we_o === 1'b0 || m_wb_we_o === 1'b1);
endproperty
assert property(af_p319);

property af_p320;
@(posedge wb_clk_i) ($rose(m_wb_we_o)) |-> $stable(m_wb_we_o);
endproperty
assert property(af_p320);

property af_p321;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_we_o == 1'b0);
endproperty
assert property(af_p321);

property af_p322;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> $stable(m_wb_we_o);
endproperty
assert property(af_p322);

property af_p323;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> (m_wb_we_o == 1'b0);
endproperty
assert property(af_p323);

property af_p324;
@(posedge wb_clk_i) (m_wb_we_o) |-> (m_wb_cyc_o);
endproperty
assert property(af_p324);

property af_p325;
@(posedge wb_clk_i) (m_wb_ack_i) |-> ##1 $changed(m_wb_we_o) || (m_wb_we_o == 1'b0);
endproperty
assert property(af_p325);

property af_p326;
@(posedge wb_clk_i) $rose(m_wb_ack_i) |-> ##[0:1] (m_wb_we_o == 1'b0);
endproperty
assert property(af_p326);

property af_p327;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 (m_wb_we_o == 1'b0);
endproperty
assert property(af_p327);

property af_p328;
@(posedge wb_clk_i) (m_wb_stb_o) |-> $stable(m_wb_we_o);
endproperty
assert property(af_p328);

property af_p329;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_ack_i) |-> $stable(m_wb_we_o);
endproperty
assert property(af_p329);

property af_p330;
@(posedge wb_clk_i) (wb_we_i) |-> (m_wb_we_o == wb_we_i);
endproperty
assert property(af_p330);

property af_p331;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> (m_wb_we_o == 1'b0);
endproperty
assert property(af_p331);

property af_p332;
@(posedge wb_clk_i) (m_wb_ack_i && m_wb_we_o) |-> (m_wb_we_o == 1'b1);
endproperty
assert property(af_p332);

property af_p333;
@(posedge wb_clk_i) (m_wb_we_o) |-> (!$isunknown(m_wb_dat_o));
endproperty
assert property(af_p333);

property af_p334;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_we_o) throughout (!m_wb_ack_i)[*1:$] |-> (m_wb_we_o == $past(m_wb_we_o));
endproperty
assert property(af_p334);

property af_p335;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> (!m_wb_we_o);
endproperty
assert property(af_p335);

property af_p336;
@(posedge wb_clk_i) (wb_rst_i) |=> (m_wb_we_o == 1'b0);
endproperty
assert property(af_p336);

property af_p337;
@(posedge wb_clk_i) (m_wb_we_o && m_wb_cyc_o) |=> (m_wb_we_o == $past(m_wb_we_o));
endproperty
assert property(af_p337);

property af_p338;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (m_wb_we_o == 1'b0) ##1 (m_wb_we_o == 1'b0);
endproperty
assert property(af_p338);

property af_p339;
@(posedge wb_clk_i) (m_wb_we_o && !$past(wb_rst_i)) |=> (m_wb_we_o || $past(m_wb_ack_i) || !$past(m_wb_cyc_o));
endproperty
assert property(af_p339);

property af_p340;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_we_i) |=> (m_wb_we_o == $past(wb_we_i));
endproperty
assert property(af_p340);

property af_p341;
@(posedge wb_clk_i) (m_wb_we_o) |-> (m_wb_stb_o);
endproperty
assert property(af_p341);




property af_p345;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (sd_dat_oe_o === 1'b0) ##1 (sd_dat_oe_o === 1'b0) ##1 (sd_dat_oe_o === 1'b0);
endproperty
assert property(af_p345);

property af_p346;
@(posedge wb_clk_i) (!sd_cmd_oe_o) |-> $stable(sd_cmd_out_o);
endproperty
assert property(af_p346);


property af_p348;
@(posedge wb_clk_i) (m_wb_sel_o) |-> (m_wb_cyc_o);
endproperty
assert property(af_p348);


property af_p350;
@(posedge wb_clk_i) (sd_cmd_oe_o) |-> (sd_cmd_out_o === 1'b0 || sd_cmd_out_o === 1'b1);
endproperty
assert property(af_p350);






property af_p356;
@(posedge wb_clk_i) 1 |-> ##[1:10] $changed(sd_clk_o_pad);
endproperty
assert property(af_p356);



property af_p359;
@(posedge wb_clk_i) wb_rst_i |-> $stable(m_wb_bte_o);
endproperty
assert property(af_p359);



property af_p362;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p362);





property af_p367;
@(posedge wb_clk_i) m_wb_cyc_o |-> $stable(m_wb_cti_o);
endproperty
assert property(af_p367);



property af_p370;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 (m_wb_adr_o !== 'x);
endproperty
assert property(af_p370);






property af_p376;
@(posedge wb_clk_i) wb_rst_i |-> ##1 !sd_cmd_oe_o;
endproperty
assert property(af_p376);






property af_p382;
@(posedge wb_clk_i) (wb_rst_i) |-> (sd_clk_o_pad === 1'b0);
endproperty
assert property(af_p382);














property af_p396;
@(posedge wb_clk_i) wb_rst_i |-> (sd_cmd_oe_o == 1'b0) && (sd_dat_oe_o == 1'b0);
endproperty
assert property(af_p396);






property af_p402;
@(posedge wb_clk_i) wb_rst_i |-> !$isunknown(sd_dat_out_o);
endproperty
assert property(af_p402);


property af_p404;
@(posedge wb_clk_i) wb_rst_i |-> !$changed(sd_clk_o_pad);
endproperty
assert property(af_p404);


property af_p406;
@(posedge wb_clk_i) (sd_clk_o_pad !== 1'bx) && ($stable(sd_clk_o_pad) || $changed(sd_clk_o_pad));
endproperty
assert property(af_p406);

property af_p407;
@(posedge wb_clk_i) disable iff (wb_rst_i) (sd_clk_o_pad === 1'b0 || sd_clk_o_pad === 1'b1);
endproperty
assert property(af_p407);

property af_p408;
@(posedge wb_clk_i) (wb_rst_i) |-> ##[1:$] $stable(sd_clk_o_pad) until (!wb_rst_i);
endproperty
assert property(af_p408);

property af_p409;
@(posedge wb_clk_i) ($rose(sd_clk_o_pad) ##1 $fell(sd_clk_o_pad)[->5]) |-> 1'b1;
endproperty
assert property(af_p409);

property af_p410;
@(posedge wb_clk_i) (wb_rst_i) |-> $stable(sd_clk_o_pad);
endproperty
assert property(af_p410);

property af_p411;
@(posedge wb_clk_i) disable iff (wb_rst_i) (sd_clk_o_pad == 1'b1) |-> ##[1:$] (sd_clk_o_pad == 1'b0);
endproperty
assert property(af_p411);

property af_p412;
@(posedge sd_clk_o_pad) (1'b1) |-> ($countones($past(wb_clk_i, 1)) >= 0);
endproperty
assert property(af_p412);

property af_p413;
@(posedge wb_clk_i) disable iff (wb_rst_i) ##[1:$] $changed(sd_clk_o_pad);
endproperty
assert property(af_p413);

property af_p414;
@(posedge wb_clk_i) disable iff (wb_rst_i) ($rose(sd_clk_o_pad) ##1 $rose(sd_clk_o_pad)[->1]) |-> 1'b1;
endproperty
assert property(af_p414);

property af_p415;
@(posedge wb_clk_i) disable iff (wb_rst_i) $stable(sd_clk_o_pad) || (sd_clk_o_pad !== 1'bx);
endproperty
assert property(af_p415);



property af_p418;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:4] $changed(sd_clk_o_pad);
endproperty
assert property(af_p418);


property af_p420;
@(posedge wb_clk_i) (wb_rst_i) |-> (sd_clk_o_pad === 1'b0);
endproperty
assert property(af_p420);

property af_p421;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (sd_clk_o_pad === 1'b0) ##[1:$] $changed(sd_clk_o_pad);
endproperty
assert property(af_p421);

property af_p422;
@(posedge wb_clk_i) (1) |-> ##[1:20] $changed(sd_clk_o_pad) throughout (##1 (1)[*20]);
endproperty
assert property(af_p422);


property af_p424;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:10] $changed(sd_clk_o_pad);
endproperty
assert property(af_p424);

property af_p425;
@(posedge wb_clk_i) (wb_rst_i) |-> (sd_clk_o_pad == 1'b0);
endproperty
assert property(af_p425);

property af_p426;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:$] $changed(sd_clk_o_pad);
endproperty
assert property(af_p426);

property af_p427;
@(posedge wb_clk_i) disable iff (wb_rst_i) ($rose(sd_clk_o_pad) |-> ##[1:$] $fell(sd_clk_o_pad) ##[1:$] $rose(sd_clk_o_pad));
endproperty
assert property(af_p427);

property af_p428;
@(posedge wb_clk_i) disable iff (wb_rst_i) (sd_clk_o_pad == wb_clk_i);
endproperty
assert property(af_p428);

property af_p429;
@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> (sd_clk_o_pad == 1'b0);
endproperty
assert property(af_p429);

property af_p430;
@(posedge wb_clk_i) disable iff (wb_rst_i) ($rose(sd_clk_o_pad) |-> ##[2:$] $rose(sd_clk_o_pad));
endproperty
assert property(af_p430);

property af_p431;
@(posedge wb_clk_i) disable iff (wb_rst_i) ($fell(wb_rst_i) |-> ##3 $changed(sd_clk_o_pad));
endproperty
assert property(af_p431);

property af_p432;
@(posedge wb_clk_i) (sd_clk_o_pad inside {1'b0, 1'b1});
endproperty
assert property(af_p432);

property af_p433;
@(posedge wb_clk_i) (sd_cmd_oe_o) |-> (sd_cmd_out_o !== sd_cmd_dat_i);
endproperty
assert property(af_p433);

property af_p434;
@(posedge wb_clk_i) (wb_rst_i) |-> (sd_cmd_dat_i === sd_cmd_dat_i);
endproperty
assert property(af_p434);



property af_p437;
@(posedge wb_clk_i) (!sd_cmd_oe_o) |-> ##1 (sd_cmd_dat_i !== sd_cmd_out_o);
endproperty
assert property(af_p437);

property af_p438;
@(posedge wb_clk_i) (sd_cmd_oe_o) |-> ##[1:$] (sd_cmd_dat_i !== sd_cmd_dat_i);
endproperty
assert property(af_p438);

property af_p439;
@(posedge wb_clk_i) (wb_rst_i) |-> ##1 ($stable(sd_cmd_dat_i));
endproperty
assert property(af_p439);

property af_p440;
@(posedge wb_clk_i) (1'b1) |-> (sd_cmd_dat_i === sd_cmd_dat_i);
endproperty
assert property(af_p440);




property af_p444;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> $stable(sd_cmd_dat_i)[*2];
endproperty
assert property(af_p444);


property af_p446;
@(posedge wb_clk_i) $changed(wb_adr_i) |-> $stable(sd_cmd_dat_i);
endproperty
assert property(af_p446);


property af_p448;
@(posedge wb_clk_i) sd_cmd_oe_o |-> (sd_cmd_out_o !== sd_cmd_dat_i);
endproperty
assert property(af_p448);


property af_p450;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 $stable(sd_cmd_dat_i);
endproperty
assert property(af_p450);

property af_p451;
@(posedge wb_clk_i) $rose(sd_cmd_dat_i) |=> $stable(sd_cmd_dat_i);
endproperty
assert property(af_p451);

property af_p452;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 (sd_cmd_dat_i === 1'b0 || sd_cmd_dat_i === 1'b1)[*1];
endproperty
assert property(af_p452);

property af_p453;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (sd_cmd_dat_i === 1'b0 || sd_cmd_dat_i === 1'b1);
endproperty
assert property(af_p453);


property af_p455;
@(posedge wb_clk_i) disable iff (wb_rst_i) (1'b1) |-> !$isunknown(sd_cmd_dat_i);
endproperty
assert property(af_p455);



property af_p458;
@(posedge wb_clk_i) (!sd_cmd_oe_o) |-> !$isunknown(sd_cmd_dat_i);
endproperty
assert property(af_p458);

property af_p459;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> (sd_cmd_dat_i === 1'b0 || sd_cmd_dat_i === 1'b1);
endproperty
assert property(af_p459);


property af_p461;
@(posedge wb_clk_i) (!wb_rst_i) |-> (sd_cmd_dat_i === 1'b0 || sd_cmd_dat_i === 1'b1);
endproperty
assert property(af_p461);

property af_p462;
@(posedge wb_clk_i) (wb_rst_i) |-> (sd_cmd_oe_o == 1'b0);
endproperty
assert property(af_p462);

property af_p463;
@(posedge wb_clk_i) $rose(sd_cmd_oe_o) |-> ##[1:16] (sd_cmd_oe_o == 1'b0);
endproperty
assert property(af_p463);

property af_p464;
@(posedge wb_clk_i) (wb_rst_i) |-> ##1 (sd_cmd_oe_o == 1'b0);
endproperty
assert property(af_p464);

property af_p465;
@(posedge wb_clk_i) (sd_cmd_oe_o == 1'b0) |-> (sd_cmd_dat_i !== sd_cmd_out_o || sd_cmd_dat_i === sd_cmd_dat_i);
endproperty
assert property(af_p465);

property af_p466;
@(posedge wb_clk_i) (sd_cmd_oe_o == 1'b0) |-> (!$isunknown(sd_cmd_dat_i));
endproperty
assert property(af_p466);

property af_p467;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (sd_cmd_oe_o == 1'b0);
endproperty
assert property(af_p467);

property af_p468;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> (sd_cmd_oe_o == 1'b0) ##1 (sd_cmd_oe_o == 1'b0);
endproperty
assert property(af_p468);

property af_p469;
@(posedge wb_clk_i) (sd_cmd_oe_o == 1'b1) |-> (!$isunknown(sd_cmd_oe_o) && (sd_cmd_dat_i === sd_cmd_dat_i));
endproperty
assert property(af_p469);

property af_p470;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (sd_cmd_oe_o == 1'b1);
endproperty
assert property(af_p470);


property af_p472;
@(posedge wb_clk_i) $rose(sd_cmd_oe_o) |-> ##[1:4] $fell(sd_cmd_oe_o);
endproperty
assert property(af_p472);

property af_p473;
@(posedge wb_clk_i) $rose(sd_cmd_oe_o) |-> !$isunknown(sd_cmd_out_o) && $stable(sd_cmd_out_o);
endproperty
assert property(af_p473);

property af_p474;
@(posedge wb_clk_i) (sd_cmd_oe_o != $past(sd_cmd_oe_o)) |=> $stable(sd_cmd_oe_o)[*3];
endproperty
assert property(af_p474);

property af_p475;
@(posedge wb_clk_i) (sd_cmd_oe_o) |-> !$isunknown(sd_cmd_out_o);
endproperty
assert property(af_p475);

property af_p476;
@(posedge wb_clk_i) !$isunknown(sd_cmd_oe_o) && ((sd_cmd_oe_o == 1'b0) || (sd_cmd_oe_o == 1'b1));
endproperty
assert property(af_p476);

property af_p477;
@(posedge wb_clk_i) (sd_cmd_oe_o === 1'b0) || (sd_cmd_oe_o === 1'b1);
endproperty
assert property(af_p477);

property af_p478;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (sd_cmd_oe_o == 1'b0)[*3];
endproperty
assert property(af_p478);

property af_p479;
@(posedge wb_clk_i) $changed(sd_cmd_oe_o) |=> $stable(sd_cmd_oe_o)[*2];
endproperty
assert property(af_p479);

property af_p480;
@(posedge wb_clk_i) $changed(sd_cmd_oe_o) |=> $stable(sd_cmd_oe_o);
endproperty
assert property(af_p480);

property af_p481;
@(posedge wb_clk_i) $rose(sd_cmd_oe_o) |-> $past(m_wb_cyc_o && m_wb_stb_o && m_wb_we_o);
endproperty
assert property(af_p481);


property af_p483;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> (sd_cmd_oe_o == 1'b0);
endproperty
assert property(af_p483);

property af_p484;
@(posedge wb_clk_i) (sd_cmd_oe_o == 1'b1) |-> !$isunknown(sd_cmd_out_o);
endproperty
assert property(af_p484);

property af_p485;
@(posedge wb_clk_i) $rose(sd_cmd_oe_o) |=> (sd_cmd_oe_o == 1'b1);
endproperty
assert property(af_p485);

property af_p486;
@(posedge wb_clk_i) (!wb_rst_i && !(m_wb_we_o && m_wb_stb_o)) |=> (sd_cmd_oe_o == 1'b0);
endproperty
assert property(af_p486);

property af_p487;
@(posedge wb_clk_i) sd_cmd_oe_o |=> $changed(sd_clk_o_pad);
endproperty
assert property(af_p487);

property af_p488;
@(posedge wb_clk_i) (sd_cmd_oe_o == 1'b0) |=> ($isunknown(sd_cmd_out_o) || (sd_cmd_out_o == 1'b0));
endproperty
assert property(af_p488);

property af_p489;
@(posedge wb_clk_i) disable iff (wb_rst_i) (sd_cmd_out_o inside {1'b0, 1'b1});
endproperty
assert property(af_p489);

property af_p490;
@(posedge wb_clk_i) $changed(sd_cmd_out_o) |-> ##1 $stable(sd_cmd_out_o);
endproperty
assert property(af_p490);

property af_p491;
@(posedge wb_clk_i) disable iff (wb_rst_i) (!sd_cmd_oe_o) |-> $stable(sd_cmd_out_o);
endproperty
assert property(af_p491);

property af_p492;
@(posedge wb_clk_i) disable iff (wb_rst_i) (sd_cmd_oe_o) |-> (!$isunknown(sd_cmd_out_o));
endproperty
assert property(af_p492);

property af_p493;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> (sd_cmd_out_o == 1'b1)[*3];
endproperty
assert property(af_p493);

property af_p494;
@(posedge wb_clk_i) (wb_rst_i) |-> ##[0:1] (sd_cmd_out_o == 1'b1);
endproperty
assert property(af_p494);

property af_p495;
@(posedge wb_clk_i) (sd_cmd_out_o) |-> (sd_cmd_oe_o);
endproperty
assert property(af_p495);

property af_p496;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> (sd_cmd_out_o == 1'b1) ##1 (sd_cmd_out_o == 1'b1);
endproperty
assert property(af_p496);

property af_p497;
@(posedge wb_clk_i) disable iff (wb_rst_i) (sd_cmd_oe_o) |-> (sd_cmd_dat_i == sd_cmd_out_o);
endproperty
assert property(af_p497);

property af_p498;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> (sd_cmd_out_o == 1'b0) ##1 (sd_cmd_out_o == 1'b0);
endproperty
assert property(af_p498);

property af_p499;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> ((sd_cmd_out_o == 1'b0) || (sd_cmd_out_o == 1'b1));
endproperty
assert property(af_p499);

property af_p500;
@(posedge wb_clk_i) (!(m_wb_stb_o && m_wb_cyc_o)) |-> $stable(sd_cmd_out_o);
endproperty
assert property(af_p500);

property af_p501;
@(posedge wb_clk_i) ($changed(sd_cmd_dat_i) && !sd_cmd_oe_o) |-> $stable(sd_cmd_out_o);
endproperty
assert property(af_p501);

property af_p502;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (((sd_cmd_out_o == 1'b0) || (sd_cmd_out_o == 1'b1)) ##1 $stable(sd_cmd_out_o));
endproperty
assert property(af_p502);

property af_p503;
@(posedge wb_clk_i) (!sd_cmd_oe_o) |-> $stable(sd_cmd_out_o);
endproperty
assert property(af_p503);

property af_p504;
@(posedge wb_clk_i) (sd_cmd_oe_o) |-> (sd_cmd_out_o == sd_cmd_dat_i);
endproperty
assert property(af_p504);

property af_p505;
@(posedge wb_clk_i) (!sd_cmd_oe_o) |-> (sd_cmd_out_o == $past(sd_cmd_out_o));
endproperty
assert property(af_p505);

property af_p506;
@(posedge wb_clk_i) (sd_cmd_oe_o) |-> (!$isunknown(sd_cmd_out_o));
endproperty
assert property(af_p506);

property af_p507;
@(posedge sd_clk_o_pad) (sd_cmd_oe_o) |-> (!$isunknown(sd_cmd_out_o));
endproperty
assert property(af_p507);

property af_p508;
@(posedge wb_clk_i) $rose(sd_cmd_oe_o) |-> ##1 (sd_cmd_out_o !== 1'bz);
endproperty
assert property(af_p508);


property af_p510;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 (sd_cmd_out_o inside {1'b0, 1'b1});
endproperty
assert property(af_p510);



property af_p513;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (sd_cmd_out_o inside {1'b0, 1'b1});
endproperty
assert property(af_p513);

property af_p514;
@(posedge wb_clk_i) ((sd_dat_dat_i >= 0) && (sd_dat_dat_i <= 7)) ##1 ((sd_dat_dat_i >= 8) && (sd_dat_dat_i <= 15)) |-> ##1 1'b1;
endproperty
assert property(af_p514);




property af_p518;
@(posedge wb_clk_i) ((sd_dat_dat_i >= 0) && (sd_dat_dat_i <= 15)) |=> (sd_dat_dat_i >= 0) && (sd_dat_dat_i <= 15);
endproperty
assert property(af_p518);

property af_p519;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (m_wb_dat_i !== $past(sd_dat_dat_i));
endproperty
assert property(af_p519);


property af_p521;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##3 (sd_dat_dat_i >= 0) && (sd_dat_dat_i <= 15);
endproperty
assert property(af_p521);




property af_p525;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 (sd_dat_dat_i inside {[0:15]});
endproperty
assert property(af_p525);

property af_p526;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> (sd_dat_dat_i inside {[0:15]});
endproperty
assert property(af_p526);

property af_p527;
@(posedge wb_clk_i) $rose(!wb_rst_i) |=> !$isunknown(sd_dat_dat_i);
endproperty
assert property(af_p527);


property af_p529;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##1 (sd_dat_dat_i inside {[0:15]}) ##1 ($stable(sd_dat_dat_i) && (sd_dat_dat_i inside {[0:15]}));
endproperty
assert property(af_p529);

property af_p530;
@(posedge wb_clk_i) (!wb_rst_i) |-> (sd_dat_dat_i inside {[0:15]});
endproperty
assert property(af_p530);


property af_p532;
@(posedge wb_clk_i) (sd_dat_oe_o) |-> ((sd_dat_out_o == sd_dat_dat_i) && (sd_dat_dat_i >= 0) && (sd_dat_dat_i <= 15));
endproperty
assert property(af_p532);

property af_p533;
@(posedge wb_clk_i) ((sd_dat_dat_i >= 4) && (sd_dat_dat_i <= 11)) |=> ((sd_dat_dat_i >= 0) && (sd_dat_dat_i <= 15));
endproperty
assert property(af_p533);


property af_p535;
@(posedge sd_clk_o_pad) (sd_dat_oe_o) |=> ((sd_dat_dat_i >= 0) && (sd_dat_dat_i <= 15));
endproperty
assert property(af_p535);



property af_p538;
@(posedge wb_clk_i) ((sd_dat_dat_i >= 1) && (sd_dat_dat_i <= 14)) |=> ((sd_dat_dat_i >= 0) && (sd_dat_dat_i <= 15));
endproperty
assert property(af_p538);

property af_p539;
@(posedge wb_clk_i) $changed(sd_dat_dat_i) |-> !$isunknown(sd_dat_dat_i);
endproperty
assert property(af_p539);

property af_p540;
@(posedge sd_clk_o_pad) ($past(wb_rst_i) && !wb_rst_i) |-> ((sd_dat_dat_i >= 0) && (sd_dat_dat_i <= 15)) ##1 ((sd_dat_dat_i >= 0) && (sd_dat_dat_i <= 15));
endproperty
assert property(af_p540);

property af_p541;
@(posedge wb_clk_i) ($rose(sd_dat_oe_o)) |-> (sd_dat_oe_o[*1] ##1 !$fell(sd_dat_oe_o));
endproperty
assert property(af_p541);

property af_p542;
@(posedge wb_clk_i) ($rose(m_wb_ack_i)) |-> ##[1:4] (sd_dat_oe_o == 1'b0);
endproperty
assert property(af_p542);



property af_p545;
@(posedge wb_clk_i) (1'b1) |-> ((sd_dat_oe_o == 1'b0) || (sd_dat_oe_o == 1'b1));
endproperty
assert property(af_p545);

property af_p546;
@(posedge wb_clk_i) (sd_dat_oe_o == 1'b1) |-> ($stable(sd_dat_out_o));
endproperty
assert property(af_p546);

property af_p547;
@(posedge wb_clk_i) (!wb_rst_i) |-> ((sd_dat_oe_o == 1'b0) || (sd_dat_oe_o == 1'b1));
endproperty
assert property(af_p547);

property af_p548;
@(posedge sd_clk_o_pad) (1'b1) |-> ((sd_dat_oe_o == 1'b0) || (sd_dat_oe_o == 1'b1));
endproperty
assert property(af_p548);

property af_p549;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 ((sd_dat_oe_o == 1'b0) || (sd_dat_oe_o == 1'b1));
endproperty
assert property(af_p549);

property af_p550;
@(posedge wb_clk_i) (1'b1) |-> ((sd_dat_oe_o inside {1'b0, 1'b1}) && (sd_cmd_oe_o inside {1'b0, 1'b1}));
endproperty
assert property(af_p550);

property af_p551;
@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> ##[0:1] (sd_dat_oe_o == 1'b0) throughout (wb_rst_i);
endproperty
assert property(af_p551);

property af_p552;
@(posedge wb_clk_i) (wb_rst_i) |-> (sd_dat_oe_o == 1'b0);
endproperty
assert property(af_p552);

property af_p553;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> (sd_dat_oe_o == 1'b0) ##1 (sd_dat_oe_o == 1'b0);
endproperty
assert property(af_p553);

property af_p554;
@(posedge wb_clk_i) ($fell(wb_rst_i) ##1 m_wb_we_o) |-> (sd_dat_oe_o == 1'b1);
endproperty
assert property(af_p554);

property af_p555;
@(posedge wb_clk_i) ($fell(wb_rst_i) ##4 1'b1) |-> (!$isunknown(sd_dat_oe_o) && (sd_dat_oe_o == $past(sd_dat_oe_o)));
endproperty
assert property(af_p555);

property af_p556;
@(posedge wb_clk_i) (sd_dat_oe_o == 1'b1) |-> (!$isunknown(sd_dat_dat_i) == 1'b0);
endproperty
assert property(af_p556);

property af_p557;
@(posedge wb_clk_i) (sd_dat_oe_o == 1'b1) |-> (!$isunknown(sd_dat_out_o));
endproperty
assert property(af_p557);

property af_p558;
@(posedge wb_clk_i) (sd_dat_oe_o == $past(sd_dat_oe_o)) or (sd_dat_oe_o == $past(sd_dat_oe_o,2));
endproperty
assert property(af_p558);

property af_p559;
@(posedge wb_clk_i) $rose(sd_dat_oe_o) |-> 1'b1;
endproperty
assert property(af_p559);

property af_p560;
@(posedge wb_clk_i) (sd_dat_oe_o == 1'b0) |-> (!$isunknown(sd_dat_dat_i));
endproperty
assert property(af_p560);

property af_p561;
@(posedge wb_clk_i) $rose(sd_dat_oe_o) |=> sd_dat_oe_o;
endproperty
assert property(af_p561);

property af_p562;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:3] !$isunknown(sd_dat_oe_o);
endproperty
assert property(af_p562);

property af_p563;
@(posedge wb_clk_i) $stable(sd_dat_dat_i) |-> $stable(sd_dat_oe_o);
endproperty
assert property(af_p563);

property af_p564;
@(posedge wb_clk_i) sd_dat_oe_o |-> (m_wb_cyc_o && m_wb_we_o);
endproperty
assert property(af_p564);

property af_p565;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:3] (sd_dat_oe_o === 1'b0);
endproperty
assert property(af_p565);

property af_p566;
@(posedge wb_clk_i) $changed(sd_dat_oe_o) |=> $stable(sd_dat_oe_o);
endproperty
assert property(af_p566);

property af_p567;
@(posedge wb_clk_i) (wb_rst_i) |-> (sd_dat_oe_o === 1'b0);
endproperty
assert property(af_p567);

property af_p568;
@(posedge wb_clk_i) disable iff (wb_rst_i) $stable(sd_dat_oe_o) || $changed(sd_dat_oe_o);
endproperty
assert property(af_p568);

property af_p569;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> (sd_dat_oe_o === 1'b0);
endproperty
assert property(af_p569);

property af_p570;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:3] (sd_dat_oe_o === 1'b0 || sd_dat_oe_o === 1'b1);
endproperty
assert property(af_p570);

property af_p571;
@(posedge wb_clk_i) (!sd_dat_oe_o) |-> $stable(sd_dat_out_o);
endproperty
assert property(af_p571);

property af_p572;
@(posedge wb_clk_i) (sd_dat_oe_o) |-> ##1 (sd_dat_out_o >= 0 && sd_dat_out_o <= 15);
endproperty
assert property(af_p572);

property af_p573;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_we_o) |-> ##1 (sd_dat_out_o == m_wb_dat_o[3:0]);
endproperty
assert property(af_p573);

property af_p574;
@(posedge wb_clk_i) $rose(sd_dat_oe_o) |-> (sd_dat_out_o >= 0 && sd_dat_out_o <= 15) ##1 $stable(sd_dat_out_o);
endproperty
assert property(af_p574);

property af_p575;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 (sd_dat_out_o >= 0 && sd_dat_out_o <= 15);
endproperty
assert property(af_p575);

property af_p576;
@(posedge wb_clk_i) (wb_rst_i) |-> $stable(sd_dat_out_o);
endproperty
assert property(af_p576);

property af_p577;
@(posedge sd_clk_o_pad) (sd_dat_oe_o) |-> (sd_dat_out_o == sd_dat_dat_i);
endproperty
assert property(af_p577);

property af_p578;
@(posedge wb_clk_i) (!wb_rst_i) |-> (sd_dat_out_o >= 0 && sd_dat_out_o <= 15);
endproperty
assert property(af_p578);

property af_p579;
@(posedge sd_clk_o_pad) (sd_dat_oe_o) |-> !$stable(sd_dat_out_o);
endproperty
assert property(af_p579);


property af_p581;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 (sd_dat_out_o >= 4'd0 && sd_dat_out_o <= 4'd15);
endproperty
assert property(af_p581);

property af_p582;
@(posedge wb_clk_i) $rose(sd_dat_oe_o) |=> (sd_dat_out_o !== $past(sd_dat_out_o));
endproperty
assert property(af_p582);

property af_p583;
@(posedge wb_clk_i) $rose(sd_dat_oe_o) |-> ##1 (sd_dat_out_o >= 4'd0 && sd_dat_out_o <= 4'd15);
endproperty
assert property(af_p583);

property af_p584;
@(posedge wb_clk_i) (wb_rst_i) |-> (sd_dat_out_o == 4'b0000);
endproperty
assert property(af_p584);

property af_p585;
@(posedge sd_clk_o_pad) (sd_dat_oe_o) |-> (sd_dat_out_o >= 4'd0 && sd_dat_out_o <= 4'd15);
endproperty
assert property(af_p585);

property af_p586;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 (sd_dat_out_o >= 4'd0 && sd_dat_out_o <= 4'd15)[*3];
endproperty
assert property(af_p586);

property af_p587;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:4] (sd_dat_out_o >= 4'd0 && sd_dat_out_o <= 4'd15);
endproperty
assert property(af_p587);

property af_p588;
@(posedge wb_clk_i) (!wb_rst_i) |-> (sd_dat_out_o >= 4'd0 && sd_dat_out_o <= 4'd15);
endproperty
assert property(af_p588);

property af_p589;
@(posedge sd_clk_o_pad) $stable(sd_dat_out_o) |=> $stable(sd_dat_out_o);
endproperty
assert property(af_p589);


property af_p591;
@(posedge wb_clk_i) (sd_dat_oe_o) |-> $stable(sd_dat_out_o);
endproperty
assert property(af_p591);

property af_p592;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (sd_dat_out_o inside {[0:15]});
endproperty
assert property(af_p592);

property af_p593;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 $stable(sd_dat_out_o);
endproperty
assert property(af_p593);

property af_p594;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o && m_wb_we_o) |-> ##1 (sd_dat_out_o == m_wb_dat_o[3:0]);
endproperty
assert property(af_p594);

property af_p595;
@(posedge wb_clk_i) (!sd_dat_oe_o) |-> ($stable(sd_dat_out_o) || $stable(sd_dat_dat_i));
endproperty
assert property(af_p595);

property af_p596;
@(posedge wb_clk_i) $fell(sd_dat_oe_o) |-> ##1 $stable(sd_dat_out_o);
endproperty
assert property(af_p596);

property af_p597;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:3] (sd_dat_out_o inside {[0:15]});
endproperty
assert property(af_p597);

property af_p598;
@(posedge wb_clk_i) ((wb_adr_i >= 64) && (wb_adr_i <= 127)) |-> ##1 ((wb_adr_i >= 32) && (wb_adr_i <= 127));
endproperty
assert property(af_p598);

property af_p599;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 ((wb_adr_i >= 0) && (wb_adr_i <= 255))[*5];
endproperty
assert property(af_p599);

property af_p600;
@(posedge wb_clk_i) ((wb_adr_i >= 0) && (wb_adr_i <= 255)) |-> ##1 (wb_adr_i >= 0) && (wb_adr_i <= 255);
endproperty
assert property(af_p600);

property af_p601;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 ((wb_adr_i >= 0) && (wb_adr_i <= 0));
endproperty
assert property(af_p601);

property af_p602;
@(posedge wb_clk_i) (!wb_rst_i) |-> ((wb_adr_i >= 0) && (wb_adr_i <= 255));
endproperty
assert property(af_p602);

property af_p603;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((wb_adr_i >= 0) && (wb_adr_i <= 255));
endproperty
assert property(af_p603);

property af_p604;
@(posedge wb_clk_i) ((wb_adr_i >= 200) && (wb_adr_i <= 220)) |-> ##1 ((wb_adr_i >= 150) && (wb_adr_i <= 255));
endproperty
assert property(af_p604);

property af_p605;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((wb_adr_i >= 0) && (wb_adr_i <= 127));
endproperty
assert property(af_p605);

property af_p606;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 ($stable(wb_adr_i) && (wb_adr_i >= 0) && (wb_adr_i <= 255))[*2];
endproperty
assert property(af_p606);

property af_p607;
@(posedge wb_clk_i) ((wb_adr_i >= 0) && (wb_adr_i <= 15)) |-> ##1 ((wb_adr_i >= 0) && (wb_adr_i <= 31));
endproperty
assert property(af_p607);

property af_p608;
@(posedge wb_clk_i) ((wb_adr_i >= 200) && (wb_adr_i <= 255)) |-> (wb_adr_i >= 180) && (wb_adr_i <= 255);
endproperty
assert property(af_p608);

property af_p609;
@(posedge wb_clk_i) ((wb_adr_i >= 128) && (wb_adr_i <= 200)) |-> (wb_adr_i >= 100) && (wb_adr_i <= 220);
endproperty
assert property(af_p609);

property af_p610;
@(posedge wb_clk_i) (!wb_rst_i) |-> ($stable(wb_adr_i) && (wb_adr_i >= 100) && (wb_adr_i <= 150));
endproperty
assert property(af_p610);

property af_p611;
@(posedge wb_clk_i) (wb_rst_i) |-> (wb_adr_i == $past(wb_adr_i));
endproperty
assert property(af_p611);

property af_p612;
@(posedge wb_clk_i) ((wb_adr_i >= 32) && (wb_adr_i <= 63)) |=> ((wb_adr_i >= 0) && (wb_adr_i <= 63));
endproperty
assert property(af_p612);

property af_p613;
@(posedge wb_clk_i) ((wb_adr_i >= 200) && (wb_adr_i <= 255)) |=> (wb_adr_i >= 180) && (wb_adr_i <= 255);
endproperty
assert property(af_p613);

property af_p614;
@(posedge wb_clk_i) (!wb_rst_i) |-> (wb_adr_i >= 0) && (wb_adr_i <= 255);
endproperty
assert property(af_p614);

property af_p615;
@(posedge wb_clk_i) ($rose(wb_rst_i)) |=> (wb_adr_i >= 0) && (wb_adr_i <= 0);
endproperty
assert property(af_p615);

property af_p616;
@(posedge wb_clk_i) ((wb_adr_i >= 200) && (wb_adr_i <= 255)) |=> ##1 (wb_adr_i >= 150) && (wb_adr_i <= 255);
endproperty
assert property(af_p616);

property af_p617;
@(posedge wb_clk_i) ((wb_adr_i >= 16) && (wb_adr_i <= 31)) |=> (wb_adr_i >= 0) && (wb_adr_i <= 255);
endproperty
assert property(af_p617);

property af_p618;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 (wb_adr_i >= 0) && (wb_adr_i <= 63);
endproperty
assert property(af_p618);

property af_p619;
@(posedge wb_clk_i) ((wb_adr_i >= 0) && (wb_adr_i <= 255)) |=> (wb_adr_i >= 0) && (wb_adr_i <= 255);
endproperty
assert property(af_p619);

property af_p620;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##5 (wb_adr_i >= 0) && (wb_adr_i <= 50);
endproperty
assert property(af_p620);

property af_p621;
@(posedge wb_clk_i) ((wb_adr_i >= 128) && (wb_adr_i <= 255)) |=> (wb_adr_i >= 64) && (wb_adr_i <= 255);
endproperty
assert property(af_p621);

property af_p622;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##3 (wb_adr_i >= 0) && (wb_adr_i <= 255);
endproperty
assert property(af_p622);

property af_p623;
@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> ##1 (wb_adr_i >= 0) && (wb_adr_i <= 0);
endproperty
assert property(af_p623);

property af_p624;
@(posedge wb_clk_i) 1 |=> ($time - $past($time)) == ($past($time) - $past($time,2));
endproperty
assert property(af_p624);

property af_p625;
@(posedge wb_clk_i) (wb_rst_i) |-> ##1 (wb_clk_i !== $past(wb_clk_i));
endproperty
assert property(af_p625);

property af_p626;
@(posedge wb_clk_i) 1 |-> ##1 $stable(wb_dat_i);
endproperty
assert property(af_p626);

property af_p627;
@(posedge wb_clk_i) 1 |=> $stable(wb_adr_i) throughout (!$rose(wb_clk_i));
endproperty
assert property(af_p627);

property af_p628;
@(posedge wb_clk_i) (!wb_rst_i) |-> ##1 (wb_clk_i !== $past(wb_clk_i));
endproperty
assert property(af_p628);

property af_p629;
@(posedge wb_clk_i) 1 |=> $stable(wb_adr_i) throughout (!$rose(wb_clk_i)) && $stable(wb_dat_i) throughout (!$rose(wb_clk_i));
endproperty
assert property(af_p629);

property af_p630;
@(posedge wb_clk_i) 1 |=> (($time - $past($time)) == ($past($time) - $past($time,2)));
endproperty
assert property(af_p630);

property af_p631;
@(posedge wb_clk_i) 1 |=> $stable(wb_dat_i) throughout (!$rose(wb_clk_i));
endproperty
assert property(af_p631);

property af_p632;
@(posedge wb_clk_i) (wb_rst_i) |-> ##1 $changed(wb_clk_i);
endproperty
assert property(af_p632);

property af_p633;
@(posedge wb_clk_i) 1 |=> $stable(m_wb_adr_o) throughout (!$rose(wb_clk_i));
endproperty
assert property(af_p633);

property af_p634;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 $stable(wb_adr_i);
endproperty
assert property(af_p634);

property af_p635;
@(posedge wb_clk_i) $changed(wb_dat_o) |-> $rose(wb_clk_i);
endproperty
assert property(af_p635);

property af_p636;
@(posedge wb_clk_i) wb_rst_i |-> ##1 $changed(wb_clk_i);
endproperty
assert property(af_p636);

property af_p637;
@(posedge wb_clk_i) 1'b1 |-> ##1 $stable(wb_clk_i) throughout (1'b0 [*0]);
endproperty
assert property(af_p637);

property af_p638;
@(posedge wb_clk_i) 1'b1 |-> (($time - $past($time)) <= (1.05 * $past($time - $past($time,2)))) && (($time - $past($time)) >= (0.95 * $past($time - $past($time,2))));
endproperty
assert property(af_p638);

property af_p639;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> $rose(wb_clk_i);
endproperty
assert property(af_p639);

property af_p640;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:10] $changed(wb_clk_i);
endproperty
assert property(af_p640);

property af_p641;
@(posedge wb_clk_i) $changed(wb_dat_i) |-> $stable(wb_dat_i);
endproperty
assert property(af_p641);



property af_p644;
@(posedge wb_clk_i) 1 |-> ##1 $stable(m_wb_dat_i) throughout (1 ##1 1);
endproperty
assert property(af_p644);

property af_p645;
@(posedge wb_clk_i) $stable(wb_adr_i) throughout (1 ##1 1);
endproperty
assert property(af_p645);

property af_p646;
@(posedge wb_clk_i or negedge wb_clk_i) (wb_rst_i) |-> $rose(wb_clk_i) or $fell(wb_clk_i);
endproperty
assert property(af_p646);

property af_p647;
@(posedge wb_clk_i) 1 |-> ##1 (wb_clk_i == ~$past(wb_clk_i));
endproperty
assert property(af_p647);

property af_p648;
@(posedge wb_clk_i) 1 |-> !$isunknown(wb_dat_i) && $stable(wb_dat_i, @(negedge wb_clk_i));
endproperty
assert property(af_p648);

property af_p649;
@(posedge wb_clk_i) (1'b1) |-> ($time - $past($time)) == ($past($time) - $past($time,2));
endproperty
assert property(af_p649);

property af_p650;
@(posedge wb_clk_i) 1 |-> ($time - $past($time)) == ($past($time) - $past($time,2));
endproperty
assert property(af_p650);

property af_p651;
@(posedge wb_clk_i) (wb_rst_i) |-> $stable(wb_dat_i) or 1'b1;
endproperty
assert property(af_p651);

property af_p652;
@(posedge wb_clk_i) (!wb_rst_i) |-> (wb_dat_i >= 0) && (wb_dat_i <= 255);
endproperty
assert property(af_p652);

property af_p653;
@(posedge wb_clk_i) ((wb_dat_i >= 500) && (wb_dat_i <= 1000)) |-> ##1 (wb_dat_i >= 400) && (wb_dat_i <= 1100);
endproperty
assert property(af_p653);

property af_p654;
@(posedge wb_clk_i) ((wb_dat_i >= 100) && (wb_dat_i <= 200)) |-> $stable(wb_adr_i);
endproperty
assert property(af_p654);

property af_p655;
@(posedge wb_clk_i) ((wb_dat_i >= 1000) && (wb_dat_i <= 2000)) |-> ##1 (wb_dat_i >= 500) && (wb_dat_i <= 2500);
endproperty
assert property(af_p655);

property af_p656;
@(posedge wb_clk_i) (!wb_rst_i) |-> $stable(wb_dat_i);
endproperty
assert property(af_p656);

property af_p657;
@(posedge wb_clk_i) ($stable(wb_adr_i)) |-> $stable(wb_dat_i);
endproperty
assert property(af_p657);

property af_p658;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((wb_dat_i >= 0) && (wb_dat_i <= 4294967295));
endproperty
assert property(af_p658);

property af_p659;
@(posedge wb_clk_i) ((wb_dat_i >= 0) && (wb_dat_i <= 255)) |-> ##1 ((wb_dat_i >= 0) && (wb_dat_i <= 4294967295));
endproperty
assert property(af_p659);

property af_p660;
@(posedge wb_clk_i) ((wb_dat_i >= 100) && (wb_dat_i <= 200)) |-> ##1 ((wb_dat_i >= 80) && (wb_dat_i <= 220));
endproperty
assert property(af_p660);

property af_p661;
@(posedge wb_clk_i) (wb_rst_i) |-> (wb_dat_i == $past(wb_dat_i));
endproperty
assert property(af_p661);

property af_p662;
@(posedge wb_clk_i) $stable(wb_dat_i, @(negedge wb_clk_i));
endproperty
assert property(af_p662);

property af_p663;
@(posedge wb_clk_i) (!wb_rst_i) |-> ((wb_dat_i >= 0) && (wb_dat_i <= 4294967295));
endproperty
assert property(af_p663);

property af_p664;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((wb_dat_i >= 0) && (wb_dat_i <= 65535));
endproperty
assert property(af_p664);

property af_p665;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 ((wb_dat_i >= 0) && (wb_dat_i <= 65535));
endproperty
assert property(af_p665);

property af_p666;
@(posedge wb_clk_i) ($stable(wb_adr_i) && (wb_dat_i >= 0) && (wb_dat_i <= 255)) |-> ##1 ($stable(wb_dat_i) && (wb_dat_i >= 0) && (wb_dat_i <= 255));
endproperty
assert property(af_p666);

property af_p667;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 ((wb_dat_i >= 0) && (wb_dat_i <= 4294967295));
endproperty
assert property(af_p667);

property af_p668;
@(posedge wb_clk_i) (($past(wb_dat_i) >= 0) && ($past(wb_dat_i) <= 50) && (wb_dat_i >= 200) && (wb_dat_i <= 255)) |-> ((wb_dat_i >= 200) && (wb_dat_i <= 255));
endproperty
assert property(af_p668);

property af_p669;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##1 (!$isunknown(wb_dat_i));
endproperty
assert property(af_p669);

property af_p670;
@(posedge wb_clk_i) (wb_rst_i) |-> (sd_clk_o_pad == 1'b0);
endproperty
assert property(af_p670);

property af_p671;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##1 (!$isunknown(wb_dat_i));
endproperty
assert property(af_p671);

property af_p672;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:3] (!$isunknown(m_wb_dat_o));
endproperty
assert property(af_p672);

property af_p673;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:2] (m_wb_adr_o == wb_adr_i);
endproperty
assert property(af_p673);

property af_p674;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 (m_wb_dat_o == wb_dat_i);
endproperty
assert property(af_p674);

property af_p675;
@(posedge wb_clk_i) (wb_rst_i[*4] ##1 !wb_rst_i) |-> (m_wb_we_o == 1'b0);
endproperty
assert property(af_p675);

property af_p676;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (m_wb_adr_o == '0);
endproperty
assert property(af_p676);

property af_p677;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_cyc_o == 1'b0 && m_wb_we_o == 1'b0 && m_wb_adr_o == '0);
endproperty
assert property(af_p677);

property af_p678;
@(posedge wb_clk_i) (wb_rst_i) |-> ##1 (m_wb_cyc_o == 1'b0);
endproperty
assert property(af_p678);

property af_p679;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (m_wb_cyc_o == 1'b0);
endproperty
assert property(af_p679);

property af_p680;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_adr_o == '0)[*2];
endproperty
assert property(af_p680);

property af_p681;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_stb_o == 1'b0) throughout (wb_rst_i[*1:$]);
endproperty
assert property(af_p681);

property af_p682;
@(posedge wb_clk_i) ($rose(wb_rst_i) ##1 $fell(wb_rst_i)) |-> ##[1:2] (m_wb_adr_o inside {[8'h00:8'hFF]});
endproperty
assert property(af_p682);

property af_p683;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (sd_cmd_oe_o == 1'b0) && (sd_dat_oe_o == 1'b0) [*1];
endproperty
assert property(af_p683);

property af_p684;
@(posedge wb_clk_i) (wb_rst_i) |-> (sd_cmd_oe_o == 1'b0);
endproperty
assert property(af_p684);

property af_p685;
@(posedge wb_clk_i) (wb_rst_i throughout wb_rst_i[*2:$]) |-> (m_wb_stb_o == 1'b0);
endproperty
assert property(af_p685);

property af_p686;
@(posedge wb_clk_i) (wb_rst_i) |=> (m_wb_stb_o == 1'b0);
endproperty
assert property(af_p686);

property af_p687;
@(posedge wb_clk_i or posedge wb_rst_i) (wb_rst_i) |-> (m_wb_adr_o == '0);
endproperty
assert property(af_p687);

property af_p688;
@(posedge wb_clk_i) (wb_rst_i) |-> (sd_clk_o_pad == 1'b0) throughout (wb_rst_i[*1:$]);
endproperty
assert property(af_p688);

property af_p689;
@(posedge wb_clk_i) (wb_rst_i) |=> (sd_cmd_oe_o == 1'b0);
endproperty
assert property(af_p689);

property af_p690;
@(posedge wb_clk_i or posedge wb_rst_i) (wb_rst_i) |-> ##[0:1] ((m_wb_cyc_o == 1'b0) && (m_wb_stb_o == 1'b0));
endproperty
assert property(af_p690);

property af_p691;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_stb_o == 1'b0) && (m_wb_we_o == 1'b0);
endproperty
assert property(af_p691);

property af_p692;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> (wb_dat_i inside {[32'h0:32'hFFFFFFFF]});
endproperty
assert property(af_p692);

property af_p693;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> (wb_rst_i [*2]);
endproperty
assert property(af_p693);

property af_p694;
@(posedge wb_clk_i) (wb_rst_i [*2]) |-> (m_wb_cyc_o == 1'b0) && (m_wb_stb_o == 1'b0);
endproperty
assert property(af_p694);

property af_p695;
@(posedge wb_clk_i) (wb_rst_i) |-> (sd_dat_oe_o == 1'b0);
endproperty
assert property(af_p695);

property af_p696;
@(posedge wb_clk_i) (!wb_rst_i [*2]) |-> ##1 ($stable(wb_dat_i) || (wb_dat_i == $past(wb_dat_i)));
endproperty
assert property(af_p696);

property af_p697;
@(posedge wb_clk_i) (wb_rst_i) |=> (m_wb_we_o == 1'b0);
endproperty
assert property(af_p697);

property af_p698;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_we_o == 1'b0);
endproperty
assert property(af_p698);

property af_p699;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 (m_wb_dat_o !== $past(m_wb_dat_o));
endproperty
assert property(af_p699);

property af_p700;
@(posedge wb_clk_i) (wb_rst_i) |-> not ($stable(wb_adr_i)) until_with (!wb_rst_i);
endproperty
assert property(af_p700);

property af_p701;
@(posedge wb_clk_i) (wb_rst_i && (m_wb_cyc_o || m_wb_stb_o)) |=> (m_wb_cyc_o == 1'b0) && (m_wb_stb_o == 1'b0);
endproperty
assert property(af_p701);

property af_p702;
@(posedge wb_clk_i) ($fell(wb_rst_i) ##4 (wb_adr_i != 8'h00)) |-> ((m_wb_cyc_o == 1'b1) && (m_wb_stb_o == 1'b1));
endproperty
assert property(af_p702);

