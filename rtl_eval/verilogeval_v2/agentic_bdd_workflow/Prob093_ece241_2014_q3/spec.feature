Feature: TopModule Karnaugh Map Implementation with 4-to-1 and 2-to-1 Muxes

  As a hardware designer implementing a Karnaugh map function
  I want TopModule to generate the four data inputs (mux_in[3:0])
  that feed an external 4-to-1 multiplexer selected by {a,b}
  So that the composite circuit realizes the specified K-map,
  using only 2-to-1 muxes with selectors c and/or d inside TopModule.

  Background:
    Given a purely combinational module named "TopModule"
    And an input signal c
    And an input signal d
    And an output bus mux_in[3:0]
    And mux_in[0] is routed to the external 4-to-1 mux input selected when a=0,b=0
    And mux_in[1] is routed to the external 4-to-1 mux input selected when a=0,b=1
    And mux_in[2] is routed to the external 4-to-1 mux input selected when a=1,b=1
    And mux_in[3] is routed to the external 4-to-1 mux input selected when a=1,b=0

  @combinational @bit0 @kmap
  Formal Scenario: mux_in[0] implements the ab=00 column of the K-map
    Given c is value C
    And d is value D
    Then mux_in[0] should equal (C or D)

  @combinational @bit1 @kmap
  Formal Scenario: mux_in[1] implements the ab=01 column of the K-map
    Given c is value C
    And d is value D
    Then mux_in[1] should equal 0 regardless of C and D

  @combinational @bit2 @kmap
  Formal Scenario: mux_in[2] implements the ab=11 column of the K-map
    Given c is value C
    And d is value D
    Then mux_in[2] should equal (C and D)

  @combinational @bit3 @kmap
  Formal Scenario: mux_in[3] implements the ab=10 column of the K-map
    Given c is value C
    And d is value D
    Then mux_in[3] should equal (C or (not D))

  @combinational @bus_consistency @kmap
  Formal Scenario: mux_in bus matches the full Karnaugh map for every c,d combination
    Given c is value C
    And d is value D
    Then mux_in should equal the 4-bit value {(C or (not D)), (C and D), 0, (C or D)}