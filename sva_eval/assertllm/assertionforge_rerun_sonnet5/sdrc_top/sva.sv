// AssertionForge baseline SVA for sdr_ctrl
// 1026 assertions captured from gen_plan.generate_svas

property af_p0;
@(posedge sdram_clk) (wb_cyc_i && $past(wb_cyc_i)) |-> (cfg_colbits == $past(cfg_colbits));
endproperty
assert property(af_p0);

property af_p1;
@(posedge sdram_clk) (cfg_sdr_en) |-> (cfg_colbits == $past(cfg_colbits));
endproperty
assert property(af_p1);

property af_p2;
@(posedge sdram_clk) (cfg_colbits >= 2'b00) && (cfg_colbits <= 2'b11);
endproperty
assert property(af_p2);


property af_p4;
@(posedge wb_clk_i) (!wb_rst_i) |-> (cfg_colbits >= 2'b00) && (cfg_colbits <= 2'b11);
endproperty
assert property(af_p4);

property af_p5;
@(posedge sdram_clk) disable iff (!sdram_resetn) (sdram_resetn) |-> (cfg_colbits == $past(cfg_colbits));
endproperty
assert property(af_p5);

property af_p6;
@(posedge wb_clk_i) ($past(cfg_colbits) == 2'b11 && cfg_colbits == 2'b00) |-> (sdr_ba == wb_addr_i[9:8]);
endproperty
assert property(af_p6);

property af_p7;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 (cfg_colbits inside {[0:3]});
endproperty
assert property(af_p7);

property af_p8;
@(posedge sdram_clk) ($fell(sdram_resetn)) |-> (cfg_colbits == 2'b00)[*2];
endproperty
assert property(af_p8);

property af_p9;
@(posedge sdram_clk) (cfg_colbits == 2'b00) |=> ($isunknown(sdr_addr[7:0]) === 1'b0);
endproperty
assert property(af_p9);

property af_p10;
@(posedge wb_clk_i) (cfg_colbits == 2'b00) |=> ((cfg_colbits == 2'b00) && (sdr_ba == wb_addr_i[9:8]));
endproperty
assert property(af_p10);

property af_p11;
@(posedge sdram_clk) (cfg_colbits inside {[2'b00:2'b11]}) |=> (cfg_colbits inside {[2'b00:2'b11]});
endproperty
assert property(af_p11);

property af_p12;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |=> $stable(cfg_colbits);
endproperty
assert property(af_p12);

property af_p13;
@(posedge wb_clk_i) (cfg_sdr_en) |-> (cfg_colbits inside {[0:3]});
endproperty
assert property(af_p13);

property af_p14;
@(posedge sdram_clk) $fell(sdram_resetn) |=> (cfg_colbits == $past(cfg_colbits));
endproperty
assert property(af_p14);

property af_p15;
@(posedge wb_clk_i) ((cfg_colbits >= 0) && (cfg_colbits <= 3)) |=> (cfg_colbits >= 0) && (cfg_colbits <= 3);
endproperty
assert property(af_p15);

property af_p16;
@(posedge sdram_clk) ($past(cfg_colbits) == 2'b01 && cfg_colbits == 2'b10) |-> ##1 (sdr_addr == $past(wb_addr_i[23:12]));
endproperty
assert property(af_p16);

