# 3
.data
    I : 0
    A : 0
.text
INIT:
    LDI 0
    STO I
LOOP:
    LD I
    SUBI 10
    BGE FIM
    
    # BLOCO 1
    LD A
    ADDI 2
    STO A

    LD I
    ADD 1
    STO I
    JMP LOOP
FIM:
    HLT
