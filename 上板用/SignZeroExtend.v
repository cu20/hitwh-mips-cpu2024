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
    input ExtSel,            // ��չѡ���źţ�0Ϊ����չ��1Ϊ������չ
    input [15:0] Immediate, // 16λ��������
    output [31:0] ExtResult    // ��չ���������
    );
    assign ExtResult[15:0] = Immediate[15:0];
    // ��չ, ExtSelΪ1�ҷ���λΪ1ʱ����1��չ
    assign ExtResult[31:16] = (ExtSel && Immediate[15]) ? 16'hFFFF : 16'h0000;
    always@(*)begin
        $display("ExtResult:", ExtResult);
    end
endmodule
