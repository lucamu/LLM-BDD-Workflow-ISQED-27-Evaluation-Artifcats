module TopModule (
    input                   clk,
    input                   rst,
    input                   we_i,
    input  [4:0]            waddr_i,
    input  [4:0]            raddr_i,
    input  [`RegBus]        data_i,
    input  [31:0]           excepttype_i,
    input  [5:0]            int_i,
    input  [`RegBus]        current_inst_addr_i,
    input                   is_in_delayslot_i,
    output [`RegBus]        data_o,
    output [`RegBus]        count_o,
    output [`RegBus]        compare_o,
    output [`RegBus]        status_o,
    output [`RegBus]        cause_o,
    output [`RegBus]        epc_o,
    output [`RegBus]        config_o,
    output [`RegBus]        prid_o,
    output                  timer_int_o
);

    // -----------------------------------------------------------
    // Scenario: Counter/Compare/Timer behavior (@counter, @timer_interrupt)
    // -----------------------------------------------------------
    dut__CP0_CountCompare u_CP0_CountCompare (
        .clk         (clk),
        .rst         (rst),
        .we_i        (we_i),
        .waddr_i     (waddr_i),
        .data_i      (data_i),
        .count_o     (count_o),
        .compare_o   (compare_o),
        .timer_int_o (timer_int_o)
    );

    // -----------------------------------------------------------
    // Scenario: Status/Cause/EPC register writes, exceptions, ERET,
    // interrupt propagation (@register_write, @exception, @interrupt,
    // @eret, @priority)
    // -----------------------------------------------------------
    dut__CP0_ExceptionRegs u_CP0_ExceptionRegs (
        .clk                   (clk),
        .rst                   (rst),
        .we_i                  (we_i),
        .waddr_i               (waddr_i),
        .data_i                (data_i),
        .excepttype_i          (excepttype_i),
        .int_i                 (int_i),
        .current_inst_addr_i   (current_inst_addr_i),
        .is_in_delayslot_i     (is_in_delayslot_i),
        .status_o              (status_o),
        .cause_o               (cause_o),
        .epc_o                 (epc_o)
    );

    // -----------------------------------------------------------
    // Scenario: Reset defaults for Config/PRID registers (@reset,
    // @register_read - config/prid)
    // -----------------------------------------------------------
    dut__CP0_ConfigPrid u_CP0_ConfigPrid (
        .clk      (clk),
        .rst      (rst),
        .config_o (config_o),
        .prid_o   (prid_o)
    );

    // -----------------------------------------------------------
    // Scenario: Register read mux (@register_read)
    // -----------------------------------------------------------
    dut__CP0_ReadMux u_CP0_ReadMux (
        .raddr_i    (raddr_i),
        .count_i    (count_o),
        .compare_i  (compare_o),
        .status_i   (status_o),
        .cause_i    (cause_o),
        .epc_i      (epc_o),
        .config_i   (config_o),
        .prid_i     (prid_o),
        .data_o     (data_o)
    );

endmodule

