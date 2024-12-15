`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/15 22:25:40
// Design Name: 
// Module Name: DB
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


module DR(
    input CLK,
    input [31:0] DataIn,
    output reg [31:0] DataOut  
    );
    always @(negedge CLK) begin
        DataOut <= DataIn;
    end
endmodule
