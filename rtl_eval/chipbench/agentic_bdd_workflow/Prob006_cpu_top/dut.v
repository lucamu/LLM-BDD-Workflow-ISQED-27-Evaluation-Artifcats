module TopModule (
    output          readM,
    output [15:0]   address,
    inout  [15:0]   data,
    input           inputReady,
    input           reset_n,
    input           clk,
    output [15:0]   num_inst,
    output [15:0]   output_port
);

    // ------------------------------------------------------------------
    // Opcode / function local parameters (per specification)
    // ------------------------------------------------------------------
    localparam [3:0] OPCODE_BNE = 4'd0;
    localparam [3:0] OPCODE_BEQ = 4'd1;
    localparam [3:0] OPCODE_BGZ = 4'd2;
    localparam [3:0] OPCODE_BLZ = 4'd3;
    localparam [3:0] OPCODE_ADI = 4'd4;
    localparam [3:0] OPCODE_ORI = 4'd5;
    localparam [3:0] OPCODE_LHI = 4'd6;
    localparam [3:0] OPCODE_LWD = 4'd7;
    localparam [3:0] OPCODE_SWD = 4'd8;
    localparam [3:0] OPCODE_JMP = 4'd9;
    localparam [3:0] OPCODE_JAL = 4'd10;
    localparam [3:0] OPCODE_R   = 4'b1111;

    localparam [5:0] FUNC_ADD = 6'd0;
    localparam [5:0] FUNC_SUB = 6'd1;
    localparam [5:0] FUNC_AND = 6'd2;
    localparam [5:0] FUNC_ORR = 6'd3;
    localparam [5:0] FUNC_NOT = 6'd4;
    localparam [5:0] FUNC_TCP = 6'd5;
    localparam [5:0] FUNC_SHL = 6'd6;
    localparam [5:0] FUNC_SHR = 6'd7;
    localparam [5:0] FUNC_JPR = 6'd25;
    localparam [5:0] FUNC_JRL = 6'd26;
    localparam [5:0] FUNC_RWD = 6'd27;
    localparam [5:0] FUNC_WWD = 6'd28;
    localparam [5:0] FUNC_HLT = 6'd29;
    localparam [5:0] FUNC_ENI = 6'd30;
    localparam [5:0] FUNC_DSI = 6'd31;

    // ------------------------------------------------------------------
    // Internal wires
    // ------------------------------------------------------------------
    wire [15:0] PC_current;            // current PC value from PCUnit
    wire [15:0] instr_out;             // instruction register output
    wire [15:0] dataReg_out;           // latched memory / IO data

    wire [3:0]  opcode = instr_out[15:12];
    wire [1:0]  rs     = instr_out[11:10];
    wire [1:0]  rt     = instr_out[9:8];
    wire [1:0]  rd     = instr_out[7:6];
    wire [7:0]  imm8   = instr_out[7:0];
    wire [5:0]  func   = instr_out[5:0];

    // Control signals
    wire        RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite;
    wire        ALUSrc, RegWrite, OpenPort;
    wire [3:0]  ALUOp;

    // Register file signals
    wire [15:0] ReadData1, ReadData2;
    wire [1:0]  writeAddr;
    wire [15:0] WriteData;

    // ALU signals
    wire [15:0] ALU_B;
    wire [15:0] ALU_C;
    wire        bcond;

    // Sign extension
    wire [15:0] sext_imm;

    // FSM control signals
    wire        fsm_readM, fsm_writeM, addr_sel;
    wire        ir_write, dr_write, rf_write_fsm, pc_write_fsm, inc_num_inst_fsm;

    // Jump target computed for PCUnit (see @pcupdate scenarios)
    wire [15:0] jump_target;

    // Halt handling (@control HLT scenario) - no dedicated sub-module,
    // implemented locally since it is architectural top-level state.
    reg  halt_reg;
    wire is_halt_instr = (opcode == OPCODE_R) && (func == FUNC_HLT);
    wire pc_write_final = pc_write_fsm & ~(halt_reg | is_halt_instr);
    wire inc_num_inst_final = inc_num_inst_fsm & ~halt_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            halt_reg <= 1'b0;                      // @reset : clears halt state
        else if (is_halt_instr && pc_write_fsm)
            halt_reg <= 1'b1;                      // @control HLT: freeze PC forever
    end

    // ------------------------------------------------------------------
    // Sub-module instantiations
    // ------------------------------------------------------------------

    // Register File (@writeback, @io scenarios)
    RF u_RF (
        .write (rf_write_fsm),
        .clk   (clk),
        .reset_n(reset_n),
        .addr1 (rs),
        .addr2 (rt),
        .addr3 (writeAddr),
        .data1 (ReadData1),
        .data2 (ReadData2),
        .data3 (WriteData)
    );

    // Control unit (@decode, @control scenarios)
    Control u_Control (
        .opcode   (opcode),
        .func     (func),
        .RegDst   (RegDst),
        .Jump     (Jump),
        .Branch   (Branch),
        .MemRead  (MemRead),
        .MemtoReg (MemtoReg),
        .ALUOp    (ALUOp),
        .MemWrite (MemWrite),
        .ALUSrc   (ALUSrc),
        .RegWrite (RegWrite),
        .OpenPort (OpenPort)
    );

    // Sign extension of immediate (@execute itype scenarios)
    dut__SignExtend u_SignExtend (
        .imm  (imm8),
        .sext (sext_imm)
    );

    // ALU B operand mux (@control ALUSrc scenarios)
    assign ALU_B = ALUSrc ? sext_imm : ReadData2;

    // ALU (@execute rtype/itype/branch scenarios)
    ALU u_ALU (
        .A     (ReadData1),
        .B     (ALU_B),
        .OP    (ALUOp),
        .C     (ALU_C),
        .bcond (bcond)
    );

    // Jump target selection for PCUnit:
    //  - JPR/JRL (@pcupdate rtype) : PC <- ReadData1
    //  - JMP/JAL (@pcupdate jump)  : PC <- {PC[15:12], target(11:0)}
    assign jump_target = (opcode == OPCODE_R && (func == FUNC_JPR || func == FUNC_JRL))
                          ? ReadData1
                          : {PC_current[15:12], instr_out[11:0]};

    // PC register / update logic (@pcupdate scenarios)
    dut__PCUnit u_PCUnit (
        .clk         (clk),
        .reset_n     (reset_n),
        .pc_write    (pc_write_final),
        .Jump        (Jump),
        .Branch      (Branch),
        .bcond       (bcond),
        .instruction (jump_target),
        .sext_imm    (sext_imm),
        .PC          (PC_current)
    );

    // Instruction register (@fetch scenarios)
    dut__IRReg u_IRReg (
        .clk      (clk),
        .reset_n  (reset_n),
        .ir_write (ir_write),
        .instr_in (data),
        .instr_out(instr_out)
    );

    // Data memory / IO register (@memory, @io RWD scenarios)
    dut__DataMemReg u_DataMemReg (
        .clk      (clk),
        .reset_n  (reset_n),
        .dr_write (dr_write),
        .data_in  (data),
        .data_out (dataReg_out)
    );

    // Instruction counter (@instcount scenarios)
    dut__InstCounter u_InstCounter (
        .clk     (clk),
        .reset_n (reset_n),
        .inc     (inc_num_inst_final),
        .count   (num_inst)
    );

    // FSM controller: sequences fetch/decode/execute/memory/writeback
    // (@fetch, @memory, @writeback, @instcount scenarios)
    dut__FSMController u_FSMController (
        .clk         (clk),
        .reset_n     (reset_n),
        .inputReady  (inputReady),
        .MemRead     (MemRead),
        .MemWrite    (MemWrite),
        .RegWrite    (RegWrite),
        .readM       (fsm_readM),
        .writeM      (fsm_writeM),
        .addr_sel    (addr_sel),
        .ir_write    (ir_write),
        .dr_write    (dr_write),
        .rf_write    (rf_write_fsm),
        .pc_write    (pc_write_fsm),
        .inc_num_inst(inc_num_inst_fsm)
    );

    // ------------------------------------------------------------------
    // Address / data bus drivers (@fetch, @memory scenarios)
    // ------------------------------------------------------------------
    assign readM   = fsm_readM;
    assign address = addr_sel ? ALU_C : PC_current; // 0: fetch (PC), 1: mem access (ALU result)

    // Drive data bus only during SWD store (@memory SWD scenario); otherwise Hi-Z
    assign data = fsm_writeM ? ReadData2 : 16'bz;

    // ------------------------------------------------------------------
    // Write-back destination address mux (@writeback scenarios)
    // ------------------------------------------------------------------
    assign writeAddr = (opcode == OPCODE_JAL) ? 2'b11 :   // @pcupdate JAL: fixed R3
                        (RegDst)              ? rd    :   // R-type dest (incl JPR/JRL/RWD)
                                                 rt;       // I-type dest

    // ------------------------------------------------------------------
    // Write-back data mux (@writeback, @pcupdate jump/rtype scenarios)
    // ------------------------------------------------------------------
    assign WriteData = (opcode == OPCODE_JAL)                                ? (PC_current + 16'd1) : // JAL return addr
                        (opcode == OPCODE_R && func == FUNC_JRL)             ? (PC_current + 16'd1) : // JRL return addr
                        (opcode == OPCODE_R && func == FUNC_RWD)             ? dataReg_out           : // RWD input value
                        (MemtoReg)                                          ? dataReg_out           : // LWD load value
                                                                               ALU_C;                  // default ALU result

    // ------------------------------------------------------------------
    // Output port (@io, @output scenarios)
    // ------------------------------------------------------------------
    assign output_port = OpenPort ? ReadData1 : 16'bz;

endmodule

module RF(
    input write,
    input clk,
    input reset_n,
    input [1:0] addr1,
    input [1:0] addr2,
    input [1:0] addr3,
    output [15:0] data1,
    output [15:0] data2,
    input [15:0] data3
    );
    
    reg [63:0] register;
    /*
    register[63:48] == register[16*3+: 16] (addr is 2'b11)
    register[47:32] == register[16*2+: 16] (addr is 2'b10)
    register[31:16] == register[16*1+: 16] (addr is 2'b01)
    register[15: 0] == register[16*0+: 16] (addr is 2'b00)
    */
    
    always @(posedge clk, negedge reset_n) begin
        // Asynchronous active low reset -> This used to be Synchronous reset; modified to asynchronous for Project 4.
    	if (!reset_n) register <= 64'b0;
    	// Synchronous data write
    	else if (write) register[16*addr3+: 16] <= data3;
    end
    
    // Asynchronous data read
    assign data1 = register[16*addr1+: 16];
    assign data2 = register[16*addr2+: 16];
    
endmodule

module ALU(
    input signed [15:0] A,
    input signed [15:0] B,
    input [3:0] OP,
    output reg [15:0] C,
    output bcond
    );
    
    always @(*) begin
        case (OP)
            0:  C = A + B;          // ADD, ADI, LWD, SWD
            1:  C = A - B;          // SUB
            2:  C = A & B;          // AND
            3:  C = A | B;          // ORR, ORI
            4:  C = ~A;             // NOT
            5:  C = ~A + 1'b1;      // TCP
            6:  C = A << 1;         // SHL
            7:  C = A >>> 1;        // SHR
            8:  C = {B[7:0], 8'b0}; // LHI
            9:  C = A - B;          // BNE
            10: C = A - B;          // BEQ
            11: C = A;              // BGZ
            12: C = A;              // BLZ
            default: C = 16'bz;
        endcase
    end
    
    // Using assign, C and bcond change at the same time.
    // The timing would have been different if they were inside a single always block. 
    assign bcond = OP==9  ? (C!=0) :        // BNE
                   OP==10 ? (C==0) :        // BEQ
                   OP==11 ? (C>0)  :        // BGZ                
                   OP==12 ? (C<0)  : 0;     // BLZ
    
endmodule

module Control (
    input  [3:0] opcode,
    input  [5:0] func,
    output [0:0] RegDst,
    output [0:0] Jump,
    output [0:0] Branch,
    output [0:0] MemRead,
    output [0:0] MemtoReg,
    output [3:0] ALUOp,
    output [0:0] MemWrite,
    output [0:0] ALUSrc,
    output [0:0] RegWrite,
    output [0:0] OpenPort
);

    reg RegDst_r;
    reg Jump_r;
    reg Branch_r;
    reg MemRead_r;
    reg MemtoReg_r;
    reg [3:0] ALUOp_r;
    reg MemWrite_r;
    reg ALUSrc_r;
    reg RegWrite_r;
    reg OpenPort_r;

    localparam OP_RTYPE  = 4'b0000;
    localparam OP_LW     = 4'b0001;
    localparam OP_SW     = 4'b0010;
    localparam OP_BEQ    = 4'b0011;
    localparam OP_JUMP   = 4'b0100;
    localparam OP_OPENPT = 4'b1111;

    localparam FUNC_ADD  = 6'b100000;
    localparam FUNC_SUB  = 6'b100010;
    localparam FUNC_AND  = 6'b100100;
    localparam FUNC_OR   = 6'b100101;
    localparam FUNC_SLT  = 6'b101010;

    always @(*) begin
        RegDst_r    = 1'b0;
        Jump_r      = 1'b0;
        Branch_r    = 1'b0;
        MemRead_r   = 1'b0;
        MemtoReg_r  = 1'b0;
        ALUOp_r     = 4'b0000;
        MemWrite_r  = 1'b0;
        ALUSrc_r    = 1'b0;
        RegWrite_r  = 1'b0;
        OpenPort_r  = 1'b0;

        case (opcode)
            OP_RTYPE: begin
                RegDst_r   = 1'b1;
                ALUSrc_r   = 1'b0;
                MemtoReg_r = 1'b0;
                RegWrite_r = 1'b1;
                MemRead_r  = 1'b0;
                MemWrite_r = 1'b0;
                Branch_r   = 1'b0;
                Jump_r     = 1'b0;
                OpenPort_r = 1'b0;

                case (func)
                    FUNC_ADD: ALUOp_r = 4'b0010;
                    FUNC_SUB: ALUOp_r = 4'b0110;
                    FUNC_AND: ALUOp_r = 4'b0000;
                    FUNC_OR : ALUOp_r = 4'b0001;
                    FUNC_SLT: ALUOp_r = 4'b0111;
                    default : ALUOp_r = 4'b0000;
                endcase
            end

            OP_LW: begin
                RegDst_r   = 1'b0;
                ALUSrc_r   = 1'b1;
                MemtoReg_r = 1'b1;
                RegWrite_r = 1'b1;
                MemRead_r  = 1'b1;
                MemWrite_r = 1'b0;
                Branch_r   = 1'b0;
                Jump_r     = 1'b0;
                OpenPort_r = 1'b0;
                ALUOp_r    = 4'b0010;
            end

            OP_SW: begin
                RegDst_r   = 1'b0;
                ALUSrc_r   = 1'b1;
                MemtoReg_r = 1'b0;
                RegWrite_r = 1'b0;
                MemRead_r  = 1'b0;
                MemWrite_r = 1'b1;
                Branch_r   = 1'b0;
                Jump_r     = 1'b0;
                OpenPort_r = 1'b0;
                ALUOp_r    = 4'b0010;
            end

            OP_BEQ: begin
                RegDst_r   = 1'b0;
                ALUSrc_r   = 1'b0;
                MemtoReg_r = 1'b0;
                RegWrite_r = 1'b0;
                MemRead_r  = 1'b0;
                MemWrite_r = 1'b0;
                Branch_r   = 1'b1;
                Jump_r     = 1'b0;
                OpenPort_r = 1'b0;
                ALUOp_r    = 4'b0110;
            end

            OP_JUMP: begin
                RegDst_r   = 1'b0;
                ALUSrc_r   = 1'b0;
                MemtoReg_r = 1'b0;
                RegWrite_r = 1'b0;
                MemRead_r  = 1'b0;
                MemWrite_r = 1'b0;
                Branch_r   = 1'b0;
                Jump_r     = 1'b1;
                OpenPort_r = 1'b0;
                ALUOp_r    = 4'b0000;
            end

            OP_OPENPT: begin
                RegDst_r   = 1'b0;
                ALUSrc_r   = 1'b0;
                MemtoReg_r = 1'b0;
                RegWrite_r = 1'b0;
                MemRead_r  = 1'b0;
                MemWrite_r = 1'b0;
                Branch_r   = 1'b0;
                Jump_r     = 1'b0;
                OpenPort_r = 1'b1;
                ALUOp_r    = 4'b0000;
            end

            default: begin
                RegDst_r   = 1'b0;
                Jump_r     = 1'b0;
                Branch_r   = 1'b0;
                MemRead_r  = 1'b0;
                MemtoReg_r = 1'b0;
                MemWrite_r = 1'b0;
                ALUSrc_r   = 1'b0;
                RegWrite_r = 1'b0;
                OpenPort_r = 1'b0;
                ALUOp_r    = 4'b0000;
            end
        endcase
    end

    assign RegDst   = RegDst_r;
    assign Jump     = Jump_r;
    assign Branch   = Branch_r;
    assign MemRead  = MemRead_r;
    assign MemtoReg = MemtoReg_r;
    assign ALUOp    = ALUOp_r;
    assign MemWrite = MemWrite_r;
    assign ALUSrc   = ALUSrc_r;
    assign RegWrite = RegWrite_r;
    assign OpenPort = OpenPort_r;

endmodule

module dut__SignExtend (
    input  wire [7:0]  imm,
    output wire [15:0] sext
);

    assign sext = {{8{imm[7]}}, imm};

endmodule

module dut__PCUnit (
    input  [0:0]  clk,
    input  [0:0]  reset_n,
    input  [0:0]  pc_write,
    input  [0:0]  Jump,
    input  [0:0]  Branch,
    input  [0:0]  bcond,
    input  [15:0] instruction,
    input  [15:0] sext_imm,
    output [15:0] PC
);

    // Registered PC value
    reg [15:0] PC_reg;
    assign PC = PC_reg;

    // Combinational next-PC computation
    reg [15:0] nextPC;

    always @(*) begin
        // @nextpc @jump, @nextpc @priority: Jump takes highest priority.
        // Jump target = {PC[15:12], instruction[11:0]}
        if (Jump) begin
            nextPC = {PC_reg[15:12], instruction[11:0]};
        end
        // @nextpc @branch @taken: Branch asserted and bcond high -> PC + IMM
        else if (Branch && bcond) begin
            nextPC = PC_reg + sext_imm;
        end
        // @nextpc @branch @not_taken, @nextpc @sequential: default to PC + 1
        else begin
            nextPC = PC_reg + 16'h0001;
        end
    end

    // Sequential PC register update
    always @(posedge clk) begin
        // @reset, @reset @priority: synchronous active-low reset has top priority
        if (!reset_n) begin
            PC_reg <= 16'h0000;
        end
        // @update @enabled: update PC to nextPC when pc_write asserted
        else if (pc_write) begin
            PC_reg <= nextPC;
        end
        // @update @disabled @hold: hold PC when pc_write deasserted
        else begin
            PC_reg <= PC_reg;
        end
        // @stability: no changes occur outside of a rising clk edge,
        // guaranteed by this being the only sequential block driving PC_reg.
    end

endmodule

module dut__IRReg (
    input  [0:0]  clk,
    input  [0:0]  reset_n,
    input  [0:0]  ir_write,
    input  [15:0] instr_in,
    output [15:0] instr_out
);

    // Registered output storage
    reg [15:0] instr_reg;

    assign instr_out = instr_reg;

    // Synchronous behavior: reset, load, hold
    always @(posedge clk) begin
        if (!reset_n) begin
            // @reset: Synchronous reset forces instruction register to zero
            // @reset: Reset takes priority over ir_write
            instr_reg <= 16'h0000;
        end
        else if (ir_write) begin
            // @load: Latch data bus value when ir_write asserted
            // @recovery: Register resumes normal capture after reset deasserted
            instr_reg <= instr_in;
        end
        else begin
            // @hold: Hold previous value when ir_write deasserted
            // @stability: Instruction remains stable across cycles until next fetch
            instr_reg <= instr_reg;
        end
    end

    // @stability: No combinational change - instr_out only updates on clk edge
    // @determinism: Next state depends only on reset_n, ir_write, and instr_in
    //   - reset_n == 0            -> instr_out = 16'h0000
    //   - reset_n == 1, ir_write==1 -> instr_out = instr_in
    //   - reset_n == 1, ir_write==0 -> instr_out remains unchanged

endmodule

module dut__DataMemReg (
    input  [0:0]  clk,
    input  [0:0]  reset_n,
    input  [0:0]  dr_write,
    input  [15:0] data_in,
    output [15:0] data_out
);

    // Internal registered output (dr_out in spec)
    reg [15:0] dr_out_reg;

    //-------------------------------------------------------------------
    // Sequential logic: single clocked always block, non-blocking assigns
    //-------------------------------------------------------------------
    always @(posedge clk) begin
        if (!reset_n) begin
            // @reset / @async_or_sync / @reset_priority:
            // Reset forces dr_out to zero, takes priority over dr_write.
            dr_out_reg <= 16'h0000;
        end
        else if (dr_write) begin
            // @capture / @sequential_capture:
            // Capture data_in into dr_out when dr_write is asserted.
            dr_out_reg <= data_in;
        end
        else begin
            // @hold / @no_dontcare_propagation:
            // Hold current value when dr_write is deasserted; data_in
            // (even unknown/arbitrary) does not affect dr_out.
            dr_out_reg <= dr_out_reg;
        end
    end

    // @stability / @writeback_interface:
    // dr_out remains stable between clock edges since it is a registered
    // output driven only within the clocked always block above.
    assign data_out = dr_out_reg;

endmodule

module dut__InstCounter (
    input  [0:0]  clk,
    input  [0:0]  reset_n,
    input  [0:0]  inc,
    output [15:0] count
);

    // Internal 16-bit counter register (drives "count" output, aka num_inst)
    reg [15:0] count_reg;

    // Continuous assignment: output always mirrors internal register
    // @output_binding: num_inst (count) always equals internal count_reg
    assign count = count_reg;

    always @(posedge clk) begin
        if (!reset_n) begin
            // @reset: Reset forces counter to zero
            // @reset_priority: Reset takes priority over increment
            count_reg <= 16'h0000;
        end
        else if (inc) begin
            // @increment: Counter increments by one when inc pulses high
            // @wraparound: 16'hFFFF + 1 wraps naturally to 16'h0000
            // @single_pulse_increment / @accumulation: repeated pulses
            // accumulate correctly cycle by cycle
            count_reg <= count_reg + 16'h0001;
        end
        else begin
            // @hold: Counter holds value when inc is not asserted
            count_reg <= count_reg;
        end
    end

    // @no_spurious_increment: count_reg only changes on posedge clk,
    // guaranteed by the clocked always block above (no other drivers).

endmodule

module dut__FSMController (
    input  [0:0] clk,
    input  [0:0] reset_n,
    input  [0:0] inputReady,
    input  [0:0] MemRead,
    input  [0:0] MemWrite,
    input  [0:0] RegWrite,
    output [0:0] readM,
    output [0:0] writeM,
    output [0:0] addr_sel,
    output [0:0] ir_write,
    output [0:0] dr_write,
    output [0:0] rf_write,
    output [0:0] pc_write,
    output [0:0] inc_num_inst
);

    // -------------------------------------------------------------------
    // State encoding
    // -------------------------------------------------------------------
    localparam [1:0] FETCH       = 2'b00;
    localparam [1:0] DECODE_EXEC = 2'b01;
    localparam [1:0] MEM_ACCESS  = 2'b10;
    localparam [1:0] WRITEBACK   = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;

    // -------------------------------------------------------------------
    // Sequential state register
    // @reset: Reset forces FSM into FETCH state
    // -------------------------------------------------------------------
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= FETCH; // @reset: reset forces FETCH
        end else begin
            state <= next_state;
        end
    end

    // -------------------------------------------------------------------
    // Next-state combinational logic
    // -------------------------------------------------------------------
    always @(*) begin
        // Default: stay in current state (avoids latches, covers stall cases)
        next_state = state;
        case (state)
            // @fetch @stall / @fetch @transition
            FETCH: begin
                if (inputReady)
                    next_state = DECODE_EXEC; // pulse ir_write, advance
                else
                    next_state = FETCH; // remain while inputReady deasserted
            end

            // @decode_exec @transition
            DECODE_EXEC: begin
                if (MemRead || MemWrite)
                    next_state = MEM_ACCESS; // memory op required
                else
                    next_state = WRITEBACK;  // no memory op required
            end

            // @mem_access @stall / @mem_access transitions
            MEM_ACCESS: begin
                if (inputReady)
                    next_state = WRITEBACK; // load or store complete
                else
                    next_state = MEM_ACCESS; // stall while not ready
            end

            // @writeback @transition
            WRITEBACK: begin
                next_state = FETCH; // unconditional return to FETCH
            end

            default: next_state = FETCH;
        endcase
    end

    // -------------------------------------------------------------------
    // Combinational outputs (Mealy-style pulses based on state & inputs)
    // -------------------------------------------------------------------
    reg readM_c;
    reg writeM_c;
    reg addr_sel_c;
    reg ir_write_c;
    reg dr_write_c;
    reg rf_write_c;
    reg pc_write_c;
    reg inc_num_inst_c;

    always @(*) begin
        // Default safe values - avoids latches, satisfies
        // @safety @no_spurious_writes and @safety @bus_control
        readM_c        = 1'b0;
        writeM_c       = 1'b0;
        addr_sel_c     = 1'b0; // 0 = PC, 1 = ALUResult
        ir_write_c     = 1'b0;
        dr_write_c     = 1'b0;
        rf_write_c     = 1'b0;
        pc_write_c     = 1'b0;
        inc_num_inst_c = 1'b0;

        case (state)
            // @fetch @combinational / @fetch @stall / @fetch @transition
            FETCH: begin
                readM_c    = 1'b1;      // assert readM during FETCH
                writeM_c   = 1'b0;
                addr_sel_c = 1'b0;      // address_sel selects PC
                if (inputReady)
                    ir_write_c = 1'b1;  // pulse ir_write exactly this cycle
                else
                    ir_write_c = 1'b0;  // no pulse while stalling
            end

            // @decode_exec @combinational
            DECODE_EXEC: begin
                readM_c  = 1'b0;
                writeM_c = 1'b0;
                // addr_sel don't-care here; default 0 keeps it safe
            end

            // @mem_access @load/@store @combinational
            MEM_ACCESS: begin
                addr_sel_c = 1'b1; // address_sel selects ALUResult
                if (MemRead) begin
                    readM_c  = 1'b1;
                    writeM_c = 1'b0;
                    if (inputReady)
                        dr_write_c = 1'b1; // pulse dr_write for load completion
                    else
                        dr_write_c = 1'b0;
                end else if (MemWrite) begin
                    readM_c  = 1'b0;
                    writeM_c = 1'b1;
                    dr_write_c = 1'b0; // never pulse dr_write during store
                end else begin
                    readM_c  = 1'b0;
                    writeM_c = 1'b0;
                    dr_write_c = 1'b0;
                end
            end

            // @writeback scenarios
            WRITEBACK: begin
                readM_c  = 1'b0;
                writeM_c = 1'b0;
                if (RegWrite)
                    rf_write_c = 1'b1; // pulse rf_write when RegWrite asserted
                else
                    rf_write_c = 1'b0;

                pc_write_c     = 1'b1; // pulse pc_write, latch nextPC
                inc_num_inst_c = 1'b1; // pulse inc, increment InstCounter
            end

            default: begin
                readM_c        = 1'b1;
                writeM_c       = 1'b0;
                addr_sel_c     = 1'b0;
                ir_write_c     = 1'b0;
                dr_write_c     = 1'b0;
                rf_write_c     = 1'b0;
                pc_write_c     = 1'b0;
                inc_num_inst_c = 1'b0;
            end
        endcase
    end

    // -------------------------------------------------------------------
    // Output assignments
    // -------------------------------------------------------------------
    assign readM        = readM_c;
    assign writeM        = writeM_c;
    assign addr_sel      = addr_sel_c;
    assign ir_write      = ir_write_c;
    assign dr_write      = dr_write_c;
    assign rf_write      = rf_write_c;
    assign pc_write      = pc_write_c;
    assign inc_num_inst  = inc_num_inst_c;

endmodule
