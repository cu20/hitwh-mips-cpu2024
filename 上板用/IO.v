`timescale 1ns / 1ps


module IO(
    input [15:0] sw,
    input clk,            // ʱ���ź�
    input reset,          // ��λ�ź�
    input [3:0] led,     // ����LED��ʾ���ź�
    output reg [3:0] AN,  // �����λѡ�ź�
    output reg [7:0] seg  // ����ܶ�ѡ�ź�
);

    reg [19:0] refresh_counter; // ���������ˢ��
    reg [1:0] current_digit;    // ��ǰ��ʾ������ܱ��
    reg stable_sure;            // ȥ����İ����ź�

    // ����ܶ�ѡ�źŵ��ֵ�
    reg [7:0] seg_lut [0:1];    // 0 ��ʾ�أ�1 ��ʾ��

    initial begin
        seg_lut[0] = 8'b11000000; // ��ʾ 0
        seg_lut[1] = 8'b11111001; // ��ʾ 1
    end

    


    // ˢ�¼�����������ܱ���л�
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

    // �������ʾ�߼�
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            AN <= 4'b1111; // �ر����������
            seg <= 8'b11111111; // �ر����ж�ѡ
        end else begin
            case (current_digit)
                2'b00: begin
                    AN <= 4'b1110; // ѡ�е�1λ�����
                    seg <= seg_lut[led[0]]; // ����led[0]��ֵ��ʾ
                end
                2'b01: begin
                    AN <= 4'b1101; // ѡ�е�2λ�����
                    seg <= seg_lut[led[1]]; // ����led[1]��ֵ��ʾ
                end
                2'b10: begin
                    AN <= 4'b1011; // ѡ�е�3λ�����
                    seg <= seg_lut[led[2]]; // ����led[2]��ֵ��ʾ
                end
                2'b11: begin
                    AN <= 4'b0111; // ѡ�е�4λ�����
                    seg <= seg_lut[led[3]]; // ����led[3]��ֵ��ʾ
                end
            endcase
        end
    end

endmodule

