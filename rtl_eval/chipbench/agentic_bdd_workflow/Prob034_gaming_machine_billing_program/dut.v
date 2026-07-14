//=============================================================================
// Module Name : TopModule
// Description : Gaming Machine Billing System with Prepaid Charging
//               - Charges balance (remain) with "money" when "set" is high
//               - Deducts balance each cycle: 1 yuan normal mode,
//                 2 yuan boost mode
//               - Balance never underflows below zero
//               - "yellow" warns of low (but nonzero) balance
//               - "red" warns of insufficient funds for current mode
//=============================================================================
module TopModule (
    input             rst_n,
    input             clk,
    input      [9:0]  money,
    input             set,
    input             boost,
    output reg [9:0]  remain,
    output reg        yellow,
    output reg        red
);

    //-------------------------------------------------------------------
    // Deduction amount per cycle depends on boost mode
    // (boost_deduction / normal_deduction / default_mode scenarios)
    //-------------------------------------------------------------------
    wire [1:0] deduction = boost ? 2'd2 : 2'd1;

    //-------------------------------------------------------------------
    // Pre-deduction value: adds money only if "set" is asserted
    // (charging / charging_boost / combined_charge_and_deduct_* scenarios)
    // Width extended to avoid overflow when adding two 10-bit numbers
    //-------------------------------------------------------------------
    wire [10:0] pre_deduct = set ? ({1'b0, remain} + {1'b0, money})
                                  : {1'b0, remain};

    //-------------------------------------------------------------------
    // Subtract deduction; detect underflow to clamp result at zero
    // (no_underflow scenario)
    //-------------------------------------------------------------------
    wire [10:0] post_deduct  = pre_deduct - {9'b0, deduction};
    wire        underflow    = pre_deduct < {9'b0, deduction};

    //-------------------------------------------------------------------
    // Sequential logic: remain register update
    // Asynchronous active-low reset (reset scenario)
    //-------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: remain -> 0
            remain <= 10'b0000000000;
        end else begin
            // Clamp at zero if underflow would occur, else take result
            if (underflow)
                remain <= 10'b0000000000;
            else
                remain <= post_deduct[9:0];
        end
    end

    //-------------------------------------------------------------------
    // Combinational logic: yellow and red indicators
    // Forced to 0 while rst_n is low (asynchronous reset behavior),
    // otherwise purely combinational function of current "remain"/"boost"
    // (yellow_warning, red_warning_normal, red_warning_boost scenarios)
    //-------------------------------------------------------------------
    always @(*) begin
        if (!rst_n) begin
            // Reset scenario: force outputs to 0
            yellow = 1'b0;
            red    = 1'b0;
        end else begin
            // yellow_warning: low but nonzero balance
            if ((remain > 10'd0) && (remain < 10'd10))
                yellow = 1'b1;
            else
                yellow = 1'b0;

            // red_warning: insufficient funds depending on mode
            if (boost) begin
                // red_warning_boost
                red = (remain < 10'd2) ? 1'b1 : 1'b0;
            end else begin
                // red_warning_normal
                red = (remain < 10'd1) ? 1'b1 : 1'b0;
            end
        end
    end

endmodule