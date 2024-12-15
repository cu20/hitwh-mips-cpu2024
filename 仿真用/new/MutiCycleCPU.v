`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/20 14:53:30
// Design Name: 
// Module Name: MutiCycleCPU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MutiCycleCPU(
    input CLK, RST,
    output [4:0] Rs, Rt, Rd,
    output [31:0] Immediate,
    output [31:0] CurPC, newAddress,
    output [31:0] InsDataOut,
    output [2:0] CurState, NextState,
    output [31:0] ReadData1, ReadData2,
    output [4:0] WriteReg, WriteData,
    output [31:0] Y
    );
    wire [4:0] Rs, Rt;
    wire [1:0] PCSrc, RegDst;
    wire [2:0] ALUOp;
    wire Zero, PCWre, IRWre, ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, ExtSel;
    wire [31:0] PC, newPC, ExtResult, dataout; 
    wire [31:0] IDataIn, IDataOut, InsOut;
    wire [31:0] readdata1, readdata2, WriteData;
    wire [31:0] DBDRDataIn, ADR_out, BDR_out, aluDR_out, DBDR_out;
    wire [31:0] A, B, y;
    wire [31:0] extsll;    // sll
    wire [15:0] Immediate; // branch
    wire [25:0] address; //jump
    wire [4:0] WriteReg;
    
    assign IDataIn = 0;
    
    PC pc(
        .CLK(CLK), 
        .RST(RST), 
        .PCWre(PCWre), 
        .newAddress(newAddress), 
        .newPC(newPC)
    );
    newAddress newaddr( 
        .PCSrc(PCSrc), 
        .immediate(ExtResult), 
        .PC(newPC), 
        .jumpAddr(IDataOut[25:0]),
        .ReadData1(readdata1), 
        .newAddress(PC)
    );

    InstructionMemory insmem(
        .InsMemRW(InsMemRW), 
        .InsAddr(newPC), 
        .IDataIn(IDataIn), 
        .IDataOut(IDataOut)
    );
    IR ir(
        .CLK(CLK),
        .IRWre(IRWre),
        .InsIn(IDataOut),
        .InsOut(InsOut)
    );

    ControlUnit cu(
        .CLK(CLK),
        .RST(RST),
        .NextState(NextState),
        .CurState(CurState)
    );
    NextState state(
        .CurState(CurState),
        .OpCode(IDataOut[31:26]),
        .teshu(IDataOut[5:0]),
        .NextState(NextState)
    );
    ControlSign cu_sign( 
        .CLK(CLK),
        .CurState(CurState),
        .OpCode(IDataOut[31:26]), 
        .teshu(IDataOut[5:0]),
        .Zero(Zero), 
        .PCWre(PCWre), 
        .ALUSrcA(ALUSrcA), 
        .ALUSrcB(ALUSrcB), 
        .DBDataSrc(DBDataSrc), 
        .RegWre(RegWre), 
        .InsMemRW(InsMemRW),  
        .mRD(mRD), 
        .mWR(mWR), 
        .IRWre(IRWre),
        .WrRegDSrc(WrRegDSrc),
        .RegDst(RegDst),
        .ExtSel(ExtSel), 
        .PCSrc(PCSrc), 
        .ALUOp(ALUOp) 
    );
    Selector5 selreg(
        .Select(RegDst),
        .A(5'b11111), 
        .B(InsOut[20: 16]), 
        .C(InsOut[15: 11]), 
        .Out(WriteReg)
    );
    RegisterFile regfile( 
        .CLK(CLK), 
        .RegWre(RegWre), 
        .RST(RST), 
        .ReadReg1(IDataOut[25:21]), 
        .ReadReg2(IDataOut[20:16]),
        .WriteReg(WriteReg),
        .WriteData(WriteData),
        .ReadData1(readdata1), 
        .ReadData2(readdata2) 
    );
    
    assign extsll = { {27{0}}, InsOut[10:6] };
    Selector32 selA( 
        .Select(ALUSrcA), 
        .A(readdata1), 
        .B(extsll), 
        .Out(A) 
    );
/*    assign sa = InsOut[10:6];
    SelectorA selA(
        .ALUSrcA(ALUSrcA),
        .ReadData1(readdata1),
        .sa(sa),
        .A(A)       
    );*/
    SignZeroExtend szextend( 
        .ExtSel(ExtSel), 
        .Immediate(IDataOut[15:0]), 
        .ExtResult(ExtResult) 
    );
    Selector32 selB( 
        .Select(ALUSrcB), 
        .A(readdata2), 
        .B(ExtResult), 
        .Out(B) 
    );            
    ALU alu( 
        .A(A), 
        .B(B), 
        .ALUOp(ALUOp), 
        .Zero(Zero), 
        .Y(y) 
    );    
    DataMemory datamem( 
        .CLK(CLK), 
        .mRD(mRD), 
        .mWR(mWR), 
        .DataAddr(aluDR_out), 
        .DataIn(BDR_out), 
        .DataOut(dataout) 
    );
    Selector32 seldatamem( 
        .Select(DBDataSrc), 
        .A(y), 
        .B(dataout), 
        .Out(DBDRDataIn) 
    );
    Selector32 writedata(
        .Select(WrRegDSrc),
        .A(newPC+4), 
        .B(DBDR_out), 
        .Out(WriteData)
    );

    DR Adr(
        .CLK(CLK),
        .DataIn(readdata1),
        .DataOut(ADR_out)
    );
    DR Bdr(
        .CLK(CLK),
        .DataIn(readdata2),
        .DataOut(BDR_out)
    );
    DR alu_DR(
        .CLK(CLK),
        .DataIn(y), 
        .DataOut(aluDR_out)
    );
    DR DBDR(
        .CLK(CLK),
        .DataIn(DBDRDataIn),
        .DataOut(DBDR_out)
    );
    
    assign CurPC = newPC;
    assign newAddress = PC;
    assign ReadData1 = readdata1;
    assign ReadData2 = readdata2;
    assign DataOut = dataout;
    assign InsDataOut = IDataOut;
    assign Rs = InsOut[25:21];
    assign Rt = InsOut[20:16];
    assign Rd = InsOut[15:11];
    assign Immediate = IDataOut[15:0];
    assign Y = y;

    always@(*)begin
        $display("                            Rs: ", Rs, "  Rt:",Rt, "  Rd:", Rd);
        //$display("                            @sa: ", sa,);
        $display("                            @extsll: ", extsll,);
        $display("             @@@@@DBDRDataIn: ", DBDRDataIn, "DBDR_out: ",DBDR_out);
    end
       
endmodule
