module TopModule(
    input  logic clk_fast,
    input  logic clk_slow,
    input  logic rst_n,
    input  logic data_in,
    output logic data_out
);

    // === Fast clock domain: detect pulse and toggle flag ===
    logic data_in_d;
    logic toggle_flag;

    always @(posedge clk_fast or negedge rst_n) begin
        if (!rst_n) begin
            data_in_d   <= 1'b0;
            toggle_flag <= 1'b0;
        end else begin
            data_in_d <= data_in;
            // detect rising edge of data_in (single cycle pulse)
            if (data_in && !data_in_d) begin
                toggle_flag <= ~toggle_flag;
            end
        end
    end

    // === Slow clock domain: synchronize toggle flag ===
    logic sync_ff1;
    logic sync_ff2;
    logic sync_ff3; // extra delayed stage to detect edge

    always @(posedge clk_slow or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff1 <= 1'b0;
            sync_ff2 <= 1'b0;
            sync_ff3 <= 1'b0;
        end else begin
            sync_ff1 <= toggle_flag;
            sync_ff2 <= sync_ff1;
            sync_ff3 <= sync_ff2;
        end
    end

    // Output pulse: one clk_slow cycle wide, generated when sync_ff2 changes relative to sync_ff3
    assign data_out = sync_ff2 ^ sync_ff3;

endmodule