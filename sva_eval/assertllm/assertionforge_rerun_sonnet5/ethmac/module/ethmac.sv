//////////////////////////////////////////////////////////////////////
////                                                              ////
////  ethmac.v                                                    ////
////                                                              ////
////  This file is part of the Ethernet IP core project           ////
////  http://www.opencores.org/project,ethmac                     ////
////                                                              ////
////  Author(s):                                                  ////
////      - Igor Mohor (igorM@opencores.org)                      ////
////                                                              ////
////  All additional information is available in the Readme.txt   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2001, 2002 Authors                             ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// 2011-08-09 olof@opencores.org
// Renamed from eth_top.v to ethmac.v to better fit into the OpenCores
// Structure
//
// CVS Revision History
//
// $Log: not supported by cvs2svn $
// Revision 1.51  2005/02/21 11:13:17  igorm
// Defer indication fixed.
//
// Revision 1.50  2004/04/26 15:26:23  igorm
// - Bug connected to the TX_BD_NUM_Wr signal fixed (bug came in with the
//   previous update of the core.
// - TxBDAddress is set to 0 after the TX is enabled in the MODER register.
// - RxBDAddress is set to r_TxBDNum<<1 after the RX is enabled in the MODER
//   register. (thanks to Mathias and Torbjorn)
// - Multicast reception was fixed. Thanks to Ulrich Gries
//
// Revision 1.49  2003/11/12 18:24:59  tadejm
// WISHBONE slave changed and tested from only 32-bit accesss to byte access.
//
// Revision 1.48  2003/10/17 07:46:16  markom
// mbist signals updated according to newest convention
//
// Revision 1.47  2003/10/06 15:43:45  knguyen
// Update RxEnSync only when mrxdv_pad_i is inactive (LOW).
//
// Revision 1.46  2003/01/30 13:30:22  tadejm
// Defer indication changed.
//
// Revision 1.45  2003/01/22 13:49:26  tadejm
// When control packets were received, they were ignored in some cases.
//
// Revision 1.44  2003/01/21 12:09:40  mohor
// When receiving normal data frame and RxFlow control was switched on, RXB
// interrupt was not set.
//
// Revision 1.43  2002/11/22 01:57:06  mohor
// Rx Flow control fixed. CF flag added to the RX buffer descriptor. RxAbort
// synchronized.
//
// Revision 1.42  2002/11/21 00:09:19  mohor
// TPauseRq synchronized to tx_clk.
//
// Revision 1.41  2002/11/19 18:13:49  mohor
// r_MiiMRst is not used for resetting the MIIM module. wb_rst used instead.
//
// Revision 1.40  2002/11/19 17:34:25  mohor
// AddressMiss status is connecting to the Rx BD. AddressMiss is identifying
// that a frame was received because of the promiscous mode.
//
// Revision 1.39  2002/11/18 17:31:55  mohor
// wb_rst_i is used for MIIM reset.
//
// Revision 1.38  2002/11/14 18:37:20  mohor
// r_Rst signal does not reset any module any more and is removed from the design.
//
// Revision 1.37  2002/11/13 22:25:36  tadejm
// All modules are reset with wb_rst instead of the r_Rst. Exception is MII module.
//
// Revision 1.36  2002/10/18 17:04:20  tadejm
// Changed BIST scan signals.
//
// Revision 1.35  2002/10/11 13:36:58  mohor
// Typo error fixed. (When using Bist)
//
// Revision 1.34  2002/10/10 16:49:50  mohor
// Signals for WISHBONE B3 compliant interface added.
//
// Revision 1.33  2002/10/10 16:29:30  mohor
// BIST added.
//
// Revision 1.32  2002/09/20 17:12:58  mohor
// CsMiss added. When address between 0x800 and 0xfff is accessed within
// Ethernet Core, error acknowledge is generated.
//
// Revision 1.31  2002/09/12 14:50:17  mohor
// CarrierSenseLost bug fixed when operating in full duplex mode.
//
// Revision 1.30  2002/09/10 10:35:23  mohor
// Ethernet debug registers removed.
//
// Revision 1.29  2002/09/09 13:03:13  mohor
// Error acknowledge is generated when accessing BDs and RST bit in the
// MODER register (r_Rst) is set.
//
// Revision 1.28  2002/09/04 18:44:10  mohor
// Signals related to the control frames connected. Debug registers reg1, 2, 3, 4
// connected.
//
// Revision 1.27  2002/07/25 18:15:37  mohor
// RxAbort changed. Packets received with MRxErr (from PHY) are also
// aborted.
//
// Revision 1.26  2002/07/17 18:51:50  mohor
// EXTERNAL_DMA removed. External DMA not supported.
//
// Revision 1.25  2002/05/03 10:15:50  mohor
// Outputs registered. Reset changed for eth_wishbone module.
//
// Revision 1.24  2002/04/22 14:15:42  mohor
// Wishbone signals are registered when ETH_REGISTERED_OUTPUTS is
// selected in eth_defines.v
//
// Revision 1.23  2002/03/25 13:33:53  mohor
// md_padoen_o changed to md_padoe_o. Signal was always active high, just
// name was incorrect.
//
// Revision 1.22  2002/02/26 16:59:54  mohor
// Small fixes for external/internal DMA missmatches.
//
// Revision 1.21  2002/02/26 16:21:00  mohor
// Interrupts changed in the top file
//
// Revision 1.20  2002/02/18 10:40:17  mohor
// Small fixes.
//
// Revision 1.19  2002/02/16 14:03:44  mohor
// Registered trimmed. Unused registers removed.
//
// Revision 1.18  2002/02/16 13:06:33  mohor
// EXTERNAL_DMA used instead of WISHBONE_DMA.
//
// Revision 1.17  2002/02/16 07:15:27  mohor
// Testbench fixed, code simplified, unused signals removed.
//
// Revision 1.16  2002/02/15 13:49:39  mohor
// RxAbort is connected differently.
//
// Revision 1.15  2002/02/15 11:38:26  mohor
// Changes that were lost when updating from 1.11 to 1.14 fixed.
//
// Revision 1.14  2002/02/14 20:19:11  billditt
// Modified for Address Checking,
// addition of eth_addrcheck.v
//
// Revision 1.13  2002/02/12 17:03:03  mohor
// HASH0 and HASH1 registers added. Registers address width was
// changed to 8 bits.
//
// Revision 1.12  2002/02/11 09:18:22  mohor
// Tx status is written back to the BD.
//
// Revision 1.11  2002/02/08 16:21:54  mohor
// Rx status is written back to the BD.
//
// Revision 1.10  2002/02/06 14:10:21  mohor
// non-DMA host interface added. Select the right configutation in eth_defines.
//
// Revision 1.9  2002/01/23 10:28:16  mohor
// Link in the header changed.
//
// Revision 1.8  2001/12/05 15:00:16  mohor
// RX_BD_NUM changed to TX_BD_NUM (holds number of TX descriptors
// instead of the number of RX descriptors).
//
// Revision 1.7  2001/12/05 10:45:59  mohor
// ETH_RX_BD_ADR register deleted. ETH_RX_BD_NUM is used instead.
//
// Revision 1.6  2001/10/19 11:24:29  mohor
// Number of addresses (wb_adr_i) minimized.
//
// Revision 1.5  2001/10/19 08:43:51  mohor
// eth_timescale.v changed to timescale.v This is done because of the
// simulation of the few cores in a one joined project.
//
// Revision 1.4  2001/10/18 12:07:11  mohor
// Status signals changed, Adress decoding changed, interrupt controller
// added.
//
// Revision 1.3  2001/09/24 15:02:56  mohor
// Defines changed (All precede with ETH_). Small changes because some
// tools generate warnings when two operands are together. Synchronization
// between two clocks domains in eth_wishbonedma.v is changed (due to ASIC
// demands).
//
// Revision 1.2  2001/08/15 14:03:59  mohor
// Signal names changed on the top level for easier pad insertion (ASIC).
//
// Revision 1.1  2001/08/06 14:44:29  mohor
// A define FPGA added to select between Artisan RAM (for ASIC) and Block Ram (For Virtex).
// Include files fixed to contain no path.
// File names and module names changed ta have a eth_ prologue in the name.
// File eth_timescale.v is used to define timescale
// All pin names on the top module are changed to contain _I, _O or _OE at the end.
// Bidirectional signal MDIO is changed to three signals (Mdc_O, Mdi_I, Mdo_O
// and Mdo_OE. The bidirectional signal must be created on the top level. This
// is done due to the ASIC tools.
//
// Revision 1.2  2001/08/02 09:25:31  mohor
// Unconnected signals are now connected.
//
// Revision 1.1  2001/07/30 21:23:42  mohor
// Directory structure changed. Files checked and joind together.
//
//
//
// 


`include "ethmac_defines.v"
`include "timescale.v"


module ethmac
(
  // WISHBONE common
  wb_clk_i, wb_rst_i, wb_dat_i, wb_dat_o, 

  // WISHBONE slave
  wb_adr_i, wb_sel_i, wb_we_i, wb_cyc_i, wb_stb_i, wb_ack_o, wb_err_o, 

  // WISHBONE master
  m_wb_adr_o, m_wb_sel_o, m_wb_we_o, 
  m_wb_dat_o, m_wb_dat_i, m_wb_cyc_o, 
  m_wb_stb_o, m_wb_ack_i, m_wb_err_i, 

  m_wb_cti_o, m_wb_bte_o, 

  //TX
  mtx_clk_pad_i, mtxd_pad_o, mtxen_pad_o, mtxerr_pad_o,

  //RX
  mrx_clk_pad_i, mrxd_pad_i, mrxdv_pad_i, mrxerr_pad_i, mcoll_pad_i, mcrs_pad_i,
  
  // MIIM
  mdc_pad_o, md_pad_i, md_pad_o, md_padoe_o,

  int_o

  // Bist
`ifdef ETH_BIST
  ,
  // debug chain signals
  mbist_si_i,       // bist scan serial in
  mbist_so_o,       // bist scan serial out
  mbist_ctrl_i        // bist chain shift control
`endif

);


parameter TX_FIFO_DATA_WIDTH = `ETH_TX_FIFO_DATA_WIDTH;
parameter TX_FIFO_DEPTH      = `ETH_TX_FIFO_DEPTH;
parameter TX_FIFO_CNT_WIDTH  = `ETH_TX_FIFO_CNT_WIDTH;
parameter RX_FIFO_DATA_WIDTH = `ETH_RX_FIFO_DATA_WIDTH;
parameter RX_FIFO_DEPTH      = `ETH_RX_FIFO_DEPTH;
parameter RX_FIFO_CNT_WIDTH  = `ETH_RX_FIFO_CNT_WIDTH;


// WISHBONE common
input           wb_clk_i;     // WISHBONE clock
input           wb_rst_i;     // WISHBONE reset
input   [31:0]  wb_dat_i;     // WISHBONE data input
output  [31:0]  wb_dat_o;     // WISHBONE data output
output          wb_err_o;     // WISHBONE error output

// WISHBONE slave
input   [11:2]  wb_adr_i;     // WISHBONE address input
input    [3:0]  wb_sel_i;     // WISHBONE byte select input
input           wb_we_i;      // WISHBONE write enable input
input           wb_cyc_i;     // WISHBONE cycle input
input           wb_stb_i;     // WISHBONE strobe input
output          wb_ack_o;     // WISHBONE acknowledge output

// WISHBONE master
output  [31:0]  m_wb_adr_o;
output   [3:0]  m_wb_sel_o;
output          m_wb_we_o;
input   [31:0]  m_wb_dat_i;
output  [31:0]  m_wb_dat_o;
output          m_wb_cyc_o;
output          m_wb_stb_o;
input           m_wb_ack_i;
input           m_wb_err_i;

wire    [29:0]  m_wb_adr_tmp;

output   [2:0]  m_wb_cti_o;   // Cycle Type Identifier
output   [1:0]  m_wb_bte_o;   // Burst Type Extension

// Tx
input           mtx_clk_pad_i; // Transmit clock (from PHY)
output   [3:0]  mtxd_pad_o;    // Transmit nibble (to PHY)
output          mtxen_pad_o;   // Transmit enable (to PHY)
output          mtxerr_pad_o;  // Transmit error (to PHY)

// Rx
input           mrx_clk_pad_i; // Receive clock (from PHY)
input    [3:0]  mrxd_pad_i;    // Receive nibble (from PHY)
input           mrxdv_pad_i;   // Receive data valid (from PHY)
input           mrxerr_pad_i;  // Receive data error (from PHY)

// Common Tx and Rx
input           mcoll_pad_i;   // Collision (from PHY)
input           mcrs_pad_i;    // Carrier sense (from PHY)

// MII Management interface
input           md_pad_i;      // MII data input (from I/O cell)
output          mdc_pad_o;     // MII Management data clock (to PHY)
output          md_pad_o;      // MII data output (to I/O cell)
output          md_padoe_o;    // MII data output enable (to I/O cell)

output          int_o;         // Interrupt output

// Bist
`ifdef ETH_BIST
input   mbist_si_i;       // bist scan serial in
output  mbist_so_o;       // bist scan serial out
input [`ETH_MBIST_CTRL_WIDTH - 1:0] mbist_ctrl_i;       // bist chain shift control
`endif

wire    [31:0]  wb_dbg_dat0;

wire     [7:0]  r_ClkDiv;
wire            r_MiiNoPre;
wire    [15:0]  r_CtrlData;
wire     [4:0]  r_FIAD;
wire     [4:0]  r_RGAD;
wire            r_WCtrlData;
wire            r_RStat;
wire            r_ScanStat;
wire            NValid_stat;
wire            Busy_stat;
wire            LinkFail;
wire    [15:0]  Prsd;             // Read Status Data (data read from the PHY)
wire            WCtrlDataStart;
wire            RStatStart;
wire            UpdateMIIRX_DATAReg;

wire            TxStartFrm;
wire            TxEndFrm;
wire            TxUsedData;
wire     [7:0]  TxData;
wire            TxRetry;
wire            TxAbort;
wire            TxUnderRun;
wire            TxDone;


reg             WillSendControlFrame_sync1;
reg             WillSendControlFrame_sync2;
reg             WillSendControlFrame_sync3;
reg             RstTxPauseRq;

reg             TxPauseRq_sync1;
reg             TxPauseRq_sync2;
reg             TxPauseRq_sync3;
reg             TPauseRq;


// Connecting Miim module
eth_miim miim1
(
  .Clk(wb_clk_i),
  .Reset(wb_rst_i),
  .Divider(r_ClkDiv),
  .NoPre(r_MiiNoPre),
  .CtrlData(r_CtrlData),
  .Rgad(r_RGAD),
  .Fiad(r_FIAD),
  .WCtrlData(r_WCtrlData),
  .RStat(r_RStat),
  .ScanStat(r_ScanStat),
  .Mdi(md_pad_i),
  .Mdo(md_pad_o),
  .MdoEn(md_padoe_o),
  .Mdc(mdc_pad_o),
  .Busy(Busy_stat),
  .Prsd(Prsd),
  .LinkFail(LinkFail),
  .Nvalid(NValid_stat),
  .WCtrlDataStart(WCtrlDataStart),
  .RStatStart(RStatStart),
  .UpdateMIIRX_DATAReg(UpdateMIIRX_DATAReg)
);




wire  [3:0] RegCs;          // Connected to registers
wire [31:0] RegDataOut;     // Multiplexed to wb_dat_o
wire        r_RecSmall;     // Receive small frames
wire        r_LoopBck;      // Loopback
wire        r_TxEn;         // Tx Enable
wire        r_RxEn;         // Rx Enable

wire        MRxDV_Lb;       // Muxed MII receive data valid
wire        MRxErr_Lb;      // Muxed MII Receive Error
wire  [3:0] MRxD_Lb;        // Muxed MII Receive Data
wire        Transmitting;   // Indication that TxEthMAC is transmitting
wire        r_HugEn;        // Huge packet enable
wire        r_DlyCrcEn;     // Delayed CRC enabled
wire [15:0] r_MaxFL;        // Maximum frame length

wire [15:0] r_MinFL;        // Minimum frame length
wire        ShortFrame;
wire        DribbleNibble;  // Extra nibble received
wire        ReceivedPacketTooBig; // Received packet is too big
wire [47:0] r_MAC;          // MAC address
wire        LoadRxStatus;   // Rx status was loaded
wire [31:0] r_HASH0;        // HASH table, lower 4 bytes
wire [31:0] r_HASH1;        // HASH table, upper 4 bytes
wire  [7:0] r_TxBDNum;      // Receive buffer descriptor number
wire  [6:0] r_IPGT;         // 
wire  [6:0] r_IPGR1;        // 
wire  [6:0] r_IPGR2;        // 
wire  [5:0] r_CollValid;    // 
wire [15:0] r_TxPauseTV;    // Transmit PAUSE value
wire        r_TxPauseRq;    // Transmit PAUSE request

wire  [3:0] r_MaxRet;       //
wire        r_NoBckof;      // 
wire        r_ExDfrEn;      // 
wire        r_TxFlow;       // Tx flow control enable
wire        r_IFG;          // Minimum interframe gap for incoming packets

wire        TxB_IRQ;        // Interrupt Tx Buffer
wire        TxE_IRQ;        // Interrupt Tx Error
wire        RxB_IRQ;        // Interrupt Rx Buffer
wire        RxE_IRQ;        // Interrupt Rx Error
wire        Busy_IRQ;       // Interrupt Busy (lack of buffers)

//wire        DWord;
wire        ByteSelected;
wire        BDAck;
wire [31:0] BD_WB_DAT_O;    // wb_dat_o that comes from the Wishbone module
                            //(for buffer descriptors read/write)
wire  [3:0] BDCs;           // Buffer descriptor CS
wire        CsMiss;         // When access to the address between 0x800
                            // and 0xfff occurs, acknowledge is set
                            // but data is not valid.
wire        r_Pad;
wire        r_CrcEn;
wire        r_FullD;
wire        r_Pro;
wire        r_Bro;
wire        r_NoPre;
wire        r_RxFlow;
wire        r_PassAll;
wire        TxCtrlEndFrm;
wire        StartTxDone;
wire        SetPauseTimer;
wire        TxUsedDataIn;
wire        TxDoneIn;
wire        TxAbortIn;
wire        PerPacketPad;
wire        PadOut;
wire        PerPacketCrcEn;
wire        CrcEnOut;
wire        TxStartFrmOut;
wire        TxEndFrmOut;
wire        ReceivedPauseFrm;
wire        ControlFrmAddressOK;
wire        RxStatusWriteLatched_sync2;
wire        LateCollision;
wire        DeferIndication;
wire        LateCollLatched;
wire        DeferLatched;
wire        RstDeferLatched;
wire        CarrierSenseLost;

wire        temp_wb_ack_o;
wire [31:0] temp_wb_dat_o;
wire        temp_wb_err_o;

`ifdef ETH_REGISTERED_OUTPUTS
  reg         temp_wb_ack_o_reg;
  reg [31:0]  temp_wb_dat_o_reg;
  reg         temp_wb_err_o_reg;
`endif

//assign DWord = &wb_sel_i;
assign ByteSelected = |wb_sel_i;
assign RegCs[3] = wb_stb_i & wb_cyc_i & ByteSelected & ~wb_adr_i[11] & ~wb_adr_i[10] & wb_sel_i[3];   // 0x0   - 0x3FF
assign RegCs[2] = wb_stb_i & wb_cyc_i & ByteSelected & ~wb_adr_i[11] & ~wb_adr_i[10] & wb_sel_i[2];   // 0x0   - 0x3FF
assign RegCs[1] = wb_stb_i & wb_cyc_i & ByteSelected & ~wb_adr_i[11] & ~wb_adr_i[10] & wb_sel_i[1];   // 0x0   - 0x3FF
assign RegCs[0] = wb_stb_i & wb_cyc_i & ByteSelected & ~wb_adr_i[11] & ~wb_adr_i[10] & wb_sel_i[0];   // 0x0   - 0x3FF
assign BDCs[3]  = wb_stb_i & wb_cyc_i & ByteSelected & ~wb_adr_i[11] &  wb_adr_i[10] & wb_sel_i[3];   // 0x400 - 0x7FF
assign BDCs[2]  = wb_stb_i & wb_cyc_i & ByteSelected & ~wb_adr_i[11] &  wb_adr_i[10] & wb_sel_i[2];   // 0x400 - 0x7FF
assign BDCs[1]  = wb_stb_i & wb_cyc_i & ByteSelected & ~wb_adr_i[11] &  wb_adr_i[10] & wb_sel_i[1];   // 0x400 - 0x7FF
assign BDCs[0]  = wb_stb_i & wb_cyc_i & ByteSelected & ~wb_adr_i[11] &  wb_adr_i[10] & wb_sel_i[0];   // 0x400 - 0x7FF
assign CsMiss = wb_stb_i & wb_cyc_i & ByteSelected & wb_adr_i[11];                   // 0x800 - 0xfFF
assign temp_wb_dat_o = ((|RegCs) & ~wb_we_i)? RegDataOut : BD_WB_DAT_O;
assign temp_wb_err_o = wb_stb_i & wb_cyc_i & (~ByteSelected | CsMiss);

`ifdef ETH_REGISTERED_OUTPUTS
  assign wb_ack_o = temp_wb_ack_o_reg;
  assign wb_dat_o[31:0] = temp_wb_dat_o_reg;
  assign wb_err_o = temp_wb_err_o_reg;
`else
  assign wb_ack_o = temp_wb_ack_o;
  assign wb_dat_o[31:0] = temp_wb_dat_o;
  assign wb_err_o = temp_wb_err_o;
`endif

`ifdef ETH_AVALON_BUS
  // As Avalon has no corresponding "error" signal, I (erroneously) will
  // send an ack to Avalon, even when accessing undefined memory. This
  // is a grey area in Avalon vs. Wishbone specs: My understanding
  // is that Avalon expects all memory addressable by the addr bus feeding
  // a slave to be, at the very minimum, readable.
  assign temp_wb_ack_o = (|RegCs) | BDAck | CsMiss;
`else // WISHBONE
  assign temp_wb_ack_o = (|RegCs) | BDAck;
`endif

`ifdef ETH_REGISTERED_OUTPUTS
  always @ (posedge wb_clk_i or posedge wb_rst_i)
  begin
    if(wb_rst_i)
      begin
        temp_wb_ack_o_reg <= 1'b0;
        temp_wb_dat_o_reg <= 32'h0;
        temp_wb_err_o_reg <= 1'b0;
      end
    else
      begin
        temp_wb_ack_o_reg <= temp_wb_ack_o & ~temp_wb_ack_o_reg;
        temp_wb_dat_o_reg <= temp_wb_dat_o;
        temp_wb_err_o_reg <= temp_wb_err_o & ~temp_wb_err_o_reg;
      end
  end
