.DSEG
.ORG SRAM_START
    V0: .BYTE 10
    V1: .BYTE 10
    VR: .BYTE 10
.CSEG
start:
    LDI XL, LOW(V0)
    LDI XH, HIGH(V0)
    LDI YL, LOW(V1)
    LDI YH, HIGH(V1)

    LDI R16, 10
    LDI R17, 20
    LDI R18, 10

    loop_inic:
        ST X+, R16
        ST Y+, R17
        INC R16
        INC R17
        DEC R18
        BRNE loop_inic

    rcall subrot_soma

    rcall subrot_zera

    rjump start
subrot_soma:
    PUSH R0
    PUSH R1
    IN R0, SREG
    PUSH R0

    CLC

    LD R0, X+
    LD R1, Y+
    ADD R0, R1
    ST Z+, R0

    LDI R16, 9
    loop_soma:
        LD R0, X+
        LD R1, Y+
        ADC R0, R1
        ST Z+, R0
        DEC R16
        BRNE loop_soma:
    POP R0
    OUT SREG, R0
    POP R1
    POP R0
    RET
subrot_zera:
    LDI R16, 0
    LDI R17, 10

    loop_zera:
        ST X+, R16
        ST Y+, R16
        DEC R17
        BRNE loop_zera
    RET
    
