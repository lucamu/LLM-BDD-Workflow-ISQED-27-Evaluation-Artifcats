//----------------------------------------------------------------------------
// Copyright (C) 2009 , Olivier Girard
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the authors nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
// OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
// THE POSSIBILITY OF SUCH DAMAGE
//
//----------------------------------------------------------------------------
//
// *File Name: openMSP430.v
//
// *Module Description:
//                       openMSP430 Top level file
//
// *Author(s):
//              - Olivier Girard,    olgirard@gmail.com
//
//----------------------------------------------------------------------------
// $Rev: 202 $
// $LastChangedBy: olivier.girard $
// $LastChangedDate: 2015-07-01 23:13:32 +0200 (Wed, 01 Jul 2015) $
//----------------------------------------------------------------------------
`ifdef OMSP_NO_INCLUDE
`else
`include "openMSP430_defines.v"
`endif

module  openMSP430 (

// OUTPUTs
    aclk,                                    // ASIC ONLY: ACLK
    aclk_en,                                 // FPGA ONLY: ACLK enable
    dbg_freeze,                              // Freeze peripherals
    dbg_i2c_sda_out,                         // Debug interface: I2C SDA OUT
    dbg_uart_txd,                            // Debug interface: UART TXD
    dco_enable,                              // ASIC ONLY: Fast oscillator enable
    dco_wkup,                                // ASIC ONLY: Fast oscillator wake-up (asynchronous)
    dmem_addr,                               // Data Memory address
    dmem_cen,                                // Data Memory chip enable (low active)
    dmem_din,                                // Data Memory data input
    dmem_wen,                                // Data Memory write byte enable (low active)
    irq_acc,                                 // Interrupt request accepted (one-hot signal)
    lfxt_enable,                             // ASIC ONLY: Low frequency oscillator enable
    lfxt_wkup,                               // ASIC ONLY: Low frequency oscillator wake-up (asynchronous)
    mclk,                                    // Main system clock
    dma_dout,                                // Direct Memory Access data output
    dma_ready,                               // Direct Memory Access is complete
    dma_resp,                                // Direct Memory Access response (0:Okay / 1:Error)
    per_addr,                                // Peripheral address
    per_din,                                 // Peripheral data input
    per_en,                                  // Peripheral enable (high active)
    per_we,                                  // Peripheral write byte enable (high active)
    pmem_addr,                               // Program Memory address
    pmem_cen,                                // Program Memory chip enable (low active)
    pmem_din,                                // Program Memory data input (optional)
    pmem_wen,                                // Program Memory write byte enable (low active) (optional)
    puc_rst,                                 // Main system reset
    smclk,                                   // ASIC ONLY: SMCLK
    smclk_en,                                // FPGA ONLY: SMCLK enable

// INPUTs
    cpu_en,                                  // Enable CPU code execution (asynchronous and non-glitchy)
    dbg_en,                                  // Debug interface enable (asynchronous and non-glitchy)
    dbg_i2c_addr,                            // Debug interface: I2C Address
    dbg_i2c_broadcast,                       // Debug interface: I2C Broadcast Address (for multicore systems)
    dbg_i2c_scl,                             // Debug interface: I2C SCL
    dbg_i2c_sda_in,                          // Debug interface: I2C SDA IN
    dbg_uart_rxd,                            // Debug interface: UART RXD (asynchronous)
    dco_clk,                                 // Fast oscillator (fast clock)
    dmem_dout,                               // Data Memory data output
    irq,                                     // Maskable interrupts
    lfxt_clk,                                // Low frequency oscillator (typ 32kHz)
    dma_addr,                                // Direct Memory Access address
    dma_din,                                 // Direct Memory Access data input
    dma_en,                                  // Direct Memory Access enable (high active)
    dma_priority,                            // Direct Memory Access priority (0:low / 1:high)
    dma_we,                                  // Direct Memory Access write byte enable (high active)
    dma_wkup,                                // ASIC ONLY: DMA Sub-System Wake-up (asynchronous and non-glitchy)
    nmi,                                     // Non-maskable interrupt (asynchronous)
    per_dout,                                // Peripheral data output
    pmem_dout,                               // Program Memory data output
    reset_n,                                 // Reset Pin (low active, asynchronous and non-glitchy)
    scan_enable,                             // ASIC ONLY: Scan enable (active during scan shifting)
    scan_mode,                               // ASIC ONLY: Scan mode
    wkup                                     // ASIC ONLY: System Wake-up (asynchronous and non-glitchy)
);

// PARAMETERs
//============
parameter            INST_NR  = 8'h00;       // Current oMSP instance number     (for multicore systems)
parameter            TOTAL_NR = 8'h00;       // Total number of oMSP instances-1 (for multicore systems)

// OUTPUTs
//============
output               aclk;                   // ASIC ONLY: ACLK
output               aclk_en;                // FPGA ONLY: ACLK enable
output               dbg_freeze;             // Freeze peripherals
output               dbg_i2c_sda_out;        // Debug interface: I2C SDA OUT
output               dbg_uart_txd;           // Debug interface: UART TXD
output               dco_enable;             // ASIC ONLY: Fast oscillator enable
output               dco_wkup;               // ASIC ONLY: Fast oscillator wake-up (asynchronous)
output [`DMEM_MSB:0] dmem_addr;              // Data Memory address
output               dmem_cen;               // Data Memory chip enable (low active)
output        [15:0] dmem_din;               // Data Memory data input
output         [1:0] dmem_wen;               // Data Memory write byte enable (low active)
output [`IRQ_NR-3:0] irq_acc;                // Interrupt request accepted (one-hot signal)
output               lfxt_enable;            // ASIC ONLY: Low frequency oscillator enable
output               lfxt_wkup;              // ASIC ONLY: Low frequency oscillator wake-up (asynchronous)
output               mclk;                   // Main system clock
output        [15:0] dma_dout;               // Direct Memory Access data output
output               dma_ready;              // Direct Memory Access is complete
output               dma_resp;               // Direct Memory Access response (0:Okay / 1:Error)
output        [13:0] per_addr;               // Peripheral address
output        [15:0] per_din;                // Peripheral data input
output               per_en;                 // Peripheral enable (high active)
output         [1:0] per_we;                 // Peripheral write byte enable (high active)
output [`PMEM_MSB:0] pmem_addr;              // Program Memory address
output               pmem_cen;               // Program Memory chip enable (low active)
output        [15:0] pmem_din;               // Program Memory data input (optional)
output         [1:0] pmem_wen;               // Program Memory write enable (low active) (optional)
output               puc_rst;                // Main system reset
output               smclk;                  // ASIC ONLY: SMCLK
output               smclk_en;               // FPGA ONLY: SMCLK enable


// INPUTs
//============
input                cpu_en;                 // Enable CPU code execution (asynchronous and non-glitchy)
input                dbg_en;                 // Debug interface enable (asynchronous and non-glitchy)
input          [6:0] dbg_i2c_addr;           // Debug interface: I2C Address
input          [6:0] dbg_i2c_broadcast;      // Debug interface: I2C Broadcast Address (for multicore systems)
input                dbg_i2c_scl;            // Debug interface: I2C SCL
input                dbg_i2c_sda_in;         // Debug interface: I2C SDA IN
input                dbg_uart_rxd;           // Debug interface: UART RXD (asynchronous)
input                dco_clk;                // Fast oscillator (fast clock)
input         [15:0] dmem_dout;              // Data Memory data output
input  [`IRQ_NR-3:0] irq;                    // Maskable interrupts (14, 30 or 62)
input                lfxt_clk;               // Low frequency oscillator (typ 32kHz)
input         [15:1] dma_addr;               // Direct Memory Access address
input         [15:0] dma_din;                // Direct Memory Access data input
input                dma_en;                 // Direct Memory Access enable (high active)
input                dma_priority;           // Direct Memory Access priority (0:low / 1:high)
input          [1:0] dma_we;                 // Direct Memory Access write byte enable (high active)
input                dma_wkup;               // ASIC ONLY: DMA Wake-up (asynchronous and non-glitchy)
input                nmi;                    // Non-maskable interrupt (asynchronous and non-glitchy)
input         [15:0] per_dout;               // Peripheral data output
input         [15:0] pmem_dout;              // Program Memory data output
input                reset_n;                // Reset Pin (active low, asynchronous and non-glitchy)
input                scan_enable;            // ASIC ONLY: Scan enable (active during scan shifting)
input                scan_mode;              // ASIC ONLY: Scan mode
input                wkup;                   // ASIC ONLY: System Wake-up (asynchronous and non-glitchy)



//=============================================================================
// 1)  INTERNAL WIRES/REGISTERS/PARAMETERS DECLARATION
//=============================================================================

wire           [7:0] inst_ad;
wire           [7:0] inst_as;
wire          [11:0] inst_alu;
wire                 inst_bw;
wire                 inst_irq_rst;
wire                 inst_mov;
wire          [15:0] inst_dest;
wire          [15:0] inst_dext;
wire          [15:0] inst_sext;
wire           [7:0] inst_so;
wire          [15:0] inst_src;
wire           [2:0] inst_type;
wire           [7:0] inst_jmp;
wire           [3:0] e_state;
wire                 exec_done;
wire                 decode_noirq;
wire                 cpu_en_s;
wire                 cpuoff;
wire                 oscoff;
wire                 scg0;
wire                 scg1;
wire                 por;
wire                 gie;
wire                 cpu_mclk;
wire                 dma_mclk;
wire                 mclk_dma_enable;
wire                 mclk_dma_wkup;
wire                 mclk_enable;
wire                 mclk_wkup;
wire          [31:0] cpu_id;
wire           [7:0] cpu_nr_inst  = INST_NR;
wire           [7:0] cpu_nr_total = TOTAL_NR;

wire          [15:0] eu_mab;
wire          [15:0] eu_mdb_in;
wire          [15:0] eu_mdb_out;
wire           [1:0] eu_mb_wr;
wire                 eu_mb_en;
wire          [15:0] fe_mab;
wire          [15:0] fe_mdb_in;
wire                 fe_mb_en;
wire                 fe_pmem_wait;

wire                 pc_sw_wr;
wire          [15:0] pc_sw;
wire          [15:0] pc;
wire          [15:0] pc_nxt;

wire                 nmi_acc;
wire                 nmi_pnd;
wire                 nmi_wkup;

wire                 wdtie;
wire                 wdtnmies;
wire                 wdtifg;
wire                 wdt_irq;
wire                 wdt_wkup;
wire                 wdt_reset;
wire                 wdtifg_sw_clr;
wire                 wdtifg_sw_set;

wire                 dbg_clk;
wire                 dbg_rst;
wire                 dbg_en_s;
wire                 dbg_halt_cmd;
wire                 dbg_mem_en;
wire                 dbg_reg_wr;
wire                 dbg_cpu_reset;
wire          [15:0] dbg_mem_addr;
wire          [15:0] dbg_mem_dout;
wire          [15:0] dbg_mem_din;
wire          [15:0] dbg_reg_din;
wire           [1:0] dbg_mem_wr;

wire                 cpu_halt_st;
wire                 cpu_halt_cmd;
wire                 puc_pnd_set;

wire          [15:0] per_dout_or;
wire          [15:0] per_dout_sfr;
wire          [15:0] per_dout_wdog;
wire          [15:0] per_dout_mpy;
wire          [15:0] per_dout_clk;


//=============================================================================
// 2)  GLOBAL CLOCK & RESET MANAGEMENT
//=============================================================================

omsp_clock_module clock_module_0 (

// OUTPUTs
    .aclk              (aclk),               // ACLK
    .aclk_en           (aclk_en),            // ACLK enablex
    .cpu_en_s          (cpu_en_s),           // Enable CPU code execution (synchronous)
    .cpu_mclk          (cpu_mclk),           // Main system CPU only clock
    .dma_mclk          (dma_mclk),           // Main system DMA and/or CPU clock
    .dbg_clk           (dbg_clk),            // Debug unit clock
    .dbg_en_s          (dbg_en_s),           // Debug interface enable (synchronous)
    .dbg_rst           (dbg_rst),            // Debug unit reset
    .dco_enable        (dco_enable),         // Fast oscillator enable
    .dco_wkup          (dco_wkup),           // Fast oscillator wake-up (asynchronous)
    .lfxt_enable       (lfxt_enable),        // Low frequency oscillator enable
    .lfxt_wkup         (lfxt_wkup),          // Low frequency oscillator wake-up (asynchronous)
    .per_dout          (per_dout_clk),       // Peripheral data output
    .por               (por),                // Power-on reset
    .puc_pnd_set       (puc_pnd_set),        // PUC pending set for the serial debug interface
    .puc_rst           (puc_rst),            // Main system reset
    .smclk             (smclk),              // SMCLK
    .smclk_en          (smclk_en),           // SMCLK enable

// INPUTs
    .cpu_en            (cpu_en),             // Enable CPU code execution (asynchronous)
    .cpuoff            (cpuoff),             // Turns off the CPU
    .dbg_cpu_reset     (dbg_cpu_reset),      // Reset CPU from debug interface
    .dbg_en            (dbg_en),             // Debug interface enable (asynchronous)
    .dco_clk           (dco_clk),            // Fast oscillator (fast clock)
    .lfxt_clk          (lfxt_clk),           // Low frequency oscillator (typ 32kHz)
    .mclk_dma_enable   (mclk_dma_enable),    // DMA Sub-System Clock enable
    .mclk_dma_wkup     (mclk_dma_wkup),      // DMA Sub-System Clock wake-up (asynchronous)
    .mclk_enable       (mclk_enable),        // Main System Clock enable
    .mclk_wkup         (mclk_wkup),          // Main System Clock wake-up (asynchronous)
    .oscoff            (oscoff),             // Turns off LFXT1 clock input
    .per_addr          (per_addr),           // Peripheral address
    .per_din           (per_din),            // Peripheral data input
    .per_en            (per_en),             // Peripheral enable (high active)
    .per_we            (per_we),             // Peripheral write enable (high active)
    .reset_n           (reset_n),            // Reset Pin (low active, asynchronous)
    .scan_enable       (scan_enable),        // Scan enable (active during scan shifting)
    .scan_mode         (scan_mode),          // Scan mode
    .scg0              (scg0),               // System clock generator 1. Turns off the DCO
    .scg1              (scg1),               // System clock generator 1. Turns off the SMCLK
    .wdt_reset         (wdt_reset)           // Watchdog-timer reset
);

assign mclk = dma_mclk;


//=============================================================================
// 3)  FRONTEND (<=> FETCH & DECODE)
//=============================================================================

omsp_frontend frontend_0 (

// OUTPUTs
    .cpu_halt_st       (cpu_halt_st),        // Halt/Run status from CPU
    .decode_noirq      (decode_noirq),       // Frontend decode instruction
    .e_state           (e_state),            // Execution state
    .exec_done         (exec_done),          // Execution completed
    .inst_ad           (inst_ad),            // Decoded Inst: destination addressing mode
    .inst_as           (inst_as),            // Decoded Inst: source addressing mode
    .inst_alu          (inst_alu),           // ALU control signals
    .inst_bw           (inst_bw),            // Decoded Inst: byte width
    .inst_dest         (inst_dest),          // Decoded Inst: destination (one hot)
    .inst_dext         (inst_dext),          // Decoded Inst: destination extended instruction word
    .inst_irq_rst      (inst_irq_rst),       // Decoded Inst: Reset interrupt
    .inst_jmp          (inst_jmp),           // Decoded Inst: Conditional jump
    .inst_mov          (inst_mov),           // Decoded Inst: mov instruction
    .inst_sext         (inst_sext),          // Decoded Inst: source extended instruction word
    .inst_so           (inst_so),            // Decoded Inst: Single-operand arithmetic
    .inst_src          (inst_src),           // Decoded Inst: source (one hot)
    .inst_type         (inst_type),          // Decoded Instruction type
    .irq_acc           (irq_acc),            // Interrupt request accepted
    .mab               (fe_mab),             // Frontend Memory address bus
    .mb_en             (fe_mb_en),           // Frontend Memory bus enable
    .mclk_dma_enable   (mclk_dma_enable),    // DMA Sub-System Clock enable
    .mclk_dma_wkup     (mclk_dma_wkup),      // DMA Sub-System Clock wake-up (asynchronous)
    .mclk_enable       (mclk_enable),        // Main System Clock enable
    .mclk_wkup         (mclk_wkup),          // Main System Clock wake-up (asynchronous)
    .nmi_acc           (nmi_acc),            // Non-Maskable interrupt request accepted
    .pc                (pc),                 // Program counter
    .pc_nxt            (pc_nxt),             // Next PC value (for CALL & IRQ)

// INPUTs
    .cpu_en_s          (cpu_en_s),           // Enable CPU code execution (synchronous)
    .cpu_halt_cmd      (cpu_halt_cmd),       // Halt CPU command
    .cpuoff            (cpuoff),             // Turns off the CPU
    .dbg_reg_sel       (dbg_mem_addr[3:0]),  // Debug selected register for rd/wr access
    .dma_en            (dma_en),             // Direct Memory Access enable (high active)
    .dma_wkup          (dma_wkup),           // DMA Sub-System Wake-up (asynchronous and non-glitchy)
    .fe_pmem_wait      (fe_pmem_wait),       // Frontend wait for Instruction fetch
    .gie               (gie),                // General interrupt enable
    .irq               (irq),                // Maskable interrupts
    .mclk              (cpu_mclk),           // Main system clock
    .mdb_in            (fe_mdb_in),          // Frontend Memory data bus input
    .nmi_pnd           (nmi_pnd),            // Non-maskable interrupt pending
    .nmi_wkup          (nmi_wkup),           // NMI Wakeup
    .pc_sw             (pc_sw),              // Program counter software value
    .pc_sw_wr          (pc_sw_wr),           // Program counter software write
    .puc_rst           (puc_rst),            // Main system reset
    .scan_enable       (scan_enable),        // Scan enable (active during scan shifting)
    .wdt_irq           (wdt_irq),            // Watchdog-timer interrupt
    .wdt_wkup          (wdt_wkup),           // Watchdog Wakeup
    .wkup              (wkup)                // System Wake-up (asynchronous)
);


//=============================================================================
// 4)  EXECUTION UNIT
//=============================================================================

omsp_execution_unit execution_unit_0 (

// OUTPUTs
    .cpuoff            (cpuoff),             // Turns off the CPU
    .dbg_reg_din       (dbg_reg_din),        // Debug unit CPU register data input
    .mab               (eu_mab),             // Memory address bus
    .mb_en             (eu_mb_en),           // Memory bus enable
    .mb_wr             (eu_mb_wr),           // Memory bus write transfer
    .mdb_out           (eu_mdb_out),         // Memory data bus output
    .oscoff            (oscoff),             // Turns off LFXT1 clock input
    .pc_sw             (pc_sw),              // Program counter software value
    .pc_sw_wr          (pc_sw_wr),           // Program counter software write
    .scg0              (scg0),               // System clock generator 1. Turns off the DCO
    .scg1              (scg1),               // System clock generator 1. Turns off the SMCLK

// INPUTs
    .dbg_halt_st       (cpu_halt_st),        // Halt/Run status from CPU
    .dbg_mem_dout      (dbg_mem_dout),       // Debug unit data output
    .dbg_reg_wr        (dbg_reg_wr),         // Debug unit CPU register write
    .e_state           (e_state),            // Execution state
    .exec_done         (exec_done),          // Execution completed
    .gie               (gie),                // General interrupt enable
    .inst_ad           (inst_ad),            // Decoded Inst: destination addressing mode
    .inst_as           (inst_as),            // Decoded Inst: source addressing mode
    .inst_alu          (inst_alu),           // ALU control signals
    .inst_bw           (inst_bw),            // Decoded Inst: byte width
    .inst_dest         (inst_dest),          // Decoded Inst: destination (one hot)
    .inst_dext         (inst_dext),          // Decoded Inst: destination extended instruction word
    .inst_irq_rst      (inst_irq_rst),       // Decoded Inst: reset interrupt
    .inst_jmp          (inst_jmp),           // Decoded Inst: Conditional jump
    .inst_mov          (inst_mov),           // Decoded Inst: mov instruction
    .inst_sext         (inst_sext),          // Decoded Inst: source extended instruction word
    .inst_so           (inst_so),            // Decoded Inst: Single-operand arithmetic
    .inst_src          (inst_src),           // Decoded Inst: source (one hot)
    .inst_type         (inst_type),          // Decoded Instruction type
    .mclk              (cpu_mclk),           // Main system clock
    .mdb_in            (eu_mdb_in),          // Memory data bus input
    .pc                (pc),                 // Program counter
    .pc_nxt            (pc_nxt),             // Next PC value (for CALL & IRQ)
    .puc_rst           (puc_rst),            // Main system reset
    .scan_enable       (scan_enable)         // Scan enable (active during scan shifting)
);


//=============================================================================
// 5)  MEMORY BACKBONE
//=============================================================================

omsp_mem_backbone mem_backbone_0 (

// OUTPUTs
    .cpu_halt_cmd      (cpu_halt_cmd),       // Halt CPU command
    .dbg_mem_din       (dbg_mem_din),        // Debug unit Memory data input
    .dmem_addr         (dmem_addr),          // Data Memory address
    .dmem_cen          (dmem_cen),           // Data Memory chip enable (low active)
    .dmem_din          (dmem_din),           // Data Memory data input
    .dmem_wen          (dmem_wen),           // Data Memory write enable (low active)
    .eu_mdb_in         (eu_mdb_in),          // Execution Unit Memory data bus input
    .fe_mdb_in         (fe_mdb_in),          // Frontend Memory data bus input
    .fe_pmem_wait      (fe_pmem_wait),       // Frontend wait for Instruction fetch
    .dma_dout          (dma_dout),           // Direct Memory Access data output
    .dma_ready         (dma_ready),          // Direct Memory Access is complete
    .dma_resp          (dma_resp),           // Direct Memory Access response (0:Okay / 1:Error)
    .per_addr          (per_addr),           // Peripheral address
    .per_din           (per_din),            // Peripheral data input
    .per_we            (per_we),             // Peripheral write enable (high active)
    .per_en            (per_en),             // Peripheral enable (high active)
    .pmem_addr         (pmem_addr),          // Program Memory address
    .pmem_cen          (pmem_cen),           // Program Memory chip enable (low active)
    .pmem_din          (pmem_din),           // Program Memory data input (optional)
    .pmem_wen          (pmem_wen),           // Program Memory write enable (low active) (optional)

// INPUTs
    .cpu_halt_st       (cpu_halt_st),        // Halt/Run status from CPU
    .dbg_halt_cmd      (dbg_halt_cmd),       // Debug interface Halt CPU command
    .dbg_mem_addr      (dbg_mem_addr[15:1]), // Debug address for rd/wr access
    .dbg_mem_dout      (dbg_mem_dout),       // Debug unit data output
    .dbg_mem_en        (dbg_mem_en),         // Debug unit memory enable
    .dbg_mem_wr        (dbg_mem_wr),         // Debug unit memory write
    .dmem_dout         (dmem_dout),          // Data Memory data output
    .eu_mab            (eu_mab[15:1]),       // Execution Unit Memory address bus
    .eu_mb_en          (eu_mb_en),           // Execution Unit Memory bus enable
    .eu_mb_wr          (eu_mb_wr),           // Execution Unit Memory bus write transfer
    .eu_mdb_out        (eu_mdb_out),         // Execution Unit Memory data bus output
    .fe_mab            (fe_mab[15:1]),       // Frontend Memory address bus
    .fe_mb_en          (fe_mb_en),           // Frontend Memory bus enable
    .mclk              (dma_mclk),           // Main system clock
    .dma_addr          (dma_addr),           // Direct Memory Access address
    .dma_din           (dma_din),            // Direct Memory Access data input
    .dma_en            (dma_en),             // Direct Memory Access enable (high active)
    .dma_priority      (dma_priority),       // Direct Memory Access priority (0:low / 1:high)
    .dma_we            (dma_we),             // Direct Memory Access write byte enable (high active)
    .per_dout          (per_dout_or),        // Peripheral data output
    .pmem_dout         (pmem_dout),          // Program Memory data output
    .puc_rst           (puc_rst),            // Main system reset
    .scan_enable       (scan_enable)         // Scan enable (active during scan shifting)
);

wire UNUSED_fe_mab_0 = fe_mab[0];

//=============================================================================
// 6)  SPECIAL FUNCTION REGISTERS
//=============================================================================
omsp_sfr sfr_0 (

// OUTPUTs
    .cpu_id            (cpu_id),             // CPU ID
    .nmi_pnd           (nmi_pnd),            // NMI Pending
    .nmi_wkup          (nmi_wkup),           // NMI Wakeup
    .per_dout          (per_dout_sfr),       // Peripheral data output
    .wdtie             (wdtie),              // Watchdog-timer interrupt enable
    .wdtifg_sw_clr     (wdtifg_sw_clr),      // Watchdog-timer interrupt flag software clear
    .wdtifg_sw_set     (wdtifg_sw_set),      // Watchdog-timer interrupt flag software set

// INPUTs
    .cpu_nr_inst       (cpu_nr_inst),        // Current oMSP instance number
    .cpu_nr_total      (cpu_nr_total),       // Total number of oMSP instances-1
    .mclk              (dma_mclk),           // Main system clock
    .nmi               (nmi),                // Non-maskable interrupt (asynchronous)
    .nmi_acc           (nmi_acc),            // Non-Maskable interrupt request accepted
    .per_addr          (per_addr),           // Peripheral address
    .per_din           (per_din),            // Peripheral data input
    .per_en            (per_en),             // Peripheral enable (high active)
    .per_we            (per_we),             // Peripheral write enable (high active)
    .puc_rst           (puc_rst),            // Main system reset
    .scan_mode         (scan_mode),          // Scan mode
    .wdtifg            (wdtifg),             // Watchdog-timer interrupt flag
    .wdtnmies          (wdtnmies)            // Watchdog-timer NMI edge selection
);


//=============================================================================
// 7)  WATCHDOG TIMER
//=============================================================================
`ifdef WATCHDOG
omsp_watchdog watchdog_0 (

// OUTPUTs
    .per_dout          (per_dout_wdog),      // Peripheral data output
    .wdt_irq           (wdt_irq),            // Watchdog-timer interrupt
    .wdt_reset         (wdt_reset),          // Watchdog-timer reset
    .wdt_wkup          (wdt_wkup),           // Watchdog Wakeup
    .wdtifg            (wdtifg),             // Watchdog-timer interrupt flag
    .wdtnmies          (wdtnmies),           // Watchdog-timer NMI edge selection

// INPUTs
    .aclk              (aclk),               // ACLK
    .aclk_en           (aclk_en),            // ACLK enable
    .dbg_freeze        (dbg_freeze),         // Freeze Watchdog counter
    .mclk              (dma_mclk),           // Main system clock
    .per_addr          (per_addr),           // Peripheral address
    .per_din           (per_din),            // Peripheral data input
    .per_en            (per_en),             // Peripheral enable (high active)
    .per_we            (per_we),             // Peripheral write enable (high active)
    .por               (por),                // Power-on reset
    .puc_rst           (puc_rst),            // Main system reset
    .scan_enable       (scan_enable),        // Scan enable (active during scan shifting)
    .scan_mode         (scan_mode),          // Scan mode
    .smclk             (smclk),              // SMCLK
    .smclk_en          (smclk_en),           // SMCLK enable
    .wdtie             (wdtie),              // Watchdog-timer interrupt enable
    .wdtifg_irq_clr    (irq_acc[`IRQ_NR-6]), // Clear Watchdog-timer interrupt flag
    .wdtifg_sw_clr     (wdtifg_sw_clr),      // Watchdog-timer interrupt flag software clear
    .wdtifg_sw_set     (wdtifg_sw_set)       // Watchdog-timer interrupt flag software set
);
`else
assign per_dout_wdog        = 16'h0000;
assign wdt_irq              =  1'b0;
assign wdt_reset            =  1'b0;
assign wdt_wkup             =  1'b0;
assign wdtifg               =  1'b0;
assign wdtnmies             =  1'b0;
wire   UNUSED_por           =  por;
wire   UNUSED_wdtie         =  wdtie;
wire   UNUSED_wdtifg_sw_clr =  wdtifg_sw_clr;
wire   UNUSED_wdtifg_sw_set =  wdtifg_sw_set;
`endif


//=============================================================================
// 8)  HARDWARE MULTIPLIER
//=============================================================================
`ifdef MULTIPLIER
omsp_multiplier multiplier_0 (

// OUTPUTs
    .per_dout          (per_dout_mpy),       // Peripheral data output

// INPUTs
    .mclk              (dma_mclk),           // Main system clock
    .per_addr          (per_addr),           // Peripheral address
    .per_din           (per_din),            // Peripheral data input
    .per_en            (per_en),             // Peripheral enable (high active)
    .per_we            (per_we),             // Peripheral write enable (high active)
    .puc_rst           (puc_rst),            // Main system reset
    .scan_enable       (scan_enable)         // Scan enable (active during scan shifting)
);
`else
assign per_dout_mpy = 16'h0000;
`endif

//=============================================================================
// 9)  PERIPHERALS' OUTPUT BUS
//=============================================================================

assign  per_dout_or  =  per_dout      |
                        per_dout_clk  |
                        per_dout_sfr  |
                        per_dout_wdog |
                        per_dout_mpy;


//=============================================================================
// 10)  DEBUG INTERFACE
//=============================================================================

`ifdef DBG_EN
omsp_dbg dbg_0 (

// OUTPUTs
    .dbg_cpu_reset     (dbg_cpu_reset),      // Reset CPU from debug interface
    .dbg_freeze        (dbg_freeze),         // Freeze peripherals
    .dbg_halt_cmd      (dbg_halt_cmd),       // Halt CPU command
    .dbg_i2c_sda_out   (dbg_i2c_sda_out),    // Debug interface: I2C SDA OUT
    .dbg_mem_addr      (dbg_mem_addr),       // Debug address for rd/wr access
    .dbg_mem_dout      (dbg_mem_dout),       // Debug unit data output
    .dbg_mem_en        (dbg_mem_en),         // Debug unit memory enable
    .dbg_mem_wr        (dbg_mem_wr),         // Debug unit memory write
    .dbg_reg_wr        (dbg_reg_wr),         // Debug unit CPU register write
    .dbg_uart_txd      (dbg_uart_txd),       // Debug interface: UART TXD

// INPUTs
    .cpu_en_s          (cpu_en_s),           // Enable CPU code execution (synchronous)
    .cpu_id            (cpu_id),             // CPU ID
    .cpu_nr_inst       (cpu_nr_inst),        // Current oMSP instance number
    .cpu_nr_total      (cpu_nr_total),       // Total number of oMSP instances-1
    .dbg_clk           (dbg_clk),            // Debug unit clock
    .dbg_en_s          (dbg_en_s),           // Debug interface enable (synchronous)
    .dbg_halt_st       (cpu_halt_st),        // Halt/Run status from CPU
    .dbg_i2c_addr      (dbg_i2c_addr),       // Debug interface: I2C Address
    .dbg_i2c_broadcast (dbg_i2c_broadcast),  // Debug interface: I2C Broadcast Address (for multicore systems)
    .dbg_i2c_scl       (dbg_i2c_scl),        // Debug interface: I2C SCL
    .dbg_i2c_sda_in    (dbg_i2c_sda_in),     // Debug interface: I2C SDA IN
    .dbg_mem_din       (dbg_mem_din),        // Debug unit Memory data input
    .dbg_reg_din       (dbg_reg_din),        // Debug unit CPU register data input
    .dbg_rst           (dbg_rst),            // Debug unit reset
    .dbg_uart_rxd      (dbg_uart_rxd),       // Debug interface: UART RXD (asynchronous)
    .decode_noirq      (decode_noirq),       // Frontend decode instruction
    .eu_mab            (eu_mab),             // Execution-Unit Memory address bus
    .eu_mb_en          (eu_mb_en),           // Execution-Unit Memory bus enable
    .eu_mb_wr          (eu_mb_wr),           // Execution-Unit Memory bus write transfer
    .fe_mdb_in         (fe_mdb_in),          // Frontend Memory data bus input
    .pc                (pc),                 // Program counter
    .puc_pnd_set       (puc_pnd_set)         // PUC pending set for the serial debug interface
);

