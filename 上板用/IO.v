`timescale 1ns / 1ps


module IO(
    input [15:0] sw,
    input clk,            // 时钟信号
    input reset,          // 复位信号
    input [3:0] led,     // 控制LED显示的信号
    output reg [3:0] AN,  // 数码管位选信号
    output reg [7:0] seg  // 数码管段选信号
);

    reg [19:0] refresh_counter; // 用于数码管刷新
    reg [1:0] current_digit;    // 当前显示的数码管编号
    reg stable_sure;            // 去抖后的按键信号

    // 数码管段选信号的字典
    reg [7:0] seg_lut [0:1];    // 0 表示关，1 表示开

    initial begin
        seg_lut[0] = 8'b11000000; // 显示 0
        seg_lut[1] = 8'b11111001; // 显示 1
    end

    


    // 刷新计数器和数码管编号切换
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            refresh_counter <= 0;
            current_digit <= 0;
        end else begin
            refresh_counter <= refresh_counter + 1;
            if (refresh_counter == 20'd2000) begin 
                refresh_counter <= 0;
                current_digit <= current_digit + 1;
            end
        end
    end

    // 数码管显示逻辑
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            AN <= 4'b1111; // 关闭所有数码管
            seg <= 8'b11111111; // 关闭所有段选
        end else begin
            case (current_digit)
                2'b00: begin
                    AN <= 4'b1110; // 选中第1位数码管
                    seg <= seg_lut[led[0]]; // 根据led[0]的值显示
                end
                2'b01: begin
                    AN <= 4'b1101; // 选中第2位数码管
                    seg <= seg_lut[led[1]]; // 根据led[1]的值显示
                end
                2'b10: begin
                    AN <= 4'b1011; // 选中第3位数码管
                    seg <= seg_lut[led[2]]; // 根据led[2]的值显示
                end
                2'b11: begin
                    AN <= 4'b0111; // 选中第4位数码管
                    seg <= seg_lut[led[3]]; // 根据led[3]的值显示
                end
            endcase
        end
    end

endmodule

