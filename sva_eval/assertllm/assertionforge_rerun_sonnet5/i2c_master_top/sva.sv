// AssertionForge baseline SVA for i2c
// 426 assertions captured from gen_plan.generate_svas

property af_p0;
@(posedge wb_clk_i) $rose(arst_i) |=> (wb_dat_o !== 8'h00);
endproperty
assert property(af_p0);

property af_p1;
@(posedge wb_clk_i or negedge arst_i) (wb_cyc_i && !arst_i) |-> (wb_dat_o == 8'h00);
endproperty
assert property(af_p1);

property af_p2;
@(posedge wb_clk_i) (!arst_i) |-> (wb_dat_o == 8'h00);
endproperty
assert property(af_p2);

property af_p3;
@(posedge wb_clk_i or negedge arst_i) (!arst_i) |-> (wb_ack_o == 1'b0);
endproperty
assert property(af_p3);

property af_p4;
@(posedge wb_clk_i or negedge arst_i) (!arst_i) |-> (scl_padoen_o == 1'b1) && (sda_padoen_o == 1'b1);
endproperty
assert property(af_p4);

property af_p5;
@(posedge wb_clk_i or negedge arst_i) (!arst_i) |-> (wb_dat_o == 8'h00);
endproperty
assert property(af_p5);

property af_p6;
@(posedge wb_clk_i) $rose(arst_i) |-> ##1 (sda_padoen_o == 1'b1);
endproperty
assert property(af_p6);

property af_p7;
@(posedge wb_clk_i) (!arst_i && wb_cyc_i) |-> (wb_dat_o == 8'h00);
endproperty
assert property(af_p7);

property af_p8;
@(posedge wb_clk_i) (!arst_i) |-> ($stable(wb_dat_o));
endproperty
assert property(af_p8);

property af_p9;
@(posedge wb_clk_i) ($rose(arst_i)) |=> (wb_dat_o == wb_dat_i);
endproperty
assert property(af_p9);

property af_p10;
@(posedge wb_clk_i) (!arst_i) |-> ($stable(wb_dat_o) && !$isunknown(wb_adr_i));
endproperty
assert property(af_p10);

property af_p11;
@(posedge wb_clk_i) (arst_i) |-> (wb_dat_o == wb_dat_i);
endproperty
assert property(af_p11);

property af_p12;
@(posedge wb_clk_i) ($rose(arst_i)) |=> (wb_dat_o !== 8'h00);
endproperty
assert property(af_p12);

property af_p13;
@(posedge wb_clk_i) (!arst_i) |-> $stable(wb_dat_o);
endproperty
assert property(af_p13);

property af_p14;
@(posedge wb_clk_i) (!arst_i && wb_cyc_i) |-> (wb_dat_o == 8'b0);
endproperty
assert property(af_p14);

property af_p15;
@(posedge wb_clk_i) $rose(arst_i) |=> (wb_dat_o == 8'b0);
endproperty
assert property(af_p15);

property af_p16;
@(posedge wb_clk_i) (!arst_i) |=> (wb_dat_o == $past(wb_dat_o));
endproperty
assert property(af_p16);

property af_p17;
@(posedge wb_clk_i) $rose(arst_i) |=> (wb_adr_i == $past(wb_adr_i));
endproperty
assert property(af_p17);

property af_p18;
@(posedge wb_clk_i) $rose(arst_i) |=> (wb_cyc_i == $past(wb_cyc_i));
endproperty
assert property(af_p18);

property af_p19;
@(posedge wb_clk_i) (!arst_i) |-> (wb_dat_o == 8'b0);
endproperty
assert property(af_p19);

property af_p20;
@(posedge wb_clk_i) (arst_i) |=> (wb_dat_o == $past(wb_dat_i));
endproperty
assert property(af_p20);


































property af_p54;
@(posedge wb_clk_i) ($past(arst_i,4) == 1'b0) |-> ((wb_dat_i >= 0) && (wb_dat_i <= 255));
endproperty
assert property(af_p54);

property af_p55;
@(posedge wb_clk_i) (wb_cyc_i) |-> ##2 ((sda_pad_i == 1'b0) || (sda_pad_i == 1'b1));
endproperty
assert property(af_p55);











property af_p66;
@(posedge wb_clk_i) ((wb_adr_i >= 4) && (wb_adr_i <= 7)) |=> (wb_adr_i >= 0) && (wb_adr_i <= 7);
endproperty
assert property(af_p66);

property af_p67;
@(posedge wb_clk_i) (!arst_i) |-> (wb_dat_i >= 0) && (wb_dat_i <= 255);
endproperty
assert property(af_p67);

property af_p68;
@(posedge wb_clk_i) (wb_cyc_i) |-> $stable(wb_dat_i);
endproperty
assert property(af_p68);








































property af_p108;
@(posedge wb_clk_i) (arst_i) |=> (sda_padoen_o == 1'b0);
endproperty
assert property(af_p108);

property af_p109;
@(posedge wb_clk_i) ($changed(wb_dat_i)) |=> (sda_padoen_o == $past(sda_padoen_o) || $changed(sda_padoen_o));
endproperty
assert property(af_p109);

property af_p110;
@(posedge wb_clk_i) (arst_i) |=> (wb_dat_o == 8'b0);
endproperty
assert property(af_p110);

property af_p111;
@(posedge wb_clk_i) (wb_cyc_i && wb_we_i && (wb_adr_i == wb_adr_i)) |=> (wb_dat_o == $past(wb_dat_i));
endproperty
assert property(af_p111);

property af_p112;
@(posedge wb_clk_i) (!wb_cyc_i) |-> ##[1:$] (!wb_cyc_i throughout $stable(wb_dat_o));
endproperty
assert property(af_p112);

property af_p113;
@(posedge wb_clk_i) (!wb_cyc_i) |=> $stable(wb_dat_o);
endproperty
assert property(af_p113);

property af_p114;
@(posedge wb_clk_i) disable iff (arst_i) (1'b1) |-> !$isunknown(wb_dat_o);
endproperty
assert property(af_p114);

property af_p115;
@(posedge wb_clk_i) disable iff (arst_i) (!$changed(wb_clk_i)) |-> $stable(wb_dat_o);
endproperty
assert property(af_p115);

property af_p116;
@(posedge wb_clk_i) (arst_i) |-> (scl_padoen_o == 1'b1) && (sda_padoen_o == 1'b1);
endproperty
assert property(af_p116);



property af_p119;
@(posedge wb_clk_i) (wb_dat_o >= 0 && wb_dat_o <= 255);
endproperty
assert property(af_p119);

property af_p120;
@(posedge wb_clk_i) (wb_cyc_i) |-> ##[1:2] (wb_dat_o >= 0 && wb_dat_o <= 255);
endproperty
assert property(af_p120);


property af_p122;
@(posedge wb_clk_i) ($fell(arst_i)) |-> ##[1:4] (wb_dat_o >= 0 && wb_dat_o <= 127);
endproperty
assert property(af_p122);

property af_p123;
@(posedge wb_clk_i) ((wb_dat_i >= 100) && (wb_dat_i <= 200)) |=> ((wb_dat_o >= 90) && (wb_dat_o <= 210));
endproperty
assert property(af_p123);

property af_p124;
@(posedge wb_clk_i) ($fell(arst_i)) |-> ##3 (wb_dat_o >= 0 && wb_dat_o <= 255);
endproperty
assert property(af_p124);

property af_p125;
@(posedge wb_clk_i) (wb_cyc_i && (wb_adr_i inside {[0:7]})) |=> (wb_dat_o >= 0 && wb_dat_o <= 255);
endproperty
assert property(af_p125);

property af_p126;
@(posedge wb_clk_i) (wb_cyc_i) |-> ($past(scl_padoen_o) != scl_padoen_o) |-> (scl_padoen_o != $past(scl_padoen_o, 2));
endproperty
assert property(af_p126);


property af_p128;
@(posedge wb_clk_i) ($changed(scl_padoen_o) && $changed(sda_padoen_o)) |-> $changed(wb_adr_i);
endproperty
assert property(af_p128);






property af_p134;
@(posedge wb_clk_i) $fell(arst_i) |=> scl_padoen_o;
endproperty
assert property(af_p134);



property af_p137;
@(posedge wb_clk_i) wb_cyc_i |-> ((scl_padoen_o == 1'b0) || (scl_padoen_o == 1'b1));
endproperty
assert property(af_p137);

property af_p138;
@(posedge arst_i) ##1 (scl_pad_i == 1'b1);
endproperty
assert property(af_p138);

property af_p139;
@(posedge wb_clk_i) (wb_dat_i != $past(wb_dat_i) || wb_adr_i != $past(wb_adr_i)) |-> (scl_pad_i == $past(scl_pad_i));
endproperty
assert property(af_p139);

property af_p140;
@(posedge wb_clk_i) $stable(scl_padoen_o) |-> $stable(scl_pad_i);
endproperty
assert property(af_p140);

property af_p141;
@(posedge scl_pad_i or negedge scl_pad_i) ((!scl_padoen_o) && (!sda_padoen_o)) |-> (scl_pad_i == 1'b1);
endproperty
assert property(af_p141);

property af_p142;
@(posedge wb_clk_i) $stable(scl_pad_i) || (scl_pad_i !== $past(scl_pad_i));
endproperty
assert property(af_p142);

property af_p143;
@(posedge wb_clk_i) (!wb_cyc_i) |-> (scl_pad_i == $past(scl_pad_i));
endproperty
assert property(af_p143);

property af_p144;
@(posedge wb_clk_i) $changed(scl_padoen_o) |-> ##1 $stable(scl_pad_i);
endproperty
assert property(af_p144);

property af_p145;
@(posedge wb_clk_i) (wb_cyc_i) |-> (scl_pad_i == $past(scl_pad_i, 1)) or (scl_pad_i !== 1'bx);
endproperty
assert property(af_p145);

property af_p146;
@(posedge wb_clk_i) (scl_padoen_o == $past(scl_padoen_o)) |-> (scl_pad_i == $past(scl_pad_i));
endproperty
assert property(af_p146);

property af_p147;
@(posedge wb_clk_i) (!scl_padoen_o) |-> ##1 (scl_pad_i == $past(scl_pad_i));
endproperty
assert property(af_p147);

property af_p148;
@(posedge wb_clk_i) $fell(arst_i) |-> ##1 (scl_pad_i === 1'b0 || scl_pad_i === 1'b1);
endproperty
assert property(af_p148);

property af_p149;
@(posedge wb_clk_i) (arst_i) |-> $stable(scl_pad_i);
endproperty
assert property(af_p149);

property af_p150;
@(posedge wb_clk_i) $fell(arst_i) |-> ##[1:2] (scl_pad_i === 1'b1);
endproperty
assert property(af_p150);

property af_p151;
@(posedge wb_clk_i) 1'b1 |-> (scl_pad_i === $past(scl_pad_i)) || $changed(scl_pad_i);
endproperty
assert property(af_p151);

property af_p152;
@(posedge wb_clk_i) (scl_padoen_o === 1'b0) |-> (scl_pad_i === scl_pad_o);
endproperty
assert property(af_p152);

property af_p153;
@(posedge wb_clk_i) $fell(scl_padoen_o) |-> ##1 (scl_pad_i === scl_pad_o);
endproperty
assert property(af_p153);

property af_p154;
@(posedge wb_clk_i) $rose(arst_i) |-> ##[1:2] (scl_pad_i === 1'b0 || scl_pad_i === 1'b1);
endproperty
assert property(af_p154);

property af_p155;
@(posedge wb_clk_i) $fell(scl_pad_i) |-> (scl_padoen_o === 1'b0);
endproperty
assert property(af_p155);

property af_p156;
@(posedge wb_clk_i) (arst_i) |-> (scl_pad_i === 1'b0);
endproperty
assert property(af_p156);


property af_p158;
@(posedge wb_clk_i) (scl_padoen_o) |-> ##[1:$] (scl_pad_i === 1'b0);
endproperty
assert property(af_p158);

property af_p159;
@(posedge wb_clk_i) (1'b1) |-> ##1 (scl_pad_i != $past(scl_pad_i)) || (wb_cyc_i || !wb_cyc_i);
endproperty
assert property(af_p159);

property af_p160;
@(posedge wb_clk_i) (scl_padoen_o) |-> (scl_pad_i == 1'b1);
endproperty
assert property(af_p160);

property af_p161;
@(posedge wb_clk_i) (1'b1) |-> ($past(scl_pad_i) == scl_pad_i) == ($past(sda_pad_i) == sda_pad_i);
endproperty
assert property(af_p161);

property af_p162;
@(posedge wb_clk_i) ($past(scl_pad_i) == 1'b0) |-> (scl_pad_i == 1'b0);
endproperty
assert property(af_p162);

property af_p163;
@(posedge wb_clk_i) $changed(wb_dat_o) |-> $stable(scl_pad_i);
endproperty
assert property(af_p163);

property af_p164;
@(posedge wb_clk_i) $stable(scl_pad_i) |-> ##1 (scl_pad_i == $past(scl_pad_i)) or (1'b1);
endproperty
assert property(af_p164);

property af_p165;
@(posedge wb_clk_i) $fell(arst_i) |-> ##[1:3] (scl_pad_i == 1'b1);
endproperty
assert property(af_p165);

property af_p166;
@(posedge wb_clk_i) (scl_padoen_o == 1'b1) |-> (scl_pad_i !== 1'bz && scl_pad_i == $past(scl_pad_i));
endproperty
assert property(af_p166);

property af_p167;
@(posedge wb_clk_i) (wb_cyc_i && $rose(scl_padoen_o) == 1'b0 && $past(scl_padoen_o) == 1'b1) |-> ##1 (scl_pad_i == 1'b0);
endproperty
assert property(af_p167);

property af_p168;
@(posedge wb_clk_i) (scl_pad_i !== scl_padoen_o) |=> (scl_padoen_o == 1'b1);
endproperty
assert property(af_p168);

property af_p169;
@(posedge arst_i) (1'b1) |-> (scl_padoen_o == 1'b1);
endproperty
assert property(af_p169);

property af_p170;
@(posedge wb_clk_i) arst_i |-> (scl_padoen_o == 1'b1) until wb_cyc_i;
endproperty
assert property(af_p170);

property af_p171;
@(posedge wb_clk_i) (wb_cyc_i && $changed(wb_dat_i)) |=> ##[1:2] $changed(scl_padoen_o);
endproperty
assert property(af_p171);


property af_p173;
@(posedge wb_clk_i) $fell(wb_cyc_i) |=> $stable(scl_padoen_o);
endproperty
assert property(af_p173);

property af_p174;
@(posedge wb_clk_i) arst_i |-> (scl_padoen_o == 1'b1) throughout (arst_i)[*1:$];
endproperty
assert property(af_p174);



property af_p177;
@(posedge wb_clk_i) arst_i |-> ##[1:4] (scl_padoen_o == 1'b1);
endproperty
assert property(af_p177);

property af_p178;
@(posedge wb_clk_i) wb_cyc_i |-> (scl_padoen_o !== sda_padoen_o || scl_padoen_o === sda_padoen_o);
endproperty
assert property(af_p178);

property af_p179;
@(posedge wb_clk_i) $rose(arst_i) |-> (scl_padoen_o == 1'b1) [*2];
endproperty
assert property(af_p179);

property af_p180;
@(posedge wb_clk_i) $fell(arst_i) |-> ##1 (scl_padoen_o == 1'b1);
endproperty
assert property(af_p180);

property af_p181;
@(posedge wb_clk_i) $changed(wb_adr_i) && (wb_adr_i == 4'h2) |=> $changed(scl_padoen_o);
endproperty
assert property(af_p181);

property af_p182;
@(posedge wb_clk_i) $fell(wb_cyc_i) |-> ##[1:2] (scl_padoen_o == 1'b1);
endproperty
assert property(af_p182);

property af_p183;
@(posedge wb_cyc_i or negedge wb_cyc_i) (!wb_cyc_i) |-> $stable(scl_padoen_o);
endproperty
assert property(af_p183);

property af_p184;
@(posedge wb_clk_i) (!wb_cyc_i) |-> $stable(scl_padoen_o);
endproperty
assert property(af_p184);

property af_p185;
@(posedge wb_clk_i) arst_i |-> $stable(scl_padoen_o);
endproperty
assert property(af_p185);

property af_p186;
@(posedge wb_clk_i) disable iff (wb_cyc_i) $stable(scl_padoen_o);
endproperty
assert property(af_p186);

property af_p187;
@(posedge wb_clk_i) (scl_padoen_o === 1'b0 || scl_padoen_o === 1'b1);
endproperty
assert property(af_p187);

property af_p188;
@(posedge wb_clk_i) (!(wb_adr_i == 4'h4) && !$stable(wb_dat_i) == 0) |-> $stable(scl_padoen_o);
endproperty
assert property(af_p188);

property af_p189;
@(posedge wb_clk_i) $fell(arst_i) |-> ##[1:4] (scl_padoen_o === 1'b0 || scl_padoen_o === 1'b1);
endproperty
assert property(af_p189);

property af_p190;
@(posedge wb_clk_i) $changed(scl_padoen_o) |-> ($past(wb_cyc_i) && $changed(wb_dat_i));
endproperty
assert property(af_p190);

property af_p191;
@(posedge wb_clk_i) (wb_cyc_i && wb_dat_i[7]) |-> ##[1:4] $fell(scl_padoen_o);
endproperty
assert property(af_p191);

property af_p192;
@(posedge wb_clk_i) (scl_padoen_o == 1'b1) |=> (scl_pad_i == 1'b1);
endproperty
assert property(af_p192);

property af_p193;
@(posedge wb_clk_i) (scl_padoen_o == 1'b0) |=> (scl_pad_i == 1'b0);
endproperty
assert property(af_p193);

property af_p194;
@(posedge wb_clk_i) $fell(sda_padoen_o) |-> (scl_padoen_o == 1'b1);
endproperty
assert property(af_p194);

property af_p195;
@(posedge wb_clk_i) (arst_i) |-> (scl_padoen_o == 1'b1);
endproperty
assert property(af_p195);

property af_p196;
@(posedge wb_clk_i) !(scl_padoen_o == 1'b0 && sda_padoen_o == 1'b0);
endproperty
assert property(af_p196);

property af_p197;
@(posedge wb_clk_i) $stable(wb_dat_i) |-> $stable(scl_padoen_o);
endproperty
assert property(af_p197);

property af_p198;
@(posedge wb_clk_i) disable iff (arst_i) (sda_padoen_o) |-> ##1 (1'b1);
endproperty
assert property(af_p198);

property af_p199;
@(posedge wb_clk_i) disable iff (arst_i) (sda_padoen_o && !sda_pad_i) |-> ##1 (sda_pad_i == $past(sda_pad_i)) ##1 (sda_pad_i == $past(sda_pad_i, 2));
endproperty
assert property(af_p199);

property af_p200;
@(posedge wb_clk_i) disable iff (arst_i) (scl_pad_i && $fell(sda_pad_i)) |-> ##1 (scl_pad_i && !sda_pad_i);
endproperty
assert property(af_p200);

property af_p201;
@(posedge wb_clk_i) ($fell(arst_i)) |-> ##1 (sda_pad_i === 1'b0 || sda_pad_i === 1'b1);
endproperty
assert property(af_p201);

property af_p202;
@(posedge wb_clk_i) disable iff (arst_i) (wb_cyc_i && wb_we_i && (wb_adr_i == 3'h3)) |-> ##1 (sda_pad_i == wb_dat_i[0]);
endproperty
assert property(af_p202);

property af_p203;
@(posedge wb_clk_i) disable iff (arst_i) ($rose(arst_i) == 0 && $past(arst_i)) |-> ##[1:4] (sda_pad_i === 1'b0 || sda_pad_i === 1'b1)[*4];
endproperty
assert property(af_p203);

property af_p204;
@(posedge wb_clk_i) disable iff (arst_i) (scl_padoen_o) |-> (sda_pad_i == $past(sda_pad_i));
endproperty
assert property(af_p204);

property af_p205;
@(posedge wb_clk_i) disable iff (arst_i) (scl_pad_i) |-> (sda_pad_i == $past(sda_pad_i));
endproperty
assert property(af_p205);

property af_p206;
@(posedge wb_clk_i) disable iff (arst_i) (1) |-> (sda_pad_i === 1'b0 || sda_pad_i === 1'b1);
endproperty
assert property(af_p206);

property af_p207;
@(posedge wb_clk_i) disable iff (arst_i) (scl_pad_i && $past(scl_pad_i)) |-> (sda_pad_i == $past(sda_pad_i));
endproperty
assert property(af_p207);

property af_p208;
@(posedge wb_clk_i) $rose(arst_i) |-> ##[1:2] (sda_pad_i == 1'b1);
endproperty
assert property(af_p208);

property af_p209;
@(posedge wb_clk_i) (wb_cyc_i) |=> (wb_dat_o[0] === $past(sda_pad_i));
endproperty
assert property(af_p209);

property af_p210;
@(posedge wb_clk_i) (scl_pad_i && $fell(sda_pad_i)) |=> (scl_pad_i && !sda_pad_i);
endproperty
assert property(af_p210);

property af_p211;
@(posedge wb_clk_i) (!wb_cyc_i && (wb_adr_i == '0)) |-> $stable(sda_pad_i);
endproperty
assert property(af_p211);

property af_p212;
@(posedge wb_clk_i) (!sda_padoen_o) |-> $stable(sda_pad_i);
endproperty
assert property(af_p212);

property af_p213;
@(posedge wb_clk_i) $rose(arst_i) |-> ##2 (sda_pad_i === 1'b0 || sda_pad_i === 1'b1);
endproperty
assert property(af_p213);

property af_p214;
@(posedge wb_clk_i) (scl_pad_i && $rose(sda_pad_i)) |=> (scl_pad_i && sda_pad_i);
endproperty
assert property(af_p214);

property af_p215;
@(posedge wb_clk_i) (!sda_padoen_o) |=> (sda_pad_i === $past(sda_pad_i));
endproperty
assert property(af_p215);

property af_p216;
@(posedge wb_clk_i) (arst_i) |-> (sda_pad_i === 1'b0 || sda_pad_i === 1'b1);
endproperty
assert property(af_p216);

property af_p217;
@(posedge wb_clk_i) (!arst_i) |-> (sda_pad_i === 1'b0 || sda_pad_i === 1'b1);
endproperty
assert property(af_p217);

property af_p218;
@(posedge wb_clk_i) ($changed(scl_pad_i)) |=> ($stable(sda_pad_i) || $changed(sda_pad_i));
endproperty
assert property(af_p218);

property af_p219;
@(posedge wb_clk_i) 1'b1 |-> (sda_pad_i === 1'b0 || sda_pad_i === 1'b1);
endproperty
assert property(af_p219);

property af_p220;
@(posedge wb_clk_i) ($past(scl_pad_i,1) && scl_pad_i && $rose(sda_pad_i)) |=> (scl_pad_i && $stable(sda_pad_i));
endproperty
assert property(af_p220);

property af_p221;
@(posedge wb_clk_i) (sda_padoen_o) |-> ##1 (sda_pad_i === 1'b0 || sda_pad_i === 1'b1);
endproperty
assert property(af_p221);

property af_p222;
@(posedge wb_clk_i) $rose(scl_pad_i) |-> (sda_pad_i === 1'b0 || sda_pad_i === 1'b1);
endproperty
assert property(af_p222);

property af_p223;
@(posedge wb_clk_i) $rose(arst_i) |-> ##3 (sda_pad_i === 1'b0 || sda_pad_i === 1'b1);
endproperty
assert property(af_p223);

property af_p224;
@(posedge wb_clk_i) (scl_pad_i && $past(scl_pad_i)) |-> $stable(sda_pad_i);
endproperty
assert property(af_p224);

property af_p225;
@(posedge wb_clk_i) (!sda_padoen_o) |=> (sda_pad_i === sda_pad_o);
endproperty
assert property(af_p225);

property af_p226;
@(posedge wb_clk_i) $rose(arst_i) |=> (sda_pad_i === 1'b0 || sda_pad_i === 1'b1);
endproperty
assert property(af_p226);

property af_p227;
@(posedge wb_clk_i) (!sda_padoen_o) |-> ##1 (!$isunknown(sda_pad_i));
endproperty
assert property(af_p227);

property af_p228;
@(posedge wb_clk_i) (!$stable(wb_dat_o)) |-> (sda_padoen_o == 1'b1);
endproperty
assert property(af_p228);

property af_p229;
@(posedge arst_i) (sda_padoen_o == 1'b1);
endproperty
assert property(af_p229);

property af_p230;
@(posedge wb_clk_i) !(($fell(sda_padoen_o)) && ($fell(scl_padoen_o)));
endproperty
assert property(af_p230);

property af_p231;
@(posedge wb_clk_i) ($rose(arst_i)) |=> $stable(sda_padoen_o);
endproperty
assert property(af_p231);

property af_p232;
@(posedge wb_clk_i) ($fell(arst_i)) |-> ##[1:3] (!$isunknown(sda_padoen_o));
endproperty
assert property(af_p232);

property af_p233;
@(posedge wb_clk_i) ($fell(wb_dat_o[0])) |=> ##[1:$] (sda_padoen_o == 1'b0);
endproperty
assert property(af_p233);

property af_p234;
@(posedge wb_clk_i) (!wb_cyc_i) |=> $stable(sda_padoen_o);
endproperty
assert property(af_p234);

property af_p235;
@(posedge wb_clk_i) (wb_dat_i[4]) |=> ##[1:5] (sda_padoen_o == 1'b0);
endproperty
assert property(af_p235);

property af_p236;
@(posedge wb_clk_i) (wb_cyc_i && (wb_dat_i == 8'h00)) |=> (sda_padoen_o == 1'b0);
endproperty
assert property(af_p236);

property af_p237;
@(posedge sda_padoen_o) (sda_padoen_o == 1'b0) |-> (sda_pad_i == wb_dat_i[0]);
endproperty
assert property(af_p237);

property af_p238;
@(posedge scl_padoen_o) (1'b1) |-> ##[0:1] (sda_padoen_o !== $past(sda_padoen_o));
endproperty
assert property(af_p238);

property af_p239;
@(posedge wb_clk_i) ($past(sda_padoen_o) && !sda_padoen_o) |-> ($stable(sda_pad_i));
endproperty
assert property(af_p239);

property af_p240;
@(posedge arst_i) (1'b1) |=> ((sda_padoen_o === 1'b1) && (scl_padoen_o === 1'b1));
endproperty
assert property(af_p240);

property af_p241;
@(posedge wb_clk_i) !((sda_padoen_o == 1'b0) && (scl_padoen_o == 1'b0) && ($past(sda_padoen_o) == 1'b1) && ($past(scl_padoen_o) == 1'b1));
endproperty
assert property(af_p241);

property af_p242;
@(posedge wb_clk_i) (sda_padoen_o == 1'b0) |-> (wb_cyc_i == 1'b1);
endproperty
assert property(af_p242);




property af_p246;
@(posedge wb_clk_i) $rose(arst_i) |-> (sda_padoen_o ##1 sda_padoen_o);
endproperty
assert property(af_p246);

property af_p247;
@(posedge wb_clk_i) (!wb_cyc_i) |-> $stable(sda_padoen_o);
endproperty
assert property(af_p247);

property af_p248;
@(posedge wb_clk_i) $fell(arst_i) |-> ##[1:4] (sda_padoen_o == 1'b1);
endproperty
assert property(af_p248);

property af_p249;
@(posedge wb_clk_i) $changed(wb_dat_i) |-> ##[1:4] (sda_padoen_o == 1'b0);
endproperty
assert property(af_p249);

property af_p250;
@(posedge wb_clk_i) $fell(arst_i) |-> (sda_padoen_o == 1'b1);
endproperty
assert property(af_p250);

property af_p251;
@(posedge wb_clk_i) $fell(wb_cyc_i) |-> sda_padoen_o;
endproperty
assert property(af_p251);

property af_p252;
@(posedge wb_clk_i) $rose(arst_i) |-> ##1 (sda_padoen_o == 1'b1);
endproperty
assert property(af_p252);





































property af_p289;
@(posedge wb_clk_i) (wb_cyc_i) |-> ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p289);

property af_p290;
@(posedge wb_clk_i) (wb_cyc_i && $past(wb_cyc_i)) |-> ($stable(wb_adr_i) && (wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p290);

property af_p291;
@(posedge wb_clk_i) (wb_cyc_i && (wb_adr_i >= 0) && (wb_adr_i <= 7)) |=> ($stable(wb_dat_o) || !$isunknown(wb_dat_o));
endproperty
assert property(af_p291);

property af_p292;
@(posedge wb_clk_i) 1'b1 |-> ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p292);

property af_p293;
@(posedge wb_clk_i) ((wb_adr_i >= 4) && (wb_adr_i <= 7)) |=> ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p293);

property af_p294;
@(posedge wb_clk_i) (wb_we_i && (wb_adr_i >= 0) && (wb_adr_i <= 7)) |=> ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p294);

property af_p295;
@(posedge wb_clk_i) (!arst_i) |-> ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p295);

property af_p296;
@(posedge wb_clk_i) ($past(arst_i,4) && !arst_i) |-> ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p296);

property af_p297;
@(posedge wb_clk_i) (wb_adr_i != $past(wb_adr_i)) |-> ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p297);

property af_p298;
@(posedge wb_clk_i) (wb_adr_i >= 0) && (wb_adr_i <= 7);
endproperty
assert property(af_p298);

property af_p299;
@(posedge wb_clk_i) (wb_cyc_i) |-> ($stable(wb_adr_i) && (wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p299);

property af_p300;
@(posedge wb_clk_i) ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p300);

property af_p301;
@(posedge wb_clk_i) (wb_cyc_i) |-> ((wb_adr_i >= 0) && (wb_adr_i <= 7)) [*2];
endproperty
assert property(af_p301);

property af_p302;
@(posedge wb_clk_i) ((wb_adr_i >= 4) && (wb_adr_i <= 7)) |-> ##1 (wb_cyc_i throughout ((wb_dat_i >= 0) && (wb_dat_i <= 255)));
endproperty
assert property(af_p302);

property af_p303;
@(posedge wb_clk_i) ((wb_adr_i >= 2) && (wb_adr_i <= 5)) |-> ##1 ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p303);

property af_p304;
@(posedge wb_clk_i) ($past(arst_i) && !arst_i) |-> ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p304);

property af_p305;
@(posedge wb_clk_i) ((wb_adr_i >= 0) && (wb_adr_i <= 3) && wb_cyc_i) |-> ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p305);

property af_p306;
@(posedge wb_clk_i) ((wb_adr_i >= 4) && (wb_adr_i <= 7)) |-> ##1 ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p306);

property af_p307;
@(posedge wb_clk_i) ((wb_adr_i >= 0) && (wb_adr_i <= 3)) |-> ##1 ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p307);

property af_p308;
@(posedge wb_clk_i) (wb_cyc_i) |-> ##2 ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p308);

property af_p309;
@(posedge wb_clk_i) ($fell(arst_i)) |-> ##[1:2] ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p309);

property af_p310;
@(posedge wb_clk_i) (arst_i || !arst_i) |-> ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p310);

property af_p311;
@(posedge wb_clk_i) ($fell(arst_i)) |-> ##3 ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p311);

property af_p312;
@(posedge wb_clk_i) ($rose(arst_i)) |-> ##1 ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p312);

property af_p313;
@(posedge wb_clk_i) ((wb_adr_i >= 0) && (wb_adr_i <= 7)) |-> ##1 ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p313);

property af_p314;
@(posedge wb_clk_i) (1'b1) |-> (wb_cyc_i === wb_cyc_i);
endproperty
assert property(af_p314);

property af_p315;
@(posedge wb_clk_i) $changed(wb_adr_i) |=> $stable(wb_adr_i);
endproperty
assert property(af_p315);

property af_p316;
@(posedge wb_clk_i) $rose(wb_cyc_i) |-> ##1 (wb_dat_o inside {[8'h00:8'hFF]});
endproperty
assert property(af_p316);

property af_p317;
@(posedge wb_clk_i) (wb_cyc_i) |-> ##1 $stable(wb_adr_i);
endproperty
assert property(af_p317);

property af_p318;
@(posedge wb_clk_i) (wb_cyc_i) |-> ##1 (wb_dat_i == $past(wb_dat_i));
endproperty
assert property(af_p318);

property af_p319;
@(posedge wb_clk_i) $changed(wb_adr_i) |-> $stable(wb_adr_i) until_with $changed(wb_adr_i);
endproperty
assert property(af_p319);

property af_p320;
@(posedge wb_clk_i) (1'b1) |-> ##2 (sda_pad_i == $past(sda_pad_i,2));
endproperty
assert property(af_p320);

property af_p321;
@(posedge wb_clk_i) (1'b1) |=> ($past(wb_clk_i) !== wb_clk_i);
endproperty
assert property(af_p321);

property af_p322;
@(posedge wb_clk_i) (1'b1) |=> $stable(wb_cyc_i) or $changed(wb_cyc_i);
endproperty
assert property(af_p322);

property af_p323;
@(posedge wb_clk_i) disable iff (arst_i) (1'b1) |=> ($past(wb_clk_i) !== wb_clk_i);
endproperty
assert property(af_p323);

property af_p324;
@(posedge wb_clk_i) disable iff(0) 1'b1 |-> ($time - $past($time) == $past($time) - $past($time,2));
endproperty
assert property(af_p324);



property af_p327;
@(posedge wb_clk_i) (1'b1) |-> $stable(wb_cyc_i) throughout (##1 1);
endproperty
assert property(af_p327);

property af_p328;
@(posedge wb_clk_i) (wb_cyc_i) |-> $stable(wb_dat_i) throughout (##1 1);
endproperty
assert property(af_p328);

property af_p329;
@(posedge wb_clk_i) (wb_cyc_i) |-> ##1 $changed(wb_dat_o);
endproperty
assert property(af_p329);

property af_p330;
@(posedge wb_clk_i) (1'b1) |-> ($changed(wb_dat_o) == 1'b0) or ($rose(wb_clk_i));
endproperty
assert property(af_p330);

property af_p331;
@(posedge wb_clk_i) 1'b1 |-> ##1 (wb_clk_i == 1'b0)[*1] ##1 ($rose(wb_clk_i));
endproperty
assert property(af_p331);

property af_p332;
@(posedge wb_clk_i) (arst_i) |-> ##1 (wb_dat_o == '0);
endproperty
assert property(af_p332);

property af_p333;
@(posedge wb_clk_i) ($rose(wb_cyc_i)) |-> (wb_cyc_i throughout (##1 1)) until (!wb_cyc_i);
endproperty
assert property(af_p333);

property af_p334;
@(posedge wb_clk_i) (wb_cyc_i && $changed(wb_dat_i)) |-> ##[1:1] (wb_dat_o == $past(wb_dat_i));
endproperty
assert property(af_p334);

property af_p335;
@(posedge wb_clk_i) 1 |-> ##1 $stable(wb_dat_o);
endproperty
assert property(af_p335);

property af_p336;
@(posedge wb_clk_i) wb_cyc_i |-> (sda_padoen_o === $past(sda_padoen_o)) || (sda_padoen_o !== $past(sda_padoen_o));
endproperty
assert property(af_p336);

property af_p337;
@(posedge wb_clk_i) $fell(arst_i) |-> ##3 (wb_dat_o != 'x && $stable(wb_dat_o));
endproperty
assert property(af_p337);

property af_p338;
@(posedge wb_clk_i) 1 |-> (scl_padoen_o === scl_padoen_o) && (sda_padoen_o === sda_padoen_o);
endproperty
assert property(af_p338);

property af_p339;
@(posedge arst_i) !arst_i |-> ##[1:10] $changed(wb_clk_i)[*10];
endproperty
assert property(af_p339);

property af_p340;
@(posedge wb_clk_i) arst_i |=> (wb_dat_o == '0);
endproperty
assert property(af_p340);

property af_p341;
@(posedge wb_clk_i) wb_cyc_i |-> ##1 (wb_adr_i == $past(wb_adr_i));
endproperty
assert property(af_p341);

property af_p342;
@(posedge wb_clk_i) 1 |-> (scl_pad_i == $past(scl_pad_i,2));
endproperty
assert property(af_p342);

property af_p343;
@(posedge arst_i) 1 |-> ##[1:10] $changed(wb_clk_i) throughout (arst_i == 0)[*10];
endproperty
assert property(af_p343);

property af_p344;
@(posedge wb_clk_i) $fell(arst_i) |-> (wb_dat_o == $past(wb_dat_o)) ##1 (wb_dat_o == $past(wb_dat_o)) ##1 (wb_dat_o != $past(wb_dat_o,2));
endproperty
assert property(af_p344);

property af_p345;
@(posedge wb_clk_i) (!wb_cyc_i) |-> (!wb_ack_o);
endproperty
assert property(af_p345);

property af_p346;
@(posedge wb_clk_i) $changed(wb_cyc_i) |-> !$isunknown(wb_dat_o);
endproperty
assert property(af_p346);

property af_p347;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i) |-> ##2 !$isunknown(wb_dat_o);
endproperty
assert property(af_p347);

property af_p348;
@(posedge wb_clk_i) (wb_cyc_i && $past(wb_cyc_i)) |-> !$isunknown(wb_dat_i);
endproperty
assert property(af_p348);

property af_p349;
@(posedge wb_clk_i) (wb_cyc_i && $past(wb_cyc_i)) |-> wb_ack_o;
endproperty
assert property(af_p349);

property af_p350;
@(posedge wb_clk_i) (wb_cyc_i) |-> $stable(wb_cyc_i);
endproperty
assert property(af_p350);

property af_p351;
@(posedge wb_clk_i) (wb_ack_o) |-> ##1 (!wb_cyc_i);
endproperty
assert property(af_p351);

property af_p352;
@(posedge wb_clk_i) (wb_cyc_i) |-> $stable(wb_adr_i);
endproperty
assert property(af_p352);

property af_p353;
@(posedge wb_clk_i) (wb_cyc_i && $past(wb_cyc_i)) |-> $stable(wb_adr_i);
endproperty
assert property(af_p353);

property af_p354;
@(posedge wb_clk_i) ($fell(arst_i)) |-> (!wb_cyc_i ##1 !wb_cyc_i);
endproperty
assert property(af_p354);

property af_p355;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> !wb_cyc_i;
endproperty
assert property(af_p355);

property af_p356;
@(posedge wb_clk_i) wb_cyc_i[*3] |-> $stable(wb_dat_i);
endproperty
assert property(af_p356);

property af_p357;
@(posedge wb_clk_i) $rose(wb_cyc_i) |=> $stable(wb_dat_o)[*2];
endproperty
assert property(af_p357);

property af_p358;
@(posedge wb_clk_i) $rose(wb_cyc_i) |-> wb_cyc_i[*2] ##1 $changed(wb_dat_o);
endproperty
assert property(af_p358);

property af_p359;
@(posedge wb_clk_i) wb_cyc_i |-> !$isunknown(wb_dat_i);
endproperty
assert property(af_p359);

property af_p360;
@(posedge wb_clk_i) $rose(wb_cyc_i) |-> wb_cyc_i[*2];
endproperty
assert property(af_p360);

property af_p361;
@(posedge wb_clk_i) (!wb_cyc_i) |-> ($stable(wb_adr_i) && $stable(wb_dat_i));
endproperty
assert property(af_p361);

property af_p362;
@(posedge wb_clk_i) (wb_cyc_i === 1'b0) || (wb_cyc_i === 1'b1);
endproperty
assert property(af_p362);

property af_p363;
@(posedge wb_clk_i) wb_cyc_i |-> wb_cyc_i;
endproperty
assert property(af_p363);

property af_p364;
@(posedge wb_clk_i or posedge arst_i) (arst_i) |-> (!wb_cyc_i);
endproperty
assert property(af_p364);

property af_p365;
@(posedge wb_clk_i) (!wb_cyc_i) |-> $stable(wb_dat_o);
endproperty
assert property(af_p365);

property af_p366;
@(posedge wb_clk_i) $rose(arst_i) |=> (wb_cyc_i == 1'b0);
endproperty
assert property(af_p366);

property af_p367;
@(posedge wb_clk_i) $rose(wb_cyc_i) |=> ($stable(wb_adr_i) && $stable(wb_dat_i));
endproperty
assert property(af_p367);

property af_p368;
@(posedge wb_clk_i) !wb_cyc_i |=> $stable(wb_dat_o);
endproperty
assert property(af_p368);

property af_p369;
@(posedge wb_clk_i) (wb_cyc_i && !$isunknown(wb_adr_i)) |-> !$isunknown(wb_adr_i);
endproperty
assert property(af_p369);

property af_p370;
@(posedge wb_clk_i) $rose(wb_cyc_i) |=> wb_cyc_i;
endproperty
assert property(af_p370);

property af_p371;
@(posedge wb_clk_i) $changed(wb_cyc_i) |-> !$isunknown(wb_adr_i);
endproperty
assert property(af_p371);

property af_p372;
@(posedge wb_clk_i) $fell(arst_i) |=> (wb_cyc_i == 1'b0);
endproperty
assert property(af_p372);

property af_p373;
@(posedge wb_clk_i) arst_i |-> (wb_cyc_i == 1'b0);
endproperty
assert property(af_p373);

property af_p374;
@(posedge wb_clk_i) $changed(wb_cyc_i) |=> $stable(wb_cyc_i);
endproperty
assert property(af_p374);

property af_p375;
@(posedge wb_clk_i) $rose(wb_cyc_i) |-> !$isunknown(wb_dat_i);
endproperty
assert property(af_p375);

property af_p376;
@(posedge wb_clk_i) (((wb_dat_i >= 50) && (wb_dat_i <= 75)) && $stable(wb_adr_i)) |=> (((wb_dat_i >= 50) && (wb_dat_i <= 75))[*2]);
endproperty
assert property(af_p376);

property af_p377;
@(posedge wb_clk_i) ((wb_dat_i >= 210) && (wb_dat_i <= 240)) |=> ((wb_dat_i >= 190) && (wb_dat_i <= 255));
endproperty
assert property(af_p377);

property af_p378;
@(posedge wb_clk_i) (wb_cyc_i) |-> ##2 ((wb_dat_i >= 0) && (wb_dat_i <= 255));
endproperty
assert property(af_p378);

property af_p379;
@(posedge wb_clk_i) (wb_cyc_i) |=> (wb_cyc_i && $stable(wb_dat_i));
endproperty
assert property(af_p379);

property af_p380;
@(posedge wb_clk_i) (wb_cyc_i && (wb_dat_i >= 10) && (wb_dat_i <= 20)) |=> (!wb_cyc_i && (wb_dat_i >= 0) && (wb_dat_i <= 40));
endproperty
assert property(af_p380);

property af_p381;
@(posedge wb_clk_i) ((wb_dat_i >= 100) && (wb_dat_i <= 150)) |=> ((wb_dat_i >= 80) && (wb_dat_i <= 175));
endproperty
assert property(af_p381);

property af_p382;
@(posedge wb_clk_i) (wb_cyc_i) |-> ((wb_dat_i >= 0) && (wb_dat_i <= 255));
endproperty
assert property(af_p382);

property af_p383;
@(posedge wb_clk_i) (wb_cyc_i) |=> ((wb_dat_i >= 0) && (wb_dat_i <= 255))[*3];
endproperty
assert property(af_p383);

property af_p384;
@(posedge wb_clk_i) ((wb_dat_i >= 100) && (wb_dat_i <= 150)) |=> ((wb_dat_i >= 80) && (wb_dat_i <= 170));
endproperty
assert property(af_p384);

property af_p385;
@(posedge wb_clk_i) (wb_cyc_i && (wb_dat_i >= 0) && (wb_dat_i <= 255)) |=> $stable(wb_dat_o);
endproperty
assert property(af_p385);

property af_p386;
@(posedge wb_clk_i) (wb_cyc_i && wb_stb_i && wb_we_i) |-> ##1 ($stable(wb_dat_i));
endproperty
assert property(af_p386);

property af_p387;
@(posedge wb_clk_i) (wb_cyc_i) |=> ($stable(wb_dat_i));
endproperty
assert property(af_p387);

property af_p388;
@(posedge wb_clk_i) ((wb_dat_i >= 200) && (wb_dat_i <= 255)) |-> ##1 ((wb_dat_i >= 180) && (wb_dat_i <= 255));
endproperty
assert property(af_p388);

property af_p389;
@(posedge wb_clk_i) ($rose(!arst_i)) |-> ##4 (($stable(wb_dat_i)) && (wb_dat_i >= 0) && (wb_dat_i <= 255));
endproperty
assert property(af_p389);

property af_p390;
@(posedge wb_clk_i) ($rose(!arst_i)) |-> ##3 ((wb_dat_i >= 50) && (wb_dat_i <= 200));
endproperty
assert property(af_p390);

property af_p391;
@(posedge wb_clk_i) ((wb_dat_i >= 0) && (wb_dat_i <= 30)) |-> ##1 ((wb_dat_i >= 0) && (wb_dat_i <= 60));
endproperty
assert property(af_p391);

property af_p392;
@(posedge wb_clk_i) ($rose(wb_cyc_i)) |-> ##2 (($stable(wb_dat_i)) && (wb_dat_i >= 0) && (wb_dat_i <= 255));
endproperty
assert property(af_p392);

property af_p393;
@(posedge wb_clk_i) (!arst_i) |-> ((wb_dat_i >= 0) && (wb_dat_i <= 255));
endproperty
assert property(af_p393);

property af_p394;
@(posedge wb_clk_i) ($rose(!arst_i)) |-> ((wb_dat_i >= 0) && (wb_dat_i <= 255));
endproperty
assert property(af_p394);

property af_p395;
@(posedge wb_clk_i) ($rose(arst_i)) |-> ##3 ((wb_dat_i >= 0) && (wb_dat_i <= 255));
endproperty
assert property(af_p395);

property af_p396;
@(posedge wb_clk_i) ($rose(arst_i)) |-> ##4 ((wb_dat_i >= 0) && (wb_dat_i <= 63));
endproperty
assert property(af_p396);

property af_p397;
@(posedge wb_clk_i) (arst_i) |-> ((wb_dat_i >= 0) && (wb_dat_i <= 255));
endproperty
assert property(af_p397);

property af_p398;
@(posedge wb_clk_i) ($rose(arst_i)) |-> ((wb_dat_i >= 0) && (wb_dat_i <= 255));
endproperty
assert property(af_p398);

property af_p399;
@(posedge wb_clk_i) ((wb_dat_i >= 128) && (wb_dat_i <= 255)) |-> ##1 ((wb_dat_i >= 100) && (wb_dat_i <= 255));
endproperty
assert property(af_p399);

property af_p400;
@(posedge wb_clk_i) ((wb_dat_i >= 0) && (wb_dat_i <= 127)) |-> ##1 ((wb_dat_i >= 0) && (wb_dat_i <= 255));
endproperty
assert property(af_p400);

property af_p401;
@(posedge wb_clk_i) (!arst_i) |-> (wb_dat_i == $past(wb_dat_i));
endproperty
assert property(af_p401);

property af_p402;
@(posedge wb_clk_i) ((wb_dat_o >= 50) && (wb_dat_o <= 100)) |=> ((wb_dat_o >= 0) && (wb_dat_o <= 150));
endproperty
assert property(af_p402);

property af_p403;
@(posedge wb_clk_i) (wb_cyc_i) |-> ##2 ((wb_dat_o >= 0) && (wb_dat_o <= 255));
endproperty
assert property(af_p403);

property af_p404;
@(posedge wb_clk_i) (!wb_cyc_i) |-> ($stable(wb_dat_o) && (wb_dat_o >= 0) && (wb_dat_o <= 255));
endproperty
assert property(af_p404);

property af_p405;
@(posedge wb_clk_i) ((wb_dat_i >= 0) && (wb_dat_i <= 255) && wb_cyc_i) |-> ##[1:2] ((wb_dat_o >= 0) && (wb_dat_o <= 255));
endproperty
assert property(af_p405);

property af_p406;
@(posedge wb_clk_i) ((wb_dat_i >= 100) && (wb_dat_i <= 200)) |-> ##2 ((wb_dat_o >= 0) && (wb_dat_o <= 255));
endproperty
assert property(af_p406);

property af_p407;
@(posedge wb_clk_i) (1'b1) |-> ((wb_dat_o >= 0) && (wb_dat_o <= 255));
endproperty
assert property(af_p407);

property af_p408;
@(posedge wb_clk_i) (($past(wb_adr_i) == wb_adr_i) && (wb_dat_o >= 0) && (wb_dat_o <= 127) && wb_cyc_i) |=> ((wb_dat_o >= 0) && (wb_dat_o <= 127));
endproperty
assert property(af_p408);

property af_p409;
@(posedge wb_clk_i) arst_i |-> ($stable(wb_dat_o) && (wb_dat_o >= 0) && (wb_dat_o <= 255));
endproperty
assert property(af_p409);

property af_p410;
@(posedge wb_clk_i) (wb_cyc_i ##1 wb_cyc_i ##1 wb_cyc_i) |-> ((wb_dat_o >= 0) && (wb_dat_o <= 255))[*3];
endproperty
assert property(af_p410);

property af_p411;
@(posedge wb_clk_i) $fell(arst_i) |-> ##2 ((wb_dat_o >= 0) && (wb_dat_o <= 255));
endproperty
assert property(af_p411);

property af_p412;
@(posedge wb_clk_i) $rose(arst_i) |=> (wb_dat_o == 8'h00);
endproperty
assert property(af_p412);

property af_p413;
@(posedge wb_clk_i) $fell(arst_i) |-> ((wb_dat_o >= 0) && (wb_dat_o <= 255))[*3];
endproperty
assert property(af_p413);

property af_p414;
@(posedge wb_clk_i) $changed(wb_adr_i) |-> ##2 ((wb_dat_o >= 0) && (wb_dat_o <= 255));
endproperty
assert property(af_p414);

property af_p415;
@(posedge wb_clk_i) (!arst_i) |-> ((wb_dat_o >= 0) && (wb_dat_o <= 255));
endproperty
assert property(af_p415);

property af_p416;
@(posedge wb_clk_i) ((wb_dat_o >= 0) && (wb_dat_o <= 255));
endproperty
assert property(af_p416);

property af_p417;
@(posedge wb_clk_i) (wb_cyc_i && (wb_dat_i >= 100) && (wb_dat_i <= 150)) |-> ##[1:2] ((wb_dat_o >= 100) && (wb_dat_o <= 150));
endproperty
assert property(af_p417);

property af_p418;
@(posedge wb_clk_i) ((wb_dat_o >= 128) && (wb_dat_o <= 255) && wb_cyc_i) |=> (wb_cyc_i && (wb_dat_o >= 100) && (wb_dat_o <= 255));
endproperty
assert property(af_p418);

property af_p419;
@(posedge wb_clk_i) ($fell(arst_i)) |-> ##4 ((wb_dat_o >= 0) && (wb_dat_o <= 255));
endproperty
assert property(af_p419);

property af_p420;
@(posedge wb_clk_i) (!wb_cyc_i) |=> ((wb_dat_o == $past(wb_dat_o)) && (wb_dat_o >= 0) && (wb_dat_o <= 255));
endproperty
assert property(af_p420);

property af_p421;
@(posedge wb_clk_i) ((wb_dat_o >= 200) && (wb_dat_o <= 255) && wb_cyc_i) |=> ((wb_dat_o >= 180) && (wb_dat_o <= 255));
endproperty
assert property(af_p421);

property af_p422;
@(posedge wb_clk_i) ($fell(arst_i)) |-> ##[1:2] ((wb_dat_o >= 0) && (wb_dat_o <= 255));
endproperty
assert property(af_p422);

property af_p423;
@(posedge wb_clk_i) (wb_cyc_i) |-> ($stable(wb_dat_o) && (wb_dat_o >= 0) && (wb_dat_o <= 255));
endproperty
assert property(af_p423);

property af_p424;
@(posedge wb_clk_i) ($changed(wb_adr_i)) |-> ((wb_dat_o >= 0) && (wb_dat_o <= 255));
endproperty
assert property(af_p424);

property af_p425;
@(posedge wb_clk_i) ((wb_dat_i >= 0) && (wb_dat_i <= 255) && wb_cyc_i) |-> ##2 ((wb_dat_o >= 0) && (wb_dat_o <= 255));
endproperty
assert property(af_p425);

