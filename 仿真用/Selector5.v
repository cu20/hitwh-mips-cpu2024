`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/15 22:03:58
// Design Name: 
// Module Name: Selector5
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


module Selector5(
    input [4:0] A,
    input [4:0] B,
    input [4:0] C,
    input [1:0] Select,
    output reg [4:0] Out
    );  
    always @(Select or A or B or C) begin
        case (Select)
            2'b00:  Out <= A;
            2'b01:  Out <= B;
            2'b10:  Out <= C;
            default:  Out <= 0;
        endcase
    end
    always@(*)begin
        $display("Select555555: ", Select, "  A:",A, "  B:", B, "  C:", C, "  Out:", Out);
    end
endmodule
