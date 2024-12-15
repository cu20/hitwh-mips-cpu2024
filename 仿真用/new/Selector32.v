`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/15 22:02:35
// Design Name: 
// Module Name: Selector32
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


module Selector32(            //选择器
    input Select,           //选择信号
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] Out       //选择结果
    );
    always @(Select or A or B) begin
        Out = Select ? B : A;
    end
    
    always@(*)begin
        $display("Select3333333222:", Select, "  A:",A, "  B:", B, "  Out:", Out);
    end
endmodule
