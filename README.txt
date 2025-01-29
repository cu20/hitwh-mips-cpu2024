hitwh  mips cpu2024五级流水线设计 最后实现回文质数判断功能 
使用到的指令：add,jal,lw,beq,addi,jr,j,slt,bne,bltz,sub,sw  
可拓展实现所有weihai指令集中的指令，在top，controll单元可自行添加  
仿真通过，上板验证过，可放心应付课设检查，我们的这次课设放在期末周，而且少了不少前置课程，所以做起来很费劲，希望能给后来的人提供点帮助吧；
没实现用sw指令控制段选和位选，实际上也不难，只需要将段选seg[7]和位选AN[3]送进datamemory后，再用sw指令操作其对应的内存，seg[7]和AN[3]作为datamemory的输出即可实现；