property af_p17;
@(posedge sdram_clk) (cfg_colbits == 2'b11) |=> (sdr_ba == $past(wb_addr_i[12:11]));
endproperty
assert property(af_p17);

property af_p18;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 ((cfg_colbits >= 0) && (cfg_colbits <= 3));
endproperty
assert property(af_p18);

property af_p19;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |=> (cfg_colbits == $past(cfg_colbits));
endproperty
assert property(af_p19);

property af_p20;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> (cfg_colbits == $past(cfg_colbits, 1)) [*5];
endproperty
assert property(af_p20);

property af_p21;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##3 ((cfg_req_depth >= 0) && (cfg_req_depth <= 31));
endproperty
assert property(af_p21);

property af_p22;
@(posedge wb_clk_i) ((cfg_req_depth >= 0) && (cfg_req_depth <= 15)) |-> ##1 ((cfg_req_depth >= 0) && (cfg_req_depth <= 15));
endproperty
assert property(af_p22);

property af_p23;
@(posedge wb_clk_i) (!wb_rst_i) |-> $stable(cfg_req_depth) && ((cfg_req_depth >= 0) && (cfg_req_depth <= 255));
endproperty
assert property(af_p23);

property af_p24;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 ((cfg_req_depth >= 0) && (cfg_req_depth <= 15));
endproperty
assert property(af_p24);

property af_p25;
@(posedge wb_clk_i) (!sdr_init_done) |-> ($stable(cfg_req_depth));
endproperty
assert property(af_p25);



property af_p28;
@(posedge wb_clk_i) (wb_stb_i) |-> ((cfg_req_depth >= 0) && (cfg_req_depth <= 255));
endproperty
assert property(af_p28);

property af_p29;
@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> (cfg_req_depth == cfg_req_depth) throughout (!wb_rst_i)[->1];
endproperty
assert property(af_p29);

property af_p30;
@(posedge wb_clk_i) (1'b1) |-> $stable(cfg_req_depth);
endproperty
assert property(af_p30);

property af_p31;
@(posedge wb_clk_i) ((cfg_req_depth >= 2) && (cfg_req_depth <= 16)) |-> ((cfg_req_depth >= 2) && (cfg_req_depth <= 16));
endproperty
assert property(af_p31);

property af_p32;
@(posedge wb_clk_i) (cfg_sdr_en && sdr_init_done) |-> ((cfg_req_depth >= 0) && (cfg_req_depth <= 15));
endproperty
assert property(af_p32);

property af_p33;
@(posedge wb_clk_i) ((cfg_req_depth >= 4) && (cfg_req_depth <= 12)) |-> ((cfg_req_depth >= 0) && (cfg_req_depth <= 16));
endproperty
assert property(af_p33);

property af_p34;
@(posedge wb_clk_i) $rose(cfg_req_depth > 0) |-> ##[1:16] wb_ack_o;
endproperty
assert property(af_p34);

property af_p35;
@(posedge wb_clk_i) (sdram_resetn) |-> ($stable(cfg_req_depth) && (cfg_req_depth >= 1) && (cfg_req_depth <= 8));
endproperty
assert property(af_p35);

property af_p36;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> (cfg_req_depth == '0);
endproperty
assert property(af_p36);

property af_p37;
@(posedge wb_clk_i) ((cfg_req_depth >= 0) && (cfg_req_depth <= 7)) |=> ((cfg_req_depth >= 0) && (cfg_req_depth <= 7));
endproperty
assert property(af_p37);

property af_p38;
@(posedge wb_clk_i) (wb_cyc_i) |-> $stable(cfg_req_depth);
endproperty
assert property(af_p38);

property af_p39;
@(posedge wb_clk_i) ((cfg_req_depth >= 2) && (cfg_req_depth <= 10)) |-> ((cfg_req_depth >= 0) && (cfg_req_depth <= 10));
endproperty
assert property(af_p39);

property af_p40;
@(posedge wb_clk_i) (sdram_resetn) |-> ((cfg_req_depth >= 0) && (cfg_req_depth <= 15));
endproperty
assert property(af_p40);

property af_p41;
@(posedge wb_clk_i) (!wb_rst_i) |-> ((cfg_req_depth >= 1 && cfg_req_depth <= 15) && (cfg_req_depth == $past(cfg_req_depth)));
endproperty
assert property(af_p41);

property af_p42;
@(posedge wb_clk_i) (cfg_req_depth == 8'hFF) |-> ##[1:$] (wb_ack_o);
endproperty
assert property(af_p42);

property af_p43;
@(posedge wb_clk_i) (wb_cyc_i && $past(wb_cyc_i)) |-> (cfg_req_depth == $past(cfg_req_depth));
endproperty
assert property(af_p43);

property af_p44;
@(posedge wb_clk_i) ((cfg_req_depth >= 4 && cfg_req_depth <= 12) && (!wb_stb_i)) |-> ##1 (cfg_req_depth >= 4 && cfg_req_depth <= 12);
endproperty
assert property(af_p44);

property af_p45;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (cfg_req_depth >= 1 && cfg_req_depth <= 32);
endproperty
assert property(af_p45);

property af_p46;
@(posedge wb_clk_i) $rose(sdram_resetn) |-> ##3 (cfg_req_depth >= 0 && cfg_req_depth <= 31);
endproperty
assert property(af_p46);

property af_p47;
@(posedge wb_clk_i) (wb_cti_i != 3'b000) |-> (cfg_req_depth == $past(cfg_req_depth));
endproperty
assert property(af_p47);

property af_p48;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (cfg_req_depth >= 0 && cfg_req_depth <= 15);
endproperty
assert property(af_p48);

property af_p49;
@(posedge wb_clk_i) (cfg_req_depth >= 16 && cfg_req_depth <= 31) |-> ##1 (cfg_req_depth >= 8 && cfg_req_depth <= 31) ##1 (cfg_req_depth >= 8 && cfg_req_depth <= 31);
endproperty
assert property(af_p49);

property af_p50;
@(posedge wb_clk_i) (cfg_req_depth >= 1 && cfg_req_depth <= 8) |-> ##1 (cfg_req_depth >= 1 && cfg_req_depth <= 8);
endproperty
assert property(af_p50);

property af_p51;
@(posedge sdram_clk) (sdr_cke) |-> $stable(cfg_sdr_cas);
endproperty
assert property(af_p51);

property af_p52;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##3 (cfg_sdr_cas >= 0) && (cfg_sdr_cas <= 7);
endproperty
assert property(af_p52);

property af_p53;
@(posedge sdram_clk) (cfg_sdr_cas >= 0) && (cfg_sdr_cas <= 7);
endproperty
assert property(af_p53);

property af_p54;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##4 (cfg_sdr_cas >= 1) && (cfg_sdr_cas <= 6);
endproperty
assert property(af_p54);

property af_p55;
@(posedge sdram_clk) $fell(sdram_resetn) |=> (cfg_sdr_cas inside {[0:7]}) [*5];
endproperty
assert property(af_p55);

property af_p56;
@(posedge sdram_clk) disable iff (!sdram_resetn) ($rose(sdram_resetn)) |-> ((cfg_sdr_cas inside {[2:3]}) throughout (!sdr_init_done)[->1]);
endproperty
assert property(af_p56);

property af_p57;
@(posedge sdram_clk) ($rose(cfg_sdr_en) && (cfg_sdr_cas >= 2) && (cfg_sdr_cas <= 4)) |-> (cfg_sdr_cas inside {[2:4]}) throughout (sdr_init_done[->1]);
endproperty
assert property(af_p57);

property af_p58;
@(posedge sdram_clk) (!sdr_init_done) |-> ($stable(cfg_sdr_cas) && (cfg_sdr_cas >= 0) && (cfg_sdr_cas <= 7));
endproperty
assert property(af_p58);

property af_p59;
@(posedge sdram_clk) ((cfg_sdr_cas >= 0) && (cfg_sdr_cas <= 7)) |-> (cfg_sdr_cas >= 0) && (cfg_sdr_cas <= 7);
endproperty
assert property(af_p59);

property af_p60;
@(posedge sdram_clk) (!sdr_init_done) |-> $stable(cfg_sdr_cas);
endproperty
assert property(af_p60);

property af_p61;
@(posedge sdram_clk) $rose(cfg_sdr_en) |=> (($stable(cfg_sdr_cas) && cfg_sdr_cas >= 1 && cfg_sdr_cas <= 7))[*4];
endproperty
assert property(af_p61);

property af_p62;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##3 (cfg_sdr_cas >= 1 && cfg_sdr_cas <= 5);
endproperty
assert property(af_p62);

property af_p63;
@(posedge sdram_clk) (!sdr_cas_n && (cfg_sdr_cas >= 2 && cfg_sdr_cas <= 4)) |=> (cfg_sdr_cas >= 2 && cfg_sdr_cas <= 4);
endproperty
assert property(af_p63);

property af_p64;
@(posedge sdram_clk) (sdram_resetn && (cfg_sdr_cas >= 4 && cfg_sdr_cas <= 7)) |=> (cfg_sdr_cas >= 4 && cfg_sdr_cas <= 7);
endproperty
assert property(af_p64);

property af_p65;
@(posedge sdram_clk) (!sdram_resetn) |-> (cfg_sdr_cas >= 0 && cfg_sdr_cas <= 7);
endproperty
assert property(af_p65);

property af_p66;
@(posedge sdram_clk) (cfg_sdr_cas >= 2 && cfg_sdr_cas <= 6) |=> (cfg_sdr_cas >= 2 && cfg_sdr_cas <= 6);
endproperty
assert property(af_p66);

property af_p67;
@(posedge sdram_clk) cfg_sdr_en |-> ($stable(cfg_sdr_cas) && (cfg_sdr_cas >= 0 && cfg_sdr_cas <= 7));
endproperty
assert property(af_p67);

property af_p68;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##4 ($stable(cfg_sdr_cas) && cfg_sdr_cas >= 0 && cfg_sdr_cas <= 7);
endproperty
assert property(af_p68);

property af_p69;
@(posedge sdram_clk) (cfg_sdr_en) |-> ($stable(cfg_sdr_cas) && (cfg_sdr_cas >= 0) && (cfg_sdr_cas <= 7));
endproperty
assert property(af_p69);

property af_p70;
@(posedge wb_clk_i) (cfg_sdr_en) |=> ($stable(cfg_sdr_cas));
endproperty
assert property(af_p70);

property af_p71;
@(posedge sdram_clk) (!cfg_sdr_en) |-> ((cfg_sdr_cas >= 0) && (cfg_sdr_cas <= 7));
endproperty
assert property(af_p71);

property af_p72;
@(posedge sdram_clk) ($rose(cfg_sdr_en)) |-> (cfg_sdr_cas == $past(cfg_sdr_cas)) until (sdr_init_done);
endproperty
assert property(af_p72);

property af_p73;
@(posedge sdram_clk) ((cfg_sdr_cas >= 2) && (cfg_sdr_cas <= 3)) |-> ((cfg_sdr_cas >= 2) && (cfg_sdr_cas <= 3))[*1:$];
endproperty
assert property(af_p73);

property af_p74;
@(posedge sdram_clk) ($fell(sdr_cas_n)) |-> ((cfg_sdr_cas >= 0) && (cfg_sdr_cas <= 7));
endproperty
assert property(af_p74);

property af_p75;
@(posedge sdram_clk) (!cfg_sdr_en) |-> ($stable(cfg_sdr_cas) && (cfg_sdr_cas >= 0) && (cfg_sdr_cas <= 7));
endproperty
assert property(af_p75);

property af_p76;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> ((cfg_sdr_cas >= 0) && (cfg_sdr_cas <= 7));
endproperty
assert property(af_p76);

property af_p77;
@(posedge sdram_clk) ((cfg_sdr_cas >= 2) && (cfg_sdr_cas <= 3)) |=> ((cfg_sdr_cas >= 2) && (cfg_sdr_cas <= 3));
endproperty
assert property(af_p77);

property af_p78;
@(posedge wb_clk_i) (!wb_rst_i) |-> ((cfg_sdr_cas >= 0) && (cfg_sdr_cas <= 7));
endproperty
assert property(af_p78);

property af_p79;
@(posedge wb_clk_i) disable iff (wb_rst_i) $stable(cfg_sdr_en);
endproperty
assert property(af_p79);

property af_p80;
@(posedge wb_clk_i) $rose(cfg_sdr_en) |-> (sdr_init_done == 0) ##1 (sdr_init_done == 0);
endproperty
assert property(af_p80);

property af_p81;
@(posedge wb_clk_i) (cfg_sdr_en == 0) |-> (wb_ack_o == 0);
endproperty
assert property(af_p81);

property af_p82;
@(posedge wb_clk_i) (cfg_sdr_en == 1 && wb_cyc_i) |-> ##1 (cfg_sdr_en == 1);
endproperty
assert property(af_p82);

property af_p83;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##3 (cfg_sdr_en inside {1'b0, 1'b1});
endproperty
assert property(af_p83);

property af_p84;
@(posedge wb_clk_i) (cfg_sdr_en == 0 && wb_stb_i && wb_cyc_i) |-> (wb_ack_o == 0);
endproperty
assert property(af_p84);

property af_p85;
@(posedge sdram_clk) (!sdram_resetn) |-> (cfg_sdr_en == 0);
endproperty
assert property(af_p85);

property af_p86;
@(posedge wb_clk_i) $rose(cfg_sdr_en) |-> ##2 (sdr_cs_n == 1'b0);
endproperty
assert property(af_p86);

property af_p87;
@(posedge wb_clk_i) (wb_rst_i) |-> (cfg_sdr_en == 0);
endproperty
assert property(af_p87);

property af_p88;
@(posedge sdram_clk) ($rose(cfg_sdr_en) && sdram_resetn) |-> ##1 $stable(cfg_sdr_en);
endproperty
assert property(af_p88);

property af_p89;
@(posedge sdram_clk) ((cfg_sdr_en >= 1'b0) && (cfg_sdr_en <= 1'b1));
endproperty
assert property(af_p89);

property af_p90;
@(posedge wb_clk_i) $rose(cfg_sdr_en) |-> (sdram_resetn || $past(sdram_resetn));
endproperty
assert property(af_p90);

property af_p91;
@(posedge wb_clk_i) 1'b1 |-> $stable(cfg_sdr_en);
endproperty
assert property(af_p91);

property af_p92;
@(posedge wb_clk_i) (!wb_rst_i) |-> ((cfg_sdr_en == 1'b0) || (cfg_sdr_en == 1'b1));
endproperty
assert property(af_p92);

property af_p93;
@(posedge wb_clk_i) (cfg_sdr_en == 1'b0) |-> (wb_ack_o == 1'b0);
endproperty
assert property(af_p93);

property af_p94;
@(posedge wb_clk_i) $rose(cfg_sdr_en) |-> cfg_sdr_en[*4];
endproperty
assert property(af_p94);

property af_p95;
@(posedge sdram_clk) (!cfg_sdr_en) |-> (sdr_cs_n == 1'b1);
endproperty
assert property(af_p95);

property af_p96;
@(posedge wb_clk_i) (wb_rst_i) |-> (cfg_sdr_en == 1'b0);
endproperty
assert property(af_p96);



property af_p99;
@(posedge sdram_clk) (cfg_sdr_en == 1'b0) |-> (sdr_cke == 1'b0);
endproperty
assert property(af_p99);

property af_p100;
@(posedge wb_clk_i) (cfg_sdr_en == 1'b0) |=> (sdr_init_done !== 1'b1);
endproperty
assert property(af_p100);

property af_p101;
@(posedge wb_clk_i) ($rose(cfg_sdr_en)) |-> (cfg_sdr_en throughout (##[0:3] cfg_sdr_en));
endproperty
assert property(af_p101);

property af_p102;
@(posedge sdram_clk) ($changed(cfg_sdr_en)) |-> (##[1:3] !$changed(cfg_sdr_en));
endproperty
assert property(af_p102);

property af_p103;
@(posedge sdram_clk) (cfg_sdr_en == 1'b0) |=> (sdr_init_done == 1'b0);
endproperty
assert property(af_p103);

property af_p104;
@(posedge sdram_clk) ($rose(sdr_init_done)) |-> (cfg_sdr_en == 1'b1);
endproperty
assert property(af_p104);

property af_p105;
@(posedge sdram_clk) ($rose(cfg_sdr_en)) |-> ##[1:8] (sdr_cke == 1'b1);
endproperty
assert property(af_p105);

property af_p106;
@(posedge wb_clk_i) (cfg_sdr_en === 1'b0 || cfg_sdr_en === 1'b1);
endproperty
assert property(af_p106);

property af_p107;
@(posedge wb_clk_i) disable iff (wb_rst_i) ($past(wb_rst_i, 3) && !wb_rst_i) |-> ($stable(cfg_sdr_en));
endproperty
assert property(af_p107);

property af_p108;
@(posedge sdram_clk) (cfg_sdr_en) |-> $stable(cfg_sdr_mode_reg);
endproperty
assert property(af_p108);

property af_p109;
@(posedge sdram_clk) $fell(sdram_resetn) |-> ($stable(cfg_sdr_mode_reg)[*2]);
endproperty
assert property(af_p109);

property af_p110;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##4 ((cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 4095));
endproperty
assert property(af_p110);

property af_p111;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 4095));
endproperty
assert property(af_p111);

property af_p112;
@(posedge wb_clk_i) (!cfg_sdr_en) |-> ($stable(cfg_sdr_mode_reg) && (cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 4095));
endproperty
assert property(af_p112);

property af_p113;
@(posedge wb_clk_i) (!wb_rst_i) |-> ((cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 4095));
endproperty
assert property(af_p113);

property af_p114;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ($stable(cfg_sdr_mode_reg) throughout (!sdr_init_done)[*1:$] ##1 sdr_init_done);
endproperty
assert property(af_p114);

property af_p115;
@(posedge sdram_clk) (!sdr_ras_n && !sdr_cas_n && !sdr_we_n) |-> (sdr_addr == cfg_sdr_mode_reg);
endproperty
assert property(af_p115);

property af_p116;
@(posedge sdram_clk) ((cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 1023)) |=> ((cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 2047));
endproperty
assert property(af_p116);

property af_p117;
@(posedge wb_clk_i) (cfg_sdr_en && sdr_init_done) |=> $stable(cfg_sdr_mode_reg);
endproperty
assert property(af_p117);

property af_p118;
@(posedge sdram_clk) (!sdram_resetn) |-> ((cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 4095));
endproperty
assert property(af_p118);

property af_p119;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ((cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 4095)) until (sdr_init_done);
endproperty
assert property(af_p119);

property af_p120;
@(posedge wb_clk_i) (!wb_rst_i) |-> (((cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 4095)) && $stable(cfg_sdr_mode_reg));
endproperty
assert property(af_p120);

property af_p121;
@(posedge wb_clk_i) ((cfg_sdr_mode_reg >= 512) && (cfg_sdr_mode_reg <= 1023)) |=> ((cfg_sdr_mode_reg >= 256) && (cfg_sdr_mode_reg <= 1023));
endproperty
assert property(af_p121);

property af_p122;
@(posedge sdram_clk) ($fell(sdram_resetn)) |-> ##3 ((cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 4095));
endproperty
assert property(af_p122);

property af_p123;
@(posedge sdram_clk) (cfg_sdr_en) |-> ((cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 4095));
endproperty
assert property(af_p123);

property af_p124;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 ((cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 4095));
endproperty
assert property(af_p124);

property af_p125;
@(posedge wb_clk_i) ((cfg_sdr_mode_reg >= 2048) && (cfg_sdr_mode_reg <= 4095)) |=> ((cfg_sdr_mode_reg >= 2048) && (cfg_sdr_mode_reg <= 4095));
endproperty
assert property(af_p125);

property af_p126;
@(posedge sdram_clk) ((cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 2047)) |=> (cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 2047);
endproperty
assert property(af_p126);

property af_p127;
@(posedge sdram_clk) sdr_init_done |-> $stable(cfg_sdr_mode_reg);
endproperty
assert property(af_p127);

property af_p128;
@(posedge wb_clk_i) ((cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 4095)) |=> (cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 4095);
endproperty
assert property(af_p128);

property af_p129;
@(posedge wb_clk_i) (($past(cfg_sdr_mode_reg) < 2048) && (cfg_sdr_mode_reg >= 2048)) |-> !cfg_sdr_en;
endproperty
assert property(af_p129);

property af_p130;
@(posedge wb_clk_i) ((cfg_sdr_mode_reg >= 512) && (cfg_sdr_mode_reg <= 1023)) |=> (cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 4095);
endproperty
assert property(af_p130);

property af_p131;
@(posedge sdram_clk) (!sdr_cs_n) |-> $stable(cfg_sdr_mode_reg);
endproperty
assert property(af_p131);

property af_p132;
@(posedge wb_clk_i) (!cfg_sdr_en) |-> $stable(cfg_sdr_mode_reg);
endproperty
assert property(af_p132);

property af_p133;
@(posedge wb_clk_i) (cfg_sdr_en && (cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 4095)) |-> ((cfg_sdr_mode_reg >= 0) && (cfg_sdr_mode_reg <= 4095)) until (sdr_init_done);
endproperty
assert property(af_p133);

property af_p134;
@(posedge sdram_clk) cfg_sdr_en |=> $stable(cfg_sdr_rfmax);
endproperty
assert property(af_p134);

property af_p135;
@(posedge wb_clk_i) (1'b1) |-> ((cfg_sdr_rfmax >= 0 && cfg_sdr_rfmax <= 7) && $stable(cfg_sdr_rfsh));
endproperty
assert property(af_p135);

property af_p136;
@(posedge wb_clk_i) disable iff (wb_rst_i) (cfg_sdr_rfmax >= 0 && cfg_sdr_rfmax <= 7) |=> ($stable(cfg_sdr_rfmax) && (cfg_sdr_rfmax >= 0 && cfg_sdr_rfmax <= 7));
endproperty
assert property(af_p136);

property af_p137;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 (cfg_sdr_rfmax >= 2 && cfg_sdr_rfmax <= 6);
endproperty
assert property(af_p137);

property af_p138;
@(posedge wb_clk_i) (cfg_sdr_rfmax >= 0 && cfg_sdr_rfmax <= 7) |=> (cfg_sdr_rfmax >= 0 && cfg_sdr_rfmax <= 7);
endproperty
assert property(af_p138);

property af_p139;
@(posedge wb_clk_i) cfg_sdr_en |=> $stable(cfg_sdr_rfmax);
endproperty
assert property(af_p139);

property af_p140;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |=> $stable(cfg_sdr_rfmax);
endproperty
assert property(af_p140);

property af_p141;
@(posedge wb_clk_i) ((cfg_sdr_rfmax >= 1 && cfg_sdr_rfmax <= 3) && cfg_sdr_en) |=> (cfg_sdr_en throughout (cfg_sdr_rfmax >= 0 && cfg_sdr_rfmax <= 3));
endproperty
assert property(af_p141);

property af_p142;
@(posedge sdram_clk) $rose(!sdram_resetn) |-> ##3 (cfg_sdr_rfmax >= 0 && cfg_sdr_rfmax <= 7);
endproperty
assert property(af_p142);

property af_p143;
@(posedge sdram_clk) $rose(!sdram_resetn) |=> (cfg_sdr_rfmax === $past(cfg_sdr_rfmax));
endproperty
assert property(af_p143);

property af_p144;
@(posedge sdram_clk) (sdr_init_done) |-> $stable(cfg_sdr_rfmax);
endproperty
assert property(af_p144);

property af_p145;
@(posedge wb_clk_i) (!wb_rst_i) |-> (cfg_sdr_rfmax >= 0) && (cfg_sdr_rfmax <= 7);
endproperty
assert property(af_p145);

property af_p146;
@(posedge wb_clk_i) ($rose(wb_rst_i) || $fell(wb_rst_i)) |-> (cfg_sdr_rfmax >= 0) && (cfg_sdr_rfmax <= 7);
endproperty
assert property(af_p146);

property af_p147;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((cfg_sdr_rfmax >= 0) && (cfg_sdr_rfmax <= 7));
endproperty
assert property(af_p147);

property af_p148;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##4 ($stable(cfg_sdr_rfmax) && (cfg_sdr_rfmax >= 0) && (cfg_sdr_rfmax <= 7));
endproperty
assert property(af_p148);

property af_p149;
@(posedge sdram_clk) (sdram_resetn) |-> (cfg_sdr_rfmax >= 0) && (cfg_sdr_rfmax <= 7);
endproperty
assert property(af_p149);

property af_p150;
@(posedge wb_clk_i) (cfg_sdr_en && (cfg_sdr_rfmax >= 4) && (cfg_sdr_rfmax <= 7)) |-> ##1 (cfg_sdr_rfmax >= 4) && (cfg_sdr_rfmax <= 7);
endproperty
assert property(af_p150);

property af_p151;
@(posedge sdram_clk) (cfg_sdr_rfmax >= 0) && (cfg_sdr_rfmax <= 7);
endproperty
assert property(af_p151);

property af_p152;
@(posedge sdram_clk) (sdr_init_done) |-> (cfg_sdr_rfmax >= 0) && (cfg_sdr_rfmax <= 7);
endproperty
assert property(af_p152);

property af_p153;
@(posedge wb_clk_i) $rose(cfg_sdr_en) |-> ##1 ($stable(cfg_sdr_rfmax) && (cfg_sdr_rfmax >= 0) && (cfg_sdr_rfmax <= 7));
endproperty
assert property(af_p153);

property af_p154;
@(posedge sdram_clk) (!sdram_resetn) |-> $stable(cfg_sdr_rfmax);
endproperty
assert property(af_p154);

property af_p155;
@(posedge sdram_clk) ((cfg_sdr_rfmax >= 0) && (cfg_sdr_rfmax <= 7)) |=> ((cfg_sdr_rfmax >= 0) && (cfg_sdr_rfmax <= 7));
endproperty
assert property(af_p155);

property af_p156;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((cfg_sdr_rfmax >= 0) && (cfg_sdr_rfmax <= 7));
endproperty
assert property(af_p156);

property af_p157;
@(posedge sdram_clk) (cfg_sdr_rfsh != 0) |-> $stable(cfg_sdr_rfmax);
endproperty
assert property(af_p157);

property af_p158;
@(posedge sdram_clk) ((cfg_sdr_rfmax >= 1) && (cfg_sdr_rfmax <= 6)) |=> ((cfg_sdr_rfmax >= 0) && (cfg_sdr_rfmax <= 7));
endproperty
assert property(af_p158);

property af_p159;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##[1:4] (cfg_sdr_rfmax != 0);
endproperty
assert property(af_p159);

property af_p160;
@(posedge sdram_clk) (!sdr_cas_n && !sdr_ras_n) |-> $stable(cfg_sdr_rfmax);
endproperty
assert property(af_p160);

property af_p161;
@(posedge wb_clk_i) ((cfg_sdr_rfmax >= 1) && (cfg_sdr_rfmax <= 6)) |=> ((cfg_sdr_rfmax >= 0) && (cfg_sdr_rfmax <= 7));
endproperty
assert property(af_p161);

property af_p162;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 ((cfg_sdr_rfmax >= 0) && (cfg_sdr_rfmax <= 7))[*4];
endproperty
assert property(af_p162);

property af_p163;
@(posedge wb_clk_i) (sdr_init_done) |-> $stable(cfg_sdr_rfmax);
endproperty
assert property(af_p163);

property af_p164;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((cfg_sdr_rfsh >= 100) && (cfg_sdr_rfsh <= 4095));
endproperty
assert property(af_p164);

property af_p165;
@(posedge wb_clk_i) (wb_we_i && wb_stb_i) |=> ((cfg_sdr_rfsh >= 0) && (cfg_sdr_rfsh <= 4095));
endproperty
assert property(af_p165);

property af_p166;
@(posedge wb_clk_i) (wb_rst_i) |-> ((cfg_sdr_rfsh >= 0) && (cfg_sdr_rfsh <= 4095));
endproperty
assert property(af_p166);

property af_p167;
@(posedge wb_clk_i) (cfg_sdr_en) |-> (cfg_sdr_rfsh > 0);
endproperty
assert property(af_p167);

property af_p168;
@(posedge sdram_clk) ((cfg_sdr_rfsh >= 0) && (cfg_sdr_rfsh <= 4095) && sdram_resetn) |=> ((cfg_sdr_rfsh >= 0) && (cfg_sdr_rfsh <= 4095));
endproperty
assert property(af_p168);

property af_p169;
@(posedge wb_clk_i) ((cfg_sdr_rfsh >= 2048) && (cfg_sdr_rfsh <= 4095)) |=> ((cfg_sdr_rfsh >= 2048) && (cfg_sdr_rfsh <= 4095));
endproperty
assert property(af_p169);

property af_p170;
@(posedge sdram_clk) ((cfg_sdr_rfsh >= 1000) && (cfg_sdr_rfsh <= 2000)) |=> ((cfg_sdr_rfsh >= 900) && (cfg_sdr_rfsh <= 2100));
endproperty
assert property(af_p170);

property af_p171;
@(posedge wb_clk_i) 1 |-> ((cfg_sdr_rfsh >= 1) && (cfg_sdr_rfsh <= 4095));
endproperty
assert property(af_p171);

property af_p172;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##2 ((cfg_sdr_rfsh >= 0) && (cfg_sdr_rfsh <= 4095));
endproperty
assert property(af_p172);

property af_p173;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((cfg_sdr_rfsh >= 0) && (cfg_sdr_rfsh <= 4095));
endproperty
assert property(af_p173);

property af_p174;
@(posedge wb_clk_i) (sdr_init_done) |-> $stable(cfg_sdr_rfsh);
endproperty
assert property(af_p174);

property af_p175;
@(posedge wb_clk_i) (!wb_we_i) |-> $stable(cfg_sdr_rfsh);
endproperty
assert property(af_p175);

property af_p176;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> $stable(cfg_sdr_rfsh);
endproperty
assert property(af_p176);

property af_p177;
@(posedge wb_clk_i) ((cfg_sdr_rfsh >= 1500) && (cfg_sdr_rfsh <= 2000)) |=> ((cfg_sdr_rfsh >= 1000) && (cfg_sdr_rfsh <= 2000));
endproperty
assert property(af_p177);

property af_p178;
@(posedge wb_clk_i) (wb_cyc_i) |-> $stable(cfg_sdr_rfsh);
endproperty
assert property(af_p178);

property af_p179;
@(posedge sdram_clk) (cfg_sdr_en) |-> $stable(cfg_sdr_rfsh);
endproperty
assert property(af_p179);


property af_p181;
@(posedge sdram_clk) (cfg_sdr_en && $changed(cfg_sdr_rfsh)) |=> $stable(cfg_sdr_rfsh)[*5];
endproperty
assert property(af_p181);

property af_p182;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##4 (cfg_sdr_rfsh >= 500 && cfg_sdr_rfsh <= 1500);
endproperty
assert property(af_p182);

property af_p183;
@(posedge wb_clk_i) (!wb_rst_i) |-> ((cfg_sdr_rfsh >= 0) && (cfg_sdr_rfsh <= 4095));
endproperty
assert property(af_p183);

property af_p184;
@(posedge wb_clk_i) $rose(wb_ack_o) |=> (cfg_sdr_rfsh == $past(wb_dat_i));
endproperty
assert property(af_p184);

property af_p185;
@(posedge sdram_clk) (sdr_init_done) |-> (cfg_sdr_rfsh > 0) && (cfg_sdr_rfsh <= 4095);
endproperty
assert property(af_p185);

property af_p186;
@(posedge wb_clk_i) ((cfg_sdr_rfsh >= 500) && (cfg_sdr_rfsh <= 900)) |-> ((cfg_sdr_rfsh >= 400) && (cfg_sdr_rfsh <= 1000))[*5];
endproperty
assert property(af_p186);

property af_p187;
@(posedge wb_clk_i) $rose(wb_rst_i == 0) |-> ##3 ((cfg_sdr_rfsh >= 750) && (cfg_sdr_rfsh <= 1500));
endproperty
assert property(af_p187);

property af_p188;
@(posedge wb_clk_i) ((cfg_sdr_rfsh >= 1024) && (cfg_sdr_rfsh <= 2047)) |=> ((cfg_sdr_rfsh >= 512) && (cfg_sdr_rfsh <= 2047));
endproperty
assert property(af_p188);

property af_p189;
@(posedge wb_clk_i) ((cfg_sdr_rfsh >= 3000) && (cfg_sdr_rfsh <= 4095)) |=> (cfg_sdr_rfsh >= 2500) && (cfg_sdr_rfsh <= 4095);
endproperty
assert property(af_p189);

property af_p190;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##[1:3] ((cfg_sdr_rfsh >= 0) && (cfg_sdr_rfsh <= 4095))[*3];
endproperty
assert property(af_p190);

property af_p191;
@(posedge wb_clk_i) (!cfg_sdr_en) |-> $stable(cfg_sdr_rfsh);
endproperty
assert property(af_p191);

property af_p192;
@(posedge sdram_clk) (sdr_cke) |-> ($stable(cfg_sdr_tras_d));
endproperty
assert property(af_p192);

property af_p193;
@(posedge wb_clk_i) disable iff (wb_rst_i) (cfg_sdr_tras_d >= 0) && (cfg_sdr_tras_d <= 15);
endproperty
assert property(af_p193);

property af_p194;
@(posedge wb_clk_i) (wb_we_i && wb_ack_o) |-> ($stable(cfg_sdr_tras_d));
endproperty
assert property(af_p194);

property af_p195;
@(posedge wb_clk_i) (!sdr_init_done) |-> ($stable(cfg_sdr_tras_d));
endproperty
assert property(af_p195);

property af_p196;
@(posedge wb_clk_i) (cfg_sdr_en) |-> ($stable(cfg_sdr_tras_d) && (cfg_sdr_tras_d >= 0) && (cfg_sdr_tras_d <= 15));
endproperty
assert property(af_p196);

property af_p197;
@(posedge wb_clk_i) (cfg_sdr_en && !sdr_init_done) |-> ($stable(cfg_sdr_tras_d));
endproperty
assert property(af_p197);

property af_p198;
@(posedge wb_clk_i) ($rose(!wb_rst_i)) |-> ##4 ((cfg_sdr_tras_d >= 0) && (cfg_sdr_tras_d <= 15) && $stable(cfg_sdr_tras_d));
endproperty
assert property(af_p198);

property af_p199;
@(posedge wb_clk_i) (cfg_sdr_en) |-> (cfg_sdr_tras_d >= (cfg_sdr_trcd_d - cfg_sdr_cas));
endproperty
assert property(af_p199);

property af_p200;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 ((cfg_sdr_tras_d >= 1) && (cfg_sdr_tras_d <= 15));
endproperty
assert property(af_p200);

property af_p201;
@(posedge sdram_clk) $fell(sdram_resetn) |=> ((cfg_sdr_tras_d >= 0) && (cfg_sdr_tras_d <= 15));
endproperty
assert property(af_p201);

property af_p202;
@(posedge wb_clk_i) (((cfg_sdr_tras_d >= 4) && (cfg_sdr_tras_d <= 15)) && cfg_sdr_en) |=> (cfg_sdr_en |-> ((cfg_sdr_tras_d >= 4) && (cfg_sdr_tras_d <= 15)));
endproperty
assert property(af_p202);

property af_p203;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> ((cfg_sdr_tras_d >= 2) && (cfg_sdr_tras_d <= 15));
endproperty
assert property(af_p203);

property af_p204;
@(posedge wb_clk_i) ((($past(cfg_sdr_tras_d) >= 0) && ($past(cfg_sdr_tras_d) <= 7)) && ((cfg_sdr_tras_d >= 8) && (cfg_sdr_tras_d <= 15))) |-> !cfg_sdr_en;
endproperty
assert property(af_p204);

property af_p205;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] ((cfg_sdr_tras_d >= 0) && (cfg_sdr_tras_d <= 15));
endproperty
assert property(af_p205);

property af_p206;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> ((cfg_sdr_tras_d >= 0) && (cfg_sdr_tras_d <= 15));
endproperty
assert property(af_p206);

property af_p207;
@(posedge wb_clk_i) disable iff (wb_rst_i) cfg_sdr_en |-> (cfg_sdr_tras_d inside {[0:15]}) until_with (wb_rst_i);
endproperty
assert property(af_p207);

property af_p208;
@(posedge wb_clk_i) (!sdr_ras_n && !sdr_cas_n) |-> $stable(cfg_sdr_tras_d);
endproperty
assert property(af_p208);

property af_p209;
@(posedge sdram_clk) (sdram_resetn) |-> (cfg_sdr_tras_d inside {[0:15]});
endproperty
assert property(af_p209);

property af_p210;
@(posedge wb_clk_i) (cfg_sdr_tras_d inside {[6:15]}) |-> ##1 (cfg_sdr_tras_d inside {[4:15]})[*3];
endproperty
assert property(af_p210);

property af_p211;
@(posedge wb_clk_i) (!sdr_cs_n) |-> $stable(cfg_sdr_tras_d);
endproperty
assert property(af_p211);

property af_p212;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> (cfg_sdr_tras_d inside {[0:15]})[*4];
endproperty
assert property(af_p212);

property af_p213;
@(posedge wb_clk_i) (cfg_sdr_tras_d inside {[4:8]} && cfg_sdr_en) |-> ##1 (cfg_sdr_tras_d inside {[4:8]});
endproperty
assert property(af_p213);

property af_p214;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##3 (cfg_sdr_trcar_d >= 3) && (cfg_sdr_trcar_d <= 15);
endproperty
assert property(af_p214);

property af_p215;
@(posedge sdram_clk) (cfg_sdr_en) |-> (cfg_sdr_trcar_d == $past(cfg_sdr_trcar_d));
endproperty
assert property(af_p215);

property af_p216;
@(posedge wb_clk_i) ((cfg_sdr_trcar_d >= 8) && (cfg_sdr_trcar_d <= 15)) |-> ##1 (cfg_sdr_trcar_d >= 8) && (cfg_sdr_trcar_d <= 15);
endproperty
assert property(af_p216);

property af_p217;
@(posedge wb_clk_i) ((cfg_sdr_trcar_d >= 6) && (cfg_sdr_trcar_d <= 9)) |-> ##[1:2] ((cfg_sdr_trcar_d >= 6) && (cfg_sdr_trcar_d <= 9));
endproperty
assert property(af_p217);

property af_p218;
@(posedge sdram_clk) (!sdr_init_done) |-> (cfg_sdr_trcar_d == $past(cfg_sdr_trcar_d));
endproperty
assert property(af_p218);

property af_p219;
@(posedge sdram_clk) ((cfg_sdr_trcar_d >= 6) && (cfg_sdr_trcar_d <= 10)) |-> ##1 ((cfg_sdr_trcar_d >= 4) && (cfg_sdr_trcar_d <= 12));
endproperty
assert property(af_p219);

property af_p220;
@(posedge sdram_clk) (cfg_sdr_en) |-> (cfg_sdr_trcar_d >= cfg_sdr_trp_d);
endproperty
assert property(af_p220);

property af_p221;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (cfg_sdr_trcar_d == $past(cfg_sdr_trcar_d,1)) && (cfg_sdr_trcar_d == $past(cfg_sdr_trcar_d,2));
endproperty
assert property(af_p221);

property af_p222;
@(posedge wb_clk_i) $rose(sdr_init_done) |-> (cfg_sdr_trcar_d === $past(cfg_sdr_trcar_d)) throughout (sdr_init_done[*1:$]);
endproperty
assert property(af_p222);

property af_p223;
@(posedge sdram_clk) (!sdram_resetn) |-> (cfg_sdr_trcar_d >= 0) && (cfg_sdr_trcar_d <= 15);
endproperty
assert property(af_p223);

property af_p224;
@(posedge wb_clk_i) $rose(sdram_resetn) |-> ##4 ((cfg_sdr_trcar_d >= 0) && (cfg_sdr_trcar_d <= 15));
endproperty
assert property(af_p224);

property af_p225;
@(posedge sdram_clk) ((cfg_sdr_trcar_d >= 0) && (cfg_sdr_trcar_d <= 15)) && $stable(cfg_sdr_trcar_d);
endproperty
assert property(af_p225);

property af_p226;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##3 ((cfg_sdr_trcar_d >= 4) && (cfg_sdr_trcar_d <= 12));
endproperty
assert property(af_p226);

property af_p227;
@(posedge sdram_clk) ((cfg_sdr_trcar_d >= 4) && (cfg_sdr_trcar_d <= 7)) |=> ((cfg_sdr_trcar_d >= 2) && (cfg_sdr_trcar_d <= 10));
endproperty
assert property(af_p227);

property af_p228;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> ((cfg_sdr_trcar_d >= 5) && (cfg_sdr_trcar_d <= 15))[*5];
endproperty
assert property(af_p228);

property af_p229;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##3 ((cfg_sdr_trcar_d >= 1) && (cfg_sdr_trcar_d <= 15));
endproperty
assert property(af_p229);

property af_p230;
@(posedge sdram_clk) (!sdr_init_done) |-> $stable(cfg_sdr_trcar_d);
endproperty
assert property(af_p230);

property af_p231;
@(posedge wb_clk_i) (!wb_rst_i) |-> (cfg_sdr_trcar_d >= 0) && (cfg_sdr_trcar_d <= 15);
endproperty
assert property(af_p231);

property af_p232;
@(posedge sdram_clk) $rose(cfg_sdr_en) |=> $stable(cfg_sdr_trcar_d);
endproperty
assert property(af_p232);

property af_p233;
@(posedge sdram_clk) ((cfg_sdr_trcar_d >= 8) && (cfg_sdr_trcar_d <= 15)) |=> ((cfg_sdr_trcar_d >= 4) && (cfg_sdr_trcar_d <= 15));
endproperty
assert property(af_p233);

property af_p234;
@(posedge wb_clk_i) ((cfg_sdr_trcar_d >= 4) && (cfg_sdr_trcar_d <= 10)) |=> ((cfg_sdr_trcar_d >= 2) && (cfg_sdr_trcar_d <= 12));
endproperty
assert property(af_p234);

property af_p235;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:4] (cfg_sdr_trcar_d != 0);
endproperty
assert property(af_p235);

property af_p236;
@(posedge wb_clk_i) (wb_cyc_i) |-> $stable(cfg_sdr_trcar_d);
endproperty
assert property(af_p236);

property af_p237;
@(posedge sdram_clk) ($rose(sdram_resetn)) |-> ##4 ((cfg_sdr_trcar_d >= 0) && (cfg_sdr_trcar_d <= 15));
endproperty
assert property(af_p237);

property af_p238;
@(posedge sdram_clk) (cfg_sdr_en) |-> ($stable(cfg_sdr_trcar_d) && (cfg_sdr_trcar_d >= 0) && (cfg_sdr_trcar_d <= 15));
endproperty
assert property(af_p238);

property af_p239;
@(posedge sdram_clk) ($rose(cfg_sdr_en)) |-> ##[1:5] $stable(cfg_sdr_trcar_d);
endproperty
assert property(af_p239);

property af_p240;
@(posedge wb_clk_i) (cfg_sdr_en) |-> ($stable(cfg_sdr_trcar_d) && (cfg_sdr_trcar_d >= 0) && (cfg_sdr_trcar_d <= 15));
endproperty
assert property(af_p240);

property af_p241;
@(posedge sdram_clk) (!sdr_cs_n) |-> $stable(cfg_sdr_trcar_d);
endproperty
assert property(af_p241);

property af_p242;
@(posedge sdram_clk) ((cfg_sdr_trcar_d >= 8) && (cfg_sdr_trcar_d <= 15)) |=> ((cfg_sdr_trcar_d >= 8) && (cfg_sdr_trcar_d <= 15));
endproperty
assert property(af_p242);

property af_p243;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> $stable(cfg_sdr_trcar_d);
endproperty
assert property(af_p243);

property af_p244;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##4 ((cfg_sdr_trcd_d >= 0) && (cfg_sdr_trcd_d <= 15));
endproperty
assert property(af_p244);

property af_p245;
@(posedge sdram_clk) (cfg_sdr_en) |-> ($stable(cfg_sdr_trcd_d) && (cfg_sdr_trcd_d >= 0) && (cfg_sdr_trcd_d <= 15));
endproperty
assert property(af_p245);

property af_p246;
@(posedge sdram_clk) (!sdram_resetn) |-> ((sdr_cas_n == 1'b1) && (sdr_ras_n == 1'b1));
endproperty
assert property(af_p246);

property af_p247;
@(posedge sdram_clk) ((cfg_sdr_trcd_d >= 1) && (cfg_sdr_trcd_d <= 7)) |=> ((cfg_sdr_trcd_d >= 0) && (cfg_sdr_trcd_d <= 15));
endproperty
assert property(af_p247);

property af_p248;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##3 ((cfg_sdr_trcd_d >= 0) && (cfg_sdr_trcd_d <= 15));
endproperty
assert property(af_p248);

property af_p249;
@(posedge sdram_clk) (!sdram_resetn) |-> ((cfg_sdr_trcd_d >= 0) && (cfg_sdr_trcd_d <= 15));
endproperty
assert property(af_p249);

property af_p250;
@(posedge sdram_clk) ((cfg_sdr_trcd_d >= 8) && (cfg_sdr_trcd_d <= 15)) |=> ((cfg_sdr_trcd_d >= 4) && (cfg_sdr_trcd_d <= 15));
endproperty
assert property(af_p250);

property af_p251;
@(posedge sdram_clk) (wb_stb_i && wb_cyc_i) |-> $stable(cfg_sdr_trcd_d);
endproperty
assert property(af_p251);

property af_p252;
@(posedge sdram_clk) (cfg_sdr_en && !sdram_resetn) |-> ((cfg_sdr_trcd_d >= 0) && (cfg_sdr_trcd_d <= 15));
endproperty
assert property(af_p252);

property af_p253;
@(posedge sdram_clk) (((cfg_sdr_trcd_d >= 2) && (cfg_sdr_trcd_d <= 6)) && sdr_init_done) |=> ((cfg_sdr_trcd_d >= 2) && (cfg_sdr_trcd_d <= 6));
endproperty
assert property(af_p253);

property af_p254;
@(posedge sdram_clk) (!sdr_init_done) |-> $stable(cfg_sdr_trcd_d);
endproperty
assert property(af_p254);

property af_p255;
@(posedge sdram_clk) ((cfg_sdr_trcd_d >= 4) && (cfg_sdr_trcd_d <= 8)) |=> ((cfg_sdr_trcd_d >= 2) && (cfg_sdr_trcd_d <= 10));
endproperty
assert property(af_p255);

property af_p256;
@(posedge sdram_clk) ((cfg_sdr_trcd_d >= 0) && (cfg_sdr_trcd_d <= 15)) |=> ((cfg_sdr_trcd_d >= 0) && (cfg_sdr_trcd_d <= 15));
endproperty
assert property(af_p256);


property af_p258;
@(posedge sdram_clk) $rose(cfg_sdr_en) |-> ((cfg_sdr_trcd_d >= 0) && (cfg_sdr_trcd_d <= 15)) [*2];
endproperty
assert property(af_p258);

property af_p259;
@(posedge sdram_clk) (sdr_cke) |-> ((cfg_sdr_trcd_d >= 2) && (cfg_sdr_trcd_d <= 15));
endproperty
assert property(af_p259);

property af_p260;
@(posedge sdram_clk) ($fell(sdram_resetn)) |-> ((cfg_sdr_trcd_d >= 0) && (cfg_sdr_trcd_d <= 15));
endproperty
assert property(af_p260);

property af_p261;
@(posedge sdram_clk) (!cfg_sdr_en) |-> ((cfg_sdr_trcd_d >= 0) && (cfg_sdr_trcd_d <= 15) && $stable(sdr_init_done));
endproperty
assert property(af_p261);

property af_p262;
@(posedge sdram_clk) $fell(sdr_ras_n) |-> $stable(cfg_sdr_trcd_d) throughout (##[1:$] $fell(sdr_cas_n));
endproperty
assert property(af_p262);

property af_p263;
@(posedge sdram_clk) $fell(sdram_resetn) |-> ##3 ((cfg_sdr_trcd_d >= 0) && (cfg_sdr_trcd_d <= 15));
endproperty
assert property(af_p263);

property af_p264;
@(posedge sdram_clk) $fell(sdram_resetn) |-> ($stable(cfg_sdr_trcd_d) && (cfg_sdr_trcd_d >= 0) && (cfg_sdr_trcd_d <= 15))[*3];
endproperty
assert property(af_p264);

property af_p265;
@(posedge sdram_clk) $fell(wb_rst_i) |-> ##[0:$] ((cfg_sdr_trcd_d >= 0) && (cfg_sdr_trcd_d <= 15));
endproperty
assert property(af_p265);

property af_p266;
@(posedge sdram_clk) (cfg_sdr_en) |-> $stable(cfg_sdr_trcd_d);
endproperty
assert property(af_p266);

property af_p267;
@(posedge sdram_clk) $rose(cfg_sdr_en) |-> (cfg_sdr_trcd_d == $past(cfg_sdr_trcd_d));
endproperty
assert property(af_p267);

property af_p268;
@(posedge sdram_clk) 1 |-> ((cfg_sdr_trcd_d >= 0) && (cfg_sdr_trcd_d <= 15));
endproperty
assert property(af_p268);

property af_p269;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 $stable(cfg_sdr_trp_d);
endproperty
assert property(af_p269);

property af_p270;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> $stable(cfg_sdr_trp_d);
endproperty
assert property(af_p270);

property af_p271;
@(posedge wb_clk_i) (cfg_sdr_en) |-> $stable(cfg_sdr_trp_d);
endproperty
assert property(af_p271);

property af_p272;
@(posedge wb_clk_i) (!sdr_ras_n && !sdr_we_n) |-> $stable(cfg_sdr_trp_d);
endproperty
assert property(af_p272);

property af_p273;
@(posedge wb_clk_i) (cfg_sdr_en) |-> ($stable(cfg_sdr_trp_d) && (cfg_sdr_trp_d >= 0) && (cfg_sdr_trp_d <= 15));
endproperty
assert property(af_p273);

property af_p274;
@(posedge wb_clk_i) (!sdr_init_done) |-> $stable(cfg_sdr_trp_d);
endproperty
assert property(af_p274);

property af_p275;
@(posedge wb_clk_i) (!cfg_sdr_en) |-> $stable(cfg_sdr_trp_d);
endproperty
assert property(af_p275);

property af_p276;
@(posedge wb_clk_i) ($fell(wb_rst_i) && (cfg_sdr_trp_d >= 4) && (cfg_sdr_trp_d <= 10)) |-> ((cfg_sdr_trp_d >= 4) && (cfg_sdr_trp_d <= 10)) throughout (!sdr_init_done)[*1:$];
endproperty
assert property(af_p276);

property af_p277;
@(posedge wb_clk_i) (!sdr_cas_n || !sdr_ras_n) |-> $stable(cfg_sdr_trp_d);
endproperty
assert property(af_p277);

property af_p278;
@(posedge wb_clk_i) $rose(cfg_sdr_en) |-> ($stable(cfg_sdr_trp_d) && (cfg_sdr_trp_d >= 1) && (cfg_sdr_trp_d <= 15));
endproperty
assert property(af_p278);

property af_p279;
@(posedge wb_clk_i) (cfg_sdr_trp_d >= 0) && (cfg_sdr_trp_d <= 15);
endproperty
assert property(af_p279);

property af_p280;
@(posedge wb_clk_i) ((cfg_sdr_trp_d >= 2) && (cfg_sdr_trp_d <= 8)) |=> ((cfg_sdr_trp_d >= 2) && (cfg_sdr_trp_d <= 8));
endproperty
assert property(af_p280);

property af_p281;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((cfg_sdr_trp_d >= 1) && (cfg_sdr_trp_d <= 15));
endproperty
assert property(af_p281);

property af_p282;
@(posedge wb_clk_i) ((cfg_sdr_trp_d >= 4) && (cfg_sdr_trp_d <= 10)) |=> ((cfg_sdr_trp_d >= 3) && (cfg_sdr_trp_d <= 11));
endproperty
assert property(af_p282);

property af_p283;
@(posedge wb_clk_i) (wb_cyc_i) |-> $stable(cfg_sdr_trp_d);
endproperty
assert property(af_p283);

property af_p284;
@(posedge wb_clk_i) (!wb_rst_i) |-> ((cfg_sdr_trp_d >= 0) && (cfg_sdr_trp_d <= 15));
endproperty
assert property(af_p284);

property af_p285;
@(posedge wb_clk_i) (cfg_sdr_en) |-> ((cfg_sdr_trp_d >= 0) && (cfg_sdr_trp_d <= 15));
endproperty
assert property(af_p285);



property af_p288;
@(posedge wb_clk_i) ($changed(cfg_sdr_trp_d) && cfg_sdr_en) |=> ##[1:$] ($fell(sdr_cas_n) && $fell(sdr_we_n)) |-> (cfg_sdr_trp_d == $past(cfg_sdr_trp_d));
endproperty
assert property(af_p288);

property af_p289;
@(posedge wb_clk_i) (((cfg_sdr_trp_d >= 2) && (cfg_sdr_trp_d <= 8)) && $stable(cfg_sdr_trp_d)) |=> ((cfg_sdr_trp_d >= 2) && (cfg_sdr_trp_d <= 8));
endproperty
assert property(af_p289);

property af_p290;
@(posedge sdram_clk) (1'b1) |-> ((cfg_sdr_trp_d >= 1) && (cfg_sdr_trp_d <= 15));
endproperty
assert property(af_p290);

property af_p291;
@(posedge wb_clk_i) ((cfg_sdr_trp_d >= 4) && (cfg_sdr_trp_d <= 10)) |=> (!sdr_ras_n)[*1:$] ##0 (sdr_ras_n)[->1] within (cfg_sdr_trp_d);
endproperty
assert property(af_p291);

property af_p292;
@(posedge wb_clk_i) (!sdr_init_done) |-> (cfg_sdr_twr_d == $past(cfg_sdr_twr_d));
endproperty
assert property(af_p292);

property af_p293;
@(posedge wb_clk_i) ((cfg_sdr_twr_d >= 0) && (cfg_sdr_twr_d <= 15)) |=> ((cfg_sdr_twr_d >= 0) && (cfg_sdr_twr_d <= 15));
endproperty
assert property(af_p293);


property af_p295;
@(posedge wb_clk_i) $past(!wb_rst_i,4) |-> ((cfg_sdr_twr_d >= 0) && (cfg_sdr_twr_d <= 15));
endproperty
assert property(af_p295);

property af_p296;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ((cfg_sdr_twr_d >= 0) && (cfg_sdr_twr_d <= 15));
endproperty
assert property(af_p296);

property af_p297;
@(posedge wb_clk_i) (!wb_rst_i) |-> (cfg_sdr_twr_d == $past(cfg_sdr_twr_d));
endproperty
assert property(af_p297);

property af_p298;
@(posedge wb_clk_i) (cfg_sdr_en && (cfg_sdr_twr_d >= 4) && (cfg_sdr_twr_d <= 15)) |=> ((cfg_sdr_twr_d >= 4) && (cfg_sdr_twr_d <= 15));
endproperty
assert property(af_p298);

property af_p299;
@(posedge wb_clk_i) $past(!wb_rst_i,3) |-> ((cfg_sdr_twr_d >= 2) && (cfg_sdr_twr_d <= 12));
endproperty
assert property(af_p299);

property af_p300;
@(posedge wb_clk_i) $past(!wb_rst_i,3) |-> ((cfg_sdr_twr_d >= 2) && (cfg_sdr_twr_d <= 10));
endproperty
assert property(af_p300);

property af_p301;
@(posedge wb_clk_i) ((cfg_sdr_twr_d >= 5) && (cfg_sdr_twr_d <= 12)) |=> (cfg_sdr_twr_d >= 3) && (cfg_sdr_twr_d <= 14);
endproperty
assert property(af_p301);

property af_p302;
@(posedge wb_clk_i) (cfg_sdr_en) |-> $stable(cfg_sdr_twr_d) && (cfg_sdr_twr_d >= 0) && (cfg_sdr_twr_d <= 15);
endproperty
assert property(af_p302);

property af_p303;
@(posedge wb_clk_i) (cfg_sdr_en) |=> $stable(cfg_sdr_twr_d);
endproperty
assert property(af_p303);

property af_p304;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 ((cfg_sdr_twr_d >= 0) && (cfg_sdr_twr_d <= 15));
endproperty
assert property(af_p304);

property af_p305;
@(posedge wb_clk_i) (cfg_sdr_en) |-> (cfg_sdr_twr_d >= 1) && (cfg_sdr_twr_d <= 15);
endproperty
assert property(af_p305);

property af_p306;
@(posedge wb_clk_i) (cfg_sdr_twr_d <= 15);
endproperty
assert property(af_p306);

property af_p307;
@(posedge wb_clk_i) (!wb_rst_i) |-> (cfg_sdr_twr_d >= 0) && (cfg_sdr_twr_d <= 15);
endproperty
assert property(af_p307);

property af_p308;
@(posedge wb_clk_i) (wb_cyc_i) |=> ($stable(cfg_sdr_twr_d));
endproperty
assert property(af_p308);

property af_p309;
@(posedge wb_clk_i) ((cfg_sdr_twr_d >= 2) && (cfg_sdr_twr_d <= 8)) |=> (cfg_sdr_twr_d >= 0) && (cfg_sdr_twr_d <= 15);
endproperty
assert property(af_p309);

property af_p310;
@(posedge wb_clk_i) ((cfg_sdr_twr_d >= 4) && (cfg_sdr_twr_d <= 8)) |=> ((cfg_sdr_twr_d >= 4) && (cfg_sdr_twr_d <= 8));
endproperty
assert property(af_p310);

property af_p311;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> ##3 (cfg_sdr_twr_d >= 0) && (cfg_sdr_twr_d <= 15);
endproperty
assert property(af_p311);

property af_p312;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> ##4 (cfg_sdr_twr_d >= 0) && (cfg_sdr_twr_d <= 15);
endproperty
assert property(af_p312);

property af_p313;
@(posedge wb_clk_i) (!cfg_sdr_en) |=> ($stable(cfg_sdr_twr_d));
endproperty
assert property(af_p313);

property af_p314;
@(posedge wb_clk_i) ((cfg_sdr_twr_d >= 4) && (cfg_sdr_twr_d <= 10)) |=> (cfg_sdr_twr_d >= 0) && (cfg_sdr_twr_d <= 15);
endproperty
assert property(af_p314);

property af_p315;
@(posedge sdram_clk) (sdram_resetn) |=> ($stable(cfg_sdr_twr_d));
endproperty
assert property(af_p315);

property af_p316;
@(posedge wb_clk_i) (wb_cyc_i) |-> ($stable(cfg_sdr_width));
endproperty
assert property(af_p316);

property af_p317;
@(posedge sdram_clk) ($changed(cfg_sdr_width)) |-> (!cfg_sdr_en);
endproperty
assert property(af_p317);

property af_p318;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##4 (cfg_sdr_width inside {[0:2]});
endproperty
assert property(af_p318);

property af_p319;
@(posedge sdram_clk) (!sdram_resetn === 1'b0) |-> (cfg_sdr_width inside {2'd0, 2'd1, 2'd2});
endproperty
assert property(af_p319);

property af_p320;
@(posedge sdram_clk) (cfg_sdr_width inside {[0:2]}) |-> ##1 (cfg_sdr_width inside {[0:2]});
endproperty
assert property(af_p320);

property af_p321;
@(posedge wb_clk_i) (cfg_sdr_en) |-> ($stable(cfg_sdr_width));
endproperty
assert property(af_p321);

property af_p322;
@(posedge sdram_clk) (cfg_sdr_en) |-> ($stable(cfg_sdr_width));
endproperty
assert property(af_p322);

property af_p323;
@(posedge sdram_clk) (cfg_sdr_width inside {2'd0, 2'd1}) |-> ##1 (sdr_dqm !== '0);
endproperty
assert property(af_p323);

property af_p324;
@(posedge sdram_clk) (sdram_resetn) |-> (cfg_sdr_width <= 2);
endproperty
assert property(af_p324);

property af_p325;
@(posedge wb_clk_i) $rose(sdram_resetn) |=> ($stable(cfg_sdr_width))[*4];
endproperty
assert property(af_p325);

property af_p326;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##3 (cfg_sdr_width >= 0 && cfg_sdr_width <= 2);
endproperty
assert property(af_p326);

property af_p327;
@(posedge sdram_clk) (!cfg_sdr_en) |-> ##1 (cfg_sdr_width == $past(cfg_sdr_width));
endproperty
assert property(af_p327);

property af_p328;
@(posedge sdram_clk) (($past(cfg_sdr_width) == 2'd2) && $rose(sdram_resetn)) |-> (cfg_sdr_width == 2'd2);
endproperty
assert property(af_p328);

property af_p329;
@(posedge sdram_clk) (!sdram_resetn) |-> (cfg_sdr_width inside {2'd0, 2'd1, 2'd2});
endproperty
assert property(af_p329);

property af_p330;
@(posedge sdram_clk) (wb_cyc_i && (cfg_sdr_width >= 0 && cfg_sdr_width <= 2)) |=> (cfg_sdr_width >= 0 && cfg_sdr_width <= 2);
endproperty
assert property(af_p330);

property af_p331;
@(posedge sdram_clk) disable iff (wb_rst_i) (!sdr_init_done) |-> $stable(cfg_sdr_width);
endproperty
assert property(af_p331);

property af_p332;
@(posedge sdram_clk) (cfg_sdr_width == 2'd2) |=> !$isunknown(sdr_dq);
endproperty
assert property(af_p332);

property af_p333;
@(posedge sdram_clk) (sdr_init_done && $changed(cfg_sdr_width)) |=> ((cfg_sdr_width >= 0) && (cfg_sdr_width <= 2));
endproperty
assert property(af_p333);

property af_p334;
@(posedge sdram_clk) (wb_cyc_i && wb_stb_i) |=> $stable(cfg_sdr_width);
endproperty
assert property(af_p334);

property af_p335;
@(posedge sdram_clk) cfg_sdr_en |-> (cfg_sdr_mode_reg[1:0] == cfg_sdr_width);
endproperty
assert property(af_p335);

property af_p336;
@(posedge sdram_clk) cfg_sdr_en |-> ((cfg_sdr_width == 2'd0) || (cfg_sdr_width == 2'd1) || (cfg_sdr_width == 2'd2));
endproperty
assert property(af_p336);

property af_p337;
@(posedge sdram_clk) cfg_sdr_en |=> $stable(cfg_sdr_width)[*4];
endproperty
assert property(af_p337);

property af_p338;
@(posedge sdram_clk) ((cfg_sdr_width >= 0) && (cfg_sdr_width <= 2)) |=> ((cfg_sdr_width >= 0) && (cfg_sdr_width <= 2));
endproperty
assert property(af_p338);

property af_p339;
@(posedge sdram_clk) sdr_init_done |-> $stable(cfg_sdr_width);
endproperty
assert property(af_p339);

property af_p340;
@(posedge wb_clk_i) (!wb_rst_i) |-> ((cfg_sdr_width >= 0) && (cfg_sdr_width <= 2));
endproperty
assert property(af_p340);

property af_p341;
@(posedge sdram_clk) (cfg_sdr_en) |-> (sdr_addr == cfg_sdr_mode_reg);
endproperty
assert property(af_p341);

property af_p342;
@(posedge sdram_clk) (!cfg_sdr_en) |-> $stable(sdr_addr);
endproperty
assert property(af_p342);

property af_p343;
@(posedge sdram_clk) $fell(cfg_sdr_en) |=> ($stable(sdr_addr))[*2];
endproperty
assert property(af_p343);

property af_p344;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##3 (sdr_addr == cfg_sdr_mode_reg);
endproperty
assert property(af_p344);

property af_p345;
@(posedge sdram_clk) $changed(sdr_addr) |-> ##1 $stable(sdr_addr);
endproperty
assert property(af_p345);

property af_p346;
@(posedge sdram_clk) $changed(sdr_ba) |-> $stable(sdr_addr);
endproperty
assert property(af_p346);

property af_p347;
@(posedge sdram_clk) (!sdram_resetn) |-> !$isunknown(sdr_addr);
endproperty
assert property(af_p347);

property af_p348;
@(posedge sdram_clk) $fell(sdr_ras_n) |-> ##1 $stable(sdr_addr);
endproperty
assert property(af_p348);


property af_p350;
@(posedge sdram_clk) (sdr_ras_n == 1'b0) |-> ($past(sdr_addr) == sdr_addr);
endproperty
assert property(af_p350);

property af_p351;
@(posedge sdram_clk) (cfg_sdr_rfsh && !sdr_cas_n && !sdr_ras_n) |-> $stable(sdr_addr);
endproperty
assert property(af_p351);

property af_p352;
@(posedge sdram_clk) (!sdr_cs_n && !sdr_ras_n && !sdr_cas_n && !sdr_we_n) |-> (sdr_addr == cfg_sdr_mode_reg);
endproperty
assert property(af_p352);

property af_p353;
@(posedge wb_clk_i) (!wb_cyc_i) |-> $stable(sdr_addr);
endproperty
assert property(af_p353);

property af_p354;
@(posedge sdram_clk) (!sdr_cs_n) |-> (sdr_addr < (1 << cfg_colbits));
endproperty
assert property(af_p354);

property af_p355;
@(posedge sdram_clk) (!sdr_cs_n && !sdr_ras_n) |-> $stable(sdr_addr) throughout (!sdr_cs_n && !sdr_ras_n)[*1:$];
endproperty
assert property(af_p355);

property af_p356;
@(posedge sdram_clk) (!sdr_ras_n && !sdr_we_n && sdr_cas_n) |-> (sdr_addr[10] == 1'b1);
endproperty
assert property(af_p356);

property af_p357;
@(posedge sdram_clk) (cfg_sdr_rfsh && !sdr_ras_n && !sdr_cas_n && (cfg_sdr_rfmax != 0)) |-> 1'b1;
endproperty
assert property(af_p357);

property af_p358;
@(posedge sdram_clk) (sdr_init_done) |-> $stable(sdr_addr);
endproperty
assert property(af_p358);

property af_p359;
@(posedge sdram_clk) (!sdr_cas_n) |-> (!$isunknown(sdr_addr));
endproperty
assert property(af_p359);

property af_p360;
@(posedge sdram_clk) (!sdr_ras_n && !sdr_we_n) |-> (sdr_addr[10] == 1'b1);
endproperty
assert property(af_p360);

property af_p361;
@(posedge sdram_clk) (!sdr_cs_n && !sdr_ras_n && !sdr_cas_n) |-> (!$isunknown(sdr_addr));
endproperty
assert property(af_p361);

property af_p362;
@(posedge sdram_clk) $fell(sdram_resetn) |=> (sdr_addr == '0) throughout (!sdr_init_done)[*1:$];
endproperty
assert property(af_p362);

property af_p363;
@(posedge sdram_clk) ($fell(sdram_resetn)) |-> (!sdr_init_done throughout (sdr_addr == '0)[*1:$] ##1 sdr_init_done);
endproperty
assert property(af_p363);

property af_p364;
@(posedge sdram_clk) (1) |-> ($stable(sdr_addr) || $changed(sdr_addr));
endproperty
assert property(af_p364);

property af_p365;
@(posedge sdram_clk) (wb_cti_i == 3'b010) |-> ($stable(sdr_addr) or (sdr_addr == ($past(sdr_addr) + 1)));
endproperty
assert property(af_p365);

property af_p366;
@(posedge wb_clk_i) (!(wb_stb_i && wb_cyc_i)) |-> $stable(sdr_addr);
endproperty
assert property(af_p366);


property af_p368;
@(posedge sdram_clk) (!sdram_resetn) |-> (sdr_addr == '0);
endproperty
assert property(af_p368);

property af_p369;
@(posedge sdram_clk) (cfg_sdr_width == 2'b10) |-> (sdr_addr[12:0] inside {[13'h0:13'h1FFF]});
endproperty
assert property(af_p369);

property af_p370;
@(posedge sdram_clk) (!sdr_we_n && !sdr_ras_n) |-> (sdr_addr[10] == 1'b1);
endproperty
assert property(af_p370);

property af_p371;
@(posedge sdram_clk) (!sdr_cs_n) |-> $stable(sdr_addr) until_with (!$stable(sdr_cs_n));
endproperty
assert property(af_p371);


property af_p373;
@(posedge sdram_clk) (1) |-> (sdr_addr < (1 << cfg_colbits));
endproperty
assert property(af_p373);


property af_p375;
@(posedge sdram_clk) ($changed(sdr_we_n) && !$changed(sdr_ba)) |-> $stable(sdr_ba);
endproperty
assert property(af_p375);

property af_p376;
@(posedge sdram_clk) (cfg_sdr_en) |-> $stable(sdr_ba);
endproperty
assert property(af_p376);

property af_p377;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##[1:2] !$isunknown(sdr_ba);
endproperty
assert property(af_p377);

property af_p378;
@(posedge sdram_clk) (sdram_resetn) |-> !$isunknown(sdr_ba);
endproperty
assert property(af_p378);

property af_p379;
@(posedge sdram_clk) (!sdram_resetn) |-> (sdr_ba == 2'b00) until (cfg_sdr_en);
endproperty
assert property(af_p379);

property af_p380;
@(posedge sdram_clk) (1'b1) |-> ##[2:$] !$isunknown(sdr_ba);
endproperty
assert property(af_p380);

property af_p381;
@(posedge sdram_clk) $changed(sdr_ba) |-> $rose(sdram_clk);
endproperty
assert property(af_p381);

property af_p382;
@(posedge sdram_clk) (!wb_cyc_i) |-> $stable(sdr_ba);
endproperty
assert property(af_p382);

property af_p383;
@(posedge sdram_clk) (wb_cyc_i && $changed(wb_addr_i)) |=> (sdr_ba == wb_addr_i[13:12]);
endproperty
assert property(af_p383);

property af_p384;
@(posedge sdram_clk) (cfg_sdr_en) |-> !$isunknown(sdr_ba);
endproperty
assert property(af_p384);

property af_p385;
@(posedge sdram_clk) (wb_stb_i && wb_cyc_i) |=> (sdr_ba == wb_addr_i[13:12]);
endproperty
assert property(af_p385);

property af_p386;
@(posedge sdram_clk) $changed(wb_addr_i) |-> ##[1:2] $changed(sdr_ba);
endproperty
assert property(af_p386);

property af_p387;
@(posedge sdram_clk) (!sdr_cs_n) |-> (sdr_ba !== 'x) && (sdr_ba !== 'z);
endproperty
assert property(af_p387);

property af_p388;
@(posedge sdram_clk) (wb_cti_i == 3'b010) |-> ($stable(sdr_ba) throughout (wb_cti_i == 3'b010)[*2:$]);
endproperty
assert property(af_p388);

property af_p389;
@(posedge sdram_clk) $changed(sdr_addr) |-> $changed(sdr_ba);
endproperty
assert property(af_p389);

property af_p390;
@(posedge sdram_clk) $rose(sdr_init_done) |-> ##2 ((sdr_ba !== 'x) && (sdr_ba !== 'z));
endproperty
assert property(af_p390);

property af_p391;
@(posedge sdram_clk) (!$past(sdr_cs_n) && !$past(sdr_ras_n) || !$past(sdr_cas_n) || !$past(sdr_we_n)) |-> $stable(sdr_ba);
endproperty
assert property(af_p391);

property af_p392;
@(posedge sdram_clk) (!sdr_cke) |-> ##1 $stable(sdr_ba);
endproperty
assert property(af_p392);

property af_p393;
@(posedge sdram_clk) $stable(sdr_ba) |=> $stable(sdr_ba);
endproperty
assert property(af_p393);

property af_p394;
@(posedge sdram_clk) (!sdr_ras_n && !sdr_cas_n) |-> ((sdr_ba !== 'x) && (sdr_ba !== 'z));
endproperty
assert property(af_p394);

property af_p395;
@(posedge sdram_clk) $changed(sdr_ba) |=> $stable(sdr_ba);
endproperty
assert property(af_p395);

property af_p396;
@(posedge sdram_clk) (cfg_sdr_width == 2'b00) |-> (sdr_ba inside {2'b00, 2'b01});
endproperty
assert property(af_p396);

property af_p397;
@(posedge sdram_clk) (wb_cti_i == 3'b010) |-> $stable(sdr_ba);
endproperty
assert property(af_p397);

property af_p398;
@(posedge sdram_clk) (sdr_we_n) |-> $stable(sdr_ba);
endproperty
assert property(af_p398);

property af_p399;
@(posedge sdram_clk) ($rose(sdram_resetn)) |-> (sdr_ba >= 0 && sdr_ba <= 3);
endproperty
assert property(af_p399);

property af_p400;
@(posedge sdram_clk) (!sdr_ras_n && !sdr_we_n) |-> $stable(sdr_ba);
endproperty
assert property(af_p400);

property af_p401;
@(posedge sdram_clk) (wb_we_i && wb_stb_i) |-> $stable(sdr_ba);
endproperty
assert property(af_p401);

property af_p402;
@(posedge sdram_clk) (!sdr_ras_n) |-> $stable(sdr_ba);
endproperty
assert property(af_p402);

property af_p403;
@(posedge sdram_clk) (sdr_init_done) |-> (sdr_ba >= 0 && sdr_ba <= 3);
endproperty
assert property(af_p403);


property af_p405;
@(posedge sdram_clk) (wb_stb_i && wb_cyc_i) |-> ##[0:1] (sdr_ba == wb_addr_i[12:11]);
endproperty
assert property(af_p405);

property af_p406;
@(posedge sdram_clk) (sdram_resetn) |-> (sdr_ba >= 0 && sdr_ba <= 3);
endproperty
assert property(af_p406);

property af_p407;
@(posedge sdram_clk) (!sdr_cas_n) |-> $stable(sdr_ba);
endproperty
assert property(af_p407);



property af_p410;
@(posedge sdram_clk) (!cfg_sdr_en) |-> (sdr_cas_n == 1'b1);
endproperty
assert property(af_p410);

property af_p411;
@(posedge sdram_clk) (!sdram_resetn) |-> (sdr_cas_n == 1'b1);
endproperty
assert property(af_p411);

property af_p412;
@(posedge sdram_clk) $rose(sdram_resetn) |-> (sdr_cas_n == 1'b1) throughout (!sdr_init_done)[*1:$];
endproperty
assert property(af_p412);

property af_p413;
@(posedge sdram_clk) $rose(cfg_sdr_rfsh) |-> ##[1:$] (!sdr_ras_n && !sdr_cas_n);
endproperty
assert property(af_p413);


property af_p415;
@(posedge sdram_clk) (!sdr_cs_n) |-> !$isunknown({sdr_ras_n, sdr_cas_n, sdr_we_n});
endproperty
assert property(af_p415);

property af_p416;
@(posedge sdram_clk) $stable(sdr_cas_n) || $changed(sdr_cas_n) |=> $stable(sdr_cas_n) throughout 1;
endproperty
assert property(af_p416);

property af_p417;
@(posedge sdram_clk) (!sdr_cs_n) |-> (sdr_cas_n == 1'b0) or ((sdr_cs_n) |-> (sdr_cas_n == 1'b1));
endproperty
assert property(af_p417);

property af_p418;
@(posedge sdram_clk) (1'b1) |-> ##1 $stable(sdr_cas_n);
endproperty
assert property(af_p418);

property af_p419;
@(posedge sdram_clk) (sdr_ras_n && sdr_we_n) |-> (!sdr_cas_n);
endproperty
assert property(af_p419);

property af_p420;
@(posedge sdram_clk) (1'b1) |-> ##1 !$isunknown(sdr_cas_n);
endproperty
assert property(af_p420);


property af_p422;
@(posedge sdram_clk) (1'b1) |-> ##[1:2] !$isunknown(sdr_cas_n);
endproperty
assert property(af_p422);

property af_p423;
@(posedge sdram_clk) $fell(sdr_cas_n) |-> ##1 (sdr_cas_n == 1'b1);
endproperty
assert property(af_p423);


property af_p425;
@(posedge sdram_clk) ($fell(sdr_cas_n)) |-> ##1 (sdr_cas_n == 1'b1);
endproperty
assert property(af_p425);

property af_p426;
@(posedge sdram_clk) !(sdr_cas_n == 1'b0 && sdr_ras_n == 1'b0);
endproperty
assert property(af_p426);

property af_p427;
@(posedge sdram_clk) (sdr_cs_n) |-> $stable(sdr_cas_n);
endproperty
assert property(af_p427);

property af_p428;
@(posedge sdram_clk) (sdr_ras_n && !sdr_we_n) |-> (!sdr_cas_n);
endproperty
assert property(af_p428);

property af_p429;
@(posedge sdram_clk) (!sdr_init_done) |-> (sdr_cas_n);
endproperty
assert property(af_p429);

property af_p430;
@(posedge sdram_clk) ($fell(sdram_resetn)) |-> (sdr_cas_n [*3]);
endproperty
assert property(af_p430);

property af_p431;
@(posedge sdram_clk) (!sdr_init_done) |-> (!sdr_cas_n);
endproperty
assert property(af_p431);


property af_p433;
@(posedge sdram_clk) (!wb_cyc_i && !wb_stb_i) |-> ($stable(sdr_cas_n));
endproperty
assert property(af_p433);


property af_p435;
@(posedge sdram_clk) (!sdr_cas_n) |-> (cfg_sdr_en);
endproperty
assert property(af_p435);

property af_p436;
@(posedge sdram_clk) ($changed(sdr_cas_n)) |=> ($stable(sdr_cas_n));
endproperty
assert property(af_p436);

property af_p437;
@(posedge sdram_clk) (cfg_sdr_en && sdr_init_done) |-> $stable(sdr_cke);
endproperty
assert property(af_p437);

property af_p438;
@(posedge sdram_clk) (wb_cyc_i && wb_ack_o) |-> (sdr_cke == 1'b1);
endproperty
assert property(af_p438);

property af_p439;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##[1:8] (sdr_cke == 1'b1);
endproperty
assert property(af_p439);

property af_p440;
@(posedge sdram_clk) (!sdram_resetn) |-> (sdr_cke == 1'b0);
endproperty
assert property(af_p440);

property af_p441;
@(posedge sdram_clk) (wb_cyc_i && wb_stb_i) |-> (sdr_cke == 1'b1);
endproperty
assert property(af_p441);

property af_p442;
@(posedge sdram_clk) $rose(sdr_cke) |-> ##[1:$] $rose(sdr_init_done);
endproperty
assert property(af_p442);

property af_p443;
@(posedge sdram_clk) $changed(sdr_cke) |-> ##1 $stable(sdr_cke);
endproperty
assert property(af_p443);

property af_p444;
@(posedge sdram_clk) $fell(sdram_resetn) |-> (sdr_cke == 1'b0);
endproperty
assert property(af_p444);

property af_p445;
@(posedge sdram_clk) (wb_cyc_i) |-> (sdr_cke == 1'b1);
endproperty
assert property(af_p445);

property af_p446;
@(posedge sdram_clk) $rose(sdr_cke) |-> sdr_init_done;
endproperty
assert property(af_p446);

property af_p447;
@(posedge sdram_clk) $rose(cfg_sdr_rfsh) |-> sdr_cke throughout (##[1:$] (cfg_sdr_trcar_d == 0));
endproperty
assert property(af_p447);


property af_p449;
@(posedge sdram_clk) $fell(cfg_sdr_en) |-> ##[1:16] !sdr_cke;
endproperty
assert property(af_p449);

property af_p450;
@(posedge sdram_clk) !sdram_resetn |-> !sdr_cke;
endproperty
assert property(af_p450);

property af_p451;
@(posedge sdram_clk) $rose(cfg_sdr_en) |=> sdr_cke throughout (cfg_sdr_en[*1:$]);
endproperty
assert property(af_p451);

property af_p452;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##[1:16] sdr_cke;
endproperty
assert property(af_p452);

property af_p453;
@(posedge sdram_clk) 1'b1 |-> $stable(sdr_cke) or ($changed(sdr_cke) && $rose(sdram_clk));
endproperty
assert property(af_p453);

property af_p454;
@(posedge sdram_clk) $fell(sdram_resetn) |-> !sdr_cke;
endproperty
assert property(af_p454);


property af_p456;
@(posedge sdram_clk) (!sdram_resetn || !sdr_init_done) |-> !sdr_cke;
endproperty
assert property(af_p456);

property af_p457;
@(posedge sdram_clk) cfg_sdr_rfsh |=> $stable(sdr_cke);
endproperty
assert property(af_p457);

property af_p458;
@(posedge sdram_clk) (wb_cyc_i && wb_stb_i) |-> sdr_cke;
endproperty
assert property(af_p458);

property af_p459;
@(posedge sdram_clk) $changed(sdr_cke) |=> $stable(sdr_cke);
endproperty
assert property(af_p459);

property af_p460;
@(posedge sdram_clk) 1'b1 |-> !$isunknown(sdr_cke);
endproperty
assert property(af_p460);

property af_p461;
@(posedge sdram_clk) $fell(cfg_sdr_en) |-> ##[1:4] !sdr_cke;
endproperty
assert property(af_p461);

property af_p462;
@(posedge sdram_clk) 1'b1 |-> ##1 $stable(sdr_cke) or $changed(sdr_cke);
endproperty
assert property(af_p462);

property af_p463;
@(posedge sdram_clk) ($past(sdr_cke) && cfg_sdr_en) |-> sdr_cke;
endproperty
assert property(af_p463);

property af_p464;
@(posedge sdram_clk) wb_ack_o |-> $stable(sdr_cs_n);
endproperty
assert property(af_p464);

property af_p465;
@(posedge sdram_clk) (wb_cti_i != 3'b000) |-> !sdr_cs_n;
endproperty
assert property(af_p465);

property af_p466;
@(posedge sdram_clk) $rose(sdram_resetn) |-> sdr_cs_n;
endproperty
assert property(af_p466);

property af_p467;
@(posedge sdram_clk) !$isunknown(sdr_cs_n);
endproperty
assert property(af_p467);

property af_p468;
@(posedge sdram_clk) $fell(wb_cyc_i) |-> sdr_cs_n;
endproperty
assert property(af_p468);

property af_p469;
@(posedge sdram_clk) (wb_cyc_i && wb_stb_i) |-> (sdr_cs_n == 1'b0) ##1 (sdr_cs_n == 1'b1);
endproperty
assert property(af_p469);

property af_p470;
@(posedge sdram_clk) (!cfg_sdr_en) |-> sdr_cs_n;
endproperty
assert property(af_p470);


property af_p472;
@(posedge sdram_clk) (!sdr_cs_n) |-> sdr_init_done;
endproperty
assert property(af_p472);


property af_p474;
@(posedge sdram_clk) (!sdr_init_done) |-> sdr_cs_n;
endproperty
assert property(af_p474);

property af_p475;
@(posedge sdram_clk) (1'b1) |-> ##[1:1] ((sdr_cs_n === 1'b0) || (sdr_cs_n === 1'b1));
endproperty
assert property(af_p475);

property af_p476;
@(posedge sdram_clk) (!cfg_sdr_en) |-> (sdr_cs_n === 1'b1);
endproperty
assert property(af_p476);

property af_p477;
@(posedge sdram_clk) (sdram_resetn) |-> ##4 (sdr_cs_n === (wb_cyc_i ? 1'b0 : 1'b1));
endproperty
assert property(af_p477);


property af_p479;
@(posedge sdram_clk) (!sdr_cs_n) |-> (!sdr_ras_n || !sdr_cas_n || !sdr_we_n);
endproperty
assert property(af_p479);

property af_p480;
@(posedge sdram_clk) (wb_cyc_i && wb_stb_i) |-> ##[1:2] (!sdr_cs_n);
endproperty
assert property(af_p480);

property af_p481;
@(posedge sdram_clk) (!sdr_ras_n && !sdr_cas_n) |-> (!sdr_cs_n);
endproperty
assert property(af_p481);

property af_p482;
@(posedge sdram_clk) (!wb_cyc_i) |-> (sdr_cs_n === 1'b1);
endproperty
assert property(af_p482);

property af_p483;
@(posedge sdram_clk) $rose(sdram_resetn) |-> (sdr_cs_n == 1'b1);
endproperty
assert property(af_p483);


property af_p485;
@(posedge sdram_clk) (sdr_init_done && !sdr_cs_n) |-> (!$isunknown(sdr_ba) && !$isunknown(sdr_addr));
endproperty
assert property(af_p485);

property af_p486;
@(posedge sdram_clk) (wb_cyc_i && wb_stb_i) |-> (sdr_cs_n == 1'b0);
endproperty
assert property(af_p486);

property af_p487;
@(posedge sdram_clk) $rose(cfg_sdr_en) |-> ##[1:8] (sdr_cs_n == 1'b0);
endproperty
assert property(af_p487);

property af_p488;
@(posedge sdram_clk) (cfg_sdr_rfsh) |-> (sdr_cs_n == 1'b0);
endproperty
assert property(af_p488);

property af_p489;
@(posedge sdram_clk) $fell(sdr_cs_n) |-> ##1 $stable(sdr_cs_n);
endproperty
assert property(af_p489);

property af_p490;
@(posedge sdram_clk) ($fell(sdr_cs_n) && $fell(sdr_ras_n)) |-> (sdr_cs_n == 1'b0 && sdr_ras_n == 1'b0);
endproperty
assert property(af_p490);

property af_p491;
@(posedge sdram_clk) $fell(sdram_resetn) |-> ##1 (sdr_cs_n == 1'b1);
endproperty
assert property(af_p491);

property af_p492;
@(posedge sdram_clk) (cfg_sdr_rfsh) |-> (sdr_cs_n == 1'b1);
endproperty
assert property(af_p492);

property af_p493;
@(posedge sdram_clk) (sdram_resetn) |-> (sdr_dq inside {[0:((1<<cfg_sdr_width)-1)]});
endproperty
assert property(af_p493);


property af_p495;
@(posedge sdram_clk) (!wb_stb_i && !wb_cyc_i) |-> $stable(sdr_dq);
endproperty
assert property(af_p495);

property af_p496;
@(posedge sdram_clk) (!sdr_init_done) |-> (sdr_dq === 'bz);
endproperty
assert property(af_p496);

property af_p497;
@(posedge sdram_clk) (!sdr_we_n && !sdr_cas_n) |-> (sdr_dq === wb_dat_i);
endproperty
assert property(af_p497);

property af_p498;
@(posedge sdram_clk) 1'b1 |-> ##[0:1] !$isunknown(sdr_dq);
endproperty
assert property(af_p498);

property af_p499;
@(posedge sdram_clk) $past(sdr_we_n) && !sdr_we_n |-> ##[2:$] $stable(sdr_dq);
endproperty
assert property(af_p499);

property af_p500;
@(posedge sdram_clk) 1'b1 |-> $stable(sdr_dq);
endproperty
assert property(af_p500);


property af_p502;
@(posedge sdram_clk) (!sdr_ras_n && !sdr_cas_n && !sdr_we_n) |=> (sdr_dq === $past(wb_dat_i));
endproperty
assert property(af_p502);

property af_p503;
@(posedge sdram_clk) (wb_ack_o) |-> (wb_dat_o === sdr_dq);
endproperty
assert property(af_p503);

property af_p504;
@(posedge sdram_clk) (sdr_cs_n) |-> ##1 $stable(sdr_dq);
endproperty
assert property(af_p504);

property af_p505;
@(posedge sdram_clk) $stable(sdram_clk) |-> ##1 $stable(sdr_dq);
endproperty
assert property(af_p505);

property af_p506;
@(posedge sdram_clk) (!sdr_ras_n && !sdr_cas_n && !sdr_we_n && !sdr_cs_n) |-> !$isunknown(sdr_dq);
endproperty
assert property(af_p506);

property af_p507;
@(posedge sdram_clk) (sdr_cs_n) |-> (sdr_dq === 'bz);
endproperty
assert property(af_p507);

property af_p508;
@(posedge sdram_clk) (!sdr_dqm) |-> (((sdr_dq >= 0) && (sdr_dq <= 65535)) ##1 ((sdr_dq >= 0) && (sdr_dq <= 65535)));
endproperty
assert property(af_p508);

property af_p509;
@(posedge sdram_clk) disable iff (!sdram_resetn) (!sdr_init_done) |-> (sdr_dq === 'bz);
endproperty
assert property(af_p509);

property af_p510;
@(posedge sdram_clk) disable iff (!sdram_resetn) (sdr_we_n == 1'b0) |-> $stable(sdr_dq);
endproperty
assert property(af_p510);

property af_p511;
@(posedge sdram_clk) (sdr_cs_n) |-> $stable(sdr_dq);
endproperty
assert property(af_p511);

property af_p512;
@(posedge sdram_clk) $rose(wb_ack_o) |-> $stable(sdr_dq);
endproperty
assert property(af_p512);

property af_p513;
@(posedge sdram_clk) $rose(sdr_init_done) |-> ##4 ((sdr_dq >= 0) && (sdr_dq <= 32'hFFFFFFFF));
endproperty
assert property(af_p513);

property af_p514;
@(posedge sdram_clk) (sdr_ras_n == 1'b0 && sdr_cas_n == 1'b0 && sdr_we_n == 1'b1) |-> ##1 (wb_dat_o == $past(sdr_dq));
endproperty
assert property(af_p514);

property af_p515;
@(posedge sdram_clk) (sdr_we_n == 1'b0 && sdr_dqm) |-> (sdr_dq === 'bz);
endproperty
assert property(af_p515);

property af_p516;
@(posedge sdram_clk) (wb_we_i) |-> ##1 (sdr_dq == wb_dat_i);
endproperty
assert property(af_p516);

property af_p517;
@(posedge sdram_clk) ($past(sdr_we_n) == 1'b1 && sdr_we_n == 1'b0) |-> ##1 (sdr_dq !== 'bz);
endproperty
assert property(af_p517);

property af_p518;
@(posedge sdram_clk) (sdram_resetn && !(cfg_sdr_en && sdr_init_done)) |-> (sdr_dq === 'bz);
endproperty
assert property(af_p518);

property af_p519;
@(posedge sdram_clk) (sdr_cas_n == 1'b0 && sdr_we_n == 1'b1) |-> $stable(sdr_dq);
endproperty
assert property(af_p519);

property af_p520;
@(posedge sdram_clk) (sdram_resetn && sdr_cke) |-> ((sdr_dq >= 0) && (sdr_dq <= ((1 << cfg_sdr_width) - 1)));
endproperty
assert property(af_p520);

property af_p521;
@(posedge sdram_clk) ((sdr_dq >= 0) && (sdr_dq <= 255)) |-> ##1 ((sdr_dq >= 0) && (sdr_dq <= 255));
endproperty
assert property(af_p521);

property af_p522;
@(posedge sdram_clk) (!sdr_we_n) |-> ##2 !$isunknown(sdr_dq);
endproperty
assert property(af_p522);

property af_p523;
@(posedge sdram_clk) (!sdram_resetn) |-> (sdr_dq === 'z || $isunknown(sdr_dq));
endproperty
assert property(af_p523);

property af_p524;
@(posedge sdram_clk) (sdr_cas_n && sdr_ras_n && sdr_we_n) |-> ##1 !$isunknown(sdr_dq);
endproperty
assert property(af_p524);

property af_p525;
@(posedge sdram_clk) (sdr_dq === 'z && !sdr_we_n) |-> ##1 (sdr_dq !== 'z);
endproperty
assert property(af_p525);


property af_p527;
@(posedge sdram_clk) ((sdr_dq >= 0) && (sdr_dq <= 65535)) |-> ##1 ((sdr_dq >= 0) && (sdr_dq <= 65535));
endproperty
assert property(af_p527);

property af_p528;
@(posedge sdram_clk) (!wb_cyc_i |-> (sdr_dq === 'z)) and ($rose(wb_cyc_i) |-> ##1 !$isunknown(sdr_dq));
endproperty
assert property(af_p528);

property af_p529;
@(posedge sdram_clk) (wb_stb_i && wb_we_i) |-> ##[1:2] (sdr_dq == wb_dat_i);
endproperty
assert property(af_p529);

property af_p530;
@(posedge sdram_clk) (sdr_dqm && !sdr_we_n) |-> $isunknown(sdr_dq);
endproperty
assert property(af_p530);

property af_p531;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> (sdr_dq == wb_dat_i);
endproperty
assert property(af_p531);

property af_p532;
@(posedge sdram_clk) (!sdr_cas_n && sdr_we_n) |-> $stable(sdr_dq);
endproperty
assert property(af_p532);

property af_p533;
@(posedge sdram_clk) (!sdr_we_n) |-> !$isunknown(sdr_dq);
endproperty
assert property(af_p533);

property af_p534;
@(posedge sdram_clk) (!sdr_cke) |-> (sdr_dq === 'z);
endproperty
assert property(af_p534);

property af_p535;
@(posedge sdram_clk) $changed(sdr_dqm) |-> $stable(sdr_dqm, @(negedge sdram_clk));
endproperty
assert property(af_p535);

property af_p536;
@(posedge sdram_clk) (sdr_dqm >= 0) && (sdr_dqm <= 15);
endproperty
assert property(af_p536);


property af_p538;
@(posedge sdram_clk) $rose(sdr_cke) |-> ##[1:3] $changed(sdr_dqm);
endproperty
assert property(af_p538);


property af_p540;
@(posedge sdram_clk) (!wb_cyc_i) |-> ##1 $stable(sdr_dqm);
endproperty
assert property(af_p540);

property af_p541;
@(posedge sdram_clk) (wb_cyc_i && wb_stb_i && !wb_we_i) |-> (sdr_dqm >= 0) && (sdr_dqm <= 15);
endproperty
assert property(af_p541);

property af_p542;
@(posedge sdram_clk) (cfg_sdr_width == 2'b00) |-> (sdr_dqm inside {2'b00, 2'b01});
endproperty
assert property(af_p542);

property af_p543;
@(posedge sdram_clk) (!sdram_resetn && sdr_init_done) |-> !$isunknown(sdr_dqm);
endproperty
assert property(af_p543);

property af_p544;
@(posedge sdram_clk) 1'b1 |-> ##[1:2] $isunknown(sdr_dqm) === 1'b0;
endproperty
assert property(af_p544);

property af_p545;
@(posedge sdram_clk) (cfg_sdr_width == 2'b10) |-> (sdr_dqm >= 0) && (sdr_dqm <= 15);
endproperty
assert property(af_p545);

property af_p546;
@(posedge sdram_clk) (wb_cyc_i && wb_stb_i && !wb_we_i) |-> (sdr_dqm == 4'b0000);
endproperty
assert property(af_p546);

property af_p547;
@(posedge sdram_clk) $rose(sdram_resetn) |-> (sdr_dqm == '0)[*3];
endproperty
assert property(af_p547);

property af_p548;
@(posedge sdram_clk) ($rose(sdram_resetn) && !wb_cyc_i) |-> (sdr_dqm == {$bits(sdr_dqm){1'b1}});
endproperty
assert property(af_p548);

property af_p549;
@(posedge sdram_clk) (wb_cti_i == 3'b010 && wb_we_i) |-> (sdr_dqm == ~wb_sel_i);
endproperty
assert property(af_p549);

property af_p550;
@(posedge sdram_clk) (!sdr_cas_n && !sdr_we_n) |-> (sdr_dqm == ~wb_sel_i);
endproperty
assert property(af_p550);

property af_p551;
@(posedge sdram_clk) (cfg_sdr_width == 2'b10 && wb_we_i) |-> (sdr_dqm == ~wb_sel_i);
endproperty
assert property(af_p551);

property af_p552;
@(posedge sdram_clk) ($fell(sdr_cas_n) && (wb_sel_i == 2'b01)) |-> (sdr_dqm[1] && !sdr_dqm[0]);
endproperty
assert property(af_p552);

property af_p553;
@(posedge sdram_clk) (wb_stb_i && wb_we_i && wb_cyc_i) |-> ##[1:2] (sdr_dqm inside {[0:15]});
endproperty
assert property(af_p553);

property af_p554;
@(posedge sdram_clk) $changed(wb_sel_i) |-> ##1 (sdr_dqm inside {[0:15]});
endproperty
assert property(af_p554);

property af_p555;
@(posedge sdram_clk) (!wb_stb_i) |-> $stable(sdr_dqm);
endproperty
assert property(af_p555);

property af_p556;
@(posedge sdram_clk) (sdr_dqm != {$bits(sdr_dqm){1'b1}}) |-> (wb_we_i && wb_cyc_i);
endproperty
assert property(af_p556);

property af_p557;
@(posedge sdram_clk) $rose(wb_ack_o) |-> ##[1:2] (sdr_dqm == '0);
endproperty
assert property(af_p557);

property af_p558;
@(posedge sdram_clk) $fell(sdram_resetn) |-> ##1 (sdr_dqm == {$bits(sdr_dqm){1'b1}});
endproperty
assert property(af_p558);

property af_p559;
@(posedge sdram_clk) (cfg_sdr_width == 2'b01) |-> (sdr_dqm >= 0 && sdr_dqm <= 3);
endproperty
assert property(af_p559);

property af_p560;
@(posedge sdram_clk) (wb_cyc_i && wb_stb_i && wb_we_i && sdr_dqm) |-> ##1 (sdr_dqm == ~wb_sel_i);
endproperty
assert property(af_p560);

property af_p561;
@(posedge sdram_clk) (!sdr_init_done) |-> (sdr_dqm == '1);
endproperty
assert property(af_p561);

property af_p562;
@(posedge sdram_clk) (wb_cyc_i && wb_stb_i && (sdr_dqm > ((cfg_sdr_width == 2'b01) ? 4'h3 : 4'hF))) |-> ##1 (sdr_dqm <= ((cfg_sdr_width == 2'b01) ? 4'h3 : 4'hF));
endproperty
assert property(af_p562);

property af_p563;
@(posedge sdram_clk) (!cfg_sdr_en) |-> (sdr_dqm == '1);
endproperty
assert property(af_p563);

property af_p564;
@(posedge sdram_clk) ((!sdr_cas_n) && sdr_we_n) |-> (sdr_dqm == '0);
endproperty
assert property(af_p564);

property af_p565;
@(posedge sdram_clk) (wb_cyc_i && wb_stb_i && wb_we_i) |-> ##1 (sdr_dqm == ~wb_sel_i);
endproperty
assert property(af_p565);

property af_p566;
@(posedge sdram_clk) (!(wb_stb_i && wb_cyc_i && wb_we_i)) |-> ($stable(sdr_dqm));
endproperty
assert property(af_p566);

property af_p567;
@(posedge sdram_clk) ($fell(cfg_sdr_en)) |-> ##1 (sdr_dqm == '1);
endproperty
assert property(af_p567);

property af_p568;
@(posedge sdram_clk) (!sdr_init_done) |-> (sdr_dqm == '0);
endproperty
assert property(af_p568);

property af_p569;
@(posedge sdram_clk) disable iff (!sdram_resetn) ($rose(sdr_init_done)) |-> (sdr_init_done until (!sdram_resetn));
endproperty
assert property(af_p569);

property af_p570;
@(posedge sdram_clk) $rose(cfg_sdr_en) |-> ##[1:200] (sdr_init_done);
endproperty
assert property(af_p570);

property af_p571;
@(posedge wb_clk_i) (!sdr_init_done && wb_cyc_i) |-> (!wb_ack_o);
endproperty
assert property(af_p571);

property af_p572;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##4 (!$isunknown(sdr_init_done));
endproperty
assert property(af_p572);

property af_p573;
@(posedge sdram_clk) disable iff (!sdram_resetn) ($rose(sdr_init_done)) |=> (sdr_init_done);
endproperty
assert property(af_p573);

property af_p574;
@(posedge sdram_clk) (!sdram_resetn) |-> (!sdr_init_done);
endproperty
assert property(af_p574);

property af_p575;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> (!sdr_init_done);
endproperty
assert property(af_p575);

property af_p576;
@(posedge sdram_clk) (cfg_sdr_rfsh) |-> (!sdr_init_done);
endproperty
assert property(af_p576);

property af_p577;
@(posedge sdram_clk) (sdr_init_done) |-> (sdr_cke);
endproperty
assert property(af_p577);

property af_p578;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && !sdr_init_done) |-> (!wb_ack_o);
endproperty
assert property(af_p578);

property af_p579;
@(posedge sdram_clk) $rose(sdr_init_done) |-> (sdr_init_done until (!sdram_resetn));
endproperty
assert property(af_p579);


property af_p581;
@(posedge wb_clk_i) (sdr_init_done && wb_cyc_i && wb_stb_i && wb_we_i) |=> sdr_init_done;
endproperty
assert property(af_p581);


property af_p583;
@(posedge sdram_clk) $rose(sdr_init_done) |-> ($past(cfg_sdr_mode_reg) !== 'x);
endproperty
assert property(af_p583);

property af_p584;
@(posedge sdram_clk) $fell(sdram_resetn) |=> (!sdr_init_done)[*1:$] ##1 $rose(sdr_init_done);
endproperty
assert property(af_p584);

property af_p585;
@(posedge sdram_clk) (!sdram_resetn) |-> (sdr_init_done == 1'b0);
endproperty
assert property(af_p585);

property af_p586;
@(posedge sdram_clk) $fell(sdr_init_done) |-> (!sdram_resetn || wb_rst_i);
endproperty
assert property(af_p586);

property af_p587;
@(posedge sdram_clk) $fell(sdram_resetn) |-> !sdr_init_done;
endproperty
assert property(af_p587);

property af_p588;
@(posedge sdram_clk) $rose(sdr_init_done) |-> $stable(cfg_sdr_mode_reg);
endproperty
assert property(af_p588);

property af_p589;
@(posedge sdram_clk) $rose(sdr_init_done) |-> $past(cfg_sdr_en);
endproperty
assert property(af_p589);

property af_p590;
@(posedge wb_clk_i) (!sdr_init_done) |-> !wb_ack_o;
endproperty
assert property(af_p590);

property af_p591;
@(posedge sdram_clk) $rose(sdr_init_done) |-> sdr_cke;
endproperty
assert property(af_p591);

property af_p592;
@(posedge wb_clk_i) wb_ack_o |-> sdr_init_done;
endproperty
assert property(af_p592);

property af_p593;
@(posedge sdram_clk) (!sdr_init_done) |-> (sdr_ras_n === 1'b1 && sdr_cas_n === 1'b1 && sdr_we_n === 1'b1);
endproperty
assert property(af_p593);

property af_p594;
@(posedge sdram_clk) $rose(sdr_init_done) |-> cfg_sdr_en;
endproperty
assert property(af_p594);

property af_p595;
@(posedge sdram_clk) $rose(sdr_init_done) |-> $past(cfg_sdr_en) && $past(!sdr_init_done);
endproperty
assert property(af_p595);

property af_p596;
@(posedge sdram_clk) (!sdr_init_done) |-> !(!sdr_cs_n && sdr_ras_n && !sdr_cas_n);
endproperty
assert property(af_p596);

property af_p597;
@(posedge sdram_clk) sdr_init_done |=> $stable(sdr_init_done);
endproperty
assert property(af_p597);


property af_p599;
@(posedge sdram_clk) (cfg_sdr_rfsh) |-> (!sdr_ras_n && !sdr_cas_n);
endproperty
assert property(af_p599);

property af_p600;
@(posedge sdram_clk) (cfg_sdr_mode_reg != '0) |-> (!sdr_ras_n && !sdr_cas_n && !sdr_we_n);
endproperty
assert property(af_p600);


property af_p602;
@(posedge sdram_clk) ($fell(sdr_ras_n)) |-> (cfg_sdr_en);
endproperty
assert property(af_p602);



property af_p605;
@(posedge sdram_clk) (!cfg_sdr_en) |-> (sdr_ras_n == 1'b1);
endproperty
assert property(af_p605);

property af_p606;
@(posedge sdram_clk) (!sdram_resetn) |-> (sdr_ras_n == 1'b1);
endproperty
assert property(af_p606);


property af_p608;
@(posedge sdram_clk) (sdr_cs_n) |-> (sdr_ras_n);
endproperty
assert property(af_p608);

property af_p609;
@(posedge sdram_clk) (!cfg_sdr_en) |-> (sdr_ras_n);
endproperty
assert property(af_p609);

property af_p610;
@(posedge sdram_clk) (!sdram_resetn) |-> (sdr_ras_n);
endproperty
assert property(af_p610);

property af_p611;
@(posedge sdram_clk) (wb_cyc_i && wb_stb_i && !wb_we_i) |-> ##[1:$] (!sdr_ras_n);
endproperty
assert property(af_p611);

property af_p612;
@(posedge sdram_clk) $fell(sdr_ras_n) |=> (sdr_ras_n);
endproperty
assert property(af_p612);

property af_p613;
@(posedge sdram_clk) (!sdr_ras_n && !sdr_we_n) |=> (sdr_ras_n);
endproperty
assert property(af_p613);

property af_p614;
@(posedge sdram_clk) (cfg_sdr_rfsh) |-> (!sdr_ras_n && !sdr_cas_n && sdr_we_n);
endproperty
assert property(af_p614);

property af_p615;
@(posedge sdram_clk) (sdr_init_done && wb_stb_i) |-> ##[1:$] (!sdr_ras_n);
endproperty
assert property(af_p615);






property af_p621;
@(posedge sdram_clk) (wb_cti_i) |-> $stable(sdr_ras_n);
endproperty
assert property(af_p621);

property af_p622;
@(posedge sdram_clk) ($rose(sdr_init_done)) |-> ##[1:$] $changed(sdr_ras_n);
endproperty
assert property(af_p622);


property af_p624;
@(posedge sdram_clk) (wb_cyc_i && wb_stb_i && $fell(sdr_ras_n)) |-> (sdr_ras_n == 1'b0) ##1 (sdr_ras_n == 1'b1);
endproperty
assert property(af_p624);

property af_p625;
@(posedge sdram_clk) $stable(sdr_ras_n);
endproperty
assert property(af_p625);

property af_p626;
@(posedge sdram_clk) (!wb_cyc_i && !wb_stb_i) |-> (sdr_ras_n == 1'b1);
endproperty
assert property(af_p626);

property af_p627;
@(posedge sdram_clk) ($fell(sdr_ras_n)) |-> (sdr_ras_n == 1'b0) ##1 (sdr_ras_n == 1'b1);
endproperty
assert property(af_p627);

property af_p628;
@(posedge sdram_clk) (!sdr_init_done) |-> $stable(sdr_ras_n);
endproperty
assert property(af_p628);

property af_p629;
@(posedge sdram_clk) ($rose(sdram_resetn)) |-> (sdr_ras_n == 1'b1) throughout (##[1:$] $fell(sdr_ras_n));
endproperty
assert property(af_p629);

property af_p630;
@(posedge sdram_clk) (!(wb_stb_i && wb_cyc_i)) |-> $stable(sdr_we_n);
endproperty
assert property(af_p630);

property af_p631;
@(posedge sdram_clk) ($rose(sdram_resetn)) |-> ##1 sdr_we_n[*3];
endproperty
assert property(af_p631);

property af_p632;
@(posedge sdram_clk) (!sdr_init_done) |-> (sdr_we_n);
endproperty
assert property(af_p632);


property af_p634;
@(posedge sdram_clk) (!sdr_we_n) |-> (cfg_sdr_en);
endproperty
assert property(af_p634);

property af_p635;
@(posedge sdram_clk) (wb_cyc_i && wb_stb_i && !wb_we_i) |-> (sdr_we_n);
endproperty
assert property(af_p635);

property af_p636;
@(posedge sdram_clk) (!cfg_sdr_en) |-> (sdr_we_n);
endproperty
assert property(af_p636);

property af_p637;
@(posedge sdram_clk) ($fell(sdram_resetn)) |-> ##1 sdr_we_n[*3];
endproperty
assert property(af_p637);

property af_p638;
@(posedge sdram_clk) (!sdr_we_n && !sdr_cas_n && !sdr_ras_n) |-> ##1 (sdr_we_n || sdr_cas_n || sdr_ras_n);
endproperty
assert property(af_p638);


property af_p640;
@(posedge sdram_clk) (sdr_cs_n) |-> (sdr_we_n);
endproperty
assert property(af_p640);

property af_p641;
@(posedge sdram_clk) (sdr_init_done) |-> (sdr_we_n == !wb_we_i);
endproperty
assert property(af_p641);

property af_p642;
@(posedge sdram_clk) (!sdr_we_n) |-> (sdr_cke == 1'b1);
endproperty
assert property(af_p642);

property af_p643;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_we_i) |=> (sdr_we_n == 1'b0) ##1 (sdr_we_n == 1'b1);
endproperty
assert property(af_p643);

property af_p644;
@(posedge sdram_clk) (!sdram_resetn) |-> (sdr_we_n == 1'b1);
endproperty
assert property(af_p644);

property af_p645;
@(posedge sdram_clk) (!cfg_sdr_en) |-> (sdr_we_n == 1'b1);
endproperty
assert property(af_p645);

property af_p646;
@(posedge sdram_clk) ($fell(sdr_we_n)) |=> $stable(sdr_we_n) throughout (1'b1[*1]);
endproperty
assert property(af_p646);

property af_p647;
@(posedge sdram_clk) (!sdr_init_done) |-> (sdr_we_n == 1'b1);
endproperty
assert property(af_p647);

property af_p648;
@(posedge sdram_clk) (1'b1) |-> ##[0:1] !$isunknown(sdr_we_n);
endproperty
assert property(af_p648);

property af_p649;
@(posedge sdram_clk) ($fell(sdr_we_n)) |=> (sdr_we_n == 1'b1);
endproperty
assert property(af_p649);

property af_p650;
@(posedge sdram_clk) ($past(cfg_sdr_mode_reg) != cfg_sdr_mode_reg) |-> (!sdr_we_n && !$isunknown(sdr_addr) && !$isunknown(sdr_ba));
endproperty
assert property(af_p650);

property af_p651;
@(posedge sdram_clk) (!sdr_cas_n && !sdr_ras_n) |-> !sdr_we_n;
endproperty
assert property(af_p651);

property af_p652;
@(posedge sdram_clk) (!sdr_cs_n && !sdr_ras_n && !sdr_cas_n) |-> !sdr_we_n;
endproperty
assert property(af_p652);

property af_p653;
@(posedge sdram_clk) (sdr_cs_n == 1'b0 && sdr_ras_n == 1'b1 && sdr_cas_n == 1'b0) |-> (sdr_we_n == 1'b0);
endproperty
assert property(af_p653);

property af_p654;
@(posedge wb_clk_i) ($rose(wb_ack_o)) |=> (sdr_we_n == 1'b1);
endproperty
assert property(af_p654);

property af_p655;
@(posedge sdram_clk) (wb_cyc_i && wb_stb_i && wb_we_i) |-> (sdr_we_n == 1'b0) ##1 (sdr_we_n == 1'b1);
endproperty
assert property(af_p655);

property af_p656;
@(posedge sdram_clk) (sdr_cs_n == 1'b0 && sdr_ras_n == 1'b1 && sdr_cas_n == 1'b1) |-> (sdr_we_n == 1'b0);
endproperty
assert property(af_p656);


property af_p658;
@(posedge sdram_clk) (sdr_cs_n == 1'b0 && sdr_ras_n == 1'b0 && sdr_cas_n == 1'b0) |-> (sdr_we_n == 1'b1);
endproperty
assert property(af_p658);

property af_p659;
@(posedge sdram_clk) (wb_we_i && wb_stb_i && wb_cyc_i) |-> ##[1:4] (sdr_we_n == 1'b0);
endproperty
assert property(af_p659);

property af_p660;
@(posedge sdram_clk) (sdr_cas_n == 1'b0 && sdr_ras_n == 1'b0 && sdr_we_n == 1'b1) |-> (sdr_we_n == 1'b1);
endproperty
assert property(af_p660);

property af_p661;
@(posedge sdram_clk) ($fell(wb_cyc_i)) |-> (sdr_we_n == 1'b1);
endproperty
assert property(af_p661);


property af_p663;
@(posedge sdram_clk) (sdr_ras_n == 1'b0 && sdr_cas_n == 1'b1) |-> (sdr_we_n == 1'b1);
endproperty
assert property(af_p663);

property af_p664;
@(posedge sdram_clk) (!sdr_init_done && sdr_ras_n == 1'b0 && sdr_cas_n == 1'b1) |-> (sdr_we_n == 1'b0);
endproperty
assert property(af_p664);

property af_p665;
@(posedge sdram_clk) (1'b1) |=> ($stable(sdr_cs_n) || $changed(sdr_cs_n)) && ($stable(sdr_ras_n) || $changed(sdr_ras_n)) && ($stable(sdr_cas_n) || $changed(sdr_cas_n)) && ($stable(sdr_we_n) || $changed(sdr_we_n));
endproperty
assert property(af_p665);

property af_p666;
@(posedge sdram_clk) (cfg_sdr_en) |-> (sdram_clk === ~$past(sdram_clk));
endproperty
assert property(af_p666);

property af_p667;
@(posedge sdram_clk) (wb_cyc_i) |-> (sdram_clk === ~$past(sdram_clk));
endproperty
assert property(af_p667);

property af_p668;
@(posedge sdram_clk) (1'b1) |=> (sdram_clk === ~$past(sdram_clk));
endproperty
assert property(af_p668);

property af_p669;
@(posedge sdram_clk) (1'b1) |=> ($stable(sdr_dq) || $changed(sdr_dq));
endproperty
assert property(af_p669);

property af_p670;
@(posedge sdram_clk) (sdr_init_done) |-> (sdram_clk === ~$past(sdram_clk));
endproperty
assert property(af_p670);

property af_p671;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##[1:16] sdr_init_done;
endproperty
assert property(af_p671);

property af_p672;
@(posedge sdr_init_done) (1'b1) |-> ##[1:$] (sdram_clk === ~$past(sdram_clk));
endproperty
assert property(af_p672);

property af_p673;
@(posedge sdram_clk or negedge sdram_clk) ($rose(sdram_resetn)) |-> (sdram_clk !== $past(sdram_clk))[*4];
endproperty
assert property(af_p673);

property af_p674;
@(posedge sdram_clk or negedge sdram_clk) (wb_stb_i || !wb_stb_i) |-> (sdram_clk !== $past(sdram_clk));
endproperty
assert property(af_p674);

property af_p675;
@(posedge sdram_clk or negedge sdram_clk) ($rose(sdram_resetn)) |-> ##[1:8] (sdram_clk !== $past(sdram_clk));
endproperty
assert property(af_p675);

property af_p676;
@(posedge sdram_clk or negedge sdram_clk) (sdr_cke) |-> (sdram_clk !== $past(sdram_clk));
endproperty
assert property(af_p676);

property af_p677;
@(posedge sdram_clk or negedge sdram_clk) (sdr_cs_n == 1'b0) |-> (sdram_clk !== $past(sdram_clk));
endproperty
assert property(af_p677);

property af_p678;
@(posedge sdram_clk or negedge sdram_clk) (!sdram_resetn) |-> (sdram_clk !== $past(sdram_clk));
endproperty
assert property(af_p678);

property af_p679;
@(posedge sdram_clk) !cfg_sdr_en |-> ##1 (sdram_clk !== $past(sdram_clk));
endproperty
assert property(af_p679);

property af_p680;
@(posedge sdram_clk) $stable(cfg_sdr_width) |-> ##1 (sdram_clk !== $past(sdram_clk));
endproperty
assert property(af_p680);

property af_p681;
@(posedge sdram_clk) cfg_sdr_en |-> ##1 (sdram_clk !== $past(sdram_clk));
endproperty
assert property(af_p681);

property af_p682;
@(posedge wb_clk_i) (sdram_clk !== $past(sdram_clk)) |-> !$isunknown(wb_dat_o);
endproperty
assert property(af_p682);

property af_p683;
@(posedge wb_clk_i) 1'b1 |-> ##[1:$] $changed(sdram_clk);
endproperty
assert property(af_p683);

property af_p684;
@(posedge sdram_clk) (sdr_cke !== $past(sdr_cke)) |-> $rose(sdram_clk);
endproperty
assert property(af_p684);

property af_p685;
@(posedge sdram_clk) cfg_sdr_rfsh |-> ##1 (sdram_clk !== $past(sdram_clk));
endproperty
assert property(af_p685);

property af_p686;
@(posedge sdram_clk) !sdram_resetn |-> ##1 (sdram_clk !== $past(sdram_clk));
endproperty
assert property(af_p686);

property af_p687;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##3 (sdram_clk !== $past(sdram_clk));
endproperty
assert property(af_p687);

property af_p688;
@(posedge sdram_clk) sdr_cke |-> ##1 (sdram_clk !== $past(sdram_clk));
endproperty
assert property(af_p688);

property af_p689;
@(posedge sdram_clk) $fell(sdram_resetn) |-> !wb_ack_o throughout (!sdram_resetn)[*1:$];
endproperty
assert property(af_p689);

property af_p690;
@(posedge sdram_clk) $fell(wb_rst_i) |-> ##1 $rose(sdram_resetn);
endproperty
assert property(af_p690);

property af_p691;
@(posedge sdram_clk) !sdram_resetn |-> !wb_ack_o;
endproperty
assert property(af_p691);

property af_p692;
@(posedge sdram_clk) $rose(wb_rst_i) |-> (!sdram_resetn)[*3];
endproperty
assert property(af_p692);

property af_p693;
@(posedge sdram_clk) !sdram_resetn |-> (sdr_addr == '0) && (sdr_ba == '0);
endproperty
assert property(af_p693);

property af_p694;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##8 $rose(sdr_init_done);
endproperty
assert property(af_p694);

property af_p695;
@(posedge sdram_clk) (!sdram_resetn && (wb_cyc_i || wb_stb_i)) |-> !wb_ack_o;
endproperty
assert property(af_p695);

property af_p696;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##[1:2] $rose(sdr_cke);
endproperty
assert property(af_p696);

property af_p697;
@(posedge sdram_clk) !sdram_resetn |-> ##1 !sdr_cke;
endproperty
assert property(af_p697);

property af_p698;
@(posedge sdram_clk) !sdram_resetn |-> sdr_cs_n;
endproperty
assert property(af_p698);

property af_p699;
@(posedge sdram_clk) $rose(sdram_resetn) |-> (!sdr_cke) until_with (sdr_init_done);
endproperty
assert property(af_p699);

property af_p700;
@(posedge sdram_clk) (!wb_rst_i) |-> $stable(sdram_resetn);
endproperty
assert property(af_p700);

property af_p701;
@(posedge cfg_sdr_en) (!sdram_resetn) |-> (!sdram_resetn);
endproperty
assert property(af_p701);

property af_p702;
@(posedge sdram_clk) (!sdram_resetn) |-> (sdr_ras_n && sdr_cas_n && sdr_we_n);
endproperty
assert property(af_p702);

property af_p703;
@(posedge sdram_clk) (!sdram_resetn) |-> ($stable(sdr_cs_n) && $stable(sdr_cke));
endproperty
assert property(af_p703);

property af_p704;
@(posedge sdram_clk) (!sdram_resetn) |-> (sdr_we_n && sdr_ras_n && sdr_cas_n);
endproperty
assert property(af_p704);

property af_p705;
@(posedge sdram_clk) (!sdram_resetn) |-> $stable(sdr_dqm);
endproperty
assert property(af_p705);

property af_p706;
@(posedge wb_rst_i) (1'b1) |-> (sdram_resetn == 1'b0);
endproperty
assert property(af_p706);

property af_p707;
@(posedge sdram_clk) $rose(sdram_resetn) |-> (sdr_init_done == 1'b0)[*2];
endproperty
assert property(af_p707);

property af_p708;
@(posedge sdram_clk) (!sdram_resetn) |-> (sdr_init_done == 1'b0);
endproperty
assert property(af_p708);

property af_p709;
@(posedge sdram_clk) (!sdram_resetn) |-> (sdr_cs_n == 1'b1);
endproperty
assert property(af_p709);

property af_p710;
@(posedge sdram_clk) $rose(sdram_resetn) |-> (sdr_cs_n throughout (!sdr_init_done)[->1]);
endproperty
assert property(af_p710);

property af_p711;
@(posedge sdram_clk) (sdram_resetn && !wb_rst_i) |=> sdram_resetn;
endproperty
assert property(af_p711);

property af_p712;
@(posedge sdram_clk) (!sdram_resetn) |-> (sdr_addr == '0) && (sdr_ba == '0);
endproperty
assert property(af_p712);

property af_p713;
@(posedge sdram_clk) (!sdram_resetn) |-> (wb_ack_o == 1'b0);
endproperty
assert property(af_p713);

property af_p714;
@(posedge sdram_clk) (!sdram_resetn) |-> (sdr_cs_n && sdr_ras_n && sdr_cas_n && sdr_we_n);
endproperty
assert property(af_p714);

property af_p715;
@(posedge sdram_clk) (!sdram_resetn) |-> (!sdr_cke);
endproperty
assert property(af_p715);

property af_p716;
@(posedge sdram_clk) (!sdram_resetn) |-> (!sdr_init_done);
endproperty
assert property(af_p716);

property af_p717;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ##[1:16] sdr_cke;
endproperty
assert property(af_p717);

property af_p718;
@(posedge sdram_clk) $rose(sdram_resetn) |-> ($past(sdram_resetn) == 1'b0);
endproperty
assert property(af_p718);

property af_p719;
@(posedge sdram_clk) $rose(sdram_resetn) |-> (!sdr_init_done)[*4];
endproperty
assert property(af_p719);

property af_p720;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_cti_i != 3'b000) |-> (wb_ack_o == 1'b1);
endproperty
assert property(af_p720);

property af_p721;
@(posedge wb_clk_i) ($rose(wb_ack_o)) |=> ((wb_ack_o == 1'b0) || (wb_cyc_i && wb_stb_i && $rose(wb_stb_i)));
endproperty
assert property(af_p721);

property af_p722;
@(posedge wb_clk_i) (wb_cti_i == 3'b000 && wb_cyc_i && wb_stb_i && wb_ack_o) |=> (wb_ack_o == 1'b0);
endproperty
assert property(af_p722);

property af_p723;
@(posedge wb_clk_i) (!wb_cyc_i) |-> (wb_ack_o == 1'b0);
endproperty
assert property(af_p723);

property af_p724;
@(posedge wb_clk_i) (1'b1) |-> $stable(wb_ack_o);
endproperty
assert property(af_p724);

property af_p725;
@(posedge wb_clk_i) ($rose(wb_ack_o) && wb_cyc_i && wb_stb_i) |=> ((wb_ack_o == 1'b0) || $rose(wb_stb_i));
endproperty
assert property(af_p725);

property af_p726;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_ack_o) |=> (!wb_stb_i -> (wb_ack_o == 1'b0));
endproperty
assert property(af_p726);

property af_p727;
@(posedge wb_clk_i) (!wb_stb_i) |-> (wb_ack_o == 1'b0);
endproperty
assert property(af_p727);

property af_p728;
@(posedge wb_clk_i) (!wb_stb_i && !wb_cyc_i) |-> !wb_ack_o;
endproperty
assert property(af_p728);

property af_p729;
@(posedge wb_clk_i) (wb_we_i && wb_stb_i && wb_cyc_i) |-> ##[1:4] wb_ack_o;
endproperty
assert property(af_p729);

property af_p730;
@(posedge wb_clk_i) (wb_we_i && wb_cyc_i && wb_stb_i) |=> wb_ack_o;
endproperty
assert property(af_p730);

property af_p731;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> !wb_ack_o[*3];
endproperty
assert property(af_p731);

property af_p732;
@(posedge wb_clk_i) wb_rst_i |=> (wb_ack_o == 1'b0);
endproperty
assert property(af_p732);

property af_p733;
@(posedge wb_clk_i) wb_rst_i |-> !wb_ack_o;
endproperty
assert property(af_p733);

property af_p734;
@(posedge wb_clk_i) (wb_rst_i) |-> (!wb_ack_o);
endproperty
assert property(af_p734);

property af_p735;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_ack_o) |=> (wb_cyc_i && wb_stb_i) |-> !wb_ack_o;
endproperty
assert property(af_p735);

property af_p736;
@(posedge wb_clk_i) disable iff (wb_rst_i) (wb_cyc_i && wb_stb_i) |-> ##[1:16] wb_ack_o;
endproperty
assert property(af_p736);

property af_p737;
@(posedge wb_clk_i) (!wb_we_i && wb_cyc_i && wb_stb_i && wb_ack_o) |-> $isunknown(wb_dat_o) == 0;
endproperty
assert property(af_p737);

property af_p738;
@(posedge wb_clk_i) (wb_cyc_i && !wb_stb_i) |-> $stable(wb_ack_o);
endproperty
assert property(af_p738);

property af_p739;
@(posedge wb_clk_i) (!wb_cyc_i) |-> (!wb_ack_o);
endproperty
assert property(af_p739);

property af_p740;
@(posedge wb_clk_i) wb_ack_o |-> (wb_stb_i && wb_cyc_i);
endproperty
assert property(af_p740);

property af_p741;
@(posedge wb_clk_i) ($rose(wb_ack_o)) |-> (wb_addr_i == $past(wb_addr_i));
endproperty
assert property(af_p741);

property af_p742;
@(posedge wb_clk_i) (wb_we_i && !wb_ack_o) |-> ((wb_addr_i == $past(wb_addr_i)) && (wb_dat_i == $past(wb_dat_i)));
endproperty
assert property(af_p742);

property af_p743;
@(posedge wb_clk_i) ($past(wb_ack_o) && (wb_cti_i == 3'b000)) |-> (wb_addr_i == $past(wb_addr_i));
endproperty
assert property(af_p743);

property af_p744;
@(posedge wb_clk_i) ($past(wb_ack_o)) |-> (wb_addr_i != $past(wb_addr_i, 2));
endproperty
assert property(af_p744);

property af_p745;
@(posedge wb_clk_i) (wb_cyc_i && (wb_cti_i == 3'b010)) |-> (wb_addr_i == $past(wb_addr_i));
endproperty
assert property(af_p745);

property af_p746;
@(posedge wb_clk_i) (1) |-> (wb_addr_i < (1 << cfg_colbits));
endproperty
assert property(af_p746);

property af_p747;
@(posedge wb_clk_i) (wb_cyc_i && wb_ack_o) |-> ##1 (wb_addr_i != $past(wb_addr_i));
endproperty
assert property(af_p747);

property af_p748;
@(posedge wb_clk_i) (wb_rst_i) |-> (wb_addr_i == $past(wb_addr_i));
endproperty
assert property(af_p748);

property af_p749;
@(posedge wb_clk_i) (wb_addr_i != $past(wb_addr_i)) |-> (wb_ack_o == 0) || (wb_stb_i && wb_cyc_i);
endproperty
assert property(af_p749);

property af_p750;
@(posedge wb_clk_i) (wb_ack_o) |-> (wb_addr_i == $past(wb_addr_i));
endproperty
assert property(af_p750);


property af_p752;
@(posedge wb_clk_i) (wb_rst_i) |-> (wb_addr_i === wb_addr_i);
endproperty
assert property(af_p752);

property af_p753;
@(posedge wb_clk_i) (wb_cyc_i && !wb_rst_i) |-> (!$isunknown(wb_addr_i));
endproperty
assert property(af_p753);

property af_p754;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> ((wb_we_i && !$isunknown(wb_addr_i)) || (!wb_we_i && !$isunknown(wb_addr_i)));
endproperty
assert property(af_p754);

property af_p755;
@(posedge wb_clk_i) (!wb_cyc_i) |-> (wb_addr_i === wb_addr_i);
endproperty
assert property(af_p755);

property af_p756;
@(posedge wb_clk_i) (!sdr_init_done) |-> (!wb_ack_o);
endproperty
assert property(af_p756);

property af_p757;
@(posedge wb_clk_i) (wb_cyc_i && (wb_sel_i != 4'b1111)) |-> (!$isunknown(wb_addr_i[1:0]));
endproperty
assert property(af_p757);

property af_p758;
@(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |-> $stable(wb_addr_i);
endproperty
assert property(af_p758);

property af_p759;
@(posedge wb_clk_i) (!wb_cyc_i) |-> ($stable(sdr_cs_n) && $stable(sdr_ras_n));
endproperty
assert property(af_p759);

property af_p760;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && !wb_ack_o) |-> $stable(wb_addr_i);
endproperty
assert property(af_p760);

property af_p761;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 (!$isunknown(wb_addr_i));
endproperty
assert property(af_p761);

property af_p762;
@(posedge wb_clk_i) (!$isunknown(wb_addr_i) && !$isunknown(cfg_colbits)) |=> (!$isunknown(sdr_addr));
endproperty
assert property(af_p762);

property af_p763;
@(posedge wb_clk_i) (!wb_cyc_i) |-> (1'b1);
endproperty
assert property(af_p763);

property af_p764;
@(posedge wb_clk_i) (wb_stb_i) |-> (!$isunknown(wb_addr_i)) && ((cfg_sdr_width == 8'd8) || (cfg_sdr_width == 8'd16) || (cfg_sdr_width == 8'd32));
endproperty
assert property(af_p764);

property af_p765;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##2 (!$isunknown(wb_addr_i));
endproperty
assert property(af_p765);

property af_p766;
@(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |-> (wb_addr_i === $past(wb_addr_i)) throughout (##[0:$] wb_ack_o);
endproperty
assert property(af_p766);

property af_p767;
@(posedge wb_clk_i) disable iff (wb_rst_i) (wb_cyc_i) |-> $stable(wb_addr_i);
endproperty
assert property(af_p767);

property af_p768;
@(posedge wb_clk_i) (wb_we_i && wb_stb_i) |-> (!$isunknown(wb_addr_i) && !$isunknown(wb_dat_i));
endproperty
assert property(af_p768);

property af_p769;
@(posedge wb_clk_i) (wb_rst_i) |-> (!wb_cyc_i || $isunknown(wb_addr_i) || 1'b1);
endproperty
assert property(af_p769);

property af_p770;
@(posedge wb_clk_i) (wb_cti_i == 3'b010) && wb_ack_o |=> (wb_addr_i == ($past(wb_addr_i) + 1));
endproperty
assert property(af_p770);

property af_p771;
@(posedge wb_clk_i) !(wb_stb_i && wb_cyc_i) |-> $stable(wb_addr_i);
endproperty
assert property(af_p771);

property af_p772;
@(posedge wb_clk_i) wb_rst_i |-> ##1 (wb_ack_o == 1'b0) && (wb_dat_o == '0);
endproperty
assert property(af_p772);

property af_p773;
@(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |-> ##1 wb_ack_o;
endproperty
assert property(af_p773);

property af_p774;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_we_i) |=> wb_ack_o;
endproperty
assert property(af_p774);

property af_p775;
@(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |=> $stable(wb_addr_i) && $stable(wb_we_i);
endproperty
assert property(af_p775);

property af_p776;
@(posedge wb_clk_i) disable iff (wb_rst_i) 1'b1 |-> ##0 $stable(wb_ack_o) || 1'b1;
endproperty
assert property(af_p776);

property af_p777;
@(posedge wb_clk_i) 1'b1 |-> $stable(wb_cti_i) || $changed(wb_cti_i);
endproperty
assert property(af_p777);

property af_p778;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:$] sdr_init_done;
endproperty
assert property(af_p778);


property af_p780;
@(posedge wb_clk_i) ($past(wb_cyc_i) && $past(wb_stb_i) && !wb_we_i) |-> $changed(wb_dat_o);
endproperty
assert property(af_p780);

property af_p781;
@(posedge wb_clk_i) wb_ack_o |-> (wb_stb_i && wb_cyc_i);
endproperty
assert property(af_p781);

property af_p782;
@(posedge wb_clk_i) (wb_we_i && wb_stb_i && wb_cyc_i) |-> ##1 $stable(wb_dat_i) || 1'b1;
endproperty
assert property(af_p782);

property af_p783;
@(posedge wb_clk_i) $rose(sdr_init_done) |-> ($past(wb_rst_i, 1) == 0) && ($past(!wb_rst_i, 4));
endproperty
assert property(af_p783);

property af_p784;
@(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |-> $stable(wb_sel_i) throughout (wb_stb_i && wb_cyc_i);
endproperty
assert property(af_p784);

property af_p785;
@(posedge wb_clk_i) (!$stable(wb_clk_i, @(negedge wb_clk_i))) |-> $stable(wb_ack_o);
endproperty
assert property(af_p785);

property af_p786;
@(posedge wb_clk_i) (wb_rst_i !== $past(wb_rst_i)) |-> $stable(wb_rst_i, @(posedge wb_clk_i));
endproperty
assert property(af_p786);

property af_p787;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && !wb_ack_o) |=> ($stable(wb_addr_i) || wb_ack_o) throughout (wb_cyc_i && wb_stb_i)[->1];
endproperty
assert property(af_p787);

property af_p788;
@(posedge wb_clk_i) !(wb_stb_i && wb_cyc_i) |-> $stable(wb_dat_o);
endproperty
assert property(af_p788);



property af_p791;
@(posedge wb_clk_i) (sdr_init_done !== $past(sdr_init_done)) |-> $stable(sdr_init_done, @(posedge wb_clk_i));
endproperty
assert property(af_p791);

property af_p792;
@(posedge wb_clk_i) (wb_we_i) |-> (wb_dat_i inside {[32'h0000_0000:32'hFFFF_FFFF]});
endproperty
assert property(af_p792);

property af_p793;
@(posedge wb_clk_i) 1'b1 |-> $stable({sdr_cke, sdr_cs_n, sdr_ras_n, sdr_cas_n, sdr_we_n}) or $changed({sdr_cke, sdr_cs_n, sdr_ras_n, sdr_cas_n, sdr_we_n});
endproperty
assert property(af_p793);

property af_p794;
@(posedge wb_clk_i) ($fell(wb_cyc_i) || $fell(wb_stb_i)) |-> ##1 (wb_ack_o == 1'b0);
endproperty
assert property(af_p794);

property af_p795;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] $stable(wb_cti_i);
endproperty
assert property(af_p795);

property af_p796;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 (wb_stb_i && wb_cyc_i) |-> 1'b1;
endproperty
assert property(af_p796);

property af_p797;
@(posedge wb_clk_i) $changed(cfg_sdr_en) |-> ##1 (cfg_sdr_en == $past(cfg_sdr_en));
endproperty
assert property(af_p797);

property af_p798;
@(posedge wb_clk_i) (!(wb_cyc_i && wb_stb_i)) |-> $stable(wb_dat_o);
endproperty
assert property(af_p798);


property af_p800;
@(posedge wb_clk_i) (wb_rst_i) |-> ##[0:1] (wb_ack_o == 1'b0);
endproperty
assert property(af_p800);

property af_p801;
@(posedge wb_clk_i) (wb_ack_o) |-> (wb_stb_i && wb_cyc_i);
endproperty
assert property(af_p801);

property af_p802;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |=> ((wb_cti_i >= 3'd0) && (wb_cti_i <= 3'd7));
endproperty
assert property(af_p802);

property af_p803;
@(posedge wb_clk_i) disable iff (!wb_cyc_i) (wb_cti_i == $past(wb_cti_i)) || (wb_cti_i != $past(wb_cti_i));
endproperty
assert property(af_p803);

property af_p804;
@(posedge wb_clk_i) (wb_cti_i == 3'b010 && wb_cyc_i) |=> (wb_addr_i == ($past(wb_addr_i) + 1));
endproperty
assert property(af_p804);

property af_p805;
@(posedge wb_clk_i) (wb_rst_i) |-> (wb_cti_i == 3'b000);
endproperty
assert property(af_p805);

property af_p806;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> (wb_cti_i == $past(wb_cti_i));
endproperty
assert property(af_p806);

property af_p807;
@(posedge wb_clk_i) (wb_rst_i) |=> ((wb_cti_i >= 3'd0) && (wb_cti_i <= 3'd0));
endproperty
assert property(af_p807);

property af_p808;
@(posedge wb_clk_i) (wb_cyc_i) |-> ((wb_cti_i == $past(wb_cti_i)) throughout wb_cyc_i);
endproperty
assert property(af_p808);

property af_p809;
@(posedge sdram_clk) (wb_cti_i == 3'b010) |-> (sdram_clk === 1'b1 || sdram_clk === 1'b0);
endproperty
assert property(af_p809);

property af_p810;
@(posedge wb_clk_i) (wb_cti_i == 3'b010 && wb_cyc_i && wb_stb_i) |=> (wb_ack_o == 1'b1);
endproperty
assert property(af_p810);

property af_p811;
@(posedge wb_clk_i) ((wb_cti_i >= 3'd2) && (wb_cti_i <= 3'd2)) |=> ((wb_cti_i >= 3'd0) && (wb_cti_i <= 3'd7));
endproperty
assert property(af_p811);

property af_p812;
@(posedge wb_clk_i) (cfg_sdr_en) |-> ((wb_cti_i == $past(wb_cti_i)) || (sdr_cas_n !== sdr_ras_n));
endproperty
assert property(af_p812);

property af_p813;
@(posedge wb_clk_i) (wb_cyc_i) |-> $stable(wb_cti_i);
endproperty
assert property(af_p813);

property af_p814;
@(posedge wb_clk_i) ((wb_cti_i >= 0) && (wb_cti_i <= 7)) |=> ((wb_cti_i >= 0) && (wb_cti_i <= 7));
endproperty
assert property(af_p814);

property af_p815;
@(posedge wb_clk_i) (wb_cti_i inside {[0:1]}) |-> (wb_ack_o -> (wb_cyc_i && wb_stb_i));
endproperty
assert property(af_p815);

property af_p816;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##3 ((wb_cti_i >= 0) && (wb_cti_i <= 7));
endproperty
assert property(af_p816);

property af_p817;
@(posedge wb_clk_i) (wb_cti_i == 3'b001 && wb_cyc_i) |=> $stable(wb_addr_i);
endproperty
assert property(af_p817);

property af_p818;
@(posedge wb_clk_i) (wb_rst_i) |=> (wb_cti_i == 3'b000);
endproperty
assert property(af_p818);

property af_p819;
@(posedge wb_clk_i) (wb_cti_i == 3'b000 && wb_stb_i) |-> ##[1:3] wb_ack_o;
endproperty
assert property(af_p819);

property af_p820;
@(posedge wb_clk_i) (wb_cyc_i ##1 !wb_cyc_i) |-> (wb_cti_i == 3'b111);
endproperty
assert property(af_p820);

property af_p821;
@(posedge wb_clk_i) (!wb_stb_i) |-> !wb_ack_o;
endproperty
assert property(af_p821);

property af_p822;
@(posedge wb_clk_i) (wb_cti_i inside {[0:7]} && wb_we_i) |=> $stable(wb_addr_i);
endproperty
assert property(af_p822);

property af_p823;
@(posedge wb_clk_i) (wb_cti_i == 3'b000) |=> $stable(wb_addr_i);
endproperty
assert property(af_p823);

property af_p824;
@(posedge wb_clk_i) (wb_cti_i == 3'b111) |=> !wb_stb_i;
endproperty
assert property(af_p824);

property af_p825;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> (wb_cti_i inside {[3'b000:3'b111]});
endproperty
assert property(af_p825);

property af_p826;
@(posedge wb_clk_i) (wb_cyc_i) |-> ##[1:$] (wb_cti_i == 3'b111);
endproperty
assert property(af_p826);

property af_p827;
@(posedge wb_clk_i) (wb_cyc_i) |-> (wb_cti_i inside {[0:7]});
endproperty
assert property(af_p827);

property af_p828;
@(posedge wb_clk_i) (!wb_rst_i) |-> (wb_cti_i >= 0 && wb_cti_i <= 7);
endproperty
assert property(af_p828);

property af_p829;
@(posedge wb_clk_i) (wb_we_i && (wb_cti_i inside {[0:7]})) |-> ##[1:$] (sdr_dq == wb_dat_i);
endproperty
assert property(af_p829);

property af_p830;
@(posedge wb_clk_i) (wb_cyc_i) |-> (wb_cti_i inside {[0:7]})[*2];
endproperty
assert property(af_p830);

property af_p831;
@(posedge wb_clk_i) (!wb_cyc_i) |-> (wb_cti_i == 3'b000);
endproperty
assert property(af_p831);

property af_p832;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (wb_cti_i inside {[0:7]});
endproperty
assert property(af_p832);

property af_p833;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> $stable(wb_cti_i);
endproperty
assert property(af_p833);

property af_p834;
@(posedge wb_clk_i) (wb_rst_i) |-> (!wb_ack_o);
endproperty
assert property(af_p834);

property af_p835;
@(posedge wb_clk_i) (wb_stb_i) |-> (wb_cyc_i);
endproperty
assert property(af_p835);

property af_p836;
@(posedge wb_clk_i) ($fell(wb_cyc_i) && (wb_cti_i != 3'b111)) |-> (!wb_ack_o);
endproperty
assert property(af_p836);

property af_p837;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_we_i) |-> ##[1:16] wb_ack_o;
endproperty
assert property(af_p837);

property af_p838;
@(posedge wb_clk_i) ($rose(wb_cyc_i)) |-> ($stable(wb_cyc_i) || wb_cyc_i);
endproperty
assert property(af_p838);

property af_p839;
@(posedge wb_clk_i) (!wb_cyc_i) |-> $stable(wb_dat_o);
endproperty
assert property(af_p839);

property af_p840;
@(posedge wb_clk_i) (!wb_cyc_i) |-> (!wb_ack_o);
endproperty
assert property(af_p840);

property af_p841;
@(posedge wb_clk_i) (!wb_cyc_i) |=> (!wb_ack_o);
endproperty
assert property(af_p841);

property af_p842;
@(posedge wb_clk_i) (wb_cyc_i && (wb_cti_i != 3'b111)) |-> (wb_cyc_i until_with wb_ack_o);
endproperty
assert property(af_p842);

property af_p843;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && !wb_ack_o) |=> ($stable(wb_addr_i) until_with wb_ack_o);
endproperty
assert property(af_p843);

property af_p844;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && !wb_we_i && wb_ack_o) |-> (!$isunknown(wb_dat_o));
endproperty
assert property(af_p844);

property af_p845;
@(posedge wb_clk_i) (wb_we_i) |-> ($stable(wb_cyc_i));
endproperty
assert property(af_p845);

property af_p846;
@(posedge wb_clk_i) ($rose(wb_cyc_i)) |=> (wb_stb_i);
endproperty
assert property(af_p846);



property af_p849;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> (wb_cyc_i && wb_stb_i);
endproperty
assert property(af_p849);

property af_p850;
@(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |-> wb_cyc_i throughout (wb_stb_i[->1] ##0 wb_ack_o[->1]);
endproperty
assert property(af_p850);

property af_p851;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_we_i) |-> (wb_we_i);
endproperty
assert property(af_p851);

property af_p852;
@(posedge wb_clk_i) (wb_ack_o) |-> ($past(wb_cyc_i, 1));
endproperty
assert property(af_p852);

property af_p853;
@(posedge wb_clk_i) (wb_cyc_i throughout ($rose(wb_stb_i) ##1 $fell(wb_stb_i) ##1 $rose(wb_stb_i))) |-> (wb_cyc_i);
endproperty
assert property(af_p853);

property af_p854;
@(posedge wb_clk_i) (wb_cyc_i && !wb_stb_i) |-> (!wb_ack_o);
endproperty
assert property(af_p854);

property af_p855;
@(posedge wb_clk_i) ($past(wb_rst_i) && !wb_rst_i) |-> ##1 (wb_cyc_i === 1'b1);
endproperty
assert property(af_p855);

property af_p856;
@(posedge wb_clk_i) $fell(wb_cyc_i) |=> $stable(wb_dat_o);
endproperty
assert property(af_p856);

property af_p857;
@(posedge wb_clk_i) wb_cyc_i |-> (wb_cyc_i throughout (##[0:$] wb_ack_o));
endproperty
assert property(af_p857);

property af_p858;
@(posedge wb_clk_i) !wb_rst_i |-> (wb_cyc_i === 1'b0 || wb_cyc_i === 1'b1);
endproperty
assert property(af_p858);

property af_p859;
@(posedge wb_clk_i) $rose(wb_cyc_i) |=> ($stable(wb_cyc_i) ##1 wb_stb_i);
endproperty
assert property(af_p859);

property af_p860;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 wb_cyc_i;
endproperty
assert property(af_p860);

property af_p861;
@(posedge wb_clk_i) wb_rst_i |-> !wb_ack_o;
endproperty
assert property(af_p861);

property af_p862;
@(posedge wb_clk_i) wb_rst_i |-> !wb_cyc_i;
endproperty
assert property(af_p862);

property af_p863;
@(posedge wb_clk_i) wb_stb_i |-> (wb_cyc_i throughout (##[0:$] wb_ack_o));
endproperty
assert property(af_p863);

property af_p864;
@(posedge wb_clk_i) (wb_cyc_i && (wb_dat_i >= 500) && (wb_dat_i <= 600)) |=> (wb_ack_o |-> (wb_dat_i >= 0 && wb_dat_i <= 32'hFFFFFFFF));
endproperty
assert property(af_p864);

property af_p865;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (wb_sel_i == 4'b0001) |-> (wb_dat_i >= 0 && wb_dat_i <= 255);
endproperty
assert property(af_p865);

property af_p866;
@(posedge wb_clk_i) (wb_stb_i && wb_cyc_i && wb_we_i && (wb_dat_i >= 0) && (wb_dat_i <= 65535)) |-> ($stable(wb_dat_i) throughout (##[0:$] wb_ack_o));
endproperty
assert property(af_p866);

property af_p867;
@(posedge wb_clk_i) (!$isunknown(wb_dat_i) && (wb_sel_i == 4'b1111) && wb_we_i) |=> wb_ack_o;
endproperty
assert property(af_p867);

property af_p868;
@(posedge wb_clk_i) (!wb_we_i && wb_cyc_i) |-> 1'b1;
endproperty
assert property(af_p868);

property af_p869;
@(posedge wb_clk_i) (wb_rst_i) |-> 1'b1;
endproperty
assert property(af_p869);

property af_p870;
@(posedge wb_clk_i) (wb_sel_i == 4'b0011) |-> (!$isunknown(wb_dat_i[15:0]));
endproperty
assert property(af_p870);

property af_p871;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && (wb_dat_i >= 1000) && (wb_dat_i <= 2000)) |=> ((wb_dat_i >= 900) && (wb_dat_i <= 2000));
endproperty
assert property(af_p871);

property af_p872;
@(posedge wb_clk_i) ((wb_cti_i != 3'b000) && $stable(wb_cti_i)) |-> $stable(wb_dat_i);
endproperty
assert property(af_p872);

property af_p873;
@(posedge wb_clk_i) (!wb_we_i) |-> 1'b1;
endproperty
assert property(af_p873);

property af_p874;
@(posedge wb_clk_i) ((wb_dat_i >= 200) && (wb_dat_i <= 255) && wb_we_i) |=> ((wb_dat_i >= 180) && (wb_dat_i <= 255));
endproperty
assert property(af_p874);

property af_p875;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((wb_dat_i >= 0) && (wb_dat_i <= 65535));
endproperty
assert property(af_p875);

property af_p876;
@(posedge wb_clk_i) (wb_we_i && wb_stb_i && wb_cyc_i && (wb_dat_i >= 0) && (wb_dat_i <= 65535)) |-> ((wb_dat_i >= 0) && (wb_dat_i <= 65535));
endproperty
assert property(af_p876);

property af_p877;
@(posedge wb_clk_i) (wb_cti_i == 3'b010 && wb_stb_i && wb_cyc_i && wb_we_i) |-> !$isunknown(wb_dat_i);
endproperty
assert property(af_p877);

property af_p878;
@(posedge wb_clk_i) (wb_we_i && (wb_dat_i >= 1000) && (wb_dat_i <= 2000)) |=> (wb_ack_o -> (($past(wb_dat_i,1) >= 1000) && ($past(wb_dat_i,1) <= 2000)));
endproperty
assert property(af_p878);

property af_p879;
@(posedge wb_clk_i) (!wb_we_i && wb_stb_i && wb_cyc_i) |-> 1'b1;
endproperty
assert property(af_p879);

property af_p880;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((wb_dat_i >= 0) && (wb_dat_i <= 32'hFFFFFFFF));
endproperty
assert property(af_p880);

property af_p881;
@(posedge wb_clk_i) ($past(wb_rst_i,4) && !wb_rst_i) |-> (wb_dat_i >= 0 && wb_dat_i <= 1048575);
endproperty
assert property(af_p881);

property af_p882;
@(posedge wb_clk_i) (!wb_rst_i) |-> (wb_dat_i >= 0 && wb_dat_i <= 4294967295);
endproperty
assert property(af_p882);

property af_p883;
@(posedge wb_clk_i) (wb_cti_i != 3'b000) |-> (wb_dat_i == $past(wb_dat_i)) throughout (!wb_ack_o)[*1:$];
endproperty
assert property(af_p883);

property af_p884;
@(posedge wb_clk_i) (wb_stb_i && wb_cyc_i && wb_we_i && (wb_dat_i >= 1000 && wb_dat_i <= 2000)) |=> (wb_dat_i >= 500 && wb_dat_i <= 3000) throughout (!wb_ack_o)[*1:$];
endproperty
assert property(af_p884);

property af_p885;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_we_i) |-> (wb_dat_i >= 0 && wb_dat_i <= 4294967295) && $stable(wb_dat_i);
endproperty
assert property(af_p885);

property af_p886;
@(posedge wb_clk_i) (wb_stb_i && wb_we_i) |-> (wb_dat_i === wb_dat_i);
endproperty
assert property(af_p886);

property af_p887;
@(posedge wb_clk_i) disable iff (wb_rst_i) ($past(wb_rst_i,2) && !wb_rst_i && wb_stb_i && wb_addr_i inside {[0:$]}) |-> (wb_dat_i >= 0 && wb_dat_i <= 4294967295);
endproperty
assert property(af_p887);

property af_p888;
@(posedge wb_clk_i) (wb_cti_i == 3'b010 && wb_ack_o) |-> ($isunknown(wb_dat_o) == 0);
endproperty
assert property(af_p888);

property af_p889;
@(posedge wb_clk_i) (wb_stb_i && wb_cyc_i && !wb_we_i && wb_ack_o) |-> ($isunknown(wb_dat_o) == 0);
endproperty
assert property(af_p889);

property af_p890;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> (wb_dat_o == 32'b0);
endproperty
assert property(af_p890);

property af_p891;
@(posedge wb_clk_i) (!wb_ack_o) |-> ($stable(wb_dat_o));
endproperty
assert property(af_p891);

property af_p892;
@(posedge wb_clk_i) (wb_we_i) |-> ($stable(wb_dat_o));
endproperty
assert property(af_p892);

property af_p893;
@(posedge wb_clk_i) (|wb_sel_i) |-> ($isunknown(wb_dat_o) == 0);
endproperty
assert property(af_p893);

property af_p894;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:3] ($isunknown(wb_dat_o) == 0);
endproperty
assert property(af_p894);

property af_p895;
@(posedge wb_clk_i) (wb_we_i) |-> (wb_dat_o != wb_dat_i || $stable(wb_dat_o));
endproperty
assert property(af_p895);

property af_p896;
@(posedge wb_clk_i) (wb_ack_o) |-> (wb_dat_o == $past(wb_addr_i));
endproperty
assert property(af_p896);

property af_p897;
@(posedge wb_clk_i) (wb_stb_i && wb_cyc_i && !wb_we_i) ##1 wb_ack_o |-> !$isunknown(wb_dat_o);
endproperty
assert property(af_p897);

property af_p898;
@(posedge wb_clk_i) $rose(wb_ack_o) |-> !$isunknown(wb_dat_o);
endproperty
assert property(af_p898);

property af_p899;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && !wb_we_i ##1 wb_ack_o) |-> !$isunknown(wb_dat_o);
endproperty
assert property(af_p899);

property af_p900;
@(posedge wb_clk_i) (!(wb_cyc_i && wb_stb_i)) |-> ($stable(wb_dat_o));
endproperty
assert property(af_p900);

property af_p901;
@(posedge wb_clk_i) (wb_cti_i && wb_ack_o) |-> !$isunknown(wb_dat_o);
endproperty
assert property(af_p901);

property af_p902;
@(posedge wb_clk_i) $rose(sdr_init_done) |-> ##4 !$isunknown(wb_dat_o);
endproperty
assert property(af_p902);

property af_p903;
@(posedge wb_clk_i) (sdr_init_done && wb_cyc_i && wb_stb_i && !wb_we_i && wb_ack_o) |-> (wb_dat_o == sdr_dq);
endproperty
assert property(af_p903);

property af_p904;
@(posedge wb_clk_i) (wb_stb_i && wb_cyc_i && !wb_we_i) |-> ##1 !$isunknown(wb_dat_o);
endproperty
assert property(af_p904);

property af_p905;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 (wb_dat_o >= 32'h0 && wb_dat_o <= 32'hFFFFFFFF);
endproperty
assert property(af_p905);

property af_p906;
@(posedge wb_clk_i) (!wb_ack_o) |=> $stable(wb_dat_o);
endproperty
assert property(af_p906);

property af_p907;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && !wb_we_i && wb_ack_o) |-> !$isunknown(wb_dat_o);
endproperty
assert property(af_p907);

property af_p908;
@(posedge wb_clk_i) (wb_cti_i == 3'b010 && wb_ack_o) |=> !$isunknown(wb_dat_o);
endproperty
assert property(af_p908);

property af_p909;
@(posedge wb_clk_i) (wb_rst_i) |-> (wb_dat_o == 32'h0);
endproperty
assert property(af_p909);

property af_p910;
@(posedge wb_clk_i) (!wb_cyc_i) |=> $stable(wb_dat_o);
endproperty
assert property(af_p910);

property af_p911;
@(posedge wb_clk_i) $fell(wb_stb_i) |=> $stable(wb_dat_o);
endproperty
assert property(af_p911);

property af_p912;
@(posedge wb_clk_i) wb_ack_o |-> ((wb_sel_i[0] || (wb_dat_o[7:0] == $past(wb_dat_o[7:0]))) && (wb_sel_i[1] || (wb_dat_o[15:8] == $past(wb_dat_o[15:8]))) && (wb_sel_i[2] || (wb_dat_o[23:16] == $past(wb_dat_o[23:16]))) && (wb_sel_i[3] || (wb_dat_o[31:24] == $past(wb_dat_o[31:24]))));
endproperty
assert property(af_p912);

property af_p913;
@(posedge wb_clk_i) (wb_rst_i) |=> (wb_dat_o == 32'h0);
endproperty
assert property(af_p913);

property af_p914;
@(posedge wb_clk_i) ($past(wb_ack_o) && !wb_ack_o) |-> $stable(wb_dat_o);
endproperty
assert property(af_p914);

property af_p915;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> ##[0:1] (wb_cyc_i && wb_stb_i) |-> 1'b1;
endproperty
assert property(af_p915);

property af_p916;
@(posedge wb_clk_i) (wb_rst_i) |-> ($isunknown(wb_dat_o) == 0);
endproperty
assert property(af_p916);

property af_p917;
@(posedge wb_clk_i) (wb_rst_i) |-> (wb_dat_o == '0);
endproperty
assert property(af_p917);

property af_p918;
@(posedge wb_clk_i) (!wb_rst_i) |-> ($stable(wb_cyc_i) && $stable(wb_stb_i)) or (wb_cyc_i && wb_stb_i);
endproperty
assert property(af_p918);

property af_p919;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (wb_ack_o == 1'b0) throughout ((wb_cyc_i && wb_stb_i)[->1]);
endproperty
assert property(af_p919);

property af_p920;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> (sdr_we_n && sdr_cas_n && sdr_ras_n);
endproperty
assert property(af_p920);

property af_p921;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (sdr_cke == 1'b1);
endproperty
assert property(af_p921);

property af_p922;
@(posedge wb_clk_i) (wb_rst_i) |-> (sdr_cke == 1'b0);
endproperty
assert property(af_p922);

property af_p923;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!(wb_cyc_i && wb_stb_i) throughout (wb_addr_i)[->1]) or 1'b1;
endproperty
assert property(af_p923);

property af_p924;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> (sdr_cke == 1'b0);
endproperty
assert property(af_p924);

property af_p925;
@(posedge wb_clk_i) (wb_rst_i) |-> (wb_ack_o == 1'b0);
endproperty
assert property(af_p925);

property af_p926;
@(posedge wb_clk_i) (wb_rst_i && wb_cyc_i) |-> !wb_ack_o;
endproperty
assert property(af_p926);

property af_p927;
@(posedge wb_clk_i) (wb_rst_i) |=> !wb_ack_o;
endproperty
assert property(af_p927);

property af_p928;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> sdr_cs_n;
endproperty
assert property(af_p928);

property af_p929;
@(posedge wb_clk_i) (wb_rst_i[*1]) |=> (wb_dat_o == 32'b0);
endproperty
assert property(af_p929);

property af_p930;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> wb_rst_i[*1] ##1 1;
endproperty
assert property(af_p930);

property af_p931;
@(posedge wb_clk_i) (wb_rst_i) |-> $stable(wb_dat_o);
endproperty
assert property(af_p931);

property af_p932;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> !sdr_init_done[*3];
endproperty
assert property(af_p932);

property af_p933;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (wb_dat_o == 32'b0);
endproperty
assert property(af_p933);

property af_p934;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> wb_rst_i[*1];
endproperty
assert property(af_p934);

property af_p935;
@(posedge wb_clk_i) (wb_rst_i && wb_cyc_i && wb_stb_i) |-> !wb_ack_o;
endproperty
assert property(af_p935);

property af_p936;
@(posedge wb_clk_i) (wb_rst_i) |-> (!wb_ack_o);
endproperty
assert property(af_p936);


property af_p938;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> (!sdr_init_done)[*3:$] ##1 sdr_init_done;
endproperty
assert property(af_p938);

property af_p939;
@(posedge wb_clk_i) (wb_rst_i) |-> (!wb_cyc_i);
endproperty
assert property(af_p939);

property af_p940;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> (!sdr_init_done throughout wb_rst_i[->1]);
endproperty
assert property(af_p940);

property af_p941;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> (sdr_cs_n);
endproperty
assert property(af_p941);

property af_p942;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!wb_ack_o throughout (!(wb_stb_i && wb_cyc_i))[->1]);
endproperty
assert property(af_p942);

property af_p943;
@(posedge wb_clk_i) (wb_rst_i && wb_stb_i && wb_we_i) |-> (!wb_ack_o);
endproperty
assert property(af_p943);

property af_p944;
@(posedge wb_clk_i) (wb_rst_i) |-> (!sdr_cke);
endproperty
assert property(af_p944);

property af_p945;
@(posedge wb_clk_i) (wb_rst_i) |=> (wb_dat_o == 32'b0);
endproperty
assert property(af_p945);

property af_p946;
@(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |-> (wb_sel_i >= 0 && wb_sel_i <= 15);
endproperty
assert property(af_p946);


property af_p948;
@(posedge wb_clk_i) (wb_cyc_i && (wb_sel_i inside {[8:15]})) |=> (!wb_cyc_i || (wb_sel_i inside {[4:15]}));
endproperty
assert property(af_p948);

property af_p949;
@(posedge wb_clk_i) (wb_sel_i == 4'b1111 && wb_we_i && wb_cyc_i) |=> (!$isunknown(wb_dat_i));
endproperty
assert property(af_p949);

property af_p950;
@(posedge wb_clk_i) (wb_stb_i && wb_we_i) |-> (wb_sel_i != 0 && wb_sel_i inside {[1:15]});
endproperty
assert property(af_p950);

property af_p951;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (wb_sel_i inside {[0:15]})[*4];
endproperty
assert property(af_p951);

property af_p952;
@(posedge wb_clk_i) (wb_cyc_i && !wb_stb_i) |-> ($stable(wb_sel_i) && (wb_sel_i inside {[0:15]}));
endproperty
assert property(af_p952);

property af_p953;
@(posedge wb_clk_i) (wb_rst_i) |-> (wb_sel_i >= 0 && wb_sel_i <= 15);
endproperty
assert property(af_p953);

property af_p954;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (wb_sel_i >= 0 && wb_sel_i <= 15);
endproperty
assert property(af_p954);

property af_p955;
@(posedge wb_clk_i) (wb_stb_i && $changed(wb_sel_i)) |=> (wb_dat_o == (wb_dat_o & {{8{wb_sel_i[3]}}, {8{wb_sel_i[2]}}, {8{wb_sel_i[1]}}, {8{wb_sel_i[0]}}}));
endproperty
assert property(af_p955);

property af_p956;
@(posedge wb_clk_i) (wb_ack_o && $past(wb_we_i) && $past(wb_stb_i)) |-> ($past(wb_sel_i) >= 1 && $past(wb_sel_i) <= 15);
endproperty
assert property(af_p956);

property af_p957;
@(posedge wb_clk_i) (wb_we_i && wb_cyc_i) |-> ((wb_sel_i >= 0 && wb_sel_i <= 15) && $stable(wb_sel_i));
endproperty
assert property(af_p957);

property af_p958;
@(posedge wb_clk_i) (!wb_cyc_i) |-> (!wb_ack_o);
endproperty
assert property(af_p958);

property af_p959;
@(posedge wb_clk_i) (wb_we_i && wb_cyc_i && wb_stb_i) |-> (wb_sel_i >= 1 && wb_sel_i <= 15);
endproperty
assert property(af_p959);

property af_p960;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((wb_sel_i >= 0) && (wb_sel_i <= 15));
endproperty
assert property(af_p960);

property af_p961;
@(posedge wb_clk_i) ((wb_sel_i >= 1) && (wb_sel_i <= 15)) |-> (wb_stb_i);
endproperty
assert property(af_p961);

property af_p962;
@(posedge wb_clk_i) ($past(wb_sel_i >= 0 && wb_sel_i <= 7) && $past(!wb_cyc_i) && wb_cyc_i) |-> (wb_sel_i >= 0 && wb_sel_i <= 15);
endproperty
assert property(af_p962);

property af_p963;
@(posedge wb_clk_i) $rose(wb_stb_i) |-> ((wb_sel_i >= 0) && (wb_sel_i <= 15)) throughout (##[1:$] wb_ack_o);
endproperty
assert property(af_p963);

property af_p964;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> (wb_sel_i >= 0 && wb_sel_i <= 15);
endproperty
assert property(af_p964);

property af_p965;
@(posedge wb_clk_i) (!wb_we_i) |-> !($stable(wb_dat_i) && $changed(wb_sel_i));
endproperty
assert property(af_p965);

property af_p966;
@(posedge wb_clk_i) wb_ack_o |-> (wb_stb_i && wb_cyc_i);
endproperty
assert property(af_p966);

property af_p967;
@(posedge wb_clk_i) disable iff (wb_rst_i) (wb_stb_i && wb_cyc_i) |-> ##[1:4] wb_ack_o;
endproperty
assert property(af_p967);

property af_p968;
@(posedge wb_clk_i) (wb_stb_i && !wb_cyc_i) |-> !wb_ack_o;
endproperty
assert property(af_p968);

property af_p969;
@(posedge wb_clk_i) (wb_cyc_i && !$stable(wb_stb_i)) |=> !wb_ack_o;
endproperty
assert property(af_p969);

property af_p970;
@(posedge wb_clk_i) (wb_stb_i && wb_we_i) |-> !$isunknown(wb_dat_i);
endproperty
assert property(af_p970);

property af_p971;
@(posedge wb_clk_i) (wb_stb_i && wb_cyc_i && wb_ack_o) |=> (!wb_ack_o throughout (wb_stb_i[*1:$] ##1 !wb_stb_i));
endproperty
assert property(af_p971);

property af_p972;
@(posedge wb_clk_i) disable iff (wb_rst_i) (wb_stb_i && wb_addr_i inside {[32'h0000_0000:32'hFFFF_FFFF]} && sdr_init_done) |-> ##[1:8] !$isunknown(wb_dat_o);
endproperty
assert property(af_p972);

property af_p973;
@(posedge wb_clk_i) wb_stb_i |-> !$isunknown(wb_addr_i);
endproperty
assert property(af_p973);

property af_p974;
@(posedge wb_clk_i) ((!wb_cyc_i) && ($rose(wb_stb_i) || $fell(wb_stb_i))) |-> !wb_ack_o;
endproperty
assert property(af_p974);

property af_p975;
@(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |-> (!$isunknown(wb_we_i) && !$isunknown(wb_addr_i) && !$isunknown(wb_sel_i));
endproperty
assert property(af_p975);

property af_p976;
@(posedge wb_clk_i) (wb_cyc_i && $fell(wb_stb_i)) |=> ($stable(wb_ack_o) until wb_stb_i);
endproperty
assert property(af_p976);

property af_p977;
@(posedge wb_clk_i) (!wb_stb_i && !wb_cyc_i) |-> !wb_ack_o;
endproperty
assert property(af_p977);

property af_p978;
@(posedge wb_clk_i) (wb_stb_i && (wb_cti_i == 3'b000)) |-> ##1 !wb_stb_i;
endproperty
assert property(af_p978);

property af_p979;
@(posedge wb_clk_i) wb_rst_i |-> !wb_stb_i;
endproperty
assert property(af_p979);

property af_p980;
@(posedge wb_clk_i) (wb_stb_i && wb_we_i) |=> ($past(wb_dat_i) == wb_dat_i);
endproperty
assert property(af_p980);

property af_p981;
@(posedge wb_clk_i) (wb_stb_i && wb_we_i && (wb_sel_i != 4'b0000)) |=> ($past(wb_dat_i) == wb_dat_i);
endproperty
assert property(af_p981);

property af_p982;
@(posedge wb_clk_i) (wb_stb_i) |-> (wb_we_i == $past(wb_we_i)) until_with (wb_ack_o);
endproperty
assert property(af_p982);

property af_p983;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> !wb_stb_i;
endproperty
assert property(af_p983);

property af_p984;
@(posedge wb_clk_i) (wb_stb_i && !wb_cyc_i) |-> ##1 (!wb_ack_o && (wb_dat_o == $past(wb_dat_o)));
endproperty
assert property(af_p984);

property af_p985;
@(posedge wb_clk_i) (wb_stb_i && wb_cyc_i) |-> ##[1:1] wb_ack_o;
endproperty
assert property(af_p985);

property af_p986;
@(posedge wb_clk_i) $rose(wb_ack_o) |=> !wb_stb_i;
endproperty
assert property(af_p986);

property af_p987;
@(posedge wb_clk_i) (wb_stb_i && wb_cyc_i && (wb_cti_i != 3'b010)) |=> wb_ack_o;
endproperty
assert property(af_p987);

property af_p988;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[0:2] $rose(wb_stb_i) |-> !wb_ack_o;
endproperty
assert property(af_p988);

property af_p989;
@(posedge wb_clk_i) !wb_stb_i |-> ##1 !wb_ack_o;
endproperty
assert property(af_p989);

property af_p990;
@(posedge wb_clk_i) (wb_stb_i && (wb_cti_i == 3'b010)) |=> wb_ack_o;
endproperty
assert property(af_p990);


property af_p992;
@(posedge wb_clk_i) (wb_stb_i && !wb_cyc_i) |-> $stable(wb_dat_o);
endproperty
assert property(af_p992);

property af_p993;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> !wb_stb_i ##1 !wb_stb_i;
endproperty
assert property(af_p993);

property af_p994;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (wb_stb_i || !wb_stb_i);
endproperty
assert property(af_p994);

property af_p995;
@(posedge wb_clk_i) ($fell(wb_stb_i) && $past(wb_ack_o)) |=> !wb_ack_o;
endproperty
assert property(af_p995);

property af_p996;
@(posedge wb_clk_i) wb_stb_i |-> wb_cyc_i;
endproperty
assert property(af_p996);

property af_p997;
@(posedge wb_clk_i) wb_stb_i |-> (wb_sel_i != 4'b0000);
endproperty
assert property(af_p997);

property af_p998;
@(posedge wb_clk_i) (wb_we_i && wb_cyc_i && wb_stb_i) |-> ($stable(wb_addr_i) throughout (wb_cyc_i && wb_stb_i)[->1] ##0 wb_ack_o);
endproperty
assert property(af_p998);

property af_p999;
@(posedge wb_clk_i) (wb_we_i && (wb_sel_i != 4'b0000)) |-> ##1 $stable(wb_dat_i);
endproperty
assert property(af_p999);

property af_p1000;
@(posedge wb_clk_i) (wb_we_i && (wb_sel_i != 4'b0000)) |-> (sdr_we_n == 1'b0);
endproperty
assert property(af_p1000);

property af_p1001;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> ($stable(wb_we_i) throughout (wb_cyc_i && wb_stb_i)[->1] ##0 wb_ack_o);
endproperty
assert property(af_p1001);

property af_p1002;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_we_i) |-> ($stable(wb_we_i) throughout (wb_cyc_i && wb_stb_i)[->1] ##0 wb_ack_o);
endproperty
assert property(af_p1002);

property af_p1003;
@(posedge wb_clk_i) (wb_we_i && wb_cyc_i && wb_stb_i) |-> ##1 $stable(wb_dat_i);
endproperty
assert property(af_p1003);

property af_p1004;
@(posedge wb_clk_i) (!wb_cyc_i) |-> not ($changed(wb_we_i) ##0 (wb_cyc_i == 0));
endproperty
assert property(af_p1004);

property af_p1005;
@(posedge wb_clk_i) (wb_we_i && wb_cyc_i && (wb_cti_i == 3'b010)) |-> (wb_we_i throughout (wb_cti_i == 3'b010)[->1] ##0 wb_ack_o);
endproperty
assert property(af_p1005);

property af_p1006;
@(posedge wb_clk_i) (wb_we_i) |-> (wb_sel_i != 4'b0000) ##0 (wb_dat_i !== 'x);
endproperty
assert property(af_p1006);

property af_p1007;
@(posedge wb_we_i) disable iff (wb_rst_i) (wb_cyc_i && wb_stb_i) |-> $stable(wb_we_i) throughout (wb_cyc_i[*1:$] ##0 wb_ack_o);
endproperty
assert property(af_p1007);

property af_p1008;
@(posedge wb_clk_i) (wb_we_i && wb_cyc_i && wb_stb_i) |-> (wb_dat_i !== 'x);
endproperty
assert property(af_p1008);

property af_p1009;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && !wb_ack_o) |-> $stable(wb_we_i);
endproperty
assert property(af_p1009);

property af_p1010;
@(posedge wb_clk_i) wb_rst_i |-> ##1 wb_rst_i;
endproperty
assert property(af_p1010);

property af_p1011;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!wb_we_i ##1 !wb_we_i);
endproperty
assert property(af_p1011);

property af_p1012;
@(posedge wb_clk_i) (!wb_cyc_i) |-> (sdr_we_n == 1'b1);
endproperty
assert property(af_p1012);

property af_p1013;
@(posedge wb_clk_i) (!wb_we_i && wb_cyc_i && wb_stb_i && wb_ack_o) |-> (wb_dat_o !== 32'bx);
endproperty
assert property(af_p1013);

property af_p1014;
@(posedge wb_clk_i) (wb_we_i && !wb_cyc_i && !wb_stb_i) |-> !wb_ack_o;
endproperty
assert property(af_p1014);

property af_p1015;
@(posedge wb_clk_i) (wb_cyc_i && !wb_ack_o) |-> ##1 $stable(wb_we_i);
endproperty
assert property(af_p1015);

property af_p1016;
@(posedge wb_clk_i) $changed(wb_we_i) |-> (wb_cyc_i && wb_stb_i);
endproperty
assert property(af_p1016);

property af_p1017;
@(posedge wb_clk_i) (!wb_we_i && wb_ack_o) |-> (wb_dat_o !== 32'bx);
endproperty
assert property(af_p1017);

property af_p1018;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && !wb_we_i && wb_ack_o) |-> !$isunknown(wb_dat_o);
endproperty
assert property(af_p1018);

property af_p1019;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!wb_we_i ##1 !wb_we_i);
endproperty
assert property(af_p1019);

property af_p1020;
@(posedge wb_clk_i) (wb_we_i && wb_stb_i && wb_cyc_i) |-> ##[1:$] (wb_ack_o && wb_we_i && wb_stb_i && wb_cyc_i);
endproperty
assert property(af_p1020);

property af_p1021;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> !$isunknown(wb_we_i);
endproperty
assert property(af_p1021);

property af_p1022;
@(posedge wb_clk_i) (wb_ack_o) |-> (wb_cyc_i && wb_stb_i);
endproperty
assert property(af_p1022);

property af_p1023;
@(posedge wb_clk_i) (!wb_stb_i) |-> $stable(wb_we_i);
endproperty
assert property(af_p1023);

property af_p1024;
@(posedge wb_clk_i) (wb_cyc_i && (wb_cti_i != 3'b111)) |-> $stable(wb_we_i);
endproperty
assert property(af_p1024);

property af_p1025;
@(posedge wb_clk_i) (wb_rst_i) |-> (wb_we_i === 1'b0);
endproperty
assert property(af_p1025);

