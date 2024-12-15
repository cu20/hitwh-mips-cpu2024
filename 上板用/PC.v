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
    input CLK, //ʱ���ź�
    input RST, //��λ
    input PCWre, //дPC�Ŀ����ź�
    input [31:0] newAddress, // PC�µ�ַ
    output reg [31:0] newPC //�µ�PC
    );
    //��ʼ��
    initial begin
        newPC = 0;
    end
    //��ʱ�������ػ������½��ش���
    always @(posedge CLK) begin
        if (RST == 0) begin  //�����λ�ź�Ϊ0����һPC��ַ��0
            newPC <= 0;
        end
        else if (PCWre || !newAddress) begin //��λ�ź���Ч��д�ź���Ч
            newPC <= newAddress;
        end
     end
endmodule

module newAddress(
    input [1:0] PCSrc, //�����źţ�����PC��ֱ��+4��branch��jump
    input [31:0] immediate, //�����ַ��������������branch
    input [31:0] PC, //��ǰPC
    input [25:0] jumpAddr, //��תָ��ĺ�26λ
    input [31:0] ReadData1, //����jrָ��
    output reg [31:0] newAddress //��һ��ָ��ĵ�ַ
    );
    wire [27:0] temp;//����jumpָ��25-0������λ��ֵ
    assign temp = jumpAddr << 2; 
    wire [31:0] PC4 = PC + 4; //����PC+4
   // assign PC4 = PC + 4;
    always @(PCSrc or immediate or PC or PC4 or temp or ReadData1) begin
        if (PCSrc == 2'b00) //��PCSrcΪ00ʱû�з�����ת����һPC��ΪPC+4
            newAddress = PC + 4;
        else if (PCSrc == 2'b01) //��PCSrcΪ01ʱ��ʾΪbranchָ��
            newAddress = PC + 4 + immediate*4;
        else if (PCSrc == 2'b11) //jump,jalָ���PC��ַ
            newAddress = {PC4[31:28], temp[27:2], 2'b00};//temp[27,2]��2'b00һ���൱�ڵ�ַ������λ���ټ���PC+4�ĸ���λ
        else if (PCSrc == 3'b10)//jr
            newAddress = ReadData1;
        //��ʾ��ǰPC����һPC�ĵ�ַ������debug
        $display("curPC:",PC,"  newAddress: ",newAddress, "  immediate: ",immediate);
    end
endmodule

