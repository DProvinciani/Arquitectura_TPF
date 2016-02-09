--- MIPS COMPILER HELP ---

Please, use the following sintax to write the instructions in the assembler code of your program. To refire
to a register (such as rs, rt, rd or base), write dollar symbol ($) and next the register number. To refire
to shamt, offset or immediate field, insert the numeric value only. At the end of all the instructions, remember
to insert semiclon (;).
Finally, save the file ussing the ".asm" extension in the assembler directory. After execute compiler.py, the
machine code of your program is under the result directory with the ".coe" extension.

R-TYPE INSTRUCTIONS
    SLL rd, rt, shamt;
    SRL rd, rt, shamt;
    SRA rd, rt, shamt;
    SLLV rd, rt, rs;
    SRLV rd, rt, rs;
    SRAV rd, rt, rs;
    JR rs:
    JLAR rs; // JLAR rd, rs;
    ADD rd, rs, rt;
    SUB rd, rs, rt;
    AND rd, rs, rt;
    OR rd, rs, rt;
    XOR rd, rs, rt;
    NOR rd, rs, rt;
    SLT rd, rs, rt;
I-TYPE INSTRUCTIONS
    BEQ rs, rt, offset;
    BNE rs, rt, offset;
    ADDI rt, rs, immediate;
    SLTI rt, rs, immediate;
    ANDI rt, rs, immediate;
    ORI rt, rs, immediate;
    XORI rt, rs, immediate;
    LUI rt, immediate;
    LB rt, offset(base);
    LH rt, offset(base);
    LW rt, offset(base);
    LBU rt, offset(base);
    LHU rt, offset(base);
    LWU rt, offset(base);
    SB rt, offset(base);
    SH rt, offset(base);
    SW rt, offset(base);
J-TYPE INSTRUCTIONS
    J target;
    JAL target;
