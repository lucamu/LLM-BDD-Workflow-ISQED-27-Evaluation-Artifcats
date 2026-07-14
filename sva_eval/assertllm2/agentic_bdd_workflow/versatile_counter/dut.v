// Flattened for tools: same behavior as original ifdef tree with current
// include/versatile_counter_defines.v (Gray, REW, CLEAR, CE, Q_BIN, LEVEL1/2;
// no WRAP, no QNEXT/Z/ZQ, no LFSR).

`include "versatile_counter_defines.v"

module vcnt (
    output reg [`CNT_LENGTH:1] q,
    output [`CNT_LENGTH:1] q_bin,
    input clear,
    input set,
    input rew,
    input cke,
    output reg level1,
    output reg level2,
    input clk,
    input rst
);

  parameter cnt_length = `CNT_LENGTH;
  parameter cnt_reset_value = `CNT_RESET_VALUE;
  parameter set_value = `CNT_LENGTH'd`CNT_SET_VALUE;
  parameter level1_value = `CNT_LENGTH'd`CNT_LEVEL1_VALUE;
  parameter level2_value = `CNT_LENGTH'd`CNT_LEVEL2_VALUE;

  reg [cnt_length:1] qi;
  wire [cnt_length:1] q_next;
  wire [cnt_length:1] q_next_fw;
  wire [cnt_length:1] q_next_rew;

  assign q_next_fw =
      clear ? `CNT_LENGTH'd0 :
      qi - `CNT_LENGTH'd1;

  assign q_next_rew =
      clear ? `CNT_LENGTH'd0 :
      qi - `CNT_LENGTH'd1;

  assign q_next = rew ? q_next_rew : q_next_fw;

  always @(posedge clk or posedge rst)
    if (rst)
      qi <= `CNT_LENGTH'd0;
    else if (cke)
      qi <= q_next;

  always @(posedge clk or posedge rst)
    if (rst)
      q <= `CNT_RESET_VALUE;
    else if (cke)
      q <= (q_next >> 1) ^ q_next;

  assign q_bin = qi;

  always @(posedge clk or posedge rst)
    if (rst)
      level1 <= 1'b0;
    else if (cke) begin
      if (q_next == level1_value)
        level1 <= 1'b1;
      else if ((q == level1_value) & rew)
        level1 <= 1'b0;
    end

  always @(posedge clk or posedge rst)
    if (rst)
      level2 <= 1'b0;
    else if (cke) begin
      if (q_next == level2_value)
        level2 <= 1'b1;
      else if ((q == level2_value) & rew)
        level2 <= 1'b0;
    end

endmodule
