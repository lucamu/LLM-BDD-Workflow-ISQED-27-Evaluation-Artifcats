module TopModule(
    input clk,
    input aresetn,        input x,
    output z ); 
    reg [1:0] state, next_state;
    always @(*) begin
        case (state)
            2'b00:	next_state = x? 2'b01 : 2'b00;
            2'b01:	next_state = x? 2'b01 : 2'b10;
            2'b10:	next_state = x? 2'b01 : 2'b11;
            2'b11:	next_state = x? 2'b01 : 2'b00;
        endcase
    end
    always @(posedge clk, negedge aresetn) begin
        if (~aresetn)
            state <= 2'b0;
        else
            state <= next_state;
    end
    assign z = (state == 2'b11) && x;
endmodule
