`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/15 21:47:08
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [2:0] ALUOp, // ALU 控制选择
    input [31:0] A, // 左操作数
    input [31:0] B, // 右操作数
    output Zero, // 运算结果标志，结果为 0 输出 1
    output reg [31:0] Y // 计算结果
    );
    always @(ALUOp or A or B) begin
        case (ALUOp)
            3'b000 : Y = (A + B); //add, addi
            3'b001 :begin
                Y = (A - B); //sub, subi
                if(Y[15] == 1)Y = {16'b0,Y[15:0]};
             end
            3'b010 : Y = (B << A); // B左移A位
            3'b011 : Y = (A | B);  //或
            3'b100 : Y = (A & B);   //与
            3'b101 : Y = (A < B) ? 1 : 0;  //不带符号比较
            3'b110 : Y = (((A < B) && (A[15] == B[15])) || ((A[15] && !B[15]))) ? 1:0; //带符号比较A和B
            3'b111 : Y = (A ^ B); //异或
            default : Y = 0;    // 无上述代码时Y默认为0
        endcase
        $display("Y=", Y, "  ALUOp:", ALUOp, "  A:", A, "  B:", B, "!!!!!!!!!!!!!!!!!!!!!!!!!!");
    end
    assign Zero = (Y == 0) ? 1:0;
endmodule
