.DSEG
.ORG SRAM_START
    A: .BYTE 4
    B: .BYTE 4
    C: .BYTE 4
.CSEG

start: 
    LDI R16, 0XFF
    STS A+0, R16
    STS A+1, R16
    STS A+2, R16
    LDI R16, 0X01
    STS A+3, R16
    
    LDI R16, 0X01
    STS B+0, R16
    STS B+1, R16
    STS B+2, R16
    STS B+3, R16
    
    LDI XL, LOW(A)
    LDI XH, HIGH(A)

    LDI YL, LOW(B)
    LDI YH, HIGH(B)

    LDI ZL, LOW(C)
    LDI ZH, HIGH(C)

    RCALL sub32bits

    rjmp start

soma32bits:
    ;salva contexto
    PUSH R0
    push R1
    PUSH R16
    IN R0, SREG
    PUSH R0

    CLC
    ;principal
    LDI R16, 4
    loop_soma:
        LD R0, X+
        LD R1, Y+
        ADC R0, R1
        ST Z+, R0
        DEC R16
        BRNE loop_soma
    ;recuperar contexto
    POP R0
    OUT SREG, R0
    POP R16
    POP R1
    POP R0
    RET

init32bits:
    ST X+, R16
    ST X+, R17
    ST X+, R18
    ST X, R19
    RET

zera32bits:
    
    PUSH R16
    IN R16, SREG
    PUSH R16

    CLR R16

    ; clr altera o sreg

    ST X+, R16
    ST X+, R16
    ST X+, R16
    ST X, R16

    POP R16
    OUT SREG, R16
    POP R16

    RET

sub32bits:

    PUSH R0
    PUSH R1
    PUSH R16
    IN R0, SREG
    PUSH R0
    
    CLC
    LDI R16, 4
loop_sub:
    ;salvar contexto
    LD R0, X+
    LD R1, Y+
    SBC R0, R1
    ST Z+, R0
    
    DEC R16
    BRNE loop_sub

    ;recuperar contexto
    POP R0
    OUT SREG, R0
    POP R16
    POP R1
    POP R0
    RET
    