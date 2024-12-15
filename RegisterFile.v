`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/15 22:20:53
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    input CLK, // 时钟输入
    input RegWre, // 写使能信号
    input RST, // 重置信号
    input [4:0] ReadReg1, // 读寄存器 1 地址
    input [4:0] ReadReg2, // 读寄存器 2 地址
    input [4:0] WriteReg, // 写寄存器地址
    input [31:0] WriteData, // 写数据
    output [31:0] ReadData1, // 读数据 1
    output [31:0] ReadData2 // 读数据 2
);
    integer i;
    reg [31:0] Register[0:31];
    // 初始化寄存器的值
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            Register[i] = 0;
        Register[4] = {27'b0,5'b10001};
        end
    end
    assign ReadData1 = Register[ReadReg1]; //读寄存器数据
    assign ReadData2 = Register[ReadReg2];
    // 写寄存器
    always @(negedge CLK) begin
        if (!RST) begin
            for (i = 1; i < 32; i = i + 1)
                Register[i] = 0;
            Register[4] = {27'b0,5'b10001};
        end
        else if (RegWre && WriteReg)  // WriteReg != 0， $0 寄存器不能修改,保护0寄存器
                Register[WriteReg] <= WriteData;
        $display("WriteData:",WriteData, "  WriteReg:",WriteReg, "  RegWre:",RegWre, "  Register[1]:", Register[1], "  Register[2]:", Register[2], "  Register[3]:", Register[3],"  Register[10]:", Register[10]  );
    end
endmodule