`else
assign      dbg_cpu_reset            =  1'b0;
assign      dbg_freeze               =  ~cpu_en_s;
assign      dbg_halt_cmd             =  1'b0;
assign      dbg_i2c_sda_out          =  1'b1;
assign      dbg_mem_addr             = 16'h0000;
assign      dbg_mem_dout             = 16'h0000;
assign      dbg_mem_en               =  1'b0;
assign      dbg_mem_wr               =  2'b00;
assign      dbg_reg_wr               =  1'b0;
assign      dbg_uart_txd             =  1'b1;
wire        UNUSED_decode_noirq      = decode_noirq;
wire [31:0] UNUSED_cpu_id            = cpu_id;
wire        UNUSED_eu_mab_0          = eu_mab[0];
wire        UNUSED_dbg_clk           = dbg_clk;
wire        UNUSED_dbg_rst           = dbg_rst;
wire        UNUSED_dbg_en_s          = dbg_en_s;
wire [15:0] UNUSED_dbg_mem_din       = dbg_mem_din;
wire [15:0] UNUSED_dbg_reg_din       = dbg_reg_din;
wire        UNUSED_puc_pnd_set       = puc_pnd_set;
wire  [6:0] UNUSED_dbg_i2c_addr      = dbg_i2c_addr;
wire  [6:0] UNUSED_dbg_i2c_broadcast = dbg_i2c_broadcast;
wire        UNUSED_dbg_i2c_scl       = dbg_i2c_scl;
wire        UNUSED_dbg_i2c_sda_in    = dbg_i2c_sda_in;
wire        UNUSED_dbg_uart_rxd      = dbg_uart_rxd;
`endif


    // --- Formal assertions ---
    // AssertionForge baseline SVA for openMSP430
    // 1591 assertions captured from gen_plan.generate_svas


    property af_p1;
    @(posedge mclk) $rose(scan_mode) |-> $stable(aclk);
    endproperty
    assert property(af_p1);

    property af_p2;
    @(posedge mclk) (aclk_en && !puc_rst) |-> (aclk !== $past(aclk));
    endproperty
    assert property(af_p2);

    property af_p3;
    @(posedge mclk) $fell(reset_n) |-> ##4 (aclk !== $past(aclk));
    endproperty
    assert property(af_p3);

    property af_p4;
    @(posedge mclk) aclk_en |-> (aclk !== $past(aclk));
    endproperty
    assert property(af_p4);

    property af_p5;
    @(posedge mclk) (!puc_rst) |-> (aclk === 1'b0 || aclk === 1'b1);
    endproperty
    assert property(af_p5);

    property af_p6;
    @(posedge mclk) puc_rst |-> $stable(aclk);
    endproperty
    assert property(af_p6);

    property af_p7;
    @(posedge mclk) (!aclk_en) [*5] |-> $stable(aclk);
    endproperty
    assert property(af_p7);

    property af_p8;
    @(posedge mclk) $fell(puc_rst) |-> ##4 (aclk !== $past(aclk));
    endproperty
    assert property(af_p8);

    property af_p9;
    @(posedge mclk) $rose(aclk_en) |-> ##[1:3] (aclk !== $past(aclk));
    endproperty
    assert property(af_p9);

    property af_p10;
    @(posedge mclk) scan_enable |-> $stable(aclk);
    endproperty
    assert property(af_p10);


    property af_p12;
    @(posedge mclk) (lfxt_enable) |-> (aclk == lfxt_clk);
    endproperty
    assert property(af_p12);


    property af_p14;
    @(posedge mclk) (aclk_en && cpu_en) |-> ##1 (aclk != $past(aclk));
    endproperty
    assert property(af_p14);

    property af_p15;
    @(posedge mclk) (!aclk_en) |-> (aclk == 1'b0);
    endproperty
    assert property(af_p15);

    property af_p16;
    @(posedge mclk) (aclk_en && !smclk_en) |-> (aclk !== smclk);
    endproperty
    assert property(af_p16);

    property af_p17;
    @(posedge mclk) (aclk_en && $changed(dbg_freeze)) |-> (aclk == $past(aclk)) || (aclk != $past(aclk));
    endproperty
    assert property(af_p17);


    property af_p19;
    @(posedge mclk) (!aclk_en) |-> $stable(aclk);
    endproperty
    assert property(af_p19);

    property af_p20;
    @(posedge mclk) (aclk && aclk_en) |-> ##1 (!aclk);
    endproperty
    assert property(af_p20);

    property af_p21;
    @(posedge mclk) $rose(aclk_en) |-> ##1 (aclk != $past(aclk));
    endproperty
    assert property(af_p21);

    property af_p22;
    @(posedge mclk) (lfxt_wkup) |-> $stable(aclk);
    endproperty
    assert property(af_p22);

    property af_p23;
    @(posedge lfxt_clk) dco_wkup |-> (aclk == 1'b0);
    endproperty
    assert property(af_p23);

    property af_p24;
    @(posedge lfxt_clk) scan_enable |-> (aclk == 1'b0);
    endproperty
    assert property(af_p24);

    property af_p25;
    @(posedge lfxt_clk) (dbg_freeze && aclk_en) |-> (aclk == ~$past(aclk));
    endproperty
    assert property(af_p25);

    property af_p26;
    @(posedge lfxt_clk) $rose(reset_n) |-> ##[1:3] $changed(aclk);
    endproperty
    assert property(af_p26);

    property af_p27;
    @(posedge lfxt_clk) puc_rst |-> $stable(aclk);
    endproperty
    assert property(af_p27);

    property af_p28;
    @(posedge lfxt_clk) $rose(wkup) |=> ##[1:$] $changed(aclk);
    endproperty
    assert property(af_p28);

    property af_p29;
    @(posedge lfxt_clk) (aclk_en && smclk_en) |-> ((aclk == ~$past(aclk)) && (mclk == ~$past(mclk)));
    endproperty
    assert property(af_p29);

    property af_p30;
    @(posedge lfxt_clk) ($past(puc_rst) && !puc_rst && !aclk_en) |-> $stable(aclk);
    endproperty
    assert property(af_p30);

    property af_p31;
    @(posedge lfxt_clk) (aclk_en) |-> (aclk == ~$past(aclk));
    endproperty
    assert property(af_p31);

    property af_p32;
    @(posedge lfxt_clk) $rose(aclk_en) |=> $changed(aclk);
    endproperty
    assert property(af_p32);

    property af_p33;
    @(posedge lfxt_clk) scan_mode |-> $stable(aclk);
    endproperty
    assert property(af_p33);

    property af_p34;
    @(posedge lfxt_clk) !lfxt_enable |-> (aclk == 1'b0);
    endproperty
    assert property(af_p34);

    property af_p35;
    @(posedge mclk) aclk_en |=> !aclk_en;
    endproperty
    assert property(af_p35);

    property af_p36;
    @(posedge mclk) $rose(aclk_en) |-> ##2 $rose(aclk_en);
    endproperty
    assert property(af_p36);

    property af_p37;
    @(posedge mclk) $rose(reset_n) |-> ##4 $changed(aclk_en);
    endproperty
    assert property(af_p37);

    property af_p38;
    @(posedge mclk) $rose(aclk_en) |-> ##2 $fell(aclk_en);
    endproperty
    assert property(af_p38);

    property af_p39;
    @(posedge mclk) $changed(aclk_en) |-> ($past(aclk_en,1) == $past(aclk_en,2));
    endproperty
    assert property(af_p39);

    property af_p40;
    @(posedge mclk) (!cpu_en) |-> $stable(aclk_en);
    endproperty
    assert property(af_p40);

    property af_p41;
    @(posedge mclk) puc_rst |-> (aclk_en == 1'b0);
    endproperty
    assert property(af_p41);

    property af_p42;
    @(posedge mclk) (!dco_enable) |-> (aclk_en == 1'b0);
    endproperty
    assert property(af_p42);

    property af_p43;
    @(posedge mclk) $rose(wkup) |-> ##[1:2] $changed(aclk_en);
    endproperty
    assert property(af_p43);

    property af_p44;
    @(posedge mclk) $rose(puc_rst) ##0 !puc_rst |-> ##4 $changed(aclk_en);
    endproperty
    assert property(af_p44);

    property af_p45;
    @(posedge mclk) scan_mode |-> (aclk_en == 1'b0);
    endproperty
    assert property(af_p45);

    property af_p46;
    @(posedge mclk) dbg_freeze |-> $stable(aclk_en);
    endproperty
    assert property(af_p46);

    property af_p47;
    @(posedge mclk) !(aclk_en && smclk_en);
    endproperty
    assert property(af_p47);

    property af_p48;
    @(posedge mclk) $rose(aclk_en) |=> aclk_en;
    endproperty
    assert property(af_p48);

    property af_p49;
    @(posedge mclk) !cpu_en |-> $stable(aclk_en);
    endproperty
    assert property(af_p49);

    property af_p50;
    @(posedge mclk) !cpu_en |-> !aclk_en;
    endproperty
    assert property(af_p50);

    property af_p51;
    @(posedge mclk) $changed(aclk_en) |=> $stable(aclk_en);
    endproperty
    assert property(af_p51);

    property af_p52;
    @(posedge mclk) aclk_en |-> $changed(lfxt_clk);
    endproperty
    assert property(af_p52);

    property af_p53;
    @(posedge mclk) (puc_rst || $past(puc_rst)) |-> !aclk_en;
    endproperty
    assert property(af_p53);

    property af_p54;
    @(posedge mclk) (aclk_en === 1'b0 || aclk_en === 1'b1);
    endproperty
    assert property(af_p54);

    property af_p55;
    @(posedge mclk) (lfxt_enable && lfxt_clk) |-> (aclk_en == 1'b1) ##1 (aclk_en == 1'b0);
    endproperty
    assert property(af_p55);

    property af_p56;
    @(posedge mclk) (!puc_rst) |-> (aclk_en === 1'b0 || aclk_en === 1'b1);
    endproperty
    assert property(af_p56);

    property af_p57;
    @(posedge mclk) (dbg_freeze) |-> $stable(aclk_en);
    endproperty
    assert property(af_p57);

    property af_p58;
    @(posedge mclk) $fell(puc_rst) |-> ##[1:2] $changed(aclk_en);
    endproperty
    assert property(af_p58);

    property af_p59;
    @(posedge mclk) (!reset_n) |-> ##[0:1] (aclk_en == 1'b0);
    endproperty
    assert property(af_p59);


    property af_p61;
    @(posedge mclk) $fell(puc_rst) |-> ##3 $changed(aclk_en);
    endproperty
    assert property(af_p61);

    property af_p62;
    @(posedge mclk) (puc_rst) |-> (aclk_en == 1'b0);
    endproperty
    assert property(af_p62);

    property af_p63;
    @(posedge mclk) (scan_enable && scan_mode) |-> $stable(aclk_en);
    endproperty
    assert property(af_p63);

    property af_p64;
    @(posedge mclk) (cpu_en && !puc_rst) |=> $changed(mclk);
    endproperty
    assert property(af_p64);

    property af_p65;
    @(posedge cpu_en) (cpu_en throughout (!dbg_en)[*1:$]) |-> !dbg_freeze;
    endproperty
    assert property(af_p65);

    property af_p66;
    @(posedge puc_rst or negedge puc_rst) $stable(cpu_en);
    endproperty
    assert property(af_p66);

    property af_p67;
    @(posedge cpu_en) (!reset_n) |-> (!mclk) until (reset_n);
    endproperty
    assert property(af_p67);

    property af_p68;
    @(posedge mclk) $changed(cpu_en) |-> ##1 $stable(cpu_en);
    endproperty
    assert property(af_p68);

    property af_p69;
    @(posedge cpu_en) ##1 $changed(mclk);
    endproperty
    assert property(af_p69);

    property af_p70;
    @(posedge mclk) cpu_en |-> ##1 cpu_en;
    endproperty
    assert property(af_p70);

    property af_p71;
    @(posedge reset_n) (1'b1) |-> (dbg_en == 1'b0);
    endproperty
    assert property(af_p71);

    property af_p72;
    @(posedge mclk) $fell(reset_n) |-> $stable(dbg_en);
    endproperty
    assert property(af_p72);

    property af_p73;
    @(posedge mclk) (dbg_en && !reset_n) |-> (dbg_i2c_scl == 1'b1) && (dbg_i2c_sda_out == 1'b1);
    endproperty
    assert property(af_p73);

    property af_p74;
    @(posedge mclk) $rose(dbg_en) |-> ##[0:1] ((dbg_i2c_scl !== 1'b1 || dbg_i2c_sda_out !== 1'b1) || (dbg_i2c_scl == dbg_i2c_addr[0]) || (dbg_i2c_sda_out == dbg_i2c_broadcast));
    endproperty
    assert property(af_p74);

    property af_p75;
    @(posedge mclk) (dbg_en == 1'b0) |-> (dbg_uart_txd == 1'b0);
    endproperty
    assert property(af_p75);

    property af_p76;
    @(posedge mclk) $changed(dbg_en) |-> ##1 (1'b1);
    endproperty
    assert property(af_p76);

    property af_p77;
    @(posedge mclk) (!puc_rst && !dbg_en) |-> (dbg_i2c_scl == 1'b1) && (dbg_i2c_sda_out == 1'b1) && (reset_n == 1'b1);
    endproperty
    assert property(af_p77);

    property af_p78;
    @(posedge mclk) $fell(dbg_en) |-> ##1 (dbg_i2c_scl == 1'b1) && (dbg_i2c_sda_out == 1'b1);
    endproperty
    assert property(af_p78);

    property af_p79;
    @(posedge mclk) $fell(dbg_en) |-> ##[0:1] (dbg_freeze == 1'b0);
    endproperty
    assert property(af_p79);

    property af_p80;
    @(posedge mclk) (dbg_en == 1'b0) |-> (dbg_i2c_scl == 1'b1) && (dbg_i2c_sda_out == 1'b1);
    endproperty
    assert property(af_p80);

    property af_p81;
    @(posedge mclk) (dbg_en == 1'b0) |-> (dbg_freeze == 1'b0);
    endproperty
    assert property(af_p81);

    property af_p82;
    @(posedge mclk) $fell(dbg_en) |=> ((dbg_i2c_addr == '0) && (dbg_i2c_broadcast == '0));
    endproperty
    assert property(af_p82);

    property af_p83;
    @(posedge mclk) $changed(dbg_en) |-> (dbg_freeze == 1'b0);
    endproperty
    assert property(af_p83);

    property af_p84;
    @(posedge mclk) $changed(dbg_en) |=> $stable(dbg_en);
    endproperty
    assert property(af_p84);

    property af_p85;
    @(posedge mclk) $changed(cpu_en) |-> $stable(dbg_en);
    endproperty
    assert property(af_p85);

    property af_p86;
    @(posedge mclk) $rose(dbg_en) |-> !(irq || nmi);
    endproperty
    assert property(af_p86);

    property af_p87;
    @(posedge mclk) (!dbg_en) |-> ((dbg_i2c_scl == 1'b0) && (dbg_i2c_sda_out == 1'b0));
    endproperty
    assert property(af_p87);

    property af_p88;
    @(posedge mclk) (dbg_en) |-> $stable(cpu_en);
    endproperty
    assert property(af_p88);

    property af_p89;
    @(posedge mclk) $rose(dbg_en) |=> dbg_en[*2];
    endproperty
    assert property(af_p89);

    property af_p90;
    @(posedge mclk) (dbg_en && $rose(dbg_uart_rxd)) |-> ##[1:10] $rose(dbg_uart_txd);
    endproperty
    assert property(af_p90);

    property af_p91;
    @(posedge mclk) (dbg_en == 0) |-> (!dbg_freeze);
    endproperty
    assert property(af_p91);

    property af_p92;
    @(posedge mclk) (dbg_en == 0) |=> (dbg_uart_txd === $past(dbg_uart_txd));
    endproperty
    assert property(af_p92);

    property af_p93;
    @(posedge mclk) (dbg_en == 0) |=> (dbg_i2c_addr === $past(dbg_i2c_addr));
    endproperty
    assert property(af_p93);

    property af_p94;
    @(posedge mclk) (dbg_en == 0) |=> (dbg_i2c_sda_out === $past(dbg_i2c_sda_out));
    endproperty
    assert property(af_p94);

    property af_p95;
    @(posedge mclk) (scan_mode && $changed(dbg_en)) |-> $stable(scan_enable);
    endproperty
    assert property(af_p95);

    property af_p96;
    @(posedge mclk) (dbg_en == 1'b1) |-> ##1 ((dbg_i2c_scl !== $past(dbg_i2c_scl)) || (dbg_i2c_sda_in !== $past(dbg_i2c_sda_in)) || (dbg_i2c_scl === $past(dbg_i2c_scl)) && (dbg_i2c_sda_in === $past(dbg_i2c_sda_in)));
    endproperty
    assert property(af_p96);

    property af_p97;
    @(posedge mclk) (dbg_en == 0) |-> (cpu_en === $past(cpu_en));
    endproperty
    assert property(af_p97);

    property af_p98;
    @(posedge mclk) (dbg_en == 0) |-> (dbg_i2c_scl == 1'b0) && (dbg_i2c_sda_out == 1'b0) && (dbg_uart_txd == 1'b1);
    endproperty
    assert property(af_p98);

    property af_p99;
    @(posedge mclk) $rose(dbg_en) |-> (cpu_en === $past(cpu_en));
    endproperty
    assert property(af_p99);

    property af_p100;
    @(posedge mclk) $rose(dbg_en) |-> ##[1:2] (dbg_i2c_sda_out !== 1'bx);
    endproperty
    assert property(af_p100);

    property af_p101;
    @(posedge mclk) $rose(dbg_freeze) |-> ##1 dbg_freeze;
    endproperty
    assert property(af_p101);

    property af_p102;
    @(posedge mclk) $rose(dbg_freeze) |-> $past(dbg_en, 1);
    endproperty
    assert property(af_p102);

    property af_p103;
    @(posedge mclk) $changed(dbg_freeze) |-> ($rose(dbg_freeze) || $fell(dbg_freeze));
    endproperty
    assert property(af_p103);

    property af_p104;
    @(posedge mclk) $fell(puc_rst) |-> (dbg_freeze == 1'b0);
    endproperty
    assert property(af_p104);

    property af_p105;
    @(posedge mclk) (!dbg_en) |-> (dbg_freeze == 1'b0);
    endproperty
    assert property(af_p105);

    property af_p106;
    @(posedge mclk) (dbg_en && $fell(cpu_en)) |-> ##1 (dbg_freeze == 1'b1);
    endproperty
    assert property(af_p106);

    property af_p107;
    @(posedge mclk) (puc_rst) |-> (dbg_freeze == 1'b0);
    endproperty
    assert property(af_p107);

    property af_p108;
    @(posedge mclk) $fell(puc_rst) |-> ##4 (dbg_freeze == (dbg_en && !cpu_en));
    endproperty
    assert property(af_p108);

    property af_p109;
    @(posedge mclk) $rose(dbg_freeze) |-> dbg_en;
    endproperty
    assert property(af_p109);

    property af_p110;
    @(posedge mclk) (dbg_en && !cpu_en) |-> (dbg_freeze == 1'b1);
    endproperty
    assert property(af_p110);

    property af_p111;
    @(posedge mclk) $rose(puc_rst) |-> (dbg_freeze == 1'b0);
    endproperty
    assert property(af_p111);

    property af_p112;
    @(posedge mclk) (dbg_en && cpu_en) |=> $stable(dbg_freeze);
    endproperty
    assert property(af_p112);

    property af_p113;
    @(posedge mclk) $rose(dbg_freeze) |-> (dbg_en && !cpu_en);
    endproperty
    assert property(af_p113);

    property af_p114;
    @(posedge mclk) (!puc_rst) |-> (dbg_freeze inside {1'b0, 1'b1});
    endproperty
    assert property(af_p114);

    property af_p115;
    @(posedge mclk) (puc_rst) |-> $stable(dbg_freeze);
    endproperty
    assert property(af_p115);

    property af_p116;
    @(posedge mclk) $fell(puc_rst) |-> (dbg_freeze == 1'b0)[*3];
    endproperty
    assert property(af_p116);

    property af_p117;
    @(posedge mclk) (dbg_freeze == 1) |-> (dbg_en == 1);
    endproperty
    assert property(af_p117);

    property af_p118;
    @(posedge mclk) (dbg_en == 0) |-> (dbg_freeze == 0);
    endproperty
    assert property(af_p118);

    property af_p119;
    @(posedge mclk) (puc_rst) |-> (dbg_freeze == 0);
    endproperty
    assert property(af_p119);

    property af_p120;
    @(posedge mclk) ($stable(dbg_en) && $stable(cpu_en)) |-> ($stable(dbg_freeze));
    endproperty
    assert property(af_p120);

    property af_p121;
    @(posedge mclk) ($past(dbg_en) == 0) |-> (dbg_freeze == 0);
    endproperty
    assert property(af_p121);

    property af_p122;
    @(posedge mclk) (dbg_freeze) |-> (cpu_en == 0);
    endproperty
    assert property(af_p122);

    property af_p123;
    @(posedge mclk) ((dbg_en == 0) && ($past(dbg_en) == 0)) |-> ($stable(dbg_freeze));
    endproperty
    assert property(af_p123);

    property af_p124;
    @(posedge mclk) (dbg_en) |-> ((dbg_freeze == 0) || (dbg_freeze == 1));
    endproperty
    assert property(af_p124);

    property af_p125;
    @(posedge mclk) (dbg_en && $rose(cpu_en)) |-> ##1 (dbg_freeze == 0);
    endproperty
    assert property(af_p125);

    property af_p126;
    @(posedge mclk) ((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119)) |=> ((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119));
    endproperty
    assert property(af_p126);

    property af_p127;
    @(posedge mclk) (dbg_i2c_addr != dbg_i2c_broadcast) |-> (((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119)) && ((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119)));
    endproperty
    assert property(af_p127);

    property af_p128;
    @(posedge mclk) $fell(puc_rst) |-> ##4 ((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119));
    endproperty
    assert property(af_p128);

    property af_p129;
    @(posedge mclk) (dbg_freeze) |-> (((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119)) && $stable(dbg_i2c_addr));
    endproperty
    assert property(af_p129);

    property af_p130;
    @(posedge mclk) (dbg_i2c_addr != dbg_i2c_broadcast) |-> (dbg_i2c_addr != dbg_i2c_broadcast);
    endproperty
    assert property(af_p130);

    property af_p131;
    @(posedge mclk) $fell(puc_rst) |-> ##3 ((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119));
    endproperty
    assert property(af_p131);

    property af_p132;
    @(posedge mclk) (dbg_en) |-> ((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119));
    endproperty
    assert property(af_p132);

    property af_p133;
    @(posedge mclk) $rose(reset_n) |-> ##4 ((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119));
    endproperty
    assert property(af_p133);

    property af_p134;
    @(posedge mclk) (!puc_rst) |-> ((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119));
    endproperty
    assert property(af_p134);

    property af_p135;
    @(posedge mclk) ((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 60)) |=> ((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119));
    endproperty
    assert property(af_p135);

    property af_p136;
    @(posedge mclk) (dbg_en) |-> (dbg_i2c_addr != dbg_i2c_broadcast);
    endproperty
    assert property(af_p136);

    property af_p137;
    @(posedge mclk) $rose(reset_n) |-> ((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119)) ##1 $stable(dbg_i2c_addr) ##1 $stable(dbg_i2c_addr);
    endproperty
    assert property(af_p137);

    property af_p138;
    @(posedge mclk) (dbg_freeze) |-> ((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119) && $stable(dbg_i2c_addr));
    endproperty
    assert property(af_p138);

    property af_p139;
    @(posedge mclk) (dbg_en) |-> ((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119) && $stable(dbg_i2c_addr));
    endproperty
    assert property(af_p139);

    property af_p140;
    @(posedge mclk) (!dbg_en) |-> $stable(dbg_i2c_addr);
    endproperty
    assert property(af_p140);

    property af_p141;
    @(posedge mclk) (dbg_freeze) |-> $stable(dbg_i2c_addr) && (dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119);
    endproperty
    assert property(af_p141);

    property af_p142;
    @(posedge mclk) (!puc_rst) |-> (dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119);
    endproperty
    assert property(af_p142);

    property af_p143;
    @(posedge mclk) $rose(dbg_en) |=> $stable(dbg_i2c_addr);
    endproperty
    assert property(af_p143);

    property af_p144;
    @(posedge mclk) $stable(dbg_i2c_scl) |-> $stable(dbg_i2c_addr);
    endproperty
    assert property(af_p144);

    property af_p145;
    @(posedge mclk) (dbg_i2c_scl == 1'b0) |-> $stable(dbg_i2c_addr);
    endproperty
    assert property(af_p145);

    property af_p146;
    @(posedge mclk) $rose(puc_rst == 1'b0) |-> ##3 ((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119));
    endproperty
    assert property(af_p146);

    property af_p147;
    @(posedge mclk) $rose(reset_n) |-> ##3 ((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119));
    endproperty
    assert property(af_p147);

    property af_p148;
    @(posedge mclk) ((dbg_i2c_addr >= 60) && (dbg_i2c_addr <= 119)) |=> ((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119));
    endproperty
    assert property(af_p148);

    property af_p149;
    @(posedge aclk) (!dbg_i2c_scl) |-> $stable(dbg_i2c_broadcast);
    endproperty
    assert property(af_p149);

    property af_p150;
    @(posedge aclk) (reset_n) |-> (dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119);
    endproperty
    assert property(af_p150);

    property af_p151;
    @(posedge aclk) (dbg_freeze) |-> (dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119);
    endproperty
    assert property(af_p151);

    property af_p152;
    @(posedge aclk) ((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119)) |=> ((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119));
    endproperty
    assert property(af_p152);

    property af_p153;
    @(posedge aclk) (1'b1) |-> (dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119);
    endproperty
    assert property(af_p153);

    property af_p154;
    @(posedge aclk) ((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 63)) |=> ((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119));
    endproperty
    assert property(af_p154);

    property af_p155;
    @(posedge aclk) $rose(reset_n) |-> ##3 ((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119));
    endproperty
    assert property(af_p155);

    property af_p156;
    @(posedge aclk) (dbg_en) |-> $stable(dbg_i2c_broadcast);
    endproperty
    assert property(af_p156);

    property af_p157;
    @(posedge aclk) $rose(reset_n) |-> ##4 ((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119))[*1:$];
    endproperty
    assert property(af_p157);

    property af_p158;
    @(posedge aclk) (reset_n) |-> $stable(dbg_i2c_broadcast);
    endproperty
    assert property(af_p158);

    property af_p159;
    @(posedge aclk) ((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119)) |-> (dbg_i2c_broadcast != dbg_i2c_addr);
    endproperty
    assert property(af_p159);

    property af_p160;
    @(posedge aclk) (!reset_n) |-> ((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119));
    endproperty
    assert property(af_p160);

    property af_p161;
    @(posedge aclk) ($rose(reset_n)) |-> ##4 ((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119));
    endproperty
    assert property(af_p161);

    property af_p162;
    @(posedge aclk) ((dbg_i2c_addr >= 8) && (dbg_i2c_addr <= 119)) |-> ((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119));
    endproperty
    assert property(af_p162);

    property af_p163;
    @(posedge aclk) (dbg_i2c_scl) |-> ($stable(dbg_i2c_broadcast) && (dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119));
    endproperty
    assert property(af_p163);

    property af_p164;
    @(posedge aclk) ((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119)) |-> (dbg_freeze);
    endproperty
    assert property(af_p164);

    property af_p165;
    @(posedge aclk) (!reset_n) |=> ((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119));
    endproperty
    assert property(af_p165);

    property af_p166;
    @(posedge aclk) ($rose(!puc_rst)) |=> ((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119));
    endproperty
    assert property(af_p166);

    property af_p167;
    @(posedge aclk) (!dbg_i2c_scl) |-> ($stable(dbg_i2c_broadcast) && (dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119));
    endproperty
    assert property(af_p167);

    property af_p168;
    @(posedge aclk) $rose(reset_n) |-> ##4 ((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119));
    endproperty
    assert property(af_p168);

    property af_p169;
    @(posedge aclk) dbg_freeze |-> ($stable(dbg_i2c_broadcast) && (dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119)) throughout (dbg_freeze[*3]);
    endproperty
    assert property(af_p169);

    property af_p170;
    @(posedge aclk) (((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119)) && $changed(dbg_i2c_sda_in)) |=> ($stable(dbg_i2c_broadcast) && (dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119));
    endproperty
    assert property(af_p170);

    property af_p171;
    @(posedge aclk) $fell(puc_rst) |-> ##1 ($stable(dbg_i2c_broadcast) && (dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119)) [*2];
    endproperty
    assert property(af_p171);

    property af_p172;
    @(posedge aclk) dbg_en |-> ($stable(dbg_i2c_broadcast) && (dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119));
    endproperty
    assert property(af_p172);

    property af_p173;
    @(posedge aclk) dbg_en |-> ((dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119));
    endproperty
    assert property(af_p173);

    property af_p174;
    @(posedge aclk) $rose(reset_n) |-> ##3 ($stable(dbg_i2c_broadcast) && (dbg_i2c_broadcast >= 8) && (dbg_i2c_broadcast <= 119));
    endproperty
    assert property(af_p174);

    property af_p175;
    @(posedge dbg_i2c_scl) (!dbg_en) |-> $stable(dbg_i2c_sda_out);
    endproperty
    assert property(af_p175);

    property af_p176;
    @(posedge mclk) $rose(dbg_i2c_scl) |-> ##1 $stable(dbg_i2c_addr);
    endproperty
    assert property(af_p176);

    property af_p177;
    @(posedge dbg_i2c_scl) (1'b1) |=> $stable(dbg_i2c_sda_out) === 1'b0;
    endproperty
    assert property(af_p177);

    property af_p178;
    @(posedge reset_n) 1 |=> (dbg_i2c_scl === 1'b0 || dbg_i2c_scl === 1'b1);
    endproperty
    assert property(af_p178);

    property af_p179;
    @(posedge reset_n) 1 |=> !$isunknown(dbg_i2c_scl);
    endproperty
    assert property(af_p179);

    property af_p180;
    @(posedge dbg_i2c_scl) (1'b1) |-> !$isunknown(dbg_i2c_sda_in);
    endproperty
    assert property(af_p180);

    property af_p181;
    @(posedge dbg_i2c_scl) (!puc_rst) |-> !$isunknown(dbg_i2c_sda_in);
    endproperty
    assert property(af_p181);

    property af_p182;
    @(posedge mclk) !$isunknown(dbg_i2c_scl);
    endproperty
    assert property(af_p182);

    property af_p183;
    @(posedge dbg_i2c_scl) (!dbg_en) |-> !dbg_en;
    endproperty
    assert property(af_p183);

    property af_p184;
    @(posedge mclk) (dbg_i2c_scl) |-> $stable(dbg_i2c_sda_out);
    endproperty
    assert property(af_p184);

    property af_p185;
    @(posedge dbg_i2c_scl) (scan_mode) |-> $stable(dbg_i2c_addr);
    endproperty
    assert property(af_p185);

    property af_p186;
    @(posedge mclk) ($rose(dbg_i2c_scl)) |-> ($stable(dbg_i2c_sda_out) throughout (##[1:10] $fell(dbg_i2c_scl)));
    endproperty
    assert property(af_p186);

    property af_p187;
    @(posedge mclk) (!dbg_i2c_scl) |-> $stable(dbg_i2c_scl) throughout (!dbg_i2c_scl)[->1];
    endproperty
    assert property(af_p187);

    property af_p188;
    @(posedge mclk) (!dbg_en) |-> $stable(dbg_i2c_sda_out) throughout ($changed(dbg_i2c_scl))[->1];
    endproperty
    assert property(af_p188);

    property af_p189;
    @(posedge dbg_i2c_scl) ($rose(dbg_i2c_sda_in) && dbg_i2c_scl) |-> ##[1:5] (dbg_i2c_scl == 1'b1);
    endproperty
    assert property(af_p189);

    property af_p190;
    @(posedge dbg_i2c_scl) (dbg_i2c_addr == dbg_i2c_broadcast) |-> (dbg_i2c_sda_out == 1'b0);
    endproperty
    assert property(af_p190);

    property af_p191;
    @(posedge mclk) ($changed(dbg_i2c_scl) && (dbg_i2c_addr == dbg_i2c_addr)) |-> ##[1:3] (dbg_freeze == 1'b1);
    endproperty
    assert property(af_p191);

    property af_p192;
    @(posedge mclk) (dbg_i2c_scl throughout ##[1:10] dbg_i2c_scl) |-> $stable(dbg_i2c_sda_out);
    endproperty
    assert property(af_p192);

    property af_p193;
    @(posedge mclk) ($fell(dbg_i2c_scl) && $stable(dbg_i2c_sda_out)) |-> (dbg_i2c_sda_out == $past(dbg_i2c_sda_out)) throughout (!$rose(dbg_i2c_scl))[->1];
    endproperty
    assert property(af_p193);

    property af_p194;
    @(posedge dbg_i2c_scl) (dbg_i2c_addr == dbg_i2c_broadcast) |-> ##1 $stable(dbg_i2c_broadcast);
    endproperty
    assert property(af_p194);

    property af_p195;
    @(posedge dbg_i2c_scl) ($stable(dbg_i2c_sda_in)) |-> !($rose(dbg_i2c_scl) && (dbg_i2c_sda_in == 1'b0));
    endproperty
    assert property(af_p195);

    property af_p196;
    @(posedge mclk) ($fell(dbg_i2c_scl) && !dbg_i2c_sda_in) |-> ##1 (dbg_i2c_scl == 1'b0);
    endproperty
    assert property(af_p196);

    property af_p197;
    @(posedge mclk) $stable(mclk) |-> (dbg_i2c_scl == 1'b0 || dbg_i2c_scl == 1'b1);
    endproperty
    assert property(af_p197);

    property af_p198;
    @(posedge dbg_i2c_scl) (dbg_i2c_sda_in) |-> ##[1:$] $stable(dbg_i2c_broadcast);
    endproperty
    assert property(af_p198);

    property af_p199;
    @(posedge mclk) (!dbg_i2c_scl) |-> $stable(dbg_i2c_sda_in);
    endproperty
    assert property(af_p199);

    property af_p200;
    @(posedge dbg_i2c_scl) (dbg_en) |-> ##[1:2] $stable(dbg_i2c_addr);
    endproperty
    assert property(af_p200);

    property af_p201;
    @(posedge mclk) (scan_enable) |-> $stable(dbg_i2c_scl);
    endproperty
    assert property(af_p201);

    property af_p202;
    @(posedge dbg_i2c_scl) ($rose(dbg_i2c_sda_in)) |-> ##1 (dbg_i2c_scl);
    endproperty
    assert property(af_p202);

    property af_p203;
    @(posedge mclk) $fell(dbg_i2c_scl) |-> $stable(dbg_i2c_sda_in) throughout (!dbg_i2c_scl);
    endproperty
    assert property(af_p203);

    property af_p204;
    @(posedge dbg_i2c_scl) (dbg_i2c_scl) |-> $stable(dbg_i2c_sda_out) throughout (dbg_i2c_scl);
    endproperty
    assert property(af_p204);

    property af_p205;
    @(posedge dbg_i2c_scl) 1'b1 |-> $stable(puc_rst);
    endproperty
    assert property(af_p205);

    property af_p206;
    @(posedge dbg_i2c_scl) !reset_n |-> $stable(dbg_i2c_sda_out);
    endproperty
    assert property(af_p206);

    property af_p207;
    @(posedge mclk) $stable(mclk) |-> !$isunknown(dbg_i2c_scl);
    endproperty
    assert property(af_p207);

    property af_p208;
    @(posedge dbg_i2c_scl) (!$isunknown(dbg_i2c_sda_in)) |-> !$isunknown(dbg_i2c_addr);
    endproperty
    assert property(af_p208);

    property af_p209;
    @(posedge mclk) (!dbg_en) |-> $stable(dbg_en);
    endproperty
    assert property(af_p209);

    property af_p210;
    @(posedge dbg_i2c_scl) (dbg_i2c_sda_in == 1'b1) |-> $stable(dbg_i2c_sda_in);
    endproperty
    assert property(af_p210);

    property af_p211;
    @(posedge mclk) ($rose(dbg_i2c_sda_in) && dbg_i2c_scl) |-> ##1 1'b1;
    endproperty
    assert property(af_p211);

    property af_p212;
    @(posedge mclk) (dbg_en) |-> (dbg_i2c_sda_in inside {1'b0, 1'b1});
    endproperty
    assert property(af_p212);

    property af_p213;
    @(posedge dbg_i2c_scl) (dbg_i2c_scl) |-> $stable(dbg_i2c_sda_in);
    endproperty
    assert property(af_p213);

    property af_p214;
    @(posedge mclk) ($rose(dbg_i2c_sda_in) && dbg_i2c_scl) |-> ##[1:3] !dbg_freeze;
    endproperty
    assert property(af_p214);

    property af_p215;
    @(posedge mclk) ($fell(dbg_i2c_sda_in) && dbg_i2c_scl) |-> ##1 1'b1;
    endproperty
    assert property(af_p215);

    property af_p216;
    @(posedge mclk) !$isunknown(dbg_i2c_sda_in);
    endproperty
    assert property(af_p216);

    property af_p217;
    @(posedge dbg_i2c_scl) (##8 1'b1) |-> (dbg_i2c_sda_in == 1'b0);
    endproperty
    assert property(af_p217);

    property af_p218;
    @(posedge mclk) (scan_mode) |-> $stable(dbg_i2c_sda_in);
    endproperty
    assert property(af_p218);

    property af_p219;
    @(posedge mclk) (!puc_rst) |-> (dbg_i2c_sda_in inside {1'b0, 1'b1});
    endproperty
    assert property(af_p219);

    property af_p220;
    @(posedge dbg_i2c_scl) (1) |-> (dbg_i2c_sda_in == dbg_i2c_broadcast[$bits(dbg_i2c_broadcast)-1]);
    endproperty
    assert property(af_p220);

    property af_p221;
    @(posedge mclk) (dbg_freeze) |-> $stable(dbg_i2c_sda_in);
    endproperty
    assert property(af_p221);

    property af_p222;
    @(posedge mclk) (dbg_i2c_scl && $fell(dbg_i2c_sda_in)) |-> dbg_i2c_scl;
    endproperty
    assert property(af_p222);

    property af_p223;
    @(posedge dbg_i2c_scl) (1) |-> (dbg_i2c_sda_in == dbg_i2c_addr[$bits(dbg_i2c_addr)-1]);
    endproperty
    assert property(af_p223);

    property af_p224;
    @(posedge mclk) (dbg_i2c_sda_out == 1'b0) |-> (dbg_i2c_sda_in !== 1'b1);
    endproperty
    assert property(af_p224);

    property af_p225;
    @(posedge mclk) $rose(scan_enable) |-> $stable(dbg_i2c_sda_in);
    endproperty
    assert property(af_p225);

    property af_p226;
    @(posedge mclk) (!dbg_en) |-> $stable(dbg_i2c_sda_out);
    endproperty
    assert property(af_p226);

    property af_p227;
    @(posedge dbg_i2c_scl) $stable(dbg_i2c_sda_in) throughout (@(posedge dbg_i2c_scl) 1);
    endproperty
    assert property(af_p227);

    property af_p228;
    @(posedge dbg_i2c_scl) (dbg_i2c_sda_in == dbg_i2c_addr) |=> (dbg_i2c_sda_in == 1'b0);
    endproperty
    assert property(af_p228);

    property af_p229;
    @(posedge mclk) (!reset_n) |-> (dbg_i2c_sda_out == 1'b1);
    endproperty
    assert property(af_p229);

    property af_p230;
    @(posedge mclk) (!scan_enable) |-> (dbg_i2c_sda_in === $past(dbg_i2c_sda_in) || dbg_i2c_sda_in !== $past(dbg_i2c_sda_in));
    endproperty
    assert property(af_p230);

    property af_p231;
    @(posedge mclk) $fell(reset_n) |=> (dbg_i2c_sda_in === 1'b0 || dbg_i2c_sda_in === 1'b1);
    endproperty
    assert property(af_p231);

    property af_p232;
    @(posedge mclk) (1'b1) |-> (dbg_i2c_sda_in === 1'b0 || dbg_i2c_sda_in === 1'b1);
    endproperty
    assert property(af_p232);

    property af_p233;
    @(posedge dbg_i2c_scl) (1'b1) |-> (dbg_i2c_sda_in === 1'b0 || dbg_i2c_sda_in === 1'b1);
    endproperty
    assert property(af_p233);

    property af_p234;
    @(posedge dbg_i2c_scl) (dbg_i2c_scl && $rose(dbg_i2c_sda_in)) |-> (dbg_i2c_sda_in === 1'b1);
    endproperty
    assert property(af_p234);

    property af_p235;
    @(posedge mclk) $fell(puc_rst) |-> ##[1:$] (dbg_i2c_sda_in === 1'b0 || dbg_i2c_sda_in === 1'b1);
    endproperty
    assert property(af_p235);

    property af_p236;
    @(posedge mclk) $rose(reset_n) |=> (dbg_i2c_sda_in === 1'b1);
    endproperty
    assert property(af_p236);

    property af_p237;
    @(posedge mclk) (dbg_i2c_scl && $fell(dbg_i2c_sda_in)) |-> ##[1:3] (dbg_en === 1'b1);
    endproperty
    assert property(af_p237);

    property af_p238;
    @(posedge mclk) $fell(reset_n) |-> ##3 (dbg_i2c_sda_in === 1'b0 || dbg_i2c_sda_in === 1'b1);
    endproperty
    assert property(af_p238);

    property af_p239;
    @(posedge dbg_i2c_scl) (1'b1) |-> ($sampled(dbg_i2c_sda_in) == dbg_i2c_broadcast[0]);
    endproperty
    assert property(af_p239);

    property af_p240;
    @(posedge mclk) (dbg_i2c_scl) |-> (dbg_i2c_sda_in == $past(dbg_i2c_sda_in));
    endproperty
    assert property(af_p240);

    property af_p241;
    @(posedge mclk) ($changed(dbg_i2c_sda_in)) |=> ($changed(dbg_i2c_sda_out));
    endproperty
    assert property(af_p241);

    property af_p242;
    @(posedge mclk) (!dbg_i2c_scl) |-> (dbg_i2c_sda_out == dbg_i2c_broadcast);
    endproperty
    assert property(af_p242);

    property af_p243;
    @(posedge mclk) (dbg_i2c_scl) |-> $stable(dbg_i2c_sda_out);
    endproperty
    assert property(af_p243);

    property af_p244;
    @(posedge dbg_i2c_scl) (dbg_en) |-> (dbg_i2c_sda_out inside {1'b0, 1'b1});
    endproperty
    assert property(af_p244);

    property af_p245;
    @(posedge dbg_i2c_scl) (!dbg_en) |-> (dbg_i2c_sda_out == 1'b1);
    endproperty
    assert property(af_p245);

    property af_p246;
    @(posedge dbg_i2c_scl) (dbg_i2c_addr == dbg_i2c_sda_out) |=> (dbg_i2c_sda_out == 1'b0);
    endproperty
    assert property(af_p246);

    property af_p247;
    @(posedge mclk) ($stable(dbg_i2c_sda_in) && dbg_i2c_scl) |-> $stable(dbg_i2c_sda_out);
    endproperty
    assert property(af_p247);

    property af_p248;
    @(posedge dbg_i2c_scl) (dbg_i2c_sda_in == dbg_i2c_addr) |=> (dbg_i2c_sda_out == 1'b0);
    endproperty
    assert property(af_p248);

    property af_p249;
    @(posedge mclk) (dbg_freeze) |-> $stable(dbg_i2c_sda_out);
    endproperty
    assert property(af_p249);

    property af_p250;
    @(posedge dbg_i2c_scl) !$isunknown(dbg_i2c_sda_out) && (dbg_i2c_sda_out == 1'b0 || dbg_i2c_sda_out == 1'b1);
    endproperty
    assert property(af_p250);

    property af_p251;
    @(posedge mclk) (!dbg_en) |-> (dbg_i2c_sda_out == 1'b1);
    endproperty
    assert property(af_p251);

    property af_p252;
    @(posedge mclk) $rose(reset_n) |-> ##[1:5] (dbg_i2c_sda_out == 1'b1);
    endproperty
    assert property(af_p252);

    property af_p253;
    @(posedge dbg_i2c_scl) ($past(dbg_i2c_broadcast) == dbg_i2c_broadcast) |=> (dbg_i2c_sda_out == 1'b0);
    endproperty
    assert property(af_p253);

    property af_p254;
    @(posedge mclk) (dbg_i2c_sda_in && dbg_i2c_scl) |-> (dbg_i2c_sda_out == 1'b1);
    endproperty
    assert property(af_p254);

    property af_p255;
    @(posedge mclk) $fell(dbg_i2c_scl) |-> ##[1:5] (dbg_i2c_sda_out == 1'b1);
    endproperty
    assert property(af_p255);

    property af_p256;
    @(posedge dbg_i2c_scl) $stable(dbg_i2c_sda_out);
    endproperty
    assert property(af_p256);

    property af_p257;
    @(posedge mclk) (!reset_n) |-> (dbg_i2c_sda_out == 1'b1);
    endproperty
    assert property(af_p257);

    property af_p258;
    @(posedge mclk) (puc_rst) |-> (dbg_i2c_sda_out == 1'b1);
    endproperty
    assert property(af_p258);

    property af_p259;
    @(posedge mclk) $changed(dbg_i2c_sda_out) |-> $fell(dbg_i2c_scl);
    endproperty
    assert property(af_p259);

    property af_p260;
    @(posedge dbg_i2c_scl) (dbg_en) |-> ##1 (dbg_i2c_sda_out == $past(dbg_i2c_sda_in));
    endproperty
    assert property(af_p260);

    property af_p261;
    @(posedge dbg_i2c_scl) ($stable(dbg_i2c_addr)) |-> ##[1:8] (dbg_i2c_sda_out == 1'b0);
    endproperty
    assert property(af_p261);

    property af_p262;
    @(posedge dbg_i2c_scl) (puc_rst) |-> ##[1:4] (dbg_i2c_sda_out == 1'b1);
    endproperty
    assert property(af_p262);

    property af_p263;
    @(posedge mclk) $rose(reset_n) |-> ##3 (dbg_i2c_sda_out inside {1'b0, 1'b1});
    endproperty
    assert property(af_p263);

    property af_p264;
    @(posedge mclk) (!dbg_en) |-> $stable(dbg_i2c_sda_out);
    endproperty
    assert property(af_p264);

    property af_p265;
    @(posedge aclk) (1) |-> $stable(dbg_uart_rxd) throughout (##1 $stable(dbg_uart_rxd));
    endproperty
    assert property(af_p265);

    property af_p266;
    @(posedge aclk) (dbg_uart_rxd == 1'b1)[*4] |-> !$fell(dbg_uart_rxd);
    endproperty
    assert property(af_p266);

    property af_p267;
    @(posedge aclk) $fell(reset_n) |-> ##1 dbg_uart_rxd == 1'b1 [*1:$];
    endproperty
    assert property(af_p267);

    property af_p268;
    @(posedge aclk) $rose(dbg_en) |-> ##1 (dbg_uart_rxd === dbg_uart_rxd);
    endproperty
    assert property(af_p268);

    property af_p269;
    @(posedge aclk) $fell(dbg_uart_rxd) |-> ##1 (dbg_uart_rxd[*8] ##1 dbg_uart_rxd == 1'b1);
    endproperty
    assert property(af_p269);

    property af_p270;
    @(posedge aclk) (scan_mode && scan_enable) |-> !$changed(dbg_uart_rxd) until_with (!scan_enable);
    endproperty
    assert property(af_p270);

    property af_p271;
    @(posedge aclk) (!dbg_en && $changed(dbg_uart_rxd)) |-> $stable(dbg_freeze);
    endproperty
    assert property(af_p271);

    property af_p272;
    @(posedge aclk) (!scan_enable) |-> $stable(dbg_uart_rxd);
    endproperty
    assert property(af_p272);

    property af_p273;
    @(posedge aclk) puc_rst |-> (dbg_uart_rxd === 1'b0 || dbg_uart_rxd === 1'b1);
    endproperty
    assert property(af_p273);

    property af_p274;
    @(posedge aclk) (dbg_uart_rxd[*8] ##1 dbg_uart_rxd == 1'b1) |-> dbg_en;
    endproperty
    assert property(af_p274);

    property af_p275;
    @(posedge aclk) (dbg_uart_rxd[*8]) |-> ##1 dbg_uart_rxd == 1'b1;
    endproperty
    assert property(af_p275);





    property af_p280;
    @(posedge aclk) $rose(reset_n) |-> dbg_uart_rxd[*3];
    endproperty
    assert property(af_p280);

    property af_p281;
    @(posedge aclk) ($changed(dbg_i2c_scl) || $changed(dbg_i2c_sda_in)) |-> $stable(dbg_uart_rxd);
    endproperty
    assert property(af_p281);

    property af_p282;
    @(posedge aclk) (dbg_en && !scan_enable && !scan_mode) |-> (dbg_uart_rxd === dbg_uart_rxd);
    endproperty
    assert property(af_p282);

    property af_p283;
    @(posedge aclk) $fell(dbg_uart_rxd) |-> ##1 !dbg_uart_rxd;
    endproperty
    assert property(af_p283);




    property af_p287;
    @(posedge aclk) ($past(dbg_uart_rxd) == 1'b1) |-> ##1 (dbg_uart_rxd == 1'b0 || dbg_uart_rxd == 1'b1);
    endproperty
    assert property(af_p287);

    property af_p288;
    @(posedge aclk) ($rose(reset_n)) |-> ##1 (dbg_uart_rxd == 1'b0 || dbg_uart_rxd == 1'b1);
    endproperty
    assert property(af_p288);

    property af_p289;
    @(posedge aclk) (!cpu_en) |-> (dbg_uart_rxd == $past(dbg_uart_rxd) || dbg_uart_rxd != $past(dbg_uart_rxd));
    endproperty
    assert property(af_p289);

    property af_p290;
    @(posedge aclk) disable iff (!dbg_freeze !== 1'bx) ($past(dbg_uart_rxd) == 1'b1 && dbg_uart_rxd == 1'b0) |-> ##1 $stable(dbg_uart_rxd) [*8] ##1 (dbg_uart_rxd == 1'b1);
    endproperty
    assert property(af_p290);

    property af_p291;
    @(posedge aclk) (dbg_freeze) |-> (dbg_uart_rxd == $past(dbg_uart_rxd) || dbg_uart_rxd != $past(dbg_uart_rxd));
    endproperty
    assert property(af_p291);

    property af_p292;
    @(posedge aclk) ($past(dbg_uart_rxd) == 1'b1 && dbg_uart_rxd == 1'b0) |-> ##1 (dbg_uart_rxd == 1'b0);
    endproperty
    assert property(af_p292);

    property af_p293;
    @(posedge aclk) (!dbg_en) |-> ($stable(dbg_uart_rxd) || !$stable(dbg_uart_rxd));
    endproperty
    assert property(af_p293);

    property af_p294;
    @(posedge aclk) ($past(dbg_uart_rxd) == 1'b1 && dbg_uart_rxd == 1'b0) |-> (dbg_en throughout (##1 dbg_uart_rxd[*8]));
    endproperty
    assert property(af_p294);

    property af_p295;
    @(posedge aclk) ($past(dbg_uart_rxd) == 1'b1 && dbg_uart_rxd == 1'b0) |-> ##10 (dbg_uart_rxd == 1'b1) ##1 (dbg_uart_rxd == 1'b1 || dbg_uart_rxd == 1'b0);
    endproperty
    assert property(af_p295);

    property af_p296;
    @(posedge aclk) (dbg_uart_rxd == 1'b0) |-> (dbg_uart_rxd == 1'b0) [*1:$];
    endproperty
    assert property(af_p296);

    property af_p297;
    @(posedge mclk) ($rose(dbg_uart_txd)) |-> dbg_uart_txd[*1];
    endproperty
    assert property(af_p297);

    property af_p298;
    @(posedge aclk) (!reset_n) |-> (dbg_uart_txd == 1'b1);
    endproperty
    assert property(af_p298);

    property af_p299;
    @(posedge aclk) (!dbg_en) |-> dbg_uart_txd[*1];
    endproperty
    assert property(af_p299);

    property af_p300;
    @(posedge mclk) (dbg_en) |-> $stable(dbg_uart_txd) or $changed(dbg_uart_txd);
    endproperty
    assert property(af_p300);

    property af_p301;
    @(posedge aclk) (dbg_freeze) |-> dbg_uart_txd[*2];
    endproperty
    assert property(af_p301);

    property af_p302;
    @(posedge aclk) disable iff (!reset_n) (!dbg_en) |-> $stable(dbg_uart_txd);
    endproperty
    assert property(af_p302);

    property af_p303;
    @(posedge aclk) ($changed(dbg_uart_txd)) |-> ##1 $stable(dbg_uart_txd);
    endproperty
    assert property(af_p303);

    property af_p304;
    @(posedge aclk) (!reset_n) |=> (dbg_uart_txd == 1'b1);
    endproperty
    assert property(af_p304);

    property af_p305;
    @(posedge aclk) $stable(dbg_uart_txd) || $changed(dbg_uart_txd);
    endproperty
    assert property(af_p305);

    property af_p306;
    @(posedge mclk) ($fell(dbg_uart_txd)) |-> (dbg_uart_txd == 1'b0)[*1] ##1 (dbg_uart_txd == 1'b1);
    endproperty
    assert property(af_p306);

    property af_p307;
    @(posedge aclk) (!dbg_en) |=> $stable(dbg_uart_txd);
    endproperty
    assert property(af_p307);

    property af_p308;
    @(posedge aclk) $past(dbg_uart_txd, 8) !== 1'bx |-> (dbg_uart_txd == 1'b1);
    endproperty
    assert property(af_p308);

    property af_p309;
    @(posedge mclk) $fell(dbg_uart_txd) |-> (dbg_uart_txd[*8] ##1 (dbg_uart_txd == 1'b1));
    endproperty
    assert property(af_p309);

    property af_p310;
    @(posedge dbg_en) (!dbg_en) |-> $stable(dbg_uart_txd);
    endproperty
    assert property(af_p310);

    property af_p311;
    @(posedge aclk) $fell(reset_n) |-> ##[1:2] (dbg_uart_txd == 1'b1);
    endproperty
    assert property(af_p311);

    property af_p312;
    @(posedge mclk) $rose(puc_rst) |-> ##[1:3] (dbg_uart_txd == 1'b1);
    endproperty
    assert property(af_p312);

    property af_p313;
    @(posedge dbg_freeze) (dbg_freeze) |=> $stable(dbg_uart_txd);
    endproperty
    assert property(af_p313);

    property af_p314;
    @(posedge aclk) (dbg_en) |-> (dbg_uart_txd === 1'b0 || dbg_uart_txd === 1'b1);
    endproperty
    assert property(af_p314);

    property af_p315;
    @(posedge aclk) (!dbg_en) |-> (dbg_uart_txd == 1'b1);
    endproperty
    assert property(af_p315);

    property af_p316;
    @(posedge aclk) $rose(dbg_en) |=> (dbg_uart_txd == 1'b0);
    endproperty
    assert property(af_p316);

    property af_p317;
    @(posedge aclk) (dbg_en && $fell(dbg_uart_txd)) |-> ##1 (!dbg_uart_txd[*8]) ##1 (dbg_uart_txd);
    endproperty
    assert property(af_p317);

    property af_p318;
    @(posedge aclk) (!dbg_en) |-> $stable(dbg_uart_txd);
    endproperty
    assert property(af_p318);

    property af_p319;
    @(posedge aclk) $changed({dbg_i2c_scl, dbg_i2c_sda_in}) |-> $stable(dbg_uart_txd);
    endproperty
    assert property(af_p319);

    property af_p320;
    @(posedge aclk) $fell(dbg_uart_txd) |-> ##9 (dbg_uart_txd ##1 dbg_uart_txd);
    endproperty
    assert property(af_p320);

    property af_p321;
    @(posedge aclk) $changed(dbg_uart_rxd) |-> ##[1:$] $changed(dbg_uart_txd);
    endproperty
    assert property(af_p321);

    property af_p322;
    @(posedge aclk) (dbg_uart_txd) |-> ##1 (!dbg_uart_txd);
    endproperty
    assert property(af_p322);


    property af_p324;
    @(posedge aclk) $rose(reset_n) |-> (dbg_uart_txd == 1'b1);
    endproperty
    assert property(af_p324);

    property af_p325;
    @(posedge mclk) $fell(dbg_uart_txd) |-> $past(dbg_uart_txd, 1) == 1'b1;
    endproperty
    assert property(af_p325);

    property af_p326;
    @(posedge dco_clk) (1'b1) |-> ##[1:2] $rose(dco_clk);
    endproperty
    assert property(af_p326);

    property af_p327;
    @(posedge dco_clk) (puc_rst) |-> (!$stable(dco_clk));
    endproperty
    assert property(af_p327);

    property af_p328;
    @(posedge dco_clk) (dco_enable) |-> (!$stable(dco_clk));
    endproperty
    assert property(af_p328);

    property af_p329;
    @(posedge dco_clk) (1'b1) |-> (smclk === dco_clk);
    endproperty
    assert property(af_p329);

    property af_p330;
    @(posedge dco_clk) $fell(reset_n) |-> ##1 (!$stable(dco_clk))[*5];
    endproperty
    assert property(af_p330);

    property af_p331;
    @(posedge dco_clk) $fell(puc_rst) |-> ##[1:3] $rose(dco_clk);
    endproperty
    assert property(af_p331);

    property af_p332;
    @(posedge dco_clk) $fell(reset_n) |-> ##1 (!$stable(dco_clk));
    endproperty
    assert property(af_p332);

    property af_p333;
    @(posedge dco_clk) $fell(puc_rst) |-> ##1 (!$stable(dco_clk))[*4];
    endproperty
    assert property(af_p333);

    property af_p334;
    @(posedge dco_clk) (scan_mode) |-> (!$isunknown(dco_clk));
    endproperty
    assert property(af_p334);

    property af_p335;
    @(posedge dco_clk) (cpu_en) |-> (!$stable(dco_clk));
    endproperty
    assert property(af_p335);


    property af_p337;
    @(posedge dco_clk) (1'b1) |-> (mclk === dco_clk);
    endproperty
    assert property(af_p337);









    property af_p346;
    @(posedge dco_clk) 1'b1 |-> $changed(smclk);
    endproperty
    assert property(af_p346);


    property af_p348;
    @(posedge dco_clk) smclk_en |-> $changed(smclk);
    endproperty
    assert property(af_p348);















    property af_p363;
    @(posedge dco_clk) 1 |-> (($past(dco_clk,1)==1'b0) && ($past(dco_clk,2)==1'b1));
    endproperty
    assert property(af_p363);





    property af_p368;
    @(posedge dco_clk) 1 |-> (mclk == dco_clk);
    endproperty
    assert property(af_p368);

    property af_p369;
    @(posedge mclk) ($fell(dco_wkup) && !dco_enable) |-> not (##[1:$] dco_enable);
    endproperty
    assert property(af_p369);

    property af_p370;
    @(posedge mclk) (dco_wkup) |-> ((!dco_enable) throughout (##[1:$] dco_enable));
    endproperty
    assert property(af_p370);

    property af_p371;
    @(posedge dco_wkup) (!mclk) |-> (!dco_enable);
    endproperty
    assert property(af_p371);

    property af_p372;
    @(posedge mclk) ($rose(dco_enable)) |-> ($past(dco_wkup,1));
    endproperty
    assert property(af_p372);

    property af_p373;
    @(posedge mclk) ($rose(dco_enable)) |-> (dco_enable throughout (##[1:$] $fell(dco_enable)));
    endproperty
    assert property(af_p373);

    property af_p374;
    @(posedge mclk) ($rose(dco_wkup)) |=> (!dco_enable);
    endproperty
    assert property(af_p374);

    property af_p375;
    @(posedge mclk) ($rose(irq)) |=> (dco_enable);
    endproperty
    assert property(af_p375);

    property af_p376;
    @(posedge mclk) (scan_mode) |-> ($stable(dco_enable));
    endproperty
    assert property(af_p376);

    property af_p377;
    @(posedge mclk) (wkup ##1 irq) |-> ##1 $rose(dco_enable);
    endproperty
    assert property(af_p377);

    property af_p378;
    @(posedge mclk) $rose(irq) |-> ##1 dco_enable;
    endproperty
    assert property(af_p378);

    property af_p379;
    @(posedge mclk) (dco_wkup && $rose(cpu_en)) |-> ##1 dco_enable;
    endproperty
    assert property(af_p379);

    property af_p380;
    @(posedge mclk) $rose(dco_enable) |-> $past(dco_wkup);
    endproperty
    assert property(af_p380);



    property af_p383;
    @(posedge mclk) puc_rst |=> !dco_enable throughout (!wkup)[*1:$];
    endproperty
    assert property(af_p383);

    property af_p384;
    @(posedge mclk) $rose(reset_n) |-> (!dco_enable) ##1 (!dco_enable);
    endproperty
    assert property(af_p384);

    property af_p385;
    @(posedge mclk) (scan_mode) |-> (dco_enable === 1'b0);
    endproperty
    assert property(af_p385);

    property af_p386;
    @(posedge mclk) (!reset_n) |-> (dco_enable === 1'b0);
    endproperty
    assert property(af_p386);

    property af_p387;
    @(posedge mclk) $rose(wkup) |-> ##[1:$] $rose(dco_enable);
    endproperty
    assert property(af_p387);

    property af_p388;
    @(posedge mclk) (dco_wkup && irq) |-> ##[1:2] $rose(dco_enable);
    endproperty
    assert property(af_p388);

    property af_p389;
    @(posedge mclk) $rose(dco_enable) |=> dco_enable[*2:$];
    endproperty
    assert property(af_p389);

    property af_p390;
    @(posedge mclk) $fell(gie) |-> ##[1:2] $fell(dco_enable);
    endproperty
    assert property(af_p390);

    property af_p391;
    @(posedge dco_clk) (wkup) |-> (dco_wkup);
    endproperty
    assert property(af_p391);

    property af_p392;
    @(posedge mclk) (puc_rst) |-> (dco_wkup == 1'b0);
    endproperty
    assert property(af_p392);

    property af_p393;
    @(posedge mclk) $fell(dco_wkup) |-> ($past(dco_wkup,1) && $past(dco_wkup,2));
    endproperty
    assert property(af_p393);

    property af_p394;
    @(posedge dco_clk) ($fell(irq)) |-> ##2 ($fell(dco_wkup));
    endproperty
    assert property(af_p394);

    property af_p395;
    @(posedge dco_clk) (wkup) |-> (dco_wkup throughout (dco_enable[->1]));
    endproperty
    assert property(af_p395);

    property af_p396;
    @(posedge mclk) (wkup) |-> (dco_wkup && !dco_enable);
    endproperty
    assert property(af_p396);

    property af_p397;
    @(posedge mclk) (wkup) |-> (dco_wkup throughout (dco_enable[->1]));
    endproperty
    assert property(af_p397);



    property af_p400;
    @(posedge mclk) (puc_rst) |-> (dco_wkup == 1'b0 && (wkup || !wkup) && (dco_enable || !dco_enable));
    endproperty
    assert property(af_p400);

    property af_p401;
    @(posedge mclk) (irq) |-> ##1 (dco_enable && dco_wkup);
    endproperty
    assert property(af_p401);

    property af_p402;
    @(posedge reset_n) 1 |-> (!dco_wkup until wkup);
    endproperty
    assert property(af_p402);

    property af_p403;
    @(posedge mclk) $rose(reset_n) |=> !dco_wkup;
    endproperty
    assert property(af_p403);

    property af_p404;
    @(posedge dco_clk) $rose(dco_wkup) |-> (!dco_enable throughout mclk[->1]) ##1 dco_enable;
    endproperty
    assert property(af_p404);



    property af_p407;
    @(posedge mclk) $fell(dco_wkup) |-> ($past(cpu_en) && $past(irq) && $past(dco_enable));
    endproperty
    assert property(af_p407);

    property af_p408;
    @(posedge mclk) $rose(wkup) |-> (dco_wkup ##1 dco_wkup);
    endproperty
    assert property(af_p408);

    property af_p409;
    @(posedge mclk) (dco_wkup && !dco_enable) |-> (!cpu_en throughout (mclk && irq)[->1]);
    endproperty
    assert property(af_p409);

    property af_p410;
    @(posedge mclk) $rose(dco_enable) |-> ##2 $fell(dco_wkup);
    endproperty
    assert property(af_p410);

    property af_p411;
    @(posedge mclk) $rose(dco_enable) |-> ##2 !dco_wkup;
    endproperty
    assert property(af_p411);

    property af_p412;
    @(posedge dco_clk) $rose(dco_wkup) ##[1:$] $rose(dco_enable) |-> ##2 !dco_wkup;
    endproperty
    assert property(af_p412);

    property af_p413;
    @(posedge mclk) $rose(wkup) |-> dco_wkup[*2] ##1 (dco_enable || dco_wkup);
    endproperty
    assert property(af_p413);

    property af_p414;
    @(posedge mclk) $rose(wkup) |-> dco_wkup;
    endproperty
    assert property(af_p414);

    property af_p415;
    @(posedge mclk) $rose(wkup) |-> dco_wkup throughout ($rose(dco_enable) ##2 1'b1);
    endproperty
    assert property(af_p415);

    property af_p416;
    @(posedge mclk) puc_rst |-> !dco_wkup;
    endproperty
    assert property(af_p416);

    property af_p417;
    @(posedge mclk) (dco_enable && $stable(wkup)) |-> $stable(dco_wkup);
    endproperty
    assert property(af_p417);

    property af_p418;
    @(posedge dco_clk) (dco_wkup && !dco_enable) |=> dco_wkup;
    endproperty
    assert property(af_p418);

    property af_p419;
    @(posedge dco_clk) ($fell(wkup) && dco_wkup) |-> ##2 !dco_wkup;
    endproperty
    assert property(af_p419);

    property af_p420;
    @(posedge mclk) (!wkup && !irq) |-> $stable(dco_wkup);
    endproperty
    assert property(af_p420);

    property af_p421;
    @(posedge mclk) $rose(wkup) |=> $stable(dco_wkup);
    endproperty
    assert property(af_p421);

    property af_p422;
    @(posedge mclk) $rose(dma_wkup) |-> (dma_addr >= 1) && (dma_addr <= 32767) throughout (!dma_ready)[*0:$] ##1 dma_ready;
    endproperty
    assert property(af_p422);

    property af_p423;
    @(posedge mclk) $fell(puc_rst) |-> ##[1:2] (dma_addr == '0);
    endproperty
    assert property(af_p423);

    property af_p424;
    @(posedge mclk) ($past(dma_ready) && (dma_addr >= 1) && (dma_addr <= 32767)) |-> ##1 1'b1;
    endproperty
    assert property(af_p424);

    property af_p425;
    @(posedge mclk) ((dma_en) && (dma_addr >= 100) && (dma_addr <= 200)) |-> ((dma_addr >= 100) && (dma_addr <= 200)) throughout (!dma_ready)[*0:$] ##1 dma_ready;
    endproperty
    assert property(af_p425);

    property af_p426;
    @(posedge mclk) (dma_priority) |-> $stable(dma_addr);
    endproperty
    assert property(af_p426);

    property af_p427;
    @(posedge mclk) (dma_en && !dma_ready) |-> ($stable(dma_addr));
    endproperty
    assert property(af_p427);

    property af_p428;
    @(posedge mclk) (dma_en && !puc_rst) |-> (dma_addr >= 1) && (dma_addr <= 65535);
    endproperty
    assert property(af_p428);

    property af_p429;
    @(posedge mclk) (dma_we) |-> $stable(dma_addr);
    endproperty
    assert property(af_p429);

    property af_p430;
    @(posedge mclk) (dma_en && (dma_addr >= 0) && (dma_addr <= 32767)) |=> (!dma_ready |-> (dma_addr >= 0) && (dma_addr <= 32767));
    endproperty
    assert property(af_p430);

    property af_p431;
    @(posedge mclk) $fell(puc_rst) |=> (dma_addr == '0);
    endproperty
    assert property(af_p431);

    property af_p432;
    @(posedge mclk) $rose(dma_en) |-> (dma_addr == $past(dma_addr)) throughout (dma_en && !dma_ready)[*0:$] ##1 dma_ready;
    endproperty
    assert property(af_p432);

    property af_p433;
    @(posedge mclk) (dma_en && dma_resp) |-> ($stable(dma_addr) && (dma_addr == $past(dma_addr,2)));
    endproperty
    assert property(af_p433);

    property af_p434;
    @(posedge mclk) (dma_en) |-> (dma_addr >= 0) && (dma_addr <= 32767);
    endproperty
    assert property(af_p434);

    property af_p435;
    @(posedge mclk) (!dma_we && dma_en) |-> $stable(dma_addr);
    endproperty
    assert property(af_p435);

    property af_p436;
    @(posedge mclk) dma_en |-> $stable(dma_addr) until dma_ready;
    endproperty
    assert property(af_p436);

    property af_p437;
    @(posedge mclk) !$stable(dma_addr) |-> $past(dma_ready);
    endproperty
    assert property(af_p437);

    property af_p438;
    @(posedge mclk) ($rose(dma_wkup) && dma_en) |-> ##[1:3] ((dma_addr >= 0) && (dma_addr <= 32767) && $stable(dma_addr));
    endproperty
    assert property(af_p438);

    property af_p439;
    @(posedge mclk) dma_resp |-> ##1 $stable(dma_addr);
    endproperty
    assert property(af_p439);

    property af_p440;
    @(posedge mclk) ($rose(dma_wkup) && dma_en) |-> ##[1:2] ((dma_addr >= 0) && (dma_addr <= 32767) && $stable(dma_addr));
    endproperty
    assert property(af_p440);

    property af_p441;
    @(posedge mclk) (dma_en && !dma_ready) |-> ##1 $stable(dma_addr);
    endproperty
    assert property(af_p441);

    property af_p442;
    @(posedge mclk) ((dma_addr >= 1) && (dma_addr <= 16383)) |=> (dma_en |-> ((dma_addr >= 1) && (dma_addr <= 32767)));
    endproperty
    assert property(af_p442);

    property af_p443;
    @(posedge mclk) $fell(puc_rst) |-> ##3 ((dma_addr >= 0) && (dma_addr <= 32767));
    endproperty
    assert property(af_p443);

    property af_p444;
    @(posedge mclk) (dma_en && !dma_ready) |=> ($stable(dma_addr));
    endproperty
    assert property(af_p444);

    property af_p445;
    @(posedge mclk) (dma_we && !dma_ready) |=> (($stable(dma_addr)) && (dma_addr >= 1) && (dma_addr <= 32767));
    endproperty
    assert property(af_p445);

    property af_p446;
    @(posedge mclk) ((dma_addr >= 0) && (dma_addr <= 16383) && dma_en) |=> (dma_ready && !$isunknown(dma_dout));
    endproperty
    assert property(af_p446);

    property af_p447;
    @(posedge mclk) (dma_en && !puc_rst) |-> ((dma_addr >= 0) && (dma_addr <= 32767));
    endproperty
    assert property(af_p447);

    property af_p448;
    @(posedge mclk) (dma_en) |-> (!$isunknown(dma_addr));
    endproperty
    assert property(af_p448);

    property af_p449;
    @(posedge mclk) (dma_en) |-> ((dma_addr >= 1) && (dma_addr <= 32767));
    endproperty
    assert property(af_p449);

    property af_p450;
    @(posedge mclk) (puc_rst) |-> (!$isunknown(dma_addr));
    endproperty
    assert property(af_p450);

    property af_p451;
    @(posedge mclk) ($fell(dma_ready)) |=> ($past(dma_addr) != dma_addr);
    endproperty
    assert property(af_p451);

    property af_p452;
    @(posedge mclk) ((dma_addr >= 0) && (dma_addr <= 16383) && dma_en) |=> ((dma_addr >= 0) && (dma_addr <= 32767));
    endproperty
    assert property(af_p452);

    property af_p453;
    @(posedge mclk) (dma_ready) |-> $stable(dma_din);
    endproperty
    assert property(af_p453);

    property af_p454;
    @(posedge mclk) (dma_priority && dma_en && !dma_ready) |=> $stable(dma_din);
    endproperty
    assert property(af_p454);

    property af_p455;
    @(posedge mclk) (!puc_rst && dma_en && |dma_we) |-> ##[0:2] ((dma_din >= 0) && (dma_din <= 65535));
    endproperty
    assert property(af_p455);

    property af_p456;
    @(posedge mclk) (dma_en && !$past(dma_ready)) |-> $stable(dma_din);
    endproperty
    assert property(af_p456);

    property af_p457;
    @(posedge mclk) (dma_we[0] && !dma_ready) |=> $stable(dma_din[7:0]);
    endproperty
    assert property(af_p457);

    property af_p458;
    @(posedge mclk) (dma_en && !dma_ready) |=> $stable(dma_din);
    endproperty
    assert property(af_p458);

    property af_p459;
    @(posedge mclk) (dma_en && dma_we[1] && !dma_ready) |=> $stable(dma_din[15:8]);
    endproperty
    assert property(af_p459);

    property af_p460;
    @(posedge mclk) (dma_we && (dma_din >= 500) && (dma_din <= 999) && !dma_ready) |=> ((dma_din >= 500) && (dma_din <= 999));
    endproperty
    assert property(af_p460);

    property af_p461;
    @(posedge mclk) (dma_en && |dma_we && !dma_ready) |-> !$changed(dma_din);
    endproperty
    assert property(af_p461);

    property af_p462;
    @(posedge mclk) (dma_en && |dma_we && !dma_ready) |=> $stable(dma_din);
    endproperty
    assert property(af_p462);

    property af_p463;
    @(posedge mclk) (dma_en && dma_we) |-> (dma_din inside {[0:65535]}) until_with (dma_ready);
    endproperty
    assert property(af_p463);

    property af_p464;
    @(posedge mclk) $fell(puc_rst) |-> ##3 (dma_din inside {[0:65535]});
    endproperty
    assert property(af_p464);

    property af_p465;
    @(posedge mclk) (dma_en && dma_we) |=> $stable(dma_din) until_with (dma_ready);
    endproperty
    assert property(af_p465);

    property af_p466;
    @(posedge mclk) (dma_en && dma_we && !dma_ready) |-> (dma_din inside {[100:200]})[*2];
    endproperty
    assert property(af_p466);

    property af_p467;
    @(posedge mclk) (dma_en && dma_we) |-> $stable(dma_din) until_with (dma_ready);
    endproperty
    assert property(af_p467);

    property af_p468;
    @(posedge mclk) dma_we[1] |-> $stable(dma_din[15:8]) until_with (dma_ready);
    endproperty
    assert property(af_p468);


    property af_p470;
    @(posedge mclk) $past(dma_ready) |-> ($stable(dma_din) || !$stable(dma_din));
    endproperty
    assert property(af_p470);

    property af_p471;
    @(posedge mclk) (dma_priority && dma_en) |-> $stable(dma_din) until_with (dma_ready);
    endproperty
    assert property(af_p471);

    property af_p472;
    @(posedge mclk) $rose(dma_en) |-> $stable(dma_din) throughout (!dma_ready[*1:$] ##1 dma_ready);
    endproperty
    assert property(af_p472);

    property af_p473;
    @(posedge mclk) (dma_we[1] && (dma_din >= 32768) && (dma_din <= 65535)) |-> ((dma_din >= 32768) && (dma_din <= 65535)) until (dma_ready);
    endproperty
    assert property(af_p473);

    property af_p474;
    @(posedge mclk) $rose(dma_wkup) |-> $stable(dma_din) throughout (!dma_ready[->1]);
    endproperty
    assert property(af_p474);

    property af_p475;
    @(posedge mclk) (dma_en && (dma_din >= 100) && (dma_din <= 200)) |-> ((dma_din >= 100) && (dma_din <= 200)) until (dma_ready);
    endproperty
    assert property(af_p475);

    property af_p476;
    @(posedge mclk) (dma_we[0] && (dma_din >= 4096) && (dma_din <= 8191)) |-> ((dma_din >= 4096) && (dma_din <= 8191)) until (dma_ready);
    endproperty
    assert property(af_p476);

    property af_p477;
    @(posedge mclk) (dma_en && dma_we[0]) |-> $stable(dma_din[7:0]) throughout (!dma_ready[->1]);
    endproperty
    assert property(af_p477);

    property af_p478;
    @(posedge mclk) (puc_rst) |-> (1'b1);
    endproperty
    assert property(af_p478);

    property af_p479;
    @(posedge mclk) ($fell(puc_rst) ##1 dma_en) |-> ((dma_din >= 0) && (dma_din <= 65535));
    endproperty
    assert property(af_p479);

    property af_p480;
    @(posedge mclk) $fell(puc_rst) |-> ((dma_din >= 0) && (dma_din <= 65535)) throughout (!dma_en[->1]);
    endproperty
    assert property(af_p480);

    property af_p481;
    @(posedge mclk) $rose(dma_en) |-> $stable(dma_din) throughout (dma_ready[->1]);
    endproperty
    assert property(af_p481);

    property af_p482;
    @(posedge mclk) (dma_en && dma_ready) |=> !$isunknown(dma_dout);
    endproperty
    assert property(af_p482);

    property af_p483;
    @(posedge mclk) (dma_en && (dma_we == 2'b00) && dma_ready) |=> !$isunknown(dma_dout);
    endproperty
    assert property(af_p483);

    property af_p484;
    @(posedge mclk) dma_en |-> (dma_dout >= 0 && dma_dout <= 65535);
    endproperty
    assert property(af_p484);

    property af_p485;
    @(posedge mclk) (dma_priority && dma_en && dma_ready) |=> !$isunknown(dma_dout);
    endproperty
    assert property(af_p485);

    property af_p486;
    @(posedge mclk) (dma_en && (dma_we == 2'b00) && $changed(dma_din)) |-> $stable(dma_dout);
    endproperty
    assert property(af_p486);

    property af_p487;
    @(posedge mclk) puc_rst |-> (dma_dout == 16'h0000);
    endproperty
    assert property(af_p487);

    property af_p488;
    @(posedge mclk) (|dma_we) |-> ($stable(dma_dout) && !$isunknown(dma_dout));
    endproperty
    assert property(af_p488);

    property af_p489;
    @(posedge mclk) dma_ready |-> $stable(dma_dout);
    endproperty
    assert property(af_p489);

    property af_p490;
    @(posedge mclk) ($stable(dma_addr) && dma_ready) |=> !$isunknown(dma_dout);
    endproperty
    assert property(af_p490);

    property af_p491;
    @(posedge mclk) (!dma_en && $past(!dma_en)) |-> $stable(dma_dout);
    endproperty
    assert property(af_p491);

    property af_p492;
    @(posedge mclk) ($past(dma_en) && $past(dma_ready)) |-> !$isunknown(dma_dout);
    endproperty
    assert property(af_p492);

    property af_p493;
    @(posedge mclk) disable iff (!dma_en) ($past(dma_en) && !dma_ready) |-> $stable(dma_dout);
    endproperty
    assert property(af_p493);

    property af_p494;
    @(posedge mclk) dma_ready |=> $stable(dma_dout);
    endproperty
    assert property(af_p494);

    property af_p495;
    @(posedge mclk) $past(dma_ready) |-> (!$isunknown(dma_dout) && dma_dout inside {[16'h0000:16'hFFFF]});
    endproperty
    assert property(af_p495);


    property af_p497;
    @(posedge mclk) dma_ready |=> !$isunknown(dma_dout);
    endproperty
    assert property(af_p497);

    property af_p498;
    @(posedge mclk) $rose(puc_rst) |-> ##[1:$] (!dma_en throughout (dma_dout == 16'h0000));
    endproperty
    assert property(af_p498);

    property af_p499;
    @(posedge mclk) dma_ready |=> (dma_dout inside {[16'd100:16'd200]}) ##1 (dma_dout inside {[16'd100:16'd200]});
    endproperty
    assert property(af_p499);

    property af_p500;
    @(posedge mclk) $fell(puc_rst) |-> ##3 !$isunknown(dma_dout);
    endproperty
    assert property(af_p500);

    property af_p501;
    @(posedge mclk) (dma_ready) |-> $stable(dma_dout);
    endproperty
    assert property(af_p501);

    property af_p502;
    @(posedge mclk) (dma_priority && dma_en && dma_ready) |-> ##1 !$isunknown(dma_dout);
    endproperty
    assert property(af_p502);

    property af_p503;
    @(posedge mclk) (!dma_ready) |-> $stable(dma_dout);
    endproperty
    assert property(af_p503);

    property af_p504;
    @(posedge mclk) (!dma_en) |=> ($isunknown(dma_dout) || !$isunknown(dma_dout));
    endproperty
    assert property(af_p504);

    property af_p505;
    @(posedge mclk) $fell(puc_rst) |-> !$isunknown(dma_dout);
    endproperty
    assert property(af_p505);

    property af_p506;
    @(posedge mclk) (dma_en && !dma_we && dma_ready) |-> ##1 !$isunknown(dma_dout);
    endproperty
    assert property(af_p506);

    property af_p507;
    @(posedge mclk) (dma_ready) |-> ##1 !$isunknown(dma_dout);
    endproperty
    assert property(af_p507);

    property af_p508;
    @(posedge mclk) (dma_ready) |-> ##1 (dma_dout == $past(dma_addr));
    endproperty
    assert property(af_p508);

    property af_p509;
    @(posedge mclk) (dma_ready && !dma_we) |-> ##1 !$isunknown(dma_dout);
    endproperty
    assert property(af_p509);

    property af_p510;
    @(posedge mclk) (dma_ready) |-> ##1 $stable(dma_dout);
    endproperty
    assert property(af_p510);

    property af_p511;
    @(posedge mclk) (dma_en) |-> $stable(dma_addr) throughout (dma_en && !dma_ready);
    endproperty
    assert property(af_p511);

    property af_p512;
    @(posedge mclk) (dma_en) |-> (dma_addr === $past(dma_addr)) throughout (dma_en[*1:$] ##0 dma_ready);
    endproperty
    assert property(af_p512);

    property af_p513;
    @(posedge mclk) (!dma_en) |-> (!dma_ready && !dma_resp);
    endproperty
    assert property(af_p513);

    property af_p514;
    @(posedge mclk) (dma_en && !dma_we && dma_ready) |-> !$isunknown(dma_dout);
    endproperty
    assert property(af_p514);

    property af_p515;
    @(posedge mclk) (dma_en && !dma_ready) |=> (dma_en);
    endproperty
    assert property(af_p515);

    property af_p516;
    @(posedge mclk) (dma_en && dma_resp) |=> (!dma_en) or ##1 (!dma_en);
    endproperty
    assert property(af_p516);

    property af_p517;
    @(posedge mclk) $fell(dma_en) |-> $past(dma_ready);
    endproperty
    assert property(af_p517);

    property af_p518;
    @(posedge mclk) (dma_en) |-> (dma_addr == $stable(dma_addr)) throughout (!dma_ready[->1]);
    endproperty
    assert property(af_p518);

    property af_p519;
    @(posedge mclk) (dma_en && dma_priority) |-> (dma_priority == 1'b1);
    endproperty
    assert property(af_p519);

    property af_p520;
    @(posedge mclk) (dma_en && !dma_we) |=> $isunknown(dma_dout) == 0;
    endproperty
    assert property(af_p520);

    property af_p521;
    @(posedge mclk) dma_en |-> ($stable(dma_en) until dma_ready);
    endproperty
    assert property(af_p521);

    property af_p522;
    @(posedge mclk) (dma_en && dma_we && !dma_ready) |=> $stable(dma_din);
    endproperty
    assert property(af_p522);

    property af_p523;
    @(posedge mclk) dma_en |-> (dma_en until dma_ready);
    endproperty
    assert property(af_p523);

    property af_p524;
    @(posedge mclk) dma_en |-> dma_wkup;
    endproperty
    assert property(af_p524);

    property af_p525;
    @(posedge mclk) dma_en |-> ($stable(dma_addr) until dma_ready);
    endproperty
    assert property(af_p525);

    property af_p526;
    @(posedge mclk) puc_rst |=> !dma_en;
    endproperty
    assert property(af_p526);

    property af_p527;
    @(posedge mclk) dma_en |-> (dma_en throughout dma_ready[->1]) ##1 !dma_en;
    endproperty
    assert property(af_p527);

    property af_p528;
    @(posedge mclk) (dma_en && dma_priority) |-> ##[1:$] dma_ready;
    endproperty
    assert property(af_p528);

    property af_p529;
    @(posedge mclk) (dma_en && dma_priority) |-> (dma_en throughout dma_ready[->1]);
    endproperty
    assert property(af_p529);

    property af_p530;
    @(posedge mclk) (dma_en && !dma_ready) |=> $stable(dma_addr);
    endproperty
    assert property(af_p530);

    property af_p531;
    @(posedge mclk) (!reset_n && dma_en) |=> ($stable(dma_addr) && $stable(dma_dout));
    endproperty
    assert property(af_p531);

    property af_p532;
    @(posedge mclk) dma_en |-> (dma_en throughout dma_ready[->1]);
    endproperty
    assert property(af_p532);




    property af_p536;
    @(posedge aclk) ($changed(dma_priority) && dma_en) |-> $stable(dma_resp);
    endproperty
    assert property(af_p536);

    property af_p537;
    @(posedge mclk) ($fell(dma_priority) && dma_en) |=> (cpu_en);
    endproperty
    assert property(af_p537);

    property af_p538;
    @(posedge mclk) (dma_priority && dma_en) |-> ##[1:$] dma_ready;
    endproperty
    assert property(af_p538);

    property af_p539;
    @(posedge mclk) (dma_priority && dma_en) |-> (!cpu_en throughout (dma_ready[->1]));
    endproperty
    assert property(af_p539);

    property af_p540;
    @(posedge aclk) ($fell(dma_priority) && dma_en) |-> ##[1:$] cpu_en;
    endproperty
    assert property(af_p540);

    property af_p541;
    @(posedge mclk) ($rose(puc_rst)) |-> (dma_priority == 1'b0);
    endproperty
    assert property(af_p541);

    property af_p542;
    @(posedge aclk) ($changed(dma_priority)) |-> (!$past(dma_en) || $past(dma_ready));
    endproperty
    assert property(af_p542);

    property af_p543;
    @(posedge mclk) (dma_priority && dma_en) |=> (!cpu_en);
    endproperty
    assert property(af_p543);

    property af_p544;
    @(posedge mclk) (dma_priority && dma_en) |-> ##[1:16] dma_ready;
    endproperty
    assert property(af_p544);

    property af_p545;
    @(posedge mclk) ($fell(puc_rst)) |=> ((dma_priority == 1'b0) throughout (!dma_en)[->1]);
    endproperty
    assert property(af_p545);

    property af_p546;
    @(posedge aclk) (dma_priority && dma_en) |-> ##[1:8] dma_ready;
    endproperty
    assert property(af_p546);

    property af_p547;
    @(posedge mclk) (!dma_priority && dma_en) |-> cpu_en;
    endproperty
    assert property(af_p547);

    property af_p548;
    @(posedge mclk) (!dma_priority && dma_en && cpu_en) |-> !dma_ready;
    endproperty
    assert property(af_p548);

    property af_p549;
    @(posedge mclk) (!dma_en) |-> $stable(dma_priority);
    endproperty
    assert property(af_p549);

    property af_p550;
    @(posedge mclk) (dma_en && !dma_ready) |-> $stable(dma_priority);
    endproperty
    assert property(af_p550);

    property af_p551;
    @(posedge aclk) (dma_priority && |dma_we) |-> ##[1:$] dma_resp;
    endproperty
    assert property(af_p551);

    property af_p552;
    @(posedge mclk) (!dma_priority && dma_en) |-> (dma_ready == 0) until_with (!cpu_en && dma_ready);
    endproperty
    assert property(af_p552);

    property af_p553;
    @(posedge aclk) (!dma_priority) |-> (dma_ready |-> $past(!cpu_en));
    endproperty
    assert property(af_p553);

    property af_p554;
    @(posedge aclk) (dma_priority && dma_ready) |-> ##1 $stable(dma_dout) throughout (1);
    endproperty
    assert property(af_p554);

    property af_p555;
    @(posedge mclk) (!reset_n) |-> (dma_priority == 1'b0);
    endproperty
    assert property(af_p555);

    property af_p556;
    @(posedge mclk) (dma_priority && dma_en && dma_ready) |-> ##[1:2] dma_en ##[1:2] dma_ready;
    endproperty
    assert property(af_p556);

    property af_p557;
    @(posedge mclk) (!dma_priority && cpu_en) |-> (!dma_ready) throughout cpu_en[*1:$];
    endproperty
    assert property(af_p557);

    property af_p558;
    @(posedge aclk) (dma_en && !dma_ready) |-> $stable(dma_priority);
    endproperty
    assert property(af_p558);

    property af_p559;
    @(posedge mclk) $changed(dma_priority) |-> (dma_en == $past(dma_en));
    endproperty
    assert property(af_p559);

    property af_p560;
    @(posedge mclk) 1'b1 |=> $stable(dma_priority);
    endproperty
    assert property(af_p560);

    property af_p561;
    @(posedge mclk) ($rose(dma_priority) && dma_en) |=> !cpu_en;
    endproperty
    assert property(af_p561);

    property af_p562;
    @(posedge aclk) (!dma_priority && cpu_en) |-> (!dma_ready) until_with (!cpu_en);
    endproperty
    assert property(af_p562);

    property af_p563;
    @(posedge mclk) (dma_priority && dma_en) |-> ##[1:$] dma_resp;
    endproperty
    assert property(af_p563);

    property af_p564;
    @(posedge aclk) (!dma_priority && !dma_ready) |-> (dma_din == $past(dma_din)) until_with (dma_ready);
    endproperty
    assert property(af_p564);

    property af_p565;
    @(posedge mclk) $changed(dma_priority) |-> !dma_ready;
    endproperty
    assert property(af_p565);

    property af_p566;
    @(posedge mclk) !dma_en |-> !dma_ready;
    endproperty
    assert property(af_p566);

    property af_p567;
    @(posedge mclk) $rose(dma_en) |-> ($stable(dma_addr) throughout ((!dma_ready)[*0:$] ##1 dma_ready));
    endproperty
    assert property(af_p567);

    property af_p568;
    @(posedge mclk) $rose(dma_wkup) |-> !dma_ready;
    endproperty
    assert property(af_p568);

    property af_p569;
    @(posedge mclk) (dma_en && !dma_ready) |-> !dma_ready;
    endproperty
    assert property(af_p569);

    property af_p570;
    @(posedge mclk) dma_ready |-> !$isunknown(dma_dout);
    endproperty
    assert property(af_p570);

    property af_p571;
    @(posedge mclk) !dma_ready |-> !$isunknown(dma_resp) == 1'b0;
    endproperty
    assert property(af_p571);

    property af_p572;
    @(posedge mclk) $rose(nmi) |-> (!dma_ready) until (dma_ready);
    endproperty
    assert property(af_p572);

    property af_p573;
    @(posedge mclk) dma_ready |-> !$isunknown(dma_resp);
    endproperty
    assert property(af_p573);

    property af_p574;
    @(posedge mclk) (puc_rst) |-> (dma_ready == 1'b0);
    endproperty
    assert property(af_p574);

    property af_p575;
    @(posedge mclk) ($fell(puc_rst)) |-> (!dma_ready until dma_en);
    endproperty
    assert property(af_p575);

    property af_p576;
    @(posedge mclk) $rose(dma_en) |-> !dma_ready ##1 1;
    endproperty
    assert property(af_p576);

    property af_p577;
    @(posedge mclk) (dma_ready) |-> ($isunknown(dma_resp) == 0);
    endproperty
    assert property(af_p577);

    property af_p578;
    @(posedge mclk) (dma_ready && !dma_we) |-> (!$isunknown(dma_dout));
    endproperty
    assert property(af_p578);

    property af_p579;
    @(posedge mclk) (!dma_ready) |-> ($isunknown(dma_resp) || 1);
    endproperty
    assert property(af_p579);

    property af_p580;
    @(posedge mclk) $rose(dma_en) |-> (dma_ready throughout (dma_en[*1:$])) ##1 !dma_en |-> ##1 !dma_ready;
    endproperty
    assert property(af_p580);

    property af_p581;
    @(posedge mclk) (dma_en && !dma_ready) |-> (dma_en throughout (!dma_ready)[*1:$] ##1 dma_ready);
    endproperty
    assert property(af_p581);

    property af_p582;
    @(posedge mclk) $rose(dma_en) |-> ((!dma_ready)[*1:$] ##1 $rose(dma_ready));
    endproperty
    assert property(af_p582);

    property af_p583;
    @(posedge mclk) (dma_we && dma_ready) |-> $stable(dma_din);
    endproperty
    assert property(af_p583);

    property af_p584;
    @(posedge mclk) (per_en && dmem_cen && !dma_en) |-> !dma_ready;
    endproperty
    assert property(af_p584);

    property af_p585;
    @(posedge mclk) $rose(dma_wkup) |-> (!dma_ready throughout (!dma_en)[*1:$] ##1 dma_en);
    endproperty
    assert property(af_p585);

    property af_p586;
    @(posedge mclk) (!dma_en) |-> !dma_ready;
    endproperty
    assert property(af_p586);

    property af_p587;
    @(posedge mclk) $rose(dma_en) |-> ($stable(dma_addr) throughout dma_ready[->1]);
    endproperty
    assert property(af_p587);

    property af_p588;
    @(posedge mclk) (scan_mode) |-> !dma_ready;
    endproperty
    assert property(af_p588);

    property af_p589;
    @(posedge mclk) $fell(puc_rst) |-> !dma_ready;
    endproperty
    assert property(af_p589);


    property af_p591;
    @(posedge mclk) (dma_ready) |-> ($sampled(dma_resp) === dma_resp);
    endproperty
    assert property(af_p591);

    property af_p592;
    @(posedge aclk) (dma_ready) |-> ($stable(dma_resp) && (dma_resp === 1'b0 || dma_resp === 1'b1));
    endproperty
    assert property(af_p592);





    property af_p597;
    @(posedge aclk) $rose(puc_rst) |-> ##[0:1] (dma_resp === 1'b0);
    endproperty
    assert property(af_p597);

    property af_p598;
    @(posedge aclk) $fell(puc_rst) |-> (dma_resp == 1'b0);
    endproperty
    assert property(af_p598);

    property af_p599;
    @(posedge aclk) (!dma_ready) |-> $stable(dma_resp);
    endproperty
    assert property(af_p599);

    property af_p600;
    @(posedge dma_we) (dma_we && (dma_addr inside {[16'h0000:16'hFFFF]}) && dma_ready) |-> (dma_resp == 1'b0);
    endproperty
    assert property(af_p600);

    property af_p601;
    @(posedge mclk) (dma_en && !(dma_addr inside {[16'h0000:16'hFFFF]}) && dma_ready) |-> (dma_resp == 1'b1);
    endproperty
    assert property(af_p601);

    property af_p602;
    @(posedge mclk) (dma_ready) |-> (dma_resp == (!(dma_addr inside {[16'h0000:16'hFFFF]}) ? 1'b1 : 1'b0));
    endproperty
    assert property(af_p602);

    property af_p603;
    @(posedge mclk) (!dma_ready) |-> (dma_resp == 1'b0);
    endproperty
    assert property(af_p603);

    property af_p604;
    @(posedge mclk) (dma_we && dma_ready) |-> (dma_resp inside {1'b0, 1'b1});
    endproperty
    assert property(af_p604);

    property af_p605;
    @(posedge aclk) (dma_ready) |-> $stable(dma_resp);
    endproperty
    assert property(af_p605);

    property af_p606;
    @(posedge aclk) (dma_resp inside {[0:1]});
    endproperty
    assert property(af_p606);

    property af_p607;
    @(posedge mclk) $rose(dma_ready) |-> (dma_resp === dma_resp);
    endproperty
    assert property(af_p607);

    property af_p608;
    @(posedge aclk) (!dma_en) |-> $stable(dma_resp);
    endproperty
    assert property(af_p608);

    property af_p609;
    @(posedge mclk) (!dma_en) |-> (dma_resp == 1'b0);
    endproperty
    assert property(af_p609);

    property af_p610;
    @(posedge mclk) $fell(puc_rst) |-> (dma_resp == 1'b0);
    endproperty
    assert property(af_p610);


    property af_p612;
    @(posedge mclk) (!dma_ready) |-> $stable(dma_resp);
    endproperty
    assert property(af_p612);

    property af_p613;
    @(posedge mclk) (dma_wkup ##[1:$] (dma_ready)) |-> (dma_resp == 1'b0);
    endproperty
    assert property(af_p613);

    property af_p614;
    @(posedge mclk) ($fell(puc_rst)) |-> ##3 ((dma_we >= 0) && (dma_we <= 3));
    endproperty
    assert property(af_p614);

    property af_p615;
    @(posedge mclk) disable iff (puc_rst) (1) |-> ((dma_we >= 0) && (dma_we <= 3));
    endproperty
    assert property(af_p615);

    property af_p616;
    @(posedge mclk) ($rose(dma_ready) && !dma_en) |=> (dma_we == 2'b00);
    endproperty
    assert property(af_p616);

    property af_p617;
    @(posedge mclk) (!dma_en) |-> ($stable(dma_we));
    endproperty
    assert property(af_p617);

    property af_p618;
    @(posedge mclk) (dma_en) |-> ($isunknown(dma_addr) === 0);
    endproperty
    assert property(af_p618);

    property af_p619;
    @(posedge mclk) (puc_rst) |-> (dma_we == 2'b00);
    endproperty
    assert property(af_p619);

    property af_p620;
    @(posedge mclk) ((dma_we >= 1) && (dma_we <= 3)) |-> (dma_en);
    endproperty
    assert property(af_p620);

    property af_p621;
    @(posedge mclk) (dma_we != 2'b00) |-> s_eventually(dma_ready);
    endproperty
    assert property(af_p621);

    property af_p622;
    @(posedge mclk) (dma_en && (dma_we != 2'b00)) |-> (dma_we == $past(dma_we)) until (dma_ready);
    endproperty
    assert property(af_p622);

    property af_p623;
    @(posedge mclk) ((dma_we >= 1) && (dma_we <= 3)) |=> ((dma_we >= 0) && (dma_we <= 3));
    endproperty
    assert property(af_p623);

    property af_p624;
    @(posedge mclk) (!dma_en) |-> ((dma_we >= 0) && (dma_we <= 3));
    endproperty
    assert property(af_p624);

    property af_p625;
    @(posedge mclk) (dma_priority && (dma_we != 2'b00)) |-> ##[1:3] (dma_ready && !cpu_en);
    endproperty
    assert property(af_p625);

    property af_p626;
    @(posedge mclk) (dma_we[0]) |-> (dma_din == $past(dma_din)) until_with (dma_ready);
    endproperty
    assert property(af_p626);

    property af_p627;
    @(posedge mclk) ((dma_we != 2'b00) && (dma_we == 2'b00)[->1]) |-> ($past(dma_ready));
    endproperty
    assert property(af_p627);

    property af_p628;
    @(posedge mclk) (~dma_en) |-> (dma_we == 2'b00);
    endproperty
    assert property(af_p628);

    property af_p629;
    @(posedge mclk) (~puc_rst) |-> (dma_we inside {[0:3]});
    endproperty
    assert property(af_p629);

    property af_p630;
    @(posedge mclk) $fell(puc_rst) |-> ##4 (dma_we inside {[0:3]});
    endproperty
    assert property(af_p630);

    property af_p631;
    @(posedge mclk) (dma_we[0] && dma_en) |-> ##[1:3] (dma_ready);
    endproperty
    assert property(af_p631);

    property af_p632;
    @(posedge mclk) (dma_we[0] && dma_we[1]) |-> (dma_din == $past(dma_din)) until_with (dma_ready);
    endproperty
    assert property(af_p632);

    property af_p633;
    @(posedge mclk) $rose(~puc_rst) |-> ##4 (dma_we inside {[0:3]});
    endproperty
    assert property(af_p633);

    property af_p634;
    @(posedge mclk) (puc_rst) |-> ##1 (dma_we == 2'b00);
    endproperty
    assert property(af_p634);

    property af_p635;
    @(posedge mclk) $rose(dma_priority) |-> (dma_we inside {[0:3]})[*2];
    endproperty
    assert property(af_p635);

    property af_p636;
    @(posedge mclk) (dma_ready) |=> (dma_we == 2'b00);
    endproperty
    assert property(af_p636);

    property af_p637;
    @(posedge mclk) ((dma_we >= 2) && (dma_we <= 3)) |=> ((dma_we >= 0) && (dma_we <= 3));
    endproperty
    assert property(af_p637);

    property af_p638;
    @(posedge mclk) (dma_we[1]) |-> ($stable(dma_din) until dma_ready);
    endproperty
    assert property(af_p638);

    property af_p639;
    @(posedge mclk) (dma_en && dma_we[1]) |-> ##[1:3] dma_ready;
    endproperty
    assert property(af_p639);

    property af_p640;
    @(posedge mclk) (!puc_rst) |-> (dma_we inside {[0:3]});
    endproperty
    assert property(af_p640);

    property af_p641;
    @(posedge mclk) (dma_we != 2'b00) |-> ($stable(dma_addr) until dma_ready);
    endproperty
    assert property(af_p641);

    property af_p642;
    @(posedge mclk) (dma_we[0] && dma_we[1]) |-> ($stable(dma_din) until dma_ready);
    endproperty
    assert property(af_p642);

    property af_p643;
    @(posedge mclk) ((dma_we >= 1) && (dma_we <= 3) && dma_priority) |-> dma_resp;
    endproperty
    assert property(af_p643);

    property af_p644;
    @(posedge mclk) (dma_en) |-> (dma_we inside {[0:3]});
    endproperty
    assert property(af_p644);

    property af_p645;
    @(posedge mclk) (puc_rst) |=> (dma_we == 2'b00);
    endproperty
    assert property(af_p645);

    property af_p646;
    @(posedge mclk) (dma_en && (dma_we != 2'b00)) |-> ($stable(dma_din) until dma_ready);
    endproperty
    assert property(af_p646);

    property af_p647;
    @(posedge mclk) (dma_wkup && dma_en) |=> (dma_addr >= 0) && (dma_addr <= 16'hFFFF);
    endproperty
    assert property(af_p647);

    property af_p648;
    @(posedge mclk) (!reset_n) |-> (dma_wkup >= 0) && (dma_wkup <= 1);
    endproperty
    assert property(af_p648);

    property af_p649;
    @(posedge mclk) (dma_en) |-> (dma_wkup == $past(dma_wkup)) ##1 (dma_wkup == $past(dma_wkup, 2));
    endproperty
    assert property(af_p649);

    property af_p650;
    @(posedge mclk) (!reset_n) |-> (dma_wkup == 1'b0);
    endproperty
    assert property(af_p650);

    property af_p651;
    @(posedge mclk) (dma_en throughout (dma_en[*2])) |-> $stable(dma_wkup);
    endproperty
    assert property(af_p651);

    property af_p652;
    @(posedge mclk) ($rose(dma_wkup)) |-> (mclk == 1'b1);
    endproperty
    assert property(af_p652);

    property af_p653;
    @(posedge mclk) (dma_en) |-> (dma_wkup == 1'b1) throughout (dma_en == 1'b1);
    endproperty
    assert property(af_p653);

    property af_p654;
    @(posedge mclk) (dma_wkup) |=> (dma_en >= 0) && (dma_en <= 1);
    endproperty
    assert property(af_p654);

    property af_p655;
    @(posedge mclk) ($changed(dma_wkup)) |-> $stable(reset_n);
    endproperty
    assert property(af_p655);

    property af_p656;
    @(posedge mclk) (!dma_en) |-> (dma_wkup == 1'b0) [*4];
    endproperty
    assert property(af_p656);

    property af_p657;
    @(posedge mclk) ($rose(dma_wkup) && !cpu_en) |=> (mclk == 1'b1);
    endproperty
    assert property(af_p657);

    property af_p658;
    @(posedge mclk) (dma_wkup && !cpu_en) |=> (mclk == 1'b1);
    endproperty
    assert property(af_p658);

    property af_p659;
    @(posedge mclk) ($fell(dma_wkup) && !cpu_en) |=> (mclk == 0);
    endproperty
    assert property(af_p659);

    property af_p660;
    @(posedge mclk) $rose(dma_en) |-> ##[1:3] (dma_wkup == 1);
    endproperty
    assert property(af_p660);

    property af_p661;
    @(posedge mclk) (dma_wkup && !cpu_en) |=> (mclk == 1);
    endproperty
    assert property(af_p661);

    property af_p662;
    @(posedge mclk) ($rose(dma_wkup) && !cpu_en) |=> (dma_ready >= 0 && dma_ready <= 1);
    endproperty
    assert property(af_p662);

    property af_p663;
    @(posedge mclk) (dma_en && !cpu_en) |-> (dma_wkup == 1);
    endproperty
    assert property(af_p663);

    property af_p664;
    @(posedge mclk) (dma_wkup && cpu_en) |=> (mclk == 1);
    endproperty
    assert property(af_p664);

    property af_p665;
    @(posedge mclk) $rose(reset_n) |=> (dma_wkup == 0);
    endproperty
    assert property(af_p665);

    property af_p666;
    @(posedge mclk) ($fell(dma_en) && !cpu_en) |=> (dma_wkup == 0);
    endproperty
    assert property(af_p666);

    property af_p667;
    @(posedge mclk) $fell(dma_en) |=> (dma_wkup == 0);
    endproperty
    assert property(af_p667);

    property af_p668;
    @(posedge mclk) (!dma_wkup && !cpu_en) |=> (mclk == 0);
    endproperty
    assert property(af_p668);

    property af_p669;
    @(posedge mclk) (dma_ready && !cpu_en) |-> dma_wkup;
    endproperty
    assert property(af_p669);

    property af_p670;
    @(posedge mclk) $rose(puc_rst) |-> ##1 (dma_wkup == 1'b0);
    endproperty
    assert property(af_p670);

    property af_p671;
    @(posedge mclk) $fell(reset_n) |-> ##2 (dma_wkup inside {1'b0, 1'b1});
    endproperty
    assert property(af_p671);

    property af_p672;
    @(posedge mclk) $rose(puc_rst) |-> ##1 (!dma_wkup)[*2];
    endproperty
    assert property(af_p672);

    property af_p673;
    @(posedge mclk) $rose(dma_en) |-> ##1 $stable(dma_wkup);
    endproperty
    assert property(af_p673);

    property af_p674;
    @(posedge mclk) ($rose(dma_wkup) && !cpu_en) |-> ##1 mclk;
    endproperty
    assert property(af_p674);

    property af_p675;
    @(posedge mclk) (!dma_wkup && !cpu_en) |-> ##1 !mclk;
    endproperty
    assert property(af_p675);

    property af_p676;
    @(posedge mclk) $fell(reset_n) |-> (!dma_wkup)[*2];
    endproperty
    assert property(af_p676);

    property af_p677;
    @(posedge mclk) (dma_wkup && !cpu_en) |-> ##1 $changed(mclk);
    endproperty
    assert property(af_p677);

    property af_p678;
    @(posedge mclk) (dma_wkup && !cpu_en)[*2:$] |-> mclk;
    endproperty
    assert property(af_p678);

    property af_p679;
    @(posedge mclk) (!dmem_cen) |-> !$isunknown(dmem_addr);
    endproperty
    assert property(af_p679);

    property af_p680;
    @(posedge mclk) (dmem_cen) |=> (dmem_addr == $past(dmem_addr));
    endproperty
    assert property(af_p680);

    property af_p681;
    @(posedge mclk) (1'b1) |-> ##1 (dmem_addr === $past(dmem_addr)) or (dmem_addr !== $past(dmem_addr));
    endproperty
    assert property(af_p681);

    property af_p682;
    @(posedge mclk) (dbg_freeze) |=> (dmem_addr == $past(dmem_addr));
    endproperty
    assert property(af_p682);

    property af_p683;
    @(posedge mclk) (dmem_wen != 2'b11) |-> !$isunknown(dmem_addr);
    endproperty
    assert property(af_p683);

    property af_p684;
    @(posedge mclk) (!dmem_cen) |-> (dmem_addr >= 16'h0000) && (dmem_addr <= 16'hFFFF);
    endproperty
    assert property(af_p684);

    property af_p685;
    @(posedge mclk) (!dmem_cen) |-> $stable(dmem_addr);
    endproperty
    assert property(af_p685);

    property af_p686;
    @(posedge mclk) (!dma_en) |-> (dmem_addr !== dma_addr) or (dma_en |-> (dmem_addr == dma_addr));
    endproperty
    assert property(af_p686);

    property af_p687;
    @(posedge mclk) (!dmem_cen && (dmem_wen != 2'b11)) |-> (dmem_addr == $past(dmem_addr)) or (dmem_addr === dmem_addr);
    endproperty
    assert property(af_p687);

    property af_p688;
    @(posedge mclk) (puc_rst) |=> (!$isunknown(dmem_addr));
    endproperty
    assert property(af_p688);

    property af_p689;
    @(posedge mclk) (|dmem_wen) |-> (!$isunknown(dmem_addr) && !$isunknown(dmem_dout));
    endproperty
    assert property(af_p689);


    property af_p691;
    @(posedge mclk) (dmem_cen) |-> $stable(dmem_addr);
    endproperty
    assert property(af_p691);



    property af_p694;
    @(posedge mclk) (!dmem_cen && (dmem_wen == 2'b00)) |-> ##1 (dmem_addr != $past(dmem_addr));
    endproperty
    assert property(af_p694);


    property af_p696;
    @(posedge mclk) (dmem_cen) |-> (dmem_addr == $past(dmem_addr));
    endproperty
    assert property(af_p696);

    property af_p697;
    @(posedge mclk) $rose(puc_rst) |-> ##1 (!$isunknown(dmem_addr) && dmem_addr == 16'h0000);
    endproperty
    assert property(af_p697);

    property af_p698;
    @(posedge mclk) $rose(reset_n) |-> ##[1:5] !$isunknown(dmem_addr);
    endproperty
    assert property(af_p698);

    property af_p699;
    @(posedge mclk) (!cpu_en) |-> $stable(dmem_addr);
    endproperty
    assert property(af_p699);

    property af_p700;
    @(posedge mclk) (!$past(dmem_cen)) |-> (dmem_dout != $past(dmem_dout) || dmem_addr == $past(dmem_addr));
    endproperty
    assert property(af_p700);

    property af_p701;
    @(posedge mclk) $fell(puc_rst) |-> ##[1:2] !$isunknown(dmem_addr);
    endproperty
    assert property(af_p701);

    property af_p702;
    @(posedge mclk) ($changed(dmem_addr)) |-> $past(!dmem_cen);
    endproperty
    assert property(af_p702);


    property af_p704;
    @(posedge mclk) (puc_rst) |-> ($stable(dmem_addr) && !$isunknown(dmem_addr));
    endproperty
    assert property(af_p704);

    property af_p705;
    @(posedge mclk) (!dmem_cen) |-> (!$isunknown(dmem_addr));
    endproperty
    assert property(af_p705);

    property af_p706;
    @(posedge mclk) ($fell(dmem_cen)) |=> (!$isunknown(dmem_dout));
    endproperty
    assert property(af_p706);

    property af_p707;
    @(posedge mclk) ($changed(dmem_cen)) |-> ((dmem_cen == 1'b0) || (dmem_cen == 1'b1));
    endproperty
    assert property(af_p707);

    property af_p708;
    @(posedge mclk) (!dmem_cen) |-> (!$isunknown(dmem_addr) && !$isunknown(dmem_wen));
    endproperty
    assert property(af_p708);

    property af_p709;
    @(posedge mclk) (!dmem_cen) |-> $stable(dmem_addr);
    endproperty
    assert property(af_p709);

    property af_p710;
    @(posedge mclk) (!dmem_cen) |=> (!$isunknown(dmem_din));
    endproperty
    assert property(af_p710);

    property af_p711;
    @(posedge mclk) (dbg_freeze) |-> (dmem_cen);
    endproperty
    assert property(af_p711);

    property af_p712;
    @(posedge mclk) (!dmem_cen) |-> (cpu_en);
    endproperty
    assert property(af_p712);

    property af_p713;
    @(posedge mclk) (!dmem_cen) |=> (!$isunknown(dmem_addr));
    endproperty
    assert property(af_p713);

    property af_p714;
    @(posedge mclk) ($fell(reset_n)) |=> (dmem_cen)[*3];
    endproperty
    assert property(af_p714);

    property af_p715;
    @(posedge mclk) ($fell(puc_rst)) |-> ##[1:2] (!dmem_cen);
    endproperty
    assert property(af_p715);

    property af_p716;
    @(posedge mclk) (dmem_cen) |-> $stable(dmem_dout);
    endproperty
    assert property(af_p716);

    property af_p717;
    @(posedge mclk) (!dmem_cen && |dmem_wen) |-> ##1 (dmem_dout === $past(dmem_din));
    endproperty
    assert property(af_p717);

    property af_p718;
    @(posedge mclk) (!cpu_en) |-> (dmem_cen == 1'b1);
    endproperty
    assert property(af_p718);

    property af_p719;
    @(posedge mclk) ($fell(dmem_cen)) |=> $rose(dmem_cen);
    endproperty
    assert property(af_p719);

    property af_p720;
    @(posedge mclk) (!dmem_cen && |dmem_wen) |=> (dmem_dout == $past(dmem_din));
    endproperty
    assert property(af_p720);

    property af_p721;
    @(posedge mclk) (puc_rst) |-> (dmem_cen == 1'b1);
    endproperty
    assert property(af_p721);

    property af_p722;
    @(posedge mclk) (dmem_cen) |=> (dmem_dout == $past(dmem_dout));
    endproperty
    assert property(af_p722);

    property af_p723;
    @(posedge mclk) (!reset_n) |-> (dmem_cen == 1'b1);
    endproperty
    assert property(af_p723);

    property af_p724;
    @(posedge mclk) (dmem_cen) |=> $stable(dmem_dout);
    endproperty
    assert property(af_p724);

    property af_p725;
    @(posedge mclk) $rose(puc_rst) |-> ##1 dmem_cen ##1 dmem_cen;
    endproperty
    assert property(af_p725);

    property af_p726;
    @(posedge mclk) $fell(puc_rst) |-> ##[1:3] (!dmem_cen);
    endproperty
    assert property(af_p726);

    property af_p727;
    @(posedge mclk) (!dmem_cen) |=> !$isunknown(dmem_dout);
    endproperty
    assert property(af_p727);

    property af_p728;
    @(posedge mclk) (dma_en) |-> (dmem_cen);
    endproperty
    assert property(af_p728);

    property af_p729;
    @(posedge mclk) (dma_en) |-> ##1 (!dmem_cen && (dmem_addr == dma_addr) && (dmem_wen == dma_we));
    endproperty
    assert property(af_p729);

    property af_p730;
    @(posedge mclk) ($past(dmem_cen)) |-> $stable(dmem_dout);
    endproperty
    assert property(af_p730);

    property af_p731;
    @(posedge mclk) (puc_rst) |-> (dmem_cen);
    endproperty
    assert property(af_p731);

    property af_p732;
    @(posedge mclk) (!cpu_en) |-> (dmem_cen);
    endproperty
    assert property(af_p732);

    property af_p733;
    @(posedge mclk) $fell(dmem_cen) |=> (dmem_cen);
    endproperty
    assert property(af_p733);

    property af_p734;
    @(posedge mclk) (!dmem_cen && !$past(dmem_cen)) |-> $stable(dmem_addr);
    endproperty
    assert property(af_p734);

    property af_p735;
    @(posedge mclk) disable iff (puc_rst) (cpu_en) |-> (dmem_cen != $past(dmem_cen));
    endproperty
    assert property(af_p735);

    property af_p736;
    @(posedge mclk) $rose(reset_n) |-> ##4 ((dmem_din >= 0) && (dmem_din <= 65535));
    endproperty
    assert property(af_p736);

    property af_p737;
    @(posedge mclk) $fell(puc_rst) |-> ##3 ((dmem_din >= 0) && (dmem_din <= 65535));
    endproperty
    assert property(af_p737);

    property af_p738;
    @(posedge mclk) (!dmem_cen && (dmem_wen != 2'b11)) |-> (!$isunknown(dmem_din)) and (dmem_cen |=> $stable(dmem_din));
    endproperty
    assert property(af_p738);

    property af_p739;
    @(posedge mclk) $rose(puc_rst) |=> $stable(dmem_din);
    endproperty
    assert property(af_p739);

    property af_p740;
    @(posedge mclk) (!dmem_wen[0]) |=> (dmem_din[15:8] == $past(dmem_din[15:8]));
    endproperty
    assert property(af_p740);

    property af_p741;
    @(posedge mclk) (!dmem_wen[1]) |-> (!$isunknown(dmem_din));
    endproperty
    assert property(af_p741);

    property af_p742;
    @(posedge mclk) ((dmem_din >= 1000) && (dmem_din <= 2000)) |=> ((dmem_din >= 500) && (dmem_din <= 2500));
    endproperty
    assert property(af_p742);

    property af_p743;
    @(posedge mclk) ((dmem_din >= 0) && (dmem_din <= 65535)) |=> ((dmem_din >= 0) && (dmem_din <= 65535));
    endproperty
    assert property(af_p743);

    property af_p744;
    @(posedge mclk) ((dmem_din >= 30000) && (dmem_din <= 65535)) |=> ((dmem_din >= 20000) && (dmem_din <= 65535));
    endproperty
    assert property(af_p744);

    property af_p745;
    @(posedge mclk) (!dmem_cen && (dmem_wen != 2'b11)) |=> (!$isunknown(dmem_din));
    endproperty
    assert property(af_p745);

    property af_p746;
    @(posedge mclk) ((dmem_din >= 0) && (dmem_din <= 32767)) |=> ((dmem_din >= 0) && (dmem_din <= 65535));
    endproperty
    assert property(af_p746);

    property af_p747;
    @(posedge mclk) (puc_rst) |-> $stable(dmem_din);
    endproperty
    assert property(af_p747);

    property af_p748;
    @(posedge mclk) (!puc_rst) |-> (dmem_din >= 0) && (dmem_din <= 65535);
    endproperty
    assert property(af_p748);

    property af_p749;
    @(posedge mclk) ($rose(reset_n)) |-> ##4 ((dmem_din >= 0) && (dmem_din <= 65535));
    endproperty
    assert property(af_p749);

    property af_p750;
    @(posedge mclk) ((dmem_din >= 32768) && (dmem_din <= 65535)) |=> (dmem_din >= 30000) && (dmem_din <= 65535);
    endproperty
    assert property(af_p750);

    property af_p751;
    @(posedge mclk) (!dmem_wen[1]) |=> $stable(dmem_din[7:0]);
    endproperty
    assert property(af_p751);

    property af_p752;
    @(posedge mclk) (((dmem_din >= 1) && (dmem_din <= 100)) && (!dmem_wen[0])) |=> ((dmem_din >= 1) && (dmem_din <= 100)) [*2];
    endproperty
    assert property(af_p752);

    property af_p753;
    @(posedge mclk) ((dmem_din >= 40000) && (dmem_din <= 65535)) |=> (dmem_din >= 30000) && (dmem_din <= 65535);
    endproperty
    assert property(af_p753);

    property af_p754;
    @(posedge mclk) ((dmem_wen == 2'b01) || (dmem_wen == 2'b10)) |=> $stable(dmem_din);
    endproperty
    assert property(af_p754);

    property af_p755;
    @(posedge mclk) (dmem_cen) |-> $stable(dmem_din);
    endproperty
    assert property(af_p755);

    property af_p756;
    @(posedge mclk) (!dmem_cen) |-> (!$isunknown(dmem_din));
    endproperty
    assert property(af_p756);

    property af_p757;
    @(posedge mclk) ($fell(puc_rst)) |-> ##4 ((dmem_din >= 0) && (dmem_din <= 65535));
    endproperty
    assert property(af_p757);


    property af_p759;
    @(posedge mclk) (dmem_wen == 2'b11) |-> $stable(dmem_din);
    endproperty
    assert property(af_p759);

    property af_p760;
    @(posedge mclk) $rose(!dmem_cen) |-> !$isunknown(dmem_din) throughout (##1 1'b1);
    endproperty
    assert property(af_p760);

    property af_p761;
    @(posedge mclk) (dmem_wen != 2'b11) |-> !$isunknown(dmem_din);
    endproperty
    assert property(af_p761);

    property af_p762;
    @(posedge mclk) (!dmem_wen[0]) |-> !$isunknown(dmem_din);
    endproperty
    assert property(af_p762);

    property af_p763;
    @(posedge mclk) $rose(puc_rst) |-> (dmem_din == 16'h0000) throughout (dmem_wen == 2'b11)[*1:$];
    endproperty
    assert property(af_p763);

    property af_p764;
    @(posedge mclk) ((dmem_din >= 1000) && (dmem_din <= 2000)) |-> ##1 ((dmem_din >= 500) && (dmem_din <= 2500));
    endproperty
    assert property(af_p764);

    property af_p765;
    @(posedge mclk) $rose(puc_rst == 1'b0) |-> ##3 (dmem_din >= 0 && dmem_din <= 65535);
    endproperty
    assert property(af_p765);

    property af_p766;
    @(posedge mclk) ((dmem_cen == 1'b0) && (dmem_wen != 2'b11)) |-> !$isunknown(dmem_din);
    endproperty
    assert property(af_p766);

    property af_p767;
    @(posedge mclk) ((dmem_din >= 100) && (dmem_din <= 200)) |-> ##1 ((dmem_din >= 50) && (dmem_din <= 250));
    endproperty
    assert property(af_p767);

    property af_p768;
    @(posedge mclk) (dmem_addr == $past(dmem_addr)) && (dmem_wen != 2'b11) |-> (dmem_din == $past(dmem_din));
    endproperty
    assert property(af_p768);

    property af_p769;
    @(posedge mclk) $rose(reset_n) |-> ##5 (dmem_din >= 0 && dmem_din <= 65535);
    endproperty
    assert property(af_p769);

    property af_p770;
    @(posedge mclk) (!dmem_cen) |=> !$isunknown(dmem_dout);
    endproperty
    assert property(af_p770);

    property af_p771;
    @(posedge mclk) (dmem_cen && (dmem_addr !== $past(dmem_addr))) |=> $stable(dmem_dout);
    endproperty
    assert property(af_p771);

    property af_p772;
    @(posedge mclk) (!dmem_cen && !$past(dmem_cen) && (dmem_addr !== $past(dmem_addr))) |-> (dmem_dout !== $past(dmem_dout));
    endproperty
    assert property(af_p772);

    property af_p773;
    @(posedge mclk) $fell(puc_rst) |-> ##[1:2] !$isunknown(dmem_dout);
    endproperty
    assert property(af_p773);

    property af_p774;
    @(posedge mclk) (!puc_rst) |-> !$isunknown(dmem_dout);
    endproperty
    assert property(af_p774);

    property af_p775;
    @(posedge mclk) ($rose(dmem_cen)) |=> $stable(dmem_dout);
    endproperty
    assert property(af_p775);

    property af_p776;
    @(posedge mclk) ($fell(puc_rst) && dmem_cen) |-> (dmem_dout === 16'h0000);
    endproperty
    assert property(af_p776);

    property af_p777;
    @(posedge mclk) ($past(dmem_cen) && dmem_cen) |-> $stable(dmem_dout);
    endproperty
    assert property(af_p777);

    property af_p778;
    @(posedge mclk) (!dmem_cen && !(&dmem_wen)) |=> (dmem_dout !== $past(dmem_dout));
    endproperty
    assert property(af_p778);

    property af_p779;
    @(posedge mclk) (dmem_cen) |=> $stable(dmem_dout);
    endproperty
    assert property(af_p779);

    property af_p780;
    @(posedge mclk) (!dmem_cen) |=> ((dmem_wen == 2'b11) || !$isunknown(dmem_dout));
    endproperty
    assert property(af_p780);

    property af_p781;
    @(posedge mclk) ($past(!dmem_cen) && dmem_cen) |-> $stable(dmem_dout);
    endproperty
    assert property(af_p781);

    property af_p782;
    @(posedge mclk) $past(!dmem_cen) |-> !$isunknown(dmem_dout);
    endproperty
    assert property(af_p782);

    property af_p783;
    @(posedge mclk) (!dmem_cen) |-> (dmem_dout >= 0 && dmem_dout <= 65535);
    endproperty
    assert property(af_p783);

    property af_p784;
    @(posedge mclk) (dmem_cen && $past(dmem_cen) && $past(dmem_cen,2)) |-> $stable(dmem_dout);
    endproperty
    assert property(af_p784);

    property af_p785;
    @(posedge mclk) (!dmem_cen) |-> $stable(dmem_dout);
    endproperty
    assert property(af_p785);

    property af_p786;
    @(posedge mclk) (dmem_cen && $past(dmem_cen)) |-> $stable(dmem_dout);
    endproperty
    assert property(af_p786);

    property af_p787;
    @(posedge mclk) (!dmem_cen && (dmem_wen != 2'b11)) |=> (dmem_dout == $past(dmem_din));
    endproperty
    assert property(af_p787);

    property af_p788;
    @(posedge mclk) ($past(!dmem_cen) && ($past(dmem_addr) == dmem_addr)) |-> !$isunknown(dmem_dout);
    endproperty
    assert property(af_p788);

    property af_p789;
    @(posedge mclk) (dmem_cen == 1'b0) |=> (dmem_dout == $past(dmem_din));
    endproperty
    assert property(af_p789);



    property af_p792;
    @(posedge mclk) (dmem_cen == 1'b1) |=> ($stable(dmem_dout));
    endproperty
    assert property(af_p792);

    property af_p793;
    @(posedge mclk) (dmem_cen == 1'b0) |=> (dmem_dout !== $past(dmem_dout)) || 1'b1;
    endproperty
    assert property(af_p793);


    property af_p795;
    @(posedge mclk) (dmem_cen == 1'b1) |=> $stable(dmem_dout);
    endproperty
    assert property(af_p795);

    property af_p796;
    @(posedge mclk) (dmem_cen == 1'b1) |-> $stable(dmem_dout);
    endproperty
    assert property(af_p796);

    property af_p797;
    @(posedge mclk) (dmem_wen == 2'b00) |=> (dmem_dout == $past(dmem_din));
    endproperty
    assert property(af_p797);

    property af_p798;
    @(posedge mclk) (dmem_cen) |=> (dmem_wen == 3);
    endproperty
    assert property(af_p798);

    property af_p799;
    @(posedge mclk) (!dmem_wen[1]) |=> (dmem_dout[15:8] == $past(dmem_din[15:8])) && $stable(dmem_addr);
    endproperty
    assert property(af_p799);

    property af_p800;
    @(posedge mclk) $fell(puc_rst) |=> (dmem_wen == 2'b11);
    endproperty
    assert property(af_p800);

    property af_p801;
    @(posedge mclk) (!dmem_wen[0]) |=> (dmem_dout[7:0] == $past(dmem_din[7:0]));
    endproperty
    assert property(af_p801);

    property af_p802;
    @(posedge mclk) (dmem_wen >= 0 && dmem_wen <= 1) |-> $stable(dmem_addr);
    endproperty
    assert property(af_p802);

    property af_p803;
    @(posedge mclk) (dmem_cen) |-> $stable(dmem_wen);
    endproperty
    assert property(af_p803);

    property af_p804;
    @(posedge mclk) (dmem_cen) |-> (dmem_wen >= 2) && (dmem_wen <= 3);
    endproperty
    assert property(af_p804);

    property af_p805;
    @(posedge mclk) (!dmem_cen && dmem_wen == 2'b11) |=> !$isunknown(dmem_dout);
    endproperty
    assert property(af_p805);

    property af_p806;
    @(posedge mclk) $fell(puc_rst) |-> (dmem_wen >= 0 && dmem_wen <= 3)[*3];
    endproperty
    assert property(af_p806);

    property af_p807;
    @(posedge mclk) ((dmem_wen[0] == 1'b0) && (dmem_wen[1] == 1'b1)) |-> (dmem_dout[15:8] == $past(dmem_dout[15:8]));
    endproperty
    assert property(af_p807);

    property af_p808;
    @(posedge mclk) (dmem_wen == 2'b00) |-> !$isunknown(dmem_din);
    endproperty
    assert property(af_p808);

    property af_p809;
    @(posedge mclk) disable iff (dbg_freeze) 1 |-> (dbg_freeze -> (dmem_wen == 2'b11));
    endproperty
    assert property(af_p809);

    property af_p810;
    @(posedge mclk) (dmem_wen[1] == 1'b0) |=> (dmem_dout[15:8] == $past(dmem_din[15:8]));
    endproperty
    assert property(af_p810);

    property af_p811;
    @(posedge mclk) $rose(puc_rst) |=> (dmem_wen == 2'b11);
    endproperty
    assert property(af_p811);

    property af_p812;
    @(posedge mclk) ($fell(dmem_wen) && !dmem_cen) |=> (dmem_dout == $past(dmem_din));
    endproperty
    assert property(af_p812);

    property af_p813;
    @(posedge puc_rst) (puc_rst) |=> (dmem_wen == 2'b11);
    endproperty
    assert property(af_p813);

    property af_p814;
    @(posedge mclk) (dmem_cen) |-> (dmem_wen == 2'b11);
    endproperty
    assert property(af_p814);

    property af_p815;
    @(posedge mclk) $rose(puc_rst) |=> (dmem_wen == 2'b11)[*3];
    endproperty
    assert property(af_p815);

    property af_p816;
    @(posedge mclk) (dmem_wen[1] == 1'b0) |-> !$isunknown(dmem_din);
    endproperty
    assert property(af_p816);

    property af_p817;
    @(posedge mclk) (!dmem_wen[0]) |=> (dmem_din[7:0] == $past(dmem_din[7:0])) && ($past(dmem_addr) == dmem_addr);
    endproperty
    assert property(af_p817);

    property af_p818;
    @(posedge mclk) (dmem_wen >= 2'b00 && dmem_wen <= 2'b11);
    endproperty
    assert property(af_p818);

    property af_p819;
    @(posedge mclk) (1'b1) |-> (dmem_wen >= 2'b00 && dmem_wen <= 2'b11);
    endproperty
    assert property(af_p819);

    property af_p820;
    @(posedge mclk) (($past(dmem_wen) == 2'b11) && (dmem_wen != 2'b11)) |-> (!$isunknown(dmem_dout));
    endproperty
    assert property(af_p820);

    property af_p821;
    @(posedge mclk) ((dmem_wen[0] == 1'b0) && (dmem_wen[1] == 1'b0)) |-> (dmem_wen == 2'b00);
    endproperty
    assert property(af_p821);

    property af_p822;
    @(posedge mclk) (!dmem_cen) |-> (dmem_wen >= 2'b00 && dmem_wen <= 2'b11);
    endproperty
    assert property(af_p822);

    property af_p823;
    @(posedge mclk) ($stable(dmem_addr)) |-> (dmem_wen >= 2'b00 && dmem_wen <= 2'b11);
    endproperty
    assert property(af_p823);

    property af_p824;
    @(posedge mclk) ($stable(dmem_cen)) |-> $stable(dmem_wen);
    endproperty
    assert property(af_p824);

    property af_p825;
    @(posedge mclk) ((dmem_wen >= 2'b10) && (dmem_wen <= 2'b11)) |-> (!dmem_cen -> $changed(dmem_dout)) && (dmem_cen -> $stable(dmem_dout));
    endproperty
    assert property(af_p825);





























    property af_p854;
    @(posedge mclk) disable iff (!reset_n) (1) |-> ((irq >= 0) && (irq <= 16383));
    endproperty
    assert property(af_p854);

    property af_p855;
    @(posedge mclk) ((irq >= 4096) && (irq <= 8191)) |=> ((irq >= 2048) && (irq <= 8191));
    endproperty
    assert property(af_p855);

    property af_p856;
    @(posedge mclk) ((irq >= 0 && irq <= 127) ##1 (irq >= 128 && irq <= 255)) |=> irq_acc;
    endproperty
    assert property(af_p856);

    property af_p857;
    @(posedge mclk) ((irq >= 0) && (irq <= 16383)) |=> ((irq >= 0) && (irq <= 16383));
    endproperty
    assert property(af_p857);

    property af_p858;
    @(posedge mclk) $fell(puc_rst) |-> ##3 ((irq >= 0) && (irq <= 16383));
    endproperty
    assert property(af_p858);

    property af_p859;
    @(posedge mclk) disable iff (puc_rst) (!puc_rst) |-> ($stable(irq) && (irq >= 0) && (irq <= 16383));
    endproperty
    assert property(af_p859);

    property af_p860;
    @(posedge mclk) irq_acc |=> $stable(irq);
    endproperty
    assert property(af_p860);

    property af_p861;
    @(posedge mclk) ((irq >= 8192) && (irq <= 16383)) |-> ##[1:2] irq_acc;
    endproperty
    assert property(af_p861);

    property af_p862;
    @(posedge mclk) (!puc_rst) |-> (irq >= 0) && (irq <= 16383);
    endproperty
    assert property(af_p862);

    property af_p863;
    @(posedge mclk) (!cpu_en) |-> $stable(irq);
    endproperty
    assert property(af_p863);

    property af_p864;
    @(posedge mclk) (irq == 14'h0001 && nmi == 1'b0) |=> (irq_acc == 4'd0);
    endproperty
    assert property(af_p864);

    property af_p865;
    @(posedge mclk) (irq >= 12288 && irq <= 16383) |-> ##[1:2] (irq_acc);
    endproperty
    assert property(af_p865);

    property af_p866;
    @(posedge mclk) ($past(reset_n,4)) |-> (irq >= 0) && (irq <= 16383);
    endproperty
    assert property(af_p866);

    property af_p867;
    @(posedge mclk) (reset_n) |-> (irq >= 0) && (irq <= 16383);
    endproperty
    assert property(af_p867);

    property af_p868;
    @(posedge mclk) (irq >= 8192 && irq <= 16383) |=> (irq >= 4096 && irq <= 16383);
    endproperty
    assert property(af_p868);

    property af_p869;
    @(posedge mclk) (!cpu_en) |-> (irq == $past(irq));
    endproperty
    assert property(af_p869);

    property af_p870;
    @(posedge mclk) (!$past(puc_rst,3)) |-> (irq >= 1024) && (irq <= 2047);
    endproperty
    assert property(af_p870);

    property af_p871;
    @(posedge mclk) (puc_rst) |-> $stable(irq);
    endproperty
    assert property(af_p871);

    property af_p872;
    @(posedge mclk) ($rose(|irq) && !nmi) |=> irq_acc;
    endproperty
    assert property(af_p872);


    property af_p874;
    @(posedge mclk) (!puc_rst) |-> ((irq >= 0) && (irq <= 16383));
    endproperty
    assert property(af_p874);

    property af_p875;
    @(posedge mclk) puc_rst |=> (irq == 16'd0);
    endproperty
    assert property(af_p875);

    property af_p876;
    @(posedge mclk) (($past(irq) >= 0) && ($past(irq) <= 8191) && (irq >= 8192) && (irq <= 16383)) |-> ((irq >= 8192) && (irq <= 16383));
    endproperty
    assert property(af_p876);

    property af_p877;
    @(posedge mclk) (nmi && (irq != 0)) |=> nmi;
    endproperty
    assert property(af_p877);

    property af_p878;
    @(posedge mclk) $fell(reset_n) |-> ##4 ((irq >= 0) && (irq <= 16383));
    endproperty
    assert property(af_p878);

    property af_p879;
    @(posedge mclk) ((irq >= 0) && (irq <= 8191)) |=> ((irq >= 0) && (irq <= 16383));
    endproperty
    assert property(af_p879);

    property af_p880;
    @(posedge mclk) ((irq >= 0) && (irq <= 16383)) |-> ##1 (irq_acc == irq);
    endproperty
    assert property(af_p880);

    property af_p881;
    @(posedge mclk) $onehot0(irq_acc);
    endproperty
    assert property(af_p881);

    property af_p882;
    @(posedge mclk) (irq == '0) |=> (irq_acc == '0);
    endproperty
    assert property(af_p882);

    property af_p883;
    @(posedge mclk) disable iff (!reset_n) $rose(reset_n) |=> (irq_acc == '0);
    endproperty
    assert property(af_p883);

    property af_p884;
    @(posedge mclk) (irq_acc != '0) |-> ((irq_acc & irq) != '0);
    endproperty
    assert property(af_p884);

    property af_p885;
    @(posedge mclk) always $onehot0(irq_acc);
    endproperty
    assert property(af_p885);

    property af_p886;
    @(posedge mclk) (puc_rst) |=> (irq_acc == '0);
    endproperty
    assert property(af_p886);

    property af_p887;
    @(posedge mclk) (puc_rst) |-> (irq_acc == '0);
    endproperty
    assert property(af_p887);

    property af_p888;
    @(posedge mclk) (dbg_freeze) |-> (irq_acc == '0);
    endproperty
    assert property(af_p888);

    property af_p889;
    @(posedge mclk) ($countones(irq) > 1) |-> $onehot0(irq_acc);
    endproperty
    assert property(af_p889);


    property af_p891;
    @(posedge mclk) $fell(puc_rst) |-> (irq_acc == '0);
    endproperty
    assert property(af_p891);

    property af_p892;
    @(posedge mclk) (irq_acc != '0) |-> $onehot(irq_acc);
    endproperty
    assert property(af_p892);

    property af_p893;
    @(posedge mclk) (nmi) |-> ((irq_acc & ~irq) == '0);
    endproperty
    assert property(af_p893);

    property af_p894;
    @(posedge mclk) (!cpu_en) |-> (irq_acc == $past(irq_acc));
    endproperty
    assert property(af_p894);

    property af_p895;
    @(posedge mclk) (irq_acc != '0) |-> ##1 (irq_acc == '0);
    endproperty
    assert property(af_p895);

    property af_p896;
    @(posedge mclk) (irq != '0) |-> ##[1:$] ((irq_acc & irq) != '0);
    endproperty
    assert property(af_p896);

    property af_p897;
    @(posedge mclk) (puc_rst) |-> (irq_acc == $past(irq_acc));
    endproperty
    assert property(af_p897);

    property af_p898;
    @(posedge mclk) (irq != '0) |-> ##[1:4] ((irq_acc & irq) != '0);
    endproperty
    assert property(af_p898);

    property af_p899;
    @(posedge mclk) $rose(irq[8]) |-> ##1 (irq_acc[8] ##1 !irq_acc[8]);
    endproperty
    assert property(af_p899);

    property af_p900;
    @(posedge mclk) ($countones(irq) > 1) |-> ##1 ($countones(irq_acc) <= 1);
    endproperty
    assert property(af_p900);

    property af_p901;
    @(posedge mclk) (irq_acc != '0) |-> (((irq | $past(irq)) & irq_acc) == irq_acc);
    endproperty
    assert property(af_p901);

    property af_p902;
    @(posedge mclk) $rose(puc_rst) |=> (irq_acc == '0);
    endproperty
    assert property(af_p902);

    property af_p903;
    @(posedge mclk) (irq_acc != '0) |=> (irq_acc == '0);
    endproperty
    assert property(af_p903);

    property af_p904;
    @(posedge mclk) $fell(reset_n) |=> (irq_acc == '0);
    endproperty
    assert property(af_p904);

    property af_p905;
    @(posedge mclk) (irq inside {[1:1048575]}) |-> ##[1:4] ((irq_acc != '0) && ($countones(irq_acc) == 1) && (irq_acc <= irq));
    endproperty
    assert property(af_p905);

    property af_p906;
    @(posedge mclk) (irq_acc != '0) |-> ((irq_acc & irq) == irq_acc);
    endproperty
    assert property(af_p906);

    property af_p907;
    @(posedge mclk) !cpu_en |=> $stable(irq_acc);
    endproperty
    assert property(af_p907);

    property af_p908;
    @(posedge mclk) (irq == '0) |-> (irq_acc == '0);
    endproperty
    assert property(af_p908);

    property af_p909;
    @(posedge mclk) irq[10] |-> irq_acc[10];
    endproperty
    assert property(af_p909);

    property af_p910;
    @(posedge mclk) ((irq_acc != '0) && (irq == '0)) |=> (irq_acc == '0);
    endproperty
    assert property(af_p910);

    property af_p911;
    @(posedge mclk) (irq_acc != '0) |-> ##[1:4] (irq_acc == '0);
    endproperty
    assert property(af_p911);

    property af_p912;
    @(posedge mclk) dbg_freeze |=> $stable(irq_acc);
    endproperty
    assert property(af_p912);

    property af_p913;
    @(posedge lfxt_clk) (1'b1) |-> (mclk === $past(lfxt_clk));
    endproperty
    assert property(af_p913);

    property af_p914;
    @(posedge dco_clk) (lfxt_enable && puc_rst) |-> (lfxt_clk !== $past(lfxt_clk));
    endproperty
    assert property(af_p914);

    property af_p915;
    @(posedge dco_clk) (!lfxt_enable) |-> $stable(lfxt_clk);
    endproperty
    assert property(af_p915);

    property af_p916;
    @(posedge dco_clk) $fell(reset_n) |-> ##[1:2] $stable(lfxt_clk);
    endproperty
    assert property(af_p916);

    property af_p917;
    @(posedge dco_clk) $fell(lfxt_enable) |-> ##[1:3] $stable(lfxt_clk);
    endproperty
    assert property(af_p917);

    property af_p918;
    @(posedge dco_clk) $rose(lfxt_clk) |-> ##[1:2] lfxt_wkup;
    endproperty
    assert property(af_p918);

    property af_p919;
    @(posedge dco_clk) (lfxt_enable) |-> (lfxt_clk !== $past(lfxt_clk));
    endproperty
    assert property(af_p919);

    property af_p920;
    @(posedge dco_clk) (scan_mode && scan_enable) |-> (lfxt_clk !== $past(lfxt_clk));
    endproperty
    assert property(af_p920);

    property af_p921;
    @(posedge dco_clk) $fell(lfxt_enable) |-> ##[1:5] (lfxt_clk == 1'b0);
    endproperty
    assert property(af_p921);

    property af_p922;
    @(posedge dco_clk) $rose(wkup) |-> ##[1:4] (lfxt_clk !== $past(lfxt_clk));
    endproperty
    assert property(af_p922);

    property af_p923;
    @(posedge dco_clk) (!reset_n) |-> (lfxt_clk == 1'b0);
    endproperty
    assert property(af_p923);

    property af_p924;
    @(posedge lfxt_clk) (1'b1) |-> (mclk === lfxt_clk);
    endproperty
    assert property(af_p924);

    property af_p925;
    @(posedge dco_clk) ($rose(reset_n) && lfxt_enable) |-> ##[1:3] (lfxt_clk !== $past(lfxt_clk));
    endproperty
    assert property(af_p925);

    property af_p926;
    @(posedge dco_clk) scan_mode |-> $stable(lfxt_clk);
    endproperty
    assert property(af_p926);

    property af_p927;
    @(posedge lfxt_clk) 1 |-> (smclk === lfxt_clk);
    endproperty
    assert property(af_p927);

    property af_p928;
    @(posedge dco_clk) puc_rst |-> $stable(lfxt_clk);
    endproperty
    assert property(af_p928);

    property af_p929;
    @(posedge lfxt_clk) (lfxt_enable) |-> (($time - $past($time)) == ($past($time) - $past($time,2)));
    endproperty
    assert property(af_p929);

    property af_p930;
    @(posedge dco_clk) ($rose(reset_n) && lfxt_enable) |-> ##[1:3] $changed(lfxt_clk);
    endproperty
    assert property(af_p930);

    property af_p931;
    @(posedge dco_clk) $rose(lfxt_clk) |-> $past(lfxt_wkup);
    endproperty
    assert property(af_p931);

    property af_p932;
    @(posedge lfxt_clk) (1) |-> (smclk === lfxt_clk);
    endproperty
    assert property(af_p932);

    property af_p933;
    @(posedge dco_clk) (!lfxt_enable) |=> $stable(lfxt_clk);
    endproperty
    assert property(af_p933);

    property af_p934;
    @(posedge dco_clk) $rose(lfxt_wkup) |-> ##[1:5] $rose(lfxt_clk);
    endproperty
    assert property(af_p934);

    property af_p935;
    @(posedge dco_clk) (!reset_n) |-> (lfxt_clk === 1'b0);
    endproperty
    assert property(af_p935);

    property af_p936;
    @(posedge dco_clk) dbg_freeze |=> $changed(lfxt_clk);
    endproperty
    assert property(af_p936);

    property af_p937;
    @(posedge dco_clk) 1 |=> $changed(dco_clk);
    endproperty
    assert property(af_p937);

    property af_p938;
    @(posedge lfxt_clk) cpu_en |-> (mclk === lfxt_clk);
    endproperty
    assert property(af_p938);

    property af_p939;
    @(posedge lfxt_clk) (lfxt_enable) |-> ##[1:2] $changed(lfxt_clk) and (!lfxt_enable) |-> $stable(lfxt_clk);
    endproperty
    assert property(af_p939);

    property af_p940;
    @(posedge lfxt_clk) ($fell(reset_n)) |-> (!lfxt_enable) [*5] |-> $stable(lfxt_clk);
    endproperty
    assert property(af_p940);

    property af_p941;
    @(posedge lfxt_clk) ($fell(reset_n) ##1 lfxt_enable) |-> ##[1:4] $changed(lfxt_clk);
    endproperty
    assert property(af_p941);

    property af_p942;
    @(posedge lfxt_clk) (lfxt_enable) |-> ($past(lfxt_clk,2) != $past(lfxt_clk,1)) && ($past(lfxt_clk,1) != lfxt_clk);
    endproperty
    assert property(af_p942);

    property af_p943;
    @(posedge lfxt_clk) (puc_rst) |-> $changed(lfxt_clk);
    endproperty
    assert property(af_p943);

    property af_p944;
    @(posedge lfxt_clk) (dco_enable && lfxt_enable) |-> ($changed(lfxt_clk) && $changed(dco_clk));
    endproperty
    assert property(af_p944);

    property af_p945;
    @(posedge lfxt_clk) (lfxt_enable) |-> (aclk == lfxt_clk) throughout (##[1:$] lfxt_clk);
    endproperty
    assert property(af_p945);


    property af_p947;
    @(posedge lfxt_clk) (aclk_en) |-> (aclk == lfxt_clk);
    endproperty
    assert property(af_p947);


    property af_p949;
    @(posedge lfxt_enable) disable iff (!lfxt_enable) ($rose(lfxt_enable)) |-> not ($stable(lfxt_clk) throughout (##0 lfxt_clk[->1]));
    endproperty
    assert property(af_p949);

    property af_p950;
    @(posedge lfxt_clk) ($rose(lfxt_wkup) && !lfxt_clk) |-> ##[1:3] $changed(lfxt_clk);
    endproperty
    assert property(af_p950);

    property af_p951;
    @(posedge mclk) lfxt_wkup |=> lfxt_enable;
    endproperty
    assert property(af_p951);

    property af_p952;
    @(posedge mclk) puc_rst |=> (!lfxt_enable);
    endproperty
    assert property(af_p952);

    property af_p953;
    @(posedge mclk) aclk_en |-> lfxt_enable;
    endproperty
    assert property(af_p953);

    property af_p954;
    @(posedge mclk) $fell(reset_n) |=> (!lfxt_enable) until ($rose(reset_n));
    endproperty
    assert property(af_p954);

    property af_p955;
    @(posedge mclk) (1) |-> (!$isunknown(lfxt_enable) && !$isunknown(dco_enable));
    endproperty
    assert property(af_p955);

    property af_p956;
    @(posedge mclk) puc_rst |-> (!lfxt_enable[*3]);
    endproperty
    assert property(af_p956);

    property af_p957;
    @(posedge mclk) $changed(lfxt_wkup) |-> $stable(lfxt_enable);
    endproperty
    assert property(af_p957);

    property af_p958;
    @(posedge mclk) (scan_mode && scan_enable) |-> $stable(lfxt_enable);
    endproperty
    assert property(af_p958);

    property af_p959;
    @(posedge mclk) puc_rst |-> (!lfxt_enable);
    endproperty
    assert property(af_p959);

    property af_p960;
    @(posedge mclk) (!reset_n) |-> ##1 (!lfxt_enable);
    endproperty
    assert property(af_p960);

    property af_p961;
    @(posedge mclk) puc_rst |-> (!lfxt_enable ##1 !lfxt_enable);
    endproperty
    assert property(af_p961);

    property af_p962;
    @(posedge mclk) scan_mode |-> $stable(lfxt_enable);
    endproperty
    assert property(af_p962);

    property af_p963;
    @(posedge mclk) lfxt_wkup[*1] |=> lfxt_enable;
    endproperty
    assert property(af_p963);

    property af_p964;
    @(posedge mclk) (lfxt_enable && lfxt_clk) |-> lfxt_enable[*5];
    endproperty
    assert property(af_p964);

    property af_p965;
    @(posedge mclk) $rose(reset_n) |-> ##[1:2] !lfxt_enable;
    endproperty
    assert property(af_p965);

    property af_p966;
    @(posedge mclk) $fell(reset_n) |-> ##3 $stable(lfxt_enable);
    endproperty
    assert property(af_p966);

    property af_p967;
    @(posedge mclk) puc_rst |-> (!lfxt_enable until reset_n);
    endproperty
    assert property(af_p967);

    property af_p968;
    @(posedge mclk) puc_rst |-> !lfxt_enable;
    endproperty
    assert property(af_p968);

    property af_p969;
    @(posedge mclk) lfxt_wkup |-> ##[1:3] lfxt_enable;
    endproperty
    assert property(af_p969);

    property af_p970;
    @(posedge aclk) 1'b1 |-> lfxt_enable;
    endproperty
    assert property(af_p970);

    property af_p971;
    @(posedge mclk) (lfxt_wkup && !puc_rst) |-> ##[1:3] lfxt_enable;
    endproperty
    assert property(af_p971);

    property af_p972;
    @(posedge mclk) $changed(lfxt_enable) |-> $past($stable(lfxt_enable));
    endproperty
    assert property(af_p972);

    property af_p973;
    @(posedge mclk) lfxt_enable |-> (lfxt_enable until (puc_rst || !cpu_en));
    endproperty
    assert property(af_p973);

    property af_p974;
    @(posedge mclk) (lfxt_wkup && !lfxt_enable) |=> lfxt_enable;
    endproperty
    assert property(af_p974);

    property af_p975;
    @(posedge mclk) (lfxt_enable && $fell(lfxt_wkup)) |=> lfxt_enable;
    endproperty
    assert property(af_p975);

    property af_p976;
    @(posedge mclk) scan_enable |-> $stable(lfxt_enable);
    endproperty
    assert property(af_p976);

    property af_p977;
    @(posedge mclk) scan_mode |-> $stable(lfxt_enable)[*5];
    endproperty
    assert property(af_p977);

    property af_p978;
    @(posedge mclk) $rose(lfxt_clk) |-> lfxt_enable[*4];
    endproperty
    assert property(af_p978);

    property af_p979;
    @(posedge mclk) $rose(lfxt_wkup) |-> ##[1:3] lfxt_enable;
    endproperty
    assert property(af_p979);

    property af_p980;
    @(posedge mclk) dbg_freeze |-> $stable(lfxt_enable);
    endproperty
    assert property(af_p980);

    property af_p981;
    @(posedge mclk) $fell(lfxt_enable) |-> cpu_en;
    endproperty
    assert property(af_p981);

    property af_p982;
    @(posedge mclk) $rose(lfxt_wkup) |-> ##1 lfxt_enable[*2];
    endproperty
    assert property(af_p982);

    property af_p983;
    @(posedge mclk) (!lfxt_wkup && !puc_rst) |-> !lfxt_enable;
    endproperty
    assert property(af_p983);

    property af_p984;
    @(posedge aclk) disable iff (puc_rst) $rose(lfxt_enable) |-> lfxt_enable[*8];
    endproperty
    assert property(af_p984);

    property af_p985;
    @(posedge mclk) $rose(wkup) |-> lfxt_enable[*4];
    endproperty
    assert property(af_p985);

    property af_p986;
    @(posedge mclk) lfxt_clk |-> lfxt_enable;
    endproperty
    assert property(af_p986);

    property af_p987;
    @(posedge mclk) $fell(puc_rst) |-> ##[1:2] $stable(lfxt_wkup);
    endproperty
    assert property(af_p987);

    property af_p988;
    @(posedge mclk) $changed(smclk_en) || $changed(aclk_en) |-> $stable(lfxt_wkup);
    endproperty
    assert property(af_p988);

    property af_p989;
    @(posedge reset_n) (!reset_n) |-> $stable(lfxt_wkup);
    endproperty
    assert property(af_p989);

    property af_p990;
    @(posedge mclk) $fell(reset_n) |-> ##[1:2] $stable(lfxt_wkup);
    endproperty
    assert property(af_p990);

    property af_p991;
    @(posedge mclk) (!wkup) |-> $stable(lfxt_wkup);
    endproperty
    assert property(af_p991);

    property af_p992;
    @(posedge mclk) $rose(lfxt_wkup) |-> ##[1:4] $fell(lfxt_wkup);
    endproperty
    assert property(af_p992);

    property af_p993;
    @(posedge mclk) (wkup) |-> (lfxt_wkup or ##1 lfxt_wkup);
    endproperty
    assert property(af_p993);

    property af_p994;
    @(posedge mclk) $rose(lfxt_wkup) |-> lfxt_wkup[*1];
    endproperty
    assert property(af_p994);

    property af_p995;
    @(posedge mclk) (lfxt_wkup) |-> (dbg_en == 1'b0);
    endproperty
    assert property(af_p995);

    property af_p996;
    @(posedge mclk) $rose(reset_n) |-> !$isunknown(lfxt_wkup);
    endproperty
    assert property(af_p996);

    property af_p997;
    @(posedge mclk) (!reset_n) |-> (lfxt_wkup == 1'b0);
    endproperty
    assert property(af_p997);

    property af_p998;
    @(posedge mclk) (wkup) |-> !$isunknown(lfxt_wkup);
    endproperty
    assert property(af_p998);

    property af_p999;
    @(posedge lfxt_wkup) (dco_wkup === 1'b0 || dco_wkup === 1'b1) |-> (lfxt_wkup == 1'b1);
    endproperty
    assert property(af_p999);

    property af_p1000;
    @(posedge mclk) $rose(cpu_en) |-> $past(lfxt_wkup);
    endproperty
    assert property(af_p1000);

    property af_p1001;
    @(posedge mclk) (irq) |-> $past(lfxt_wkup);
    endproperty
    assert property(af_p1001);

    property af_p1002;
    @(posedge mclk) (!lfxt_enable) |-> (lfxt_wkup == 1'b1);
    endproperty
    assert property(af_p1002);

    property af_p1003;
    @(posedge mclk) (reset_n && !puc_rst) |-> !$isunknown(lfxt_wkup);
    endproperty
    assert property(af_p1003);

    property af_p1004;
    @(posedge mclk) (wkup) |-> (lfxt_wkup == 1'b1);
    endproperty
    assert property(af_p1004);

    property af_p1005;
    @(posedge mclk) $rose(cpu_en) |-> lfxt_wkup;
    endproperty
    assert property(af_p1005);

    property af_p1006;
    @(posedge mclk) lfxt_enable |=> !lfxt_wkup;
    endproperty
    assert property(af_p1006);

    property af_p1007;
    @(posedge mclk) puc_rst |=> !lfxt_wkup;
    endproperty
    assert property(af_p1007);

    property af_p1008;
    @(posedge mclk) $fell(wkup) |-> ##[1:5] !lfxt_wkup;
    endproperty
    assert property(af_p1008);

    property af_p1009;
    @(posedge mclk) !lfxt_enable |-> ##[1:$] (lfxt_wkup ##[1:$] lfxt_enable);
    endproperty
    assert property(af_p1009);

    property af_p1010;
    @(posedge mclk) $stable(lfxt_clk) |-> !lfxt_wkup;
    endproperty
    assert property(af_p1010);

    property af_p1011;
    @(posedge mclk) !reset_n |-> !lfxt_wkup;
    endproperty
    assert property(af_p1011);






    property af_p1017;
    @(posedge dco_clk) (dco_enable && !lfxt_enable) |-> (mclk === dco_clk);
    endproperty
    assert property(af_p1017);






    property af_p1023;
    @(posedge mclk) $rose(reset_n) |-> ##[1:3] $changed(mclk);
    endproperty
    assert property(af_p1023);

    property af_p1024;
    @(posedge aclk_en) 1'b1 |-> ##[1:2] $changed(mclk);
    endproperty
    assert property(af_p1024);

    property af_p1025;
    @(posedge dco_clk) $fell(puc_rst) |-> ##1 (mclk === dco_clk);
    endproperty
    assert property(af_p1025);

    property af_p1026;
    @(posedge mclk) $rose(dbg_freeze) |-> ##1 ($changed(mclk))[*4];
    endproperty
    assert property(af_p1026);

    property af_p1027;
    @(posedge dco_clk) (puc_rst |-> $stable(mclk)) and ($fell(puc_rst) |-> ##1 $changed(mclk));
    endproperty
    assert property(af_p1027);

    property af_p1028;
    @(posedge mclk) (scan_mode) |-> ##1 $changed(mclk);
    endproperty
    assert property(af_p1028);

    property af_p1029;
    @(posedge mclk) (!cpu_en && !puc_rst) |-> ##1 $changed(mclk);
    endproperty
    assert property(af_p1029);

    property af_p1030;
    @(posedge mclk) $rose(nmi) |-> ##1 $changed(mclk);
    endproperty
    assert property(af_p1030);

    property af_p1031;
    @(posedge smclk_en) 1'b1 |-> ##[1:2] $changed(mclk);
    endproperty
    assert property(af_p1031);

    property af_p1032;
    @(posedge dco_clk) $fell(puc_rst) |-> ##[1:2] $changed(mclk);
    endproperty
    assert property(af_p1032);

    property af_p1033;
    @(posedge lfxt_clk) (lfxt_enable) |-> (mclk === lfxt_clk);
    endproperty
    assert property(af_p1033);

    property af_p1034;
    @(posedge dco_clk) puc_rst |-> (mclk === 1'b0);
    endproperty
    assert property(af_p1034);

    property af_p1035;
    @(posedge dco_clk) 1'b1 |-> ##[1:8] $changed(mclk);
    endproperty
    assert property(af_p1035);

    property af_p1036;
    @(posedge dco_clk) !puc_rst |-> (mclk != $past(mclk));
    endproperty
    assert property(af_p1036);

    property af_p1037;
    @(posedge dco_clk) $rose(wkup) |=> (mclk != $past(mclk))[*4];
    endproperty
    assert property(af_p1037);

    property af_p1038;
    @(posedge dco_clk) (mclk !== $past(mclk));
    endproperty
    assert property(af_p1038);

    property af_p1039;
    @(posedge dco_clk) dma_en |-> (mclk != $past(mclk));
    endproperty
    assert property(af_p1039);

    property af_p1040;
    @(posedge dco_clk) dbg_en |-> (mclk != $past(mclk));
    endproperty
    assert property(af_p1040);

    property af_p1041;
    @(posedge dco_clk) 1'b1 |-> ##[1:10] $changed(mclk);
    endproperty
    assert property(af_p1041);

    property af_p1042;
    @(posedge dco_clk) smclk_en |-> (mclk != $past(mclk));
    endproperty
    assert property(af_p1042);

    property af_p1043;
    @(posedge dco_clk) puc_rst |-> $stable(mclk);
    endproperty
    assert property(af_p1043);

    property af_p1044;
    @(posedge dco_clk) !dbg_freeze |-> (mclk != $past(mclk));
    endproperty
    assert property(af_p1044);

    property af_p1045;
    @(posedge mclk) $rose(nmi) |-> ##[0:1] wkup;
    endproperty
    assert property(af_p1045);

    property af_p1046;
    @(posedge mclk) (!reset_n) |-> (nmi === 1'b0 || nmi === 1'b1);
    endproperty
    assert property(af_p1046);

    property af_p1047;
    @(posedge mclk) (!reset_n && nmi) |-> puc_rst;
    endproperty
    assert property(af_p1047);

    property af_p1048;
    @(posedge mclk) $rose(reset_n) |-> ##[1:3] (nmi === 1'b0 || nmi === 1'b1);
    endproperty
    assert property(af_p1048);

    property af_p1049;
    @(posedge mclk) $rose(nmi) |=> irq_acc;
    endproperty
    assert property(af_p1049);

    property af_p1050;
    @(posedge mclk) $rose(reset_n) |-> !nmi ##1 !nmi;
    endproperty
    assert property(af_p1050);

    property af_p1051;
    @(posedge mclk) (!cpu_en && nmi) |-> ##[0:1] wkup;
    endproperty
    assert property(af_p1051);

    property af_p1052;
    @(posedge mclk) $rose(nmi) |=> puc_rst;
    endproperty
    assert property(af_p1052);

    property af_p1053;
    @(posedge mclk) disable iff (!reset_n) 1'b1 |-> $stable(nmi);
    endproperty
    assert property(af_p1053);

    property af_p1054;
    @(posedge mclk) (scan_mode && scan_enable) |-> (nmi === 1'b0);
    endproperty
    assert property(af_p1054);

    property af_p1055;
    @(posedge mclk) (nmi && dma_en) |-> $stable(dma_en) && $stable(dma_we);
    endproperty
    assert property(af_p1055);

    property af_p1056;
    @(posedge mclk) (!cpu_en) |-> $stable(nmi);
    endproperty
    assert property(af_p1056);

    property af_p1057;
    @(posedge mclk) (dbg_freeze && nmi) |-> !$changed(puc_rst) until (!dbg_freeze);
    endproperty
    assert property(af_p1057);

    property af_p1058;
    @(posedge mclk) $rose(reset_n) |-> nmi ##1 (nmi === $past(nmi,1)) ##1 (nmi === $past(nmi,2));
    endproperty
    assert property(af_p1058);

    property af_p1059;
    @(posedge mclk) $rose(nmi) |-> ##1 1'b1;
    endproperty
    assert property(af_p1059);

    property af_p1060;
    @(posedge mclk) nmi |-> !puc_rst;
    endproperty
    assert property(af_p1060);

    property af_p1061;
    @(posedge mclk) (nmi && cpu_en) |-> ##1 $stable(dmem_dout);
    endproperty
    assert property(af_p1061);

    property af_p1062;
    @(posedge mclk) $rose(nmi) |-> ##[0:2] wkup;
    endproperty
    assert property(af_p1062);

    property af_p1063;
    @(posedge mclk) $rose(puc_rst) |-> !nmi;
    endproperty
    assert property(af_p1063);

    property af_p1064;
    @(posedge mclk) $rose(reset_n) |-> ##2 (nmi === 1'b0 || nmi === 1'b1);
    endproperty
    assert property(af_p1064);

    property af_p1065;
    @(posedge mclk) (1'b1) |-> (nmi === 1'b0 || nmi === 1'b1);
    endproperty
    assert property(af_p1065);

    property af_p1066;
    @(posedge mclk) (nmi && dbg_freeze) |-> $stable(per_dout);
    endproperty
    assert property(af_p1066);

    property af_p1067;
    @(posedge mclk) (!reset_n) |-> $stable(nmi);
    endproperty
    assert property(af_p1067);

    property af_p1068;
    @(posedge mclk) (dbg_freeze) |-> (nmi == $past(nmi));
    endproperty
    assert property(af_p1068);

    property af_p1069;
    @(posedge mclk) ($rose(puc_rst)) |-> ##1 (nmi == 1'b0);
    endproperty
    assert property(af_p1069);

    property af_p1070;
    @(posedge mclk) (nmi) |-> ##1 (nmi == 1);
    endproperty
    assert property(af_p1070);

    property af_p1071;
    @(posedge mclk) (nmi && irq) |-> (nmi == 1'b1) and (puc_rst == $past(puc_rst) || puc_rst inside {1'b0,1'b1});
    endproperty
    assert property(af_p1071);

    property af_p1072;
    @(posedge mclk) (nmi) |-> (irq == 5'h0E);
    endproperty
    assert property(af_p1072);


    property af_p1074;
    @(posedge mclk) (nmi == 1'b1) |-> (irq == irq);
    endproperty
    assert property(af_p1074);

    property af_p1075;
    @(posedge mclk) ($rose(nmi)) |-> (nmi == 1'b1) ##1 (nmi == 1'b1);
    endproperty
    assert property(af_p1075);

    property af_p1076;
    @(posedge mclk) (nmi == 1) |-> (nmi != irq_acc || nmi == 1);
    endproperty
    assert property(af_p1076);


    property af_p1078;
    @(posedge mclk) (scan_enable) |-> (nmi == 1'b0);
    endproperty
    assert property(af_p1078);

    property af_p1079;
    @(posedge mclk) ($rose(nmi)) |-> ##1 (nmi == 1'b1);
    endproperty
    assert property(af_p1079);

    property af_p1080;
    @(posedge mclk) $rose(!puc_rst) |-> ##3 ((per_en >= 0) && (per_en <= 1));
    endproperty
    assert property(af_p1080);





    property af_p1085;
    @(posedge mclk) ((pmem_addr >= 0) && (pmem_addr <= 65535)) |=> ((pmem_addr >= 0) && (pmem_addr <= 65535));
    endproperty
    assert property(af_p1085);









    property af_p1094;
    @(posedge mclk) $rose(reset_n) |-> ##3 ((dmem_din >= 0) && (dmem_din <= 65535));
    endproperty
    assert property(af_p1094);




    property af_p1098;
    @(posedge mclk) $rose(reset_n) |-> ##4 ((dmem_cen >= 0) && (dmem_cen <= 1));
    endproperty
    assert property(af_p1098);







    property af_p1105;
    @(posedge mclk) ((pmem_wen >= 0) && (pmem_wen <= 3)) |-> (pmem_wen >= 0) && (pmem_wen <= 3);
    endproperty
    assert property(af_p1105);

    property af_p1106;
    @(posedge mclk) (!puc_rst) |-> (per_addr >= 0) && (per_addr <= 16383);
    endproperty
    assert property(af_p1106);





    property af_p1111;
    @(posedge mclk) ($fell(per_en)) |-> (!$isunknown(per_addr) && (per_addr <= 16383));
    endproperty
    assert property(af_p1111);


    property af_p1113;
    @(posedge mclk) (per_en) |-> (per_addr >= 0 && per_addr <= 16383);
    endproperty
    assert property(af_p1113);

    property af_p1114;
    @(posedge mclk) (!per_en) |-> $stable(per_dout);
    endproperty
    assert property(af_p1114);

    property af_p1115;
    @(posedge mclk) (per_en) |-> (per_addr <= 16383);
    endproperty
    assert property(af_p1115);

    property af_p1116;
    @(posedge mclk) (puc_rst) |-> (per_addr == 14'b0);
    endproperty
    assert property(af_p1116);

    property af_p1117;
    @(posedge mclk) (per_en) |-> $stable(per_addr);
    endproperty
    assert property(af_p1117);

    property af_p1118;
    @(posedge mclk) $fell(puc_rst) |-> ##[1:2] (!$isunknown(per_addr));
    endproperty
    assert property(af_p1118);

    property af_p1119;
    @(posedge mclk) $fell(puc_rst) |-> ##[1:2] (per_addr inside {[0:16383]}) [*1:$];
    endproperty
    assert property(af_p1119);

    property af_p1120;
    @(posedge mclk) $fell(puc_rst) |-> ##[1:4] (per_addr inside {[0:16383]});
    endproperty
    assert property(af_p1120);

    property af_p1121;
    @(posedge mclk) $rose(reset_n) |-> (per_addr inside {[0:16383]});
    endproperty
    assert property(af_p1121);

    property af_p1122;
    @(posedge mclk) (!per_en) |-> ##1 (1'b1);
    endproperty
    assert property(af_p1122);

    property af_p1123;
    @(posedge mclk) (per_en && per_we) |=> (per_addr == $past(per_addr));
    endproperty
    assert property(af_p1123);

    property af_p1124;
    @(posedge mclk) (per_addr <= 8191) && (per_en) |=> !$isunknown(per_dout);
    endproperty
    assert property(af_p1124);

    property af_p1125;
    @(posedge mclk) (per_en) |-> ((per_addr inside {[0:16383]}) ##1 (per_addr inside {[0:16383]}) ##1 (per_addr inside {[0:16383]}));
    endproperty
    assert property(af_p1125);

    property af_p1126;
    @(posedge mclk) (per_en && per_we) |-> $stable(per_addr);
    endproperty
    assert property(af_p1126);

    property af_p1127;
    @(posedge mclk) (per_en) |=> ($stable(per_addr) || $changed(per_addr));
    endproperty
    assert property(af_p1127);

    property af_p1128;
    @(posedge aclk) ($changed(per_addr)) |-> $rose(mclk);
    endproperty
    assert property(af_p1128);

    property af_p1129;
    @(posedge mclk) (per_en && !per_we) |-> !$isunknown(per_dout);
    endproperty
    assert property(af_p1129);

    property af_p1130;
    @(posedge mclk) (per_en && per_we && (per_addr >= 100) && (per_addr <= 200)) |=> (per_dout == $past(per_din));
    endproperty
    assert property(af_p1130);

    property af_p1131;
    @(posedge mclk) (per_en) |-> $stable(per_addr) throughout (per_en[*1:$]);
    endproperty
    assert property(af_p1131);

    property af_p1132;
    @(posedge mclk) (per_en && per_we) |=> $stable(per_addr);
    endproperty
    assert property(af_p1132);

    property af_p1133;
    @(posedge mclk) $rose(puc_rst) |-> ##3 ((per_din >= 0) && (per_din <= 65535));
    endproperty
    assert property(af_p1133);

    property af_p1134;
    @(posedge mclk) ((per_din >= 200) && (per_din <= 255)) |=> ((per_din >= 180) && (per_din <= 255));
    endproperty
    assert property(af_p1134);

    property af_p1135;
    @(posedge mclk) (per_we != 2'b00) |-> $stable(per_din) || 1'b1;
    endproperty
    assert property(af_p1135);

    property af_p1136;
    @(posedge mclk) (per_we[0] && per_en) |-> ((per_din[7:0] >= 0) && (per_din[7:0] <= 255));
    endproperty
    assert property(af_p1136);

    property af_p1137;
    @(posedge mclk) (!per_en) |-> (per_dout == 16'h0000);
    endproperty
    assert property(af_p1137);

    property af_p1138;
    @(posedge mclk) (puc_rst == 1'b0) |-> ((per_din >= 0) && (per_din <= 65535));
    endproperty
    assert property(af_p1138);

    property af_p1139;
    @(posedge mclk) (!per_en) |-> ((per_din >= 0) && (per_din <= 65535));
    endproperty
    assert property(af_p1139);

    property af_p1140;
    @(posedge mclk) ($stable(per_addr) && per_en) |-> ((per_din >= 0) && (per_din <= 65535));
    endproperty
    assert property(af_p1140);

    property af_p1141;
    @(posedge mclk) (!per_en && (per_we == 2'b00)) |-> $stable(per_din);
    endproperty
    assert property(af_p1141);

    property af_p1142;
    @(posedge mclk) (per_en) |-> ((per_din >= 0) && (per_din <= 65535));
    endproperty
    assert property(af_p1142);

    property af_p1143;
    @(posedge mclk) (per_en && (per_we != 2'b00) && (per_addr >= 0) && (per_addr <= 255)) |-> ((per_din >= 0) && (per_din <= 65535));
    endproperty
    assert property(af_p1143);

    property af_p1144;
    @(posedge mclk) (($past(per_we) == 2'b00) && (per_we != 2'b00)) |-> ((per_din >= 0) && (per_din <= 65535));
    endproperty
    assert property(af_p1144);

    property af_p1145;
    @(posedge mclk) ((per_din >= 0) && (per_din <= 255)) |-> per_we[0];
    endproperty
    assert property(af_p1145);

    property af_p1146;
    @(posedge mclk) (per_we[1] && per_en) |-> ((per_din[15:8] >= 0) && (per_din[15:8] <= 255));
    endproperty
    assert property(af_p1146);

    property af_p1147;
    @(posedge mclk) (!per_en) |-> $stable(per_din);
    endproperty
    assert property(af_p1147);

    property af_p1148;
    @(posedge mclk) (!puc_rst) |-> (per_din >= 0) && (per_din <= 65535);
    endproperty
    assert property(af_p1148);

    property af_p1149;
    @(posedge mclk) $fell(puc_rst) |-> ##4 ((per_din >= 0) && (per_din <= 100));
    endproperty
    assert property(af_p1149);

    property af_p1150;
    @(posedge mclk) (per_we == 2'b11) |-> ((per_din >= 0) && (per_din <= 65535));
    endproperty
    assert property(af_p1150);

    property af_p1151;
    @(posedge mclk) $fell(puc_rst) |-> (per_din == 16'h0000);
    endproperty
    assert property(af_p1151);

    property af_p1152;
    @(posedge mclk) $fell(puc_rst) |-> ##1 ((per_din >= 0) && (per_din <= 65535));
    endproperty
    assert property(af_p1152);

    property af_p1153;
    @(posedge mclk) (per_we[0]) |-> ((per_din >= 0) && (per_din <= 255));
    endproperty
    assert property(af_p1153);

    property af_p1154;
    @(posedge mclk) $fell(puc_rst) |-> ##4 ((per_din >= 0) && (per_din <= 65535));
    endproperty
    assert property(af_p1154);

    property af_p1155;
    @(posedge mclk) ((per_we == 2'b11) && per_en && (per_addr == per_addr)) |-> ##1 ((per_din >= 0) && (per_din <= 65535));
    endproperty
    assert property(af_p1155);

    property af_p1156;
    @(posedge mclk) ((per_din >= 100) && (per_din <= 150)) |=> ((per_din >= 80) && (per_din <= 150));
    endproperty
    assert property(af_p1156);

    property af_p1157;
    @(posedge mclk) (per_en && (per_we != 2'b00)) |-> ((per_din >= 0) && (per_din <= 65535));
    endproperty
    assert property(af_p1157);

    property af_p1158;
    @(posedge mclk) ((per_din >= 0) && (per_din <= 32767)) |=> ((per_dout >= 0) && (per_dout <= 65535));
    endproperty
    assert property(af_p1158);



    property af_p1161;
    @(posedge mclk) ((per_din >= 256) && (per_din <= 65535)) |-> (per_we[1] == 1'b1);
    endproperty
    assert property(af_p1161);

    property af_p1162;
    @(posedge mclk) (per_en && (per_we == $past(per_we)) && (per_we != 2'b00)) |=> ($stable(per_din));
    endproperty
    assert property(af_p1162);

    property af_p1163;
    @(posedge mclk) ((!per_en) && (per_we == 2'b00)) |=> ($stable(per_din));
    endproperty
    assert property(af_p1163);

    property af_p1164;
    @(posedge mclk) (!per_en) |=> ($stable(per_din));
    endproperty
    assert property(af_p1164);

    property af_p1165;
    @(posedge mclk) (per_en && (per_addr != 8'h00)) |=> (per_dout == $past(per_din));
    endproperty
    assert property(af_p1165);

    property af_p1166;
    @(posedge mclk) per_en |-> !$isunknown(per_dout);
    endproperty
    assert property(af_p1166);

    property af_p1167;
    @(posedge mclk) (per_en && $changed(per_addr)) |-> $changed(per_dout);
    endproperty
    assert property(af_p1167);

    property af_p1168;
    @(posedge mclk) ($past(per_en) && !per_en) |-> (per_dout == '0);
    endproperty
    assert property(af_p1168);

    property af_p1169;
    @(posedge mclk) (per_en && per_we) |-> !$isunknown(per_dout);
    endproperty
    assert property(af_p1169);


    property af_p1171;
    @(posedge mclk) (per_en && $stable(per_addr)) |-> $stable(per_dout);
    endproperty
    assert property(af_p1171);

    property af_p1172;
    @(posedge mclk) ($fell(per_en)) |=> (!per_en -> (per_dout == '0));
    endproperty
    assert property(af_p1172);

    property af_p1173;
    @(posedge mclk) (per_en) |-> ($stable(per_addr) || $changed(per_dout));
    endproperty
    assert property(af_p1173);

    property af_p1174;
    @(posedge mclk) (per_en && $changed(per_addr)) |-> ($changed(per_dout));
    endproperty
    assert property(af_p1174);

    property af_p1175;
    @(posedge mclk) ($rose(per_en)) |-> (!$isunknown(per_dout));
    endproperty
    assert property(af_p1175);

    property af_p1176;
    @(posedge mclk) (per_en && per_we) |=> ($changed(per_dout));
    endproperty
    assert property(af_p1176);

    property af_p1177;
    @(posedge mclk) (!per_en) |=> (per_dout == $past(per_dout));
    endproperty
    assert property(af_p1177);

    property af_p1178;
    @(posedge mclk) (per_en) |-> (!$isunknown(per_dout));
    endproperty
    assert property(af_p1178);

    property af_p1179;
    @(posedge mclk) (puc_rst) |-> (per_dout == 16'h0000);
    endproperty
    assert property(af_p1179);

    property af_p1180;
    @(posedge mclk) ($fell(per_en)) |-> $stable(per_dout);
    endproperty
    assert property(af_p1180);

    property af_p1181;
    @(posedge mclk) (!per_en) |-> (per_dout == 16'h0000);
    endproperty
    assert property(af_p1181);

    property af_p1182;
    @(posedge mclk) (per_en && $stable(per_addr)) |-> $stable(per_dout) throughout ($past(per_we) != per_we);
    endproperty
    assert property(af_p1182);

    property af_p1183;
    @(posedge mclk) ($stable(per_addr) && $changed(per_en)) |-> $stable(per_dout);
    endproperty
    assert property(af_p1183);


    property af_p1185;
    @(posedge mclk) ($past(per_en) && !per_en) |-> !$stable(per_dout) == 1'b0;
    endproperty
    assert property(af_p1185);

    property af_p1186;
    @(posedge mclk) (!per_en) |=> $stable(per_dout);
    endproperty
    assert property(af_p1186);

    property af_p1187;
    @(posedge mclk) (per_en && per_we) |=> (per_addr == $past(per_addr) && per_din == $past(per_din));
    endproperty
    assert property(af_p1187);

    property af_p1188;
    @(posedge mclk) (per_en) |-> (per_dout == per_dout) && !$isunknown(per_dout);
    endproperty
    assert property(af_p1188);

    property af_p1189;
    @(posedge mclk) (per_en && !per_we) |=> $stable(per_dout);
    endproperty
    assert property(af_p1189);

    property af_p1190;
    @(posedge mclk) (per_en) |=> (!per_en || $stable(per_en) == 1'b0);
    endproperty
    assert property(af_p1190);

    property af_p1191;
    @(posedge mclk) (puc_rst && per_en) |-> (!per_we);
    endproperty
    assert property(af_p1191);

    property af_p1192;
    @(posedge mclk) (per_en) |-> $stable(per_addr);
    endproperty
    assert property(af_p1192);

    property af_p1193;
    @(posedge mclk) (per_en && !per_we) |=> (!per_we);
    endproperty
    assert property(af_p1193);

    property af_p1194;
    @(posedge mclk) (per_en && per_we) |=> ($past(per_din) == $past(per_din));
    endproperty
    assert property(af_p1194);




    property af_p1198;
    @(posedge mclk) ($rose(per_en) && per_we) |=> $stable(per_din);
    endproperty
    assert property(af_p1198);

    property af_p1199;
    @(posedge mclk) ($rose(per_en) && !per_we) |-> ##0 !$isunknown(per_dout);
    endproperty
    assert property(af_p1199);

    property af_p1200;
    @(posedge mclk) !per_en |-> $stable(per_dout);
    endproperty
    assert property(af_p1200);

    property af_p1201;
    @(posedge mclk) (per_en && per_we) |-> ##1 (per_dout == per_din);
    endproperty
    assert property(af_p1201);

    property af_p1202;
    @(posedge mclk) (per_en throughout (##1 per_en)) |-> ##0 !$isunknown(per_dout);
    endproperty
    assert property(af_p1202);

    property af_p1203;
    @(posedge mclk) per_en |-> ##0 !$isunknown(per_dout);
    endproperty
    assert property(af_p1203);

    property af_p1204;
    @(posedge mclk) (per_en && (per_addr !== '0)) |-> ##0 (per_dout !== 'x);
    endproperty
    assert property(af_p1204);

    property af_p1205;
    @(posedge mclk) ((!per_en)[*3]) |-> (per_dout == '0);
    endproperty
    assert property(af_p1205);

    property af_p1206;
    @(posedge mclk) (puc_rst) |-> (!per_en);
    endproperty
    assert property(af_p1206);

    property af_p1207;
    @(posedge mclk) ($fell(per_en)) |=> (per_dout == '0);
    endproperty
    assert property(af_p1207);

    property af_p1208;
    @(posedge mclk) ($fell(puc_rst)) |=> (!per_en);
    endproperty
    assert property(af_p1208);

    property af_p1209;
    @(posedge mclk) (per_en) |-> (cpu_en);
    endproperty
    assert property(af_p1209);

    property af_p1210;
    @(posedge mclk) (!per_en) |-> (!per_we);
    endproperty
    assert property(af_p1210);

    property af_p1211;
    @(posedge mclk) (per_en && per_we) |=> ($stable(per_addr));
    endproperty
    assert property(af_p1211);

    property af_p1212;
    @(posedge mclk) (!per_en) |-> (per_we == 2'b00);
    endproperty
    assert property(af_p1212);

    property af_p1213;
    @(posedge mclk) (per_en && (per_we == 2'b01)) |-> (per_din[7:0] == $past(per_din[7:0])) && (per_din[15:8] == $past(per_din[15:8]));
    endproperty
    assert property(af_p1213);

    property af_p1214;
    @(posedge mclk) (per_we[0] || per_we[1]) |-> (per_en && (per_din !== 16'bx));
    endproperty
    assert property(af_p1214);

    property af_p1215;
    @(posedge mclk) (per_en && (per_we == 2'b11)) |-> (per_din[7:0] == $past(per_din[7:0])) && (per_din[15:8] == $past(per_din[15:8]));
    endproperty
    assert property(af_p1215);

    property af_p1216;
    @(posedge mclk) (per_en && (per_we != 2'b00)) |-> (per_addr == $past(per_addr)) && (per_din == $past(per_din));
    endproperty
    assert property(af_p1216);

    property af_p1217;
    @(posedge mclk) $fell(puc_rst) |-> (per_we == 2'b00)[*1] ##1 !((per_en) && (per_we != 2'b00));
    endproperty
    assert property(af_p1217);

    property af_p1218;
    @(posedge mclk) $rose(puc_rst) |-> (per_we == 2'b00) until (per_en && (per_we != 2'b00));
    endproperty
    assert property(af_p1218);

    property af_p1219;
    @(posedge mclk) ($past(per_we) == 2'b00) && per_en |=> (per_we != 2'b00);
    endproperty
    assert property(af_p1219);

    property af_p1220;
    @(posedge mclk) ($past(per_we) == 2'b00) && (per_we != 2'b00) |-> (per_addr inside {[0:$]}) && per_en;
    endproperty
    assert property(af_p1220);

    property af_p1221;
    @(posedge mclk) ((per_we != 2'b00) ##1 (!per_en)) |-> (per_we == 2'b00);
    endproperty
    assert property(af_p1221);

    property af_p1222;
    @(posedge mclk) (per_we > 2'b00) |-> (per_en);
    endproperty
    assert property(af_p1222);

    property af_p1223;
    @(posedge mclk) (!per_en) |-> ($stable(per_we));
    endproperty
    assert property(af_p1223);

    property af_p1224;
    @(posedge mclk) ($rose(dma_we)) |-> ($stable(per_we));
    endproperty
    assert property(af_p1224);

    property af_p1225;
    @(posedge mclk) ($rose(puc_rst)) |-> (per_we == 2'b00);
    endproperty
    assert property(af_p1225);

    property af_p1226;
    @(posedge mclk) (per_en && (per_we == 2'b10)) |-> ($stable(per_din[7:0]) && !$stable(per_din[15:8]));
    endproperty
    assert property(af_p1226);

    property af_p1227;
    @(posedge mclk) (per_we[0]) |-> (per_en);
    endproperty
    assert property(af_p1227);

    property af_p1228;
    @(posedge mclk) (per_we != 2'b00) |-> (per_din !== 16'bx);
    endproperty
    assert property(af_p1228);

    property af_p1229;
    @(posedge mclk) (per_we == 2'b00) |=> $stable(per_dout);
    endproperty
    assert property(af_p1229);

    property af_p1230;
    @(posedge mclk) !$isunknown(per_we) && (per_we inside {2'b00, 2'b01, 2'b10});
    endproperty
    assert property(af_p1230);

    property af_p1231;
    @(posedge mclk) (per_we[1] === 1'b1) |-> (per_en === 1'b1);
    endproperty
    assert property(af_p1231);

    property af_p1232;
    @(posedge mclk) (per_we != 2'b00) |-> (per_en === 1'b1);
    endproperty
    assert property(af_p1232);

    property af_p1233;
    @(posedge mclk) (per_we != 2'b00) |-> (per_en && (per_addr !== '0));
    endproperty
    assert property(af_p1233);

    property af_p1234;
    @(posedge mclk) (per_en) |-> !(per_we[0] && per_we[1]);
    endproperty
    assert property(af_p1234);

    property af_p1235;
    @(posedge mclk) (per_en && (per_we == 2'b00)) |-> $stable(per_we);
    endproperty
    assert property(af_p1235);

    property af_p1236;
    @(posedge mclk) ((pmem_addr inside {[0:32767]}) && !pmem_cen) |=> (!pmem_cen |-> (pmem_addr inside {[0:65535]}));
    endproperty
    assert property(af_p1236);

    property af_p1237;
    @(posedge mclk) $changed(pmem_addr) |-> $past(!pmem_cen);
    endproperty
    assert property(af_p1237);

    property af_p1238;
    @(posedge mclk) (puc_rst) |=> (pmem_addr == '0);
    endproperty
    assert property(af_p1238);

    property af_p1239;
    @(posedge mclk) disable iff (!reset_n) (!pmem_cen) |=> !$isunknown(pmem_addr);
    endproperty
    assert property(af_p1239);

    property af_p1240;
    @(posedge mclk) $rose(cpu_en) |-> (pmem_addr inside {[0:65535]})[*5];
    endproperty
    assert property(af_p1240);

    property af_p1241;
    @(posedge mclk) (pmem_cen[*2]) |=> $stable(pmem_addr);
    endproperty
    assert property(af_p1241);

    property af_p1242;
    @(posedge mclk) $rose(reset_n) |-> ##3 !$isunknown(pmem_addr);
    endproperty
    assert property(af_p1242);

    property af_p1243;
    @(posedge mclk) (pmem_cen) |=> $stable(pmem_addr);
    endproperty
    assert property(af_p1243);

    property af_p1244;
    @(posedge mclk) $fell(puc_rst) |-> (pmem_addr == 16'h0000) ##[1:3] (pmem_addr != 16'h0000);
    endproperty
    assert property(af_p1244);

    property af_p1245;
    @(posedge mclk) (dbg_freeze) |=> $stable(pmem_addr);
    endproperty
    assert property(af_p1245);

    property af_p1246;
    @(posedge mclk) (dbg_freeze) |-> $stable(pmem_addr) until (!dbg_freeze);
    endproperty
    assert property(af_p1246);

    property af_p1247;
    @(posedge mclk) (!pmem_cen) |-> ((pmem_addr >= 0) && (pmem_addr <= (`PMEM_AWIDTH-1)));
    endproperty
    assert property(af_p1247);

    property af_p1248;
    @(posedge mclk) (puc_rst) |=> (!pmem_cen || (pmem_addr == $past(pmem_addr)));
    endproperty
    assert property(af_p1248);

    property af_p1249;
    @(posedge mclk) (!pmem_cen) |-> $stable(pmem_addr);
    endproperty
    assert property(af_p1249);

    property af_p1250;
    @(posedge mclk) $fell(puc_rst) |=> ##3 ((pmem_addr >= 0) && (pmem_addr <= 65535));
    endproperty
    assert property(af_p1250);

    property af_p1251;
    @(posedge mclk) (pmem_cen) |=> (pmem_addr == $past(pmem_addr));
    endproperty
    assert property(af_p1251);

    property af_p1252;
    @(posedge mclk) $fell(reset_n) |=> (pmem_addr == 0);
    endproperty
    assert property(af_p1252);

    property af_p1253;
    @(posedge mclk) (!pmem_cen && (pmem_wen != 2'b11)) |-> $stable(pmem_addr);
    endproperty
    assert property(af_p1253);

    property af_p1254;
    @(posedge mclk) (reset_n && !pmem_cen) |=> (pmem_addr == ($past(pmem_addr) + 1));
    endproperty
    assert property(af_p1254);

    property af_p1255;
    @(posedge mclk) (pmem_addr != $past(pmem_addr)) |-> ($past(!pmem_cen));
    endproperty
    assert property(af_p1255);

    property af_p1256;
    @(posedge mclk) $rose(reset_n) |=> ((pmem_addr == 0)[*2]);
    endproperty
    assert property(af_p1256);

    property af_p1257;
    @(posedge mclk) (!pmem_cen) |-> ##[0:1] !$isunknown(pmem_dout);
    endproperty
    assert property(af_p1257);

    property af_p1258;
    @(posedge mclk) $rose(reset_n) |-> ##[1:2] !$isunknown(pmem_addr);
    endproperty
    assert property(af_p1258);

    property af_p1259;
    @(posedge mclk) (pmem_cen) |-> (pmem_addr == $past(pmem_addr));
    endproperty
    assert property(af_p1259);

    property af_p1260;
    @(posedge mclk) $past(!reset_n) |-> (pmem_addr == '0);
    endproperty
    assert property(af_p1260);

    property af_p1261;
    @(posedge mclk) (pmem_addr !== $past(pmem_addr)) |-> ($past(!pmem_cen) && ($past(pmem_wen) != '1));
    endproperty
    assert property(af_p1261);

    property af_p1262;
    @(posedge mclk) $past(pmem_cen) |-> (pmem_addr == $past(pmem_addr));
    endproperty
    assert property(af_p1262);

    property af_p1263;
    @(posedge mclk) (!reset_n) |-> $stable(pmem_addr);
    endproperty
    assert property(af_p1263);

    property af_p1264;
    @(posedge mclk) $past(!pmem_cen) |-> !$isunknown(pmem_dout);
    endproperty
    assert property(af_p1264);

    property af_p1265;
    @(posedge mclk) (!puc_rst) |-> (!$isunknown(pmem_addr) && (pmem_addr < (1 << `PMEM_AWIDTH)));
    endproperty
    assert property(af_p1265);

    property af_p1266;
    @(posedge mclk) (!pmem_cen) |=> !$isunknown(pmem_dout);
    endproperty
    assert property(af_p1266);

    property af_p1267;
    @(posedge mclk) (dbg_freeze) |-> (pmem_cen);
    endproperty
    assert property(af_p1267);

    property af_p1268;
    @(posedge mclk) ($past(!pmem_cen) && pmem_cen) |=> $stable(pmem_dout);
    endproperty
    assert property(af_p1268);

    property af_p1269;
    @(posedge mclk) (pmem_cen) |-> $stable(pmem_dout);
    endproperty
    assert property(af_p1269);

    property af_p1270;
    @(posedge mclk) (cpu_en) |-> (!pmem_cen);
    endproperty
    assert property(af_p1270);

    property af_p1271;
    @(posedge mclk) (!pmem_cen && (pmem_wen != 2'b11)) |=> ((pmem_wen[0]==1'b0) -> (pmem_dout[7:0] == $past(pmem_din[7:0]))) && ((pmem_wen[1]==1'b0) -> (pmem_dout[15:8] == $past(pmem_din[15:8])));
    endproperty
    assert property(af_p1271);

    property af_p1272;
    @(posedge mclk) (pmem_cen) |=> $stable(pmem_dout);
    endproperty
    assert property(af_p1272);

    property af_p1273;
    @(posedge mclk) (!pmem_cen) |-> !$isunknown(pmem_addr);
    endproperty
    assert property(af_p1273);

    property af_p1274;
    @(posedge mclk) ($changed(pmem_wen)) |-> (!pmem_cen);
    endproperty
    assert property(af_p1274);

    property af_p1275;
    @(posedge mclk) (!pmem_cen ##1 !pmem_cen) |-> 1'b1;
    endproperty
    assert property(af_p1275);

    property af_p1276;
    @(posedge mclk) (puc_rst) |-> ##1 (pmem_cen);
    endproperty
    assert property(af_p1276);

    property af_p1277;
    @(posedge mclk) (!cpu_en) |-> (pmem_cen);
    endproperty
    assert property(af_p1277);

    property af_p1278;
    @(posedge mclk) (!pmem_cen) |-> ##0 (!pmem_cen);
    endproperty
    assert property(af_p1278);

    property af_p1279;
    @(posedge mclk) (puc_rst) |-> (pmem_cen);
    endproperty
    assert property(af_p1279);

    property af_p1280;
    @(posedge mclk) ($fell(puc_rst)) |-> (pmem_cen);
    endproperty
    assert property(af_p1280);

    property af_p1281;
    @(posedge mclk) ($fell(pmem_cen)) |-> ($past(pmem_cen) == 1'b1);
    endproperty
    assert property(af_p1281);

    property af_p1282;
    @(posedge aclk or posedge smclk) $stable(pmem_cen);
    endproperty
    assert property(af_p1282);

    property af_p1283;
    @(posedge mclk) (!pmem_cen) |=> !$isunknown(pmem_dout) && (pmem_addr == $past(pmem_addr));
    endproperty
    assert property(af_p1283);

    property af_p1284;
    @(posedge mclk) (dbg_freeze) |-> (pmem_cen == 1'b1);
    endproperty
    assert property(af_p1284);

    property af_p1285;
    @(posedge mclk) $rose(reset_n) |-> (pmem_cen == 1'b1);
    endproperty
    assert property(af_p1285);

    property af_p1286;
    @(posedge mclk) (!pmem_cen && !(&pmem_wen)) |=> !$isunknown(pmem_din);
    endproperty
    assert property(af_p1286);

    property af_p1287;
    @(posedge mclk) (pmem_cen) |-> (pmem_dout == $past(pmem_dout));
    endproperty
    assert property(af_p1287);

    property af_p1288;
    @(posedge mclk) (!pmem_cen && (!pmem_wen[0] || !pmem_wen[1])) |-> !$isunknown(pmem_din);
    endproperty
    assert property(af_p1288);

    property af_p1289;
    @(posedge mclk) $fell(pmem_cen) |-> !$isunknown(pmem_addr);
    endproperty
    assert property(af_p1289);

    property af_p1290;
    @(posedge mclk) ($past(pmem_cen)==1'b0 && pmem_cen==1'b0) |-> !$isunknown(pmem_dout);
    endproperty
    assert property(af_p1290);

    property af_p1291;
    @(posedge mclk) (pmem_wen && $stable(pmem_addr)) |-> (((pmem_din >= 0) && (pmem_din <= 65535)) ##1 (pmem_din != $past(pmem_din)));
    endproperty
    assert property(af_p1291);

    property af_p1292;
    @(posedge mclk) (dbg_freeze) |-> ((pmem_din >= 0) && (pmem_din <= 65535));
    endproperty
    assert property(af_p1292);

    property af_p1293;
    @(posedge mclk) ((pmem_din >= 0) && (pmem_din <= 255) && pmem_wen) |=> ((pmem_din >= 0) && (pmem_din <= 255));
    endproperty
    assert property(af_p1293);

    property af_p1294;
    @(posedge mclk) ((pmem_din >= 0) && (pmem_din <= 65535)) |-> ##1 (((pmem_din >= 0) && (pmem_din <= 65535)) && !pmem_wen);
    endproperty
    assert property(af_p1294);


    property af_p1296;
    @(posedge mclk) (dbg_i2c_scl && dbg_i2c_sda_in) |-> (((pmem_din >= 0) && (pmem_din <= 65535)) && $stable(pmem_din));
    endproperty
    assert property(af_p1296);

    property af_p1297;
    @(posedge mclk) ((pmem_din >= 0) && (pmem_din <= 255)) |-> ##1 (((pmem_din >= 0) && (pmem_din <= 255)) && !pmem_wen);
    endproperty
    assert property(af_p1297);

    property af_p1298;
    @(posedge mclk) (!aclk_en) |-> $stable(pmem_din);
    endproperty
    assert property(af_p1298);

    property af_p1299;
    @(posedge mclk) $fell(puc_rst) |-> ##2 ((pmem_din >= 0) && (pmem_din <= 65535));
    endproperty
    assert property(af_p1299);

    property af_p1300;
    @(posedge mclk) (!pmem_cen) |-> $stable(pmem_din);
    endproperty
    assert property(af_p1300);

    property af_p1301;
    @(posedge mclk) $rose(puc_rst) |-> ##1 (pmem_din >= 0) && (pmem_din <= 65535);
    endproperty
    assert property(af_p1301);

    property af_p1302;
    @(posedge mclk) !pmem_cen |-> ((pmem_din >= 0) && (pmem_din <= 65535)) && $stable(pmem_din);
    endproperty
    assert property(af_p1302);

    property af_p1303;
    @(posedge mclk) !pmem_wen |-> $stable(pmem_din) || 1'b1;
    endproperty
    assert property(af_p1303);

    property af_p1304;
    @(posedge mclk) !cpu_en |-> (pmem_din >= 0) && (pmem_din <= 65535);
    endproperty
    assert property(af_p1304);

    property af_p1305;
    @(posedge mclk) $fell(puc_rst) |-> ##[1:2] ((pmem_din >= 0) && (pmem_din <= 65535));
    endproperty
    assert property(af_p1305);

    property af_p1306;
    @(posedge mclk) (pmem_cen && pmem_wen) |-> ##1 (pmem_dout == $past(pmem_din));
    endproperty
    assert property(af_p1306);


    property af_p1308;
    @(posedge scan_enable) scan_mode |-> (pmem_din === pmem_din);
    endproperty
    assert property(af_p1308);

    property af_p1309;
    @(posedge mclk) !pmem_cen |-> $stable(pmem_din);
    endproperty
    assert property(af_p1309);

    property af_p1310;
    @(posedge mclk) ($fell(puc_rst)) |-> ##1 ((pmem_din >= 0) && (pmem_din <= 65535));
    endproperty
    assert property(af_p1310);

    property af_p1311;
    @(posedge mclk) (!cpu_en) |-> (pmem_din === 'bz);
    endproperty
    assert property(af_p1311);

    property af_p1312;
    @(posedge mclk) (pmem_wen) |-> ($stable(pmem_din) && !$isunknown(pmem_din));
    endproperty
    assert property(af_p1312);

    property af_p1313;
    @(posedge mclk) (dbg_freeze) |-> $stable(pmem_din);
    endproperty
    assert property(af_p1313);

    property af_p1314;
    @(posedge mclk) (pmem_wen && (pmem_din >= 0) && (pmem_din <= 255)) |-> ##1 ((pmem_din >= 0) && (pmem_din <= 255));
    endproperty
    assert property(af_p1314);

    property af_p1315;
    @(posedge mclk) (puc_rst) |-> (1'b1);
    endproperty
    assert property(af_p1315);

    property af_p1316;
    @(posedge mclk) (!dbg_en && $changed(pmem_din)) |-> $stable(pmem_dout);
    endproperty
    assert property(af_p1316);

    property af_p1317;
    @(posedge mclk) (!reset_n) |-> ((pmem_din == '0) until (!puc_rst));
    endproperty
    assert property(af_p1317);

    property af_p1318;
    @(posedge mclk) (!pmem_cen && !pmem_wen[1] && pmem_wen[0]) |=> (pmem_dout[15:8] == $past(pmem_din[15:8]));
    endproperty
    assert property(af_p1318);

    property af_p1319;
    @(posedge mclk) ($changed(pmem_addr) && !pmem_cen) |=> $changed(pmem_dout);
    endproperty
    assert property(af_p1319);

    property af_p1320;
    @(posedge mclk) (!pmem_cen && (pmem_wen != 2'b11)) |=> $changed(pmem_dout);
    endproperty
    assert property(af_p1320);

    property af_p1321;
    @(posedge mclk) (!puc_rst && !pmem_cen) |=> $changed(pmem_dout);
    endproperty
    assert property(af_p1321);

    property af_p1322;
    @(posedge mclk) (!pmem_cen && (pmem_wen != 2'b11)) |=> (pmem_dout == $past(pmem_din));
    endproperty
    assert property(af_p1322);

    property af_p1323;
    @(posedge mclk) (!puc_rst) |-> $stable(pmem_dout);
    endproperty
    assert property(af_p1323);

    property af_p1324;
    @(posedge mclk) (!pmem_cen) |=> $changed(pmem_dout);
    endproperty
    assert property(af_p1324);

    property af_p1325;
    @(posedge mclk) (!pmem_cen && (pmem_wen != 2'b11)) |=> !$isunknown(pmem_dout);
    endproperty
    assert property(af_p1325);

    property af_p1326;
    @(posedge mclk) (!pmem_cen && (pmem_wen == 2'b11)) |=> !$isunknown(pmem_dout);
    endproperty
    assert property(af_p1326);

    property af_p1327;
    @(posedge mclk) ($rose(pmem_cen)) |=> $stable(pmem_dout) until ($fell(pmem_cen));
    endproperty
    assert property(af_p1327);


    property af_p1329;
    @(posedge mclk) (pmem_cen) |=> $stable(pmem_dout);
    endproperty
    assert property(af_p1329);

    property af_p1330;
    @(posedge mclk) ($past(pmem_cen) && pmem_cen) |-> $stable(pmem_dout);
    endproperty
    assert property(af_p1330);

    property af_p1331;
    @(posedge mclk) (!reset_n) |=> $stable(pmem_dout);
    endproperty
    assert property(af_p1331);

    property af_p1332;
    @(posedge mclk) (!pmem_cen && $changed(pmem_addr)) |-> ##1 ($changed(pmem_dout));
    endproperty
    assert property(af_p1332);

    property af_p1333;
    @(posedge mclk) (!pmem_cen && !pmem_wen[0]) |-> ##1 (pmem_dout[7:0] == $past(pmem_din[7:0]));
    endproperty
    assert property(af_p1333);

    property af_p1334;
    @(posedge mclk) (!pmem_cen && $past(!pmem_cen) && $changed(pmem_addr)) |-> ($changed(pmem_dout));
    endproperty
    assert property(af_p1334);

    property af_p1335;
    @(posedge mclk) (pmem_cen) |-> (pmem_dout == $past(pmem_dout));
    endproperty
    assert property(af_p1335);

    property af_p1336;
    @(posedge mclk) (pmem_cen && $past(pmem_cen)) |-> ($stable(pmem_dout));
    endproperty
    assert property(af_p1336);

    property af_p1337;
    @(posedge mclk) (!pmem_cen && (pmem_dout >= 0) && (pmem_dout <= 65535)) |-> ##1 (!pmem_cen -> ((pmem_dout >= 0) && (pmem_dout <= 65535)));
    endproperty
    assert property(af_p1337);


    property af_p1339;
    @(posedge mclk) ($rose(pmem_cen)) |-> ($stable(pmem_dout));
    endproperty
    assert property(af_p1339);

    property af_p1340;
    @(posedge mclk) ($fell(pmem_cen)) |-> ((pmem_dout == $past(pmem_dout)) ##1 (pmem_dout != $past(pmem_dout,2)));
    endproperty
    assert property(af_p1340);

    property af_p1341;
    @(posedge mclk) (pmem_wen == 2'b00) |=> (pmem_wen inside {[2'b01:2'b11]});
    endproperty
    assert property(af_p1341);

    property af_p1342;
    @(posedge mclk) (!puc_rst) |-> (pmem_wen inside {[2'b00:2'b11]});
    endproperty
    assert property(af_p1342);

    property af_p1343;
    @(posedge mclk) (pmem_wen inside {[2'b00:2'b01]}) |=> (pmem_wen inside {[2'b10:2'b11]});
    endproperty
    assert property(af_p1343);

    property af_p1344;
    @(posedge mclk) (!pmem_cen && (pmem_wen == 2'b11)) |=> (!$isunknown(pmem_dout));
    endproperty
    assert property(af_p1344);

    property af_p1345;
    @(posedge mclk) (!pmem_cen && (pmem_wen != 2'b11)) |=> (!$isunknown(pmem_dout));
    endproperty
    assert property(af_p1345);

    property af_p1346;
    @(posedge mclk) ($past(pmem_wen) == 2'b11 && (pmem_wen == 2'b10)) |=> (pmem_dout[15:8] == $past(pmem_din[15:8]));
    endproperty
    assert property(af_p1346);

    property af_p1347;
    @(posedge mclk) (puc_rst) |-> (pmem_wen == 2'b11);
    endproperty
    assert property(af_p1347);

    property af_p1348;
    @(posedge mclk) (!pmem_cen && (pmem_addr != 0) && (pmem_wen != 2'b11)) |=> (!pmem_cen) |-> (pmem_dout == $past(pmem_din));
    endproperty
    assert property(af_p1348);

    property af_p1349;
    @(posedge mclk) ($fell(puc_rst)) |-> ##2 (pmem_wen inside {[2'b00:2'b11]});
    endproperty
    assert property(af_p1349);

    property af_p1350;
    @(posedge mclk) (pmem_cen) |-> (pmem_wen == 2'b11);
    endproperty
    assert property(af_p1350);

    property af_p1351;
    @(posedge mclk) (!pmem_cen && !pmem_wen[0]) |-> (!$isunknown(pmem_din[7:0]));
    endproperty
    assert property(af_p1351);

    property af_p1352;
    @(posedge mclk) ($past(pmem_cen) && pmem_cen) |-> $stable(pmem_wen);
    endproperty
    assert property(af_p1352);

    property af_p1353;
    @(posedge mclk) (pmem_cen) |-> $stable(pmem_wen);
    endproperty
    assert property(af_p1353);

    property af_p1354;
    @(posedge mclk) (!pmem_cen && (pmem_wen == 2'b00)) |-> (!$isunknown(pmem_din));
    endproperty
    assert property(af_p1354);

    property af_p1355;
    @(posedge mclk) ($rose(puc_rst)) |=> (pmem_wen == 2'b11);
    endproperty
    assert property(af_p1355);

    property af_p1356;
    @(posedge mclk) ($fell(puc_rst)) |-> ##3 ((pmem_wen >= 0) && (pmem_wen <= 3));
    endproperty
    assert property(af_p1356);

    property af_p1357;
    @(posedge mclk) ((pmem_wen >= 2) && (pmem_wen <= 3)) |=> ((pmem_wen >= 0) && (pmem_wen <= 3));
    endproperty
    assert property(af_p1357);

    property af_p1358;
    @(posedge mclk) (!pmem_cen && !pmem_wen[0]) |-> (!$isunknown(pmem_din[7:0]) && $stable(pmem_din[7:0]));
    endproperty
    assert property(af_p1358);

    property af_p1359;
    @(posedge mclk) (pmem_cen) |=> (pmem_wen == 2'b11);
    endproperty
    assert property(af_p1359);

    property af_p1360;
    @(posedge mclk) (($past(pmem_wen) == 2'b11) && (pmem_wen != 2'b11)) |-> (pmem_cen == 1'b0);
    endproperty
    assert property(af_p1360);

    property af_p1361;
    @(posedge mclk) (!pmem_wen[0] || !pmem_wen[1]) |=> $changed(pmem_dout);
    endproperty
    assert property(af_p1361);

    property af_p1362;
    @(posedge mclk) $fell(puc_rst) |-> ##4 (pmem_wen >= 0 && pmem_wen <= 3);
    endproperty
    assert property(af_p1362);

    property af_p1363;
    @(posedge mclk) (pmem_wen == 2'b00) |-> $stable(pmem_din) throughout (pmem_wen == 2'b00)[*1:$];
    endproperty
    assert property(af_p1363);

    property af_p1364;
    @(posedge mclk) (!puc_rst) |-> (pmem_wen >= 0 && pmem_wen <= 3);
    endproperty
    assert property(af_p1364);

    property af_p1365;
    @(posedge mclk) (!pmem_wen[1] && !pmem_cen) |-> ##1 (pmem_din[15:8] == $past(pmem_din[15:8]));
    endproperty
    assert property(af_p1365);

    property af_p1366;
    @(posedge mclk) (!pmem_wen[1] && !pmem_cen) |-> $stable(pmem_din[15:8]) && !$isunknown(pmem_din[15:8]);
    endproperty
    assert property(af_p1366);

    property af_p1367;
    @(posedge mclk) (pmem_cen) |-> $stable(pmem_wen) || (pmem_dout == $past(pmem_dout));
    endproperty
    assert property(af_p1367);

    property af_p1368;
    @(posedge mclk) (!pmem_cen) |-> (pmem_wen >= 0 && pmem_wen <= 2);
    endproperty
    assert property(af_p1368);

    property af_p1369;
    @(posedge mclk) $rose(puc_rst) |=> (pmem_wen == 2'b11) throughout (pmem_wen != 2'b11)[->1];
    endproperty
    assert property(af_p1369);

    property af_p1370;
    @(posedge mclk) ($past(pmem_wen) == 2'b11 && pmem_wen == 2'b01) |=> (pmem_din[7:0] == $past(pmem_din[7:0]));
    endproperty
    assert property(af_p1370);


    property af_p1372;
    @(posedge puc_rst) (1) |-> (dmem_wen == 1'b0 && pmem_wen == 1'b0);
    endproperty
    assert property(af_p1372);

    property af_p1373;
    @(posedge mclk) (puc_rst && scan_mode) |-> (puc_rst == puc_rst);
    endproperty
    assert property(af_p1373);

    property af_p1374;
    @(posedge mclk) (puc_rst) |-> (cpu_en == 1'b0);
    endproperty
    assert property(af_p1374);


    property af_p1376;
    @(posedge mclk) (puc_rst) |-> ##[0:$] (per_dout == per_dout);
    endproperty
    assert property(af_p1376);

    property af_p1377;
    @(posedge mclk) (puc_rst && smclk_en) |-> (puc_rst);
    endproperty
    assert property(af_p1377);

    property af_p1378;
    @(posedge mclk) ($rose(reset_n)) |-> (puc_rst == 1'b0);
    endproperty
    assert property(af_p1378);

    property af_p1379;
    @(posedge mclk) (puc_rst) |-> (dma_en == 1'b0);
    endproperty
    assert property(af_p1379);

    property af_p1380;
    @(posedge mclk) (puc_rst) |-> (irq_acc == 1'b0) throughout (puc_rst[*1:$]);
    endproperty
    assert property(af_p1380);

    property af_p1381;
    @(posedge mclk) (puc_rst) |-> (aclk_en == 1'b0);
    endproperty
    assert property(af_p1381);


    property af_p1383;
    @(posedge mclk) $fell(puc_rst) |-> ##4 dco_enable;
    endproperty
    assert property(af_p1383);

    property af_p1384;
    @(posedge mclk) $fell(puc_rst) |-> ##[1:$] $changed(aclk_en);
    endproperty
    assert property(af_p1384);

    property af_p1385;
    @(posedge mclk) $fell(reset_n) |=> puc_rst;
    endproperty
    assert property(af_p1385);

    property af_p1386;
    @(posedge mclk) puc_rst |-> ($stable(scan_mode) && $stable(scan_enable));
    endproperty
    assert property(af_p1386);

    property af_p1387;
    @(posedge mclk) $fell(puc_rst) |-> ##2 $rose(mclk);
    endproperty
    assert property(af_p1387);

    property af_p1388;
    @(posedge mclk) $rose(puc_rst) |=> puc_rst;
    endproperty
    assert property(af_p1388);

    property af_p1389;
    @(posedge mclk) puc_rst |-> !dbg_en;
    endproperty
    assert property(af_p1389);

    property af_p1390;
    @(posedge mclk) $fell(puc_rst) |-> !dbg_en;
    endproperty
    assert property(af_p1390);

    property af_p1391;
    @(posedge mclk) puc_rst |-> (irq == 1'b0);
    endproperty
    assert property(af_p1391);

    property af_p1392;
    @(posedge puc_rst) 1'b1 |-> !dma_en;
    endproperty
    assert property(af_p1392);

    property af_p1393;
    @(posedge puc_rst) 1'b1 |-> (dbg_freeze == 1'b0);
    endproperty
    assert property(af_p1393);

    property af_p1394;
    @(posedge mclk) puc_rst |-> !dma_en;
    endproperty
    assert property(af_p1394);

    property af_p1395;
    @(posedge mclk) puc_rst |-> !per_en;
    endproperty
    assert property(af_p1395);

    property af_p1396;
    @(posedge mclk) puc_rst |-> !smclk_en;
    endproperty
    assert property(af_p1396);

    property af_p1397;
    @(posedge mclk) puc_rst |-> $stable(per_en);
    endproperty
    assert property(af_p1397);

    property af_p1398;
    @(posedge mclk) $rose(reset_n) |-> ##1 $fell(puc_rst);
    endproperty
    assert property(af_p1398);

    property af_p1399;
    @(posedge mclk) $fell(puc_rst) |-> ##1 (cpu_en == 1'b1);
    endproperty
    assert property(af_p1399);

    property af_p1400;
    @(posedge mclk) puc_rst |-> (wkup == 1'b0);
    endproperty
    assert property(af_p1400);

    property af_p1401;
    @(posedge mclk) $fell(puc_rst) |-> ##[1:2] $changed(aclk_en);
    endproperty
    assert property(af_p1401);

    property af_p1402;
    @(posedge mclk) puc_rst |-> !irq_acc;
    endproperty
    assert property(af_p1402);

    property af_p1403;
    @(posedge mclk) $fell(puc_rst) |-> (!puc_rst until (!reset_n));
    endproperty
    assert property(af_p1403);

    property af_p1404;
    @(posedge mclk) $fell(puc_rst) |-> ##1 cpu_en;
    endproperty
    assert property(af_p1404);

    property af_p1405;
    @(posedge mclk) $fell(reset_n) |-> ##1 puc_rst;
    endproperty
    assert property(af_p1405);

    property af_p1406;
    @(posedge mclk) ($rose(reset_n)) |-> ##1 (puc_rst == 1'b0);
    endproperty
    assert property(af_p1406);

    property af_p1407;
    @(posedge mclk) (!reset_n || puc_rst) |-> (!per_en);
    endproperty
    assert property(af_p1407);

    property af_p1408;
    @(posedge mclk) (!reset_n) |-> (puc_rst == 1'b1);
    endproperty
    assert property(af_p1408);

    property af_p1409;
    @(posedge mclk) (!reset_n || puc_rst) |-> (!dma_en);
    endproperty
    assert property(af_p1409);

    property af_p1410;
    @(posedge mclk) (!reset_n) |-> (irq == 1'b0);
    endproperty
    assert property(af_p1410);

    property af_p1411;
    @(posedge mclk) (!reset_n) |-> (!cpu_en);
    endproperty
    assert property(af_p1411);

    property af_p1412;
    @(posedge mclk) (!reset_n || puc_rst) |-> (!irq);
    endproperty
    assert property(af_p1412);

    property af_p1413;
    @(posedge mclk) (reset_n && puc_rst) |-> (!cpu_en);
    endproperty
    assert property(af_p1413);

    property af_p1414;
    @(posedge mclk) ($rose(reset_n)) |-> ##2 (puc_rst == 1'b0);
    endproperty
    assert property(af_p1414);

    property af_p1415;
    @(posedge mclk) (!reset_n) |-> (!pmem_cen && !dmem_cen);
    endproperty
    assert property(af_p1415);

    property af_p1416;
    @(posedge mclk) (!reset_n) |-> !dmem_wen;
    endproperty
    assert property(af_p1416);

    property af_p1417;
    @(posedge mclk) $rose(reset_n) |-> puc_rst ##1 !puc_rst;
    endproperty
    assert property(af_p1417);

    property af_p1418;
    @(posedge mclk) (!reset_n) |-> puc_rst;
    endproperty
    assert property(af_p1418);

    property af_p1419;
    @(posedge mclk) (!reset_n) |-> dbg_freeze;
    endproperty
    assert property(af_p1419);

    property af_p1420;
    @(posedge mclk) (!reset_n) |-> !nmi;
    endproperty
    assert property(af_p1420);

    property af_p1421;
    @(posedge mclk) $rose(reset_n) |-> dbg_freeze until (!puc_rst);
    endproperty
    assert property(af_p1421);

    property af_p1422;
    @(posedge mclk) $rose(reset_n) |-> ##[1:$] !puc_rst;
    endproperty
    assert property(af_p1422);

    property af_p1423;
    @(posedge mclk) $fell(puc_rst) |-> !per_en;
    endproperty
    assert property(af_p1423);

    property af_p1424;
    @(posedge mclk) (!reset_n) |-> !dbg_en;
    endproperty
    assert property(af_p1424);

    property af_p1425;
    @(posedge mclk) (reset_n[*3]) |=> (!puc_rst);
    endproperty
    assert property(af_p1425);

    property af_p1426;
    @(posedge mclk) (!reset_n) |-> (puc_rst && $stable(puc_rst));
    endproperty
    assert property(af_p1426);

    property af_p1427;
    @(posedge mclk) ((!reset_n) || puc_rst) |-> (!dma_en);
    endproperty
    assert property(af_p1427);

    property af_p1428;
    @(posedge mclk) $rose(reset_n) |=> !puc_rst;
    endproperty
    assert property(af_p1428);

    property af_p1429;
    @(posedge mclk) $fell(reset_n) |=> ((pmem_addr == '0) && (dmem_addr == '0));
    endproperty
    assert property(af_p1429);

    property af_p1430;
    @(posedge mclk) (!reset_n) |-> (!wkup);
    endproperty
    assert property(af_p1430);

    property af_p1431;
    @(posedge mclk) ((!reset_n) || puc_rst) |-> (irq == 0);
    endproperty
    assert property(af_p1431);

    property af_p1432;
    @(posedge mclk) (!reset_n) |-> (dbg_freeze);
    endproperty
    assert property(af_p1432);

    property af_p1433;
    @(posedge mclk) (!reset_n) |-> (!pmem_wen);
    endproperty
    assert property(af_p1433);

    property af_p1434;
    @(posedge dco_clk) (scan_mode && $rose(scan_enable)) |-> ##1 (scan_enable == 1'b1);
    endproperty
    assert property(af_p1434);




    property af_p1438;
    @(posedge dco_clk) (!scan_mode) |-> ($stable(scan_enable) throughout (!scan_mode)[*1:$]);
    endproperty
    assert property(af_p1438);

    property af_p1439;
    @(posedge dco_clk) (scan_mode && scan_enable) |-> ##1 (mclk == $past(~mclk));
    endproperty
    assert property(af_p1439);

    property af_p1440;
    @(posedge dco_clk) $rose(reset_n) |-> ##[1:2] (scan_enable == 1'b0);
    endproperty
    assert property(af_p1440);


    property af_p1442;
    @(posedge dco_clk) (!scan_mode) |-> (scan_enable == 1'b0);
    endproperty
    assert property(af_p1442);



    property af_p1445;
    @(posedge dco_clk) ($fell(scan_enable) && scan_mode) |=> (smclk == (dco_clk && smclk_en));
    endproperty
    assert property(af_p1445);

    property af_p1446;
    @(posedge dco_clk) (scan_mode && scan_enable) |-> (puc_rst == !reset_n);
    endproperty
    assert property(af_p1446);

    property af_p1447;
    @(posedge dco_clk) (scan_mode && !scan_enable) |-> (mclk == (dco_clk && cpu_en));
    endproperty
    assert property(af_p1447);

    property af_p1448;
    @(posedge dco_clk) (scan_mode && scan_enable) |-> (scan_enable[*3]);
    endproperty
    assert property(af_p1448);

    property af_p1449;
    @(posedge dco_clk) ($rose(scan_enable) && scan_mode) |-> ##[1:$] ($fell(scan_enable) && (puc_rst == !reset_n));
    endproperty
    assert property(af_p1449);

    property af_p1450;
    @(posedge dco_clk) (scan_mode && scan_enable) |-> ((mclk == dco_clk) && (smclk == dco_clk));
    endproperty
    assert property(af_p1450);

    property af_p1451;
    @(posedge dco_clk) (scan_mode && scan_enable) |-> (smclk == dco_clk);
    endproperty
    assert property(af_p1451);

    property af_p1452;
    @(posedge dco_clk) (scan_mode) |-> ((scan_enable |-> (mclk == dco_clk)) and (!scan_enable |-> (mclk == (dco_clk && cpu_en))));
    endproperty
    assert property(af_p1452);

    property af_p1453;
    @(posedge dco_clk) (scan_enable && !scan_mode) |-> ((mclk == (dco_clk && cpu_en)) && (smclk == (dco_clk && smclk_en)));
    endproperty
    assert property(af_p1453);

    property af_p1454;
    @(posedge dco_clk) (scan_mode) |-> (puc_rst == !reset_n);
    endproperty
    assert property(af_p1454);

    property af_p1455;
    @(posedge dco_clk) (!scan_mode && $changed(scan_enable)) |-> ($stable(mclk) && $stable(smclk));
    endproperty
    assert property(af_p1455);

    property af_p1456;
    @(posedge dco_clk) ($fell(reset_n) && scan_mode && scan_enable) |=> (mclk == dco_clk);
    endproperty
    assert property(af_p1456);

    property af_p1457;
    @(posedge dco_clk) disable iff (scan_mode) $stable(scan_enable);
    endproperty
    assert property(af_p1457);

    property af_p1458;
    @(posedge dco_clk) (!scan_mode) |-> ((mclk == aclk_en) && (smclk == smclk_en));
    endproperty
    assert property(af_p1458);

    property af_p1459;
    @(posedge dco_clk) (scan_mode && scan_enable) |-> (mclk == dco_clk);
    endproperty
    assert property(af_p1459);

    property af_p1460;
    @(posedge dco_clk) (scan_mode && scan_enable) |-> (smclk_en);
    endproperty
    assert property(af_p1460);

    property af_p1461;
    @(posedge dco_clk) (scan_mode && $fell(scan_enable)) |=> (mclk == dco_clk);
    endproperty
    assert property(af_p1461);


    property af_p1463;
    @(posedge mclk) (scan_mode && scan_enable) |-> (aclk_en == 1'b1) && (smclk_en == 1'b1);
    endproperty
    assert property(af_p1463);

    property af_p1464;
    @(posedge mclk) (!scan_enable) |-> (dma_en == $past(dma_en));
    endproperty
    assert property(af_p1464);

    property af_p1465;
    @(posedge mclk) (scan_mode && scan_enable) |-> ##1 (mclk == !$past(mclk));
    endproperty
    assert property(af_p1465);

    property af_p1466;
    @(posedge mclk) ($rose(scan_mode)) |-> ##1 (puc_rst == reset_n);
    endproperty
    assert property(af_p1466);

    property af_p1467;
    @(posedge mclk) (scan_mode) |-> (puc_rst == reset_n);
    endproperty
    assert property(af_p1467);

    property af_p1468;
    @(posedge mclk) ($stable(scan_mode));
    endproperty
    assert property(af_p1468);


    property af_p1470;
    @(posedge mclk) ($rose(scan_mode)) |-> (puc_rst == reset_n);
    endproperty
    assert property(af_p1470);


    property af_p1472;
    @(posedge mclk) (scan_mode && !scan_enable) |-> (aclk_en === aclk_en);
    endproperty
    assert property(af_p1472);

    property af_p1473;
    @(posedge mclk) (!scan_mode) |-> !(puc_rst === reset_n);
    endproperty
    assert property(af_p1473);

    property af_p1474;
    @(posedge mclk) (scan_mode) |-> (puc_rst === reset_n);
    endproperty
    assert property(af_p1474);

    property af_p1475;
    @(posedge mclk) (!scan_mode) |-> ((dbg_freeze === $past(dbg_freeze)) || (scan_enable !== $past(scan_enable)));
    endproperty
    assert property(af_p1475);

    property af_p1476;
    @(posedge mclk) (scan_mode && scan_enable) |-> (smclk_en === 1'b1);
    endproperty
    assert property(af_p1476);

    property af_p1477;
    @(posedge mclk) (scan_mode) |-> ((puc_rst === reset_n) && !$isunknown(wkup));
    endproperty
    assert property(af_p1477);

    property af_p1478;
    @(posedge mclk) (!reset_n) |-> $stable(scan_mode);
    endproperty
    assert property(af_p1478);

    property af_p1479;
    @(posedge mclk) $stable(scan_mode);
    endproperty
    assert property(af_p1479);

    property af_p1480;
    @(posedge mclk) (scan_mode && scan_enable) |-> (aclk !== $past(aclk));
    endproperty
    assert property(af_p1480);

    property af_p1481;
    @(posedge mclk) $rose(scan_mode) |=> (puc_rst == ~reset_n);
    endproperty
    assert property(af_p1481);

    property af_p1482;
    @(posedge mclk) (scan_mode) |-> ##1 (puc_rst == ~reset_n);
    endproperty
    assert property(af_p1482);

    property af_p1483;
    @(posedge mclk) (!scan_mode) |-> !(puc_rst == ~reset_n);
    endproperty
    assert property(af_p1483);

    property af_p1484;
    @(posedge mclk) (scan_mode) |-> (puc_rst == ~reset_n);
    endproperty
    assert property(af_p1484);

    property af_p1485;
    @(posedge mclk) (scan_mode && scan_enable) |-> (dco_enable == 1'b1);
    endproperty
    assert property(af_p1485);

    property af_p1486;
    @(posedge mclk) (scan_mode && scan_enable) |=> $changed(mclk);
    endproperty
    assert property(af_p1486);

    property af_p1487;
    @(posedge mclk) (scan_mode && dbg_freeze) |-> ##1 (puc_rst == ~reset_n);
    endproperty
    assert property(af_p1487);


    property af_p1489;
    @(posedge mclk) (scan_mode && scan_enable) |=> $changed(smclk);
    endproperty
    assert property(af_p1489);

    property af_p1490;
    @(posedge dco_clk) (1'b1) |-> (smclk_en ? (smclk !== $past(smclk)) : $stable(smclk));
    endproperty
    assert property(af_p1490);

    property af_p1491;
    @(posedge dco_clk) puc_rst |-> (smclk === 1'b0);
    endproperty
    assert property(af_p1491);

    property af_p1492;
    @(posedge dco_clk) ($fell(puc_rst) && smclk_en) |-> ##[1:2] (smclk !== $past(smclk));
    endproperty
    assert property(af_p1492);

    property af_p1493;
    @(posedge dco_clk) $rose(wkup) |-> ##[1:2] (smclk !== $past(smclk));
    endproperty
    assert property(af_p1493);

    property af_p1494;
    @(posedge dco_clk) $fell(smclk_en) |=> $stable(smclk);
    endproperty
    assert property(af_p1494);

    property af_p1495;
    @(posedge dco_clk) $rose(smclk_en) |=> (smclk === dco_clk);
    endproperty
    assert property(af_p1495);

    property af_p1496;
    @(posedge dco_clk) (!smclk_en) |-> $stable(smclk);
    endproperty
    assert property(af_p1496);


    property af_p1498;
    @(posedge dco_clk) (!scan_enable && smclk_en) |-> (smclk !== $past(smclk));
    endproperty
    assert property(af_p1498);

    property af_p1499;
    @(posedge dco_clk) (!smclk_en) |=> (smclk === 1'b0);
    endproperty
    assert property(af_p1499);

    property af_p1500;
    @(posedge dco_clk) dbg_freeze |-> $stable(smclk);
    endproperty
    assert property(af_p1500);

    property af_p1501;
    @(posedge dco_clk) smclk_en |-> ##1 (smclk === dco_clk);
    endproperty
    assert property(af_p1501);

    property af_p1502;
    @(posedge dco_clk) $rose(puc_rst) |=> $stable(smclk);
    endproperty
    assert property(af_p1502);

    property af_p1503;
    @(posedge dco_clk) $fell(reset_n) |-> (!smclk) ##1 (!smclk);
    endproperty
    assert property(af_p1503);

    property af_p1504;
    @(posedge dco_clk) (smclk_en && $past(smclk_en) && $past(smclk_en,2)) |-> (smclk == $past(smclk,2));
    endproperty
    assert property(af_p1504);

    property af_p1505;
    @(posedge dco_clk) smclk_en |=> (smclk === dco_clk);
    endproperty
    assert property(af_p1505);


    property af_p1507;
    @(posedge dco_clk) (smclk_en && $past(smclk_en)) |-> (smclk == dco_clk);
    endproperty
    assert property(af_p1507);

    property af_p1508;
    @(posedge dco_clk) $rose(smclk_en) |=> (smclk === $past(dco_clk));
    endproperty
    assert property(af_p1508);

    property af_p1509;
    @(posedge dco_clk) (!reset_n) |-> (!smclk);
    endproperty
    assert property(af_p1509);

    property af_p1510;
    @(posedge dco_clk) (scan_mode) |-> $stable(smclk);
    endproperty
    assert property(af_p1510);

    property af_p1511;
    @(posedge dco_clk) $rose(reset_n) |-> (!smclk) ##1 (!smclk);
    endproperty
    assert property(af_p1511);

    property af_p1512;
    @(posedge dco_clk) $fell(dbg_freeze) |=> (smclk !== $past(smclk));
    endproperty
    assert property(af_p1512);

    property af_p1513;
    @(posedge dco_clk) $rose(smclk_en) |-> ##1 (smclk === dco_clk);
    endproperty
    assert property(af_p1513);

    property af_p1514;
    @(posedge dco_clk) (scan_enable && scan_mode) |-> $stable(smclk);
    endproperty
    assert property(af_p1514);

    property af_p1515;
    @(posedge dco_clk) scan_mode |-> (smclk == 1'b0);
    endproperty
    assert property(af_p1515);

    property af_p1516;
    @(posedge dco_clk) scan_enable |-> $stable(smclk);
    endproperty
    assert property(af_p1516);

    property af_p1517;
    @(posedge dco_clk) ($rose(reset_n) && smclk_en) |-> ##[1:3] $changed(smclk);
    endproperty
    assert property(af_p1517);

    property af_p1518;
    @(posedge dco_clk) !smclk_en |=> $stable(smclk);
    endproperty
    assert property(af_p1518);

    property af_p1519;
    @(posedge dco_clk) (!smclk_en && puc_rst) |-> !$changed(smclk);
    endproperty
    assert property(af_p1519);

    property af_p1520;
    @(posedge dco_clk) $fell(reset_n) |=> $stable(smclk);
    endproperty
    assert property(af_p1520);

    property af_p1521;
    @(posedge lfxt_clk) smclk_en |-> ##1 $changed(smclk);
    endproperty
    assert property(af_p1521);

    property af_p1522;
    @(posedge dco_clk) 1 |-> !((smclk !== $past(smclk)) && (smclk === $past(smclk,2)));
    endproperty
    assert property(af_p1522);

    property af_p1523;
    @(posedge dco_clk) puc_rst |-> $stable(smclk);
    endproperty
    assert property(af_p1523);

    property af_p1524;
    @(posedge dco_clk) $rose(smclk_en) |=> (smclk !== $past(smclk));
    endproperty
    assert property(af_p1524);

    property af_p1525;
    @(posedge mclk) disable iff (puc_rst) $rose(smclk_en) |-> ##1 $rose(smclk_en) == 1'b0 throughout ($past(smclk_en) == smclk_en);
    endproperty
    assert property(af_p1525);

    property af_p1526;
    @(posedge mclk) puc_rst |-> !smclk_en;
    endproperty
    assert property(af_p1526);

    property af_p1527;
    @(posedge mclk) $rose(puc_rst) |-> !smclk_en;
    endproperty
    assert property(af_p1527);

    property af_p1528;
    @(posedge mclk) disable iff (puc_rst) $rose(smclk_en) |=> !smclk_en;
    endproperty
    assert property(af_p1528);

    property af_p1529;
    @(posedge mclk) $fell(puc_rst) |-> ##[1:16] smclk_en;
    endproperty
    assert property(af_p1529);

    property af_p1530;
    @(posedge mclk) !(smclk_en && puc_rst);
    endproperty
    assert property(af_p1530);


    property af_p1532;
    @(posedge mclk) $stable(smclk_en);
    endproperty
    assert property(af_p1532);

    property af_p1533;
    @(posedge mclk) $fell(puc_rst) |-> (!smclk_en)[*4];
    endproperty
    assert property(af_p1533);

    property af_p1534;
    @(posedge mclk) disable iff (puc_rst) smclk_en |-> (smclk_en == $past(smclk_en) ^ 1'b1) || (smclk == $past(smclk));
    endproperty
    assert property(af_p1534);

    property af_p1535;
    @(posedge mclk) $fell(puc_rst) |-> (!smclk_en)[*2];
    endproperty
    assert property(af_p1535);

    property af_p1536;
    @(posedge mclk) disable iff (puc_rst) (1'b1) |=> ($past(smclk_en) !== smclk_en) or ($past(smclk_en) === smclk_en);
    endproperty
    assert property(af_p1536);

    property af_p1537;
    @(posedge mclk) disable iff (puc_rst) (smclk_en) |-> ##[1:$] (smclk_en);
    endproperty
    assert property(af_p1537);

    property af_p1538;
    @(posedge mclk) (smclk_en) |-> ($past(smclk) !== smclk);
    endproperty
    assert property(af_p1538);

    property af_p1539;
    @(posedge mclk) (puc_rst) |-> (smclk_en === 1'b0) throughout (puc_rst[*1:$]);
    endproperty
    assert property(af_p1539);

    property af_p1540;
    @(posedge mclk) (dbg_freeze && puc_rst) |-> (smclk_en === 1'b0);
    endproperty
    assert property(af_p1540);

    property af_p1541;
    @(posedge mclk) (puc_rst) |=> (smclk_en === 1'b0);
    endproperty
    assert property(af_p1541);

    property af_p1542;
    @(posedge mclk) (scan_mode) |-> (smclk_en === 1'b0);
    endproperty
    assert property(af_p1542);

    property af_p1543;
    @(posedge mclk) (scan_enable) |=> (smclk_en === $past(smclk_en));
    endproperty
    assert property(af_p1543);

    property af_p1544;
    @(posedge mclk) disable iff (puc_rst) (smclk_en) |-> ##1 (!smclk_en)[*1:$] ##1 (smclk_en);
    endproperty
    assert property(af_p1544);

    property af_p1545;
    @(posedge mclk) !(smclk_en && aclk_en);
    endproperty
    assert property(af_p1545);

    property af_p1546;
    @(posedge mclk) (puc_rst) |-> (smclk_en === 1'b0);
    endproperty
    assert property(af_p1546);

    property af_p1547;
    @(posedge mclk) disable iff (puc_rst) (!puc_rst) |-> ##[1:$] $rose(smclk_en);
    endproperty
    assert property(af_p1547);

    property af_p1548;
    @(posedge mclk) (dbg_freeze) |=> (smclk_en == $past(smclk_en));
    endproperty
    assert property(af_p1548);

    property af_p1549;
    @(posedge mclk) ($fell(puc_rst)) |=> ##[1:$] $rose(smclk_en) ##1 (smclk_en == !$past(smclk_en));
    endproperty
    assert property(af_p1549);

    property af_p1550;
    @(posedge mclk) ($fell(puc_rst)) |=> ##[1:$] $rose(smclk_en);
    endproperty
    assert property(af_p1550);

    property af_p1551;
    @(posedge mclk) ($fell(puc_rst)) |-> ##3 $rose(smclk_en);
    endproperty
    assert property(af_p1551);

    property af_p1552;
    @(posedge mclk) ($fell(dbg_freeze)) |=> ##[1:$] (smclk_en == !$past(smclk_en));
    endproperty
    assert property(af_p1552);

    property af_p1553;
    @(posedge mclk) disable iff (puc_rst) (smclk_en) |=> (!smclk_en || $past(smclk_en) == 0);
    endproperty
    assert property(af_p1553);


    property af_p1555;
    @(posedge mclk) (!puc_rst) |-> ##[1:$] (smclk_en throughout !puc_rst[*1:$]);
    endproperty
    assert property(af_p1555);

    property af_p1556;
    @(posedge mclk) (smclk_en) |=> $isunknown(smclk) == 0;
    endproperty
    assert property(af_p1556);

    property af_p1557;
    @(posedge mclk) ($rose(puc_rst)) |-> (smclk_en == 1'b0);
    endproperty
    assert property(af_p1557);

    property af_p1558;
    @(posedge mclk) !reset_n |-> !wkup;
    endproperty
    assert property(af_p1558);

    property af_p1559;
    @(posedge mclk) (wkup && !lfxt_wkup) |-> !$changed(lfxt_enable);
    endproperty
    assert property(af_p1559);

    property af_p1560;
    @(posedge mclk) $rose(wkup) |-> ##1 dco_enable;
    endproperty
    assert property(af_p1560);

    property af_p1561;
    @(posedge mclk) $fell(reset_n) |=> !wkup;
    endproperty
    assert property(af_p1561);

    property af_p1562;
    @(posedge dco_clk) ($fell(wkup) && puc_rst) |-> ##[1:2] !dco_wkup;
    endproperty
    assert property(af_p1562);

    property af_p1563;
    @(posedge mclk) (wkup && !dco_enable) |-> ##0 dco_wkup;
    endproperty
    assert property(af_p1563);

    property af_p1564;
    @(posedge mclk) $fell(wkup) |-> dco_wkup[*2];
    endproperty
    assert property(af_p1564);

    property af_p1565;
    @(posedge mclk) $fell(wkup) |-> ##1 $stable(dco_enable);
    endproperty
    assert property(af_p1565);

    property af_p1566;
    @(posedge dco_clk) (wkup && !dco_enable) |-> ##0 (dco_wkup throughout (!mclk)[*1:$]) until (mclk);
    endproperty
    assert property(af_p1566);

    property af_p1567;
    @(posedge dco_clk) ($rose(wkup) ##1 $fell(wkup)) |-> ##[1:2] (dco_wkup == puc_rst);
    endproperty
    assert property(af_p1567);

    property af_p1568;
    @(posedge dco_clk) $rose(wkup) |-> ##[1:8] mclk;
    endproperty
    assert property(af_p1568);

    property af_p1569;
    @(posedge mclk) wkup |-> (wkup throughout (irq[->0]));
    endproperty
    assert property(af_p1569);

    property af_p1570;
    @(posedge mclk) (wkup && !cpu_en) |-> ##[1:5] cpu_en;
    endproperty
    assert property(af_p1570);

    property af_p1571;
    @(posedge mclk) $fell(wkup) |-> $past(irq_acc);
    endproperty
    assert property(af_p1571);


    property af_p1573;
    @(posedge mclk) (wkup && irq_acc) |-> $stable(dco_wkup);
    endproperty
    assert property(af_p1573);

    property af_p1574;
    @(posedge dco_clk) (wkup && mclk) |-> ##1 dco_enable;
    endproperty
    assert property(af_p1574);

    property af_p1575;
    @(posedge mclk) wkup |-> ((aclk_en && smclk_en) until irq);
    endproperty
    assert property(af_p1575);

    property af_p1576;
    @(posedge mclk) (wkup && mclk) |=> irq;
    endproperty
    assert property(af_p1576);

    property af_p1577;
    @(posedge mclk) wkup |-> ##[1:10] (aclk && smclk);
    endproperty
    assert property(af_p1577);

    property af_p1578;
    @(posedge mclk) !(wkup && dma_wkup);
    endproperty
    assert property(af_p1578);

    property af_p1579;
    @(posedge mclk) (wkup && scan_mode) |-> !dco_wkup;
    endproperty
    assert property(af_p1579);

    property af_p1580;
    @(posedge mclk) (wkup && !dco_enable) |-> dco_wkup;
    endproperty
    assert property(af_p1580);

    property af_p1581;
    @(posedge mclk) $rose(wkup) |-> ##1 $rose(dco_enable);
    endproperty
    assert property(af_p1581);

    property af_p1582;
    @(posedge mclk) (wkup ##1 wkup) |-> $stable(dco_enable);
    endproperty
    assert property(af_p1582);

    property af_p1583;
    @(posedge mclk) (wkup && !puc_rst && $fell(irq)) |-> ##2 (!dco_wkup);
    endproperty
    assert property(af_p1583);

    property af_p1584;
    @(posedge mclk) (!reset_n) |-> (!wkup);
    endproperty
    assert property(af_p1584);

    property af_p1585;
    @(posedge mclk) $stable(wkup);
    endproperty
    assert property(af_p1585);

    property af_p1586;
    @(posedge mclk) $rose(dco_enable) |-> $past(wkup);
    endproperty
    assert property(af_p1586);

    property af_p1587;
    @(posedge mclk) (puc_rst) |-> (!wkup);
    endproperty
    assert property(af_p1587);

    property af_p1588;
    @(posedge dco_clk) (wkup[*3]) |-> (dco_enable[*3]);
    endproperty
    assert property(af_p1588);

    property af_p1589;
    @(posedge mclk) $rose(wkup) |-> (wkup until (cpu_en));
    endproperty
    assert property(af_p1589);

    property af_p1590;
    @(posedge mclk) $rose(wkup) |-> (wkup until (!irq));
    endproperty
    assert property(af_p1590);




endmodule // openMSP430

`ifdef OMSP_NO_INCLUDE
`else
`include "openMSP430_undefines.v"
`endif
