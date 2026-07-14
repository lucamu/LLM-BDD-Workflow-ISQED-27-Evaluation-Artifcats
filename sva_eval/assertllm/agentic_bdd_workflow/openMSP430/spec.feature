Feature: openMSP430 Core Formal Verification
  Formal properties for the openMSP430 16-bit microcontroller core covering
  reset behavior, memory interfaces, interrupt handling, DMA protocol,
  low-power clock management, watchdog, and serial debug interface.

  Background:
    Given the design is synchronous to the rising edge of mclk
    And puc_rst is the synchronous system reset signal for the mclk domain
    And reset_n is the asynchronous active-low external reset pin

  # -----------------------------------------------------------------
  # RESET / PUC BEHAVIOR
  # -----------------------------------------------------------------

  @reset
  Formal Scenario: Asynchronous reset asserts puc_rst
    Given reset_n is deasserted (driven to 0)
    When one mclk rising edge occurs
    Then puc_rst should be 1

  @reset
  Formal Scenario: puc_rst deasserts synchronously after reset release
    Given reset_n is asserted (driven to 1)
    And puc_rst is currently 1
    And no watchdog reset condition and no debug reset condition are active
    When one mclk rising edge occurs
    Then puc_rst should be 0

  @reset
  Formal Scenario: Watchdog timeout generates PUC reset
    Given the WATCHDOG feature is included
    And the watchdog counter reaches its terminal count in watchdog mode
    When one mclk rising edge occurs
    Then puc_rst should be 1

  @reset
  Formal Scenario: Debug interface software reset generates PUC reset
    Given the DBG_EN feature is enabled
    And CPU_CTL.CPU_RST is written with value 1
    When one mclk rising edge occurs
    Then puc_rst should be 1

  @reset
  Formal Scenario: CPU_CTL reset value depends on DBG_RST_BRK_EN configuration
    Given a POR event (puc_rst asserted then released) has just completed
    And the DBG_RST_BRK_EN configuration option is set to configValue
    Then CPU_CTL should be 8'h30 if configValue equals 1
    And CPU_CTL should be 8'h10 if configValue equals 0

  # -----------------------------------------------------------------
  # PROGRAM / DATA MEMORY INTERFACE PROTOCOL
  # -----------------------------------------------------------------

  @memory
  Formal Scenario: Program memory chip enable gates address output validity
    Given pmem_cen is driven to logic value cenValue
    And pmem_addr is driven to address value addrA
    When one mclk rising edge occurs
    Then the program memory access should be performed if cenValue equals 0
    And no program memory access should be performed if cenValue equals 1

  @memory
  Formal Scenario: Data memory write byte enable controls byte writes
    Given dmem_cen is driven to 0 (active)
    And dmem_wen is driven to a 2-bit value wenValue
    And dmem_din is driven to data value dataIn
    And dmem_addr is driven to address value addrD
    When one mclk rising edge occurs
    Then the lower byte at addrD should be written with dataIn[7:0] if wenValue[0] equals 0
    And the upper byte at addrD should be written with dataIn[15:8] if wenValue[1] equals 0
    And no byte at addrD should be written if wenValue equals 2'b11

  @memory
  Formal Scenario: Data memory output updates only on valid access
    Given dmem_cen is driven to logic value cenValue
    And dmem_dout currently holds value prevDout
    When one mclk rising edge occurs
    Then dmem_dout should be updated with the memory content if cenValue equals 0
    And dmem_dout should retain prevDout if cenValue equals 1

  @memory
  Formal Scenario: Peripheral read data is combinational with per_en
    Given per_en is driven to logic value enValue
    And per_addr is driven to address value addrP
    And the addressed peripheral register holds value regValue
    Then per_dout should equal regValue during the same mclk cycle if enValue equals 1
    And per_dout should equal 0 if enValue equals 0

  @memory
  Formal Scenario: Peripheral write byte enable is high-active
    Given per_en is driven to 1
    And per_we is driven to a 2-bit value weValue
    And per_din is driven to data value dataInP
    And per_addr is driven to address value addrPer
    When one mclk rising edge occurs
    Then the lower byte of the addressed peripheral register should be written with dataInP[7:0] if weValue[0] equals 1
    And the upper byte of the addressed peripheral register should be written with dataInP[15:8] if weValue[1] equals 1

  # -----------------------------------------------------------------
  # INTERRUPT PRIORITY AND VECTOR MAPPING
  # -----------------------------------------------------------------

  @interrupt
  Formal Scenario: NMI has higher priority than any maskable IRQ
    Given nmi is asserted (driven to 1)
    And an arbitrary irq bus value irqBus is simultaneously pending
    And NMIIE is set to 1
    When the interrupt arbitration evaluates pending requests
    Then the NMI vector (0xFFFC) should be serviced before any IRQ vector

  @interrupt
  Formal Scenario: Higher indexed IRQ bit has higher priority than lower indexed IRQ bit
    Given two distinct IRQ bit indices indexHigh and indexLow are simultaneously pending
    And indexHigh is greater than indexLow
    And GIE is set to 1
    When the interrupt arbitration evaluates pending requests
    Then the interrupt at indexHigh should be serviced before the interrupt at indexLow

  @interrupt
  Formal Scenario: IRQ vector address maps to fixed offset from IRQ index
    Given a single active IRQ bit at index irqIndex
    And GIE is set to 1
    When the interrupt is accepted
    Then the fetched vector address should equal 0xFFE0 + 2*irqIndex

  @interrupt
  Formal Scenario: irq_acc reflects the accepted interrupt bit
    Given a single active IRQ bit at index irqIndex is pending
    And GIE is set to 1
    When the CPU accepts the interrupt
    Then irq_acc[irqIndex] should be 1
    And all other bits of irq_acc should be 0

  # -----------------------------------------------------------------
  # DMA INTERFACE PROTOCOL
  # -----------------------------------------------------------------

  @dma
  Formal Scenario: DMA read transfer returns data after ready is asserted
    Given the DMA_IF_EN feature is enabled
    And dma_en is driven to 1
    And dma_we is driven to 2'b00 (read)
    And dma_addr is driven to address value dmaAddr
    And the memory location at dmaAddr holds value memVal
    When dma_ready is asserted
    Then dma_dout should equal memVal
    And dma_resp should be 0

  @dma
  Formal Scenario: DMA write transfer writes din to addressed location
    Given the DMA_IF_EN feature is enabled
    And dma_en is driven to 1
    And dma_we is driven to a nonzero 2-bit value dmaWe
    And dma_addr is driven to address value dmaAddrW
    And dma_din is driven to data value dmaDataIn
    When dma_ready is asserted
    Then the memory location at dmaAddrW should hold dmaDataIn according to dmaWe byte selection

  @dma
  Formal Scenario: DMA access to unmapped address returns error response
    Given the DMA_IF_EN feature is enabled
    And dma_en is driven to 1
    And dma_addr targets an address outside any mapped program, data, or peripheral region
    When dma_ready is asserted
    Then dma_resp should be 1
    And no wait state should have been inserted for this transfer

  @dma
  Formal Scenario: High priority DMA transfer completes without wait states
    Given the DMA_IF_EN feature is enabled
    And dma_en is driven to 1
    And dma_priority is driven to 1
    And dma_addr targets a validly mapped resource
    When one mclk rising edge occurs
    Then dma_ready should be 1 on that same edge

  @dma
  Formal Scenario: Low priority DMA transfer waits when CPU accesses same resource
    Given the DMA_IF_EN feature is enabled
    And dma_en is driven to 1
    And dma_priority is driven to 0
    And the CPU is simultaneously accessing the same resource as dma_addr
    When one mclk rising edge occurs
    Then dma_ready should be 0 until the CPU access to that resource completes

  @dma
  Formal Scenario: DMA wakeup restores MCLK_DMA in low power mode
    Given the ASIC_CLOCKING configuration is enabled
    And the CPU is in a Low-Power-Mode with MCLK_CPU off
    And dma_wkup is asserted
    Then MCLK_DMA should be restored (running)
    And MCLK_CPU should remain off

  # -----------------------------------------------------------------
  # LOW POWER MODE / CLOCK MANAGEMENT
  # -----------------------------------------------------------------

  @clocking
  Formal Scenario: CPUOFF gates MCLK while preserving state machine idle
    Given the CPUOFF_EN feature is included
    And status register bit CPUOFF is set to 1 by a BIS or MOV instruction to R2
    And the CPU state machines have reached IDLE state
    Then MCLK should be gated off

  @clocking
  Formal Scenario: SCG1 gates SMCLK
    Given the SCG1_EN feature is included
    And status register bit SCG1 is set to sc1Value
    Then SMCLK should be gated off if sc1Value equals 1
    And SMCLK should be running if sc1Value equals 0

  @clocking
  Formal Scenario: SCG0 controls DCO oscillator enable
    Given the SCG0_EN feature is included
    And status register bit SCG0 is set to scg0Value
    And no wakeup event is pending
    Then dco_enable should be 0 if scg0Value equals 1
    And dco_enable should be 1 if scg0Value equals 0

  @clocking
  Formal Scenario: Wakeup event asynchronously asserts DCO_WKUP before DCO_ENABLE
    Given the CPU is in a low power mode with SCG0 set to 1
    And a peripheral asserts the wkup input
    Then dco_wkup should be asserted asynchronously before MCLK is restored
    And dco_enable should be synchronously set only after the CPU state machines are reactivated

  @clocking
  Formal Scenario: Clock mux in scan mode forces DCO_CLK selection
    Given scan_mode is driven to 1
    And BCSCTL2.SELMx is driven to any selection value selVal
    Then the MCLK mux output should select dco_clk regardless of selVal

  # -----------------------------------------------------------------
  # WATCHDOG TIMER
  # -----------------------------------------------------------------

  @watchdog
  Formal Scenario: Watchdog counter increments each qualifying clock edge
    Given the WATCHDOG feature is included
    And the watchdog is not held (WDTHOLD is 0)
    And the watchdog counter currently holds value countVal
    When one qualifying watchdog clock edge occurs
    Then the watchdog counter should hold countVal + 1

  @watchdog
  Formal Scenario: Watchdog interval mode sets WDTIFG on terminal count without reset
    Given the WATCHDOG feature is included
    And WDTTMSEL is set to 1 (interval timer mode)
    And the watchdog counter reaches its configured terminal count
    When one mclk rising edge occurs
    Then WDTIFG should be set to 1
    And puc_rst should remain 0

  @watchdog
  Formal Scenario: Watchdog mode sets PUC reset on terminal count
    Given the WATCHDOG feature is included
    And WDTTMSEL is set to 0 (watchdog mode)
    And the watchdog counter reaches its configured terminal count
    When one mclk rising edge occurs
    Then puc_rst should be 1

  @watchdog
  Formal Scenario: dbg_freeze halts watchdog counter when FRZ_BRK_EN is set
    Given the WATCHDOG feature is included
    And CPU_CTL.FRZ_BRK_EN is set to 1
    And the debug interface has halted the CPU (dbg_freeze is 1)
    And the watchdog counter currently holds value freezeCount
    When one mclk rising edge occurs
    Then the watchdog counter should remain freezeCount

  # -----------------------------------------------------------------
  # SERIAL DEBUG INTERFACE - CPU CONTROL
  # -----------------------------------------------------------------

  @debug
  Formal Scenario: HALT bit stops CPU execution
    Given the DBG_EN feature is enabled
    And dbg_en is driven to 1
    And CPU_CTL.HALT is written with value 1
    When one mclk rising edge occurs
    Then CPU_STAT.HALT_RUN should be 1

  @debug
  Formal Scenario: RUN bit resumes CPU execution from halt
    Given the DBG_EN feature is enabled
    And CPU_STAT.HALT_RUN currently equals 1
    And CPU_CTL.RUN is written with value 1
    When one mclk rising edge occurs
    Then CPU_STAT.HALT_RUN should be 0

  @debug
  Formal Scenario: ISTEP performs single instruction step while halted
    Given the DBG_EN feature is enabled
    And CPU_STAT.HALT_RUN currently equals 1
    And CPU_CTL.ISTEP is written with value 1
    When the single step completes
    Then exactly one instruction should have been executed
    And CPU_STAT.HALT_RUN should return to 1

  @debug
  Formal Scenario: ISTEP and RUN bits are write-only and read as zero
    Given the DBG_EN feature is enabled
    And CPU_CTL.ISTEP was previously written with value 1
    And CPU_CTL.RUN was previously written with value 1
    And CPU_CTL.HALT was previously written with value 1
    When CPU_CTL is read
    Then bit ISTEP should read as 0
    And bit RUN should read as 0
    And bit HALT should read as 0

  @debug
  Formal Scenario: PUC_PND flag is set on any PUC reset occurrence
    Given the DBG_EN feature is enabled
    And puc_rst transitions from 0 to 1
    When one mclk rising edge occurs
    Then CPU_STAT.PUC_PND should be set to 1

  @debug
  Formal Scenario: PUC_PND flag clears only on write of 1
    Given CPU_STAT.PUC_PND currently equals 1
    And CPU_STAT is written with PUC_PND bit set to clearValue
    Then CPU_STAT.PUC_PND should be 0 if clearValue equals 1
    And CPU_STAT.PUC_PND should remain 1 if clearValue equals 0

  @debug
  Formal Scenario: DBG_EN deasserted holds debug interface in reset
    Given dbg_en is driven to 0
    Then the debug interface internal state should be held in reset
    And CPU execution should not be affected by the debug interface state

  # -----------------------------------------------------------------
  # SERIAL DEBUG INTERFACE - MEMORY ACCESS
  # -----------------------------------------------------------------

  @debug
  Formal Scenario: Single memory read via debug interface returns correct data
    Given the DBG_EN feature is enabled
    And MEM_ADDR is set to address value memAddrR
    And MEM_CNT equals 0
    And MEM_CTL.MEM/REG is set to 0 (memory access)
    And MEM_CTL.RD/WR is set to 0 (read)
    And the memory location at memAddrR holds value memContent
    When MEM_CTL.START is written with value 1
    Then MEM_DATA should be updated with memContent after transfer completion

  @debug
  Formal Scenario: Single memory write via debug interface writes correct data
    Given the DBG_EN feature is enabled
    And MEM_ADDR is set to address value memAddrW
    And MEM_DATA is set to value memWriteVal
    And MEM_CNT equals 0
    And MEM_CTL.MEM/REG is set to 0 (memory access)
    And MEM_CTL.RD/WR is set to 1 (write)
    When MEM_CTL.START is written with value 1
    Then the memory location at memAddrW should hold memWriteVal after transfer completion

  @debug
  Formal Scenario: Burst memory access auto-increments MEM_ADDR
    Given the DBG_EN feature is enabled
    And MEM_ADDR is set to address value burstStart
    And MEM_CNT is set to a nonzero burst count burstSize
    And MEM_CTL.B/W selects 16-bit access (B/W equals 0)
    When MEM_CTL.START is written with value 1
    And the first data element of the burst is transferred
    Then MEM_ADDR should be updated to burstStart + 2
    And MEM_CNT should be updated to burstSize - 1

  @debug
  Formal Scenario: CPU_ID fields reflect static configuration parameters
    Given a POR event has just completed
    And the implementation configuration defines PMEM_SIZE_config, DMEM_SIZE_config, MPY_config, ASIC_config, USER_VERSION_config, PER_SPACE_config
    Then CPU_ID_HI.PMEM_SIZE should equal PMEM_SIZE_config
    And CPU_ID_HI.DMEM_SIZE should equal DMEM_SIZE_config
    And CPU_ID_HI.MPY should equal MPY_config
    And CPU_ID_LO.ASIC should equal ASIC_config
    And CPU_ID_LO.USER_VERSION should equal USER_VERSION_config
    And CPU_ID_LO.PER_SPACE should equal PER_SPACE_config

  # -----------------------------------------------------------------
  # HARDWARE BREAKPOINT UNIT
  # -----------------------------------------------------------------

  @debug
  Formal Scenario: Hardware breakpoint triggers on address match in normal mode
    Given a hardware breakpoint unit is included
    And BRKx_CTL.RANGE_MODE is set to 0 (normal mode)
    And BRKx_CTL.BREAK_EN is set to 1
    And BRKx_CTL.ACCESS_MODE is set to a value enabling read or write detection
    And BRKx_ADDR0 is set to address value brkAddr
    When the CPU performs an access matching brkAddr and the configured access type
    Then CPU_STAT.HALT_RUN should transition to 1
    And BRKx_STAT.ADDR0_RD or BRKx_STAT.ADDR0_WR should be set accordingly

  @debug
  Formal Scenario: Hardware breakpoint range mode triggers within address range
    Given a hardware breakpoint unit is included
    And the DBG_HWBRK_RANGE feature is enabled
    And BRKx_CTL.RANGE_MODE is set to 1 (range mode)
    And BRKx_ADDR0 is set to rangeLow and BRKx_ADDR1 is set to rangeHigh
    And BRKx_CTL.BREAK_EN is set to 1
    When the CPU accesses an address addrX such that rangeLow <= addrX <= rangeHigh
    Then the breakpoint condition should be detected
    And BRKx_STAT.RANGE_RD or BRKx_STAT.RANGE_WR should be set according to the access type

  @debug
  Formal Scenario: Watchpoint mode does not halt CPU on match
    Given a hardware breakpoint unit is included
    And BRKx_CTL.BREAK_EN is set to 0 (watchpoint mode)
    And an address match condition occurs as configured
    Then the corresponding status bit in BRKx_STAT should be set
    And CPU_STAT.HALT_RUN should remain unchanged by this event

  # -----------------------------------------------------------------
  # SFR REGISTER BEHAVIOR
  # -----------------------------------------------------------------

  @sfr
  Formal Scenario: WDTIFG sets WDTIE-gated interrupt request
    Given the WATCHDOG feature is included
    And IFG1.WDTIFG is set to 1
    And IE1.WDTIE is set to ieValue
    Then the watchdog interrupt request to the CPU should be asserted if ieValue equals 1
    And the watchdog interrupt request to the CPU should be deasserted if ieValue equals 0

  @sfr
  Formal Scenario: NMIIFG reflects configured NMI edge detection
    Given the NMI feature is included
    And the NMI edge selection bit is set to edgeSel
    And nmi transitions in the direction configured by edgeSel
    When one mclk rising edge occurs after the nmi transition
    Then IFG1.NMIIFG should be set to 1

  # -----------------------------------------------------------------
  # HARDWARE MULTIPLIER
  # -----------------------------------------------------------------

  @multiplier
  Formal Scenario: Unsigned multiplication result equals product of operands
    Given the MULTIPLIER feature is included
    And the multiplier operand register MPY is written with value opA
    And the multiplier operand register OP2 is written with value opB
    And the multiplication mode selected is unsigned (MPY register used)
    When the multiplication completes
    Then the result registers RESLO and RESHI concatenated should equal opA * opB

  @multiplier
  Formal Scenario: Signed multiplication result equals signed product of operands
    Given the MULTIPLIER feature is included
    And the multiplier operand register MPYS is written with signed value opAs
    And the multiplier operand register OP2 is written with signed value opBs
    When the multiplication completes
    Then the result registers RESLO and RESHI concatenated should equal the signed product of opAs and opBs

  @multiplier
  Formal Scenario: MAC mode accumulates product into SUMEXT and result registers
    Given the MULTIPLIER feature is included
    And the multiplier operand register MACS is written with value opAm
    And the multiplier operand register OP2 is written with value opBm
    And the previous result register value equals prevResult
    When the multiply-accumulate completes
    Then the result registers should equal prevResult + (opAm * opBm) truncated to 32 bits
    And SUMEXT should reflect the carry/overflow condition of that addition

  # -----------------------------------------------------------------
  # GPIO PERIPHERAL
  # -----------------------------------------------------------------

  @gpio
  Formal Scenario: GPIO output register drives port data output
    Given Port1 is enabled (P1_EN equals 1)
    And the P1OUT register is written with value outVal
    And p1_dout_en bits corresponding to output-configured pins are set
    Then p1_dout should equal outVal for pins configured as output

  @gpio
  Formal Scenario: GPIO interrupt flag sets on configured edge of input pin
    Given Port1 is enabled
    And the P1IE bit for pin pinIndex is set to 1
    And the P1IES edge selection for pinIndex is set to edgeSelP
    And p1_din[pinIndex] transitions in the direction specified by edgeSelP
    When one mclk rising edge occurs after the transition
    Then P1IFG[pinIndex] should be set to 1
    And irq_port1 should be asserted

  # -----------------------------------------------------------------
  # TIMER A PERIPHERAL
  # -----------------------------------------------------------------

  @timerA
  Formal Scenario: TACCR0 compare match generates irq_ta0
    Given Timer A is included
    And TAR currently equals TACCR0 value ccr0Val
    And the timer is running in a mode that counts up to TACCR0
    When TAR reaches ccr0Val on a qualifying clock edge
    Then irq_ta0 should be asserted

  @timerA
  Formal Scenario: Timer A counter increments with selected clock source
    Given Timer A is included
    And the timer clock source select (TASSEL) picks a clock with enable signal clkEn
    And TAR currently holds value tarVal
    When clkEn is asserted on a qualifying edge and the timer is not held
    Then TAR should update to tarVal + 1 (modulo counting mode wraparound rules)

  # -----------------------------------------------------------------
  # ADDRESS SPACE / CONFIGURATION CONSISTENCY
  # -----------------------------------------------------------------

  @config
  Formal Scenario: Combined memory space does not exceed 64kB
    Given the program memory size is PMEM_SIZE_config bytes
    And the data memory size is DMEM_SIZE_config bytes
    And the peripheral memory size is PER_SIZE_config bytes
    Then PMEM_SIZE_config + DMEM_SIZE_config + PER_SIZE_config should be less than or equal to 65536

  @config
  Formal Scenario: Data memory mapping shifts with peripheral space size
    Given the peripheral memory size is configured to PER_SIZE_config bytes
    Then the data memory base address should equal PER_SIZE_config