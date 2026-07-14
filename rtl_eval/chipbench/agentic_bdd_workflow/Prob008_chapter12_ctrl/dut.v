module TopModule (
    input                   rst,
    input      [31:0]       excepttype_i,
    input      `RegBus       cp0_epc_i,
    input                   stallreq_from_if,
    input                   stallreq_from_id,
    input                   stallreq_from_ex,
    input                   stallreq_from_mem,
    output     `RegBus       new_pc,
    output                  flush,
    output     [5:0]        stall
);

    // Internal wire for exception occurrence flag from ExceptModule
    wire except_occur;

    // ------------------------------------------------------------------
    // ExceptModule: handles reset (@reset) and exception scenarios
    // (@exception @interrupt, @syscall, @invalid_instruction, @trap,
    //  @overflow, @eret, @unrecognized_type)
    // Produces new_pc, flush, and except_occur based on excepttype_i,
    // cp0_epc_i, and rst.
    // ------------------------------------------------------------------
    dut__ExceptModule u_ExceptModule (
        .rst          (rst),
        .excepttype_i (excepttype_i),
        .cp0_epc_i    (cp0_epc_i),
        .new_pc       (new_pc),
        .flush        (flush),
        .except_occur (except_occur)
    );

    // ------------------------------------------------------------------
    // StallCtrl: handles stall priority logic
    // (@stall @mem_priority, @ex_priority, @id_priority, @if_only,
    //  @default @no_stall_no_exception, @exception @priority_over_stall)
    // except_occur (from ExceptModule) forces stall to 0 when an
    // exception is active, giving exception handling priority over
    // stall requests. Reset also forces stall to 0 via StallCtrl's
    // own rst handling.
    // ------------------------------------------------------------------
    dut__StallCtrl u_StallCtrl (
        .rst               (rst),
        .except_occur      (except_occur),
        .stallreq_from_if  (stallreq_from_if),
        .stallreq_from_id  (stallreq_from_id),
        .stallreq_from_ex  (stallreq_from_ex),
        .stallreq_from_mem (stallreq_from_mem),
        .stall             (stall)
    );

endmodule

module dut__ExceptModule (
    input              rst,
    input      [31:0]  excepttype_i,
    input      [31:0]  cp0_epc_i,
    output reg [31:0]  new_pc,
    output reg         flush,
    output reg         except_occur
);

    localparam VEC_INTERRUPT = 32'h00000020;
    localparam VEC_SYSCALL   = 32'h00000040;
    localparam VEC_COMMON    = 32'h00000040;

    always @(*) begin
        new_pc       = 32'h00000000;
        flush        = 1'b0;
        except_occur = 1'b0;

        if (excepttype_i != 32'h00000000) begin
            except_occur = 1'b1;
            flush        = 1'b1;

            case (excepttype_i)
                32'h00000001: new_pc = VEC_INTERRUPT;
                32'h00000008: new_pc = VEC_SYSCALL;
                32'h0000000a: new_pc = VEC_COMMON;
                32'h0000000d: new_pc = VEC_COMMON;
                32'h0000000c: new_pc = VEC_COMMON;
                32'h0000000e: new_pc = cp0_epc_i;
                default:      new_pc = VEC_COMMON;
            endcase
        end
    end

endmodule

module dut__StallCtrl (
    input  wire        rst,
    input  wire        except_occur,
    input  wire        stallreq_from_if,
    input  wire        stallreq_from_id,
    input  wire        stallreq_from_ex,
    input  wire        stallreq_from_mem,
    output reg  [5:0]  stall
);

    always @(*) begin
        if (except_occur) begin
            stall = 6'b000000;
        end
        else if (stallreq_from_mem) begin
            stall = 6'b011111;
        end
        else if (stallreq_from_ex) begin
            stall = 6'b001111;
        end
        else if (stallreq_from_id) begin
            stall = 6'b000111;
        end
        else if (stallreq_from_if) begin
            stall = 6'b000111;
        end
        else begin
            stall = 6'b000000;
        end
    end

endmodule
