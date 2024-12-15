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
    input CLK, // ʱ������
    input RegWre, // дʹ���ź�
    input RST, // �����ź�
    input [4:0] ReadReg1, // ���Ĵ��� 1 ��ַ
    input [4:0] ReadReg2, // ���Ĵ��� 2 ��ַ
    input [4:0] WriteReg, // д�Ĵ�����ַ
    input [31:0] WriteData, // д����
    output [31:0] ReadData1, // ������ 1
    output [31:0] ReadData2 // ������ 2
);
    integer i;
    reg [31:0] Register[0:31];
    // ��ʼ���Ĵ�����ֵ
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            Register[i] = 0;
        Register[4] = {27'b0,5'b10001};
        end
    end
    assign ReadData1 = Register[ReadReg1]; //���Ĵ�������
    assign ReadData2 = Register[ReadReg2];
    // д�Ĵ���
    always @(negedge CLK) begin
        if (!RST) begin
            for (i = 1; i < 32; i = i + 1)
                Register[i] = 0;
            Register[4] = {27'b0,5'b10001};
        end
        else if (RegWre && WriteReg)  // WriteReg != 0�� $0 �Ĵ��������޸�,����0�Ĵ���
                Register[WriteReg] <= WriteData;
        $display("WriteData:",WriteData, "  WriteReg:",WriteReg, "  RegWre:",RegWre, "  Register[1]:", Register[1], "  Register[2]:", Register[2], "  Register[3]:", Register[3],"  Register[10]:", Register[10]  );
    end
endmodule
