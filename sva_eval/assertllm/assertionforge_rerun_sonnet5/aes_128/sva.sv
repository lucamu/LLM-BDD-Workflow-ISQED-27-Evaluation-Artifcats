// AssertionForge baseline SVA for tiny_aes
// 200 assertions captured from gen_plan.generate_svas

property af_p0;
@(posedge clk) (1) |-> ##1 state == $past(state, 1) || state != $past(state, 1);
endproperty
assert property(af_p0);



















property af_p19;
@(posedge clk) (1) |=> (out == $past(state));
endproperty
assert property(af_p19);






property af_p25;
@(posedge clk) 1'b1 |=> $stable(state);
endproperty
assert property(af_p25);



property af_p28;
@(posedge clk) 1'b1 |=> $stable(out);
endproperty
assert property(af_p28);
































property af_p60;
@(posedge clk) (!state) |-> (out == 0);
endproperty
assert property(af_p60);




property af_p64;
@(posedge clk) (!state) |-> ##1 $stable(out);
endproperty
assert property(af_p64);

property af_p65;
@(posedge clk) $rose(state) |-> $stable(out)[*1];
endproperty
assert property(af_p65);

property af_p66;
@(posedge clk) $rose(state) |-> ##[1:19] $stable(out);
endproperty
assert property(af_p66);


property af_p68;
@(posedge clk) (state) |-> (out >= 0) && (out <= 255);
endproperty
assert property(af_p68);



property af_p71;
@(posedge clk) $changed(state) |=> (out >= 0 && out <= 255);
endproperty
assert property(af_p71);








property af_p79;
@(posedge clk) $stable(state) |-> $stable(out);
endproperty
assert property(af_p79);



property af_p82;
@(posedge clk) 1'b1 |-> ((out[7:0] >= 0) && (out[7:0] <= 255));
endproperty
assert property(af_p82);



property af_p85;
@(posedge clk) 1'b1 |-> !$isunknown(out);
endproperty
assert property(af_p85);



property af_p88;
@(posedge clk) $stable(out) |-> ##1 $stable(out);
endproperty
assert property(af_p88);

property af_p89;
@(posedge clk) (state) |-> $stable(out);
endproperty
assert property(af_p89);
















































































property af_p169;
@(posedge clk) (state == $past(state)) |-> (out == $past(out));
endproperty
assert property(af_p169);



property af_p172;
@(posedge clk) $changed(state) |-> ##1 $changed(out);
endproperty
assert property(af_p172);



property af_p175;
@(posedge clk) $changed(state) |-> $changed(out);
endproperty
assert property(af_p175);


property af_p177;
@(posedge clk) 1 |-> ##2 (state != $past(state,2));
endproperty
assert property(af_p177);


property af_p179;
@(posedge clk) 1 |-> ##2 (state != $past(state));
endproperty
assert property(af_p179);

property af_p180;
@(posedge clk) $past(state,2) != state |-> $changed(state);
endproperty
assert property(af_p180);



property af_p183;
@(posedge clk) (1'b1) |-> ##1 (state == ($past(state) + 1));
endproperty
assert property(af_p183);





property af_p188;
@(posedge clk) (1'b1) |-> ##1 ($bits(state) == $bits($past(state)));
endproperty
assert property(af_p188);


property af_p190;
@(posedge clk) (1'b1) |-> ##1 $stable(state);
endproperty
assert property(af_p190);




property af_p194;
@(posedge clk) (state == $past(state,2)) |-> (out == $past(out,2));
endproperty
assert property(af_p194);





property af_p199;
@(posedge clk) 1'b1 |-> !$isunknown(state);
endproperty
assert property(af_p199);

