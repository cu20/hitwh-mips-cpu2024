```
by cu20
```

### hitwh  mips cpu2024五级流水线设计

基于vivado2018.3

使用到的指令：add,jal,lw,beq,addi,jr,j,slt,bne,bltz,sub,sw  

可拓展实现所有RISC指令集中的指令，根据需要在top，controll单元进行添加



1. 立即寻址

​                       ![image-20250425164208377](D:\Typora\typora-user-images\image-20250425164208377.png)

2. 寄存器寻址

 ![image-20250425164215790](D:\Typora\typora-user-images\image-20250425164215790.png)

3. 相对寻址

 ![image-20250425164220911](D:\Typora\typora-user-images\image-20250425164220911.png)

4. 基址寻址

 ![image-20250425164225490](D:\Typora\typora-user-images\image-20250425164225490.png)

5. 类直接寻址 

 ![image-20250425164230754](D:\Typora\typora-user-images\image-20250425164230754.png)

5. 总体的CPU数据通路图

 ![image-20250425164237183](D:\Typora\typora-user-images\image-20250425164237183.png)

6. CPU主要模块的控制信号分析
7. PCWre (Program Counter Write Enable)

o  作用：控制是否更新程序计数器（PC）。

o  电平含义：高电平（1）表示允许写入新的 PC 值。

2. ALUSrcA (ALU Source A)

o  作用：选择 ALU 的第一个操作数来源。

o  电平含义：高电平（1）表示使用立即数，低电平（0）表示使用寄存器的数据。

3. ALUSrcB (ALU Source B)

o  作用：选择 ALU 的第二个操作数来源。

o  电平含义：高电平（1）表示使用立即数，低电平（0）表示使用寄存器的数据。

4. DBDataSrc (Data Bus Data Source)

o  作用：选择写回寄存器的数据来源。

o  电平含义：高电平（1）表示使用数据内存的读数据，低电平（0）表示使用 ALU 的结果。

5. RegWre (Register Write Enable)

o  作用：控制是否将数据写回寄存器。

o  电平含义：高电平（1）表示允许写回操作。

6. InsMemRW (Instruction Memory Read/Write)

o  作用：控制指令存储器的读写操作。

o  电平含义：高电平（1）表示写操作，低电平（0）表示读操作。

7. mRD (Memory Read)

o  作用：控制数据存储器的读操作。

o  电平含义：高电平（1）表示执行读操作。

8. mWR (Memory Write)

o  作用：控制数据存储器的写操作。

o  电平含义：高电平（1）表示执行写操作。

9. IRWre (Instruction Register Write Enable)

o  作用：控制是否更新指令寄存器。

o  电平含义：高电平（1）表示允许写入新的指令。

10. WrRegDSrc (Write Register Data Source)

o  作用：选择写回寄存器的数据来源。

o  电平含义：高电平（1）表示使用跳转地址，低电平（0）表示使用 ALU 结果。

11. RegDst (Register Destination)

o  作用：确定 ALU 结果应该写入哪个寄存器。

o  电平含义：不同的值对应不同的寄存器。

12. ExtSel (Extension Select)

o  作用：选择如何处理立即数的符号扩展。

o  电平含义：不同的值对应不同的符号扩展方式。

13. PCSrc (Program Counter Source)

o  作用：确定程序计数器的下一个值的来源。

o  电平含义：不同的值对应不同的 PC 值来源。

14. ALUOp (ALU Operation)

o  作用：选择 ALU 要执行的操作。

o  电平含义：不同的值对应不同的 ALU 操作。