`endif


// Connecting Ethernet registers
eth_registers ethreg1
(
  .DataIn(wb_dat_i),
  .Address(wb_adr_i[9:2]),
  .Rw(wb_we_i),
  .Cs(RegCs),
  .Clk(wb_clk_i),
  .Reset(wb_rst_i),
  .DataOut(RegDataOut),
  .r_RecSmall(r_RecSmall),
  .r_Pad(r_Pad),
  .r_HugEn(r_HugEn),
  .r_CrcEn(r_CrcEn),
  .r_DlyCrcEn(r_DlyCrcEn),
  .r_FullD(r_FullD),
  .r_ExDfrEn(r_ExDfrEn),
  .r_NoBckof(r_NoBckof),
  .r_LoopBck(r_LoopBck),
  .r_IFG(r_IFG),
  .r_Pro(r_Pro),
  .r_Iam(),
  .r_Bro(r_Bro),
  .r_NoPre(r_NoPre),
  .r_TxEn(r_TxEn),
  .r_RxEn(r_RxEn),
  .Busy_IRQ(Busy_IRQ),
  .RxE_IRQ(RxE_IRQ),
  .RxB_IRQ(RxB_IRQ),
  .TxE_IRQ(TxE_IRQ),
  .TxB_IRQ(TxB_IRQ),
  .r_IPGT(r_IPGT),
  .r_IPGR1(r_IPGR1),
  .r_IPGR2(r_IPGR2),
  .r_MinFL(r_MinFL),
  .r_MaxFL(r_MaxFL),
  .r_MaxRet(r_MaxRet),
  .r_CollValid(r_CollValid),
  .r_TxFlow(r_TxFlow),
  .r_RxFlow(r_RxFlow),
  .r_PassAll(r_PassAll),
  .r_MiiNoPre(r_MiiNoPre),
  .r_ClkDiv(r_ClkDiv),
  .r_WCtrlData(r_WCtrlData),
  .r_RStat(r_RStat),
  .r_ScanStat(r_ScanStat),
  .r_RGAD(r_RGAD),
  .r_FIAD(r_FIAD),
  .r_CtrlData(r_CtrlData),
  .NValid_stat(NValid_stat),
  .Busy_stat(Busy_stat),
  .LinkFail(LinkFail),
  .r_MAC(r_MAC),
  .WCtrlDataStart(WCtrlDataStart),
  .RStatStart(RStatStart),
  .UpdateMIIRX_DATAReg(UpdateMIIRX_DATAReg),
  .Prsd(Prsd),
  .r_TxBDNum(r_TxBDNum),
  .int_o(int_o),
  .r_HASH0(r_HASH0),
  .r_HASH1(r_HASH1),
  .r_TxPauseRq(r_TxPauseRq),
  .r_TxPauseTV(r_TxPauseTV),
  .RstTxPauseRq(RstTxPauseRq),
  .TxCtrlEndFrm(TxCtrlEndFrm),
  .StartTxDone(StartTxDone),
  .TxClk(mtx_clk_pad_i),
  .RxClk(mrx_clk_pad_i),
  .dbg_dat(wb_dbg_dat0),
  .SetPauseTimer(SetPauseTimer)
  
);



wire  [7:0] RxData;
wire        RxValid;
wire        RxStartFrm;
wire        RxEndFrm;
wire        RxAbort;

wire        WillTransmit;            // Will transmit (to RxEthMAC)
wire        ResetCollision;          // Reset Collision (for synchronizing 
                                     // collision)
wire  [7:0] TxDataOut;               // Transmit Packet Data (to TxEthMAC)
wire        WillSendControlFrame;
wire        ReceiveEnd;
wire        ReceivedPacketGood;
wire        ReceivedLengthOK;
wire        InvalidSymbol;
wire        LatchedCrcError;
wire        RxLateCollision;
wire  [3:0] RetryCntLatched;   
wire  [3:0] RetryCnt;   
wire        StartTxAbort;   
wire        MaxCollisionOccured;   
wire        RetryLimit;   
wire        StatePreamble;   
wire  [1:0] StateData; 

// Connecting MACControl
eth_maccontrol maccontrol1
(
  .MTxClk(mtx_clk_pad_i),
  .TPauseRq(TPauseRq),
  .TxPauseTV(r_TxPauseTV),
  .TxDataIn(TxData),
  .TxStartFrmIn(TxStartFrm),
  .TxEndFrmIn(TxEndFrm),
  .TxUsedDataIn(TxUsedDataIn),
  .TxDoneIn(TxDoneIn),
  .TxAbortIn(TxAbortIn),
  .MRxClk(mrx_clk_pad_i),
  .RxData(RxData),
  .RxValid(RxValid),
  .RxStartFrm(RxStartFrm),
  .RxEndFrm(RxEndFrm),
  .ReceiveEnd(ReceiveEnd),
  .ReceivedPacketGood(ReceivedPacketGood),
  .TxFlow(r_TxFlow),
  .RxFlow(r_RxFlow),
  .DlyCrcEn(r_DlyCrcEn),
  .MAC(r_MAC),
  .PadIn(r_Pad | PerPacketPad),
  .PadOut(PadOut),
  .CrcEnIn(r_CrcEn | PerPacketCrcEn),
  .CrcEnOut(CrcEnOut),
  .TxReset(wb_rst_i),
  .RxReset(wb_rst_i),
  .ReceivedLengthOK(ReceivedLengthOK),
  .TxDataOut(TxDataOut),
  .TxStartFrmOut(TxStartFrmOut),
  .TxEndFrmOut(TxEndFrmOut),
  .TxUsedDataOut(TxUsedData),
  .TxDoneOut(TxDone),
  .TxAbortOut(TxAbort),
  .WillSendControlFrame(WillSendControlFrame),
  .TxCtrlEndFrm(TxCtrlEndFrm),
  .ReceivedPauseFrm(ReceivedPauseFrm),
  .ControlFrmAddressOK(ControlFrmAddressOK),
  .SetPauseTimer(SetPauseTimer),
  .RxStatusWriteLatched_sync2(RxStatusWriteLatched_sync2),
  .r_PassAll(r_PassAll)
);



wire TxCarrierSense;          // Synchronized CarrierSense (to Tx clock)
wire Collision;               // Synchronized Collision

reg CarrierSense_Tx1;
reg CarrierSense_Tx2;
reg Collision_Tx1;
reg Collision_Tx2;

reg RxEnSync;                 // Synchronized Receive Enable
reg WillTransmit_q;
reg WillTransmit_q2;



// Muxed MII receive data valid
assign MRxDV_Lb = r_LoopBck? mtxen_pad_o : mrxdv_pad_i & RxEnSync;

// Muxed MII Receive Error
assign MRxErr_Lb = r_LoopBck? mtxerr_pad_o : mrxerr_pad_i & RxEnSync;

// Muxed MII Receive Data
assign MRxD_Lb[3:0] = r_LoopBck? mtxd_pad_o[3:0] : mrxd_pad_i[3:0];



// Connecting TxEthMAC
eth_txethmac txethmac1
(
  .MTxClk(mtx_clk_pad_i),
  .Reset(wb_rst_i),
  .CarrierSense(TxCarrierSense),
  .Collision(Collision),
  .TxData(TxDataOut),
  .TxStartFrm(TxStartFrmOut),
  .TxUnderRun(TxUnderRun),
  .TxEndFrm(TxEndFrmOut),
  .Pad(PadOut),
  .MinFL(r_MinFL),
  .CrcEn(CrcEnOut),
  .FullD(r_FullD),
  .HugEn(r_HugEn),
  .DlyCrcEn(r_DlyCrcEn),
  .IPGT(r_IPGT),
  .IPGR1(r_IPGR1),
  .IPGR2(r_IPGR2),
  .CollValid(r_CollValid),
  .MaxRet(r_MaxRet),
  .NoBckof(r_NoBckof),
  .ExDfrEn(r_ExDfrEn),
  .MaxFL(r_MaxFL),
  .MTxEn(mtxen_pad_o),
  .MTxD(mtxd_pad_o),
  .MTxErr(mtxerr_pad_o),
  .TxUsedData(TxUsedDataIn),
  .TxDone(TxDoneIn),
  .TxRetry(TxRetry),
  .TxAbort(TxAbortIn),
  .WillTransmit(WillTransmit),
  .ResetCollision(ResetCollision),
  .RetryCnt(RetryCnt),
  .StartTxDone(StartTxDone),
  .StartTxAbort(StartTxAbort),
  .MaxCollisionOccured(MaxCollisionOccured),
  .LateCollision(LateCollision),
  .DeferIndication(DeferIndication),
  .StatePreamble(StatePreamble),
  .StateData(StateData)   
);




wire  [15:0]  RxByteCnt;
wire          RxByteCntEq0;
wire          RxByteCntGreat2;
wire          RxByteCntMaxFrame;
wire          RxCrcError;
wire          RxStateIdle;
wire          RxStatePreamble;
wire          RxStateSFD;
wire   [1:0]  RxStateData;
wire          AddressMiss;



// Connecting RxEthMAC
eth_rxethmac rxethmac1
(
  .MRxClk(mrx_clk_pad_i),
  .MRxDV(MRxDV_Lb),
  .MRxD(MRxD_Lb),
  .Transmitting(Transmitting),
  .HugEn(r_HugEn),
  .DlyCrcEn(r_DlyCrcEn),
  .MaxFL(r_MaxFL),
  .r_IFG(r_IFG),
  .Reset(wb_rst_i),
  .RxData(RxData),
  .RxValid(RxValid),
  .RxStartFrm(RxStartFrm),
  .RxEndFrm(RxEndFrm),
  .ByteCnt(RxByteCnt),
  .ByteCntEq0(RxByteCntEq0),
  .ByteCntGreat2(RxByteCntGreat2),
  .ByteCntMaxFrame(RxByteCntMaxFrame),
  .CrcError(RxCrcError),
  .StateIdle(RxStateIdle),
  .StatePreamble(RxStatePreamble),
  .StateSFD(RxStateSFD),
  .StateData(RxStateData),
  .MAC(r_MAC),
  .r_Pro(r_Pro),
  .r_Bro(r_Bro),
  .r_HASH0(r_HASH0),
  .r_HASH1(r_HASH1),
  .RxAbort(RxAbort),
  .AddressMiss(AddressMiss),
  .PassAll(r_PassAll),
  .ControlFrmAddressOK(ControlFrmAddressOK)
);


// MII Carrier Sense Synchronization
always @ (posedge mtx_clk_pad_i or posedge wb_rst_i)
begin
  if(wb_rst_i)
    begin
      CarrierSense_Tx1 <=  1'b0;
      CarrierSense_Tx2 <=  1'b0;
    end
  else
    begin
      CarrierSense_Tx1 <=  mcrs_pad_i;
      CarrierSense_Tx2 <=  CarrierSense_Tx1;
    end
end

assign TxCarrierSense = ~r_FullD & CarrierSense_Tx2;


// MII Collision Synchronization
always @ (posedge mtx_clk_pad_i or posedge wb_rst_i)
begin
  if(wb_rst_i)
    begin
      Collision_Tx1 <=  1'b0;
      Collision_Tx2 <=  1'b0;
    end
  else
    begin
      Collision_Tx1 <=  mcoll_pad_i;
      if(ResetCollision)
        Collision_Tx2 <=  1'b0;
      else
      if(Collision_Tx1)
        Collision_Tx2 <=  1'b1;
    end
end


// Synchronized Collision
assign Collision = ~r_FullD & Collision_Tx2;



// Delayed WillTransmit
always @ (posedge mrx_clk_pad_i)
begin
  WillTransmit_q <=  WillTransmit;
  WillTransmit_q2 <=  WillTransmit_q;
end 


assign Transmitting = ~r_FullD & WillTransmit_q2;



// Synchronized Receive Enable
always @ (posedge mrx_clk_pad_i or posedge wb_rst_i)
begin
  if(wb_rst_i)
    RxEnSync <=  1'b0;
  else
  if(~mrxdv_pad_i)
    RxEnSync <=  r_RxEn;
end 



// Synchronizing WillSendControlFrame to WB_CLK;
always @ (posedge wb_clk_i or posedge wb_rst_i)
begin
  if(wb_rst_i)
    WillSendControlFrame_sync1 <= 1'b0;
  else
    WillSendControlFrame_sync1 <= WillSendControlFrame;
end

always @ (posedge wb_clk_i or posedge wb_rst_i)
begin
  if(wb_rst_i)
    WillSendControlFrame_sync2 <= 1'b0;
  else
    WillSendControlFrame_sync2 <= WillSendControlFrame_sync1;
end

always @ (posedge wb_clk_i or posedge wb_rst_i)
begin
  if(wb_rst_i)
    WillSendControlFrame_sync3 <= 1'b0;
  else
    WillSendControlFrame_sync3 <= WillSendControlFrame_sync2;
end

always @ (posedge wb_clk_i or posedge wb_rst_i)
begin
  if(wb_rst_i)
    RstTxPauseRq <= 1'b0;
  else
    RstTxPauseRq <= WillSendControlFrame_sync2 & ~WillSendControlFrame_sync3;
end




// TX Pause request Synchronization
always @ (posedge mtx_clk_pad_i or posedge wb_rst_i)
begin
  if(wb_rst_i)
    begin
      TxPauseRq_sync1 <=  1'b0;
      TxPauseRq_sync2 <=  1'b0;
      TxPauseRq_sync3 <=  1'b0;
    end
  else
    begin
      TxPauseRq_sync1 <=  (r_TxPauseRq & r_TxFlow);
      TxPauseRq_sync2 <=  TxPauseRq_sync1;
      TxPauseRq_sync3 <=  TxPauseRq_sync2;
    end
end


always @ (posedge mtx_clk_pad_i or posedge wb_rst_i)
begin
  if(wb_rst_i)
    TPauseRq <=  1'b0;
  else
    TPauseRq <=  TxPauseRq_sync2 & (~TxPauseRq_sync3);
end


wire LatchedMRxErr;
reg RxAbort_latch;
reg RxAbort_sync1;
reg RxAbort_wb;
reg RxAbortRst_sync1;
reg RxAbortRst;

// Synchronizing RxAbort to the WISHBONE clock
always @ (posedge mrx_clk_pad_i or posedge wb_rst_i)
begin
  if(wb_rst_i)
    RxAbort_latch <=  1'b0;
  else if(RxAbort | (ShortFrame & ~r_RecSmall) | LatchedMRxErr &
          ~InvalidSymbol | (ReceivedPauseFrm & (~r_PassAll)))
    RxAbort_latch <=  1'b1;
  else if(RxAbortRst)
    RxAbort_latch <=  1'b0;
end

always @ (posedge wb_clk_i or posedge wb_rst_i)
begin
  if(wb_rst_i)
    begin
      RxAbort_sync1 <=  1'b0;
      RxAbort_wb    <=  1'b0;
      RxAbort_wb    <=  1'b0;
    end
  else
    begin
      RxAbort_sync1 <=  RxAbort_latch;
      RxAbort_wb    <=  RxAbort_sync1;
    end
end

always @ (posedge mrx_clk_pad_i or posedge wb_rst_i)
begin
  if(wb_rst_i)
    begin
      RxAbortRst_sync1 <=  1'b0;
      RxAbortRst       <=  1'b0;
    end
  else
    begin
      RxAbortRst_sync1 <=  RxAbort_wb;
      RxAbortRst       <=  RxAbortRst_sync1;
    end
end



// Connecting Wishbone module
eth_wishbone #(.TX_FIFO_DATA_WIDTH(TX_FIFO_DATA_WIDTH),
	       .TX_FIFO_DEPTH     (TX_FIFO_DEPTH),
	       .TX_FIFO_CNT_WIDTH (TX_FIFO_CNT_WIDTH),
	       .RX_FIFO_DATA_WIDTH(RX_FIFO_DATA_WIDTH),
	       .RX_FIFO_DEPTH     (RX_FIFO_DEPTH),
	       .RX_FIFO_CNT_WIDTH (RX_FIFO_CNT_WIDTH))
wishbone
(
  .WB_CLK_I(wb_clk_i),
  .WB_DAT_I(wb_dat_i),
  .WB_DAT_O(BD_WB_DAT_O),

  // WISHBONE slave
  .WB_ADR_I(wb_adr_i[9:2]),
  .WB_WE_I(wb_we_i),
  .BDCs(BDCs),
  .WB_ACK_O(BDAck),
  .Reset(wb_rst_i),

  // WISHBONE master
  .m_wb_adr_o(m_wb_adr_tmp),
  .m_wb_sel_o(m_wb_sel_o),
  .m_wb_we_o(m_wb_we_o),
  .m_wb_dat_i(m_wb_dat_i),
  .m_wb_dat_o(m_wb_dat_o),
  .m_wb_cyc_o(m_wb_cyc_o),
  .m_wb_stb_o(m_wb_stb_o),
  .m_wb_ack_i(m_wb_ack_i),
  .m_wb_err_i(m_wb_err_i),
  
  .m_wb_cti_o(m_wb_cti_o),
  .m_wb_bte_o(m_wb_bte_o), 

    //TX
  .MTxClk(mtx_clk_pad_i),
  .TxStartFrm(TxStartFrm),
  .TxEndFrm(TxEndFrm),
  .TxUsedData(TxUsedData),
  .TxData(TxData),
  .TxRetry(TxRetry),
  .TxAbort(TxAbort),
  .TxUnderRun(TxUnderRun),
  .TxDone(TxDone),
  .PerPacketCrcEn(PerPacketCrcEn),
  .PerPacketPad(PerPacketPad),

  // Register
  .r_TxEn(r_TxEn),
  .r_RxEn(r_RxEn),
  .r_TxBDNum(r_TxBDNum),
  .r_RxFlow(r_RxFlow),
  .r_PassAll(r_PassAll), 

  //RX
  .MRxClk(mrx_clk_pad_i),
  .RxData(RxData),
  .RxValid(RxValid),
  .RxStartFrm(RxStartFrm),
  .RxEndFrm(RxEndFrm),
  .Busy_IRQ(Busy_IRQ),
  .RxE_IRQ(RxE_IRQ),
  .RxB_IRQ(RxB_IRQ),
  .TxE_IRQ(TxE_IRQ),
  .TxB_IRQ(TxB_IRQ), 

  .RxAbort(RxAbort_wb),
  .RxStatusWriteLatched_sync2(RxStatusWriteLatched_sync2), 

  .InvalidSymbol(InvalidSymbol),
  .LatchedCrcError(LatchedCrcError),
  .RxLength(RxByteCnt),
  .RxLateCollision(RxLateCollision),
  .ShortFrame(ShortFrame),
  .DribbleNibble(DribbleNibble),
  .ReceivedPacketTooBig(ReceivedPacketTooBig),
  .LoadRxStatus(LoadRxStatus),
  .RetryCntLatched(RetryCntLatched),
  .RetryLimit(RetryLimit),
  .LateCollLatched(LateCollLatched),
  .DeferLatched(DeferLatched),
  .RstDeferLatched(RstDeferLatched),
  .CarrierSenseLost(CarrierSenseLost),
  .ReceivedPacketGood(ReceivedPacketGood),
  .AddressMiss(AddressMiss),
  .ReceivedPauseFrm(ReceivedPauseFrm)
  
`ifdef ETH_BIST
  ,
  .mbist_si_i       (mbist_si_i),
  .mbist_so_o       (mbist_so_o),
  .mbist_ctrl_i       (mbist_ctrl_i)
`endif
`ifdef WISHBONE_DEBUG
  ,
  .dbg_dat0(wb_dbg_dat0)
