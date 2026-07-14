module TopModule(
    input clk,
    input rst_n,
    input [1:0] wave_choice,
    output [4:0] wave
);
    reg [4:0] wave_sq, wave_tri, wave_saw;
    reg [15:0] cnt;
    always @(posedge clk) begin
        if (~rst_n) begin
            cnt <= 16'd0;
        end
        else begin
            cnt <= cnt + 16'd1;
        end
    end
    always @(posedge clk) begin
        if (~rst_n) begin
            wave_sq <= 5'd0;
        end
        else begin
            if (cnt == 16'd9999) begin
                wave_sq <= 5'd31;
            end
            else if (cnt == 16'd19999) begin
                wave_sq <= 5'd0;
            end
        end
    end
    always @(posedge clk) begin
        if (~rst_n) begin
            wave_tri <= 5'd0;
        end
        else begin
            if (cnt == 16'd9999) begin
                wave_tri <= 5'd31;
            end
            else if (cnt == 16'd19999) begin
                wave_tri <= 5'd0;
            end
            else if (cnt == 16'd29999) begin
                wave_tri <= 5'd31;
            end
            else if (cnt == 16'd39999) begin
                wave_tri <= 5'd0;
            end
            else if (cnt == 16'd49999) begin
                wave_tri <= 5'd31;
            end
            else if (cnt == 16'd59999) begin
                wave_tri <= 5'd0;
            end
            else if (cnt == 16'd69999) begin
                wave_tri <= 5'd31;
            end
            else if (cnt == 16'd79999) begin
                wave_tri <= 5'd0;
            end
            else if (cnt == 16'd89999) begin
                wave_tri <= 5'd31;
            end
            else if (cnt == 16'd99999) begin
                wave_tri <= 5'd0;
            end
            else if (cnt == 16'd109999) begin
                wave_tri <= 5'd31;
            end
            else if (cnt == 16'd119999) begin
                wave_tri <= 5'd0;
            end
            else if (cnt == 16'd129999) begin
                wave_tri <= 5'd31;
            end
            else if (cnt == 16'd139999) begin
                wave_tri <= 5'd0;
            end
            else if (cnt == 16'd149999) begin
                wave_tri <= 5'd31;
            end
            else if (cnt == 16'd159999) begin
                wave_tri <= 5'd0;
            end
        end
    end
    always @(posedge clk) begin
        if (~rst_n) begin
            wave_saw <= 5'd0;
        end
        else begin
            if (cnt == 16'd9999) begin
                wave_saw <= 5'd31;
            end
            else if (cnt == 16'd19999) begin
                wave_saw <= 5'd63;
            end
            else if (cnt == 16'd29999) begin
                wave_saw <= 5'd95;
            end
            else if (cnt == 16'd39999) begin
                wave_saw <= 5'd127;
            end
            else if (cnt == 16'd49999) begin
                wave_saw <= 5'd159;
            end
            else if (cnt == 16'd59999) begin
                wave_saw <= 5'd191;
            end
            else if (cnt == 16'd69999) begin
                wave_saw <= 5'd223;
            end
            else if (cnt == 16'd79999) begin
                wave_saw <= 5'd255;
            end
            else if (cnt == 16'd89999) begin
                wave_saw <= 5'd255;
            end
            else if (cnt == 16'd99999) begin
                wave_saw <= 5'd223;
            end
            else if (cnt == 16'd109999) begin
                wave_saw <= 5'd191;
            end
            else if (cnt == 16'd119999) begin
                wave_saw <= 5'd159;
            end
            else if (cnt == 16'd129999) begin
                wave_saw <= 5'd127;
            end
            else if (cnt == 16'd139999) begin
                wave_saw <= 5'd95;
            end
            else if (cnt == 16'd149999) begin
                wave_saw <= 5'd63;
            end
            else if (cnt == 16'd159999) begin
                wave_saw <= 5'd31;
            end
        end
    end
    assign wave = (wave_choice == 2'd0) ? wave_sq :
                  (wave_choice == 2'd1) ? wave_saw : wave_tri;
endmodule
