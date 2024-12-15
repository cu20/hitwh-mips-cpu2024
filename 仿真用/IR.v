`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/15 22:31:57
// Design Name: 
// Module Name: IR
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


module IR(
    input CLK,
    input IRWre,
    input [31:0] InsIn,
    output reg [31:0] InsOut
    );
  always @(negedge CLK) begin
    if (IRWre) begin
      InsOut <= InsIn;
    end
    $display("!!!!IRWre:",IRWre, "   InsIn:",InsIn,"  InsOut: ",InsOut);    
  end
endmodule
