`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/15 20:27:14
// Design Name: 
// Module Name: instructionMemory
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


module InstructionMemory(
    input InsMemRW,                 // 指令读写信号, 读1, 写0
    input [31:0] InsAddr,           // 指令地址输入
    input [31:0] IDataIn,
    output reg [31:0] IDataOut    // 指令存储器输出数据
    );
    reg [31:0] InsMemory[0:127];         // 8 位长的指令存储单元，共 128 个
    initial begin
       $readmemh("C:/Users/gugu/Desktop/memfile.txt", InsMemory);     
//           InsMemory[0] = 32'h20080000;
//           InsMemory[1] = 32'h20090001;
//           InsMemory[2] = 32'h0109502a;
    end
    always @(InsAddr or InsMemRW) begin
        if (InsMemRW) begin //四个字节
            IDataOut = InsMemory[InsAddr[31:2]];
        end
        $display("IIIIIInsMemRW:",InsMemRW, "    IDataOut:",IDataOut);       
    end
endmodule

