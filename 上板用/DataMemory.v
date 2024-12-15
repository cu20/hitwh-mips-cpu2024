`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/15 22:11:02
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input CLK,	           // 时钟输入
    input mRD,	       // 读数据使能输入
    input mWR,	       // 写数据使能输入 
    input [31:0] DataAddr,	   // 数据内存地址 
    input [31:0] DataIn,   // 输入数据 
    output [31:0] DataOut , // 输出数据
    output reg [3:0] led
    );
    // 8 位一字节，也采用大端模式存储数据
    reg [31:0] dataMemory[0:257];
    
    //always @(MemRead or DataAddr) begin 
//        assign DataOut[7:0] = (mRD) ? dataMemory[DataAddr + 3] : 8'bz;
//        assign DataOut[15:8] = (mRD) ? dataMemory[DataAddr + 2] : 8'bz;
//        assign DataOut[23:6] = (mRD) ? dataMemory[DataAddr + 1] : 8'bz;
        assign DataOut= (mRD) ? dataMemory[DataAddr] : 8'bz;
    //end
    // 写数据
    always @(negedge CLK) begin
        if (mWR) begin            
            dataMemory[DataAddr] <= DataIn;          
        end
        led[0] <= dataMemory[128][0];
        led[1] <= dataMemory[129][0];
        led[2] <= dataMemory[130][0];
        led[3] <= dataMemory[131][0];
    end
        always@(*)begin
        $display("DDDDDataOut:", DataOut, "     DataIn:",DataIn, "      mWR", mWR, "        mRD", mRD);
        $display("      DataAddr", DataAddr);
    end
endmodule
