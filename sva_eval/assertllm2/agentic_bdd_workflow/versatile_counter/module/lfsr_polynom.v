// lfsr_polynom.v
// Standard preprocessor-only version for Jasper/IEEE-style tools.
// This file intentionally keeps macro-style outputs:
//   `LFSR_FB
//   `LFSR_FB_REW
//
// Requirements:
//   1) `CNT_LENGTH must be defined to a fixed integer value before include.
//   2) Exactly one of `CNT_LENGTH_2 ... `CNT_LENGTH_32 must also be defined.
//   3) Parent may define `LFSR_LENGTH as cnt_length before include, e.g.
//        `define LFSR_LENGTH cnt_length
//
// Example:
//   `define CNT_LENGTH 8
//   `define CNT_LENGTH_8
//   `define LFSR_LENGTH cnt_length
//   `include "lfsr_polynom.v"

`undef LFSR_FB
`undef LFSR_FB_REW

`ifdef CNT_LENGTH_2
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[1]
  `define LFSR_FB_REW  qi[1]^qi[2]

`elsif CNT_LENGTH_3
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[2]
  `define LFSR_FB_REW  qi[1]^qi[3]

`elsif CNT_LENGTH_4
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[3]
  `define LFSR_FB_REW  qi[1]^qi[4]

`elsif CNT_LENGTH_5
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[3]
  `define LFSR_FB_REW  qi[1]^qi[4]

`elsif CNT_LENGTH_6
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[5]
  `define LFSR_FB_REW  qi[1]^qi[6]

`elsif CNT_LENGTH_7
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[6]
  `define LFSR_FB_REW  qi[1]^qi[7]

`elsif CNT_LENGTH_8
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[6]^qi[5]^qi[4]
  `define LFSR_FB_REW  qi[1]^qi[7]^qi[6]^qi[5]

`elsif CNT_LENGTH_9
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[5]
  `define LFSR_FB_REW  qi[1]^qi[6]

`elsif CNT_LENGTH_10
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[7]
  `define LFSR_FB_REW  qi[1]^qi[8]

`elsif CNT_LENGTH_11
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[9]
  `define LFSR_FB_REW  qi[1]^qi[10]

`elsif CNT_LENGTH_12
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[6]^qi[4]^qi[1]
  `define LFSR_FB_REW  qi[1]^qi[7]^qi[5]^qi[2]

`elsif CNT_LENGTH_13
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[4]^qi[3]^qi[1]
  `define LFSR_FB_REW  qi[1]^qi[5]^qi[4]^qi[2]

`elsif CNT_LENGTH_14
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[5]^qi[3]^qi[1]
  `define LFSR_FB_REW  qi[1]^qi[6]^qi[4]^qi[2]

`elsif CNT_LENGTH_15
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[14]
  `define LFSR_FB_REW  qi[1]^qi[15]

`elsif CNT_LENGTH_16
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[15]^qi[13]^qi[4]
  `define LFSR_FB_REW  qi[1]^qi[16]^qi[14]^qi[5]

`elsif CNT_LENGTH_17
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[14]
  `define LFSR_FB_REW  qi[1]^qi[15]

`elsif CNT_LENGTH_18
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[11]
  `define LFSR_FB_REW  qi[1]^qi[12]

`elsif CNT_LENGTH_19
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[6]^qi[2]^qi[1]
  `define LFSR_FB_REW  qi[1]^qi[7]^qi[3]^qi[2]

`elsif CNT_LENGTH_20
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[17]
  `define LFSR_FB_REW  qi[1]^qi[18]

`elsif CNT_LENGTH_21
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[19]
  `define LFSR_FB_REW  qi[1]^qi[20]

`elsif CNT_LENGTH_22
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[21]
  `define LFSR_FB_REW  qi[1]^qi[22]

`elsif CNT_LENGTH_23
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[18]
  `define LFSR_FB_REW  qi[1]^qi[19]

`elsif CNT_LENGTH_24
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[23]^qi[22]^qi[17]
  `define LFSR_FB_REW  qi[1]^qi[24]^qi[23]^qi[18]

`elsif CNT_LENGTH_25
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[22]
  `define LFSR_FB_REW  qi[1]^qi[23]

`elsif CNT_LENGTH_26
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[6]^qi[2]^qi[1]
  `define LFSR_FB_REW  qi[1]^qi[7]^qi[3]^qi[2]

`elsif CNT_LENGTH_27
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[5]^qi[2]^qi[1]
  `define LFSR_FB_REW  qi[1]^qi[6]^qi[3]^qi[2]

`elsif CNT_LENGTH_28
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[25]
  `define LFSR_FB_REW  qi[1]^qi[26]

`elsif CNT_LENGTH_29
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[27]
  `define LFSR_FB_REW  qi[1]^qi[28]

`elsif CNT_LENGTH_30
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[6]^qi[4]^qi[1]
  `define LFSR_FB_REW  qi[1]^qi[7]^qi[5]^qi[2]

`elsif CNT_LENGTH_31
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[28]
  `define LFSR_FB_REW  qi[1]^qi[29]

`elsif CNT_LENGTH_32
  `define LFSR_FB      qi[`LFSR_LENGTH]^qi[22]^qi[2]^qi[1]
  `define LFSR_FB_REW  qi[1]^qi[23]^qi[3]^qi[2]
`endif