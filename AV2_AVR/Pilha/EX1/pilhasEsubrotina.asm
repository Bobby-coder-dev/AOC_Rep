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
    
    LDI R16, 0X02
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
    
    rcall soma32bits
    rjmp start
    
soma32bits:
    ; Salva contexto
    PUSH R0
    PUSH R1
    IN R0, SREG
    PUSH R0
    
    CLC

    LD R0, X+
    LD R1, Y+
    ADD R0, R1
    ST Z+, R0

    LDI R16, 3
    loop_soma:
	LD R0, X+
	LD R1, Y+
	ADC R0, R1
	ST Z+, R0

	DEC R16
	BRNE loop_soma
	
    ; Recuperar contexto
    POP R0
    OUT SREG, R0
    POP R1
    POP R0
    ret
