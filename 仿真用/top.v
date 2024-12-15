`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/15 11:06:55
// Design Name: 
// Module Name: top
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


`define Add 6'b000000
`define Sub 6'b000001
`define Addiu 6'b001000

`define And 6'b010000 
`define Andi 6'b010001
`define Or 6'b010011
`define Ori 6'b010010
`define Xori 6'b010011

`define Sll 6'b011000

`define Slti 6'b100110
`define Slt 6'h00

`define Sw 6'b101011
`define Lw 6'h23

`define Beq 6'h04
`define Bne 6'h05
`define Bltz 6'h01

`define J 6'h02
`define Jr 6'b00

`define Jal 6'h03

`define Halt 6'b111111

//״̬
`define IF 3'b000
`define ID 3'b001

`define mem_EXE 3'b010
`define r_EXE 3'b110
`define br_EXE 3'b101

`define MEM 3'b011

`define lw_WB 3'b100
`define r_WB 3'b111