module dut__CP0_CountCompare (
    input               clk,
    input               rst,
    input               we_i,
    input       [4:0]   waddr_i,
    input       [31:0]  data_i,
    output reg  [31:0]  count_o,
    output reg  [31:0]  compare_o,
    output reg          timer_int_o
);

    // CP0 register addresses for COUNT and COMPARE
    localparam CP0_REG_COUNT   = 5'd9;
    localparam CP0_REG_COMPARE = 5'd11;

    // Internal write-enable decode signals
    wire write_count   = we_i && (waddr_i == CP0_REG_COUNT);
    wire write_compare = we_i && (waddr_i == CP0_REG_COMPARE);

    always @(posedge clk) begin
        if (rst) begin
            // @reset: Reset initializes count, compare, and timer interrupt
            count_o     <= 32'd0;
            compare_o   <= 32'd0;
            timer_int_o <= 1'b0;
        end else begin
            //-----------------------------------------------------------
            // COUNT register update
            //-----------------------------------------------------------
            if (write_count) begin
                // @write_count / @priority_count_over_increment:
                // Write to COUNT overrides automatic increment
                count_o <= data_i;
            end else begin
                // @increment: Count increments when no write occurs
                count_o <= count_o + 32'd1;
            end

            //-----------------------------------------------------------
            // COMPARE register update
            //-----------------------------------------------------------
            if (write_compare) begin
                // @write_compare / @independent_count_compare_update:
                // Writing COMPARE loads compare_o (independent of COUNT update)
                compare_o <= data_i;
            end else begin
                // @no_write / @write_count_leaves_compare:
                // No write to COMPARE leaves compare_o unchanged
                compare_o <= compare_o;
            end

            //-----------------------------------------------------------
            // Timer interrupt logic
            //-----------------------------------------------------------
            if (write_compare) begin
                // @write_compare / @timer_int_cleared_on_rewrite:
                // Writing COMPARE clears any pending timer interrupt
                timer_int_o <= 1'b0;
            end else begin
                // Determine next count value (mirrors count_o update logic)
                // to detect match condition for timer_int_o in this cycle.
                if ((write_count ? data_i : (count_o + 32'd1)) == compare_o &&
                    (compare_o != 32'd0)) begin
                    // @timer_int_assert: count equals nonzero compare
                    timer_int_o <= 1'b1;
                end else if (compare_o == 32'd0) begin
                    // @timer_int_no_assert_zero_compare: compare is zero
                    timer_int_o <= 1'b0;
                end else begin
                    // @timer_int_no_assert_mismatch / @timer_int_held:
                    // Retain previous state if no match and no compare write
                    timer_int_o <= timer_int_o;
                end
            end
        end
    end

endmodule

module dut__CP0_ExceptionRegs (
    input  wire        clk,
    input  wire         rst,
    input  wire         we_i,
    input  wire [4:0]   waddr_i,
    input  wire [31:0]  data_i,
    input  wire [31:0]  excepttype_i,
    input  wire [5:0]   int_i,
    input  wire [31:0]  current_inst_addr_i,
    input  wire         is_in_delayslot_i,
    output reg  [31:0]  status_o,
    output reg  [31:0]  cause_o,
    output reg  [31:0]  epc_o
);

    //-------------------------------------------------------------------
    // CP0 register addresses (distinct fixed values)
    //-------------------------------------------------------------------
    localparam CP0_REG_STATUS = 5'd12;
    localparam CP0_REG_CAUSE  = 5'd13;
    localparam CP0_REG_EPC    = 5'd14;

    //-------------------------------------------------------------------
    // Fixed ERET exception code, distinct from other excepttype_i values
    //-------------------------------------------------------------------
    localparam EXC_ERET = 32'h0000000d;

    //-------------------------------------------------------------------
    // Bit position definitions
    //-------------------------------------------------------------------
    localparam STATUS_EXL_BIT = 1;     // EXL bit in STATUS
    localparam CAUSE_BD_BIT   = 31;    // Branch-delay bit in CAUSE
    localparam CAUSE_IV_BIT   = 23;    // IV bit in CAUSE

    // Reset value for STATUS: CU[0] bit (bit 28) = 1, all other bits = 0
    localparam STATUS_RESET_VAL = 32'h1000_0000;

    //-------------------------------------------------------------------
    // Sequential logic: single clocked always block implementing all
    // register updates for STATUS, CAUSE, and EPC.
    //-------------------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // @reset: Initialize STATUS (CU0=1, rest 0), CAUSE=0, EPC=0
            status_o <= STATUS_RESET_VAL;
            cause_o  <= 32'b0;
            epc_o    <= 32'b0;
        end else begin
            //-------------------------------------------------------
            // @ip_update: hardware interrupt pending bits are updated
            // every cycle regardless of any other input activity.
            //-------------------------------------------------------
            cause_o[15:10] <= int_i;

            if (excepttype_i == EXC_ERET) begin
                //---------------------------------------------------
                // @eret: ERET clears EXL bit, does not touch EPC or
                // the ExcCode/BD fields of CAUSE, and takes priority
                // over any concurrent CP0 register write.
                //---------------------------------------------------
                status_o[STATUS_EXL_BIT] <= 1'b0;
                // epc_o, cause_o[6:2], cause_o[31] intentionally left
                // unassigned here -> retain previous values.
            end
            else if (excepttype_i != 32'b0) begin
                //---------------------------------------------------
                // @exception_entry: any nonzero, non-ERET exception
                // type triggers exception entry, taking priority over
                // any concurrent CP0 register write (@priority).
                //---------------------------------------------------
                status_o[STATUS_EXL_BIT] <= 1'b1;

                // Update ExcCode (derived from excepttype_i) and BD bit
                cause_o[6:2]           <= excepttype_i[4:0];
                cause_o[CAUSE_BD_BIT]  <= is_in_delayslot_i;

                //-----------------------------------------------
                // @epc_guard: only capture EPC if EXL was clear
                // before this cycle; otherwise EPC is preserved.
                //-----------------------------------------------
                if (status_o[STATUS_EXL_BIT] == 1'b0) begin
                    if (is_in_delayslot_i)
                        epc_o <= current_inst_addr_i - 32'd4; // @delay_slot
                    else
                        epc_o <= current_inst_addr_i;
                end
                // else: epc_o unchanged (EXL already set)
            end
            else begin
                //---------------------------------------------------
                // Normal operation (excepttype_i == 0): process CP0
                // register writes when requested.
                //---------------------------------------------------
                if (we_i) begin
                    case (waddr_i)
                        CP0_REG_STATUS: begin
                            // @write_status: full STATUS register load
                            status_o <= data_i;
                        end

                        CP0_REG_CAUSE: begin
                            // @write_cause: only bits [9:8] (software IP)
                            // and IV bit are writable; other bits
                            // (except [15:10] handled above) retain value.
                            cause_o[9:8]           <= data_i[9:8];
                            cause_o[CAUSE_IV_BIT]  <= data_i[CAUSE_IV_BIT];
                        end

                        CP0_REG_EPC: begin
                            // @write_epc: full EPC register load
                            epc_o <= data_i;
                        end

                        default: begin
                            // No operation for unrecognized address
                        end
                    endcase
                end
            end
        end
    end

endmodule

module dut__CP0_ConfigPrid (
    input  wire        clk,
    input  wire        rst,
    output wire [31:0] config_o,
    output wire [31:0] prid_o
);

    // -------------------------------------------------------------------
    // Fixed constant values (per specification)
    // -------------------------------------------------------------------
    localparam [31:0] CONFIG_RESET_VAL = 32'h00008000; // BE bit (bit15) = 1, rest = 0
    localparam [31:0] PRID_FIXED_VAL   = 32'h00480002; // Fixed PRID constant

    // -------------------------------------------------------------------
    // Registered storage for CONFIG and PRID
    // -------------------------------------------------------------------
    reg [31:0] config_reg;
    reg [31:0] prid_reg;

    // -------------------------------------------------------------------
    // Sequential logic: registers are hardwired constants.
    // Scenarios covered:
    //   @reset @config          - resets to 32'h00008000
    //   @reset @prid            - resets to 32'h00480002
    //   @stability @config      - stable value across cycles, BE bit stays 1
    //   @stability @prid        - stable value across cycles
    //   @no_write @config       - no write path exists, value never changes
    //   @no_write @prid         - no write path exists, value never changes
    //   @invariant @config      - BE bit (bit 15) always asserted
    //   @invariant @combined    - independent of all data inputs (none exist)
    //   @reset_recovery         - returns to fixed values immediately after reset
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            // Reset scenario: force registers to their fixed reset values
            config_reg <= CONFIG_RESET_VAL;
            prid_reg   <= PRID_FIXED_VAL;
        end else begin
            // No write interface exists; registers remain hardwired constants
            // every cycle (stability, no_write, invariant scenarios).
            config_reg <= CONFIG_RESET_VAL;
            prid_reg   <= PRID_FIXED_VAL;
        end
    end

    // -------------------------------------------------------------------
    // Output assignments
    // -------------------------------------------------------------------
    assign config_o = config_reg;
    assign prid_o   = prid_reg;

endmodule

module dut__CP0_ReadMux (
    input  [4:0]  raddr_i,
    input  [31:0] count_i,
    input  [31:0] compare_i,
    input  [31:0] status_i,
    input  [31:0] cause_i,
    input  [31:0] epc_i,
    input  [31:0] config_i,
    input  [31:0] prid_i,
    output reg [31:0] data_o
);

    localparam [4:0] CP0_REG_COUNT   = 5'd9;
    localparam [4:0] CP0_REG_COMPARE = 5'd11;
    localparam [4:0] CP0_REG_STATUS  = 5'd12;
    localparam [4:0] CP0_REG_CAUSE   = 5'd13;
    localparam [4:0] CP0_REG_EPC     = 5'd14;
    localparam [4:0] CP0_REG_PRID    = 5'd15;
    localparam [4:0] CP0_REG_CONFIG  = 5'd16;

    always @(*) begin
        case (raddr_i)
            CP0_REG_COUNT:   data_o = count_i;
            CP0_REG_COMPARE: data_o = compare_i;
            CP0_REG_STATUS:  data_o = status_i;
            CP0_REG_CAUSE:   data_o = cause_i;
            CP0_REG_EPC:     data_o = epc_i;
            CP0_REG_CONFIG:  data_o = config_i;
            CP0_REG_PRID:    data_o = prid_i;
            default:         data_o = 32'd0;
        endcase
    end

endmodule
