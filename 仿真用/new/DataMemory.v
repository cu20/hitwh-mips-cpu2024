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
    input CLK,	           // ʱ������
    input mRD,	       // ������ʹ������
    input mWR,	       // д����ʹ������ 
    input [31:0] DataAddr,	   // �����ڴ��ַ 
    input [31:0] DataIn,   // �������� 
    output [31:0] DataOut  // �������
    );
    // 8 λһ�ֽڣ�Ҳ���ô��ģʽ�洢����
    reg [31:0] dataMemory[0:257];
    
    //always @(MemRead or DataAddr) begin 
//        assign DataOut[7:0] = (mRD) ? dataMemory[DataAddr + 3] : 8'bz;
//        assign DataOut[15:8] = (mRD) ? dataMemory[DataAddr + 2] : 8'bz;
//        assign DataOut[23:6] = (mRD) ? dataMemory[DataAddr + 1] : 8'bz;
        assign DataOut= (mRD) ? dataMemory[DataAddr] : 8'bz;
    //end
    // д����
    always @(negedge CLK) begin
        if (mWR) begin
//            dataMemory[DataAddr + 3] <= DataIn[7:0];
//            dataMemory[DataAddr + 2] <= DataIn[15:8];
//            dataMemory[DataAddr + 1] <= DataIn[23:16];
            dataMemory[DataAddr] <= DataIn;
            $display("COMEIN %%% DataOut:", DataOut, "     DataIn:",DataIn, "      mWR", mWR, "        mRD", mRD);
            $display(" DATADATATDATDAT---DataAddr: ", DataAddr);
        end
    end
        always@(*)begin
        $display("DDDDDataOut:", DataOut, "     DataIn:",DataIn, "      mWR", mWR, "        mRD", mRD);
        $display("      DataAddr", DataAddr);
    end
endmodule
