// ============================================================================
// Module: TopModule
// Purpose: Combinational PS/2 scancode decoder for arrow keys.
//          Decodes 16-bit scancode into individual arrow key signals:
//          left, down, right, up. Only one output is asserted at a time,
//          matching the exact PS/2 extended scancode for each arrow key.
// ============================================================================
module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    // Scenario: Left arrow key scancode is recognized (16'he06b)
    assign left  = (scancode == 16'he06b);

    // Scenario: Down arrow key scancode is recognized (16'he072)
    assign down  = (scancode == 16'he072);

    // Scenario: Right arrow key scancode is recognized (16'he074)
    assign right = (scancode == 16'he074);

    // Scenario: Up arrow key scancode is recognized (16'he075)
    assign up    = (scancode == 16'he075);

    // Scenario: Unrecognized scancode asserts no arrow key outputs
    //   -> Handled implicitly: if scancode doesn't match any of the four
    //      comparisons above, all four outputs evaluate to 0.

    // Scenario: Mutual exclusion
    //   -> Guaranteed since each output is tied to a unique, distinct
    //      scancode value; only one comparison can be true at a time.

    // Scenario: Output-consistency (iff relationships)
    //   -> Each assign statement directly implements the iff condition
    //      for its corresponding arrow key.

    // Scenario: Combinational purity
    //   -> All outputs are driven by continuous assignments depending
    //      solely on the current value of scancode; no clocked/latched
    //      state is present, so outputs always reflect the current input.

endmodule