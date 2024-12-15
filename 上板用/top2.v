`timescale 1ns / 1ps
module top2(
    input  CLK,
    input [15:0] SW,

    input key_sure,
    input key_reset,
    output [3:0] AN,
    output [7:0] seg
    );
    //reg CLK;
    reg RST;
    wire [4:0] Rs;
    wire [4:0] Rt;
    wire [4:0] Rd;
    wire [31:0] Immediate;
    wire [31:0] CurPC;    
    wire [31:0] newAddress;
    wire [31:0] InsDataOut;
    wire [2:0] CurState;
    wire [2:0] NextState;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [4:0] WriteReg;
    wire [31:0] WriteData;
    wire [31:0] Y;
    wire [3:0] led;
    wire [15:0] sw;
    assign sw = SW;
    //banzi

    MutiCycleCPU cpu(
        .CLK(CLK),
        .RST(RST),
        .sw(sw),
        .Rs(Rs),
        .Rt(Rt),
        .Rd(Rd),
        .Immediate(Immediate),
        .CurPC(CurPC),
        .newAddress(newAddress),
        .InsDataOut(InsDataOut),
        .CurState(CurState),
        .NextState(NextState),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .WriteReg(WriteReg),
        .WriteData(WriteData),
        .Y(Y),
        .led(led)
//        .a0(a0)
    );
    
    IO segment(
     .sw(sw),
     .clk(CLK),
     .reset(key_reset),
     .led(led),
     .AN(AN),
     .seg(seg)
    );
    
    reg delay_done = 0;
    parameter ONE_SECOND_COUNT = 5_000_000;
    parameter TEN_SECONDS = 10;

    reg [31:0] one_second_counter;
    reg [3:0] ten_second_counter;

    always @(posedge CLK or posedge key_reset) begin
        if (key_reset) begin
            one_second_counter <= 0;
            ten_second_counter <= 0;
            delay_done <= 0;
        end else begin
            if (one_second_counter < ONE_SECOND_COUNT - 1) begin
                one_second_counter <= one_second_counter + 1;
            end else begin
                one_second_counter <= 0;
                if (ten_second_counter < TEN_SECONDS - 1) begin
                    ten_second_counter <= ten_second_counter + 1;
                end else begin
                    ten_second_counter <= 0;
                    delay_done <= 1;  // 10 ÃëÑÓÊ±Íê³É
                end
            end
        end
    end
//    initial begin
//    CLK = 1;
//    RST = 0;
//    #25;
//         begin 
//             CLK=1;
//             end
//         forever #25 CLK=~CLK;
//    end
    initial begin
            RST = 0;
            end
     always @(posedge CLK)
        if(delay_done) RST = 1;
    
//    initial begin
//         CLK = 1;
//         RST = 0;
//         #25;
//         CLK = 0;
//         #25;
//         begin 
//             RST=1;
//             CLK=1;
//         end
//         forever #25 CLK=~CLK;
//     end
endmodule
