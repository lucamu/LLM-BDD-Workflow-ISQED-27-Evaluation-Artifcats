module TopModule (
    input                       clk,
    input                       rst,
    input      [5:0]            stall,
    input                       flush,
    input      [31:0]           new_pc,
    input                       branch_flag_i,
    input      [31:0]           branch_target_address_i,
    output     [31:0]           pc,
    output                      ce
);

    // ----------------------------------------------------------------------
    // Scenario: Chip enable is disabled during reset / enabled after reset
    // CeGenerator handles the ce logic based on rst and clk.
    // ----------------------------------------------------------------------
    dut__CeGenerator u_CeGenerator (
        .clk (clk),
        .rst (rst),
        .ce  (ce)
    );

    // ----------------------------------------------------------------------
    // Scenario: PC cleared when ce is 0 (reset / chip disable)
    // Scenario: PC holds value when stall[0] asserted
    // Scenario: PC updates to new_pc when flush asserted and not stalled
    // Scenario: PC updates to branch target when branch_flag_i asserted,
    //           flush not asserted, and not stalled
    // Scenario: PC increments by 4 when no stall/flush/branch
    // Scenario: Flush takes priority over branch
    // Scenario: Stall takes priority over flush and branch
    // Scenario: ce disables PC regardless of stall/flush/branch
    // PcController implements all of the above priority logic internally.
    // ----------------------------------------------------------------------
    dut__PcController u_PcController (
        .clk                     (clk),
        .rst                     (rst),
        .ce                      (ce),
        .stall                   (stall),
        .flush                   (flush),
        .new_pc                  (new_pc),
        .branch_flag_i           (branch_flag_i),
        .branch_target_address_i (branch_target_address_i),
        .pc                      (pc)
    );

endmodule

module dut__CeGenerator (
    input  wire clk,
    input  wire rst,
    output reg  ce
);

    // -----------------------------------------------------------
    // Sequential logic: ce is updated only on rising edge of clk
    // -----------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            // @reset @synchronous
            // Scenario: ce is cleared when rst is asserted
            ce <= 1'b0;
        end else begin
            // @enable @synchronous
            // Scenario: ce is set when rst is deasserted
            ce <= 1'b1;
        end
        // @functional_equivalence
        // ce = NOT(rst) sampled value on this clock edge
        // (achieved implicitly by the if/else above)

        // @stability
        // Holding rst constant across consecutive edges keeps ce
        // stable at NOT(rst), since the same branch is taken each
        // cycle.

        // @toggle_response
        // Each edge independently evaluates rst at that instant,
        // so toggling rst between cycles correctly toggles ce.

        // @initial_state
        // On the first rising edge with rst asserted, ce becomes 0
        // as handled by the reset branch above.
    end

    // -----------------------------------------------------------
    // @no_combinational_bypass
    // There is no combinational assignment to ce; it is driven
    // exclusively inside the clocked always block above, ensuring
    // ce retains its previous value until the next rising edge of
    // clk, regardless of rst changes between clock edges.
    // -----------------------------------------------------------

endmodule

module dut__PcController (
    input               clk,
    input               rst,
    input               ce,
    input       [5:0]   stall,
    input               flush,
    input       [31:0]  new_pc,
    input               branch_flag_i,
    input       [31:0]  branch_target_address_i,
    output      [31:0]  pc
);

    // Internal register holding the current program counter value
    reg [31:0] pc_reg;

    // Output always mirrors the internal pc register (scenario: @output_mirror)
    assign pc = pc_reg;

    always @(posedge clk) begin
        if (rst) begin
            // Scenario: Reset forces pc to zero regardless of other control
            // signals (@reset @priority_highest), also covers
            // @priority_check @rst_over_all (reset overrides everything)
            pc_reg <= 32'h00000000;
        end
        else if (!ce) begin
            // Scenario: Clock enable deasserted forces pc to zero when not
            // in reset (@ce_disabled @priority_second), also covers
            // @priority_check @ce_over_all (ce overrides flush/branch/stall)
            pc_reg <= 32'h00000000;
        end
        else if (flush) begin
            // Scenario: Flush redirects pc to new_pc when ce enabled and
            // not in reset (@flush @priority_third), also covers
            // @priority_check @flush_over_branch (flush beats branch)
            pc_reg <= new_pc;
        end
        else if (branch_flag_i) begin
            // Scenario: Branch resolution redirects pc to
            // branch_target_address_i when flush not asserted
            // (@branch @priority_fourth), also covers
            // @priority_check @branch_over_stall (branch beats stall)
            pc_reg <= branch_target_address_i;
        end
        else if (stall[0]) begin
            // Scenario: Stall bit 0 holds pc value when flush and branch
            // are not asserted (@stall @priority_fifth)
            pc_reg <= pc_reg;
        end
        else begin
            // Scenario: Sequential advance increments pc by 4 when no
            // override condition is active (@sequential @priority_lowest)
            pc_reg <= pc_reg + 32'd4;
        end
    end

endmodule
