module TopModule(
    output readM,
    output [15:0] address,
    inout  [15:0] data,
    input  inputReady,
    input  reset_n,
    input  clk,
    output [15:0] num_inst,
    output [15:0] output_port
    );
    wire [15:0] instruction, ReadData1, ReadData2, ALUResult;
    wire [15:0] nextPC;
    wire [3:0] ALUOp;
    wire RegDst, Jump, Branch, MemRead, MemWrite, ALUSrc, RegWrite, bcond, MemtoReg, OpenPort;
    Control control(instruction[15:12], instruction[5:0], RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, OpenPort);
    RF rf(RegWrite, clk, reset_n, instruction[11:10], instruction[9:8], instruction[7:6], ReadData1, ReadData2, ALUResult);
    ALU alu(ReadData1, (ALUSrc ? instruction[7:0] : ReadData2), ALUOp, ALUResult, bcond);
    assign nextPC = (Jump ? {PC[15:12], instruction[11:0]} : 
                    (Branch & bcond ? PC + {{8{instruction[7]}}, instruction[7:0]} : 
                    PC + 1));
    reg [15:0] PC;
    always @(posedge clk, negedge reset_n) begin
        if (!reset_n) PC <= 0;
        else PC <= nextPC;
    end
    assign readM = (MemRead | (MemWrite & inputReady));
    assign address = ALUResult;
    assign data = (MemWrite & inputReady ? ReadData2 : 16'bz);
    assign num_inst = PC;
    assign output_port = (OpenPort ? ReadData1 : 16'bz);
endmodule
