Feature: streamScaler Video Stream Resizer Formal Specification

  As a verification engineer
  I want formal properties for the streamScaler design
  So that input/output handshake, frame lifecycle, buffering, coordinate
  progression, and interpolation behavior are provably correct

  Background:
    Given the design is synchronous to "clk"
    And "rst" is active-high and asynchronous
    And when "rst" is asserted all internal control and datapath state is reset
    And "nextDin" is deasserted while "rst" is asserted
    And "dOutValid" is deasserted while "rst" is asserted

  # ---------------------------------------------------------------------
  # Input handshake
  # ---------------------------------------------------------------------

  @input_handshake
  Formal Scenario: Input sample is accepted only on qualified handshake
    Given "dInValid" is value V_VALID
    And "nextDin" is value V_READY
    And "dIn" is value D_IN
    When one clock edge occurs
    Then the internal write-side sample-accept condition should be 1 if and only if V_VALID equals 1 and V_READY equals 1

  @input_handshake
  Formal Scenario: nextDin deasserted at line-buffer capacity limit
    Given internal line-buffer fill count equals the configured capacity limit
    When one clock edge occurs
    Then "nextDin" should be 0

  @input_handshake
  Formal Scenario: nextDin asserted only when fill below capacity and write acceptance active
    Given internal line-buffer fill count is value F
    And write-side acceptance state is value W_ACTIVE
    And the configured line depth is value DEPTH
    When one clock edge occurs
    Then "nextDin" should be 1 only if F is less than DEPTH and W_ACTIVE equals 1

  # ---------------------------------------------------------------------
  # Frame lifecycle
  # ---------------------------------------------------------------------

  @frame_lifecycle
  Formal Scenario: start pulse reinitializes read and write frame state
    Given the module is in any internal state S
    And "start" is asserted for one clock cycle
    When one clock edge occurs
    Then internal read-coordinate state should be reset to its frame-start initial value
    And internal write-coordinate state should be reset to its frame-start initial value

  @frame_lifecycle
  Formal Scenario: frame processing begins only after start deassertion
    Given "start" is deasserted
    And a prior clock cycle had "start" asserted
    When "dInValid" is 1 and "nextDin" is 1
    Then the accepted sample should be treated as the first raster-ordered input sample of the new frame

  @frame_lifecycle
  Formal Scenario: control inputs held stable during active frame processing
    Given "inputXRes", "inputYRes", "outputXRes", "outputYRes", "xScale", "yScale", "leftOffset", "topFracOffset", "nearestNeighbor" are held at fixed values throughout a frame from "start" assertion until output-stream completion
    When the frame is processed
    Then all scaling and coordinate-mapping computations for that frame should use only the stable values captured at frame start

  # ---------------------------------------------------------------------
  # Input discard behavior
  # ---------------------------------------------------------------------

  @input_discard
  Formal Scenario: initial input samples discarded according to inputDiscardCnt
    Given "inputDiscardCnt" is value N
    And a new frame has just started
    When N qualified input samples (dInValid=1 and nextDin=1) are accepted after frame start
    Then none of these N samples should be written into line-buffer storage
    And the (N+1)th qualified input sample should be the first sample written into line-buffer storage

  # ---------------------------------------------------------------------
  # Write control completion
  # ---------------------------------------------------------------------

  @write_completion
  Formal Scenario: write control stops requesting input after final input line processed
    Given "inputYRes" is value Y_RES
    And the current write-side line index equals Y_RES
    And the current line has been fully written
    When one clock edge occurs
    Then write control should enter its completion state
    And "nextDin" should be 0 in the completion state

  # ---------------------------------------------------------------------
  # Buffer fill / backpressure coupling
  # ---------------------------------------------------------------------

  @buffer_fill
  Formal Scenario: readyForRead asserted only when sufficient buffered lines available
    Given internal fill count is value F
    And the minimum required buffered lines for read is value REQ_MIN
    When one clock edge occurs
    Then "readyForRead" should be 1 only if F is greater than or equal to REQ_MIN

  @buffer_fill
  Formal Scenario: fillCount updates deterministically under concurrent advance signals
    Given "advanceWrite" is value AW
    And "advanceRead1" is value AR1
    And "advanceRead2" is value AR2
    And current "fillCount" is value F
    When one clock edge occurs with these signal values applied to ramFifo
    Then next "fillCount" should equal F + AW - AR1 - 2*AR2, saturated within the valid buffer range

  # ---------------------------------------------------------------------
  # Output handshake and read control
  # ---------------------------------------------------------------------

  @output_handshake
  Formal Scenario: output progression only on active readout with downstream request
    Given "nextDout" is value V_NEXT
    And internal read-control active-output state is value V_ACTIVE
    When one clock edge occurs
    Then output coordinate progression should occur if and only if V_NEXT equals 1 and V_ACTIVE equals 1

  @output_handshake
  Formal Scenario: dOut sampled only when dOutValid asserted
    Given "dOutValid" is value V_VALID
    And "dOut" carries value D_OUT
    Then D_OUT should be considered meaningful by downstream logic only if V_VALID equals 1

  @output_handshake
  Formal Scenario: line-switch output suppression does not add advancement under backpressure
    Given "nextDout" is 0
    And "lineSwitchOutputDisable" is asserted for one cycle
    When one clock edge occurs
    Then no additional output coordinate advancement should occur beyond what "nextDout"=0 already implies

  @output_valid_latency
  Formal Scenario: dOutValid latency is four cycles from qualified readout request
    Given an internal qualified readout request R occurs at cycle T
    When four clock edges occur after cycle T
    Then "dOutValid" corresponding to request R should be asserted at cycle T+4

  # ---------------------------------------------------------------------
  # Vertical/horizontal coordinate progression
  # ---------------------------------------------------------------------

  @coordinate_progression
  Formal Scenario: horizontal source coordinate advances by xScale per output pixel
    Given "xScale" is value XS
    And current "xScaleAmount" is value X_CUR
    And an output pixel is consumed (nextDout=1 and active output state)
    When one clock edge occurs
    Then next "xScaleAmount" should equal X_CUR + XS

  @coordinate_progression
  Formal Scenario: vertical source coordinate advances by yScale per output line
    Given "yScale" is value YS
    And current "yScaleAmount" is value Y_CUR
    And an output line boundary is reached
    When one clock edge occurs
    Then next "yScaleAmount" should equal Y_CUR + YS

  @coordinate_progression
  Formal Scenario: advanceRead2 asserted only when accumulated vertical step spans two lines
    Given "yScaleAmount" integer-part delta between consecutive output lines equals value D_LINES
    When D_LINES is greater than or equal to 2
    Then "advanceRead2" should be 1
    And "advanceRead1" should be 0

  @coordinate_progression
  Formal Scenario: advanceRead1 asserted when accumulated vertical step spans exactly one line
    Given "yScaleAmount" integer-part delta between consecutive output lines equals value D_LINES
    When D_LINES equals 1
    Then "advanceRead1" should be 1
    And "advanceRead2" should be 0

  # ---------------------------------------------------------------------
  # Line selection for buffering
  # ---------------------------------------------------------------------

  @line_selection
  Formal Scenario: only lines required for current or adjacent vertical sampling are stored
    Given the current output-line vertical sample requires source lines L and L+1
    And an incoming input line has index IN_LINE
    When IN_LINE is not equal to L and IN_LINE is not equal to L+1
    Then the incoming line should not be written into line-buffer storage

  # ---------------------------------------------------------------------
  # Interpolation datapath - bilinear
  # ---------------------------------------------------------------------

  @interpolation_bilinear
  Formal Scenario: bilinear output is weighted sum of four neighbor samples
    Given "nearestNeighbor" is 0
    And four neighbor samples are readData00=TL, readData01=TR, readData10=BL, readData11=BR
    And blend fractions are xBlend=XB and yBlend=YB
    When one interpolation cycle completes
    Then the per-channel output sample should equal the normalized weighted sum of TL, TR, BL, BR using coefficients derived from XB and YB

  @interpolation_bilinear
  Formal Scenario: bilinear coefficients sum to unity (normalization correctness)
    Given "nearestNeighbor" is 0
    And blend fractions are xBlend=XB and yBlend=YB
    When the four interpolation coefficients are derived
    Then the sum of the four coefficients should equal the fixed-point representation of 1

  # ---------------------------------------------------------------------
  # Interpolation datapath - nearest neighbor
  # ---------------------------------------------------------------------

  @interpolation_nearest
  Formal Scenario: nearest-neighbor mode selects single sample by blend-half decision
    Given "nearestNeighbor" is 1
    And blend fractions are xBlend=XB and yBlend=YB
    And four neighbor samples are readData00=TL, readData01=TR, readData10=BL, readData11=BR
    When one interpolation cycle completes
    Then the per-channel output sample should equal TL if XB is less than half and YB is less than half
    And the per-channel output sample should equal TR if XB is greater than or equal to half and YB is less than half
    And the per-channel output sample should equal BL if XB is less than half and YB is greater than or equal to half
    And the per-channel output sample should equal BR if XB is greater than or equal to half and YB is greater than or equal to half

  # ---------------------------------------------------------------------
  # Multi-channel operation
  # ---------------------------------------------------------------------

  @multi_channel
  Formal Scenario: channel slices process independently with shared coordinate timing
    Given CHANNELS independent channel input slices are present in "dIn"
    And shared read coordinates and blend fractions are identical across channels for a given output pixel
    When one interpolation cycle completes
    Then each channel slice of "dOut" should depend only on its own corresponding channel input samples and the shared blend fractions
    And no channel's output should depend on another channel's input samples

  @multi_channel
  Formal Scenario: dOut channel concatenation order matches dIn channel order
    Given CHANNELS channel slices are indexed 0 to CHANNELS-1 in "dIn"
    When one output sample is produced
    Then channel slice K of "dOut" should correspond to channel slice K of "dIn" for all K from 0 to CHANNELS-1

  # ---------------------------------------------------------------------
  # ramFifo read/write coupling
  # ---------------------------------------------------------------------

  @ramfifo
  Formal Scenario: ramFifo produces four-neighbor samples for given read address
    Given "readAddress" is value ADDR
    And current and adjacent line banks contain buffered data
    When one clock edge occurs
    Then "readData00" should equal the sample at ADDR in the current line bank
    And "readData01" should equal the sample at ADDR+1 in the current line bank
    And "readData10" should equal the sample at ADDR in the adjacent line bank
    And "readData11" should equal the sample at ADDR+1 in the adjacent line bank

  @ramfifo
  Formal Scenario: ramFifo write occurs only when writeEnable asserted
    Given "writeEnable" is value WE
    And "writeData" is value D
    And "writeAddress" is value A
    When one clock edge occurs
    Then the selected write-line storage at address A should be updated to D if and only if WE equals 1

  @ramfifo
  Formal Scenario: forceRead enables readout completion after write finishes
    Given all input data has been written (allDataWritten=1)
    And "forceRead" is asserted
    When one clock edge occurs
    Then ramFifo should permit continued read advancement independent of further write activity

  # ---------------------------------------------------------------------
  # Reset behavior
  # ---------------------------------------------------------------------

  @reset
  Formal Scenario: asynchronous reset clears all outputs regardless of clock
    Given "rst" is asserted at an arbitrary point within a clock cycle
    Then "nextDin" should become 0 immediately
    And "dOutValid" should become 0 immediately
    And internal fillCount should become 0 immediately