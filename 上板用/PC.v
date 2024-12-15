`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/15 10:38:15
// Design Name: 
// Module Name: PC
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/18 23:13:26
// Design Name: 
// Module Name: PC
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

module PC(
    input CLK, //时钟信号
    input RST, //置位
    input PCWre, //写PC的控制信号
    input [31:0] newAddress, // PC新地址
    output reg [31:0] newPC //新的PC
    );
    //初始化
    initial begin
        newPC = 0;
    end
    //在时钟上升沿或重置下降沿触发
    always @(posedge CLK) begin
        if (RST == 0) begin  //如果置位信号为0则下一PC地址置0
            newPC <= 0;
        end
        else if (PCWre || !newAddress) begin //置位信号无效且写信号有效
            newPC <= newAddress;
        end
     end
endmodule

module newAddress(
    input [1:0] PCSrc, //控制信号，控制PC：直接+4，branch，jump
    input [31:0] immediate, //计算地址的立即数，用于branch
    input [31:0] PC, //当前PC
    input [25:0] jumpAddr, //跳转指令的后26位
    input [31:0] ReadData1, //用于jr指令
    output reg [31:0] newAddress //下一条指令的地址
    );
    wire [27:0] temp;//计算jump指令25-0左移两位的值
    assign temp = jumpAddr << 2; 
    wire [31:0] PC4 = PC + 4; //计算PC+4
   // assign PC4 = PC + 4;
    always @(PCSrc or immediate or PC or PC4 or temp or ReadData1) begin
        if (PCSrc == 2'b00) //当PCSrc为00时没有发生跳转，下一PC即为PC+4
            newAddress = PC + 4;
        else if (PCSrc == 2'b01) //当PCSrc为01时表示为branch指令
            newAddress = PC + 4 + immediate*4;
        else if (PCSrc == 2'b11) //jump,jal指令的PC地址
            newAddress = {PC4[31:28], temp[27:2], 2'b00};//temp[27,2]和2'b00一起相当于地址左移两位，再加上PC+4的高四位
        else if (PCSrc == 3'b10)//jr
            newAddress = ReadData1;
        //显示当前PC和下一PC的地址，方便debug
        $display("curPC:",PC,"  newAddress: ",newAddress, "  immediate: ",immediate);
    end
endmodule

