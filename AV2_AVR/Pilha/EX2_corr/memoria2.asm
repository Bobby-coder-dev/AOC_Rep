.DSEG
.ORG SRAM_START
    V0: .BYTE 10
    V1: .BYTE 10
    VR: .BYTE 10

.CSEG
start:

    LDI R16, 10
    LDI R17, 20
    LDI XH, HIGH(V0)
    LDI XL, LOW(V0)
    LDI YH, HIGH(V1)
    LDI YL, LOW(V1)

loop_init:
    ST X+, R16
    ST Y+, R17
    INC R16
    INC R17

    CPI R16, 20
    BRNE loop_init
    
    LDI XH, HIGH(V0)
    LDI XL, LOW(V0)
    LDI YH, HIGH(V1)
    LDI YL, LOW(V1)
    LDI ZH, HIGH(VR)
    LDI ZL, LOW(VR)

    LDI R16, 0

    loop_soma:
        LD R17, X+
        LD R18, Y+
        ADD R17, R18
        ST Z+, R17

        INC R16
        CPI R16, 10
        BRNE loop_soma


;ZERA VETOR
    LDI XH, HIGH(V0)
    LDI XL, LOW(V0)
    LDI YH, HIGH(V1)
    LDI YL, LOW(V1)

    LDI R16, 0
    CLR R17
    loop_zera:
        ST X+, R17
        ST Y+, R17
        INC CPI R16, 10
        BRNE loop_zera
    rjmp start  
