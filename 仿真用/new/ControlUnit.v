`include "top.v"
`timescale 1ns / 1ps


module ControlUnit(
    input CLK, RST,
    input [2:0] NextState, 
    output reg [2:0] CurState = 0
    );
    always @(posedge CLK) begin
        if(RST == 0) CurState <= 3'b000;
        else CurState = NextState;
    end
endmodule

module NextState(
    input [2:0] CurState,
    input [5:0] OpCode,
    input [5:0] teshu,
    output reg [2:0] NextState
    );
    always @(CurState or OpCode) begin
        case(CurState)
            `IF : NextState <= `ID;
            `ID : begin
                    if (OpCode == `J || OpCode == `Jal || (OpCode == `Jr && teshu == 6'h08) || OpCode == `Halt) NextState <= `IF;
                    else if (OpCode == `Beq || OpCode == `Bne || OpCode == `Bltz) NextState <= `br_EXE;
                    else if (OpCode == 6'h2b || OpCode == 6'h23) NextState <= `mem_EXE;
                        else NextState <= `r_EXE;
                end
             `br_EXE : NextState <= `IF;
             `mem_EXE : NextState <= `MEM;
             `r_EXE : NextState <= `r_WB;
             `MEM : begin
                        if (OpCode == 6'h23) NextState <= `lw_WB;
                        else NextState <= `IF;
                    end
              `r_WB : NextState <= `IF;
              `lw_WB : NextState <= `IF;
         endcase
        $display("CurState:", CurState, "     NextState:",NextState, "      OpCode", OpCode);        
    end
endmodule    

module ControlSign(
    input CLK,
    input [2:0] CurState,
    input [5:0] OpCode,
    input [5:0] teshu,
    input Zero,
    output reg PCWre, // PC д�ź�
    output reg ALUSrcA, // ALU �������ѡ���ź�
    output reg ALUSrcB, // ALU �Ҳ�����ѡ���ź�
    output reg DBDataSrc, // д��Ĵ�������ѡ���ź�
    output reg RegWre, // �Ĵ�����дʹ���ź�
    output reg InsMemRW, // ָ��洢����д�ź�
    output reg mRD, // ���ݴ洢�����ź�
    output reg mWR, // ���ݴ洢��д�ź�
    output reg IRWre, //ָ��Ĵ���д�ź�
    output reg WrRegDSrc, //DBDR֮��jalд��Ĵ���ѡ���ź�
    output reg [1:0] RegDst, // д�Ĵ������ַ�ź�
    output reg ExtSel, // ��չ��ʽѡ���ź�
    output reg [1:0] PCSrc, // ָ���֧ѡ���ź�
    output reg [2:0] ALUOp // ALU ����ѡ���ź�
    );
    
    always @(CurState or Zero or OpCode) begin
        //PCWre = ( (CurState == `IF && OpCode == `Halt) || CurState == `ID || CurState == `r_EXE || 
        //    CurState == `br_EXE || CurState == `mem_EXE || CurState == `MEM || CurState == `r_WB || CurState == `lw_WB ) ? 0 : 1 ;
        ALUSrcA = (CurState == `r_EXE && OpCode == `Sll) ? 1 : 0;
        ALUSrcB = ( (CurState == `r_EXE || CurState == `br_EXE || CurState == `mem_EXE) && 
            (OpCode == `Addiu || OpCode == `Andi || OpCode == `Ori || OpCode == `Xori || 
            OpCode == `Slti || OpCode == 6'h2b || OpCode == 6'h23) ) ? 1 : 0;
        ExtSel = ( (CurState == `ID || CurState == `mem_EXE || CurState == `br_EXE || CurState == `r_EXE) && (OpCode == `Andi || OpCode == `Ori || OpCode == `Xori || OpCode == `Sll || OpCode == `Slti ) ) ? 0 : 1;        
        DBDataSrc = ( (CurState == `MEM || CurState == `lw_WB) && OpCode == 6'h23) ? 1 : 0 ;
        RegWre = ( (CurState == `ID && OpCode == `Jal) || CurState == `r_WB || CurState == `lw_WB) ? 1 : 0;
        WrRegDSrc = (CurState == `ID && OpCode == `Jal) ? 0 : 1;
        InsMemRW = 1;
        mRD = (CurState == `MEM && OpCode == 6'h23) ? 1 : 0;
        mWR = (CurState == `MEM && OpCode == 6'h2b) ? 1 : 0;  
        IRWre = (CurState == `IF) ? 1 : 0;

        if ( (CurState == `ID || CurState == `IF) && (OpCode == `Jr && teshu == 6'h08) ) PCSrc = 2'b10;
        else if ((CurState == `ID || CurState == `IF) && (OpCode == `J || OpCode == `Jal)) PCSrc = 2'b11;
        else if ( CurState == `br_EXE && ( (OpCode == `Beq && Zero) || (OpCode == `Bne && !Zero) || (OpCode == `Bltz && !Zero) ) )  PCSrc = 2'b01;
        else  PCSrc = 2'b00;
        
        if (CurState == `ID && OpCode == `Jal)  RegDst = 2'b00; //jalָ����Ҫ���Ӳ���PC+4�洢��������ID�׶ξ�д�Ĵ���
        else if ( (CurState == `r_WB || CurState == `lw_WB) && (OpCode == `Addiu || OpCode == `Andi || OpCode == `Ori || OpCode == `Xori ||
            OpCode == `Slti || OpCode == 6'h23)) RegDst = 2'b01; //һ���ָ�����WB�׶η���
        else  RegDst = 2'b10;        
        
        case(OpCode)
            `Beq, `Bne :
                ALUOp = 3'b001;
            `Sll :
                ALUOp = 3'b010;
            `Ori :
                ALUOp = 3'b011;
            `Andi, `And :
                ALUOp = 3'b100;
            `Slt :begin
                if(OpCode == `Slt && teshu == 6'h2a)
                      ALUOp = 3'b110;  
                else if(teshu == 6'h20) ALUOp = 3'b000;
                else if(teshu == 6'h22) ALUOp = 3'b001;
                 end 
            6'h01 :   ALUOp = 3'b110;                                                                      
            `Xori :
                ALUOp = 3'b111;
            default:
                ALUOp = 3'b000;
        endcase 
    end
    always @(negedge CLK) begin
      case (CurState)
        `ID: begin
          if (OpCode == `J || OpCode == `Jal || (OpCode == `Jr && teshu == 6'h08))  PCWre <= 1;
        end
        `br_EXE: begin //��EXE�׶δ�ʲô�˷�֧��ת����������źţ�ֱ�ӽ�����ת
          if (OpCode == `Beq || OpCode == `Bltz || OpCode == `Bne)  PCWre <= 1;
        end      
        `MEM : begin
          if (OpCode == 6'h2b)  PCWre <= 1;
        end    
        `lw_WB, `r_WB: PCWre <= 1;      
        default:  PCWre <= 0;
      endcase
    end  

    always@(*)begin
        $display("PPPPPPCSrc:", PCSrc, "  CurState:",CurState, "  RegDst:", RegDst);
    end
     
endmodule