`endif

);

assign m_wb_adr_o = {m_wb_adr_tmp, 2'h0};

// Connecting MacStatus module
eth_macstatus macstatus1 
(
  .MRxClk(mrx_clk_pad_i),
  .Reset(wb_rst_i),
  .ReceiveEnd(ReceiveEnd),
  .ReceivedPacketGood(ReceivedPacketGood),
     .ReceivedLengthOK(ReceivedLengthOK),
  .RxCrcError(RxCrcError),
  .MRxErr(MRxErr_Lb),
  .MRxDV(MRxDV_Lb),
  .RxStateSFD(RxStateSFD),
  .RxStateData(RxStateData),
  .RxStatePreamble(RxStatePreamble),
  .RxStateIdle(RxStateIdle),
  .Transmitting(Transmitting),
  .RxByteCnt(RxByteCnt),
  .RxByteCntEq0(RxByteCntEq0),
  .RxByteCntGreat2(RxByteCntGreat2),
  .RxByteCntMaxFrame(RxByteCntMaxFrame),
  .InvalidSymbol(InvalidSymbol),
  .MRxD(MRxD_Lb),
  .LatchedCrcError(LatchedCrcError),
  .Collision(mcoll_pad_i),
  .CollValid(r_CollValid),
  .RxLateCollision(RxLateCollision),
  .r_RecSmall(r_RecSmall),
  .r_MinFL(r_MinFL),
  .r_MaxFL(r_MaxFL),
  .ShortFrame(ShortFrame),
  .DribbleNibble(DribbleNibble),
  .ReceivedPacketTooBig(ReceivedPacketTooBig),
  .r_HugEn(r_HugEn),
  .LoadRxStatus(LoadRxStatus),
  .RetryCnt(RetryCnt),
  .StartTxDone(StartTxDone),
  .StartTxAbort(StartTxAbort),
  .RetryCntLatched(RetryCntLatched),
  .MTxClk(mtx_clk_pad_i),
  .MaxCollisionOccured(MaxCollisionOccured),
  .RetryLimit(RetryLimit),
  .LateCollision(LateCollision),
  .LateCollLatched(LateCollLatched),
  .DeferIndication(DeferIndication),
  .DeferLatched(DeferLatched),
  .RstDeferLatched(RstDeferLatched),
  .TxStartFrm(TxStartFrmOut),
  .StatePreamble(StatePreamble),
  .StateData(StateData),
  .CarrierSense(CarrierSense_Tx2),
  .CarrierSenseLost(CarrierSenseLost),
  .TxUsedData(TxUsedDataIn),
  .LatchedMRxErr(LatchedMRxErr),
  .Loopback(r_LoopBck),
  .r_FullD(r_FullD)
);


// --- Formal assertions ---
// AssertionForge baseline SVA for ethernet
// 999 assertions captured from gen_plan.generate_svas





























































property af_p60;
@(posedge wb_clk_i) (wb_rst_i && $past(wb_rst_i)) |-> ($stable(int_o));
endproperty
assert property(af_p60);

property af_p61;
@(posedge wb_clk_i) (m_wb_err_i) |-> ##[1:$] (int_o == 1'b1);
endproperty
assert property(af_p61);

property af_p62;
@(posedge wb_clk_i) (mcoll_pad_i) |-> ##[1:4] (int_o == 1'b1);
endproperty
assert property(af_p62);

property af_p63;
@(posedge wb_clk_i) (mrxerr_pad_i) |-> ##1 (int_o == 1'b1);
endproperty
assert property(af_p63);

property af_p64;
@(posedge wb_clk_i) (mtxerr_pad_o) |-> ##[1:4] (int_o == 1'b1);
endproperty
assert property(af_p64);

property af_p65;
@(posedge wb_clk_i) (wb_rst_i) |-> (int_o == 1'b0);
endproperty
assert property(af_p65);

property af_p66;
@(posedge wb_clk_i) (int_o) |-> ($past(m_wb_ack_i));
endproperty
assert property(af_p66);


property af_p68;
@(posedge wb_clk_i) ($fell(wb_rst_i) && m_wb_err_i) |-> ##2 (int_o == 1'b1);
endproperty
assert property(af_p68);

property af_p69;
@(posedge wb_clk_i) (m_wb_err_i) |-> (int_o);
endproperty
assert property(af_p69);

property af_p70;
@(posedge wb_clk_i) (m_wb_ack_i) |-> ##[1:3] (!int_o);
endproperty
assert property(af_p70);

property af_p71;
@(posedge wb_clk_i) (wb_rst_i) |-> (!int_o);
endproperty
assert property(af_p71);

property af_p72;
@(posedge wb_clk_i) (!m_wb_cyc_o && !m_wb_stb_o) [*5] |-> (!int_o);
endproperty
assert property(af_p72);

property af_p73;
@(posedge wb_clk_i) (m_wb_err_i) |-> ##[1:2] (int_o);
endproperty
assert property(af_p73);

property af_p74;
@(posedge wb_clk_i) (mcoll_pad_i) |-> ##[1:$] (int_o);
endproperty
assert property(af_p74);

property af_p75;
@(posedge mtx_clk_pad_i) (mtxerr_pad_o) |-> ##[1:4] (int_o);
endproperty
assert property(af_p75);

property af_p76;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> ($stable(int_o));
endproperty
assert property(af_p76);

property af_p77;
@(posedge wb_clk_i) ($past(!mrxerr_pad_i) && !mrxerr_pad_i && $past(!mtxerr_pad_o) && !mtxerr_pad_o) |-> ($stable(int_o));
endproperty
assert property(af_p77);

property af_p78;
@(posedge wb_clk_i) (!m_wb_cyc_o && !m_wb_stb_o) |-> (!int_o);
endproperty
assert property(af_p78);

property af_p79;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:4] (int_o === 1'b0);
endproperty
assert property(af_p79);

property af_p80;
@(posedge wb_clk_i) $rose(int_o) |-> int_o throughout (m_wb_we_o)[->1];
endproperty
assert property(af_p80);

property af_p81;
@(posedge wb_clk_i) (!mrxerr_pad_i && !mtxerr_pad_o) |-> (int_o === 1'b0);
endproperty
assert property(af_p81);

property af_p82;
@(posedge wb_clk_i) $rose(mrxerr_pad_i) |=> (int_o === 1'b1);
endproperty
assert property(af_p82);

property af_p83;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> !int_o [*4];
endproperty
assert property(af_p83);

property af_p84;
@(posedge wb_rst_i) wb_rst_i |-> !int_o;
endproperty
assert property(af_p84);

property af_p85;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (int_o === 1'b0 || int_o === 1'b1);
endproperty
assert property(af_p85);

property af_p86;
@(posedge wb_clk_i) $rose(int_o) |-> int_o throughout (wb_dat_i != 0)[->1];
endproperty
assert property(af_p86);

property af_p87;
@(posedge mrx_clk_pad_i) mrxerr_pad_i |=> (int_o === 1'b1);
endproperty
assert property(af_p87);

property af_p88;
@(posedge wb_clk_i) (m_wb_err_i && m_wb_cyc_o) |-> ##[1:2] (int_o === 1'b1);
endproperty
assert property(af_p88);

property af_p89;
@(posedge wb_clk_i) m_wb_ack_i |-> (m_wb_cyc_o && m_wb_stb_o) || ($past(m_wb_cyc_o) && $past(m_wb_stb_o));
endproperty
assert property(af_p89);

property af_p90;
@(posedge wb_clk_i) not (m_wb_ack_i && m_wb_err_i);
endproperty
assert property(af_p90);

property af_p91;
@(posedge wb_clk_i) m_wb_ack_i |-> !m_wb_err_i;
endproperty
assert property(af_p91);

property af_p92;
@(posedge wb_clk_i) (m_wb_ack_i && m_wb_we_o) |-> m_wb_we_o;
endproperty
assert property(af_p92);

property af_p93;
@(posedge wb_clk_i) (m_wb_ack_i |-> m_wb_cyc_o) and ($fell(m_wb_cyc_o) |-> !m_wb_ack_i);
endproperty
assert property(af_p93);

property af_p94;
@(posedge wb_clk_i) m_wb_stb_o |-> ##[1:$] m_wb_ack_i;
endproperty
assert property(af_p94);

property af_p95;
@(posedge wb_clk_i) m_wb_ack_i |=> !m_wb_ack_i;
endproperty
assert property(af_p95);

property af_p96;
@(posedge wb_clk_i) m_wb_ack_i |-> (m_wb_cyc_o || $past(m_wb_cyc_o));
endproperty
assert property(af_p96);

property af_p97;
@(posedge wb_clk_i) (m_wb_ack_i && !m_wb_we_o) |-> $stable(m_wb_dat_i);
endproperty
assert property(af_p97);

property af_p98;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> !m_wb_ack_i;
endproperty
assert property(af_p98);

property af_p99;
@(posedge wb_clk_i) !(m_wb_ack_i && m_wb_err_i);
endproperty
assert property(af_p99);

property af_p100;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> !m_wb_ack_i;
endproperty
assert property(af_p100);

property af_p101;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> !m_wb_ack_i throughout (!m_wb_cyc_o)[->1];
endproperty
assert property(af_p101);

property af_p102;
@(posedge wb_clk_i) wb_rst_i |-> !m_wb_ack_i;
endproperty
assert property(af_p102);

property af_p103;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> !m_wb_ack_i ##1 !m_wb_ack_i;
endproperty
assert property(af_p103);

property af_p104;
@(posedge wb_clk_i) m_wb_ack_i |-> ##1 (m_wb_adr_o == $past(m_wb_adr_o)) throughout (##[0:$] !m_wb_ack_i);
endproperty
assert property(af_p104);

property af_p105;
@(posedge wb_clk_i) $rose(m_wb_ack_i) |=> !m_wb_stb_o;
endproperty
assert property(af_p105);

property af_p106;
@(posedge wb_clk_i) !m_wb_cyc_o |-> !m_wb_ack_i;
endproperty
assert property(af_p106);

property af_p107;
@(posedge wb_clk_i) (m_wb_ack_i && !m_wb_we_o) |-> ($stable(m_wb_dat_i) || 1'b1);
endproperty
assert property(af_p107);

property af_p108;
@(posedge wb_clk_i) $rose(m_wb_ack_i) |=> !m_wb_ack_i;
endproperty
assert property(af_p108);

property af_p109;
@(posedge wb_clk_i) $changed(m_wb_adr_o) |-> $past(m_wb_ack_i);
endproperty
assert property(af_p109);

property af_p110;
@(posedge wb_clk_i) m_wb_ack_i |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p110);

property af_p111;
@(posedge wb_clk_i) m_wb_ack_i |-> (m_wb_cyc_o && m_wb_stb_o);
endproperty
assert property(af_p111);

property af_p112;
@(posedge wb_clk_i) (m_wb_ack_i && !m_wb_cyc_o) |=> !m_wb_ack_i;
endproperty
assert property(af_p112);

property af_p113;
@(posedge wb_clk_i) m_wb_ack_i |-> !$isunknown(m_wb_dat_i);
endproperty
assert property(af_p113);

property af_p114;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> !m_wb_ack_i;
endproperty
assert property(af_p114);

property af_p115;
@(posedge wb_clk_i) (m_wb_ack_i && !m_wb_stb_o) |=> !m_wb_stb_o;
endproperty
assert property(af_p115);

property af_p116;
@(posedge wb_clk_i) m_wb_ack_i <-> (m_wb_cyc_o && m_wb_stb_o);
endproperty
assert property(af_p116);

property af_p117;
@(posedge wb_clk_i) (m_wb_ack_i && m_wb_we_o) |-> $stable(m_wb_dat_o);
endproperty
assert property(af_p117);

property af_p118;
@(posedge wb_clk_i) $fell(m_wb_cyc_o) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p118);

property af_p119;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (m_wb_adr_o == '0);
endproperty
assert property(af_p119);

property af_p120;
@(posedge wb_clk_i) m_wb_stb_o |-> !$isunknown(m_wb_adr_o);
endproperty
assert property(af_p120);

property af_p121;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o && !m_wb_ack_i) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p121);

property af_p122;
@(posedge wb_clk_i) (m_wb_cti_o == 3'b010) |-> (m_wb_adr_o == ($past(m_wb_adr_o) + 1));
endproperty
assert property(af_p122);

property af_p123;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 (m_wb_adr_o != '0);
endproperty
assert property(af_p123);

property af_p124;
@(posedge wb_clk_i) wb_rst_i |-> (m_wb_adr_o == '0);
endproperty
assert property(af_p124);

property af_p125;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_ack_i) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p125);

property af_p126;
@(posedge wb_clk_i) $rose(wb_rst_i == 0) |-> !$isunknown(m_wb_adr_o);
endproperty
assert property(af_p126);

property af_p127;
@(posedge wb_clk_i) $changed(m_wb_we_o) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p127);

property af_p128;
@(posedge wb_clk_i) $rose(m_wb_err_i) |=> (m_wb_adr_o == $past(m_wb_adr_o)) throughout (m_wb_cyc_o[*1:$] ##1 !m_wb_cyc_o);
endproperty
assert property(af_p128);


property af_p130;
@(posedge wb_clk_i) (m_wb_cti_o == 3'b010) |=> (m_wb_adr_o == ($past(m_wb_adr_o) + 4));
endproperty
assert property(af_p130);

property af_p131;
@(posedge wb_clk_i) $past(!wb_rst_i, 4) |-> !$isunknown(m_wb_adr_o);
endproperty
assert property(af_p131);

property af_p132;
@(posedge wb_clk_i) $rose(m_wb_ack_i) |-> $stable(m_wb_adr_o) throughout(1);
endproperty
assert property(af_p132);

property af_p133;
@(posedge wb_clk_i) $changed(m_wb_adr_o) |-> $rose(wb_clk_i);
endproperty
assert property(af_p133);

property af_p134;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p134);

property af_p135;
@(posedge wb_clk_i) (m_wb_ack_i) |=> 1'b1;
endproperty
assert property(af_p135);

property af_p136;
@(posedge wb_clk_i) (m_wb_err_i) |=> $stable(m_wb_adr_o);
endproperty
assert property(af_p136);

property af_p137;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p137);

property af_p138;
@(posedge wb_clk_i) (m_wb_ack_i) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p138);

property af_p139;
@(posedge wb_clk_i) (m_wb_we_o) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p139);

property af_p140;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> (m_wb_adr_o == '0) ##1 (m_wb_adr_o == '0);
endproperty
assert property(af_p140);

property af_p141;
@(posedge wb_clk_i) (m_wb_sel_o != 4'b0000) |-> ((m_wb_adr_o[1:0] & ~m_wb_sel_o[1:0]) == 2'b00);
endproperty
assert property(af_p141);

property af_p142;
@(posedge wb_clk_i) ((m_wb_bte_o inside {[0:3]}) && m_wb_cyc_o) |=> (m_wb_bte_o inside {[0:3]});
endproperty
assert property(af_p142);

property af_p143;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (m_wb_bte_o inside {[0:3]})[*3];
endproperty
assert property(af_p143);

property af_p144;
@(posedge wb_clk_i) m_wb_bte_o == 0;
endproperty
assert property(af_p144);

property af_p145;
@(posedge wb_clk_i) m_wb_stb_o |-> (m_wb_bte_o == 0)[*2];
endproperty
assert property(af_p145);

property af_p146;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> m_wb_bte_o == 0;
endproperty
assert property(af_p146);

property af_p147;
@(posedge wb_clk_i) $rose(m_wb_cyc_o) |=> $stable(m_wb_bte_o);
endproperty
assert property(af_p147);

property af_p148;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (m_wb_bte_o == 0)[*4];
endproperty
assert property(af_p148);

property af_p149;
@(posedge wb_clk_i) (m_wb_bte_o inside {[0:3]}) |-> (m_wb_cyc_o |=> (m_wb_bte_o inside {[0:3]}));
endproperty
assert property(af_p149);

property af_p150;
@(posedge wb_clk_i) (m_wb_cti_o == 3'b010) |=> $stable(m_wb_bte_o);
endproperty
assert property(af_p150);

property af_p151;
@(posedge wb_clk_i) !m_wb_stb_o |-> $stable(m_wb_bte_o);
endproperty
assert property(af_p151);

property af_p152;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] (m_wb_bte_o inside {[0:3]});
endproperty
assert property(af_p152);

property af_p153;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o) |-> $stable(m_wb_bte_o);
endproperty
assert property(af_p153);

property af_p154;
@(posedge wb_clk_i) m_wb_err_i |-> ##[1:2] (m_wb_bte_o == 2'b00);
endproperty
assert property(af_p154);

property af_p155;
@(posedge wb_clk_i) m_wb_stb_o |-> (m_wb_bte_o inside {[0:3]});
endproperty
assert property(af_p155);

property af_p156;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_ack_i) |=> $stable(m_wb_bte_o);
endproperty
assert property(af_p156);

property af_p157;
@(posedge wb_clk_i) (m_wb_cti_o == 3'b010) |-> (m_wb_bte_o inside {[0:3]});
endproperty
assert property(af_p157);

property af_p158;
@(posedge wb_clk_i) (m_wb_cti_o == 3'b010) |=> (m_wb_bte_o inside {[0:3]});
endproperty
assert property(af_p158);

property af_p159;
@(posedge wb_clk_i) $changed(m_wb_adr_o) |-> (m_wb_bte_o inside {[0:3]});
endproperty
assert property(af_p159);

property af_p160;
@(posedge wb_clk_i) m_wb_ack_i |=> (m_wb_bte_o inside {[0:3]});
endproperty
assert property(af_p160);

property af_p161;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:2] (m_wb_bte_o == 0);
endproperty
assert property(af_p161);

property af_p162;
@(posedge wb_clk_i) ($changed(m_wb_we_o)) |-> (m_wb_bte_o == 0);
endproperty
assert property(af_p162);

property af_p163;
@(posedge wb_clk_i) (m_wb_cyc_o && $past(m_wb_cyc_o)) |-> ($stable(m_wb_bte_o));
endproperty
assert property(af_p163);

property af_p164;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> (m_wb_bte_o == 0);
endproperty
assert property(af_p164);

property af_p165;
@(posedge wb_clk_i) (wb_rst_i) |=> (m_wb_bte_o == 0);
endproperty
assert property(af_p165);

property af_p166;
@(posedge wb_clk_i) (!wb_rst_i) |-> (m_wb_bte_o >= 0) && (m_wb_bte_o <= 3);
endproperty
assert property(af_p166);

property af_p167;
@(posedge wb_clk_i) (m_wb_we_o && $past(m_wb_we_o)) |-> ($stable(m_wb_bte_o));
endproperty
assert property(af_p167);

property af_p168;
@(posedge wb_clk_i) (m_wb_ack_i) |-> ($stable(m_wb_bte_o));
endproperty
assert property(af_p168);

property af_p169;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_cyc_o) |-> (m_wb_bte_o >= 0) && (m_wb_bte_o <= 3);
endproperty
assert property(af_p169);

property af_p170;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 (m_wb_bte_o >= 0) && (m_wb_bte_o <= 3);
endproperty
assert property(af_p170);

property af_p171;
@(posedge wb_clk_i) (m_wb_ack_i) |-> ##1 (m_wb_cti_o >= 0 && m_wb_cti_o <= 7);
endproperty
assert property(af_p171);

property af_p172;
@(posedge wb_clk_i) (m_wb_cti_o == 3'b000) |-> (m_wb_cyc_o && m_wb_stb_o);
endproperty
assert property(af_p172);

property af_p173;
@(posedge wb_clk_i) (m_wb_cyc_o && ($past(m_wb_adr_o) + 1 == m_wb_adr_o)) |-> (m_wb_cti_o == 3'b010);
endproperty
assert property(af_p173);

property af_p174;
@(posedge wb_clk_i) (m_wb_we_o && m_wb_cyc_o) |-> ($stable(m_wb_cti_o));
endproperty
assert property(af_p174);

property af_p175;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> ((m_wb_cti_o >= 0 && m_wb_cti_o <= 7) && (m_wb_bte_o >= 0 && m_wb_bte_o <= 3));
endproperty
assert property(af_p175);

property af_p176;
@(posedge wb_clk_i) (wb_rst_i) |-> ##1 (m_wb_cti_o == 3'b000);
endproperty
assert property(af_p176);

property af_p177;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> ##1 (m_wb_cti_o == 3'b000);
endproperty
assert property(af_p177);

property af_p178;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (m_wb_cti_o == 3'b000);
endproperty
assert property(af_p178);

property af_p179;
@(posedge wb_clk_i) disable iff(0) (m_wb_cti_o >= 0 && m_wb_cti_o <= 7);
endproperty
assert property(af_p179);

property af_p180;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> (m_wb_cti_o >= 0 && m_wb_cti_o <= 7);
endproperty
assert property(af_p180);

property af_p181;
@(posedge wb_clk_i) (m_wb_stb_o) |-> (m_wb_cti_o >= 0 && m_wb_cti_o <= 7);
endproperty
assert property(af_p181);

property af_p182;
@(posedge wb_clk_i) ($past(m_wb_adr_o) < m_wb_adr_o) |-> (m_wb_cti_o == 3'b010);
endproperty
assert property(af_p182);

property af_p183;
@(posedge wb_clk_i) ($past(m_wb_adr_o) + 1 == m_wb_adr_o) |-> (m_wb_cti_o == 3'b010);
endproperty
assert property(af_p183);

property af_p184;
@(posedge wb_clk_i) ($past(m_wb_cyc_o) && !m_wb_cyc_o) |-> (m_wb_cti_o == 3'b000);
endproperty
assert property(af_p184);

property af_p185;
@(posedge wb_clk_i) (m_wb_stb_o && !m_wb_ack_i) |=> $stable(m_wb_cti_o);
endproperty
assert property(af_p185);

property af_p186;
@(posedge wb_clk_i) (!wb_rst_i) |-> (m_wb_cti_o inside {[0:7]});
endproperty
assert property(af_p186);

property af_p187;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_ack_i) ##1 (!m_wb_cyc_o) |-> ($past(m_wb_cti_o) == 3'b111);
endproperty
assert property(af_p187);

property af_p188;
@(posedge wb_clk_i) (m_wb_cti_o == 3'b111) |-> ##1 (!m_wb_stb_o);
endproperty
assert property(af_p188);

property af_p189;
@(posedge wb_clk_i) ($past(m_wb_err_i)) |-> $stable(m_wb_cti_o);
endproperty
assert property(af_p189);

property af_p190;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_ack_i) |-> $stable(m_wb_cti_o);
endproperty
assert property(af_p190);

property af_p191;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_cyc_o) |-> (m_wb_cti_o inside {[0:7]});
endproperty
assert property(af_p191);

property af_p192;
@(posedge wb_clk_i) (m_wb_cyc_o && (m_wb_we_o != $past(m_wb_we_o))) |-> $stable(m_wb_cti_o);
endproperty
assert property(af_p192);

property af_p193;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o && (m_wb_cti_o == 3'b010)) |=> (m_wb_cti_o == 3'b010);
endproperty
assert property(af_p193);

property af_p194;
@(posedge wb_clk_i) (m_wb_err_i && m_wb_cyc_o) |=> ($stable(m_wb_cti_o));
endproperty
assert property(af_p194);

property af_p195;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_ack_i) |=> (!m_wb_cyc_o |-> m_wb_cti_o == 3'b111);
endproperty
assert property(af_p195);

property af_p196;
@(posedge wb_clk_i) (m_wb_we_o) |-> (m_wb_cti_o inside {[3'b000:3'b111]});
endproperty
assert property(af_p196);

property af_p197;
@(posedge wb_clk_i) (m_wb_stb_o && !m_wb_ack_i) |=> ($stable(m_wb_cti_o));
endproperty
assert property(af_p197);

property af_p198;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 (m_wb_cti_o inside {[3'b000:3'b111]});
endproperty
assert property(af_p198);

property af_p199;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> (m_wb_cti_o == 3'b000);
endproperty
assert property(af_p199);

property af_p200;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> (m_wb_cti_o == 3'b000);
endproperty
assert property(af_p200);

property af_p201;
@(posedge wb_clk_i) $fell(m_wb_cyc_o) |=> (m_wb_cti_o == 3'b000);
endproperty
assert property(af_p201);

property af_p202;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> (m_wb_cti_o == 3'b000)[*3];
endproperty
assert property(af_p202);

property af_p203;
@(posedge wb_clk_i) $changed(m_wb_adr_o) |-> m_wb_cyc_o;
endproperty
assert property(af_p203);

property af_p204;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_ack_i) |-> !m_wb_cyc_o;
endproperty
assert property(af_p204);

property af_p205;
@(posedge wb_clk_i) m_wb_cyc_o |-> (m_wb_cyc_o throughout (!m_wb_ack_i && !m_wb_err_i)[*0:$] ##1 (m_wb_ack_i || m_wb_err_i));
endproperty
assert property(af_p205);

property af_p206;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> $stable(m_wb_cyc_o);
endproperty
assert property(af_p206);

property af_p207;
@(posedge wb_clk_i) wb_rst_i |=> !m_wb_cyc_o;
endproperty
assert property(af_p207);

property af_p208;
@(posedge wb_clk_i) m_wb_cyc_o |-> !$isunknown(m_wb_adr_o);
endproperty
assert property(af_p208);

property af_p209;
@(posedge wb_clk_i) wb_rst_i |-> !m_wb_cyc_o;
endproperty
assert property(af_p209);

property af_p210;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_we_o) |-> (m_wb_cyc_o && m_wb_we_o) throughout (!m_wb_ack_i)[*0:$] ##1 m_wb_ack_i;
endproperty
assert property(af_p210);

property af_p211;
@(posedge wb_clk_i) (m_wb_cyc_o && (m_wb_cti_o == 3'b010) && !m_wb_ack_i) |=> m_wb_cyc_o;
endproperty
assert property(af_p211);

property af_p212;
@(posedge wb_clk_i) ($rose(m_wb_cyc_o) && m_wb_we_o) |-> (m_wb_cyc_o && m_wb_we_o);
endproperty
assert property(af_p212);

property af_p213;
@(posedge wb_clk_i) (m_wb_cyc_o && (m_wb_cti_o == 3'b010)) |=> (m_wb_cyc_o throughout (m_wb_cti_o == 3'b010)[*1:$]);
endproperty
assert property(af_p213);

property af_p214;
@(posedge wb_clk_i) ($fell(wb_rst_i) && m_wb_cyc_o) |-> (m_wb_cyc_o [*3]);
endproperty
assert property(af_p214);

property af_p215;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_ack_i) |-> (m_wb_cyc_o == 1'b0);
endproperty
assert property(af_p215);

property af_p216;
@(posedge wb_clk_i) ($rose(wb_rst_i)) |=> (m_wb_cyc_o == 1'b0);
endproperty
assert property(af_p216);

property af_p217;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> (m_wb_stb_o);
endproperty
assert property(af_p217);

property af_p218;
@(posedge wb_clk_i) (m_wb_cyc_o && (m_wb_bte_o != 2'b00)) |-> ##1 (m_wb_cyc_o == $past(m_wb_cyc_o));
endproperty
assert property(af_p218);

property af_p219;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_err_i) |=> (m_wb_cyc_o || $past(m_wb_err_i));
endproperty
assert property(af_p219);

property af_p220;
@(posedge wb_clk_i) (m_wb_cyc_o && (m_wb_cti_o == 3'b010)) |-> ##1 m_wb_cyc_o;
endproperty
assert property(af_p220);

property af_p221;
@(posedge wb_clk_i) m_wb_stb_o |-> m_wb_cyc_o;
endproperty
assert property(af_p221);

property af_p222;
@(posedge wb_clk_i) m_wb_err_i |=> !m_wb_cyc_o;
endproperty
assert property(af_p222);

property af_p223;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> !m_wb_cyc_o;
endproperty
assert property(af_p223);

property af_p224;
@(posedge wb_clk_i) $rose(m_wb_cyc_o) |-> m_wb_cyc_o throughout (!m_wb_ack_i)[*0:$] ##1 m_wb_ack_i;
endproperty
assert property(af_p224);

property af_p225;
@(posedge wb_clk_i) ((m_wb_dat_i >= 100) && (m_wb_dat_i <= 150)) |-> ##1 ((m_wb_dat_i >= 80) && (m_wb_dat_i <= 170));
endproperty
assert property(af_p225);

property af_p226;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 255))[*5];
endproperty
assert property(af_p226);

property af_p227;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o && !m_wb_we_o) |-> ##1 ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 255));
endproperty
assert property(af_p227);

property af_p228;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o) |-> ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 255));
endproperty
assert property(af_p228);

property af_p229;
@(posedge wb_clk_i) (m_wb_err_i) |-> (1'b1);
endproperty
assert property(af_p229);

property af_p230;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((m_wb_dat_i >= 50) && (m_wb_dat_i <= 200));
endproperty
assert property(af_p230);

property af_p231;
@(posedge wb_clk_i) $rose(m_wb_err_i) |-> ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 255)) ##1 ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 255));
endproperty
assert property(af_p231);

property af_p232;
@(posedge wb_clk_i) ((m_wb_dat_i >= 200) && (m_wb_dat_i <= 255)) |-> ##1 ((m_wb_dat_i >= 175) && (m_wb_dat_i <= 255));
endproperty
assert property(af_p232);

property af_p233;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 255));
endproperty
assert property(af_p233);

property af_p234;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 255));
endproperty
assert property(af_p234);

property af_p235;
@(posedge wb_clk_i) $rose(m_wb_cyc_o) |-> ##[0:$] ((m_wb_dat_i >= 50) && (m_wb_dat_i <= 200));
endproperty
assert property(af_p235);

property af_p236;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 (m_wb_dat_i >= 0) && (m_wb_dat_i <= 60);
endproperty
assert property(af_p236);

property af_p237;
@(posedge wb_clk_i) (!m_wb_we_o && m_wb_ack_i) |-> ##1 (m_wb_dat_i >= 0) && (m_wb_dat_i <= 255);
endproperty
assert property(af_p237);

property af_p238;
@(posedge wb_clk_i) ((m_wb_dat_i >= 200) && (m_wb_dat_i <= 255)) |-> ##1 ((m_wb_dat_i >= 180) && (m_wb_dat_i <= 255));
endproperty
assert property(af_p238);

property af_p239;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 (m_wb_dat_i >= 0) && (m_wb_dat_i <= 100);
endproperty
assert property(af_p239);

property af_p240;
@(posedge wb_clk_i) (!m_wb_ack_i) |-> $stable(m_wb_dat_i) throughout (!m_wb_ack_i)[*1:$] ##1 $rose(m_wb_ack_i);
endproperty
assert property(af_p240);

property af_p241;
@(posedge wb_clk_i) (!wb_rst_i) |-> (m_wb_dat_i >= 0) && (m_wb_dat_i <= 255);
endproperty
assert property(af_p241);

property af_p242;
@(posedge wb_clk_i) (!m_wb_ack_i && !m_wb_err_i) |-> $stable(m_wb_dat_i);
endproperty
assert property(af_p242);

property af_p243;
@(posedge wb_clk_i) (m_wb_adr_o) |-> $stable(m_wb_dat_i) throughout (!m_wb_ack_i)[*0:$] ##1 m_wb_ack_i;
endproperty
assert property(af_p243);

property af_p244;
@(posedge wb_clk_i) (m_wb_ack_i) |-> $stable(m_wb_dat_i);
endproperty
assert property(af_p244);

property af_p245;
@(posedge wb_clk_i) ((m_wb_dat_i >= 10) && (m_wb_dat_i <= 50)) |=> ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 70));
endproperty
assert property(af_p245);

property af_p246;
@(posedge wb_clk_i) (m_wb_ack_i) |-> ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 255)) && $stable(m_wb_dat_i);
endproperty
assert property(af_p246);

property af_p247;
@(posedge wb_clk_i) ((m_wb_dat_i >= 120) && (m_wb_dat_i <= 160)) |=> ((m_wb_dat_i >= 90) && (m_wb_dat_i <= 160));
endproperty
assert property(af_p247);

property af_p248;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_dat_i == 0);
endproperty
assert property(af_p248);

property af_p249;
@(posedge wb_clk_i) ((m_wb_cyc_o && m_wb_stb_o && !m_wb_we_o) && m_wb_ack_i) |-> ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 255));
endproperty
assert property(af_p249);

property af_p250;
@(posedge wb_clk_i) ($changed(m_wb_adr_o)) |=> ##1 ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 255));
endproperty
assert property(af_p250);

property af_p251;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 255));
endproperty
assert property(af_p251);

property af_p252;
@(posedge wb_clk_i) ((m_wb_dat_i >= 100) && (m_wb_dat_i <= 150)) |=> ((m_wb_dat_i >= 75) && (m_wb_dat_i <= 175));
endproperty
assert property(af_p252);

property af_p253;
@(posedge wb_clk_i) (((m_wb_dat_i >= 10) && (m_wb_dat_i <= 90)) && $fell(m_wb_ack_i)) |=> ((m_wb_dat_i >= 0) && (m_wb_dat_i <= 120));
endproperty
assert property(af_p253);

property af_p254;
@(posedge wb_clk_i) (wb_rst_i) |=> (m_wb_dat_o == 0);
endproperty
assert property(af_p254);

property af_p255;
@(posedge wb_clk_i) ($stable(m_wb_bte_o)) |-> !($past(m_wb_dat_o) !== m_wb_dat_o && $isunknown(m_wb_dat_o) && $isunknown($past(m_wb_dat_o)));
endproperty
assert property(af_p255);

property af_p256;
@(posedge wb_clk_i) (m_wb_ack_i) |-> ($stable(m_wb_dat_o));
endproperty
assert property(af_p256);

property af_p257;
@(posedge wb_clk_i) (!m_wb_we_o && m_wb_cyc_o) |-> (m_wb_dat_o >= 0) && (m_wb_dat_o <= 255);
endproperty
assert property(af_p257);

property af_p258;
@(posedge wb_clk_i) (wb_rst_i) |=> (m_wb_dat_o == 0) throughout (!(m_wb_we_o && m_wb_cyc_o && m_wb_stb_o))[*1:$];
endproperty
assert property(af_p258);

property af_p259;
@(posedge wb_clk_i) ((m_wb_dat_o >= 0) && (m_wb_dat_o <= 255)) |=> ((m_wb_dat_o >= 0) && (m_wb_dat_o <= 255));
endproperty
assert property(af_p259);

property af_p260;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> ($stable(m_wb_dat_o));
endproperty
assert property(af_p260);

property af_p261;
@(posedge wb_clk_i) (m_wb_we_o && m_wb_cyc_o && m_wb_stb_o) |-> ($stable(m_wb_dat_o) throughout (!m_wb_ack_i)[*0:$] ##0 m_wb_ack_i);
endproperty
assert property(af_p261);

property af_p262;
@(posedge wb_clk_i) (m_wb_cti_o == 3'b010) |-> ($stable(m_wb_dat_o));
endproperty
assert property(af_p262);

property af_p263;
@(posedge wb_clk_i) (m_wb_we_o && (m_wb_dat_o >= 100) && (m_wb_dat_o <= 200)) |=> ((m_wb_dat_o >= 80) && (m_wb_dat_o <= 220));
endproperty
assert property(af_p263);

property af_p264;
@(posedge wb_clk_i) (m_wb_ack_i) |-> (m_wb_dat_o >= 0) && (m_wb_dat_o <= 255);
endproperty
assert property(af_p264);

property af_p265;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_cyc_o) |-> (!$stable(m_wb_dat_o) || $isunknown($past(m_wb_dat_o)));
endproperty
assert property(af_p265);

property af_p266;
@(posedge wb_clk_i) (!m_wb_we_o) |-> ($stable(m_wb_dat_o));
endproperty
assert property(af_p266);

property af_p267;
@(posedge wb_clk_i) (!m_wb_stb_o) |-> $stable(m_wb_dat_o);
endproperty
assert property(af_p267);

property af_p268;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o) |-> (m_wb_dat_o >= 0 && m_wb_dat_o <= 255);
endproperty
assert property(af_p268);

property af_p269;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o) |-> (m_wb_dat_o >= 0 && m_wb_dat_o <= 255) && $stable(m_wb_dat_o);
endproperty
assert property(af_p269);

property af_p270;
@(posedge wb_clk_i) (m_wb_err_i) |-> (m_wb_dat_o == $past(m_wb_dat_o));
endproperty
assert property(af_p270);

property af_p271;
@(posedge wb_clk_i) (m_wb_err_i && m_wb_we_o) |-> (m_wb_dat_o == $past(m_wb_dat_o));
endproperty
assert property(af_p271);

property af_p272;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (m_wb_dat_o == 0);
endproperty
assert property(af_p272);

property af_p273;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_we_o) |-> (m_wb_dat_o == m_wb_adr_o);
endproperty
assert property(af_p273);

property af_p274;
@(posedge wb_clk_i) (m_wb_we_o && m_wb_cyc_o) |-> (m_wb_dat_o !== 'x);
endproperty
assert property(af_p274);

property af_p275;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (m_wb_dat_o >= 0 && m_wb_dat_o <= 255);
endproperty
assert property(af_p275);

property af_p276;
@(posedge wb_clk_i) $rose(m_wb_cyc_o) |-> ##[1:2] $stable(m_wb_dat_o);
endproperty
assert property(af_p276);

property af_p277;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (m_wb_dat_o >= 0 && m_wb_dat_o <= 255);
endproperty
assert property(af_p277);

property af_p278;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 $stable(m_wb_dat_o);
endproperty
assert property(af_p278);

property af_p279;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> $stable(m_wb_dat_o);
endproperty
assert property(af_p279);

property af_p280;
@(posedge wb_clk_i) (!(m_wb_stb_o && m_wb_ack_i)) |-> $stable(m_wb_dat_o);
endproperty
assert property(af_p280);

property af_p281;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] ((m_wb_dat_o >= 0) && (m_wb_dat_o <= 255));
endproperty
assert property(af_p281);

property af_p282;
@(posedge wb_clk_i) (!m_wb_we_o) |-> $stable(m_wb_dat_o);
endproperty
assert property(af_p282);

property af_p283;
@(posedge wb_clk_i) (!m_wb_ack_i) |-> $stable(m_wb_dat_o);
endproperty
assert property(af_p283);

property af_p284;
@(posedge wb_clk_i) (m_wb_we_o) |-> ( (!m_wb_sel_o[0] || !$isunknown(m_wb_dat_o[7:0])) && (!m_wb_sel_o[1] || !$isunknown(m_wb_dat_o[15:8])) && (!m_wb_sel_o[2] || !$isunknown(m_wb_dat_o[23:16])) && (!m_wb_sel_o[3] || !$isunknown(m_wb_dat_o[31:24])) );
endproperty
assert property(af_p284);

property af_p285;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((m_wb_dat_o >= 0) && (m_wb_dat_o <= 255));
endproperty
assert property(af_p285);

property af_p286;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_we_o) |-> ((m_wb_dat_o >= 0) && (m_wb_dat_o <= 255));
endproperty
assert property(af_p286);

property af_p287;
@(posedge wb_clk_i) $rose(m_wb_we_o) |-> ##1 ((m_wb_dat_o >= 0) && (m_wb_dat_o <= 255));
endproperty
assert property(af_p287);

property af_p288;
@(posedge wb_clk_i) (|m_wb_sel_o) |-> ((m_wb_dat_o >= 0) && (m_wb_dat_o <= 255));
endproperty
assert property(af_p288);

property af_p289;
@(posedge wb_clk_i) ($fell(wb_rst_i) && m_wb_stb_o) |=> ((m_wb_dat_o >= 0) && (m_wb_dat_o <= 255));
endproperty
assert property(af_p289);

property af_p290;
@(posedge wb_clk_i) (m_wb_we_o && (m_wb_dat_o >= 100) && (m_wb_dat_o <= 200)) |=> ((m_wb_dat_o >= 90) && (m_wb_dat_o <= 210));
endproperty
assert property(af_p290);

property af_p291;
@(posedge wb_clk_i) $rose(m_wb_err_i) |=> !m_wb_err_i;
endproperty
assert property(af_p291);

property af_p292;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> (!m_wb_err_i)[*2];
endproperty
assert property(af_p292);

property af_p293;
@(posedge wb_clk_i) (!m_wb_stb_o) |-> (m_wb_err_i == 1'b0);
endproperty
assert property(af_p293);

property af_p294;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> (!m_wb_err_i)[*2];
endproperty
assert property(af_p294);

property af_p295;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_err_i) |=> !m_wb_stb_o;
endproperty
assert property(af_p295);

property af_p296;
@(posedge wb_clk_i) $rose(m_wb_err_i) |=> (m_wb_adr_o == $past(m_wb_adr_o));
endproperty
assert property(af_p296);

property af_p297;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_cyc_o) |=> !$isunknown(m_wb_err_i);
endproperty
assert property(af_p297);

property af_p298;
@(posedge wb_clk_i) (wb_rst_i) |=> (m_wb_err_i == 1'b0);
endproperty
assert property(af_p298);

property af_p299;
@(posedge wb_clk_i) $rose(m_wb_err_i) |=> !m_wb_cyc_o;
endproperty
assert property(af_p299);

property af_p300;
@(posedge wb_clk_i) (m_wb_err_i) |-> ##1 $stable(m_wb_dat_i);
endproperty
assert property(af_p300);

property af_p301;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> !(m_wb_err_i && m_wb_ack_i);
endproperty
assert property(af_p301);

property af_p302;
@(posedge wb_clk_i) !(m_wb_err_i && m_wb_ack_i);
endproperty
assert property(af_p302);

property af_p303;
@(posedge wb_clk_i) (m_wb_err_i) |-> ##1 $stable(m_wb_adr_o);
endproperty
assert property(af_p303);

property af_p304;
@(posedge wb_clk_i) (m_wb_err_i) |-> ##1 $stable(m_wb_we_o);
endproperty
assert property(af_p304);

property af_p305;
@(posedge wb_clk_i) (m_wb_err_i && m_wb_we_o) |-> ##1 (!m_wb_we_o);
endproperty
assert property(af_p305);

property af_p306;
@(posedge wb_clk_i) ((m_wb_cti_o == 3'b010) && m_wb_err_i) |-> ##1 $stable(m_wb_bte_o);
endproperty
assert property(af_p306);

property af_p307;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> (!m_wb_err_i);
endproperty
assert property(af_p307);

property af_p308;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> (!m_wb_err_i);
endproperty
assert property(af_p308);

property af_p309;
@(posedge wb_clk_i) (m_wb_err_i) |-> ##1 (!m_wb_cyc_o);
endproperty
assert property(af_p309);

property af_p310;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> !m_wb_err_i[*2];
endproperty
assert property(af_p310);

property af_p311;
@(posedge wb_clk_i) (m_wb_we_o && m_wb_err_i) |=> $stable(m_wb_dat_o);
endproperty
assert property(af_p311);

property af_p312;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o && m_wb_err_i) |=> !(m_wb_cyc_o && m_wb_stb_o);
endproperty
assert property(af_p312);

property af_p313;
@(posedge wb_clk_i) m_wb_err_i |=> $stable(m_wb_dat_o);
endproperty
assert property(af_p313);

property af_p314;
@(posedge wb_clk_i) m_wb_err_i |=> int_o;
endproperty
assert property(af_p314);

property af_p315;
@(posedge wb_clk_i) wb_rst_i |-> !m_wb_err_i;
endproperty
assert property(af_p315);

property af_p316;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_err_i) |-> !m_wb_ack_i;
endproperty
assert property(af_p316);

property af_p317;
@(posedge wb_clk_i) m_wb_err_i |=> $stable(m_wb_adr_o);
endproperty
assert property(af_p317);

property af_p318;
@(posedge wb_clk_i) m_wb_err_i |=> !m_wb_cyc_o;
endproperty
assert property(af_p318);

property af_p319;
@(posedge wb_clk_i) (m_wb_ack_i) |-> (($past(m_wb_sel_o) >= 0) && ($past(m_wb_sel_o) <= 15));
endproperty
assert property(af_p319);

property af_p320;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((m_wb_sel_o >= 0) && (m_wb_sel_o <= 15));
endproperty
assert property(af_p320);

property af_p321;
@(posedge wb_clk_i) (m_wb_stb_o) |-> $stable(m_wb_sel_o);
endproperty
assert property(af_p321);

property af_p322;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> (m_wb_sel_o == 4'b0000);
endproperty
assert property(af_p322);

property af_p323;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> ((m_wb_sel_o >= 0) && (m_wb_sel_o <= 15));
endproperty
assert property(af_p323);

property af_p324;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 ((m_wb_sel_o >= 0) && (m_wb_sel_o <= 15));
endproperty
assert property(af_p324);

property af_p325;
@(posedge wb_clk_i) ((m_wb_sel_o >= 0) && (m_wb_sel_o <= 15)) |=> ((m_wb_sel_o >= 0) && (m_wb_sel_o <= 15));
endproperty
assert property(af_p325);

property af_p326;
@(posedge wb_clk_i) (m_wb_stb_o && !m_wb_ack_i) |-> ##1 $stable(m_wb_sel_o);
endproperty
assert property(af_p326);

property af_p327;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> (m_wb_sel_o == 4'b0000) until_with (m_wb_stb_o);
endproperty
assert property(af_p327);

property af_p328;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> (m_wb_sel_o == 4'b0000);
endproperty
assert property(af_p328);

property af_p329;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> (m_wb_sel_o inside {[4'h0:4'hF]});
endproperty
assert property(af_p329);

property af_p330;
@(posedge wb_clk_i) 1'b1 |-> (m_wb_sel_o == (4'b0001 << m_wb_adr_o[1:0]));
endproperty
assert property(af_p330);

property af_p331;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_ack_i) |-> $stable(m_wb_sel_o);
endproperty
assert property(af_p331);

property af_p332;
@(posedge wb_clk_i) $changed(m_wb_sel_o) |-> $past(m_wb_ack_i);
endproperty
assert property(af_p332);

property af_p333;
@(posedge wb_clk_i) $past(m_wb_ack_i) |-> (m_wb_sel_o inside {[4'h0:4'hF]});
endproperty
assert property(af_p333);

property af_p334;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o) |-> (m_wb_sel_o >= 4'h0 && m_wb_sel_o <= 4'hF);
endproperty
assert property(af_p334);

property af_p335;
@(posedge wb_clk_i) $rose(m_wb_cyc_o) |-> (m_wb_sel_o inside {[4'h0:4'hF]});
endproperty
assert property(af_p335);

property af_p336;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o && !m_wb_ack_i) |-> $stable(m_wb_sel_o);
endproperty
assert property(af_p336);

property af_p337;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (m_wb_sel_o == 4'b0000);
endproperty
assert property(af_p337);

property af_p338;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 (m_wb_sel_o inside {[4'h0:4'hF]});
endproperty
assert property(af_p338);

property af_p339;
@(posedge wb_clk_i) (m_wb_stb_o) |-> (m_wb_sel_o != 4'b0000);
endproperty
assert property(af_p339);

property af_p340;
@(posedge wb_clk_i) ($changed(m_wb_sel_o)) |-> ($changed(m_wb_adr_o));
endproperty
assert property(af_p340);

property af_p341;
@(posedge wb_clk_i) (m_wb_stb_o) |-> (m_wb_sel_o >= 0) && (m_wb_sel_o <= 15);
endproperty
assert property(af_p341);

property af_p342;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_sel_o == 4'b0000);
endproperty
assert property(af_p342);

property af_p343;
@(posedge wb_clk_i) ((m_wb_cti_o == 3'b010) && (m_wb_bte_o == 2'b00)) |-> $stable(m_wb_sel_o);
endproperty
assert property(af_p343);

property af_p344;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> (m_wb_sel_o >= 0) && (m_wb_sel_o <= 15);
endproperty
assert property(af_p344);

property af_p345;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_err_i) |-> $stable(m_wb_sel_o);
endproperty
assert property(af_p345);

property af_p346;
@(posedge wb_clk_i) ((m_wb_sel_o >= 4) && (m_wb_sel_o <= 11)) |=> (m_wb_sel_o >= 0) && (m_wb_sel_o <= 15);
endproperty
assert property(af_p346);

property af_p347;
@(posedge wb_clk_i) (m_wb_we_o) |-> (m_wb_sel_o != 4'b0000);
endproperty
assert property(af_p347);

property af_p348;
@(posedge wb_clk_i) (m_wb_we_o) |-> (m_wb_sel_o >= 0) && (m_wb_sel_o <= 15);
endproperty
assert property(af_p348);

property af_p349;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_ack_i) |=> (m_wb_stb_o == 1'b0);
endproperty
assert property(af_p349);

property af_p350;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_stb_o == 1'b0);
endproperty
assert property(af_p350);

property af_p351;
@(posedge wb_clk_i) (m_wb_stb_o) |-> ($stable(m_wb_sel_o));
endproperty
assert property(af_p351);

property af_p352;
@(posedge wb_clk_i) (m_wb_stb_o) |-> (m_wb_cyc_o);
endproperty
assert property(af_p352);

property af_p353;
@(posedge wb_clk_i) (m_wb_stb_o) |-> (m_wb_stb_o[*1:16] ##0 (m_wb_ack_i || m_wb_err_i));
endproperty
assert property(af_p353);

property af_p354;
@(posedge wb_clk_i) (m_wb_stb_o) |-> (m_wb_stb_o throughout (!m_wb_ack_i && !m_wb_err_i)[*0:$] ##0 (m_wb_ack_i || m_wb_err_i));
endproperty
assert property(af_p354);

property af_p355;
@(posedge wb_clk_i) (m_wb_stb_o) |-> ($stable(m_wb_adr_o) && !$isunknown(m_wb_adr_o));
endproperty
assert property(af_p355);

property af_p356;
@(posedge wb_clk_i) (m_wb_err_i) |-> (m_wb_stb_o == 1'b0);
endproperty
assert property(af_p356);

property af_p357;
@(posedge wb_clk_i) (m_wb_we_o && m_wb_stb_o) |-> ($stable(m_wb_dat_o) throughout (m_wb_stb_o[*1:$]));
endproperty
assert property(af_p357);

property af_p358;
@(posedge wb_clk_i) (m_wb_stb_o || m_wb_cyc_o) |-> (m_wb_stb_o == m_wb_cyc_o);
endproperty
assert property(af_p358);

property af_p359;
@(posedge wb_clk_i) (m_wb_stb_o && !m_wb_ack_i) |-> (m_wb_stb_o until (m_wb_ack_i));
endproperty
assert property(af_p359);

property af_p360;
@(posedge wb_clk_i) (m_wb_stb_o && $past(m_wb_stb_o)) |-> ($stable(m_wb_we_o));
endproperty
assert property(af_p360);

property af_p361;
@(posedge wb_clk_i) ($rose(wb_rst_i)) |=> (!m_wb_stb_o);
endproperty
assert property(af_p361);

property af_p362;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!m_wb_stb_o)[*4];
endproperty
assert property(af_p362);

property af_p363;
@(posedge wb_clk_i) ($rose(m_wb_stb_o)) |-> (m_wb_cyc_o);
endproperty
assert property(af_p363);

property af_p364;
@(posedge wb_clk_i) ($fell(m_wb_stb_o) && $past(m_wb_ack_i)) |-> (!m_wb_stb_o) ##1 (!m_wb_stb_o);
endproperty
assert property(af_p364);

property af_p365;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_err_i) |=> (!m_wb_stb_o);
endproperty
assert property(af_p365);

property af_p366;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (!m_wb_stb_o) ##1 (!m_wb_stb_o);
endproperty
assert property(af_p366);

property af_p367;
@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> (!m_wb_stb_o) ##1 (!m_wb_stb_o);
endproperty
assert property(af_p367);

property af_p368;
@(posedge wb_clk_i) (m_wb_ack_i) |-> ##[1:2] (m_wb_stb_o);
endproperty
assert property(af_p368);

property af_p369;
@(posedge wb_clk_i) (m_wb_stb_o && !m_wb_ack_i) |-> (m_wb_stb_o && $stable(m_wb_adr_o)) until_with (m_wb_ack_i);
endproperty
assert property(af_p369);

property af_p370;
@(posedge wb_clk_i) (wb_rst_i) |-> (!m_wb_stb_o);
endproperty
assert property(af_p370);

property af_p371;
@(posedge wb_clk_i) (m_wb_stb_o && !m_wb_ack_i) |=> ($stable(m_wb_adr_o) throughout (m_wb_stb_o[->1] ##0 m_wb_ack_i));
endproperty
assert property(af_p371);

property af_p372;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_we_o) |-> (!$isunknown(m_wb_dat_o));
endproperty
assert property(af_p372);

property af_p373;
@(posedge wb_clk_i) (m_wb_stb_o && m_wb_ack_i) |=> !m_wb_stb_o;
endproperty
assert property(af_p373);

property af_p374;
@(posedge wb_clk_i) ($rose(m_wb_ack_i)) |=> (!m_wb_stb_o);
endproperty
assert property(af_p374);

property af_p375;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> !m_wb_stb_o ##1 !m_wb_stb_o;
endproperty
assert property(af_p375);

property af_p376;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (m_wb_we_o == 1'b0);
endproperty
assert property(af_p376);

property af_p377;
@(posedge wb_clk_i) (!m_wb_cyc_o && !m_wb_stb_o) |-> (m_wb_we_o == 1'b0);
endproperty
assert property(af_p377);

property af_p378;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o) |-> $stable(m_wb_we_o) throughout (##[0:$] m_wb_ack_i);
endproperty
assert property(af_p378);

property af_p379;
@(posedge wb_clk_i) (m_wb_err_i) |-> (m_wb_we_o == 1'b0);
endproperty
assert property(af_p379);

property af_p380;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_stb_o) |-> !$isunknown(m_wb_we_o);
endproperty
assert property(af_p380);

property af_p381;
@(posedge wb_clk_i) (m_wb_we_o && m_wb_stb_o) |-> (m_wb_dat_o !== 'x) throughout (##[0:$] m_wb_ack_i);
endproperty
assert property(af_p381);

property af_p382;
@(posedge wb_clk_i) (m_wb_we_o) |-> (m_wb_sel_o !== 'x);
endproperty
assert property(af_p382);

property af_p383;
@(posedge wb_clk_i) (m_wb_stb_o) |-> $stable(m_wb_we_o);
endproperty
assert property(af_p383);

property af_p384;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_we_o == 1'b0);
endproperty
assert property(af_p384);

property af_p385;
@(posedge wb_clk_i) (m_wb_we_o) |-> (m_wb_dat_o !== 'x);
endproperty
assert property(af_p385);


property af_p387;
@(posedge wb_clk_i) (m_wb_we_o && m_wb_cyc_o) |-> (m_wb_dat_o !== 'bx);
endproperty
assert property(af_p387);

property af_p388;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_we_o) |-> (m_wb_dat_i !== 'bx);
endproperty
assert property(af_p388);

property af_p389;
@(posedge wb_clk_i) (m_wb_we_o) |-> $stable(m_wb_adr_o);
endproperty
assert property(af_p389);

property af_p390;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_ack_i) |-> $stable(m_wb_we_o);
endproperty
assert property(af_p390);

property af_p391;
@(posedge wb_clk_i) (m_wb_we_o && (m_wb_cti_o == 3'b010)) |-> (m_wb_we_o throughout (m_wb_cti_o == 3'b010)[*1:$]);
endproperty
assert property(af_p391);

property af_p392;
@(posedge wb_clk_i) (m_wb_we_o) |-> (m_wb_cyc_o && m_wb_stb_o);
endproperty
assert property(af_p392);

property af_p393;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_we_o) |-> (m_wb_we_o throughout (m_wb_cyc_o[*1:$] ##0 m_wb_ack_i));
endproperty
assert property(af_p393);

property af_p394;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_we_o && m_wb_err_i) |=> (m_wb_we_o == 1'b0);
endproperty
assert property(af_p394);

property af_p395;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (m_wb_we_o == 1'b0) ##1 (m_wb_we_o == 1'b0);
endproperty
assert property(af_p395);

property af_p396;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (m_wb_we_o == 1'b0);
endproperty
assert property(af_p396);

property af_p397;
@(posedge wb_clk_i) (m_wb_cyc_o && m_wb_err_i) |-> ##[0:1] (m_wb_we_o == 1'b0);
endproperty
assert property(af_p397);

property af_p398;
@(posedge wb_clk_i) ($changed(m_wb_we_o)) |-> (m_wb_cyc_o && m_wb_stb_o);
endproperty
assert property(af_p398);

property af_p399;
@(posedge wb_clk_i) (!m_wb_cyc_o) |-> (m_wb_we_o == 1'b0);
endproperty
assert property(af_p399);

property af_p400;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_ack_i && m_wb_we_o) |=> $stable(m_wb_we_o);
endproperty
assert property(af_p400);

property af_p401;
@(posedge wb_clk_i) (m_wb_we_o) |-> ($isunknown(m_wb_adr_o) == 1'b0) && ($isunknown(m_wb_sel_o) == 1'b0);
endproperty
assert property(af_p401);

property af_p402;
@(posedge wb_clk_i) $rose(m_wb_ack_i) |=> (m_wb_we_o == 1'b0);
endproperty
assert property(af_p402);













































































property af_p479;
@(posedge mtx_clk_pad_i) ($rose(mcoll_pad_i) ##1 $fell(mcoll_pad_i)) |-> ##1 (!mcoll_pad_i);
endproperty
assert property(af_p479);

property af_p480;
@(posedge mtx_clk_pad_i) (mcoll_pad_i) |-> ($stable(mtxd_pad_o));
endproperty
assert property(af_p480);

property af_p481;
@(posedge mtx_clk_pad_i) $fell(mcoll_pad_i) |-> (!mcoll_pad_i);
endproperty
assert property(af_p481);

property af_p482;
@(posedge mtx_clk_pad_i) (wb_rst_i) |-> ((mtxen_pad_o == 1'b0) && (mtxd_pad_o == 8'h00));
endproperty
assert property(af_p482);

property af_p483;
@(posedge mtx_clk_pad_i) (!mcoll_pad_i) |-> ##1 (!mcoll_pad_i);
endproperty
assert property(af_p483);

property af_p484;
@(posedge mtx_clk_pad_i) $rose(mcoll_pad_i) |-> (mtxen_pad_o[*4]) ##1 (!mtxen_pad_o);
endproperty
assert property(af_p484);

property af_p485;
@(posedge mtx_clk_pad_i) $fell(wb_rst_i) |-> (!mcoll_pad_i);
endproperty
assert property(af_p485);


property af_p487;
@(posedge mtx_clk_pad_i) disable iff (wb_rst_i) (mcoll_pad_i) |-> ##1 (mcoll_pad_i);
endproperty
assert property(af_p487);

property af_p488;
@(posedge mtx_clk_pad_i) (mcoll_pad_i) |-> ##1 (!mtxen_pad_o);
endproperty
assert property(af_p488);

property af_p489;
@(posedge mtx_clk_pad_i) $stable(mcoll_pad_i);
endproperty
assert property(af_p489);

property af_p490;
@(posedge mtx_clk_pad_i) (!mcoll_pad_i) |-> $stable(mtxen_pad_o);
endproperty
assert property(af_p490);

property af_p491;
@(posedge mtx_clk_pad_i) disable iff (wb_rst_i) !$isunknown(mcoll_pad_i);
endproperty
assert property(af_p491);

property af_p492;
@(posedge mtx_clk_pad_i) (mcoll_pad_i && mcrs_pad_i) |-> ##0 (mcoll_pad_i && mcrs_pad_i);
endproperty
assert property(af_p492);

property af_p493;
@(posedge mtx_clk_pad_i) $changed(mcoll_pad_i) |-> !$isunknown(mtxd_pad_o);
endproperty
assert property(af_p493);

property af_p494;
@(posedge mtx_clk_pad_i) $rose(mcoll_pad_i) |-> (mtxen_pad_o until (!mcoll_pad_i));
endproperty
assert property(af_p494);

property af_p495;
@(posedge mtx_clk_pad_i) (mtxen_pad_o && !mcoll_pad_i) |-> (mtxen_pad_o until (!mtxen_pad_o));
endproperty
assert property(af_p495);

property af_p496;
@(posedge mtx_clk_pad_i) (!mtxen_pad_o) |-> ($stable(mtxd_pad_o) && $stable(mtxen_pad_o));
endproperty
assert property(af_p496);

property af_p497;
@(posedge mtx_clk_pad_i) ($fell(mcoll_pad_i)) |-> ($stable(mtxen_pad_o));
endproperty
assert property(af_p497);

property af_p498;
@(posedge mtx_clk_pad_i) ($past(mcoll_pad_i)==1'b0 && mcoll_pad_i==1'b1) |-> ##1 (mcoll_pad_i == 1'b0);
endproperty
assert property(af_p498);

property af_p499;
@(posedge mtx_clk_pad_i) (wb_rst_i) |-> (mtxen_pad_o == 1'b0);
endproperty
assert property(af_p499);

property af_p500;
@(posedge mtx_clk_pad_i) ($fell(wb_rst_i)) |-> (mtxen_pad_o == 1'b0);
endproperty
assert property(af_p500);

property af_p501;
@(posedge mtx_clk_pad_i) ($rose(mcoll_pad_i)) |-> (!mtxerr_pad_o);
endproperty
assert property(af_p501);

property af_p502;
@(posedge mtx_clk_pad_i) ($rose(mcoll_pad_i)) |-> (mcoll_pad_i == 1'b1);
endproperty
assert property(af_p502);

property af_p503;
@(posedge mtx_clk_pad_i) ($fell(wb_rst_i)) |-> ##1 (!$rose(mcoll_pad_i));
endproperty
assert property(af_p503);

property af_p504;
@(posedge mtx_clk_pad_i) (mcoll_pad_i && $past(mcoll_pad_i)) |-> (!$rose(mcoll_pad_i));
endproperty
assert property(af_p504);

property af_p505;
@(posedge mtx_clk_pad_i) (!mcoll_pad_i) |-> (!mtxerr_pad_o);
endproperty
assert property(af_p505);

property af_p506;
@(posedge mtx_clk_pad_i) (!$stable(mcrs_pad_i) && $past(mcrs_pad_i,1) != mcrs_pad_i) |-> ##1 $stable(mcrs_pad_i);
endproperty
assert property(af_p506);

property af_p507;
@(posedge mtx_clk_pad_i) (mcrs_pad_i && mrxdv_pad_i) |-> !mrxerr_pad_i;
endproperty
assert property(af_p507);

property af_p508;
@(posedge mtx_clk_pad_i) (!mcrs_pad_i) |-> (mtxerr_pad_o == 1'b0);
endproperty
assert property(af_p508);

property af_p509;
@(posedge mtx_clk_pad_i) (mcrs_pad_i && mtxen_pad_o) |-> ##1 (mcoll_pad_i == mcoll_pad_i);
endproperty
assert property(af_p509);

property af_p510;
@(posedge mtx_clk_pad_i) (mtxen_pad_o) |-> (mcrs_pad_i == 1'b1);
endproperty
assert property(af_p510);

property af_p511;
@(posedge wb_rst_i) (wb_rst_i) |-> (mtxen_pad_o == 1'b0);
endproperty
assert property(af_p511);

property af_p512;
@(posedge mtx_clk_pad_i) $stable(mcrs_pad_i) |-> ##1 $stable(mcrs_pad_i);
endproperty
assert property(af_p512);

property af_p513;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 $stable(mcrs_pad_i);
endproperty
assert property(af_p513);

property af_p514;
@(posedge mtx_clk_pad_i) (mcrs_pad_i && mcoll_pad_i) |-> ##1 (mcoll_pad_i == 1'b1);
endproperty
assert property(af_p514);

property af_p515;
@(posedge mtx_clk_pad_i) $rose(mcrs_pad_i) |-> ##1 $stable(mcrs_pad_i);
endproperty
assert property(af_p515);

property af_p516;
@(posedge mtx_clk_pad_i) $rose(mcrs_pad_i) |-> !$fell(mtxen_pad_o);
endproperty
assert property(af_p516);

property af_p517;
@(posedge mtx_clk_pad_i) $fell(wb_rst_i) |=> (mcoll_pad_i == 1'b0)[*3];
endproperty
assert property(af_p517);

property af_p518;
@(posedge mtx_clk_pad_i) $fell(wb_rst_i) |=> (!mcrs_pad_i)[*2];
endproperty
assert property(af_p518);

property af_p519;
@(posedge mtx_clk_pad_i) (mtxen_pad_o && $fell(mcrs_pad_i)) |-> mtxerr_pad_o;
endproperty
assert property(af_p519);

property af_p520;
@(posedge mtx_clk_pad_i) (mtxen_pad_o && mcrs_pad_i) |-> mtxen_pad_o;
endproperty
assert property(af_p520);

property af_p521;
@(posedge mtx_clk_pad_i) $changed(mcrs_pad_i) |-> $stable(mtxd_pad_o);
endproperty
assert property(af_p521);

property af_p522;
@(posedge mtx_clk_pad_i) mrxdv_pad_i |-> mcrs_pad_i;
endproperty
assert property(af_p522);

property af_p523;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> $stable(mcrs_pad_i)[*3];
endproperty
assert property(af_p523);

property af_p524;
@(posedge mtx_clk_pad_i) $changed(mcrs_pad_i) |-> ##2 $stable(mcrs_pad_i);
endproperty
assert property(af_p524);

property af_p525;
@(posedge mtx_clk_pad_i) (mcrs_pad_i && mcoll_pad_i)[*2] |-> ##1 !mtxen_pad_o;
endproperty
assert property(af_p525);

property af_p526;
@(posedge mtx_clk_pad_i) ($fell(mcrs_pad_i)) |-> ##1 (mtxen_pad_o == 1'b1);
endproperty
assert property(af_p526);

property af_p527;
@(posedge mtx_clk_pad_i) (mcrs_pad_i && mcoll_pad_i) |-> mtxen_pad_o;
endproperty
assert property(af_p527);

property af_p528;
@(posedge mtx_clk_pad_i) (mcrs_pad_i && mtxen_pad_o) |-> mcoll_pad_i;
endproperty
assert property(af_p528);

property af_p529;
@(posedge mtx_clk_pad_i) (!mcrs_pad_i)[*4] |-> mtxen_pad_o;
endproperty
assert property(af_p529);

property af_p530;
@(posedge mrx_clk_pad_i) $stable(mcrs_pad_i);
endproperty
assert property(af_p530);

property af_p531;
@(posedge mrx_clk_pad_i) $stable(mcrs_pad_i) |-> (##[1:2] $stable(mtxen_pad_o) || mtxen_pad_o == mtxen_pad_o);
endproperty
assert property(af_p531);

property af_p532;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> $stable(mcrs_pad_i);
endproperty
assert property(af_p532);

property af_p533;
@(posedge mtx_clk_pad_i) $fell(mcrs_pad_i) |-> (mtxen_pad_o == $past(mtxen_pad_o));
endproperty
assert property(af_p533);

property af_p534;
@(posedge mtx_clk_pad_i) (mcrs_pad_i [*3]) |-> (!mtxen_pad_o);
endproperty
assert property(af_p534);

property af_p535;
@(posedge wb_rst_i) (1'b1) |-> !$isunknown(md_pad_i) throughout (!mdc_pad_o[*0:$] ##1 mdc_pad_o);
endproperty
assert property(af_p535);

property af_p536;
@(posedge mdc_pad_o) (md_padoe_o) |-> (md_pad_o == md_pad_o);
endproperty
assert property(af_p536);

property af_p537;
@(posedge mdc_pad_o) (1'b1) |=> $stable(md_pad_i);
endproperty
assert property(af_p537);

property af_p538;
@(posedge mdc_pad_o) (1'b1) |-> $stable(md_pad_i) throughout (mdc_pad_o[*1] ##1 !mdc_pad_o[*1]);
endproperty
assert property(af_p538);

property af_p539;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 !$isunknown(md_pad_i);
endproperty
assert property(af_p539);

property af_p540;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##[1:3] $isunknown(md_pad_i) == 0;
endproperty
assert property(af_p540);

property af_p541;
@(posedge mdc_pad_o) (mdc_pad_o) |-> $stable(md_pad_i) throughout (mdc_pad_o[*1]);
endproperty
assert property(af_p541);

property af_p542;
@(posedge mdc_pad_o) (!md_padoe_o) |-> !$isunknown(md_pad_i);
endproperty
assert property(af_p542);

property af_p543;
@(posedge mdc_pad_o) (md_pad_i != mtxd_pad_o) or (md_pad_i == mtxd_pad_o);
endproperty
assert property(af_p543);

property af_p544;
@(posedge mdc_pad_o) disable iff (md_padoe_o) (1'b1) |-> $sampled(md_pad_i);
endproperty
assert property(af_p544);

property af_p545;
@(posedge wb_clk_i) disable iff (!wb_rst_i) (1'b1) |-> !$isunknown(md_pad_i);
endproperty
assert property(af_p545);

property af_p546;
@(posedge mdc_pad_o) (!md_padoe_o) |-> $stable(md_pad_i);
endproperty
assert property(af_p546);

property af_p547;
@(posedge mdc_pad_o) (md_padoe_o) |-> 1'b1;
endproperty
assert property(af_p547);

property af_p548;
@(posedge mdc_pad_o) (1'b1) |-> ##1 (md_pad_i == $past(md_pad_i));
endproperty
assert property(af_p548);

property af_p549;
@(posedge wb_clk_i) ($rose(wb_rst_i)) |-> ##[1:$] @(posedge mdc_pad_o) 1'b1;
endproperty
assert property(af_p549);

property af_p550;
@(posedge mdc_pad_o) (md_padoe_o) |-> !$stable(md_pad_i) or 1'b1;
endproperty
assert property(af_p550);

property af_p551;
@(posedge mdc_pad_o) (md_pad_i inside {1'b0,1'b1}) |-> !((md_pad_i == mcrs_pad_i) && (md_pad_i == mcoll_pad_i));
endproperty
assert property(af_p551);

property af_p552;
@(posedge mdc_pad_o) (!md_padoe_o) |-> ##1 $stable(md_pad_i);
endproperty
assert property(af_p552);

property af_p553;
@(posedge mdc_pad_o) (md_padoe_o) |-> !(md_pad_o === md_pad_i);
endproperty
assert property(af_p553);

property af_p554;
@(posedge mdc_pad_o) (!md_padoe_o) |-> $stable(md_pad_i) or (md_pad_i == md_pad_i);
endproperty
assert property(af_p554);

property af_p555;
@(posedge mdc_pad_o) ((md_pad_i === 1'b0) || (md_pad_i === 1'b1)) |-> ##1 ((md_pad_i === 1'b0) || (md_pad_i === 1'b1));
endproperty
assert property(af_p555);

property af_p556;
@(posedge mdc_pad_o) ($fell(md_padoe_o)) |-> ##1 ((md_pad_i === 1'b0) || (md_pad_i === 1'b1));
endproperty
assert property(af_p556);

property af_p557;
@(posedge mdc_pad_o) (!md_padoe_o) |-> ((md_pad_i === 1'b0) || (md_pad_i === 1'b1));
endproperty
assert property(af_p557);

property af_p558;
@(posedge mdc_pad_o) (md_padoe_o) |-> (!$stable(md_pad_i) || $stable(md_pad_o));
endproperty
assert property(af_p558);

property af_p559;
@(posedge wb_rst_i) 1 |-> ##1 $stable(md_pad_i);
endproperty
assert property(af_p559);

property af_p560;
@(posedge mdc_pad_o) disable iff (wb_rst_i) ((md_pad_i === 1'b0) || (md_pad_i === 1'b1));
endproperty
assert property(af_p560);

property af_p561;
@(posedge wb_clk_i) (!md_padoe_o) |-> ((md_pad_i === 1'b0) || (md_pad_i === 1'b1));
endproperty
assert property(af_p561);

property af_p562;
@(posedge mdc_pad_o) (!md_padoe_o) |-> ($stable(md_pad_i) || !$stable(md_pad_o));
endproperty
assert property(af_p562);

property af_p563;
@(posedge mdc_pad_o) (!wb_rst_i) |-> ((md_pad_i === 1'b0) || (md_pad_i === 1'b1));
endproperty
assert property(af_p563);

property af_p564;
@(posedge mdc_pad_o) (md_padoe_o) |-> (md_pad_o === 1'b0 || md_pad_o === 1'b1);
endproperty
assert property(af_p564);

property af_p565;
@(posedge wb_clk_i) ($past(wb_rst_i) && !wb_rst_i) |-> (md_pad_o === 1'b0 || md_pad_o === 1'b1);
endproperty
assert property(af_p565);

property af_p566;
@(posedge wb_clk_i) (wb_rst_i) |=> (md_pad_o === 1'b0);
endproperty
assert property(af_p566);

property af_p567;
@(posedge mdc_pad_o) (!md_padoe_o) |-> (md_pad_o === $past(md_pad_o));
endproperty
assert property(af_p567);

property af_p568;
@(posedge mdc_pad_o) (1'b1) |-> ($stable(md_pad_o) || (md_pad_o !== $past(md_pad_o)));
endproperty
assert property(af_p568);

property af_p569;
@(posedge mdc_pad_o) (wb_rst_i) |-> (md_pad_o === $past(md_pad_o));
endproperty
assert property(af_p569);

property af_p570;
@(posedge mdc_pad_o) (md_pad_o === 1'b1) |=> (md_padoe_o && (md_pad_o === 1'b1));
endproperty
assert property(af_p570);

property af_p571;
@(posedge mdc_pad_o) (md_padoe_o && !$past(md_padoe_o) === 0 && md_padoe_o == $past(md_padoe_o)) |-> (md_pad_o === $past(md_pad_o));
endproperty
assert property(af_p571);

property af_p572;
@(posedge wb_clk_i) (wb_rst_i) |-> (md_pad_o === 1'b0);
endproperty
assert property(af_p572);

property af_p573;
@(posedge mdc_pad_o) (md_padoe_o && (md_pad_o === 1'b0 || md_pad_o === 1'b1)) |=> (md_pad_o === 1'b0 || md_pad_o === 1'b1);
endproperty
assert property(af_p573);

property af_p574;
@(posedge mdc_pad_o) (md_padoe_o) |-> !$stable(md_pad_o) or $stable(md_pad_o);
endproperty
assert property(af_p574);

property af_p575;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> (md_pad_o === 1'b0 || md_pad_o === 1'b1);
endproperty
assert property(af_p575);

property af_p576;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##3 (md_pad_o === 1'b0 || md_pad_o === 1'b1);
endproperty
assert property(af_p576);

property af_p577;
@(posedge wb_clk_i) 1'b1 |-> (md_pad_o === 1'b0 || md_pad_o === 1'b1);
endproperty
assert property(af_p577);

property af_p578;
@(posedge wb_clk_i) (!md_padoe_o) |-> $stable(md_pad_o);
endproperty
assert property(af_p578);


property af_p580;
@(posedge mdc_pad_o) 1'b1 |-> ##1 $stable(md_pad_o) or !$stable(md_pad_o);
endproperty
assert property(af_p580);

property af_p581;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##[1:4] (md_pad_o === 1'b0 || md_pad_o === 1'b1)[*4];
endproperty
assert property(af_p581);

property af_p582;
@(posedge mdc_pad_o) (md_padoe_o) |-> (md_pad_o !== mrxd_pad_i) && (md_pad_o !== mtxd_pad_o);
endproperty
assert property(af_p582);

property af_p583;
@(posedge mdc_pad_o) (!md_padoe_o) |=> (md_pad_o == $past(md_pad_o));
endproperty
assert property(af_p583);

property af_p584;
@(posedge wb_clk_i) (!wb_rst_i) |-> (md_pad_o === 1'b0 || md_pad_o === 1'b1);
endproperty
assert property(af_p584);

property af_p585;
@(posedge wb_clk_i) ($rose(md_padoe_o)) |-> ##[1:2] (md_pad_o == wb_dat_i[0]);
endproperty
assert property(af_p585);

property af_p586;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 (md_pad_o !== 1'bx);
endproperty
assert property(af_p586);

property af_p587;
@(posedge mdc_pad_o) (md_padoe_o) |-> (md_pad_o inside {1'b0, 1'b1});
endproperty
assert property(af_p587);

property af_p588;
@(posedge wb_clk_i) (md_padoe_o) |-> ##1 (md_pad_o == $past(md_pad_o));
endproperty
assert property(af_p588);

property af_p589;
@(posedge mdc_pad_o) $fell(wb_rst_i) |-> ##4 (md_pad_o !== 1'bx);
endproperty
assert property(af_p589);

property af_p590;
@(posedge mdc_pad_o) (md_padoe_o) |=> (md_pad_o == $past(md_pad_o));
endproperty
assert property(af_p590);

property af_p591;
@(posedge wb_clk_i) (md_pad_o == 1'b1) |-> ##1 (!md_padoe_o -> (md_pad_o == 1'b1));
endproperty
assert property(af_p591);

property af_p592;
@(posedge wb_clk_i) disable iff (wb_rst_i) ($fell(wb_rst_i)) |-> (md_padoe_o == 1'b0) throughout (wb_adr_i == '0)[->1];
endproperty
assert property(af_p592);

property af_p593;
@(posedge wb_clk_i) ($rose(md_padoe_o)) |-> (md_padoe_o until $fell(md_padoe_o));
endproperty
assert property(af_p593);

property af_p594;
@(posedge wb_clk_i) (wb_rst_i) |-> (md_padoe_o == 1'b0);
endproperty
assert property(af_p594);

property af_p595;
@(posedge wb_clk_i) (md_padoe_o) |-> (!$isunknown(md_pad_o));
endproperty
assert property(af_p595);

property af_p596;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##[1:3] (!$isunknown(md_padoe_o));
endproperty
assert property(af_p596);

property af_p597;
@(posedge wb_clk_i) (1'b1) |-> $stable(md_padoe_o);
endproperty
assert property(af_p597);

property af_p598;
@(posedge mdc_pad_o) (1'b1) |-> (md_padoe_o == 1'b0);
endproperty
assert property(af_p598);

property af_p599;
@(posedge wb_clk_i) (wb_rst_i) |-> (md_padoe_o !== 1'b1);
endproperty
assert property(af_p599);

property af_p600;
@(posedge wb_clk_i) ($rose(md_padoe_o)) |-> (!$isunknown(md_pad_o));
endproperty
assert property(af_p600);

property af_p601;
@(posedge wb_clk_i) (!$rose(mdc_pad_o) && !$fell(mdc_pad_o)) |-> $stable(md_padoe_o);
endproperty
assert property(af_p601);

property af_p602;
@(posedge wb_clk_i) (md_padoe_o) |-> (md_pad_o !== 1'bz) && !(md_pad_i inside {md_pad_o});
endproperty
assert property(af_p602);

property af_p603;
@(posedge mdc_pad_o) disable iff (!wb_clk_i) (!md_padoe_o) |-> ##[1:4] (!md_padoe_o);
endproperty
assert property(af_p603);

property af_p604;
@(posedge wb_clk_i) ($fell(wb_rst_i) && md_padoe_o) |-> ##1 (md_padoe_o == 1'b1);
endproperty
assert property(af_p604);

property af_p605;
@(posedge mdc_pad_o) disable iff (!wb_clk_i) (md_padoe_o) |=> ##[1:2] $changed(md_padoe_o);
endproperty
assert property(af_p605);


property af_p607;
@(posedge mdc_pad_o) $stable(md_padoe_o) |-> ##1 $stable(md_padoe_o);
endproperty
assert property(af_p607);

property af_p608;
@(posedge mdc_pad_o) disable iff (!wb_clk_i) (md_padoe_o == 1'b1) |=> $changed(md_padoe_o) || $stable(md_padoe_o);
endproperty
assert property(af_p608);

property af_p609;
@(posedge wb_clk_i) (md_padoe_o) |-> (md_pad_o !== 1'bz);
endproperty
assert property(af_p609);

property af_p610;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] !$isunknown(md_padoe_o);
endproperty
assert property(af_p610);

property af_p611;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##1 (md_padoe_o == 1'b0);
endproperty
assert property(af_p611);

property af_p612;
@(posedge mdc_pad_o) (md_padoe_o) |-> !$isunknown(md_pad_o);
endproperty
assert property(af_p612);

property af_p613;
@(posedge wb_clk_i) (md_padoe_o) |-> ($changed(md_padoe_o) == $changed(md_pad_o));
endproperty
assert property(af_p613);

property af_p614;
@(posedge wb_clk_i) (wb_rst_i) |-> $stable(md_padoe_o);
endproperty
assert property(af_p614);

property af_p615;
@(posedge wb_clk_i) $fell(md_padoe_o) |-> ##1 (md_padoe_o == 1'b0);
endproperty
assert property(af_p615);

property af_p616;
@(posedge wb_clk_i) (!md_padoe_o) |-> $stable(md_pad_o) && !$isunknown(md_pad_i);
endproperty
assert property(af_p616);

property af_p617;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> (!md_padoe_o)[*2];
endproperty
assert property(af_p617);

property af_p618;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!md_padoe_o)[*2];
endproperty
assert property(af_p618);

property af_p619;
@(posedge wb_clk_i) (wb_rst_i && $past(wb_rst_i)) |-> $stable(md_padoe_o);
endproperty
assert property(af_p619);

property af_p620;
@(posedge wb_clk_i) ($rose(md_padoe_o) && (wb_adr_i == 6'h04) && !$isunknown(wb_dat_i)) |-> (md_padoe_o throughout (##[1:$] $fell(md_padoe_o)));
endproperty
assert property(af_p620);

property af_p621;
@(posedge wb_clk_i) (!md_padoe_o) |-> !$isunknown(md_pad_i);
endproperty
assert property(af_p621);

property af_p622;
@(posedge wb_clk_i) wb_rst_i |-> $stable(mdc_pad_o);
endproperty
assert property(af_p622);

property af_p623;
@(posedge wb_clk_i) disable iff (wb_rst_i) (1'b1) |-> (mdc_pad_o !== $past(mdc_pad_o));
endproperty
assert property(af_p623);

property af_p624;
@(posedge wb_clk_i) (1'b1) |-> (mdc_pad_o !== $past(mdc_pad_o));
endproperty
assert property(af_p624);

property af_p625;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:16] (mdc_pad_o !== $past(mdc_pad_o));
endproperty
assert property(af_p625);

property af_p626;
@(posedge wb_clk_i) (wb_rst_i |-> $stable(mdc_pad_o)) and ($fell(wb_rst_i) |-> ##[1:16] (mdc_pad_o !== $past(mdc_pad_o)));
endproperty
assert property(af_p626);

property af_p627;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (mdc_pad_o == 1'b0)[*8] ##1 (mdc_pad_o !== $past(mdc_pad_o));
endproperty
assert property(af_p627);

property af_p628;
@(posedge wb_clk_i) disable iff (wb_rst_i) (mdc_pad_o == $past(mdc_pad_o)) |=> (mdc_pad_o != $past(mdc_pad_o));
endproperty
assert property(af_p628);

property af_p629;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> (mdc_pad_o == 1'b0);
endproperty
assert property(af_p629);

property af_p630;
@(posedge wb_clk_i) disable iff (wb_rst_i) $rose(mdc_pad_o) |-> ##4 $rose(mdc_pad_o);
endproperty
assert property(af_p630);

property af_p631;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:4] $changed(mdc_pad_o);
endproperty
assert property(af_p631);

property af_p632;
@(posedge wb_clk_i) disable iff (wb_rst_i) ($stable(mdc_pad_o) || $changed(mdc_pad_o));
endproperty
assert property(af_p632);

property af_p633;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 $changed(mdc_pad_o);
endproperty
assert property(af_p633);

property af_p634;
@(posedge wb_clk_i) disable iff (wb_rst_i) ($changed(md_pad_o) || $changed(md_padoe_o)) |-> ##[1:$] $changed(mdc_pad_o);
endproperty
assert property(af_p634);

property af_p635;
@(posedge wb_clk_i) (wb_rst_i) |-> $stable(mdc_pad_o);
endproperty
assert property(af_p635);

property af_p636;
@(posedge wb_clk_i) disable iff (wb_rst_i) $rose(mdc_pad_o) |-> ##[1:$] ($fell(mdc_pad_o) ##[1:$] $rose(mdc_pad_o));
endproperty
assert property(af_p636);

property af_p637;
@(posedge wb_clk_i) disable iff (wb_rst_i) $rose(mdc_pad_o) |-> ##[1:$] $fell(mdc_pad_o);
endproperty
assert property(af_p637);

property af_p638;
@(posedge wb_clk_i) $rose(mdc_pad_o) |-> ##5 $fell(mdc_pad_o) ##5 $rose(mdc_pad_o);
endproperty
assert property(af_p638);

property af_p639;
@(posedge wb_clk_i) (mdc_pad_o) |-> $stable(md_pad_o);
endproperty
assert property(af_p639);

property af_p640;
@(posedge wb_clk_i) $rose(mdc_pad_o) |-> !$fell(mdc_pad_o);
endproperty
assert property(af_p640);

property af_p641;
@(posedge wb_clk_i) disable iff (wb_rst_i) $rose(mdc_pad_o) |-> ##5 $rose(mdc_pad_o);
endproperty
assert property(af_p641);

property af_p642;
@(posedge wb_clk_i) $changed(md_pad_i) |-> (mdc_pad_o === $past(mdc_pad_o) || mdc_pad_o !== $past(mdc_pad_o));
endproperty
assert property(af_p642);

property af_p643;
@(posedge wb_clk_i) disable iff (wb_rst_i) (md_padoe_o) |-> ##1 (mdc_pad_o !== $past(mdc_pad_o));
endproperty
assert property(af_p643);

property af_p644;
@(posedge wb_clk_i) $rose(mdc_pad_o) |-> ##5 $fell(mdc_pad_o);
endproperty
assert property(af_p644);

property af_p645;
@(posedge wb_clk_i) ($changed(mtxen_pad_o) || $changed(mrxdv_pad_i)) |-> ##1 (mdc_pad_o !== $past(mdc_pad_o) || mdc_pad_o === $past(mdc_pad_o));
endproperty
assert property(af_p645);

property af_p646;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> $stable(mdc_pad_o);
endproperty
assert property(af_p646);

property af_p647;
@(posedge mrx_clk_pad_i) wb_rst_i |-> ##1 $rose(mrx_clk_pad_i) || $fell(mrx_clk_pad_i);
endproperty
assert property(af_p647);

property af_p648;
@(posedge mrx_clk_pad_i) 1'b1 |-> $rose(mtx_clk_pad_i) || !$rose(mtx_clk_pad_i);
endproperty
assert property(af_p648);

property af_p649;
@(posedge mrx_clk_pad_i) $stable(mrx_clk_pad_i) |-> ($stable(mrxd_pad_i) && $stable(mrxdv_pad_i));
endproperty
assert property(af_p649);

property af_p650;
@(posedge mrx_clk_pad_i) mrxerr_pad_i |-> $rose(mrx_clk_pad_i);
endproperty
assert property(af_p650);

property af_p651;
@(posedge mrx_clk_pad_i) !$rose(mrxdv_pad_i) |-> $stable(mrxdv_pad_i);
endproperty
assert property(af_p651);

property af_p652;
@(posedge mrx_clk_pad_i) 1'b1 |-> $stable(mcrs_pad_i) || !$stable(mcrs_pad_i);
endproperty
assert property(af_p652);

property af_p653;
@(posedge mrx_clk_pad_i) mrxdv_pad_i |-> $stable(mrxd_pad_i);
endproperty
assert property(af_p653);

property af_p654;
@(posedge mrx_clk_pad_i) $fell(wb_rst_i) |-> ##[1:2] $stable(mrxd_pad_i);
endproperty
assert property(af_p654);

property af_p655;
@(posedge mrx_clk_pad_i) $rose(mrxdv_pad_i) |-> ##1 $stable(mrxdv_pad_i);
endproperty
assert property(af_p655);

property af_p656;
@(posedge mrx_clk_pad_i) 1'b1 |-> $stable(mrx_clk_pad_i) == 0;
endproperty
assert property(af_p656);

property af_p657;
@(posedge mrx_clk_pad_i) (!wb_rst_i) |-> (mrx_clk_pad_i !== $past(mrx_clk_pad_i));
endproperty
assert property(af_p657);

property af_p658;
@(posedge mrx_clk_pad_i) (1) |-> ($stable(mcrs_pad_i) && $stable(mcoll_pad_i)) || $changed(mrx_clk_pad_i);
endproperty
assert property(af_p658);

property af_p659;
@(posedge mrx_clk_pad_i) (mrxerr_pad_i && mrxdv_pad_i) |-> (mrxerr_pad_i == 1'b1);
endproperty
assert property(af_p659);

property af_p660;
@(posedge mrx_clk_pad_i) (!mrxdv_pad_i) |-> (!mrxerr_pad_i);
endproperty
assert property(af_p660);

property af_p661;
@(posedge mrx_clk_pad_i) (!mrxdv_pad_i) |-> (mrxdv_pad_i == 1'b0);
endproperty
assert property(af_p661);

property af_p662;
@(posedge mrx_clk_pad_i) (!wb_rst_i) |-> (mrxdv_pad_i === mrxdv_pad_i);
endproperty
assert property(af_p662);

property af_p663;
@(posedge mrx_clk_pad_i) (1) |=> (mrxd_pad_i == $past(mrxd_pad_i, 1)) || ($changed(mrxd_pad_i));
endproperty
assert property(af_p663);


property af_p665;
@(posedge mrx_clk_pad_i) (1) |-> ##1 $stable(mcrs_pad_i) && $stable(mcoll_pad_i);
endproperty
assert property(af_p665);

property af_p666;
@(posedge mrx_clk_pad_i or negedge mrx_clk_pad_i) (!wb_rst_i) |-> ##1 (mrx_clk_pad_i !== $past(mrx_clk_pad_i));
endproperty
assert property(af_p666);

property af_p667;
@(posedge wb_clk_i) 1'b1 |-> !$isunknown(mrx_clk_pad_i);
endproperty
assert property(af_p667);






property af_p673;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i) ##1 (mrxdv_pad_i) |-> !$isunknown(mrxd_pad_i);
endproperty
assert property(af_p673);


property af_p675;
@(posedge mrx_clk_pad_i) (!mrxdv_pad_i && !mrxerr_pad_i) |-> $stable(mrxd_pad_i);
endproperty
assert property(af_p675);

property af_p676;
@(posedge mrx_clk_pad_i) (wb_rst_i) |-> ##1 (mrxd_pad_i == $past(mrxd_pad_i));
endproperty
assert property(af_p676);

property af_p677;
@(posedge mrx_clk_pad_i) (!wb_rst_i) |-> (mrxd_pad_i >= 4'h0 && mrxd_pad_i <= 4'hF);
endproperty
assert property(af_p677);

property af_p678;
@(posedge mrx_clk_pad_i) ($fell(wb_rst_i)) |-> ##1 (!$isunknown(mrxd_pad_i));
endproperty
assert property(af_p678);

property af_p679;
@(posedge mrx_clk_pad_i) ($rose(mrxdv_pad_i)) |-> (mrxd_pad_i == 4'h5);
endproperty
assert property(af_p679);

property af_p680;
@(posedge mrx_clk_pad_i) (wb_rst_i) |-> $stable(mrxd_pad_i);
endproperty
assert property(af_p680);

property af_p681;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i) |-> (mrxd_pad_i inside {[4'h0:4'hF]});
endproperty
assert property(af_p681);

property af_p682;
@(posedge mrx_clk_pad_i) (!mrxdv_pad_i) |-> $stable(mrxd_pad_i);
endproperty
assert property(af_p682);

property af_p683;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i) |-> (!$isunknown(mrxd_pad_i));
endproperty
assert property(af_p683);

property af_p684;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i[*4]) |-> (!$isunknown({mrxd_pad_i, $past(mrxd_pad_i,1), $past(mrxd_pad_i,2), $past(mrxd_pad_i,3)}));
endproperty
assert property(af_p684);

property af_p685;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i) |=> $stable(mrxd_pad_i);
endproperty
assert property(af_p685);

property af_p686;
@(posedge mrx_clk_pad_i) $rose(wb_rst_i) |-> ##3 ((mrxd_pad_i >= 0) && (mrxd_pad_i <= 15));
endproperty
assert property(af_p686);

property af_p687;
@(posedge mrx_clk_pad_i) (!mrxdv_pad_i) |=> 1'b1;
endproperty
assert property(af_p687);

property af_p688;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i) |-> $stable(mrxd_pad_i);
endproperty
assert property(af_p688);

property af_p689;
@(posedge mrx_clk_pad_i) (mrxerr_pad_i) |-> $isunknown(mrxd_pad_i);
endproperty
assert property(af_p689);

property af_p690;
@(posedge mrx_clk_pad_i) (!mrxdv_pad_i) |-> ($stable(mcoll_pad_i) && $stable(mcrs_pad_i));
endproperty
assert property(af_p690);

property af_p691;
@(posedge mrx_clk_pad_i) $rose(wb_rst_i) |-> ##4 ((mrxd_pad_i >= 0) && (mrxd_pad_i <= 15));
endproperty
assert property(af_p691);

property af_p692;
@(posedge mrx_clk_pad_i) (mrxerr_pad_i) |-> !$isunknown(mrxd_pad_i);
endproperty
assert property(af_p692);

property af_p693;
@(posedge mrx_clk_pad_i) (mcoll_pad_i) |-> !$isunknown(mrxd_pad_i);
endproperty
assert property(af_p693);

property af_p694;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i && (mrxd_pad_i >= 0) && (mrxd_pad_i <= 7)) |=> (mrxd_pad_i >= 0) && (mrxd_pad_i <= 15);
endproperty
assert property(af_p694);

property af_p695;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i) |=> (mrxd_pad_i >= 0) && (mrxd_pad_i <= 15);
endproperty
assert property(af_p695);

property af_p696;
@(posedge mrx_clk_pad_i) (mrxerr_pad_i) |-> 1'b1;
endproperty
assert property(af_p696);

property af_p697;
@(posedge mrx_clk_pad_i) (mrxd_pad_i >= 0) && (mrxd_pad_i <= 15);
endproperty
assert property(af_p697);

property af_p698;
@(posedge mrx_clk_pad_i) (!mcrs_pad_i) |-> $stable(mrxd_pad_i);
endproperty
assert property(af_p698);

property af_p699;
@(posedge mrx_clk_pad_i) 1'b1 |-> $stable(mrxd_pad_i);
endproperty
assert property(af_p699);

property af_p700;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i) |-> (mrxd_pad_i >= 0 && mrxd_pad_i <= 15) [*3];
endproperty
assert property(af_p700);

property af_p701;
@(posedge mrx_clk_pad_i) (!mrxdv_pad_i) |=> $stable(mrxd_pad_i);
endproperty
assert property(af_p701);

property af_p702;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i) |=> $stable(mrxd_pad_i) && (mrxd_pad_i !== 'x);
endproperty
assert property(af_p702);

property af_p703;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i) |-> $stable(mrxdv_pad_i);
endproperty
assert property(af_p703);

property af_p704;
@(posedge mrx_clk_pad_i) $stable(mrxdv_pad_i) throughout (1'b1[*1]);
endproperty
assert property(af_p704);

property af_p705;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i && $past(mrxdv_pad_i) && $past(mrxdv_pad_i,2)) |-> (mrxd_pad_i !== 'x) && !(mrxd_pad_i == $past(mrxd_pad_i) && $past(mrxd_pad_i) == $past(mrxd_pad_i,2));
endproperty
assert property(af_p705);

property af_p706;
@(posedge mrx_clk_pad_i) ($fell(mrxdv_pad_i)) |=> !mrxdv_pad_i;
endproperty
assert property(af_p706);

property af_p707;
@(posedge mrx_clk_pad_i) ($fell(mcrs_pad_i)) |=> !mrxdv_pad_i;
endproperty
assert property(af_p707);

property af_p708;
@(posedge mrx_clk_pad_i) ($fell(wb_rst_i)) |=> (!mrxdv_pad_i) throughout (!mcrs_pad_i)[->1];
endproperty
assert property(af_p708);


property af_p710;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i) |-> $stable(mrxerr_pad_i);
endproperty
assert property(af_p710);

property af_p711;
@(posedge mrx_clk_pad_i) $rose(mrxdv_pad_i) |=> !mrxerr_pad_i;
endproperty
assert property(af_p711);

property af_p712;
@(posedge mrx_clk_pad_i) (wb_rst_i) |-> !mrxdv_pad_i;
endproperty
assert property(af_p712);

property af_p713;
@(posedge mrx_clk_pad_i) $rose(mrxdv_pad_i) |=> mrxdv_pad_i[*1:$] ##1 $fell(mrxdv_pad_i);
endproperty
assert property(af_p713);

property af_p714;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i[*8]) |-> not ($stable(mrxd_pad_i)[*8]);
endproperty
assert property(af_p714);

property af_p715;
@(posedge wb_clk_i) (wb_rst_i) |-> !mrxdv_pad_i;
endproperty
assert property(af_p715);

property af_p716;
@(posedge mrx_clk_pad_i) $rose(mcrs_pad_i) |-> ##[1:2] mrxdv_pad_i;
endproperty
assert property(af_p716);

property af_p717;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> !mrxdv_pad_i;
endproperty
assert property(af_p717);

property af_p718;
@(posedge mrx_clk_pad_i) (!mrxdv_pad_i) |-> $stable(mrxd_pad_i);
endproperty
assert property(af_p718);

property af_p719;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i) |-> !$isunknown(mrxd_pad_i);
endproperty
assert property(af_p719);

property af_p720;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i && mcrs_pad_i) |=> !$isunknown(mrxd_pad_i);
endproperty
assert property(af_p720);

property af_p721;
@(posedge mrx_clk_pad_i) !mrxdv_pad_i |-> $stable(mrxd_pad_i) or !$stable(mrxd_pad_i);
endproperty
assert property(af_p721);

property af_p722;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> !mrxdv_pad_i;
endproperty
assert property(af_p722);

property af_p723;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (!mrxdv_pad_i)[*4];
endproperty
assert property(af_p723);

property af_p724;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> !mrxdv_pad_i until @(posedge mrx_clk_pad_i) 1'b1;
endproperty
assert property(af_p724);

property af_p725;
@(posedge mrx_clk_pad_i) $rose(mrxdv_pad_i) |-> (!mrxerr_pad_i ##1 !mrxerr_pad_i);
endproperty
assert property(af_p725);

property af_p726;
@(posedge mrx_clk_pad_i) $changed(mrxdv_pad_i) |-> ##1 $stable(mrxdv_pad_i);
endproperty
assert property(af_p726);

property af_p727;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i && mrxdv_pad_i[*2]) |-> !$isunknown(mrxd_pad_i);
endproperty
assert property(af_p727);

property af_p728;
@(posedge mrx_clk_pad_i) mrxdv_pad_i |-> !$isunknown(mrxd_pad_i);
endproperty
assert property(af_p728);

property af_p729;
@(posedge mrx_clk_pad_i) $fell(wb_rst_i) |-> ##4 (mrxerr_pad_i === 1'b0 || mrxerr_pad_i === 1'b1);
endproperty
assert property(af_p729);

property af_p730;
@(posedge mrx_clk_pad_i) (!mrxdv_pad_i) |-> (mrxerr_pad_i === 1'b0 || mrxerr_pad_i === 1'b1);
endproperty
assert property(af_p730);

property af_p731;
@(posedge mrx_clk_pad_i) (mrxerr_pad_i && mcrs_pad_i) |=> mrxerr_pad_i;
endproperty
assert property(af_p731);

property af_p732;
@(posedge mrx_clk_pad_i) (!mrxerr_pad_i)[*4] |-> !$isunknown(mrxd_pad_i);
endproperty
assert property(af_p732);

property af_p733;
@(posedge mrx_clk_pad_i) (mrxerr_pad_i && mrxdv_pad_i) |=> mrxerr_pad_i;
endproperty
assert property(af_p733);

property af_p734;
@(posedge mrx_clk_pad_i) (mrxerr_pad_i && mrxdv_pad_i) |=> (mrxdv_pad_i |-> mrxerr_pad_i);
endproperty
assert property(af_p734);

property af_p735;
@(posedge mrx_clk_pad_i) (mrxerr_pad_i && mrxdv_pad_i) |=> (mrxerr_pad_i === 1'b0 || mrxerr_pad_i === 1'b1);
endproperty
assert property(af_p735);

property af_p736;
@(posedge mrx_clk_pad_i) (mrxerr_pad_i && mrxdv_pad_i) |-> $sampled(mrxerr_pad_i);
endproperty
assert property(af_p736);

property af_p737;
@(posedge mrx_clk_pad_i) $rose(mrxerr_pad_i) |=> !mrxerr_pad_i;
endproperty
assert property(af_p737);

property af_p738;
@(posedge mrx_clk_pad_i) wb_rst_i |-> !mrxerr_pad_i;
endproperty
assert property(af_p738);

property af_p739;
@(posedge mrx_clk_pad_i) (wb_rst_i) |-> (!mrxerr_pad_i);
endproperty
assert property(af_p739);

property af_p740;
@(posedge mrx_clk_pad_i) (mrxerr_pad_i && (mrxd_pad_i >= 0)) |-> ((mrxerr_pad_i >= 0) && (mrxerr_pad_i <= 1));
endproperty
assert property(af_p740);

property af_p741;
@(posedge mrx_clk_pad_i) (!mrxdv_pad_i) |-> ($stable(mrxerr_pad_i));
endproperty
assert property(af_p741);

property af_p742;
@(posedge mrx_clk_pad_i) (!mrxdv_pad_i) |-> (!mrxerr_pad_i);
endproperty
assert property(af_p742);

property af_p743;
@(posedge mrx_clk_pad_i) ($fell(wb_rst_i)) |-> (!mrxerr_pad_i);
endproperty
assert property(af_p743);

property af_p744;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i && mrxerr_pad_i) |-> ##[1:3] ($changed(wb_dat_o));
endproperty
assert property(af_p744);

property af_p745;
@(posedge mrx_clk_pad_i) ($stable(mrxerr_pad_i)) |-> ($stable(md_pad_o) && $stable(md_padoe_o));
endproperty
assert property(af_p745);

property af_p746;
@(posedge mrx_clk_pad_i) (mrxerr_pad_i) |-> ##[1:4] (int_o);
endproperty
assert property(af_p746);

property af_p747;
@(posedge mrx_clk_pad_i) ($stable(mrxerr_pad_i)) |-> ($stable(mtxd_pad_o) && $stable(mtxen_pad_o));
endproperty
assert property(af_p747);

property af_p748;
@(posedge mrx_clk_pad_i) (mrxerr_pad_i) |-> (mrxd_pad_i === mrxd_pad_i);
endproperty
assert property(af_p748);

property af_p749;
@(posedge mrx_clk_pad_i) (wb_rst_i) |-> (mrxerr_pad_i === mrxerr_pad_i);
endproperty
assert property(af_p749);

property af_p750;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i) |-> (mrxerr_pad_i >= 1'b0) && (mrxerr_pad_i <= 1'b1);
endproperty
assert property(af_p750);

property af_p751;
@(posedge mrx_clk_pad_i) (1'b1) |-> ((mrxerr_pad_i == 1'b0) || (mrxerr_pad_i == 1'b1));
endproperty
assert property(af_p751);

property af_p752;
@(posedge mrx_clk_pad_i) (mrxdv_pad_i) |=> ($past(mrxerr_pad_i) !== mrxerr_pad_i) || ($past(mrxerr_pad_i) === mrxerr_pad_i);
endproperty
assert property(af_p752);

property af_p753;
@(posedge mrx_clk_pad_i) ($past(wb_rst_i) && !wb_rst_i) |-> (mrxerr_pad_i === mrxerr_pad_i);
endproperty
assert property(af_p753);

property af_p754;
@(posedge mrx_clk_pad_i) ($past(wb_rst_i) && !wb_rst_i) |-> ((mrxerr_pad_i >= 1'b0) && (mrxerr_pad_i <= 1'b1))[*3];
endproperty
assert property(af_p754);



property af_p757;
@(posedge mtx_clk_pad_i) (wb_rst_i) |-> ((mtxd_pad_o == 8'h00) && (mtxen_pad_o == 1'b0));
endproperty
assert property(af_p757);


property af_p759;
@(posedge mtx_clk_pad_i) disable iff (wb_rst_i) (1'b1) |-> $stable(mtxd_pad_o);
endproperty
assert property(af_p759);

property af_p760;
@(posedge mtx_clk_pad_i) $fell(wb_rst_i) |-> !mtxen_pad_o;
endproperty
assert property(af_p760);

property af_p761;
@(posedge mtx_clk_pad_i) (1'b1) |-> ($rose(mtx_clk_pad_i) or $fell(mtx_clk_pad_i));
endproperty
assert property(af_p761);

property af_p762;
@(posedge mtx_clk_pad_i) disable iff (wb_rst_i) $fell(wb_rst_i) |-> !mtxen_pad_o[*1];
endproperty
assert property(af_p762);




property af_p766;
@(posedge mtx_clk_pad_i) $rose(wb_rst_i) |-> (!mtxen_pad_o) throughout (##2 1);
endproperty
assert property(af_p766);

property af_p767;
@(posedge mtx_clk_pad_i) disable iff (wb_rst_i) $rose(mtxen_pad_o) |-> mtxen_pad_o[*1];
endproperty
assert property(af_p767);

property af_p768;
@(posedge mtx_clk_pad_i) disable iff (wb_rst_i) $fell(wb_rst_i) |=> $changed(mtxd_pad_o);
endproperty
assert property(af_p768);

property af_p769;
@(posedge mtx_clk_pad_i) disable iff (!wb_rst_i) (mtxen_pad_o) |-> $stable(mtxd_pad_o)[*1:$] ##1 1'b1;
endproperty
assert property(af_p769);

property af_p770;
@(posedge mtx_clk_pad_i) $rose(mtxen_pad_o) |-> ##[1:4] mtxen_pad_o;
endproperty
assert property(af_p770);

property af_p771;
@(posedge mtx_clk_pad_i) (1'b1) |-> $stable(mtxd_pad_o) until_with $rose(mtx_clk_pad_i);
endproperty
assert property(af_p771);

property af_p772;
@(posedge mtx_clk_pad_i) $rose(mtxen_pad_o) |-> mtxen_pad_o[*8];
endproperty
assert property(af_p772);

property af_p773;
@(posedge mtx_clk_pad_i) (1'b1) |=> $stable(mtxd_pad_o);
endproperty
assert property(af_p773);

property af_p774;
@(posedge mtx_clk_pad_i) (mtxen_pad_o == mtxen_pad_o);
endproperty
assert property(af_p774);

property af_p775;
@(posedge mtx_clk_pad_i) disable iff (wb_rst_i) $fell(wb_rst_i) |-> ##1 $stable(mtxd_pad_o) == 0;
endproperty
assert property(af_p775);

property af_p776;
@(posedge mtx_clk_pad_i) (1'b1) |-> ##1 $stable(mtxd_pad_o) throughout (1'b1)[*1];
endproperty
assert property(af_p776);

property af_p777;
@(posedge mtx_clk_pad_i) (mtxen_pad_o) |-> ((mtxd_pad_o >= 0) && (mtxd_pad_o <= 255))[*8];
endproperty
assert property(af_p777);

property af_p778;
@(posedge mtx_clk_pad_i) $changed(mtxerr_pad_o) |-> $rose(mtx_clk_pad_i);
endproperty
assert property(af_p778);

property af_p779;
@(posedge mtx_clk_pad_i) (1) |-> ##1 $stable(mtxd_pad_o);
endproperty
assert property(af_p779);

property af_p780;
@(posedge mtx_clk_pad_i) $changed(mtxen_pad_o) |-> ($rose(mtx_clk_pad_i) && !$rose(wb_clk_i));
endproperty
assert property(af_p780);

property af_p781;
@(posedge mtx_clk_pad_i) (1) |-> (mtxerr_pad_o == 1'b0);
endproperty
assert property(af_p781);

property af_p782;
@(posedge mtx_clk_pad_i) (wb_rst_i) |-> (mtxen_pad_o == 1'b0) && (mtxerr_pad_o == 1'b0);
endproperty
assert property(af_p782);

property af_p783;
@(posedge mtx_clk_pad_i) (!wb_rst_i) |-> ##1 $rose(mtx_clk_pad_i);
endproperty
assert property(af_p783);

property af_p784;
@(posedge mtx_clk_pad_i) (1) |=> $stable(mtxd_pad_o);
endproperty
assert property(af_p784);

property af_p785;
@(posedge mtx_clk_pad_i) $rose(mtxerr_pad_o) |-> $rose(mtx_clk_pad_i);
endproperty
assert property(af_p785);

property af_p786;
@(posedge mtx_clk_pad_i) $changed(mtxen_pad_o) |-> $rose(mtx_clk_pad_i);
endproperty
assert property(af_p786);

property af_p787;
@(posedge mtx_clk_pad_i) $changed(mtxen_pad_o) |-> !$isunknown(mtxd_pad_o) ##1 !$isunknown(mtxd_pad_o);
endproperty
assert property(af_p787);

property af_p788;
@(posedge mtx_clk_pad_i) $rose(mtxen_pad_o) |-> ##3 !$isunknown(mtxd_pad_o);
endproperty
assert property(af_p788);

property af_p789;
@(posedge mtx_clk_pad_i) $rose(mtxen_pad_o) |-> ##1 $stable(mtxd_pad_o);
endproperty
assert property(af_p789);

property af_p790;
@(posedge mtx_clk_pad_i) 1'b1 |-> $stable(mtxd_pad_o) until_with $rose(mtx_clk_pad_i);
endproperty
assert property(af_p790);

property af_p791;
@(posedge mtx_clk_pad_i) (mtxen_pad_o) |-> $stable(mtxd_pad_o);
endproperty
assert property(af_p791);

property af_p792;
@(posedge mtx_clk_pad_i) (wb_rst_i) |-> (mtxd_pad_o == '0);
endproperty
assert property(af_p792);

property af_p793;
@(posedge mtx_clk_pad_i) (!mtxen_pad_o) |-> $stable(mtxd_pad_o);
endproperty
assert property(af_p793);

property af_p794;
@(posedge mtx_clk_pad_i) (!mtxen_pad_o) |-> (mtxd_pad_o == '0);
endproperty
assert property(af_p794);

property af_p795;
@(posedge mtx_clk_pad_i) $rose(wb_rst_i) |-> (mtxd_pad_o == '0) [*2];
endproperty
assert property(af_p795);

property af_p796;
@(posedge mtx_clk_pad_i) (mtxen_pad_o) |-> ($stable(mtxd_pad_o) || $changed(mtxd_pad_o)) && (mtxd_pad_o !== 'x);
endproperty
assert property(af_p796);

property af_p797;
@(posedge mtx_clk_pad_i) ($rose(wb_rst_i)) |-> (mtxd_pad_o == '0);
endproperty
assert property(af_p797);

property af_p798;
@(posedge mtx_clk_pad_i) ($fell(mtxen_pad_o)) |=> (mtxd_pad_o == '0);
endproperty
assert property(af_p798);

property af_p799;
@(posedge mtx_clk_pad_i) (mtxerr_pad_o) |=> ((mtxd_pad_o >= 0) && (mtxd_pad_o <= 15));
endproperty
assert property(af_p799);

property af_p800;
@(posedge mtx_clk_pad_i) (mtxerr_pad_o) |-> $stable(mtxd_pad_o);
endproperty
assert property(af_p800);

property af_p801;
@(posedge mtx_clk_pad_i) ($fell(wb_rst_i)) |-> ##[1:4] (mtxen_pad_o throughout ((mtxd_pad_o >= 0) && (mtxd_pad_o <= 15)));
endproperty
assert property(af_p801);

property af_p802;
@(posedge mtx_clk_pad_i) ($past(wb_rst_i) && !wb_rst_i) |=> ((mtxd_pad_o >= 0) && (mtxd_pad_o <= 15));
endproperty
assert property(af_p802);

property af_p803;
@(posedge mtx_clk_pad_i) ($fell(wb_rst_i)) |-> ##[1:3] ((mtxd_pad_o >= 0) && (mtxd_pad_o <= 15) && !mtxen_pad_o);
endproperty
assert property(af_p803);

property af_p804;
@(posedge mtx_clk_pad_i) mtxerr_pad_o |=> !$isunknown(mtxd_pad_o);
endproperty
assert property(af_p804);

property af_p805;
@(posedge mtx_clk_pad_i) (mtxd_pad_o >= 0 && mtxd_pad_o <= 15) |-> ##1 (mtxd_pad_o >= 0 && mtxd_pad_o <= 15);
endproperty
assert property(af_p805);

property af_p806;
@(posedge mtx_clk_pad_i) $changed(mtxd_pad_o) |-> (mtxen_pad_o && $past(mtxen_pad_o));
endproperty
assert property(af_p806);

property af_p807;
@(posedge mtx_clk_pad_i) $rose(mtxen_pad_o) |=> !$isunknown(mtxd_pad_o);
endproperty
assert property(af_p807);

property af_p808;
@(posedge mtx_clk_pad_i) wb_rst_i |-> (mtxd_pad_o == 0);
endproperty
assert property(af_p808);

property af_p809;
@(posedge mtx_clk_pad_i) mtxen_pad_o |-> (mtxd_pad_o >= 0 && mtxd_pad_o <= 15);
endproperty
assert property(af_p809);

property af_p810;
@(posedge mtx_clk_pad_i) mtxen_pad_o |-> !$isunknown(mtxd_pad_o);
endproperty
assert property(af_p810);

property af_p811;
@(posedge mtx_clk_pad_i) $fell(wb_rst_i) |-> ##[1:2] !$isunknown(mtxd_pad_o);
endproperty
assert property(af_p811);

property af_p812;
@(posedge mtx_clk_pad_i) $rose(mtxen_pad_o) |-> mtxen_pad_o throughout (##[1:$] $fell(mtxen_pad_o));
endproperty
assert property(af_p812);

property af_p813;
@(posedge mtx_clk_pad_i) wb_rst_i |=> !mtxen_pad_o;
endproperty
assert property(af_p813);

property af_p814;
@(posedge mtx_clk_pad_i) mtxerr_pad_o |-> !mtxen_pad_o;
endproperty
assert property(af_p814);

property af_p815;
@(posedge mtx_clk_pad_i) mcrs_pad_i |-> !mtxen_pad_o;
endproperty
assert property(af_p815);

property af_p816;
@(posedge mtx_clk_pad_i) (mtxd_pad_o !== '0 && mtxd_pad_o !== 'x) |-> mtxen_pad_o;
endproperty
assert property(af_p816);

property af_p817;
@(posedge mtx_clk_pad_i) $rose(mtxen_pad_o) |=> mtxen_pad_o;
endproperty
assert property(af_p817);

property af_p818;
@(posedge mtx_clk_pad_i) mtxen_pad_o |-> !mcrs_pad_i;
endproperty
assert property(af_p818);

property af_p819;
@(posedge mtx_clk_pad_i) $rose(mtxen_pad_o) |-> (mtxd_pad_o !== 'x);
endproperty
assert property(af_p819);

property af_p820;
@(posedge mtx_clk_pad_i) 1'b1 |-> ($stable(mtxen_pad_o) || $changed(mtxen_pad_o));
endproperty
assert property(af_p820);

property af_p821;
@(posedge mtx_clk_pad_i) mcoll_pad_i |-> !mtxen_pad_o;
endproperty
assert property(af_p821);

property af_p822;
@(posedge mtx_clk_pad_i) $fell(wb_rst_i) |-> (!mtxen_pad_o ##1 !mtxen_pad_o ##1 !mtxen_pad_o);
endproperty
assert property(af_p822);

property af_p823;
@(posedge mtx_clk_pad_i) (!mtxen_pad_o && (mtxd_pad_o !== '0)) |=> mtxen_pad_o;
endproperty
assert property(af_p823);

property af_p824;
@(posedge mtx_clk_pad_i) mtxen_pad_o |-> (mtxd_pad_o !== 'x);
endproperty
assert property(af_p824);

property af_p825;
@(posedge mtx_clk_pad_i) (mtxd_pad_o === 'x) |=> !mtxen_pad_o;
endproperty
assert property(af_p825);

property af_p826;
@(posedge mtx_clk_pad_i) wb_rst_i |-> (!mtxen_pad_o ##1 !mtxen_pad_o);
endproperty
assert property(af_p826);

property af_p827;
@(posedge mtx_clk_pad_i) mtxen_pad_o |-> m_wb_cyc_o;
endproperty
assert property(af_p827);

property af_p828;
@(posedge mtx_clk_pad_i) mtxen_pad_o |-> ($stable(mtxen_pad_o) || $fell(mtxen_pad_o));
endproperty
assert property(af_p828);

property af_p829;
@(posedge mtx_clk_pad_i) (mtxerr_pad_o) |-> (mtxen_pad_o == 1'b0);
endproperty
assert property(af_p829);

property af_p830;
@(posedge mtx_clk_pad_i) (!mcrs_pad_i) |-> (mtxen_pad_o == 1'b0);
endproperty
assert property(af_p830);

property af_p831;
@(posedge mtx_clk_pad_i) ($fell(wb_rst_i)) |-> (mtxen_pad_o == 1'b0);
endproperty
assert property(af_p831);

property af_p832;
@(posedge mtx_clk_pad_i) (mtxen_pad_o) |-> ($isunknown(mtxd_pad_o) == 1'b0);
endproperty
assert property(af_p832);

property af_p833;
@(posedge mtx_clk_pad_i) (wb_rst_i) |-> ($stable(mtxen_pad_o));
endproperty
assert property(af_p833);

property af_p834;
@(posedge mtx_clk_pad_i) ($fell(mtxen_pad_o)) |-> ##[1:1] (mtxen_pad_o == 1'b0);
endproperty
assert property(af_p834);

property af_p835;
@(posedge mtx_clk_pad_i) ($fell(mtxen_pad_o)) |-> ($past(mtxd_pad_o) !== mtxd_pad_o);
endproperty
assert property(af_p835);

property af_p836;
@(posedge mtx_clk_pad_i) ($fell(wb_rst_i)) |-> (mtxen_pad_o == 1'b0) throughout (!mtxen_pad_o[->1]);
endproperty
assert property(af_p836);

property af_p837;
@(posedge mtx_clk_pad_i) ($fell(wb_rst_i)) |-> (mtxen_pad_o == 1'b0) [*2];
endproperty
assert property(af_p837);

property af_p838;
@(posedge mtx_clk_pad_i) (mtxen_pad_o && $isunknown(mtxd_pad_o)) |=> mtxerr_pad_o;
endproperty
assert property(af_p838);

property af_p839;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> (mtxerr_pad_o == 1'b0)[*4];
endproperty
assert property(af_p839);

property af_p840;
@(posedge mtx_clk_pad_i) !mtxen_pad_o |-> !mtxerr_pad_o;
endproperty
assert property(af_p840);

property af_p841;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> (mtxerr_pad_o == 1'b0);
endproperty
assert property(af_p841);

property af_p842;
@(posedge mtx_clk_pad_i) mtxerr_pad_o |-> mtxen_pad_o;
endproperty
assert property(af_p842);

property af_p843;
@(posedge wb_clk_i) $changed(mtxerr_pad_o) |-> $rose(mtx_clk_pad_i);
endproperty
assert property(af_p843);

property af_p844;
@(posedge mtx_clk_pad_i) $changed(mtxerr_pad_o) |-> ($changed(mtxen_pad_o) || $changed(mtxd_pad_o));
endproperty
assert property(af_p844);

property af_p845;
@(posedge mtx_clk_pad_i) mtxerr_pad_o |-> (mtxd_pad_o == 4'hF);
endproperty
assert property(af_p845);

property af_p846;
@(posedge mtx_clk_pad_i) (mtxerr_pad_o !== $past(mtxerr_pad_o)) |-> ($stable(mtxerr_pad_o) == 0);
endproperty
assert property(af_p846);

property af_p847;
@(posedge wb_rst_i) (wb_rst_i) |-> (mtxerr_pad_o == 1'b0);
endproperty
assert property(af_p847);

property af_p848;
@(posedge mtxen_pad_o) (!mtxen_pad_o) |-> (mtxerr_pad_o == 1'b0);
endproperty
assert property(af_p848);

property af_p849;
@(posedge mtx_clk_pad_i) ($fell(mtxen_pad_o)) |-> (mtxerr_pad_o == $past(mtxerr_pad_o));
endproperty
assert property(af_p849);

property af_p850;
@(posedge mtx_clk_pad_i) (!mtxen_pad_o) |-> (mtxerr_pad_o == 1'b0);
endproperty
assert property(af_p850);

property af_p851;
@(posedge mtx_clk_pad_i) ($rose(mtxerr_pad_o) && !mtxd_pad_o) |=> (mtxerr_pad_o == 1'b0);
endproperty
assert property(af_p851);

property af_p852;
@(posedge mtx_clk_pad_i) ($stable(mtxd_pad_o)) |-> (mtxerr_pad_o == 1'b0);
endproperty
assert property(af_p852);

property af_p853;
@(posedge mtx_clk_pad_i) (mtxerr_pad_o) |-> (mtxen_pad_o);
endproperty
assert property(af_p853);

property af_p854;
@(posedge wb_clk_i) $rose(mtxerr_pad_o) |-> ##[1:2] (!mtxerr_pad_o);
endproperty
assert property(af_p854);

property af_p855;
@(posedge mtx_clk_pad_i) $fell(wb_rst_i) |-> (mtxerr_pad_o == 1'b0) ##1 (mtxerr_pad_o == 1'b0) ##1 (mtxerr_pad_o == 1'b0) ##1 (mtxerr_pad_o == 1'b0);
endproperty
assert property(af_p855);

property af_p856;
@(posedge mtx_clk_pad_i) mtxerr_pad_o |-> ##1 (!mtxerr_pad_o || mtxen_pad_o);
endproperty
assert property(af_p856);

property af_p857;
@(posedge mtx_clk_pad_i) $fell(wb_rst_i) |-> (mtxerr_pad_o == 1'b0) ##1 (mtxerr_pad_o == 1'b0);
endproperty
assert property(af_p857);

property af_p858;
@(posedge mtx_clk_pad_i) $rose(mtxerr_pad_o) |-> ##1 (!mtxerr_pad_o);
endproperty
assert property(af_p858);

property af_p859;
@(posedge mtx_clk_pad_i) $fell(wb_rst_i) |-> (mtxerr_pad_o == 1'b0);
endproperty
assert property(af_p859);

property af_p860;
@(posedge mtx_clk_pad_i) (!mcoll_pad_i && !mcrs_pad_i) |-> (mtxerr_pad_o == 1'b0);
endproperty
assert property(af_p860);

property af_p861;
@(posedge mtx_clk_pad_i) (wb_rst_i) |-> (mtxerr_pad_o == 1'b0);
endproperty
assert property(af_p861);

property af_p862;
@(posedge mtx_clk_pad_i) (!mtxen_pad_o) |-> (mtxerr_pad_o == $past(mtxerr_pad_o));
endproperty
assert property(af_p862);


property af_p864;
@(posedge wb_clk_i) (!md_padoe_o) |-> (md_pad_i === md_pad_i);
endproperty
assert property(af_p864);

property af_p865;
@(posedge wb_clk_i) (m_wb_cyc_o && !m_wb_ack_i && !m_wb_err_i) |=> m_wb_cyc_o;
endproperty
assert property(af_p865);

property af_p866;
@(posedge wb_clk_i) (wb_rst_i) |=> (!m_wb_cyc_o && !m_wb_stb_o);
endproperty
assert property(af_p866);



property af_p869;
@(posedge wb_clk_i) (mtxen_pad_o) |-> (!mtxerr_pad_o);
endproperty
assert property(af_p869);

property af_p870;
@(posedge wb_clk_i) (m_wb_stb_o) |-> ($stable(m_wb_adr_o));
endproperty
assert property(af_p870);

property af_p871;
@(posedge wb_clk_i) (md_padoe_o) |-> (md_pad_o === md_pad_o);
endproperty
assert property(af_p871);




property af_p875;
@(posedge wb_clk_i) md_padoe_o |-> !$isunknown(md_pad_o);
endproperty
assert property(af_p875);



property af_p878;
@(posedge wb_clk_i) (m_wb_we_o && !m_wb_ack_i) |=> $stable(m_wb_dat_o);
endproperty
assert property(af_p878);



property af_p881;
@(posedge wb_clk_i) $stable(md_padoe_o) |-> $stable(md_pad_o);
endproperty
assert property(af_p881);


property af_p883;
@(posedge wb_clk_i) (md_padoe_o && $past(md_padoe_o)) |-> $stable(md_pad_o);
endproperty
assert property(af_p883);


property af_p885;
@(posedge wb_clk_i) (wb_rst_i) |-> (md_padoe_o == 1'b0);
endproperty
assert property(af_p885);

property af_p886;
@(posedge wb_clk_i) (m_wb_stb_o) |-> (m_wb_sel_o == 4'b1111);
endproperty
assert property(af_p886);





property af_p891;
@(posedge wb_clk_i) ($isunknown(md_pad_o) == 0) |-> ##[1:2] $changed(mdc_pad_o);
endproperty
assert property(af_p891);

property af_p892;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> (mtxen_pad_o == 1'b0) && (mtxd_pad_o == 4'b0000);
endproperty
assert property(af_p892);

property af_p893;
@(posedge wb_clk_i) (m_wb_cyc_o) |-> $stable(m_wb_we_o);
endproperty
assert property(af_p893);



property af_p896;
@(posedge wb_clk_i) $rose(!wb_rst_i) |-> ##4 ((wb_adr_i >= 0) && (wb_adr_i <= 1023));
endproperty
assert property(af_p896);

property af_p897;
@(posedge wb_clk_i) (!wb_rst_i) |-> ((wb_adr_i >= 0) && (wb_adr_i <= 255))[*2];
endproperty
assert property(af_p897);

property af_p898;
@(posedge wb_clk_i) ((wb_adr_i >= 200) && (wb_adr_i <= 255)) |-> ##[1:2] ((wb_adr_i >= 180) && (wb_adr_i <= 255));
endproperty
assert property(af_p898);

property af_p899;
@(posedge wb_clk_i) (!wb_rst_i) |-> ((wb_adr_i >= 128) && (wb_adr_i <= 255)) ##1 (!wb_rst_i throughout ((wb_adr_i >= 128) && (wb_adr_i <= 255))[*1]);
endproperty
assert property(af_p899);

property af_p900;
@(posedge wb_clk_i) ((wb_adr_i >= 0) && (wb_adr_i <= 31)) |=> ((wb_adr_i >= 0) && (wb_adr_i <= 31));
endproperty
assert property(af_p900);

property af_p901;
@(posedge wb_clk_i) ((wb_adr_i >= 0) && (wb_adr_i <= 127)) |=> ((wb_adr_i >= 0) && (wb_adr_i <= 255));
endproperty
assert property(af_p901);

property af_p902;
@(posedge wb_clk_i) (!wb_rst_i) |-> ((wb_adr_i >= 0) && (wb_adr_i <= 255));
endproperty
assert property(af_p902);

property af_p903;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##1 ((wb_adr_i >= 0) && (wb_adr_i <= 7));
endproperty
assert property(af_p903);

property af_p904;
@(posedge wb_clk_i) ((wb_adr_i >= 32) && (wb_adr_i <= 63)) |-> ##1 ((wb_adr_i >= 0) && (wb_adr_i <= 63));
endproperty
assert property(af_p904);

property af_p905;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((wb_adr_i >= 0) && (wb_adr_i <= 63));
endproperty
assert property(af_p905);

property af_p906;
@(posedge wb_clk_i) ((wb_adr_i >= 64) && (wb_adr_i <= 127)) |-> ##1 ((wb_adr_i >= 0) && (wb_adr_i <= 127));
endproperty
assert property(af_p906);

property af_p907;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((wb_adr_i >= 0) && (wb_adr_i <= 15));
endproperty
assert property(af_p907);

property af_p908;
@(posedge wb_clk_i) ((wb_adr_i >= 0) && (wb_adr_i <= 255)) |-> ##1 ((wb_adr_i >= 0) && (wb_adr_i <= 255));
endproperty
assert property(af_p908);

property af_p909;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> (wb_adr_i == 0) throughout (!wb_rst_i)[->1];
endproperty
assert property(af_p909);

property af_p910;
@(posedge wb_clk_i) (!wb_rst_i) |-> (wb_adr_i >= 0) && (wb_adr_i <= 255);
endproperty
assert property(af_p910);

property af_p911;
@(posedge wb_clk_i) ((wb_adr_i >= 64) && (wb_adr_i <= 127)) |-> ##1 ((wb_adr_i >= 32) && (wb_adr_i <= 159));
endproperty
assert property(af_p911);

property af_p912;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##3 ((wb_adr_i >= 0) && (wb_adr_i <= 511));
endproperty
assert property(af_p912);

property af_p913;
@(posedge wb_clk_i) ((wb_adr_i >= 0) && (wb_adr_i <= 127)) |-> ##1 ((wb_adr_i >= 0) && (wb_adr_i <= 127));
endproperty
assert property(af_p913);

property af_p914;
@(posedge wb_clk_i) ((wb_adr_i >= 64) && (wb_adr_i <= 95)) |-> ##1 ((wb_adr_i >= 32) && (wb_adr_i <= 127));
endproperty
assert property(af_p914);

property af_p915;
@(posedge wb_clk_i) (wb_rst_i) |-> $stable(wb_adr_i);
endproperty
assert property(af_p915);

property af_p916;
@(posedge wb_clk_i) (!wb_rst_i) |-> (!$isunknown(wb_adr_i));
endproperty
assert property(af_p916);

property af_p917;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ((wb_adr_i >= 0) && (wb_adr_i <= 15));
endproperty
assert property(af_p917);

property af_p918;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 ((wb_adr_i >= 0) && (wb_adr_i <= 31));
endproperty
assert property(af_p918);

property af_p919;
@(posedge wb_clk_i) ($rose(mdc_pad_o)) |-> ##[1:$] $fell(mdc_pad_o);
endproperty
assert property(af_p919);

property af_p920;
@(posedge wb_clk_i) (1'b1) |=> $stable(wb_adr_i);
endproperty
assert property(af_p920);

property af_p921;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##1 (!wb_rst_i)[*10];
endproperty
assert property(af_p921);

property af_p922;
@(posedge wb_clk_i) (m_wb_ack_i) |=> $stable(m_wb_dat_o);
endproperty
assert property(af_p922);

property af_p923;
@(posedge wb_clk_i) (wb_rst_i) |-> ##[0:2] (!m_wb_cyc_o);
endproperty
assert property(af_p923);

property af_p924;
@(posedge wb_clk_i) (1'b1) |=> (wb_clk_i == 1'b0);
endproperty
assert property(af_p924);

property af_p925;
@(posedge wb_clk_i) 1'b1 |=> (wb_clk_i == 1'b0);
endproperty
assert property(af_p925);

property af_p926;
@(posedge wb_clk_i) (m_wb_ack_i) |-> (m_wb_dat_o == m_wb_dat_i);
endproperty
assert property(af_p926);

property af_p927;
@(posedge wb_clk_i) 1'b1 |=> $stable(m_wb_dat_o) || $changed(m_wb_dat_o);
endproperty
assert property(af_p927);

property af_p928;
@(posedge wb_clk_i) 1'b1 |-> $stable(wb_dat_i);
endproperty
assert property(af_p928);

property af_p929;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 $rose(m_wb_cyc_o);
endproperty
assert property(af_p929);

property af_p930;
@(posedge wb_clk_i) (m_wb_stb_o) |-> $stable(wb_adr_i);
endproperty
assert property(af_p930);

property af_p931;
@(posedge wb_clk_i) (!wb_rst_i) |-> (wb_dat_i == wb_dat_i);
endproperty
assert property(af_p931);

property af_p932;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##[1:2] $stable(wb_adr_i);
endproperty
assert property(af_p932);

property af_p933;
@(posedge wb_clk_i) (m_wb_ack_i) |-> 1'b1;
endproperty
assert property(af_p933);

property af_p934;
@(posedge wb_clk_i) (!wb_rst_i) |-> (wb_adr_i == wb_adr_i);
endproperty
assert property(af_p934);

property af_p935;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ($stable(int_o))[*4];
endproperty
assert property(af_p935);

property af_p936;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> !m_wb_ack_i;
endproperty
assert property(af_p936);

property af_p937;
@(posedge wb_clk_i) m_wb_cyc_o |-> ($stable(m_wb_bte_o) && $stable(m_wb_cti_o));
endproperty
assert property(af_p937);

property af_p938;
@(posedge wb_clk_i) 1'b1 |-> ($sampled(wb_rst_i) == wb_rst_i);
endproperty
assert property(af_p938);

property af_p939;
@(posedge wb_clk_i) m_wb_stb_o |-> m_wb_cyc_o;
endproperty
assert property(af_p939);

property af_p940;
@(posedge wb_clk_i) m_wb_stb_o |-> ##1 $stable(m_wb_adr_o);
endproperty
assert property(af_p940);

property af_p941;
@(posedge wb_clk_i) wb_rst_i |=> (!m_wb_cyc_o && !m_wb_stb_o && !m_wb_we_o);
endproperty
assert property(af_p941);

property af_p942;
@(posedge wb_clk_i) m_wb_err_i |=> !m_wb_cyc_o;
endproperty
assert property(af_p942);

property af_p943;
@(posedge wb_clk_i) m_wb_cyc_o |-> $stable(m_wb_sel_o);
endproperty
assert property(af_p943);

property af_p944;
@(posedge wb_clk_i) ((wb_dat_i >= 10) && (wb_dat_i <= 20))[*2] |=> ((wb_dat_i >= 21) && (wb_dat_i <= 40));
endproperty
assert property(af_p944);

property af_p945;
@(posedge wb_clk_i) ((wb_dat_i >= 100) && (wb_dat_i <= 150)) |=> ((wb_dat_i >= 80) && (wb_dat_i <= 150));
endproperty
assert property(af_p945);

property af_p946;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##5 ((wb_dat_i >= 10) && (wb_dat_i <= 245));
endproperty
assert property(af_p946);

property af_p947;
@(posedge wb_clk_i) ((wb_dat_i >= 0) && (wb_dat_i <= 255)) |=> ((wb_dat_i >= 0) && (wb_dat_i <= 255));
endproperty
assert property(af_p947);

property af_p948;
@(posedge wb_clk_i) ((!wb_rst_i) && $stable(wb_adr_i)) |-> $stable(wb_dat_i);
endproperty
assert property(af_p948);

property af_p949;
@(posedge wb_clk_i) $stable(wb_adr_i) |=> (((wb_dat_i >= 0) && (wb_dat_i <= 255)) && $stable(wb_dat_i))[*2];
endproperty
assert property(af_p949);

property af_p950;
@(posedge wb_clk_i) (wb_rst_i) |-> (wb_dat_i == $past(wb_dat_i));
endproperty
assert property(af_p950);

property af_p951;
@(posedge wb_clk_i) ((wb_dat_i >= 100) && (wb_dat_i <= 150)) |=> ((wb_dat_i >= 80) && (wb_dat_i <= 170));
endproperty
assert property(af_p951);

property af_p952;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> (((wb_dat_i >= 0) && (wb_dat_i <= 255)) && (wb_dat_i != $past(wb_dat_i)));
endproperty
assert property(af_p952);

property af_p953;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((wb_dat_i >= 0) && (wb_dat_i <= 255));
endproperty
assert property(af_p953);

property af_p954;
@(posedge wb_clk_i) 1'b1 |-> ((wb_dat_i >= 0) && (wb_dat_i <= 255));
endproperty
assert property(af_p954);

property af_p955;
@(posedge wb_clk_i) ($past(wb_adr_i) == wb_adr_i) |-> ($past(wb_dat_i) == wb_dat_i);
endproperty
assert property(af_p955);

property af_p956;
@(posedge wb_clk_i) ((wb_dat_i >= 200) && (wb_dat_i <= 255)) |-> ##1 ((wb_dat_i >= 180) && (wb_dat_i <= 255));
endproperty
assert property(af_p956);

property af_p957;
@(posedge wb_clk_i) (($past(wb_dat_i) >= 0) && ($past(wb_dat_i) <= 127) && (wb_dat_i >= 128) && (wb_dat_i <= 255)) |-> 1'b1;
endproperty
assert property(af_p957);

property af_p958;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> ((wb_dat_i >= 0) && (wb_dat_i <= 15));
endproperty
assert property(af_p958);

property af_p959;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##3 ((wb_dat_i >= 50) && (wb_dat_i <= 200));
endproperty
assert property(af_p959);

property af_p960;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##2 ((wb_dat_i >= 50) && (wb_dat_i <= 200));
endproperty
assert property(af_p960);

property af_p961;
@(posedge wb_clk_i) $fell(wb_rst_i) |-> ##4 ((wb_dat_i >= 0) && (wb_dat_i <= 255));
endproperty
assert property(af_p961);

property af_p962;
@(posedge wb_clk_i) (wb_rst_i) |-> (wb_dat_i == 8'd0);
endproperty
assert property(af_p962);

property af_p963;
@(posedge wb_clk_i) (!wb_rst_i) |-> (wb_dat_i >= 0) && (wb_dat_i <= 255);
endproperty
assert property(af_p963);

property af_p964;
@(posedge wb_clk_i) (wb_rst_i) |-> (wb_dat_i >= 0) && (wb_dat_i <= 63);
endproperty
assert property(af_p964);



property af_p967;
@(posedge wb_clk_i) (wb_adr_i !== 'x) |-> (wb_dat_i throughout (##1 1));
endproperty
assert property(af_p967);

property af_p968;
@(posedge wb_clk_i) $rose(~wb_rst_i) |-> ##3 ((wb_dat_i >= 0) && (wb_dat_i <= 63));
endproperty
assert property(af_p968);

property af_p969;
@(posedge wb_clk_i) (wb_dat_i > 128) |-> ##1 (wb_dat_i >= 64);
endproperty
assert property(af_p969);

property af_p970;
@(posedge wb_clk_i) ((wb_dat_i >= 100) && (wb_dat_i <= 150)) |-> ##1 ((wb_dat_i >= 50) && (wb_dat_i <= 200));
endproperty
assert property(af_p970);

property af_p971;
@(posedge wb_clk_i) $rose(wb_rst_i) |-> ##4 ((wb_dat_i >= 0) && (wb_dat_i <= 63));
endproperty
assert property(af_p971);

property af_p972;
@(posedge wb_clk_i) wb_rst_i |=> (m_wb_cyc_o == 1'b0);
endproperty
assert property(af_p972);

property af_p973;
@(posedge wb_clk_i) wb_rst_i |=> $stable(mdc_pad_o);
endproperty
assert property(af_p973);

property af_p974;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> (m_wb_sel_o == '0);
endproperty
assert property(af_p974);

property af_p975;
@(posedge wb_clk_i) wb_rst_i |=> $stable(m_wb_dat_o);
endproperty
assert property(af_p975);

property af_p976;
@(posedge wb_clk_i) $rose(wb_rst_i) |=> (md_padoe_o == 1'b1) throughout wb_rst_i[->1];
endproperty
assert property(af_p976);

property af_p977;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> ##3 (m_wb_sel_o == '0);
endproperty
assert property(af_p977);

property af_p978;
@(posedge wb_clk_i) wb_rst_i |=> (m_wb_adr_o == '0);
endproperty
assert property(af_p978);

property af_p979;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> (mtxen_pad_o == 1'b0)[*2];
endproperty
assert property(af_p979);

property af_p980;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> ((m_wb_dat_o >= 0) && (m_wb_dat_o <= 0))[*3];
endproperty
assert property(af_p980);

property af_p981;
@(posedge wb_clk_i) $fell(wb_rst_i) |=> (m_wb_adr_o == '0)[*2];
endproperty
assert property(af_p981);

property af_p982;
@(posedge wb_clk_i) (!wb_rst_i) |-> ##3 (m_wb_cyc_o == 1'b1);
endproperty
assert property(af_p982);

property af_p983;
@(posedge wb_clk_i) (wb_rst_i) |=> (m_wb_stb_o == 1'b0);
endproperty
assert property(af_p983);

property af_p984;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_cyc_o == 1'b0);
endproperty
assert property(af_p984);

property af_p985;
@(posedge wb_clk_i) (wb_rst_i) |-> (int_o == 1'b0);
endproperty
assert property(af_p985);

property af_p986;
@(posedge wb_clk_i) (!wb_rst_i) |=> ($isunknown(m_wb_we_o) == 1'b0);
endproperty
assert property(af_p986);

property af_p987;
@(posedge wb_clk_i) (!wb_rst_i) |-> ##4 (m_wb_adr_o == wb_adr_i);
endproperty
assert property(af_p987);

property af_p988;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_ack_i == 1'b0);
endproperty
assert property(af_p988);

property af_p989;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_cti_o == 3'b000) && (m_wb_bte_o == 2'b00);
endproperty
assert property(af_p989);

property af_p990;
@(posedge wb_clk_i) (wb_rst_i) |-> (mtxen_pad_o == 1'b0);
endproperty
assert property(af_p990);

property af_p991;
@(posedge wb_clk_i) disable iff (wb_rst_i) $stable(m_wb_we_o) until_with ($changed(wb_adr_i));
endproperty
assert property(af_p991);

property af_p992;
@(posedge wb_clk_i) (wb_rst_i) |-> (m_wb_stb_o == 1'b0);
endproperty
assert property(af_p992);

property af_p993;
@(posedge wb_clk_i) (wb_rst_i) |-> ($stable(wb_dat_i) || !$stable(wb_dat_i));
endproperty
assert property(af_p993);

property af_p994;
@(posedge wb_clk_i) (wb_rst_i) |=> (int_o == 1'b0);
endproperty
assert property(af_p994);

property af_p995;
@(posedge wb_clk_i) ($rose(wb_rst_i)) |=> (md_padoe_o == 1'b0);
endproperty
assert property(af_p995);

property af_p996;
@(posedge wb_clk_i) (wb_rst_i) |-> ($stable(m_wb_err_i) || !$stable(m_wb_err_i));
endproperty
assert property(af_p996);

property af_p997;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |=> (m_wb_we_o == 1'b0);
endproperty
assert property(af_p997);

property af_p998;
@(posedge wb_clk_i) ($fell(wb_rst_i)) |-> ##4 (md_padoe_o inside {[0:1]});
endproperty
assert property(af_p998);




endmodule
