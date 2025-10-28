.DSEG
.ORG SRAM_START
    A: .BYTE 4
    B: .BYTE 4
    C: .BYTE 4
.CSEG
start:
    LDI XL, LOW(A)
    LDI XH, HIGH(A)
    LDI YL, LOW(B)
    LDI YH, HIGH(B)
    LDI ZL, LOW(C)
    LDI ZH, HIGH(C)

    rcall init_32bits

    rcall sub_32bits

    rcall zera_32bits
    
    rjmp start
init_32bits:
    ST X+, R16
    ST X+, R17
    ST X+, R18
    ST X+, R19
    RET
zera_32bits:
    LDI R16, 0

    LDI R17, 4
    loop_zero:
        ST X+, R16
        DEC R17
        BRNE loop_zero
    RET
sub_32bits:
    PUSH R0
    PUSH R1
    IN R0, SREG
    PUSH R0

    CLC

    LD R0, X+
    LD R1, Y+
    SUB R0, R1
    ST Z+, R0

    LDI R16, 3
    loop_sub:
        LD R0, X+
        LD R1, Y+
        SBC R0, R1
        ST Z+, R0
        DEC R16
        BRNE loop_sub

    POP R0
    OUT SREG, R0
    POP R1
    POP R0
    RET

