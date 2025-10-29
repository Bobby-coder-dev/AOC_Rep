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

RCALL soma32bits

RJMP start

soma32bits:
; Salva contexto
PUSH R0
PUSH R1
IN R0, SREG
PUSH R0

; Principal
LD R0, X+
LD R1, Y+
ADC R0, R1
ST Z+, R0

LD R0, X+
LD R1, Y+
ADC R0, R1
ST Z+, R0

LD R0, X+
LD R1, Y+
ADC R0, R1
ST Z+, R0

; Recuperar contexto
POP R0
OUT SREG, R0
POP R1
POP R0

RET