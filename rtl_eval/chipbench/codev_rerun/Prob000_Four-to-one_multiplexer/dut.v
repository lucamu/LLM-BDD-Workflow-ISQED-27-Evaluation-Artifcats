module TopModule (
    input [1:0] d0, d1, d2, d3,
    input [1:0] sel,
    output wire [1:0] mux_out
);
    assign mux_out = (sel == 2'b00) ? d0 :
                     (sel == 2'b01) ? d1 :
                     (sel == 2'b10) ? d2 :
                     d3;
endmodule
