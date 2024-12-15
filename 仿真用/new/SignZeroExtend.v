`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/15 21:44:23
// Design Name: 
// Module Name: SignZeroExtend
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


module SignZeroExtend(
    input ExtSel,            // 扩展选择信号，0为零扩展，1为符号扩展
    input [15:0] Immediate, // 16位的立即数
    output [31:0] ExtResult    // 扩展后的输出结果
    );
    assign ExtResult[15:0] = Immediate[15:0];
    // 扩展, ExtSel为1且符号位为1时，用1扩展
    assign ExtResult[31:16] = (ExtSel && Immediate[15]) ? 16'hFFFF : 16'h0000;
    always@(*)begin
        $display("ExtResult:", ExtResult);
    end
endmodule
